#Requires -Version 5.1
<#
    New-StudyDir.ps1  —  一键重建学习目录结构（幂等，重复跑不报错）
    用法：
        powershell -ExecutionPolicy Bypass -File .\New-StudyDir.ps1
        powershell -ExecutionPolicy Bypass -File .\New-StudyDir.ps1 -Root 'E:\Study\it-102'
#>
param(
    [string]$Root = 'D:\Study\it-102',

    [string[]]$Dirs = @(
        '00-log',
        'w01-powershell',
        'w03-shell',
        'w05-docker',
        'w07-python',
        'w09-k3s',
        'w11-project'
    )
)

$paths = $Dirs | ForEach-Object { Join-Path $Root $_ }
New-Item -ItemType Directory -Path $paths -Force | Out-Null

$out = @()
$out += ('根目录：{0}' -f $Root)
$out += ''
$out += '当前结构：'
$out += ('  ' + (Split-Path $Root -Leaf) + '\')

for ($i = 0; $i -lt $Dirs.Count; $i++) {
    $last = ($i -eq $Dirs.Count - 1)
    $out += ('  ' + $(if ($last) { '└── ' } else { '├── ' }) + $Dirs[$i] + '\')

    $files = @(Get-ChildItem $paths[$i] -File -ErrorAction SilentlyContinue |
               Sort-Object Name)
    for ($j = 0; $j -lt $files.Count; $j++) {
        $tail = ($j -eq $files.Count - 1)
        $pad = $(if ($last) { '    ' } else { '│   ' })
        $out += ('  ' + $pad + $(if ($tail) { '└── ' } else { '├── ' }) + $files[$j].Name)
    }
}

Write-Host ($out -join [Environment]::NewLine)
