local D = {}

---prints only if debug is true.
---
---@param scope string: the scope from where this function is called.
---@param str string: the formatted string.
---@param ... any: the arguments of the formatted string.
---@private
function D.log(scope, str, ...) end

D.trace = D.log

---prints the table if debug is true.
---
---@param table table: the table to print.
---@param indent number?: the default indent value, starts at 0.
---@private
function D.tprint(table, indent) end

return D
