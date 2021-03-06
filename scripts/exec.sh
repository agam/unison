#!/usr/bin/env bash
source="$1"
if [ -z "$source" ]; then
  echo "usage: $0 <file.u>"
  exit 1
fi

binary=`mktemp`

if [ -z "$binary" ]; then
  echo "error running `mktemp` to generate a temporary file name"
  exit 1
fi

function horizontal_line {
  cols=`tput cols`
  char="="
  printf "%0.s$char" $(seq 1 $cols)
  echo
}

horizontal_line

echo "Parsing/typechecking..." &&
  stack exec bootstrap "$source" "$binary" &&
  echo "Executing..." &&
  scala \
    -cp runtime-jvm/main/target/scala-2.12/classes org.unisonweb.Bootstrap \
    "$binary"

echo "Waiting for changes to '$1'..."
