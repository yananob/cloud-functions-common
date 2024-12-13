#!/bin/bash
set -eu

bash ./_cf-common/deploy/deploy_php_http.sh . {CLOUD_FUNCTION_NAME}
