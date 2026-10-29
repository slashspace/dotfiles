return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

        local colors = {
            bg = "#0a0a0a",
            surface = "#1f1f1f",
            fg = "#ffffff",
            grey = "#b7bfce",
            green = "#37f499",
            cyan = "#04d1f9",
            purple = "#987afb",
            red = "#f16c75",
            yellow = "#f1fc79",
        }
		local my_lualine_theme = {
			normal = {
				a = { fg = colors.bg, bg = colors.green, gui = "bold" },
				b = { fg = colors.fg, bg = colors.surface },
				c = { fg = colors.grey, bg = colors.surface },
			},
			insert = {
				a = { fg = colors.bg, bg = colors.cyan, gui = "bold" },
				b = { fg = colors.fg, bg = colors.surface },
			},
			visual = {
				a = { fg = colors.bg, bg = colors.purple, gui = "bold" },
				b = { fg = colors.fg, bg = colors.surface },
			},
			replace = {
				a = { fg = colors.bg, bg = colors.red, gui = "bold" },
				b = { fg = colors.fg, bg = colors.surface },
			},
			command = {
				a = { fg = colors.bg, bg = colors.yellow, gui = "bold" },
				b = { fg = colors.fg, bg = colors.surface },
			},
			inactive = {
				a = { fg = colors.grey, bg = colors.surface },
				b = { fg = colors.grey, bg = colors.surface },
				c = { fg = colors.grey, bg = colors.surface },
			},
		}

        local mode = {
            'mode',
            fmt = function(str)
                return '' .. str
            end,
        }

        local diff = {
            'diff',
            colored = true,
            symbols = { added = ' ', modified = ' ', removed = ' ' }, -- changes diff symbols
            -- cond = hide_in_width,
        }

        local filename = {
            'filename',
            file_status = true,
            path = 0,
        }

        local branch = {'branch', icon = {'', color={fg='#04d1f9'}}, '|'}


		lualine.setup({
            icons_enabled = true,
			options = {
				theme = my_lualine_theme,
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "|", right = "" },
			},
			sections = {
                lualine_a = { mode },
                lualine_b = { branch },
                lualine_c = { diff, filename },
				lualine_x = {
					{
                        -- require("noice").api.statusline.mode.get,
                        -- cond = require("noice").api.statusline.mode.has,
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#f1fc79" },
					},
					-- { "encoding",},
					-- { "fileformat" },
					{ "filetype" },
				},
			},
		})
	end,
}
