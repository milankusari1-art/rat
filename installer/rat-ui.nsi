; Rat UI Installer
; NSIS Installer Script

!include "MUI2.nsh"
!include "x64.nsh"

; Define constants
!define APPNAME "Rat UI"
!define APPVERSION "1.0.0"
!define APPEXE "rat-ui.exe"
!define COMPANYNAME "RatUI"
!define DESCRIPTION "Opiumware Command Executor - All-Green Terminal Interface"
!define INSTALLDIR "$PROGRAMFILES\RatUI"

; MUI Settings
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

; Installer info
Name "${APPNAME} ${APPVERSION}"
OutFile "RatUI-${APPVERSION}-installer.exe"
InstallDir "${INSTALLDIR}"
ShowInstDetails show
ShowUninstDetails show

; Request admin rights
RequestExecutionLevel admin

; Installation function
Section "Install"
    SetOutPath "${INSTALLDIR}"
    
    ; Create directory
    CreateDirectory "${INSTALLDIR}\resources"
    CreateDirectory "${INSTALLDIR}\public"
    CreateDirectory "$SMPROGRAMS\${APPNAME}"
    
    ; Copy app files
    File /r "dist\*.*"
    File /r "public\*.*" "${INSTALLDIR}\public\"
    File /r "assets\*.*" "${INSTALLDIR}\assets\"
    
    ; Create shortcuts
    CreateShortCut "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk" "${INSTALLDIR}\${APPEXE}" "" "${INSTALLDIR}\assets\rat-icon.ico"
    CreateShortCut "$DESKTOP\${APPNAME}.lnk" "${INSTALLDIR}\${APPEXE}" "" "${INSTALLDIR}\assets\rat-icon.ico"
    CreateShortCut "$SMPROGRAMS\${APPNAME}\Uninstall ${APPNAME}.lnk" "$INSTDIR\uninstall.exe"
    
    ; Write uninstaller
    WriteUninstaller "$INSTDIR\uninstall.exe"
    
    ; Write registry entries
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME} ${APPVERSION}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$INSTDIR\uninstall.exe"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayVersion" "${APPVERSION}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "Publisher" "${COMPANYNAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayIcon" "${INSTALLDIR}\assets\rat-icon.ico"
SectionEnd

; Uninstaller function
Section "Uninstall"
    ; Remove files
    RMDir /r "${INSTALLDIR}"
    
    ; Remove shortcuts
    RMDir /r "$SMPROGRAMS\${APPNAME}"
    Delete "$DESKTOP\${APPNAME}.lnk"
    
    ; Remove registry entries
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
SectionEnd

; Function to run on initialization
Function .onInit
    ${If} ${RunningX64}
        SetRegView 64
    ${Else}
        SetRegView 32
    ${EndIf}
FunctionEnd
