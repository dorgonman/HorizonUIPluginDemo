git checkout -f master
git pull
git submodule foreach --recursive "git checkout -f master"
git submodule foreach --recursive "git pull"