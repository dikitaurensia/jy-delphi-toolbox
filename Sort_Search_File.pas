unit Sort_Search_File;

interface

uses SysUtils, Classes;

type
  PSearchRec = ^TSearchRec;

  TSortBy = (SortByTime, SortBySize, SortByName);

  TSearchFileList = class(TList)
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
    function GetItem(Index: Integer): PSearchRec;
    procedure SetItem(Index: Integer; ASearchRec: PSearchRec);
  public
    function FindFiles(const Path: string; Attr: Integer; ASortBy: TSortBy; ADeleteOldFile: boolean=false; AOldTime: LongWord=3600; ADeleteNum: integer = 100): integer;
    function Add(ASearchRec: PSearchRec): Integer;
    function Extract(Item: PSearchRec): PSearchRec;
    function Remove(ASearchRec: PSearchRec): Integer;
    function IndexOf(ASearchRec: PSearchRec): Integer;
    procedure Insert(Index: Integer; ASearchRec: PSearchRec);
    function First: PSearchRec;
    function Last: PSearchRec;
    property Items[Index: Integer]: PSearchRec read GetItem write SetItem; default;
  end;


implementation

uses DateUtils, StrUtils, slmlog;

{ TSearchFileList }

function TSearchFileList.Add(ASearchRec: PSearchRec): Integer;
begin
  Result := inherited Add(ASearchRec);
end;

function TSearchFileList.Extract(Item: PSearchRec): PSearchRec;
begin
  Result := PSearchRec(inherited Extract(Item));
end;

//比较函数(按名字)
function ListSortByNameCompare(Item1, Item2: Pointer): Integer;
begin
  result := CompareText(PSearchRec(Item1).Name, PSearchRec(Item2).Name);
  if result = 0 then result := (PSearchRec(Item1).Attr and $00000010) - (PSearchRec(Item2).Attr and $00000010);
end;
//比较函数(按大小)
function ListSortBySizeCompare(Item1, Item2: Pointer): Integer;
begin
  result := PSearchRec(Item1).Size - PSearchRec(Item2).Size;
  if result = 0 then result := ListSortByNameCompare(Item1, Item2);
end;
//比较函数(按时间)
function ListSortByTimeCompare(Item1, Item2: Pointer): Integer;
begin
  if PSearchRec(Item1).Time > PSearchRec(Item2).Time then
    result := 1
  else if PSearchRec(Item1).Time < PSearchRec(Item2).Time then
    result := -1
  else
    result := ListSortBySizeCompare(Item1, Item2);  //按大小排列，让触发信号在抓拍图片之前

  //以下的做法不行，但不知问题在哪
  {if result = 0 then
  begin
    if RightStr(PSearchRec(Item1).Name, 6) = '.entry' then
      result := -1
    else if RightStr(PSearchRec(Item2).Name, 6) = '.entry' then
      result := 1
    else if RightStr(PSearchRec(Item1).Name, 6) = '.leave' then
      result := 1
    else if RightStr(PSearchRec(Item1).Name, 6) = '.leave' then
      result := -1
    else
      result := ListSortByNameCompare(Item1, Item2);
  end;  }

  //if result = 0 then result := ListSortByNameCompare(Item1, Item2);
end;

function TSearchFileList.FindFiles(const Path: string; Attr: Integer; ASortBy: TSortBy; ADeleteOldFile: boolean=false; AOldTime: LongWord=3600; ADeleteNum: integer = 100): integer;
var
  F: TSearchRec;
  P: PSearchRec;
  i: integer;
begin
  Clear;
  //查找出所有符合条件的文件并插入列表中
  i := 0;
  if FindFirst(Path, Attr, F) = 0 then
  begin
    repeat
      if (F.Attr and Attr) = F.Attr then
      begin
        if ADeleteOldFile and (SecondsBetween(FileDateToDateTime(F.Time), now) > AOldTime) then
        begin
          Inc(i);
          DeleteFile(Format('%s%s', [ExtractFilePath(Path), F.Name]));
          if i >= ADeleteNum then break;
          continue;
        end;
        P := new(PSearchRec);
        P^ := F;
        Add(P);
      end;
    until FindNext(F) <> 0;
    FindClose(F);
  end;
  //排序
  case ASortBy of
    SortByName: Sort(ListSortByNameCompare);
    SortByTime: Sort(ListSortByTimeCompare);
    SortBySize: Sort(ListSortBySizeCompare);
  end;

  Result := Count;
end;

function TSearchFileList.First: PSearchRec;
begin
  Result := PSearchRec(inherited First);
end;

function TSearchFileList.GetItem(Index: Integer): PSearchRec;
begin
  Result := inherited Items[Index];
end;

function TSearchFileList.IndexOf(ASearchRec: PSearchRec): Integer;
begin
  Result := inherited IndexOf(ASearchRec);
end;

procedure TSearchFileList.Insert(Index: Integer; ASearchRec: PSearchRec);
begin
  inherited Insert(Index, ASearchRec);
end;

function TSearchFileList.Last: PSearchRec;
begin
  Result := PSearchRec(inherited Last);
end;

procedure TSearchFileList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if Action = lnDeleted then
    Dispose(PSearchRec(Ptr));
  inherited Notify(Ptr, Action);
end;

function TSearchFileList.Remove(ASearchRec: PSearchRec): Integer;
begin
  Result := inherited Remove(ASearchRec);
end;

procedure TSearchFileList.SetItem(Index: Integer; ASearchRec: PSearchRec);
begin
  inherited Items[Index] := ASearchRec;
end;

end.
