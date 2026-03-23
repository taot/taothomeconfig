-- ----------
-- module
-- ----------

local module = {}

function module.setup(config)
    config.initial_cols = 140
    config.initial_rows = 30
    config.enable_scroll_bar = true
    config.colors = {
        scrollbar_thumb = "#00ffff",
    }
end

return module
