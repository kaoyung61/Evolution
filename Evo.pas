unit Evo;

interface

uses  Math, {MyFunction,} ReDrawUnit, EvoTypes, StatUnit,
   AddBac,
  DateUtils,         System.Diagnostics,System.TimeSpan,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, System.Actions, FMX.ActnList, FMX.Edit,
  FMX.ListBox, FMX.Colors, FMX.Menus, FMX.Layouts, FMXTee.Engine, FMXTee.Series,
  FMXTee.Procs, FMXTee.Chart, FMX.TabControl, FMX.ScrollBox, FMX.Memo;

type
  TMainForm = class(TForm)
    PetryPanel: TPanel;
    T1: TTimer;
    ActionList1: TActionList;
    EllipceClick: TAction;
    UpdateSimK: TAction;
    RedrawMuster: TAction;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    procedure T1Timer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure EllipceClickExecute(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);


  private

    { Private declarations }
  public
    { Public declarations }

  end;

var
   MainForm: TMainForm;
   time_start,time_end:TDateTime; time1,time2:word;
     Stopwatch: TStopwatch;
  Elapsed: TTimeSpan;
implementation

{$R *.fmx}
{
������ ��� �������� ��������� � �������� �������� ����������� � �� ������ ��� ����� ����
���: � �������� ���� 3 �������� ��������: �����, ����������, ����� ����. 4-� ��� ������� �� ��� ��������
������ ��� ������� � ������ �������� ������ � ����������� �� ������� � �������� ������������
��� ���������� ������� ���� �������� ������� ��� ���������� �������������� ������� ������� �
                                                      ������ �������� ������� ������ �������

���� ������� ���� 0 �� �������� �������
    - ������� ���� ������ �� ����� ���� ���������
���� ���, � ���� ������� ������ ������� ����������, �������� �������
    - ������� ��� ���� ����� �� ��������, �� � ������ ����� �������� � ������� ������ �� ���� ���������
���� ���, ���������, ���� �� ��� � ������� ��������, ���� ��, ����
    - ��������� � ������� �������� ������� ���
���� ���, ���������, ���� �� � ������� ������ ���
    - ������� �� ������ ���������� � ���� � ������� ������ ����, �������������� ���� � ���������
���� ���, ������ ��������� � ������� ���
    - ������ ��������, ��������, ������� ������ ���� ��������
� ����� ��������� ���������� � ��������� �������

��� �������� �������� ������� �������� ���������� (���� �� ������� �� ���, ���� �� �������� ��������)
      (������^3*����������^2+����������������)*���� �����������������

}

procedure TMainForm.FormResize(Sender: TObject);
var a:byte;
begin
 //PetryPanel.Canvas.Bitmap.SetSize(Round(PetryPanel.Width), Round(PetryPanel.Height));
 //PetryPanel.Canvas.Bitmap.Clear(TAlphaColors.White);
 //Image1.Bitmap.SetSize(Round(Image1.Width), Round(Image1.Height));
 //Image1.Bitmap.Clear(TAlphaColors.White);//������ ����� ����
  //���� ��������� � "�" ��� -����� ������� ���������
  a:=1;
 Sim.y:=round(PetryPanel.Height)*a; Sim.x:=round(PetryPanel.Width)*a;      //���������� ����� ������ � ���������
 Menuitem4.Text:='������ ����: '+inttostr(Sim.x)+' x '+inttostr(Sim.y);  //� ������� � �������}
end;

procedure TMainForm.MenuItem1Click(Sender: TObject);
begin
 Form2.Show;
end;


procedure TMainForm.MenuItem2Click(Sender: TObject);
begin
T1.Enabled:=true;
end;

procedure TMainForm.MenuItem3Click(Sender: TObject);
begin
T1.Enabled:=false;
end;

procedure TMainForm.EllipceClickExecute(Sender: TObject);  //����������� ���������� � �������� ��� �������
var i:integer;
begin
{i:=TEllipse(Sender).Tag;
ShowMessage(     '��������     '+ #$9 +IntTostr(i)
            +#13+'�������      '+ #$9 +FloatTostr(bac[i].age)
            +#13+'������       '+ #$9 +FloatTostr(bac[i].size)
            +#13+'��������     '+ #$9 +FloatTostr(bac[i].speed)
            +#13+'�������      '+ #$9 +FloatTostr(bac[i].energy)
            +#13+'�������      '+ #$9 +FloatTostr(bac[i].sence)
         //   +#13+'������ �� ���'+#$9+ floattostr(sett.kEnergy*bac[i].CountEnergy(Sett.EnergyRule, bac[i].speed) )
            );  }
end;



procedure TMainForm.T1Timer(Sender: TObject);  //������ ������ ��� ������
var i,a:integer; path:integer; // ����� ����
  s:string; dob:Double;

begin
Elapsed := Stopwatch.Elapsed ;
dob:= Elapsed.TotalMilliseconds;
s:=inttostr(sol)+' ���. '+inttostr(sim.BacCount)+' ����. �����: '+dob.ToString;
Stopwatch := TStopwatch.StartNew;


sol:=sol+1;
Menuitem4.Text:=inttostr(sol);
Form2.Button1Click(self);
{for i := 1 to count do if bac[i].energy<0 then delbac(i);   // ���� � �������� ��� �������, �� ��� �������, ������� ���� ������ �� ����
//�������������� ���������� ������� ������ ��� �����, �������� count ��������� � ���������� ��������

for i := 1 to count do  if bac[i].energy>=bac[i].replicenergy  then NewLife(i,sett.Mutshance, sett.MutPower);

 if Foodcount>0 then begin for i := 1 to count do if bac[i].activ then EatFood(i);    //������, ���� ������������
   for i := 1 to count do if bac[i].activ then SearchFood(i);end; // ����������� � ������� ���������, ���� ����� ���� � �������
for i := 1 to count do if bac[i].activ then MoveBac(i,bac[i].speed);  //������ ������� ���������� ��������, ������� ������ �� �������

//SpawnFood(FoodSpawn,FoodPower);
RedrawBacteryIMG;
//RedrawBactery;
//RedrawFood; //������������ ���

//If sol mod strtoint(StatBox.Items[StatBox.ItemIndex]) =0 then RenewStatistik();

//for i := 1 to count do bac[i].activ:=true;// ���� ��������� ��������� ��������� �������� � ��������� ���������

//Label5.Text:='������ '+inttostr(floor(sol/20))+' ��� ('+ inttostr(round(sol))+ ' ���������); ���������� ��������: '+inttostr(count);
 //���� ��� ������, ����� ���������, ���� ���- ������� ��� }

Elapsed := Stopwatch.Elapsed ;
dob:= Elapsed.TotalMilliseconds;
time_end:=now();
time2:=MilliSecondsBetween(time_start, time_end);
s:=s+' ���������: ' +dob.ToString;
Form2.logmemo.Lines.Add(s);
Form2.logmemo.ScrollBy(0, Form2.logmemo.Lines.Count);
Stopwatch := TStopwatch.StartNew;
 end;


end.
