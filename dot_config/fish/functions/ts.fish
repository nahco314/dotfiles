function ts
    set session (tmux ls -F "#{session_name}" | fzf \
        --preview 'tmux capture-pane -pt {}' \
        --preview-window 'right:70%')
    or return
    if set -q SSH_CONNECTION
        env TERM=screen-256color tmux new-session -t $session
    else
        tmux new-session -t $session
    end
end
