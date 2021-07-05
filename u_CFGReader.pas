unit u_CFGReader;

interface

uses System.SysUtils, System.Classes, System.Generics.Collections, u_CFGNode;

type
  TLineType = (ltUnknown, ltComment, ltBeginObject, ltEndObject,
    ltNameValue);

  TCFGReader = class
  private
    fFileName: string;
    fLines: TStringList;
    fRoot: TCFGNode;

    // line state
    fIndex: Integer;
    fLineType: TLineType;
    fLine: string;

    procedure EvalLine;
    function NextLine: Boolean;

    procedure Parse;
    procedure LoadFile;
  public
    constructor Create(const aFileName: string);
    destructor Destroy; override;
    property Root: TCFGNode read fRoot;
    property FileName: string read fFileName;
  end;


implementation

uses System.IOUtils, System.Types;

{ TCFGReader }

constructor TCFGReader.Create(const aFileName: string);
begin
  inherited Create;
  fFileName := aFileName;
  fRoot := nil;
  fLines := TStringList.Create;
  fIndex := -1;

  if TFile.Exists(aFileName) then
  begin
    LoadFile;
    Parse;
  end;
end;

destructor TCFGReader.Destroy;
begin
  fLines.Free;
  inherited;
end;

procedure TCFGReader.Parse;
var
  CurrentNode: TCFGNode;
  NewNode: TCFGNode;
begin
  CurrentNode := nil;

  while NextLine do
  begin

    // require a root node
    if (fRoot = nil) and (fLineType <> ltBeginObject) then
      raise Exception.Create('File must begin with an object');

    case fLineType of
      ltUnknown: begin end;
      ltComment: begin end;
      ltBeginObject:
        begin
          // cannot begin an object if the root is already created and we've
          // gone outside of it
          if (fRoot <> nil) and (CurrentNode = nil) then
            raise Exception.Create('Multiple root nodes detected');

          NewNode := TCFGNode.Create(CurrentNode, fLine);

          // if this is our first node then it's the root
          if fRoot = nil then
            fRoot := NewNode;

          CurrentNode := NewNode;
        end;
      ltEndObject:
        begin
          CurrentNode := CurrentNode.Parent;
          // it's OK to end the root node as long as no new nodes are found
        end;
      ltNameValue:
        begin
          CurrentNode.AddProperty(fLine);
        end;
    end;

  end;
end;

function TCFGReader.NextLine: Boolean;
begin
  // move to next non-blank line
  repeat
    Inc(fIndex);
  until (fIndex >= fLines.Count) or (fLines[fIndex] <> '');

  Result := fIndex < fLines.Count;
  if Result then
  begin
    fLine := fLines[fIndex];
    EvalLine;
  end;
end;

procedure TCFGReader.EvalLine;
var
  P: Integer;
  S: string;
begin
  fLineType := ltUnknown;

  S := Trim(fLines[fIndex]);

  if S.StartsWith('//') then
    fLineType := ltComment
  else if S = '}' then
    fLineType := ltEndObject
  else
  begin
    P := S.IndexOf('=');

    // if it's a name value pair...
    if (P > 0) and (P < S.Length) then
    begin
      fLineType := ltNameValue;
    end
    else
    begin
      // validate ident
      if not S.Contains(' ') then
      begin
        // the next line must be an open brace
        if (fIndex < fLines.Count - 1) and (Trim(fLines[fIndex + 1]) = '{') then
        begin
          fLineType := ltBeginObject;
          Inc(fIndex); // skip next line
        end;
      end;
    end;
  end;
end;

procedure TCFGReader.LoadFile;
var
  I: Integer;
begin
  fLines.LoadFromFile(fFileName);
  // remove indentation
  for I := 0 to fLines.Count - 1 do
    fLines[I] := Trim(fLines[I]);
end;

end.
