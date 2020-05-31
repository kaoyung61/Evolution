unit CustomType.TBactery;

interface

uses   Math,
      System.UITypes, System.Types, System.Math.Vectors,
      FMX.Objects, FMX.Graphics,FMX.Dialogs;

type
  TBacteryInfo=record
    age:word;            //������� �������� - ������� ��������� ������� �������� - �������� �� ����� ���������
  	color:TAlphaColor;       // ���� ��������
    size,          // ������ �������� - ����� � ������
    speed,         //�������� ��������  - ������� ����� �������� �� ���������
    sence,          //����������������, ���������� �������� ������� ��������
    energy,        //������� ���� ������� � ������ ������ �������
    x,y:single;
    angle:integer;  //��� ��������� �������� � �� ����������� ��������
  end;

  TBactery=record
    activ:boolean; // ����� �� �������� ��������� ����� ���� ��������
    alive:Boolean; //���� �� ��������
    inf:TBacteryInfo;   //������ � ��������
    ellipse:TEllipse;  //������ ��������     ����������� ��������


    function Mutation:TBacteryInfo;       //�������� ������ ������������ ��������
    procedure Write(BacteryInfo:TBacteryInfo); //��������� ������� ������ � ������ ������ ������� ��������
    procedure Born; // ��������, �������� ��������-��������. ������� ���� � ����� ������
    procedure Die; //������, �������� �������� �������, ��� ��������� �� ���� �����. �� ������ ������ � ����� �������, ������ ����������

    function CountEnergy(var EnergyRule:byte;Way:single):single;



	// ��������� ���������
	procedure CheckEllipse; //��������� ��������, ���������� �� ������, ���� ���, �� �������, ���� ��, Update.
  procedure CreateEllipse; //������ ��������� � ��������� ��������
  procedure UpdateEllipse; //����������� ����, ������, ���������. ������ ���������� ������� - ��� ������ ��� ����� �������� �����������

  procedure MoveEllipse; //������������� ���������� ������� � ����������� ������ � ������������� � ������� ��������
	procedure ChangeColor(Color:TAlphaColor);//��������� ���� �������� � ������� - ����� ��� �������� �������� � ����� �������

	procedure ShowEllipse;
	procedure HideEllipse;

	function GetPolygon(points:byte):TPolygon; //����������� ��������. Points - ��������� �� ������

  end;



  implementation  uses  EvoTypes, evo, AddBac;


function TBactery.Mutation:TBacteryInfo;
var MutSpeed,MutSize,MutSence:Single;
begin
 randomize;
  MutSpeed:=1; MutSize:=1;MutSence:=1;
// ������� ���������, ����� �� ������ ������� ������� �� ��������� � �����������
   if Sett.MutShance>=random(99)+1 then if random(99)<49 then MutSpeed:=1+Sett.MutPower/100 else MutSpeed:=1-Sett.MutPower/100 ; // ��� ������
   if Sett.MutShance>=random(99)+1 then if random(99)<49 then MutSize:=1+Sett.MutPower/100 else MutSize:=1-Sett.MutPower/100 ; // ��� ������
   if Sett.MutShance>=random(99)+1 then if random(99)<49 then MutSence:=1+Sett.MutPower/100 else MutSence:=1-Sett.MutPower/100 ;

   Result:=TBactery(self).inf;//� ��������� ������������ ���� ��������
   Result.speed:=Result.speed*MutSpeed;     //� ���������������� ������������ ��������
   Result.size:=Result.size*MutSize;
   Result.sence:=Result.sence*MutSence;
end;


procedure TBactery.Write( BacteryInfo:TBacteryInfo);   //���� � ������ ���� ������ ������� � ������ ������
begin                                                  //����������� ������� �� ����.
 tBactery(self).inf:=BacteryInfo;
 tBactery(self).inf.Age:=0;
end;

procedure TBactery.Born; // ������� �������� �� ���� ��������
begin
  Inc(sim.BacCount); //����������� �� ����
  bac[sim.BacCount].write(tBactery(self).Mutation);//� ��� ���������� ������������ �������� ����� ��������
  bac[sim.BacCount].CheckEllipse;
end;

 procedure TBactery.Die;
 begin
 TBactery(self).HideEllipse; //����� �������� ������
 {������ ��������. ������ �����- ��������� �� ������ ������� �� ����������, �� �������� �������� ������
 ��� �������- ������ �������� � ����� ������, � �� �� ����� ��������� ���������, ����� �� �������
 ��� �������- ������ ������� � ��������� � ��������� ���������� �������� �� �������.
 �� ����� }
 end;

function TBactery.CountEnergy(var EnergyRule:byte; Way:single):single;
 begin
   case EnergyRule of
  1: Result:=Power(TBactery(self).inf.size,3)/1000*Power(Way,2)/100;
  2: Result:=Power(TBactery(self).inf.size/10,3)*Power(Way,2)/100+0.5*TBactery(self).inf.size/10*TBactery(self).inf.sence/10;
  3: Result:=Power(TBactery(self).inf.size/10,2)*Power(Way/10,2);
  4: Result:=Power(TBactery(self).inf.size/10,3)*Way/10;
  5: Result:=Power(TBactery(self).inf.size/10,2)*Way/10;
  else Form2.logmemo.lines.add('������ ���������� �������');
  end;
 end;


procedure TBactery.CheckEllipse;
begin
{������������ ������ ��� ��������/�������� ��������, ��� ���� ����� ������, ���� ��������� ������ ��� ��� }
If Assigned(TBactery(self).ellipse) //���� ������ �� ����������- �������, ���� ����- ��������� ������ � ���� � ������������ � �������
  then tBactery(self).UpdateEllipse    else TBactery(self).CreateEllipse;
end;



procedure TBactery.CreateEllipse;
begin
  TBactery(self).Ellipse:=TEllipse.Create(MainForm.PetryPanel);
  TBactery(self).ellipse.Parent:= MainForm.PetryPanel;
 with  TBactery(self).Ellipse do begin
  Fill.Kind:= TBrushKind.Gradient;//��������� ��������� ��������� �� ���������
  Fill.Gradient.Color:=TBactery(self).inf.Color;
  Height:=TBactery(self).inf.size*sett.AnimMas ; Width:=TBactery(self).inf.size/2*sett.AnimMas ;
  Position.X:= TBactery(self).inf.X;  Position.Y:= TBactery(self).inf.Y;
  RotationAngle:= TBactery(self).inf.angle;
  end;

end;

procedure tBactery.UpdateEllipse ;
begin
with tBactery(self).ellipse do begin            //�������� ������� � ����������
 Height:=TBactery(self).inf.size*sett.AnimMas ;
 Width:=TBactery(self).inf.size/2*sett.AnimMas;
 Fill.Color:=tBactery(self).inf.Color; end;    // � ����
 tBactery(self).MoveEllipse; //����������� � ������ �����
 tBactery(self).ShowEllipse;//���� ����� ������ ����������
end;



procedure TBactery.ShowEllipse; begin TBactery(self).Ellipse.Visible:=true; end;
procedure TBactery.HideEllipse; begin TBactery(self).Ellipse.Visible:=false; end;

procedure TBactery.MoveEllipse;
begin
TBactery(self).Ellipse.Position.X:=TBactery(self).inf.X ;
TBactery(self).Ellipse.Position.Y:=TBactery(self).inf.Y;
TBactery(self).Ellipse.RotationAngle:=TBactery(self).inf.Angle;
end;

procedure TBactery.ChangeColor(Color:TAlphaColor); //����� ����� �������� � ����� �������
begin
TBactery(self).Ellipse.Fill.Color:=Color; TBactery(self).inf.Color:=Color;
end;







function TBactery.GetPolygon(points:byte):TPolygon;
//���� � ���, ��� �� ����� �������������� ��������, ��� ���� ������ ��������.� ������
// �������� ������ �������� ������� ����� ���������, �� �� ����������� ���������� ����������

var i:integer;X0,Y0,Rad:single;
begin
 //���� ������������ �������� ���������, ��������� ������� �������
SetLength(Result, points);
for i := 0 to points-1 do
  begin
 Rad:=i*(2*pi/points);  //������� ������� �������������� ����� � ��������� �� ��������
 X0:=TBactery(Self).inf.Size*cos(Rad)*Sett.AnimMas;
 Y0:=TBactery(Self).inf.Size*sin(Rad)/2*Sett.AnimMas;
 Rad:=TBactery(Self).inf.Angle*pi/180;
 Result[i].X:=x0*cos(Rad)-y0*sin(Rad)+TBactery(Self).inf.X;    //�������� ���������� �����, ���������� �� ������������ ���� ������������ 0,0
 Result[i].Y:=x0*sin(Rad)+y0*cos(Rad)+TBactery(Self).inf.Y;    // � ���������� ���������� ������

 end;//������� ����� ��������
{Bitmap.Canvas.Fill.Color := TBactery(Self).color; //���������� ���������
Bitmap.Canvas.DrawPolygon(MyPolygon, 50);
Bitmap.Canvas.FillPolygon(MyPolygon, 50);}

end;

end.
