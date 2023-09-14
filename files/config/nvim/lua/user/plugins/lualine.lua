return {
  'nvim-lualine/lualine.nvim',
  config = function()
  -- Set lualine as statusline
  -- See `:help lualine.txt`
		require('lualine').setup {
			options = {
				icons_enabled = true,
				component_separators = '|',
				section_separators = '',
			},
			sections = {
				lualine_x = {
					{
						require("noice").api.statusline.mode.get,
						cond = require("noice").api.statusline.mode.has,
						color = { fg = "#ff9e64" },
					}
				},
				lualine_a = {
					{
						'buffers',
					}
				}
			}
		}
	end
}
