local wezterm = require 'wezterm'

local config = {}
config.enable_tab_bar = false;
config.window_decorations = "NONE";
config.enable_wayland = false
config.window_close_confirmation = 'NeverPrompt'


config.keys = {

{ key = 'a', mods = 'CTRL', action = wezterm.action_callback(function(window, pane)
    local dims = pane:get_dimensions()
    local txt = pane:get_text_from_region(0, dims.scrollback_top, 0, dims.scrollback_top + dims.scrollback_rows)
    window:copy_to_clipboard(txt:match('^%s*(.-)%s*$')) -- trim leading and trailing whitespace
    end)
}
	}
	return config

	-- {
        --     key =  "a",
        --     mods = "SUPER",
        --     action = wezterm.action_callback(function(window, pane)
        --         local selected = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)
        --         window:copy_to_clipboard(selected, 'Clipboard')
        --     end)
        -- },





-- local wezterm = require 'wezterm'
-- local act = wezterm.action
-- local mux = wezterm.mux
--
--
-- --config.enable_wayland = true;
-- config.enable_tab_bar = false;
--
--
-- -- GUI startup hook: open a window and make it fullscreen
-- --wezterm.on("gui-startup", function(cmd)
--   --local tab, pane, window = mux.spawn_window(cmd or {})
--   --window:gui_window():toggle_fullscreen()
-- --end)
--
-- wezterm.on("gui-startup", function(cmd)
--   local tab, pane, window = mux.spawn_window(cmd or {})
--   window:gui_window():maximize()
-- end)
--
-- -- Unable to set or get environment variables
-- --wezterm.log_info('shell: ' .. shell("echo $PATH"))
-- -- wezterm.log_info('os: ' ..os.getenv("PATH"))
-- --wezterm.log_info(os.getenv("WEZTERM_MAXIMIZE"))
-- -- Some shell commands cannot be used, such as:
-- --wezterm.log_info('node -v: ' .. shell("node -v"))
--
--
-- --execute command:  wezterm start --config-overrides fullscreen_on_startup=true
--
-- if os.getenv("WEZTERM_MAXIMIZE") == "1" then
--   wezterm.on('gui-startup', function(cmd)
--     local tab, pane, window = mux.spawn_window(cmd or {})
--     window:gui_window():maximize()
--   end)
-- end
--
-- --config.leader = {
--   --key = 'a',
--   --mods = 'CTRL',
--   --timeout_milliseconds = 2000,
-- --}
--
-- -- Keybindings: Ctrl+W to close tab without confirmation
-- config.keys = {
-- -- {
-- --   key = 'w',
-- --    mods = 'CTRL',
-- --    action = wezterm.action.CloseCurrentTab { confirm = false },
-- --  },
--
--  { 
--         key = 'g', 
--         mods = 'CTRL', 
--         action = wezterm.action.ShowDebugOverlay 
--   },
-- {
--   key = 'v',
--   mods = 'CTRL|ALT',
--   action = wezterm.action.ActivateCopyMode,
-- }
-- }
-- --
-- -- I think I can remove this as I don't need it below.
--
-- -- Muse bindings: Right-click to copy/paste
-- config.mouse_bindings = {
--   {
--     event = { Down = { streak = 1, button = 'Right' } },
--     mods = 'NONE',
--     action = wezterm.action_callback(function(window, pane)
--       local has_selection = window:get_selection_text_for_pane(pane) ~= ""
--       if has_selection then
--         window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
--         window:perform_action(act.ClearSelection, pane)
--       else
--         window:perform_action(act.PasteFrom("Clipboard"), pane)
--       end
--     end),
--   },
-- }
--
--
-- -- Native fullscreen (MacOS)
-- --config.native_macos_fullscreen_mode = false
--
--
--
-- return config
--
--
--

