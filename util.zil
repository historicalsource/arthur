;"***************************************************************************"
; "game : Arthur"
; "file : UTIL.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   15 May 1989 18:00:54  $"
; "revs : $Revision:   1.86  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Utility routines"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

<ROUTINE RT-AUTHOR-MSG (STR)
	<RT-AUTHOR-ON>
	<TELL .STR>
	<RT-AUTHOR-OFF>
>

<GLOBAL GL-AUTHOR-SIZE 0 <> BYTE>

;<ROUTINE RT-AUTHOR-ON ()
	<DIROUT ,D-TABLE-ON ,K-DIROUT-TBL ;0>
>

<ROUTINE RT-AUTHOR-OFF ("AUX" WY WX Y X W AY N L PTR SP?)
	<DIROUT ,D-TABLE-OFF>
;	<RT-MAKE-FTBL ,K-DIROUT-TBL 0>	;"Temporary measure for IBM zip."
	<COND
		(<G? ,GL-AUTHOR-SIZE 0>
			<RT-AUTHOR-CLEAR>
		)
	>
	<SETG GL-AUTHOR-SIZE <RT-COUNT-LINES ,K-DIROUT-TBL>>
	<SET AY <* ,GL-AUTHOR-SIZE ,GL-FONT-Y>>
	<SCROLL 0 .AY>
	<SET Y <- <WINGET 0 ,K-W-YCURPOS> .AY>>
	<SET X <WINGET 0 ,K-W-XCURPOS>>
	<SET WY <- <WINGET 0 ,K-W-YSIZE> .AY>>
	<SET WX <WINGET 0 ,K-W-XSIZE>>
	<WINSIZE 0 .WY .WX>
	<COND
		(<G? .Y 0>
			<CURSET .Y .X>
		)
		(T
			<CURSET 1 .X>
		)
	>
	<WINPOS 3 <+ <WINGET 0 ,K-W-YPOS> .WY> <WINGET 0 ,K-W-XPOS>>
	<WINSIZE 3 .AY .WX>
	<WINATTR 3 ,A-WRAP ,O-SET>	;"Make window 3 wrap."
	<WINATTR 3 ,A-SCRIPT ,O-SET>	;"Make window 3 script."
	<WINATTR 3 ,A-BUFFER ,O-SET>	;"Make window 3 buffered."
	<CLEAR 3>
	<SCREEN 3>
	<CURSET 1 1>
 	<HLIGHT ,K-H-INV>
;	<RT-PRINTF ,K-DIROUT-TBL>

	<COND
		(<G? ,GL-AUTHOR-SIZE 1>
			<SET N <ZGET ,K-DIROUT-TBL 0>>
			<SET PTR <ZREST ,K-DIROUT-TBL 2>>
			<REPEAT ()
				<COND
					(<NOT <G? .N 0>>
						<RETURN>
					)
					(T
						<SET L <LOWCORE SCRH>>
						<SET SP? <>>
						<COND
							(<G? .N .L>
								<REPEAT ()
									<COND
										(<EQUAL? <GETB .PTR <- .L 1>> !\ >
											<SET SP? T>
											<RETURN>
										)
										(<L? <SET L <- .L 1>> 1>
											<SET L <LOWCORE SCRH>>
											<RETURN>
										)
									>
								>
							)
							(T
								<SET L .N>
							)
						>
						<COND
							(.SP?
								<PRINTT .PTR <- .L 1>>
							)
							(T
								<PRINTT .PTR .L>
							)
						>
						<SET N <- .N .L>>
						<SET PTR <ZREST .PTR .L>>
						; "Erase rest of line with spaces."
						<SET L </ <- <WINGET 3 ,K-W-XSIZE> <WINGET 3 ,K-W-XCURPOS>> ,GL-SPACE-WIDTH>>
						<COND
							(<G? .L 0>
								<PUTB ,K-DIROUT-TBL 0 !\ >
								<COPYT ,K-DIROUT-TBL <ZREST ,K-DIROUT-TBL 1> <- .L>>
								<PRINTT ,K-DIROUT-TBL .L>
							)
						>
						<CRLF>
					)
				>
			>
		)
		(T
			<PRINTT <ZREST ,K-DIROUT-TBL 2> <ZGET ,K-DIROUT-TBL 0>>
			; "Erase rest of line with spaces."
			<SET L </ <- <WINGET 3 ,K-W-XSIZE> <WINGET 3 ,K-W-XCURPOS>> ,GL-SPACE-WIDTH>>
			<COND
				(<G? .L 0>
					<PUTB ,K-DIROUT-TBL 0 !\ >
					<COPYT ,K-DIROUT-TBL <ZREST ,K-DIROUT-TBL 1> <- .L>>
					<PRINTT ,K-DIROUT-TBL .L>
				)
			>
		)
	>

	<HLIGHT ,K-H-NRM>
	<SCREEN 0>
>

<ROUTINE RT-AUTHOR-CLEAR ("AUX" WY WX Y X)
	<COND
		(<G? ,GL-AUTHOR-SIZE 0>
			<CLEAR 3>
			<SET Y <WINGET 0 ,K-W-YCURPOS>>
			<SET X <WINGET 0 ,K-W-XCURPOS>>
			<SET WY <WINGET 0 ,K-W-YSIZE>>
			<SET WX <WINGET 0 ,K-W-XSIZE>>
			<WINSIZE 0 <+ .WY <* ,GL-AUTHOR-SIZE ,GL-FONT-Y>> .WX>
			<CURSET .Y .X>
			<SETG GL-AUTHOR-SIZE 0>
			<SCREEN 0>
		)
	>
>

<ROUTINE RT-COUNT-LINES (TBL "AUX" TW W CNT)
	<SET TW <LOWCORE TWID>>
	<SET W <WINGET 0 ,K-W-XSIZE>>
	<COND
		(<L? .TW .W>
			<RETURN 1>
		)
		(T
			<SET TW <+ .TW </ .TW 10>>>
			<SET CNT </ .TW .W>>
			<COND
				(<G? <MOD .TW .W> 0>
					<INC CNT>
				)
			>
			<RETURN .CNT>
		)
	>
>

;<ROUTINE RT-COUNT-LINES (TBL "AUX" (CNT 0))
	<REPEAT (I (PTR .TBL))
		<COND
			(<ZERO? <SET I <GET .PTR 0>>>
				<RETURN>
			)
			(T
				<INC CNT>
				<SET PTR <REST <REST .PTR 2> .I>>
			)
		>
	>
	<RETURN .CNT>
>

;<ROUTINE RT-PRINTF (TBL "AUX" I)
	<REPEAT ()
		<COND
			(<ZERO? <SET I <ZGET .TBL 0>>>
				<RETURN>
			)
			(T
				<SET TBL <ZREST .TBL 2>>
				<ERASE 1>
				<PRINTT .TBL .I>
			;	<CURGET ,K-WIN-TBL>
				<COND
					(<NOT <EQUAL? <WINGET -3 ,K-W-XCURPOS> 1>>
						<CRLF>
					)
				>
				<SET TBL <ZREST .TBL .I>>
			)
		>
	>
>

;<ROUTINE RT-MAKE-FTBL (TBL WID "AUX" CNT PTR Q N I SP?)
	<COND
		(<L? .WID 0>
			<SET WID <- .WID>>
		)
		(T
			<SET WID </ <WINGET .WID ,K-W-XSIZE> ,GL-FONT-X>>
		)
	>
	<SET CNT <ZGET .TBL 0>>
	<REPEAT ()
		<SET PTR <ZREST .TBL 2>>
		<SET SP? <>>
		<COND
			(<G? .WID .CNT>
				<SET I .CNT>
			)
			(T
				<SET I .WID>
			)
		>
		<COND
			(<SET Q <INTBL? 13 .PTR .I 1>>
				<PUTB .Q 0 !\ >
				<SET SP? T>
				<SET I <- .I <+ <- .Q .PTR> 1>>>
				<SET PTR <ZREST .Q 1>>
			)
			(<L? .WID .CNT>
				<REPEAT ()
					<COND
						(<SET Q <INTBL? !\  .PTR .I 1>>
							<SET SP? T>
							<SET I <- .I <+ <- .Q .PTR> 1>>>
							<SET PTR <ZREST .Q 1>>
						)
						(T
							<RETURN>
						)
					>
				>
			)
		>
		<COND
			(.SP?
				<SET I <- .PTR <ZREST .TBL 2>>>
				<SET .CNT <- .CNT .I>>
				<COND
					(<G? .I 1>
						<SET Q <ZREST .PTR 1>>
						<DEC I>
					)
					(T
						<SET Q <ZREST .PTR 2>>
					)
				>
				<COPYT .PTR .Q .CNT>
			)
			(<G? .WID .CNT>
				<SET I .CNT>
				<SET CNT 0>
			)
			(T
				<SET I .WID>
				<SET .CNT <- .CNT .WID>>
				<SET PTR <ZREST .TBL <+ .WID 2>>>
				<COPYT .PTR <ZREST .PTR 2> .CNT>
			)
		>
		<ZPUT .TBL 0 .I>
		<SET TBL <ZREST .TBL <+ .I 2>>>
		<COND
			(<ZERO? .CNT>
				<ZPUT .TBL 0 0>
				<RETURN>
			)
		>
	>
>

<ROUTINE RT-EARNED-MSG (N)
	<COND
		(<G? .N 0>
			<TELL "earned">
		)
		(T
			<TELL "lost">
		)
	>
>

<ROUTINE RT-POINT-MSG (STR PT PREV MORE?)
	<COND
		(.PREV
			<TELL comma .MORE?>
		)
	>
	<COND
		(<OR	<ZERO? .PREV>
				<AND
					<OR
						<L? .PT 0>
						<L? .PREV 0>
					>
					<OR
						<G? .PT 0>
						<G? .PREV 0>
					>
				>
			>
			<TELL " ">
			<RT-EARNED-MSG .PT>
		)
	>
	<TELL wn <ABS .PT> " " .STR " point">
	<COND
		(<NOT <EQUAL? <ABS .PT> 1>>
			<TELL "s">
		)
	>
>

<ROUTINE RT-SCORE-MSG (CHV WIS EXP QST "OPT" (NL? T) "AUX" (N 0) (I 0))
	<COND
		(<OR .CHV .WIS .EXP .QST>
			<SETG GL-SC-CHV <+ ,GL-SC-CHV .CHV>>
			<SETG GL-SC-WIS <+ ,GL-SC-WIS .WIS>>
			<SETG GL-SC-EXP <+ ,GL-SC-EXP .EXP>>
			<SETG GL-SC-QST <+ ,GL-SC-QST .QST>>
			<COND
				(,GL-NOTIFY-SCORE?
					<COND
						(.NL?
							<CRLF>
						)
					>
					<HLIGHT ,H-BOLD>
					<TELL "[You have">
					<COND
						(.CHV
							<RT-POINT-MSG "chivalry" .CHV .N <OR .WIS .EXP .QST>>
							<SET N .CHV>
						)
					>
					<COND
						(.WIS
							<RT-POINT-MSG "wisdom" .WIS .N <OR .EXP .QST>>
							<SET N .WIS>
						)
					>
					<COND
						(.EXP
							<RT-POINT-MSG "experience" .EXP .N .QST>
							<SET N .EXP>
						)
					>
					<COND
						(.QST
							<RT-POINT-MSG "quest" .QST .N <>>
							<SET N .QST>
						)
					>
					<TELL ".]">
					<HLIGHT ,H-NORMAL>
					<COND
						(.NL?
							<CRLF>
						)
					>
				)
			>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-STAT>
					<RT-UPDATE-STAT-WINDOW>
				)
			>
			<COND
				(<L=? ,GL-SC-CHV -15>
					<MOVE ,CH-MERLIN ,HERE>
					<TELL ,K-MERLIN-WASTED-MSG CR>
					<RT-END-OF-GAME>
				)
			>
			<RTRUE>
		)
	>
>

<ROUTINE RT-SCORE-OBJ (OBJ "OPT" (NL? T) "AUX" SC)
	<COND
		(<SET SC <GETP .OBJ ,P?SCORE>>
			<RT-SCORE-MSG
				0	;"Chivalry"
				<MOD <SHIFT .SC %<- ,K-WISD-SHIFT>> 32>	;"Wisdom"
				<MOD <SHIFT .SC %<- ,K-EXPR-SHIFT>> 32>	;"Experience"
				<MOD <SHIFT .SC %<- ,K-QUEST-SHIFT>> 32>	;"Quest"
				.NL?
			>
			<PUTP .OBJ ,P?SCORE 0>
			<RTRUE>
		)
	>
>

<GLOBAL GL-SC-CHV 0 <> BYTE>
<GLOBAL GL-SC-WIS 0 <> BYTE>
<GLOBAL GL-SC-EXP 0 <> BYTE>
<GLOBAL GL-SC-QST 0 <> BYTE>

<ROUTINE V-SCORE ()
	<TELL "You have" wn ,GL-SC-CHV " chivalry point">
	<COND
		(<NOT <EQUAL? <ABS ,GL-SC-CHV> 1>>
			<TELL "s">
		)
	>
	<TELL "," wn ,GL-SC-WIS " wisdom point">
	<COND
		(<NOT <EQUAL? <ABS ,GL-SC-WIS> 1>>
			<TELL "s">
		)
	>
	<TELL "," wn ,GL-SC-EXP " experience point">
	<COND
		(<NOT <EQUAL? <ABS ,GL-SC-EXP> 1>>
			<TELL "s">
		)
	>
	<TELL ", and" wn ,GL-SC-QST " quest point">
	<COND
		(<NOT <EQUAL? <ABS ,GL-SC-QST> 1>>
			<TELL "s">
		)
	>
	<TELL "." CR>
>

<SYNTAX NOTIFY = V-NOTIFY>
<SYNTAX NOTIFY ON OBJECT (FIND FL-ROOMS) = V-NOTIFY-ON>
<SYNTAX NOTIFY OFF OBJECT (FIND FL-ROOMS) = V-NOTIFY-OFF>
<GLOBAL GL-NOTIFY-SCORE? T <> BYTE>
<ROUTINE V-NOTIFY ("OPT" VAL)
	<TELL "[Score notification turned ">
	<COND
		(<ASSIGNED? VAL>
			<SETG GL-NOTIFY-SCORE? .VAL>
		)
		(T
			<SETG GL-NOTIFY-SCORE? <NOT ,GL-NOTIFY-SCORE?>>
		)
	>
	<COND
		(,GL-NOTIFY-SCORE?
			<TELL "on">
		)
		(T
			<TELL "off">
		)
	>
	<TELL ".]" CR>
>
<ROUTINE V-NOTIFY-ON ()
	<COND
		(<MC-PRSO? ,ROOMS>
			<V-NOTIFY T>
		)
		(T
			<DONT-UNDERSTAND>
		)
	>
>
<ROUTINE V-NOTIFY-OFF ()
	<COND
		(<MC-PRSO? ,ROOMS>
			<V-NOTIFY <>>
		)
		(T
			<DONT-UNDERSTAND>
		)
	>
>

%<DEBUG-CODE
	<ROUTINE V-$STEAL ()
		<COND
			(<RT-DO-TAKE ,PRSO T>
				<SETG CLOCK-WAIT T>
				<TELL The+verb ,PRSO "appear" " in your hand." CR>
			)
		>
		<RTRUE>
	>
>

%<DEBUG-CODE
	<ROUTINE V-$GOTO ("AUX" OBJ)
		<COND
			(<IN? ,PRSO ,ROOMS>
				<RT-GOTO ,PRSO>
			)
			(T
				<SET OBJ <LOC ,PRSO>>
				<REPEAT ()
					<COND
						(<IN? .OBJ ,ROOMS>
							<RETURN>
						)
						(<EQUAL? <LOC .OBJ> ,LOCAL-GLOBALS ,GLOBAL-OBJECTS <>>
							<RETURN>
						)
						(T
							<SET OBJ <LOC .OBJ>>
						)
					>
				>
				<COND
					(<IN? .OBJ ,ROOMS>
						<TELL "[" D .OBJ "]" CR>
						<RT-GOTO .OBJ>
					)
					(T
						<TELL The+verb ,PRSO "are" "n't in a room." CR>
					)
				>
			)
		>
	>
>

%<DEBUG-CODE
	<ROUTINE V-$PASSWORD ()
		<TELL "You don't need to use a password right now." CR>
	>
>

<ROUTINE V-VERSION ()
	<HLIGHT ,K-H-BLD>
	<TELL
"Arthur: The Quest for Excalibur, by Bob Bates." CR
"Copyright (c) 1989 Infocom, Inc. All rights reserved." CR
"Arthur: The Quest for Excalibur is a trademark of Infocom, Inc." CR
	>
	<TELL
<GET ,K-MACHINE-NAME-TBL <LOWCORE INTID>> " Interpreter version "
N <LOWCORE (ZVERSION 0)> "." N <LOWCORE INTVR> CR
	>
	<TELL "Release " N <BAND <LOWCORE ZORKID> *3777*>>
	<PICINF 0 ,K-WIN-TBL>
	<TELL " / Pix " N <GET ,K-WIN-TBL 1> " / Serial Number ">
	<LOWCORE-TABLE SERIAL 6 PRINTC>
	<CRLF>
	<HLIGHT ,K-H-NRM>
>

<CONSTANT K-MACHINE-NAME-TBL
	<TABLE (PURE LENGTH)
		"Debugging"
		"Apple IIe"
		"Macintosh"
		"Amiga"
		"Atari ST"
		"IBM"
		"Commodore 128"
		"Commodore 64"
		"Apple IIc"
		"Apple IIgs"
	>
>

<SYNTAX COLOR = V-COLOR>

<GLOBAL GL-COLOR-NOTE <> <> BYTE>
<GLOBAL GL-F-COLOR 1 <> BYTE>
<GLOBAL GL-B-COLOR 1 <> BYTE>

<ROUTINE V-COLOR ("AUX" S)
	<COND
		(<NOT ,GL-COLOR-NOTE>
			<SETG GL-COLOR-NOTE T>
			<TELL
"Aesthetically, we recommend not changing the standard setting. "
			>
			<COND
				(<EQUAL? <LOWCORE INTID> ,MACINTOSH>
					<COND
						(<MAC-II?>	; "Color?"
							<TELL
"Also, if your Mac II displays only 16 colors, you probably won't get
the color you ask for. "
							>
						)
						(T
							<TELL
"Also, you can have only black on white or white on black. "
							>
						)
					>
				)
			>
			<TELL "Do you still want to go ahead?" CR>
			<COND
				(<NOT <Y?>>
					<RTRUE>
				)
			>
		)
	>
	<CRLF>
	<REPEAT ()
		<RT-DO-COLOR>
		<TELL
"You should now get " <GET ,K-COLOR-TABLE ,GL-F-COLOR> " text on a "
<GET ,K-COLOR-TABLE ,GL-B-COLOR> " background. Is that what you want?|"
		>
		<COND
			(<Y?>
				<RETURN>
			)
		>
		<COND
			(<AND <EQUAL? <LOWCORE INTID> ,MACINTOSH>
					<NOT <MAC-II?>>	; "Not color?"
				>
				<COND
					(<EQUAL? ,GL-B-COLOR 2>
						<SETG GL-B-COLOR 9>
						<SETG GL-F-COLOR 2>
					)
					(T
						<SETG GL-B-COLOR 2>
						<SETG GL-F-COLOR 9>
					)
				>
				<RETURN>
			)
		>
		<TELL
"|Do you want to pick again, or would you like to just go back to the
standard colors? (Type Y to pick again) >"
		>
		<COND
			(<Y? <>>
				<CRLF>
			)
			(T
				<SETG GL-F-COLOR 1>
				<SETG GL-B-COLOR 1>
				<RETURN>
			)
		>
	>
	<SET S 0>
	<REPEAT ()
		<SCREEN .S>
		<COLOR ,GL-F-COLOR ,GL-B-COLOR>
		<COND
			(<IGRTR? S 7>
				<RETURN>
			)
		>
	>
	<V-$REFRESH>
>

<ROUTINE RT-DO-COLOR ()
	<COND
		(<AND <EQUAL? <LOWCORE INTID> ,MACINTOSH>
				<NOT <MAC-II?>> ;"b&w Mac"
			>
			<COND
				(<EQUAL? ,GL-B-COLOR 2>
					<SETG GL-B-COLOR 9>
					<SETG GL-F-COLOR 2>
				)
				(T
					<SETG GL-B-COLOR 2>
					<SETG GL-F-COLOR 9>
				)
			>
		)
		(T
			<SETG GL-F-COLOR <RT-PICK-COLOR ,GL-F-COLOR "text" T>>
			<SETG GL-B-COLOR <RT-PICK-COLOR ,GL-B-COLOR "background">>
		)
	>
>

<ROUTINE RT-PICK-COLOR (WHICH STRING "OPTIONAL" (SETTING-FG <>) "AUX" CHAR)
	<TELL
"The current " .STRING " color is " <GET ,K-COLOR-TABLE .WHICH> "." CR
	>
	<FONT 4>
	<TELL
"   1 --> WHITE   5 --> YELLOW" CR
"   2 --> BLACK   6 --> BLUE" CR
"   3 --> RED     7 --> MAGENTA" CR
"   4 --> GREEN   8 --> CYAN" CR
	>
	<FONT 1>
	<TELL
"Type a number to select the " .STRING " color you want. >"
	>
	<REPEAT ()
		<COND
			(,DEMO-VERSION?
				<SET CHAR <INPUT-DEMO 1>>
			)
			(T
				<SET CHAR <INPUT 1>>
			)
		>
		<SET CHAR <- .CHAR !\0>> ; "convert from ASCII"
		<COND
			(<EQUAL? .CHAR 1> ; "white is really 9, not 1"
				<SET CHAR 9>
			)
		>
		<COND
			(<EQUAL? .CHAR 2 3 4 5 6 7 8 9>
				<COND
					(<AND <NOT .SETTING-FG>
							<EQUAL? .CHAR ,GL-F-COLOR>
						>
						<TELL
"|You can't make the background the same color as the text. Please pick
another color. >"
						>
					)
					(T
						<RETURN>
					)
				>
			)
			(T
				<TELL CR ,K-TYPE-NUMBER-MSG "8. >">
			)
		>
	>
	<CRLF>
	<CRLF>
	<RETURN .CHAR>
>

<CONSTANT K-TYPE-NUMBER-MSG "Please press a number from 1 to ">

<CONSTANT K-COLOR-TABLE
	<TABLE (PURE)
		;0 "no change"
		;1 "the standard color"
		;2 "black"
		;3 "red"
		;4 "green"
		;5 "yellow"
		;6 "blue"
		;7 "magenta"
		;8 "cyan"
		;9 "white"
	>
>

<ROUTINE MAC-II? ()
	; "Determine if color flag is set."
	<COND
		(<FLAG-ON? ,F-COLOR>
			<RTRUE>
		)
		(T
			<RFALSE>
		)
	>
>

<ROUTINE Y? ("OPT" (P? T) "AUX" C (1ST? T))
	<REPEAT ()
		<COND
			(.P?
				<TELL "Please press Y or N >">
			)
		>
		<COND
			(,DEMO-VERSION?
				<SET C <INPUT-DEMO 1>>
			)
			(T
				<SET C <INPUT 1>>
			)
		>
		<COND
			(<EQUAL? .C !\Y !\N !\y !\n>
				<PRINTC .C>
				<CRLF>
				<COND
					(<EQUAL? .C !\Y !\y>
						<RTRUE>
					)
					(T
						<RFALSE>
					)
				>
			)
			(T
				<SOUND ,S-BEEP>
			)
		>
		<COND
			(.P?
				<CRLF>
			)
		>
	>
>

<VERB-SYNONYM CREDITS CREDIT>
<SYNTAX CREDITS = V-CREDITS>

<ROUTINE V-CREDITS ()
	<TELL ,K-CREDITS-MSG CR>
	<SETG CLOCK-WAIT T>
>

<ROUTINE RT-CHECK-ADJ (DOOR)
	<COND
		(<EQUAL? .DOOR ,LG-CELL-DOOR>
			<RT-UPDATE-ADJ ,LG-CELL-DOOR ,RM-CELL ,RM-HALL>
		)
		(<EQUAL? .DOOR ,LG-IVORY-DOOR>
			<RT-UPDATE-ADJ ,LG-CELL-DOOR ,RM-TOW-CLEARING ,RM-CIRC-ROOM>
		)
		(<EQUAL? .DOOR ,LG-WOODEN-DOOR>
			<RT-UPDATE-ADJ ,LG-CELL-DOOR ,RM-LANDING ,RM-TOWER-ROOM>
		)
	>
>

<ROUTINE RT-UPDATE-ADJ (DOOR RM1 RM2 "AUX" TMP1 TMP2)
	<SET TMP2 <GETP .RM1 ,P?ADJACENT>>
	<COND
		(.TMP2
			<COND
				(<SET TMP1 <INTBL? .RM2 <REST .TMP2 1> <GETB .TMP2 0> 1>>
					<PUTB .TMP1 1 <FSET? .DOOR ,FL-OPEN>>
				)
			>
		)
	>
	<SET TMP2 <GETP .RM2 ,P?ADJACENT>>
	<COND
		(.TMP2
			<COND
				(<SET TMP1 <INTBL? .RM1 <REST .TMP2 1> <GETB .TMP2 0> 1>>
					<PUTB .TMP1 1 <FSET? .DOOR ,FL-OPEN>>
				)
			>
		)
	>
>

<ROUTINE RT-WORD-NUMBERS (COUNT "OPT" (1ST? T) "AUX" N)
	<COND
		(.1ST?
			<TELL " ">
			<COND
				(<L? .COUNT 0>
					<TELL "negative ">
					<SET COUNT <ABS .COUNT>>
				)
			>
		)
	>
	<COND
		(<EQUAL? .COUNT  0> <TELL "zero">)
		(<EQUAL? .COUNT  1> <TELL "one">)
		(<EQUAL? .COUNT  2> <TELL "two">)
		(<EQUAL? .COUNT  3> <TELL "three">)
		(<EQUAL? .COUNT  4> <TELL "four">)
		(<EQUAL? .COUNT  5> <TELL "five">)
		(<EQUAL? .COUNT  6> <TELL "six">)
		(<EQUAL? .COUNT  7> <TELL "seven">)
		(<EQUAL? .COUNT  8> <TELL "eight">)
		(<EQUAL? .COUNT  9> <TELL "nine">)
		(<EQUAL? .COUNT 10> <TELL "ten">)
		(<EQUAL? .COUNT 11> <TELL "eleven">)
		(<EQUAL? .COUNT 12> <TELL "twelve">)
		(<EQUAL? .COUNT 13> <TELL "thirteen">)
		(<EQUAL? .COUNT 14> <TELL "fourteen">)
		(<EQUAL? .COUNT 15> <TELL "fifteen">)
		(<EQUAL? .COUNT 16> <TELL "sixteen">)
		(<EQUAL? .COUNT 17> <TELL "seventeen">)
		(<EQUAL? .COUNT 18> <TELL "eighteen">)
		(<EQUAL? .COUNT 19> <TELL "nineteen">)
		(<EQUAL? .COUNT 20> <TELL "twenty">)
		(<EQUAL? .COUNT 30> <TELL "thirty">)
		(<EQUAL? .COUNT 40> <TELL "forty">)
		(<EQUAL? .COUNT 50> <TELL "fifty">)
		(<EQUAL? .COUNT 60> <TELL "sixty">)
		(<EQUAL? .COUNT 70> <TELL "seventy">)
		(<EQUAL? .COUNT 80> <TELL "eighty">)
		(<EQUAL? .COUNT 90> <TELL "ninety">)
		(<L? .COUNT 100>
			<SET N <MOD .COUNT 10>>
			<RT-WORD-NUMBERS <- .COUNT .N> <>>
			<TELL "-">
			<RT-WORD-NUMBERS .N <>>
		)
		(<L? .COUNT 1000>
			<RT-WORD-NUMBERS </ .COUNT 100> <>>
			<TELL " hundred">
			<COND
				(<G? <MOD .COUNT 100> 0>
					<TELL " and ">
					<RT-WORD-NUMBERS <MOD .COUNT 100> <>>
				)
			>
		)
		(T
			<RT-WORD-NUMBERS </ .COUNT 1000> <>>
			<TELL " thousand">
			<COND
				(<G? <MOD .COUNT 1000> 0>
					<TELL ", ">
					<RT-WORD-NUMBERS <MOD .COUNT 1000> <>>
				)
			>
		)
	>
>

<ROUTINE RT-NOUN-TO-DIR ()
	<COND
		(<NOUN-USED? ,INTDIR ,W?NORTH>
			<RETURN ,P?NORTH>
		)
		(<NOUN-USED? ,INTDIR ,W?SOUTH>
			<RETURN ,P?SOUTH>
		)
		(<NOUN-USED? ,INTDIR ,W?EAST>
			<RETURN ,P?EAST>
		)
		(<NOUN-USED? ,INTDIR ,W?WEST>
			<RETURN ,P?WEST>
		)
		(<NOUN-USED? ,INTDIR ,W?NW ,W?NORTHWEST>
			<RETURN ,P?NW>
		)
		(<NOUN-USED? ,INTDIR ,W?NE ,W?NORTHEAST>
			<RETURN ,P?NE>
		)
		(<NOUN-USED? ,INTDIR ,W?SW ,W?SOUTHWEST>
			<RETURN ,P?SW>
		)
		(<NOUN-USED? ,INTDIR ,W?SE ,W?SOUTHEAST>
			<RETURN ,P?SE>
		)
	>
>

;<ROUTINE RT-DIRWORD-MSG (DIR)
	<TELL " ">
	<COND
		(<EQUAL? .DIR ,P?NORTH ,P?NE ,P?EAST ,P?SE ,P?SOUTH ,P?SW ,P?WEST ,P?NW>
			<COND
				(<EQUAL? .DIR ,P?NORTH ,P?NE ,P?NW>
					<TELL "north">
				)
				(<EQUAL? .DIR ,P?SOUTH ,P?SE ,P?SW>
					<TELL "south">
				)
			>
			<COND
				(<EQUAL? .DIR ,P?EAST ,P?NE ,P?SE>
					<TELL "east">
				)
				(<EQUAL? .DIR ,P?WEST ,P?NW ,P?SW>
					<TELL "west">
				)
			>
		)
		(<EQUAL? .DIR ,P?UP>
			<TELL "up">
		)
		(<EQUAL? .DIR ,P?DOWN>
			<TELL "down">
		)
		(<EQUAL? .DIR ,P?IN>
			<TELL "in">
		)
		(<EQUAL? .DIR ,P?OUT>
			<TELL "out">
		)
	>
>

<CONSTANT K-NIGHT 1>
<CONSTANT K-EARLY-MORNING 2>
<CONSTANT K-MORNING 3>
<CONSTANT K-AFTERNOON 4>
<CONSTANT K-EVENING 5>

<ROUTINE RT-TIME-OF-DAY? (TIME1 "OPT" (TIME2 -1) (TIME3 -1) "AUX" MIN)
	<SET MIN <MOD ,GL-MOVES 1440>>
	<COND
		(<L? .MIN 360>
			<RETURN <EQUAL? ,K-NIGHT .TIME1 .TIME2 .TIME3>>
		)
		(<L? .MIN 540>
			<RETURN <EQUAL? ,K-EARLY-MORNING .TIME1 .TIME2 .TIME3>>
		)
		(<L? .MIN 720>
			<RETURN <EQUAL? ,K-MORNING .TIME1 .TIME2 .TIME3>>
		)
		(<L? .MIN 1050>
			<RETURN <EQUAL? ,K-AFTERNOON .TIME1 .TIME2 .TIME3>>
		)
		(<L? .MIN 1140>
			<RETURN <EQUAL? ,K-EVENING .TIME1 .TIME2 .TIME3>>
		)
		(T
			<RETURN <EQUAL? ,K-NIGHT .TIME1 .TIME2 .TIME3>>
		)
	>
>

<CONSTANT K-MERLIN-NODS-MSG
"Merlin nods his head and says, \"Very well, Arthur.\"">

<CONSTANT K-MERLIN-SORRY-MSG
"Merlin shakes his head and says, \"It seems that is beyond my power, Arthur.
Perhaps you would like to try another.\"">

<ROUTINE RT-STOP-READ () <RTRUE>>

<ROUTINE RT-END-OF-GAME ("OPT" (WIN? <>) (RPT <>) "AUX" VAL (MSG? T) (M? <>))
	<UPDATE-STATUS-LINE>
	<COND
		(<NOT .RPT>
			<CRLF>
			<COND
				(<INTBL? ,HERE <ZREST ,K-DEMON-DOMAIN-TBL 1> <GETB ,K-DEMON-DOMAIN-TBL 0> 1>
					<TELL
"You hear Merlin's voice faintly in your ears, \"You have failed, Arthur.
England is doomed.\"||"
					>
				)
				(T
					<SET M? T>
					<TELL "Merlin ">
					<COND
						(<NOT <IN? ,CH-MERLIN ,HERE>>
							<TELL "appears before you and ">
						)
					>
					<TELL "says ">
					<COND
						(.WIN?
							<TELL
"\"You have done well, Arthur. Your reign will be long and, at times,
peaceful. I must leave you now for a long journey. But rest assured my young
friend - when you have need of me, I will be there.\"" CR CR

"\"Before I go, I shall"
							>
						)
						(T
							<TELL
"sadly, \"You have failed in your quest, Arthur. Dark days lie ahead for all
England.\"||\"However, it is within my power to"
							>
						)
					>
					<TELL " grant you one final wish. ">
				)
			>
		)
	>
	<REPEAT ()
		<COND
			(.RPT
				<CRLF>
				<COND
					(.M?
						<TELL "\"">
					)
				>
			)
		>
		<TELL "Do you want to ">
		<COND
			(,P-CAN-UNDO
				<TELL "Undo, ">
			)
		>
		<TELL "Restore, Restart, Quit, or get a Hint?">
		<COND
			(.M?
				<TELL "\"">
			)
		>
		<CRLF>
		<COND
			(<AND <NOT .RPT>
					.WIN?
				>
				; "Bob"
				<TELL
"(Now that you have won the game, you may read the author's appendix by
typing HINT, and looking under the APPENDIX section.)" CR
				>
			)
		>
		<SET RPT T>
		<REPEAT ()
			<TELL ">">
			<PUTB ,P-INBUF 1 0>
			<REPEAT ()
				<SET VAL <ZREAD ,P-INBUF ,P-LEXV>>
				<COND
					(<EQUAL? .VAL 10 13>
						<RETURN>
					)
					(T
						<RT-HOT-KEY .VAL>
					)
				>
			>
			<SET VAL <GET ,P-LEXV ,P-LEXSTART>>
			<COND
				(<AND ,P-CAN-UNDO
						<EQUAL? .VAL ,W?UNDO>
					>
					<COND
						(.M?
							<TELL ,K-MERLIN-NODS-MSG CR>
							<INPUT 1 20 ,RT-STOP-READ>
						)
					>
					<V-UNDO>
					<COND
						(.M?
							<TELL ,K-MERLIN-SORRY-MSG CR>
						)
					>
					<RETURN>
				)
				(<EQUAL? .VAL ,W?RESTART>
					<COND
						(.M?
							<TELL ,K-MERLIN-NODS-MSG CR>
							<INPUT 1 20 ,RT-STOP-READ>
						)
					>
					<RESTART>
					<COND
						(.M?
							<TELL ,K-MERLIN-SORRY-MSG CR>
						)
					>
					<RETURN>
				)
				(<EQUAL? .VAL ,W?RESTORE>
					<COND
						(.M?
							<TELL "\"Very well. What is the name of the file?\"" CR>
						)
					>
					<V-RESTORE>
					<COND
						(.M?
							<TELL ,K-MERLIN-SORRY-MSG CR>
						)
					>
					<RETURN>
				)
				(<EQUAL? .VAL ,W?QUIT ,W?Q>
					<COND
						(.M?
							<TELL "\"">
						)
					>
					<TELL "Are you sure you want to quit?">
					<COND
						(.M?
							<TELL "\" he asks.">
						)
					>
					<COND
						(<YES? T>
							<COND
								(.M?
									<TELL "Merlin bows his head and murmurs, \"So be it.\"" CR>
									<INPUT 1 20 ,RT-STOP-READ>
								)
							>
							<QUIT>
							<COND
								(.M?
									<TELL ,K-MERLIN-SORRY-MSG CR>
								)
							>
						)
						(T
							<RETURN>
						)
					>
				)
				(<EQUAL? .VAL ,W?HINT>
					<COND
						(<AND <NOT <IN? ,CH-PLAYER ,RM-CRYSTAL-CAVE>> .M? .MSG?>
							<TELL
"Merlin waves his arms over you and suddenly you become disoriented. Your
vision blurs. It seems you are standing in a darkened cave, gazing into a
crystal ball.||"
							>
							<COND
								(,GL-HINT-WARNING
									<INPUT 1 50 ,RT-STOP-READ>
								)
							>
						)
					>
					<SET MSG? ,GL-HINT-WARNING>
					<V-HINT>
					<COND
						(<AND <NOT <IN? ,CH-PLAYER ,RM-CRYSTAL-CAVE>> .M? .MSG?>
							<TELL
"Your vision clears and Merlin says, \"Welcome back, Arthur.\"|"
							>
						)
					>
					<RETURN>
				)
				(T
					<COND
						(.M?
							<TELL "\"">
						)
					>
					<TELL "Please type ">
					<COND
						(,P-CAN-UNDO
							<TELL "UNDO, ">
						)
					>
					<TELL "RESTORE, RESTART, QUIT, or HINT.">
					<COND
						(.M?
							<TELL "\"">
						)
					>
					<CRLF>
				)
			>
		>
	>
>

<ROUTINE NO-NEED ("OPTIONAL" (STR <>) (OBJ <>))
	<COND
		(<NOT .OBJ>
			<SET OBJ ,PRSO>
		)
	>
	<SETG CLOCK-WAIT T>
	<TELL "[" The+verb ,WINNER "do" "n't need to ">
	<COND
		(.STR
			<TELL .STR>
		)
		(T
		;	<VERB-PRINT>
			<PRINTB <PARSE-VERB ,PARSE-RESULT>>
		)
	>
	<COND
		(<EQUAL? .STR "go" ;"drive">
			<TELL " in that " D ,INTDIR>
		)
		(.OBJ
			<TELL the .OBJ>
		)
	>
	<TELL ".]" CR>
>

<ROUTINE RT-TAKE-WITH-MSG (OBJ WITH "AUX" SIZE)
	<SET SIZE <GETB <GETPT .OBJ ,P?SIZE> ,K-SIZE>>
	<COND
		(<OR	<G? .SIZE 1>
				<MC-FORM? ,K-FORM-EEL ,K-FORM-TURTLE ,K-FORM-SALAMANDER>
			>
			<TELL The+verb .OBJ "are" " too big for" the .WITH "." CR>
		)
		(T
			<TELL
"You pick up" the .OBJ ", shake" him .OBJ " a few times, and then drop"
him .OBJ " again." CR
			>
		)
	>
>

<ROUTINE RT-YOU-CANT-MSG ("OPTIONAL" (STR <>) (WHILE <>) (STR1 <>))
	<TELL The ,WINNER " can't ">
	<COND
		(<ZERO? .STR>
		;	<VERB-PRINT>
			<PRINTB <PARSE-VERB ,PARSE-RESULT>>
		)
		(T
			<TELL .STR>
		)
	>
	<COND
		(<EQUAL? .STR "go">
			<TELL " in that " D ,INTDIR>
		)
		(T
			<TELL the ,PRSO>
			<COND
				(.STR1
					<TELL " while">
					<COND
						(.WHILE
							<TELL he+verb .WHILE "are">
						)
						(T
							<TELL he+verb ,PRSO "are">
						)
					>
					<TELL " " .STR1>
				)
			>
		)
	>
	<TELL "." CR>
>

<ROUTINE RT-ALREADY-MSG (OBJ "OPTIONAL" (STR <>))
	<SETG CLOCK-WAIT T>
	<COND
		(<NOT <G? ,P-MULT 1>>
			<RT-AUTHOR-ON>
		)
	>
	<TELL The+verb .OBJ "are" " already">
	<COND
		(.STR
			<TELL " " .STR ".">
			<COND
				(<G? ,P-MULT 1>
					<CRLF>
				)
				(T
					<RT-AUTHOR-OFF>
				)
			>
		)
	>
	<RTRUE>
>

<CONSTANT K-TOO-DARK-MSG "It's too dark to see.|">

<CONSTANT K-NOT-LIKELY-TBL
	<TABLE (PATTERN (BYTE WORD))
		<BYTE 1>
		<TABLE (PURE LENGTH)
			"isn't likely"
			"seems doubtful"
			"seems unlikely"
			"doesn't seem likely"
		>
	>
>

<ROUTINE RT-NOT-LIKELY-MSG (OBJ STR)
	<TELL
"It " <RT-PICK-NEXT ,K-NOT-LIKELY-TBL> " that" the .OBJ " " .STR "." CR
	>
>

<CONSTANT K-NO-POINT-TBL
	<TABLE (PATTERN (BYTE WORD))
		<BYTE 1>
		<TABLE (PURE LENGTH)
			"not do anything useful"
			"accomplish nothing"
			"have no desirable effect"
			"not be very productive"
			"serve no purpose"
			"be pointless"
			"be a waste of time"
		>
	>
>

<CONSTANT K-UNUSUAL-TBL
	<TABLE (PATTERN (BYTE WORD))
		<BYTE 1>
		<TABLE (PURE LENGTH)
			"unusual"
			"special"
			"interesting"
			"important"
			"of interest"
		>
	>
>

<ROUTINE RT-NO-POINT-MSG (STR)
	<TELL .STR the ,PRSO " would " <RT-PICK-NEXT ,K-NO-POINT-TBL> "." CR>
>

<ROUTINE RT-PICK-NEXT (TBL "AUX" CNT STR NT)
	<SET CNT <GETB .TBL 0>>
	<SET NT <ZGET <REST .TBL 1> 0>>
	<SET STR <ZGET .NT .CNT>>
	<COND
		(<G? <SET CNT <+ .CNT 1>> <GET .NT 0>>
			<SET CNT 1>
		)
	>
	<PUTB .TBL 0 .CNT>
	<RETURN .STR>
>

<CONSTANT K-TALK-TO-SELF-MSG "Talking to yourself is a bad sign.">

<ROUTINE RT-NO-RESPONSE-MSG ("OPT" (OBJ <>))
   <COND
      (<NOT .OBJ>
			<SET OBJ ,PRSO>
      )
   >
	<COND
		(<EQUAL? .OBJ ,ROOMS>
			<SET OBJ ,WINNER>
		)
	>
	<COND
		(<AND <EQUAL? .OBJ ,CH-PLAYER>
				<NOT <SET OBJ <FIND-FLAG-HERE ,FL-PERSON ,CH-PLAYER>>>
			>
			<RT-AUTHOR-MSG ,K-TALK-TO-SELF-MSG>
		)
		(<FSET? .OBJ ,FL-ASLEEP>
			<TELL The+verb .OBJ "are" " in no condition to respond." CR>
		)
		(T
			<TELL The+verb .OBJ "do" "n't respond." CR>
		)
	>
>

<ROUTINE RT-FOOLISH-TO-TALK? ()
	<COND
		(<MC-PRSO? <> ,ROOMS>
			<RFALSE>
		)
		(<NOT <FSET? ,PRSO ,FL-ALIVE>>
			<RT-NO-RESPONSE-MSG>
		)
		(<MC-PRSO? ,CH-PLAYER ,PRSI ,WINNER>
			<RT-WASTE-OF-TIME-MSG>
		)
		(T
			<THIS-IS-IT ,PRSO>
			<RFALSE>
		)
	>
>

<ROUTINE RT-WASTE-OF-TIME-MSG ()
;	<TELL "That would be a waste of time." CR>
	<TELL "That would " <RT-PICK-NEXT ,K-NO-POINT-TBL> "." CR>
>

<CONSTANT K-HOW-INTEND-MSG "How do you intend to do that?">

;<ROUTINE FIND-FLAG-NOT (RM FLAG "AUX" OBJ)
	<SET OBJ <FIRST? .RM>>
	<REPEAT ()
		<COND
			(<NOT .OBJ>
				<RFALSE>
			)
			(<AND <NOT <FSET? .OBJ .FLAG>>
					<NOT <FSET? .OBJ ,FL-INVISIBLE>>
				>
				<RETURN .OBJ>
			)
			(T
				<SET OBJ <NEXT? .OBJ>>
			)
		>
	>
>

<ROUTINE FIND-FLAG-LG (RM FLAG "OPTIONAL" (FLAG2 0) "AUX" TBL OBJ (CNT 0) SIZE)
	<COND
		(<SET TBL <GETPT .RM ,P?GLOBAL>>
			<SET SIZE <RMGL-SIZE .TBL>>
			<REPEAT ()
				<SET OBJ <GET/B .TBL .CNT>>
				<COND
					(<AND <FSET? .OBJ .FLAG>
							<NOT <FSET? .OBJ ,FL-INVISIBLE>>
							<OR
								<0? .FLAG2>
								<FSET? .OBJ .FLAG2>
							>
						>
						<RETURN .OBJ>
					)
					(<IGRTR? CNT .SIZE>
						<RFALSE>
					)
				>
			>
		)
	>
>

<ROUTINE FIND-FLAG-HERE (FLAG "OPTIONAL" (NOT1 <>) (NOT2 <>) "AUX" OBJ)
	<SET OBJ <FIRST? ,HERE>>
	<REPEAT ()
		<COND
			(<NOT .OBJ>
				<RFALSE>
			)
			(<AND <FSET? .OBJ .FLAG>
					<NOT <FSET? .OBJ ,FL-INVISIBLE>>
					<NOT <EQUAL? .OBJ .NOT1 .NOT2>>
				>
				<RETURN .OBJ>
			)
			(T
				<SET OBJ <NEXT? .OBJ>>
			)
		>
	>
>

<ROUTINE HAR-HAR ()
	<SETG CLOCK-WAIT T>
	<TELL "[You can't be serious.]" CR>
>

<ROUTINE RT-IMPOSSIBLE-MSG ()
	<SETG CLOCK-WAIT T>
	<TELL "[That's impossible.]" CR>
>

<ROUTINE RT-WONT-HELP-MSG ()
	<SETG CLOCK-WAIT T>
	<TELL "[That would be a waste of time.]" CR>
>

<ROUTINE RT-META-IN? (OBJ CONT "AUX" L)
	<SET L <LOC .OBJ>>
	<REPEAT ()
		<COND
			(<ZERO? .L>
				<RFALSE>
			)
			(<EQUAL? .L .CONT>
				<RTRUE>
			)
			(T
				<SET L <LOC .L>>
			)
		>
	>
>

<ROUTINE RT-CANT-REACH-MSG ("OPT" (OBJ1 <>) (OBJ2 <>))
	<COND
		(<NOT .OBJ1>
			<SET OBJ1 ,PRSO>
		)
	>
	<TELL The ,WINNER " can't reach" the .OBJ1>
	<COND
		(.OBJ2
			<TELL " from" the .OBJ2>
		)
	>
	<TELL "." CR>
>

<ROUTINE RT-I-SUNSET ()
	<RT-QUEUE ,RT-I-SUNSET <+ ,GL-MOVES 1440>>
	<COND
		(<NOT <FSET? ,HERE ,FL-INDOORS>>
			<TELL "|Daylight begins to fade. Soon it will be dark." CR>
		)
	>
>

<ROUTINE RT-COMMA-MSG (MORE?)
	<COND
		(.MORE?
			<TELL ",">
		)
		(T
			<TELL " and">
		)
	>
>

<ROUTINE RT-MOVE-ALL (FROM "OPT" (TO <>) "AUX" NXT OBJ (CNT 0))
	<SET OBJ <FIRST? .FROM>>
	<REPEAT ()
		<COND
			(<NOT .OBJ>
				<RETURN>
			)
			(T
				<SET NXT <NEXT? .OBJ>>
				<COND
					(.TO
						<MOVE .OBJ .TO>
					)
					(T
						<REMOVE .OBJ>
					)
				>
				<INC CNT>
				<SET OBJ .NXT>
			)
		>
	>
	<RETURN .CNT>
>

<ROUTINE RT-MOVE-ALL-BUT-WORN (FROM "OPT" (TO <>) "AUX" NXT OBJ (CNT 0))
	<SET OBJ <FIRST? .FROM>>
	<REPEAT ()
		<COND
			(<NOT .OBJ>
				<RETURN>
			)
			(T
				<SET NXT <NEXT? .OBJ>>
				<COND
					(<NOT <FSET? .OBJ ,FL-WORN>>
						<COND
							(.TO
								<MOVE .OBJ .TO>
							)
							(T
								<REMOVE .OBJ>
							)
						>
						<INC CNT>
					)
				>
				<SET OBJ .NXT>
			)
		>
	>
	<RETURN .CNT>
>

<ROUTINE RT-CENTER-STRING (STR)
	<DIROUT ,K-D-TBL-ON ,K-DIROUT-TBL>
	<PRINT .STR>
	<DIROUT ,K-D-TBL-OFF>
	<CURSET
		<WINGET -3 ,K-W-YCURPOS>
		<+ </ <- <WINGET -3 ,K-W-XSIZE> <LOWCORE TWID>> 2> 1>
	>
	<PRINTT <ZREST ,K-DIROUT-TBL 2> <ZGET ,K-DIROUT-TBL 0>>
	<CRLF>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

