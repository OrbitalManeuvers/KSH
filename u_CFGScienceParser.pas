unit u_CFGScienceParser;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Types,
  System.StrUtils,
  System.Generics.Collections,
  u_CFGWrapper, u_CFGNode;

type
  TSituation = (
    SrfLanded, SrfSplashed, FlyingLow, FlyingHigh, InSpaceLow, InSpaceHigh
  );
  TSituations = set of TSituation;

  TExperiment = class
  private
    fId: string;
    fTitle: string;
  public
    constructor Create(const aId, aTitle: string);
    destructor Destroy; override;

    property Id: string read fId;
    property Title: string read fTitle;
  end;

  TExperimentResults = class
  private
    fSituations: TSituations;
  public
    constructor Create;
    procedure AddSituation(aSituation: TSituation);
    property Situations: TSituations read fSituations;
  end;

  TCelestialBody = class
  private
    fName: string;
    fExperimentResults: TObjectDictionary<TExperiment, TExperimentResults>;
    function GetExperimentResults(aExperiment: TExperiment): TExperimentResults;
  public
    constructor Create(const aName: string);
    destructor Destroy; override;
    property Name: string read fName;
    procedure AddResult(aExperiment: TExperiment; aSituation: TSituation);
    procedure GetExperiments(aList: TObjectList<TExperiment>);
    property ExperimentResults[Experiment: TExperiment]: TExperimentResults read GetExperimentResults;
  end;

  TCFGScienceParser = class
  private
    fRoot: TCFGNode;

    // master dictionary of experiments
    fExperiments: TObjectDictionary<string, TExperiment>;

    // list of bodies that have experiment results
    fBodies: TObjectDictionary<string, TCelestialBody>;

    function FindOrCreateExperiment(const aId, aTitle: string): TExperiment;
    function FindOrCreateBody(const aName: string): TCelestialBody;
    procedure Parse;
    procedure ParseScienceNode(aNode: TCFGNode);
    function GetGameTitle: string;
  public
    constructor Create(aRoot: TCFGNode);
    destructor Destroy; override;

    procedure GetCelestialBodies(aList: TObjectList<TCelestialBody>);
    property GameTitle: string read GetGameTitle;
  end;


implementation

const
  SituationNames: array[TSituation] of string = (
  'SrfLanded',
  'SrfSplashed',
  'FlyingLow',
  'FlyingHigh',
  'InSpaceLow',
  'InSpaceHigh'
  );


{ TExperiment }

constructor TExperiment.Create(const aId, aTitle: string);
var
  P: Integer;
begin
  inherited Create;
  fId := aId;

  P := Pos('from', aTitle);
  if P = 0 then
    P := Pos('while', aTitle);
  if P > 0 then fTitle := Trim(Copy(aTitle, 1, P - 1))
  else fTitle := Trim(aTitle);
end;

destructor TExperiment.Destroy;
begin
  //
  inherited;
end;

{ TExperimentResults }
constructor TExperimentResults.Create;
begin
  inherited;
  fSituations := [];
end;

procedure TExperimentResults.AddSituation(aSituation: TSituation);
begin
  Include(fSituations, aSituation);
end;

{ TCelestialBody }

constructor TCelestialBody.Create(const aName: string);
begin
  inherited Create;
  fName := aName;
  fExperimentResults := TObjectDictionary<TExperiment, TExperimentResults>.Create([doOwnsValues]);
end;

destructor TCelestialBody.Destroy;
begin
  fExperimentResults.Free;
  inherited;
end;

function TCelestialBody.GetExperimentResults(
  aExperiment: TExperiment): TExperimentResults;
begin
  if not fExperimentResults.TryGetValue(aExperiment, Result) then
    Result := nil;
end;

procedure TCelestialBody.GetExperiments(aList: TObjectList<TExperiment>);
var
  Key: TExperiment;
begin
  for Key in fExperimentResults.Keys do
    aList.Add(Key);
end;

procedure TCelestialBody.AddResult(aExperiment: TExperiment;
  aSituation: TSituation);
var
  R: TExperimentResults;
begin
  if not fExperimentResults.TryGetValue(aExperiment, R) then
  begin
    R := TExperimentResults.Create();
    fExperimentResults.Add(aExperiment, R);
  end;
  R.AddSituation(aSituation);
end;

{ TCFGScienceParser }

constructor TCFGScienceParser.Create(aRoot: TCFGNode);
begin
  inherited Create;
  fRoot := aRoot;

  // master list of experiments and bodies
  fExperiments := TObjectDictionary<string{id}, TExperiment>.Create([doOwnsValues]);
  fBodies := TObjectDictionary<string{name}, TCelestialBody>.Create([doOwnsValues]);

  Parse;
end;

destructor TCFGScienceParser.Destroy;
begin
  fBodies.Free;
  fExperiments.Free;
  inherited;
end;

function TCFGScienceParser.FindOrCreateBody(
  const aName: string): TCelestialBody;
begin
  if not fBodies.TryGetValue(aName, Result) then
  begin
    Result := TCelestialBody.Create(aName);
    fBodies.Add(aName, Result);
  end;
end;

function TCFGScienceParser.FindOrCreateExperiment(const aId,
  aTitle: string): TExperiment;
begin
  if not fExperiments.TryGetValue(aId, Result) then
  begin
    Result := TExperiment.Create(aId, aTitle);
    fExperiments.Add(aId, Result);
  end;
end;

procedure TCFGScienceParser.GetCelestialBodies(aList: TObjectList<TCelestialBody>);
var
  Item: TPair<string, TCelestialBody>;
begin
  for Item in fBodies do
    aList.Add(Item.Value);
end;

function TCFGScienceParser.GetGameTitle: string;
begin
  Result := fRoot.Properties.Values['Title'];
end;

procedure TCFGScienceParser.Parse;
var
  Wrapper: TCFGWrapper;
  Results: TObjectList<TCFGNode>;
  RDNode: TCFGNode;
  Node: TCFGNode;
begin
  Wrapper := TCFGWrapper.Create(fRoot);
  try
    Results := TObjectList<TCFGNode>.Create(False);
    try
      Wrapper.FindNodes('SCENARIO.name=ResearchAndDevelopment', Results);

      if Results.Count > 0 then
      begin
        RDNode := Results[0];

        // find all the science nodes here
        Wrapper.FindNodes(RDNode, 'Science.id', Results);
        for Node in Results do
        begin
          ParseScienceNode(Node);
        end;
      end;

    finally
      Results.Free;
    end;

  finally
    Wrapper.Free;
  end;
end;

procedure TCFGScienceParser.ParseScienceNode(aNode: TCFGNode);
var
  Parts: TStringDynArray;
  Situation: TSituation;
  S: string;
  P: Integer;
  ExperimentId: string;
  Title: string;
  BodyName: string;
  Experiment: TExperiment;
  Body: TCelestialBody;
begin
  // the "id" property contains the experiment id then @ then more info
  S := aNode.Properties.Values['id'];
  Parts := SplitString(S, '@');
  if Length(Parts) > 1 then
  begin

    // find or create the experiment
    ExperimentId := Parts[0];

    // only process experiments that resulted in science gain
    if aNode.Properties.Values['sci'] = '0' then
      Exit;

    Title := aNode.Properties.Values['title'];
    Experiment := FindOrCreateExperiment(ExperimentId, Title);

    // continue parsing part after @
    S := Parts[1];

    // find which situations are mentioned in the string
    for Situation := Low(TSituation) to High(TSituation) do
    begin
      P := Pos(SituationNames[Situation], S);

      if P > 0 then // found the matching Situation
      begin
        // celestial body name comes first, before the situation
        BodyName := Copy(S, 1, P - 1);

        // find or create the celestial body
        Body := FindOrCreateBody(BodyName);
        Body.AddResult(Experiment, Situation);

        // done with this node
        Break;
      end;
    end;
  end;
end;



end.
