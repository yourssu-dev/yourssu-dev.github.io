#!/bin/bash

echo -e "\033[0;32m깃허브로 디플로잉 중 '3'...\033[0m"

cd public

if [ -n "$GITHUB_TOKEN" ]
then
  touch ~/.git-credentials
  chmod 0600 ~/.git-credentials
  echo $GITHUB_TOKEN > ~/.git-credentials

  git config credential.helper store
  git config user.email "yourssu.dev@gmail.com"
  git config user.name "유어슈 쓰니"
fi

git add .
git commit -m "글 갱신.."
ls
# git push --force origin HEAD:master
