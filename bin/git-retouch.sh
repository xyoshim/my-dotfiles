#!/bin/sh

for file in $(git ls-files); do
  timestamp=$(git log -1 --date=format-local:"%Y%m%d%H%M.%S" --pretty=format:"%ad" "${file}")
  echo touch -t "${timestamp}" "${file}"
  touch -t "${timestamp}" "${file}"
done
