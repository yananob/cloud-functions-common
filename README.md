# cf-common

Google Cloud Functions (PHP) の共通デプロイスクリプトと GitHub Actions ワークフローを集めたリポジトリです。
他のプロジェクトから git submodule として利用されることを想定しています。

## 主な機能

- **ローカルデプロイスクリプト**: PHP 関数の HTTP トリガーおよびイベント（Pub/Sub）トリガーを簡単にデプロイするための Bash スクリプトを提供します。
- **再利用可能な GitHub Actions ワークフロー**: CI/CD パイプラインを標準化するためのワークフローを提供します。
    - Workload Identity Federation による安全な GCP 認証。
    - Secret Manager との統合。
    - Cloud Storage への静的ファイルアップロード支援。
    - HTTP トリガーおよび Pub/Sub トリガーのデプロイ。
- **アーティファクト管理**: Cloud Functions のデプロイ時に作成されるアーティファクトのクリーンアップポリシーを提供します。

## ディレクトリ構成

- `deploy/`: ローカルデプロイ用のシェルスクリプト。
    - `deploy_php_http.sh`: HTTP トリガーの PHP 関数をデプロイします。
    - `deploy_php_event.sh`: Pub/Sub トリガーの PHP 関数をデプロイします。
    - `common.sh`: 各スクリプトで共通して利用される設定。
    - `RENAME_deploy.sh`: プロジェクトにコピーして使用するデプロイスクリプトのテンプレート。
- `.github/workflows/`: 再利用可能な GitHub Actions ワークフロー。
    - `deploy-cloud-functions.yaml`: 関数のデプロイ用ワークフロー。
    - `remove-cloud-functions.yaml`: 関数の削除用ワークフロー。
- `misc/`: その他ユーティリティ。
    - `artifact_cleanup_policy/`: GCS バケットのライフサイクルポリシー設定。
- `test/`: 開発およびテスト用ヘルパー。
    - `export_secrets.sh`: Google Secret Manager から秘密情報を取得し、環境変数としてエクスポートします。
    - `phpstan.neon`: PHPStan 用の共通設定ファイル。

## 使い方

### 1. プロジェクトへの追加 (Git Submodule)

プロジェクトのルートディレクトリで以下のコマンドを実行し、本リポジトリを `_cf-common` として追加します。

```bash
git submodule add https://github.com/your-org/cf-common.git _cf-common
```

### 2. ローカルからのデプロイ

1. `_cf-common/deploy/RENAME_deploy.sh` をプロジェクトのルートにコピーし、リネームします（例: `deploy.sh`）。
2. `deploy.sh` 内の関数名やデプロイタイプをプロジェクトに合わせて編集します。
3. 必要に応じて、プロジェクトルートに `.gcloudignore` や `configs/config.json` を作成します。
4. スクリプトを実行してデプロイします。

   ```bash
   bash deploy.sh
   ```

### 3. GitHub Actions での利用

プロジェクトの `.github/workflows/deploy.yml` から再利用可能なワークフローを呼び出します。

```yaml
jobs:
  deploy:
    uses: ./.github/workflows/deploy-cloud-functions.yaml@main
    with:
      function_name: 'my-function'
      project_id: 'my-gcp-project'
      region: 'us-west1'
      service_account_name: 'github-actions-sa'
      gcp_project_number: '1234567890'
      secrets_config: |
        MY_SECRET
        ANOTHER_SECRET
```

### 4. 開発用ヘルパーの利用

ローカルでのテスト時に Secret Manager の値を利用したい場合、以下のように `export_secrets.sh` を利用できます。

```bash
# SECRETS 配列に取得したいシークレット名を定義
export SECRETS=("SECRET_A" "SECRET_B")
source _cf-common/test/export_secrets.sh
```
