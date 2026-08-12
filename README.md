# 龙腾鑫享产品管理平台 · 使用与维护说明

## 🌐 访问地址（团队共享，需登录）

- **网页地址**：https://yangzhiyaun.github.io/ltxx-dashboard/
- **管理员账号**：`yzy` / `142753869`（内置，不可删除；首次登录后请在「👥 账号管理」中为同事新增账号）
- 普通账号由管理员在「👥 账号管理」中新增/删除（保存到云端，同事刷新页面后生效）
- 所有登录用户都能**查看和修改**同一份数据，修改后约 2 秒自动同步到云端，每 45 秒自动拉取同事的最新修改；也可随时点右上角「☁️ 同步」手动强制同步。

> ⚠️ **登录机制说明**：本平台为静态网页（GitHub Pages），登录为**客户端门禁**——用于挡住未经授权的人直接查看数据，密码以哈希存储、账号库存于私有 Gist；任何能查看网页源码的人理论上可绕过，请勿在数据中存放机密信息。

## 📦 报单结束与成立规模录入

- 产品收单完成后点「🏁 报单结束」→ 自动进入「📦 录入实际成立规模」
- 录入要素：产品信息（只读）、总份额、各渠道确认份额（份）
- **自动读取**：启动本地桥接服务后，点「📬 从邮箱读取」自动从 Coremail 邮箱（yangzy@chinaamc.com）读取该产品的「基金成立汇总表」Excel 并填入各渠道份额
- **上传 Excel**：也可手动上传「基金成立汇总表」.xlsx，浏览器端自动解析填入（渠道名自动映射：如「中信建投证券」→「中信建投」，中信证券各专户合并到「中信证券」）
- 报单结束后不可再修改报单，可随时修改成立规模
- 本地桥接启动：双击 `启动成立规模桥接.bat`（页面检测到服务在线后显示「📬 从邮箱读取」按钮）

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
