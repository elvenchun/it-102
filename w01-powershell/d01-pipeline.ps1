#Requires -Version 5.1
<#
    d01-pipeline.ps1  —  管道三件事：筛、排、算
    运行：powershell -ExecutionPolicy Bypass -File .\d01-pipeline.ps1
#>

# 1. 筛选：只留运行中的服务
$running = Get-Service | Where-Object Status -eq 'Running'

# 2. 排序：按进程内存倒序取前 10
$topMem = Get-Process |
    Sort-Object WorkingSet64 -Descending |
    Select-Object -First 10

# 3. 计算列：把字节换算成 MB，命名成中文列
$report = $topMem | Select-Object Name,
    @{ n = '内存MB'; e = { [math]::Round($_.WorkingSet64 / 1MB, 1) } },
    @{ n = '句柄数'; e = { $_.HandleCount } }

# 输出统一拼成一段，避免标题与表格错位
$out = @()
$out += ('运行中的服务：{0} 个' -f $running.Count)
$out += '内存占用 Top10：'
$out += ($report | Format-Table -AutoSize | Out-String -Width 200)
Write-Host ($out -join [Environment]::NewLine)
