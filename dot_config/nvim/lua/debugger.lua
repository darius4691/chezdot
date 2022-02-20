local dap = require('dap')
vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
dap.adapters.python = {
  type = 'executable';
  command = os.getenv("DEBUGPY_PATH");
  args = { '-m', 'debugpy.adapter' };
}
dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch';
    name = "Launch file";

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    program = "${file}"; -- This configuration will launch the current file if used.
    pythonPath = function()
      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
      local cwd = vim.fn.getcwd()
      local condapython = os.getenv("CONDA_PYTHON_EXE")
      if vim.fn.executable(condapython) == 1 then
          return condapython
      elseif vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      else
        return '/usr/bin/python'
      end
    end;
  },
}
dap.adapters.go = function(callback, config)
    local stdout = vim.loop.new_pipe(false)
    local handle
    local pid_or_err
    local port = 38697
    local opts = {
      stdio = {nil, stdout},
      args = {"dap", "-l", "127.0.0.1:" .. port},
      detached = true
    }
    handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
      stdout:close()
      handle:close()
      if code ~= 0 then
        print('dlv exited with code', code)
      end
    end)
    assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
    stdout:read_start(function(err, chunk)
      assert(not err, err)
      if chunk then
        vim.schedule(function()
          require('dap.repl').append(chunk)
        end)
      end
    end)
    -- Wait for delve to start
    vim.defer_fn(
      function()
        callback({type = "server", host = "127.0.0.1", port = port})
      end,
      100)
  end
  -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
    {
      type = "go",
      name = "Debug",
      request = "launch",
      program = "${file}"
    },
    {
      type = "go",
      name = "Debug test", -- configuration for debugging test files
      request = "launch",
      mode = "test",
      program = "${file}"
    },
    -- works with go.mod packages and sub packages 
    {
      type = "go",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}"
    }
}

-- dap.adapters.cppdbg = {
--   id = 'cppdbg',
--   type = 'executable',
--   command = '/absolute/path/to/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
-- }

--require("dapui").setup({
--  icons = { expanded = "▾", collapsed = "▸" },
--  mappings = {
--    -- Use a table to apply multiple mappings
--    expand = { "<CR>", "<2-LeftMouse>" },
--    open = "o",
--    remove = "d",
--    edit = "e",
--    repl = "r",
--  },
--  sidebar = {
--    open_on_start = false,
--    -- You can change the order of elements in the sidebar
--    elements = {
--      -- Provide as ID strings or tables with "id" and "size" keys
--      {
--        id = "scopes",
--        size = 0.25, -- Can be float or integer > 1
--      },
--      { id = "breakpoints", size = 0.25 },
--      { id = "stacks", size = 0.25 },
--      { id = "watches", size = 00.25 },
--    },
--    width = 40,
--    position = "left", -- Can be "left" or "right"
--  },
--  tray = {
--    open_on_start = false,
--    elements = { "repl" },
--    height = 10,
--    position = "bottom", -- Can be "bottom" or "top"
--  },
--  floating = {
--    max_height = nil, -- These can be integers or a float between 0 and 1.
--    max_width = nil, -- Floats will be treated as percentage of your screen.
--    mappings = {
--      close = { "q", "<Esc>" },
--    },
--  },
--  windows = { indent = 1 },
--})
