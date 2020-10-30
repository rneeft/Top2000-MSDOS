@ECHO ON
CLS
@ECHO TOP2000 APP voor MS-DOS installer
@ECHO =================================
@ECHO.
@ECHO Welkom bij de installer
@ECHO Deze installer installeerd de TOP2000 APP voor MS-DOS op C:\TOP2000
@ECHO Indien u in een andere map de applicatie wilt installeren verander dan de locatie in dit script
@ECHO Druk op ENTER om de installatie te starten of CTRL-C om te beeindigen.
@PAUSE
mkdir C:\TOP2000
EXPAND.EXE TOP2000.IC_ C:\TOP2000\TOP2000.ICO
EXPAND.EXE TOP2000.DA_ C:\TOP2000\TOP2000.DAT
EXPAND.EXE TOP2000.EX_ C:\TOP2000\TOP2000.EXE