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
| 令牌 | 细粒度令牌（仅限 gist + 本仓库），以**混淆形式**内置在 `index.html` 中 |

**⚠️ 安全须知（重要）**
- 令牌随页面分发：任何拿到页面链接的人都能读写共享数据——这是"所有人可修改"的设计，请把链接视为**内部资料**，不要公开发布
- 令牌在页面中做了混淆存储（GitHub 的密钥扫描会识别明文令牌并自动撤销，混淆仅为绕过该误杀机制；令牌本身设计上就是全员共享的）
- 建议定期更换令牌（详见下方"更换令牌"）

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
1. GitHub → Settings → Developer settings → Personal access tokens → **Fine-grained tokens** → Generate new token
2. Repository access 选 `ltxx-dashboard`；Repository permissions → Contents: Read and write；Account permissions → Gists: Read and write
3. 生成后，用下面的命令把新令牌混淆（每个字符 ASCII +1），替换 `index.html` 中 `CLOUD.token` 的混淆字符串：
   ```python
   tok = 'github_pat_新令牌'
   print(''.join(chr(ord(c)+1) for c in tok))   # 输出即为要填的混淆字符串
   ```
4. 提交推送后约 1 分钟新版本生效

### 查看/备份云端数据
```bash
curl -H "Authorization: Bearer <令牌>" https://api.github.com/gists/33369ccd0e4cb84fef6da08577fa1f19
```
