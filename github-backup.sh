#!/bin/sh -u
# This quick script lets you clone/pull all your GitHub repositories folders in a local directory.
# It doesn't support deleting at this stage.
# The script returns fail if any repo's failing, *but* will try to process them all regardless.
# Script failure enables successful/failure notification in a CRON context
#
# First, indeed, you have to $ gh auth login
# Then don't forget to change your DIR/USER variables
#
# DOCKERIZED SETUP
# I use it within a Dockerized Cronicle. https://github.com/bluet/docker-cronicle-docker
# With the following setup after creating the docker container of name "cronicle"
# $ sudo docker container exec -it cronicle apk add --no-cache github-cli
# $ sudo docker container exec -it cronicle gh auth login

DIR=/gits
USER=licryle

mkdir -p "$DIR" || exit 1
cd "$DIR" || exit 1
echo "Starting in folder $(pwd) $(ls -al $DIR)"

echo "Starting to list Repos for user $USER"
repos=$(gh repo list $USER --limit 1000) || exit 1
mkdir -p "$DIR/$USER"

# Track if any errors occurred
errors_occurred=0
while read -r repo _; do
  cd $DIR
  echo "Starting to pull $repo"

  if [ -d "$repo" ] && git -C "$repo" rev-parse --is-bare-repository >/dev/null 2>&1; then
    echo "Repo $repo already exists, just pulling updates..."
    cd "$repo"
    if ! git remote update --prune; then
      echo "❌ Failed to update $repo"
      errors_occurred=1
      continue
    fi
    echo "✅ Successfully updated $repo"
  else
	echo "Creating folder $repo"
	mkdir -p "$repo"

    echo "Cloning $repo using git clone --mirror..."
    cd "$repo"
    if ! git clone --mirror "https://github.com/$repo.git" "$repo"; then
      echo "❌ Failed to clone $repo"
      errors_occurred=1
      continue
    fi
    echo "✅ Successfully mirrored $repo"
  fi
done < <(echo $repos)

echo "errors_occurred = $errors_occurred"

# Exit with a non-zero status if any error occurred
if [ $errors_occurred -ne 0 ]; then
  echo "Some repositories failed, exiting with error status."
  exit 1
fi
