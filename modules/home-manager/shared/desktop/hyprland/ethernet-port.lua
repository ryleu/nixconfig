-- ethernet-port host monitor overrides
hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "auto",
    scale = 1.5,
    bitdepth = 10,
    cm = "dcip3",
    vrr = 1,
})
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

hl.env("GDK_SCALE", "2")
hl.env("QT_SCREEN_SCALE_FACTORS", "XWAYLAND0=2;XWAYLAND1=2;XWAYLAND2=2;XWAYLAND3=2")
hl.env("_JAVA_OPTIONS", "-Dsun.java2d.uiScale=2")
