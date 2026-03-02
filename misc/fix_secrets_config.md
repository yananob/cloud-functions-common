# Cloud Functions シークレット設定の修正について

## 問題の概要
GitHub Actions の `secrets_config` 入力に複数行でシークレット名を指定した際、環境によっては以下の要素が混入し、Google Cloud へのデプロイ時にシークレットが正しく認識されない問題が発生していました。

1.  **改行コード (CRLF)**: Windows 環境などで編集された際に、行末に `\r` (キャリッジリターン) が残る。
2.  **不要な空白**: シークレット名の前後にスペースが含まれる。

これらが混入すると、GCP 側のリソースパスが `.../secrets/SECRET_NAME\r/versions/latest` のようになり、不正なパスとして扱われます。

## 修正内容
`.github/workflows/deploy-cloud-functions.yaml` の `prep_secrets` ステップにおいて、パース処理を以下のように改善しました。

- **`tr -d '\r'`**: 入力文字列から全てのキャリッジリターンを削除。
- **`xargs`**: 各シークレット名の前後の空白をトリミング。
- **堅牢なループ処理**: `while read` を使用し、空行をスキップしながら正確なカンマ区切りリストを構築。

## 修正後の動作
呼び出し側で以下のように指定しても、正しくパースされます。

```yaml
secrets_config: |
  FIREBASE_SERVICE_ACCOUNT

  ANOTHER_SECRET
```

空行や末尾のスペースは自動的に除去され、以下の形式でデプロイアクションに渡されます：
`FIREBASE_SERVICE_ACCOUNT=projects/.../latest,ANOTHER_SECRET=projects/.../latest`
