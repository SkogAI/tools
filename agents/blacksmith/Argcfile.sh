#!/usr/bin/env bash
set -e

# @env LLM_OUTPUT=/dev/stdout The output path

# @cmd Create a new file at the specified path with contents.
# @option --path! The path where the file should be created
# @option --contents! The contents of the file
fs_create() {
  mkdir -p "$(dirname "$argc_path")"
  printf "%s" "$argc_contents" >"$argc_path"
  echo "File created: $argc_path"
}

# @cmd Say hello to a name
# @option --name The name to greet. Defaults to 'World'.
hello_name() {
  local name=${argc_name:-World}
  echo "Hello, $name!"
}

# @cmd SkogCLI - Command line interface for SkogAI.
skogcli() {
    command skogcli "$@"
}

# @cmd Show the version of SkogCLI.
skogcli::version() {
    command skogcli version
}

# @cmd Knowledge management for SkogAI agents and their shared memories
skogcli::memory() { :; }

# @cmd Add content to memory
# @arg content! - The content to add to the memory.
skogcli::memory::add() {
    command skogcli memory add "$argc_content"
}

# @cmd List memories
# @option --limit - The maximum number of memories to list
# @option --sort-by[date|name] - The field to sort by
skogcli::memory::list() {
    command skogcli memory list --limit "$argc_limit" --sort-by "$argc_sort_by"
}

# @cmd Search memories
# @arg query! - The query to search for.
skogcli::memory::search() {
    command skogcli memory search "$argc_query"
}

# @cmd Manage SkogCLI configuration
skogcli::config() { :; }

# @cmd Get a configuration value
# @arg key! - The configuration key to get.
skogcli::config::get() {
    command skogcli config get "$argc_key"
}

# @cmd Set a configuration value
# @arg key! - The configuration key to set.
# @arg value! - The value to set.
skogcli::config::set() {
    command skogcli config set "$argc_key" "$argc_value"
}

# @cmd Script management commands
skogcli::script() { :; }

# @cmd Run a script
# @arg name! - The name of the script to run.
skogcli::script::run() {
    command skogcli script run "$argc_name"
}

# @cmd List available scripts
skogcli::script::list() {
    command skogcli script list
}

# @cmd Interact with SkogAI agents
skogcli::agent() { :; }

# @cmd Create a new agent
# @arg name! - The name of the agent to create.
skogcli::agent::create() {
    command skogcli agent create "$argc_name"
}

# @cmd List available agents
skogcli::agent::list() {
    command skogcli agent list
}

# @cmd Chat with an agent
# @arg name! - The name of the agent to chat with.
# @arg message! - The message to send.
skogcli::agent::chat() {
    command skogcli agent chat "$argc_name" "$argc_message"
}

_die() {
  echo "$*" >&2
  exit 1
}

# See more details at https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
