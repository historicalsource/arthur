;"***************************************************************************"
; "game : Arthur"
; "file : WINDOW.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   12 May 1989  0:50:02  $"
; "revs : $Revision:   1.102  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Upper Window stuff"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

<ROUTINE RT-HOT-KEY (KEY "OPT" (BUF ,P-INBUF))
	<COND
		(<EQUAL? .KEY ,K-F1>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-NONE>
					<SETG GL-WINDOW-TYPE ,K-WIN-PICT>
				)
				(T
					<RT-UPDATE-PICT-WINDOW T>
					<RTRUE>
				)
			>
		)
		(<EQUAL? .KEY ,K-F2>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-NONE>
					<SETG GL-WINDOW-TYPE ,K-WIN-MAP>
				)
				(T
					<RT-UPDATE-MAP-WINDOW T>
					<RTRUE>
				)
			>
		)
		(<EQUAL? .KEY ,K-F3>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-NONE>
					<SETG GL-WINDOW-TYPE ,K-WIN-INVT>
				)
				(T
					<RT-UPDATE-INVT-WINDOW T>
					<RTRUE>
				)
			>
		)
		(<EQUAL? .KEY ,K-F4>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-NONE>
					<SETG GL-WINDOW-TYPE ,K-WIN-STAT>
				)
				(T
					<RT-UPDATE-STAT-WINDOW T>
					<RTRUE>
				)
			>
		)
		(<EQUAL? .KEY ,K-F5>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-NONE>
					<SETG GL-WINDOW-TYPE ,K-WIN-DESC>
				)
				(T
					<RT-UPDATE-DESC-WINDOW T>
					<RTRUE>
				)
			>
		)
		(<EQUAL? .KEY ,K-F6>
			<COND
				(<NOT <EQUAL? ,GL-WINDOW-TYPE ,K-WIN-NONE>>
					<SETG GL-WINDOW-TYPE ,K-WIN-NONE>
				)
			>
		)
		(T
			<RFALSE>
		)
	>
	<V-REFRESH <>>
	<UPDATE-STATUS-LINE>
	<TELL CR ">">
	<COND
		(<G? <GETB .BUF 1> 0>
			<PRINTT <ZREST .BUF 2> <GETB .BUF 1>>
		)
	>
	<RTRUE>
>

%<DEBUG-CODE <SYNTAX $INVENTORY = V-$INVENTORY>>
%<DEBUG-CODE <SYNONYM $INVENTORY $I $INV $INVT $F1>>
%<DEBUG-CODE
	<ROUTINE V-$INVENTORY ()
		<COND
			(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-NONE>
				<SETG GL-WINDOW-TYPE ,K-WIN-INVT>
				<V-REFRESH <>>
			)
			(T
				<RT-UPDATE-INVT-WINDOW T>
			)
		>
		<SETG CLOCK-WAIT T>
		<RFATAL>
	>
>

%<DEBUG-CODE <SYNTAX $DESC = V-$DESC>>
%<DEBUG-CODE <SYNONYM $DESC $DESCRIPTION $LOOK $L $F2>>
%<DEBUG-CODE
	<ROUTINE V-$DESC ()
		<COND
			(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-NONE>
				<SETG GL-WINDOW-TYPE ,K-WIN-DESC>
				<V-REFRESH <>>
			)
			(T
				<RT-UPDATE-DESC-WINDOW T>
			)
		>
		<SETG CLOCK-WAIT T>
		<RFATAL>
	>
>

%<DEBUG-CODE <SYNTAX $SCORE = V-$SCORE>>
%<DEBUG-CODE <SYNONYM $SCORE $STAT $STATUS $F3>>
%<DEBUG-CODE
	<ROUTINE V-$SCORE ()
		<COND
			(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-NONE>
				<SETG GL-WINDOW-TYPE ,K-WIN-STAT>
				<V-REFRESH <>>
			)
			(T
				<RT-UPDATE-STAT-WINDOW T>
			)
		>
		<SETG CLOCK-WAIT T>
		<RFATAL>
	>
>

<SYNTAX MAP = V-MAP>
%<DEBUG-CODE <SYNONYM MAP $MAP $F4>>
<ROUTINE V-MAP ()
	<COND
		(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-NONE>
			<SETG GL-WINDOW-TYPE ,K-WIN-MAP>
			<V-$REFRESH <>>
		)
		(T
			<RT-UPDATE-MAP-WINDOW T>
		)
	>
	<SETG CLOCK-WAIT T>
	<RFATAL>
>

%<DEBUG-CODE <SYNTAX $PICTURE = V-$PICTURE>>
%<DEBUG-CODE <SYNONYM $PICTURE $PICT $F5>>
%<DEBUG-CODE
	<ROUTINE V-$PICTURE ()
		<COND
			(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-NONE>
				<SETG GL-WINDOW-TYPE ,K-WIN-PICT>
				<V-REFRESH <>>
			)
			(T
				<RT-UPDATE-PICT-WINDOW T>
			)
		>
		<SETG CLOCK-WAIT T>
		<RFATAL>
	>
>

%<DEBUG-CODE <SYNTAX $NONE = V-$NONE>>
%<DEBUG-CODE <SYNONYM $NONE $FULL $NOWINDOW $FULLSCREEN $F6>>
%<DEBUG-CODE
	<ROUTINE V-$NONE ()
		<COND
			(<NOT <EQUAL? ,GL-WINDOW-TYPE ,K-WIN-NONE>>
				<SETG GL-WINDOW-TYPE ,K-WIN-NONE>
				<V-REFRESH <>>
			)
		>
		<SETG CLOCK-WAIT T>
		<RFATAL>
	>
>

<CONSTANT K-WIN-NONE 0>
<CONSTANT K-WIN-INVT 1>
<CONSTANT K-WIN-DESC 2>
<CONSTANT K-WIN-STAT 3>
<CONSTANT K-WIN-MAP  4>
<CONSTANT K-WIN-PICT 5>

<GLOBAL GL-WINDOW-TYPE ,K-WIN-PICT <> BYTE>

<GLOBAL GL-UPDATE-WINDOW 0 <> BYTE>
<CONSTANT K-UPD-INVT  1>
<CONSTANT K-UPD-OBJS  2>
<CONSTANT K-UPD-DESC  4>
<CONSTANT K-UPD-STAT  8>
<CONSTANT K-UPD-MAP  16>
<CONSTANT K-UPD-PICT 32>

;"Information about stuff in window."
<GLOBAL GL-WIN-N 0>
<GLOBAL GL-WIN-X 0>
<GLOBAL GL-WIN-Y 0>

;"---------------------------------------------------------------------------"
; "Status window"
;"---------------------------------------------------------------------------"

<ROUTINE RT-BAR (TITLE VAL "OPT" (REF? <>) "AUX" W X M S)
	<SET M <- <WINGET -3 ,K-W-XSIZE> <* 8 ,GL-FONT-X>>>
	<COND
		(.REF?
			<CURSET ,GL-WIN-Y 1>
			<TELL .TITLE ":">
		)
	>
	<CURSET ,GL-WIN-Y <* 13 ,GL-FONT-X>>
	<TELL N .VAL>
	<ERASE 1>
	<CURSET ,GL-WIN-Y .M>
	<TELL "|">
	<SETG GL-WIN-Y <+ ,GL-WIN-Y ,GL-FONT-Y>>
	<CURSET ,GL-WIN-Y 1>
	<SET X <+ <* </ .M 100> .VAL> </ <+ <* <MOD .M 100> .VAL> 50> 100>>>
	<COND
		(<G? .X 0>
			<SET S </ <+ .X </ ,GL-SPACE-WIDTH 2>> ,GL-SPACE-WIDTH>>
			<PUTB ,K-DIROUT-TBL 0 !\ >
			<COPYT ,K-DIROUT-TBL <ZREST ,K-DIROUT-TBL 1> <- .S>>
			<HLIGHT ,K-H-INV>
			<PRINTT ,K-DIROUT-TBL .S>
			<HLIGHT ,K-H-NRM>
			<ERASE 1>
		)
	>
	<COND
		(<L? .VAL 100>
			<CURSET ,GL-WIN-Y .M>
			<TELL "|">
		)
	>
	<SETG GL-WIN-Y <+ ,GL-WIN-Y ,GL-FONT-Y>>
	<CURSET ,GL-WIN-Y 1>
>

<ROUTINE RT-UPDATE-STAT-WINDOW ("OPT" (REF? <>))
	<WINATTR 2 ,A-WRAP ,O-CLEAR>	;"Make window 2 not wrap."
	<COND
		(<OR	.REF?
				<NOT <EQUAL? ,GL-WINDOW-TYPE ,K-WIN-STAT>>
			>
			<SET REF? T>
			<CLEAR 2>
			<CLEAR 5>
			<CLEAR 6>
		)
	>
	<SCREEN 2>
	<CURSET 1 <- <WINGET 2 ,K-W-XSIZE> <* 9 ,GL-FONT-X>>>
	<TELL "100">
	<SETG GL-WIN-Y <L-PIXELS 2>>
	<RT-BAR "Chivalry"   ,GL-SC-CHV .REF?>
	<RT-BAR "Wisdom"     ,GL-SC-WIS .REF?>
	<RT-BAR "Experience" ,GL-SC-EXP .REF?>
	<RT-BAR "Quest"      ,GL-SC-QST .REF?>
	<SETG GL-WINDOW-TYPE ,K-WIN-STAT>
	<SCREEN 0>
>

;"---------------------------------------------------------------------------"
; "Inventory window"
;"---------------------------------------------------------------------------"

<ROUTINE RT-PUT-UP-FOO (FOO "OPT" (BOLD? <>) (STR? <>) "AUX" W TBL)
	<SET W <- </ <ZGET ,K-WIN-TBL 2> 3> 1>>
	<SET TBL <ZREST ,K-DIROUT-TBL 2>>
	<COND
		(<OR	<G? ,GL-WIN-Y <ZGET ,K-WIN-TBL 1>>
				<G? ,GL-WIN-X <ZGET ,K-WIN-TBL 2>>
			>
			<RFALSE>
		)
	>
	<VERSION?
		(YZIP
			<CCURSET ,GL-WIN-Y ,GL-WIN-X>
		)
		(T
			<CURSET ,GL-WIN-Y ,GL-WIN-X>
		)
	>
	<ERASE <* .W ,GL-FONT-X>>
	<COND
		(.FOO
			<COND
				(.BOLD?
					<HLIGHT ,K-H-BLD>
				)
			>
			<COND
				(.STR?
					<TELL .FOO>
				)
				(T
					<TELL D .FOO>
				)
			>
			<HLIGHT ,K-H-NRM>
		)
	>
	<COND
		(<IGRTR? GL-WIN-Y <ZGET ,K-WIN-TBL 1>>
			<SETG GL-WIN-Y 1>
			<SETG GL-WIN-X <+ ,GL-WIN-X .W 2>>
		)
	>
	<INC GL-WIN-N>
	<RTRUE>
>

<ROUTINE RT-PUT-UP-OBJS (WORN? "AUX" (ANY? <>))
	<REPEAT ((OBJ <FIRST? ,CH-PLAYER>))
		<COND
			(<NOT .OBJ>
				<RETURN>
			)
			(<AND <NOT <FSET? .OBJ ,FL-NO-DESC>>
					<EQUAL? .WORN? <FSET? .OBJ ,FL-WORN>>
				>
				<SET ANY? T>
				<RT-PUT-UP-FOO .OBJ>
			)
		>
		<SET OBJ <NEXT? .OBJ>>
	>
	.ANY?
>

<ROUTINE RT-UPDATE-INVT-WINDOW ("OPT" (REF? <>) "AUX" WX WY W X Y I J K N)
	<SCREEN 2>
	<WINATTR 2 ,A-WRAP ,O-CLEAR>	;"Make window 2 not wrap."
	<SET WY </ <WINGET 2 ,K-W-YSIZE> ,GL-FONT-Y>>
	<SET WX </ <WINGET 2 ,K-W-XSIZE> ,GL-FONT-X>>
	<ZPUT ,K-WIN-TBL 1 .WY>
	<ZPUT ,K-WIN-TBL 2 .WX>
	<SET W <- </ .WX 3> 1>>
	<COND
		(<OR	.REF?
				<NOT <EQUAL? ,GL-WINDOW-TYPE ,K-WIN-INVT>>
			>
			<CLEAR 2>
			<CLEAR 5>
			<CLEAR 6>
			<REPEAT ((Y 0) (X <+ .W 1>))
				<COND
					(<IGRTR? Y .WY>
						<SET Y 1>
						<SET X <+ .X .W 2>>
						<COND
							(<G? <+ .X .W 1> .WX>
								<RETURN>
							)
						>
					)
				>
				<CCURSET .Y .X>
				<HLIGHT ,K-H-INV>
				<TELL " ">
				<HLIGHT ,K-H-NRM>
			>
			<SET J 0>
			<SET K 0>
		)
		(T
			<SET J <BAND <SHIFT ,GL-WIN-N -8> 255>>
			<SET K <BAND ,GL-WIN-N 255>>
		)
	>
	<SETG GL-WIN-N 0>
	<SETG GL-WIN-Y 1>
	<SETG GL-WIN-X 1>
	<RT-PUT-UP-FOO "You are carrying:" T T>
	<COND
		(<NOT <RT-PUT-UP-OBJS <>>>
			<RT-PUT-UP-FOO "nothing" <> T>
		)
	>
	<SET N ,GL-WIN-N>
	<SET X ,GL-WIN-X>
	<SET Y ,GL-WIN-Y>
	<SET I ,GL-WIN-N>
	<REPEAT ()
		<COND
			(<G=? .I .J>
				<RETURN>
			)
			(T
				<RT-PUT-UP-FOO <>>
				<INC I>
			)
		>
	>
	<SETG GL-WIN-N .N>
	<SETG GL-WIN-X .X>
	<SETG GL-WIN-Y .Y>
	<SET J ,GL-WIN-N>
	<COND
		(<AND <G? ,GL-WIN-Y 1>
				<L=? <+ ,GL-WIN-X <* .W 2> 1> .WX>
			>
			<COND
				(<AND <L? .J .K>
						<EQUAL? </ .K .WY> </ .J .WY>>
					>
					<SET N ,GL-WIN-N>
					<SET X ,GL-WIN-X>
					<SET Y ,GL-WIN-Y>
					<SET I ,GL-WIN-N>
					<REPEAT ()
						<COND
							(<G=? .I .K>
								<RETURN>
							)
							(T
								<RT-PUT-UP-FOO <>>
								<INC I>
							)
						>
					>
					<SETG GL-WIN-N .N>
					<SETG GL-WIN-X .X>
					<SETG GL-WIN-Y .Y>
				)
			>
			<SETG GL-WIN-N <+ ,GL-WIN-N <- .WY ,GL-WIN-Y> 1>>
			<SETG GL-WIN-X <+ ,GL-WIN-X .W 2>>
			<SETG GL-WIN-Y 1>
		)
	>
	<RT-PUT-UP-FOO "You are wearing:" T T>
	<COND
		(<NOT <RT-PUT-UP-OBJS T>>
			<RT-PUT-UP-FOO "nothing" <> T>
		)
	>
	<SET N ,GL-WIN-N>
	<SET X ,GL-WIN-X>
	<SET Y ,GL-WIN-Y>
	<COND
		(<L? </ ,GL-WIN-N .WY> </ .K .WY>>
			<SETG GL-WIN-N <+ ,GL-WIN-N <- .WY ,GL-WIN-Y> 1>>
			<SETG GL-WIN-X <+ ,GL-WIN-X .W 2>>
			<SETG GL-WIN-Y 1>
		)
	>
	<SET I ,GL-WIN-N>
	<REPEAT ()
		<COND
			(<G=? .I .K>
				<RETURN>
			)
			(T
				<RT-PUT-UP-FOO <>>
				<INC I>
			)
		>
	>
	<SETG GL-WIN-N .N>
	<SETG GL-WIN-X .X>
	<SETG GL-WIN-Y .Y>
	<SET K ,GL-WIN-N>
	<SETG GL-WIN-N <BOR <SHIFT .J 8> .K>>
	<SETG GL-UPDATE-WINDOW <BAND ,GL-UPDATE-WINDOW <BCOM ,K-UPD-INVT>>>
	<SETG GL-WINDOW-TYPE ,K-WIN-INVT>
	<SCREEN 0>
>

;"---------------------------------------------------------------------------"
; "Room description window"
;"---------------------------------------------------------------------------"

<ROUTINE RT-UPDATE-DESC-WINDOW ("OPT" (REF? <>) "AUX" Y Y1)
	<SCREEN 2>
	<WINATTR 2 ,A-WRAP ,O-SET>	;"Make window 2 wrap."
	<COND
		(<OR	.REF?
				<NOT <EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>>
				<BAND ,GL-UPDATE-WINDOW ,K-UPD-DESC>
			>
			<SET REF? T>
			<CLEAR 2>
			<CLEAR 5>
			<CLEAR 6>
			<CURSET 1 1>
			<COND
				(<DESCRIBE-ROOM T>
					<SETG GL-WIN-Y <WINGET -3 ,K-W-YCURPOS>>
					<SETG GL-WIN-N ,GL-WIN-Y>
				)
				(T
					<SETG GL-WIN-N -1>
				)
			>
			<SETG GL-UPDATE-WINDOW
				<BAND ,GL-UPDATE-WINDOW <BCOM ,K-UPD-DESC>>
			>
		)
	>
	<COND
		(<AND <NOT <EQUAL? ,GL-WIN-N -1>>
				<OR
					.REF?
					<BAND ,GL-UPDATE-WINDOW ,K-UPD-OBJS>
				>
			>
			<COND
				(<NOT .REF?>
					<SET Y ,GL-WIN-Y>
					<REPEAT ()
						<COND
							(<L? .Y ,GL-WIN-N>
								<CURSET .Y 1>
								<ERASE 1>
								<SET Y <+ .Y ,GL-FONT-Y>>
							)
							(T
								<RETURN>
							)
						>
					>
				)
			>
			<CURSET ,GL-WIN-Y 1>
			<RT-DESCRIBE-OBJECTS>
			<SETG GL-WIN-N <WINGET -3 ,K-W-YCURPOS>>
			<SETG GL-UPDATE-WINDOW <BAND ,GL-UPDATE-WINDOW <BCOM ,K-UPD-OBJS>>>
		)
	>
	<SETG GL-WINDOW-TYPE ,K-WIN-DESC>
	<SCREEN 0>
>

;"---------------------------------------------------------------------------"
; "Map window"
;"---------------------------------------------------------------------------"

<GLOBAL GL-MAP-GRID-X:NUMBER 0 <> BYTE>
<GLOBAL GL-MAP-GRID-Y:NUMBER 0 <> BYTE>

<CONSTANT K-MAP-BOG-TBL-NUM 1>
<CONSTANT K-MAP-BOG-Y 0>
<CONSTANT K-MAP-BOG-X 1>
<CONSTANT K-MAP-BOG-ENTRY-SIZE 2>
<CONSTANT K-MAP-ROOM 0>
<CONSTANT K-MAP-Y 1>
<CONSTANT K-MAP-X 2>
<CONSTANT K-MAP-ENTRY-SIZE 3>

<CONSTANT K-MAP-TBL
	<TABLE (PURE LENGTH)
		;"Bog map table - special case."
		<TABLE (BYTE LENGTH)
			3 3
			0 0
			0 0
			0 0
			0 0
		>
		<TABLE (PURE BYTE LENGTH)
			RM-TOWER-ROOM				1  4
			RM-CRACK-ROOM				2  3
			RM-LANDING					2  4
			RM-DEMON-HALL				2 13
			RM-STAIRS-1					3  4
			RM-HOT-ROOM					3 13
			RM-TOW-CLEARING			4  3
			RM-CIRC-ROOM				4  4
			RM-BAS-LAIR					4 12
			RM-ICE-ROOM					4 14
			RM-STAIRS-2					5  4
			RM-RAVEN-NEST				5  5
			RM-CAVE						5 13
		>
		<TABLE (PURE BYTE LENGTH)
			RM-GLADE						1  1
			RM-NORTH-OF-CHASM			1  2
			RM-CELLAR					1  4
			RM-RAVEN-TREE				1  5
			RM-LEDGE						1 13
			RM-CHESTNUT-PATH			2  1
			RM-SOUTH-OF-CHASM			2  2
			RM-GROVE						2  5
			RM-FOOT-OF-MOUNTAIN		2 12
			RM-LEP-PATH					3  2
			RM-TOW-PATH					3  3
			RM-RAV-PATH					3  4
			RM-BOG						3  8
			RM-WEST-OF-FORD			3  9
			RM-FORD						3 10
			RM-EAST-OF-FORD			3 11
			RM-ENCHANTED-FOREST		4  3
			RM-COTTAGE					4  6
			RM-EDGE-OF-BOG				4  7
			RM-EDGE-OF-WOODS			5  3
			RM-MOOR						5  6
			RM-RIVER-1					5 10
		>
		<TABLE (PURE BYTE LENGTH)
			RM-CRYSTAL-CAVE			1  1
			RM-ROAD						1  3
			RM-OUTSIDE-CRYSTAL-CAVE	2  1
			RM-FORK-IN-ROAD			2  4
			RM-CHURCHYARD				2  6
			RM-CHURCH					2  7
			RM-MERPATH					3  2
			RM-TOWN-GATE				3  4
			RM-VILLAGE-GREEN			3  5
			RM-TOWN-SQUARE				3  6
			RM-CASTLE-GATE				3  7
			RM-PARADE-AREA				3  8
			RM-GREAT-HALL				3  9
			RM-RIVER-2					3 11
			RM-MEADOW					4  3
			RM-PAVILION					4  4
			RM-TAVERN					4  6
			RM-SMITHY					4  7
			RM-ARMOURY					4  8
			RM-CAS-KITCHEN				4  9
			RM-FIELD-OF-HONOUR		5  4
			RM-END-OF-CAUSEWAY		5  5
			RM-TAV-KITCHEN				5  6
		>
		<TABLE (PURE BYTE LENGTH)
			RM-CAUSEWAY					1 5
			RM-SHALLOWS					2 4
			RM-ISLAND					2 5
			RM-UG-CHAMBER				3 5
			RM-RIVER-3					3 7
			RM-MID-LAKE					4 4
			RM-LAKE-WINDOW				4 5
			RM-BOAT-ROOM				5 3
			RM-INLET						5 5
		>
		<TABLE (PURE BYTE LENGTH)
			RM-BEHIND-THRONE			1 5
			RM-PASSAGE-2				2 5
			RM-BOTTOM-OF-STAIRS		3 1
			RM-HALL						3 2
			RM-END-OF-HALL				3 3
			RM-SMALL-CHAMBER			3 4
			RM-PASSAGE-1				3 5
			RM-HOLE						4 1
			RM-CELL						4 2
			RM-PASSAGE-3				4 5
			RM-BEHIND-FIRE				5 5
		>
		<TABLE (PURE BYTE LENGTH)
			RM-ABOVE-FOREST			1 2
			RM-ABOVE-MERCAVE			2 1
			RM-ABOVE-EDGE-OF-WOODS	2 2
			RM-ABOVE-MOOR				2 3
			RM-ABOVE-BOG				2 4
			RM-ABOVE-FORD				2 5
			RM-ABOVE-MEADOW			3 2
			RM-ABOVE-TOWN				3 3
			RM-ABOVE-CASTLE			3 4
			RM-ABOVE-FIELD				4 2
			RM-ABOVE-LAKE				5 2
		>
	>
>

<ROUTINE RT-UPDATE-MAP-WINDOW ("OPT" (REF? <>) "AUX" TBL PTR Y X)
	<COND
		(<ZERO? ,GL-MAP-GRID-Y>
			<PICINF ,K-MAP-GRID-SIZE ,K-WIN-TBL>
			<SETG GL-MAP-GRID-Y <ZGET ,K-WIN-TBL 0>>
			<SETG GL-MAP-GRID-X <ZGET ,K-WIN-TBL 1>>
		)
	>
	<SCREEN 2>
	<WINATTR 2 ,A-WRAP ,O-CLEAR>	;"Make window 2 not wrap."
	<COND
		(<OR	.REF?
				<NOT <EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>>
				<ZERO? ,GL-WIN-N>
			>
		; "Clear the window and redraw the map."
			<RT-REDRAW-MAP>
			<COND
				(<NOT <ZERO? ,GL-WIN-N>>
					<RT-DRAW-ROSE>
				)
			>
		)
		(T
		; "If the new HERE is in the table (in the window) then put it up and
			display its connections. Otherwise, find the new table (window) and
			redraw the map."
			<SET TBL <ZGET ,K-MAP-TBL ,GL-WIN-N>>
			<COND
				(<MC-HERE? ,RM-BOG>
					<COND
						(<EQUAL? ,GL-WIN-N ,K-MAP-BOG-TBL-NUM>
							<SET PTR <ZREST .TBL <+ <* ,GL-BOG-POS ,K-MAP-BOG-ENTRY-SIZE> 1>>>
						)
					>
				)
				(T
					<SET PTR
						<INTBL?
							,HERE
							<ZREST .TBL 1>
							</ <GETB .TBL 0> ,K-MAP-ENTRY-SIZE>
							,K-MAP-ENTRY-SIZE
						>
					>
				)
			>
			<COND
				(.PTR
				; "If there was an old here, erase it."
					<COND
						(<NOT <ZERO? ,GL-WIN-X>>
							<COND
								(<NOT <EQUAL? .PTR ,GL-WIN-X>>
									<SET Y <RT-GET-MAP-Y ,GL-WIN-X>>
									<SET X <RT-GET-MAP-X ,GL-WIN-X>>
									<PICINF ,K-MAP-ROOM-OFF ,K-WIN-TBL>
									<DISPLAY
										,K-MAP-NOT-HERE-ROOM
										<+ <RT-MAP-Y .Y> <ZGET ,K-WIN-TBL 0>>
										<+ <RT-MAP-X .X> <ZGET ,K-WIN-TBL 1>>
									>
								)
							>
						)
					>
					<SETG GL-WIN-X .PTR>
					<SET Y <RT-GET-MAP-Y .PTR>>
					<SET X <RT-GET-MAP-X .PTR>>
					<PICINF ,K-MAP-ROOM-OFF ,K-WIN-TBL>
					<DISPLAY
						,K-MAP-HERE-ROOM
						<+ <RT-MAP-Y .Y> <ZGET ,K-WIN-TBL 0>>
						<+ <RT-MAP-X .X> <ZGET ,K-WIN-TBL 1>>
					>
					<RT-DRAW-ROOM-CONNECTIONS ,HERE .Y .X>
					<RT-DRAW-ROSE>
				)
				(T
					<RT-REDRAW-MAP>
					<COND
						(<NOT <ZERO? ,GL-WIN-N>>
							<RT-DRAW-ROSE>
						)
					>
				)
			>
		)
	>
	<SETG GL-WINDOW-TYPE ,K-WIN-MAP>
	<SCREEN 0>
>

<ROUTINE RT-FIND-MAP-TBL (RM "AUX" (I 0) (N <ZGET ,K-MAP-TBL 0>) (TBL <>))
	<COND
		(<EQUAL? .RM ,RM-BOG>
			<RETURN ,K-MAP-BOG-TBL-NUM>
		)
		(T
			<REPEAT ()
				<COND
					(<DLESS? N 0>
						<RFALSE>
					)
					(T
						<INC I>
						<COND
							(<NOT <EQUAL? .I ,K-MAP-BOG-TBL-NUM>>
								<SET TBL <ZGET ,K-MAP-TBL .I>>
								<COND
									(<INTBL?
											,HERE
											<ZREST .TBL 1>
											</ <GETB .TBL 0> ,K-MAP-ENTRY-SIZE>
											,K-MAP-ENTRY-SIZE
										>
										<RETURN>
									)
								>
							)
						>
					)
				>
			>
			<RETURN .I>
		)
	>
>

<ROUTINE RT-REDRAW-MAP ("AUX" TBL PTR N Y X RM RM-ICON OLD-NUM)
	<CLEAR 2>
	<CLEAR 5>
	<CLEAR 6>
	<SETG GL-WIN-N <RT-FIND-MAP-TBL ,HERE>>
	<COND
		(<ZERO? ,GL-WIN-N>
			<DIROUT ,K-D-TBL-ON ,K-DIROUT-TBL>
			<TELL "Mapping is not available for this area.">
			<DIROUT ,K-D-TBL-OFF>
			<CURSET
				<+ </ <- <WINGET 2 ,K-W-YSIZE> ,GL-FONT-Y> 2> 1>
				<+ </ <- <WINGET 2 ,K-W-XSIZE> <LOWCORE TWID>> 2> 1>
			>
			<PRINTT <ZREST ,K-DIROUT-TBL 2> <ZGET ,K-DIROUT-TBL 0>>
		)
		(T
		; "Display background scroll."
			<SCREEN 7>
		;	<PICINF ,K-MAP-SCROLL-POS ,K-WIN-TBL>
			<DISPLAY ,K-MAP-SCROLL 1 1 ;"<ZGET ,K-WIN-TBL 0> <ZGET ,K-WIN-TBL 1>">
			<SCREEN 2>
			<MOUSE-LIMIT 2>

			<SET TBL <ZGET ,K-MAP-TBL ,GL-WIN-N>>
			<SET PTR <ZREST .TBL 1>>
			<COND
				(<EQUAL? ,GL-WIN-N ,K-MAP-BOG-TBL-NUM>
					<SET N </ <GETB .TBL 0> ,K-MAP-BOG-ENTRY-SIZE>>
					<SET OLD-NUM ,GL-BOG-POS>
					<SETG GL-BOG-POS 0>
				)
				(T
					<SET N </ <GETB .TBL 0> ,K-MAP-ENTRY-SIZE>>
				)
			>

			<SETG GL-WIN-X 0>
			<REPEAT ()
				<COND
					(<DLESS? N 0>
						<RETURN>
					)
					(T
						<SET RM-ICON <>>
						<COND
							(<EQUAL? ,GL-WIN-N ,K-MAP-BOG-TBL-NUM>
								<COND
									(<ZERO? <GETB .PTR 0>>
										<RETURN>
									)
									(<EQUAL? ,GL-BOG-POS .OLD-NUM>
										<SETG GL-WIN-X .PTR>
										<SET RM-ICON ,K-MAP-HERE-ROOM>
									)
									(T
										<SET RM-ICON ,K-MAP-NOT-HERE-ROOM>
									)
								>
								<SET RM ,RM-BOG>
							)
							(<SET RM <GETB .PTR ,K-MAP-ROOM>>
								<COND
									(<OR	<FSET? .RM ,FL-TOUCHED>
											<EQUAL? .RM ,HERE>
										>
										<COND
											(<EQUAL? .RM ,HERE>
												<SETG GL-WIN-X .PTR>
												<SET RM-ICON ,K-MAP-HERE-ROOM>
											)
											(T
												<SET RM-ICON ,K-MAP-NOT-HERE-ROOM>
											)
										>
									)
								>
							)
						>
						<COND
							(.RM-ICON
								<SET Y <RT-GET-MAP-Y .PTR>>
								<SET X <RT-GET-MAP-X .PTR>>
								<PICINF ,K-MAP-ROOM-OFF ,K-WIN-TBL>
								<DISPLAY
									.RM-ICON
									<+ <RT-MAP-Y .Y> <ZGET ,K-WIN-TBL 0>>
									<+ <RT-MAP-X .X> <ZGET ,K-WIN-TBL 1>>
								>
								<RT-DRAW-ROOM-CONNECTIONS .RM .Y .X>
							)
						>
						<COND
							(<EQUAL? ,GL-WIN-N ,K-MAP-BOG-TBL-NUM>
								<SET PTR <ZREST .PTR ,K-MAP-BOG-ENTRY-SIZE>>
								<INC GL-BOG-POS>
							)
							(T
								<SET PTR <ZREST .PTR ,K-MAP-ENTRY-SIZE>>
							)
						>
					)
				>
			>
			<COND
				(<EQUAL? ,GL-WIN-N ,K-MAP-BOG-TBL-NUM>
					<SETG GL-BOG-POS .OLD-NUM>
				)
			>
		)
	>
>

<GLOBAL GL-ROSE-Y:NUMBER 0>
<GLOBAL GL-ROSE-X:NUMBER 0>

<ROUTINE RT-DRAW-ROSE ("AUX" X Y (DIR 0) P D)
	<PICINF ,K-ROSE-BLANK ,K-WIN-TBL>
	<COND
		(<EQUAL? <LOWCORE INTID> ,MACINTOSH ,DEBUGGING-ZIP>
			<SET Y 3>
		)
		(T
			<SET Y 2>
		)
	>
	<SET X <- <WINGET 2 ,K-W-XSIZE> <ZGET ,K-WIN-TBL 1>>>
	<SETG GL-ROSE-Y .Y>
	<SETG GL-ROSE-X .X>
	<PICINF ,K-ROSE-OFF ,K-WIN-TBL>
	<DISPLAY
		,K-ROSE-BLANK
		<+ .Y <ZGET ,K-WIN-TBL 0>>
		<+ .X <ZGET ,K-WIN-TBL 1>>
	>
	<PICINF ,K-ROSE-DOWN-OFF ,K-WIN-TBL>
	<DISPLAY
		,K-ROSE-UP-DN-BLANK
		<+ .Y <ZGET ,K-WIN-TBL 0>>
		<+ .X <ZGET ,K-WIN-TBL 1>>
	>
	<PICINF ,K-ROSE-UP-OFF ,K-WIN-TBL>
	<DISPLAY
		,K-ROSE-UP-DN-BLANK
		<+ .Y <ZGET ,K-WIN-TBL 0>>
		<+ .X <ZGET ,K-WIN-TBL 1>>
	>
	<REPEAT ()
		<COND
			(<NOT <SET DIR <RT-GET-NEXT-DIR ,HERE .DIR T>>>
				<RETURN>
			)
			(<EQUAL? .DIR ,P?IN ,P?OUT>
				<AGAIN>
			)
		;	(<AND <EQUAL? .DIR ,P?UP>
					<NOT <EQUAL? .RM
,RM-CIRC-ROOM ,RM-STAIRS-1 ,RM-STAIRS-2 ,RM-CELLAR ,RM-UG-CHAMBER
,RM-RAVEN-TREE ,RM-GROVE ,RM-MEADOW ,RM-MERPATH>
					>
				>
				<AGAIN>
			)
		;	(<AND <EQUAL? .DIR ,P?DOWN>
					<NOT <EQUAL? .RM
,RM-CIRC-ROOM ,RM-LANDING ,RM-STAIRS-1 ,RM-STAIRS-2 ,RM-ISLAND ,RM-RAVEN-NEST
,RM-RAVEN-TREE ,RM-SMITHY ,RM-OUTSIDE-CRYSTAL-CAVE ,RM-MERPATH>
					>
				>
				<AGAIN>
			)
			(T
				<SET D <>>
				<COND
					(<EQUAL? ,GL-WIN-N ,K-MAP-BOG-TBL-NUM>
						<SET D T>
					)
					(<AND <RT-GET-DIR-INFO ,HERE .DIR>
							<GETB ,K-DIR-INFO-TBL 1>	; "Destination room"
							<NOT <GETB ,K-DIR-INFO-TBL 2>>	; "Not closed?"
						>
						<SET D T>
					)
				>
				<COND
					(.D
						<COND
							(<EQUAL? .DIR ,P?DOWN>
								<PICINF ,K-ROSE-DOWN-OFF ,K-WIN-TBL>
								<DISPLAY
									,K-ROSE-DOWN
									<+ .Y <ZGET ,K-WIN-TBL 0>>
									<+ .X <ZGET ,K-WIN-TBL 1>>
								>
							)
							(<EQUAL? .DIR ,P?UP>
								<PICINF ,K-ROSE-UP-OFF ,K-WIN-TBL>
								<DISPLAY
									,K-ROSE-UP
									<+ .Y <ZGET ,K-WIN-TBL 0>>
									<+ .X <ZGET ,K-WIN-TBL 1>>
								>
							)
							(T
								<COND
									(<EQUAL? .DIR ,P?NORTH>
										<SET P ,K-ROSE-NORTH>
									)
									(<EQUAL? .DIR ,P?NE>
										<SET P ,K-ROSE-NE>
									)
									(<EQUAL? .DIR ,P?EAST>
										<SET P ,K-ROSE-EAST>
									)
									(<EQUAL? .DIR ,P?SE>
										<SET P ,K-ROSE-SE>
									)
									(<EQUAL? .DIR ,P?SOUTH>
										<SET P ,K-ROSE-SOUTH>
									)
									(<EQUAL? .DIR ,P?SW>
										<SET P ,K-ROSE-SW>
									)
									(<EQUAL? .DIR ,P?WEST>
										<SET P ,K-ROSE-WEST>
									)
									(<EQUAL? .DIR ,P?NW>
										<SET P ,K-ROSE-NW>
									)
								>
								<PICINF ,K-ROSE-OFF ,K-WIN-TBL>
								<DISPLAY
									.P
									<+ .Y <ZGET ,K-WIN-TBL 0>>
									<+ .X <ZGET ,K-WIN-TBL 1>>
								>
							)
						>
					)
				>
			)
		>
	>
	<RTRUE>
>

; "These two routines convert from map coordinates to window coordinates."

<ROUTINE RT-MAP-Y (Y)
	<RETURN <+ <* <- .Y 1> ,GL-MAP-GRID-Y> 1>>
>

<ROUTINE RT-MAP-X (X)
	<RETURN <+ <* <- .X 1> ,GL-MAP-GRID-X> 1>>
>

<ROUTINE RT-GET-MAP-Y (PTR)
	<COND
		(<EQUAL? ,GL-WIN-N ,K-MAP-BOG-TBL-NUM>
			<GETB .PTR ,K-MAP-BOG-Y>
		)
		(T
			<GETB .PTR ,K-MAP-Y>
		)
	>
>

<ROUTINE RT-GET-MAP-X (PTR)
	<COND
		(<EQUAL? ,GL-WIN-N ,K-MAP-BOG-TBL-NUM>
			<GETB .PTR ,K-MAP-BOG-X>
		)
		(T
			<GETB .PTR ,K-MAP-X>
		)
	>
>

<CONSTANT K-DIR-INFO-TBL
	<TABLE (BYTE)
		0	; "Dir type"
		0	; "Destination room"
		0	; "Blocked?"
	>
>

<ROUTINE RT-GET-DIR-INFO (RM DIR "AUX" P PS OD)
	<COND
		(<SET P <GETPT .RM .DIR>>
			<PUTB ,K-DIR-INFO-TBL 0 0>
			<PUTB ,K-DIR-INFO-TBL 1 <>>
			<PUTB ,K-DIR-INFO-TBL 2 <>>
			<COND
				(<NOT <EQUAL? ,GL-WIN-N ,K-MAP-BOG-TBL-NUM>>
					<SET PS <PTSIZE .P>>
					<PUTB ,K-DIR-INFO-TBL 0 .PS>
					<COND
						(<EQUAL? .RM ,RM-BOG>	; "Bog connectors are hard-coded."
							<COND
								(<EQUAL? .DIR ,P?EAST>
									<PUTB ,K-DIR-INFO-TBL 1 ,RM-WEST-OF-FORD>
								)
								(<EQUAL? .DIR ,P?SW>
									<PUTB ,K-DIR-INFO-TBL 1 ,RM-EDGE-OF-BOG>
								)
							>
						)
						(<EQUAL? .PS ,NEXIT>)
						(<EQUAL? .PS ,FEXIT>
							<SET OD ,P-WALK-DIR>
							<SETG P-WALK-DIR .DIR>
							<PUTB ,K-DIR-INFO-TBL 1 <APPLY <GET .P ,FEXITFCN> T>>
							<SETG P-WALK-DIR .OD>
						)
						(<EQUAL? .PS ,DEXIT>
							<PUTB ,K-DIR-INFO-TBL 1 <GET/B .P ,REXIT>>
							<COND
								(<NOT <FSET? <GET/B .P ,DEXITOBJ> ,FL-OPEN>>
									<PUTB ,K-DIR-INFO-TBL 2 T>
								)
							>
						)
						(<EQUAL? .PS ,UEXIT ,CEXIT>
							<PUTB ,K-DIR-INFO-TBL 1 <GET/B .P ,REXIT>>
						)
					>
				)
			>
			<RTRUE>
		)
	>
>

<ROUTINE RT-GET-NEXT-DIR (RM DIR "OPT" (ROSE? <>))
	<COND
		(<EQUAL? ,GL-WIN-N ,K-MAP-BOG-TBL-NUM>
			<COND
				(<EQUAL? ,GL-BOG-POS ,K-BOG-NUM>
					<COND
						(<ZERO? .DIR>
							<RETURN ,P?EAST>
						)
						(.ROSE?
							<COND
								(<EQUAL? .DIR ,P?EAST>
									<RETURN <RT-OPPOSITE-DIR <ZGET ,K-BOG-DIR-TBL <- ,GL-BOG-POS 1>>>>
								)
							>
						)
					>
				)
				(<ZERO? .DIR>
					<RETURN <ZGET ,K-BOG-DIR-TBL ,GL-BOG-POS>>
				)
				(<AND .ROSE?
						<G? ,GL-BOG-POS 0>
						<EQUAL? .DIR <ZGET ,K-BOG-DIR-TBL ,GL-BOG-POS>>
					>
					<RETURN <RT-OPPOSITE-DIR <ZGET ,K-BOG-DIR-TBL <- ,GL-BOG-POS 1>>>>
				)
				(<EQUAL? ,GL-BOG-POS 0>
					<COND
						(<NOT <EQUAL? .DIR ,P?SW>>
							<RETURN ,P?SW>
						)
					>
				)
			>
		)
		(<EQUAL? .RM ,RM-BOG>	; "Bog connectors are hard-coded."
			<COND
				(<ZERO? .DIR>
					<RETURN ,P?EAST>
				)
				(<EQUAL? .DIR ,P?EAST>
					<RETURN ,P?SW>
				)
			>
		)
		(<OR	<ZERO? <SET DIR <NEXTP .RM .DIR>>>
				<L? .DIR ,LOW-DIRECTION>
			>
			<RFALSE>
		)
		(T
			<RETURN .DIR>
		)
	>
>

<ROUTINE RT-OPPOSITE-DIR (DIR)
	<COND
		(<EQUAL? .DIR ,P?NORTH>
			<RETURN ,P?SOUTH>
		)
		(<EQUAL? .DIR ,P?NE>
			<RETURN ,P?SW>
		)
		(<EQUAL? .DIR ,P?EAST>
			<RETURN ,P?WEST>
		)
		(<EQUAL? .DIR ,P?SE>
			<RETURN ,P?NW>
		)
		(<EQUAL? .DIR ,P?SOUTH>
			<RETURN ,P?NORTH>
		)
		(<EQUAL? .DIR ,P?SW>
			<RETURN ,P?NE>
		)
		(<EQUAL? .DIR ,P?WEST>
			<RETURN ,P?EAST>
		)
		(<EQUAL? .DIR ,P?NW>
			<RETURN ,P?SE>
		)
		(<EQUAL? .DIR ,P?UP>
			<RETURN ,P?DOWN>
		)
		(<EQUAL? .DIR ,P?DOWN>
			<RETURN ,P?UP>
		)
		(<EQUAL? .DIR ,P?IN>
			<RETURN ,P?OUT>
		)
		(<EQUAL? .DIR ,P?OUT>
			<RETURN ,P?IN>
		)
	>
>

; "The following routine displays all the connections from the given room."

<ROUTINE RT-DRAW-ROOM-CONNECTIONS (RM Y X "AUX" (DIR 0) P PS (TO-RM <>) TBL CLSD? OD)
	<SET OD ,P-WALK-DIR>
	<SET TBL <ZGET ,K-MAP-TBL ,GL-WIN-N>>

;	<SCREEN 0>
;	<TELL D .RM " @ " N .Y "," N .X ":">
;	<SCREEN 2>

	<REPEAT ()
		<SET CLSD? <>>

		<COND
			(<NOT <SET DIR <RT-GET-NEXT-DIR .RM .DIR>>>
				<RETURN>
			)
		>
		<SETG P-WALK-DIR .DIR>

	;	<SCREEN 0>
	;	<TELL " ">
	;	<RT-DIR-NAME-MSG .DIR>
	;	<SCREEN 2>

		<COND
			(<EQUAL? .DIR ,P?IN ,P?OUT>
				<AGAIN>
			)
			(<AND <EQUAL? .DIR ,P?UP>
					<NOT <EQUAL? .RM
,RM-CIRC-ROOM ,RM-STAIRS-1 ,RM-STAIRS-2 ,RM-CELLAR ,RM-UG-CHAMBER
,RM-RAVEN-TREE ,RM-GROVE>
					>
				>
				<AGAIN>
			)
			(<AND <EQUAL? .DIR ,P?DOWN>
					<NOT <EQUAL? .RM
,RM-CIRC-ROOM ,RM-LANDING ,RM-STAIRS-1 ,RM-STAIRS-2 ,RM-ISLAND ,RM-RAVEN-NEST
,RM-RAVEN-TREE ,RM-SMITHY>
					>
				>
				<AGAIN>
			)
			(<NOT <EQUAL? ,GL-WIN-N ,K-MAP-BOG-TBL-NUM>>
				<COND
					(<NOT <RT-GET-DIR-INFO .RM .DIR>>
					;	<SCREEN 0>
					;	<TELL "-INFO">
					;	<SCREEN 2>

						<AGAIN>
					)
					(<NOT <SET TO-RM <GETB ,K-DIR-INFO-TBL 1>>>
					;	<SCREEN 0>
					;	<TELL "-ROOM">
					;	<SCREEN 2>

						<AGAIN>
					)
				>
				<SET PS <GETB ,K-DIR-INFO-TBL 0>>
				<SET CLSD? <GETB ,K-DIR-INFO-TBL 2>>
				<COND
					; "Special case for castle gate."
					(<OR	<AND
								<EQUAL? .RM ,RM-PARADE-AREA>
								<EQUAL? .DIR ,P?WEST>
							>
							<AND
								<EQUAL? .RM ,RM-CASTLE-GATE>
								<EQUAL? .DIR ,P?EAST>
							>
						>
						<SET CLSD? 1>
					;	<COND
							(<NOT <SET TO-RM <GET/B .P ,REXIT>>>
								<AGAIN>
							)
						>
					)
				>
				<COND
					(<EQUAL? .DIR ,P?SOUTH ,P?EAST ,P?NE ,P?SE ,P?DOWN>
						<COND
							(<FSET? .TO-RM ,FL-TOUCHED>
								<COND
									(<INTBL?
											.TO-RM
											<ZREST .TBL 1>
											</ <GETB .TBL 0> ,K-MAP-ENTRY-SIZE>
											,K-MAP-ENTRY-SIZE
										>
										<AGAIN>
									)
								>
							)
						>
					)
				>
			)
		>
		<RT-DRAW-CONNECTOR .RM .Y .X .TO-RM .CLSD?>
	>
	<SETG P-WALK-DIR .OD>

;	<SCREEN 0>
;	<CRLF>
;	<SCREEN 2>
>

;<ROUTINE RT-DIR-NAME-MSG (DIR)
	<COND
		(<EQUAL? ,P-WALK-DIR ,P?NORTH ,P?NW ,P?NE>
			<TELL "north">
		)
		(<EQUAL? ,P-WALK-DIR ,P?SOUTH ,P?SW ,P?SE>
			<TELL "south">
		)
		(<EQUAL? ,P-WALK-DIR ,P?UP>
			<TELL "up">
		)
		(<EQUAL? ,P-WALK-DIR ,P?DOWN>
			<TELL "down">
		)
	>
	<COND
		(<EQUAL? ,P-WALK-DIR ,P?EAST ,P?NE ,P?SE>
			<TELL "east">
		)
		(<EQUAL? ,P-WALK-DIR ,P?WEST ,P?NW ,P?SW>
			<TELL "west">
		)
	>
>

;<ROUTINE RT-DIR-LETTER-MSG (DIR)
	<COND
		(<EQUAL? ,P-WALK-DIR ,P?NORTH ,P?NW ,P?NE>
			<TELL "N">
		)
		(<EQUAL? ,P-WALK-DIR ,P?SOUTH ,P?SW ,P?SE>
			<TELL "S">
		)
		(<EQUAL? ,P-WALK-DIR ,P?UP>
			<TELL "UP">
		)
		(<EQUAL? ,P-WALK-DIR ,P?DOWN>
			<TELL "DN">
		)
	>
	<COND
		(<EQUAL? ,P-WALK-DIR ,P?EAST ,P?NE ,P?SE>
			<TELL "E">
		)
		(<EQUAL? ,P-WALK-DIR ,P?WEST ,P?NW ,P?SW>
			<TELL "W">
		)
	>
>

<ROUTINE RT-DRAW-CONNECTOR (RM Y X TO-RM CLSD? "AUX" TBL ICON BIG TO-Y TO-X)
	<COND
		(<EQUAL? ,P-WALK-DIR ,P?NORTH ,P?SOUTH>
			<COND
			;	(<EQUAL? .CLSD? 2>
					<SET ICON ,K-MAP-BLANK-CONN>
					<SET BIG ,K-MAP-BIG-BLANK-CONN>
				)
				(T
					<COND
						(.CLSD?
							<SET ICON ,K-MAP-N-S-CLSD>
						)
						(T
							<SET ICON ,K-MAP-N-S-CONN>
						)
					>
					<SET BIG ,K-MAP-BIG-N-S-CONN>
				)
			>
			<COND
				(<EQUAL? ,P-WALK-DIR ,P?NORTH>
					<PICINF ,K-MAP-N-OFF ,K-WIN-TBL>
				)
				(T
					<PICINF ,K-MAP-S-OFF ,K-WIN-TBL>
				)
			>
		)
		(<EQUAL? ,P-WALK-DIR ,P?EAST ,P?WEST>
			<COND
			;	(<EQUAL? .CLSD? 2>
					<SET ICON ,K-MAP-BLANK-CONN>
					<SET BIG ,K-MAP-BIG-BLANK-CONN>
				)
				(T
					<COND
						(.CLSD?
							<SET ICON ,K-MAP-E-W-CLSD>
						)
						(T
							<SET ICON ,K-MAP-E-W-CONN>
						)
					>
					<SET BIG ,K-MAP-BIG-E-W-CONN>
				)
			>
			<COND
				(<EQUAL? ,P-WALK-DIR ,P?EAST>
					<PICINF ,K-MAP-E-OFF ,K-WIN-TBL>
				)
				(T
					<PICINF ,K-MAP-W-OFF ,K-WIN-TBL>
				)
			>
		)
		(<EQUAL? ,P-WALK-DIR ,P?NE ,P?SW>
			<COND
			;	(<EQUAL? .CLSD? 2>
					<SET ICON ,K-MAP-BLANK-CONN>
					<SET BIG ,K-MAP-BIG-BLANK-CONN>
				)
				(T
					<COND
						(<OR	<AND
									<EQUAL? .RM ,RM-ABOVE-MEADOW>
									<EQUAL? ,P-WALK-DIR ,P?NE>
								>
								<AND
									<EQUAL? .RM ,RM-ABOVE-MOOR>
									<EQUAL? ,P-WALK-DIR ,P?SW>
								>
							>
							<COND
								(<OR	<FSET? ,RM-ABOVE-EDGE-OF-WOODS ,FL-TOUCHED>
										<FSET? ,RM-ABOVE-TOWN ,FL-TOUCHED>
									>
									<SET ICON ,K-MAP-NW-SW-CONN>
								)
								(T
									<SET ICON ,K-MAP-NE-SW-CONN>
								)
							>
						)
						(<OR	<AND
									<EQUAL? .RM ,RM-ABOVE-TOWN>
									<EQUAL? ,P-WALK-DIR ,P?NE>
								>
								<AND
									<EQUAL? .RM ,RM-ABOVE-BOG>
									<EQUAL? ,P-WALK-DIR ,P?SW>
								>
							>
							<COND
								(<OR	<FSET? ,RM-ABOVE-MOOR ,FL-TOUCHED>
										<FSET? ,RM-ABOVE-CASTLE ,FL-TOUCHED>
									>
									<SET ICON ,K-MAP-NW-SW-CONN>
								)
								(T
									<SET ICON ,K-MAP-NE-SW-CONN>
								)
							>
						)
						(.CLSD?
							<SET ICON ,K-MAP-NE-SW-CLSD>
						)
						(T
							<SET ICON ,K-MAP-NE-SW-CONN>
						)
					>
					<SET BIG ,K-MAP-BIG-NE-SW-CONN>
				)
			>
			<COND
				(<EQUAL? ,P-WALK-DIR ,P?NE>
					<PICINF ,K-MAP-NE-OFF ,K-WIN-TBL>
				)
				(T
					<PICINF ,K-MAP-SW-OFF ,K-WIN-TBL>
				)
			>
		)
		(<EQUAL? ,P-WALK-DIR ,P?NW ,P?SE>
			<COND
			;	(<EQUAL? .CLSD? 2>
					<SET ICON ,K-MAP-BLANK-CONN>
					<SET BIG ,K-MAP-BIG-BLANK-CONN>
				)
				(T
					<COND
						(<OR	<AND
									<EQUAL? .RM ,RM-ABOVE-EDGE-OF-WOODS>
									<EQUAL? ,P-WALK-DIR ,P?SE>
								>
								<AND
									<EQUAL? .RM ,RM-ABOVE-TOWN>
									<EQUAL? ,P-WALK-DIR ,P?NW>
								>
							>
							<COND
								(<OR	<FSET? ,RM-ABOVE-MEADOW ,FL-TOUCHED>
										<FSET? ,RM-ABOVE-MOOR ,FL-TOUCHED>
									>
									<SET ICON ,K-MAP-NW-SW-CONN>
								)
								(T
									<SET ICON ,K-MAP-NW-SE-CONN>
								)
							>
						)
						(<OR	<AND
									<EQUAL? .RM ,RM-ABOVE-MOOR>
									<EQUAL? ,P-WALK-DIR ,P?SE>
								>
								<AND
									<EQUAL? .RM ,RM-ABOVE-CASTLE>
									<EQUAL? ,P-WALK-DIR ,P?NW>
								>
							>
							<COND
								(<OR	<FSET? ,RM-ABOVE-BOG ,FL-TOUCHED>
										<FSET? ,RM-ABOVE-TOWN ,FL-TOUCHED>
									>
									<SET ICON ,K-MAP-NW-SW-CONN>
								)
								(T
									<SET ICON ,K-MAP-NW-SE-CONN>
								)
							>
						)
						(.CLSD?
							<SET ICON ,K-MAP-NW-SE-CLSD>
						)
						(T
							<SET ICON ,K-MAP-NW-SE-CONN>
						)
					>
					<SET BIG ,K-MAP-BIG-NW-SE-CONN>
				)
			>
			<COND
				(<EQUAL? ,P-WALK-DIR ,P?NW>
					<PICINF ,K-MAP-NW-OFF ,K-WIN-TBL>
				)
				(T
					<PICINF ,K-MAP-SE-OFF ,K-WIN-TBL>
				)
			>
		)
		(<EQUAL? ,P-WALK-DIR ,P?UP ,P?DOWN>
			<SET ICON ,K-MAP-UP-N-CONN>
			<SET BIG ,K-MAP-BIG-UP-N-CONN>
			<COND
				(<EQUAL? ,P-WALK-DIR ,P?UP>
					<PICINF ,K-MAP-UP-OFF ,K-WIN-TBL>
				)
				(T
					<PICINF ,K-MAP-DN-OFF ,K-WIN-TBL>
				)
			>
		)
	>
	<COND
		(<EQUAL? ,GL-WIN-N ,K-MAP-BOG-TBL-NUM>)
		(<AND .TO-RM
				<SET TBL
					<INTBL?
						.TO-RM
						<ZREST <SET TBL <ZGET ,K-MAP-TBL ,GL-WIN-N>> 1>
						</ <GETB .TBL 0> ,K-MAP-ENTRY-SIZE>
						,K-MAP-ENTRY-SIZE
					>
				>
			>
			<SET TO-Y <GETB .TBL ,K-MAP-Y>>
			<SET TO-X <GETB .TBL ,K-MAP-X>>
		)
		(<EQUAL? ,P-WALK-DIR ,P?NORTH ,P?UP>
			<SET TO-Y 0>
			<SET TO-X .X>
		)
		(<EQUAL? ,P-WALK-DIR ,P?SOUTH ,P?DOWN>
			<SET TO-Y 6>
			<SET TO-X .X>
		)
		(<EQUAL? ,P-WALK-DIR ,P?EAST>
			<SET TO-Y .Y>
			<SET TO-X <+ .X 1>>
		)
		(<EQUAL? ,P-WALK-DIR ,P?WEST>
			<SET TO-Y .Y>
			<SET TO-X <- .X 1>>
		)
		(<EQUAL? ,P-WALK-DIR ,P?NE>
			<SET TO-Y 0>
			<SET TO-X <+ .X .Y>>
		)
		(<EQUAL? ,P-WALK-DIR ,P?NW>
			<SET TO-Y 0>
			<SET TO-X <- .X .Y>>
		)
		(<EQUAL? ,P-WALK-DIR ,P?SE>
			<SET TO-Y 6>
			<SET TO-X <+ .X <- 6 .Y>>>
		)
		(<EQUAL? ,P-WALK-DIR ,P?SW>
			<SET TO-Y 6>
			<SET TO-X <- .X <- 6 .Y>>>
		)
	>
	<REPEAT ()

	;	<SCREEN 0>
	;	<RT-DIR-LETTER-MSG ,P-WALK-DIR>
	;	<TELL ": " N .Y "," N .X " - " N .TO-Y "," N .TO-X CR>
	;	<SCREEN 2>

		<DISPLAY
			.ICON
			<+ <RT-MAP-Y .Y> <ZGET ,K-WIN-TBL 0>>
			<+ <RT-MAP-X .X> <ZGET ,K-WIN-TBL 1>>
		>

		<COND
			(<EQUAL? ,GL-WIN-N ,K-MAP-BOG-TBL-NUM>
				<RETURN>
			)
			(<EQUAL? ,P-WALK-DIR ,P?NORTH ,P?NW ,P?NE ,P?UP>
				<COND
					(<DLESS? Y 1>
						<RETURN>
					)
				>
			)
			(<EQUAL? ,P-WALK-DIR ,P?SOUTH ,P?SW ,P?SE ,P?DOWN>
				<COND
					(<IGRTR? Y 5>
						<RETURN>
					)
				>
			)
		>
		<COND
			(<EQUAL? ,P-WALK-DIR ,P?WEST ,P?NW ,P?SW>
				<COND
					(<DLESS? X 1>
						<RETURN>
					)
				>
			)
			(<EQUAL? ,P-WALK-DIR ,P?EAST ,P?NE ,P?SE>
				<COND
					(<IGRTR? X 14>
						<RETURN>
					)
				>
			)
		>
		<COND
			(<AND <EQUAL? .Y .TO-Y>
					<EQUAL? .X .TO-X>
				>
				<RETURN>
			)
			(T
				<PICINF ,K-MAP-ROOM-OFF <ZREST ,K-WIN-TBL 4>>
				<DISPLAY
					.BIG
					<+ <RT-MAP-Y .Y> <ZGET ,K-WIN-TBL 2>>
					<+ <RT-MAP-X .X> <ZGET ,K-WIN-TBL 3>>
				>
			)
		>
	>
>

;"---------------------------------------------------------------------------"
; "Picture window"
;"---------------------------------------------------------------------------"

<ROUTINE RT-CENTER-PIC (N "OPT" (SAVE? <>) "AUX" X Y)
	<PICINF .N ,K-WIN-TBL>
	<SET Y <ZGET ,K-WIN-TBL 0>>
	<SET X <ZGET ,K-WIN-TBL 1>>
	<SET Y <+ </ <- <WINGET -3 ,K-W-YSIZE> .Y> 2> 1>>
	<SET X <+ </ <- <WINGET -3 ,K-W-XSIZE> .X> 2> 1>>
	<DISPLAY .N .Y .X>
	<COND
		(.SAVE?
			<SETG GL-WIN-N .N>
			<SETG GL-WIN-Y .Y>
			<SETG GL-WIN-X .X>
		)
	>
	<RTRUE>
>

<CONSTANT K-STAMP-PICTURES
	<TABLE (PURE BYTE LENGTH)
		,K-PIC-CHURCHYARD
		,K-PIC-GRAVESTONE
		,K-PIC-GLADE-ROCK
		,K-PIC-GIRL
		,K-PIC-DEMON
		,K-PIC-RAVEN-NEST
		,K-PIC-SOUTH-OF-CHASM
		,K-PIC-NORTH-OF-CHASM
		,K-PIC-CHAMBER
		,K-PIC-WINDOW
		,K-PIC-ISLAND
	>
>

<ROUTINE RT-UPDATE-PICT-WINDOW ("OPT" (REF? <>) "AUX" STAMP OFF ST? ;"DX DY")
	<SCREEN 2>
	<WINATTR 2 ,A-WRAP ,O-CLEAR>	;"Make window 2 not wrap."
	<COND
		(<OR	<NOT <EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>>
				<ZERO? ,GL-WIN-N>
				<AND
					<EQUAL? ,GL-WIN-N ,K-PIC-PARADE-AREA ,K-PIC-AIR-SCENE>
					<NOT <EQUAL? ,GL-PICTURE-NUM ,GL-WIN-N>>
				>
			>
			<SET REF? T>
		)
	>
	<COND
		(.REF?
			<CLEAR 2>
			<CLEAR 5>
			<CLEAR 6>
			<SCREEN 2>
		)
		(<G? ,GL-WIN-N 0>
			<COND
				(<NOT <EQUAL? ,GL-PICTURE-NUM ,GL-WIN-N>>
					<DCLEAR ,GL-WIN-N ,GL-WIN-Y ,GL-WIN-X>
				)
			>
		)
	>
	<COND
		(,GL-PICTURE-NUM
			<SET ST?
				<INTBL?
					,GL-PICTURE-NUM
					<ZREST ,K-STAMP-PICTURES 1>
					<GETB ,K-STAMP-PICTURES 0>
					1
				>
			>
			<COND
				(<OR .REF? .ST? <NOT <EQUAL? ,GL-PICTURE-NUM ,GL-WIN-N>>>
					<RT-CENTER-PIC ,GL-PICTURE-NUM T>
				)
			>
			<COND
				(.ST?
					; "Handle stamps."
					<COND
						(<EQUAL? ,GL-PICTURE-NUM ,K-PIC-CHURCHYARD>
							<COND
								(<IN? ,TH-STONE ,RM-CHURCHYARD>
									<SET OFF ,K-PIC-STONE-1-OFF>
									<SET STAMP ,K-PIC-STONE-1>
								)
							>
						)
						(<EQUAL? ,GL-PICTURE-NUM ,K-PIC-GRAVESTONE>
							<COND
								(<IN? ,TH-STONE ,RM-CHURCHYARD>
									<SET OFF ,K-PIC-STONE-2-OFF>
									<SET STAMP ,K-PIC-STONE-2>
								)
							>
						)
						(<EQUAL? ,GL-PICTURE-NUM ,K-PIC-GLADE-ROCK>
							<COND
								(<IN? ,CH-LEPRECHAUN ,RM-GLADE>
									<COND
										(<IN? ,TH-SPICE-BOTTLE ,CH-LEPRECHAUN>
											<SET OFF ,K-PIC-LEP-BOTTLE-OFF>
											<SET STAMP ,K-PIC-LEP-BOTTLE>
										)
										(T
											<SET OFF ,K-PIC-LEP-WALK-OFF>
											<SET STAMP ,K-PIC-LEP-WALK>
										)
									>
								)
							>
						)
						(<EQUAL? ,GL-PICTURE-NUM ,K-PIC-GIRL>
							<COND
								(<IN? ,TH-GOLD-KEY ,CH-GIRL>
									<SET OFF ,K-PIC-KEY-1-OFF>
									<SET STAMP ,K-PIC-KEY-1>
								)
							>
						)
						(<EQUAL? ,GL-PICTURE-NUM ,K-PIC-DEMON>
							<COND
								(<IN? ,TH-GOLD-KEY ,CH-DEMON>
									<SET OFF ,K-PIC-KEY-2-OFF>
									<SET STAMP ,K-PIC-KEY-2>
								)
							>
						)
						(<EQUAL? ,GL-PICTURE-NUM ,K-PIC-RAVEN-NEST>
							<COND
								(<OR	<IN? ,TH-RAVEN-EGG ,RM-RAVEN-NEST>
										<IN? ,TH-BRASS-EGG ,RM-RAVEN-NEST>
									>
									; "Stamp kludge"
								;	<COND
										(<EQUAL? <LOWCORE INTID> ,MACINTOSH>
											<SET DY 0>
											<SET DX 2>
										)
										(<EQUAL? <LOWCORE INTID> ,IBM>
											<SET DY 0>
											<SET DX 1>
										)
									>
									<SET OFF ,K-PIC-EGG-OFF>
									<SET STAMP ,K-PIC-EGG>
								)
							>
						)
						(<EQUAL? ,GL-PICTURE-NUM ,K-PIC-SOUTH-OF-CHASM>
							<COND
								(<NOT <FSET? ,TH-BOAR ,FL-ALIVE>>
									<SET OFF ,K-PIC-DEAD-BOAR-OFF>
									<SET STAMP ,K-PIC-DEAD-BOAR>
								)
							>
						)
						(<EQUAL? ,GL-PICTURE-NUM ,K-PIC-NORTH-OF-CHASM>
							<COND
								(<FSET? ,TH-BOAR ,FL-ALIVE>
									<COND
										(<ZERO? ,GL-BOAR-NUM>
											<SET OFF ,K-PIC-PACING-BOAR-OFF>
											<SET STAMP ,K-PIC-PACING-BOAR>
										)
										(<EQUAL? ,GL-BOAR-NUM 1>
											<SET OFF ,K-PIC-ALERT-BOAR-OFF>
											<SET STAMP ,K-PIC-ALERT-BOAR>
										)
										(T
											<SET OFF ,K-PIC-CHARGING-BOAR-OFF>
											<SET STAMP ,K-PIC-CHARGING-BOAR>
										)
									>
								)
							>
						)
						(<EQUAL? ,GL-PICTURE-NUM ,K-PIC-CHAMBER>
							<COND
								(<IN? ,TH-GAUNTLET ,TH-BIER>
									<COND
										(<NOT <FSET? ,TH-GAUNTLET ,FL-TOUCHED>>
											; "Stamp kludge"
										;	<COND
												(<EQUAL? <LOWCORE INTID> ,MACINTOSH>
													<SET DY 16>
													<SET DX 0>
												)
												(<EQUAL? <LOWCORE INTID> ,IBM>
													<SET DY 8>
													<SET DX 0>
												)
											>
											<SET OFF ,K-PIC-GAUNTLET1-OFF>
											<SET STAMP ,K-PIC-GAUNTLET1>
										)
									>
								)
							>
						)
						(<EQUAL? ,GL-PICTURE-NUM ,K-PIC-WINDOW>
							<COND
								(<IN? ,TH-GAUNTLET ,TH-BIER>
									<COND
										(<NOT <FSET? ,TH-GAUNTLET ,FL-TOUCHED>>
											<SET OFF ,K-PIC-GAUNTLET2-OFF>
											<SET STAMP ,K-PIC-GAUNTLET2>
										)
									>
								)
							>
						)
						(<EQUAL? ,GL-PICTURE-NUM ,K-PIC-ISLAND>
							<COND
								(<FSET? ,LG-SILVER-DOOR ,FL-OPEN>
									; "Stamp kludge"
								;	<COND
										(<EQUAL? <LOWCORE INTID> ,MACINTOSH>
											<SET DY 2>
											<SET DX 4>
										)
										(<EQUAL? <LOWCORE INTID> ,IBM>
											<SET DY 1>
											<SET DX 2>
										)
									>
									<SET OFF ,K-PIC-ISLAND-DOOR-OFF>
									<SET STAMP ,K-PIC-ISLAND-DOOR>
								)
							>
						)
					>
					<COND
						(.OFF
						;	<SCREEN 0>
						;	<TELL "Enter delta for stamp #" N .STAMP " (X,Y): ">
						;	<PUTB ,P-INBUF 1 0>
						;	<ZREAD ,P-INBUF ,P-LEXV>
						;	<SET PTR <ZREST ,P-LEXV 2>>
						;	<COND
								(<EQUAL? <NUMBER? .PTR> ,W?INT.NUM>
									<SET DX ,P-NUMBER>
									<SET PTR <ZREST .PTR 4>>
									<COND
										(<EQUAL? <ZGET .PTR 0> ,W?COMMA>
											<SET PTR <ZREST .PTR 4>>
										)
									>
									<COND
										(<EQUAL? <NUMBER? .PTR> ,W?INT.NUM>
											<SET DY ,P-NUMBER>
										)
									>
								)
							>
						;	<COND
								(<NOT <EQUAL? 0 .DX .DY>>
									<TELL "(" N .DX "," N .DY ")|">
								)
							>
						;	<SCREEN 2>
							<PICINF .OFF ,K-WIN-TBL>
							<DISPLAY
								.STAMP
								<+ ,GL-WIN-Y <ZGET ,K-WIN-TBL 0> ;.DY>
								<+ ,GL-WIN-X <ZGET ,K-WIN-TBL 1> ;.DX>
							>
						)
					>
				)
			>
		)
	>
	<COND
		(.REF?
			<SCREEN 7>
			<RT-CENTER-PIC ,K-PIC-BANNER>
			<SCREEN 2>
			<COND
				(<EQUAL? ,GL-PICTURE-NUM ,K-PIC-PARADE-AREA ,K-PIC-AIR-SCENE>
					<RT-CENTER-PIC ,GL-PICTURE-NUM T>
				)
			>
		)
	>
	<SETG GL-WINDOW-TYPE ,K-WIN-PICT>
	<SCREEN 0>
>

%<DEBUG-CODE <SYNTAX $P OBJECT = V-$P>>
%<DEBUG-CODE
	<ROUTINE V-$P ()
		<COND
			(<PICINF ,P-NUMBER ,K-WIN-TBL>
				<COND
					(<ZERO? ,P-NUMBER>
						<TELL "Last picture number is " N <ZGET ,K-WIN-TBL 0> "." CR>
					)
					(T
						<TELL N <ZGET ,K-WIN-TBL 0> "x" N <ZGET ,K-WIN-TBL 1> CR>
					)
				>
			)
			(T
				<TELL "No such picture." CR>
			)
		>
	>
>

%<DEBUG-CODE <SYNTAX $D OBJECT = V-$D>>
%<DEBUG-CODE
	<ROUTINE V-$D ()
		<COND
			(<PICINF ,P-NUMBER ,K-WIN-TBL>
				<SCREEN 7>
				<CLEAR 7>
				<RT-CENTER-PIC ,P-NUMBER>
				<INPUT 1>
				<SCREEN 0>
				<V-REFRESH <>>
			)
			(T
				<TELL "No such picture." CR>
			)
		>
	>
>

%<DEBUG-CODE <SYNTAX $SHOW = V-$SHOW>>
%<DEBUG-CODE
	<ROUTINE V-$SHOW ("AUX" P N C)
		<PICINF 0 ,K-WIN-TBL>
		<SET N <ZGET ,K-WIN-TBL 0>>
		<SET P 1>
		<REPEAT ()
			<COND
				(<PICINF .P ,K-WIN-TBL>
					<SCREEN 7>
					<CLEAR 7>
					<CURSET 1 1>
					<TELL
"Picture #" N .P ".  [Q]uit, [+F] to advance, [-B] to back up.|"
					>
					<RT-CENTER-PIC .P>
					<SET C <INPUT 1>>
					<COND
						(<EQUAL? .C !\q !\Q>
							<SCREEN 0>
							<V-$REFRESH <>>
							<RTRUE>
						)
						(<EQUAL? .C !\- !\b !\B>
							<COND
								(<DLESS? P 1>
									<SET P .N>
								)
							>
						)
						(T
							<COND
								(<IGRTR? P .N>
									<SET P 1>
								)
							>
						)
					>
				)
			>
		>
	>
>

%<DEBUG-CODE <SYNTAX $W OBJECT = V-$W>>
%<DEBUG-CODE
	<ROUTINE V-$W ("AUX" WIN A TMP)
		<SET WIN ,P-NUMBER>
		<COND
			(<OR	<L? .WIN 0>
					<G? .WIN 7>
				>
				<TELL "No such window." CR>
				<RTRUE>
			)
		>
		<TELL
"#" N .WIN " at " N <WINGET .WIN ,K-W-YPOS> "," N <WINGET .WIN ,K-W-XPOS>
"; size " N <WINGET .WIN ,K-W-YSIZE> "x" N <WINGET .WIN ,K-W-XSIZE>
		>
		<COND
			(<OR	<WINGET .WIN ,K-W-LMARG>
					<WINGET .WIN ,K-W-RMARG>
				>
				<TELL
" (" N <WINGET .WIN ,K-W-LMARG> "<->" N <WINGET .WIN ,K-W-RMARG> ")"
				>
			)
		>
		<COND
			(<SET TMP <WINGET .WIN ,K-W-HLIGHT>>
				<TELL "; HL=" N .TMP>
			)
		>
		<COND
			(<NOT <EQUAL? <SET TMP <WINGET .WIN ,K-W-COLOR>> 257>>
				<TELL "; C=" N <SHIFT .TMP -8> "," N <BAND .TMP 255>>
			)
		>
		<COND
			(<NOT <EQUAL? <SET TMP <WINGET .WIN ,K-W-FONT>> 0>>
				<TELL "; F=" N .TMP>
			)
		>
		<SET TMP <WINGET .WIN ,K-W-FONTSIZE>>
		<COND
			(<OR	<NOT <EQUAL? <SHIFT .TMP -8> ,GL-FONT-Y>>
					<NOT <EQUAL? <BAND .TMP 255> ,GL-FONT-X>>
				>
				<TELL "; FS=" N <SHIFT .TMP -8> "x" N <BAND .TMP 255>>
			)
		>
		<TELL
"; cursor " N <WINGET .WIN ,K-W-YCURPOS> "," N <WINGET .WIN ,K-W-XCURPOS>
"; line " N <WINGET .WIN ,K-W-MORE>
		>
		<COND
			(<AND <SET TMP <WINGET .WIN ,K-W-CRCNT>>
					<WINGET .WIN ,K-W-CRFCN>
				>
				<TELL "; CR=" N .TMP>
			)
		>
		<TELL "; ">
		<SET A <WINGET .WIN ,K-W-ATTR>>
		<COND
			(<ZERO? <BAND .A ,A-WRAP>>
				<TELL "-">
			)
			(T
				<TELL "+">
			)
		>
		<TELL "W,">
		<COND
			(<ZERO? <BAND .A ,A-SCROLL>>
				<TELL "-">
			)
			(T
				<TELL "+">
			)
		>
		<TELL "S,">
		<COND
			(<ZERO? <BAND .A ,A-SCRIPT>>
				<TELL "-">
			)
			(ELSE
				<TELL "+">
			)
		>
		<TELL "P,">
		<COND
			(<ZERO? <BAND .A ,A-BUFFER>>
				<TELL "-">
			)
			(ELSE
				<TELL "+">
			)
		>
		<TELL "B" CR>
	>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

