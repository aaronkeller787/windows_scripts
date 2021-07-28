@echo off

rem This file is used to check if the slaves are behind the master and report that to IP Monitor

rem This connects to the mysql database and outputs the values of SHOW SLAVE STATUS into a file
c:\"Program Files\MySQL\MySQL Server 5.5\bin\mysql.exe" -h %1 -u %2 -%3 --connect_timeout=10 --execute="SHOW SLAVE STATUS\G" > c:\scripts\slave-status-%1

rem This searches the file created above, and outputs the value of Seconds_Behind_Master to a new file
findstr Seconds_Behind_Master c:\scripts\slave-status-%1 | c:\scripts\awk.exe "{print $(NF)}" > slave-status-%1-1

rem This assigns the value of the file to the variable secondsbehind
set /p secondsbehind= < c:\scripts\slave-status-%1-1

rem Used for testing to make sure the value is stored
echo %secondsbehind%

rem Removes the new file that was created
del c:\scripts\slave-status-%1-1

rem Performs logic to determine which type of exit code will be passed based on the value of the secondsbehind variable
if %secondsbehind% EQU NULL (exit 1) else if %secondsbehing% GTR 300 (exit 1) else (exit 0)
