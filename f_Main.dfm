object MainForm: TMainForm
  Left = 0
  Top = 0
  ActiveControl = ListView
  Caption = 'Kerbal Science History'
  ClientHeight = 547
  ClientWidth = 781
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 17
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 781
    Height = 107
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      781
      107)
    object Label1: TLabel
      Left = 8
      Top = 17
      Width = 53
      Height = 17
      Caption = 'Save File:'
    end
    object Bevel1: TBevel
      Left = 0
      Top = 63
      Width = 793
      Height = 11
      Anchors = [akLeft, akTop, akRight]
      Shape = bsBottomLine
      ExplicitWidth = 865
    end
    object Label2: TLabel
      Left = 8
      Top = 46
      Width = 65
      Height = 17
      Caption = 'Game Title:'
    end
    object btnRefresh: TPngSpeedButton
      Left = 8
      Top = 77
      Width = 110
      Height = 25
      Action = RefreshAction
    end
    object btnExpandAll: TPngSpeedButton
      Left = 125
      Top = 77
      Width = 110
      Height = 25
      Action = ExpandAllAction
    end
    object btnCollapseAll: TPngSpeedButton
      Left = 243
      Top = 77
      Width = 110
      Height = 25
      Action = CollapseAllAction
    end
    object btnBrowse: TPngSpeedButton
      Left = 489
      Top = 13
      Width = 88
      Height = 27
      Action = BrowseAction
    end
    object Label3: TLabel
      Left = 384
      Top = 80
      Width = 55
      Height = 17
      Caption = 'Focus on:'
    end
    object edtSaveFileName: TEdit
      Left = 106
      Top = 14
      Width = 377
      Height = 25
      ParentShowHint = False
      ReadOnly = True
      ShowHint = False
      TabOrder = 0
    end
    object edtGameTitle: TEdit
      Left = 106
      Top = 43
      Width = 377
      Height = 25
      ReadOnly = True
      TabOrder = 1
    end
    object cmbFocus: TComboBox
      Left = 449
      Top = 77
      Width = 152
      Height = 25
      Style = csDropDownList
      TabOrder = 2
      OnChange = cmbFocusChange
    end
  end
  object ListView: TListView
    Left = 0
    Top = 107
    Width = 781
    Height = 440
    Align = alClient
    BorderStyle = bsNone
    Columns = <
      item
        Caption = 'Experiment Name'
        MinWidth = 50
        Width = 250
      end
      item
        Alignment = taCenter
        Caption = 'Landed'
        MaxWidth = 80
        MinWidth = 80
        Width = 80
      end
      item
        Alignment = taCenter
        Caption = 'Splashed'
        MaxWidth = 80
        MinWidth = 80
        Width = 80
      end
      item
        Alignment = taCenter
        Caption = 'Fly Low'
        MaxWidth = 80
        MinWidth = 80
        Width = 80
      end
      item
        Alignment = taCenter
        Caption = 'Fly High'
        MaxWidth = 80
        MinWidth = 80
        Width = 80
      end
      item
        Alignment = taCenter
        Caption = 'Space Low'
        MaxWidth = 80
        MinWidth = 80
        Width = 80
      end
      item
        Caption = 'Space High'
        MaxWidth = 80
        MinWidth = 80
        Width = 80
      end>
    ColumnClick = False
    DoubleBuffered = True
    FlatScrollBars = True
    IconOptions.Arrangement = iaLeft
    GroupView = True
    ReadOnly = True
    RowSelect = True
    ParentDoubleBuffered = False
    SmallImages = Images
    SortType = stText
    TabOrder = 1
    ViewStyle = vsReport
    OnAdvancedCustomDrawSubItem = ListViewAdvancedCustomDrawSubItem
    OnCompare = ListViewCompareItem
  end
  object dlgFileOpen: TFileOpenDialog
    FavoriteLinks = <>
    FileName = 'persistent.sfs'
    FileNameLabel = 'KSP Save file:'
    FileTypes = <
      item
        DisplayName = 'Save file (*.sfs)'
        FileMask = '*.sfs'
      end>
    Options = [fdoNoChangeDir, fdoFileMustExist, fdoNoTestFileCreate]
    Left = 728
    Top = 8
  end
  object Images: TPngImageList
    PngImages = <
      item
        Background = clWindow
        Name = 'PngImage0'
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000001654944415478DA6364C0
          02424343995959598D191919A5A1424F7EFDFA756EF5EAD57FD1D532A2696403
          822220B31488F980F805548D38107F04E22EA041138006FDC23020262646F2FF
          FFFFEB814C69205DFBFBF7EFF54085204D0C09090902407E1090D90CC40FFFFD
          FB17B87CF9F2977003D2D2D2B8BE7EFD7A18E8E46F4C4C4C018B162D7A8BCD6B
          9191912240F90D402613D0250E209730426DAF05DA9AC6CCCC6C804B339A2117
          81964D58B26449372328C080FE06F9B57CE9D2A5F3188800D1D1D1A920EFA8AA
          AA4A31C6C6C69A03FD741418EA220B162CF8408C01404B858096BE02BAC48211
          685A3850AC1768BB0C319A915CF114E8ED028A0C00864321C8000B20FF08D034
          D165CB96BD2746735C5C9CF0DFBF7F5F82BD801488B54057CC20D2F66C907A70
          2042052A815436301AF5898CC64B40E7F783A31124E8E9E9C92E2424741028F8
          9BAC840402C0E42A014CAE2049D2933252FC929F99D00C223A3B03002E65CA78
          E106C8970000000049454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage1'
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000001A54944415478DAA593BF
          4B425114C7DF7D6241438414FD30280AA7A08282A4A9D5AD026B50C1C9A51FA4
          10D1E0E45664D254BB0F0707FD17C282A6402797B2A020DB1A6C78FA9E7DAEBC
          225E9252070EF7DCEF3DE77BCF39F75CA1B411BFDFEF703A9D0B4208B7053DE9
          BA7E9BCD660DBBAFB005F62031CC7DB41F7DB17C86D137F408A21444FA0F8260
          3038DA6C3673986ED678BD5ECFE128839470383CC07E1D33813E9AA6B996C964
          AA5F049148A4AF56AB1548F95D55D5D546A331031C653F6BF117094AB29639CF
          B3AA64B2223311D6ED716E8D381C8E79C3304240497B798809618C730D922276
          2A9D4E1F0BD930EA96B51E0096212AC81B94F66212BC4C3632B384C7E31913A1
          506809E09AAE0F52E705071BCAEF9221FD6D2E7D85CC2B0281C026E089A669E3
          D815ECC90E04F7F84EE3FB4CB67B768207EC890E04157CA724012547258117F0
          0AB62180F36E4AA0D93B34B3DA2AE15B13E31094BA6CE2A2F46F3551A26471C8
          B205F35C97CF58C23E6D3DA33CF1F97CBD2E97EB12B02E0709270FF02EBA6405
          DF809F3160776D07C91AD7119E31FFA751FE947F7D261B51D7DFF90352E3F478
          9BA377760000000049454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'Refresh_16px'
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000001334944415478DA6364A0
          103052DD004F4F4F766161E1D8FFFFFF4701B9AA40CCCCC8C87817C89FFFEBD7
          AF25ECECEC5620754B962C398061406464A4081313D31E20F32550530F90BE02
          A4FF02356B01713590CF0DC4C780625F800634A018D0D0D0C074FBF6ED6340E6
          9EA54B97D660736D4C4C4C3DD0A024207B3E504D3D8A01515151A14093338112
          4ED8FC1A1D1DFD1F89DB0554578EE185D8D858EEC58B177F1DD858A0B901E8DE
          440EC45E602016C1F8C040C26A3830260E0063620A507E0DBA014D4003128192
          73962D5BD6884D333026DA8094BDAAAAAA2D30DAFFA1180034B901A89907C8B4
          03E27740C326B3B0B01CFDFAF5EB7F56565653A05819508C0BC8F659B060C107
          0C2F000D7000D1404D27FEFCF9130F342C11C8D506E2BF407C1188670393F2F2
          D5AB57FF1DD8584007006AF57B11BFF8D7A00000000049454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'Expand Arrow_16px'
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000B04944415478DA6364A0
          10308E1A0031202A2A4A8999995961F1E2C5FB88D1141D1DEDFCFFFFFFFBCB96
          2DBB0736202626C61628B08E9191316AC99225BBF16906AA7505AA5D06541B04
          547B18EE85C8C8484B2626A64D408964A0C4261C9AFD809AE7FEFBF7CF6FF9F2
          E5C731C2009F21D834630D44982140854940859BF169C6190BC88680F840F63C
          6C9AF14623D0107B60CCAC06B1819A4380217E086734E23304181EFF71692668
          003160E00D0000F4C26811888D175A0000000049454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'Collapse Arrow_16px'
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000B14944415478DA6364A0
          10300E6E03222323ED191919FF2F5BB6EC10C9068034333333AF06B1FFFDFB17
          82CB10AC06C4C4C478FFFFFF7F01D0767F200D52B301C84E58B264C9568206C0
          340399014B972E3D0A128B8E8EB6C665082321CD3080CB104634CD0B814C7F74
          CD68866C041A120F338411AAD916A8791D50220A28B11B5FCC00D5BA02D52E03
          AA0D02AA3D0C36202A2A4A0918E20A8B172FDEC7400400BAC41968C87D60CCDC
          1BE4297168180000E5175C112E0766C00000000049454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'Opened Folder_16px'
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000F54944415478DA6364A0
          1030C2185151512E4C4C4C0540E673207E8B4FD3BF7FFFF62C5BB66C0F8A01D1
          D1D12D402A0588B981F83F10DC676464BC0F547C0D487F84DBC8C8E802C44797
          2C59D28062404C4C0C58002401344C0BC87404E224A0E2CD30C5E8EA701A408A
          187D0D484B4B63FDFAF5EB6660F88002B18728038081280D549C0A8DA9125020
          727373FBCE9A35EB37410380812903A4F60135D503C597635383D70074F11160
          4015902A0086FA51207D161870678179E3ECDFBF7F3B80EC44B80646C646AC06
          2085BA29109B01E3DA0CA8D818C86607D29DE82EC36A003A68686860BA79F3A6
          1A3333F37FA00137B1A901007BEFBE118ADBB6840000000049454E44AE426082}
      end>
    Left = 712
    Top = 64
  end
  object MainActions: TActionList
    Images = Images
    Left = 648
    Top = 16
    object RefreshAction: TAction
      Caption = 'Refresh'
      ImageIndex = 2
      ImageName = 'Refresh_16px'
      OnExecute = RefreshActionExecute
    end
    object ExpandAllAction: TAction
      Caption = 'Expand All'
      ImageIndex = 3
      ImageName = 'Expand Arrow_16px'
      OnExecute = ExpandAllActionExecute
    end
    object CollapseAllAction: TAction
      Caption = 'Collapse All'
      ImageIndex = 4
      ImageName = 'Collapse Arrow_16px'
      OnExecute = CollapseAllActionExecute
    end
    object BrowseAction: TAction
      Caption = 'Browse...'
      ImageIndex = 5
      ImageName = 'Opened Folder_16px'
      ShortCut = 16463
      OnExecute = BrowseActionExecute
    end
  end
end
