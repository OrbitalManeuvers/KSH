unit f_Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls,
  u_CFGNode, u_CFGReader, u_CFGScienceParser, System.ImageList, Vcl.ImgList,
  PngImageList, Vcl.WinXCtrls, System.Actions, Vcl.ActnList,
  Vcl.Buttons, PngSpeedButton;

type
  TMainForm = class(TForm)
    pnlHeader: TPanel;
    Label1: TLabel;
    edtSaveFileName: TEdit;
    Bevel1: TBevel;
    dlgFileOpen: TFileOpenDialog;
    Images: TPngImageList;
    Label2: TLabel;
    edtGameTitle: TEdit;
    ListView: TListView;
    btnRefresh: TPngSpeedButton;
    MainActions: TActionList;
    RefreshAction: TAction;
    ExpandAllAction: TAction;
    CollapseAllAction: TAction;
    btnExpandAll: TPngSpeedButton;
    btnCollapseAll: TPngSpeedButton;
    btnBrowse: TPngSpeedButton;
    BrowseAction: TAction;
    Label3: TLabel;
    cmbFocus: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListViewCompareItem(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListViewAdvancedCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure RefreshActionExecute(Sender: TObject);
    procedure ExpandAllActionExecute(Sender: TObject);
    procedure CollapseAllActionExecute(Sender: TObject);
    procedure BrowseActionExecute(Sender: TObject);
    procedure cmbFocusChange(Sender: TObject);
  private
    fSaveFileName: string;
    fSaveFile: TCFGReader;
    fScience: TCFGScienceParser;
    procedure UpdateControls;
    procedure CloseAll;
    procedure LoadSaveFile;
    procedure PopulateList;
    procedure SetAllGroups(isOpen: Boolean);
    procedure SetGroup(aGroup: TListGroup; isOpen: Boolean);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses System.StrUtils, System.IOUtils, System.Generics.Collections,
  System.Generics.Defaults;

{$R *.dfm}

function GetFileVersion(AFilename: string = ''; const AFmt: string = '%d.%d.%d.%d'): string;
var
  iBufferSize: DWORD;
  iDummy: DWORD;
  pBuffer: Pointer;
  pFileInfo: Pointer;
  iVer: array[1..4] of word;
begin
  // set default value
  if AFilename = '' then
    AFileName := Application.ExeName;
  Result := '';
  // get size of version info (0 if no version info exists)
  iBufferSize := GetFileVersionInfoSize(PChar(AFilename), iDummy);
  if (iBufferSize > 0) then
  begin
    Getmem(pBuffer, iBufferSize);
    try
    // get fixed file info
      GetFileVersionInfo(PChar(AFilename), 0, iBufferSize, pBuffer);
      VerQueryValue(pBuffer, '\', pFileInfo, iDummy);
    // read version blocks
      iVer[1] := HiWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionMS);
      iVer[2] := LoWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionMS);
      iVer[3] := HiWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionLS);
      iVer[4] := LoWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionLS);
    finally
      Freemem(pBuffer);
    end;
    // format result string
    Result := Format(AFmt, [iVer[1], iVer[2], iVer[3], iVer[4]]);
  end;
end;

{ TMainForm }

procedure TMainForm.SetGroup(aGroup: TListGroup; isOpen: Boolean);
begin
  if isOpen then aGroup.State := aGroup.State - [lgsCollapsed]
  else aGroup.State := aGroup.State + [lgsCollapsed];
end;

procedure TMainForm.SetAllGroups(isOpen: Boolean);
var
  I: Integer;
begin
  ListView.Items.BeginUpdate;
  try
    for I := 0 to ListView.Groups.Count - 1 do
      SetGroup(ListView.Groups.Items[I], isOpen);
  finally
    ListView.Items.EndUpdate;
  end;
end;

procedure TMainForm.CollapseAllActionExecute(Sender: TObject);
begin
  SetAllGroups(False);
end;

procedure TMainForm.ExpandAllActionExecute(Sender: TObject);
begin
  SetAllGroups(True);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  UpdateControls;
  Self.Caption := Self.Caption + ' - ' + GetFileVersion();
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  CloseAll;
end;

procedure TMainForm.PopulateList;
var
  Bodies: TObjectList<TCelestialBody>;
  Body: TCelestialBody;
  Experiments: TObjectList<TExperiment>;
  Experiment: TExperiment;
  ExperimentResults: TExperimentResults;
  Item: TListItem;
  Group: TListGroup;
  GroupID: Integer;
  Situation: TSituation;
begin
  ListView.Items.BeginUpdate;
  try
    Bodies := TObjectList<TCelestialBody>.Create(False);
    try
      fScience.GetCelestialBodies(Bodies);

      Bodies.Sort(TComparer<TCelestialBody>.Construct(
        function (const L, R: TCelestialBody): Integer
        begin
          Result := CompareText(L.Name, R.Name);
        end));

      GroupID := 0;
      cmbFocus.AddItem('None', nil);

      for Body in Bodies do
      begin

        // add body focus combo
        cmbFocus.Items.Add(Body.Name);

        // create group for body
        Group := ListView.Groups.Add;
        Group.Header := Body.Name;
        Inc(GroupID);
        Group.GroupID := GroupID;
        Group.State := [lgsNormal, lgsCollapsible];

        // populate list of experiments
        Experiments := TObjectList<TExperiment>.Create(False);
        try
          Body.GetExperiments(Experiments);
          for Experiment in Experiments do
          begin
            ExperimentResults := Body.ExperimentResults[Experiment];
            if Assigned(ExperimentResults) then
            begin
              Item := ListView.Items.Add;
              Item.Caption := Experiment.Title;
              Item.Data := Experiment;
              Item.GroupID := GroupID;
              Item.ImageIndex := -1;

              for Situation := Low(TSituation) to High(TSituation) do
              begin
                Item.SubItems.Add(''); // no text, just icon
                if Situation in ExperimentResults.Situations then
                  Item.SubItemImages[Item.SubItems.Count - 1] := 1
                else
                  Item.SubItemImages[Item.SubItems.Count - 1] := 0;
              end;
            end;
          end;

        finally
          Experiments.Free;
        end;
      end;

      cmbFocus.ItemIndex := 0;

    finally
      Bodies.Free;
    end;

  finally
    ListView.Items.EndUpdate;
  end;
end;

procedure TMainForm.RefreshActionExecute(Sender: TObject);
begin
  CloseAll;
  LoadSaveFile;
end;

procedure TMainForm.BrowseActionExecute(Sender: TObject);
begin
  if dlgFileOpen.Execute(Self.Handle) then
  begin
    CloseAll;

    fSaveFileName := dlgFileOpen.FileName;
    LoadSaveFile;
  end;
end;

procedure TMainForm.CloseAll;
begin
  ListView.Items.BeginUpdate;
  try
    ListView.Items.Clear;
    ListView.Groups.Clear;
  finally
    ListView.Items.EndUpdate;
  end;
  cmbFocus.Clear;
  fScience.Free;
  fSaveFile.Free;
  UpdateControls;
end;

procedure TMainForm.cmbFocusChange(Sender: TObject);
var
  I: Integer;
  Group: TListGroup;
begin
  ListView.Items.BeginUpdate;
  try
    for I := 0 to ListView.Groups.Count - 1 do
    begin
      Group := ListView.Groups.Items[I];
      SetGroup(Group, (cmbFocus.ItemIndex = 0) or SameText(Group.Header, cmbFocus.Text));
    end;
  finally
    ListView.Items.EndUpdate;
  end;
  ActiveControl := ListView;
end;

procedure TMainForm.LoadSaveFile;
begin
  if TFile.Exists(fSaveFileName) then
  begin
    fSaveFile := TCFGReader.Create(fSaveFileName);
    if Assigned(fSaveFile) then
    begin
      fScience := TCFGScienceParser.Create(fSaveFile.Root);
      PopulateList;
    end;
  end;
  UpdateControls;
end;

procedure TMainForm.ListViewAdvancedCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
var
  ImageIndex: Integer;
  R: TRect;
  P: TPoint;
begin
  DefaultDraw := True;
  ImageIndex := Item.SubItemImages[SubItem - 1];
  R := Item.DisplayRect(drLabel);

  // start at the first subitem column
  R.Left := Sender.Column[0].Width;
  R.Left := R.Left + ((SubItem - 1) * 80);
  R.Right := R.Left + 80;

  // center within this rect
  P.X := R.CenterPoint.X - (Images.Width div 2);
  P.Y := R.CenterPoint.Y - (Images.Height div 2);

  case Stage of
    cdPrePaint:
      begin
        Images.Draw(Sender.Canvas, P.X, P.Y, ImageIndex);
        DefaultDraw := False;
      end;
    cdPostPaint: DefaultDraw := True;
    cdPreErase:
      begin
        DefaultDraw := True;
      end;
    cdPostErase: DefaultDraw := True;
  end;
end;

procedure TMainForm.ListViewCompareItem(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var
  E1, E2: TExperiment;
begin
  E1 := Item1.Data;
  E2 := Item2.Data;
  if Assigned(E1) and Assigned(E2) then
    Compare := E1.Title.CompareTo(E2.Title);
end;

procedure TMainForm.UpdateControls;
begin
  if Assigned(fSaveFile) and Assigned(fScience) then
  begin
    edtGameTitle.Text := fScience.GameTitle;
    edtSaveFileName.Text := fSaveFileName;
    RefreshAction.Enabled := True;
    ExpandAllAction.Enabled := True;
    CollapseAllAction.Enabled := True;
    cmbFocus.Enabled := True;
  end
  else
  begin
    edtGameTitle.Text := '';
    edtSaveFileName.Text := 'No file loaded. Click Browse button =>';
    RefreshAction.Enabled := False;
    ExpandAllAction.Enabled := False;
    CollapseAllAction.Enabled := False;
    cmbFocus.Enabled := False;
  end;
end;

end.
