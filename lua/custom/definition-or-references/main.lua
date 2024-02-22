local definitions = require("custom.definition-or-references.definitions")
local references = require("custom.definition-or-references.references")
local methods = require("custom.definition-or-references.methods_state")
local config = require("custom.definition-or-references.config")
-- internal methods
local DefinitionOrReferences = {}

function DefinitionOrReferences.definition_or_references()
    config.get_config().before_start_callback()
    methods.clear_references()
    methods.clear_definitions()
    -- sending references request before definitons to parallelize both requests
    definitions()
    -- references.send_references_request()
end

return DefinitionOrReferences
