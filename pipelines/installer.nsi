# name the installer

!define APPNAME "TOP2000"
!define COMPANYNAME "Chroomsoft"

# These three must be integers
!define VERSIONMAJOR 1
!define VERSIONMINOR 0
!define VERSIONBUILD 1

!define HELPURL "http://dos.top2000.app" # "Support Information" link
!define UPDATEURL "https://github.com/rneeft/Top2000-MSDOS/releases" # "Product Updates" link

InstallDir "$LOCALAPPDATA\${COMPANYNAME}\${APPNAME}"

Name "TOP 2000 APP voor MS-DOS"
Icon "top2000.ico"
OutFile "Top2000Installer.exe"
RequestExecutionLevel user
LicenseData "BIN\licentie.txt"

page license
page directory
Page instfiles

# default section start; every NSIS script has at least one section.
Section "install"
    SetOutPath $INSTDIR
    file "BIN\TOP2000.EXE"  
    file "BIN\TOP2000.ICO"
    file "BIN\TOP2000.DAT"
    file "BIN\DOSBox.exe"
    file "BIN\SDL.dll"
    file "BIN\SDL_net.dll"

    writeUninstaller "$INSTDIR\uninstall.exe"

	# Start Menu
	createDirectory "$SMPROGRAMS\TOP2000"
	createShortCut "$SMPROGRAMS\TOP2000\TOP2000 App voor DOS.lnk" "$INSTDIR\DOSBox.exe" '-noconsole -userconf -c "MOUNT T $INSTDIR" -c T: -c TOP2000' "$INSTDIR\TOP2000.ICO"

SectionEnd

section "uninstall"
	# Remove Start Menu launcher
	delete "$SMPROGRAMS\TOP2000\TOP2000 App voor DOS.lnk"
	# Try to remove the Start Menu folder - this will only happen if it is empty
	rmDir "$SMPROGRAMS\TOP2000"

    # Remove files
    delete  $INSTDIR\TOP2000.EXE 
    delete  $INSTDIR\TOP2000.ICO
    delete  $INSTDIR\TOP2000.DAT
    delete  $INSTDIR\DOSBox.exe
    delete  $INSTDIR\SDL.dll
    delete  $INSTDIR\SDL_net.dll
 
	# Always delete uninstaller as the last action
	delete $INSTDIR\uninstall.exe

    # Try to remove the install directory - this will only happen if it is empty
	rmDir $INSTDIR
SectionEnd