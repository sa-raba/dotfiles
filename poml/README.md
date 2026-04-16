# POML

## 環境構築

docker内で作業

```bash
# mkdir
mkdir -p ~/poml-project/src

# npm
cd ~/poml-project
npm init -y
npm install pomljs
npm install -D typescript tsx @types/node

npm pkg set type=module
npm pkg set scripts.dev="tsx src/index.ts"
cat package.json

# 実行ファイルの同期、tsを更新したら同期する
cp -f /app/poml/src/index.ts ~/poml-project/src/index.ts
```

以下を設定しておくと`poml`で使える

```bash
echo 'source /app/poml/init.sh' >> ~/.bashrc
source ~/.bashrc
```
