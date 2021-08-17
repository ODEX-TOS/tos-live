#!/bin/bash

#These settings are needed for zsh completion

#plugins used by ZSH
plugins=(
  docker
  docker-compose
  colored-man-pages # colorize your man pages
  zsh-autosuggestions # give autocompletion example when typing a command
  zsh-autocomplete # smart filling of current command
  #fast-syntax-highlighting #colorize the command you enter in your terminal (This requires networking for some reason)
  dirpersist # automatically save the last 20 dirs into pushd/popd
  zsh-completions
)
