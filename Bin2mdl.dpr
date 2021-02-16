program Bin2mdl;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  DSE_SearchFiles in 'DSE_SearchFiles.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Bin2Mdl';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
