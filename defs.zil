;"***************************************************************************"
; "game : Arthur"
; "file : DEFS.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   12 May 1989  0:45:52  $"
; "rev  : $Revision:   1.144  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Default substitutions"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

<INCLUDE "BASEDEFS" "PBITDEFS" "SYMBOLS">

<COMPILATION-FLAG P-PS-COMMA T>
<COMPILATION-FLAG P-PS-QUOTE T>
<COMPILATION-FLAG P-DEBUGGING-PARSER T>

<TERMINALS
	VERB NOUN ADJ ADV QUANT MISCWORD DIR TOBE QWORD CANDO COMMA PARTICLE PREP
	ASKWORD ;PRONOUN QUOTE
>

<ADD-TELL-TOKENS
	D *						<RT-PRINT-DESC .X>
	a *						<RT-PRINT-OBJ .X ,K-ART-A>
	A *						<RT-PRINT-OBJ .X ,K-ART-A T>
	a+verb *	*:STRING		<RT-PRINT-OBJ .X ,K-ART-A <> .Y>
	A+verb *	*:STRING		<RT-PRINT-OBJ .X ,K-ART-A T .Y>
	any *						<RT-PRINT-OBJ .X ,K-ART-ANY>
	Any *						<RT-PRINT-OBJ .X ,K-ART-ANY T>
	the *						<RT-PRINT-OBJ .X ,K-ART-THE>
	the+verb * *:STRING	<RT-PRINT-OBJ .X ,K-ART-THE <> .Y>
	The *						<RT-PRINT-OBJ .X ,K-ART-THE T>
	The+verb * *:STRING	<RT-PRINT-OBJ .X ,K-ART-THE T .Y>
	he *						<RT-PRINT-OBJ .X ,K-ART-HE>
	he+verb * *:STRING	<RT-PRINT-OBJ .X ,K-ART-HE <> .Y>
	He *						<RT-PRINT-OBJ .X ,K-ART-HE T>
	He+verb * *:STRING	<RT-PRINT-OBJ .X ,K-ART-HE T .Y>
	him *						<RT-PRINT-OBJ .X ,K-ART-HIM>
	his *						<RT-PRINT-OBJ .X ,K-ART-HIS>
	His *						<RT-PRINT-OBJ .X ,K-ART-HIS T>
	verb * *:STRING		<RT-PRINT-VERB .X .Y>
	in *						<RT-IN-ON-MSG .X>
	In *						<RT-IN-ON-MSG .X T>
	out *						<RT-OUT-OFF-MSG .X>
	Out *						<RT-OUT-OFF-MSG .X T>
	vw							<PRINTB ,P-PRSA-WORD>
	form						<RT-FORM-MSG>
	formtype					<RT-FORM-TYPE-MSG>
	Form						<RT-FORM-MSG <> T>
	aform						<RT-FORM-MSG ,K-ART-A>
	Aform						<RT-FORM-MSG ,K-ART-A T>
	open *					<RT-OPEN-MSG .X>
	wn *						<RT-WORD-NUMBERS .X>
	walk						<RT-WALK-MSG>
	walking					<RT-WALK-MSG T>
	standing					<RT-STANDING-MSG>
	comma *					<RT-COMMA-MSG .X>
	dirword *				<RT-DIRWORD-MSG .X>
>

<PROPDEF SIZE <>
	(SIZE S:FIX "OPT" CAPACITY C:FIX =
		2
		(K-SIZE <BYTE .S>)
		(K-CAPACITY <BYTE .C>)
	)
	(CAPACITY C:FIX "OPT" SIZE S:FIX =
		2
		(K-SIZE <BYTE .S>)
		(K-CAPACITY <BYTE .C>)
	)
>
<CONSTANT K-CAP-MAX 255>

<CONSTANT K-UP		129>
<CONSTANT K-DOWN	130>
<CONSTANT K-LEFT	131>
<CONSTANT K-RIGHT	132>
<CONSTANT K-F1		133>
<CONSTANT K-F2		134>
<CONSTANT K-F3		135>
<CONSTANT K-F4		136>
<CONSTANT K-F5		137>
<CONSTANT K-F6		138>
<CONSTANT K-F7		139>
<CONSTANT K-F8		140>
<CONSTANT K-F9		141>
<CONSTANT K-F10	142>
<CONSTANT K-F11	143>
<CONSTANT K-F12	144>
<CONSTANT K-CLICK1	254>
<CONSTANT K-CLICK2	253>
<CONSTANT CR 13>
<CONSTANT LF 10>
<CONSTANT TAB 9>
<CONSTANT ESC 27>

<CONSTANT TCHARS
	<TABLE (KERNEL BYTE)
		,K-UP
		,K-DOWN
		,K-LEFT
		,K-RIGHT
		,K-F1
		,K-F2
		,K-F3
		,K-F4
		,K-F5
		,K-F6
		,K-CLICK1
		,K-CLICK2
		0
	>
>

<DEFMAC RT-AUTHOR-ON ()
	<FORM DIROUT ',D-TABLE-ON ',K-DIROUT-TBL ;0>
>

<DEFMAC APPLE? ()
	<FORM EQUAL? <FORM LOWCORE INTID> ',APPLE-2E ',APPLE-2C ',APPLE-2GS>
>

<REPLACE-DEFINITION DIR-VERB-PRSI?
	<CONSTANT DIR-VERB-PRSI? <>>
; "The following is surrounded by quotes so that the atoms PARSE-ACTION and
	NOUN-PHRASE-OBJ1 do not get defined."
; "<DEFINE DIR-VERB-PRSI? (NP)
		<AND
			<EQUAL? <PARSE-ACTION ,PARSE-RESULT>
				,V?MOVE-DIR ,V?RIDE-DIR ,V?ROLL-DIR ,V?SET-DIR
			>
			<NOT <EQUAL? <NOUN-PHRASE-OBJ1 .NP> ,INTDIR ,LEFT-RIGHT>>
		>
	>"
>

<REPLACE-DEFINITION NO-M-WINNER-VERB?
	<CONSTANT NO-M-WINNER-VERB-TABLE
		<PLTABLE V?TELL-ABOUT V?GIVE-SWP ;V?SHOW-SWP ;V?RUB-SWP ;V?PUT-ON-SWP>
	>
	<ROUTINE NO-M-WINNER-VERB? ()
		<COND
			(<INTBL? ,PRSA <ZREST ,NO-M-WINNER-VERB-TABLE 2>
					<ZGET ,NO-M-WINNER-VERB-TABLE 0>
				>
				<RTRUE>
			)
		>
	>
>

<REPLACE-DEFINITION SPEAKING-VERB?
	<ROUTINE SPEAKING-VERB? ()
		<EQUAL? ,PRSA
,V?ASK-ABOUT ,V?ASK-FOR ,V?CALL ,V?CHALLENGE ,V?GOODBYE ,V?HELLO ,V?SAY
,V?TALK-TO ,V?TELL ,V?TELL-ABOUT ,V?THANK ,V?WHO ,V?WHAT ,V?YELL
		>
	>
>

<REPLACE-DEFINITION CONTBIT		<CONSTANT CONTBIT			FL-CONTAINER>>
<REPLACE-DEFINITION FEMALE			<CONSTANT FEMALE			FL-FEMALE>>
<REPLACE-DEFINITION INVISIBLE		<CONSTANT INVISIBLE		FL-INVISIBLE>>
<REPLACE-DEFINITION NARTICLEBIT	<CONSTANT NARTICLEBIT	FL-NO-ARTICLE>>
<REPLACE-DEFINITION ONBIT			<CONSTANT ONBIT			FL-LIGHTED>>
<REPLACE-DEFINITION OPENBIT		<CONSTANT OPENBIT			FL-OPEN>>
<REPLACE-DEFINITION PERSONBIT		<CONSTANT PERSONBIT		FL-PERSON>>
<REPLACE-DEFINITION PLURAL			<CONSTANT PLURAL			FL-PLURAL>>
<REPLACE-DEFINITION ROOMSBIT		<CONSTANT ROOMSBIT		FL-ROOMS>>
<REPLACE-DEFINITION SEARCHBIT		<CONSTANT SEARCHBIT		FL-SEARCH>>
<REPLACE-DEFINITION SEENBIT		<CONSTANT SEENBIT			FL-SEEN>>
<REPLACE-DEFINITION SURFACEBIT	<CONSTANT SURFACEBIT		FL-SURFACE>>
<REPLACE-DEFINITION TAKEBIT		<CONSTANT TAKEBIT			FL-TAKEABLE>>
<REPLACE-DEFINITION TRANSBIT		<CONSTANT TRANSBIT		FL-TRANSPARENT>>
<REPLACE-DEFINITION TRYTAKEBIT	<CONSTANT TRYTAKEBIT		FL-TRY-TAKE>>
<REPLACE-DEFINITION TOUCHBIT		<CONSTANT TOUCHBIT		FL-TOUCHED>>

<REPLACE-DEFINITION PLAYER <CONSTANT PLAYER CH-PLAYER>>

<REPLACE-DEFINITION GAME-VERB?
	<ROUTINE GAME-VERB? ()
		%<DEBUG-CODE
			<COND
				(<EQUAL? ,PRSA ,V?COMMAND ,V?RECORD ,V?UNRECORD>
					<RTRUE>
				)
			>
		>
		<COND
			(<EQUAL? ,PRSA
,V?QUIT ,V?RESTART ,V?RESTORE ,V?SAVE ,V?SCRIPT ,V?VERIFY ,V?DESC-LEVEL
,V?$REFRESH ,V?VERSION ,V?SCORE
				>
				<RTRUE>
			)
		>
	>
>

<REPLACE-DEFINITION ITAKE-CHECK
	<ROUTINE ITAKE-CHECK (OBJ BITS "AUX" (TAKEN <>) V)
		<COND
			(<AND <NOT <HELD? .OBJ ,WINNER>>
					<NOT <EQUAL? .OBJ ,TH-HANDS ,ROOMS>>
				>
				<COND
					(<NOT <EQUAL? ,GL-PLAYER-FORM ,K-FORM-ARTHUR>>
						T
					)
					(<FSET? .OBJ ,FL-TRY-TAKE>
						T
					)
					(<NOT <RT-META-IN? .OBJ ,WINNER>>
						T
					)
				;	(<RT-META-IN? ,WINNER .OBJ>
						T
					)
				;	(<NOT <EQUAL? ,WINNER ,CH-PLAYER>>
						<SET TAKEN T>
					)
					(<BTST .BITS ,SEARCH-DO-TAKE>
						<SET V <ITAKE .OBJ <>>>
						<COND
							(<AND .V
									<NOT <EQUAL? .V ,M-FATAL>>
								>
								<SET TAKEN T>
							)
						>
					)
				>
				<COND
					(<AND <NOT .TAKEN>
							<BTST .BITS ,SEARCH-MUST-HAVE>
						>
						<THIS-IS-IT .OBJ>
						<RT-AUTHOR-ON>
						<TELL The+verb ,WINNER "are" "n't holding" the .OBJ ".">
						<RT-AUTHOR-OFF>
					)
				>
			)
		>
	>
>

<REPLACE-DEFINITION NOT-HERE-VERB?
	<ROUTINE NOT-HERE-VERB? (V)
		<EQUAL? .V ,V?WALK-TO>
	>
>

<REPLACE-DEFINITION QCONTEXT-CHECK
	<ROUTINE QCONTEXT-CHECK (PER "AUX" WHO)
		<COND
			(<OR	<AND
						<EQUAL? ,PRSA ,V?SHOW ,V?TELL-ABOUT>
						<EQUAL? .PER ,PLAYER>
					>
					<AND
						<EQUAL? ,PRSA ,V?HELLO ,V?GOODBYE>
						<EQUAL? .PER <> ,ROOMS>
					>
				>
				<COND
					(<AND <SET WHO <FIND-A-WINNER ,HERE>>
						;	<OR	; "Is this right? -- DEB"
								<MC-FORM? ,K-FORM-ARTHUR>
								<NOT <FSET? .WHO ,FL-PERSON>>
							>
						>
						<SETG QCONTEXT .WHO>
					)
				>
				<COND
					(<AND <QCONTEXT-GOOD?>
							<EQUAL? ,WINNER ,PLAYER> ;"? more?"
						>
						<SETG WINNER ,QCONTEXT>
						<TELL-SAID-TO ,QCONTEXT>
						<RTRUE>
					)
				>
			)
		>
	>
>

<REPLACE-DEFINITION TELL-SAID-TO
	<DEFINE TELL-SAID-TO (PER)
		<TELL "[said to" the .PER "]" CR>
	>
>

<REPLACE-DEFINITION FIND-A-WINNER
	<DEFINE FIND-A-WINNER ACT ("OPT" (RM ,HERE) "AUX" (WHO <>))
		<COND
			(<AND ,QCONTEXT
					<IN? ,QCONTEXT .RM>
				>
				,QCONTEXT
			)
			(<SET WHO <FIND-FLAG-HERE ,FL-PERSON ,CH-PLAYER>>
				<RETURN .WHO .ACT>
			)
			(<SET WHO <FIND-FLAG-HERE ,FL-ALIVE ,CH-PLAYER>>
				<RETURN .WHO .ACT>
			)
			(T
				<RETURN <> .ACT>
			)
		>
	>
>

<REPLACE-DEFINITION VERB-ALL-TEST
	<ROUTINE VERB-ALL-TEST (O I "AUX" L)
		<SET L <LOC .O>>
		<COND
			(<FSET? .O ,FL-NO-ALL>
				<RFALSE>
			)
			(<EQUAL? ,PRSA ,V?DROP ,V?THROW ,V?THROW-OVER ,V?GIVE>
				<COND
					(<FSET? .O ,FL-WORN>
						<RFALSE>
					)
					(<EQUAL? .L ,WINNER>
						<RTRUE>
					)
					(T
						<RFALSE>
					)
				>
			)
			(<EQUAL? ,PRSA ,V?PUT ,V?PUT-IN>
				<COND
					(<EQUAL? .O .I>
						<RFALSE>
					)
					(<FSET? .O ,FL-WORN>
						<RFALSE>
					)
					(<NOT <IN? .O .I>>
						<RTRUE>
					)
					(T
						<RFALSE>
					)
				>
			)
			(<EQUAL? ,PRSA ,V?TAKE>
				<COND
					(<RT-META-IN? ,WINNER .O>
						<RFALSE>
					)
					(<IN? .O ,WINNER>
						<RFALSE>
					)
					(<AND	<NOT .I>
							<RT-META-IN? .O ,WINNER>
						>
						<RFALSE>
					)
					(<FSET? .O ,FL-WORN>
						<RFALSE>
					)
					(<NOT <FSET? .O ,FL-TAKEABLE>>
						<RFALSE>
					)
					(<AND .I <NOT <EQUAL? .L .I>>>
						<RFALSE>
					)
					(<EQUAL? .L ,HERE>
						<RTRUE>
					)
					(<OR	<FSET? .L ,FL-PERSON>
							<FSET? .L ,FL-SURFACE>
						>
						<RTRUE>
					)
					(<AND <FSET? .L ,FL-CONTAINER>
							<FSET? .L ,FL-OPEN>
						>
						<RTRUE>
					)
					(T
						<RFALSE>
					)
				>
			)
			(<NOT <ZERO? .I>>
				<COND
					(<NOT <EQUAL? .O .I>>
						<RTRUE>
					)
					(T
						<RFALSE>
					)
				>
			)
			(T
				<RTRUE>
			)
		>
	>
>

<REPLACE-DEFINITION NOT-HERE
	<ROUTINE NOT-HERE (OBJ "OPT" (CLOCK <>))
		<COND
			(<ZERO? .CLOCK>
				<SETG CLOCK-WAIT T>
			;	<TELL "[">
				<RT-AUTHOR-ON>
			)
		>
		<TELL The+verb .OBJ "are" "n't ">
		<COND
			(<VISIBLE? .OBJ>
				<TELL "close enough">
				<COND
					(<SPEAKING-VERB?>
						<TELL " to hear you">
					)
				>
			)
			(T
				<TELL "here">
			)
		>
		<TELL ".">
		<THIS-IS-IT .OBJ>
		<COND
			(<ZERO? .CLOCK>
			;	<TELL "]">
				<RT-AUTHOR-OFF>
			)
			(T
				<CRLF>
			)
		>
	>
>

<REPLACE-DEFINITION ASKING-VERB-WORD?
	<ADD-WORD ASK ASKWORD>
	<ADD-WORD ORDER ASKWORD>
	<ADD-WORD TELL ASKWORD>
>

<REPLACE-DEFINITION CAPITAL-NOUN?
	<DEFINE CAPITAL-NOUN? (NAM)
		<EQUAL? .NAM ,W?MERLIN ,W?LOT ,W?ARTHUR ,W?NIMUE ,W?THOMAS ,W?NUDD>
	>
>

<REPLACE-DEFINITION STATUS-LINE
	<DEFINE INIT-STATUS-LINE ("AUX" N W M L)
		<COND
			(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-NONE>
				<WINPOS 0 <+ ,GL-FONT-Y 1> 1>
				<WINSIZE 0 <- <LOWCORE VWRD> ,GL-FONT-Y> <LOWCORE HWRD>>
				<WINPOS 1 1 1>
				<WINSIZE 1 ,GL-FONT-Y <LOWCORE HWRD>>
			)
			(T
				<COND
					(<PICINF ,K-PIC-BANNER-MARGIN ,K-WIN-TBL>
						<SET M <ZGET ,K-WIN-TBL 1>>
					)
					(T
						<SET M <* 3 ,GL-FONT-X>>
					)
				>
				<SET W <- <LOWCORE HWRD> <* .M 2>>>
				<SET L <+ 1 .M>>
				<SET N </ <LOWCORE VWRD> 2>>
				<SET N <+ <- .N <MOD .N ,GL-FONT-Y>> 1>>
				<WINPOS 0 <+ .N ,GL-FONT-Y> .L>
				<WINSIZE 0 <+ <- <LOWCORE VWRD> .N ,GL-FONT-Y> 1> .W>
				<WINPOS 1 .N .L>
				<WINSIZE 1 ,GL-FONT-Y .W>
				<WINPOS 2 1 .L>
				<WINSIZE 2 <- .N 1> .W>
				<WINPOS 5 1 1>
				<WINSIZE 5 <LOWCORE VWRD> .M>
				<WINPOS 6 1 <+ .L .W>>
				<WINSIZE 6 <LOWCORE VWRD> .M>
				<WINPOS 7 1 1>
				<WINSIZE 7 <LOWCORE VWRD> <LOWCORE HWRD>>
			)
		>
		<SCREEN 1>
		<CURSET 1 1>
		<PUTB ,K-DIROUT-TBL 0 !\ >
		<SET N </ <WINGET 1 ,K-W-XSIZE> ,GL-SPACE-WIDTH>>
		<COPYT ,K-DIROUT-TBL <ZREST ,K-DIROUT-TBL 1> <- .N>>
		<HLIGHT ,H-INVERSE>
		<PRINTT ,K-DIROUT-TBL .N>
		<HLIGHT ,H-NORMAL>
		<CURSET 1 1>
		<SCREEN 0>
		<SETG GL-SL-HERE <>>
		<SETG GL-SL-VEH <>>
		<SETG GL-SL-HIDE <>>
		<SETG GL-SL-TIME 0>
		<SETG GL-SL-FORM 0>
		<RTRUE>
	>

	<GLOBAL GL-SL-HERE:OBJECT <>>
	<GLOBAL GL-SL-VEH:OBJECT <>>
	<GLOBAL GL-SL-HIDE:OBJECT <>>
	<GLOBAL GL-SL-TIME 0>
	<GLOBAL GL-SL-FORM 0 <> BYTE>

	<DEFINE UPDATE-STATUS-LINE ("AUX" C N L CW (REF <>))
		<SCREEN 1>
		<HLIGHT ,H-INVERSE>
		<SET L <LOC ,CH-PLAYER>>
		<COND
			(<OR	<NOT <EQUAL? ,HERE ,GL-SL-HERE>>
					<NOT <EQUAL? ,GL-HIDING ,GL-SL-HIDE>>
					<AND
						<IN? .L ,ROOMS>
						,GL-SL-VEH
					>
					<AND
						<NOT <IN? .L ,ROOMS>>
						<NOT <EQUAL? .L ,GL-SL-VEH>>
					>
				>
				<SET REF T>
				<CURSET 1 1>
				<PUTB ,K-DIROUT-TBL 0 !\ >
				<SET N </ <WINGET 1 ,K-W-XSIZE> ,GL-SPACE-WIDTH>>
				<COPYT ,K-DIROUT-TBL <ZREST ,K-DIROUT-TBL 1> <- .N>>
				<PRINTT ,K-DIROUT-TBL .N>
				<DIROUT ,K-D-TBL-ON ,K-DIROUT-TBL>
				<RT-ROOM-NAME-MSG>
				<DIROUT ,K-D-TBL-OFF>
				<COND
					(<AND <G=? <SET C <GETB ,K-DIROUT-TBL 2>> !\a>
							<L=? .C !\z>
						>
						<PUTB ,K-DIROUT-TBL 2 <- .C 32>>
					)
				>
				<CURSET 1 1>
				<PRINTT <ZREST ,K-DIROUT-TBL 2> <ZGET ,K-DIROUT-TBL 0>>
				<COND
					(<IN? .L ,ROOMS>)
					(<EQUAL? .L ,TH-BEHIND-G-STONE ,TH-BEHIND-ROCK ,TH-BEHIND-DOOR>
						<TELL ", behind ">
						<COND
							(<EQUAL? .L ,TH-BEHIND-G-STONE>
								<TELL "gravestone">
							)
							(<EQUAL? .L ,TH-BEHIND-ROCK>
								<TELL "gravestone">
							)
							(T
								<TELL "door">
							)
						>
					)
					(,GL-HIDING
						<TELL ", behind " D ,GL-HIDING>
					)
					(T
						<TELL "," in .L " " D .L>
					)
				>
			)
		>
		<COND
			(<OR	.REF
					<NOT <EQUAL? ,GL-PLAYER-FORM ,GL-SL-FORM>>
				>
				<DIROUT ,K-D-TBL-ON ,K-DIROUT-TBL>
				<TELL "Salamander">
				<DIROUT ,K-D-TBL-OFF>
				<SET N <+ </ <LOWCORE TWID> ,GL-SPACE-WIDTH> 1>>
				<CURSET 1 <- <WINGET 1 ,K-W-XSIZE> <* 34 ,GL-FONT-X>>>
				<PUTB ,K-DIROUT-TBL 0 !\ >
				<COPYT ,K-DIROUT-TBL <ZREST ,K-DIROUT-TBL 1> <- .N>>
				<PRINTT ,K-DIROUT-TBL .N>
				<COND
					(<NOT <EQUAL? ,GL-PLAYER-FORM ,K-FORM-ARTHUR>>
						<CURSET 1 <- <WINGET 1 ,K-W-XSIZE> <* 34 ,GL-FONT-X>>>
						<TELL Form>
					)
				>
			)
		>
		<COND
			(<OR	.REF
					<NOT <EQUAL? </ ,GL-SL-TIME 180> </ ,GL-MOVES 180>>>
				>
				<SET REF T>
				<DIROUT ,K-D-TBL-ON ,K-DIROUT-TBL>
				<TELL "Christmas Day, Compline  ">
				<DIROUT ,K-D-TBL-OFF>
				<SET N <LOWCORE TWID>>
				<CURSET 1 <- <WINGET 1 ,K-W-XSIZE> .N>>
				<PUTB ,K-DIROUT-TBL 0 !\ >
				<SET N </ .N ,GL-SPACE-WIDTH>>
				<COPYT ,K-DIROUT-TBL <ZREST ,K-DIROUT-TBL 1> <- .N>>
				<PRINTT ,K-DIROUT-TBL .N>
				<DIROUT ,K-D-TBL-ON ,K-DIROUT-TBL>
				<SET N </ ,GL-MOVES 1440>>
				<COND
					(<EQUAL? .N 0>
						<TELL "St Anne's Day">
					)
					(<EQUAL? .N 1>
						<TELL "St John's Day">
					)
					(<EQUAL? .N 2>
						<TELL "Christmas Eve">
					)
					(T
						<TELL "Christmas Day">
					)
				>
				<TELL ", ">
				<RT-HOUR-NAME-MSG ,GL-MOVES>
				<TELL " ">
				<DIROUT ,K-D-TBL-OFF>
				<CURSET 1 <- <WINGET 1 ,K-W-XSIZE> <LOWCORE TWID>>>
				<PRINTT <ZREST ,K-DIROUT-TBL 2> <ZGET ,K-DIROUT-TBL 0>>
			)
		>
		<HLIGHT ,H-NORMAL>
		<CURSET 1 1>
		<SCREEN 0>
		<SETG GL-SL-HERE ,HERE>
		<SETG GL-SL-HIDE ,GL-HIDING>
		<COND
			(<NOT <IN? .L ,ROOMS>>
				<SETG GL-SL-VEH .L>
			)
			(T
				<SETG GL-SL-VEH <>>
			)
		>
		<SETG GL-SL-FORM ,GL-PLAYER-FORM>
		<SETG GL-SL-TIME ,GL-MOVES>
		<RTRUE>
	>
	<ROUTINE RT-HOUR-NAME-MSG (N)
		<SET N <MOD .N 1440>>
		<COND
			(<L? .N 180>
				<TELL "Matins">
			)
			(<L? .N 360>
				<TELL "Lauds">
			)
			(<L? .N 540>
				<TELL "Prime">
			)
			(<L? .N 720>
				<TELL "Terce">
			)
			(<L? .N 900>
				<TELL "Sext">
			)
			(<L? .N 1080>
				<TELL "None">
			)
			(<L? .N 1260>
				<TELL "Vespers">
			)
			(T
				<TELL "Compline">
			)
		>
	>
>

<REPLACE-DEFINITION READ-INPUT
	<GLOBAL GL-MOUSE-X:NUMBER 0>
	<GLOBAL GL-MOUSE-Y:NUMBER 0>
	<GLOBAL GL-TL-Y:NUMBER 0>
	<GLOBAL GL-TL-X:NUMBER 0>
	<GLOBAL GL-BR-Y:NUMBER 0>
	<GLOBAL GL-BR-X:NUMBER 0>

	<DEFINE WITHIN? (Y1 X1 Y2 X2)
		<COND
			(<AND <NOT <L? ,GL-MOUSE-X .X1>>
					<NOT <G? ,GL-MOUSE-X .X2>>
					<NOT <L? ,GL-MOUSE-Y .Y1>>
					<NOT <G? ,GL-MOUSE-Y .Y2>>
				>
				<RTRUE>
			)
		>
	>
	<ROUTINE MOUSE-INPUT? ("OPT" W X1 Y1 X2 Y2 "AUX" N)
		<SETG GL-MOUSE-X <LOWCORE MSLOCX>>
		<SETG GL-MOUSE-Y <LOWCORE MSLOCY>>
		<COND
			(<NOT <ASSIGNED? W>>
				<RTRUE>
			)
			(<NOT <ASSIGNED? X1>>
				<COND
					(<EQUAL? .W -1>
						<RTRUE>
					)
					(T
						<SETG GL-TL-X <WINGET .W ,K-W-XPOS>>
						<SETG GL-TL-Y <WINGET .W ,K-W-YPOS>>
						<SETG GL-BR-X <- <+ ,GL-TL-X <WINGET .W ,K-W-XSIZE>> 1>>
						<SETG GL-BR-Y <- <+ ,GL-TL-Y <WINGET .W ,K-W-YSIZE>> 1>>
						<COND
							(<WITHIN? ,GL-TL-Y ,GL-TL-X ,GL-BR-Y ,GL-BR-X>
								<SETG GL-MOUSE-X <+ <- ,GL-MOUSE-X ,GL-TL-X> 1>>
								<SETG GL-MOUSE-Y <+ <- ,GL-MOUSE-Y ,GL-TL-Y> 1>>
								<RTRUE>
							)
						>
					)
				>
			)
			(T
				<COND
					(<NOT <EQUAL? .W -1>>
						<SET N <- <WINGET .W ,K-W-XPOS> 1>>
						<SETG GL-TL-X <+ ,GL-TL-X .N>>
						<SETG GL-BR-X <+ ,GL-BR-X .N>>
						<SET N <- <WINGET .W ,K-W-YPOS> 1>>
						<SETG GL-TL-Y <+ ,GL-TL-Y .N>>
						<SETG GL-BR-Y <+ ,GL-BR-Y .N>>
					)
				>
				<COND
					(<WITHIN? ,GL-TL-Y ,GL-TL-X ,GL-BR-Y ,GL-BR-X>
						<SETG GL-MOUSE-X <+ <- ,GL-MOUSE-X ,GL-TL-X> 1>>
						<SETG GL-MOUSE-Y <+ <- ,GL-MOUSE-Y ,GL-TL-Y> 1>>
						<RTRUE>
					)
				>
			)
		>
	>
	<CONSTANT TANGENT-VALUE 44>
	<ROUTINE MAC-II-CLICK (CY CX "AUX" Y X RW RH)
		<PICINF ,K-ROSE-BLANK ,K-WIN-TBL>
		<SET RH <ZGET ,K-WIN-TBL 0>>
		<SET RW <ZGET ,K-WIN-TBL 1>>
		<COND
			(<AND <G? ,GL-MOUSE-X .CX>
					<L? ,GL-MOUSE-Y .CY>
				> ;"ne quadrant"
				<SET X <- ,GL-MOUSE-X .CX>>
				<SET Y </ <* <- .CY ,GL-MOUSE-Y> .RW> .RH>>
				<COND
					(<G? <* .X ,TANGENT-VALUE> <* .Y 100>>
						<RETURN ,P?EAST>
					)
					(<G? <* .Y ,TANGENT-VALUE> <* .X 100>>
						<RETURN ,P?NORTH>
					)
					(T
						<RETURN ,P?NE>
					)
				>
			)
			(<G? ,GL-MOUSE-X .CX> ;"se quadrant"
				<SET X <- ,GL-MOUSE-X .CX>>
				<SET Y </ <* <- ,GL-MOUSE-Y .CY> .RW> .RH>>
				<COND
					(<G? <* .X ,TANGENT-VALUE> <* .Y 100>>
						<RETURN ,P?EAST>
					)
					(<G? <* .Y ,TANGENT-VALUE> <* .X 100>>
						<RETURN ,P?SOUTH>
					)
					(T
						<RETURN ,P?SE>
					)
				>
			)
			(<G? ,GL-MOUSE-Y .CY> ;"sw quadrant"
				<SET X <- .CX ,GL-MOUSE-X>>
				<SET Y </ <* <- ,GL-MOUSE-Y .CY> .RW> .RH>>
				<COND
					(<G? <* .X ,TANGENT-VALUE> <* .Y 100>>
						<RETURN ,P?WEST>
					)
					(<G? <* .Y ,TANGENT-VALUE> <* .X 100>>
						<RETURN ,P?SOUTH>
					)
					(T
						<RETURN ,P?SW>
					)
				>
			)
			(T ;"nw quadrant"
				<SET X <- .CX ,GL-MOUSE-X>>
				<SET Y </ <* <- .CY ,GL-MOUSE-Y> .RW> .RH>>
				<COND
					(<G? <* .X ,TANGENT-VALUE> <* .Y 100>>
						<RETURN ,P?WEST>
					)
					(<G? <* .Y ,TANGENT-VALUE> <* .X 100>>
						<RETURN ,P?NORTH>
					)
					(T
						<RETURN ,P?NW>
					)
				>
			)
		>
	>
	<ROUTINE RT-MAP-CLICK (C "AUX" CY CX X Y)
		<PICINF ,K-ROSE-DOWN-OFF ,K-WIN-TBL>
		<SETG GL-TL-Y <+ ,GL-ROSE-Y <ZGET ,K-WIN-TBL 0>>>
		<SETG GL-TL-X <+ ,GL-ROSE-X <ZGET ,K-WIN-TBL 1>>>
		<PICINF ,K-ROSE-UP-DN-BLANK ,K-WIN-TBL>
		<SETG GL-BR-Y <+ ,GL-TL-Y <ZGET ,K-WIN-TBL 0>>>
		<SETG GL-BR-X <+ ,GL-TL-X <ZGET ,K-WIN-TBL 1>>>
		<COND
			(<WITHIN? ,GL-TL-Y ,GL-TL-X ,GL-BR-Y ,GL-BR-X>
				<RETURN ,P?DOWN>
			)
		>
		<PICINF ,K-ROSE-UP-OFF ,K-WIN-TBL>
		<SETG GL-TL-Y <+ ,GL-ROSE-Y <ZGET ,K-WIN-TBL 0>>>
		<SETG GL-TL-X <+ ,GL-ROSE-X <ZGET ,K-WIN-TBL 1>>>
		<PICINF ,K-ROSE-UP-DN-BLANK ,K-WIN-TBL>
		<SETG GL-BR-Y <+ ,GL-TL-Y <ZGET ,K-WIN-TBL 0>>>
		<SETG GL-BR-X <+ ,GL-TL-X <ZGET ,K-WIN-TBL 1>>>
		<COND
			(<WITHIN? ,GL-TL-Y ,GL-TL-X ,GL-BR-Y ,GL-BR-X>
				<RETURN ,P?UP>
			)
		>
		<PICINF ,K-ROSE-OFF ,K-WIN-TBL>
		<SETG GL-TL-Y <+ ,GL-ROSE-Y <ZGET ,K-WIN-TBL 0>>>
		<SETG GL-TL-X <+ ,GL-ROSE-X <ZGET ,K-WIN-TBL 1>>>
		<PICINF ,K-ROSE-BLANK ,K-WIN-TBL>
		<SETG GL-BR-Y <+ ,GL-TL-Y <ZGET ,K-WIN-TBL 0>>>
		<SETG GL-BR-X <+ ,GL-TL-X <ZGET ,K-WIN-TBL 1>>>
		<SET CY <+ ,GL-TL-Y </ <ZGET ,K-WIN-TBL 0> 2>>>
		<SET CX <+ ,GL-TL-X </ <ZGET ,K-WIN-TBL 1> 2>>>
		<COND
			(<WITHIN? ,GL-TL-Y ,GL-TL-X ,GL-BR-Y ,GL-BR-X>
				<COND
				;	(<AND <EQUAL? <LOWCORE INTID> ,MACINTOSH>
							<NOT <MAC-II?>>
						>
						<RETURN <MAC-CLICK .CY .CX>>
					)
					(<OR	<EQUAL? <LOWCORE INTID> ,IBM ,AMIGA ,MACINTOSH ,DEBUGGING-ZIP>
							<APPLE?>
						>
						<RETURN <MAC-II-CLICK .CY .CX>>
					)
					(T
						<SOUND ,S-BEEP>
						<TELL
"[Sorry, clicking on the compass rose is not yet implemented on this machine.]|"
						>
						<RFALSE>
					)
				>
			)
		>
		<SET CY <RT-MAP-Y <RT-GET-MAP-Y ,GL-WIN-X>>>
		<SET CX <RT-MAP-X <RT-GET-MAP-X ,GL-WIN-X>>>
		<PICINF ,K-MAP-NOT-HERE-ROOM ,K-WIN-TBL>
		<SETG GL-TL-Y <- .CY <ZGET ,K-WIN-TBL 0>>>
		<SETG GL-TL-X <- .CX <ZGET ,K-WIN-TBL 1>>>
		<SETG GL-BR-Y <- <+ .CY <* 2 ,GL-MAP-GRID-Y>> 1>>
		<SETG GL-BR-X <- <+ .CX <* 2 ,GL-MAP-GRID-X>> 1>>
		<COND
			(<WITHIN? ,GL-TL-Y ,GL-TL-X ,GL-BR-Y ,GL-BR-X>
				<SETG GL-BR-Y <- <+ ,GL-TL-Y ,GL-MAP-GRID-Y> 1>>
				<SETG GL-BR-X <- <+ ,GL-TL-X ,GL-MAP-GRID-X> 1>>
				<COND
					(<WITHIN? ,GL-TL-Y ,GL-TL-X ,GL-BR-Y ,GL-BR-X>
						<RETURN ,P?NW>
					)
				>
				<SETG GL-TL-X <+ ,GL-TL-X ,GL-MAP-GRID-X>>
				<SETG GL-BR-Y <- <+ ,GL-TL-Y ,GL-MAP-GRID-Y> 1>>
				<SETG GL-BR-X <- <+ ,GL-TL-X <ZGET ,K-WIN-TBL 1>> 1>>
				<COND
					(<WITHIN? ,GL-TL-Y ,GL-TL-X ,GL-BR-Y ,GL-BR-X>
						<COND
							(<RT-FIND-ROOM ,P?NORTH <LOC ,CH-PLAYER>>
								<RETURN ,P?NORTH>
							)
							(T
								<RETURN ,P?UP>
							)
						>
					)
				>
				<SETG GL-TL-X <+ ,GL-TL-X <ZGET ,K-WIN-TBL 1>>>
				<SETG GL-BR-Y <- <+ ,GL-TL-Y ,GL-MAP-GRID-Y> 1>>
				<SETG GL-BR-X <- <+ ,GL-TL-X ,GL-MAP-GRID-X> 1>>
				<COND
					(<WITHIN? ,GL-TL-Y ,GL-TL-X ,GL-BR-Y ,GL-BR-X>
						<RETURN ,P?NE>
					)
				>
				<SETG GL-TL-Y <+ ,GL-TL-Y ,GL-MAP-GRID-Y>>
				<SETG GL-TL-X <- .CX <ZGET ,K-WIN-TBL 1>>>
				<SETG GL-BR-Y <- <+ ,GL-TL-Y <ZGET ,K-WIN-TBL 0>> 1>>
				<SETG GL-BR-X <- <+ ,GL-TL-X ,GL-MAP-GRID-X> 1>>
				<COND
					(<WITHIN? ,GL-TL-Y ,GL-TL-X ,GL-BR-Y ,GL-BR-X>
						<RETURN ,P?WEST>
					)
				>
				<SETG GL-TL-X <+ ,GL-TL-X ,GL-MAP-GRID-X <ZGET ,K-WIN-TBL 1>>>
				<SETG GL-BR-Y <- <+ ,GL-TL-Y <ZGET ,K-WIN-TBL 0>> 1>>
				<SETG GL-BR-X <- <+ ,GL-TL-X ,GL-MAP-GRID-X> 1>>
				<COND
					(<WITHIN? ,GL-TL-Y ,GL-TL-X ,GL-BR-Y ,GL-BR-X>
						<RETURN ,P?EAST>
					)
				>
				<SETG GL-TL-Y <+ ,GL-TL-Y <ZGET ,K-WIN-TBL 0>>>
				<SETG GL-TL-X <- .CX <ZGET ,K-WIN-TBL 1>>>
				<SETG GL-BR-Y <- <+ ,GL-TL-Y ,GL-MAP-GRID-Y> 1>>
				<SETG GL-BR-X <- <+ ,GL-TL-X ,GL-MAP-GRID-X> 1>>
				<COND
					(<WITHIN? ,GL-TL-Y ,GL-TL-X ,GL-BR-Y ,GL-BR-X>
						<RETURN ,P?SW>
					)
				>
				<SETG GL-TL-X <+ ,GL-TL-X ,GL-MAP-GRID-X>>
				<SETG GL-BR-Y <- <+ ,GL-TL-Y ,GL-MAP-GRID-Y> 1>>
				<SETG GL-BR-X <- <+ ,GL-TL-X <ZGET ,K-WIN-TBL 1>> 1>>
				<COND
					(<WITHIN? ,GL-TL-Y ,GL-TL-X ,GL-BR-Y ,GL-BR-X>
						<COND
							(<RT-FIND-ROOM ,P?SOUTH <LOC ,CH-PLAYER>>
								<RETURN ,P?SOUTH>
							)
							(T
								<RETURN ,P?DOWN>
							)
						>
					)
				>
				<SETG GL-TL-X <+ ,GL-TL-X <ZGET ,K-WIN-TBL 0>>>
				<SETG GL-BR-Y <- <+ ,GL-TL-Y ,GL-MAP-GRID-Y> 1>>
				<SETG GL-BR-X <- <+ ,GL-TL-X ,GL-MAP-GRID-X> 1>>
				<COND
					(<WITHIN? ,GL-TL-Y ,GL-TL-X ,GL-BR-Y ,GL-BR-X>
						<RETURN ,P?SE>
					)
				>
			)
		>
	>
	<ROUTINE DIR-TO-STRING (DIR)
		<COND
			(<EQUAL? .DIR ,P?UP>
				<RETURN "up">
			)
			(<EQUAL? .DIR ,P?DOWN>
				<RETURN "down">
			)
			(<EQUAL? .DIR ,P?NORTH>
				<RETURN "north">
			)
			(<EQUAL? .DIR ,P?NE>
				<RETURN "northeast">
			)
			(<EQUAL? .DIR ,P?EAST>
				<RETURN "east">
			)
			(<EQUAL? .DIR ,P?SE>
				<RETURN "southeast">
			)
			(<EQUAL? .DIR ,P?SOUTH>
				<RETURN "south">
			)
			(<EQUAL? .DIR ,P?SW>
				<RETURN "southwest">
			)
			(<EQUAL? .DIR ,P?WEST>
				<RETURN "west">
			)
			(<EQUAL? .DIR ,P?NW>
				<RETURN "northwest">
			)
		>
	>
	<ROUTINE ADD-TO-INPUT (FDEF TRM M "AUX" N TMP)
		<SET N <GETB ,P-INBUF 1>> ;"number chars already"
		<COND
			(<EQUAL? <GETB .FDEF .M> 13 10>
				<SET TRM 13> ;"this def is a terminator"
				<SET M <- .M 1>>
			)
		>
		<SET FDEF <REST .FDEF>>
		<SET TMP <REST ,P-INBUF <+ .N 2>>>
		<COND
			(<G=? <+ .M .N> <GETB ,P-INBUF 0>> ;"overflowed input buffer"
				<SOUND 1>
				<SET M <- <GETB ,P-INBUF 0> .N 1>>
			)
		>
		<COPYT .FDEF .TMP .M>
		<PUTB .TMP .M 0>
		<WINATTR -3 ,A-SCRIPT ,O-CLEAR>
		<PRINTT .FDEF .M>
		<PUTB ,P-INBUF 1 <+ .N .M>>
		<COND
			(<EQUAL? .TRM 13 10>
				<CRLF>
			)
		>
		<WINATTR -3 ,A-SCRIPT ,O-SET>
		.TRM
	>


	<DEFINE READ-INPUT ("AUX" C DIR)
		<PUTB ,P-INBUF 1 0>
		<TELL ">">
		<REPEAT ()
			<SET C <ZREAD ,P-INBUF ,P-LEXV>>
			<COND
				(<EQUAL? .C ,CR ,LF>
					<RETURN>
				)
				(<EQUAL? .C ,F1 ,F2 ,F3 ,F4 ,F5 ,F6>
					<RT-HOT-KEY .C>
				)
				(<EQUAL? .C ,CLICK1 ,CLICK2>
					<COND
						(<AND <EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>
								<MOUSE-INPUT? 2>
								<SET DIR <RT-MAP-CLICK .C>>
								<RT-FIND-ROOM .DIR <LOC ,CH-PLAYER>>
							>
							<SET C ,CR>
							<DIROUT ,D-TABLE-ON ,O-INBUF>
							<TELL <DIR-TO-STRING .DIR>>
							<DIROUT ,D-TABLE-OFF>
							<PUTB ,O-INBUF 0 ,INBUF-LENGTH>
							<ADD-TO-INPUT <REST ,O-INBUF 1> ,CR <GETB ,O-INBUF 1>>
							<RETURN>
						)
						(T
							<SOUND ,S-BEEP>
						)
					>
				)
			>
		>
		<RT-SCRIPT-INBUF>
		<COND
			(<G? ,GL-AUTHOR-SIZE 0>
				<RT-AUTHOR-CLEAR>
			)
		>
		<LEX ,P-INBUF ,P-LEXV>
		<RETURN .C>
	>
>

<REPLACE-DEFINITION YES?
	<CONSTANT YES-INBUF <ITABLE 19 (BYTE LENGTH) 0>>
	<CONSTANT YES-LEXV  <ITABLE 3 (LEXV) 0 0>>

	<DEFINE YES? ("OPT" (NO-Q <>) "AUX" WORD VAL)
		<COND
			(<NOT .NO-Q>
				<TELL "?">
			)
		>
		<REPEAT ()
			<TELL "|Please answer YES or NO >">
			<PUTB ,YES-INBUF 1 0>
			<REPEAT ()
				<SET VAL <ZREAD ,YES-INBUF ,YES-LEXV>>
				<COND
					(<EQUAL? .VAL 10 13>
						<RETURN>
					)
					(T
						<RT-HOT-KEY .VAL ,YES-INBUF>
					)
				>
			>
			<VERSION?
				(YZIP
					<RT-SCRIPT-INBUF ,YES-INBUF>
				)
			>
			<COND
				(<AND <NOT <0? <GETB ,YES-LEXV ,P-LEXWORDS>>>
						<SET WORD <ZGET ,YES-LEXV ,P-LEXSTART>>
					>
					<COND
						(<COMPARE-WORD-TYPES
								<WORD-CLASSIFICATION-NUMBER .WORD>
								<GET-CLASSIFICATION VERB>
							>
							<SET VAL <WORD-VERB-STUFF .WORD>>
						)
						(T
							<SET VAL <>>
						)
					>
					<COND
						(<OR	<EQUAL? .VAL ,ACT?YES>
								<EQUAL? .WORD ,W?Y>
							>
							<SET VAL T>
							<RETURN>
						)
						(<OR	<EQUAL? .VAL ,ACT?NO>
								<EQUAL? .WORD ,W?N>
							>
							<SET VAL <>>
							<RETURN>
						)
						(<EQUAL? .VAL ,ACT?RESTART>
							<V-RESTART>
						)
						(<EQUAL? .VAL ,ACT?RESTORE>
							<V-RESTORE>
						)
						(<EQUAL? .VAL ,ACT?QUIT>
							<V-QUIT>
						)
					>
				)
			>
		;	<TELL "[Please type YES or NO.]">
		>
		.VAL
	>
>

<REPLACE-DEFINITION TELL-TOO-DARK
	<DEFINE TELL-TOO-DARK ()
		<TELL ,K-TOO-DARK-MSG>
		<SETG CLOCK-WAIT T>
		<RFATAL>
	>
>

<REPLACE-DEFINITION UNKNOWN-WORD
	<DEFINE UNKNOWN-WORD (RLEXV "AUX" X)
		<COND
			(<SET X <NUMBER? .RLEXV>>
				.X
			)
			(T
				<RT-AUTHOR-ON>
				<TELL "You don't need to use the word \"">
				<ZPUT ,OOPS-TABLE ,O-PTR </ <- .RLEXV ,P-LEXV> 2>>
				<WORD-PRINT .RLEXV>
				<TELL ".\"">
				<RT-AUTHOR-OFF>
				<THROW ,PARSER-RESULT-DEAD ,PARSE-SENTENCE-ACTIVATION>
			)
		>
	>
>

<REPLACE-DEFINITION SEE-VERB?
	<ROUTINE SEE-VERB? ()
		<EQUAL? ,PRSA
,V?EXAMINE ,V?LOOK ,V?LOOK-BEHIND ,V?LOOK-IN ,V?LOOK-ON ,V?LOOK-UP
,V?LOOK-DOWN ,V?LOOK-THRU ,V?LOOK-UNDER ,V?READ
		>
	>
>

<REPLACE-DEFINITION BUZZER-WORD?
	<IFN-P-BE-VERB!-
		<CONSTANT P-W-WORDS
			<TABLE (PURE LENGTH)
				<VOC "WHAT"> <IFN-P-APOSTROPHE-BREAKS-WORDS!- <VOC "WHAT\'S">>
				<VOC "WHEN"> <IFN-P-APOSTROPHE-BREAKS-WORDS!- <VOC "WHEN\'S">>
				<VOC "WHERE"> <IFN-P-APOSTROPHE-BREAKS-WORDS!- <VOC "WHERE\'S">>
				<VOC "WHO"> <IFN-P-APOSTROPHE-BREAKS-WORDS!- <VOC "WHO\'S">>
				<VOC "WHY"> <IFN-P-APOSTROPHE-BREAKS-WORDS!- <VOC "WHY\'S">>
				<VOC "HOW"> <IFN-P-APOSTROPHE-BREAKS-WORDS!- <VOC "HOW\'S">>
				<VOC "WOULD"> <IFN-P-APOSTROPHE-BREAKS-WORDS!- <VOC "WOULDN\'T">>
				<VOC "COULD"> <IFN-P-APOSTROPHE-BREAKS-WORDS!- <VOC "COULDN\'T">>
				<VOC "SHOULD"> <IFN-P-APOSTROPHE-BREAKS-WORDS!- <VOC "SHOULDN\'T">>
			>
		>
	>

	<IFN-P-BE-VERB!-
		<IFFLAG
			(P-APOSTROPHE-BREAKS-WORDS
				<CONSTANT P-Q-WORDS1
					<TABLE (PURE LENGTH)
						<IFN-P-BE-VERB!- <VOC "AREN">>
						<IFN-P-BE-VERB!- <VOC "CAN">>
						<IFN-P-BE-VERB!- <VOC "COULDN">>
						<IFN-P-BE-VERB!- <VOC "DIDN">>
						<IFN-P-BE-VERB!- <VOC "DOESN">>
						<IFN-P-BE-VERB!- <VOC "DON">>
						<VOC "HASN">
						<VOC "HAVEN">
						<IFN-P-BE-VERB!- <VOC "HE">>
						<VOC "I">
						<VOC "I">
						<IFN-P-BE-VERB!- <VOC "I">>
						<VOC "I">
						<IFN-P-BE-VERB!- <VOC "ISN">>
						<IFN-P-BE-VERB!- <VOC "IT">>
						<VOC "LET">
					;	<VOC "SHAN">
						<IFN-P-BE-VERB!- <VOC "SHE">>
						<IFN-P-BE-VERB!- <VOC "SHOULDN">>
						<IFN-P-BE-VERB!- <VOC "THAT">>
						<IFN-P-BE-VERB!- <VOC "THEY">>
						<IFN-P-BE-VERB!- <VOC "WASN">>
						<IFN-P-BE-VERB!- <VOC "WE">>
						<VOC "WE">
						<IFN-P-BE-VERB!- <VOC "WEREN">>
						<IFN-P-BE-VERB!- <VOC "WON">>
						<IFN-P-BE-VERB!- <VOC "WOULDN">>
						<IFN-P-BE-VERB!- <VOC "YOU">>
					>
				>

				<CONSTANT P-Q-WORDS2
					<TABLE (PURE LENGTH)
						<IFN-P-BE-VERB!- <VOC "T">>
						<IFN-P-BE-VERB!- <VOC "T">>
						<IFN-P-BE-VERB!- <VOC "T">>
						<IFN-P-BE-VERB!- <VOC "T">>
						<IFN-P-BE-VERB!- <VOC "T">>
						<IFN-P-BE-VERB!- <VOC "T">>
						<VOC "T">
						<VOC "T">
						<IFN-P-BE-VERB!- <VOC "S">>
						<VOC "D">
						<VOC "LL">
						<IFN-P-BE-VERB!- <VOC "M">>
						<VOC "VE">
						<IFN-P-BE-VERB!- <VOC "T">>
						<IFN-P-BE-VERB!- <VOC "S">>
						<VOC "S">
					;	<VOC "T">
						<IFN-P-BE-VERB!- <VOC "S">>
						<IFN-P-BE-VERB!- <VOC "T">>
						<IFN-P-BE-VERB!- <VOC "S">>
						<IFN-P-BE-VERB!- <VOC "RE">>
						<IFN-P-BE-VERB!- <VOC "T">>
						<IFN-P-BE-VERB!- <VOC "RE">>
						<VOC "LL">
						<IFN-P-BE-VERB!- <VOC "T">>
						<IFN-P-BE-VERB!- <VOC "T">>
						<IFN-P-BE-VERB!- <VOC "T">>
						<IFN-P-BE-VERB!- <VOC "RE">>
					>
				>
			)
			(T
				<CONSTANT P-Q-WORDS1
					<TABLE (PURE LENGTH)
						<IFN-P-BE-VERB!- <VOC "AREN\'T">>
						<IFN-P-BE-VERB!- <VOC "CAN\'T">>
						<IFN-P-BE-VERB!- <VOC "COULDN\'T">>
						<IFN-P-BE-VERB!- <VOC "DIDN\'T">>
						<IFN-P-BE-VERB!- <VOC "DOESN\'T">>
						<IFN-P-BE-VERB!- <VOC "DON\'T">>
						<VOC "HASN\'T">
						<VOC "HAVEN\'T">
						<IFN-P-BE-VERB!- <VOC "HE\'S">>
						<VOC "I\'D">
						<VOC "I\'LL">
						<IFN-P-BE-VERB!- <VOC "I\'M">>
						<VOC "I\'VE">
						<IFN-P-BE-VERB!- <VOC "ISN\'T">>
						<IFN-P-BE-VERB!- <VOC "IT\'S">>
						<VOC "LET\'S">
					;	<VOC "SHAN\'T">
						<IFN-P-BE-VERB!- <VOC "SHE\'S">>
						<IFN-P-BE-VERB!- <VOC "SHOULDN\'T">>
						<IFN-P-BE-VERB!- <VOC "THAT\'S">>
						<IFN-P-BE-VERB!- <VOC "THEY\'RE">>
						<IFN-P-BE-VERB!- <VOC "WASN\'T">>
						<IFN-P-BE-VERB!- <VOC "WE\'RE">>
						<VOC "WE\'LL">
						<IFN-P-BE-VERB!- <VOC "WEREN\'T">>
						<IFN-P-BE-VERB!- <VOC "WON\'T">>
						<IFN-P-BE-VERB!- <VOC "WOULDN\'T">>
						<IFN-P-BE-VERB!- <VOC "YOU\'RE">>
					>
				>
			)
		>

		<GLOBAL QUESTION-WORD-COUNT:NUMBER 2>
		<CONSTANT P-Q-WORDS
			<TABLE (PURE LENGTH)
				<IFN-P-BE-VERB!- <VOC "AM">>
			;	<VOC "ANY">
				<IFN-P-BE-VERB!- <VOC "ARE">>
				<IFN-P-BE-VERB!- <VOC "CAN">>
				<IFN-P-BE-VERB!- <VOC "COULD">>
				<IFN-P-BE-VERB!- <VOC "DID">>
				<IFN-P-BE-VERB!- <VOC "DO">>
				<VOC "HAS">
				<VOC "HAVE">
				<IFN-P-BE-VERB!- <VOC "IS">>
				<VOC "LIKE">
			;	<IFN-P-BE-VERB!- <VOC "MAY">>
			;	<IFN-P-BE-VERB!- <VOC "SHALL">>
				<IFN-P-BE-VERB!- <VOC "SHOULD">>
				<VOC "WANT">
				<IFN-P-BE-VERB!- <VOC "WAS">>
				<IFN-P-BE-VERB!- <VOC "WERE">>
			;	<VOC "WHICH">
				<IFN-P-BE-VERB!- <VOC "WILL">>
				<IFN-P-BE-VERB!- <VOC "WOULD">>
			>
		>
	>

	<CONSTANT P-N-WORDS
		<TABLE (PURE LENGTH)
			<VOC "ZERO"> <VOC "EIGHT"> <VOC "NINE"> <VOC "TEN"> <VOC "ELEVEN">
			<VOC "TWELVE"> <VOC "THIRTEEN"> <VOC "FOURTEEN"> <VOC "FIFTEEN">
			<VOC "SIXTEEN"> <VOC "SEVENTEEN"> <VOC "EIGHTEEN"> <VOC "NINETEEN">
			<VOC "TWENTY"> <VOC "THIRTY"> <VOC "FORTY"> <VOC "FIFTY">
			<VOC "SIXTY"> <VOC "SEVENTY"> <VOC "EIGHTY"> <VOC "NINETY">
			<VOC "HUNDRED"> <VOC "THOUSAND"> <VOC "MILLION"> <VOC "BILLION">
		>
	>

	<CONSTANT P-C-WORDS
		<TABLE (PURE LENGTH)
			<VOC "ASS"> <VOC "ASSHOLE"> <VOC "BASTARD"> <VOC "BITCH">
			<VOC "COCK"> <VOC "COCKSUCKER"> <VOC "CRAP"> <VOC "CUNT">
			;<VOC "CURSE"> <VOC "CUSS"> <VOC "DAMN"> <VOC "DAMNED"> <VOC "FUCK">
			<VOC "FUCKED"> <VOC "FUCKER"> <VOC "FUCKING"> <VOC "GODDAMN">
			<VOC "GODDAMNED"> <VOC "HELL"> <VOC "PISS"> <VOC "SCREW">
			<VOC "SHIT"> <VOC "SHITHEAD"> ;<VOC "SUCK"> <VOC "SUCKS">
		>
	>

	<DEFINE BUZZER-WORD? (WD PTR "AUX" N)
		<COND
			(<EQUAL? .WD ,W?\(SOMETHI>
				<RT-AUTHOR-ON>
				<TELL "Type a real word instead of" ,P-SOMETHING>
				<RT-AUTHOR-OFF>
				<RTRUE>
			)
		>
		<IFN-P-BE-VERB!-
			<COND
				(<INTBL? .WD <ZREST ,P-W-WORDS 2> <ZGET ,P-W-WORDS 0>>
					<W-WORD-REPLY .WD>
					<RTRUE>
				)
			>
			<COND
				(<OR	<INTBL? .WD <ZREST ,P-Q-WORDS 2> <ZGET ,P-Q-WORDS 0>>
						<IFFLAG
							(P-APOSTROPHE-BREAKS-WORDS
								<AND
									<SET N
										<INTBL?
											.WD
											<ZREST ,P-Q-WORDS1 2>
											<ZGET ,P-Q-WORDS1 0>
										>
									>
									<EQUAL?
										<ZGET .PTR ,P-LEXELEN>
										,W?APOSTROPHE
									>
									<EQUAL?
										<ZGET ,P-Q-WORDS2 <- .N ,P-Q-WORDS1>>
										<ZGET .PTR <* 2 ,P-LEXELEN>>
									>
								>
							)
							(T
								<INTBL? .WD <ZREST ,P-Q-WORDS1 2> <ZGET ,P-Q-WORDS1 0>>
							)
						>
					>
					<RT-AUTHOR-ON>
					<TELL "Please use commands">
					<SETG QUESTION-WORD-COUNT <+ 1 ,QUESTION-WORD-COUNT>>
					<COND
						(<ZERO? <MOD ,QUESTION-WORD-COUNT 4>>
							<TELL
" to tell the computer what you want to do in the story. Here are some
commands:" CR
"ANSWER \"FOO\"" CR
"LOOK UNDER THE RUG" CR
"JESTER, GIVE ME THE KEY" CR
"Now you can try again"
							>
						)
						(T
							<TELL ", not statements or questions">
						)
					>
					<TELL ".">
					<RT-AUTHOR-OFF>
					<RTRUE>
				)
			>
		>
		<COND
			(<INTBL? .WD <ZREST ,P-N-WORDS 2> <ZGET ,P-N-WORDS 0>>
				<RT-AUTHOR-MSG "Use numerals for numbers, for example \"10.\"">
			)
			(<INTBL? .WD <ZREST ,P-C-WORDS 2> <ZGET ,P-C-WORDS 0>>
				<SETG P-CAN-UNDO <ISAVE>>
				<COND
					(<EQUAL? ,P-CAN-UNDO 2>
						<SETG P-CONT -1>
						<V-$REFRESH>
						<RFALSE>
					)
					(T
						<RT-AUTHOR-ON>
						<TELL <RT-PICK-ONE ,K-OFFENDED-TBL>>
						<RT-AUTHOR-OFF>
						<RT-SCORE-MSG -1 0 0 0>
					)
				>
			)
		>
	>

	<ROUTINE RT-PICK-ONE (TBL)
		<ZGET .TBL <RANDOM <GET .TBL 0>>>
	>

	<CONSTANT K-OFFENDED-TBL
		<TABLE (PURE LENGTH)
			"Does your mother know you use words like that?"
			"Now, now. Let's not get vulgar."
			"Are we going to have to scrape your mouth out with pumice?"
			"Such language is frowned upon in chivalrous circles."
			"Obscenity is the first refuge of a dirty mind."
		>
	>

	<IFN-P-BE-VERB!-
		<DEFINE W-WORD-REPLY (WD)
			<COND
			; "Added W? to WHO -- DEB -- 5/6/88"
				(<OR	<NOT <EQUAL? .WD ,W?WHAT ,W?WHO>>
						<NOT <EQUAL? ,WINNER ,PLAYER>>
					>
					<COND
						(<EQUAL? .WD ,W?WHERE>
							<TO-DO-X-USE-Y "locate" "FIND">
						)
						(T
							<TO-DO-X-USE-Y "ask about" "TELL ME ABOUT">
						)
					>
				)
			>
		>
	>

	<IFN-P-BE-VERB!-
		<DEFINE TO-DO-X-USE-Y (STR1 STR2)
			<RT-AUTHOR-ON>
			<TELL "To " .STR1 " something, use the command: " .STR2 ,P-SOMETHING>
			<RT-AUTHOR-OFF>
		>
	>

	<CONSTANT P-SOMETHING " (something).">
	<VOC "(SOMETHI">
>

<REPLACE-DEFINITION OWNERS
	<CONSTANT OWNERS
		<TABLE (PURE LENGTH)
			CH-BASILISK
			CH-BLACK-KNIGHT
			CH-DEMON
			CH-DRAGON
			CH-FARMERS
			CH-LOT
			CH-MERLIN
			CH-NIMUE
			CH-PEASANT
			CH-PLAYER
			CH-PRISONER
			CH-RAVEN
			CH-SOLDIERS
			LG-CHASM
			LG-LAKE
			LG-MOUNTAIN
			TH-ARMOUR
			TH-BOAR
			TH-CHEESE
			TH-GLASS
			TH-GROUND
			TH-HAWTHORN
			TH-ICE
			TH-MIDGES
			TH-PEAT-BRICK
			TH-SCROLL
			TH-SPICE-BOTTLE
			TH-WEEDS
			TH-WHISKY-JUG
		>
	>
>

;<REPLACE-DEFINITION TELL-I-ASSUME
	<CONSTANT TELL-I-ASSUME <>>
>

<REPLACE-DEFINITION MORE-SPECIFIC
	<DEFINE MORE-SPECIFIC ()
		<SETG CLOCK-WAIT T>
		<RT-AUTHOR-MSG "Please be more specific.">
	>
>

<REPLACE-DEFINITION BEG-PARDON
	<DEFINE BEG-PARDON ()
		<RT-AUTHOR-MSG "I beg your pardon?">
	>
>

<REPLACE-DEFINITION CANT-USE-MULTIPLE
	<DEFINE CANT-USE-MULTIPLE (LOSS WD)
		<SETG CLOCK-WAIT T>
		<RT-AUTHOR-ON>
		<COND
			(<EQUAL? .WD ,W?TELL>
				<TELL "You can't talk to more than one person at a time.">
			)
			(T
				<TELL "You can't use more than one ">
				<COND
					(<==? .LOSS 2>
						<TELL "in">
					)
				>
				<TELL "direct object with \"">
				<PRINT-VOCAB-WORD .WD>
				<TELL "\"!">
			)
		>
		<RT-AUTHOR-OFF>
	>
>

<REPLACE-DEFINITION REFRESH
	<DEFMAC V-REFRESH ("ARGS" L)
		<FORM V-$REFRESH !.L>
	>

	<ROUTINE V-$REFRESH ("OPT" (LOOK? T))
		<LOWCORE FLAGS <BAND <LOWCORE FLAGS> <BCOM 4>>>
		<CLEAR -1>
		<INIT-STATUS-LINE>
		<COND
			(<AND <NOT <IN? ,TH-RED-LANCE ,CH-PLAYER>>
					<NOT <IN? ,TH-GREEN-LANCE ,CH-PLAYER>>
				>
				<COND
					(.LOOK?
						<V-LOOK>
					)
				>
				<COND
					(<AND <EQUAL? ,HERE ,RM-EDGE-OF-WOODS>
							<IN? ,CH-PLAYER ,TH-HORSE>
							<IN? ,CH-BLUE-KNIGHT ,RM-EDGE-OF-WOODS>
						>
						<SETUP-ORPHAN-NP "take lance" ,TH-RED-LANCE ,TH-GREEN-LANCE>
						<TELL "|\"Well lad,\" says the knight. \"" ,K-WHICH-LANCE-MSG>
					)
				>
			)
		>
		<COND
			(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-INVT>		; "Inventory"
				<RT-UPDATE-INVT-WINDOW T>
			)
			(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>		; "Room description"
				<RT-UPDATE-DESC-WINDOW T>
			)
			(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-STAT>		; "Status"
				<RT-UPDATE-STAT-WINDOW T>
			)
			(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>		; "Map"
				<RT-UPDATE-MAP-WINDOW T>
			)
			(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>		; "Picture"
				<RT-UPDATE-PICT-WINDOW T>
			)
		>
		<RTRUE>
	>
>

<REPLACE-DEFINITION TOO-MANY-NOUNS
	<DEFINE TOO-MANY-NOUNS (WD)
		<RT-AUTHOR-ON>
		<TELL "I can't understand that many nouns with ">
		<COND
			(.WD
				<TELL "\"">
				<PRINT-VOCAB-WORD .WD>
				<TELL "\"">
			)
			(T
				<TELL "that verb">
			)
		>
		<TELL ".">
		<RT-AUTHOR-OFF>
	>
>

<REPLACE-DEFINITION DIR-VERB?
	<DEFINE DIR-VERB? () <EQUAL? ,PRSA ,V?WALK>>
>

<REPLACE-DEFINITION DIR-VERB-WORD?
	<DEFINE DIR-VERB-WORD? (WD)
		<EQUAL? .WD ,W?WALK ,W?RUN ,W?GO ,W?HEAD ,W?PROCEED ,W?FLY ,W?SWIM ,W?CRAWL>
	>
>

<DELAY-DEFINITION PRSO-VERB?>
<DELAY-DEFINITION PRSI-VERB?>

<DIRECTIONS	NORTH NE EAST SE SOUTH SW WEST NW UP DOWN IN OUT>

<OBJECT INTDIR
	(LOC GLOBAL-OBJECTS)
	(DESC "direction")
	(SYNONYM NORTH NE EAST SE SOUTH SW WEST NW)
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

