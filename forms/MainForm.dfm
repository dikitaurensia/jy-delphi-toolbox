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
    ActivePage = TabSheet3
    Align = alClient
    TabIndex = 2
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
      object edtFTPFileURL: TEdit
        Left = 72
        Top = 8
        Width = 693
        Height = 21
        TabOrder = 0
        Text = 'ftp://user:password@192.168.1.168/_public/test.exe'
      end
      object btnAnalyzeFTPUrl: TButton
        Left = 8
        Top = 36
        Width = 141
        Height = 25
        Caption = 'AnalyzeFTPUrl'
        TabOrder = 1
        OnClick = btnAnalyzeFTPUrlClick
      end
      object memAnalyzeFTPUrl: TMemo
        Left = 8
        Top = 68
        Width = 753
        Height = 121
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          'memAnalyzeFTPUrl')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 2
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'FTP Download'
      ImageIndex = 1
      object Label2: TLabel
        Left = 8
        Top = 8
        Width = 65
        Height = 21
        AutoSize = False
        Caption = 'URL:'
        Layout = tlCenter
      end
      object Label3: TLabel
        Left = 8
        Top = 92
        Width = 65
        Height = 21
        AutoSize = False
        Caption = 'Local Name:'
        Layout = tlCenter
      end
      object Label4: TLabel
        Left = 8
        Top = 36
        Width = 65
        Height = 21
        AutoSize = False
        Caption = 'UserName:'
        Layout = tlCenter
      end
      object Label5: TLabel
        Left = 8
        Top = 64
        Width = 65
        Height = 21
        AutoSize = False
        Caption = 'UserName:'
        Layout = tlCenter
      end
      object edtDownloadURL: TEdit
        Left = 72
        Top = 8
        Width = 693
        Height = 21
        TabOrder = 0
        Text = 'ftp://192.168.1.168/_public/test.exe'
      end
      object Button1: TButton
        Left = 8
        Top = 120
        Width = 141
        Height = 25
        Caption = 'Download !'
        TabOrder = 1
        OnClick = Button1Click
      end
      object edtLocalFileName: TEdit
        Left = 72
        Top = 92
        Width = 693
        Height = 21
        TabOrder = 2
        Text = 'd:\jiaoyan\toll\test.exe.jyTMP'
      end
      object slvDownload: TShellListView
        Left = 8
        Top = 152
        Width = 757
        Height = 337
        ObjectTypes = [otFolders, otNonFolders]
        Root = 'C:\'
        Sorted = True
        ReadOnly = False
        HideSelection = False
        TabOrder = 3
        ViewStyle = vsReport
      end
      object Button2: TButton
        Left = 152
        Top = 120
        Width = 141
        Height = 25
        Caption = 'Refresh'
        TabOrder = 4
        OnClick = Button2Click
      end
      object edtFTPUserName: TEdit
        Left = 72
        Top = 36
        Width = 169
        Height = 21
        TabOrder = 5
        Text = 'anonymous'
      end
      object edtFTPPassword: TEdit
        Left = 72
        Top = 64
        Width = 169
        Height = 21
        TabOrder = 6
        Text = '@jysoft'
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'zLib Test'
      ImageIndex = 2
      object SpeedButton1: TSpeedButton
        Left = 744
        Top = 68
        Width = 23
        Height = 22
        Caption = '...'
        OnClick = SpeedButton1Click
      end
      object SpeedButton2: TSpeedButton
        Left = 744
        Top = 132
        Width = 23
        Height = 22
        Caption = '...'
        OnClick = SpeedButton2Click
      end
      object Button3: TButton
        Left = 8
        Top = 96
        Width = 75
        Height = 25
        Caption = 'Compress'
        TabOrder = 0
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 8
        Top = 160
        Width = 75
        Height = 25
        Caption = 'DeCompress'
        TabOrder = 1
        OnClick = Button4Click
      end
      object edtSourceFile: TEdit
        Left = 8
        Top = 68
        Width = 729
        Height = 21
        TabOrder = 2
        Text = 'edtSourceFile'
      end
      object edtD6ZLIB1File: TEdit
        Left = 8
        Top = 132
        Width = 729
        Height = 21
        TabOrder = 3
        Text = 'edtSourceFile'
      end
      object rgCompressType: TRadioGroup
        Left = 8
        Top = 8
        Width = 761
        Height = 49
        Caption = 'Compress Type'
        Columns = 5
        ItemIndex = 0
        Items.Strings = (
          'None'
          'D6Zlib1'
          'D6Zlib2')
        TabOrder = 4
      end
    end
  end
end
