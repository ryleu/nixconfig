-- @placeholder@ strings get subbed by default.nix

-- compositor settings

hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 1,
    },

    decoration = {
        rounding = 0,
        rounding_power = 0,
    },

    misc = {
        force_default_wallpaper = 1, -- no anime girl
        disable_hyprland_logo = true,
        enable_anr_dialog = false, -- no application-not-responding dialog
        middle_click_paste = false,
    },

    -- see https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    dwindle = {
        pseudotile = false,
        preserve_split = false,
        force_split = 2,
        split_width_multiplier = 1.5, -- 16:9
    },

    -- see https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    master = {
        new_status = "master",
    },

    -- https://wiki.hyprland.org/Configuring/Variables/#input
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",

        follow_mouse = 1,
        accel_profile = "adaptive",
        sensitivity = 0.2,

        touchpad = {
            natural_scroll = true,
            clickfinger_behavior = true,
            ["tap-to-click"] = true,
        },
    },

    animations = {
        enabled = true,
    },
})

-- bezier curves
-- slow animations are for unixporn, not for real people

hl.bezier("specialWorkSwitch", 0.05, 0.5, 0.1, 1)
hl.bezier("emphasizedAccel", 0.3, 0, 0.5, 0.15)
hl.bezier("emphasizedDecel", 0.05, 0.5, 0.1, 1)
hl.bezier("standard", 0.2, 0, 0, 1)

-- animations

hl.animation("layersIn", 1, 1, "emphasizedDecel", "slide")
hl.animation("layersOut", 1, 1, "emphasizedAccel", "slide")
hl.animation("fadeLayers", 1, 1, "standard")
hl.animation("windowsIn", 1, 1, "emphasizedDecel")
hl.animation("windowsOut", 1, 1, "emphasizedAccel")
hl.animation("windowsMove", 1, 1, "standard")
hl.animation("workspaces", 1, 1, "standard")
hl.animation("specialWorkspace", 0, 0, "specialWorkSwitch", "slidevert 15%")
hl.animation("fade", 1, 1, "standard")
hl.animation("fadeDim", 1, 1, "standard")
hl.animation("border", 1, 1, "standard")

-- monitor / env / windowrule

-- default monitor configuration; overridden per-host
hl.monitor("", { mode = "preferred", position = "auto", scale = 1 })

-- makes some electron apps work a bit better
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

-- see https://wiki.hyprland.org/Configuring/Window-Rules/ for more
hl.windowrule("suppressevent maximize", "class:.*")
-- fix some dragging issues with xwayland
hl.windowrule("nofocus", "class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0")

-- devices

-- evil mouse at work that moves at 1 pixel per mile
hl.device("logitech-optical-usb-mouse", { sensitivity = 1.0 })

-- gestures
-- https://wiki.hypr.land/Configuring/Gestures/

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- keybinds
-- See https://wiki.hyprland.org/Configuring/Binds/ for more

hl.bind("SUPER, RETURN", "exec, @kitty@")
hl.bind("SUPER, C", "killactive,")
hl.bind("SUPER, S", "toggleSpecialWorkspace, magic")
hl.bind("SUPER SHIFT, S", "movetoworkspace, special:magic")
hl.bind("SUPER SHIFT, ESCAPE", "exit,")
hl.bind("SUPER, E", "exec, @file_manager@")
hl.bind("SUPER, V", "togglefloating,")
hl.bind("SUPER, F", "fullscreen, 1")
hl.bind("SUPER SHIFT, F", "fullscreen, 0")
hl.bind("SUPER, ESCAPE", "exec, @hyprlock@ --immediate")
hl.bind("SUPER, T", "exec, @toggle_touchpad@")

-- move focus with mainMod + H J K L
hl.bind("SUPER, H", "movefocus, l")
hl.bind("SUPER, J", "movefocus, d")
hl.bind("SUPER, K", "movefocus, u")
hl.bind("SUPER, L", "movefocus, r")

-- scroll through existing workspaces with mainMod + scroll
hl.bind("SUPER, mouse_down", "workspace, e-1")
hl.bind("SUPER, mouse_up", "workspace, e+1")

-- app runner
hl.bind("SUPER, R", "exec, @rofi@ -show drun")
hl.bind("SUPER SHIFT, 201", "exec, @rofi@ -show drun")

-- monitor control
hl.bind("SUPER, M", "exec, [float] @kitty@ -o confirm_os_window_close=0 --name Hyprmon @hyprmon@")

-- screenshot
hl.bind("     , PRINT", "exec, @hyprshot@ -z -m output -m active --clipboard-only")
hl.bind("SHIFT, PRINT", "exec, @hyprshot@ -m region --clipboard-only")
hl.bind("CTRL , PRINT", "exec, @hyprshot@ -z -m window --clipboard-only")

-- workspaces 1-10 on SUPER+[1-0], 11-20 on SUPER+ALT+[1-0]
for n = 1, 10 do
    local key = n % 10
    hl.bind("SUPER, " .. key, "workspace, " .. n)
    hl.bind("SUPER SHIFT, " .. key, "movetoworkspacesilent, " .. n)
    hl.bind("SUPER ALT, " .. key, "workspace, " .. (n + 10))
    hl.bind("SUPER ALT SHIFT, " .. key, "movetoworkspacesilent, " .. (n + 10))
end

-- mouse binds
hl.bindm("SUPER, mouse:272", "movewindow")
hl.bindm("SUPER, mouse:273", "resizewindow")

-- multimedia (work when locked)
hl.bindl(",XF86AudioNext", "exec, @playerctl@ next")
hl.bindl(",XF86AudioPause", "exec, @playerctl@ play-pause")
hl.bindl(",XF86AudioPlay", "exec, @playerctl@ play-pause")
hl.bindl(",XF86AudioPrev", "exec, @playerctl@ previous")

hl.bindl(",XF86AudioRaiseVolume", "exec, @wpctl@ set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+")
hl.bindl(",XF86AudioLowerVolume", "exec, @wpctl@ set-volume @DEFAULT_AUDIO_SINK@ 5%-")
hl.bindl(",XF86AudioMute", "exec, @wpctl@ set-mute @DEFAULT_AUDIO_SINK@ toggle")
hl.bindl(",XF86AudioMicMute", "exec, @wpctl@ set-mute @DEFAULT_AUDIO_SOURCE@ toggle")

hl.bindl(",XF86MonBrightnessUp", "exec, @brightnessctl@ s 10%+")
hl.bindl(",XF86MonBrightnessDown", "exec, @brightnessctl@ s 10%-")

-- startup

-- apply hyprcursor theme/size on session start
hl.on("hyprland.start", function()
    hl.exec_cmd("@hyprctl@ setcursor @cursor_name@ @cursor_size@")
end)
