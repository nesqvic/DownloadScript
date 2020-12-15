#youtube-dl https://www.site.com/video_adress -f 299+140 -o %(title)s.%(ext)s   Run this after videos finish downloading
$prog="youtube-dl.exe"
$argums="https://www.site.com/video_adress -f 299,140 -o %(title)s.%(ext)s"
$logfile="log.txt"
$wait=30    #Decrease this if keeps on freezing, it is doubled on start it's not a mistake

function init {
    $proc=Start-Process $prog -ArgumentList $argums -PassThru -RedirectStandardOutput $logfile -WindowStyle Minimized

    $proc
    Start-Sleep $wait
    check
}

function check {
    Start-Sleep $wait
    $size1=(Get-Content $logfile).Length
    if ($size1 -gt 1024*1024) { #keeps log files size less than 1 MB
    #you can use any size in bytes, convert variable to any units or get rid of this part.
    #Log file can get 100s of gigabytes in size over night.
        Write-Host $size1
        restart
    }
    
    Start-Sleep $wait
    $size2=(Get-Content $logfile).Length
    if ($size2 -eq $size1) { #Process can be easily killed if it froze not long ago.
    #I check for freezes every half a minute & it seems OK for my system.
        Write-Host $size1
        restart
    }
    
    check
}

function restart {
    Stop-Process -Id $proc.Id
    init
}

init
