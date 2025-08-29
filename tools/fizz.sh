#!/usr/bin/env bash
set -e

# @describe Classic FizzBuzz implementation - prints numbers 1 to max, replacing multiples of 3 with 'Fizz', multiples of 5 with 'Buzz', and multiples of both with 'FizzBuzz'
# @option --max=15

# @env LLM_OUTPUT=/dev/stdout The output path

main() {
  local max=${argc_max}

  for ((i = 1; i <= max; i++)); do
    if ((i % 15 == 0)); then
      echo "FizzBuzz" >>"$LLM_OUTPUT"
    elif ((i % 3 == 0)); then
      echo "Fizz" >>"$LLM_OUTPUT"
    elif ((i % 5 == 0)); then
      echo "Buzz" >>"$LLM_OUTPUT"
    else
      echo "$i" >>"$LLM_OUTPUT"
    fi
  done
}

eval "$(argc --argc-eval "$0" "$@")"
