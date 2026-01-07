-- nvim-dap.lua
-- Debug Adapter Protocol client
local nvim_dap = {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "nvim-neotest/nvim-nio"
    }
}

local function setup_dotnet(dap)
    local netcoredbg_path = vim.fn.exepath("netcoredbg")

    if netcoredbg_path == "" then
        vim.notify("netcoredbg not found in PATH. Dotnet debugging will not be available.", vim.log.levels.WARN)
        return
    end

    dap.adapters.coreclr = {
        type = "executable",
        command = netcoredbg_path,
        args = { "--interpreter=vscode" }
    }

    local function load_launch_json()
        local root_dir = vim.fn.getcwd()
        local clients = vim.lsp.get_active_clients()
        if #clients > 0 and clients[1].config.root_dir then
            root_dir = clients[1].config.root_dir
        end

        local launch_json_path = root_dir .. '/launch.json'

        vim.notify("Looking for launch.json at: " .. launch_json_path, vim.log.levels.DEBUG)

        if vim.fn.filereadable(launch_json_path) == 0 then
            vim.notify("launch.json not found at: " .. launch_json_path, vim.log.levels.DEBUG)
            return nil
        end

        local ok, launch_data = pcall(vim.fn.json_decode, vim.fn.readfile(launch_json_path))

        if not (ok and launch_data and launch_data.configurations) then
            vim.notify("Failed to parse .vscode/launch.json", vim.log.levels.WARN)
            return nil
        end

        local coreclr_configs = {}
        for _, config in ipairs(launch_data.configurations) do
            if config.type == "coreclr" then
                if config.program and type(config.program) == "string" and not config.program:match("^/") then
                    config.program = root_dir .. "/" .. config.program
                end
                if config.cwd and type(config.cwd) == "string" and not config.cwd:match("^/") then
                    config.cwd = root_dir .. "/" .. config.cwd
                end

                table.insert(coreclr_configs, config)
            end
        end

        return #coreclr_configs > 0 and coreclr_configs or nil
    end

    dap.configurations.cs = {
        {
            type = "coreclr",
            name = "launch - netcoredbg",
            request = "launch",
            program = function()
                return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
            end,
        },
        {
            type = "coreclr",
            name = "attach - netcoredbg",
            request = "attach",
            processId = require('dap.utils').pick_process,
        }
    }

    -- Add launch.json configurations if available
    local launch_configs = load_launch_json()
    if launch_configs then
        for _, config in ipairs(launch_configs) do
            table.insert(dap.configurations.cs, config)
        end
    end

    vim.notify("=== All CS Configurations ===", vim.log.levels.INFO)
    for i, config in ipairs(dap.configurations.cs) do
        vim.notify(string.format("Config %d: %s", i, vim.inspect(config)), vim.log.levels.INFO)
    end
end

function nvim_dap.config()
    local dap = require("dap")
    setup_dotnet(dap)

    local dapui = require("dapui")
    dapui.setup()

    dap.listeners.before.attach.dapui_config = function()
        dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
        dapui.open()
    end
    dap.listeners.after.event_terminated.dapui_config = function()
        dapui.close()
    end
    dap.listeners.after.event_exited.dapui_config = function()
        dapui.close()
    end

    require("nvim-dap-virtual-text").setup()
end

function nvim_dap.keys()
    local dap = require("dap");
    local dapui = require("dapui");

    return {
        { "<F5>",       dap.continue,                                                              desc = "DAP: Continue" },
        { "<F6>",       dap.step_over,                                                             desc = "DAP: Step Over" },
        { "<F7>",       dap.step_into,                                                             desc = "DAP: Step Into" },
        { "<F8>",       dap.step_out,                                                              desc = "DAP: Step Out" },
        { "<leader>b",  dap.toggle_breakpoint,                                                     desc = "Toggle [B]reakpoint" },
        { "<leader>bc", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Toggle [B]reakpoint, [C]onditional" },
        { "<leader>rc", dap.run_to_cursor,                                                         desc = "[R]un to [C]ursor" },
        { "<leader>di", function() dapui.eval(nil, { enter = true }) end,                          desc = "[D]ebug [I]nspect" }
    }
end

return nvim_dap
