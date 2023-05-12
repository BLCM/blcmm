; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "OpenBLCMM"
#define MyAppVersion "1.3.0"
#define MyAppPublisher "BLCM"
#define MyAppURL "https://github.com/BLCM/OpenBLCMM/"
#define MyAppExeName "OpenBLCMM.exe"
#define MyAppAssocName MyAppName + " File"
#define MyAppAssocExt ".blcm"
#define MyAppAssocKey StringChange(MyAppAssocName, " ", "") + MyAppAssocExt

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{B577E48B-FDBF-487B-BB94-B23B66A7572A}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
ChangesAssociations=yes
DisableProgramGroupPage=yes
LicenseFile=..\LICENSE.txt
InfoBeforeFile=installer-pre-text.txt
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputBaseFilename=OpenBLCMM-{#MyAppVersion}-Installer
SetupIconFile=openblcmm.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern
OutputDir=..\store
;SetupLogging=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\store\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\store\awt.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\store\fontmanager.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\store\freetype.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\store\java.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\store\javaaccessbridge.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\store\javajpeg.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\store\jawt.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\store\jsound.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\store\jvm.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\store\lcms.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "openblcmm.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\LICENSE.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\src\CHANGELOG.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "VC_redist.x64.exe"; DestDir: "{tmp}"; Flags: dontcopy
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Registry]
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocExt}\OpenWithProgids"; ValueType: string; ValueName: "{#MyAppAssocKey}"; ValueData: ""; Flags: uninsdeletevalue
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}"; ValueType: string; ValueName: ""; ValueData: "{#MyAppAssocName}"; Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0"
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""
Root: HKA; Subkey: "Software\Classes\Applications\{#MyAppExeName}\SupportedTypes"; ValueType: string; ValueName: ".blcm"; ValueData: ""

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}/openblcmm.ico"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}/openblcmm.ico"; Tasks: desktopicon

; Disabling this for now -- I'd seen some slightly weird behavior in the app
; which *seemed* related to having started it from the installer at the end,
; so I'm gonna disable this for now.  If I'm being honest, I suspect that the
; launch-at-end is fine and I'm just seeing casuation where there's only
; correlation (at best), but I'm leaving it out for now regardless.
;[Run]
;Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Run]
; Install VC Redist package if need be
Filename: "{tmp}\VC_redist.x64.exe"; \
  StatusMsg: "Installing VC++ redistributables..."; \
  Parameters: "/quiet"; \
  Check: VC2022RedistNeedsInstall; \
  Flags: waituntilterminated

[Code]
function VC2022RedistNeedsInstall: Boolean;
var 
  instVersionStrRaw, instVersionStr, reqVersionStr: String;
  instVersion, reqVersion: Int64;
begin
  Result := False;
  if RegQueryStringValue(HKEY_LOCAL_MACHINE,
       'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64', 'Version',
       instVersionStrRaw) then
  begin
    reqVersionStr := '14.34.31938.00';
    instVersionStr := Copy(instVersionStrRaw, 2, length(instVersionStrRaw)-1);
    Log('VC Redist Version Check : Installed Version: ' + instVersionStr);
    Log('VC Redist Version Check : Required Version: ' + reqVersionStr);
    if (StrToVersion(reqVersionStr, reqVersion)) then
    begin
      if (StrToVersion(instVersionStr, instVersion)) then
      begin
        if (ComparePackedVersion(instVersion, reqVersion) >= 0) then
        begin
          Log('VC Redist Version Check : Redist is already new enough');
          Result := False;
        end
        else
        begin
          Log('VC Redist Version Check : Redist is too old');
          Result := True;
        end
      end
      else
      begin
        Log('VC Redist Version Check : Could not parse installed version');
        Result := True;
      end
    end
    else
    begin
      Log('VC Redist Version Check : Could not parse required version');
      Result := True;
    end
  end
  else 
  begin
    // Not even an old version installed
    Log('VC Redist Version Check : No installed vcredist found');
    Result := True;
  end;
  if (Result) then
  begin
    Log('VC Redist Version Check : Extracting VC Redist package');
    ExtractTemporaryFile('VC_redist.x64.exe');
  end;
end;
