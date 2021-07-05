unit u_CFGWrapper;

interface

uses System.Generics.Collections, u_CFGNode;

type
  TCFGWrapper = class
  private
    fRoot: TCFGNode;
    fQueryRoot: TCFGNode;
  public
    constructor Create(aNode: TCFGNode);
    destructor Destroy; override;

    procedure FindNodes(const aQuery: string; aResults: TObjectList<TCFGNode>); overload;
    procedure FindNodes(aRoot: TCFGNode; const aQuery: string; aResults: TObjectList<TCFGNode>); overload;

  end;

implementation

uses System.Types, System.SysUtils, System.StrUtils;

{ TCFGWrapper }

constructor TCFGWrapper.Create(aNode: TCFGNode);
begin
  inherited Create;
  fRoot := aNode;
  fQueryRoot := nil;
end;

destructor TCFGWrapper.Destroy;
begin

  inherited;
end;

procedure TCFGWrapper.FindNodes(aRoot: TCFGNode; const aQuery: string;
  aResults: TObjectList<TCFGNode>);
begin
  fQueryRoot := aRoot;
  FindNodes(aQuery, aResults);
end;

procedure TCFGWrapper.FindNodes(const aQuery: string; aResults: TObjectList<TCFGNode>);
var
  I: Integer;
  Parts: TStringDynArray;
  NodeKey: string;
  PropName: string;
  PropValue: string;
  Node: TCFGNode;
  S: string;
begin
  aResults.Clear;

  // starting node for the query
  if fQueryRoot = nil then
    fQueryRoot := fRoot;

  // format is key[.field=value]
  Parts := SplitString(aQuery, '.');
  if Length(Parts) = 0 then
    Exit;

  NodeKey := Trim(Parts[0]); // types of nodes to find

  // if there's a query specified, split it into property name and value
  if Length(Parts) > 1 then
  begin
    Parts := SplitString(Parts[1], '=');
    if Length(Parts) > 0 then PropName := Trim(Parts[0])
    else PropName := '';
    if Length(Parts) > 1 then PropValue := Trim(Parts[1])
    else PropValue := '*';  // allow 'KEY.property' to be same as 'KEY.property=*'
  end;

  if NodeKey <> '' then
  begin
    for I := 0 to fQueryRoot.ChildCount - 1 do
    begin
      Node := fQueryRoot.Children[I];
      if not SameText(Node.Key, NodeKey) then
        Continue;

      // additional query params?
      if PropName <> '' then
      begin
        S := Node.Properties.Values[PropName];

        // non-blank
        if PropValue = '*' then
        begin
          if S = '' then
          Continue;
        end
        else
        begin
          // match
          if not SameText(PropValue, S) then
            Continue;
        end;
      end;

      aResults.Add(Node);
    end;
  end;
end;

end.
