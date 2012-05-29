object frmMain: TfrmMain
  Left = 456
  Top = 208
  BorderStyle = bsDialog
  Caption = 'JY-Delphi-ToolBox Test Project'
  ClientHeight = 522
  ClientWidth = 780
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 780
    Height = 522
    ActivePage = TabSheet1
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'FTP URL'
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 65
        Height = 21
        AutoSize = False
        Caption = 'URL:'
        Layout = tlCenter
      end
      object Edit1: TEdit
        Left = 72
        Top = 8
        Width = 693
        Height = 21
        TabOrder = 0
        Text = 'Edit1'
      end
      object Button1: TButton
        Left = 8
        Top = 36
        Width = 141
        Height = 25
        Caption = 'Button1'
        TabOrder = 1
      end
    end
  end
end
