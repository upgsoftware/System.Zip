{
--------------------------------------------------------------------------------
--  SISTEMA...............: Zip                                               --
--  LINGUAGEM/DB..........: Delphi 10.3 Rio (32 bits / 64 bits )              --
--  DATA..................: 09/01/2020                                        --
--  AUTOR/PROGRAMADOR.....: Vinicius Fernandes (2021)                         --
--  E-MAIL................: upgsoftware@gmail.com                             --
--------------------------------------------------------------------------------
--  Você pode comercializar o codigo-fonte. Nem mesmo parcialmente!           --
--  Codigo-fonte livre pra estudo.                                            --
--------------------------------------------------------------------------------
}

unit Zip.View.Principal;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  Winapi.ShellAPI, // Necessária
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Zip, // Necessária
  FileCtrl,  // Necessária
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.Menus;

const
  SELDIRHELP = 1000;

type
  TFrmPrincipal = class(TForm)
    ListBox: TListBox;
    BtnNovo: TButton;
    BtnCompactar: TButton;
    LabelProgressoArquivo: TLabel;
    LabelPorcentagemArquivo: TLabel;
    ProgressBar1: TProgressBar;
    LabelPorcentagemGeral: TLabel;
    LabelProgressoGeral: TLabel;
    ProgressBar2: TProgressBar;
    BtnFechar: TButton;
    EditArquivoZip: TEdit;
    LabelArquivoZip: TLabel;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    BtnAbrir: TButton;
    BtnExtrair: TButton;
    chAbrirAposCompactacao: TCheckBox;
    Bevel1: TBevel;
    PM: TPopupMenu;
    Adicionar1: TMenuItem;
    Adicionarpasta1: TMenuItem;
    BtnAdicionar: TButton;
    N1: TMenuItem;
    Excluir1: TMenuItem;
    LimparTudo1: TMenuItem;
    N2: TMenuItem;
    Extrairarquivo1: TMenuItem;
    ExtrairTudo1: TMenuItem;
    procedure BtnNovoClick(Sender: TObject);
    procedure BtnCompactarClick(Sender: TObject);
    procedure BtnFecharClick(Sender: TObject);
    procedure BtnAbrirClick(Sender: TObject);
    procedure ListBoxDblClick(Sender: TObject);
    procedure BtnExtrairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnAdicionarClick(Sender: TObject);
    procedure Adicionarpasta1Click(Sender: TObject);
    procedure LimparTudo1Click(Sender: TObject);
    procedure Excluir1Click(Sender: TObject);
    procedure ExtrairTudo1Click(Sender: TObject);
    procedure Extrairarquivo1Click(Sender: TObject);
  private
    { Private declarations }
    BytesParaCompactar: cardinal;
    BytesProcessados: cardinal;
    function ObterTamanhoArquivo(const NomeArquivo: string): integer;
    function ObterTamanhoTotalParaCompactacao: integer;
    function TemAtributo(Attr, Val: Integer): Boolean;
    procedure Limpar;
    procedure Habilita_Controles( Values : Boolean);
    procedure ListarArquivos(Diretorio: string; Sub: Boolean);
    procedure EventoOnProgress(Sender: TObject; FileName: string; Header: TZipHeader; Position: Int64);
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

{ TFrmPrincipal }

procedure TFrmPrincipal.BtnNovoClick(Sender: TObject);
begin
  {Criada = 09/01/2021}
  OpenDialog.DefaultExt := '';
  OpenDialog.Filter     := '';
  OpenDialog.Options    := [ ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing ];
  if OpenDialog.Execute then
     begin
     Limpar;
     ListBox.Items := OpenDialog.Files;
     end;
end;

procedure TFrmPrincipal.Adicionarpasta1Click(Sender: TObject);
Var
  Dir : String;
begin
  {Criada = 09/01/2022}
  Dir := GetCurrentDir;
  // Adcionar uma pasta de arquivos
  if FileCtrl.SelectDirectory(Dir, [sdAllowCreate, sdPerformCreate,
     sdPrompt],SELDIRHELP) then
     begin
     ListarArquivos(Dir,True);
     end;
	 
	 
	 
end;

procedure TFrmPrincipal.BtnAdicionarClick(Sender: TObject);
begin
  {Criada = 09/01/2021}
  OpenDialog.DefaultExt := '';
  OpenDialog.Options    := [ ofHideReadOnly, ofEnableSizing ];
  if OpenDialog.Execute then
     begin
     ListBox.Items.Add(OpenDialog.FileName);
     end;
end;

procedure TFrmPrincipal.BtnCompactarClick(Sender: TObject);
var
  ZipFile: TZipFile;
  Arquivo: string;
begin
  {Criada = 09/01/2021}

  // Se foi adcionado arquivos pra compactar, se não estiverem preenchidos corretamente, a ação é descontinuada
  if ListBox.Items.Count = 0 then
     begin
     ShowMessage('Adicione alguns arquivos!');
     Exit;
     end;

  // Configura o diretório inicial do SaveDialog para a pasta da aplicação
  SaveDialog.InitialDir := GetCurrentDir;

  // Exibe o caminho e nome do arquivo Zip que será criado
  if SaveDialog.Execute then
     begin
     EditArquivoZip.Text := SaveDialog.FileName;
     end;

  // Se o nome do arquivo esta preenchido, se não estiverem preenchidos corretamente, a ação é descontinuada
  if EditArquivoZip.GetTextLen = 0 then
     begin
     ShowMessage('Especifique o nome do arquivo zip!');
     Exit;
     end;

  // Desabilita os botões para evitar que seja pressionado novamente durante a compactação
  Habilita_Controles(False);

  BytesProcessados := 0;

  // Obtém o tamanho total para compactação (soma do tamanho de todos os arquivos)
  BytesParaCompactar := ObterTamanhoTotalParaCompactacao;

  // Cria uma instância da classe TZipFIle
  ZipFile := TZipFile.Create;
  try
    // Especifica o arquivo de destino selecionado pelo componente SaveDialog
    //ZipFile.Open(SaveDialog.FileName, zmWrite);

    ZipFile.Open(EditArquivoZip.Text, zmWrite);

    // Associa o evento OnProgress
    ZipFile.OnProgress := EventoOnProgress;

    // Percorre os arquivos adicionados na ListBox para compactá-los
    for Arquivo in ListBox.Items do
        begin
        ZipFile.Add(Arquivo);
        // Atualiza a variável que armazena a quantidade de bytes processados
        BytesProcessados := BytesProcessados + ZipFile.FileInfo[Pred(ZipFile.FileCount)].UncompressedSize;
        end;

    ShowMessage('Compactação concluída.');

    // Abre o arquivo Zip criado
    if chAbrirAposCompactacao.Checked then
       begin
       if FileExists(EditArquivoZip.Text) then
          ShellExecute(0, nil, PChar(EditArquivoZip.Text), nil,  nil, SW_SHOWNORMAL);
       end;

  finally
    // Libera o objeto da memória
    ZipFile.Free;
    // Habilita novamente os botões da tela
    Habilita_Controles(True);
  end;
end;

procedure TFrmPrincipal.BtnFecharClick(Sender: TObject);
begin
  {Criada = 09/01/2021}
  Application.Terminate;
end;

procedure TFrmPrincipal.BtnAbrirClick(Sender: TObject);
var
  ZipFile : TZipFile;
  i       : Integer;
begin
  {Criada = 09/01/2021}
  OpenDialog.DefaultExt := 'zip';
  openDialog.Filter     := 'Arquivo ZIP|*.zip';
  openDialog.Options    := [ ofHideReadOnly, ofEnableSizing ];
  if openDialog.Execute then
     begin
     if ZipFile.IsValid(openDialog.FileName) then
        begin
        try
          EditArquivoZip.Text := openDialog.FileName;
          ZipFile := TZipFile.Create;
          ZipFile.Open(openDialog.FileName, zmRead);
          ListBox.Clear;

          for i:= Low(zipfile.FileNames) to High(zipfile.FileNames) do
              begin
              ListBox.Items.Add(ZipFile.FileName[I])
              end;
        finally
          FreeAndNil(ZipFile);
        end;
        end
     else
        begin
        ShowMessage('Arquivo zip inválido.');
        end;
     end;
end;

procedure TFrmPrincipal.BtnExtrairClick(Sender: TObject);
var
  ZipFile : TZipFile;
  Dir     : string;
begin
  {Criada = 09/01/2021}
  if EditArquivoZip.GetTextLen = 0 then
     begin
     ShowMessage('Abra o arquivo zip!');
     Exit;
     end;

  // Verifica arquivo zip foi aberto
  if ListBox.Items.Count = 0 then
     begin
     ShowMessage('Adicione alguns arquivos!');
     Exit;
     end;

  // Verifica se o arquivo zip e válido
  if not ZipFile.IsValid(EditArquivoZip.Text) then
     begin
     ShowMessage('Arquivo zip inválido.');
     end;

  // Configura o diretório inicial do SelectDirectory para a pasta da aplicação
  Dir := GetCurrentDir;

  if FileCtrl.SelectDirectory(Dir, [sdAllowCreate, sdPerformCreate, sdPrompt],
     SELDIRHELP) then
     begin


     // Desabilita os botões para evitar que seja pressionado novamente durante a descompactação
     Habilita_Controles(False);
     try
       ZipFile := TZipFile.Create;
       try
         // abre o arquivo pra desompactação
         ZipFile.Open(EditArquivoZip.Text, zmRead);
         // extrai todos os arquivos
         ZipFile.ExtractAll(Dir);
         // Associa o evento OnProgress
         ZipFile.OnProgress := EventoOnProgress;
         // Fecha o arquivo zip
         ZipFile.Close;
       finally
         FreeAndNil(ZipFile);
       end;
       //Deletar o arquivo zip caso queira excluir
       //DeleteFile(ZipFile);
       ShowMessage('Desompactação concluída.');
     except
       ShowMessage('Erro na desompactação.');
     end;
     // Habilita novamente os botões da tela
     Habilita_Controles(True);
     end;
end;

procedure TFrmPrincipal.EventoOnProgress(Sender: TObject; FileName: string;
  Header: TZipHeader; Position: Int64);
var
  PorcentagemArquivo: real;
  PorcentagemGeral: real;
begin
  {Criada = 09/01/2021}
  Application.ProcessMessages;

  // Exibe o nome do arquivo atualmente em compactação
  LabelProgressoArquivo.Caption := Format('Progresso do arquivo "%s":', [ExtractFileName(FileName)]);

  // Calcula a porcentagem de conclusão do arquivo
  PorcentagemArquivo := Position / Header.UncompressedSize * 100;
  // Calcula a porcentagem de conclusão geral
  PorcentagemGeral := (BytesProcessados + Position) / BytesParaCompactar * 100;

  // Preenche as Labels com as porcentagens calculadas
  LabelPorcentagemArquivo.Caption := FormatFloat('#.## %', PorcentagemArquivo);
  LabelPorcentagemGeral.Caption := FormatFloat('#.## %', PorcentagemGeral);

  // Atualiza as barras de progresso de acordo com as porcentagens
  ProgressBar1.Position := Trunc(PorcentagemArquivo);
  ProgressBar2.Position := Trunc(PorcentagemGeral);
end;

procedure TFrmPrincipal.Excluir1Click(Sender: TObject);
begin
  {Criada = 09/01/2021}
  ListBoxDblClick(Sender);
end;

procedure TFrmPrincipal.Extrairarquivo1Click(Sender: TObject);
var
  ZipFile : TZipFile;
  Dir     : string;
  Arquivo : String;
begin
  {Criada = 09/01/2021}
  if EditArquivoZip.GetTextLen = 0 then
     begin
     ShowMessage('Abra o arquivo zip!');
     Exit;
     end;

  // Verifica arquivo zip foi aberto
  if ListBox.Items.Count = 0 then
     begin
     ShowMessage('Adicione alguns arquivos!');
     Exit;
     end;

  // Verifica se o arquivo zip e válido
  if not ZipFile.IsValid(EditArquivoZip.Text) then
     begin
     ShowMessage('Arquivo zip inválido.');
     end;

  // Configura o diretório inicial do SelectDirectory para a pasta da aplicação
  Dir := GetCurrentDir;

  if FileCtrl.SelectDirectory(Dir, [sdAllowCreate, sdPerformCreate, sdPrompt],
     SELDIRHELP) then
     begin
     // Pega o arquivo selecionado no listbox
     Arquivo := ListBox.Items[(ListBox.ItemIndex)];

     try
       ZipFile := TZipFile.Create;
       try
         // abre o arquivo pra desompactação
         ZipFile.Open(EditArquivoZip.Text, zmRead);
         // extrai todos os arquivos
         ZipFile.Extract(Arquivo, Dir, False);
         // Associa o evento OnProgress
         ZipFile.OnProgress := EventoOnProgress;
         // Fecha o arquivo zip
         ZipFile.Close;
       finally
         FreeAndNil(ZipFile);
       end;
       //Deletar o arquivo zip caso queira excluir
       //DeleteFile(ZipFile);
       ShowMessage('Desompactação concluída.');
     except
       ShowMessage('Erro na desompactação.');
     end;
     end;
end;

procedure TFrmPrincipal.ExtrairTudo1Click(Sender: TObject);
begin
  {Criada = 09/01/2021}
  BtnExtrairClick(Sender);
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  {Criada = 09/01/2021}
  limpar;
end;

procedure TFrmPrincipal.Habilita_Controles(Values: Boolean);
begin
  {Criada = 09/01/2021}
  BtnNovo.Enabled      := Values;
  BtnAdicionar.Enabled := Values;
  BtnAbrir.Enabled     := Values;
  BtnExtrair.Enabled   := Values;
  BtnFechar.Enabled    := Values;
end;

procedure TFrmPrincipal.Limpar;
begin
  {Criada = 09/01/2021}
  // Limpa os componentes na tela
  ListBox.Clear;
  ProgressBar1.Position := 0;
  ProgressBar2.Position := 0;
  EditArquivoZip.Text   := 'Arquivo.zip';
  OpenDialog.DefaultExt := '';
  openDialog.Filter     := '';
end;

procedure TFrmPrincipal.LimparTudo1Click(Sender: TObject);
begin
  {Criada = 09/01/2021}
  Limpar;
end;

procedure TFrmPrincipal.ListarArquivos(Diretorio: string; Sub: Boolean);
var
  F: TSearchRec;
  Ret: Integer;
  TempNome: string;
begin
  {Criada = 09/01/2021}
  Ret := FindFirst(Diretorio + '\*.*', faAnyFile, F);
  try
    while Ret = 0 do
          begin
          if TemAtributo(F.Attr, faDirectory) then
              begin
              if (F.Name <> '.') and (F.Name <> '..') then
                 if Sub = True then
                    begin
                    TempNome := Diretorio + '\' + F.Name;
                    ListarArquivos(TempNome, True);
                    end;
              end
          else
              begin
              ListBox.Items.Add(Diretorio + '\' + F.Name);
              end;
          Ret := FindNext(F);
          end;
  finally
    begin
    FindClose(F);
    end;
  end;
end;

procedure TFrmPrincipal.ListBoxDblClick(Sender: TObject);
begin
  {Criada = 09/01/2021}
  // Confirmar a exclusão do aquivo no listbox.
  if Application.messageBox('Deseja Excluir esse Registro?','Confirmação',
     mb_YesNo+mb_IconInformation+mb_DefButton2) = IdYes  then
     begin
     ListBox.Items.Delete(ListBox.ItemIndex); {Remover da listagem}
     end;
end;

function TFrmPrincipal.ObterTamanhoArquivo(const NomeArquivo: string): integer;
var
  StreamArquivo: TFileStream;
begin
  {Criada = 09/01/2021}
  // Cria uma instância da classe TFileStream em modo de leitura do arquivo
  StreamArquivo := TFileStream.Create(NomeArquivo, fmOpenRead);
  try
    // Obtém o tamanho do arquivo
    result := StreamArquivo.Size;
  finally
    // Libera o objeto da memória
    StreamArquivo.Free;
  end;
end;

function TFrmPrincipal.ObterTamanhoTotalParaCompactacao: integer;
var
  Arquivo: string;
begin
  {Criada = 09/01/2021}
  result := 0;
  // Percorre os arquivos adicionados na ListBox para obter o tamanho de cada um
  for Arquivo in ListBox.Items do
      result := result + ObterTamanhoArquivo(Arquivo);
end;

function TFrmPrincipal.TemAtributo(Attr, Val: Integer): Boolean;
begin
  {Criada = 09/01/2021}
  Result := Attr and Val = Val;
end;

end.
