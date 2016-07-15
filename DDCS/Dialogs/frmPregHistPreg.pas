unit frmPregHistPreg;

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
   VA Contract: TAC-13-06464

   v2.0.0.0
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons, ORCtrls, ORDtTm,
  uDialog, frmPregHistPregInfo, frmPregHistChild;

type
  TPregType = (ptN, ptAI, ptAS, ptE);

  TfPreg = class(TFrame)
    btnDelete: TBitBtn;
    pgPreg: TPageControl;
    procedure btnDeleteClick(Sender: TObject);
    procedure pgPregChange(Sender: TObject);
  private
    FPregType: TPregType;
    FPregIEN: Integer;
    procedure SetPregType(Value: TPregType);
    function GetIndex: Integer;
    function GetChildrenV: string;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DeleteChild(Value: TTabSheet);
    procedure GetSaveChildComments(PregID: string);
    function GetPregInfo: TfPregInfo;
    function GetChild(Value: Integer): TfChild;
    function GetText: TStringList;
    function GetSavePregInfo(PregID: string): string;
    function GetSavePregComments(PregID: string): TStringList;
    property PregnancyType: TPregType read FPregType write SetPregType default ptN;
    property PregnancyIEN: Integer read FPregIEN write FPregIEN default 0;
  end;

implementation

{$R *.dfm}

uses
  udlgPregHist, uCommon, uReportItems;

procedure TfPreg.btnDeleteClick(Sender: TObject);
begin
  if ShowMsg('Are you sure you wish to delete this pregnancy record?' +
             ' All associated child information will also be deleted.' +
             ' This action cannot be undone.', smiWarning, smbYesNo) = smrYes then
    dlgPregHist.DeletePregnancy(GetIndex);
end;

procedure TfPreg.pgPregChange(Sender: TObject);
begin
  if pgPreg.ActivePageIndex <> 0 then
    btnDelete.Visible := False
  else
    btnDelete.Visible := True;
end;

// Private ---------------------------------------------------------------------

procedure TfPreg.SetPregType(Value: TPregType);
var
  vPregInfo: TfPregInfo;
begin
  FPregType := Value;

  vPregInfo := GetPregInfo;
  if vPregInfo <> nil then
  begin
    case Value of
         ptN: vPregInfo.lbStatus.Visible := False;
        ptAI: vPregInfo.lbStatus.Caption := 'Induced Abortion';
        ptAS: vPregInfo.lbStatus.Caption := 'Spontaneous Abortion';
         ptE: vPregInfo.lbStatus.Caption := 'Ectopic';
    end;
  end;
end;

function TfPreg.GetIndex: Integer;
begin
  Result := -1;
  if Owner is TTabSheet then
    Result := TTabSheet(Owner).TabIndex;
end;

function TfPreg.GetChildrenV: string;
var
  I: Integer;
begin
  Result := '';

  if pgPreg.PageCount > 1 then
    for I := 1 to pgPreg.PageCount - 1 do
      if pgPreg.Pages[I].ControlCount > 0 then
        if pgPreg.Pages[I].Controls[0] is TfChild then
          Result := Result + TfChild(pgPreg.Pages[I].Controls[0]).GetV;
end;

// Public ----------------------------------------------------------------------

constructor TfPreg.Create(AOwner: TComponent);
var
  nItem: TDDCSNoteItem;
begin
  inherited;

  nItem := dlgPregHist.ReportCollection.GetNoteItemAddifNil(btnDelete);
  if nItem <> nil then
    nItem.SayOnFocus := 'Click to delete current pregnancy and associated child records.';
end;

procedure TfPreg.DeleteChild(Value: TTabSheet);
var
  I: Integer;
  vPregInfo: TfPregInfo;
begin
  pgPreg.Pages[Value.TabIndex].Free;

  vPregInfo := GetPregInfo;
  if vPregInfo <> nil then
  begin
    vPregInfo.spnBirthCount.OnChange := nil;
    vPregInfo.spnBirthCount.Value := vPregInfo.spnBirthCount.Value - 1;
    vPregInfo.spnBirthCount.OnChange := vPregInfo.spnBabyCountChange;

    vPregInfo.ChildCount := vPregInfo.spnBirthCount.Value;
    if ((vPregInfo.ChildCount < 2) and (vPregInfo.MultiBirth)) then
    begin
      vPregInfo.MultiBirth := False;
      dlgPregHist.ModifyMultiBirth(-1);
    end;
  end;

  if pgPreg.PageCount > 1 then
    for I := 1 to pgPreg.PageCount - 1 do
      pgPreg.Pages[I].Caption := 'Baby # ' + IntToStr(I);

  pgPregChange(pgPreg);
end;

procedure TfPreg.GetSaveChildComments(PregID: string);
var
  I,J: Integer;
  vChild: TfChild;
  BabyID: string;
  cItem: TConfigItem;
begin
  if PregID = '' then
    PregID := IntToStr(PregnancyIEN);

  //  B^IEN|BABY|#^COMMENT
  if pgPreg.PageCount > 1 then
    for I := 1 to pgPreg.PageCount - 1 do
      if pgPreg.Pages[I].ControlCount > 0 then
        if pgPreg.Pages[I].Controls[0] is TfChild then
        begin
          vChild := TfChild(pgPreg.Pages[I].Controls[0]);
          BabyID := PregID + '|' + vChild.BabyIEN + '|' + vChild.BabyNumber;

          cItem := dlgPregHist.Configuration.LookUp('B', BabyID, '');
          if cItem = nil then
          begin
            cItem := TConfigItem.Create(dlgPregHist.Configuration);
            cItem.ID[1] := 'B';
            cItem.ID[2] := BabyID;
          end;
          cItem.Data.Clear;

          for J := 0 to vChild.meComplications.Lines.Count - 1 do
            cItem.Data.Add('B^' + BabyID + U + vChild.meComplications.Lines[J]);
        end;
end;

function TfPreg.GetPregInfo: TfPregInfo;
begin
  Result := nil;

  if pgPreg.PageCount > 0 then
    if pgPreg.Pages[0].ControlCount > 0 then
      if pgPreg.Pages[0].Controls[0] is TfPregInfo then
        Result := TfPregInfo(pgPreg.Pages[0].Controls[0]);
end;

function TfPreg.GetChild(Value: Integer): TfChild;
var
  I: Integer;
  sValue: string;
begin
  Result := nil;

  sValue := IntToStr(Value);

  if pgPreg.PageCount > 1 then
    for I := 1 to pgPreg.PageCount - 1 do
      if pgPreg.Pages[I].ControlCount > 0 then
        if pgPreg.Pages[I].Controls[0] is TfChild then
          if TfChild(pgPreg.Pages[I].Controls[0]).BabyIEN = sValue then
          begin
            Result := TfChild(pgPreg.Pages[I].Controls[0]);
            Break;
          end;
end;

function TfPreg.GetText: TStringList;
var
  I: Integer;
begin
  Result := TStringList.Create;

  if GetPregInfo <> nil then
    Result.AddStrings(GetPregInfo.GetText);

  if pgPreg.PageCount > 1 then
    for I := 1 to pgPreg.PageCount - 1 do
      if pgPreg.Pages[I].ControlCount > 0 then
        if pgPreg.Pages[I].Controls[0] is TfChild then
          Result.AddStrings(TfChild(pgPreg.Pages[I].Controls[0]).GetText);
end;

function TfPreg.GetSavePregInfo(PregID: string): string;
var
  vPregInfo: TfPregInfo;
  tDelivery: string;
begin
  Result := '';

  vPregInfo := GetPregInfo;
  if vPregInfo = nil then
    Exit;

  if PregID = '' then
    PregID := IntToStr(PregnancyIEN);

  //   1) L
  //   2) IEN
  //   3) DATE RECORDED
  //   4) EDC
  //   5) DFN|PATIENT
  //   6) STATUS
  //   7) FOF|(IEN OR IDENTIFIER)
  //   8) EDD
  //   9) PREGNANCY END
  //  10) OB IEN|OB
  //  11) FACILITY IEN|FACILITY
  //  12) UPDATED BY IEN|UPDATED BY
  //  13) GESTATIONAL AGE
  //  14) LENGTH OF LABOR
  //  15) TYPE OF DELIVERY
  //  16) ANESTHESIA
  //  17) PRETERM DELIVERY
  //  18) BIRTH TYPE
  //  19) IEN;NUMBER;NAME;GENDER;BIRTH WEIGHT;STILLBORN;APGAR1;APGAR2;STATUS;NICU|
  //  20) OUTCOME
  //  21) HIGH RISK FLAG
  //  22) DAYS IN HOSPITAL

  tDelivery := '';
  if vPregInfo.rgTypeDelivery.ItemIndex = 0 then
    tDelivery := 'V'
  else if vPregInfo.rgTypeDelivery.ItemIndex = 1 then
    tDelivery := 'C';

  Result := 'L^';                                                    // ID (L)
  Result := Result + PregID + U;                                     // IEN (Replaced upstream if 0)
  Result := Result + U;                                              // DATE RECORDED
  Result := Result + U;                                              // EDC
  Result := Result + U;                                              // DFN| PATIENT (handled by routine)
  Result := Result + U;                                              // STATUS (this is Historical or Current and is handled by routine)
  Result := Result + U;                                              // FOF|(IEN OR IDENTIFIER)
  Result := Result + U;                                              // EDD
  Result := Result + vPregInfo.dtDelivery.Text + U;                  // PREGNANCY END
  Result := Result + U;                                              // OB IEN|OB
  Result := Result + '|' + vPregInfo.cbDeliveryPlace.Text + U;       // FACILITY IEN|FACILITY
  Result := Result + U;                                              // UPDATED BY IEN|UPDATED BY
  Result := Result + vPregInfo.spnGAWeeks.Text + 'W' + vPregInfo.spnGADays.Text  + 'D^';   // GESTATIONAL AGE
  Result := Result + vPregInfo.spnLaborLength.Text + U;              // LENGTH OF LABOR
  Result := Result + tDelivery + U;                                  // TYPE OF DELIVERY
  Result := Result + vPregInfo.cbAnesthesia.Text + U;                // ANESTHESIA
  Result := Result + IntToStr(vPregInfo.rgPretermDelivery.ItemIndex) + U;   // PRETERM DELIVERY
  Result := Result + U;                                              // BIRTH TYPE
  Result := Result + GetChildrenV + U;                               // IEN;NUMBER;NAME;GENDER;BIRTH WEIGHT;STILLBORN;APGAR1;APGAR2;STATUS;NICU|
  Result := Result + vPregInfo.cbOutcome.Text + U;                   // OUTCOME
  Result := Result + U;                                              // HIGH RISK FLAG
  Result := Result + vPregInfo.edtDeliveryAt.Text;                   // DAYS IN HOSPITAL
end;

function TfPreg.GetSavePregComments(PregID: string): TStringList;
var
  vPregInfo: TfPregInfo;
  I: Integer;
begin
  Result := TStringList.Create;

  vPregInfo := GetPregInfo;
  if vPregInfo = nil then
    Exit;

  if PregID = '' then
    PregID := IntToStr(PregnancyIEN);

  //  C^IEN^COMMENT
  for I := 0 to vPregInfo.meDeliveryNotes.Lines.Count - 1 do
    Result.Add('C^' + PregID + U + vPregInfo.meDeliveryNotes.Lines[I])
end;

end.
