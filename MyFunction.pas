unit MyFunction;  //���� � ����������� ���������

interface
  uses Math, EvoTypes,
   System.SysUtils, System.UITypes, FMX.Dialogs;


  function GetPath(var xBac, yBac, xFood, yFood:real):real;
  function GetAngle(var xBac, yBac, xFood, yFood:real):integer;

   procedure MoveBac(var number:integer; length:real);
   procedure SpawnBac(var number:integer; Color:TColor; Speed,Size,Sence,Energy,ReplicEnergy,X,Y:real; Angle:integer);
   procedure DelBac(var number:integer);

   procedure NewLife(var number, MutShance,MutPower:integer);
   procedure EatFood(var number:integer); //����� ���. ���� �����, ������
   procedure SearchFood(var number:integer); //����� ���.  ���� � ���� ��������, �������������� � ��������� � ������ ���

   procedure SpawnFood(var Spawn,Power:integer);    //���������� �� ��������� ������, ������ ����� ���� ������ ��������� � ���������� ����������� ��� � ���������
   procedure DelFood(var number:integer);



implementation uses Evo;







function GetPath(var xBac, yBac, xFood, yFood:real):real;   //������ ���������� �� �������� �� ���
var x,y,m:real;
begin
x:=xBac-xFood; y:=yBac-yFood;
m:=Power(x,2)+Power(y,2);
Result:=Power( m   ,0.5);
end;
                                                                 //������� ��� �� �����������
function GetAngle(var xBac, yBac, xFood, yFood:real):integer;   //������ ���� �� �������� �� ���
var x,y,m:real; nul:real;
begin
x:=xFood-xBac; y:=yFood-yBac; //������� ���� � ����� ��������
 //������������� ������� ��������� - �������� ��� ��������
m:=-y/GetPath(xBac, yBac, xFood, yFood);
Result:=round(   RadToDeg(   Arccos( m )   )   );     //����������� ���
if x<0 then Result:=360-Result;  //���� ��� ����� ��������, �� ��������� 180 ����
end;


procedure NewLife(var number, MutShance,MutPower:integer);
var a:integer; MutSpeed,MutSize,MutSence:real;
begin
 { randomize;
  MutSpeed:=1; MutSize:=1;MutSence:=1;
   //���� ������� �������, �������� �������, ������� ���� ������ �����
   if MutShance>=random(99)+1 then if random(99)<50 then MutSpeed:=1+MutPower/100 else MutSpeed:=1-MutPower/100 ; // ��� ������
   if MutShance>=random(99)+1 then if random(99)<50 then MutSize:=1+MutPower/100 else MutSize:=1-MutPower/100 ; // ��� ������
   if MutShance>=random(99)+1 then if random(99)<50 then MutSence:=1+MutPower/100 else MutSence:=1-MutPower/100 ;

   a:=count+1;
   SpawnBac(a,bac[number].color, bac[number].speed*MutSpeed, bac[number].size*MutSize, bac[number].sence*MutSence,
                       bac[number].energy/2, bac[number].replicenergy, bac[number].pos.x, bac[number].pos.y, random(358)+1);
   bac[number].energy:=bac[number].energy/2;  //�������� �������� �������
   bac[number].activ:=false;  //���������� �� ����, ������ �������� �� ��������� � ���� ��������� ������� ��������
        //����������� ���������� �� ����, ��� � ������������� ��� ����  }

end;




procedure EatFood(var number:integer); //����� ���. ���� �����, ������
var i:integer; FoundFood:array[1..1000] of real;
    FoodNear:integer; // ����� ��������� ���
begin
// �� ������ ������������ ��� ��� � ������� ���������� �� ���.
// ����� ������� ��������� � ���� ���������� � �������� ��������, ����       //�� ���������� ������� ����� ������������� ���, ��� �� �������
 { if Foodcount>0 then begin
 for i := 1 to FoodCount do FoundFood[i]:=GetPath(bac[number].pos.x, bac[number].pos.y, food[i].pos.x,Food[i].pos.y);
 FoodNear:=1;
 for i := 1 to FoodCount do if FoundFood[i]<FoundFood[FoodNear] then FoodNear:=i;  //������� ���������
 if FoundFood[FoodNear]<bac[number].size*kRadEat  //���� ��������� ��� ����� ������ c ������ ������ ����
    then  begin                                  //�� ����
    bac[number].energy:=bac[number].energy+food[Foodnear].energy;
    //bac[number].NearFood:=0;
    bac[number].activ:=false;  //����������� �� ������
    DelFood(Foodnear);
    end;      // ������� ���
   end;}
end;

procedure SearchFood(var number:integer); //����� ��� ���������� ���������. ���� � ���� ��������, �������������� � ��������� � ������ ���

var i:integer; FoundFood:array[1..1000] of real; //���������� �����
    FoodNear:integer; // ����� ��������� ���
    way:real; //����� ��� ������ � ������� ���
begin
// �� ������ ������������ ��� ��� � ������� ���������� �� ���.
// ���� ���� � �������� ���������, �������������� � ������ � ��� ���
 { if Foodcount>0 then begin
 for i := 1 to FoodCount do FoundFood[i]:=GetPath(bac[number].pos.x, bac[number].pos.y, Food[i].pos.x,Food[i].pos.y);
 FoodNear:=1;
 for i := 1 to FoodCount do if FoundFood[i]<FoundFood[FoodNear] then FoodNear:=i;  //������� ���������
 if FoundFood[FoodNear]<bac[number].sence*kRadSence*bac[number].size then   //���� � ���� ��������� ���� ���
    begin
    bac[number].NearFood:=FoodNear;
    bac[number].angle:=GetAngle(bac[number].pos.x, bac[number].pos.y, food[FoodNear].pos.x,Food[FoodNear].pos.y); //������������ � ������� ���
    if FoundFood[FoodNear]<bac[number].speed then way:=FoundFood[FoodNear] else way:=bac[number].speed; //������� ����������
    MoveBac(number,way);    //�������
    bac[number].activ:=false;
    end;
  end; }
end;



procedure SpawnFood(var Spawn,Power:integer);
var i:integer;
begin
 {If (foodcount<900) then for i := 1 to Spawn do begin
                        FoodCount:=FoodCount+1;  //��������� ���� ��� � ����� ��������� � ��������� ������
                        food[FoodCount].pos.x:=26+random(round(Petry.x)-51); //������� �� ����������
                        food[FoodCount].pos.y:=26+random(round(Petry.y)-51);
                        food[FoodCount].energy:=Power;                                  // � ���� �� ����
                        end; }
end;

procedure DelFood(var number:integer); // ������ �������� ������� ���
var i:integer;
begin
//FoodCount:=FoodCount-1;// ��������� ����� ���������� ��� �� ���� �� ����
//for i := number to FoodCount do food[i]:=food[i+1]; //������� ���� ������ �� ���� �����
end;






procedure MoveBac(var number:integer; length:real); //������ ������ ��������� �������� � ��������� �������
var vx,vy:real;
begin
{   // ��������� ���� ����� �� ���� �� �������������
  if (bac[number].pos.y<20) then  begin bac[number].pos.y:=30; bac[number].angle:=180-bac[number].angle; end;
  if (bac[number].pos.y>Petry.y-20) then  begin bac[number].pos.y:=Petry.y-30; bac[number].angle:=180-bac[number].angle; end;

  if (bac[number].pos.x<20) then begin bac[number].pos.x:=30; bac[number].angle:= 360-bac[number].angle; end;
  if (bac[number].pos.x>Petry.x-20) then begin bac[number].pos.x:=Petry.x-30; bac[number].angle:= 360-bac[number].angle; end;
  // ������� ������ ��������
  vx:=length*sin(bac[number].angle*PI/180);
  bac[number].pos.x:=bac[number].pos.x+vx;
  vy:=-1*length*cos(bac[number].angle*PI/180);
  bac[number].pos.y:=bac[number].pos.y+vy;
  bac[number].energy:=bac[number].energy-kEnergy*Energystep(number);}
end;


procedure SpawnBac(var number:integer; Color:TColor; Speed,Size,Sence,Energy,ReplicEnergy,X,Y:real; Angle:integer);
begin
 {   // number- ��� �� ����� ����� ������ ��������. � ������ ������� ������ �� ����������, ��������� ����� ��� � �����.
    // ���� ������� � �����, �� ����� � ��� ���� ���� ��������� ��� ��� ������ ������� � ������ ������ �������� - ������� �������� �� �������
    // ��� ��� ���������� �� ���� �������� � �����
    bac[number].age:=0; bac[number].activ:=false;  // ��� ������ ��������, ��� ������� ���� ��������
    bac[number].speed:=Speed;       bac[number].size:=Size;
    bac[number].sence:=Sence;       bac[number].color:=Color;
    bac[number].energy:=Energy;     bac[number].replicenergy:=ReplicEnergy;
    bac[number].pos.x:=X;           bac[number].pos.y:=Y;     bac[number].angle:=Angle;
    count:=count+1;      // ����������� ���������� �������� �� ����   }
end;


procedure DelBac(var number:integer);  //�������� ���������� ��������
var i,a:integer; //d:TBactery;
begin
//for i := number to count-1 do bac[i]:=bac[i+1]; //������� ���� ������ �� ���� �����
//count:=count-1;// ��������� ����� ���������� �������� �� ����
end;





end.
