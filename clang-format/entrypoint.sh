#!/bin/sh
set -e

cd "${GITHUB_WORKSPACE}"
wget https://raw.githubusercontent.com/Geode-solutions/actions/master/clang-format/.clang-format -O .clang-format

files=$(find . \( -name "*.h" -o -name "*.cpp" \))
clang-format-8 -style=file -i $files

if git diff --quiet; then
    git config user.email ${GITHUB_ACTOR}@users.noreply.github.com
    git config user.name ${GITHUB_ACTOR}
    git checkout `echo ${GITHUB_REF##*/*/}`
    git add --all "${GITHUB_WORKSPACE}"
    git commit -m "style: CI format update"
    git push https://BotellaA:${GH_TOKEN}@github.com/${GITHUB_REPOSITORY}
    echo ::error::Format requirement is not satisfied
    return 1
fi
