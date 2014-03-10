#-------------------------------------------------------------------------
# Copyright (c) Microsoft Open Technologies, Inc.
# All Rights Reserved. Licensed under the MIT License.
#--------------------------------------------------------------------------

param (
    [string]$vm_id = $(throw "-vm_id is required.")
 )

# Include the following modules
$presentDir = Split-Path -parent $PSCommandPath
$modules = @()
$modules += $presentDir + "\utils\write_messages.ps1"
forEach ($module in $modules) { . $module }

try {
  $vm = Get-VM -Id $vm_id -ErrorAction "stop"
  Resume-VM $vm
  $state = $vm.state
  $status = $vm.status
  $name = $vm.name
  $resultHash = @{
    state = "$state"
    status = "$status"
    name = "$name"
  }
  $result = ConvertTo-Json $resultHash
  Write-Output-Message $result
}
catch {
  $errortHash = @{
    type = "PowerShellError"
    message ="Failed to mount files VM  $_"
  }
  $errorResult = ConvertTo-Json $errortHash
  Write-Error-Message $errorResult
}
