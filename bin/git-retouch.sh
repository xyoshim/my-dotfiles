#!/bin/sh

dateformat="ad"
dry_run=no
while [ $# != 0 ]; do
  option="$1"
  shift

  case $option in
    -h | --help)
      echo "$0 [-a|-c]"
      echo ""
      echo "  -a : author date (default)"
      echo "  -c : committer date"
      exit 0;;
    -a)
      dateformat="ad";;
    -c)
      dateformat="cd";;
    -n | --dry-run)
      dry_run=yes;;
    *)
      echo "$0 unsupported option '${option}'"
      exit 1;;
  esac
done

for file in $(git ls-files); do
  timestamp=$(git log -1 --date=format-local:"%Y%m%d%H%M.%S" --pretty=format:"%${dateformat}" "${file}")
  if [ "${dry_run}" = "no" ]; then
    echo touch -t "${timestamp}" "${file}"
    touch -t "${timestamp}" "${file}"
  else
    echo Would touch -t "${timestamp}" "${file}"
  fi
done
