if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    atuin init fish --disable-up-arrow | source
    alias cat bat
    alias ls eza

    # Auto-create tmux session (skip if already inside tmux, e.g. SSH from tmux)
    if not set -q TMUX
        and not set -q SSH_CONNECTION
        tmux new-session -A -s (hostname)--(date +%H%M%S)
    end
end
set -x EMSDK_PYTHON /home/nahco314/.local/share/uv/python/cpython-3.12.5-linux-x86_64-gnu/bin/python3
set -x EMSDK_QUIET 1
source "/home/nahco314/emsdk/emsdk_env.fish"
set -e __MISE_DIFF
set -e __MISE_SESSION
~/.local/bin/mise activate fish --no-hook-env | source
if status is-interactive
    ~/.local/bin/mise hook-env -s fish | source
    function __mise_on_pwd --on-variable PWD --description 'Update mise on directory changes, including cd . reloads'
        ~/.local/bin/mise hook-env -s fish | source
    end
end
set -x EMSDK_PYTHON /home/nahco314/.local/share/uv/python/cpython-3.12.5-linux-x86_64-gnu/bin/python3

set -x PATH /usr/local/cuda/bin $PATH
set -x LD_LIBRARY_PATH /usr/local/cuda/lib64 $LD_LIBRARY_PATH

set -gx WASMTIME_HOME "$HOME/.wasmtime"

string match -r ".wasmtime" "$PATH" > /dev/null; or set -gx PATH "$WASMTIME_HOME/bin" $PATH
set -gx PATH /opt/nvidia/hpc_sdk/Linux_x86_64/24.11/compilers/bin $PATH
