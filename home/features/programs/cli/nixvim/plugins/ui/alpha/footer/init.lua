local dashboard = require "alpha.themes.dashboard"

-- 2. Calculate True Startup Time
-- hrtime is in nanoseconds. Divide by 1,000,000 for milliseconds,
-- and then format it to seconds with 3 decimal places.
local end_time = vim.uv.hrtime()
local duration_ms = (end_time - vim.g.start_time) / 1000000
local s = (math.floor(duration_ms) / 1000)

-- 3. Get Neovim Version
local v = vim.version()
local version = "v" .. v.major .. "." .. v.minor .. "." .. v.patch

-- 4. Update the Footer
dashboard.section.footer.val = {
  " ",
  " Nixvim " .. version .. "    " .. s .. "s",
}

-- Force redraw
pcall(vim.cmd.AlphaRedraw)
