unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,Fields,Debug;


type
  TForm1 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    OpenDialog1: TOpenDialog;
    Button7: TButton;
    procedure FormPaint(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
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



implementation

{$R *.dfm}


procedure NewGame;
begin
  if Fields.Debug<>nil then Fields.Debug.Finalize;
  Fields.Debug := TDebug.Initialize('debug.txt');
  if MainField<>nil then MainField.Destroy;
  MainField := TField.Create;
  Win := False;
  Lose := False;
  Form1.Label1.Visible := False;
  NTurn := 0;
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
  if Button=mbLeft then Color :=2
                   else Color :=0;

  if OutOfBounds(GridX,GridY) then exit;

  if MainField.Data[GridX,GridY].Color=1 then
    begin
      MainField.SetData(GridX,GridY,Color);
      //Repaint;
      //SimpleTurn;
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

procedure TForm1.Button1Click(Sender: TObject);
begin
  NewGame;
  Repaint;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
Field: TField;
F,i:Byte;
begin
  NewGame;
  // Set up the field data and figures
  Field := MainField;
  //SetLength(Field.Figures,5);
    // Test case 1: Creating a new figure
  MainField.SetData(10,10,2);
  MainField.SetData(11,10,2);

  Assert(Field.Figures[0].Length = 2, 'Test case 1 failed');
  Assert(Field.Figures[0].Hole = False, 'Test case 1 failed');


  // Test case 2: Figure with hole
  MainField.SetData(3,4,0);
  MainField.SetData(2,4,0);
  MainField.SetData(4,4,0);
  MainField.SetData(3,3,0);



  Assert(Field.Figures[1].Length = 3, 'Test case 2 failed');
  Assert(Field.Figures[1].Hole = False, 'Test case 2 failed');
  for i := 2 to 4 do
    begin
      Assert(Field.Figures[4].Length = 2, 'Test case2 failed');
      Assert(Field.Figures[4].Hole = False, 'Test case 2 failed');
    end;

  // Test case 3: Joining to a figure with a hole
  MainField.SetData(5,7,0);
  MainField.SetData(7,7,0);
  Assert(Field.Figures[5].Length = 2, 'Test case 3 failed');
  Assert(Field.Figures[5].Hole = True, 'Test case 3 failed');
  MainField.SetData(8,7,0);
  Assert(Field.Figures[5].Length = 3, 'Test case 3 failed');
  Assert(Field.Figures[5].Hole = True, 'Test case 3 failed');
  MainField.SetData(6,7,0);
  Assert(Field.Figures[5].Length = 4, 'Test case 3 failed');
  Assert(Field.Figures[5].Hole = False, 'Test case 3 failed');

   // Test case 4: Set data to double hole
  MainField.SetData(0,0,2);
  MainField.SetData(0,3,2);
  MainField.SetData(0,2,2);
  Assert(Field.Figures[6].Length = 3, 'Test case 4 failed');
  Assert(Field.Figures[6].Hole = True, 'Test case 4 failed');
  //Assert(Field.Figures[7].Length = 2, 'Test case 4 failed');
  //Assert(Field.Figures[7].Hole = False, 'Test case 4 failed');

  MainField.SetData(15,0,2);
  MainField.SetData(15,3,2);
  MainField.SetData(15,1,2);
  Assert(Field.Figures[7].Length = 3, 'Test case 5 failed');
  Assert(Field.Figures[7].Hole = True, 'Test case 5 failed');
  MainField.SetData(15,2,2);
  Assert(Field.Figures[7].Length = 4, 'Test case 5 failed');
  Assert(Field.Figures[7].Hole = False, 'Test case 5 failed');
  //Assert(Field.Figures[7].Length = 2, 'Test case 4 failed');
  //Assert(Field.Figures[7].Hole = False, 'Test case 4 failed');

   MainField.SetData(15,6,2);
   MainField.SetData(15,7,2);
   MainField.SetData(15,9,2);
   MainField.SetData(15,10,2);
   Assert(Field.Figures[8].Length = 4, 'Test case 6 failed');
   Assert(Field.Figures[8].Hole = True, 'Test case 6 failed');
   MainField.SetData(15,8,0);
   Assert(Field.Figures[8].Length = 2, 'Test case 6 failed');
   Assert(Field.Figures[9].Length = 2, 'Test case 6 failed');
   Assert(Field.Figures[8].Hole = False, 'Test case 6 failed');
   Assert(Field.Figures[9].Hole = False, 'Test case 6 failed');



  MainField.SetData(0,7,0);
  MainField.SetData(0,8,2);
  MainField.SetData(0,10,2);
  MainField.SetData(0,9,2);
  MainField.SetData(0,11,2);
  Assert(Field.Figures[10].Length = 4, 'Test case 7 failed');
  Assert(Field.Figures[10].Score = 8, 'Test case 7 failed');

  MainField.SetData(0,15,2);
  MainField.SetData(2,15,2);
  MainField.SetData(4,15,2);
  MainField.SetData(1,15,2);
  Assert(Field.Figures[11].Length = 4, 'Test case 8 failed');
  Assert(Field.Figures[11].Hole = True, 'Test case 8 failed');
  //Assert(Field.Figures[11].Score = 7, 'Test case 7 failed');
  // Additional test cases
  MainField.SetData(6,15,0);
  MainField.SetData(8,15,0);
  MainField.SetData(10,15,0);
  MainField.SetData(9,15,0);
  Assert(Field.Figures[14].Length = 4, 'Test case 9 failed');
  Assert(Field.Figures[14].Hole = True, 'Test case 9 failed');

  MainField.SetData(9,0,2);
  MainField.SetData(8,1,2);
  MainField.SetData(5,4,2);
  MainField.SetData(6,3,2);
  Assert(Field.Figures[15].Length = 0, 'Test case 10 failed');
  Assert(Field.Figures[15].Hole = False, 'Test case 10 failed');
  Assert(Field.Figures[16].Length = 4, 'Test case 10 failed');
  Assert(Field.Figures[16].Hole = True, 'Test case 10 failed');
  Assert(Field.Figures[16].StartX = 5, 'Test case 10 failed');
  Assert(Field.Figures[16].StartY = 4, 'Test case 10 failed');

  MainField.SetData(6,4,0);
  MainField.SetData(7,3,0);
  MainField.SetData(10,0,0);
  MainField.SetData(9,1,0);
  Assert(Field.Figures[17].Length = 4, 'Test case 11 failed');
  Assert(Field.Figures[17].Hole = True, 'Test case 11 failed');
  Assert(Field.Figures[17].StartX = 6, 'Test case 11 failed');
  Assert(Field.Figures[17].StartY = 4, 'Test case 11 failed');

  //MainField.SetData(15,12,0);
  //MainField.SetData(15,13,0);
  MainField.SetData(4,12,2);
  MainField.SetData(5,11,2);
  MainField.SetData(6,10,2);
  MainField.SetData(3,13,0);
  MainField.SetData(6,9,0);
  MainField.SetData(8,10,0);
  MainField.SetData(7,9,2);
  Assert(Field.Figures[18].Length = 4, 'Test case 12 failed');
  Assert(Field.Figures[18].Score = 8, 'Test case 12 failed');

  MainField.SetData(7,5,2);
  MainField.SetData(8,4,2);
  MainField.SetData(11,1,2);
  MainField.SetData(9,3,2);
  Assert(Field.Figures[21].Length = 4, 'Test case 13 failed');
  Assert(Field.Figures[21].Score = 8, 'Test case 13 failed');

  MainField.SetData(12,3,0);
  MainField.SetData(12,7,0);
  MainField.SetData(12,5,0);
  Assert(Field.Figures[22].Length = 2, 'Test case 14 failed');
  Assert(Field.Figures[23].Length = 2, 'Test case 14 failed');


  MainField.SetData(14,15,0);
  MainField.SetData(14,10,0);
  MainField.SetData(14,14,0);
  MainField.SetData(14,12,0);
  MainField.SetData(14,11,0);
  Assert(Field.Figures[25].Length = 5, 'Test case 15 failed');
  Assert(Field.Figures[25].Hole = True, 'Test case 15 failed');
  Assert(Field.Figures[25].Score = 8, 'Test case 15 failed');

  MainField.SetData(1,0,0);
  MainField.SetData(5,0,0);
  MainField.SetData(4,0,0);
  MainField.SetData(2,0,0);
  MainField.SetData(3,0,0);
  Assert(Field.Figures[27].Length = 5, 'Test case 15 failed');
  Assert(Field.Figures[27].Hole = False, 'Test case 15 failed');

  MainField.SetData(13,15,2);
  MainField.SetData(13,14,2);
  MainField.SetData(13,10,2);
  MainField.SetData(13,11,2);
  MainField.SetData(13,12,2);
  Assert(Field.Figures[29].Length = 5, 'Test case 15 failed');
  Assert(Field.Figures[29].Hole = True, 'Test case 15 failed');
  Assert(Field.Figures[29].Score = 8, 'Test case 15 failed');

  Repaint;
  // ...

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  NewGame;
  MainField.SetData(0,0,2);
  MainField.SetData(0,2,0);
  MainField.SetData(0,3,0);
  MainField.SetData(0,4,0);
  MainField.SetData(0,5,2);
  MainField.SetData(0,7,0);
  MainField.SetData(0,8,0);
  SimpleTurn(0);
  Assert(MainField.Figures[1].Length = 3, 'Test case 1 failed');
  MainField.SetData(0,9,2);
  MainField.SetData(0,11,0);
  MainField.SetData(0,12,0);
  MainField.SetData(0,14,2);
  MainField.SetData(0,15,0);
  MainField.SetData(1,15,0);
  SimpleTurn(0);
  Assert(MainField.Figures[2].Length = 2, 'Test case 2 failed');
  Assert(MainField.Figures[2].Score = 0, 'Test case 2 failed');
  Assert(MainField.Figures[3].Length = 3, 'Test case 2 failed');



  MainField.SetData(4,15,2);
  MainField.SetData(7,15,2);
  MainField.SetData(9,15,2);
  MainField.SetData(6,15,2);
  MainField.SetData(8,15,0);
  Assert(MainField.Figures[5].Length = 3, 'Test case 3 failed');
  //MainField.SetData(5,15,2);
  //Assert(MainField.Data[6,15].Figure[5] = 4, 'Test case 3 failed'); }

  MainField.SetData(14,0,2);
  MainField.SetData(11,0,2);
  MainField.SetData(9,0,2);
  MainField.SetData(12,0,2);
  MainField.SetData(10,0,0);
  Assert(MainField.Figures[7].Length = 3, 'Test case 4 failed');
  MainField.SetData(5,15,0);

  MainField.SetData(4,0,2);
  MainField.SetData(3,0,2);
  MainField.SetData(2,0,2);
  Assert(MainField.Figures[11].Length = 4, 'Test case 5 failed');
  Assert(MainField.Figures[11].Hole = True, 'Test case 5 failed');

  MainField.SetData(15,15,0);
  MainField.SetData(11,15,0);
  MainField.SetData(12,15,0);
  MainField.SetData(13,15,0);
  Assert(MainField.Figures[12].Length = 4, 'Test case 6 failed');
  Assert(MainField.Figures[12].Hole = True, 'Test case 6 failed');
  MainField.SetData(15,14,2);
  MainField.SetData(11,14,2);
  MainField.SetData(13,14,2);
  MainField.SetData(12,14,2);
  Assert(MainField.Figures[13].Length = 4, 'Test case 6 failed');
  Assert(MainField.Figures[13].Hole = True, 'Test case 6 failed');

  Repaint;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  NewGame;
  MainField.SetData(6,7,2);
  MainField.SetData(6,8,0);
  MainField.SetData(7,8,2);
  MainField.SetData(5,6,0);
  MainField.SetData(7,7,2);
  MainField.SetData(5,7,0);
  MainField.SetData(7,9,2);
  MainField.SetData(7,6,0);
  MainField.SetData(7,10,2);
  MainField.SetData(7,11,0);
  MainField.SetData(8,9,2);
  MainField.SetData(5,5,0);
  MainField.SetData(5,8,2);
  MainField.SetData(5,4,0);
  MainField.SetData(5,3,2);
  MainField.SetData(6,6,0);
  MainField.SetData(8,6,2);
  MainField.SetData(4,6,0);
  MainField.SetData(3,6,2);
  HardTurn(MainField,2,0);

  Repaint;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  if NTurn>=sqr(GridSize) then exit;
  HardTurn(MainField,2,0);
  Repaint;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  if NTurn>=sqr(GridSize) then exit;
  HardTurn(MainField,0,0);
  Repaint;
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  Filename: string;
  FileLines: TStringList;
  Values: TArray<Integer>;
  Line, Index: Integer;
  LineValues: TStringList;
begin
  if not OpenDialog1.Execute then exit;
  NewGame;
  Filename := OpenDialog1.FileName;
   FileLines := TStringList.Create;
  LineValues := TStringList.Create;
  try
    FileLines.LoadFromFile(Filename);

    // Set the length of the Values array based on the number of lines in the file
    SetLength(Values, FileLines.Count);

    for Line := 0 to FileLines.Count - 1 do
    begin
      // Split the line into individual values using colons as the delimiter
      LineValues.Delimiter := ':';
      LineValues.DelimitedText := FileLines[Line];
      SetLength(Values,LineValues.Count);
      // Convert the string values to integers and store them in the array
      for Index := 0 to LineValues.Count - 1 do
        Values[Index] := StrToInt(LineValues[Index]);
      MainField.SetData(Values[0],Values[1],Values[2]);
    end;
  finally
    FileLines.Free;
    LineValues.Free;
  end;
  Repaint;
end;

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
                             else Canvas.Pen.Color := clBlue;
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
