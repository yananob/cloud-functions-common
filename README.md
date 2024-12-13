
# How to add submodule

```
git submodule add git@github.com:yananob/cloud-functions-common _cf-common
cp -pv ./_cf-common/.gitignore .
ln -s ./_cf-common/.gcloudignore .
cp -pv ./_cf-common/.gitattributes .
ln -s ./_cf-common/test/phpstan.neon .
cp -pv ./_cf-common/deploy/RENAME_deploy.sh ./deploy.sh
sed -i 's/{CLOUD_FUNCTION_NAME}/XXXX/' bash ./deploy.sh
```
