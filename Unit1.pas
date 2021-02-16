unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,Winapi.ShellAPI,IniFiles,StrUtils,
  Dialogs, DSE_SearchFiles, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    sf: SE_SearchFiles;
    Button1: TButton;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DisplayLog ( aString:string);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
function GetDosOutput(CommandLine: string; Work: string = 'C:\'): string;  { Run a DOS program and retrieve its output dynamically while it is running. }
var
  SecAtrrs: TSecurityAttributes;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  StdOutPipeRead, StdOutPipeWrite: THandle;
  WasOK: Boolean;
  pCommandLine: array[0..255] of AnsiChar;
  BytesRead: Cardinal;
  WorkDir: string;
  Handle: Boolean;
begin
  Result := '';
  with SecAtrrs do begin
    nLength := SizeOf(SecAtrrs);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;
  CreatePipe(StdOutPipeRead, StdOutPipeWrite, @SecAtrrs, 0);
  try
    with StartupInfo do
    begin
      FillChar(StartupInfo, SizeOf(StartupInfo), 0);
      cb := SizeOf(StartupInfo);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      wShowWindow := SW_HIDE;
      hStdInput := GetStdHandle(STD_INPUT_HANDLE); // don't redirect stdin
      hStdOutput := StdOutPipeWrite;
      hStdError := StdOutPipeWrite;
    end;
    WorkDir := Work;
    Handle := CreateProcess(nil, PChar('cmd.exe /C ' + CommandLine),
                            nil, nil, True, 0, nil,
                            PChar(WorkDir), StartupInfo, ProcessInfo);
    CloseHandle(StdOutPipeWrite);
    if Handle then
      try
        repeat
          WasOK := windows.ReadFile(StdOutPipeRead, pCommandLine, 255, BytesRead, nil);
          if BytesRead > 0 then
          begin
            pCommandLine[BytesRead] := #0;
            Result := Result + pCommandLine;
          end;
        until not WasOK or (BytesRead = 0);
        WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
      finally
        CloseHandle(ProcessInfo.hThread);
        CloseHandle(ProcessInfo.hProcess);
      end;
  finally
    CloseHandle(StdOutPipeRead);
  end;
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  i: Integer;
begin

  sf.FromPath := edit1.Text;

  sf.MaskInclude.Add('*.*');
  sf.SubDirectories := False;
  sf.Execute;

  while sf.SearchState <> ssIdle do begin
    Application.ProcessMessages;
  end;
  for I := 0 to sf.ListFiles.Count -1 do begin
    GetDosOutput ('nwnmdlcomp.exe ' + '-d ' + Edit1.text + Sf.ListFiles[i] + ' ' + Edit2.text + Sf.ListFiles[i], ExtractFilePath(application.Exename));
    DisplayLog (IntToStr(i+1) + ' of ' + IntToStr(sf.ListFiles.Count) + ' : ' + sf.CurrentDirectory + '\' +sf.CurrentFileName);
  end;
  DisplayLog ('Done!');

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
  ini: Tinifile;
begin
  ini := TIniFile.Create( ExtractFilePath(application.Exename) + 'bin2mdl.ini' );
  ini.WriteString('setup','sourcedir',Edit1.Text);
  ini.WriteString('setup','destdir',Edit2.Text);
  ini.free;

end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
  ini: Tinifile;
begin
  ini := TIniFile.Create( ExtractFilePath(application.Exename) + 'bin2mdl.ini' );
  Edit1.Text := ini.ReadString('setup','sourcedir','');
  Edit2.Text := ini.ReadString('setup','destdir','');
  ini.free;

  if RightStr (Edit1.Text,1) <> '\' then
    Edit1.Text := Edit1.Text + '\';
  if RightStr (Edit2.Text,1) <> '\' then
    Edit2.Text := Edit2.Text + '\';


end;
procedure TForm1.DisplayLog ( aString:string);
begin
  Memo1.Lines.Add( aString );
  if Memo1.Lines.Count > 300 then
    Memo1.Clear;
end;


end.
