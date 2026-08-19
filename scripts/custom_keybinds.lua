hl.unbind("SUPER + H")
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))

hl.unbind("SUPER + L")
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))

hl.unbind("SUPER + K")
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))

hl.unbind("SUPER + J")
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))

hl.unbind("XF86AudioRaiseVolume")
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })

hl.unbind("XF86AudioLowerVolume")
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })

hl.config({ input = { kb_options = "caps:escape" } })
