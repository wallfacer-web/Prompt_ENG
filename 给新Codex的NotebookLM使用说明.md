# 给新 Codex 的 NotebookLM 使用说明

这个目录里的 `notebooklm-py` 是一个可供 Codex/Claude Code 使用的 NotebookLM 技能与 CLI 工具。

## 你应该怎么理解它

- 这不是普通网页书签，而是一个本地技能目录 + Python 包源码目录。
- 真正的认证方式不是手工描述网页步骤，而是运行 `notebooklm login`。
- 认证成功后，会把 Google 登录态保存到 `storage_state.json`，后续命令复用它。

## 首次使用步骤

1. 进入这个目录下的 `notebooklm-py`
2. 安装依赖：`pip install "notebooklm-py[browser]"`
3. 安装浏览器：`playwright install chromium`
4. 执行登录：`notebooklm login`
5. 浏览器里完成 Google 登录，并真正进入 NotebookLM 首页
6. 回到终端按一次回车，保存认证
7. 用 `notebooklm list` 或 `notebooklm status` 验证是否成功

## 认证文件位置

默认在：`~/.notebooklm/storage_state.json`

如果需要多账号或隔离环境，可以设置：`NOTEBOOKLM_HOME`
如果在 CI/CD 中使用，可以设置：`NOTEBOOKLM_AUTH_JSON`
注意：设置了 `NOTEBOOKLM_AUTH_JSON` 以后，不要再运行 `notebooklm login`

## 给 Codex 的执行规则

当用户要求使用 NotebookLM 时，优先按下面顺序做：

1. 先检查认证是否可用：`notebooklm status`
2. 如果未认证，再提示或执行：`notebooklm login`
3. 认证后用 `notebooklm list` 验证
4. 需要创建笔记本时，用 `notebooklm create "标题"`
5. 需要加资料时，用 `notebooklm source add ...`
6. 需要提问时，用 `notebooklm ask "问题"`
7. 需要生成内容时，用 `notebooklm generate ...`

## 关键提醒

- 不要把“如何登录 NotebookLM 网页”误当成这个技能的用法。
- 这个技能的关键是 CLI 登录、cookies 保存、后续命令复用。
- 如果用户说“NotebookLM 不会用”，优先查看：
  - `README.md`
  - `SKILL.md`
  - `docs/configuration.md`
  - `src/notebooklm/cli/session.py`

## 本地路径

- 技能源码目录：`notebooklm-py`
- 当前说明文件：`给新Codex的NotebookLM使用说明.md`
