JUST:="just --justfile="+justfile()

@_all:
    {{ JUST }} --list

@clean:
  rm -rf {{ justfile_directory() }}/.nvim

@proba-lazy-remote:
  XDG_CONFIG_HOME={{ justfile_directory() }}/.nvim/config \
  XDG_DATA_HOME={{ justfile_directory() }}/.nvim/data \
  nvim -u {{ justfile_directory() }}/tests/init_lazy_remote.lua

@proba-lazy-local:
  XDG_CONFIG_HOME={{ justfile_directory() }}/.nvim/config \
  XDG_DATA_HOME={{ justfile_directory() }}/.nvim/data \
  nvim -u {{ justfile_directory() }}/tests/init_lazy_local.lua
