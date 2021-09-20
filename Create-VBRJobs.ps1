$host.ui.RawUI.WindowTitle = "Creating Veeam Backup & Replication Jobs"
      
$JobName    = Read-Host -Prompt 'Enter Job Name'
$BackupRepo = Read-Host -Prompt 'Enter Repo 1'
$vSphereTag = Read-Host -Prompt 'Enter in vSphere Tag'
       
Write-Host ":: Creating Tag Based Policy Backup Job" -ForegroundColor Green
Add-VBRViBackupJob -Name $JobName -BackupRepository $BackupRepo -Entity (Find-VBRViEntity -Tags -Name $vSphereTag) | Out-Null

Write-Host ":: Setting Retention Policy Backup Jobs" -ForegroundColor Green
$JobOptions = Get-VBRJobOptions $JobName
$JobOptions.BackupStorageOptions.RetainDaysToKeep = Read-Host -Prompt 'Enter Desired Restore Days' 
$JobName | Set-VBRJobOptions -Options $JobOptions | Out-Null

$FullBackupDay = Read-Host -Prompt 'Enter the Desired Full Backup Day'

Get-VBRJob -Name $JobName | Set-VBRJobAdvancedBackupOptions -Algorithm Incremental -TransformFullToSyntethic $False -EnableFullBackup $True -FullBackupDays $FullBackupDay | Out-Null

Write-Host ":: Setting Schedule for Backup Jobs" -ForegroundColor Green
$JobTime = Read-Host -Prompt 'Enter Desired Job Start Time'
Get-VBRJob -Name $JobName | Set-VBRJobSchedule -Daily -At $JobTime | Out-Null
Get-VBRJob -Name $JobName | Enable-VBRJobSchedule | Out-Null

Write-Host ":: Job Configured!" -ForegroundColor Green
