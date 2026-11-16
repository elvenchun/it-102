# PowerShell 学习笔记

> 只记「查不到的东西」。`Get-Help` 能查到的不用抄。

## D01 环境、帮助系统、对象管道

### 三件套
- `Get-Help` — 查用法，`-Examples` 最有用
- `Get-Command` — 找命令，按 `-Verb` / `-Noun` 搜
- `Get-Member` — 看对象有什么属性和方法

### 踩过的坑
- `Update-Help` 需要管理员权限，非提权会整批失败（`$PSHOME` 受保护）
- UTF-8 无 BOM 的 `.ps1` 被 PS 5.1 按 GBK 读，中文注释乱码后报「缺少右括号」的假语法错
- `Get-Command -Module X` 查不到不等于命令不存在，模块没装也返回空且不报错

### 待补
-
