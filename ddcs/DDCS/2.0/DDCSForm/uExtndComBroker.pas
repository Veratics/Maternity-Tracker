unit uExtndComBroker;

{
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

     Developer: Theodore Fontana
       Company: Document Storage Systems Inc.
   VA Contract: TAC-13-06464
}

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, Dialogs, Trpcb, Hash, msxml,
  CPRSChart_TLB;

const
  U = '^';
  XWB_M_REJECT =  20000 + 2;

type
  TNote = class(TPersistent)
  private
    FImport: WideString;
    FIEN: string;
    FAuthor: string;
    FAIEN: string;
    FLines: TStrings;
    procedure SetLines(const Value: TStrings);
    procedure ParseTIUXML(const Value: WideString);
  public
    constructor Create;
    destructor Destroy;
    property Import: WideString read FImport write ParseTIUXML;
    property IEN: string read FIEN write FIEN;
    property Author: string read FAuthor write FAuthor;
    property AIEN: string read FAIEN write FAIEN;
    property Lines: TStrings read FLines write SetLines;
  end;

  TVistaUser = class(TPersistent)
  private
    FDUZ: string;
    FName: string;
  public
    property DUZ: string read FDUZ write FDUZ;
    property Name: string read FName write FName;
  end;

  TCPRSComBroker = class(TRPCBroker)
  private
    FOwner: TComponent;
    FUser: TVistaUser;
    FNote: TNote;
    FComBroker: ICPRSBroker;
    FCPRSSTate: ICPRSState;
    FCPRSHandle: HWND;
    FPatientDFN: string;
    FPatientName: string;
    FPatientDOB: string;
    FPatientSSN: string;
    FLocationIEN: Integer;
    FLocationName: string;
    FRemoteProcedure: string;
    FControlObject: string;
    FDDCSInterface: string;
    FDDCSInterfacePages: TStrings;
    procedure SetInterfacePages(const Value: TStrings);
    procedure SetList(AStringList: TStrings; ParamIndex: Integer);
    procedure SetParams(const RPCName: string; const AParam: array of const);
    procedure SetComBroker(const Value: ICPRSBroker);
    procedure SetCPRSState(const Value: ICPRSState);
  protected
    function BrokerCall: WideString; safecall;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CallV(const RPCName: string; const AParam: array of const);
    function sCallV(const RPCName: string; const AParam: array of const): string;
    procedure tCallV(ReturnData: TStrings; const RPCName: string; const AParam: array of const);
    procedure SetContext(const Value: string);
    property COMBroker: ICPRSBroker write SetComBroker;
    property CPRSState: ICPRSState write SetCPRSSTate;
    property CPRSHandle: HWND read FCPRSHandle write FCPRSHandle;
    property PatientDFN: string read FPatientDFN;
    property PatientName: string read FPatientName;
    property PatientDOB: string read FPatientDOB;
    property PatientSSN: string read FPatientSSN;
    property LocationIEN: Integer read FLocationIEN;
    property LocationName: string read FLocationName;
    property Source: TNote read FNote write FNote;
    property ControlObject: string read FControlObject write FControlObject;
    property DDCSInterface: string read FDDCSInterface write FDDCSInterface;
    property DDCSInterfacePages: TStrings read FDDCSInterfacePages write SetInterfacePages;
    property Owner: TComponent read FOwner write FOwner;
  published
    property RemoteProcedure: string read FRemoteProcedure write FRemoteProcedure;
  end;
  PCPRSComBroker = ^TCPRSComBroker;

  function GetRPCCursor: TCursor;
  procedure FastAssign(source, destination: TStrings);

var
  RPCBrokerV: TCPRSComBroker;
  AppStartedCursorForm: TForm = nil;
  baseContext: string = '';

implementation

uses
  VAUtils;

{ Helper Methods }

procedure FastAssign(source, destination: TStrings);
// do not use this with RichEdit Lines unless source is RichEdit with PlainText
var
  ms: TMemoryStream;
begin
  destination.Clear;

  if ((source is TStringList) and (destination is TStringList)) then
    destination.Assign(source)
  else if (CompareText(source.ClassName, 'TRichEditStrings') = 0) then
    destination.Assign(source)
  else
  begin
    ms := TMemoryStream.Create;
    try
      source.SaveToStream(ms);
      ms.Seek(0, soFromBeginning);
      destination.LoadFromStream(ms);
    finally
      ms.Free;
    end;
  end;
end;

function GetRPCCursor: TCursor;
var
  pt: TPoint;
begin
  Result := crHourGlass;

  if (assigned(AppStartedCursorForm) and (AppStartedCursorForm.Visible)) then
  begin
    pt := Mouse.CursorPos;

    if PtInRect(AppStartedCursorForm.BoundsRect, pt) then
      Result := crAppStart;
  end;
end;

{ TNote }

constructor TNote.Create;
begin
  inherited;

  FLines := TStringList.Create;
end;

destructor TNote.Destroy;
begin
  FLines.Free;

  inherited;
end;

procedure TNote.SetLines(const Value: TStrings);
begin
  FLines.Assign(Value);
end;

procedure TNote.ParseTIUXML(const Value: WideString);
var
  XML: IXMLDOMDocument;
  Nlist: IXMLDOMNodeList;
  Node: IXMLDOMNode;
  I: Integer;
begin
  XML := CoDOMDocument.Create;
  XML.loadXML(Value);

  Nlist := XML.getElementsByTagName('DOC_IEN');
  if Nlist <> nil then
  for I := 0 to Nlist.length - 1 do
  begin
    Node := Nlist[I];
    if Node.nodeName = 'DOC_IEN' then
    FIEN := Node.text;
  end;

  Nlist := XML.getElementsByTagName('AUTHOR_IEN');
  if Nlist <> nil then
  for I := 0 to Nlist.length - 1 do
  begin
    Node := Nlist[I];
    if Node.nodeName = 'AUTHOR_IEN' then
    FAIEN := Node.text;
  end;

  Nlist := XML.getElementsByTagName('AUTHOR_NAME');
  if Nlist <> nil then
  for I := 0 to Nlist.length - 1 do
  begin
    Node := Nlist[I];
    if Node.nodeName = 'AUTHOR_NAME' then
    FAuthor := Node.text;
  end;
end;

{ TCPRSComBroker }

constructor TCPRSComBroker.Create(AOwner: TComponent);
begin
  inherited;

  FUser := TVistaUser.Create;
  FNote := TNote.Create;
  FDDCSInterfacePages := TStringList.Create;
end;

destructor TCPRSComBroker.Destroy;
begin
  FUser.Free;
  FNote.Free;
  FDDCSInterfacePages.Free;

  inherited;
end;

procedure TCPRSComBroker.SetContext(const Value: string);
begin
  if FComBroker = nil then
    Exit;

  // Cannot use the same context as the host application (CPRS)
  // thus you cannot use "OR CPRS GUI CHART" for VA VistA
  FComBroker.SetContext(Value);
end;

procedure TCPRSComBroker.SetComBroker(const Value: ICPRSBroker);
begin
  FCOMBroker := Value;
  FComBroker.ClearParameters := True;
  FComBroker.ClearResults := True;
end;

procedure TCPRSComBroker.SetCPRSState(const Value: ICPRSState);
begin
  FCPRSSTate    := Value;

  FUser.FName   := FCPRSState.UserName;
  FUser.FDUZ    := FCPRSState.UserDUZ;

  FPatientDFN   := FCPRSState.PatientDFN;
  FPatientName  := FCPRSState.PatientName;
  FPatientDOB   := FCPRSState.PatientDOB;
  FPatientSSN   := FCPRSState.PatientSSN;
  FLocationIEN  := FCPRSState.LocationIEN;
  FLocationName := FCPRSState.LocationName;
end;

procedure TCPRSComBroker.SetInterfacePages(const Value: TStrings);
begin
  FDDCSInterfacePages.Assign(Value);
end;

procedure TCPRSComBroker.SetList(AStringList: TStrings; ParamIndex: Integer);
var
  I: Integer;
begin
  FComBroker.ParamType[ParamIndex] := bptList;

  // Not need to list the count of the MULT
  // FComBroker.ParamListCount(AStringList.Count);
  for I := 0 to AStringList.Count - 1 do
    FComBroker.ParamList[ParamIndex, IntToStr(I+1)] := AStringList.Strings[I];
end;

procedure TCPRSComBroker.SetParams(const RPCName: string; const AParam: array of const);
{ takes the params (array of const) passed to xCallV and sets them into FComBroker.Param[I] }
const
  BoolChar: array[boolean] of char = ('0', '1');
var
  TmpExt: Extended;
  I: Integer;
  ValueStr: string;
  wValueStr: WideString;
  BrokerError: EBrokerError;
begin
  FComBroker.ClearParameters := True;
  RemoteProcedure := ShortString(RPCName);

  if RPCName = '' then
    raise Exception.Create('No RPC Name');

  if FComBroker <> nil then
  try
    for I := Low(AParam) to High(AParam) do
      case TVarRec(AParam[I]).VType of
        vtInteger:    begin
                        FComBroker.Param[I] := IntToStr(AParam[I].VInteger);
                        FComBroker.ParamType[I] := bptLiteral;
                      end;
        vtBoolean:    begin
                        FComBroker.Param[I] := BoolChar[AParam[I].VBoolean];
                        FComBroker.ParamType[I] := bptLiteral;
                      end;
        vtChar:       begin
                        if AParam[I].VChar = #0 then
                          FComBroker.Param[I] := ''
                        else
                          FComBroker.Param[I] := Char(AParam[I].VChar);

                        FComBroker.ParamType[I] := bptLiteral;
                      end;
        vtExtended:   begin
                        TmpExt := AParam[I].VExtended^;

                        if(abs(TmpExt) < 0.0000000000001) then
                          TmpExt := 0;

                        FComBroker.Param[I] := FloatToStr(TmpExt);
                        FComBroker.ParamType[I] := bptLiteral;
                      end;
        vtPointer:    begin
                        if AParam[I].VPointer = nil then
                          FComBroker.ClearParameters := True
                        else
                          raise Exception.Create('Pointer type must be nil.');
                      end;
        vtPChar:      begin
                        FComBroker.Param[I] := string(AParam[I].VPChar);
                        FComBroker.ParamType[I] := bptLiteral;
                      end;
        vtObject:     if AParam[I].VObject is TStrings then
                        SetList(TStrings(AParam[I].VObject), I);
        vtWideChar:   begin
                        FComBroker.Param[I] := Char(AParam[I].VWideChar);
                        FComBroker.ParamType[I] := bptLiteral;
                      end;
        vtPWideChar:  begin
                        FComBroker.Param[I] := string(AParam[I].VPWideChar);
                        FComBroker.ParamType[I] := bptLiteral;
                      end;
        vtWideString: begin
                        FComBroker.Param[I] := string(AParam[I].VPWideChar);
                        FComBroker.ParamType[I] := bptLiteral;
                      end;
        vtInt64:      begin
                        FComBroker.Param[I] := IntToStr(AParam[I].VInt64^);
                        FComBroker.ParamType[I] := bptLiteral;
                      end;
        // String pre-D2009 is ANSI, and in D2009 and later is Unicode
        vtString:     begin
                        // ValueStr := String(VString);
                        // if (Length(ValueStr) > 0) and (ValueStr[1] = #1) then
                        //   ValueStr := Copy(ValueStr, 2, Length(ValueStr));

                        wValueStr := string(AParam[I].VString);
                        FComBroker.Param[I] := wValueStr;
                        FComBroker.ParamType[I] := bptLiteral;
                      end;
        vtAnsiString: begin
                        // ValueStr := string(VAnsiString);
                        // if (Length(ValueStr) > 0) and (ValueStr[1] = #1) then
                        //   ValueStr := Copy(ValueStr, 2, Length(ValueStr));

                        wValueStr := string(AParam[I].VAnsiString);
                        FComBroker.Param[I] := wValueStr;
                        FComBroker.ParamType[I] := bptLiteral;
                      end;
     vtUnicodeString: begin
                        // ValueStr := string(VUnicodeString);
                        // FComBroker.ParamType[I] := bptLiteral;
                        // if (Length(ValueStr) > 0) and (ValueStr[1] = #1) then
                        // begin
                        //   ValueStr := Copy(ValueStr, 2, Length(ValueStr));
                        //   FComBroker.ParamType[I] := bptReference;
                        // end else
                        //   FComBroker.Param[I] := ValueStr;

                        wValueStr := string(AParam[I].VUnicodeString);
                        FComBroker.Param[I] := wValueStr;
                        FComBroker.ParamType[I] := bptLiteral;
                      end;
    end;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

procedure TCPRSComBroker.CallV(const RPCName: string; const AParam: array of const);
{ calls the broker and returns no value. }
var
  SavedCursor: TCursor;
  CallResults: TStrings;
  BrokerError: EBrokerError;
begin
  if FComBroker = nil then
    Exit;

  SavedCursor := Screen.Cursor;
  Screen.Cursor := GetRPCCursor;

  CallResults := TStringList.Create;
  try
    FComBroker.ClearResults := True;

    SetParams(RPCName, AParam);
    CallResults.Text := BrokerCall;

    if (CallResults.Count > 0) and (Piece(CallResults[0],U,1) = '-%%999^') then
    begin
      BrokerError := EBrokerError.Create(Piece(CallResults[0],U,2));
      if CallResults.Count > 1 then
        BrokerError.Code := StrToIntDef(CallResults[1],0);
      if CallResults.Count > 2 then
        BrokerError.Action := CallResults[2];
    end;

    Screen.Cursor := SavedCursor;
  finally
    FComBroker.ClearParameters := True;

    if BrokerError <> nil then
      Raise BrokerError;
  end;
end;

function TCPRSComBroker.sCallV(const RPCName: string; const AParam: array of const): string;
{ calls the broker and returns a scalar value. }
var
  SavedCursor: TCursor;
  CallResults: TStrings;
  BrokerError: EBrokerError;
begin
  if FComBroker = nil then
    Exit;

  SavedCursor := Screen.Cursor;
  Screen.Cursor := GetRPCCursor;

  CallResults := TStringList.Create;
  try
    FComBroker.ClearResults := True;

    SetParams(RPCName, AParam);
    CallResults.Text := BrokerCall;

    if (CallResults.Count > 0) and (Piece(CallResults[0],U,1) = '-%%999^') then
    begin
      BrokerError := EBrokerError.Create(Piece(CallResults[0],U,2));
      if CallResults.Count > 1 then
        BrokerError.Code := StrToIntDef(CallResults[1],0);
      if CallResults.Count > 2 then
        BrokerError.Action := CallResults[2];
    end;

    if CallResults.Count > 0 then
      Result := CallResults[0]
    else Result := '';

    Screen.Cursor := SavedCursor;
  finally
    FComBroker.ClearParameters := True;

    if BrokerError <> nil then
      Raise BrokerError;
  end;
end;

procedure TCPRSComBroker.tCallV(ReturnData: TStrings; const RPCName: string; const AParam: array of const);
{ calls the broker and returns TStrings data }
var
  SavedCursor: TCursor;
  BrokerError: EBrokerError;
begin
  if FComBroker = nil then
    Exit;

  SavedCursor := Screen.Cursor;
  Screen.Cursor := GetRPCCursor;

  if ReturnData = nil then
    raise Exception.Create('TString not created');

  try
    FComBroker.ClearResults := True;

    SetParams(RPCName, AParam);
    ReturnData.Text := BrokerCall;

    if (ReturnData.Count > 0) and (Piece(ReturnData[0],U,1) = '-%%999^') then
    begin
      BrokerError := EBrokerError.Create(Piece(ReturnData[0],U,2));
      if ReturnData.Count > 1 then
        BrokerError.Code := StrToIntDef(ReturnData[1],0);
      if ReturnData.Count > 2 then
        BrokerError.Action := ReturnData[2];

      ReturnData.Clear;
    end;

    Screen.Cursor := SavedCursor;
  finally
    FComBroker.ClearParameters := True;

    if BrokerError <> nil then
      Raise BrokerError;
  end;
end;

function TCPRSComBroker.BrokerCall: WideString;
begin
  if FComBroker <> nil then
  begin
    try
      FComBroker.CallRPC(RemoteProcedure);
      Result := FComBroker.Results;
    except
      on E: Exception do
      Result := '-%%999^' + E.Message + #13
                + EBrokerError(E).Action + #13
                + EBrokerError(E).Mnemonic + #13
                + IntToStr(EBrokerError(E).Code) + #13
                + '[RPCDebugInfo]';
    end;
  end;
end;

end.

