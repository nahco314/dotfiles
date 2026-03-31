function ts
    set session (tmux ls -F "#{session_name}" | fzf \
        --preview 'tmux capture-pane -pt {}' \
        --preview-window 'right:70%')
    and tmux new-session -t $session
end
