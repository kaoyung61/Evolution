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
Каждый ход бактерии двигаются в рандомно выбраном направлении и их задача это найти пищу
доп: У бактерии есть 3 основных действия: поиск, следование, прием пищи. 4-е это деление на две бактерии
каждый ход энергия у каждой бактерии падает в зависимости от размера и скорости передвижения
при достижении энергии ноль бактерия умирает при достижении репродуктивной энергии делится и
                                                      отдает половину энергии своему потомку

Если энергия ниже 0 то бактерия умирает
    - двигаем весь массив на минус одно положение
Если нет, и если энергия больше энергии репликации, бактерия делится
    - создаем еще одну такую же бактерию, но с другим углом движения и двигаем массив на одно положение
Если нет, проверяем, есть ли еда в радиусе поедания, если да, едим
    - добавляем к энергии бактерии энергию еды
Если нет, проверяем, есть ли в радиусе зрения еда
    - находим до каждой расстояние и если в радиусе зрения есть, поворачиваемся туда и двигаемся
Если нет, просто двигаемся в поисках еды
    - делаем движение, возможно, немного меняем угол движения
В конце обновляем количество и положение элипсов

при движении тратится энергия согласно расстоянию (либо на сколько до еды, либо на значение скорости)
      (размер^3*расстояние^2+чувствительность)*коэф энергопотребления

}

procedure TMainForm.FormResize(Sender: TObject);
var a:byte;
begin
 //PetryPanel.Canvas.Bitmap.SetSize(Round(PetryPanel.Width), Round(PetryPanel.Height));
 //PetryPanel.Canvas.Bitmap.Clear(TAlphaColors.White);
 //Image1.Bitmap.SetSize(Round(Image1.Width), Round(Image1.Height));
 //Image1.Bitmap.Clear(TAlphaColors.White);//делаем белым поле
  //поле увеличено в "А" раз -потом сделать настройку
  a:=1;
 Sim.y:=round(PetryPanel.Height)*a; Sim.x:=round(PetryPanel.Width)*a;      //записываем какой размер у симуляции
 Menuitem4.Text:='Размер поля: '+inttostr(Sim.x)+' x '+inttostr(Sim.y);  //и выводим в менюшку}
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

procedure TMainForm.EllipceClickExecute(Sender: TObject);  //отображение информации о бактерии при нажатии
var i:integer;
begin
{i:=TEllipse(Sender).Tag;
ShowMessage(     'Бактерия     '+ #$9 +IntTostr(i)
            +#13+'Возраст      '+ #$9 +FloatTostr(bac[i].age)
            +#13+'Размер       '+ #$9 +FloatTostr(bac[i].size)
            +#13+'Скорость     '+ #$9 +FloatTostr(bac[i].speed)
            +#13+'Энергия      '+ #$9 +FloatTostr(bac[i].energy)
            +#13+'Чувство      '+ #$9 +FloatTostr(bac[i].sence)
         //   +#13+'Тратит за сим'+#$9+ floattostr(sett.kEnergy*bac[i].CountEnergy(Sett.EnergyRule, bac[i].speed) )
            );  }
end;



procedure TMainForm.T1Timer(Sender: TObject);  //каждый расчет что делаем
var i,a:integer; path:integer; // какой путь
  s:string; dob:Double;

begin
Elapsed := Stopwatch.Elapsed ;
dob:= Elapsed.TotalMilliseconds;
s:=inttostr(sol)+' сим. '+inttostr(sim.BacCount)+' бакт. Пауза: '+dob.ToString;
Stopwatch := TStopwatch.StartNew;


sol:=sol+1;
Menuitem4.Text:=inttostr(sol);
Form2.Button1Click(self);
{for i := 1 to count do if bac[i].energy<0 then delbac(i);   // если у бактерии нет энергии, то она умирает, двигаем весь массив на один
//соответственно дальнейшие расчеты только для живых, значение count обновлено в предыдущей операции

for i := 1 to count do  if bac[i].energy>=bac[i].replicenergy  then NewLife(i,sett.Mutshance, sett.MutPower);

 if Foodcount>0 then begin for i := 1 to count do if bac[i].activ then EatFood(i);    //съесть, если дотягивается
   for i := 1 to count do if bac[i].activ then SearchFood(i);end; // повернуться в сторону ближайшей, если такая есть и шагнуть
for i := 1 to count do if bac[i].activ then MoveBac(i,bac[i].speed);  //просто двигаем оставшиеся бактерии, которые ничего не сделали

//SpawnFood(FoodSpawn,FoodPower);
RedrawBacteryIMG;
//RedrawBactery;
//RedrawFood; //отрисовываем еду

//If sol mod strtoint(StatBox.Items[StatBox.ItemIndex]) =0 then RenewStatistik();

//for i := 1 to count do bac[i].activ:=true;// всем бактериям разрешаем выполнить действие в следующей симуляции

//Label5.Text:='Прошло '+inttostr(floor(sol/20))+' сол ('+ inttostr(round(sol))+ ' симуляций); Количество бактерий: '+inttostr(count);
 //если все умерли, конец симуляции, если нет- спавним еды }

Elapsed := Stopwatch.Elapsed ;
dob:= Elapsed.TotalMilliseconds;
time_end:=now();
time2:=MilliSecondsBetween(time_start, time_end);
s:=s+' Процедура: ' +dob.ToString;
Form2.logmemo.Lines.Add(s);
Form2.logmemo.ScrollBy(0, Form2.logmemo.Lines.Count);
Stopwatch := TStopwatch.StartNew;
 end;


end.
