if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    atuin init fish --disable-up-arrow | source
end
~/.local/bin/mise activate fish | source
