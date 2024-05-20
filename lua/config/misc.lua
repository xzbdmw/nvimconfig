keymap("n", "<C-f>", "<cmd>NvimTreeFocus<CR>")
keymap({ "n" }, "<leader>fn", '<cmd>lua require("nvim-tree.api").fs.create()<CR>', { desc = "create new file" })

keymap({ "s", "i", "n" }, "<C-7>", function()
    print(get_float_win_count())
    for _, win in pairs(vim.api.nvim_list_wins()) do
        local success, win_config = pcall(vim.api.nvim_win_get_config, win)
        if success then
            if win_config.relative ~= "" then
                print(vim.inspect(win))
                print(vim.inspect(win_config))
                vim.api.nvim_win_close(win, true)
            end
        end
    end
end, opts)
--[[ keymap("n", "<leader>zz", function()
    local n = require("nui-components")
    local fn = require("nui-components.utils.fn")
    local renderer = n.create_renderer({
        width = 80,
       height = 3,
        position = {
            row = 1,
            col = "50%",
        },
    })

    local data = {
        n.node({ text = "Code Documentation Standards" }),
        n.node({ text = "Version Control Workflow" }),
        n.node({ text = "Essential API Documentation" }),
        n.node({ text = "Bug Reporting Protocol" }),
        n.node({ text = "Testing Strategy Overview" }),
        n.node({ text = "Code Review Checklist" }),
        n.node({ text = "Agile Sprint Planning Guide" }),
        n.node({ text = "Deployment Process Documentation" }),
        n.node({ text = "Continuous Integration Setup" }),
        n.node({ text = "Security Protocol Documentation" }),
    }

    local signal = n.create_signal({
        search_value = "",
        data = data,
    })

    local get_data = function()
        return signal.data
            :dup()
            :combine_latest(signal.search_value:debounce(0):start_with(""), function(items, search_value)
                return fn.ifilter(items, function(item)
                    return string.find(item.text:lower(), search_value:lower())
                end)
            end)
    end

    local body = n.rows(
        n.text_input({
            size = 1,
            max_lines = 1,
            autofocus = true,
            on_change = function(value)
                signal.search_value = value
            end,
        }),
        n.tree({
            border_label = "",
            size = get_data()
                :map(function(lines)
                    return #lines
                end)
                :tap(function(lines)
                    renderer:set_size({ height = math.max(lines + 3, 3) })
                end),
            data = get_data(),
            hidden = get_data():map(function(lines)
                return #lines == 0
            end),
            on_select = function(node)
                print("selected: " .. node.text)
            end,
            prepare_node = function(node, line)
                line:append(node.text)
                return line
            end,
        })
    )

    renderer:render(body)
end, opts) ]]
-- keymap("i", "h", function()
--     _G.start_ttt = vim.uv.hrtime()
--     return "h"
-- end, { expr = true })
