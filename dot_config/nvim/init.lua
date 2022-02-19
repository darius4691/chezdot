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
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.pumheight = 7

vim.api.nvim_set_var("loaded_python_provider", 0)  --- disable python2 support
vim.cmd("autocmd FileType make set noexpandtab")        --change space back to tab
vim.cmd("autocmd TermOpen * setlocal nonumber norelativenumber" )  -- disable line number in terminal mode

vim.cmd( "highlight link CompeDocumentation NormalFloat" )
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true})

vim.go.cscopequickfix = "s-,c-,d-,i-,t-,e-,a-"
vim.go.cscopeverbose = false

--: }}}

-- Packer {{{
require('packer').startup(function(use)
    -- Packer itself
    use 'wbthomason/packer.nvim'

    -- LSP and debugger {{{

    use {"L3MON4D3/LuaSnip"}

    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "quangnguyen30192/cmp-nvim-tags",
            'saadparwaiz1/cmp_luasnip'
        },
        config = function()
                local has_words_before = function()
                    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
                end

                local luasnip = require("luasnip")
                local cmp = require("cmp")
                cmp.setup{
                    snippet = {
                        expand = function(args)
                            require'luasnip'.lsp_expand(args.body)
                            vim.fn["vsnip#anonymous"](args.body)
                        end
                    },
                    sources = cmp.config.sources({
                        {name = "nvim_lsp"},
                        {name = "luasnip"},
                        {name = "buffer"},
                        {name = "tags", max_item_count = 5}
                    }),
                    mapping = {
                        ["<Tab>"] = cmp.mapping(
                            function(fallback)
                                if cmp.visible() then
                                    cmp.select_next_item()
                                elseif luasnip.expand_or_jumpable() then
                                    luasnip.expand_or_jump()
                                elseif has_words_before() then
                                    cmp.complete()
                                else
                                    fallback()
                                end
                            end, { "i", "s" }),
                        ["<S-Tab>"] = cmp.mapping(
                            function(fallback)
                                if cmp.visible() then
                                    cmp.select_prev_item()
                                elseif luasnip.jumpable(-1) then
                                    luasnip.jump(-1)
                                else
                                    fallback()
                                end
                            end, { "i", "s" }),
                        }
                  }
        end
    }

    use {"neovim/nvim-lspconfig",
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
            require'lspconfig'.pyright.setup{capabilities=capabilities}
            require'lspconfig'.gopls.setup{capabilities=capabilities}
            require'lspconfig'.clangd.setup{capabilities=capabilities}
            require'lspconfig'.jsonls.setup{capabilities=capabilities}
            require'lspconfig'.sumneko_lua.setup{
                capabilities=capabilities,
                settings = {
                    Lua = {
                      runtime = {
                        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT',
                      },
                      diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = {'vim'},
                      },
                      workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = vim.api.nvim_get_runtime_file("", true),
                      },
                      -- Do not send telemetry data containing a randomized but unique identifier
                      telemetry = {
                        enable = false,
                      },
                    },
                  }
            }
        end
    }

    -- LSP and debugger}}}


    --- UI & theme {{{

    use {'navarasu/onedark.nvim',
        config = function()
            vim.cmd[[colorscheme onedark]]
        end
    }

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
                c = {
                    function()
                        local file = vim.fn.findfile("cscope.out", ".;")
                        vim.cmd("silent! cs add "..file)
                        vim.fn.setqflist({})
                        vim.cmd("cs find c <cword>")
                        vim.cmd([[cclose]])
                        ts.quickfix()
                    end,
                    "CscopeRefs"},
                d = {ts.lsp_document_symbols, "DocumentSymbolDocumentSymbols"},
                h = {ts.help_tags, "HelpTag"},
                m = {ts.marks, "VimMarks"},
                q = {ts.quickfix, "QuickFix"},
                -- k = {require('lspsaga.hover').render_hover_doc, "HoverDoc"},
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
