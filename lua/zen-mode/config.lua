local util = require("zen-mode.util")
local M = {}

---@class ZenOptions
local defaults = {
    zindex = 40, -- zindex of the zen window. Should be less than 50, which is the float default
    window = {
        backdrop = 0.95,
            -- shade the backdrop of the zen window.
            -- Set to 1 to keep the same as Normal.
            
        width = 0.85, -- width of the zen window
        height = 1, -- height of the zen window
            -- Height and width can be:
                -- * an asbolute number of cells when > 1
                -- * a percentage of the width / height of the editor when <= 1
        -- by default, no options are changed in for the zen window
        -- uncomment any of the options below,
        -- or add other vim.wo options you want to apply
        options = {
            -- signcolumn = "no"      , -- disable signcolumn
            -- number = false         , -- disable number column
            -- relativenumber = false , -- disable relative numbers
            -- cursorline = false     , -- disable cursorline
            -- cursorcolumn = false   , -- disable cursor column
            -- foldcolumn = "0"       , -- disable fold column
            -- list = false           , -- disable whitespace characters
        },
    },
    plugins = {
        -- disable some global vim options (vim.o) 
        options = {
            enabled = true  ,
            ruler   = false , 
            showcmd = false , --  command in the last line of the screen  改了没变化
        },

        twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
        gitsigns = { enabled = false },
        tmux     = { enabled = false }, -- disables the tmux statusline
    },

    on_open = function(_win) end,
        -- callback where you can add custom code when the zen window opens
    on_close = function() end,
}

---@type ZenOptions
M.options = {}

function M.colors()
    local normal = util.get_hl("Normal")
    if normal and normal.background then
        local bg = util.darken(normal.background, M.options.window.backdrop)
        vim.cmd(("highlight ZenBg guibg=%s guifg=%s"):format(bg, bg))
    end
end

function M.setup(options)
    M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
    M.colors()
    vim.cmd([[autocmd ColorScheme * lua require("zen-mode.config").colors()]])
    for plugin, plugin_opts in pairs(M.options.plugins) do
        if type(plugin_opts) == "boolean" then
            M.options.plugins[plugin] = { enabled = plugin_opts }
        end
        if M.options.plugins[plugin].enabled == nil then
            M.options.plugins[plugin].enabled = true
        end
    end
end

M.setup()

return M
