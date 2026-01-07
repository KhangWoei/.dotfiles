-- .NET debug adapter configuration
local dotnet = {}

function dotnet.setup(dap, launch_configs)
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

    if launch_configs then
        for _, config in ipairs(launch_configs) do
            if config["type"] == "coreclr" then
                table.insert(dap.configurations.cs, config)
            end
        end
    end
end

return dotnet
