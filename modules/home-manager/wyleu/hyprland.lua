-- wyleu monitor + workspace assignments
-- integrated monitor
hl.monitor({ output = "eDP-1", mode = "2880x1800", position = "0x1080", scale = 1.5 })
hl.workspace_rule({ workspace = "1", monitor = "eDP-1", default = true, persistent = true })

-- horizontal monitor on top
horizontals = { "desc:Dell Inc. DELL P2722H FRL6293", "desc:Dell Inc. DELL P2722H H2L6293" }
for _, display in ipairs(horizontals) do
    hl.monitor({
        output = display,
        mode = "1920x1080",
        position = "0x0",
        scale = 1,
    })
    hl.workspace_rule({ workspace = "6", monitor = display, default = true, persistent = true })
end

-- vertical monitor on the right
verticals = { "desc:Dell Inc. DELL P2722H 6QL6293", "desc:Dell Inc. DELL P2722H 53L6293" }
for _, display in ipairs(verticals) do
    hl.monitor({
        output = display,
        mode = "1920x1080",
        position = "1920x0",
        scale = 1,
        transform = 3,
    })
    hl.workspace_rule({ workspace = "11", monitor = display, default = true, persistent = true })
end
