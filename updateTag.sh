#!/bin/sh

# 用法： eg: ./updateTag v1.0.0
if [[ $# < 1 ]]; then
    echo "Usage: UpdateJS.sh <tagname>"
    exit 1
fi

# 拿到当前仓库名
repository=`git remote get-url origin`

echo "local repository is $repository"

# 如果远程有这个分支，则删掉
if [[ `git ls-remote --tags $repository | grep -o refs/tags/$1` ]]; then
    echo "remote have tag $1"
    echo "delete remote tag $1..."
    git push --delete origin tag $1
else
    echo "remote don't have tag $1"
fi

# 如果本地有这个分支，则删掉
if [[ `git tag | grep -o $1` ]]; then
    #statements
    echo "local have tag $1"
    echo "delete local tag $1..."
    git tag -d $1
else
    echo "local don't have tag $1"
fi

# 同步代码
echo "sync code..."
git fetch

# 在当前本地分支创建分支
echo "from master create local tag $1..."
git tag $1
echo "create local tag $1 done"

# 分支推送到远程
echo "push local tag $1 to remote"
git push origin $1
echo "push local tag $1 done"

echo "Done"