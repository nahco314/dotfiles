if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    atuin init fish --disable-up-arrow | source
end
~/.local/bin/mise activate fish | source
set -x EMSDK_PYTHON /home/nahco314/.local/share/uv/python/cpython-3.12.5-linux-x86_64-gnu/bin/python3
set -x EMSDK_QUIET 1
source "/home/nahco314/emsdk/emsdk_env.fish"
set -x EMSDK_PYTHON /home/nahco314/.local/share/uv/python/cpython-3.12.5-linux-x86_64-gnu/bin/python3

