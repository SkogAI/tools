# Tool Development Guide

This document is the comprehensive guide for creating custom tools in the LLM Functions framework using Bash, JavaScript, and Python.

## Overview

Tools are standalone functions that can be called by LLMs. They use specially formatted comments in source code to automatically generate function declarations. The `Argcfile.sh` script parses these comments to create the JSON schemas needed by the LLM.

**Key Concept:** Write code with comment tags → Argcfile.sh generates schemas → LLM can call your tools

## Getting Started

Before creating tools, review the critical rules in `rules.md`:
- Use argc choice functions for validation
- Use argc defaults (not bash fallbacks)
- Write data-only output to `$LLM_OUTPUT`
- Trust argc validation (don't re-validate)

See `bash-best-practices.md` for detailed patterns and examples.

## Comment Tag Reference

### `@describe`

Sets the description for the command.

> **<sup>Syntax</sup>**\
> `@describe` [_description_]

```sh
# @describe A demo CLI
```

### `@cmd`

Defines a subcommand. Use this in agent tools that contain multiple functions.

> **<sup>Syntax</sup>**\
> `@cmd` [_description_]<sup>?</sup>

```sh
# @cmd Upload a file
upload() {
  echo Run upload
}

# @cmd Download a file
download() {
  echo Run download
}
```

```
USAGE: prog <COMMAND>

COMMANDS:
  upload    Upload a file
  download  Download a file
```

> **Note:** In `tools/<tool-name>.sh`, use `@describe` with a single `main` function. In `agents/<agent-name>/tools.sh`, use `@cmd` with named functions for multiple tools.

### `@alias`

Sets aliases for the subcommand.

> **<sup>Syntax</sup>**\
> [_name_] (`,` [_name_])<sup>\*</sup>

```sh
# @cmd Run tests
# @alias t,tst
test() {
  echo Run test
}
```

```
USAGE: prog <COMMAND>

COMMANDS:
  test  Run tests [aliases: t, tst]
```

### `@arg`

Defines a positional argument.

> **<sup>Syntax</sup>**\
> `@arg` [_name_] [_modifier_]<sup>?</sup> [_param-value_]<sup>?</sup>
>   [_bind-env_]<sup>?</sup>
>   [_notation_]<sup>?</sup>
>   [_description_]<sup>?</sup>

**Examples:**

```sh
# @arg va                         optional argument
# @arg vb!                        required
# @arg vc*                        multi-values
# @arg vd+                        multi-values + required
# @arg vna <PATH>                 value notation
# @arg vda=a                      default
# @arg vdb=`_default_fn`          default from fn
# @arg vca[a|b]                   choices
# @arg vcb[=a|b]                  choices + default
# @arg vcc*[a|b]                  multi-values + choice
# @arg vcd+[a|b]                  required + multi-values + choice
# @arg vfa[`_choice_fn`]          choice from fn
# @arg vfb[?`_choice_fn`]         choice from fn + no validation
# @arg vfc*[`_choice_fn`]         multi-values + choice from fn
# @arg vfd*,[`_choice_fn`]        multi-values + choice from fn + comma-separated list
# @arg vxa~                       capture all remaining args
# @arg vea $$                     bind-env
# @arg veb $BE <PATH>             bind-named-env
```

### `@option`

Defines an option argument.

> **<sup>Syntax</sup>**\
> `@option` [_short_]<sup>?</sup> [_long_] [_modifier_]<sup>?</sup> [_param-value_]<sup>?</sup>
>   [_bind-env_]<sup>?</sup>
>   [_notations_]<sup>?</sup>
>   [_description_]<sup>?</sup>

**Examples:**

```sh
# @option    --oa                   optional
# @option -b --ob                   short + long
# @option -c                        short only
# @option    --oc!                  required
# @option    --od*                  multi-occurs
# @option    --oe+                  required + multi-occurs
# @option    --of*,                 multi-occurs + comma-separated list
# @option    --ona <PATH>           value notation
# @option    --onb <FILE> <FILE>    two-args value notations
# @option    --onc <CMD> <FILE+>    unlimited-args value notations
# @option    --oda=a                default
# @option    --odb=`_default_fn`    default from fn
# @option    --oca[a|b]             choice
# @option    --ocb[=a|b]            choice + default
# @option    --occ*[a|b]            multi-occurs + choice
# @option    --ocd+[a|b]            required + multi-occurs + choice
# @option    --ofa[`_choice_fn`]    choice from fn
# @option    --ofb[?`_choice_fn`]   choice from fn + no validation
# @option    --ofc*[`_choice_fn`]   multi-occurs + choice from fn
# @option    --ofd*,[`_choice_fn`]  multi-occurs + choice from fn + comma-separated list
# @option    --oxa~                 capture all remaining args
# @option    --oea $$               bind-env
# @option    --oeb $BE <PATH>       bind-named-env
```

### `@flag`

Defines a flag argument. Flags are boolean options that do not accept values.

> **<sup>Syntax</sup>**\
> `@flag` [_short_]<sup>?</sup> [_long_]`*`<sup>?</sup>
>   [_bind-env_]<sup>?</sup>
>   [_description_]<sup>?</sup>

**Examples:**

```sh
# @flag     --fa                   boolean flag
# @flag  -b --fb                   short + long
# @flag  -c                        short only
# @flag     --fd*                  multi-occurs
# @flag     --ea $$                bind-env
# @flag     --eb $BE               bind-named-env
```

### `@env`

Defines an environment variable.

> **<sup>Syntax</sup>**\
> `@env` [_NAME_]`!`<sup>?</sup>[_param-value_]<sup>?</sup>
>   [_notation_]<sup>?</sup>
>   [_description_]<sup>?</sup>

**Examples:**

```sh
# @env EA                          optional
# @env EB!                         required
# @env EC=true                     default
# @env EDA[dev|prod]               choices
# @env EDB[=dev|prod]              choices + default
# @env LLM_OUTPUT=/dev/stdout      The output path
```

### `@meta`

Adds metadata to the tool.

> **<sup>Syntax</sup>**\
> `@meta` [_name_] [_value_]<sup>?</sup>

| syntax                           | scope  | description                                                          |
| :------------------------------- | ------ | :------------------------------------------------------------------- |
| `@meta version <value>`          | any    | Set the version for the command.                                     |
| `@meta dotenv [<path>]`          | root   | Load a dotenv file from a custom path, if present.                   |
| `@meta default-subcommand`       | subcmd | Set the current subcommand as the default.                           |
| `@meta require-tools <tool>,...` | any    | Require certain tools to be available on the system.                 |
| `@meta man-section <1-8>`        | root   | Override the section for the man page, defaulting to 1.              |
| `@meta inherit-flag-options`     | root   | Subcommands will inherit the flags/options from their parent.        |
| `@meta combine-shorts`           | root   | Short flags/options can be combined, e.g. `prog -xf => prog -x -f `. |
| `@meta symbol <param>`           | any    | Define a symbolic parameter, e.g. `+toolchain`, `@argument-file`.    |

**Examples:**

```sh
# @meta version 1.0.0
# @meta dotenv
# @meta dotenv .env.local
# @meta require-tools git,yq
# @meta man-section 8
# @meta symbol +toolchain[`_choice_fn`]
```

## Language-Specific Examples

### Bash

Complete example demonstrating all parameter types:

```sh
#!/usr/bin/env bash
set -e

# @describe Demonstrate how to create a tool using Bash and how to use comment tags.
# @option --string!                  Define a required string property
# @option --string-enum![foo|bar]    Define a required string property with enum
# @option --string-optional          Define a optional string property
# @flag --boolean                    Define a boolean property
# @option --integer! <INT>           Define a required integer property
# @option --number! <NUM>            Define a required number property
# @option --array+ <VALUE>           Define a required string array property
# @option --array-optional*          Define a optional string array property

# @env LLM_OUTPUT=/dev/stdout The output path

main() {
    # Access parameters via $argc_<name> variables
    echo "string: $argc_string" >> "$LLM_OUTPUT"
    echo "boolean: $argc_boolean" >> "$LLM_OUTPUT"
    echo "array: ${argc_array[@]}" >> "$LLM_OUTPUT"
}

eval "$(argc --argc-eval "$0" "$@")"
```

**Key points for Bash:**
- Use `# @describe` for single-function tools
- Use `# @cmd` for multi-function agent tools
- Parameters accessed as `$argc_<name>` (kebab-case → snake_case)
- Always write output to `$LLM_OUTPUT`
- Use `eval "$(argc --argc-eval "$0" "$@")"` at end

See `bash-best-practices.md` for detailed patterns.

### JavaScript

Use JSDoc-style comments to define parameters:

```js
/**
 * Demonstrate how to create a tool using JavaScript and how to use comments.
 *
 * @typedef {Object} Args
 * @property {string} string - Define a required string property
 * @property {"foo"|"bar"} string_enum - Define a required string property with enum
 * @property {string} [string_optional] - Define an optional string property
 * @property {boolean} boolean - Define a required boolean property
 * @property {number} integer - Define a required integer property
 * @property {number} number - Define a required number property
 * @property {string[]} array - Define a required string array property
 * @property {string[]} [array_optional] - Define an optional string array property
 */

/**
 * @param {Args} args
 */
export default function main(args) {
    console.log("string:", args.string);
    console.log("boolean:", args.boolean);
    console.log("array:", args.array);
}
```

**Key points for JavaScript:**
- `@typedef {Object} Args` defines argument object
- `@property {type} name description` for each parameter
- `[name]` indicates optional parameter
- `{type1|type2}` for enum types
- Function receives args as object

### Python

Python tools use similar JSDoc-style docstrings (refer to framework documentation for complete Python examples).

## Agent Tools

Agents can have their own toolset scripts under `agents/<agent-name>/tools.{sh,js,py}` containing multiple tool functions.

**Example: Git agent tools**

```sh
# @cmd Shows the working tree status
git_status() {
    git status >> "$LLM_OUTPUT"
}

# @cmd Shows differences between branches or commits
# @option --target!   Target branch or commit to compare
git_diff() {
    git diff "$argc_target" >> "$LLM_OUTPUT"
}

eval "$(argc --argc-eval "$0" "$@")"
```

**Difference from standalone tools:**
- Use `@cmd` instead of `@describe` (multiple functions)
- Each function is a separate tool
- All functions in same file share common setup

See `agent.md` for complete agent structure documentation.

## Quick Tool Creation

### Using argc

`Argcfile.sh` provides `create@tool` to quickly create tool scripts:

```sh
argc create@tool _test.sh foo bar! baz+ qux*
```

**Arguments:**
- `_test.sh`: Tool script name (extensions: `.sh`, `.js`, or `.py`)
- `foo bar! baz+ qux*`: Parameter definitions

**Suffixes:**
- `!`: Required property
- `*`: Array property (optional)
- `+`: Required array property
- No suffix: Optional property

### Using aichat

AI can automatically create tool scripts from descriptions:

**Create a standalone tool:**

```sh
aichat -f docs/tool-development-guide.md <<-'EOF'
create tools/get_youtube_transcript.py

description: Extract transcripts from YouTube videos
parameters:
   url (required): YouTube video URL or video ID
   lang (default: "en"): Language code for transcript (e.g., "ko", "en")
EOF
```

**Create an agent with tools:**

```sh
aichat -f docs/agent.md -f docs/tool-development-guide.md <<-'EOF'

create a spotify agent

index.yaml:
    name: spotify
    description: An AI agent that works with Spotify

tools.py:
  search: Search for tracks, albums, artists, or playlists on Spotify
    query (required): Query term
    qtype (default: "track"): Type of items to search for
    limit (default: 10): Maximum number of items to return
  get_info: Get detailed information about a Spotify item
    item_id (required): ID of the item to get information about
    qtype (default: "track"): Type of item: 'track', 'album', 'artist', or 'playlist'
EOF
```

## Syntax Reference (Appendix)

This section provides detailed definitions of syntax elements referenced in comment tags.

### short

A single character abbreviation for a flag/option.

> **<sup>Syntax</sup>**\
> &nbsp;&nbsp; -[_short-char_] \
> | +[_short-char_]

### long

A descriptive name for a flag/option.

> **<sup>Syntax</sup>**\
> &nbsp; -- [_long-name_] \
> | -[_long-name_] \
> | +[_long-name_]

### modifier

Symbols used to modify param behavior:

> **<sup>Syntax</sup>**\
> &nbsp; `!` \
> | `*` [_separated-char_]<sup>?</sup> \
> | `+` [_separated-char_]<sup>?</sup>

- `!`: The option is required and must be provided.
- `*`: multi-occurs for @option; multi-values for @arg;
- `+`: The option is required and can be used multiple times.

### param-value

Ways to specify values for params:

> **<sup>Syntax</sup>**\
> &nbsp; =[_value_] \
> | =\`[_fn-name_]\` \
> | [[_choices_]] \
> | [=[_choices_]] \
> | [\`[_fn-name_]\`] \
> | [?\`[_fn-name_]\`]

### choices

Define a set of acceptable values for a param:

> **<sup>Syntax</sup>**\
> [_value_] (`|` [_value_])<sup>\*</sup>

### notations

Placeholders in help messages and usage instructions:

> **<sup>Syntax</sup>**\
> ([_notation_] )<sup>\*</sup>  [_notation-last_]

### notation

> **<sup>Syntax</sup>**\
> `<` [_value_]` >`

- `FILE`/`PATH`: complete files
- `DIR`: complete directories

### notation-last

> **<sup>Syntax</sup>**\
> `<` [_value_] [_notation-modifier_]<sup>?</sup> `>`

### notation-modifier

Symbols used within the last notation to specify value requirements:

> **<sup>Syntax</sup>**\
> &nbsp; `*` \
> | `+` \
> | `?`

- `*`: Zero or more values are allowed.
- `+`: One or more values are allowed.
- `?`: Zero or one value is allowed.

### short-char

Valid characters for short flags/options:

A-Z a-z 0-9 `!` `#` `$` `%` `*` `+` `,` `.` `/` `:` `=` `?` `@` `[` `]` `^` `_` `{` `}` `~`

### separated-char

Valid separator characters for multi-value parameters:

`,` `:` `@` `|` `/`

### bind-env

Link environment variables to params:

- `$$`: Automatically use the param's name for the environment variable.
- `$`[_NAME_]: Use a specific environment variable name.

### description

Plain text for documentation and usage information:

```sh
# @describe Can be multiline
#
# Extra lines after the comment tag that don't start with an `@`
# are treated as the long description. A line which is not a comment ends the block.
```

## See Also

- **rules.md** - Critical rules for writing tools (input validation, defaults, output, code style)
- **bash-best-practices.md** - Bash-specific patterns, examples, and common mistakes
- **environment-variables.md** - Reference for LLM_OUTPUT and other injected variables
- **agent.md** - Agent folder structure and index.yaml configuration
- **variables.md** - Argc variable system documentation
- **argcfile.md** - Using Argcfile.sh for builds and MCP
- **command-runner.md** - Using argc as a command runner
