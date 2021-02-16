object Form1: TForm1
  Left = 241
  Top = 210
  Caption = 'Bin2Mdl'
  ClientHeight = 287
  ClientWidth = 504
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 16
    Top = 16
    Width = 50
    Height = 13
    Caption = 'Source Dir'
  end
  object Label3: TLabel
    Left = 16
    Top = 43
    Width = 90
    Height = 13
    Caption = 'Destination Dir'
  end
  object Button1: TButton
    Left = 159
    Top = 67
    Width = 186
    Height = 25
    Caption = 'Convert Bin to Mdl'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 112
    Top = 13
    Width = 273
    Height = 21
    TabOrder = 1
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 112
    Top = 40
    Width = 273
    Height = 21
    TabOrder = 2
    Text = 'Edit1'
  end
  object Memo1: TMemo
    Left = 8
    Top = 158
    Width = 488
    Height = 121
    Lines.Strings = (
      '')
    TabOrder = 3
  end
  object sf: SE_SearchFiles
    SubDirectories = False
    Left = 392
    Top = 16
  end
end
