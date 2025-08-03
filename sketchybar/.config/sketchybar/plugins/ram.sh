#!/bin/bash

# 参考 Raycast System Monitor 的实现
# https://github.com/raycast/extensions/blob/ca400569f7b9b65f537928ce836c3accf55f373a/extensions/system-monitor/src/Memory/MemoryUtils.ts#L26
hwPagesize=$(sysctl -n hw.pagesize)
pMemTotal=$(sysctl -n hw.memsize)
memTotal=$(($pMemTotal / 1024 / 1024))
pVmPagePageableInternalCount=$(sysctl -n vm.page_pageable_internal_count)
pVmPagePurgeableCount=$(sysctl -n vm.page_purgeable_count)
pagesApp=$(($pVmPagePageableInternalCount - $pVmPagePurgeableCount))
pagesWired=$(vm_stat | awk '/ wired/ { print $4 }' | sed 's/\.//')
pPagesCompressed=$(vm_stat | awk '/ occupied/ { printf $5 }' | sed 's/\.//')
memUsed=$((($pagesApp + $pagesWired + $pPagesCompressed) * $hwPagesize / 1024 / 1024))
memUsedPercentage=$((100 * $memUsed / $memTotal))

sketchybar -m --set $NAME label="$memUsedPercentage%"