-- vim:foldmethod=marker
-- Neovide{{{
vim.cmd[[
    set guifont=FiraCode\ Nerd\ Font\ Mono
    let g:neovide_transparency=0.8
    let g:neovide_cursor_vfx_mode = "railgun"
]]
-- }}}

-- Defaults {{{
vim.cmd("syntax enable") -- syntax highlight
vim.wo.number = true -- show line numbers
vim.o.ruler = true
vim.o.ttyfast = true                          -- terminal acceleration
vim.cmd("set tabstop=4 ")                              -- 4 whitespaces for tabs visual presentation
vim.cmd("set shiftwidth=4")                            -- shift lines by 4 spaces
vim.o.smarttab = true                               -- set tabs for a shifttabs logic
vim.cmd("set expandtab")                            -- expand tabs into spaces
vim.o.autoindent = true                             -- indent when moving to the next line while writing code
vim.o.cursorline = true                            -- shows line under the cursor's line
vim.o.showmatch = true                             -- shows matching part of bracket pairs (), [], {}
vim.o.enc="utf-8"                               -- utf-8 by default
vim.o.backspace="indent,eol,start"              -- backspace removes all (indents, EOLs, start) What is start?
vim.o.scrolloff=10                            -- let 10 lines before/after cursor during scroll
vim.o.clipboard="unnamedplus"                       -- use system clipboard
vim.o.hidden=true                                  -- TextEdit might fail if hidden is not set. 
vim.o.backup=false                                -- Some servers have issues with backup files, see #649.
vim.o.writebackup=false
vim.o.cmdheight=2                             -- Give more space for displaying messages.
vim.o.updatetime=300                          -- reduce updatetime (default is 4000 ms = 4 s) leads to noticeable
vim.cmd('set iskeyword+=-') -- treat dash separated words as a word text object"
vim.wo.signcolumn="yes"                        -- Always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved.
vim.o.showmode=false                              -- compatible with lightline
vim.o.showtabline=2                           -- show tab line always
vim.o.list=true                                    -- show invisible characters
vim.o.listchars="tab:>-,trail:~"                -- list symbols, extends,precedes are useless if warp is on
--vim.o.foldnestmax=1                           -- only fold top level
--vim.o.foldmethod=syntax                       --fold by syntax

vim.o.termguicolors = true
vim.o.completeopt = "menuone,noselect"

vim.cmd("let g:loaded_python_provider = 0")            --- disable python2 support
vim.cmd("autocmd FileType make set noexpandtab")        --       change space back to tab
vim.cmd("autocmd TermOpen * setlocal nonumber norelativenumber" )  -- disable line number in terminal mode

vim.cmd( "highlight link CompeDocumentation NormalFloat" )
vim.cmd( "let $NVIM_TUI_ENABLE_TRUE_COLOR=1" )

--: }}}


-- Redefine tab completion {{{
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.cmd[[inoremap <silent><expr> <CR>      compe#confirm('<CR>')]]

-- }}}

-- Packer {{{
require('packer').startup(function()
    -- Packer itself
    use 'wbthomason/packer.nvim'

    -- LSP and debugger {{{
    use {"neovim/nvim-lspconfig",
        config = function()
            require'lspconfig'.pyright.setup{}
            require'lspconfig'.gopls.setup{}
            require'lspconfig'.ccls.setup{}
            require'lspconfig'.jsonls.setup{}
            --require'nvim_lsp'.vimls.setup{}
            --require'nvim_lsp'.sumneko_lua.setup{}
        end
    }

    use {'glepnir/lspsaga.nvim',
        config = function()
            require'lspsaga'.init_lsp_saga{}
        end
    }

    use {'hrsh7th/nvim-compe',
        requires = {'hrsh7th/vim-vsnip', 'rafamadriz/friendly-snippets'},
        config = function()
            require'compe'.setup {
                preselect = 'disable',
                source = {
                    path = true,
                    buffer = true,
                    calc = true,
                    nvim_lsp = true,
                    nvim_lua = false,
                    vsnip = true,
                    spell = true 
                }
            }
        end
    }

    use { 'rcarriga/nvim-dap-ui', requires = {'mfussenegger/nvim-dap'},
        config = function()
            require "debugger"
        end
    }
    -- LSP and debugger}}}


    --- UI & theme {{{

    use {'navarasu/onedark.nvim',
        config = function()
            vim.cmd[[colorscheme onedark]]
        end
    }


    -- Automatically creates missing LSP diagnostics highlight groups for color schemes that don't yet support the Neovim 0.5 builtin lsp client.
    --use 'folke/lsp-colors.nvim'


    --- lualine
    use {'hoob3rt/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true},
        config = function() require('lualine').setup{
              options = {
                theme = 'onedark',
                section_separators = {'', ''},
                component_separators = {'', ''},
                icons_enabled = true,
              },
              sections = {
                lualine_a = {{'mode',upper = true}},
                lualine_b = {{'branch',icon = ''}},
                lualine_c = {
                    {'filename', file_status = true},
                    {'diagnostics', sources = {"nvim_lsp"}}, 
                },
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location'  },
              },
              inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {'filename' },
                lualine_x = { 'location' },
                lualine_y = {  },
                lualine_z = {   }
              },
              extensions = { 'fugitive' }
        }end
    }
    -- bufferline
    use {
        'akinsho/nvim-bufferline.lua',
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("bufferline").setup{}
        end
    }
    --- }}}

    --- TOOLS
    -- git integration
    use 'tpope/vim-fugitive'
    --- align
    use 'junegunn/vim-easy-align'
    ---  <count>ai ii aI iI indent level
    use 'michaeljsmith/vim-indent-object'
    --- quoting/parenthesizing
    use 'tpope/vim-surround'
    -- enable repeating supported plugin maps with .
    use 'tpope/vim-repeat'
    use 'jiangmiao/auto-pairs'

    --- formatting
    use {'sbdchd/neoformat'}

    use {'sindrets/diffview.nvim',
        config = function()
            local cb = require'diffview.config'.diffview_callback

            require'diffview'.setup {
              diff_binaries = false,    -- Show diffs for binaries
              file_panel = {
                width = 35,
                use_icons = true        -- Requires nvim-web-devicons
              },
              key_bindings = {
                disable_defaults = false,                   -- Disable the default key bindings
                -- The `view` bindings are active in the diff buffers, only when the current
                -- tabpage is a Diffview.
                view = {
                  ["<tab>"]     = cb("select_next_entry"),  -- Open the diff for the next file 
                  ["<s-tab>"]   = cb("select_prev_entry"),  -- Open the diff for the previous file
                  ["<leader>e"] = cb("focus_files"),        -- Bring focus to the files panel
                  ["<leader>b"] = cb("toggle_files"),       -- Toggle the files panel.
                },
                file_panel = {
                  ["j"]             = cb("next_entry"),         -- Bring the cursor to the next file entry
                  ["<down>"]        = cb("next_entry"),
                  ["k"]             = cb("prev_entry"),         -- Bring the cursor to the previous file entry.
                  ["<up>"]          = cb("prev_entry"),
                  ["<cr>"]          = cb("select_entry"),       -- Open the diff for the selected entry.
                  ["o"]             = cb("select_entry"),
                  ["<2-LeftMouse>"] = cb("select_entry"),
                  ["-"]             = cb("toggle_stage_entry"), -- Stage / unstage the selected entry.
                  ["S"]             = cb("stage_all"),          -- Stage all entries.
                  ["U"]             = cb("unstage_all"),        -- Unstage all entries.
                  ["R"]             = cb("refresh_files"),      -- Update stats and entries in the file list.
                  ["<tab>"]         = cb("select_next_entry"),
                  ["<s-tab>"]       = cb("select_prev_entry"),
                  ["<leader>e"]     = cb("focus_files"),
                  ["<leader>b"]     = cb("toggle_files"),
                }
              }
            }
        end
    }
    --- Treesitter and highlight
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ':TSUpdate',
        config = function() 
            require'nvim-treesitter.configs'.setup{
                ensure_installed = {"python", "go", "json", "bash", "lua", "c", "cpp"},
                highlight = {enable = true},
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "gnn",
                        node_incremental = "}",
                        scope_incremental = "grc",
                        node_decremental = "{",
                    },
                },
                refactor = {
                    highlight_definitions = {enable = true},
                    highlight_current_scope = {enable = true},
                },
            }
        end
    }
    --- hightlight
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup{}
        end
    }

    -- telescope
    use {"nvim-telescope/telescope.nvim",
        requires = {"nvim-lua/popup.nvim", "nvim-lua/plenary.nvim"},
        --config = function()
        --    require'telescope'.load_extension'dap'
        --end
    }

    -- keymaps
    use {
        "folke/which-key.nvim",
        config = function()
            local wk = require("which-key")
            local ts = require("telescope.builtin")
            local bl = require("bufferline")
            wk.register({
                a = {require("dapui").toggle, "toggledapui"},
                b = {ts.buffers, "Buffers"},
                c = {ts.commands, "Commands"},
                d = {require'lspsaga.provider'.preview_definition, "Defination"},
                f = {ts.file_browser, "FileBrowser"},
                h = {ts.help_tags, "HelpTag"},
                k = {require('lspsaga.hover').render_hover_doc, "HoverDoc"},
                o = {ts.find_files, "OpenFile"},
                p = {ts.lsp_document_diagnostics, "Diagnostics"},
                r = {ts.registers, "Registers"},
                s = {require('lspsaga.rename').rename, "RenameVariable"},
                t = {vim.lsp.buf.formatting, "Formatting"},
                x = {require"dap".continue, "DebugRunContinue"},
                z = {require"dap".toggle_breakpoint, "DebugBreakPoint"},
                M = {"<Cmd>TodoTelescope<Cr>", "TODOs"},
                D = {ts.lsp_definitions, "Defination"},
                T = {ts.treesitter, "TreesitterObject"},
                ["]"] = {require("lspsaga.diagnostic").lsp_jump_diagnostic_prev, "PrevDiag"},
                ["["] = {require("lspsaga.diagnostic").lsp_jump_diagnostic_next, "PrevDiag"},
                ["/"] = {ts.live_grep, "Buffers"},
                ["1"] = {function() bl.go_to_buffer(1) end, "which_key_ignore"},
                ["2"] = {function() bl.go_to_buffer(2) end, "which_key_ignore"},
                ["3"] = {function() bl.go_to_buffer(3) end, "which_key_ignore"},
                ["4"] = {function() bl.go_to_buffer(4) end, "which_key_ignore"},
                ["5"] = {function() bl.go_to_buffer(5) end, "which_key_ignore"},
                ["6"] = {function() bl.go_to_buffer(6) end, "which_key_ignore"},
                ["7"] = {function() bl.go_to_buffer(7) end, "which_key_ignore"},
                ["8"] = {function() bl.go_to_buffer(8) end, "which_key_ignore"},
                ["9"] = {function() bl.go_to_buffer(9) end, "which_key_ignore"},
                }, {prefix="<space>"})
      end
    }

    use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'},
        config = function() 
        require('gitsigns').setup()
    end
    }

end)
--}}}

