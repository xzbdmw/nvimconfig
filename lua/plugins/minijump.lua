return {
    "echasnovski/mini.jump",
    version = false,
    config = function()
        require("mini.jump").setup(
            -- No need to copy this inside `setup()`. Will be used automatically.
            {
                -- Module mappings. Use `''` (empty string) to disable one.
                mappings = {
                    forward = "f",
                    backward = "F",
                    forward_till = "t",
                    backward_till = "T",
                    repeat_jump = "",
                },

                -- Delay values (in ms) for different functionalities. Set any of them to
                -- a very big number (like 10^7) to virtually disable.
                delay = {
                    -- Delay between jump and highlighting all possible jumps
                    highlight = 10000000,

                    -- Delay between jump and automatic stop if idle (no jump is done)
                    idle_stop = 10000000,
                },
            }
        )
    end,
}
