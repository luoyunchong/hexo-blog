

hexo clean
hexo g

cd ./public

git init
git config user.name "luoyunchong"
git config user.email "luoyunchong@foxmail.com" 
git add .
git commit -m "Travis CI Auto Builder"
git push --force --quiet "https://github.com/luoyunchong/luoyunchong.github.io" master:master

cd ..