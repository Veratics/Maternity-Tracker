unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Samples.Spin, Vcl.Mask, JvExMask, JvSpin,
  System.ConvUtils, System.StdConvs,
  uExtndComBroker, oCNTBase, frmVitals,
  fBase508Form, VA508AccessibilityManager;

type
  TForm1 = class(TfrmBase508Form)
    ofrm1: ToForm;
    oPage1: ToPage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    lblLabor: TLabel;
    lbDeliveryNotes: TLabel;
    L_GestationalAgeAtDelivery: TLabel;
    L_LengthofLabor: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label287: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    dtDelivery: TDateTimePicker;
    dtMaternal: TDateTimePicker;
    edtDeliveryAt: TSpinEdit;
    cbAnesthesia: TComboBox;
    cbLabor: TComboBox;
    memoDeliveryNotes: TMemo;
    cxRadioGroup_PretermLabor: TRadioGroup;
    E_LengthofLabor: TJvSpinEdit;
    SPN_GADays: TSpinEdit;
    SPN_GAWeeks: TSpinEdit;
    CB_PlaceofDelivery: TComboBox;
    cbOutcomeType: TComboBox;
    oPage2: ToPage;
    pgCtrlBaby: TPageControl;
    TsBaby1: TTabSheet;
    lblBirthweight1: TLabel;
    lblLB1: TLabel;
    lblOz1: TLabel;
    lblComplications1: TLabel;
    lblg1: TLabel;
    rgSex1: TRadioGroup;
    edtLb1: TJvSpinEdit;
    edtOz1: TJvSpinEdit;
    memComplications1: TMemo;
    edtAPGAR1: TLabeledEdit;
    ckNICU1: TCheckBox;
    edtAPGARs1: TEdit;
    edtg1: TJvSpinEdit;
    Panel2: TPanel;
    Panel3: TPanel;
    rbSingleton: TRadioButton;
    rbMultiple: TRadioButton;
    edtNumBabies: TSpinEdit;
    oPage3: ToPage;
    gbCesarean: TGroupBox;
    lbCesareanReasons: TLabel;
    lbReasonsCPrimary: TLabel;
    lbReasonsCSecondary: TLabel;
    lblReasonforCOther: TLabel;
    chkCPrimaryFor: TCheckBox;
    edtCPrimaryFor: TEdit;
    chkCUnsuccessfulVBAC: TCheckBox;
    rgincision: TRadioGroup;
    ckRepeatwoLabor: TCheckBox;
    cbReasonsCPrimary: TComboBox;
    cbReasonsCSecondary: TComboBox;
    edtReasonsCOthPrimary: TEdit;
    edtReasonsCOthSecondary: TEdit;
    gbOtherProcedures: TGroupBox;
    edtProceduresOther: TLabeledEdit;
    ckProUterineCurettage: TCheckBox;
    ckProTubalLigationatCesarean: TCheckBox;
    ckProPostpartumTubalLigation: TCheckBox;
    ckProPostpartumHysterectomy: TCheckBox;
    ckNexplanonImplant: TCheckBox;
    ckIUDInsertion: TCheckBox;
    ckBakri: TCheckBox;
    gbVaginal: TGroupBox;
    chkVagVacuum: TCheckBox;
    chkVagForceps: TCheckBox;
    chkVagEpisiotomy: TCheckBox;
    chkVagLacerations: TCheckBox;
    chkVagVBAC: TCheckBox;
    chkVagSVD: TCheckBox;
    chkAKRI: TCheckBox;
    ckDeliveryMethodV: TCheckBox;
    ckDeliveryMethodC: TCheckBox;
    oPage4: ToPage;
    lstDelivery: TListView;
    GroupBox1: TGroupBox;
    rbLiving1: TRadioButton;
    rbDemised1: TRadioButton;
    procedure edtDeliveryAtChange(Sender: TObject);
    procedure rbSingletonClick(Sender: TObject);
    procedure rbMultipleClick(Sender: TObject);
    procedure edtNumBabiesChange(Sender: TObject);
    procedure edtNumBabiesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtLb1Change(Sender: TObject);
    procedure edtOz1Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UpdateLBOZ(Sender: TObject);
    procedure Finished(Sender: TObject);
    procedure ofrm1FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ofrm1Change(Sender: TObject);
    procedure SPN_GAWeeksChange(Sender: TObject);
    procedure SPN_GADaysChange(Sender: TObject);
    procedure E_LengthofLaborChange(Sender: TObject);
  private
    rgSexlist: TList;
    rbLivingList: TList;
    rbDemisedList: TList;
    edtLBList: TList;
    edtOzList: TList;
    edtGList: TList;
    edtAPGARList: TList;
    edtAPGARsList: TList;
    ckNICUList: TList;
    memComplicationsList: Tlist;
    KeyValue: Integer;
    procedure Rebuild;
    procedure FreeTabs;
    procedure AddBabyTab;
    procedure SetPageControlTabs;
    procedure OnChangeNil(J: Integer);
    procedure OnChangeRestore(J: Integer);
    procedure UpdateGrams(J: Integer);
  public
    pgIENs: array of string;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  VA508AccessibilityRouter;

procedure TForm1.FormCreate(Sender: TObject);
begin
  dtDelivery.Format := 'MM/dd/yyyy';
  dtDelivery.DateTime := Now;
  dtMaternal.Format := 'MM/dd/yyyy';
  dtMaternal.DateTime := Now;

  Rebuild;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  SetLength(pgIENs,0);
  rgSexList.Clear;
  rbLivingList.Clear;
  rbDemisedList.Clear;
  edtLBList.Clear;
  edtOzList.Clear;
  edtGList.Clear;
  edtAPGARList.Clear;
  edtAPGARsList.Clear;
  ckNICUList.Clear;
  memComplicationsList.Clear;
  FreeTabs;
end;

procedure TForm1.FreeTabs;
var
  I, counter: integer;
  vtabsheet: TTAbsheet;
begin
 counter := pgCtrlBaby.PageCount;

  for I :=  counter - 1 downto 1 do
  begin
    vTabsheet := pgCtrlBaby.Pages[I];
    vTabsheet.Free;
    vTabsheet := nil;
  end;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  case ofrm1.ActivePageIndex of
    1: Panel3.Left := (ofrm1.Width div 2) - (Panel3.Width div 2);               // Neonatal Information
  end;
end;

procedure TForm1.ofrm1FormShow(Sender: TObject);
var
  I,J,pgct,pgx,tVal: Integer;
  pg: TTabSheet;
  val: string;
  pageplace: array of string;
begin

  //  ID^IEN^NUMBER^NAME^GENDER^BIRTH WEIGHT^STILLBORN^APGAR1^APGAR2^STATUS^NICU

  for I := 0 to lstDelivery.Items.Count - 1 do
  begin
    if lstDelivery.Items.Item[I].Caption = 'L' then
    begin
      SetLength(pageplace,Length(pageplace)+1);
      pageplace[Length(pageplace)-1] := lstDelivery.Items.Item[I].SubItems[0];
    end;

    for J := lstDelivery.Items.item[I].SubItems.Count - 1 to 8 do
      lstDelivery.Items.Item[I].SubItems.Add('');
  end;
  pgct := 0;

  for I := 0 to lstDelivery.Items.Count - 1 do
  begin
    if lstDelivery.Items.Item[I].Caption = 'L' then
    begin
      inc(pgct);

      if pgct > 1 then
      begin
        rbMultiple.Checked := True;
        if pgct > 2 then
          edtNumBabies.Value := edtNumBabies.Value + 1;
      end;

      pgx := pgCtrlBaby.PageCount-1;
       pg := pgCtrlBaby.Pages[pgx];
      SetLength(pgIENs,pgCtrlBaby.PageCount);

      for J := 0 to lstDelivery.Items.Item[I].SubItems.Count - 1 do
      begin
        val := lstDelivery.Items.Item[I].SubItems[J];
        if val <> '' then
          case J of
            0 : pgIENs[pgx] := val;                                             // IEN
            1 : ;                                                               // Baby Number
            2 : ;                                                               // Name
            3 : begin                                                           // Gender
                  if val = 'M' then
                    TRadioGroup(rgSexlist[pgx]).ItemIndex := 0
                  else if val = 'F' then
                    TRadioGroup(rgSexlist[pgx]).ItemIndex := 1
                  else
                    TRadioGroup(rgSexlist[pgx]).ItemIndex := 2;
                end;
            4 : begin                                                           // Birth Weight in grams
                  OnChangeNil(pgx);

                  if TryStrToInt(val,tVal) then
                    TJvSpinEdit(edtGList[pgx]).Value := tVal;

                  OnChangeRestore(pgx);
                  UpdateLBOZ(TJvSpinEdit(edtGList[pgx]));
                end;
            5 : if val = '1' then                                               // StillBorn
                  TRadioButton(rbDemisedList[pgx]).Checked := True;
            6 : TLabeledEdit(edtAPGARList[pgx]).Text := val;                    // APGAR1
            7 : TLabeledEdit(edtAPGARsList[pgx]).Text := val;                   // APGAR2
            8 : begin                                                           // Status
                  if val = 'L' then
                    TRadioButton(rbLivingList[pgx]).Checked := True
                  else if val = 'D' then
                    TRadioButton(rbDemisedList[pgx]).Checked := True;
                end;
            9 : if val = '1' then
                  TCheckBox(ckNICUList[pgx]).Checked := True;                   // NICU
          end;
      end;
    end else if lstDelivery.Items.Item[I].Caption = 'C' then
    begin
      for J := 0 to Length(pageplace) - 1 do
      begin
        if pageplace[J] = lstDelivery.Items.Item[I].SubItems[0] then
        begin
          pg := pgCtrlBaby.Pages[J];
          if pg <> nil then
            TMemo(memComplicationsList[J]).Lines.Add(lstDelivery.Items.Item[I].SubItems[1]);

          Break;
        end;
      end;
    end;
  end;

  SetLength(pageplace,0);
end;

procedure TForm1.ofrm1Change(Sender: TObject);
begin
  FormResize(Sender);
end;

procedure TForm1.Finished(Sender: TObject);
var
  tmpstr,IEN: string;
  I,J: Integer;
  lvitem: TListItem;
  sl: TStringList;

  procedure CleanLv(Lv: TListView);
  var
    I: Integer;
  begin
    for I := 0 to Lv.Items.Count - 1 do
      if ((Lv.Items[I].Caption = 'L') or (Lv.Items[I].Caption = 'C')) then
      begin
        Lv.Items[I].Delete;
        CleanLv(Lv);
        Break;
      end;
  end;

begin
  ofrm1.Validated := True;
  tmpstr := '';

  ofrm1.TmpStrList.Add('Delivery Details:');
  ofrm1.TmpStrList.Add('  Delivery Date: ' + formatdatetime('mm/dd/yyyy',dtDelivery.date));
  ofrm1.TmpStrList.Add('  Maternal Date: ' + formatdatetime('mm/dd/yyyy',dtMAternal.date));
  ofrm1.TmpStrList.Add('  Days to Delivery at '+ edtDeliveryAt.text);
  ofrm1.TmpStrList.Add('  Gestational Age: ' + SPN_GAWeeks.Text + ' Weeks ' + SPN_GADays.Text + ' Days');

  if cbAnesthesia.ItemIndex <> -1 then
    ofrm1.TmpStrList.Add('  Anesthesia: ' + cbAnesthesia.Text);

  if cxRadioGroup_PretermLabor.ItemIndex = 0 then
    ofrm1.TmpStrList.Add('  Preterm Labor: No')
  else if cxRadioGroup_PretermLabor.ItemIndex = 1 then
    ofrm1.TmpStrList.Add('  Preterm Labor: Yes');

  if cbLabor.ItemIndex <> -1 then
    ofrm1.TmpStrList.Add('  Labor: ' + cbLabor.Items[cbLabor.ItemIndex]);

  if Trim(E_LengthofLabor.Text) <> '' then
    ofrm1.TmpStrList.Add('  Length of Labor: ' + Trim(E_LengthofLabor.Text) + ' hrs');

  if cbOutcomeType.ItemIndex <> -1 then
    ofrm1.TmpStrList.Add('  Outcome: ' + cbOutcomeType.Items[cbOutcomeType.ItemIndex]);

  if Trim(CB_PlaceofDelivery.Text) <> '' then
    ofrm1.TmpStrList.Add('  Place of Delivery: ' + Trim(CB_PlaceofDelivery.Text));

  if memoDeliveryNotes.Lines.Count > 0 then
  begin
    ofrm1.TmpStrList.Add('  Delivery Notes: ');
    for I := 0 to memoDeliveryNotes.Lines.Count - 1 do
      ofrm1.TmpStrList.Add('   ' + memoDeliveryNotes.Lines[I]);
  end;

  ofrm1.TmpStrList.Add('Neonatal Information:');
  if rbSingleton.Checked then
    ofrm1.tmpStrList.Add('  Number of Babies: 1')
  else if rbMultiple.Checked then
    ofrm1.tmpStrList.Add('  Number of Babies: ' + IntToStr(edtNumBabies.Value));

  for I := 0 to pgCtrlbaby.PageCount - 1 do
  begin
    if pgCtrlbaby.Pages[I].TabVisible then
    begin
      tmpstr := '  Baby ' + IntTostr(I+1);
      if TRadioButton(rbLivingList[I]).Checked then
        tmpstr := tmpstr + ' (Living):'
      else if TRadioButton(rbDemisedList[I]).Checked then
        tmpstr := tmpstr + ' (Demise):';

      ofrm1.TmpStrList.Add(tmpstr);
      tmpstr := '';

      if TRadioGroup(rgSexList[I]).ItemIndex = 0 then
        ofrm1.TmpStrList.add('   Gender: Male')
      else if TRadioGroup(rgSexList[I]).ItemIndex = 1 then
        ofrm1.TmpStrList.add('   Gender: Female')
      else if TRadioGroup(rgSexlist[I]).ItemIndex = 2 then
        ofrm1.TmpStrList.Add('   Gender: Unknown');

      tmpstr := '';
      if TJvSpinEdit(edtLBList[I]).Value > 0 then
        tmpstr := FloatToStr(TJvSpinEdit(edtLBList[I]).Value) + ' Lb';
      if TJvSpinEdit(edtOZList[I]).Value > 0 then
      begin
        if tmpstr <> '' then
          tmpstr := tmpstr + ' ';

        tmpstr := tmpstr + FloatToStr(TJvSpinEdit(edtOZList[I]).Value) + ' Oz';
      end;
      if tmpstr <> '' then
      begin
        tmpstr := '   Weight: ' + tmpstr + ' (' + TJvSpinEdit(edtGList[I]).Text + 'g)';
        ofrm1.TmpStrList.Add(tmpstr);
      end;

      tmpstr := '';
      if Trim(TLabeledEdit(edtAPGARList[I]).Text) <> '' then
        tmpstr := '   APGAR Score: ' + TLabeledEdit(edtAPGARList[I]).Text;
      if Trim(TEdit(edtAPGARsList[I]).Text) <> '' then
      begin
        if tmpstr <> '' then
          tmpstr := tmpstr + ' ' + TEdit(edtAPGARsList[I]).Text
        else
          tmpstr := '   APGAR Score: ' + TEdit(edtAPGARsList[I]).Text;
      end;
      if tmpstr <> '' then
        ofrm1.TmpStrList.Add(tmpstr);

      if TCheckBox(ckNICUList[I]).Checked then
        ofrm1.TmpStrList.Add('   NICU Admission: Yes')
      else
        ofrm1.TmpStrList.Add('   NICU Admission: No');

      if TMemo(memComplicationsList[I]).Lines.Count > 0 then
      begin
        ofrm1.Tmpstrlist.Add('   Complications: ');
        for J := 0 to TMemo(memComplicationsList[I]).Lines.Count - 1 do
          ofrm1.TmpStrList.Add('    ' + TMemo(memComplicationsList[I]).Lines[J]);
      end;
    end;
  end;

  sl := TStringList.Create;
  try
    if chkVagSVD.Checked then
      sl.Add('  - Spontaneous Vaginal Delivery');
    if chkVagVacuum.Checked then
      sl.Add('  - Vacuum');
    if chkVagForceps.Checked then
      sl.Add('  - Forceps');
    if chkVagEpisiotomy.Checked then
      sl.Add('  - Episiotomy');
    if chkVagLacerations.Checked then
      sl.Add('  - Lacerations');
    if chkVagVBAC.Checked then
      sl.Add('  - Vaginal Birth after Cesarean');
    if chkAKRI.Checked then
      sl.Add('  - AKRI');

    if sl.Count > 0 then
    begin
      ofrm1.TmpStrList.Add('Delivery Method - Vaginal: ');
      ofrm1.TmpStrList.AddStrings(sl);
      ckDeliveryMethodV.Checked := True;
    end;
    sl.Clear;

    if (chkCPrimaryFor.Checked) and (Trim(edtCPrimaryFor.Text) <> '') then
      sl.Add('  Primary ' + Trim(edtCPrimaryFor.Text));
    if ckRepeatwoLabor.Checked then
      sl.Add('  Repeat without Labor');
    if chkCUnsuccessfulVBAC.Checked then
      sl.Add('  Repeat - Unsuccessful Vaginal Birth at Cesarean');

    sl.Add('  Indications for Cesarean:');
    sl.Add('     Primary: ' + cbReasonsCPrimary.Text);
    sl.Add('       Other: ' + edtReasonsCOthPrimary.Text);
    sl.Add('   Secondary: ' + cbReasonsCSecondary.Text);
    sl.Add('       Other: ' + edtReasonsCOthSecondary.Text);

    if rgIncision.ItemIndex <> -1 then
    begin
      tmpStr := '   Uterine Incision - ';
      if rgIncision.ItemIndex = 0  then
        tmpstr := tmpstr + 'Low Transverse'
      else if rgIncision.ItemIndex = 1  then
        tmpstr := tmpstr + 'Low Vertical'
      else if rgIncision.ItemIndex = 2  then
        tmpstr := tmpstr + 'Classical';

     sl.Add(tmpstr);
    end;

    if sl.Count > 0 then
    begin
      ofrm1.TmpStrList.Add('Delivery Method - Cesarean: ');
      ofrm1.TmpStrList.AddStrings(sl);
      ckDeliveryMethodC.Checked := True;
    end;
  finally
    sl.Free;
  end;

  ofrm1.TmpStrList.Add('Other Procedures done during same Hospitalization:');
  if ckNexplanonImplant.Checked then
    ofrm1.TmpStrList.Add('  - ' + ckNexplanonImplant.Caption);
  if ckProTubalLigationatCesarean.Checked then
    ofrm1.TmpStrList.Add('  - ' + ckProTubalLigationatCesarean.Caption);
  if ckProUterineCurettage.Checked then
    ofrm1.TmpStrList.Add('  - ' + ckProUterineCurettage.Caption);
  if ckProPostpartumTubalLigation.Checked then
    ofrm1.TmpStrList.Add('  - ' + ckProPostpartumTubalLigation.Caption);
  if ckProPostpartumHysterectomy.Checked then
    ofrm1.TmpStrList.Add('  - ' + ckProPostpartumHysterectomy.Caption);
  if ckIUDInsertion.Checked then
    ofrm1.TmpStrList.Add('  - ' + ckIUDInsertion.Caption);
  if ckBakri.Checked then
    ofrm1.TmpStrList.Add('  - ' + ckBakri.Caption);
  if Trim(edtProceduresOther.Text) <> '' then
    ofrm1.TmpStrList.Add('  - Other: ' + edtProceduresOther.Text);

  CleanLv(lstDelivery);

  for I := 0 to pgCtrlbaby.PageCount - 1 do
  begin
    if pgCtrlBaby.Pages[I].TabVisible then
    begin
      lvitem := lstDelivery.Items.Add;
      lvitem.Caption := 'L';
      for J := 0 to 10 do
        lvitem.SubItems.Add('');

      if ((Length(pgIENs) >= I) and (I > 0)) then                                        // IEN
        IEN := pgIENs[I]
      else IEN := '';

      lvitem.SubItems[0] := IEN;

      case TRadioGroup(rgSexlist[I]).ItemIndex of                                        // Gender
        0 : lvitem.SubItems[3] := 'M';
        1 : lvitem.SubItems[3] := 'F';
        2 : lvitem.SubItems[3] := 'U';
      end;

      lvitem.SubItems[4] := TJvSpinEdit(edtGList[I]).Text;                               // Birth Weight
      lvitem.SubItems[6] := TLabeledEdit(edtAPGARList[I]).Text;                          // APGAR1
      lvitem.SubItems[7] := TLabeledEdit(edtAPGARsList[I]).Text;                         // APGAR2

      if TRadioButton(rbLivingList[I]).Checked then                                      // Status
        lvitem.SubItems[8] := 'L'
      else if TRadioButton(rbDemisedList[I]).Checked then
        lvitem.SubItems[8] := 'D';

      if TCheckBox(ckNICUList[I]).Checked then                                           // NICU
        lvitem.SubItems[9] := '1';

      if TMemo(memComplicationsList[I]).Lines.Count > 0 then                             //COMMENTS
      begin
        for J := 0 to TMemo(memComplicationsList[I]).Lines.Count - 1 do
        begin
          lvitem := lstDelivery.Items.Add;
          lvitem.Caption := 'C';
          lvitem.SubItems.Add(IEN);
          lvitem.SubItems.Add(TMemo(memComplicationsList[I]).Lines[J]);
        end;
      end;
    end;
  end;
end;

procedure TForm1.edtDeliveryAtChange(Sender: TObject);
begin
  if not (Sender is TSpinEdit) then
    Exit;

  if TSpinEdit(Sender).Value < 0 then
  begin
    TSpinEdit(Sender).Value := 0;
    Exit;
  end;
end;

procedure TForm1.SPN_GAWeeksChange(Sender: TObject);
begin
  if SPN_GAWeeks.Value < 0 then
    SPN_GAWeeks.Value := 0;
end;

procedure TForm1.SPN_GADaysChange(Sender: TObject);
begin
  if SPN_GADays.Value < 0 then
    SPN_GADays.Value := 0;

  if SPN_GADays.Value > 6 then
  begin
    SPN_GADays.OnChange := nil;
    SPN_GAWeeks.Value := SPN_GAWeeks.Value + Trunc(SPN_GADays.Value div 7);
    SPN_GADays.Value := SPN_GADays.Value - (Trunc(SPN_GADays.Value div 7) * 7);
    SPN_GADays.OnChange := SPN_GADaysChange;
  end;
end;

procedure TForm1.E_LengthofLaborChange(Sender: TObject);
begin
  if TJvSpinEdit(Sender).Value < 0 then
    TJvSpinEdit(Sender).Value := 0;
end;

procedure TForm1.rbSingletonClick(Sender: TObject);
var
  I: integer;
begin
  if rbSingleton.Checked then
  begin
    edtNumBabies.Visible := False;
    pgCtrlBaby.Pages[0].TabVisible := True;

    for I := 1 to pgCtrlBaby.PageCount - 1 do
      pgCtrlBaby.Pages[I].TabVisible := False;
  end;
end;

procedure TForm1.rbMultipleClick(Sender: TObject);
begin
  if rbMultiple.Checked then
  begin
    edtNumBabies.Visible := True;
    edtNumBabies.Value := 2;
    SetPageControlTabs;
  end;
end;

procedure TForm1.edtNumBabiesChange(Sender: TObject);
begin
  if edtNumBabies.Value < 2 then
    edtNumBabies.Value := 2;

  edtNumBabies.OnChange := nil;
  if ((KeyValue <> -1) or ((edtNumBabies.Value >= 2) and (edtNumBabies.Value <= 8))) then
  begin
    if ((KeyValue <> - 1) and (KeyValue <> 0)) then
      edtNumBabies.Value := KeyValue
    else
      KeyValue := edtNumBabies.Value;

    if KeyValue < 2 then
      edtNumBabies.Value := 2;
    if KeyValue > 8 then
      edtNumBabies.Value := 8;
  end else
  begin
    if edtNumBabies.Value < 2 then
      edtNumBabies.Value := 2;
    if edtNumBabies.Value > 8 then
      edtNumBabies.Value := 8;
  end;

  edtNumBabies.OnChange := edtNumBabiesChange;

  SetPageControlTabs;
  KeyValue := -1;
end;

procedure TForm1.SetPageControlTabs;
var
  I,edtcnt,pgcnt: Integer;
begin
  edtcnt := edtNumBabies.Value;
  if  edtcnt > 8 then
    Exit;

  pgcnt := pgCtrlBaby.PageCount;
  for I := pgcnt to edtcnt - 1 do
    AddBabyTab;

  for I := 0 to pgcnt - 1 do
    pgCtrlBaby.Pages[I].TabVisible := (I<edtCnt);
end;

procedure TForm1.AddbabyTab;
var
  vTabsheet: TTabsheet;
  vPN: string;
  rg: TRadioGroup;
  ck: TCheckBox;
  rbL,rbD: TRadioButton;
  edtlbla: TLabeledEdit;
  edtAPGARs: TEdit;
  lblBirthweightx,lblLBx,lblOzx,lblg,lblComplicationsx: TLabel;
  edtLbx,edtOzx,edtlblg: TJvSpinEdit;
  memComplicationsx: TMemo;
begin
  if rgSexlist = nil then
    Rebuild;

  vTabSheet := TTabSheet.Create(pgCtrlBaby);
  vTabsheet.PageControl := pgCtrlBaby;
  vPN := IntToStr(pgCtrlBaby.PageCount);
  vTabsheet.Caption := 'Baby '+ vPN;

  //Sex
  rg := TRadioGroup.Create(vTabsheet);
  rg.Name := 'rgSex' + vPN;
  rg.Parent := vTabsheet;
  rg.Caption := rgSex1.Caption;
  rg.Top:= rgSex1.Top;
  rg.Left := rgSex1.Left;
  rg.Height := rgSex1.Height;
  rg.Width := rgSex1.Width;
  rg.Items.Add('Male');
  rg.Items.Add('Female');
  rg.Items.Add('Unknown');
  rg.Columns := 3;
  rgSexList.Add(rg);

  //Living
  rbL := TRadioButton.Create(vTabsheet);
  rbL.Name := 'rbLiving' + vPN;
  rbL.Parent := vTabsheet;
  rbL.Caption := rbLiving1.Caption;
  rbL.Top := rbLiving1.Top;
  rbL.Left := rbLiving1.Left;
  rbL.Height := rbLiving1.Height;
  rbL.Width := rbLiving1.Width;
  rbLivingList.Add(rbL);

  //Demised
  rbD := TRadioButton.Create(vTabsheet);
  rbD.Name := 'rbDemised' + vPN;
  rbD.Parent := vTabsheet;
  rbD.Caption := rbDemised1.Caption;
  rbD.Top := rbDemised1.Top;
  rbD.Left := rbDemised1.Left;
  rbD.Height := rbDemised1.Height;
  rbD.Width := rbDemised1.Width;
  rbDemisedList.Add(rbD);

  //Birth Weight Label
  lblBirthweightx := TLabel.Create(vTabSheet);
  lblBirthweightx.Name := 'lblBirthweight'+vPN;
  lblBirthweightx.Parent := vTabSheet;
  lblBirthweightx.Caption := lblBirthweight1.Caption;
  lblBirthweightx.Top := lblBirthweight1.Top;
  lblBirthweightx.Left := lblBirthweight1.Left;
  lblBirthweightx.Height := lblBirthweight1.Height;
  lblBirthweightx.Width := lblBirthweight1.Width;

  //Birth Weight SpinEdit LBS
  edtLBx := TJvSpinEdit.Create(vTabSheet);
  edtLBx.Name := 'edtLB' + vPN;
  edtLBx.Parent := vTabSheet;
  edtLbx.ValueType := vtFloat;
  edtLBx.Value := 0;
  edtLbx.Decimal := 0;
  edtLBx.Top := edtLB1.Top;
  edtLBx.Left := edtLB1.Left;
  edtLBx.Height := edtLB1.Height;
  edtLBx.Width := edtLB1.Width;
  edtLbx.OnChange := edtLb1Change;
  edtLBList.Add(edtLBx);

  //Birth Weight lbs Label
  lblLBx := TLabel.Create(vTabSheet);
  lblLBx.Name := 'lblLB' + vPN;
  lblLBx.Parent := vTabSheet;
  lblLBx.Caption := lblLB1.Caption;
  lblLBx.Top := lblLB1.Top;
  lblLBx.Left := lblLB1.Left;
  lblLBx.Height := lblLB1.Height;
  lblLBx.Width := lblLB1.Width;

  //Birth Weight SpinEdit OZS
  edtOZx := TJvSpinEdit.Create(vTabSheet);
  edtOZx.Name := 'edtOZ' + vPN;
  edtOZx.Parent := vTabSheet;
  edtOzx.ValueType := vtFloat;
  edtOZx.Value := 0;
  edtozx.Decimal := 0;
  edtOZx.Top := edtOZ1.Top;
  edtOZx.Left := edtOZ1.Left;
  edtOZx.Height := edtOZ1.Height;
  edtOZx.Width := edtOZ1.Width;
  edtOzx.OnChange := edtOz1Change;
  edtOZList.Add(edtOZx);

  //Birth Weight ozs Label
  lblOzx := TLabel.Create(vTabSheet);
  lblOzx.Name := 'lblOz' + vPN;
  lblOzx.Parent := vTabSheet;
  lblOzx.Caption := lblOz1.Caption;
  lblOzx.Top := lblOz1.Top;
  lblOzx.Left := lblOz1.Left;
  lblOzx.Height := lblOz1.Height;
  lblOzx.Width := lblOz1.Width;

  //Birth Weight grams spinedit
  edtlblg := TJvSpinEdit.Create(vTabsheet);
  edtlblg.Name := 'edtg' + vPN;
  edtlblg.Parent := vTabsheet;
  edtlblg.ValueType := vtFloat;
  edtlblg.Value := 0;
  edtlblg.Top := edtg1.Top;
  edtlblg.Left := edtg1.Left;
  edtlblg.Height := edtg1.Height;
  edtlblg.Width := edtg1.Width;
  edtlblg.OnChange := UpdateLBOZ;
  edtGList.Add(edtlblg);

  //Birth Weight grams Label
  lblg := TLabel.Create(vTabSheet);
  lblg.Name := 'lblg' + vPN;
  lblg.Parent := vTabSheet;
  lblg.Caption := lblg1.Caption;
  lblg.Top := lblg1.Top;
  lblg.Left := lblg1.Left;
  lblg.Height := lblg1.Height;
  lblg.Width := lblg1.Width;

  //APGAR Score Part 1
  edtlbla := TLabeledEdit.Create(vTabsheet);
  edtlbla.Name := 'edtAPGAR' + vPN;
  edtlbla.Parent := vTabsheet;
  edtlbla.LabelPosition := lpLeft;
  edtlbla.EditLabel.Caption := edtAPGAR1.EditLabel.Caption;
  edtlbla.Text := '';
  edtlbla.Top := edtAPGAR1.Top;
  edtlbla.Left := edtAPGAR1.Left;
  edtlbla.Height := edtAPGAR1.Height;
  edtlbla.Width := edtAPGAR1.Width;
  edtAPGARList.Add(edtlbla);

  //APGAR Score Part 2
  edtAPGARs := TEdit.Create(vTabsheet);
  edtAPGARs.Name := 'edtAPGARs' + vPN;
  edtAPGARs.Parent := vTabsheet;
  edtAPGARs.Text := '';
  edtAPGARs.Top := edtAPGARs1.Top;
  edtAPGARs.Left := edtAPGARs1.Left;
  edtAPGARs.Height := edtAPGARs1.Height;
  edtAPGARs.Width := edtAPGARs1.Width;
  edtAPGARsList.Add(edtAPGARs);

  //NICU
  ck := TCheckBox.Create(vTabsheet);
  ck.Name := 'ckNICU' + vPN;
  ck.Parent := vTabsheet;
  ck.Caption := ckNICU1.Caption;
  ck.Top := ckNICU1.Top;
  ck.Left := ckNICU1.Left;
  ck.Height := ckNICU1.Height;
  ck.Width := ckNICU1.Width;
  ckNICUList.Add(ck);

  //Complications Memo
  memComplicationsx := TMemo.Create(vTabSheet);
  memComplicationsx.Name := 'memComplications' + vPN;
  memComplicationsx.Parent := vTabSheet;
  memComplicationsx.Top := memComplications1.Top;
  memComplicationsx.Left := memComplications1.Left;
  memComplicationsx.Height := memComplications1.Height;
  memComplicationsx.Width := memComplications1.Width;
  memComplicationsx.Lines.Clear;
  memComplicationsx.ScrollBars := ssVertical;
  memComplicationsList.Add(memComplicationsx);

  //Complications Memo Label
  lblComplicationsx := TLabel.Create(vTabSheet);
  lblComplicationsx.Name := 'lblComplications' + vPN;
  lblComplicationsx.Parent := vTabSheet;
  lblComplicationsx.Caption := lblComplications1.Caption;
  lblComplicationsx.Top := lblComplications1.Top;
  lblComplicationsx.Left := lblComplications1.Left;
  lblComplicationsx.Height := lblComplications1.Height;
  lblComplicationsx.Width := lblComplications1.Width;
end;

procedure TForm1.Rebuild;
begin
  if rgSexlist = nil then
  begin
    rgSexlist := TList.Create;
    rgSexList.Add(rgSex1);
  end;
  if rbLivingList = nil then
  begin
    rbLivingList := TList.Create;
    rbLivingList.Add(rbLiving1);
  end;
  if rbDemisedList = nil then
  begin
    rbDemisedList := TList.Create;
    rbDemisedList.Add(rbDemised1);
  end;
  if edtLBList = nil then
  begin
    edtLBList := TList.Create;
    edtLBList.Add(edtLB1);
  end;
  if edtOzList = nil then
  begin
    edtOzList := TList.Create;
    edtOzList.Add(edtOz1);
  end;
  if edtGList = nil then
  begin
    edtGList := TList.Create;
    edtGList.Add(edtg1);
  end;
  if edtAPGARList = nil then
  begin
    edtAPGARList := TList.Create;
    edtAPGARList.Add(edtAPGAR1);
  end;
  if edtAPGARsList = nil then
  begin
    edtAPGARsList := TList.Create;
    edtAPGARsList.Add(edtAPGARs1);
  end;
  if ckNICUList = nil then
  begin
    ckNICUList := TList.Create;
    ckNICUList.Add(ckNICU1);
  end;
  if memComplicationsList = nil then
  begin
    memComplicationsList:= Tlist.Create;
    memComplicationsList.Add(memComplications1);
  end;
end;

procedure TForm1.edtNumBabiesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key >= 98) and (Key <= 104)) then
  begin
    edtNumBabies.OnChange := nil;
    edtNumBabies.Value := (Key - 96);
    edtNumBabies.OnChange := edtNumBabiesChange;
  end;
  if ((Key >= 50) and (Key <= 56)) then
  begin
    edtNumBabies.OnChange := nil;
    edtNumBabies.Value := (Key - 48);
    edtNumBabies.OnChange := edtNumBabiesChange;
  end;
  KeyValue := edtNumBabies.Value;
end;

procedure TForm1.edtLb1Change(Sender: TObject);
begin
  if not (Sender is TJvSpinEdit) then
    Exit;

  if TJvSpinEdit(Sender).Value < 0 then
  begin
    TJvSpinEdit(Sender).Value := 0;
    Exit;
  end;

  UpdateGrams(TTabSheet(TJvSpinEdit(Sender).Parent).PageIndex);
end;

procedure TForm1.edtOz1Change(Sender: TObject);
var
  lb,lb2,oz: double;
  J: Integer;
begin
  if not (Sender is TJvSpinEdit) then Exit;
  if TJvSpinEdit(Sender).Value < 0 then
  begin
    TJvSpinEdit(Sender).Value := 0;
    Exit;
  end;

  J := TTabSheet(TJvSpinEdit(Sender).Parent).PageIndex;
  UpdateGrams(J);

  lb := Convert(TJvSpinEdit(edtOzList[J]).Value, muOunces, muPounds);
  if lb >= 1 then
  begin
    lb2 := Convert(Trunc(lb), muPounds, muOunces);
     oz := TJvSpinEdit(edtOzList[J]).Value - lb2;
     lb := Convert(lb2, muOunces, muPounds);

    TJvSpinEdit(edtLBList[J]).Value := TJvSpinEdit(edtLBList[J]).Value + lb;
    TJvSpinEdit(edtOzList[J]).Value := oz;
  end;
end;

procedure TForm1.UpdateLBOZ(Sender: TObject);
var
  lb,lb2,oz: double;
  I: Integer;
begin
  if not (Sender is TJvSpinEdit) then
    Exit;

  I := TTabSheet(TJvSpinEdit(Sender).Parent).PageIndex;
  OnChangeNil(I);

  oz := Convert(TJvSpinEdit(edtGList[I]).Value, muGrams, muOunces);
  lb := Convert(TJvSpinEdit(edtGList[I]).Value, muGrams, muPounds);
  if lb >= 1 then
  begin
    lb2 := Convert(Trunc(lb), muPounds, muOunces);
     oz := oz - lb2;

    TJvSpinEdit(edtLBList[I]).Value := Convert(lb2, muOunces, muPounds);
    TJvSpinEdit(edtOzList[I]).Value := oz;
  end else
  begin
    TJvSpinEdit(edtOzList[I]).Value := oz;
    TJvSpinEdit(edtLBList[I]).Value := 0;
  end;

  OnChangeRestore(I);
end;

procedure TForm1.UpdateGrams(J: Integer);
var
  lbs,ozs: double;
begin
  OnChangeNil(J);

  lbs := Convert(TJvSpinEdit(edtLBList[J]).Value, muPounds, muGrams);
  ozs := Convert(TJvSpinEdit(edtOzList[J]).Value, muOunces, muGrams);
  TJvSpinEdit(edtGList[J]).Value := lbs + ozs;

  OnChangeRestore(J);
end;

procedure TForm1.OnChangeNil(J: Integer);
var
  lbc,ozc,gc: TJvSpinEdit;
begin
  lbc := TJvSpinEdit(edtLBList[J]);
  ozc := TJvSpinEdit(edtOzList[J]);
   gc := TJvSpinEdit(edtGList[J]);
  lbc.OnChange := nil;
  ozc.OnChange := nil;
   gc.OnChange := nil;
end;

procedure TForm1.OnChangeRestore(J: Integer);
var
  lbc,ozc,gc: TJvSpinEdit;
begin
  lbc := TJvSpinEdit(edtLBList[J]);
  ozc := TJvSpinEdit(edtOzList[J]);
   gc := TJvSpinEdit(edtGList[J]);
  lbc.OnChange := edtLb1Change;
  ozc.OnChange := edtOz1Change;
   gc.OnChange := UpdateLBOZ;
end;

end.
