unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,Fields,Debug;


type
  TForm1 = class(TForm)
    Label1: TLabel;
    procedure FormPaint(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    //procedure Button1Click(Sender: TObject);
    //procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
  //procedure Repaint;
    { Public declarations }
   procedure DrawGrid;
   procedure DrawCrossZeros;
   procedure DrawCross(i,j:Byte;CellSize:Word);
   procedure DrawZero(i,j:Byte;CellSize:Word);
  end;

//Динамический массив фигур или совсем от Point отказаться.





var
  Form1: TForm1;

Procedure  NewGame;
  {MainField : TField;
  Win,Lose : Boolean;
  //Win:Array[0..2] of Boolean;


Procedure  NewGame;
function OutOfBounds(X,Y:int8):Boolean;
Function HardTurn(Field:TField;TurnColor:Byte;RecDeep:Word):Double; }


implementation

{$R *.dfm}


procedure NewGame;
begin
  if MainField<>nil then MainField.Destroy;
  MainField := TField.Create;
  Win := False;
  Lose := False;
  NTurn := 0;
  Form1.Label1.Visible := False;
end;


procedure TForm1.DrawGrid;
var
 { GridSize,} CellSize, I: Integer;
begin
  CellSize := ClientHeight div GridSize; // Size of each grid cell

  // Set the pen properties for grid lines
  Canvas.Pen.Color := clBlack;
  Canvas.Pen.Width := 2;

  // Draw vertical grid lines
  for I := 0 to GridSize do
  begin
    Canvas.MoveTo(I * CellSize, 0);
    Canvas.LineTo(I * CellSize, ClientHeight);
  end;

  // Draw horizontal grid lines
  for I := 0 to GridSize do
  begin
    Canvas.MoveTo(0, I * CellSize);
    Canvas.LineTo(CellSize*GridSize, I * CellSize);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  NewGame;
  Randomize;
  Fields.Debug := TDebug.Initialize('debug.txt');
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  {GridSize,} CellSize, GridX, GridY: Integer;
  Color:Byte;
begin
  if Win or Lose then exit;
  if NTurn>=sqr(GridSize) then exit;

  CellSize := ClientHeight div GridSize; // Size of each grid cell

  // Calculate the grid coordinates based on the mouse click position
  GridX := X div CellSize;  //0..15
  GridY := Y div CellSize;  //0..15
  //if Button=mbLeft then Color :=2
                   //else Color :=0;

  if MainField.Data[GridX,GridY].Color=1 then
    begin
      MainField.SetData(GridX,GridY,2);
      if NTurn>=sqr(GridSize) then exit;
      Repaint;
      HardTurn(MainField,0,0);//SimpleTurn;
    end;
 Repaint;
end;

procedure TForm1.DrawCrossZeros;
var  CellSize, I,J: Integer;
begin
  CellSize := ClientHeight div GridSize;
  for I := 0 to GridSize-1 do
    for J := 0 to GridSize-1 do
      case MainField.Data[i,j].Color of
        0: DrawZero(i,j,CellSize);
        2: DrawCross(i,j,CellSize);
      end;
end;

{
procedure TForm1.Button1Click(Sender: TObject);
begin
  NewGame;
end;
}


procedure TForm1.DrawCross(i: Byte; j: Byte; CellSize: Word);
var
  CrossSize, CrossHalfSize: Integer;
  CrossMargin : Integer;
  CrossLeft, CrossTop: Integer;
begin
  CrossSize := Round(CellSize*0.8); // Size of the cross
  CrossHalfSize := CrossSize div 2;
  CrossMargin := CellSize div 2 - CrossHalfSize;


  CrossLeft := i*CellSize + CrossMargin; // Calculate the left position of the cross
  CrossTop :=  j*CellSize + CrossMargin; // Calculate the top position of the cross

  // Set the pen properties for the cross
  if (i=XLast) and (j=Ylast) then Canvas.Pen.Color := clBlack
                             else Canvas.Pen.Color := clRed;
  //Canvas.Pen.Color := clRed;
  Canvas.Pen.Width := 4;

  // Draw the first line of the cross
  Canvas.MoveTo(CrossLeft, CrossTop);
  Canvas.LineTo(CrossLeft + CrossSize, CrossTop + CrossSize);

  // Draw the second line of the cross
  Canvas.MoveTo(CrossLeft + CrossSize, CrossTop);
  Canvas.LineTo(CrossLeft, CrossTop + CrossSize);
end;

procedure TForm1.DrawZero(i: Byte; j: Byte; CellSize: Word);
var
  CircleDiameter: Integer;
  CircleRadius: Integer;
  CircleMargin : Integer;
  CircleLeft, CircleTop: Integer;
begin
  CircleDiameter := Round(CellSize*0.8); // Diameter of the circle (50 pixels)
  CircleRadius := CircleDiameter div 2;
  CircleMargin := CellSize div 2 - CircleRadius;

  CircleLeft := i*CellSize + CircleMargin; // Calculate the left position of the circle
  CircleTop := j*CellSize + CircleMargin; // Calculate the top position of the circle

  // Set the pen properties for the circle
  if (i=XLast) and (j=Ylast) then Canvas.Pen.Color := clBlack
                             else  Canvas.Pen.Color := clBlue;
  Canvas.Pen.Width := 4;

  // Draw the circle
  Canvas.Ellipse(CircleLeft, CircleTop, CircleLeft + CircleDiameter, CircleTop + CircleDiameter);
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  Canvas.Brush.Color:=clBtnFace;
  Canvas.FillRect(ClientRect);    //полностью очищаем форму.
  DrawGrid;
  {if (not Win) and (not Lose) then} DrawCrossZeros;
  if Win then
    begin
      Label1.Caption := 'Победа!';
      Label1.Font.Color := ClMaroon;
    end;
  if Lose then
    begin
      Label1.Caption := 'Поражение...';
      Label1.Font.Color := clAqua;
    end;
  if  Win or Lose then  Form1.Label1.Visible := True;
  if NTurn>=sqr(GridSize) then
    begin
      Label1.Caption := 'Ничья';
      Label1.Font.Color := clBlack;
      Form1.Label1.Visible := True;
    end;
end;

end.
