object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  Caption = 'System.Zip'
  ClientHeight = 416
  ClientWidth = 550
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  DesignSize = (
    550
    416)
  PixelsPerInch = 96
  TextHeight = 13
  object LabelProgressoArquivo: TLabel
    Left = 15
    Top = 301
    Width = 311
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Caption = 'Progresso do arquivo:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitTop = 272
    ExplicitWidth = 345
  end
  object LabelPorcentagemArquivo: TLabel
    Left = 515
    Top = 305
    Width = 20
    Height = 13
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Caption = '0 %'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitTop = 276
  end
  object LabelPorcentagemGeral: TLabel
    Left = 515
    Top = 346
    Width = 20
    Height = 13
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Caption = '0 %'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitTop = 317
  end
  object LabelProgressoGeral: TLabel
    Left = 15
    Top = 346
    Width = 79
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Progresso geral:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitTop = 317
  end
  object LabelArquivoZip: TLabel
    Left = 15
    Top = 59
    Width = 81
    Height = 13
    Caption = 'Nome do arquivo'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 15
    Top = 290
    Width = 520
    Height = 2
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsBottomLine
    ExplicitTop = 261
  end
  object ListBox: TListBox
    Left = 15
    Top = 112
    Width = 520
    Height = 162
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    PopupMenu = PM
    TabOrder = 1
    OnDblClick = ListBoxDblClick
  end
  object BtnNovo: TButton
    Left = 15
    Top = 10
    Width = 80
    Height = 40
    Caption = 'Novo'
    TabOrder = 0
    OnClick = BtnNovoClick
  end
  object BtnCompactar: TButton
    Left = 282
    Top = 10
    Width = 80
    Height = 40
    Caption = 'Compactar!'
    TabOrder = 5
    OnClick = BtnCompactarClick
  end
  object ProgressBar1: TProgressBar
    Left = 15
    Top = 321
    Width = 520
    Height = 20
    Anchors = [akLeft, akRight, akBottom]
    Smooth = True
    TabOrder = 3
  end
  object ProgressBar2: TProgressBar
    Left = 15
    Top = 365
    Width = 520
    Height = 20
    Anchors = [akLeft, akRight, akBottom]
    Step = 1
    TabOrder = 4
  end
  object BtnFechar: TButton
    Left = 460
    Top = 10
    Width = 75
    Height = 40
    Anchors = [akTop, akRight]
    Caption = 'Fechar'
    TabOrder = 6
    OnClick = BtnFecharClick
  end
  object EditArquivoZip: TEdit
    Left = 15
    Top = 78
    Width = 520
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
  end
  object BtnAbrir: TButton
    Left = 193
    Top = 10
    Width = 80
    Height = 40
    Caption = 'Abrir'
    TabOrder = 7
    OnClick = BtnAbrirClick
  end
  object BtnExtrair: TButton
    Left = 371
    Top = 10
    Width = 80
    Height = 40
    Caption = 'Extrair'
    TabOrder = 8
    OnClick = BtnExtrairClick
  end
  object chAbrirAposCompactacao: TCheckBox
    Left = 407
    Top = 394
    Width = 136
    Height = 17
    Anchors = [akRight, akBottom]
    Caption = 'Abrir ap'#243's compacta'#231#227'o'
    Checked = True
    State = cbChecked
    TabOrder = 9
  end
  object BtnAdicionar: TButton
    Left = 104
    Top = 10
    Width = 80
    Height = 40
    Caption = 'Adicionar'
    TabOrder = 10
    OnClick = BtnAdicionarClick
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'zip'
    Filter = 'Arquivo ZIP|*.zip'
    Left = 124
    Top = 221
  end
  object OpenDialog: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 52
    Top = 216
  end
  object PM: TPopupMenu
    Left = 52
    Top = 168
    object Adicionar1: TMenuItem
      Caption = 'Adicionar arquivo'
      OnClick = BtnAdicionarClick
    end
    object Adicionarpasta1: TMenuItem
      Caption = 'Adicionar pasta'
      OnClick = Adicionarpasta1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Excluir1: TMenuItem
      Caption = 'Excluir'
      OnClick = Excluir1Click
    end
    object LimparTudo1: TMenuItem
      Caption = 'Limpar Tudo'
      OnClick = LimparTudo1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Extrairarquivo1: TMenuItem
      Caption = 'Extrair arquivo'
      OnClick = Extrairarquivo1Click
    end
    object ExtrairTudo1: TMenuItem
      Caption = 'Extrair Tudo'
      OnClick = ExtrairTudo1Click
    end
  end
end
