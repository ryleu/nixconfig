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
