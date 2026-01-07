-- Node.js debug adapter configuration
local node = {}

function node.setup(dap, launch_configs)
    local tsx_path = vim.fn.exepath("tsx")

    if tsx_path == "" then
        vim.notify("tsx not found in PATH. Typescript debugging will not be available.", vim.log.levels.WARN)
        return
    end

    dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
            command = "node",
            args = { "/home/khang/Projects/vscode-js-debug/dist/src/dapDebugServer.js", "${port}"
            }
        }
    }

    dap.configurations.typescript = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file (tsx)",
            program = "${file}",
            cwd = "${workspaceFolder}",
            runtimeExecutable = "tsx",
            sourceMaps = true,
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require('dap.utils').pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
        }
    }

    if launch_configs then
        for _, config in ipairs(launch_configs) do
            if config["type"] == "pwa-node" then
                table.insert(dap.configurations.typescript, config)
            end
        end
    end
end

return node
