; LayerLab Windows installer (Inno Setup 6)
;
; Build:
;   "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" scripts\installer.iss
;
; Override the app folder built by build-app.ps1:
;   ISCC.exe /DAppSrc="E:\path\to\LayerLab-App" scripts\installer.iss
;
; Produces: dist\LayerLab-Setup-<version>.exe

#define AppName      "LayerLab"
#define AppVersion   "1.0.1"
#define AppPublisher "FDDX"
#define AppURL       "https://github.com/FancyDDxAI/LayerLab"
#define AppExe       "LayerLab.exe"

#ifndef AppSrc
  #define AppSrc "..\..\LayerLab\LayerLab-App"
#endif

[Setup]
AppId={{8E5B1C42-9A3D-4F7E-B6C1-LAYERLAB0001}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}/issues
AppUpdatesURL={#AppURL}/releases
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
DisableDirPage=no
LicenseFile=..\LICENSE
OutputDir=..\dist
OutputBaseFilename=LayerLab-Setup-{#AppVersion}
SetupIconFile=..\assets\icon.ico
UninstallDisplayIcon={app}\{#AppExe}
UninstallDisplayName={#AppName} {#AppVersion}
WizardStyle=modern
Compression=lzma2/max
SolidCompression=yes
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
; per-user install by default, so no admin prompt is needed
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop shortcut"; GroupDescription: "Shortcuts:"

[Files]
Source: "{#AppSrc}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#AppName}";              Filename: "{app}\{#AppExe}"
Name: "{group}\Uninstall {#AppName}";    Filename: "{uninstallexe}"
Name: "{autodesktop}\{#AppName}";        Filename: "{app}\{#AppExe}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppExe}"; Description: "Launch {#AppName}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
; user settings live in Electron's profile folder
Type: filesandordirs; Name: "{localappdata}\layerlab"
