-- neovim Debug Adapter Protocol adapter integration for .NET Core
-- see: https://github.com/mfussenegger/nvim-dap
-- see: https://github.com/nvim-lua/plenary.nvim
local Path = require'plenary.path'
local Scan = require'plenary.scandir'
local Context = require'plenary.context_manager'
local Job = require'plenary.job'

local open = Context.open
local with = Context.with

-- parse target framework from csproj
local function parse_target_framework(csproj_file)
  return with(open(csproj_file), function(reader)
    local content = reader:read()
    while content do
      local match = string.match(content, "<TargetFramework>(.+)%</TargetFramework>")
      if match then
        return match
      end

      content = reader:read()
    end

    return nil
  end)
end

-- checks if path is root
local function is_root(pathname)
  if Path.path.sep == '\\' then
    return string.match(pathname, '^[A-Z]:\\?$')
  end
  return pathname == '/'
end

local concat_paths = function(...)
  return table.concat({...}, Path.path.sep)
end

-- looks for csproj in current and all parent directories
local function find_csproj()
  -- scan directories up until we hit the root
  -- TODO: handle case where csproj is in the root_dir
  local current_dir = vim.fn.expand('%:p:h') -- directory of current file
  while not is_root(current_dir) do
    -- scan directory for a csproj
      local results = Scan.scan_dir(current_dir, {
        hidden = false;
        add_dirs = false;
        depth = 1;
        search_pattern = '%.csproj$';
    })

    -- check
    -- TODO: handle when multiple csproj files are found
    if results and results[1] then
      return results[1]
    end

    -- move to parent
    current_dir = Path:new(current_dir):parent()
  end

  -- we hit the root directory
  return nil
end

local M = {
  initialized = false,
  stopped = false,
  exiting = false,
  exited = false,
}

local default_setup_opts = {
  include_configs = true,
}

local function load_dap()
  local ok, dap = pcall(require, 'dap')
  assert(ok, 'nvim-dap is required to use dap-omnisharp')
  return dap
end

function M.setup(netcoredbg_path, opts)
  local dap = load_dap()

  dap.listeners.after['event_initialized']['dap-omnisharp-jrobb'] = function()
    M.initialized = true
    M.stopped = false
    M.exiting = false
    M.exited = false
  end

  dap.listeners.after['event_stopped']['dap-omnisharp-jrobb'] = function()
    M.stopped = true
  end

  dap.listeners.after['event_continued']['dap-omnisharp-jrobb'] = function()
    M.stopped = false
  end

  dap.listeners.after['event_exited']['dap-omnisharp-jrobb'] = function()
    M.exiting = true
  end

  dap.listeners.after['event_terminated']['dap-omnisharp-jrobb'] = function()
    M.initialized = false
    M.exiting = false
    M.exited = true
  end

  netcoredbg_path = vim.fn.expand(netcoredbg_path)
  opts = vim.tbl_extend('keep', opts or {}, default_setup_opts)

  dap.adapters.cs = function(cb)
    -- locate csproj
    -- local csproj_file = find_csproj()
    -- local base_dir = Path:new(csproj_file):parent()

    -- local on_output = function(err, data)
    --   if err then
    --     return
    --   end

    --   if data == nil then
    --     return
    --   end

    --   print(data)
    -- end

    -- -- build using dotnet
    -- Job:new({
    --   command = 'dotnet',
    --   args = { 'build', '-c', 'Debug', csproj_file },
    --   cwd = base_dir,
    --   on_stderr = on_output,
    --   on_stdout = on_output,
    -- }):start()

    -- debug using netcoredbg
    cb({
      type = 'executable';
      command = netcoredbg_path;
      args = { '--interpreter=vscode' };
    })
  end

  dap.configurations.cs = dap.configurations.cs or {}
  table.insert(dap.configurations.cs, {
    type = 'cs',
    request = 'launch',
    name = 'Launch',
    stopAtEntry = false,
    console = 'integratedTerminal',
    env = { 'ASPNETCORE_ENVIRONMENT=Development' },

    -- locate the project directory
    cwd = function()
      -- locate csproj
      local csproj_file = find_csproj()
      return Path:new(csproj_file):parent()
    end,

    -- locate the compiled project dll
    program = function()
      -- locate csproj
      local csproj_file = find_csproj()
      local target_framework = parse_target_framework(csproj_file)

      -- build debug path
      local base_dir = Path:new(csproj_file):parent()
      local sep = Path.path.sep
      local name = string.match(csproj_file, sep.."([^"..sep.."]+)%.csproj$")
      return concat_paths(base_dir, 'bin', 'Debug', target_framework, name..'.dll')
    end,
  })
end

return M