object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 768
  ClientWidth = 1026
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 280
    Top = 288
    Width = 194
    Height = 67
    Caption = #1055#1086#1073#1077#1076#1072'!'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -50
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Visible = False
  end
  object Button1: TButton
    Left = 920
    Top = 8
    Width = 91
    Height = 25
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1086#1083#1077
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 920
    Top = 39
    Width = 91
    Height = 25
    Caption = #1058#1077#1089#1090#1099' 1'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 920
    Top = 70
    Width = 91
    Height = 25
    Caption = #1058#1077#1089#1090#1099' 2'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 920
    Top = 101
    Width = 91
    Height = 25
    Caption = #1058#1077#1089#1090#1099' 3'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 920
    Top = 132
    Width = 91
    Height = 25
    Caption = #1061#1086#1076' '#1082#1088#1077#1089#1090#1080#1082#1086#1084
    TabOrder = 4
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 920
    Top = 163
    Width = 91
    Height = 25
    Caption = #1061#1086#1076' '#1085#1086#1083#1080#1082#1086#1084
    TabOrder = 5
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 920
    Top = 194
    Width = 91
    Height = 25
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1087#1072#1088#1090#1080#1102
    TabOrder = 6
    OnClick = Button7Click
  end
  object OpenDialog1: TOpenDialog
    Left = 928
    Top = 264
  end
end
