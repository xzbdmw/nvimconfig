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
            dayfox = {
                inactive = "#090909", -- Slightly lighter then black background
                syntax = {
                    keyword = "#9F3F9E",
                    comment = "#7E7D7D",
                    conditional = "#9F3F9E",
                    func = "#0033b3",
                    number = "#D3604F",
                    operator = "#4D4F52",
                    bracket = "#4D4F52",
                    string = "#59904E",
                    type = "#0373A4",
                    variable = "#383A41",
                },
            },
            dawnfox = {
                syntax = {
                    keyword = "#0033b3",
                    comment = "#6d6b6b",
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
            dawnfox = {
                Visual = { bg = "#D8E0E0" },
                NormalNC = { link = "Normal" },
                NoiceFormatProgressDone = { bg = "#D1D8D8" },
                BranchName = { fg = "#3B4D56" },
                CommitWinbar = { fg = "#636262", style = "underline" },
                MiniSnippetsCurrent = { link = "None" },
                MiniSnippetsVisited = { style = "underline", sp = "#DCDCD7" },
                MiniSnippetsFinal = { link = "MiniSnippetsVisited" },
                MiniSnippetsUnVisited = { style = "underline", sp = "#DCDCD7" },
                -- MiniSnippetsFinal = { fg = "#ff0000" },
                None = {},
                CommitNCWinbar = { fg = "#636262", style = "italic,underline" },
                CommitHasDiffWinbar = { fg = "#636262", style = "underline" },
                CommitHasDiffNCWinbar = { fg = "#636262", style = "italic,underline" },
                TelescopeResultDiffStaged = { fg = "#558873" },
                TelescopePromptCounter = { link = "CmpGhostTextNonItalic" },
                SnacksPickerDimmed = { link = "CmpGhostTextNonItalic" },
                SnacksPickerRow = { link = "CmpGhostTextNonItalic" },
                SnacksPickerDelim = { link = "SnacksPickerRow" },
                SnacksPickerCol = { link = "CmpGhostTextNonItalic" },
                SnacksPickerMatch = { link = "TelescopeMatching" },
                SnacksPickerDir = { link = "CmpGhostTextNonItalic" },
                SnacksPickerFile = { link = "SmartUnOpened" },
                SnacksPickerPreviewCursorLine = { link = "TelescopeSelection" },
                SnacksPickerListCursorLine = { link = "TelescopeSelection" },
                SnacksPickerBorder = { fg = "#e8e7e0" },
                TelescopeResultDiffUnStaged = { fg = "#C15E7A" },
                WinBarHunk = { fg = "#363A72" },
                IncSearch = { fg = "none", bg = "#C9D2F5" },
                NoiceScrollbar = { fg = "#FBF7E6" },
                -- NoiceCmdlinePopupBorder = { fg = "#ff0000" },
                LspInlayHint = { fg = "#7E7D7D", bg = "none" },
                LspReferenceText = { bg = "#DEE2E2" },
                -- MiniIndentscopeSymbol = { fg = "#D6D8DB" },
                MiniIndentscopeSymbol = { fg = "#CECECD" },
                GitSignsAddNr = { fg = "#AEC2AF" },
                GitSignsUntrackedNr = { link = "LineNr" },
                GitSignsChangeNr = { fg = "#8688BF" },
                TabLineSel = { bg = "#f0ecde", fg = "#364E57" },
                GitSignsStagedAddNr = { fg = "#6A9580" },
                GrugFarResultsMatchAdded = { bg = "#CAFCD6" },
                GrugFarResultsMatchRemoved = { bg = "#FFDEDE" },
                GitSignsChangeInline = { link = "DiffText" },
                GitSignsAddInline = { link = "DiffText" },
                GitSignsChangePreview = { link = "DiffChange" },
                GitSignsStagedDeleteNr = { fg = "#b4637a" },
                GitSignsStagedChangeNr = { fg = "#8688BF" },
                GitSignsChangedeleteNr = { fg = "#8688bf" },
                GitSignsStagedChangedeleteNr = { fg = "#8688bf" },
                GitSignsCurrentLineBlame = { fg = "#9294BE" },
                GitSignsChange = { fg = "#A4AAD9" },
                GitSignsStagedChange = { fg = "#A4AAD9" },
                GitSignsAdd = { fg = "#9BBCA3" },
                GitSignsDeleteInline = { bg = "#A1BDC4" },
                GitSignsDeleteVirtLnInLine = { bg = "#EABAB8" },
                Directory = { link = "Comment" },
                MatchParen = { fg = "", style = "underline" },
                SatelliteBar = { bg = "#faf7e8" },
                SatelliteCursor = { bg = "#CFD4CD", fg = "#CFD4CD" },
                SignCursor = { fg = "#DEDAD5" },
                SatelliteSearch = { link = "SatelliteQuickfix" },
                SatelliteQuickfix = { fg = "#7275D2" },
                AerialLine = { link = "NvimTreeCursorLine" },
                Substitute = { bg = "#FCF0A1", fg = "#000000", style = "bold" },
                -- I have the same problem and more
                AerialGuide = { link = "LineNr" },
                Title = { fg = "#268BD2", style = "bold" },
                MultiCursorMain = { bg = "#C9D2F5" },
                MultiCursorSign = { fg = "#949FD1" },
                MultiCursorMainSign = { fg = "#7987E0" },
                -- TermCursor = { bg = "#7E7D7D", fg = "#ffffff" },
                GitConflictIncomingLabel = { link = "DiffText" },
                GitConflictCurrent = { bg = "#E1E5E2" },
                GitConflictIncoming = { bg = "#dbded5" },
                GitConflictCurrentLabel = { link = "DiffText" },
                lspFloatWinNormal = { bg = "#F4F1E9" },
                Normal = { fg = "#000000", bg = "#FAF7E8" },
                LighterVisual = { bg = "#ECEEE7" },
                MultiCursor = { bg = "#514F4C", fg = "#ffffff" },
                -- Normal = { fg = "#3B3B3C", bg = "#ffffff" },
                Ufo = { link = "MyNormalDocFloat" },
                MasonNormal = { link = "MyNormalDocFloat" },
                TroubleNormal = { link = "Normal" },
                TroubleTextError = { fg = "#B4637A" },
                GrugFarResultsMatch = { link = "Search" },
                TroubleTextWarning = { fg = "#EA9D34" },
                UfoFoldedBg = { bg = "#EBE8DB" },
                ArrowIcon = { fg = "#717070" },
                ArrowBookmarkNote = { fg = "#215062", style = "italic,bold" },
                DiffFileCount = { fg = "#6D6B6B", style = "italic,bold" },
                ArrowNoteMode = { bg = "#215062" },
                CopilotSuggestion = { fg = "#1D6D8D" },
                ArrowCursorLine = { link = "CursorLine" },
                Folded = { bg = "#F5F1E3", fg = "#CECECD" },
                MoreMsg = { fg = "#286983" },
                lualine_c_normal = { bg = "#FAF7E8" },
                diffChanged = { link = "Keyword" },
                DiffChange = { bg = "#E4EBEB" },
                DiffText = { bg = "#CFDCF1" },
                DiffAdd = { bg = "#D9EDD9" },
                DiffDelete = { fg = "#6d6b6b", bg = "#ecd7d6" },
                MCDisabled = { bg = "#C0BCBC" },
                NoiceSearch = { fg = "#025164", bg = "#D5DAEA" },
                illuminatedH = { fg = "#000000", bg = "#D5DAEA" },
                illuminatedHItalic = { fg = "#000000", bg = "#D5DAEA", style = "italic" },
                ItalicComment = { fg = "#7E7D7D", style = "italic" },
                HlSearchLensNear = { fg = "#2B2B2B", bg = "#D5DAEA", style = "italic,bold" },
                QuickFixHeaderSoft = { fg = "#e8e7e0" },
                QuickFixHeaderHard = { link = "QuickFixHeaderSoft" },
                Delimiter = { link = "QuickFixHeaderSoft" },
                HlSearchLensNearFail = { fg = "#A93463", bg = "#F9E3E3", style = "italic,bold,undercurl" },
                HlSearchLensCount = { fg = "#636262", bg = "#D5DAEA" },
                HlSearchLensCountItalic = { fg = "#636262", bg = "#D5DAEA", style = "italic" },
                HlSearchLensCountNoBg = { fg = "#636262" },
                HlSearchLensCountItalicNoBg = { fg = "#636262", style = "italic" },
                HlSearchLensCountFail = { fg = "#B85E7D", bg = "#F9E3E3" },
                LeapBackdrop = { fg = "none" },
                LeapMatch = { fg = "#AA3622", bg = "none", style = "italic" },
                LeapLabelPrimary = { link = "LeapMatch" },
                -- diffRemoved = { fg = "#E7EADE" },
                MiniDiffSignAdd = { link = "GitSignsAdd" },
                GitSignsDeleteVirtLn = { bg = "#ecd7d6" },
                MiniDiffOverAdd = { bg = "#E6EADD" },
                MiniDiffSignChange = { link = "diffChanged" },
                -- MiniDiffOverContext = { bg = "#E6E6E6" },
                -- MiniDiffOverChange = { bg = "#D3D9D9" },
                MiniDiffSignDelete = { link = "GitSignsDelete" },
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
                LazygitFloatBorder = { fg = "#152381" },
                GlanceListMatch = { fg = "#000000", bg = "#FAF0AA" },
                GlanceListCursorLine = { bg = "#d0d8d8" },
                GlanceBorderTop = { link = "WinSeparator" },
                GlanceListBorderBottom = { link = "WinSeparator" },
                GlancePreviewBorderBottom = { link = "WinSeparator" },
                GlanceWinbarFileName = { fg = "#000000" },
                GlanceWinbarFolderName = { fg = "#7E7D7D" },
                SymbolHighlight = { bg = "#D9E0E0" },
                GlancePreviewMatch = { link = "Search" },
                TroublePreview = { link = "GlancePreviewMatch" },
                -- GlancePreviewNormal = { link = "MyNormalDocFloat" },
                DropBarMenuCurrentContext = { link = "DropBarMenuHoverEntry" },
                -- barbecue_normal = { link = "Normal" },
                barbecue_dirname = { fg = "#3b4d56" },
                barbecue_ellipsis = { link = "barbecue_dirname" },
                NormalFloat = { link = "Normal" },
                LazyNormal = { link = "Normal" },
                MyNormalFloat = { link = "Normal" },
                MyNormalDocFloat = { link = "Normal" },
                ToggleTerm1FloatBorder = { link = "FloatBorder" },
                FloatBorder = { bg = "#faf7e8" },
                LspFloatWinBorder = { link = "FloatBorder" },
                CursorLine = { bg = "#F0ECDE" },
                CursorLineMC = { bg = "#F0ECDE" },
                FloatCursorLine = { bg = "#EBE8DB" },
                LualineCursorLine = { bg = "#EBE8DB" },
                SubstituteRange = { link = "Substitute" },
                -- FzfLuaBorder = { fg = "#BDBFC9" },
                FzfLuaHeaderText = { link = "TelescopeTitle" },
                FzfLuaHeaderBind = { link = "TelescopeTitle" },
                -- FzfLuaBorder = { link = "TelescopeBorder" },
                ArrowCurrentFile = { link = "Comment" },
                CodeActionNumber = { link = "Comment" },
                QuickFixLine = { style = "bold,italic" },
                MyCmpCursorLine = { bg = "#faf7e8", style = "underline,bold,italic", sp = "#e8e7e0" }, -- only current line need to add underline
                NoMyCmpCursorLine = { bg = "#faf7e8", style = "bold,italic" }, -- when there is only one entry
                BlinkCmpMenuSelection = { link = "MyCursorLine" },
                illuminatedWordText = { bg = "#E3E0E0" },
                illuminatedWordRead = { bg = "#E3E0E0" },
                illuminatedWordKeepText = { link = "Search" },
                illuminatedWordKeepRead = { link = "Search" },
                illuminatedWordKeepWrite = { link = "IncSearch" },
                StatusLine = { link = "Normal" },
                BufferLineBackground = { bg = "#E7E5D9", fg = "#3B4D56" },
                LspSignatureActiveParameter = { fg = "", bg = "#D0D8D8" },
                StatusLineNC = { link = "Normal" },
                WinBar = { bg = "#FAF7E8", fg = "#3B4D56", style = "" },
                WinBarNC = { bg = "#FAF7E8", fg = "#3B4D56", style = "" },
                WinbarFolder = { fg = "#3B4D56" },
                WinbarFileName = { fg = "#000000" },
                NvimTreeNormal = { bg = "#FAF7E8", fg = "#3B4D56" },
                SmartUnOpened = { fg = "#403D3D" },
                NvimTreeFolderArrowOpen = { link = "Directory" },
                NvimTreeFolderArrowClosed = { link = "Directory" },
                NvimTreeNormalFloat = { bg = "#FAF7E8", fg = "#3B4D56" },
                NvimTreeIndentMarker = { fg = "#F1F1E7" },
                TabLine = { link = "Normal" },
                EyelinerPrimary = { link = "FlashLabel" },
                EyelinerSecondary = { link = "Search" },
                TXT = { fg = "#2D5D22" },
                TabLineFill = { link = "Normal" },
                NvimTreeOpenedFileIcon = { fg = "#8094b4" },
                GithubSign = { bg = "#F6F8FA" },
                SpellCap = { style = "" },
                gitcommitHeader = { link = "Title" },
                gitcommitFirstLine = { fg = "#000000", style = "bold,italic" },
                gitcommitSummary = { fg = "#000000", style = "bold,italic" },
                gitcommitSelectedFile = { fg = "#364E57" },
                gitcommitDiscardedFile = { fg = "#364E57" },
                hlchunk = { fg = "#DCDCD4" },
                gitcommitSelectedType = { link = "Comment" },
                gitcommitDiscardedType = { link = "Comment" },
                ArrowBookmarkSign = { link = "LineNr" },
                -- NvimTreeCursorLine = { bg = "#EBE8DB", style = "italic,bold" },
                NvimTreeFolderIcon = { fg = "#3B4D56" },
                MiniFilesDirectory = { link = "NvimTreeFolderName" },
                NvimTreeFolderName = { link = "Directory" },
                NvimTreeOpenedFolderName = { link = "NvimTreeFolderName" },
                NvimTreeRootFolder = { link = "NvimTreeFolderName" },
                NvimTreeOpenedFile = { fg = "#000000" },
                NvimTreeOpenedHL = { fg = "#000000" },
                OilSize = { fg = "#215062", style = "bold" },
                NvimTreeGitDirtyIcon = { fg = "#CB7A8E" },
                NvimTreeGitStagedIcon = { fg = "#438A72" },
                CmpItemAbbr = { fg = "#000000" },
                CmpItemAbbrMatch = { fg = "none", style = "bold,nocombine" },
                CmpItemAbbrMatchCursorLine = { fg = "none", style = "bold,underline,nocombine", sp = "#e8e7e0" },
                CmpItemAbbrMatchFuzzyCursorLine = { fg = "none", style = "bold,underline,nocombine", sp = "#e8e7e0" },
                CmpItemAbbrMatchCmdLine = { link = "TelescopeMatching" },
                BlinkCmpLabelMatch = { style = "bold" },
                BlinkCmpMenu = { link = "MyNormalFloat" },
                CmpItemAbbrMatchFuzzy = { link = "CmpItemAbbrMatch" },
                MiniSnippetsUnvisited = { link = "Unvisited" },
                MiniSnippetsCurrentReplace = { link = "illuminatedWordWrite" },
                FileChangedIcon = { fg = "#1D6D8D" },
                -- CmpItemAbbrMatch = { fg = "#152381", style = "bold" },
                -- CmpItemAbbrMatchFuzzy = { fg = "#152381", style = "bold" },
                CmpGhostText = { fg = "#7E7D7D" },
                CmpGhostTextItalic = { fg = "#A4A3A3", style = "italic" },
                NvimTreeLineCount = { fg = "#A4A3A3" },
                CmpGhostTextNonItalic = { fg = "#A4A3A3" },
                PasteHint = { fg = "#afb3c1", bg = "#faf7e8" },
                Cursor = { fg = "#FBF7E6", bg = "#000000" },
                MacroWinabr = { fg = "#D23F3F" },
                -- CmpGhostText = { link = "@variable" },
                TreesitterContext = { fg = "#AFB3C1", bg = "#FAF7E8" },
                TreesitterContextBottom = { sp = "#E8E7E0", style = "underline" },
                TreesitterContextLineNumber = { fg = "#AEB3C2" },
                Unvisited = { link = "illuminatedWordRead" },
                Visited = { bg = "#9EA3AC" },
                CmpItemKindField = { fg = "#B5585F" },
                CmpItemMenu = { fg = "#7E7D7D" },
                CmpItemKindProperty = { fg = "#7E8294" },
                CmpItemKindEvent = { fg = "#B5585F" },
                CmpItemKindText = { fg = "#215062" },
                CmpItemKindEnum = { fg = "#9FBD73" },
                CmpItemKindKeyword = { fg = "#7E8294" },
                CmpItemKindConstant = { fg = "#7E8294" },
                CmpItemKindConstructor = { fg = "#D4BB6C" },
                CmpItemKindReference = { fg = "#215062" },
                CmpItemKindFunction = { fg = "#6C8ED4" },
                CmpItemKindStruct = { fg = "#6c8ed4" },
                CmpItemKindClass = { fg = "#6c8ed4" },
                CmpItemKindColor = { fg = "#215062" },
                CmpItemKindModule = { fg = "#d4bb6c" },
                CmpItemKindOperator = { link = "CmpItemKindFile" },
                CmpItemKindVariable = { fg = "#112386" },
                CmpItemKindFile = { fg = "#7E8294" },
                CmpItemKindUnit = { fg = "#D4A959" },
                CmpItemKindSnippet = { fg = "#7E8294" },
                CmpItemKindCopilot = { fg = "#112386" },
                RustIcon = { fg = "#C58C6E" },
                CmpItemKindFolder = { fg = "#D4A959" },
                CmpItemKindMethod = { fg = "#6C8ED4" },
                CmpItemKindValue = { fg = "#6C8ED4" },
                CmpItemKindEnumMember = { fg = "#6C8ED4" },
                CmpItemKindInterface = { fg = "#B5585F" },
                CmpItemKindTypeParameter = { fg = "#58B5A8" },
                ChangedCmpItemKindField = { fg = "#B5585F" },
                ChangedCmpItemKindEnumMember = { fg = "#B5585F" },
                ChangedCmpItemKindTypeParameter = { link = "ChangedCmpItemKindStruct" },
                ChangedCmpItemKindEnum = { fg = "#6c8ed4" },
                ChangedCmpItemKindProperty = { fg = "#B5585F" },
                ChangedCmpItemKindConstant = { fg = "#7E8294" },
                ChangedCmpItemKindFunction = { fg = "#215062" },
                ChangedCmpItemKindStruct = { fg = "#6c8ed4" },
                ChangedCmpItemKindInterface = { fg = "#522775" },
                ChangedCmpItemKindClass = { fg = "#6c8ed4" },
                ChangedCmpItemKindVariable = { fg = "#6c8ed4" },
                ChangedCmpItemKindMethod = { fg = "#215062" },
                TelescopePromptTitle = { fg = "#3D4D56" },
                TelescopeFileName = { fg = "#BEACC5" },
                DiagnosticVirtualTextError = { fg = "#E7636B", bg = "#FBE8D9" },
                DiagnosticVirtualTextWarn = { fg = "#FF9112", bg = "#FEECD2" },
                DiagnosticUnderlineWarn = { sp = "#999797", style = "undercurl" },
                DiagnosticUnderlineErrorUnused = { sp = "#6F6D6C", style = "undercurl" },
                DiagnosticSignWarn = { fg = "#999797" },
                DiagnosticUnnecessary = { fg = "none", bg = "none" },
                DiagnosticVirtualTextInfo = { fg = "#215062", bg = "none" },
                DiagnosticVirtualTextHint = { fg = "#215063", bg = "none" },
                SagaBeacon = { bg = "#F1D694" },
                TelescopeTitle = { fg = "#3D4D56" },
                TelescopeNormal = { fg = "#000000" },
                Search = { fg = "none", bg = "#C2D7DE" },
                YankyPut = { bg = "#FCF0A1" },
                YankyYanked = { link = "YankyPut" },
                SubstituteSubstituted = { link = "YankyPut" },
                Whitespace = { fg = "#868DB7" },
                LeapBG = { fg = "none", bg = "#FCF0A1" },
                CurSearch = { link = "IncSearch" },
                FlashCurrent = { link = "IncSearch" },
                FlashLabel = { link = "LeapMatch" },
                FlashLabelCursorline = { fg = "#aa3622", bg = "#F0ECDE", style = "italic" },
                FLashPrompt = { fg = "#364E57", style = "italic,underline" },
                NoiceCmdlineIconSearch = { fg = "#BEACC5" },
                NoiceFormatLevelWarn = { fg = "#ac5402", bg = "#EEE8D5" },
                Pmenu = { bg = "" },
                PmenuThumb = { bg = "#E8E7DF" },
                PortalLabel = { bg = "#A2F7E4" },
                TelescopeParent = { link = "TelescopeTitle" },
                TelescopeSelection = { bg = "#F0ECDE", style = "italic,bold" },
                hl_bookmarks_csl = { link = "TelescopeMatching" },
                -- TelescopeMatching = { bg = "#FCF0A1" },
                TelescopeMatching = { fg = "#C15E7A", style = "bold,nocombine" },
                TelescopeGrepMatching = { bg = "#e3e0e0", style = "bold,italic,nocombine" },
                TelescopeResultsComment = { fg = "#000000" },
                TelescopeResultsLineNr = { fg = "#000000" },
                TelescopePreviewLine = { link = "TelescopeSelection" },
                CursorLineNr = { fg = "#777A89", style = "bold,italic" },
                LineNr = { fg = "#AFB3C1" },
                LibPath = { fg = "#2D5D22" },
                BoldBlue = { fg = "#0033b3", style = "bold" },
                ["@string.regexp.lua"] = { link = "@string.escape" },
                ["@lsp.type.macro.lua"] = { link = "@variable" },
                ["@lsp.typemod.typeParameter.definition.go"] = { link = "@type" },
                ["@lsp.type.typeParameter.go"] = { link = "@type" },
                ["@go.error.go"] = { link = "@interface.name" },
                ["@lsp.mod.placeholder.go"] = { link = "@printf.printf" },
                ["@lsp.typemod.variable.number.go"] = { link = "@variable.member.go" },
                ["@go.string.go"] = { link = "Keyword" },
                ["@constant.go"] = { link = "@lsp.mod.const.go" },
                ["@lsp.mod.const.go"] = { fg = "#000000", style = "underline" },
                ["@spell.xml"] = { link = "@none" },
                ["@receiver"] = { fg = "#000000", style = "italic" },
                ["@string.documentation.python"] = { link = "Comment" },
                ["@keyword.operator.lua"] = { link = "Keyword" },
                ["@spell.python"] = { link = "Comment" },
                ["@spell.markdown"] = { fg = "#000000" },
                ["@markup.raw"] = { fg = "#0033b3", style = "" },
                ["@markup.link"] = { style = "underline" },
                ["@markup.link.label.markdown_inline"] = { fg = "#215062", style = "underline" },
                ["@comment.rust"] = { fg = "#6d6b6b", style = "" },
                ["Comment"] = { fg = "#6d6b6b", style = "" },
                ["@comment.documentation.rust"] = { link = "@comment.rust" },
                ["@spell.rust"] = { link = "@comment.rust" },
                ["@keyword.operator.rust"] = { link = "@keyword" },
                ["@markup.strong.markdown_inline"] = { link = "Title" },
                ["@spell"] = { link = "Comment" },
                ["@string.escape"] = { fg = "#395C2A", style = "italic" },
                ["@lsp.type.namespace"] = { link = "@variable.member.go" },
                ["@lsp.type.macro.cpp"] = { fg = "#1F542E" },
                ["@lsp.typemod.keyword.documentation.lua"] = { link = "@comment" },
                ["@lsp.type.keyword.lua"] = { link = "@comment" },
                ["@keyword.luadoc"] = { link = "@comment" },
                ["preProc"] = { fg = "#9E880D" },
                ["@lsp.type.macro.c"] = { link = "@lsp.type.macro.cpp" },
                ["@lsp.typemod.method.unsafe.rust"] = { fg = "#215062", bg = "#F8E6D5" },
                ["@lsp.typemod.parameter.callable.rust"] = { fg = "#215062" },
                ["@lsp.type.property"] = { fg = "#152381" },
                ["@printf.printf"] = { link = "@property.go" },
                ["@lsp.type.variable"] = { fg = "#000000" },
                ["@lsp.type.interface"] = { link = "@trait.definition" },
                ["@lsp.type.variable.go"] = {},
                ["@keyword"] = { fg = "#0033b3" },
                ["@keyword.operator.cpp"] = { link = "Keyword" },
                ["@variable.member"] = { fg = "#152381" },
                ["@variable.special"] = { fg = "#777A89", style = "italic" },
                ["@punctuation.bracket.special"] = { link = "Comment" },
                ["@variable.builtin.python"] = { style = "italic" },
                ["@keyword.operator.python"] = { link = "Keyword" },
                ["@lsp.type.namespace.rust"] = { fg = "#000000" },
                ["@constructor"] = { fg = "#215062" },
                ["@lsp.typemod.variable.defaultLibrary.go"] = { fg = "#592479" },
                ["@lsp.typemod.variable.defaultLibrary.rust"] = { fg = "#000000" },
                ["@lsp.typemod.selfKeyword"] = { fg = "#000000", style = "italic" },
                ["@lsp.type.selfTypeKeyword"] = { fg = "#0033b3", style = "italic" },
                ["@lsp.type.selfKeyword"] = { fg = "#000000", style = "italic" },
                ["@lsp.type.enum"] = { fg = "#592479" },
                ["@spell.go"] = { link = "Comment" },
                ["@lsp.typemod.operator.controlFlow.rust"] = { link = "@trait.definition" },
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
                ["@module.cpp"] = { fg = "#152381" },
                ["@variable.member.go"] = { fg = "#152381" },
                ["@property.go"] = { fg = "#152381" },
                ["@interface.name.go"] = { fg = "#80462D" },
                ["@interface.name"] = { fg = "#80462D" },
                ["@trait.definition"] = { fg = "#80462D" },
                ["@lsp.typemod.interface"] = { fg = "#80462D" },
                ["@lsp.mod.interface.go"] = { fg = "#80462D" },
                ["@lsp.mod.signature.go"] = { fg = "#215062" },
                ["@lsp.type.interface.typescript"] = { fg = "#80462D" },
                ["@lsp.type.function"] = { fg = "#215062" },
                ["Functions"] = { fg = "#215062" },
                ["@markup.italic"] = { style = "italic" },
                ["Constant"] = { fg = "#0033b3" },
                ["@lsp.typemod.method.library"] = { fg = "#215062" },
                ["@lsp.typemod.enumMember.library"] = { fg = "#152381" },
                ["@function.macro.vim"] = { fg = "#152381" },
                ["@type.builtin"] = { fg = "#0033b3" },
                ["@function.builtin"] = { fg = "#215062" },
                ["@variable.builtin.rust"] = { fg = "#000000", style = "italic" },
                ["@variable.builtin.lua"] = { fg = "#000000", style = "italic" },
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
                ["@spell.lua"] = { link = "Comment" },
                ["@markup.raw.block"] = { fg = "#592479" },
                ["@keyword.import"] = { fg = "#0033b3" },
                ["@keyword.storage.rust"] = { fg = "#0033b3" },
                ["@keyword.return"] = { fg = "#0033b3" },
                AerialArrayIcon = { link = "AerialArray" },
                AerialBooleanIcon = { link = "AerialBoolean" },
                AerialClassIcon = { link = "AerialClass" },
                AerialConstantIcon = { link = "AerialConstant" },
                AerialConstructorIcon = { link = "AerialConstructor" },
                AerialEnumIcon = { link = "AerialEnum" },
                AerialEnumMemberIcon = { link = "AerialEnumMember" },
                AerialEventIcon = { link = "AerialEvent" },
                AerialFieldIcon = { link = "AerialField" },
                AerialFileIcon = { link = "AerialFile" },
                AerialFunctionIcon = { link = "AerialFunction" },
                AerialInterfaceIcon = { link = "AerialInterface" },
                AerialKeyIcon = { link = "AerialKey" },
                AerialMethodIcon = { link = "AerialMethod" },
                AerialModuleIcon = { link = "AerialModule" },
                AerialNamespaceIcon = { link = "AerialNamespace" },
                AerialNullIcon = { link = "AerialNull" },
                AerialNumberIcon = { link = "AerialNumber" },
                AerialObjectIcon = { link = "AerialObject" },
                AerialOperatorIcon = { link = "AerialOperator" },
                AerialPackageIcon = { link = "AerialPackage" },
                AerialPropertyIcon = { link = "AerialProperty" },
                AerialStringIcon = { link = "AerialString" },
                AerialStructIcon = { link = "AerialStruct" },
                AerialTypeParameterIcon = { link = "AerialTypeParameter" },
                AerialVariableIcon = { link = "AerialVariable" },

                AerialArray = { link = "@lsp.type.property" },
                AerialBoolean = { link = "@boolean" },
                AerialClass = { link = "@lsp.type.class" },
                AerialConstant = { link = "@constant" },
                AerialConstructor = { link = "@constructor" },
                AerialEnum = { link = "@lsp.type.enum" },
                AerialEnumMember = { link = "@lsp.type.enumMember" },
                AerialEvent = { link = "@lsp.type.event" },
                AerialField = { link = "@lsp.type.property" },
                AerialFile = { link = "@include" },
                AerialFunction = { link = "@lsp.type.function" },
                AerialInterface = { link = "@lsp.type.interface" },
                AerialKey = { link = "@variable" },
                AerialMethod = { link = "@lsp.type.method" },
                AerialModule = { link = "@keyword" },
                AerialNamespace = { link = "@lsp.type.namespace" },
                AerialNull = { link = "@variable" },
                AerialNumber = { link = "@number" },
                AerialObject = { link = "@lsp.type.property" },
                AerialOperator = { link = "@operator" },
                AerialPackage = { link = "@include" },
                AerialProperty = { link = "@lsp.type.property" },
                AerialString = { link = "@string" },
                AerialStruct = { link = "@lsp.type.struct" },
                AerialTypeParameter = { link = "@lsp.type.typeParameter" },
                AerialVariable = { link = "@variable" },
            },
        }
        require("nightfox").setup({
            options = options,
            palettes = palettes,
            specs = specs,
            groups = groups,
        })

        if vim.g.neovide then
            vim.defer_fn(function()
                vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#e8e7e0" })
            end, 100)
        end
        _G.curosr_hl = api.nvim_get_hl_by_name("Cursor", true)
    end,
}
