local hostname = io.popen("uname -n"):read("*l")

------------------
---- MONITORS ----
------------------

local monitor_configurations = {
  ["pc"] = {
    { output = "DP-1", mode = "2560x1440@165", position = "0x0",    scale = 1, vrr = 1 },
    { output = "DP-3", mode = "2560x1440@165", position = "2560x0", scale = 1, vrr = 1 },
  },
  ["x260"] = {
    { output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = 1, vrr = 0 },
  }
}

local current_monitors = monitor_configurations[hostname] or {
  { output = "", mode = "preferred", position = "auto", scale = 1 }
}

for _, mon in ipairs(current_monitors) do
  hl.monitor(mon)
end

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "kitty"
local file_manager = terminal .. " --class yazi -e 'yazi'"
local tofi_launcher = "tofi-drun --drun-launch=true"
local tofi_power_menu = "$HOME/.config/scripts/tofi_power_menu.sh"
local tofi_system_menu = "$HOME/.config/scripts/tofi_system_menu.sh"
local clipboard = terminal .. " --class clipse -e 'clipse'"
local grab_screenshot = "grim -g \"$(slurp)\" - | swappy -f - -o - | wl-copy"
local event_handler = "$HOME/.config/scripts/event_handler.sh"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
  -- Hyprland utils and key desktop elements
  hl.exec_cmd("hyprsunset")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("waybar")
  hl.exec_cmd("dunst")
  hl.exec_cmd("swaybg -c 221F1E")
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP") -- Screen sharing TODO: check if needed
  --hl.exec_cmd("hyprpm reload -nn") -- Hyprland plugins with error notifications on
  -- Clipboard listener
  hl.exec_cmd("clipse -listen")
  -- Apps to run on startup
  hl.exec_cmd("signal-desktop")
  hl.exec_cmd("vesktop --start-minimized")
  hl.exec_cmd("mpDris2") -- MPRIS for MPD
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

-- TODO

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
  general = {
    gaps_in          = 5,
    gaps_out         = 10,

    border_size      = 1,

    col              = {
      active_border   = "rgb(E6DBC3)",
      inactive_border = "rgb(615856)",
    },

    resize_on_border = true,

    allow_tearing    = false,

    layout           = "dwindle",
  },

  decoration = {
    rounding         = 0,
    rounding_power   = 0,

    active_opacity   = 1.0,
    inactive_opacity = 1.0,

    shadow           = {
      enabled = false,
    },

    blur             = {
      enabled = false,
    },
  },

  animations = {
    enabled = true,
  },
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.curve("easy", { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

hl.config({
  dwindle = {
    preserve_split = true, -- You probably want this
  },
})

----------------
----  MISC  ----
----------------

hl.config({
  misc = {
    force_default_wallpaper = -1,
    disable_hyprland_logo   = true,
  },
})

---------------
---- INPUT ----
---------------

hl.config({
  input = {
    kb_layout          = "pl",
    numlock_by_default = true,

    follow_mouse       = 1,

    sensitivity        = -0.5, -- -1.0 - 1.0, 0 means no modification.

    touchpad           = {
      natural_scroll = true,
    },
  },
})

hl.device({
  name        = "steelseries-steelseries-kinzu-v3-gaming-mouse",
  sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

hl.bind("SUPER + C", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + RETURN", hl.dsp.window.fullscreen({ action = "toggle" }))

hl.bind("SUPER + L", hl.dsp.exec_cmd(tofi_power_menu))
hl.bind("SUPER + M", hl.dsp.exec_cmd(tofi_system_menu))

hl.bind("SUPER + Q", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + E", hl.dsp.exec_cmd(file_manager))
hl.bind("SUPER + R", hl.dsp.exec_cmd(tofi_launcher))
hl.bind("SUPER + V", hl.dsp.exec_cmd(clipboard))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd(grab_screenshot))
hl.bind("SUPER + N", hl.dsp.exec_cmd("dunstctl history-pop"))

-- Move focus with SUPER + arrow keys
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))

-- Resize current window
hl.bind("SUPER + S", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
  hl.bind("left", hl.dsp.window.resize({ x = -15, y = 0, relative = true }), { repeating = true })
  hl.bind("right", hl.dsp.window.resize({ x = 15, y = 0, relative = true }), { repeating = true })
  hl.bind("up", hl.dsp.window.resize({ x = 0, y = 15, relative = true }), { repeating = true })
  hl.bind("down", hl.dsp.window.resize({ x = 0, y = -15, relative = true }), { repeating = true })
  hl.bind("SHIFT + left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
  hl.bind("SHIFT + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
  hl.bind("SHIFT + up", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
  hl.bind("SHIFT + down", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })

  hl.bind("escape", hl.dsp.submap("reset"))
  hl.bind("Return", hl.dsp.submap("reset"))
  hl.bind("Space", hl.dsp.submap("reset"))
  hl.bind("SUPER + S", hl.dsp.submap("reset"))
end)

-- Switch focused monitor
--hl.bind("SUPER + 1", hl.dsp.focus({ monitor = "DP-1" }))
--hl.bind("SUPER + 2", hl.dsp.focus({ monitor = "DP-3" }))
hl.bind("SUPER + TAB", hl.dsp.focus({ monitor = "+1" }))

-- Switch to next/prev workspace
hl.bind("SUPER + ALT + left", hl.dsp.focus({ workspace = "m-1" }))     -- with arrows
hl.bind("SUPER + ALT + right", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("SUPER + ALT + mouse_up", hl.dsp.focus({ workspace = "m-1" })) -- with scroll
hl.bind("SUPER + ALT + mouse_down", hl.dsp.focus({ workspace = "m+1" }))

-- Switch to next/prev workspace on both monitors (GNOME like)
hl.bind("SUPER + ALT + SHIFT + left", function() -- with arrows
  hl.dispatch(hl.dsp.focus({ workspace = "m-1" }))
  hl.dispatch(hl.dsp.focus({ monitor = "+1" }))
  hl.dispatch(hl.dsp.focus({ workspace = "m-1" }))
  hl.dispatch(hl.dsp.focus({ monitor = "+1" }))
end)
hl.bind("SUPER + ALT + SHIFT + right", function()
  hl.dispatch(hl.dsp.focus({ workspace = "m+1" }))
  hl.dispatch(hl.dsp.focus({ monitor = "+1" }))
  hl.dispatch(hl.dsp.focus({ workspace = "m+1" }))
  hl.dispatch(hl.dsp.focus({ monitor = "+1" }))
end)
hl.bind("SUPER + ALT + SHIFT + mouse_up", function() -- with scroll
  hl.dispatch(hl.dsp.focus({ workspace = "m-1" }))
  hl.dispatch(hl.dsp.focus({ monitor = "+1" }))
  hl.dispatch(hl.dsp.focus({ workspace = "m-1" }))
  hl.dispatch(hl.dsp.focus({ monitor = "+1" }))
end)
hl.bind("SUPER + ALT + SHIFT + mouse_down", function()
  hl.dispatch(hl.dsp.focus({ workspace = "m+1" }))
  hl.dispatch(hl.dsp.focus({ monitor = "+1" }))
  hl.dispatch(hl.dsp.focus({ workspace = "m+1" }))
  hl.dispatch(hl.dsp.focus({ monitor = "+1" }))
end)

-- Move active window to a next/prev workspace
hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ workspace = "m-1" }))     -- with arrows
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ workspace = "m+1" }))
hl.bind("SUPER + SHIFT + mouse_up", hl.dsp.window.move({ workspace = "m-1" })) -- with scroll
hl.bind("SUPER + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "m+1" }))

-- Move active window to currently active workspace on next monitor
--hl.bind("SUPER + LEFT_CTRL + left", hl.dsp.window.move(), { monitor = "+1" })

-- Move window
hl.bind("SUPER + CTRL + left", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + CTRL + right", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + CTRL + up", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + CTRL + down", hl.dsp.window.move({ direction = "down" }))

-- Move/resize windows with SUPER + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia on normal keyboard
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(event_handler .. " mic toggle"), { locked = true })          -- Mute mic with mute vol key, remove it from laptop config
hl.bind("ALT + XF86AudioMute", hl.dsp.exec_cmd(event_handler .. " volume toggle"), { locked = true }) -- Mute audio with alt + mute vol key, remove it from laptop config

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(event_handler .. " volume up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(event_handler .. " volume down"), { locked = true, repeating = true })
-- hl.bind("XF86AudioMute", hl.dsp.exec_cmd(event_handler .. " volume toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

----------------------
----- WORKSPACES -----
----------------------

hl.workspace_rule({ workspace = "1", monitor = "DP-1", persistent = true, default = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-1", persistent = true })
hl.workspace_rule({ workspace = "3", monitor = "DP-1", persistent = true })
hl.workspace_rule({ workspace = "4", monitor = "DP-1", persistent = true })

hl.workspace_rule({ workspace = "5", monitor = "DP-3", persistent = true, default = true })
hl.workspace_rule({ workspace = "6", monitor = "DP-3", persistent = true })
hl.workspace_rule({ workspace = "7", monitor = "DP-3", persistent = true })
hl.workspace_rule({ workspace = "8", monitor = "DP-3", persistent = true })

-----------------
---- WINDOWS ----
-----------------

hl.window_rule({
  -- Ignore maximize requests from all apps. You'll probably like this.
  name           = "suppress-maximize-events",
  match          = { class = ".*" },

  suppress_event = "maximize",
})

hl.window_rule({
  -- Fix some dragging issues with XWayland
  name     = "fix-xwayland-drags",
  match    = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },

  no_focus = true,
})

hl.window_rule({
  -- Calculator - open in center as floating
  name = "kde-calc",
  match = { class = "org.kde.kalk" },
  float = true,
  center = true,
  size = { 300, 415 }
})

hl.window_rule({
  -- yazi - open in center as floating
  name = "yazi",
  match = { class = "yazi" },
  float = true,
  center = true,
  size = { 1000, 600 }
})

hl.window_rule({
  -- Clipse - open in center as floating
  name = "clipse",
  match = { class = "clipse" },
  float = true,
  center = true,
  size = { 622, 652 }
})
