#Requires -Version 5.1
<#
    d02-service-report.ps1  —  服务健康报表
    产出：按状态汇总 + 自动启动却停着的服务清单
    运行：powershell -ExecutionPolicy Bypass -File .\d02-service-report.ps1
#>

# 长名字截断，防止把表格撑破
function Shorten([string]$s, [int]$n) {
    if ($null -eq $s) { return '' }
    if ($s.Length -gt $n) { return $s.Substring(0, $n - 2) + '..' }
    return $s
}

$all = Get-Service

$sum = $all | Group-Object Status |
    Sort-Object Count -Descending |
    Select-Object @{ n = '状态'; e = { $_.Name } }, @{ n = '数量'; e = { $_.Count } }

# 该起没起：启动类型为自动，但当前不是 Running
$lazy = @($all | Where-Object { $_.StartType -eq 'Automatic' -and $_.Status -ne 'Running' })

$out = @()
$out += '=== 服务状态汇总 ==='
$out += ($sum | Format-Table -AutoSize | Out-String -Width 200)
$out += ('自动启动但未运行：{0} 个' -f $lazy.Count)

if ($lazy.Count -gt 0) {
    $out += ($lazy |
        Select-Object @{ n = '服务名'; e = { Shorten $_.Name 34 } },
                      @{ n = '显示名'; e = { Shorten $_.DisplayName 26 } },
                      Status |
        Format-Table -AutoSize | Out-String -Width 200)
}

Write-Host ($out -join [Environment]::NewLine)
