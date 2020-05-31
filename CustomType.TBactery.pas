unit CustomType.TBactery;

interface

uses   Math,
      System.UITypes, System.Types, System.Math.Vectors,
      FMX.Objects, FMX.Graphics,FMX.Dialogs;

type//ралорроапк
  TBacteryInfo=record
    age:word;            //Ô¯þ­Ó±_ ßÓÛ_Õ­ÞÞ - ±Û¯Ù³Û¯ ±Þý¾Ù ÷ÞÚ ´­¯µÞÙÓ ßÓÛ_Õ­Þ  - Ô¯þý¯µÝ¯ ¯_ ²_¯Ò¯ ¯_ÛÓµÕý± 
  	color:TAlphaColor;       // ÷ÔÕ_ ßÓÛ_Õ­ÞÞ
    size,          // ­ÓþýÕ­ ßÓÛ_Õ­ÞÞ - õÙÞÝÓ Ô _¯¸ÛÓ§
    speed,         //±Û¯­¯±_³ õÔÞµÕÝÞ   - ±Û¯Ù³Û¯ _¯¸ÕÛ ´­¯§¯õÞ_ þÓ ±Þý¾Ù ÷Þ_
    sence,          //¸¾Ô±_ÔÞ_ÕÙ³Ý¯±_³, Û¯ÙÞ¸Õ±_Ô¯ ­ÓõÞ¾±¯Ô ­ÓþýÕ­Ó ßÓÛ_Õ­ÞÞ
    energy,        //±Û¯Ù³Û¯ Õ±_³ ²ÝÕ­ÒÞÞ Ô õÓÝÝ¹Ú ý¯ýÕÝ_ Ô­ÕýÕÝÞ
    x,y:single;
    angle:integer;  //ÒõÕ ÝÓ§¯õÞ_±  ßÓÛ_Õ­Þ  Þ ÕÕ ÝÓ´­ÓÔÙÕÝÞÕ õÔÞµÕÝÞ 
  end;

  TBactery=record
    activ:boolean; // ý¯µÕ_ ÙÞ ßÓÛ_Õ­Þ  Ô¹´¯ÙÝÞ_³ ÛÓÛ¯Õ ÙÞß¯ õÕÚ±_ÔÞÕ
    alive:Boolean; //µÞÔÓ ÙÞ ßÓÛ_Õ­Þ 
    inf:TBacteryInfo;   //õÓÝÝ¹Õ ¯ ßÓÛ_Õ­ÞÞ
    ellipse:TEllipse;  //²ÙÙÞ´± ßÓÛ_Õ­ÞÞ     +_¯ß­ÓµÕÝÞÕ ßÓÛ_Õ­ÞÞ


    function Mutation:TBacteryInfo;       //´¯Ù¾¸ÓÕý õÓÝÝ¹Õ ý¾_Þ­¯ÔÓÔ°ÕÚ ßÓÛ_Õ­ÞÞ
    procedure Write(BacteryInfo:TBacteryInfo); //´­¯÷Õõ¾­Ó ´­¯±_¯Ú þÓ´Þ±Þ Ô  ¸ÕÚÛ¾ ´Óý _Þ ±Ô¯Ú±_Ô ßÓÛ_Õ­ÞÞ
    procedure Born; // ­¯µõÕÝÞÕ, ÓÛ_ÞÔÝÓ  ßÓÛ_Õ­Þ -­¯õÞ_ÕÙ³. ´¯_¯ý¯Û ÞõÕ_ Ô Û¯ÝÕ÷ ±´Þ±ÛÓ
    procedure Die; //±ýÕ­_³, ÓÛ_ÞÔÝÓ  ßÓÛ_Õ­Þ  ¾ýÞ­ÓÕ_, Ô±Õ õÔÞÒÓ__±  ÝÓ ¯õÞÝ ´¾ÝÛ_. ÕÕ õÓÝÝ¹Õ ¾§¯õ _ Ô Û¯ÝÕ÷ ýÓ±±ÞÔÓ, ²ÙÙÞ´± ±Û­¹ÔÓÕ_± 

    function CountEnergy(var EnergyRule:byte;Way:single):single;



	// ´­¯÷Õõ¾­¹ ¯_­Þ±¯ÔÛÞ
	procedure CheckEllipse; //´­¯÷Õõ¾­Ó ´­¯ÔÕ­ÛÞ, ±¾¨Õ±_Ô¾Õ_ ÙÞ ²ÙÙÞ´±, Õ±ÙÞ ÝÕ_, _¯ ±¯þõÓÕý, Õ±ÙÞ õÓ, Update.
  procedure CreateEllipse; //¦ÙÙÞ´± ±¯þõÓÕ_±  ± ­ÓþýÕ­ÓýÞ ßÓÛ_Õ­ÞÞ
  procedure UpdateEllipse; //¯ßÝ¯ÔÙ Õ_±  ÷ÔÕ_, ­ÓþýÕ­, ´¯Ù¯µÕÝÞÕ. ²ÙÙÞ´± ±_ÓÝ¯ÔÞ_±  ÔÞõÞý¹ý - Õ¨Õ §¯­¯°¯ õÙ  ±ýÕÝ¹ ýÓ±°_ÓßÓ ¯_¯ß­ÓµÕÝÞ 

  procedure MoveEllipse; //¾±_ÓÝÓÔÙÞÔÓÕý Û¯¯­õÞÝÓ_¹ ²ÙÙÞ´±Ó Þ ÝÓ´­ÓÔÙÕÝÞÕ þ­ÕÝÞ  Ô ±¯¯_ÔÕ_±_ÔÞÞÞ ± õÓÝÝ¹ýÞ ßÓÛ_Õ­ÞÞ
	procedure ChangeColor(Color:TAlphaColor);//¯ßÝ¯ÔÙ Õý ÷ÔÕ_ ßÓÛ_Õ­ÞÞ Þ ²ÙÙÞ´±Ó - Ý¾µÝ¯ ´­Þ ´Õ­Õ§¯õÕ ßÓÛ_Õ­ÞÞ Ô Ý¯Ô¾_ Û¯Ù¯ÝÞ_

	procedure ShowEllipse;
	procedure HideEllipse;

	function GetPolygon(points:byte):TPolygon; //¯´­ÕõÕÙÕÝÞÕ ´¯ÙÞÒ¯ÝÓ. Points - ÝÓ±Û¯Ù³Û¯ ¯Ý ÒÙÓõ¯Û

  end;



  implementation  uses  EvoTypes, evo, AddBac;


function TBactery.Mutation:TBacteryInfo;
var MutSpeed,MutSize,MutSence:Single;
begin
 randomize;
  MutSpeed:=1; MutSize:=1;MutSence:=1;
// ±ÝÓ¸ÓÙÓ ´­¯ÔÕ­ Õý, ß¾õÕ_ ÙÞ Ô¯¯ß¨Õ ý¾_Ó÷Þ  ÛÓµõ¯Ò¯ Þþ ´­ÞþÝÓÛ¯Ô Ô ¯_õÕÙ³Ý¯±_Þ
   if Sett.MutShance>=random(99)+1 then if random(99)<49 then MutSpeed:=1+Sett.MutPower/100 else MutSpeed:=1-Sett.MutPower/100 ; // ÞÙÞ ¯_Ý _³
   if Sett.MutShance>=random(99)+1 then if random(99)<49 then MutSize:=1+Sett.MutPower/100 else MutSize:=1-Sett.MutPower/100 ; // ÞÙÞ ¯_Ý _³
   if Sett.MutShance>=random(99)+1 then if random(99)<49 then MutSence:=1+Sett.MutPower/100 else MutSence:=1-Sett.MutPower/100 ;

   Result:=TBactery(self).inf;//Ô ­Õþ¾Ù³_Ó_ þÓ´Þ±¹ÔÓÕ_±  ±ÓýÓ ßÓÛ_Õ­Þ 
   Result.speed:=Result.speed*MutSpeed;     //Þ ´Õ­Õ¯´­ÕõÕÙ __±  ý¾_Þ­¯ÔÓÔ°ÞÕ þÝÓ¸ÕÝÞ 
   Result.size:=Result.size*MutSize;
   Result.sence:=Result.sence*MutSence;
end;


procedure TBactery.Write( BacteryInfo:TBacteryInfo);   //±¾_³ Ô þÓ´Þ±Þ Ô±Õ§ õÓÝÝ¹§ ýÓ±_Õ­Ó Ô  ¸ÕÚÛ¾ ´Óý _Þ
begin                                                  //ßÕ±´¯ÙÕþÝÓ  ¶¾ÝÛ÷Þ  ´¯ ±¾_Þ.
 tBactery(self).inf:=BacteryInfo;
 tBactery(self).inf.Age:=0;
end;

procedure TBactery.Born; // ´­¯÷Õ±± ­¯µõÕÝÞ  ¯_ ²_¯Ú ßÓÛ_Õ­ÞÞ
begin
  Inc(sim.BacCount); //¾ÔÕÙÞ¸ÞÔÓÕý ÝÓ ¯õÞÝ
  bac[sim.BacCount].write(tBactery(self).Mutation);//Ô ÝÕÕ þÓ´Þ±¹ÔÓÕý ý¾_Þ­¯ÔÓÔ°ÞÕ þÝÓ¸ÕÝÞ  ÝÓ°ÕÚ ßÓÛ_Õ­ÞÞ
  bac[sim.BacCount].CheckEllipse;
end;

 procedure TBactery.Die;
 begin
 TBactery(self).HideEllipse; //±­Óþ¾ ±Û­¹ÔÓÕý ²ÙÙÞ´±
 {±ýÕ­_³ ßÓÛ_Õ­ÞÞ. ¤Õ­ÔÓ  ¸Ó±_³- Þ±ÛÙ_¸Þ_³ Þþ ±´Þ±ÛÓ þÓ_Õ­ÕÔ ÕÕ ÞÝ¶¯­ýÓ÷Þ_, Ý¯ ±¯§­ÓÝÞÔ ±¯þõÓÝ¹Ú ²ÙÙÞ´±
 ÛÓÛ ÔÓ­ÞÓÝ_- ¾ß­Ó_³ ßÓÛ_Õ­Þ_ Ô Û¯ÝÕ÷ ±´Þ±ÛÓ, Ó ÝÓ ÕÕ ýÕ±_¯ ´¯±_ÓÔÞ_³ ´¯±ÙÕõÝ__, ¸_¯ß¹ ÝÕ õÔÞÒÓ_³
 ÛÓÛ ÔÓ­ÞÓÝ_- ýÕÝ _³ ýÕ±_ÓýÞ ± ´¯±ÙÕõÝÕÚ Þ ¾ýÕÝ³°Ó_³ Û¯ÙÞ¸Õ±_Ô¯ ßÓÛ_Õ­ÞÚ ÝÓ ÕõÞÝÞ÷¾.
 Ý¯ _¯ÒõÓ }
 end;

function TBactery.CountEnergy(var EnergyRule:byte; Way:single):single;
 begin
   case EnergyRule of
  1: Result:=Power(TBactery(self).inf.size,3)/1000*Power(Way,2)/100;
  2: Result:=Power(TBactery(self).inf.size/10,3)*Power(Way,2)/100+0.5*TBactery(self).inf.size/10*TBactery(self).inf.sence/10;
  3: Result:=Power(TBactery(self).inf.size/10,2)*Power(Way/10,2);
  4: Result:=Power(TBactery(self).inf.size/10,3)*Way/10;
  5: Result:=Power(TBactery(self).inf.size/10,2)*Way/10;
  else Form2.logmemo.lines.add('+°ÞßÛÓ Ô¹¸Þ±ÙÕÝÞ  ¦ÝÕ­ÒÞÞ');
  end;
 end;


procedure TBactery.CheckEllipse;
begin
{+±´¯Ù³þ¾Õ_±  _¯Ù³Û¯ ´­Þ ±¯þõÓÝÞÞ/­¯µõÕÝÞÞ ßÓÛ_Õ­ÞÞ, õÙ  _¯Ò¯ ¸_¯ß¹ ´¯Ý _³, Ý¯õ¯ ±¯þõÓÔÓ_³ ²ÙÙÞ´± ÞÙÞ ÝÕ_ }
If Assigned(TBactery(self).ellipse) //Õ±ÙÞ ²ÙÙÞ´± ÝÕ ±¾¨Õ±_Ô¾Õ_- ±¯þõÓÕý, Õ±ÙÞ Õ±_³- ¯ßÝ¯ÔÙ Õý ­ÓþýÕ­ Þ ÷ÔÕ_ Ô ±¯¯_ÔÕ_±_ÔÞÞ ± õÓÝÝ¹ýÞ
  then tBactery(self).UpdateEllipse    else TBactery(self).CreateEllipse;
end;



procedure TBactery.CreateEllipse;
begin
  TBactery(self).Ellipse:=TEllipse.Create(MainForm.PetryPanel);
  TBactery(self).ellipse.Parent:= MainForm.PetryPanel;
 with  TBactery(self).Ellipse do begin
  Fill.Kind:= TBrushKind.Gradient;//¯_­Þ±¯ÔÛÓ Ò­ÓõÞÕÝ_Ó Û­¾Ò¯Ô¯Ò¯ ±¯ ±ýÕ¨ÕÝÞÕý
  Fill.Gradient.Color:=TBactery(self).inf.Color;
  Height:=TBactery(self).inf.size*sett.AnimMas ; Width:=TBactery(self).inf.size/2*sett.AnimMas ;
  Position.X:= TBactery(self).inf.X;  Position.Y:= TBactery(self).inf.Y;
  RotationAngle:= TBactery(self).inf.angle;
  end;

end;

procedure tBactery.UpdateEllipse ;
begin
with tBactery(self).ellipse do begin            //´­ÞÔ¯õÞý ­ÓþýÕ­¹ Û ´­ÓÔÞÙ³Ý¹ý
 Height:=TBactery(self).inf.size*sett.AnimMas ;
 Width:=TBactery(self).inf.size/2*sett.AnimMas;
 Fill.Color:=tBactery(self).inf.Color; end;    // Þ ÷ÔÕ_
 tBactery(self).MoveEllipse; //­Ó±´¯Ù¯ÒÓÕý Ô Ý¾µÝ¯ý ýÕ±_Õ
 tBactery(self).ShowEllipse;//²_¯_ ²ÙÞ´± _Õ´Õ­³ ¯_¯ß­ÓµÓÕý
end;



procedure TBactery.ShowEllipse; begin TBactery(self).Ellipse.Visible:=true; end;
procedure TBactery.HideEllipse; begin TBactery(self).Ellipse.Visible:=false; end;

procedure TBactery.MoveEllipse;
begin
TBactery(self).Ellipse.Position.X:=TBactery(self).inf.X ;
TBactery(self).Ellipse.Position.Y:=TBactery(self).inf.Y;
TBactery(self).Ellipse.RotationAngle:=TBactery(self).inf.Angle;
end;

procedure TBactery.ChangeColor(Color:TAlphaColor); //±ýÕÝÓ ÷ÔÕ_Ó ßÓÛ_Õ­ÞÞ Þ ±­Óþ¾ ²ÙÙÞ´±Ó
begin
TBactery(self).Ellipse.Fill.Color:=Color; TBactery(self).inf.Color:=Color;
end;







function TBactery.GetPolygon(points:byte):TPolygon;
//ÞõÕ  Ô _¯ý, ¸_¯ ÝÓ ÛÓÝÔÕ ¯_­Þ±¯Ô¹ÔÓÕ_±  ßÓÛ_Õ­Þ , ²_¯ µ­Õ_ ýÕÝ³°Õ ­Õ±¾­±¯Ô.Ô _Õ¯­ÞÞ
// Ô¯þý¯µÝ¯ ­Ó±¸Õ_ ´¯Ô¯­¯_Ó ²ÙÙÞ´±Ó ß¾õÕ_ ´­¯µ¯­ÙÞÔ, Ý¯ ÝÕ ´¯´¹_ÓÔ°Þ±³ ÝÕÔ¯þý¯µÝ¯ ¯´­ÕõÕÙÞ_³

var i:integer;X0,Y0,Rad:single;
begin
 //²_Þý ¯´­ÕõÕÙ Õ_±  ÛÓ¸Õ±_Ô¯ ¯_­Þ±¯ÔÛÞ, ÝÓ±Û¯Ù³Û¯ ß¯Ù³°¯Ú ´¯ÙÞÒ¯Ý
SetLength(Result, points);
for i := 0 to points-1 do
  begin
 Rad:=i*(2*pi/points);  //±¸Þ_ÓÕý ­ÓõÞÓÝ¹ ´­¯±¸Þ_¹ÔÓÕý¯Ú _¯¸ÛÞ Ô ´¯Ù¯µÕÝÞÞ õ¯ ´¯Ô¯­¯_Ó
 X0:=TBactery(Self).inf.Size*cos(Rad)*Sett.AnimMas;
 Y0:=TBactery(Self).inf.Size*sin(Rad)/2*Sett.AnimMas;
 Rad:=TBactery(Self).inf.Angle*pi/180;
 Result[i].X:=x0*cos(Rad)-y0*sin(Rad)+TBactery(Self).inf.X;    //´¯Ù¾¸ÓÕý Û¯¯­õÞÝÓ_¹ _¯¸ÛÞ, ´¯ÔÕ­Ý¾_¯Ú ÝÓ ¯´­ÕõÕÙÕÝÝ¹Ú ¾Ò¯Ù ¯_Ý¯±Þ_ÕÙ³Ý¯ 0,0
 Result[i].Y:=x0*sin(Rad)+y0*cos(Rad)+TBactery(Self).inf.Y;    // Þ ´­ÞßÓÔÙ Õý Û¯¯­õÞÝÓ_¹ ÷ÕÝ_­Ó

 end;//­Ó±±¸Õ_ _¯¸ÕÛ ´¯ÙÞÒ¯ÝÓ
{Bitmap.Canvas.Fill.Color := TBactery(Self).color; //±¯ß±_ÔÕÝÝ¯ ¯_­Þ±¯ÔÛÓ
Bitmap.Canvas.DrawPolygon(MyPolygon, 50);
Bitmap.Canvas.FillPolygon(MyPolygon, 50);}

end;

end.
