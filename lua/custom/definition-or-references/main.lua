local definitions = require("custom.definition-or-references.definitions")
local references = require("custom.definition-or-references.references")
local methods = require("custom.definition-or-references.methods_state")
local config = require("custom.definition-or-references.config")
-- internal methods
local DefinitionOrReferences = {}

function DefinitionOrReferences.definition_or_references()
    definitions()
end

return DefinitionOrReferences
