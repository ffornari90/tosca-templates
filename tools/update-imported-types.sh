#!/usr/bin/env bash

declare -a FILES

echo "Updating the tosca-types imported in the templates..."

FILES=(`git ls-files; git ls-files . --exclude-standard --others`)
LAST_TAG=`git -c 'versionsort.suffix=-' ls-remote --exit-code --refs --sort='version:refname' --tags https://baltig.infn.it/infn-cloud/tosca-types.git '*.*.*' | tail --lines=1 | cut -d'/' -f3`

for file in "${FILES[@]}"; do
  if [[ $file == *.yml || $file == *.yaml ]]; then
    echo "Updating file $file"
    python3 ./tools/bin/update-types-links.py $LAST_TAG $file
  fi
done

