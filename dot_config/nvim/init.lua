-- vim:foldmethod=marker
-- README {{{
-- Install packer first
-- Unix-like:
--   git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
-- Windows(PowerShell):
--   git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"
-- }}}
-- HELPER FUNCTION {{{
function Dolist(list, func)
    for _, item in ipairs(list) do
        if type(item) == "table" then
            func(unpack(item))
        else
            func(item)
        end
    end
end
-- }}}

-- Defaults {{{
vim.opt.number = true                               -- show line numbers
vim.opt.ruler = true
vim.opt.ttyfast = true                              -- terminal acceleration
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true                             -- set tabs for a shifttabs logic
vim.opt.expandtab = true
vim.opt.autoindent = true                           -- indent when moving to the next line while writing code
vim.opt.cursorline = true                           -- shows line under the cursor's line
vim.opt.showmatch = true                            -- shows matching part of bracket pairs (), [], {}
vim.opt.enc = 'utf-8'                               -- utf-8 by default
vim.opt.backspace = 'indent,eol,start'              -- backspace removes all (indents, EOLs, start) What is start?
vim.opt.scrolloff = 10                              -- let 10 lines before/after cursor during scroll
vim.opt.clipboard = 'unnamedplus'                   -- use system clipboard
vim.opt.hidden = true                               -- textEdit might fail if hidden is not set.
vim.opt.backup = false                              -- some servers have issues with backup files, see #649.
vim.opt.writebackup = false
vim.opt.cmdheight = 2                               -- give more space for displaying messages.
vim.opt.updatetime = 300                            -- reduce updatetime (default is 4000 ms = 4 s) leads to noticeable
vim.opt.iskeyword:append{'-'}                       -- treat dash separated words as a word text object"
vim.opt.signcolumn = 'yes'                          -- Always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved.
vim.opt.showmode = false                            -- compatible with lightline
vim.opt.showtabline = 2                             -- show tab line always
vim.opt.list = true                                 -- show invisible characters
vim.opt.listchars = 'tab:>-,trail:~'                -- list symbols, extends,precedes are useless if warp is on
vim.opt.foldnestmax = 1                             -- only fold top level
vim.opt.foldmethod = 'syntax'                       -- fold by syntax

vim.opt.termguicolors = true                        -- enable true color
vim.opt.completeopt = 'menu,menuone,noselect'       -- completion menu options
vim.opt.pumheight = 7                               -- limit the completion menu height
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case" -- use ripgrep for completion
vim.opt.helplang = "cn,en"

vim.opt.cscopequickfix = 's-,c-,d-,i-,t-,e-,a-'
vim.opt.cscopeverbose = false
vim.opt.omnifunc = "v:lua.vim.lsp.omnifunc"         -- use lsp for omni completion
vim.api.nvim_set_var('loaded_python_provider', 0)   -- disable python2 support
vim.cmd('syntax enable')                            -- syntax highlight
vim.cmd('autocmd TermOpen * setlocal nonumber norelativenumber' )  -- disable line number in terminal mode

Dolist({
    {'t', '<Esc>', '<C-\\><C-n>', {noremap = true}},
    {'n', ']l', '<CMD>lnext<CR>', {noremap = true}},
    {'n', '[l', '<CMD>lprev<CR>', {noremap = true}},
    {'n', ']f', '<CMD>cnext<CR>', {noremap = true}},
    {'n', '[f', '<CMD>cprev<CR>', {noremap = true}},
    {'n', '<C-_>s', '<CMD>cs f s <cword><CR>', {noremap = true}},
    {'n', '<C-_>g', '<CMD>cs f g <cword><CR>', {noremap = true}},
    {'n', '<C-_>c', '<CMD>cs f c <cword><CR>', {noremap = true}},
    {'n', '<C-_>t', '<CMD>cs f t <cword><CR>', {noremap = true}},
    {'n', '<C-_>e', '<CMD>cs f e <cword><CR>', {noremap = true}},
    {'n', '<C-_>f', '<CMD>cs f f <cfile><CR>', {noremap = true}},
    {'n', '<C-_>i', '<CMD>cs f i <cfile><CR>', {noremap = true}},
    {'n', '<C-_>d', '<CMD>cs f d <cword><CR>', {noremap = true}},
    {'n', '<C-_>a', '<CMD>cs f a <cword><CR>', {noremap = true}}
}, vim.api.nvim_set_keymap)

-- vim.diagnostic.setloclist()
--: }}}
vim.cmd("command! ReloadInit :luafile " .. vim.fn.stdpath("config") .. "/init.lua")
local packer = require('packer')
packer.init()
packer.use 'wbthomason/packer.nvim'
-- Completion {{{
packer.use {'L3MON4D3/LuaSnip'}
packer.use {
    'hrsh7th/nvim-cmp',
    requires = {
        'hrsh7th/cmp-path', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline', 'saadparwaiz1/cmp_luasnip'
    },
    config = function()
        local has_words_before = function()
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and
                       vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(
                           col, col):match("%s") == nil
        end

        local luasnip = require("luasnip")
        local cmp = require("cmp")
        cmp.setup {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },
            sources = cmp.config.sources({
                {name = "nvim_lsp"}, {name = "luasnip"}, {name = "path"},
                {name = "buffer"}
            }),
            mapping = {
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, {"i", "s"}),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, {"i", "s"}),
                ['<CR>'] = cmp.mapping.confirm({select = false})
            }
        }
        cmp.setup.cmdline(':', {
            sources = cmp.config.sources({{name = 'cmdline'}},
                                         {{name = 'path'}, {name = 'buffer'}})
        })
    end
}
-- }}}
-- LSP {{{
packer.use {
    'neovim/nvim-lspconfig',
    config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local lspconfig = require 'lspconfig'
        capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
        lspconfig.pyright.setup {capabilities = capabilities}
        lspconfig.gopls.setup {capabilities = capabilities}
        lspconfig.clangd.setup {capabilities = capabilities, autostart = false}
        lspconfig.jsonls.setup {capabilities = capabilities}
        lspconfig.sumneko_lua.setup {
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = {version = 'LuaJIT'},
                    diagnostics = {globals = {'vim'}},
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true)
                    },
                    telemetry = {enable = false}
                }
            }
        }
    end
}

packer.use {
    'mfussenegger/nvim-lint',
    config = function()
        local lint = require('lint')
        lint.linters_by_ft = {cpp = {'cppcheck'}, c = {'cppcheck'}}
        vim.cmd("command! Lint :lua require('lint').try_lint()<CR>")
    end
}
-- }}}
-- UI and theme {{{
-- nix highlight
packer.use {'LnL7/vim-nix', ft = {"nix"}}

packer.use {
    'folke/tokyonight.nvim',
    config = function() vim.g.tokyonight_style = "night" end
}
packer.use {'sainnhe/everforest'}
packer.use {
    'navarasu/onedark.nvim',
    config = function() vim.cmd("colorscheme everforest") end
}

--- lualine
packer.use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
        require('lualine').setup {
            options = {
                component_separators = {left = '', right = ''},
                section_separators = {left = '', right = ''}
            },
            tabline = {lualine_a = {"tabs"}, lualine_z = {"buffers"}},
            extensions = {'fugitive', 'quickfix'}
        }
    end
}
--- }}}
-- tools {{{
-- git integration
packer.use 'tpope/vim-fugitive' -- align
packer.use 'tpope/vim-surround'
packer.use 'tpope/vim-repeat' -- enable repeating supported plugin maps with .
packer.use 'junegunn/vim-easy-align' -- <count>ai ii aI iI indent level
packer.use 'michaeljsmith/vim-indent-object' -- quoting/parenthesizing
packer.use 'jiangmiao/auto-pairs' -- colorize hex color code for quick theme configuration
packer.use {
    "norcalli/nvim-colorizer.lua",
    config = function()
        require"colorizer".setup {"xdefaults", "conf", "dosini"}
    end
}

packer.use {
    "darius4691/nvim-projectconfig",
    config = function() require("nvim-projectconfig").setup {} end
}

-- tags auto generating
packer.use {
    "ludovicchabant/vim-gutentags",
    config = function()
        local tag_cache_dir = vim.fn.stdpath('cache') .. '/tags'
        if not vim.fn.isdirectory(tag_cache_dir) then
            vim.fn.mkdir(tag_cache_dir, 'p')
        end
        Dolist({
            {'project_root', {'.root', '.svn', '.git', '.hg', '.project'}},
            {'ctags_tagfile', '.tags'}, {'cache_dir', tag_cache_dir}, {
                'ctags_extra_args', {
                    '--fields,+niazS', '--extras,+fq', '--kinds-C,+px',
                    '--kinds-C++,+px', '--output-format,e-ctags'
                }
            }, {'modules', {'ctags', 'cscope'}},
            {'define_advanced_commands', 1}, {
                'file_list_command', 'find . -name ' ..
                    table.concat(
                        {
                            '"*.c"', '"*.cpp"', '"*.h"', '"*.py"', '"*.lua"',
                            '"*.go"'
                        }, " -o -name ")
            }
        }, function(k, v) vim.api.nvim_set_var("gutentags_" .. k, v) end)
    end
}

-- Treesitter and highlight
packer.use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
        'p00f/nvim-ts-rainbow', 'nvim-treesitter/nvim-treesitter-refactor'
    },
    run = ':TSUpdate',
    config = function()
        require'nvim-treesitter.configs'.setup {
            ensure_installed = {
                "python", "go", "json", "bash", "lua", "c", "cpp"
            },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn",
                    node_incremental = "}",
                    scope_incremental = "grc",
                    node_decremental = "{"
                }
            },
            refactor = {
                highlight_definitions = {enable = true},
                highlight_current_scope = {enable = true}
            },
            rainbow = {
                enable = true,
                extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
                max_file_lines = 10000 -- Do not enable for files with more than n lines, int
            }
        }
    end
}

--- hightlight
packer.use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function() require("todo-comments").setup() end
}

packer.use {
    'lewis6991/gitsigns.nvim',
    requires = {'nvim-lua/plenary.nvim'},
    config = function() require('gitsigns').setup() end
}
-- telescope
packer.use {
    "nvim-telescope/telescope.nvim",
    requires = {
        "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim",
        "ahmedkhalf/project.nvim", "nvim-telescope/telescope-file-browser.nvim"
    },
    config = function()
        require("project_nvim").setup {manual_mode = true}
        local ts = require("telescope")
        local actions = require "telescope.actions"
        ts.setup {
            pickers = {
                quickfix = {theme = "dropdown"},
                loclist = {theme = "dropdown"},
                marks = {theme = "ivy"},
                current_buffer_fuzzy_find = {theme = "ivy"},
                find_files = {hidden = true},
                commands = {theme = "ivy"},
                buffers = {mappings = {i = {["<c-d>"] = actions.delete_buffer}}}
            }
        }
        Dolist({'projects', 'file_browser'}, ts.load_extension)
    end
}
-- }}}

-- Key Mappings {{{
packer.use {
    "folke/which-key.nvim",
    config = function()
        local wk = require("which-key")
        local te = require('telescope')
        local ts = require("telescope.builtin")
        wk.register({
            b = {ts.buffers, "Buffers"},
            g = {ts.grep_string, "GrepCword"},
            h = {ts.help_tags, "HelpTag"},
            l = {ts.loclist, "LocList"},
            m = {ts.marks, "VimMarks"},
            c = {ts.quickfix, "QuickFix"},
            f = {ts.find_files, "OpenFile"},
            p = {ts.diagnostics, "Diagnostics"},
            r = {ts.lsp_references, "ListReferences"},
            t = {ts.treesitter, "TreesitterObject"},
            D = {ts.lsp_document_symbols, "DocumentSymbol"},
            F = {te.extensions.file_browser.file_browser, "FileBrowser"},
            M = {"<Cmd>TodoTelescope<Cr>", "TODOs"},
            P = {te.extensions.projects.projects, "Project"},
            S = {vim.lsp.buf.rename, "RenameVariable"},
            Q = {vim.lsp.buf.formatting, "Formatting"},
            ["."] = {ts.resume, "Resume"},
            [":"] = {ts.commands, "Commands"},
            ["]"] = {vim.diagnostic.goto_prev, "NextDiag"},
            ["["] = {vim.diagnostic.goto_next, "PrevDiag"},
            ["/"] = {ts.current_buffer_fuzzy_find, "FindCurrent"},
            ["?"] = {ts.live_grep, "LiveGrep"},
            ["1"] = {"1gt", "which_key_ignore"},
            ["2"] = {"2gt", "which_key_ignore"},
            ["3"] = {"3gt", "which_key_ignore"},
            ["4"] = {"4gt", "which_key_ignore"},
            ["5"] = {"5gt", "which_key_ignore"},
            ["6"] = {"6gt", "which_key_ignore"},
            ["7"] = {"7gt", "which_key_ignore"},
            ["8"] = {"8gt", "which_key_ignore"},
            ["9"] = {"9gt", "which_key_ignore"}
        }, {prefix = "<space>"})
        wk.register({
            g = {
                d = {ts.lsp_definitions, "GoToDef"},
                D = {ts.lsp_type_definitions, "GoToTypeDef"}
            }
        })
        -- which-key hijacked telescope C-r paste buffer command
        vim.api.nvim_exec([[
            augroup telescope
                autocmd!
                autocmd FileType TelescopePrompt inoremap <buffer> <silent> <C-r> <C-r>
            augroup END]], false)
    end
}
--}}}
-- Debugger {{{
packer.use {
    'mfussenegger/nvim-dap',
    requires = {
        "nvim-telescope/telescope-dap.nvim", 'theHamsta/nvim-dap-virtual-text'
    },
    config = function()
        local ts = require("telescope")
        local wk = require("which-key")
        local dap = require("dap")
        vim.cmd([[
        highlight DapBreakpoint ctermbg=0 guifg=#993939 guibg=#31353f
        highlight DapLogPoint   ctermbg=0 guifg=#61afef guibg=#31353f
        highlight DapStopped    ctermbg=0 guifg=#98c379 guibg=#31353f
        ]])
        Dolist({
            {
                'DapBreakpoint',
                {
                    text = '',
                    texthl = 'DapBreakpoint',
                    linehl = '',
                    numhl = 'DapBreakpoint'
                }
            }, {
                'DapBreakpointCondition',
                {
                    text = 'ﳁ',
                    texthl = 'DapBreakpoint',
                    linehl = '',
                    numhl = 'DapBreakpoint'
                }
            }, {
                'DapBreakpointRejected',
                {
                    text = '',
                    texthl = 'DapBreakpoint',
                    linehl = '',
                    numhl = 'DapBreakpoint'
                }
            }, {
                'DapLogPoint', {
                    text = '',
                    texthl = 'DapLogPoint',
                    linehl = 'DapLogPoint',
                    numhl = 'DapLogPoint'
                }
            }, {
                'DapStopped', {
                    text = '',
                    texthl = 'DapStopped',
                    linehl = 'DapStopped',
                    numhl = 'DapStopped'
                }
            }
        }, vim.fn.sign_define)
        require("nvim-dap-virtual-text").setup()
        ts.load_extension("dap")
        wk.register({
            name = 'DapList',
            b = {dap.toggle_breakpoint, "DapBreak"},
            x = {dap.continue, "DapContinue"},
            c = {ts.extensions.dap.commands, "Commands"},
            s = {ts.extensions.dap.configuration, "Settings(cfg)"},
            v = {ts.extensions.dap.variables, "Variables"},
            f = {ts.extensions.dap.frames, "Frames(stack)"},
            o = {dap.repl.open, "DapREPL"},
            l = {ts.extensions.dap.list_breakpoints, "BreakPoints"},
            a = {
                function()
                    local widgets = require('dap.ui.widgets')
                    widgets.centered_float(widgets.scopes)
                end, "ScopeWidget"
            },
            t = {
                function()
                    local widgets = require('dap.ui.widgets')
                    widgets.centered_float(widgets.frames)
                end, "FrameWidget"
            }
        }, {prefix = "<leader>"})
    end
}
--}}}
