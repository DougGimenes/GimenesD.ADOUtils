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
  OldCreateOrder = True
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
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
      Width = 627
      Height = 277
      Anchors = [akLeft, akTop, akRight, akBottom]
      DataSource = DsConsulta
      Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
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
      Width = 627
      Height = 26
      Anchors = [akLeft, akTop, akRight]
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
end
