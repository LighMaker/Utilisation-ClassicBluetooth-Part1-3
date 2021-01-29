unit CLassicBluetoothPas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.StdCtrls, FMX.ListBox, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, System.Bluetooth;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    BtnDecouverte: TButton;
    ComboBox1: TComboBox;
    AniIndicator1: TAniIndicator;
    procedure FormShow(Sender: TObject);
    procedure BtnDecouverteClick(Sender: TObject);
  private
    { Déclarations privées }
    FBluetoothManager : TBluetoothManager;
    FBluetoothDevicesList : TBluetoothDeviceList;
    Procedure FinDecouverteAppareils (Const Sender : TObject; Const Adevices : TBluetoothDeviceList);
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
  procedure TForm1.BtnDecouverteClick(Sender: TObject);
begin
  ComboBox1.Clear;
  AniIndicator1.Visible:=True;
  AniIndicator1.Enabled:=True;

  if FBluetoothManager.ConnectionState=TBluetoothConnectionState.Connected then
  begin
    FBluetoothManager.StartDiscovery(10000);
  end else
  begin
    Memo1.Lines.Add('Votre Bluetooth n''est pas activé');
  end;
end;

Procedure Tform1.FinDecouverteAppareils (Const Sender : TObject; Const Adevices : TBluetoothDeviceList);
begin
TThread.Synchronize(nil, procedure
  Var I : Integer ;
  begin
    AniIndicator1.Visible:=False;
    AniIndicator1.Enabled:=False;
    FBluetoothDevicesList:=ADevices;

    if FBluetoothDevicesList.Count>0 then
    begin
      Memo1.Lines.Add('Nbre d''appareils trouvés : ' + IntToStr(FBluetoothDevicesList.Count));
      for I := 0 to FBluetoothDevicesList.Count-1 do
      begin
        ComboBox1.Items.Add(FBluetoothDevicesList.Items[I].DeviceName);
      end;
      ComboBox1.ItemIndex:=0;
    end else
    begin
      Memo1.Lines.Add('Nbre d''appareils trouvés : 0');
    end;
  end);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
   FBluetoothManager:=TBluetoothManager.Current;
   FBluetoothManager.OnDiscoveryEnd:=FinDecouverteAppareils;
end;

end.
