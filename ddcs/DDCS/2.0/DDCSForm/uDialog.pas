unit uDialog;

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
  SysUtils, Classes, Controls, Forms, Dialogs, uCommon, uExtndComBroker;

Type
  TGetTmpStrList = function: TStringList of object;

  TpbOnDialogClose = procedure(Sender: TObject) of object;

  { Dialog Custom Form }
  TDDCSDialog = class(TForm)
  private
    FReturnList: TStringList;
    FDebugMode: Boolean;
    FIEN: string;
    FConfiguration: TStringList;
    FOnGetTmpStrList: TGetTmpStrList;
    FpbDialogClose: TpbOnDialogClose;
  protected
  public
    constructor Create(AOwner: TComponent; Broker: PCPRSComBroker; DebugMode: Boolean; iIEN: string); overload;
    destructor Destroy; override;
    procedure Save;
    procedure DialogClose(Sender: TObject; var Action: TCloseAction);
    property TmpStrList: TStringList read FReturnList write FReturnList;
    property DebugMode: Boolean read FDebugMode write FDebugMode;
    property IEN: string read FIEN write FIEN;
    property Configuration: TStringList read FConfiguration write FConfiguration;
  published
    property OnGetTmpStrList: TGetTmpStrList read FOnGetTmpStrList write FOnGetTmpStrList;
    property OnDialogClose: TpbOnDialogClose read FpbDialogClose write FpbDialogClose;
  end;

  TDialogClass = class of TDDCSDialog;

  procedure Register;

implementation

procedure Register;
begin
  RegisterClass(TDDCSDialog);
end;

constructor TDDCSDialog.Create(AOwner: TComponent; Broker: PCPRSComBroker; DebugMode: Boolean; iIEN: string);
var
  sl,dl: TStringList;
  I,ctI: Integer;
  Control: TComponent;
  Controlled,vPropertyList,vProp,vValue: string;
begin
  inherited Create(AOwner);

  RPCBrokerV := Broker^;
  FDebugMode := DebugMode;
  FIEN := iIEN;
  Self.OnClose := Self.DialogClose;
  FReturnList := TStringList.Create;
  FConfiguration := TStringList.Create;

  if FIEN = '' then
    try
      RPCBrokerV.SetContext(MENU_CONTEXT);
      FIEN := RPCBrokerV.sCallV('DSIO DDCS DIALOG LOOKUP', [ClassName]);
    except
    end;

  if StrToInt(IEN) > 0 then
  begin
    sl := TStringList.Create; dl := TStringList.Create;
    try
      dl.Add(IEN + ';DSIO(19641.49,');
      try
        RPCBrokerV.SetContext(MENU_CONTEXT);
        RPCBrokerV.tCallV(sl, 'DSIO DDCS BUILD FORM', [dl, RPCBrokerV.ControlObject, RPCBrokerV.Source.IEN]);

        if sl.Count > 0 then
        begin
          for I := 0 to sl.Count - 1 do
          begin

            // Control Value --------------------------------------------------
            //               CV^NAME^F^(INDEXED^VALUE)
            if Piece(sl[I],'^',1)='CV' then
            begin
              Control := FindComponent(Piece(sl[I],U,2));
              if ((Control <> nil) and (Control is TWinControl)) then
              begin
                if Piece(sl[I],U,3) = 'F' then
                  Fill(TWinControl(Control), Piece(sl[I],U,4), Piece(sl[I],U,5,9999));
              end;
            end;
          end;
        end;

      except
        on E: Exception do
        ShowDialog(Self, E.Message, mtError);
      end;
    finally
      sl.Free; dl.Free;
    end;
  end;
end;

destructor TDDCSDialog.Destroy;
begin
  FConfiguration.Free;
  FReturnList.Free;
  inherited Destroy;
end;

procedure TDDCSDialog.DialogClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult <> mrCancel then
  begin
    if not DebugMode then
      Save;
  end;

  Action := caFree;

  if Assigned(FpbDialogClose) then
    FpbDialogClose(Self);
end;

procedure TDDCSDialog.Save;
var
  Note,Build: TStringList;
  I: Integer;
begin
  try
    if StrToInt(IEN) > 0 then
    begin
      Note := TStringList.Create;
      for I := 0 to ComponentCount - 1 do
      begin
        Build := TStringList.Create;
        try
//          Build := BuildDiscreetData(TWinControl(Components[I]),'');
          if Build.Count > 0 then
            Note.AddStrings(Build);
        finally
          Build.Free;
        end;
      end;

      if Note.Count > 0 then
      begin
        try
          RPCBrokerV.SetContext(MENU_CONTEXT);
          RPCBrokerV.CallV('DSIO DDCS STORE', [RPCBrokerV.ControlObject, RPCBrokerV.Source.IEN, IEN + ';DSIO(19641.49,', Note]);
        except
        end;
      end;
      Note.Free;
    end;
  except
    on E: Exception do
    ShowDialog(Self, E.Message, mtError);
  end;
end;

end.