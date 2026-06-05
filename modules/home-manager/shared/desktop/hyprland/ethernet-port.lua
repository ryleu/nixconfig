-- ethernet-port host monitor overrides
hl.monitor("eDP-1", {
    mode = "preferred",
    position = "auto",
    scale = 1.5,
    bitdepth = 10,
    cm = "dcip3",
    vrr = 1,
})
hl.monitor("", { mode = "preferred", position = "auto", scale = 1 })
