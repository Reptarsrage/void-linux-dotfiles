-- based on https://github.com/mfussenegger/nvim-dap-python/blob/master/lua/dap-python.lua
local M = {}

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

  netcoredbg_path = vim.fn.expand(netcoredbg_path)
  opts = vim.tbl_extend('keep', opts or {}, default_setup_opts)

  dap.adapters.cs =  function(cb, config)
    if config.request == 'attach' then
      cb({
        type = 'server';
        port = config.port or 4711;
        host = config.host or '127.0.0.1';
      })
    else
      cb({
        type = 'executable';
        command = netcoredbg_path;
        args = { '--interpreter=vscode' };
      })
    end
  end

  if opts.include_configs then
    dap.configurations.cs = dap.configurations.cs or {}
    table.insert(dap.configurations.cs, {
      type = 'cs';
      request = 'launch';
      name = 'Launch';
      program = 'C:/Users/jrobb/Source/temp/MondecaShim/MondecaShim/bin/Debug/net5.0/MondecaShim.dll';
      cwd = 'C:/Users/jrobb/Source/temp/MondecaShim/MondecaShim/';
      env = { 'ASPNETCORE_ENVIRONMENT=Development' };
      stopAtEntry = false;
      console = opts.console;
    })

    table.insert(dap.configurations.cs, {
      type = 'cs';
      request = 'attach';
      name = 'Attach remote';
      host = function()
        local value = vim.fn.input('Host [127.0.0.1]: ')
        if value ~= "" then
          return value
        end
        return '127.0.0.1'
      end;
      port = function()
        return tonumber(vim.fn.input('Port [4711]: ')) or 4711
      end;
    })
  end
end

return M