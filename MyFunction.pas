unit MyFunction;  //юнит с самописными функциями

interface
  uses Math, EvoTypes,
   System.SysUtils, System.UITypes, FMX.Dialogs;


  function GetPath(var xBac, yBac, xFood, yFood:real):real;
  function GetAngle(var xBac, yBac, xFood, yFood:real):integer;

   procedure MoveBac(var number:integer; length:real);
   procedure SpawnBac(var number:integer; Color:TColor; Speed,Size,Sence,Energy,ReplicEnergy,X,Y:real; Angle:integer);
   procedure DelBac(var number:integer);

   procedure NewLife(var number, MutShance,MutPower:integer);
   procedure EatFood(var number:integer); //поиск еды. если рядом, съесть
   procedure SearchFood(var number:integer); //поиск еды.  если в зоне движения, поворачиваемся к ближайшей и делаем шаг

   procedure SpawnFood(var Spawn,Power:integer);    //поработать со скоростью спавна, сейчас спавн идет каждую симуляцию и отличается количеством еды в симуляцию
   procedure DelFood(var number:integer);



implementation uses Evo;







function GetPath(var xBac, yBac, xFood, yFood:real):real;   //расчет расстояния от бактерии до еды
var x,y,m:real;
begin
x:=xBac-xFood; y:=yBac-yFood;
m:=Power(x,2)+Power(y,2);
Result:=Power( m   ,0.5);
end;
                                                                 //Считает что то неправильно
function GetAngle(var xBac, yBac, xFood, yFood:real):integer;   //расчет угла от бактерии до еды
var x,y,m:real; nul:real;
begin
x:=xFood-xBac; y:=yFood-yBac; //перенос нуля в точку бактерии
 //разворачиваем систему координат - возможно тут проблема
m:=-y/GetPath(xBac, yBac, xFood, yFood);
Result:=round(   RadToDeg(   Arccos( m )   )   );     //направление еды
if x<0 then Result:=360-Result;  //если еда левее бактерии, то добавляем 180 град
end;


procedure NewLife(var number, MutShance,MutPower:integer);
var a:integer; MutSpeed,MutSize,MutSence:real;
begin
 { randomize;
  MutSpeed:=1; MutSize:=1;MutSence:=1;
   //если энергии хватает, бактерия делится, создает свою точную копию
   if MutShance>=random(99)+1 then if random(99)<50 then MutSpeed:=1+MutPower/100 else MutSpeed:=1-MutPower/100 ; // или отнять
   if MutShance>=random(99)+1 then if random(99)<50 then MutSize:=1+MutPower/100 else MutSize:=1-MutPower/100 ; // или отнять
   if MutShance>=random(99)+1 then if random(99)<50 then MutSence:=1+MutPower/100 else MutSence:=1-MutPower/100 ;

   a:=count+1;
   SpawnBac(a,bac[number].color, bac[number].speed*MutSpeed, bac[number].size*MutSize, bac[number].sence*MutSence,
                       bac[number].energy/2, bac[number].replicenergy, bac[number].pos.x, bac[number].pos.y, random(358)+1);
   bac[number].energy:=bac[number].energy/2;  //остается половина енергии
   bac[number].activ:=false;  //активность на нуле, дальше бактерия не выполняет в этой симуляции никаких действий
        //увеличивать количество не надо, оно в спавнбактерии уже есть  }

end;




procedure EatFood(var number:integer); //поиск еды. если рядом, съесть
var i:integer; FoundFood:array[1..1000] of real;
    FoodNear:integer; // номер ближайшей еды
begin
// мы просто просчитываем всю еду и находим расстояние до нее.
// затем находим ближайшую и если расстояние в пределах съедания, едим       //по непонятной причине когда заканчивается еда, все ее съедают
 { if Foodcount>0 then begin
 for i := 1 to FoodCount do FoundFood[i]:=GetPath(bac[number].pos.x, bac[number].pos.y, food[i].pos.x,Food[i].pos.y);
 FoodNear:=1;
 for i := 1 to FoodCount do if FoundFood[i]<FoundFood[FoodNear] then FoodNear:=i;  //находим ближайшую
 if FoundFood[FoodNear]<bac[number].size*kRadEat  //если ближайшую еду можно съесть c учетом общего коэф
    then  begin                                  //то едим
    bac[number].energy:=bac[number].energy+food[Foodnear].energy;
    //bac[number].NearFood:=0;
    bac[number].activ:=false;  //исключаемся из списка
    DelFood(Foodnear);
    end;      // удвляем еду
   end;}
end;

procedure SearchFood(var number:integer); //поиск еды конкретной бактерией. если в зоне движения, поворачиваемся к ближайшей и делаем шаг

var i:integer; FoundFood:array[1..1000] of real; //расстояние доеды
    FoodNear:integer; // номер ближайшей еды
    way:real; //какой шаг делает в сторону еды
begin
// мы просто просчитываем всю еду и находим расстояние до нее.
// если есть в пределах видимости, поворачиваемся и делаем к ней шаг
 { if Foodcount>0 then begin
 for i := 1 to FoodCount do FoundFood[i]:=GetPath(bac[number].pos.x, bac[number].pos.y, Food[i].pos.x,Food[i].pos.y);
 FoodNear:=1;
 for i := 1 to FoodCount do if FoundFood[i]<FoundFood[FoodNear] then FoodNear:=i;  //находим ближайшую
 if FoundFood[FoodNear]<bac[number].sence*kRadSence*bac[number].size then   //если в зоне видимости есть еда
    begin
    bac[number].NearFood:=FoodNear;
    bac[number].angle:=GetAngle(bac[number].pos.x, bac[number].pos.y, food[FoodNear].pos.x,Food[FoodNear].pos.y); //поворачиваем в сторону еды
    if FoundFood[FoodNear]<bac[number].speed then way:=FoundFood[FoodNear] else way:=bac[number].speed; //находим расстояние
    MoveBac(number,way);    //прыгаем
    bac[number].activ:=false;
    end;
  end; }
end;



procedure SpawnFood(var Spawn,Power:integer);
var i:integer;
begin
 {If (foodcount<900) then for i := 1 to Spawn do begin
                        FoodCount:=FoodCount+1;  //добавляем одну еду и будем вписывать в последнюю ячейку
                        food[FoodCount].pos.x:=26+random(round(Petry.x)-51); //создаем ее координаты
                        food[FoodCount].pos.y:=26+random(round(Petry.y)-51);
                        food[FoodCount].energy:=Power;                                  // и даем ей силу
                        end; }
end;

procedure DelFood(var number:integer); // просто удаление кусочка еды
var i:integer;
begin
//FoodCount:=FoodCount-1;// уменьшаем общее количество еды на поле на один
//for i := number to FoodCount do food[i]:=food[i+1]; //двигаем весь массив на один влево
end;






procedure MoveBac(var number:integer; length:real); //Расчет нового положения бактерии и отнимание энергии
var vx,vy:real;
begin
{   // проверяем если дошла до края то разворачиваем
  if (bac[number].pos.y<20) then  begin bac[number].pos.y:=30; bac[number].angle:=180-bac[number].angle; end;
  if (bac[number].pos.y>Petry.y-20) then  begin bac[number].pos.y:=Petry.y-30; bac[number].angle:=180-bac[number].angle; end;

  if (bac[number].pos.x<20) then begin bac[number].pos.x:=30; bac[number].angle:= 360-bac[number].angle; end;
  if (bac[number].pos.x>Petry.x-20) then begin bac[number].pos.x:=Petry.x-30; bac[number].angle:= 360-bac[number].angle; end;
  // двигаем каждую бактерию
  vx:=length*sin(bac[number].angle*PI/180);
  bac[number].pos.x:=bac[number].pos.x+vx;
  vy:=-1*length*cos(bac[number].angle*PI/180);
  bac[number].pos.y:=bac[number].pos.y+vy;
  bac[number].energy:=bac[number].energy-kEnergy*Energystep(number);}
end;


procedure SpawnBac(var number:integer; Color:TColor; Speed,Size,Sence,Energy,ReplicEnergy,X,Y:real; Angle:integer);
begin
 {   // number- это на какое место ставим бактерию. В случае деления ставим на предыдущее, следующее место или в конец.
    // если ставить в конец, то тогда у нее есть шанс двинуться или что нибудь сделать в момент своего рождения - сделать проверку на возраст
    // так как обработчик ее тоже проверит в конце
    bac[number].age:=0; bac[number].activ:=false;  // она только родилась, она сделала свое действие
    bac[number].speed:=Speed;       bac[number].size:=Size;
    bac[number].sence:=Sence;       bac[number].color:=Color;
    bac[number].energy:=Energy;     bac[number].replicenergy:=ReplicEnergy;
    bac[number].pos.x:=X;           bac[number].pos.y:=Y;     bac[number].angle:=Angle;
    count:=count+1;      // увеличиваем количество бактерий на один   }
end;


procedure DelBac(var number:integer);  //удаление конкретной бактерии
var i,a:integer; //d:TBactery;
begin
//for i := number to count-1 do bac[i]:=bac[i+1]; //двигаем весь массив на один влево
//count:=count-1;// уменьшаем общее количество бактерий на один
end;





end.
