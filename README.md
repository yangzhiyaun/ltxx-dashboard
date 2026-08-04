# 龙腾鑫享产品管理平台 · 使用与维护说明

## 🌐 访问地址（团队共享）

- **网页地址**：https://yangzhiyaun.github.io/ltxx-dashboard/ （部署后生效）
- **数据存储**：GitHub 私有 Gist（仅通过页面内置令牌访问）
- 所有打开页面的人**都能查看和修改**同一份数据，修改后约 2 秒自动同步到云端，每 45 秒自动拉取同事的最新修改；也可随时点右上角「☁️ 同步」手动强制同步。

## 🔐 云同步架构

| 项目 | 值 |
|---|---|
| 托管 | GitHub Pages（仓库 `yangzhiyaun/ltxx-dashboard`，公开） |
| 数据 | 私有 Gist `33369ccd0e4cb84fef6da08577fa1f19`（文件 `ltxx_data.json`） |
| 令牌 | 页面内置（`index.html` 中 `CLOUD.token`），含 gist + repo scope |

**⚠️ 安全须知（重要）**
- 令牌随页面分发：任何拿到页面链接的人都能读写共享数据——这是"所有人可修改"的设计，请把链接视为**内部资料**，不要公开发布
- 令牌同时含 repo 权限（用于部署），如担心泄露可在 GitHub 设置中重新生成令牌并替换页面中的 `CLOUD.token`
- 建议每 90 天更换一次令牌：GitHub → Settings → Developer settings → Personal access tokens → 生成新令牌（勾选 repo + gist）→ 替换 `index.html` 中 token → 重新部署
- 重要数据请定期用页面「📤 导出」备份 JSON

## 🔄 同步机制

- 本地保存（浏览器 localStorage）+ 云端（GitHub Gist）双写
- **时间戳较新者胜**：云端 `meta.updatedAt` 与本地时间戳比较，自动双向协调
- 修改后 2 秒去抖推送；每 45 秒轮询拉取；切回标签页立即刷新
- 完全离线也可用：云端不可用时页面照常工作，恢复后自动补同步
- 多人同时编辑同一产品时按"最后修改者胜"，建议避免同时改同一产品

## 🛠 维护操作（管理员）

### 修改/部署页面
```bash
git clone https://github.com/yangzhiyaun/ltxx-dashboard.git
# 编辑 index.html 后：
git add -A && git commit -m "更新" && git push
# 或直接通过 GitHub 网页端编辑 index.html → Commit changes
```
部署由 GitHub Actions 自动完成（push 到 main 即生效，约 1 分钟）。

### 更换令牌
1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic) → Generate new token
2. 勾选 `repo` 和 `gist`，生成后复制
3. 在 GitHub 网页端编辑 `index.html`，把 `CLOUD.token` 的值替换为新令牌 → Commit changes
4. 约 1 分钟后新版本生效

### 查看/备份云端数据
```bash
curl -H "Authorization: Bearer <令牌>" https://api.github.com/gists/33369ccd0e4cb84fef6da08577fa1f19
```
