local function checkSplitAndSetLaststatus()
    local windows = vim.api.nvim_list_wins()
    local is_split = false

    for _, win in ipairs(windows) do
        local success, win_config = pcall(vim.api.nvim_win_get_config, win)
        if success then
            if win_config.relative ~= "" then
                goto continue
            end
        end
        local win_height = vim.api.nvim_win_get_height(win)
        local screen_height = vim.api.nvim_get_option("lines")
        print(win_height)
        print(screen_height)
        if win_height + 1 < screen_height then
            is_split = true
            break
        end
        ::continue::
    end

    if is_split then
        -- print("set statue = 3")
        -- vim.schedule()
        -- print("is_split")
        vim.cmd("set laststatus=3")
    else
        -- print("not is_split")
        vim.cmd("set laststatus=0")
    end
end
return { checkSplitAndSetLaststatus = checkSplitAndSetLaststatus }
