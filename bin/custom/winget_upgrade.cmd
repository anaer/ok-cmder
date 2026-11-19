@REM 应用更新并备份版本信息

chcp 65001

winget upgrade --all --include-unknown  --include-pinned

winget export -o winget-pkg.config