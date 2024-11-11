#!/bin/bash

# log file
echo "wrapper_linker.sh: $@" >> /tmp/wrapper_linker.log

# new args
filtered_args=()

# check args
while [[ $# -gt 0 ]]; do
  if [[ $1 == "-flavor" ]]; then
    # skip "-flavor" and its argument
    shift 2
    continue
  fi
    #note: wasm-ld: error: unknown argument: -Wl,--max-memory=1073741824
#   if [[ $1 == "-Wl,--max-memory=1073741824" ]]; then
#     # skip "-Wl,--max-memory=1073741824" because it is not supported by wasm-ld
#     shift 1
#     continue
#   fi

  # add -Wl
  # --shared-memory
  if [[ $1 == "--shared-memory" ]]; then
    filtered_args+=("-Wl,--shared-memory")
    shift
    continue
  fi

  # --max-memory=1073741824
  if [[ $1 == "--max-memory=1073741824" ]]; then
      filtered_args+=("-Wl,--max-memory=1073741824")
      shift
      continue
  fi

  # --import-memory
  if [[ $1 == "--import-memory" ]]; then
      filtered_args+=("-Wl,--import-memory")
      shift
      continue
  fi

  # --export
  if [[ $1 == "--export" ]]; then
      filtered_args+=("-Wl,--export=$2")
      shift 2
      continue
  fi

  # --stack-first
  if [[ $1 == "--stack-first" ]]; then
      filtered_args+=("-Wl,--stack-first")
      shift
      continue
  fi

  # --allow-undefined
  if [[ $1 == "--allow-undefined" ]]; then
      filtered_args+=("-Wl,--allow-undefined")
      shift
      continue
  fi

  # --no-demangle
  if [[ $1 == "--no-demangle" ]]; then
      filtered_args+=("-Wl,--no-demangle")
      shift
      continue
  fi

  # --gc-sections
  if [[ $1 == "--gc-sections" ]]; then
      filtered_args+=("-Wl,--gc-sections")
      shift
      continue
  fi

  # --export-memory
  if [[ $1 == "--export-memory" ]]; then
      filtered_args+=("-Wl,--export-memory")
      shift
      continue
  fi

  # add arg to new args
  filtered_args+=("$1")
  shift
done

# get script directory
DIR=$(cd $(dirname $0); pwd)

echo "wrapper_linker.sh: wasm-ld -lwasi-emulated-mman ${filtered_args[@]}" >> $DIR/wrapper_linker.log

# call wasm-ld with new args
# $DIR/wasi-sdk-24.0-x86_64-linux/bin/wasm-ld -lwasi-emulated-mman "${filtered_args[@]}" -v >> $DIR/wrapper_linker_output.log 2>&1
$DIR/wasi-sdk-24.0-x86_64-linux/bin/wasm32-wasi-threads-clang -lwasi-emulated-mman "${filtered_args[@]}" -v >> $DIR/wrapper_linker_output.log 2>&1

# return wasm-ld exit code
exit $?
