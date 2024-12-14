-- Declare the module
local telescopePickers = {}

-- Store Utilities we'll use frequently
local telescopeUtilities = require("telescope.utils")
local make_entry = require("telescope.make_entry")
local plenaryStrings = require("plenary.strings")
local devIcons = require("nvim-web-devicons")
local telescopeEntryDisplayModule = require("telescope.pickers.entry_display")

-- Obtain Filename icon width
-- --------------------------
-- INSIGHT: This width applies to all icons that represent a file type
local fileTypeIconWidth = plenaryStrings.strdisplaywidth(devIcons.get_icon("fname", { default = true }))

---- Helper functions ----

-- Gets the File Path and its Tail (the file name) as a Tuple
function telescopePickers.getPathAndTail(fileName)
    -- Get the Tail
    local bufferNameTail = telescopeUtilities.path_tail(fileName)

    -- Now remove the tail from the Full Path
    local pathWithoutTail = require("plenary.strings").truncate(fileName, #fileName - #bufferNameTail, "")

    -- Apply truncation and other pertaining modifications to the path according to Telescope path rules
    local pathToDisplay = telescopeUtilities.transform_path({
        path_display = { "truncate" },
    }, pathWithoutTail)

    -- Return as Tuple
    return bufferNameTail, pathToDisplay
end

---- Picker functions ----

-- Generates a Find File picker but beautified
-- -------------------------------------------
-- This is a wrapping function used to modify the appearance of pickers that provide a Find File
-- functionality, mainly because the default one doesn't look good. It does this by changing the 'display()'
-- function that Telescope uses to display each entry in the Picker.
--
-- Adapted from: https://github.com/nvim-telescope/telescope.nvim/issues/2014#issuecomment-1541423345.
--
-- @param (table) pickerAndOptions - A table with the following format:
--                                   {
--                                      picker = '<pickerName>',
--                                      (optional) options = { ... }
--                                   }
function telescopePickers.prettyFilesPicker(ftype)
    local pickerAndOptions = {}
    if ftype == "file" then
        pickerAndOptions = {
            picker = "find_files",
            options = {
                previewer = false,
                -- layout_strategy = "vertical",
                layout_config = {
                    horizontal = {
                        width = 0.35,
                        height = 0.7,
                    },
                    mirror = false,
                },
            },
        }
    else
        pickerAndOptions = {
            cwd_only = false,
            picker = "oldfiles",
            options = {

                previewer = false,
                -- layout_strategy = "vertical",
                layout_config = {
                    prompt_position = "top",
                    width = 0.4,
                    height = 0.95,
                    mirror = true,
                    preview_cutoff = 0,
                    -- preview_height = 0.55,
                },
            },
        }
    end
    -- Parameter integrity check
    if type(pickerAndOptions) ~= "table" or pickerAndOptions.picker == nil then
        print(
            "Incorrect argument format. Correct format is: { picker = 'desiredPicker', (optional) options = { ... } }"
        )

        -- Avoid further computation
        return
    end

    -- Ensure 'options' integrity
    local options = pickerAndOptions.options or {}

    -- Use Telescope's existing function to obtain a default 'entry_maker' function
    -- ----------------------------------------------------------------------------
    -- INSIGHT: Because calling this function effectively returns an 'entry_maker' function that is ready to
    --          handle entry creation, we can later call it to obtain the final entry table, which will
    --          ultimately be used by Telescope to display the entry by executing its 'display' key function.
    --          This reduces our work by only having to replace the 'display' function in said table instead
    --          of having to manipulate the rest of the data too.
    local originalEntryMaker = make_entry.gen_from_file(options)

    -- INSIGHT: 'entry_maker' is the hardcoded name of the option Telescope reads to obtain the function that
    --          will generate each entry.
    -- INSIGHT: The paramenter 'line' is the actual data to be displayed by the picker, however, its form is
    --          raw (type 'any) and must be transformed into an entry table.
    options.entry_maker = function(line)
        -- Generate the Original Entry table
        local originalEntryTable = originalEntryMaker(line)

        -- INSIGHT: An "entry display" is an abstract concept that defines the "container" within which data
        --          will be displayed inside the picker, this means that we must define options that define
        --          its dimensions, like, for example, its width.
        local displayer = telescopeEntryDisplayModule.create({
            separator = " ", -- Telescope will use this separator between each entry item
            items = {
                { width = 1 },
                { width = nil },
                { remaining = true },
            },
        })

        -- LIFECYCLE: At this point the "displayer" has been created by the create() method, which has in turn
        --            returned a function. This means that we can now call said function by using the
        --            'displayer' variable and pass it actual entry values so that it will, in turn, output
        --            the entry for display.
        --
        -- INSIGHT: We now have to replace the 'display' key in the original entry table to modify the way it
        --          is displayed.
        -- INSIGHT: The 'entry' is the same Original Entry Table but is is passed to the 'display()' function
        --          later on the program execution, most likely when the actual display is made, which could
        --          be deferred to allow lazy loading.
        --
        -- HELP: Read the 'make_entry.lua' file for more info on how all of this works
        originalEntryTable.display = function(entry)
            -- Get the Tail and the Path to display
            local tail, pathToDisplay = telescopePickers.getPathAndTail(entry.value)

            -- Add an extra space to the tail so that it looks nicely separated from the path
            local tailForDisplay = tail .. " "

            -- Get the Icon with its corresponding Highlight information
            local icon, iconHighlight = telescopeUtilities.get_devicons(tail)

            -- INSIGHT: This return value should be a tuple of 2, where the first value is the actual value
            --          and the second one is the highlight information, this will be done by the displayer
            --          internally and return in the correct format.
            return displayer({
                { icon, iconHighlight },
                tailForDisplay,
                { pathToDisplay, "Comment" },
            })
        end

        return originalEntryTable
    end

    -- Finally, check which file picker was requested and open it with its associated options
    if pickerAndOptions.picker == "find_files" then
        require("telescope.builtin").find_files(options)
    elseif pickerAndOptions.picker == "git_files" then
        require("telescope.builtin").git_files(options)
    elseif pickerAndOptions.picker == "oldfiles" then
        require("telescope.builtin").oldfiles(options)
    elseif pickerAndOptions.picker == "" then
        print("Picker was not specified")
    else
        print("Picker is not supported by Pretty Find Files")
    end
end
-- Generates a Grep Search picker but beautified
-- ----------------------------------------------
-- This is a wrapping function used to modify the appearance of pickers that provide Grep Search
-- functionality, mainly because the default one doesn't look good. It does this by changing the 'display()'
-- function that Telescope uses to display each entry in the Picker.
--
-- @param (table) pickerAndOptions - A table with the following format:
--                                   {
--                                      picker = '<pickerName>',
--                                      (optional) options = { ... }
--                                   }
function telescopePickers.prettyGrepPicker(search, default_text, filetype)
    local pickerAndOptions = {
        picker = search,
        options = {
            on_complete = {
                vim.schedule_wrap(function()
                    local action_state = require("telescope.actions.state")
                    local prompt_bufnr = require("telescope.state").get_existing_prompt_bufnrs()[1]
                    local picker = action_state.get_current_picker(prompt_bufnr)
                    if not api.nvim_buf_is_valid(picker.results_bufnr) then
                        return
                    end
                    local count = api.nvim_buf_line_count(picker.results_bufnr)
                    if count == 1 then
                        pcall(require("treesitter-context").close_all)
                    end
                end),
            },
            layout_strategy = "vertical",
            layout_config = {
                vertical = {
                    prompt_position = "top",
                    width = 0.8,
                    height = 0.95,
                    mirror = true,
                    preview_cutoff = 0,
                    preview_height = 0.5,
                },
            },
        },
    }
    local function escape_for_ripgrep(text)
        local escapes = {
            ["\\"] = [[\]],
            ["^"] = [[\^]],
            ["$"] = [[\$]],
            ["."] = [[\.]],
            ["["] = [[\[]],
            ["]"] = "\\]",
            ["("] = [[\(]],
            [")"] = [[\)]],
            ["{"] = [[\{]],
            ["}"] = [[\}]],
            ["*"] = [[\*]],
            ["+"] = [[\+]],
            ["-"] = [[\-]],
            ["?"] = [[\?]],
            ["|"] = [[\|]],
            ["#"] = [[\#]],
            ["&"] = [[\&]],
            ["%"] = [[\%]],
        }
        return text:gsub(".", function(c)
            return escapes[c] or c
        end)
    end
    if default_text then
        if filetype == nil then
            pickerAndOptions.options.default_text = default_text
            pickerAndOptions.options.initial_mode = "insert"
        else
            local escaped_text = escape_for_ripgrep(default_text)
            local reformated_body = escaped_text:gsub("%s*\r?\n%s*", " ")
            if filetype == "rust" then
                filetype = "rs"
            end
            if filetype == "python" then
                filetype = "py"
            end
            if filetype == "txt" then
                filetype = "text"
            end
            if filetype ~= "" then
                pickerAndOptions.options.default_text = "`" .. filetype .. " " .. reformated_body
            else
                pickerAndOptions.options.default_text = reformated_body
            end
            pickerAndOptions.options.initial_mode = "normal"
        end
    end

    -- Parameter integrity check
    if type(pickerAndOptions) ~= "table" or pickerAndOptions.picker == nil then
        print(
            "Incorrect argument format. Correct format is: { picker = 'desiredPicker', (optional) options = { ... } }"
        )

        -- Avoid further computation
        return
    end

    -- Ensure 'options' integrity
    local options = pickerAndOptions.options or {}

    -- Use Telescope's existing function to obtain a default 'entry_maker' function
    -- ----------------------------------------------------------------------------
    -- INSIGHT: Because calling this function effectively returns an 'entry_maker' function that is ready to
    --          handle entry creation, we can later call it to obtain the final entry table, which will
    --          ultimately be used by Telescope to display the entry by executing its 'display' key function.
    --          This reduces our work by only having to replace the 'display' function in said table instead
    --          of having to manipulate the rest of the data too.
    local originalEntryMaker = make_entry.gen_from_vimgrep(options)

    -- INSIGHT: 'entry_maker' is the hardcoded name of the option Telescope reads to obtain the function that
    --          will generate each entry.
    -- INSIGHT: The paramenter 'line' is the actual data to be displayed by the picker, however, its form is
    --          raw (type 'any) and must be transformed into an entry table.
    options.entry_maker = function(line)
        -- Generate the Original Entry table
        local originalEntryTable = originalEntryMaker(line)
        -- INSIGHT: An "entry display" is an abstract concept that defines the "container" within which data
        --          will be displayed inside the picker, this means that we must define options that define
        --          its dimensions, like, for example, its width.
        local displayer = telescopeEntryDisplayModule.create({
            separator = " ", -- Telescope will use this separator between each entry item
            items = {
                { width = 1 },
                { width = nil },
                -- { width = nil }, -- Maximum path size, keep it short
                { remaining = true },
            },
        })

        -- LIFECYCLE: At this point the "displayer" has been created by the create() method, which has in turn
        --            returned a function. This means that we can now call said function by using the
        --            'displayer' variable and pass it actual entry values so that it will, in turn, output
        --            the entry for display.
        --
        -- INSIGHT: We now have to replace the 'display' key in the original entry table to modify the way it
        --          is displayed.
        -- INSIGHT: The 'entry' is the same Original Entry Table but is is passed to the 'display()' function
        --          later on the program execution, most likely when the actual display is made, which could
        --          be deferred to allow lazy loading.
        --
        -- HELP: Read the 'make_entry.lua' file for more info on how all of this works
        originalEntryTable.display = function(entry)
            ---- Get File columns data ----
            -------------------------------

            -- Get the Tail and the Path to display
            local tail, _ = telescopePickers.getPathAndTail(entry.filename)

            -- Get the Icon with its corresponding Highlight information
            local icon, iconHighlight = telescopeUtilities.get_devicons(tail)

            ---- Format Text for display ----
            ---------------------------------

            -- Add coordinates if required by 'options'
            local coordinates = ""

            if not options.disable_coordinates then
                if entry.lnum then
                    coordinates = string.format(" -> %s", entry.lnum)
                end
            end

            -- Append coordinates to tail
            tail = tail .. coordinates

            -- Add an extra space to the tail so that it looks nicely separated from the path
            local tailForDisplay = tail .. " "

            -- Encode text if necessary
            local text = options.file_encoding and vim.iconv(entry.text, options.file_encoding, "utf8") or entry.text

            -- INSIGHT: This return value should be a tuple of 2, where the first value is the actual value
            --          and the second one is the highlight information, this will be done by the displayer
            --          internally and return in the correct format.
            return displayer({
                { icon, iconHighlight },
                { tailForDisplay, "ChangedCmpItemKindInterface" },
                { text, "TelescopeNormal" },
            })
        end

        return originalEntryTable
    end

    -- Finally, check which file picker was requested and open it with its associated options
    if pickerAndOptions.picker == "live_grep" then
        require("telescope.builtin").live_grep(options)
    elseif pickerAndOptions.picker == "grep_string" then
        require("telescope.builtin").grep_string(options)
    elseif pickerAndOptions.picker == "egrepify" then
        require("telescope").extensions.egrepify.egrepify(options)
    elseif pickerAndOptions.picker == "agitator" then
        options.preview = {
            timeout = 10000,
        }
        require("agitator").search_in_added(options)
    elseif pickerAndOptions.picker == "" then
        print("Picker was not specified")
    else
        print("Picker is not supported by Pretty Grep Picker")
    end
end
local kind_icons = {
    Array = " ",
    Boolean = " 󰨙",
    Class = " 󰯳",
    Codeium = " 󰘦",
    Color = " ",
    Control = " ",
    Constant = " 󰯱",
    Constructor = " ",
    Enum = " 󰯹",
    EnumMember = " ",
    Field = " ",
    Function = " 󰊕",
    Interface = " 󰰅",
    Key = " ",
    Keyword = " 󱕴",
    Method = " 󰰑",
    Module = " 󰆼",
    Namespace = " 󰰔",
    Null = " ",
    Number = " 󰰔",
    Object = " 󰲟",
    Package = " 󰰚",
    Property = " 󰲽",
    Reference = " 󰰠",
    Struct = " 󰰣",
    TypeParameter = " 󰰦",
    Value = " ",
    Variable = " 󰄛",
}

local lsp_type_highlight = {
    ["Class"] = "ChangedCmpItemKindClass",
    ["Enum"] = "ChangedCmpItemKindEnum",
    ["EnumMember"] = "ChangedCmpItemKindEnumMember",
    ["TypeParameter"] = "ChangedCmpItemKindTypeParameter",
    ["Constant"] = "ChangedCmpItemKindConstant",
    ["Field"] = "ChangedCmpItemKindField",
    ["Function"] = "ChangedCmpItemKindFunction",
    ["Method"] = "ChangedCmpItemKindMethod",
    ["Property"] = "ChangedCmpItemKindProperty",
    ["Interface"] = "ChangedCmpItemKindInterface",
    ["Struct"] = "ChangedCmpItemKindStruct",
    ["Variable"] = "ChangedCmpItemKindVariable",
}
function telescopePickers.prettyDocumentSymbols(localOptions)
    if localOptions ~= nil and type(localOptions) ~= "table" then
        print("Options must be a table.")
        return
    end
    local options = localOptions or {}
    local originalEntryMaker = make_entry.gen_from_lsp_symbols(options)

    options.entry_maker = function(line)
        local originalEntryTable = originalEntryMaker(line)

        local displayer = telescopeEntryDisplayModule.create({
            separator = " ",
            items = {
                { width = fileTypeIconWidth },
                { width = 20 },
                { remaining = true },
            },
        })

        originalEntryTable.display = function(entry)
            return displayer({
                string.format("%s", kind_icons[(entry.symbol_type:lower():gsub("^%l", string.upper))]),
                { entry.symbol_type:lower(), "TelescopeResultsVariable" },
                { entry.symbol_name, "TelescopeResultsConstant" },
            })
        end

        return originalEntryTable
    end

    require("telescope.builtin").lsp_document_symbols(options)
end

function telescopePickers.prettyWorkspaceSymbols(localOptions)
    if localOptions ~= nil and type(localOptions) ~= "table" then
        print("Options must be a table.")
        return
    end

    local options = localOptions or {}

    local originalEntryMaker = make_entry.gen_from_lsp_symbols(options)

    options.entry_maker = function(line)
        local originalEntryTable = originalEntryMaker(line)

        local displayer = telescopeEntryDisplayModule.create({
            separator = " ",
            items = {
                { width = 12 },
                { width = 22 },
                { remaining = true },
            },
        })

        originalEntryTable.display = function(entry)
            local tail, _ = telescopePickers.getPathAndTail(entry.filename)
            local tailForDisplay = tail .. " "
            local _ = telescopeUtilities.transform_path({
                path_display = { shorten = { num = 2, exclude = { -2, -1 } }, "truncate" },
            }, entry.value.filename)

            return displayer({
                { "[" .. entry.symbol_type:lower() .. "]", lsp_type_highlight[entry.symbol_type] },
                { entry.symbol_name, "Black" },
                { tailForDisplay, "Comment" },
                -- { pathToDisplay, "TelescopeResultsComment" },
            })
        end

        return originalEntryTable
    end

    require("telescope.builtin").lsp_dynamic_workspace_symbols(options)
end

function telescopePickers.prettyBuffersPicker(previewer, initial)
    local localOptions = {}
    if previewer then
        localOptions = {
            initial_mode = initial,
            bufnr_width = 0,
            layout_strategy = "horizontal",
            attach_mappings = function(_, map)
                map("n", "d", function(prompt_bufnr)
                    require("telescope.actions").delete_buffer(prompt_bufnr)
                end, { nowait = true })
                return true
            end,
            previewer = false,
            layout_config = {
                horizontal = {
                    width = 0.35,
                    height = 0.7,
                },
                mirror = false,
            },
        }
    end
    if localOptions ~= nil and type(localOptions) ~= "table" then
        print("Options must be a table.")
        return
    end

    local options = localOptions or {}

    local originalEntryMaker = make_entry.gen_from_buffer(options)

    options.entry_maker = function(line)
        local originalEntryTable = originalEntryMaker(line)

        local displayer = telescopeEntryDisplayModule.create({
            separator = " ",
            items = {
                { width = 1 },
                { width = nil },
                { remaining = true },
            },
        })

        originalEntryTable.display = function(entry)
            local tail, path = telescopePickers.getPathAndTail(entry.filename)
            local tailForDisplay = tail .. " "
            local icon, iconHighlight = telescopeUtilities.get_devicons(tail)

            return displayer({
                { icon, iconHighlight },
                tailForDisplay,
                { path, "Comment" },
            })
        end

        return originalEntryTable
    end

    require("telescope.builtin").buffers(options)
end
-- Return the module for use
return telescopePickers
