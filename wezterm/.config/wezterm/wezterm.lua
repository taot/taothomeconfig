local wezterm = require 'wezterm'

local config = {}

require("appearance").setup(config)
require("tabs").setup(config)

return config
