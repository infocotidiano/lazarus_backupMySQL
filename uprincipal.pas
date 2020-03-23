unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ActnList, process;

type

  { Tfrmprincipal }
  { 040 099 041 032 073 110 102 111 099 111 116 105 100 105 097 110 111 }


  Tfrmprincipal = class(TForm)
    btnBackup: TButton;
    edtMYSQLDUMP: TEdit;
    edtSCHEMA: TEdit;
    edtUSUARIO: TEdit;
    edtSENHA: TEdit;
    edtSERVIDOR: TEdit;
    edtDESTINO: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    procedure btnBackupClick(Sender: TObject);
  private
    { private declarations }
    procedure backupMySQL;
  public
    { public declarations }
  end;

var
  frmprincipal: Tfrmprincipal;

implementation

{$R *.lfm}

{ Tfrmprincipal }

procedure Tfrmprincipal.btnBackupClick(Sender: TObject);
begin
  backupMySQL;
end;

procedure Tfrmprincipal.backupMySQL;
  const READ_BYTES = 2048;
  var
    command : TProcess;
    cARQBKP: String;
    output : tstringlist;
    BytesRead, n : LongInt;
    m: TMemoryStream;
begin
  cARQBKP:= edtDESTINO.Text;
  command := TProcess.Create(nil);
  output := TStringList.Create;
  m := TMemoryStream.Create;
  BytesRead:=0;
  command.CommandLine:=edtMYSQLDUMP.Text+' -u'+edtUSUARIO.Text+' -p'+edtSENHA.Text+' -h'+edtSERVIDOR.Text+' '+edtSCHEMA.text;
  command.Options:=command.Options+[poUsePipes];
  Memo1.Clear;
  Memo1.Lines.Add('Backup Iniciado');
  command.ShowWindow:=swoHIDE;
  command.Execute;
  while command.Running do
     begin
       m.SetSize(BytesRead+READ_BYTES);
       n:= command.Output.Read((m.Memory+BytesRead)^, READ_BYTES);
       if n> 0 then
          inc(BytesRead,n)
       else
          Sleep(100);
     end;
  repeat
    m.SetSize(BytesRead+READ_BYTES);
    n := command.Output.Read((m.Memory+BytesRead)^, READ_BYTES);
    if n> 0 then
       inc(BytesRead,n)
    else
       Sleep(100);
  until n <= 0;
  m.SetSize(BytesRead);
  output.LoadFromStream(m);
  Memo1.Lines.AddStrings(output);
  output.SaveToFile(cARQBKP);
  output.Free;
  command.free;
  m.Free;
  Memo1.Lines.Add('Comando concluido !');

end;

end.

