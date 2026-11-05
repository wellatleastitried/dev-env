hl.unbind("SUPER + H")
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))

hl.unbind("SUPER + L")
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))

hl.unbind("SUPER + K")
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))

hl.unbind("SUPER + J")
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))

hl.unbind("SUPER + E")
hl.bind("SUPER + E", hl.dsp.exec_cmd("/home/wellatleastitried/.config/omarchy/plugins/omamail/scripts/mailto.sh"))

hl.unbind("XF86AudioRaiseVolume")
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })

hl.unbind("XF86AudioLowerVolume")
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })

hl.config({ input = { kb_options = "caps:escape" } })

hl.on("hyprland.start", function()
    hl.exec_cmd([[gpu-screen-recorder -w DP-4 -f 60 -a default_output -c mp4 -r 30 -restart-replay-on-save yes -o "$HOME/Videos/Clips"]])
end)
hl.unbind("SUPER + SHIFT + MINUS")
hl.bind("SUPER + SHIFT + MINUS", hl.dsp.exec_cmd("killall -SIGUSR1 gpu-screen-recorder && notify-send 'Clip Saved'"))
