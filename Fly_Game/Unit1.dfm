object Form1: TForm1
  Left = 232
  Top = 131
  BorderStyle = bsSingle
  Caption = 'Fly Game'
  ClientHeight = 533
  ClientWidth = 929
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 120
  TextHeight = 16
  object Image1: TImage
    Left = 10
    Top = 10
    Width = 828
    Height = 454
  end
  object Memo1: TMemo
    Left = 20
    Top = 20
    Width = 158
    Height = 99
    TabStop = False
    Color = clInfoBk
    Lines.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6')
    ReadOnly = True
    TabOrder = 0
    Visible = False
  end
  object GroupBox1: TGroupBox
    Left = 266
    Top = 473
    Width = 247
    Height = 50
    Caption = ' Power '
    TabOrder = 1
    object PowerBar: TProgressBar
      Left = 10
      Top = 20
      Width = 228
      Height = 19
      Max = 25000
      Smooth = True
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 522
    Top = 473
    Width = 316
    Height = 50
    Caption = ' Speed '
    TabOrder = 2
    object SpeedBar: TProgressBar
      Left = 10
      Top = 20
      Width = 296
      Height = 19
      Max = 200
      Smooth = True
      TabOrder = 0
    end
  end
  object GroupBox3: TGroupBox
    Left = 138
    Top = 473
    Width = 119
    Height = 50
    Caption = ' Poids '
    TabOrder = 3
    object EditPoids: TEdit
      Left = 10
      Top = 20
      Width = 100
      Height = 24
      TabStop = False
      TabOrder = 0
      Text = 'EditPoids'
    end
  end
  object GroupBox4: TGroupBox
    Left = 10
    Top = 473
    Width = 119
    Height = 50
    Caption = ' Surface '
    TabOrder = 4
    object EditSurf: TEdit
      Left = 10
      Top = 20
      Width = 100
      Height = 24
      TabStop = False
      TabOrder = 0
      Text = 'EditSurf'
    end
  end
  object VSpeedBox: TGroupBox
    Left = 847
    Top = 10
    Width = 70
    Height = 228
    Caption = ' VSpeed '
    Color = clBtnFace
    ParentColor = False
    TabOrder = 5
    object RedAlert: TShape
      Left = 10
      Top = 203
      Width = 50
      Height = 21
      Brush.Color = clRed
      Visible = False
    end
    object BarVitZ: TTrackBar
      Left = 20
      Top = 15
      Width = 21
      Height = 183
      Max = 1000
      Min = -1000
      Orientation = trVertical
      Frequency = 200
      Position = -1000
      TabOrder = 0
      TabStop = False
      ThumbLength = 10
    end
  end
  object GroupBox6: TGroupBox
    Left = 847
    Top = 246
    Width = 70
    Height = 208
    Caption = ' Alt '
    TabOrder = 6
    object BarAlt: TProgressBar
      Left = 20
      Top = 20
      Width = 21
      Height = 178
      Max = 3000
      Orientation = pbVertical
      Smooth = True
      TabOrder = 0
    end
  end
  object GameT: TRadioGroup
    Left = 847
    Top = 463
    Width = 80
    Height = 60
    Caption = 'GameType'
    ItemIndex = 0
    Items.Strings = (
      '1'
      '2')
    TabOrder = 7
    TabStop = True
    OnClick = GameTClick
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 640
    Top = 344
  end
end
