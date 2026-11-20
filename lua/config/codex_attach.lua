local M = {}
local root = vim.fn.expand("~/.codex/codex-shortcut-launcher/scripts/")
local node = "/Applications/ChatGPT.app/Contents/Resources/cua_node/bin/node"
local state_file = vim.fn.stdpath("state") .. "/codex-window-bindings.json"
local function instance()
  if vim.v.servername == "" then vim.fn.serverstart() end
  return vim.v.servername
end
local function bindings()
  local ok, data = pcall(vim.fn.readfile, state_file)
  if not ok then return {} end
  local parsed, value = pcall(vim.json.decode, table.concat(data, "\n"))
  return parsed and type(value) == "table" and value or {}
end
local function request(payload, callback)
  vim.system({ node, root .. "neovim-client.mjs" }, { text = true, stdin = vim.json.encode(payload) }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then vim.notify(result.stderr, vim.log.levels.ERROR); return end
      local ok, value = pcall(vim.json.decode, result.stdout)
      if not ok then vim.notify("Invalid Codex response", vim.log.levels.ERROR); return end
      callback(value)
    end)
  end)
end
function M.attach()
  local owner = instance()
  request({ action = "list" }, function(chats)
    if #chats == 0 then vim.notify("No Codex sidebar chats available"); return end
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    require("telescope.pickers").new({}, {
      prompt_title = "Attach this Neovide window to Codex",
      sorting_strategy = "ascending",
      finder = require("telescope.finders").new_table({ results = chats, entry_maker = function(chat)
        local label = chat.title .. "  [" .. chat.hostId .. "]  " .. chat.cwd
        return { value = chat, display = label, ordinal = label }
      end }),
      sorter = require("telescope.config").values.generic_sorter({}),
      attach_mappings = function(buf)
        actions.select_default:replace(function()
          local selected = action_state.get_selected_entry()
          if not selected then return end
          actions.close(buf)
          local all = bindings()
          all[owner] = selected.value
          vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
          vim.fn.writefile({ vim.json.encode(all) }, state_file)
          vim.notify("Attached to " .. selected.value.title)
        end)
        return true
      end,
    }):find()
  end)
end
function M.send_selection()
  local bound = bindings()[instance()]
  if not bound then vim.notify("Run :CodexAttach first", vim.log.levels.WARN); return end
  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
    vim.notify("Select code in Visual mode first", vim.log.levels.WARN); return
  end
  local first, last = vim.fn.getpos("v"), vim.fn.getpos(".")
  local lines = vim.fn.getregion(first, last, { type = mode, exclusive = vim.o.selection == "exclusive" })
  local filename = vim.api.nvim_buf_get_name(0)
  local text = table.concat(lines, "\n")
  if text:match("^%s*$") then return end
  local from, to = math.min(first[2], last[2]), math.max(first[2], last[2])
  local header = string.format("Neovim buffer selection\nSource host: %s\nFile: %s\nLines: %d-%d\nUnsaved changes: %s\n\n",
    vim.fn.hostname(), filename ~= "" and filename or "[No Name]", from, to, tostring(vim.bo.modified))
  vim.ui.input({ prompt = "Note for " .. bound.title .. ": " }, function(note)
    if note == nil then return end
    local annotation = note:match("%S") and ("Note: " .. note .. "\n\n") or ""
    request({ action = "send", sessionId = bound.sessionId, text = annotation .. header .. text }, function()
      vim.notify("Selection added to " .. bound.title)
    end)
  end)
end
function M.detach()
  local all = bindings()
  all[instance()] = nil
  vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
  vim.fn.writefile({ vim.json.encode(all) }, state_file)
  vim.notify("Codex window binding removed")
end
return M
