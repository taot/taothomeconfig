local wezterm = require 'wezterm'

-- -------------
-- tab name
-- -------------

local function basename(s)
    if not s or s == "" then
        return ""
    end
    return s:gsub("(.*[/\\])(.*)", "%2")
end

local function dir_from_uri(uri)
    if not uri then
        return nil
    end
    local path = uri.file_path or tostring(uri):gsub("^file://", "")
    if not path or path == "" then
        return nil
    end
    if #path > 1 then
        path = path:gsub("/$", "")
    end
    return basename(path)
end

local function get_tab_name(tab)
    local pane = tab.active_pane
    local proc = basename(pane.foreground_process_name)
    local cwd_name = dir_from_uri(pane.current_working_dir)

    local title
    if proc == "bash" then
        title = cwd_name or "bash"
    else
        title = proc ~= "" and proc or (cwd_name or "shell")
    end

    return "  " .. title .. "  "
end

-- -------------
-- key bindings
-- -------------

local function key_bindings(config)
    config.keys = config.keys or {}

    for i = 1, 8 do
        -- CTRL+ALT + number to activate that tab
        table.insert(config.keys, {
            key = tostring(i),
            mods = 'ALT',
            action = wezterm.action.ActivateTab(i - 1),
        })
    end

    table.insert(config.keys, {
        key = 'LeftArrow',
        mods = 'ALT',
        action = wezterm.action.ActivateTabRelative(-1),
    })
    table.insert(config.keys, {
        key = 'RightArrow',
        mods = 'ALT',
        action = wezterm.action.ActivateTabRelative(1),
    })
    table.insert(config.keys, {
        key = 'LeftArrow',
        mods = 'CTRL|ALT',
        action = wezterm.action.MoveTabRelative(-1),
    })
    table.insert(config.keys, {
        key = 'RightArrow',
        mods = 'CTRL|ALT',
        action = wezterm.action.MoveTabRelative(1),
    })
end

-- ----------
-- module
-- ----------

local module = {}

function module.setup(config)
    key_bindings(config)
    wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
        return get_tab_name(tab)
    end)
end

return module
