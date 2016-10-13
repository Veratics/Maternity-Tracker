Routine DSIO8 saved using VFDXTRS routine on Oct 13, 2016 17:20
DSIO8^INT^64180,41191^Sep 19, 2016@11:26
DSIO8 ;DSS/KAR - DSIO EDUCATION RPCs;08/26/2016 16:00
 ;;2.0;DSIO 2.0;;Aug 26, 2016;Build 1
 ;
 ;
 ;
 Q
 ;
SAVE(RET,IEN,DESC,CAT,TYPE,URL,CODE,SYS,DEL) ; RPC: DSIO SAVE EDUCATION ITEM
 ;
 ;  INPUT:
 ;    IEN:  IEN OF RECORD TO UPDATE OR DELETE, ELSE BLANK FOR NEW RECORD
 ;   DESC:  ENTER DESCRIPTION - REQUIRED
 ;    CAT:  CATEGORY IN WHICH MATERIAL FALLS
 ;   TYPE:  (D)ISCUSSION, (L)INC, (P)RINTED, (E)NROLLMENT, (O)THER - REQUIRED
 ;    URL:  WEB LINK
 ;   CODE:  CODE NUMBER
 ;    SYS:  CODING SYSTEM (L)OINC, (S)NOMED, (N)ONE - REQUIRED
 ;    DEL:  0 = SAVE 1 = DELETE - OPTIONAL (DEFAULTS TO 0 - SAVE)
 ;
 ; OUTPUT:
 ;   1^SUCCESS OR -1^ERROR MESSAGE
 ;
 N J,I,DSIOFDA,IENS,P01,FLAG S FLAG=0 K RET
 S IEN=$G(IEN),DEL=$G(DEL),URL=$G(URL),CAT=$G(CAT),CODE=$G(CODE)
 I IEN,$$FIND1^DIC(19641.8,,"A",IEN,,,"ERR")=0 S RET="-1^THIS RECORD DOES NOT EXIST." Q
 I IEN'="",DEL=1 D   ; DELETE A RECORD
 .; HAVE IEN OF EDUCATION ITEM FROM INPUT PARAMETER
 .; CHECK IF THIS IEN IS POINTED TO IN THE DSIO MCC CHECKLIST(19641.7) OR DSIO MCC PATIENT CHECKLIST (19641.76) FILES
 .S J=0 F  S J=$O(^DSIO(19641.7,"C",IEN,J)) Q:'J  D
 ..I $D(^DSIO(19641.7,"C",IEN,J)) S FLAG=1,RET="-1^CANNOT DELETE THIS ITEM SINCE IT IS LINKED TO THE DSIO MCC CHECKLIST" Q
 .Q:FLAG
 .S J=0 F  S J=$O(^DSIO(19641.76,"D",IEN,J)) Q:'J  D
 ..S I=0 F  S I=$O(^DSIO(19641.76,"D",IEN,J,I)) Q:'I  D
 ...I $D(^DSIO(19641.76,"D",IEN,J,I)) S FLAG=1,RET="-1^CANNOT DELETE THIS ITEM SINCE IT IS LINKED TO THE DSIO MCC PATIENT CHECKLIST" Q
 .Q:FLAG
 .S IENS=IEN_","
 .S DSIOFDA(19641.8,IENS,.01)="@"
 .K IENS D UPDATE^DIE(,"DSIOFDA","IENS","MSG")
 .S RET="1^SUCCESSFULLY DELETED RECORD"
 .S FLAG=1
 Q:FLAG
 Q:IEN'=""&(DEL=1)
 S DESC=$G(DESC) I DESC']"" S RET="-1^Description not specified" Q
 S TYPE=$G(TYPE) I TYPE']"" S RET="-1^Type not specified" Q
 S SYS=$G(SYS) I SYS']"" S RET="-1^System not specified" Q
 S DESC=$$TITLE^XLFSTR(DESC),CAT=$$TITLE^XLFSTR(CAT)
 I DEL'=1 S DEL=0
 I DEL=0,IEN]"" D  Q  ; UPDATE TO FILE
 .S IENS=IEN_","
 .S DSIOFDA(19641.8,IENS,.01)=DESC
 .S DSIOFDA(19641.8,IENS,1)=CAT
 .S DSIOFDA(19641.8,IENS,3)=TYPE
 .S DSIOFDA(19641.8,IENS,4)=URL
 .S DSIOFDA(19641.8,IENS,5)=CODE
 .S DSIOFDA(19641.8,IENS,6)=SYS
 .D FILE^DIE(,"DSIOFDA","MSG")
 .S RET="1^SUCCESSFULLY UPDATED RECORD"
 .S FLAG=1
 Q:FLAG
 I DEL=0,IEN="" D  Q  ; SAVE
 .S IENS="+1,"
 .S DSIOFDA(19641.8,IENS,.01)=DESC
 .S DSIOFDA(19641.8,IENS,1)=CAT
 .S DSIOFDA(19641.8,IENS,3)=TYPE
 .S DSIOFDA(19641.8,IENS,4)=URL
 .S DSIOFDA(19641.8,IENS,5)=CODE
 .S DSIOFDA(19641.8,IENS,6)=SYS
 .K MSG
 .K IENS D UPDATE^DIE(,"DSIOFDA","IENS","MSG")
 .;I $D(MSG) S RET="-1^"_MSG("DIERR",1,"TEXT",1) Q
 .S P01=9999999 S P01=$O(^DSIO(19641.8,P01),-1)
 .S RET=P01_"^SUCCESS" Q
 Q
 ;
GET(RET,PSIZE,PAGE,CAT,TYPE,IEN,FLG) ; RPC: DSIO GET EDUCATION ITEMS
 ;
 ;  INPUT:
 ;  PSIZE: NUMBER OF ITEMS TO RETURN
 ;   PAGE: NUMBER OF PAGES
 ;    CAT: CATEGORY INTO WHICH MATERIAL FALLS
 ;   TYPE: (D)ISCUSSION, (L)INC, (P)RINTED MATERIAL, (E)NROLLMENT, (O)THER
 ;    IEN: IEN OF RECORD TO GET, ELSE BLANK FOR ARRAY OF PAGES
 ;    FLG: SORT - 0=BY TYPE, 1=BY DESCRIPTION, 2=BY CATEGORY (DEFAULT IS TYPE)
 ; OUTPUT:
 ;   RET(0)    = NUMBER OF ITEMS
 ;   RET(1..n) = IEN ^ DESCRIPTION ^ CATEGORY ^ TYPE ^ URL ^ CODE ^ CODING SYSTEM
 ;     OR -1^ERROR MESSAGE
 ;
 N I,J,FILE,DESC,URL,CODE,SYS S FILE=19641.8 K RET
 S PSIZE=$G(PSIZE) S:PSIZE>500 PSIZE=500
 S PAGE=$G(PAGE),CAT=$G(CAT),TYPE=$G(TYPE),IEN=$G(IEN)
 S FLG=$G(FLG) I FLG=""!(FLG>2!(FLG<0)) S FLG=0
 I IEN]"" D  Q
 .I IEN D  Q  ; RETRIEVE A SPECIFIC RECORD
 ..S RET=$NA(^TMP("DSIO8",$J)) K @RET
 ..I $$GET1^DIQ(FILE,IEN,.01)="" S @RET@(0)=0,@RET@(1)="-1^THIS RECORD DOES NOT EXIST" Q
 ..S @RET@(0)=1
 ..S @RET@(1)=IEN_"^"_$$GET1^DIQ(FILE,IEN,.01)_"^"_$$GET1^DIQ(FILE,IEN,1)_"^"_$$GET1^DIQ(FILE,IEN,3)
 ..S @RET@(1)=@RET@(1)_"^"_$$GET1^DIQ(FILE,IEN,4)_"^"_$$GET1^DIQ(FILE,IEN,5)_"^"_$$GET1^DIQ(FILE,IEN,6)
 .I IEN>0 Q
 ;
 N I,J,K,FLAG,CAT1,TYPE1,CNT,MIN,MAX,FILE,CT,CT0,CT1,CT2,CT3,TOT
 S (MIN,MAX,FLAG)=0,(TYPE1,CAT1)="",CNT=1 K RET,ARR
 S PSIZE=$G(PSIZE),PAGE=$G(PAGE),CAT=$G(CAT),TYPE=$G(TYPE),IEN=$G(IEN)
 S FILE=19641.8,CT=1,(TOT,CT0,CT1,CT2,CT3)=0
 S RET=$NA(^TMP("DSIO8",$J)) K @RET
 I CAT]"" S FLAG=1
 I TYPE]"" S FLAG=2
 I CAT]"",TYPE]"" S FLAG=3
 I ((PSIZE="")&(PAGE'=""))!((PSIZE'="")&(PAGE="")) S @RET@(1)="-1^MUST ENTER BOTH PAGE AND PAGE SIZE OR NEITHER." Q
 ;
 I FLG=0 D  ; SORT BY TYPE
 .S J="" F  S J=$O(^DSIO(FILE,"AD",J)) Q:J=""  D   ; J = TYPE
 ..S I=0 F  S I=$O(^DSIO(FILE,"AD",J,I)) Q:'I  D   ; I = IEN
 ...S DESC=$P($G(^DSIO(19641.8,I,0)),U)
 ...S CAT1=$$GET1^DIQ(FILE,I,1),TYPE1=$$GET1^DIQ(FILE,I,3) I $L(TYPE1)=0 S TYPE1=$$GET1^DIQ(FILE,I,3,"I")
 ...S URL=$$GET1^DIQ(FILE,I,4),CODE=$$GET1^DIQ(FILE,I,5),SYS=$$GET1^DIQ(FILE,I,6)
 ...S ARR(CNT)=I_"^"_DESC_"^"_CAT1_"^"_TYPE1_"^"_URL_"^"_CODE_"^"_SYS,CNT=CNT+1
 ;
 I FLG=1 D  ; SORT BY DESCRIPTION
 .S J="" F  S J=$O(^DSIO(FILE,"B",J)) Q:J=""  D  ; J = DESCTIPTION
 ..S I=0 F  S I=$O(^DSIO(FILE,"B",J,I)) Q:'I  D  ; I = IEN
 ...S DESC=$P($G(^DSIO(FILE,I,0)),U) ;,DESC=$$TITLE^XLFSTR(DESC)
 ...S CAT1=$$GET1^DIQ(FILE,I,1),TYPE1=$$GET1^DIQ(FILE,I,3) I $L(TYPE1)=0 S TYPE1=$$GET1^DIQ(FILE,I,3,"I")
 ...;S CAT1=$$TITLE^XLFSTR(CAT1)
 ...S URL=$$GET1^DIQ(FILE,I,4),CODE=$$GET1^DIQ(FILE,I,5),SYS=$$GET1^DIQ(FILE,I,6)
 ...S ARR(CNT)=I_"^"_DESC_"^"_CAT1_"^"_TYPE1_"^"_URL_"^"_CODE_"^"_SYS,CNT=CNT+1
 ;
 I FLG=2 D  ; SORT BY CATEGORY
 .S J="" F  S J=$O(^DSIO(FILE,"AC",J)) Q:J=""  D  ; J = CATEGORY
 ..S I=0 F  S I=$O(^DSIO(FILE,"AC",J,I)) Q:'I  D  ; I = IEN
 ...S DESC=$P($G(^DSIO(FILE,I,0)),U) ;,DESC=$$TITLE^XLFSTR(DESC)
 ...S CAT1=$$GET1^DIQ(FILE,I,1),TYPE1=$$GET1^DIQ(FILE,I,3) I $L(TYPE1)=0 S TYPE1=$$GET1^DIQ(FILE,I,3,"I")
 ...;S CAT1=$$TITLE^XLFSTR(CAT1)
 ...S URL=$$GET1^DIQ(FILE,I,4),CODE=$$GET1^DIQ(FILE,I,5),SYS=$$GET1^DIQ(FILE,I,6)
 ...S ARR(CNT)=I_"^"_DESC_"^"_CAT1_"^"_TYPE1_"^"_URL_"^"_CODE_"^"_SYS,CNT=CNT+1
 ;
 S K=0 F  S K=$O(ARR(K)) Q:'K  D
 .I FLAG=0 S CT0=CT0+1,@RET@(0)=CT0
 .I FLAG=1,$P(ARR(K),"^",3)=CAT S CT1=CT1+1,@RET@(0)=CT1
 .I FLAG=2,$P(ARR(K),"^",4)=TYPE S CT2=CT2+1,@RET@(0)=CT2
 .I FLAG=3,$P(ARR(K),"^",3)=CAT&($P(ARR(K),"^",4)=TYPE) S CT3=CT3+1,@RET@(0)=CT3
 .;
 .I 'PAGE D
 ..I FLAG=0 S @RET@(CT)=ARR(K),CT=CT+1
 ..I FLAG=1,$P(ARR(K),"^",3)=CAT S @RET@(CT)=ARR(K),CT=CT+1
 ..I FLAG=2,$P(ARR(K),"^",4)=TYPE S @RET@(CT)=ARR(K),CT=CT+1
 ..I FLAG=3,$P(ARR(K),"^",3)=CAT&($P(ARR(K),"^",4)=TYPE) S @RET@(CT)=ARR(K),CT=CT+1
 ;
 I PAGE D
 .N NARR,CT,J,MIN,MAX
 .S CT0=$P($G(^DSIO(19641.8,0)),U,4)
 .S MIN=((PAGE-1)*PSIZE)+1,MAX=(PAGE*PSIZE) I MIN=0 S MIN=1
 .;
 .I FLAG=0 D
 ..S @RET@(0)=CT0,CT=1
 ..S J=0 F  S J=$O(ARR(J)) Q:'J  D
 ...S NARR(CT)=ARR(J),CT=CT+1
 ..S CT=MIN,J=MIN-1 F  S J=$O(NARR(J)) Q:'J  D
 ...I MIN<=CT0 S @RET@(CT)=NARR(J),CT=CT+1 I CT>MAX S J=CT0 Q
 .;
 .I FLAG=1 D
 ..S @RET@(0)=CT1,CT=1
 ..S J=0 F  S J=$O(ARR(J)) Q:'J  D
 ...I $P(ARR(J),"^",3)=CAT S NARR(CT)=ARR(J),CT=CT+1
 ..S CT=MIN,J=MIN-1 F  S J=$O(NARR(J)) Q:'J  D
 ...I MIN<=CT1 S @RET@(CT)=NARR(J),CT=CT+1 I CT>MAX S J=CT0 Q
 .;
 .I FLAG=2 D
 ..S @RET@(0)=CT2,CT=1
 ..S J=0 F  S J=$O(ARR(J)) Q:'J  D
 ...I $P(ARR(J),"^",4)=TYPE S NARR(CT)=ARR(J),CT=CT+1
 ..S CT=MIN,J=MIN-1 F  S J=$O(NARR(J)) Q:'J  D
 ...I MIN<=CT2 S @RET@(CT)=NARR(J),CT=CT+1 I CT>MAX S J=CT0 Q
 .;
 .I FLAG=3 D
 ..S @RET@(0)=CT3,CT=1
 ..S J=0 F  S J=$O(ARR(J)) Q:'J  D
 ...I $P(ARR(J),"^",3)=CAT,$P(ARR(J),"^",4)=TYPE S NARR(CT)=ARR(J),CT=CT+1
 ..S CT=MIN,J=MIN-1 F  S J=$O(NARR(J)) Q:'J  D
 ...I MIN<=CT3 S @RET@(CT)=NARR(J),CT=CT+1 I CT>MAX S J=CT0 Q
 Q
 ;
SAVPTED(RET,DFN,IEN,COMPLON,EDUCIEN,CAT,DESC,TYPE,URL,CODE,CODESYS) ; RPC: DSIO SAVE PATIENT EDUCATION
 ;
 ;   INPUT:
 ;     DFN: PATIENT DFN - REQUIRED
 ;     IEN: IEN OF RECORD TO UPDATE, ELSE BLANK FOR NEW RECORD
 ; COMPLON: DATE COMPLETED - REQUIRED
 ; EDUCIEN: POINTER TO DSIO EDUCATION FILE (19641.8)
 ;     CAT: CATEGORY IN WHICH MATERIAL FALLS
 ;    DESC: ENTER DESCRIPTION
 ;    TYPE: (D)ISCUSSION, (L)INC, (P)RINTED, (E)NROLLMENT, (O)THER
 ;     URL: WEB LINK
 ;    CODE: CODE NUMBER
 ; CODESYS: CODING SYSTEM (L)OINC, (S)NOMED, (N)ONE
 ;
 ;  OUTPUT:
 ;     "IEN^SUCCESS" OR "-1^ERROR MESSAGE" OR "1^SUCCESSFULLY UPDATED RECORD"
 ;
 N DSIOFDA,IENS,MSG,P01 K RET
 S DFN=$G(DFN),IEN=$G(IEN),COMPLON=$G(COMPLON),EDUCIEN=$G(EDUCIEN),CAT=$G(CAT),DESC=$G(DESC)
 S TYPE=$G(TYPE),URL=$G(URL),CODE=$G(CODE),CODESYS=$G(CODESYS)
 I DFN="" S RET="-1^MUST HAVE A PATIENT DFN" Q
 I COMPLON="" S RET="-1^MUST HAVE A COMPLETED ON DATE" Q
 I EDUCIEN="",DESC="" S RET="-1^MUST HAVE A DESCRIPTION IF NOT USING DSIO EDUCATION ITEM." Q
 I EDUCIEN="",TYPE="" S RET="-1^MUST HAVE A TYPE IF NOT USING DSIO EDUCATION ITEM." Q
 I EDUCIEN="",CODESYS="" S RET="-1^MUST HAVE A CODE SYSTEM IF NOT USING DSIO EDUCATION ITEM." Q
 ;
 I EDUCIEN'="",$G(^DSIO(19641.8,EDUCIEN,0))="" S RET="-1^THIS DSIO EDUCATION RECORD DOESN'T EXIST." Q
 I EDUCIEN'="" D  ; GRAB FROM 19641.8
 .S CAT=$$GET1^DIQ(19641.8,EDUCIEN,1,"E")
 .S DESC=$$GET1^DIQ(19641.8,EDUCIEN,.01,"E")
 .S TYPE=$$GET1^DIQ(19641.8,EDUCIEN,3,"I")
 .;I $L($$GET1^DIQ(19641.8,J,3,"I"))>1 S TYPE=$$GET1^DIQ(19641.8,J,3,"I")
 .S URL=$$GET1^DIQ(19641.8,EDUCIEN,4,"E")
 .S CODE=$$GET1^DIQ(19641.8,EDUCIEN,5,"E")
 .S CODESYS=$$GET1^DIQ(19641.8,EDUCIEN,6,"I")
 ;
 I IEN]"" D  Q  ; UPDATE TO FILE
 .S IENS=IEN_","
 .S DSIOFDA(19641.81,IENS,.01)=DFN
 .S DSIOFDA(19641.81,IENS,2)=DUZ
 .S DSIOFDA(19641.81,IENS,3)=COMPLON
 .S DSIOFDA(19641.81,IENS,4)=EDUCIEN
 .S DSIOFDA(19641.81,IENS,5)=CAT
 .S DSIOFDA(19641.81,IENS,10)=DESC
 .S DSIOFDA(19641.81,IENS,11)=TYPE
 .S DSIOFDA(19641.81,IENS,12)=URL
 .S DSIOFDA(19641.81,IENS,13)=CODE
 .S DSIOFDA(19641.81,IENS,14)=CODESYS
 .D FILE^DIE(,"DSIOFDA","MSG")
 .S RET="1^SUCCESSFULLY UPDATED RECORD" Q
 I IEN="" D  Q  ; SAVE
 .S P01=$P($G(^DSIO(19641.81,0)),U,4)+1
 .S IENS="+1,"
 .S DSIOFDA(19641.81,IENS,.01)=DFN
 .S DSIOFDA(19641.81,IENS,2)=DUZ
 .S DSIOFDA(19641.81,IENS,3)=COMPLON
 .S DSIOFDA(19641.81,IENS,4)=EDUCIEN
 .S DSIOFDA(19641.81,IENS,5)=CAT
 .S DSIOFDA(19641.81,IENS,10)=DESC
 .S DSIOFDA(19641.81,IENS,11)=TYPE
 .S DSIOFDA(19641.81,IENS,12)=URL
 .S DSIOFDA(19641.81,IENS,13)=CODE
 .S DSIOFDA(19641.81,IENS,14)=CODESYS
 .K MSG
 .K IENS D UPDATE^DIE(,"DSIOFDA","IENS","MSG")
 .;I $D(MSG) S RET="-1^"_MSG("DIERR",1,"TEXT",1) Q
 .S P01=9999999 S P01=$O(^DSIO(19641.81,P01),-1)
 .S RET=P01_"^SUCCESS" Q
 Q
 ;
GETPTED(RET,DFN,IEN,PSIZE,PAGE,FROM,TODA,TYPE) ; RPC: DSIO GET PATIENT EDUCATION
 ;
 ;  INPUT:
 ;    DFN: PATIENT DFN - REQUIRED
 ;    IEN: IEN OF RECORD TO GET, ELSE BLANK FOR ARRAY OF PAGES
 ;  PSIZE: NUMBER OF ITEMS PER PAGE
 ;   PAGE: NUMBER OF PAGES
 ;   FROM: DATE TO START SEARCH
 ;   TODA: DATE TO END SEARCH
 ;   TYPE: (D)ISCUSSION, (L)INC, (P)RINTED MATERIAL, (E)NROLLMENT, (O)THER
 ; OUTPUT:
 ;   RET(0)    = NUMBER OF ITEMS
 ;   RET(1..n) = IEN ^ COMPLETED ON ^ CATEGORY ^ DESCRIPTION ^ TYPE ^ URL ^ CODE ^ CODING SYSTEM ^ USER
 ;           OR -1^ERROR MESSAGE
 ;
 N I,J,FILE,ARR,ARRT,ARRF,CT S FILE=19641.81,CT=0 K RET,ARR,ARRT,ARRF
 S PSIZE=$G(PSIZE) S:PSIZE>500 PSIZE=500
 S DFN=$G(DFN),FROM=$G(FROM),TODA=$G(TODA),PAGE=$G(PAGE),CAT=$G(CAT),TYPE=$G(TYPE),IEN=$G(IEN)
 S RET=$NA(^TMP("DSIO8",$J)) K @RET
 I DFN="" S @RET@(1)="-1^MUST ENTER A PATIENT DFN." Q
 I ((PSIZE="")&(PAGE'=""))!((PSIZE'="")&(PAGE="")) S @RET@(1)="-1^MUST ENTER BOTH PAGE AND PAGE SIZE OR NEITHER." Q
 ;
 ; RETRIEVE A SPECIFIC RECORD
 I IEN D  Q  ; 
 .I $$GET1^DIQ(FILE,IEN,.01)="" S @RET@(0)=0,@RET@(1)="-1^THIS RECORD DOES NOT EXIST" Q
 .S @RET@(0)=1
 .S DU=$$GET1^DIQ(FILE,IEN,2)
 .S @RET@(1)=IEN_"^"_$$GET1^DIQ(FILE,IEN,3,"I")_"^"_$$GET1^DIQ(FILE,IEN,5)_"^"_$$GET1^DIQ(FILE,IEN,10)
 .S @RET@(1)=@RET@(1)_"^"_$$GET1^DIQ(FILE,IEN,11)_"^"_$$GET1^DIQ(FILE,IEN,12)_"^"_$$GET1^DIQ(FILE,IEN,13)
 .S @RET@(1)=@RET@(1)_"^"_$$GET1^DIQ(FILE,IEN,14)_"^"_$$GET1^DIQ(200,DU,.01)
 I IEN>0 Q
 ;
 ; GET ALL RECORDS OF SPECIFIC PATIENT AND PUT IN ARR()
 N J,I,CNT,DAT,MIN,MAX S CNT=1,(MIN,MAX,I)=0
 S J=0 F  S J=$O(^DSIO(FILE,"B",J)) Q:'J  D  ; DFN
 .I J=DFN D
 ..S I=0 F  S I=$O(^DSIO(FILE,"B",J,I)) Q:'I  D   ; IEN
 ...S DU=$$GET1^DIQ(FILE,I,2)
 ...S ARR(CNT)=I_"^"_$$GET1^DIQ(FILE,I,3,"I")_"^"_$$GET1^DIQ(FILE,I,5)_"^"_$$GET1^DIQ(FILE,I,10)
 ...S ARR(CNT)=ARR(CNT)_"^"_$$GET1^DIQ(FILE,I,11)_"^"_$$GET1^DIQ(FILE,I,12)_"^"_$$GET1^DIQ(FILE,I,13)
 ...S ARR(CNT)=ARR(CNT)_"^"_$$GET1^DIQ(FILE,I,14)_"^"_$$GET1^DIQ(200,DU,.01),CNT=CNT+1  ;$$GET1^DIQ(FILE,I,2),CNT=CNT+1
 ...S ARR(0)=CNT-1
 I '$D(ARR) S @RET@(0)=0 Q
 K ARRF M ARRF=ARR S CT=ARRF(0)
 ;
 ; PUT IN FILTERS
 N J,DAT,CNT,ARRT S CNT=1 K ARRT
 I FROM="" S FROM=0
 I TODA="" S TODA=$$NOW^XLFDT
 S J=0 F  S J=$O(ARRF(J)) Q:'J  D
 .S DAT=$P($G(ARRF(J)),U,2)
 .S I=$P($G(ARRF(J)),U)
 .I DAT>=FROM,DAT<=TODA D
 ..S ARRT(CNT)=I_"^"_$P($G(ARRF(J)),U,2)_"^"_$P($G(ARRF(J)),U,3)_"^"_$P($G(ARRF(J)),U,4)
 ..S ARRT(CNT)=ARRT(CNT)_"^"_$P($G(ARRF(J)),U,5)_"^"_$P($G(ARRF(J)),U,6)_"^"_$P($G(ARRF(J)),U,7)
 ..S ARRT(CNT)=ARRT(CNT)_"^"_$P($G(ARRF(J)),U,8)_"^"_$P($G(ARRF(J)),U,9),CNT=CNT+1
 ..S ARRT(0)=CNT-1
 I $D(ARRT) K ARRF M ARRF=ARRT
 S CT=ARRF(0)
 ;
 I TYPE]"" D
 .S TYPE=$E(TYPE,1),CNT=1 K ARRT
 .S J=0 F  S J=$O(ARRF(J)) Q:'J  D
 ..S I=$P($G(ARRF(J)),U)
 ..S TYP=$E($P($G(ARRF(J)),U,5),1)
 ..I TYP=TYPE  D  ;!(TYPE="") D
 ...S ARRT(CNT)=I_"^"_$P($G(ARRF(J)),U,2)_"^"_$P($G(ARRF(J)),U,3)_"^"_$P($G(ARRF(J)),U,4)
 ...S ARRT(CNT)=ARRT(CNT)_"^"_$P($G(ARRF(J)),U,5)_"^"_$P($G(ARRF(J)),U,6)_"^"_$P($G(ARRF(J)),U,7)
 ...S ARRT(CNT)=ARRT(CNT)_"^"_$P($G(ARRF(J)),U,8)_"^"_$P($G(ARRF(J)),U,9),CNT=CNT+1
 ...S ARRT(0)=CNT-1
 .K ARRF M ARRF=ARRT I $D(ARRF) S CT=ARRF(0)
 ;
 I '$D(ARRF) S @RET@(0)=0 Q
 S @RET@(0)=0
 N MIN,MAX,ARRT,CNT,J S CNT=1 K ARRT
 I PAGE]"" D
 .S MIN=((PAGE-1)*PSIZE)+1,MAX=(PAGE*PSIZE),CNT=MIN
 .S J=MIN-1 F  S J=$O(ARRF(J)) Q:'J!(J>MAX)  D
 ..S I=$P($G(ARRF(J)),U)
 ..S ARRT(CNT)=I_"^"_$P($G(ARRF(J)),U,2)_"^"_$P($G(ARRF(J)),U,3)_"^"_$P($G(ARRF(J)),U,4)
 ..S ARRT(CNT)=ARRT(CNT)_"^"_$P($G(ARRF(J)),U,5)_"^"_$P($G(ARRF(J)),U,6)_"^"_$P($G(ARRF(J)),U,7)
 ..S ARRT(CNT)=ARRT(CNT)_"^"_$P($G(ARRF(J)),U,8)_"^"_$P($G(ARRF(J)),U,9),CNT=CNT+1
 ..S ARRT(0)=CNT-1
 .K ARRF M ARRF=ARRT
 M @RET=ARRF I CT'=0 S @RET@(0)=CT
 Q
 ;
GETCAT(RET) ;  RPC: DSIO GET EDUC CATEGORY LIST
 ; This RPC will produce an alphabetized list of category naes
 ; from the DSIO EDUCATION and the DSIO PATIENT EDUCATION files.
 N FILE,FILE1,I,J,CNT K RET
 S FILE=19641.8,FILE1=19641.81,CNT=1
 S RET=$NA(^TMP("DSIO8",$J)) K @RET
 S J="" F  S J=$O(^DSIO(FILE,"AC",J)) Q:J=""  D
 .S @RET@(CNT,J)=J
 S I="" F  S I=$O(^DSIO(FILE1,"AC",I)) Q:I=""  D
 .S @RET@(CNT,I)=I
 Q
 ;
TITLE ;
 N FILE,J,DSIOFDA,IENS S FILE=19641.8
 S J=0 F  S J=$O(^DSIO(FILE,J)) Q:'J  D
 .S DESC=$P($G(^DSIO(FILE,J,0)),U),DESC=$$TITLE^XLFSTR(DESC)
 .S CAT=$P($G(^DSIO(FILE,J,0)),U,2),CAT=$$TITLE^XLFSTR(CAT)
 .S TYPE=$P($G(^DSIO(FILE,J,0)),U,3)
 .S URL=$P($G(^DSIO(FILE,J,2)),U)
 .S CODE=$P($G(^DSIO(FILE,J,2)),U,2)
 .S SYS=$P($G(^DSIO(FILE,J,2)),U,3)
 .S IENS=J_","
 .S DSIOFDA(FILE,IENS,.01)=DESC
 .S DSIOFDA(FILE,IENS,1)=CAT
 .S DSIOFDA(FILE,IENS,3)=TYPE
 .S DSIOFDA(FILE,IENS,4)=URL
 .S DSIOFDA(FILE,IENS,5)=CODE
 .S DSIOFDA(FILE,IENS,6)=SYS
 .D FILE^DIE(,"DSIOFDA","MSG")
 ;W !,RET="1^SUCCESSFULLY UPDATED RECORDS"
 Q
