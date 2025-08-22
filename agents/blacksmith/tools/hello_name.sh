#!/usr/bin/env bash
# @option --name The name to greet. Defaults to 'World'.
hello_name() {
  local name=${argc_name:-World}
  echo "Hello, $name!"
eval "$(argc --argc-eval \"$0\" \"$@\")"