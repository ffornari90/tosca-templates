#!/usr/bin/env bash

declare -a FILES


CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`
if [ $CURRENT_BRANCH == 'master' ]; then
  echo "[Post-checkout Hook] info: Nothing to do on the master branch!"
  exit 0
fi

if [ -z "$1" ]; then 
  echo "Please provide a title for your Merge Request" 
  exit 1 
fi

declare -a TAGS

TAGS=`git -c 'versionsort.suffix=-' ls-remote --exit-code --refs --sort='version:refname' --tags https://baltig.infn.it/infn-cloud/tosca-types.git '*.*.*' | tail --lines=2 | cut -d'/' -f3`

while : ; do
    echo -e "Specify the tosca types tag to use. Choose one of the existing latest tags:\n${TAGS}"
    read -p ">" TAG < /dev/tty

    if [[ ${TAGS[*]} =~ (^|[[:space:]])"${TAG}"($|[[:space:]]) ]]; then
      break
    else
      echo -e "Error: The supplied tag is not valid\n"
    fi
done

echo "Updating the tosca-types imported in the templates..."

FILES=(`git ls-files; git ls-files . --exclude-standard --others`)

for file in "${FILES[@]}"; do
  if [[ $file == *.yml || $file == *.yaml ]]; then
    echo "Updating file $file"
    python3 ./.githooks/bin/update-types-links.py "${TAG}" $file
    if [ ! $? -eq 0 ]; then echo Error: merge request creation failed; exit 1; fi
  fi
done

# commit changes, if any
git commit -m"Set tosca-types branch ${TAG}" -a

if [ ! $? -eq 0 ]; then
  echo "Nothing to commit. Empty commit will be added to proceed with MR..."
  git commit --allow-empty -m"Prepare Merge Request"
fi

git push -o merge_request.create -o merge_request.target=master -o merge_request.remove_source_branch -o merge_request.title="$1"

exit 0

