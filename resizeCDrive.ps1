# (Get-Disk | Where-Object {$_.Number -eq 0}).Size

$diskToShrink = (Get-Partition -DriveLetter C).PartitionNumber
$totalDiskCSize = (Get-Volume -DriveLetter C).Size * 1

$percentageToShrink = 20 / 100

$remainingDiskCSize = (Get-Volume -DriveLetter C).SizeRemaining * 1

$sizeToShrinkTotal = [math]::Ceiling(($totalDiskCSize * $percentageToShrink))

$sizeToShrinkRemaining = [math]::Ceiling($remainingDiskCSize * $percentageToShrink)


Write-Host $sizeToShrinkTotal

Write-Host $sizeToShrinkRemaining

if ($sizeToShrinkTotal -gt $remainingDiskCSize){
    Resize-Partition -DiskNumber 0 -PartitionNumber $diskToShrink -Size ($remainingDiskCSize-$sizeToShrinkRemaining)
    New-Partition -DiskNumber 0 -UseMaximumSize -DriveLetter O
    Format-Volume -DriveLetter O -FileSystem NTFS -Confirm:$false -Force -NewFileSystemLabel "OneDrive"
    Exit 0
}

#Resize disk C
Resize-Partition -DiskNumber 0 -PartitionNumber $diskToShrink -Size ($totalDiskCSize-$sizeToShrinkTotal)
New-Partition -DiskNumber 0 -UseMaximumSize -DriveLetter O
Format-Volume -DriveLetter O -FileSystem NTFS -Confirm:$false -Force -NewFileSystemLabel "OneDrive"


