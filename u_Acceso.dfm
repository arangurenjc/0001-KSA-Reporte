object fAcceso: TfAcceso
  Left = 0
  Top = 0
  Caption = 'fAcceso'
  ClientHeight = 124
  ClientWidth = 336
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 64
    Top = 27
    Width = 26
    Height = 13
    Caption = 'USER'
  end
  object Label2: TLabel
    Left = 64
    Top = 54
    Width = 50
    Height = 13
    Caption = 'PSSWORD'
  end
  object edtUsername: TEdit
    Left = 152
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'edtUsername'
  end
  object edtPassword: TEdit
    Left = 152
    Top = 51
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 198
    Top = 78
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
end
