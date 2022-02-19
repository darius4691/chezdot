-- vim:foldmethod=marker

-- Defaults {{{
vim.cmd("syntax enable") -- syntax highlight
vim.opt.number = true -- show line numbers
vim.opt.ruler = true
vim.opt.ttyfast = true                          -- terminal acceleration
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true                               -- set tabs for a shifttabs logic
vim.opt.expandtab = true
vim.opt.autoindent = true                             -- indent when moving to the next line while writing code
vim.opt.cursorline = true                            -- shows line under the cursor's line
vim.opt.showmatch = true                             -- shows matching part of bracket pairs (), [], {}
vim.opt.enc = "utf-8"                               -- utf-8 by default
vim.opt.backspace = "indent,eol,start"              -- backspace removes all (indents, EOLs, start) What is start?
vim.opt.scrolloff = 10                            -- let 10 lines before/after cursor during scroll
vim.opt.clipboard = "unnamedplus"                       -- use system clipboard
vim.opt.hidden = true                                  -- TextEdit might fail if hidden is not set. 
vim.opt.backup = false                                -- Some servers have issues with backup files, see #649.
vim.opt.writebackup = false
vim.opt.cmdheight = 2                             -- Give more space for displaying messages.
vim.opt.updatetime = 300                          -- reduce updatetime (default is 4000 ms = 4 s) leads to noticeable
vim.opt.iskeyword:append{"-"} -- treat dash separated words as a word text object"
vim.opt.signcolumn = "yes"                        -- Always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved.
vim.opt.showmode = false                              -- compatible with lightline
vim.opt.showtabline = 2                           -- show tab line always
vim.opt.list = true                                    -- show invisible characters
vim.opt.listchars = "tab:>-,trail:~"                -- list symbols, extends,precedes are useless if warp is on
vim.opt.foldnestmax = 1                           -- only fold top level
vim.opt.foldmethod = "syntax"                       --fold by syntax

vim.opt.termguicolors = true
vim.opt.completeopt = "menuone,noselect"

vim.api.nvim_set_var("loaded_python_provider", 0)  --- disable python2 support
vim.cmd("autocmd FileType make set noexpandtab")        --change space back to tab
vim.cmd("autocmd TermOpen * setlocal nonumber norelativenumber" )  -- disable line number in terminal mode

vim.cmd( "highlight link CompeDocumentation NormalFloat" )
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true})
--vim.api.nvim_set_var("vsnip_snippet_dir", "~/.config/nvim/snippets")

vim.go.cscopequickfix = "s-,c-,d-,i-,t-,e-,a-"
vim.go.cscopeverbose = false

--: }}}

-- Redefine tab completion {{{
--local t = function(str)
--  return vim.api.nvim_replace_termcodes(str, true, true, true)
--end
--
--local check_back_space = function()
--    local col = vim.fn.col('.') - 1
--    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
--        return true
--    else
--        return false
--    end
--end
--
--_G.tab_complete = function()
--  if vim.fn.pumvisible() == 1 then
--    return t "<C-n>"
--  elseif vim.fn.call("vsnip#available", {1}) == 1 then
--    return t "<Plug>(vsnip-expand-or-jump)"
--  elseif check_back_space() then
--    return t "<Tab>"
--  else
--    return vim.fn['compe#complete']()
--  end
--end
--
--_G.s_tab_complete = function()
--  if vim.fn.pumvisible() == 1 then
--    return t "<C-p>"
--  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
--    return t "<Plug>(vsnip-jump-prev)"
--  else
--    return t "<S-Tab>"
--  end
--end
--
--vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
--vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
--vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
--vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
--vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", {noremap=true, silent=true, expr=true})
--vim.cmd[[inoremap <silent><expr> <CR>      compe#confirm('<CR>')]]

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
            require'lspconfig'.clangd.setup{}
            require'lspconfig'.jsonls.setup{}
            --require'nvim_lsp'.vimls.setup{}
            --require'nvim_lsp'.sumneko_lua.setup{}
        end
    }

    use {"ms-jpq/coq_nvim",
        branch = 'coq'
    }

--    use {'hrsh7th/nvim-compe',
--        requires = {'hrsh7th/vim-vsnip', 'rafamadriz/friendly-snippets'},
--        config = function()
--            require'compe'.setup {
--                preselect = 'disable',
--                source = {
--                    path = true,
--                    buffer = true,
--                    calc = true,
--                    nvim_lsp = true,
--                    nvim_lua = false,
--                    vsnip = true,
--                    spell = true 
--                }
--            }
--        end
--    }
--
    --use { 'rcarriga/nvim-dap-ui', requires = {'mfussenegger/nvim-dap'},
    --    config = function()
    ----        require "debugger"
    --    end
    --}
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
    -- colorize hex color code for quick theme configuration
    use { "norcalli/nvim-colorizer.lua" ,
        config = function()
            require"colorizer".setup{
                "xdefaults";
                "conf";
                "dosini"
            }
        end
        }

    --- formatting
    use {'sbdchd/neoformat'}

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
    }

    -- keymaps
    use {
        "folke/which-key.nvim",
        config = function()
            local wk = require("which-key")
            local ts = require("telescope.builtin")
            local bl = require("bufferline")
            wk.register({
                --a = {require("dapui").toggle, "toggledapui"},
                b = {ts.buffers, "Buffers"},
                d = {ts.lsp_document_symbols, "DocumentSymbolDocumentSymbols"},
                h = {ts.help_tags, "HelpTag"},
                q = {ts.quickfix, "QuickFix"},
                -- k = {require('lspsaga.hover').render_hover_doc, "HoverDoc"},
                c = {
                    function()
                        -- find and link cscope
                        file = vim.fn.findfile("cscope.out", ".;")
                        vim.cmd("silent! cs add "..file)

                        local srcfile = vim.api.nvim_buf_get_name(0)
                        vim.fn.setqflist({})
                        vim.cmd([[normal! mY]])
                        vim.cmd("cs find c <cword>")
                        vim.cmd([[cclose]])
                        local curfile = vim.api.nvim_buf_get_name(0)
                        if curfile ~= srcfile then
                            vim.cmd([[normal! `Y]])
                        end
                        ts.quickfix()
                    end,
                    "CscopeRefs"},
                f = {function() ts.find_files{hidden=true} end, "OpenFile"},
                p = {ts.diagnostics, "Diagnostics"},
                r = {ts.lsp_references, "ListReferences"},
                s = {vim.lsp.buf.rename, "RenameVariable"},
                t = {ts.treesitter, "TreesitterObject"},
                M = {"<Cmd>TodoTelescope<Cr>", "TODOs"},
                T = {vim.lsp.buf.formatting, "Formatting"},
                ["."] = {ts.resume, "Resume"},
                [":"] = {ts.commands, "Commands"},
                ["]"] = {vim.diagnostic.goto_prev, "Next"},
                ["["] = {vim.diagnostic.goto_next, "PrevDiag"},
                ["/"] = {ts.current_buffer_fuzzy_find, "FindCurrent"},
                ["?"] = {ts.live_grep, "LiveGrep"},
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
            wk.register({g={
                d={ts.lsp_definitions, "GoToDef"},
                D={ts.lsp_type_definitions, "GoToTypeDef"},
            }})
      end
    }

    use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'},
        config = function() 
        require('gitsigns').setup()
    end
    }

end)
--}}}
