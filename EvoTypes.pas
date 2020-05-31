unit EvoTypes;  //юнит где хран¤тс¤ все переменные

interface

uses  CustomType.TBactery,
      System.UITypes, FMX.Objects;

type
  TFood=record
    X,Y:word;
  end;

  TSettings=record
    AnimSpeed,AnimMas:real;// масштаб и скорость анимации отображени¤ размера бактерий форме
    kEnergy:real; // коэфициент расходовани¤ энергии дл¤ всей системы
    kRadEat:real; // коэфициент возможности поедани¤, от размера существа
    kRadSence:real; // коэфициент замечани¤ еды, от размера существа
    EnergyRule:integer;
    FoodSpawn, FoodPower: word;  // количество спавнейщейся еды в одну симул¤цию и энергия этой еды
    Mutshance, MutPower:integer; //шансы мутации в процентах
  end;


  TSimulation=record   //основные данные о симул¤ции
    X,Y, //размеры мира
    BacCount, FoodCount,//количество бактерий и еды
    MaxBacCount:word;// максимально существовавшее количество бактерий - показывает, сколько эллипсов было создано

  end;

  TFoodSearchResult=record //результат поиска еды
    result:boolean; //
    path:real; // расссто¤ние до еды
    angle:integer; // направление движени¤ бактерии к еде
  end;

  TColony=record
    color:TAlphaColor; //цвет колонии
    count,born,died:integer;     // количество бактерий в колонии
    Energy,       //энерги¤ колонии
    MinEnergy,MaxEnergy, //минимальна¤ и максимальна¤ энерги¤ в колонии

    Age:real;         //общий возраст всех бактерий в колонии, дл¤ расчета среднего
    minAge,MaxAge:real;  //минимальный и максимальный возраст в колонии
end;



  var bac:array [1..10000] of TBactery;   // массив живущих бактерий


      food:array[0..10000] of TFood;     // массив еды на поле


      Colony: array[0..100] of TColony;// массив колоний. 0- еда
      ColonyCount:integer; //количество колоний в симул¤ции

      sett:TSettings;
      sim:TSimulation;
     
      

      sol:integer; // количество прошедших симул¤ций


implementation
end.
