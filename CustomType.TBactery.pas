unit CustomType.TBactery;

interface

uses   Math,
      System.UITypes, System.Types, System.Math.Vectors,
      FMX.Objects, FMX.Graphics,FMX.Dialogs;

type
  TBacteryInfo=record
    age:word;            //возраст бактерии - сколько симуляций прожила бактерия - возможно от этого откажемся
  	color:TAlphaColor;       // цвет бактерии
    size,          // размер бактерии - длина в точках
    speed,         //скорость движения  - сколько точек проходит за симуляцию
    sence,          //чувствительность, количество радиусов размера бактерии
    energy,        //сколько есть энергии в данный момент времени
    x,y:single;
    angle:integer;  //где находится бактерия и ее направление движения
  end;

  TBactery=record
    activ:boolean; // может ли бактерия выполнить какое либо действие
    alive:Boolean; //жива ли бактерия
    inf:TBacteryInfo;   //данные о бактерии
    ellipse:TEllipse;  //эллипс бактерии     Отображение бактерии


    function Mutation:TBacteryInfo;       //получаем данные мутировавшей бактерии
    procedure Write(BacteryInfo:TBacteryInfo); //процедура простой записи в ячейку памяти свойств бактерии
    procedure Born; // рождение, активная бактерия-родитель. потомок идет в конец списка
    procedure Die; //смерть, активная бактерия умирает, все двигаются на один пункт. ее данные уходят в конец массива, эллипс скрывается

    function CountEnergy(var EnergyRule:byte;Way:single):single;



	// процедуры отрисовки
	procedure CheckEllipse; //процедура проверки, существует ли эллипс, если нет, то создаем, если да, Update.
  procedure CreateEllipse; //Эллипс создается с размерами бактерии
  procedure UpdateEllipse; //обновляется цвет, размер, положение. эллипс становится видимым - еще хорошо для смены масштаба отображения

  procedure MoveEllipse; //устанавливаем координаты эллипса и направление зрения в соответствиии с данными бактерии
	procedure ChangeColor(Color:TAlphaColor);//обновляем цвет бактерии и эллипса - нужно при переходе бактерии в новую колонию

	procedure ShowEllipse;
	procedure HideEllipse;

	function GetPolygon(points:byte):TPolygon; //определение полигона. Points - насколько он гладок

  end;



  implementation  uses  EvoTypes, evo, AddBac;


function TBactery.Mutation:TBacteryInfo;
var MutSpeed,MutSize,MutSence:Single;
begin
 randomize;
  MutSpeed:=1; MutSize:=1;MutSence:=1;
// сначала проверяем, будет ли вообще мутация каждого из признаков в отдельности
   if Sett.MutShance>=random(99)+1 then if random(99)<49 then MutSpeed:=1+Sett.MutPower/100 else MutSpeed:=1-Sett.MutPower/100 ; // или отнять
   if Sett.MutShance>=random(99)+1 then if random(99)<49 then MutSize:=1+Sett.MutPower/100 else MutSize:=1-Sett.MutPower/100 ; // или отнять
   if Sett.MutShance>=random(99)+1 then if random(99)<49 then MutSence:=1+Sett.MutPower/100 else MutSence:=1-Sett.MutPower/100 ;

   Result:=TBactery(self).inf;//в результат записывается сама бактерия
   Result.speed:=Result.speed*MutSpeed;     //и переопределяются мутировавшие значения
   Result.size:=Result.size*MutSize;
   Result.sence:=Result.sence*MutSence;
end;


procedure TBactery.Write( BacteryInfo:TBacteryInfo);   //суть в записи всех данных мастера в ячейку памяти
begin                                                  //бесполезная функция по сути.
 tBactery(self).inf:=BacteryInfo;
 tBactery(self).inf.Age:=0;
end;

procedure TBactery.Born; // процесс рождения от этой бактерии
begin
  Inc(sim.BacCount); //увеличиваем на один
  bac[sim.BacCount].write(tBactery(self).Mutation);//в нее записываем мутировавшие значения нашей бактерии
  bac[sim.BacCount].CheckEllipse;
end;

 procedure TBactery.Die;
 begin
 TBactery(self).HideEllipse; //сразу скрываем эллипс
 {смерть бактерии. Первая часть- исключить из списка затерев ее информацию, но сохранив созданый эллипс
 как вариант- убрать бактерию в конец списка, а на ее место поставить последнюю, чтобы не двигать
 как вариант- менять местами с последней и уменьшать количество бактерий на единицу.
 но тогда }
 end;

function TBactery.CountEnergy(var EnergyRule:byte; Way:single):single;
 begin
   case EnergyRule of
  1: Result:=Power(TBactery(self).inf.size,3)/1000*Power(Way,2)/100;
  2: Result:=Power(TBactery(self).inf.size/10,3)*Power(Way,2)/100+0.5*TBactery(self).inf.size/10*TBactery(self).inf.sence/10;
  3: Result:=Power(TBactery(self).inf.size/10,2)*Power(Way/10,2);
  4: Result:=Power(TBactery(self).inf.size/10,3)*Way/10;
  5: Result:=Power(TBactery(self).inf.size/10,2)*Way/10;
  else Form2.logmemo.lines.add('Ошибка вычисления Энергии');
  end;
 end;


procedure TBactery.CheckEllipse;
begin
{Используется только при создании/рождении бактерии, для того чтобы понять, нодо создавать эллипс или нет }
If Assigned(TBactery(self).ellipse) //если эллипс не существует- создаем, если есть- обновляем размер и цвет в соответствии с данными
  then tBactery(self).UpdateEllipse    else TBactery(self).CreateEllipse;
end;



procedure TBactery.CreateEllipse;
begin
  TBactery(self).Ellipse:=TEllipse.Create(MainForm.PetryPanel);
  TBactery(self).ellipse.Parent:= MainForm.PetryPanel;
 with  TBactery(self).Ellipse do begin
  Fill.Kind:= TBrushKind.Gradient;//отрисовка градиента кругового со смещением
  Fill.Gradient.Color:=TBactery(self).inf.Color;
  Height:=TBactery(self).inf.size*sett.AnimMas ; Width:=TBactery(self).inf.size/2*sett.AnimMas ;
  Position.X:= TBactery(self).inf.X;  Position.Y:= TBactery(self).inf.Y;
  RotationAngle:= TBactery(self).inf.angle;
  end;

end;

procedure tBactery.UpdateEllipse ;
begin
with tBactery(self).ellipse do begin            //приводим размеры к правильным
 Height:=TBactery(self).inf.size*sett.AnimMas ;
 Width:=TBactery(self).inf.size/2*sett.AnimMas;
 Fill.Color:=tBactery(self).inf.Color; end;    // и цвет
 tBactery(self).MoveEllipse; //распологаем в нужном месте
 tBactery(self).ShowEllipse;//этот элипс теперь отображаем
end;



procedure TBactery.ShowEllipse; begin TBactery(self).Ellipse.Visible:=true; end;
procedure TBactery.HideEllipse; begin TBactery(self).Ellipse.Visible:=false; end;

procedure TBactery.MoveEllipse;
begin
TBactery(self).Ellipse.Position.X:=TBactery(self).inf.X ;
TBactery(self).Ellipse.Position.Y:=TBactery(self).inf.Y;
TBactery(self).Ellipse.RotationAngle:=TBactery(self).inf.Angle;
end;

procedure TBactery.ChangeColor(Color:TAlphaColor); //смена цвета бактерии и сразу эллипса
begin
TBactery(self).Ellipse.Fill.Color:=Color; TBactery(self).inf.Color:=Color;
end;







function TBactery.GetPolygon(points:byte):TPolygon;
//идея в том, что на канве отрисовывается бактерия, это жрет меньше ресурсов.в теории
// возможно расчет поворота эллипса будет прожорлив, но не попытавшись невозможно определить

var i:integer;X0,Y0,Rad:single;
begin
 //этим определяется качество отрисовки, насколько большой полигон
SetLength(Result, points);
for i := 0 to points-1 do
  begin
 Rad:=i*(2*pi/points);  //считаем радианы просчитываемой точки в положении до поворота
 X0:=TBactery(Self).inf.Size*cos(Rad)*Sett.AnimMas;
 Y0:=TBactery(Self).inf.Size*sin(Rad)/2*Sett.AnimMas;
 Rad:=TBactery(Self).inf.Angle*pi/180;
 Result[i].X:=x0*cos(Rad)-y0*sin(Rad)+TBactery(Self).inf.X;    //получаем координаты точки, повернутой на определенный угол относительно 0,0
 Result[i].Y:=x0*sin(Rad)+y0*cos(Rad)+TBactery(Self).inf.Y;    // и прибавляем координаты центра

 end;//рассчет точек полигона
{Bitmap.Canvas.Fill.Color := TBactery(Self).color; //собственно отрисовка
Bitmap.Canvas.DrawPolygon(MyPolygon, 50);
Bitmap.Canvas.FillPolygon(MyPolygon, 50);}

end;

end.
