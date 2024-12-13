
# How to add submodule

```
git submodule add git@github.com:yananob/cloud-functions-common _cf-common
ln -s ./_cf-common/.gitignore .
cp -pv ./_cf-common/.gitattributes .
cp -pv ./_cf-common/deploy/RENAME_deploy.sh ./deploy.sh
sed -i 's/{CLOUD_FUNCTION_NAME}/XXXX/' bash ./deploy.sh
```
