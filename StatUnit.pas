unit StatUnit;

interface

 uses  EvoTypes, Math, System.SysUtils;


  procedure NulColonys();  //���������� ���� ������������ ������� � �������� ����
  procedure UpdateColonys();

  procedure CountBacteriesCount(); //���������, ������� �������� � ������� ������
  procedure CountEnergy();   /// ��������� ������� �������
  procedure CountAge();

  //��������� ����������
  procedure RenewStatistik();
  procedure ShowStatistik();

implementation  uses Evo;

procedure NulColonys(); //���������� � ���� ���� �������� �������, ��� ��������� ����������
var i:integer;
begin
colony[0].Energy:=0; colony[0].count:=0; colony[0].color:=$FF228B22;  //�������� ���
for i := 1 to ColonyCount do begin       //�������� ��� ������������ �������
                      colony[i].count:=0;
                      colony[i].Energy:=0; colony[i].MinEnergy:=99999; colony[i].MaxEnergy:=0;
                      colony[i].Age:=0; colony[i].MaxAge:=0;
                     end;
end;

procedure UpdateColonys();   //�������� ���������� � ���������� ������� � �� �����
var i,j:integer; Res:boolean;
begin
{
����� �������� �������� � ���������, ���� �� ����� ������� �� ��� ������������.
���� ���, ��������� +1 ������� � ������� �� ���� ��������
}
{for i := 1 to ColonyCount do colony[i].color:=$FFFFFFFF; //������ ��� ������� ������
ColonyCount:=1;
colony[1].color:=bac[1].color;    //������ �������� ������� ���������
for i := 2 to Count do     //��������� ��� �������� �� ������������
  begin
    res:=true; //��� ���������� ��������
    {���������, ���� �� ����� ������� ���, ���� ����, ���������� ����������� FALSE
     ���� ��� ����� �������, �� �� ���� �� ���������� FALSE � �������� ��������� true
     ���� TRUE, �� ����������� ���������� ������� �� 1 � ��������� ����������� ���� ���������� ��������
     ��� ��������� �������� ����� ��� ����� ����� ��������}
   { for j := 1 to ColonyCount do if Colony[j].color=bac[i].color then res:=false; // �������� �� ���������
    if res then begin ColonyCount:=ColonyCount+1; Colony[ColonyCount].color:=bac[i].color; end;
    end;
colony[ColonyCount].AgeArray[0]:=0; //��������� ��������� 0 � ���������� �������  }
end;

{
procedure ();
var i,j:integer;
begin
for i := 1 to count do for j:=1 to ColonyCount do
    if colony[j].color=bac[i].color then    //���� ������������� �������, ��
            begin
            colony[j].Energy:=colony[j].Energy+bac[i].energy;  // ��������� ���������� � �������
            end;
end;
}
procedure CountBacteriesCount();
var i,j:integer;
begin
{for i := 1 to count do for j:=1 to ColonyCount do
    if colony[j].color=bac[i].color then    //���� ������������� �������, ��
            begin
            colony[j].Count:=colony[j].Count+1;  // ��������� ���������� � �������
            end;
colony[0].count:=FoodCount; //���������� ��� �� ���� � ���� ����������   }
end;

procedure CountEnergy(); //������� ������ ������� �������
var i,j:integer;
begin
{for i := 1 to count do for j:=1 to ColonyCount do
    if colony[j].color=bac[i].color then    //���� ������������� �������, ��
            begin
            colony[j].Energy:=colony[j].Energy+bac[i].energy;  // ����� ������� ���� �������
            if colony[j].MinEnergy>bac[i].energy  then colony[j].MinEnergy:=bac[i].energy;  //����� ������ �������
            if colony[j].MaxEnergy<bac[i].energy  then colony[j].MaxEnergy:=bac[i].energy   //����� ������� �������
            end;
if Foodcount>0 then for i := 1 to Foodcount do colony[0].Energy:=colony[0].Energy+sett.FoodPower //��������� � ������� ������ ������� ���
else colony[0].Energy:=0; }
end;

procedure CountAge();
var i,j:integer;
begin
{for i := 1 to count do for j:=1 to ColonyCount do
    if colony[j].color=bac[i].color then    //���� ������������� �������, ��
            begin
            colony[j].Age:=colony[j].Age+bac[i].Age;  // ������� �������� ������� �����������
            if colony[j].MinAge>bac[i].Age  then colony[j].MinAge:=bac[i].Age;  //����� �������, � �������� ��� 0
            if colony[j].MaxAge<bac[i].Age  then colony[j].MaxAge:=bac[i].Age   //����� ������
            end; }
end;

procedure RenewStatistik();  //������ ����������� ��� ����������
var i:integer;
begin
{NulColonys(); //��� �������� ������� ��������

CountBacteriesCount();
for i := 1 to ColonyCount do if colony[i].count=0 then UpdateColonys();

CountEnergy();        //���������� �� ������� ������ ����� �� ����������� ��, ��� ��� �� ����
CountAge();

ShowStatistik();    // ���������� ��, ��� ���� ����� ���������}
end;


procedure ShowStatistik();  //���������� ���������� � ����������� �� ��������� ��������� ��� ������ ����� ����
var i,j:integer; stat:array[0..1000] of real; energ,ageSum:real;
begin
{Form1.Series1.Clear;
Form1.Series2.Clear;



Form1.Chart1.Title.Text.Clear;
Form1.Chart1.Title.Text.Add('����� �������� � ���������');
Form1.Chart1.Title.Text.Add(inttostr(count));

if Form1.ComboBox1.ItemIndex=0 then begin
      for i := 1 to ColonyCount do Form1.Series1.Add(colony[i].Count, inttostr(colony[i].Count), colony[i].color);
      Form1.Series1.Add(colony[0].Count, inttostr(colony[0].Count), colony[0].color);
                                    end;

if Form1.ComboBox1.ItemIndex=1 then begin   //% �� ������ ���������� ��������, ��� �� ���������

      for i := 1 to ColonyCount do stat[i]:=Round((100*colony[i].Count/count)*100)/100;
      for i := 1 to ColonyCount do Form1.Series1.Add(stat[i],floattostr(stat[i]), colony[i].color);

                                    end;


energ:=0; for i := 0 to ColonyCount do energ:=energ+colony[i].Energy ; //����� ������� �������
Form1.Chart2.Title.Text.Clear;
Form1.Chart2.Title.Text.Add('����� ������� � ���������');
Form1.Chart2.Title.Text.Add(floattostr(round(energ)));

if Form1.ComboBox2.ItemIndex=0 then begin

      for i := 1 to ColonyCount do Form1.Series2.Add(colony[i].Energy,floattostr(round(colony[i].Energy)), colony[i].color);
      Form1.Series2.Add(colony[0].Energy, inttostr(round(colony[0].Energy)), colony[0].color);
                                    end;

if Form1.ComboBox2.ItemIndex=1 then begin      //��������

      for i := 0 to ColonyCount do stat[i]:=Round((100*colony[i].Energy/energ)*100)/100;
      for i := 1 to ColonyCount do Form1.Series2.Add(stat[i],floattostr(round(stat[i])), colony[i].color);
      Form1.Series2.Add(stat[0], floattostr(round(stat[0])), colony[0].color);
                                    end;
if Form1.ComboBox2.ItemIndex=2 then begin
       for i := 1 to ColonyCount do stat[i]:=Round((colony[i].Energy/colony[i].count)*100)/100;
       for i := 1 to ColonyCount do Form1.Series2.Add(stat[i],floattostr(round(stat[i]*100)/100), colony[i].color);
                                    end;

 }                                   //for i := 1 to round(sol/20) do
{if sol<500 then begin  stat[floor(sol)]:=count;  Form1.Series3.AddXY(sol/20,count,'k',colony[1].color); end
            else begin  for i := 1 to 499 do stat[i]:=stat[i+1]; stat[500]:=count;
                        form1.Series3.Clear; for i:=1 to 500 do Form1.Series3.AddXY(sol/20,stat[i],'k',colony[1].color);  end;


    ����������� ���������� ����������
 }
end;



end.
