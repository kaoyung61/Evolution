unit AddBac;

interface

uses  Utils.WindowMove,CustomType.TBactery,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.TabControl, FMX.ScrollBox, FMX.Memo,
  FMX.ListBox, FMXTee.Engine, FMXTee.Series, FMXTee.Procs, FMXTee.Chart,
  FMX.Objects, FMX.Colors, FMX.Edit, FMX.Layouts, System.Actions, FMX.ActnList;

type
  TForm2 = class(TForm)
    ActionList1: TActionList;
    UpdateSett: TAction;
    TopPanel: TPanel;
    OpacityBar: TTrackBar;
    AddBacClose: TSpeedButton;
    TabControl1: TTabControl;
    StatTab: TTabItem;
    Panel2: TPanel;
    Chart1: TChart;
    Series1: TBarSeries;
    ComboBox1: TComboBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ComboBox2: TComboBox;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    Chart2: TChart;
    Series2: TBarSeries;
    ShowBigChartButton: TButton;
    LogTab: TTabItem;
    LogMemo: TMemo;
    TabItem1: TTabItem;
    AddBacPanel: TPanel;
    GridLayout1: TGridLayout;
    Label2: TLabel;
    CountEdit: TEdit;
    Label3: TLabel;
    SizeEdit: TEdit;
    Label4: TLabel;
    SpeedEdit: TEdit;
    Label6: TLabel;
    SenceEdit: TEdit;
    Label7: TLabel;
    EnergyEdit: TEdit;
    Label11: TLabel;
    ReplicEdit: TEdit;
    Label8: TLabel;
    ColorEdit: TColorComboBox;
    AddBac: TButton;
    Label16: TLabel;
    TabItem2: TTabItem;
    SettScroll: TVertScrollBox;
    SetPanel: TPanel;
    Label1: TLabel;
    Label14: TLabel;
    EnergyRule1: TRadioButton;
    EnergyRule2: TRadioButton;
    EnergyRule3: TRadioButton;
    Layout1: TLayout;
    LabelLay1: TLayout;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label9: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    ComboBoxLay1: TLayout;
    kEnergyBox: TComboBox;
    AnimSpeedBox: TComboBox;
    AnimMasBox: TComboBox;
    FoodSpawnBox: TComboBox;
    FoodPowerBox: TComboBox;
    kSenceRadBox: TComboBox;
    kEatRadBox: TComboBox;
    StatBox: TComboBox;
    MutShanceBox: TComboBox;
    MutPowerBox: TComboBox;
    EnergyRule5: TRadioButton;
    EnergyRule4: TRadioButton;
    VertScrollBox1: TVertScrollBox;
    VertScrollBox2: TVertScrollBox;
    Button1: TButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OpacityBarChange(Sender: TObject);
    procedure AddBacClick(Sender: TObject);
    procedure AddBacCloseClick(Sender: TObject);
    procedure AnimSpeedBoxChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure EnergyRule1Click(Sender: TObject);
  private
    { Private declarations }
    FWindowMove: IWindowMove;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation uses  Evotypes, Evo;

{$R *.fmx}

procedure TForm2.AddBacClick(Sender: TObject); //добавить новых бактерий
var i,a:integer; Mas:TBacteryInfo;
begin
MainForm.T1.Enabled:=false; //приостанавливаем таймер
Randomize;
a:=strtoint(CountEdit.Text) ;
for I := 1 to a do begin
Mas.speed:=strtofloat(SpeedEdit.Text);   //формируем информацию о бактерии
Mas.size:=strtofloat(SizeEdit.Text);
Mas.sence:=strtofloat(SenceEdit.Text);
Mas.color:=ColorEdit.Color;
mas.energy:=strtofloat(EnergyEdit.Text);
mas.angle:=random(358)+1;
Mas.x:=random(Sim.x);
Mas.y:=random(Sim.y);
bac[sim.BacCount+i].Write(Mas); end;
iNC(sim.BacCount,a);
for I := 1 to sim.BacCount do bac[i].CheckEllipse;
//randomize;     //рандомизируем этот мир


{for i := sim.Baccount+1 to sim.Baccount+strtoint(CountEdit.Text) do//добавляем в конец массива новые бактерии
SpawnBac(i,ColorEdit.Color, strtofloat(SpeedEdit.Text),strtofloat(SizeEdit.Text),strtofloat(SenceEdit.Text),strtofloat(EnergyEdit.Text),strtofloat(ReplicEdit.Text),
          26+random(round(Petry.x)-51),26+random(round(Petry.y)-51),random(358)+1);
LogMemo.Lines.Add(inttostr(sol)+' - Количество бактерий: '+inttostr(count)); }


end;

procedure TForm2.Button1Click(Sender: TObject);
var Mas:TBactery; i:integer;
begin
{Mas.speed:=strtofloat(SpeedEdit.Text);
Mas.size:=strtofloat(SizeEdit.Text);
Mas.color:=ColorEdit.Color;
Mas.x:=100;
Mas.y:=100;
mas.EllipseIsCreated:=true;}         //
mas:=bac[1];
for i := 1 to sim.BacCount-1 do bac[i]:=bac[i+1]; //первая становится 2    не копируется цвет
bac[sim.BacCount]:=mas;
for i := 1 to sim.BacCount do begin bac[i].inf.x:=100+10*(i mod 100); bac[i].inf.y:=50+(sol mod 100)*5; bac[i].Updateellipse end;
bac[5].HideEllipse;
//for i := 1 to 9 do bac[i].CheckEllipse;  //здесь должны обновиться цвета-он почему то не копируется
//bac[10]:=mas;
//bac[10].HideEllipse;

//bac[2].ellipse.Fill.Color:=bac[2].Color;
end;

procedure TForm2.AddBacCloseClick(Sender: TObject);
begin
 MainForm.Activate;
end;

procedure TForm2.AnimSpeedBoxChange(Sender: TObject);
var i:integer;
begin
MainForm.T1.Enabled:=false; //в любом случае останавливаем симуляцию

sett.FoodPower:=strtoint(FoodPowerBox.Items[FoodPowerBox.ItemIndex]);    //настройки спавна еды
sett.FoodSpawn:=strtoint(FoodSpawnBox.Items[FoodSpawnBox.ItemIndex]);

                       //настройки поведения бактерии
sett.kEnergy:=strtofloat(kEnergyBox.Items[kEnergyBox.ItemIndex]);
sett.kRadEat:=strtofloat(kEatRadBox.Items[kEatRadBox.ItemIndex]);
sett.kRadSence:=strtofloat(kSenceRadBox.Items[kSenceRadBox.ItemIndex]);

sett.Mutshance:=strtoint(MutShanceBox.Items[MutshanceBox.ItemIndex]);
sett.MutPower:=strtoint(MutPowerBox.Items[MutPowerBox.ItemIndex]);

//MainForm.T1.Interval:=round(1000/strtoint(AnimSpeedBox.Items[AnimSpeedBox.ItemIndex]));        //настройки анимации
sett.AnimMas:=strtofloat(AnimMasBox.Items[AnimMasBox.ItemIndex]);
if (Sender is TCombobox) then  //если поменяли масштаб, только тогда отрисовываем всех
  if (Sender as TCombobox).Name='AnimMasBox' then
    for i := 1 to sim.baccount do  bac[i].UpdateEllipse;
end;



procedure TForm2.EnergyRule1Click(Sender: TObject);
begin
sett.EnergyRule:=(Sender as TRadiobutton).Tag;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
FWindowMove := TWindowMove.Create(Self) as IWindowMove;
  FWindowMove.RegisterControl(TopPanel);
  sim.BacCount:=0;
  Form2.AnimSpeedBoxChange(self);
end;

procedure TForm2.OpacityBarChange(Sender: TObject);
begin
TabControl1.Opacity:=OpacityBar.Value;
end;

procedure TForm2.SpeedButton1Click(Sender: TObject);
begin
Form2.Hide; MainForm.Activate;
end;
end.
