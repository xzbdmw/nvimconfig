return {
    "EdenEast/nightfox.nvim",
    config = function()
        local options = {
            dim_inactive = false,
            -- module_default = false,
        }
        local palettes = {
            nightfox = {
                red = "#c94f6d",
            },
            nordfox = {
                comment = "#60728a",
            },
        }
        local specs = {
            dawnfox = {
                syntax = {
                    keyword = "#0033b3",
                    comment = "#7E7D7D",
                    conditional = "#0033b3",
                    func = "#215062",
                    number = "#0033B3",
                    operator = "#000000",
                    bracket = "#000000",
                    string = "#395C2A",
                    type = "#522775",
                    variable = "#000000",
                },
            },
        }
        local groups = {
            all = {
                -- RainbowDelimiterRed = { fg = "#ff9999" }, -- 浅红色
                -- RainbowDelimiterYellow = { fg = "#ffff99" }, -- 浅黄色
                -- RainbowDelimiterBlue = { fg = "#9999ff" }, -- 浅蓝色
                -- RainbowDelimiterOrange = { fg = "#ffcc99" }, -- 浅橙色
                -- RainbowDelimiterGreen = { fg = "#99ff99" }, -- 浅绿色
                -- RainbowDelimiterViolet = { fg = "#cc99ff" }, -- 浅紫色
                -- RainbowDelimiterCyan = { fg = "#99ffff" }, -- 浅青色
                -- DiagnosticVirtualTextWarn = { fg = "#EA9D34", bg = "#FAF7E8" },
                NoiceFormatProgressDone = { bg = "#D1D8D8" },
                LspInlayHint = { fg = "#595655", bg = "none" },
                illuminatedwordwrite = { link = "Visual" },
                MiniIndentscopeSymbol = { link = "Comment" },
                MatchParen = { fg = "#000000", style = "italic,bold" },
                TermCursor = { bg = "#5F5695", fg = "#ffffff" },
                lspFloatWinNormal = { bg = "#F4F1E9" },
                Normal = { fg = "#000000", bg = "#FAF7E8" },
                TelscopeNormal = { fg = "#000000" },
                Comment = { fg = "#7E7D7D" },
                Ufo = { link = "MyNormalDocFloat" },
                LazyNormal = { link = "MyNormalDocFloat" },
                MasonNormal = { link = "MyNormalDocFloat" },
                TroubleNormal = {},
                TroubleText = {},
                TroubleTextError = { fg = "#B4637A" },
                TroubleTextWarning = { fg = "#EA9D34" },
                UfoFoldedBg = { bg = "#EBE8DB" },
                Folded = { bg = "#F1EEE1" },
                MoreMsg = { fg = "#286983" },
                lualine_c_normal = { bg = "#FAF7E8" },
                DropBarIconKindArray = { fg = "#3b4d56" },
                DropBarIconKindBoolean = { fg = "#3b4d56" },
                DropBarIconKindType = { fg = "#3b4d56" },
                DropBarIconKindTypeParameter = { fg = "#3b4d56" },
                DropBarIconKindUnit = { fg = "#3b4d56" },
                DropBarIconKindStruct = { fg = "#3b4d56" },
                DropBarIconKindPackage = { fg = "#3b4d56" },
                DropBarIconKindMethod = { fg = "#3b4d56" },
                DropBarIconKindModule = { fg = "#3b4d56" },
                DropBarIconKindValue = { fg = "#3b4d56" },
                DropBarIconKindFile = { fg = "#3b4d56" },
                DropBarIconKindFolder = { fg = "#3b4d56" },
                DropBarIconKindInterface = { fg = "#3b4d56" },
                DropBarIconKindEnumMember = { fg = "#3b4d56" },
                DropBarIconKindIdentifier = { fg = "#3b4d56" },
                DropBarIconKindBreakStatement = { fg = "#3b4d56" },
                DropBarIconKindCall = { fg = "#3b4d56" },
                DropBarIconKindEvent = { fg = "#3b4d56" },
                DropBarIconKindField = { fg = "#3b4d56" },
                DropBarIconKindProperty = { fg = "#3b4d56" },
                DropBarIconKindVariable = { fg = "#3b4d56" },
                DropBarIconKindCaseStatement = { fg = "#3b4d56" },
                DropBarIconKindClass = { fg = "#3b4d56" },
                DropBarIconKindConstructor = { fg = "#3b4d56" },
                DropBarIconKindContinueStatement = { fg = "#3b4d56" },
                DropBarIconKindDeclaration = { fg = "#3b4d56" },
                DropBarMenuHoverIcon = { fg = "#3b4d56" },
                DropBarIconKindDelete = { fg = "#3b4d56" },
                DropBarIconKindDoStatement = { fg = "#3b4d56" },
                DropBarIconKindElseStatement = { fg = "#3b4d56" },
                DropBarIconKindEnum = { fg = "#3b4d56" },
                DropBarIconUIIndicator = {},
                DropBarMenuCurrentContext = { link = "DropBarMenuHoverEntry" },
                NormalFloat = { bg = "#FAF7E6", fg = "#000000" },
                MyNormalFloat = { bg = "#FAF7E6" },
                MyNormalDocFloat = { bg = "#f1efe1" },
                FloatBorder = { bg = "#FAF7E6" },
                LspFloatWinBorder = { link = "FloatBorder" },
                NormalNC = { bg = "#FAF7E8" },
                CursorLine = { bg = "#EBE8DB" },
                FloatCursorLine = { bg = "#EBE8DB" },
                LualineCursorLine = { bg = "#EBE8DB" },
                MyCursorLine = { bg = "#D1D8D8" },
                illuminatedWordText = { bg = "#D2D0D0" },
                illuminatedWordRead = { bg = "#D2D0D0" },
                StatusLine = { link = "Normal" },
                BufferLineBackground = { bg = "#E7E5D9", fg = "#3B4D56" },
                LspSignatureActiveParameter = { fg = "#000000", bg = "#D0D8D8" },
                TabLineSel = { bg = "#E7E5D9", fg = "#3B4D56" },
                StatusLineNC = { link = "Normal" },
                WinBar = { bg = "#FAF7E8", fg = "#3B4D56", style = "italic,bold" },
                WinBarNC = { bg = "#FAF7E8", fg = "#3B4D56", style = "italic,bold" },
                NvimTreeNormal = { bg = "#FAF7E8", fg = "#3B4D56" },
                NvimTreeNormalFloat = { bg = "#FAF7E8", fg = "#3B4D56" },
                NvimTreeIndentMarker = { bg = "#FAF7E8", fg = "#3B4D56" },
                NvimTreeRootFolder = { fg = "#3B4D56", style = "italic,bold" },
                NvimTreeOpenedFileIcon = { fg = "#8094b4" },
                BookmarkSign = { fg = "#3B7CF3" },
                NvimTreeCursorLine = { bg = "#EBE8DB", fg = "#000000", style = "italic,bold" },
                NvimTreeFolderIcon = { fg = "#3B4D56" },
                NvimTreeFolderName = { fg = "#3B4D56" },
                NvimTreeOpenedFolderName = { fg = "#3B4D56" },
                CmpItemAbbr = { fg = "#000000" },
                CmpItemAbbrMatch = { fg = "#000000", style = "bold" },
                CmpItemAbbrMatchFuzzy = { fg = "#000000", style = "bold" },
                CmpGhostText = { fg = "#595655", style = "italic" },
                TreesitterContext = { bg = "#FAF7E8", style = "bold" },
                Unvisited = { bg = "#C6C9C7" },
                Visited = { bg = "#9EA3AC" },
                CmpItemKindField = { fg = "#000000", bg = "#B5585F" },
                CmpItemMenu = { fg = "#3F4D56" },
                CmpItemKindProperty = { fg = "#000000", bg = "#7E8294" },
                CmpItemKindEvent = { fg = "#000000", bg = "#B5585F" },
                CmpItemKindText = { fg = "#000000", bg = "#9FBD73" },
                CmpItemKindEnum = { fg = "#000000", bg = "#9FBD73" },
                CmpItemKindKeyword = { fg = "#000000", bg = "#7E8294" },
                CmpItemKindConstant = { fg = "#000000", bg = "#7E8294" },
                CmpItemKindConstructor = { fg = "#000000", bg = "#D4BB6C" },
                CmpItemKindReference = { fg = "#000000", bg = "#D4BB6C" },
                CmpItemKindFunction = { fg = "#000000", bg = "#A377BF" },
                CmpItemKindStruct = { fg = "#000000", bg = "#B5585F" },
                CmpItemKindClass = { fg = "#000000", bg = "#A377BF" },
                CmpItemKindModule = { fg = "#000000", bg = "#D4BB6C" },
                CmpItemKindOperator = { fg = "#000000", bg = "#A377BF" },
                CmpItemKindVariable = { fg = "#000000", bg = "#7E8294" },
                CmpItemKindFile = { fg = "#000000", bg = "#7E8294" },
                CmpItemKindUnit = { fg = "#000000", bg = "#D4A959" },
                CmpItemKindSnippet = { fg = "#000000", bg = "#7E8294" },
                CmpItemKindFolder = { fg = "#000000", bg = "#D4A959" },
                CmpItemKindMethod = { fg = "#000000", bg = "#6C8ED4" },
                CmpItemKindValue = { fg = "#000000", bg = "#6C8ED4" },
                CmpItemKindEnumMember = { fg = "#000000", bg = "#6C8ED4" },
                CmpItemKindInterface = { fg = "#000000", bg = "#943D1D" },
                CmpItemKindColor = { fg = "#000000", bg = "#58B5A8" },
                CmpItemKindTypeParameter = { fg = "#000000", bg = "#58B5A8" },
                TelescopePromptTitle = { fg = "#3D4D56" },
                -- TelescopeBorder = { fg = "#3D4D56" },
                SagaBeacon = { bg = "#F1D694" },
                TelescopeTitle = { fg = "#3D4D56" },
                TelescopeNormal = { fg = "#000000", style = "bold,italic" },
                TelescopeParent = { link = "TelescopeTitle" },
                TelescopeSelection = { bg = "#D1D8D8" },
                TelescopeMatching = { style = "bold", bg = "#b8cece" },
                TelescopeResultsComment = { fg = "#000000" },
                TelescopeResultsLineNr = { fg = "#000000" },
                CursorLineNr = { fg = "#777A89", style = "bold,italic" },
                LineNr = { fg = "#AFB3C1" },
                Search = { bg = "#F1D694" },
                FlashLabel = { bg = "#A2F7E4", style = "italic" },
                FlashMatch = { style = "italic" },
                FlashCurrent = { fg = "#3D4D56", bg = "#A2F7E4" },
                ["@string.escape"] = { fg = "#395C2A", style = "italic,bold" },
                ["@lsp.type.namespace"] = { fg = "#152381" },
                ["@lsp.type.property"] = { fg = "#152381" },
                ["@lsp.type.variable"] = { fg = "#000000" },
                ["@keyword"] = { fg = "#0033b3" },
                ["@variable.member"] = { fg = "#152381" },
                ["@variable.member.go"] = { fg = "#000000" },
                ["@lsp.type.namespace.rust"] = { fg = "#000000" },
                ["@constructor"] = { fg = "#215062" },
                ["@lsp.typemod.variable.defaultLibrary.go"] = { fg = "#592479" },
                ["@lsp.typemod.selfKeyword"] = { fg = "#000000", style = "italic" },
                ["@lsp.type.selfTypeKeyword"] = { fg = "#0033b3", style = "italic" },
                ["@lsp.type.enum"] = { fg = "#592479" },
                ["@lsp.type.string"] = { link = "@string" },
                ["@variable.parameter"] = { fg = "#000000" },
                ["@lsp.typemod.enum"] = { fg = "#592479" },
                ["@constant.builtin"] = { fg = "#152381" },
                ["@function.macro.rust"] = { link = "@property" },
                ["@lsp.typemod.macro.defaultLibrary.rust"] = { link = "@property" },
                ["@lsp.mod.attribute.rust"] = { fg = "#59595E" },
                ["@lsp.type.macro.rust"] = { link = "@property" },
                ["@lsp.typemod.typeParameter"] = { fg = "#000000" },
                ["@lsp.type.typeParameter"] = { fg = "#000000" },
                ["@module.rust"] = { link = "@lsp.type.namespace.rust" },
                ["@module.go"] = { fg = "#152381" },
                ["@property.go"] = { link = "Functions" },
                ["@lsp.type.function"] = { fg = "#215062" },
                ["Functions"] = { fg = "#215062" },
                ["Constant"] = { fg = "#0033b3" },
                ["@lsp.typemod.method.library"] = { fg = "#215062" },
                ["@lsp.typemod.enumMember.library"] = { fg = "#152381" },
                ["@lsp.typemod.interface"] = { fg = "#80462D" },
                ["@type.builtin"] = { fg = "#0033b3" },
                ["@function.builtin"] = { fg = "#215062" },
                ["@variable.builtin.rust"] = { fg = "#000000" },
                ["@variable.builtin"] = { fg = "#000000" },
                ["@field"] = { fg = "#000000" },
                ["@identifier"] = { fg = "#000000" },
                ["Identifier"] = { fg = "#000000" },
                ["@parameters"] = { fg = "#000000" },
                ["@parameter"] = { fg = "#000000" },
                ["@lsp.typemod.arithmetic.injected.rust"] = { fg = "#000000" },
                ["@lsp.typemod.generic"] = { fg = "#000000" },
                ["@lsp.type.punctuation"] = { fg = "#000000" },
                ["@variable"] = { fg = "#000000" },
                ["@variable.parameter.go"] = { fg = "#000000" },
                ["@type.builtin.go"] = { fg = "#592479" },
                ["@namespace"] = { fg = "#000000" },
                ["@property"] = { link = "@variable.member" },
                ["@constructor.lua"] = { fg = "#000000" },
                ["@spell"] = { fg = "#000000" },
                ["@spell.go"] = { link = "Comment" },
                ["@spell.rust"] = { link = "Comment" },
                ["@spell.lua"] = { link = "Comment" },
                ["@markup.raw.block"] = { fg = "#592479" },
                ["@keyword.import"] = { fg = "#0033b3" },
                ["@keyword.storage.rust"] = { fg = "#0033b3" },
                ["@keyword.return"] = { fg = "#0033b3" },
            },
        }

        require("nightfox").setup({
            options = options,
            palettes = palettes,
            specs = specs,
            groups = groups,
        })
    end,
}
