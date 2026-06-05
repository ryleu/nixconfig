-- wyleu monitor + workspace assignments
hl.monitor({ output = "eDP-1", mode = "2880x1800", position = "0x1080", scale = 1.5 })
hl.monitor({
    output = "desc:Dell Inc. DELL P2722H FRL6293",
    mode = "1920x1080",
    position = "0x0",
    scale = 1,
})
hl.monitor({
    output = "desc:Dell Inc. DELL P2722H 6QL6293",
    mode = "1920x1080",
    position = "1920x0",
    scale = 1,
    transform = 3,
})

hl.workspace_rule({ workspace = "1", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "6", monitor = "desc:Dell Inc. DELL P2722H FRL6293" })
hl.workspace_rule({ workspace = "11", monitor = "desc:Dell Inc. DELL P2722H 6QL6293" })
