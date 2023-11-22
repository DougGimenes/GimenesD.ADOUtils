object FrmConsultaBase: TFrmConsultaBase
  Left = 0
  Top = 0
  Caption = 'Consulta'
  ClientHeight = 352
  ClientWidth = 648
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  Position = poMainFormCenter
  OnShow = FormShow
  TextHeight = 18
  object PnlMain: TPanel
    Left = 0
    Top = 0
    Width = 648
    Height = 352
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      648
      352)
    object DbgConsulta: TDBGrid
      Left = 10
      Top = 56
      Width = 625
      Height = 277
      Anchors = [akLeft, akTop, akRight, akBottom]
      DataSource = DsConsulta
      Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      PopupMenu = PmnMenuExcel
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -16
      TitleFont.Name = 'Arial'
      TitleFont.Style = []
      OnDblClick = DbgConsultaDblClick
      OnKeyDown = DbgConsultaKeyDown
    end
    object EdtConsulta: TEdit
      Left = 10
      Top = 12
      Width = 625
      Height = 26
      Hint = 'Precione enter com o campo vazio para exibir todos'
      Anchors = [akLeft, akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TextHint = 'Consulta'
      OnChange = EdtConsultaChange
      OnKeyDown = EdtConsultaKeyDown
    end
  end
  object QryConsulta: TADOQuery
    Parameters = <>
    Left = 40
    Top = 128
  end
  object DsConsulta: TDataSource
    DataSet = QryConsulta
    Left = 40
    Top = 176
  end
  object TimConsulta: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = TimConsultaTimer
    Left = 40
    Top = 224
  end
  object QryAutoComplete: TADOQuery
    Parameters = <>
    Left = 120
    Top = 128
  end
  object PmnMenuExcel: TPopupMenu
    Left = 120
    Top = 176
    object MniExportarExcel: TMenuItem
      Caption = 'Exportar para Excel'
      OnClick = MniExportarExcelClick
    end
  end
end
