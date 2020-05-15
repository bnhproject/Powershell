# Brandon Hunt 00186124
try{
Do {
$task = (Read-Host "Enter a number from 1-4 or enter 5 to quit.");

 switch ($task) {
    1 {Get-ChildItem $PSScriptRoot -Filter *.log | Out-File -FilePath $PSScriptRoot\DailyLog.txt -Append; break} #Finds .log files in the same directory as the script and appends them to DailyLog.txt
       2 {Get-ChildItem $PSScriptRoot | Sort-Object Name | Format-Table | Out-File $PSScriptRoot\C916contents.txt -Append ; break}# Lists all files in the same directory as the script, formats to tabular format in alphabetical order ascending and appends to C916contents.txt
          3 {Get-Counter -Counter "\Processor(*)\% Processor Time", "\Memory\Committed Bytes" -SampleInterval 5 -MaxSamples 4 ; break} # Gets 4 samples at 5 second intervals of processor time and memory usage.
             4 {Get-Process| Sort-Object CPU -Descending | Out-GridView ; break} #Shows running processes in Gridview sorted by cpu time from greatest to least.
                5 {"Goodbye."; break}# Exits switch and ptints Goodbye
                   default {"Invalid Input!"; break}# prints invalid input
                   }
                   } until ($task -eq 5)
}
catch [System.OutOfMemoryException] {
    Write-Host "A system out of memory exception occured."# Catches system out of memory error
    }
#test commit changes
