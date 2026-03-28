if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    atuin init fish --disable-up-arrow | source
    alias cat bat
    alias ls eza
end
set -x EMSDK_PYTHON /home/nahco314/.local/share/uv/python/cpython-3.12.5-linux-x86_64-gnu/bin/python3
set -x EMSDK_QUIET 1
source "/home/nahco314/emsdk/emsdk_env.fish"
set -e __MISE_DIFF
set -e __MISE_SESSION
~/.local/bin/mise activate fish | source
set -x EMSDK_PYTHON /home/nahco314/.local/share/uv/python/cpython-3.12.5-linux-x86_64-gnu/bin/python3

set -x PATH /usr/local/cuda/bin $PATH
set -x LD_LIBRARY_PATH /usr/local/cuda/lib64 $LD_LIBRARY_PATH

set -gx WASMTIME_HOME "$HOME/.wasmtime"

string match -r ".wasmtime" "$PATH" > /dev/null; or set -gx PATH "$WASMTIME_HOME/bin" $PATH
set -gx PATH /opt/nvidia/hpc_sdk/Linux_x86_64/24.11/compilers/bin $PATH
