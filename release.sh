#!/usr/bin/env bash

# v1.0.0, v1.5.2, etc.
versionLabel=$1

# establish branch and tag name variables
devBranch=develop
masterBranch=master
releaseBranch=release/$versionLabel

# create release branch
git checkout -b release/$versionLabel
git push origin HEAD

git checkout develop

# create release PR
gh pr create --base master --head release/$versionLabel

# merge release branch with the new version number into master
git checkout $masterBranch
git pull origin $masterBranch
git merge $releaseBranch

# create tag for new version from -master
git tag -a v$versionLabel -m "Create release tag v$versionLabel"

# push to master
git push origin master
git push origin --tags

# merge release branch with the new version number back into develop
git checkout $devBranch
git merge $releaseBranch

#push develop branch
git push origin develop

# remove release branch
git branch -D $releaseBranch

# create release
gh release create -t v$versionLabel -F CHANGELOG.md
