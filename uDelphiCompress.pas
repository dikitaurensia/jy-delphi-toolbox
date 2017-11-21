unit uDelphiCompress;

interface

uses Classes;

type
  TCompressType = Byte;

const
  COMPRESS_TYPE_NONE    = 0;
  COMPRESS_TYPE_D6ZLIB1 = 1;
  COMPRESS_TYPE_D6ZLIB2 = 2;
  COMPRESS_TYPE_UNKNOWN = 255;

function StrToCompressType(AStr: string): TCompressType;  {$message 'todo: 改为查表'}
function DelphiDecompressStream(ACompressType: TCompressType; ASourceStream: TMemoryStream; ATargetFile: string): boolean;
function DelphiCompressFile(ACompressType: TCompressType; ASourceFile, ATargetFile: string): boolean;

implementation

uses Windows, Zlib, SysUtils, StrUtils, md5;

function StrToCompressType(AStr: string): TCompressType;  {$message 'todo: 改为查表'}
begin
  if LowerCase(AStr) = 'd6zlib1' then
    result := COMPRESS_TYPE_D6ZLIB1
  else if LowerCase(AStr) = 'd6zlib2' then
    result := COMPRESS_TYPE_D6ZLIB2
  else if LowerCase(AStr) = 'none' then
    result := COMPRESS_TYPE_NONE
  else
    result := COMPRESS_TYPE_UNKNOWN;
end;

function DelphiDecompressStream_None(ASourceStream: TMemoryStream; ATargetFile: string): boolean;
begin
  result := false;

  try
    ASourceStream.SaveToFile(ATargetFile);
    result := true;
  except
  end;
end;

// 文件大小4字节, 文件名大小1字节, 文件名, 文件内容
function DelphiDecompressStream_D6Zlib1(ASourceStream: TMemoryStream; ATargetFile: string): boolean;
var
  dsMain: TDecompressionStream;
  strmTarget: TMemoryStream;
  num: Integer;             {接受文件压缩前的大小}
  numFileName: byte;
  strFileName: string;
begin
  result := false;

  try
    ASourceStream.Position := 0;
    ASourceStream.ReadBuffer(num,SizeOf(num));
    ASourceStream.ReadBuffer(numFileName, SizeOf(numFileName));
    strFileName := DupeString(' ', numFileName);
    ASourceStream.ReadBuffer(strFileName[1], numFileName);

    strmTarget := TMemoryStream.Create;
    try
      strmTarget.SetSize(num);
      dsMain := TDecompressionStream.Create(ASourceStream);
      try
        dsMain.Read(strmTarget.Memory^, num);
        strmTarget.SaveToFile(ATargetFile);

        result := true;
      finally
        dsMain.Free;
      end;
    finally
      strmTarget.Free;
    end;
  except
  end;
end;

// 在d6zlib1的基础上，增加了md5校验
// 文件大小4字节,  md5校验16字节, 文件名大小1字节,文件名, 文件内容
function DelphiDecompressStream_D6Zlib2(ASourceStream: TMemoryStream; ATargetFile: string): boolean;
var
  dsMain: TDecompressionStream;
  strmTarget: TMemoryStream;
  num: Integer;             {接受文件压缩前的大小}
  numFileName: byte;
  strFileName: string;
  MD5Digest1: TMD5Digest;
  MD5Digest2: TMD5Digest;
begin
  result := false;

  try
    ASourceStream.Position := 0;
    ASourceStream.ReadBuffer(num,SizeOf(num));
    ASourceStream.ReadBuffer(MD5Digest1, sizeof(MD5Digest1));
    ASourceStream.ReadBuffer(numFileName, SizeOf(numFileName));
    strFileName := DupeString(' ', numFileName);
    ASourceStream.ReadBuffer(strFileName[1], numFileName);

    strmTarget := TMemoryStream.Create;
    try
      strmTarget.SetSize(num);
      dsMain := TDecompressionStream.Create(ASourceStream);
      try
        dsMain.Read(strmTarget.Memory^, num);
        MD5Digest2 := MD5Stream(strmTarget);
        if not CompareMem(@MD5Digest1, @MD5Digest2, SizeOf(MD5Digest2)) then exit;
        strmTarget.SaveToFile(ATargetFile);

        result := true;
      finally
        dsMain.Free;
      end;
    finally
      strmTarget.Free;
    end;
  except
  end;
end;

function DelphiDecompressStream(ACompressType: TCompressType; ASourceStream: TMemoryStream; ATargetFile: string): boolean;
begin
  case ACompressType of
    COMPRESS_TYPE_NONE: result := DelphiDecompressStream_None(ASourceStream, ATargetFile);
    COMPRESS_TYPE_D6ZLIB1: result := DelphiDecompressStream_D6Zlib1(ASourceStream, ATargetFile);
    COMPRESS_TYPE_D6ZLIB2: result := DelphiDecompressStream_D6Zlib2(ASourceStream, ATargetFile);
    COMPRESS_TYPE_UNKNOWN: result := false;
    else result := false;
  end;
end;

function DelphiCompressStream_None(ASourceFile, ATargetFile: string): boolean;
begin
  result := CopyFile(PChar(ASourceFile), PChar(ATargetFile), false);
end;

function DelphiCompressStream_D6Zlib2(ASourceFile, ATargetFile: string): boolean;
var
  strmSource: TMemoryStream;
  strmCompress: TCompressionStream;
  strmTarget: TMemoryStream;
  num: Integer;           {原始文件大小}
  strFileName: string;
  numFileNameString: byte;
  MD5Digest: TMD5Digest;
begin
  strmSource := TMemoryStream.Create;
  try
    strmSource.LoadFromFile(ASourceFile);
    strmTarget := TMemoryStream.Create;
    try
      num := strmSource.Size;
      strmTarget.Write(num, SizeOf(num));

      MD5Digest := MD5Stream(strmSource);
      strmTarget.Write(MD5Digest, SizeOf(MD5Digest));

      strFileName := ExtractFileName(ASourceFile);
      numFileNameString := Length(strFileName);
      strmTarget.Write(numFileNameString, SizeOf(numFileNameString));
      strmTarget.Write(strFileName[1], numFileNameString);

      strmCompress := TCompressionStream.Create(clMax, strmTarget);
      try
        strmSource.SaveToStream(strmCompress);
      finally
        strmCompress.Free;
      end;

      strmTarget.SaveToFile(ATargetFile);

      result := true;
    finally
      strmTarget.Free;
    end;
  finally
    strmSource.Free;
  end;
end;

function DelphiCompressStream_D6Zlib1(ASourceFile, ATargetFile: string): boolean;
var
  strmSource: TMemoryStream;
  strmCompress: TCompressionStream;
  strmTarget: TMemoryStream;
  num: Integer;           {原始文件大小}
  strFileName: string;
  numFileNameString: byte;
begin
  strmSource := TMemoryStream.Create;
  try
    strmSource.LoadFromFile(ASourceFile);
    strmTarget := TMemoryStream.Create;
    try
      num := strmSource.Size;
      strmTarget.Write(num, SizeOf(num));

      strFileName := ExtractFileName(ASourceFile);
      numFileNameString := Length(strFileName);
      strmTarget.Write(numFileNameString, SizeOf(numFileNameString));
      strmTarget.Write(strFileName[1], numFileNameString);

      strmCompress := TCompressionStream.Create(clMax, strmTarget);
      try
        strmSource.SaveToStream(strmCompress);
      finally
        strmCompress.Free;
      end;

      strmTarget.SaveToFile(ATargetFile);

      result := true;
    finally
      strmTarget.Free;
    end;
  finally
    strmSource.Free;
  end;
end;

function DelphiCompressFile(ACompressType: TCompressType; ASourceFile, ATargetFile: string): boolean;
begin
  case ACompressType of
    COMPRESS_TYPE_NONE: result := DelphiCompressStream_None(ASourceFile, ATargetFile);
    COMPRESS_TYPE_D6ZLIB1: result := DelphiCompressStream_D6Zlib1(ASourceFile, ATargetFile);
    COMPRESS_TYPE_D6ZLIB2: result := DelphiCompressStream_D6Zlib2(ASourceFile, ATargetFile);
    COMPRESS_TYPE_UNKNOWN: result := false;
    else result := false;
  end;
end;

end.
