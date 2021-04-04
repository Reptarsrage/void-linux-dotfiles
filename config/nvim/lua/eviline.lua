local gl = require('galaxyline')
local colors = require('galaxyline.theme').default
local condition = require('galaxyline.condition')
local omni = require'dap-omnisharp'
local gls = gl.section
gl.short_line_list = {'NvimTree','vista','dbui','packer'}

-- Hack to fix mismatched color pallette from theme
vim.api.nvim_command('hi StatusLine ' .. 'guifg=' .. colors.fg .. ' guibg=' .. colors.bg)

gls.left[1] = {
  RainbowRed = {
    provider = function() return '▊' end,
    separator = ' ',
    highlight = {colors.blue,colors.blue},
    separator_highlight = {'NONE',colors.bg}
  },
}

gls.left[2] = {
  ViMode = {
    provider = function()
      -- auto change color according the vim mode
      local mode_color = {n = colors.red, i = colors.green,v=colors.blue,
                          [''] = colors.blue,V=colors.blue,
                          c = colors.magenta,no = colors.red,s = colors.orange,
                          S=colors.orange,[''] = colors.orange,
                          ic = colors.yellow,R = colors.violet,Rv = colors.violet,
                          cv = colors.red,ce=colors.red, r = colors.cyan,
                          rm = colors.cyan, ['r?'] = colors.cyan,
                          ['!']  = colors.red,t = colors.red}
      vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color[vim.fn.mode()])
      return '  '
    end,
    highlight = {colors.red,colors.bg,'bold'},
  },
}

gls.left[3] = {
  FileSize = {
    provider = 'FileSize',
    condition = condition.buffer_not_empty,
    highlight = {colors.fg,colors.bg}
  }
}

gls.left[4] ={
  FileIcon = {
    provider = 'FileIcon',
    condition = condition.buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.bg},
  },
}

gls.left[5] = {
  FileName = {
    provider = 'FileName',
    condition = condition.buffer_not_empty,
    highlight = {colors.magenta,colors.bg,'bold'}
  }
}

gls.left[6] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.fg,colors.bg},
  },
}

gls.left[7] = {
  PerCent = {
    provider = 'LinePercent',
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.fg,colors.bg,'bold'},
  }
}

gls.left[8] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {colors.red,colors.bg}
  }
}

gls.left[9] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = {colors.yellow,colors.bg},
  }
}

gls.left[10] = {
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = '  ',
    highlight = {colors.cyan,colors.bg},
  }
}

gls.left[11] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    highlight = {colors.blue,colors.bg},
  }
}

gls.mid[1] = {
  ShowLspClient = {
    provider = 'GetLspClient',
    condition = function ()
      local tbl = {['dashboard'] = true,['']=true}
      if tbl[vim.bo.filetype] then
        return false
      end
      return true
    end,
    icon = ' LSP:',
    highlight = {colors.cyan,colors.bg,'bold'}
  }
}

local function is_debugging()
  local dap = require('dap')
  local session = dap.session()
  return session ~= nil
end

local function supports_debugging()
  local dap = require('dap')
  local adapters = dap.adapters
  local ext = vim.fn.expand('%:e')
  ext = (ext == 'py' and 'python') or ext
  return adapters ~= nil and adapters[ext] ~= nil
end

local function get_debug_state()
  if omni.exited then return 5 end
  if omni.exiting then return 4 end
  if omni.stopped then return 3 end
  if omni.initialized then return 2 end
  if not is_debugging() then return 0 end
  return 1
end

gls.right[2] = {
  Debugging = {
    provider = function()
      local states = { 'F5 Debug', 'Initializing', 'Debugging', 'Paused', 'Exiting', 'Stopped', }
      local highlight_colors = { colors.green, colors.blue, colors.red, colors.yellow, colors.red, colors.red, }
      vim.api.nvim_command('highlight GalaxyDebugging guifg='..highlight_colors[get_debug_state() + 1])
      return ' '..states[get_debug_state() + 1]
    end,
    icon = function()
      local icons = { '', '痢', '', '', '', '栗', }
      return icons[get_debug_state() + 1]
    end,
    condition = function ()
      return supports_debugging()
    end,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = function()
      local highlight_colors = { colors.green, colors.blue, colors.red, colors.yellow, colors.red, colors.red, }
      return { highlight_colors[get_debug_state() + 1], colors.bg }
    end,
  }
}

gls.right[3] = {
  FileEncode = {
    provider = 'FileEncode',
    condition = condition.hide_in_width,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.green,colors.bg,'bold'}
  }
}

gls.right[4] = {
  FileFormat = {
    provider = 'FileFormat',
    condition = condition.hide_in_width,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.green,colors.bg,'bold'}
  }
}

gls.right[5] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = condition.check_git_workspace,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.violet,colors.bg,'bold'},
  }
}

gls.right[6] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = condition.check_git_workspace,
    highlight = {colors.violet,colors.bg,'bold'},
  }
}

gls.right[7] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = {colors.green,colors.bg},
  }
}

gls.right[8] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = condition.hide_in_width,
    icon = ' 柳',
    highlight = {colors.orange,colors.bg},
  }
}

gls.right[9] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = {colors.red,colors.bg},
  }
}

gls.right[10] = {
  RainbowBlue = {
    provider = function() return '▊' end,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.blue,colors.blue},
  },
}

gls.short_line_left[1] = {
  BufferType = {
    provider = 'FileTypeName',
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.blue,colors.bg,'bold'}
  }
}

gls.short_line_left[2] = {
  SFileName = {
    provider =  'SFileName',
    condition = condition.buffer_not_empty,
    highlight = {colors.fg,colors.bg,'bold'}
  }
}

gls.short_line_right[1] = {
  BufferIcon = {
    provider= 'BufferIcon',
    highlight = {colors.fg,colors.bg}
  }
}
