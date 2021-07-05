unit u_CFGNode;

interface

uses System.Classes, System.Generics.Collections;

type
  TCFGNode = class
  private
    fParent: TCFGNode;
    fKey: string;
    fProperties: TStringList;
    fChildren: TObjectList<TCFGNode>;
    function GetChild(aIndex: Integer): TCFGNode;
    function GetChildCount: Integer;
  public
    constructor Create(aParent: TCFGNode; const aKey: string);
    destructor Destroy; override;
    property Parent: TCFGNode read fParent;
    property Key: string read fKey write fKey;
    property Children[aIndex: Integer]: TCFGNode read GetChild;
    property ChildCount: Integer read GetChildCount;
    property Properties: TStringList read fProperties;

    procedure AddChild(aNode: TCFGNode);
    procedure AddProperty(const S: string);

  end;

implementation

uses System.Types, System.SysUtils, StrUtils;

{ TCFGNode }

constructor TCFGNode.Create(aParent: TCFGNode; const aKey: string);
begin
  inherited Create;
  fKey := aKey;
  fProperties := TStringList.Create;
  fProperties.Sorted := True;
  fProperties.Duplicates := dupIgnore;

  fParent := aParent;
  if fParent <> nil then
    fParent.AddChild(Self);
end;

destructor TCFGNode.Destroy;
begin
  fChildren.Free;
  fProperties.Free;
  inherited;
end;

procedure TCFGNode.AddChild(aNode: TCFGNode);
begin
  if not Assigned(fChildren) then
    fChildren := TObjectList<TCFGNode>.Create(True);
  fChildren.Add(aNode);
end;

procedure TCFGNode.AddProperty(const S: string);
var
  Parts: TStringDynArray;
begin
  Parts := SplitString(S, '=');
  if Length(Parts) = 2 then
  begin
    fProperties.Add(Trim(Parts[0]) + '=' + Trim(Parts[1]));
  end;
end;

function TCFGNode.GetChild(aIndex: Integer): TCFGNode;
begin
  Result := fChildren[aIndex];
end;

function TCFGNode.GetChildCount: Integer;
begin
  if Assigned(fChildren) then
    Result := fChildren.Count
  else
    Result := 0;
end;

end.
