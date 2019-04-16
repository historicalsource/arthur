;"***************************************************************************"
; "game : Arthur"
; "file : HINTS.ZIL"
; "auth :   $Author:   RAB  $"
; "date :     $Date:   15 May 1989 19:40:14  $"
; "revs : $Revision:   1.50  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Hints"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

<FILE-FLAGS CLEAN-STACK?>

<GLOBAL GL-HINT-WARNING <> <> BYTE>
<GLOBAL GL-HINTS-OFF <> <> BYTE>

<SYNTAX HELP OFF OBJECT (FIND FL-ROOMS) = V-HINTS-NO>

<CONSTANT K-NO-HINTS-MSG "Hints have been disallowed for this session.">

<ROUTINE V-HINTS-NO ()
	<COND
		(<NOT <MC-PRSO? ,ROOMS>>
			<DONT-UNDERSTAND>
		)
		(T
			<SETG GL-HINTS-OFF T>
			<RT-AUTHOR-MSG ,K-NO-HINTS-MSG>
		)
	>
	<SETG CLOCK-WAIT T>
	<RFATAL>
>

%<DEBUG-CODE <SYNTAX $HINT = V-HINT>>

<ROUTINE V-HINT ("AUX" N (WHO <>))
	<COND
		(,GL-HINTS-OFF
		;	<RT-AUTHOR-MSG ,K-NO-HINTS-MSG>
			<TELL
"You look inside the crystal, but it has gone dark. Merlin's voice
echoes in your mind, \"Earlier, in the true spirit of adventure, you
disabled the hints. Go forward, therefore, and continue your quest.\"" CR
			>
		)
		(T
			<TELL
"You look inside the ball and see the hazy outline of a hint menu."
			>
			<COND
				(<NOT ,GL-HINT-WARNING>
					<SETG GL-HINT-WARNING T>
					<TELL
"||Merlin comes into the cave and says, \"You can get a hint simply by looking
in the crystal. But I know that sometimes you will be tempted to get a hint
before you really want or need to. Therefore, you may at any time during your
adventure type HINTS OFF, and I will make the crystal go dark. This will
disallow the seeking of help for the remainder of that session. If you still
want a hint now, then look once more into the crystal.\"||Merlin disappears.|"
					>
				)
				(T
					<TELL "..|">
					<INPUT 1 50 ,RT-STOP-READ>
					<DO-HINTS>
				;	<REPEAT ()
						<RT-INIT-HINT-SCREEN>
						<VERSION?
							(YZIP
								<CCURSET 5 1>
							)
							(T
								<CURSET 5 1>
							)
						>
						<RT-PUT-UP-QUESTIONS <>>	; "Put up chapters."
						<COND
							(<SET N <RT-SELECT-ONE ,GL-CHAPT-NUM>>
								<COND
									(<NOT <EQUAL? .N ,GL-CHAPT-NUM>>
										<SETG GL-QUEST-NUM 1>
									)
								>
								<SETG GL-CHAPT-NUM .N>
								<RT-PICK-QUESTION>
							)
							(T
								<RETURN>
							)
						>
					>
					<V-REFRESH <>>
				)
			>
		)
	>
	<SETG CLOCK-WAIT T>
	<RFATAL>
>

;[		;"Start of commented-out block."

<CONSTANT K-RETURN-SEE-HINT " RETURN = see hint">
<CONSTANT K-RETURN-SEE-HINT-LEN <LENGTH " RETURN = see hint">>

<CONSTANT K-Q-MAIN-MENU "Q = main menu">
<CONSTANT K-Q-MAIN-MENU-LEN <LENGTH "Q = main menu">>

<CONSTANT K-Q-RESUME-STORY "Q = Resume story">
<CONSTANT K-Q-RESUME-STORY-LEN <LENGTH "Q = Resume story">>

<CONSTANT K-INTELLI-HINTS "INTELLI-HINTS (tm)">
<CONSTANT K-INTELLI-HINTS-LEN <LENGTH "INTELLI-HINTS (tm)">>

<CONSTANT K-NEXT " N = Next">
<CONSTANT K-NEXT-LEN <LENGTH " N = Next">>

<CONSTANT K-PREVIOUS "P = Previous">
<CONSTANT K-PREVIOUS-LEN <LENGTH "P = Previous">>

;"zeroth (first) element is 5"
<GLOBAL GL-LINE-TABLE
	<PTABLE
		5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22
		5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22
	>
>

;"zeroth (first) element is 4"
<CONSTANT GL-COLUMN-TABLE
	<PTABLE
		3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3  3
	  23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23
	>
>

; "If the first argument is non-false, build a parallel impure table
   for storing the count of answers already seen; make it a constant
   under the given name."

<DEFINE20 CONSTRUCT-HINTS (COUNT-NAME "TUPLE" STUFF "AUX" (SS <>) (HL (T)) (HLL .HL) V (CL (T)) (CLL .CL) TCL TCLL)
	<REPEAT ((CT 0))
		<COND
			(<OR	<EMPTY? .STUFF>
					<TYPE? <1 .STUFF> STRING>
				>
				; "Chapter break"
				<COND
					(<NOT .SS>
						; "First one, just do setup"
						<SET SS .STUFF>
						<SET TCL (T)>
						<SET TCLL .TCL>
						<SET CT 0>
					)
					(T
						<SET V <SUBSTRUC .SS 0 <- <LENGTH .SS> <LENGTH .STUFF>>>>
						; "One chapter's worth"
						<SET HLL <REST <PUTREST .HLL (<EVAL <FORM PLTABLE !.V>>)>>>
						<COND
							(.COUNT-NAME
								<SET CLL
									<REST
										<PUTREST .CLL
											(<EVAL <FORM TABLE (BYTE) !<REST .TCL>>>)
										>
									>
								>
								<SET TCL (T)>
								<SET TCLL .TCL>
								<SET CT 0>
							)
						>
						<SET SS .STUFF>
					)
				>
				<COND
					(<EMPTY? .STUFF>
						<RETURN>
					)
				>
				<SET STUFF <REST .STUFF>>
			)
			(T
				<COND
					(.COUNT-NAME
						<COND
							(<1? <MOD <SET CT <+ .CT 1>> 2>>
								<SET TCLL <REST <PUTREST .TCLL (0)>>>
							)
						>
					)
				>
				<SET STUFF <REST .STUFF>>
			)
		>
	>
	<COND
		(.COUNT-NAME
			<EVAL
				<FORM CONSTANT .COUNT-NAME
					<EVAL <FORM PTABLE !<REST .CL>>>
				>
			>
		)
	>
	<EVAL <FORM PLTABLE !<REST .HL>>>
>

;"shows in HINT-TBL ltable which QUESTION it's on."
<GLOBAL GL-QUEST-NUM 1 <> BYTE>

;"shows in HINT-TBL ltable which CHAPTER it's on."
<GLOBAL GL-CHAPT-NUM 1 <> BYTE>

<ROUTINE RT-SELECT-ONE (N "AUX" (Q 1) P (MAX <ZGET ,K-HINT-ITEMS 0>))
	<REPEAT ((I 0))
		<COND
			(<IGRTR? I .MAX>
				<RETURN>
			)
			(<EQUAL? .N <ZGET ,K-HINT-ITEMS .I>>
				<SET Q .I>
				<RETURN>
			)
		>
	>
	<RT-NEW-CURSOR .Q>
	<REPEAT (CHR)
		<SET CHR <INPUT 1>>
		<COND
			(<EQUAL? .CHR ,K-CLICK1 ,K-CLICK2>
				<COND
					(<SET P <RT-MOUSE-SELECT>>
						<COND
							(<NOT <EQUAL? .P .Q>>
								<RT-ERASE-CURSOR .Q>
								<COND
									(<G? .P 0>
										<SET Q .P>
									)
									(<EQUAL? .P -1>	; "Clicked next"
										<COND
											(<EQUAL? .Q .MAX> ; "Wrap around on N"
												<SET Q 1>
											)
											(T
												<INC Q>
											)
										>
									)
									(<EQUAL? .P -2>	; "Clicked previous"
										<COND
											(<EQUAL? .Q 1>
												<SET Q .MAX>
											)
											(T
												<DEC Q>
											)
										>
									)
									(<EQUAL? .P -3>	; "Clicked see hint"
										<RETURN>
									)
									(<EQUAL? .P -4>	; "Clicked quit"
										<RFALSE>
									)
								>
								<RT-NEW-CURSOR .Q>
							)
						>
						<COND
							(<G? .P 0>
								<COND
									(<EQUAL? .CHR ,K-CLICK2>
										<RETURN>
									)
								>
							)
						>
					)
				>
			)
			(<EQUAL? .CHR !\Q !\q 27>
				<RFALSE>
			)
			(<EQUAL? .CHR !\N !\n ,K-DOWN>
				<RT-ERASE-CURSOR .Q>
				<COND
					(<EQUAL? .Q .MAX> ; "Wrap around on N"
						<SET Q 1>
					)
					(T
						<INC Q>
					)
				>
				<RT-NEW-CURSOR .Q>
			)
			(<EQUAL? .CHR !\P !\p ,K-UP>
				<RT-ERASE-CURSOR .Q>
				<COND
					(<EQUAL? .Q 1>
						<SET Q .MAX>
					)
					(T
						<DEC Q>
					)
				>
				<RT-NEW-CURSOR .Q>
			)
			(<EQUAL? .CHR 13 10 !\ >
				<RETURN>
			)
		>
	>
	<RETURN <GET ,K-HINT-ITEMS .Q>>
>

<ROUTINE RT-MOUSE-SELECT ("OPT" (HINT? <>) "AUX" X Y N)
	<SET Y </ <LOWCORE MSLOCY> ,GL-FONT-Y>>
	<SET X </ <LOWCORE MSLOCX> ,GL-FONT-X>>
	<COND
		(<EQUAL? .Y 2>
			<COND
				(.HINT?
					<RFALSE>
				)
				(<L? .X </ <LOWCORE SCRH> 2>>
					<RETURN -1>
				)
				(T
					<RETURN -2>
				)
			>
		)
		(<EQUAL? .Y 3>
			<COND
				(<L? .X </ <LOWCORE SCRH> 2>>
					<RETURN -3>
				)
				(T
					<RETURN -4>
				)
			>
		)
		(.HINT?
			<RFALSE>
		)
		(<AND <G=? .Y 5>
				<L=? .Y 22>
			>
			<SET N <- .Y 4>>
			<COND
				(<G=? .X 23>
					<SET N <+ .N 18>>
				)
			>
			<RETURN .N>
		)
	>
>

<ROUTINE RT-PICK-QUESTION ("AUX" N)
	<RT-INIT-HINT-SCREEN <>>
	<RT-JUSTIFY-LINE 3 ,K-RETURN-SEE-HINT ,K-J-LEFT>
	<RT-JUSTIFY-LINE 3 ,K-Q-MAIN-MENU ,K-J-RIGHT ,K-Q-MAIN-MENU-LEN>
	<VERSION?
		(YZIP
			<CCURSET 5 1>
		)
		(T
			<CURSET 5 1>
		)
	>
	<RT-PUT-UP-QUESTIONS>
	<COND
		(<SET N <RT-SELECT-ONE ,GL-QUEST-NUM>>
			<SETG GL-QUEST-NUM .N>
			<RT-DISPLAY-HINT>
			<AGAIN>
		)
	>
>

<ROUTINE RT-ERASE-CURSOR (N)
	<DEC N>
	<VERSION?
		(YZIP
			<CCURSET
				<GET ,GL-LINE-TABLE .N>
				<- <GET ,GL-COLUMN-TABLE .N> 2>
			>
		)
		(T
			<CURSET
				<GET ,GL-LINE-TABLE .N>
				<- <GET ,GL-COLUMN-TABLE .N> 2>
			>
		)
	>
	<TELL " ">	; "erase previous highlight cursor"
>

; "go back 2 spaces from question text, print cursor and flash is between
	the cursor and text"

<ROUTINE RT-NEW-CURSOR (N)
	<DEC N>
	<VERSION?
		(YZIP
			<CCURSET
				<GET ,GL-LINE-TABLE .N>
				<- <GET ,GL-COLUMN-TABLE .N> 2>
			>
		)
		(T
			<CURSET
				<GET ,GL-LINE-TABLE .N>
				<- <GET ,GL-COLUMN-TABLE .N> 2>
			>
		)
	>
	<TELL ">">	; "print the new cursor"
>

<ROUTINE RT-INVERSE-LINE ("AUX" TBL N)
	<HLIGHT ,K-H-INV>
	<SET N ,GL-SCR-WID>
	<SET TBL <REST ,K-DIROUT-TBL 2>>
	<PUTB .TBL 0 !\ >
	<COPYT .TBL <REST .TBL 1> <- .N>>
	<PRINTT .TBL .N>
	<HLIGHT ,K-H-NRM>
>

<ROUTINE RT-DISPLAY-HINT ("AUX" H MX (CNT 3) CHR (FLG T) N P CV SHIFT? COUNT-OFFS)
	<CLEAR -1>
	<VERSION?
		(YZIP
			<CSPLIT 3>
		)
		(T
			<SPLIT 3>
		)
	>
	<SCREEN ,K-S-WIN>
	<VERSION?
		(YZIP
			<CCURSET 1 1>
		)
		(T
			<CURSET 1 1>
		)
	>
	<RT-INVERSE-LINE>
	<RT-JUSTIFY-LINE 1 ,K-INTELLI-HINTS ,K-J-CENTER ,K-INTELLI-HINTS-LEN>
	<VERSION?
		(YZIP
			<CCURSET 2 1>
		)
		(T
			<CURSET 2 1>
		)
	>
	<RT-INVERSE-LINE>
	<HLIGHT ,K-H-BLD>
	<SET H <GET <GET ,K-HINTS ,GL-CHAPT-NUM> <+ ,GL-QUEST-NUM 1>>>
	; "Byte table to use for showing questions already seen"
	; "Actually a nibble table. The high four bits of each byte are for
      quest-num odd; the low for bits are for quest-num even. See SHIFT?
      and COUNT-OFFS."
	<SET CV <GET ,K-HINT-COUNTS <- ,GL-CHAPT-NUM 1>>>
	<RT-JUSTIFY-LINE 2 <GET .H 2> ,K-J-CENTER>
	<HLIGHT ,K-H-NRM>
	<VERSION?
		(YZIP
			<CCURSET 3 1>
		)
		(T
			<CURSET 3 1>
		)
	>
	<RT-INVERSE-LINE>
	<RT-JUSTIFY-LINE 3 "RETURN = see new hint" ,K-J-LEFT>
	<RT-JUSTIFY-LINE 3 "Q = see hint menu" ,K-J-RIGHT %<LENGTH "Q = see hint menu">>
	<SET MX <GET .H 0>>
	<SCREEN ,K-S-NOR>
	<CRLF>
	<SET SHIFT? <MOD ,GL-QUEST-NUM 2>>
	<SET COUNT-OFFS </ <- ,GL-QUEST-NUM 1> 2>>
	<REPEAT ((CURCX <GETB .CV .COUNT-OFFS>)
		(CURC <+ 2 <ANDB <COND (.SHIFT? <LSH .CURCX -4>) (T .CURCX)> *17*>>))
		<COND
			(<G=? .CNT .CURC>
				<RETURN>
			)
			(T
				<TELL <GET .H .CNT> CR ;CR>
				<SET CNT <+ .CNT 1>>
			)
		>
	>
	<REPEAT ()
		<COND
			(<AND .FLG <G? .CNT .MX>>
				<SET FLG <>>
				<TELL "[That's all.]" CR>
			)
			(.FLG
				<SET N <+ <- .MX .CNT> 1>>
				<TELL N .N ;" hint">
			;	<COND
					(<NOT <EQUAL? .N 1>>
						<TELL "s">
					)
				>
				<TELL " left > ">
				<SET FLG <>>
			)
		>
		<REPEAT ()
			<SET CHR <INPUT 1>>
			<COND
				(<EQUAL? .CHR ,K-CLICK1 ,K-CLICK2>
					<COND
						(<SET P <RT-MOUSE-SELECT T>>
							<COND
								(<EQUAL? .P -3>
									<SET CHR 13>
								)
								(<EQUAL? .P -4>
									<SET CHR !\Q>
								)
							>
						)
					>
				)
			>
			<COND
				(<EQUAL? .CHR !\Q !\q 27 13 10 !\ >
					<RETURN>
				)
			>
		>
		<COND
			(<EQUAL? .CHR !\Q !\q 27>
				<COND
					(.SHIFT?
						<PUTB .CV .COUNT-OFFS
							<ORB
								<ANDB <GETB .CV .COUNT-OFFS> *17*>
								<LSH <- .CNT 2> 4>
							>
						>
					)
					(T
						<PUTB .CV .COUNT-OFFS
							<ORB
								<ANDB <GETB .CV .COUNT-OFFS> *360*>
								<- .CNT 2>
							>
						>
					)
				>
				<RETURN>
			)
			(<EQUAL? .CHR 13 10 !\ >
				<COND
					(<L=? .CNT .MX>
						<SET FLG T>	;".cnt starts as 2"
						<TELL <GET .H .CNT> ;CR CR>
						; "3rd = line 7, 4th = line 9, ect"
						<COND
							(<IGRTR? CNT .MX>
								<SET FLG <>>
								<TELL "[Final hint]" CR>
							)
						>
					)
				>
			)
		>
	>
>

<CONSTANT K-HINT-ITEMS
	<TABLE
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
	>
>

<ROUTINE RT-SEE-QST? (OBJ)
	<COND
		(<NOT .OBJ>
			T
		)
		(<OR	<L=? .OBJ 0>
				<G? .OBJ ,LAST-OBJECT>
			>
			<APPLY .OBJ>
		)
		(<IN? .OBJ ,ROOMS>
			<FSET? .OBJ ,FL-TOUCHED>
		)
		(T
			<FSET? .OBJ ,FL-SEEN>
		)
	>
>

<ROUTINE RT-PUT-UP-QUESTIONS ("OPT" (QST? T) "AUX" MXQ MXL)
	<COND
		(.QST?
			<SET MXQ <- <GET <GET ,K-HINTS ,GL-CHAPT-NUM> 0> 1>>
		)
		(T
			<SET MXQ <GET ,K-HINTS 0>>
		)
	>
	<SET MXL <- <LOWCORE SCRV> 1>>
	<REPEAT ((N 0) (QN 1) OBJ QST P?)
		<COND
			(<IGRTR? .N .MXQ>
				<RETURN>
			)
			(T
				<COND
					(.QST?
						<SET OBJ <GET <GET <GET ,K-HINTS ,GL-CHAPT-NUM> <+ .N 1>> 1>>
						<SET P? <RT-SEE-QST? .OBJ>>
					)
					(T
						<SET P? <>>
						<REPEAT ((I 0) (MAX <- <GET <GET ,K-HINTS .N> 0> 1>))
							<COND
								(<IGRTR? .I .MAX>
									<RETURN>
								)
								(T
									<SET OBJ <GET <GET <GET ,K-HINTS .N> <+ .I 1>> 1>>
									<COND
										(<SET P? <RT-SEE-QST? .OBJ>>
											<RETURN>
										)
									>
								)
							>
						>
					)
				>
				<COND
					(.P?
						<VERSION?
							(YZIP
								<CCURSET
									<GET ,GL-LINE-TABLE <- .QN 1>>
									<- <GET ,GL-COLUMN-TABLE <- .QN 1>> 1>
								>
							)
							(T
								<CURSET
									<GET ,GL-LINE-TABLE <- .QN 1>>
									<- <GET ,GL-COLUMN-TABLE <- .QN 1>> 1>
								>
							)
						>
						<COND
							(.QST?
								<SET QST <GET <GET <GET ,K-HINTS ,GL-CHAPT-NUM> <+ .N 1>> 2>>
							)
							(T
								<SET QST <GET <GET ,K-HINTS .N> 1>>
							)
						>
						<TELL " " .QST>
						<ZPUT ,K-HINT-ITEMS .QN .N>
						<ZPUT ,K-HINT-ITEMS 0 .QN>
						<INC QN>
					)
				>
			)
		>
	>
>

<ROUTINE RT-INIT-HINT-SCREEN ("OPTIONAL" (THIRD T))
	<CLEAR -1>
	<VERSION?
		(YZIP
			<CSPLIT <- <LOWCORE SCRV> 1>>
		)
		(T
			<SPLIT <- <LOWCORE SCRV> 1>>
		)
	>
	<SCREEN ,K-S-WIN>
	<VERSION?
		(YZIP
			<CCURSET 1 1>
		)
		(T
			<CURSET 1 1>
		)
	>
	<RT-INVERSE-LINE>
	<VERSION?
		(YZIP
			<CCURSET 2 1>
		)
		(T
			<CURSET 2 1>
		)
	>
	<RT-INVERSE-LINE>
	<VERSION?
		(YZIP
			<CCURSET 3 1>
		)
		(T
			<CURSET 3 1>
		)
	>
	<RT-INVERSE-LINE>
	<RT-JUSTIFY-LINE 1 ,K-INTELLI-HINTS ,K-J-CENTER ,K-INTELLI-HINTS-LEN>
	<RT-JUSTIFY-LINE 2 ,K-NEXT ,K-J-LEFT>
	<RT-JUSTIFY-LINE 2 ,K-PREVIOUS ,K-J-RIGHT ,K-PREVIOUS-LEN>
	<COND
		(.THIRD
			<RT-JUSTIFY-LINE 3 ,K-RETURN-SEE-HINT ,K-J-LEFT>
			<RT-JUSTIFY-LINE 3 ,K-Q-RESUME-STORY ,K-J-RIGHT ,K-Q-RESUME-STORY-LEN>
		)
	>
>

<CONSTANT K-J-LEFT 0>
<CONSTANT K-J-CENTER 1>
<CONSTANT K-J-RIGHT 2>

<ROUTINE RT-JUSTIFY-LINE (LN STR TYPE "OPTIONAL" (LEN 0) (INV T) "AUX" COL)
	<COND
		(<ZERO? .LEN>
			<COND
				(<NOT <EQUAL? .TYPE ,K-J-LEFT>>
					<DIROUT ,K-D-TBL-ON ,K-DIROUT-TBL>
					<TELL .STR>
					<DIROUT ,K-D-TBL-OFF>
					<SET LEN <GET ,K-DIROUT-TBL 0>>
				)
			>
		)
	>
	<COND
		(<EQUAL? .TYPE ,K-J-LEFT>
			<SET COL 1>
		)
		(<EQUAL? .TYPE ,K-J-CENTER>
			<SET COL </ <- ,GL-SCR-WID .LEN> 2>>
		)
		(<EQUAL? .TYPE ,K-J-RIGHT>
			<SET COL <- ,GL-SCR-WID .LEN>>
		)
	>
	<VERSION?
		(YZIP
			<CCURSET .LN .COL>
		)
		(T
			<CURSET .LN .COL>
		)
	>
	<COND
		(.INV
			<HLIGHT ,K-H-INV>
		)
	>
	<TELL .STR>
	<COND
		(.INV
			<HLIGHT ,K-H-NRM>
		)
	>
>

]	;"End of commented-out block."

<ROUTINE RT-H-STONE-STOLEN? ()
	<RETURN <NOT <IN? ,TH-STONE ,RM-CHURCHYARD>>>
>

;<ROUTINE RT-H-LOT-ATTENTION-1? ()
	<RETURN <FSET? ,RM-GREAT-HALL ,FL-TOUCHED>>
>

<ROUTINE RT-H-LOT-ATTENTION-2? ()
	<RETURN
		<AND
			<FSET? ,RM-GREAT-HALL ,FL-TOUCHED>
			<FSET? ,TH-GAUNTLET ,FL-SEEN>
		>
	>
>

<ROUTINE RT-H-FIGHT-LOT? ()
	<RETURN <IN? ,CH-LOT ,RM-FIELD-OF-HONOUR>>
>

<ROUTINE RT-H-BEAT-LOT? ()
	<RETURN <FSET? ,CH-LOT ,FL-LOCKED>>
>

<ROUTINE RT-H-DEFEAT-LOT? ()
	<RETURN <AND <FSET? ,CH-LOT ,FL-BROKEN> <FSET? ,CH-LOT ,FL-LOCKED>>>
>

;<ROUTINE RT-H-I-KNIGHT-1? ()
	<RETURN <FSET? ,RM-MEADOW ,FL-TOUCHED>>
>

<ROUTINE RT-H-I-KNIGHT-2? ()
	<RETURN
		<AND
			<FSET? ,RM-MEADOW ,FL-TOUCHED>
			<FSET? ,TH-MAGIC-RING ,FL-SEEN>
		>
	>
>

;<ROUTINE RT-H-CASTLE-1? ()
	<RETURN <FSET? ,RM-CASTLE-GATE ,FL-TOUCHED>>
>

<ROUTINE RT-H-CASTLE-2? ()
	<RETURN
		<AND
			<FSET? ,RM-CASTLE-GATE ,FL-TOUCHED>
			<FSET? ,RM-HOLE ,FL-TOUCHED>
		>
	>
>

;<ROUTINE RT-H-PASSWORD-1? ()
	<RETURN
		<AND
			<FSET? ,RM-CASTLE-GATE ,FL-TOUCHED>
		;	<NOT <FSET? ,RM-CELL ,FL-TOUCHED>>
		;	<NOT <FSET? ,RM-HALL ,FL-TOUCHED>>
		>
	>
>

<ROUTINE RT-H-PASSWORD-2? ()
	<RETURN
		<AND
			<FSET? ,RM-CASTLE-GATE ,FL-TOUCHED>
			<FSET? ,RM-CELL ,FL-TOUCHED>
		;	<NOT <FSET? ,RM-HALL ,FL-TOUCHED>>
		>
	>
>

<ROUTINE RT-H-PASSWORD-3? ()
	<RETURN
		<AND
			<FSET? ,RM-CASTLE-GATE ,FL-TOUCHED>
			<FSET? ,RM-HALL ,FL-TOUCHED>
		>
	>
>

<ROUTINE RT-H-HEARD-PASSWORD? ()
	<RETURN <FSET? ,TH-PASSWORD ,FL-TOUCHED>>
>

<ROUTINE RT-H-PRISONER-OUT? ()
	<RETURN <FSET? ,CH-PRISONER ,FL-AIR>>
>

;<ROUTINE RT-H-PRISONER-1? ()
	<RETURN
		<AND
			<FSET? ,RM-CELL ,FL-TOUCHED>
		;	<NOT <FSET? ,CH-CELL-GUARD ,FL-SEEN>>
		>
	>
>

<ROUTINE RT-H-PRISONER-2? ()
	<RETURN
		<AND
			<FSET? ,RM-CELL ,FL-TOUCHED>
			<FSET? ,CH-CELL-GUARD ,FL-SEEN>
		>
	>
>

<ROUTINE RT-H-SWORD? ()
	<RETURN <NOT <FSET? ,TH-SWORD ,FL-LOCKED>>>
>

;<ROUTINE RT-H-BRACELET-1? ()
	<RETURN
		<AND
			<FSET? ,CH-KRAKEN ,FL-SEEN>
		;	<LOC ,CH-KRAKEN>
		>
	>
>

<ROUTINE RT-H-BRACELET-2? ()
	<RETURN
		<AND
			<FSET? ,CH-KRAKEN ,FL-SEEN>
			<NOT <LOC ,CH-KRAKEN>>
		>
	>
>

<ROUTINE RT-H-HEARD-MURMUR? ()
	<RETURN <FSET? ,TH-ROCK ,FL-BROKEN>>
>

;<ROUTINE RT-H-EGG-1? ()
	<RETURN
		<AND
			<FSET? ,TH-RAVEN-EGG ,FL-SEEN>
		;	<NOT <FSET? ,TH-BRASS-EGG ,FL-SEEN>>
		>
	>
>

<ROUTINE RT-H-EGG-2? ()
	<RETURN
		<AND
			<FSET? ,TH-RAVEN-EGG ,FL-SEEN>
			<FSET? ,TH-BRASS-EGG ,FL-SEEN>
		>
	>
>

;<ROUTINE RT-H-TOWER-1? ()
	<RETURN
		<AND
			<FSET? ,RM-TOW-CLEARING ,FL-TOUCHED>
		;	<NOT <FSET? ,TH-IVORY-KEY ,FL-SEEN>>
		>
	>
>

<ROUTINE RT-H-TOWER-2? ()
	<RETURN
		<AND
			<FSET? ,RM-TOW-CLEARING ,FL-TOUCHED>
			<FSET? ,TH-IVORY-KEY ,FL-SEEN>
		>
	>
>

;<ROUTINE RT-H-NAME-1? ()
	<RETURN
		<AND
			<FSET? ,CH-RHYMER ,FL-SEEN>
		;	<NOT <FSET? ,RM-CRACK-ROOM ,FL-TOUCHED>>
		;	<NOT <FSET? ,RM-CELLAR ,FL-SEEN>>
		>
	>
>

<ROUTINE RT-H-NAME-2? ()
	<RETURN
		<AND
			<FSET? ,CH-RHYMER ,FL-SEEN>
			<FSET? ,RM-CRACK-ROOM ,FL-TOUCHED>
		;	<NOT <FSET? ,RM-CELLAR ,FL-SEEN>>
		>
	>
>

<ROUTINE RT-H-NAME-3? ()
	<RETURN
		<AND
			<FSET? ,CH-RHYMER ,FL-SEEN>
			<FSET? ,RM-CRACK-ROOM ,FL-TOUCHED>
			<FSET? ,RM-CELLAR ,FL-SEEN>
		>
	>
>

;<ROUTINE RT-H-TUSK-1? ()
	<RETURN
		<AND
			<FSET? ,RM-NORTH-OF-CHASM ,FL-TOUCHED>
		;	<FSET? ,TH-BOAR ,FL-ALIVE>
		>
	>
>

<ROUTINE RT-H-TUSK-2? ()
	<RETURN
		<AND
			<FSET? ,RM-NORTH-OF-CHASM ,FL-TOUCHED>
			<NOT <FSET? ,TH-BOAR ,FL-ALIVE>>
		>
	>
>

<ROUTINE RT-H-SEEN-BOG? ()
	<RETURN <FSET? ,RM-BOG ,FL-SEEN>>
>

<ROUTINE RT-H-SEEN-THORNY-ISLAND? ()
	<RETURN <FSET? ,RM-THORNEY-ISLAND ,FL-SEEN>>
>

;<ROUTINE RT-H-BLACK-KNIGHT-1? ()
	<RETURN <FSET? ,CH-BLACK-KNIGHT ,FL-SEEN>>
>

<ROUTINE RT-H-BLACK-KNIGHT-2? ()
	<RETURN
		<AND
			<FSET? ,CH-BLACK-KNIGHT ,FL-SEEN>
			<FSET? ,TH-SWORD ,FL-SEEN>
		>
	>
>

<ROUTINE RT-H-BLACK-KNIGHT-3? ()
	<RETURN
		<AND
			<FSET? ,CH-BLACK-KNIGHT ,FL-SEEN>
			<FSET? ,TH-SWORD ,FL-SEEN>
			<G=? ,GL-SC-EXP 66>
		>
	>
>

;<ROUTINE RT-H-DRAGON-1? ()
	<RETURN
		<AND
			<FSET? ,CH-DRAGON ,FL-SEEN>
		;	<NOT <FSET? ,TH-WHISKY-JUG ,FL-SEEN>>
		>
	>
>

<ROUTINE RT-H-DRAGON-2? ()
	<RETURN
		<AND
			<FSET? ,CH-DRAGON ,FL-SEEN>
			<FSET? ,TH-WHISKY-JUG ,FL-SEEN>
		>
	>
>

;<ROUTINE RT-H-TALKING-DOOR-1? ()
	<RETURN
		<AND
			<FSET? ,RM-HOT-ROOM ,FL-TOUCHED>
		;	<NOT <FSET? ,RM-ICE-ROOM ,FL-TOUCHED>>
		>
	>
>

<ROUTINE RT-H-TALKING-DOOR-2? ()
	<RETURN
		<AND
			<FSET? ,RM-HOT-ROOM ,FL-TOUCHED>
			<FSET? ,RM-ICE-ROOM ,FL-TOUCHED>
		>
	>
>

<ROUTINE RT-H-SEEN-DEMON? ()
	<RETURN <NOT <FSET? ,CH-DEMON ,FL-LOCKED>>>
>

<ROUTINE RT-H-APPENDIX? ()
	<RETURN <NOT <IN? ,TH-EXCALIBUR ,TH-STONE>>>
>

;"longest hint topic can be 17 chars"

<CONSTANT HINTS
	<CONSTRUCT-HINTS HINT-COUNTS

		"THE CHURCHYARD"

		<PLTABLE
<>
"How do I keep the soldiers from arresting me?"
"Hide where they can't see you."
"You can't hide in the church."
"Hmmm. Doesn't that gravestone look pretty big?"
"Hide behind the gravestone."
		>
		<PLTABLE
RT-H-STONE-STOLEN?
"How do I keep Lot from stealing the stone?"
"You can't."
		>
		<PLTABLE
<>
"What can I do in the church?"
"What should any chivalrous knight do when starting a quest?"
"Pray."
		>

		"KING LOT"

		<PLTABLE
<>
"Who is King Lot?"
"He is one of the many lesser kings who live in Britain. He wants to be High
King."
		>
		<PLTABLE
RM-GREAT-HALL
"Why does Lot ignore me in the great hall?"
"You are but a boy - insignificant in his eyes."
		>
		<PLTABLE
RM-GREAT-HALL
"How can I get Lot's attention?"
"You need to challenge him in the traditional way."
"Unless the next hint topic begins, \"More on getting Lot's attention,\" then
someplace in the game there is some object or information that you have not
yet discovered.  Until you do, it is unlikely that you will solve this
puzzle."
		>
		<PLTABLE
RT-H-LOT-ATTENTION-2?
"More on getting Lot's attention"
"Take the gauntlet to the Great Hall and hit Lot with it."
		>
		<PLTABLE
RT-H-FIGHT-LOT?
"How can I defeat Lot in battle?"
"Lot is a better swordsman than you."
"You'll have to resort to something other than swordplay."
"You'll have to distract him."
"Have you noticed his dominant personality characteristic?"
"Have you noticed how greedy he is?"
"Throw the bracelet on the ground."
		>
		<PLTABLE
RT-H-BEAT-LOT?
"More on defeating Lot"
"Once you have him at your mercy, you must spare his life."
		>

		"THE VILLAGE IDIOT"

		<PLTABLE
CH-IDIOT
"Why is the idiot in the Town Square?"
"The idiot is a metaphor for the angst of the human condition. He has
positioned himself in the Town Square as a silent protest against man's
inhumanity to man, and as a constant reminder of society's responsibility to
care for its intellectually inferior elements."
"Actually, he just likes it there."
		>
		<PLTABLE
CH-IDIOT
"How can I get things from the idiot?"
"The idiot isn't too bright."
"He has no concept of value."
"He'll trade you anything he's got for anything you've got."
		>

		"THE TAVERN"

		<PLTABLE
RM-TAVERN
"Are the farmers important?"
"Without farmers there would be no crops, and eventually everyone would die."
"Oh! You mean in the GAME?"
"Yes."
"Their conversation provides an important clue."
		>
		<PLTABLE
RM-TAV-KITCHEN
"Do I have to get into the locked cupboard?"
"Is the Queen English?"
"Are wild bears Catholic?"
"Does the Pope....(well, never mind)."
"Yes."
		>
		<PLTABLE
RM-TAV-KITCHEN
"How do I get into the locked cupboard?"
"Have you asked the cook to open it for you?"
"Of course, he's such a jerk that he probably wouldn't help you."
"The wooden key opens the locked cupboard."
"Have you asked the cook where the key is?"
"Oh yeah. We forgot. He's a jerk."
"Do not read the next clue until you have paid a visit to Merlin."
"Have you asked the bird about the key?"
"Turn yourself into an owl and see what the bird has to say."
"(But wait until that jerk leaves the room.)"
		>

		"INVISIBLE KNIGHT"

		<PLTABLE
RM-MEADOW
"How can I get back what the invisible knight steals?"
"He trades away some of the things he steals to another character in the game."
"The other character is the idiot."
"You can trade with the idiot for whatever he has."
"The Invisible Knight will keep the rest of your possessions until you track
him to his lair."
"Unless the next hint topic begins, \"More on the invisible knight,\" then
someplace in the game, there is some object or information that you have not
yet discovered.  Until you do, it is unlikely that you will solve this
puzzle."
		>
		<PLTABLE
RT-H-I-KNIGHT-2?
"More on the invisible knight"
"Think of the Invisible Knight as an unseen force."
"Go to the meadow and rub the magic ring."
		>

		"THE BRASS EGG"

		<PLTABLE
CH-I-KNIGHT
"What is the solution to the invisible knight's riddle?"
"This is the first clue"
"This is the second clue"
"This is the third clue"
"This is the fourth clue"
"Examine the first four clues carefully"
"The first four clues form a sequence"
"The clue after the first four clues would be the fifth clue"
"Look at the last two letters of the words in the first four clues"
"The letters the knight is looking for are TH (as in fifTH)"
		>

		"MERLIN'S BAG"

		<PLTABLE
TH-BAG
"What is the magic of Merlin's bag?"
"No matter what you put into it, it never fills up."
		>

		"ENTERING THE CASTLE"

		<PLTABLE
RM-CASTLE-GATE
"How can I get into the castle?"
"Give the guard at the gate the password."
		>
		<PLTABLE
RT-H-CASTLE-2?
"More on getting into the castle"
"You must go down the badger hole to get into the castle."
"Push the stone."
		>
		<PLTABLE
RM-CASTLE-GATE		; "(has the guard blocked entry or exit)"
"How can I get the password?"
"Strangely enough, you will have to get into the castle before you can learn
the password."
"Don't read the next hint until you have visited Merlin."
"You need to turn yourself into an animal in order to get into the castle."
"You must enter the castle as a badger."
"Unless the next hint topic begins, \"More on getting the password,\" then
you should come back after you've explored more thoroughly as a badger."
		>
		<PLTABLE
RT-H-PASSWORD-2?
"More on getting the password"
"Have you listened to the farmers in the tavern?"
"The \"He\" they are referring to is Lot."
"The poem they are referring to is in your documentation."
"Lot announces the password every canonical hour."
"You have to be where you can hear Lot set the password."
"You have to be somewhere other than in the Great Hall."
"Unless the next hint topic begins, \"Still more on getting the password,\"
then you should come back after you have escaped from the cell."
		>
		<PLTABLE
RT-H-PASSWORD-3?
"Still more on getting the password"
"Have you found a dark passage yet?"
"Perhaps the small chamber at the end of the hall bears closer examination."
"Perhaps there is a secret exit from the small chamber."
"Look behind the tapestry."
"The next hint will be the very last hint on how to get the password."
"Wait behind the throne until the canonical hour changes. You will hear Lot
announce a verse and a line. That line is the password."
		>
		<PLTABLE
RT-H-HEARD-PASSWORD?
"How do I use the password?"
"In your documentation, you will find a poem about King Lot. Look up the
verse and line that you overheard from Lot. Then go to the guard and repeat
that line using the following format:|   >Say \"Correct line from poem\""
		>

		"THE CELL"

		<PLTABLE
RM-CELL
"Do I need to free the prisoner?"
"It would be the chivalrous thing to do."
"Yes. You need to free the prisoner."
		>
		<PLTABLE
RM-CELL
"How do I free the prisoner?"
"The chains and the padlock can't be broken."
"You have to unlock the padlock."
"Guards generally have keys to padlocks."
"Have you asked the prisoner about the guards?"
"Call the guard."
		>
		<PLTABLE
RT-H-PRISONER-2?
"More on freeing the prisoner"
"Did we mention that you should hide behind the door before you call the guard?"
"Did we mention that you will have to hit the guard in order to get the key?"
"Did we mention that you need to use the stone in order to knock out the guard?"
"Are you sick of us forgetting to mention things?"
		>

		"LEAVING THE CASTLE"

		<PLTABLE
RM-HALL
"How do I get out of the underground corridor?"
"Forget the guard at the top of the stairs. He'll kill you every time."
"Look around the small chamber."
"How about that tapestry."
"Look behind the tapestry."
		>
		<PLTABLE
RM-PASSAGE-1
"How do I get out of the dark passage?"
"If you emerge from behind the throne, you'll always get killed."
"You'll have to get through that fire somehow."
"Gee....what animal was it that walks through fire?"
"Turn yourself into a salamander."
		>
		<PLTABLE
RM-CAS-KITCHEN
"How do I get the prisoner through the fire?"
"The prisoner can't turn himself into a salamander."
"You can't turn him into a salamander."
"It looks like you'll have to put out that fire."
"Push over the barrel of water."
		>
		<PLTABLE
RM-CAS-KITCHEN
"How do I get the prisoner to leave the kitchen?"
"He needs a disguise so the guards won't recognize him."
"Perhaps something that will cover part of his face."
"Remember that guard you knocked out?"
"Give him the guard's helmet."
		>
		<PLTABLE
RT-H-PRISONER-OUT?
"How do I get the prisoner past the guard at the gate?"
"Give the guard the password."
"See the hints on getting and using the password."
		>

		"THE SMITH'S SWORD"

		<PLTABLE
RT-H-SWORD?
"How can I get the sword from under the tree?"
"The smith said he buried it."
"Perhaps you should try digging."
"Perhaps you should try digging as another animal."
"Turn yourself into a badger, then dig."
		>

		"THE RED KNIGHT"

		<PLTABLE
CH-RED-KNIGHT
"How do I get past the red knight?"
"Give him what he wants."
		>

		"THE BADGER MAZE"

		<PLTABLE
RM-BADGER-TUNNEL
"Do I have to go through the badger maze?"
"Yes."
		>
		<PLTABLE
RM-BADGER-TUNNEL
"How do I get through the badger maze?"
"The maze can be mapped."
"Although you cannot carry anything as a badger, you can still map the maze."
"You need some way to distinguish one room from another."
"You need to find a unique way to mark each room."
"What natural tools does a badger have?"
"Use your claws to mark each room."
"When you enter the first room, put one claw mark on the wall. When you enter
the next room, put two claw marks on the wall. Keep doing that and you will
soon be able to map the entire maze."
"The next two hints will give you the exact directions through the maze."
"From the smithy, go down, south, up, down, and up."
"From Thorney Island, go down, north, north, and up."
		>

		"THORNEY ISLAND"

		<PLTABLE
RM-THORNEY-ISLAND
"How can I remove the hawthorn sprig from my fur?"
"You can't reach it with your claws."
"When you change back to human form, the sprig will fall to the ground."
		>
		<PLTABLE
RM-THORNEY-ISLAND
"What else can I do on the island?"
"Lie on the beach?"
"Sing 'Goodbye My Thorney Island Baby'?"
"Nothing."
		>

		"THE JOUST"

		<PLTABLE
CH-BLUE-KNIGHT
"How do I start the joust?"
"First you'll have to find some armour...."
"Then of course you'll need a shield...."
"And you'll need to polish the shield...."
"With the pumice stone...."
"And then get on the horse."
		>
		<PLTABLE
CH-BLUE-KNIGHT
"How do I win the joust?"
"The blue knight seems to place a great deal of importance on honourable behaviour."
"Don't think of the joust as a fight. Think of it as a gentleman's sport,
with gentleman's rules and conventions."
"A gentleman wouldn't truly try to hurt another gentleman."
"Have you noticed where the blue knight always ends up aiming?"
"The blue knight will always end up aiming at your body."
"You must always end up shielding your body...."
"And you must always end up aiming at his body."
		>

		"THE CONKERS"

		<PLTABLE
RM-CHESTNUT-PATH
"Why do the enchanted trees throw conkers at me?"
"They don't need a reason. They're enchanted."
		>
		<PLTABLE
RM-CHESTNUT-PATH
"How do I survive the attack of the enchanted trees?"
"You can't destroy the trees."
"Find a way to protect yourself."
"Your armour and shield can't quite protect all of your body."
"Turn into a turtle."
"Retract your head and legs into your shell."
"Wait until the trees stop throwing the conkers."
		>

		"THE KRAKEN"

		<PLTABLE
CH-KRAKEN
"Do I need the bracelet?"
"Yes."
		>
		<PLTABLE
CH-KRAKEN
"How do I get the bracelet?"
"The Kraken won't give it to you."
"You'll have to take it from him."
"You'll have to use violence."
"You'll have to cut it off with your sword."
"You can't carry a sword while you're swimming."
"If you can't get the sword to the kraken, you'll have to get the kraken to
the sword."
"If you zap the kraken as an eel, he'll start to chase you."
"Leave the sword in the ford or the shallows."
"Zap the kraken and go back to where you left the sword. Change back to human
form, take the sword, and cut off the bracelet."
		>
		<PLTABLE
RT-H-BRACELET-2?
"More on getting the bracelet"
"Think of the bracelet as a hoop."
"Swim through the bracelet."
"Swim through the bracelet as a turtle."
"Take the bracelet to the shallows or the ford and then pull your head inside
your shell."
		>

		"THE GLADE"

		<PLTABLE
RM-GLADE
"What is rustling in the undergrowth?"
"Perhaps it is something that is afraid of you."
"Maybe you should hide somewhere."
"Hide behind the rock."
		>
		<PLTABLE
RT-H-HEARD-MURMUR?
"What is the murmuring below the rock?"
"Listen to it."
"It's a leprechaun complaining about something."
		>
		<PLTABLE
CH-LEPRECHAUN
"How do I catch the leprechaun?"
"Listen to the murmuring from below the rock."
"Don't read the next clue until you have opened the cupboard in the tavern."
"The leprechaun is complaining about the lack of spice in his Irish stew."
"Leave the spice in the glade, then hide behind the rock."
"Catch the leprechaun while he is looking at the bottle of spice."
		>

		"THE RAVEN"

		<PLTABLE
CH-RAVEN
"Where is the raven's egg?"
"Where do ravens usually keep eggs?"
"It's in the raven's nest."
"The nest is at the top of the tall tree in the grove."
		>
		<PLTABLE
TH-RAVEN-EGG
"How can I get the gold egg out of the nest?"
"You need to get into the nest...."
"Then you need to distract the raven long enough to get the egg."
"Unless the next hint topic begins, \"More on getting the gold egg,\" then
someplace in the game, there is some object or information that you have not
yet discovered.  Until you do, it is unlikely that you will solve this
puzzle."
		>
		<PLTABLE
RT-H-EGG-2?
"More on getting the gold egg"
"The raven likes bright objects."
"The bird may even think the brass egg is real."
"Drop the brass egg in the grove."
"Fly up to the nest."
"Push the egg out of the nest."
"Get out of there before the raven kills you."
		>

		"THE IVORY TOWER"

		<PLTABLE
RM-TOW-CLEARING
"How do I get into the ivory tower?"
"You need a key."
"Unless the next hint topic begins, \"More on getting into the tower,\" then
someplace in the game, there is some object or information that you have not
yet discovered.  Until you do, it is unlikely that you will solve this
puzzle."
		>
		<PLTABLE
RT-H-TOWER-2?
"More on getting into the tower"
"The Blue Knight gave you an ivory key. Use it."
		>
		<PLTABLE
CH-RHYMER
"How can I find out the man's name?"
"It isn't Rumplestiltskin."
"Magical creatures who have secret names usually have an irresistable urge to
write it down somewhere."
"There's more than one room on this floor of the tower."
"Crawl through the crack in the wall on the landing."
		>
		<PLTABLE
RT-H-NAME-2?
"More on the secret name"
"The letters on the wall of the abandoned room are a cryptogram."
"The key to cryptogram is somewhere else."
		>
		<PLTABLE
RT-H-NAME-3?
"Still more on the secret name"
"Think of the writing on the cellar wall as two strings of letters, rather
than words."
"The writing on the cellar wall is the key to the cryptogram in the abandoned
room."
"It is a substitution cypher."
"Every letter that appears in the phrase AMHTIR AMU SMOTUS also appears in
the name RIOTHAMUS."
"Substitute the letters in the phrase AMHTIR AMU SMOTUS with the letters
in SAYMOTHER that appear above the corresponding letters in RIOTHAMUS."
"For example, the 'S' of SAYMOTHER appears directly above the 'R' of
RIOTHAMUS, so wherever you see an 'R' in AMHTIR AMU SMOTUS, substitute
the letter 'S.'"
"The man's name is Thomas The Rhymer."
		>
		<PLTABLE
RM-CELLAR
"What is in the cellar?"
"It's too dark to see."
"Actually, it's only too dark for a human to see."
"Turn yourself into an owl."
		>

		"THE BOAR"

		<PLTABLE
TH-BOAR
"How do I get across the chasm?"
"You can't jump over it."
"Don't read the next clue until you have visited Merlin."
"Fly over the chasm as an owl."
		>
		<PLTABLE
RM-NORTH-OF-CHASM
"How do I get the tusk from the boar?"
"You'll have to kill the boar."
"You can't kill it with your bare hands."
"And it looks too big to kill with a conventional weapon."
"So maybe you could poison it."
"Gee. If only there were a poison apple in the game."
"But wait! What luck! There IS a poison apple - conveniently located just
east of the ford."
"That's really all you need to know, unless you're having difficulty getting
the apple to where the boar is - in which case, read on."
"Well, first you'll have to get the apple safely out of the Badlands, which
is covered in a separate hint topic."
"But once you've done that, you've still got to get the apple to the other
side of the chasm."
"Of course, the chasm really isn't all that wide."
"Throw the apple over the chasm."
		>
		<PLTABLE
RT-H-TUSK-2?
"More on getting the tusk"
"Have you tried pulling the tusk out?"
"Cut off the tusk with the sword."
"Then throw everything back over the chasm."
		>

		"THE COTTAGE"

		<PLTABLE
RM-COTTAGE
"What's wrong with the peasant?"
"He has passed out from the cold."
		>
		<PLTABLE
RM-COTTAGE
"How do I awaken the peasant?"
"He has passed out from the cold."
"You need to warm him up."
"The fire has gone out."
"You need to restart the fire."
"You need some new fuel for the fire."
"Peat is a good fuel."
"Go to the bog and cut some peat."
"Use the slean."
		>

		"THE BOG"

		<PLTABLE
RT-H-SEEN-BOG?
"How do I get through the bog?"
"You need expert guidance."
"Ask the peasant in the cottage."
		>
		<PLTABLE
RT-H-SEEN-THORNY-ISLAND?
"How do I get to the island in the middle of the bog?"
"You can't get to it from the bog."
"You can't get to it from the air."
"Do not read the next clue until you are really stumped."
"You have to solve the badger maze to get to the island."
		>

		"THE BLACK KNIGHT"

		<PLTABLE
CH-BLACK-KNIGHT
"How can I get past the black knight?"
"You'll have to defeat him in battle."
"You'll need a good weapon."
"Unless the next hint topic begins, \"More on getting past the black knight,\"
then someplace in the game there is some object or information that you have
not yet discovered.  Until you do, it is unlikely that you will solve this
puzzle."
		>
		<PLTABLE
RT-H-BLACK-KNIGHT-2?
"More on getting past the black knight"
"You have to attack the knight with your sword."
"Unless the next hint topic begins, \"Still more on getting past the black
knight,\" then you don't have enough experience to defeat him yet."
		>
		<PLTABLE
RT-H-BLACK-KNIGHT-3?
"Still more on getting past the black knight"
"You now have all the experience you need to defeat the black knight."
"However, you have to do more than simply attack him."
"The black knight is enchanted."
"Have you looked at him?"
"The medallion is the source of his enchanted power."
"Wait until you have knocked the sword from his hand, then cut off the medallion."
		>

		"THE DRAGON"

		<PLTABLE
CH-DRAGON
"How can I kill the dragon?"
"Bloodthirsty sort, aren't you?"
"You can't kill the dragon."
		>
		<PLTABLE
CH-DRAGON
"How can I get past the dragon?"
"Unless the next hint topic begins, \"More on getting past the dragon,\" then
someplace in the game there is some object or information that you have not
yet discovered.  Until you do, it is unlikely that you will solve this
puzzle."
		>
		<PLTABLE
RT-H-DRAGON-2?
"More on getting past the dragon."
"Does the dragon remind you of anyone?"
"Like someone who would rather be in Philadelphia?"
"Like someone known for his alcoholic intake?"
"Give him the jug of whisky."
		>

		"THE APPARITIONS"

		<PLTABLE
TH-GHOSTS
"How can I kill the apparitions?"
"You can't. They're already dead."
		>
		<PLTABLE
TH-GHOSTS
"How can I stop the apparitions from killing me?"
"The apparitions aren't real."
"They are being created in your mind by an evil force."
"If you leave them alone, they'll leave you alone."
		>

		"THE BASILISK"

		<PLTABLE
CH-BASILISK
"How can I stop the basilisk from killing me?"
"The basilisk turns everything it sees into stone."
"Perhaps if it caught a glimpse of itself...."
"Like in a mirror, perhaps..."
"Or something that was sort of like a mirror."
"Point your shield at the basilisk."
		>

		"THE ICE ROOM"

		<PLTABLE
RM-ICE-ROOM
"What can I do in the ice room?"
"Make ice cream?"
"Freeze things."
"See the hints for the Hot Room."
		>

		"THE HOT ROOM"

		<PLTABLE
RM-HOT-ROOM
"How can I get past the talking door?"
"Just say the word and the door will open."
"Oh yeah. We forgot. You can't talk."
"Unless the next hint topic begins, \"More on getting past the talking door,\"
then someplace in the game there is some object or information that you
have not yet discovered.  Until you do, it is unlikely that you will solve
this puzzle."
		>
		<PLTABLE
RT-H-TALKING-DOOR-2?
"More on getting past the talking door"
"It sure is hot in here."
"Real hot."
"Hot enough to melt almost anything."
"Especially ice."
"Especially ice that contained a frozen word."
"Like Nudd."
"Go to the ice room, say \"Nudd,\" catch the block of ice before it falls,
and bring it back to the hot room."
		>

		"THE DEMON'S LAIR"

		<PLTABLE
RM-DEMON-HALL
"Should I free the girl?"
"Have you tried kissing her?"
"Take our word for it. You don't want to free her."
"She's not what she pretends to be."
"If you show her that you know who she is, her disguise will disappear."
"She's really the demon himself."
"Either attack her, or address her as Nudd."
		>
		<PLTABLE
RT-H-SEEN-DEMON?
"How do I get out of the demon's lair alive?"
"Well, you could turn down the demon's deal and simply leave."
"Of course, in that case you wouldn't get the fleece."
"It looks as if you'll have to accept his offer."
"But perhaps you could outsmart him."
"Like if you fulfilled the letter - but not the spirit - of the contract."
"All you have to do is open the manacles."
"He didn't say anything about not being able to close them again."
"Of course, you'd have to open them one at a time."
		>

		"THE UNDERGROUND CHAMBER"

		<PLTABLE
CH-NIMUE
"Who is the sleeping woman?"
"She is Nimue. The Lady of the Lake."
		>
		<PLTABLE
CH-NIMUE
"How can I break the enchantment?"
"You must heed Merlin's message in the documentation."
		>

		"THE ENDGAME"

		<PLTABLE
RT-H-DEFEAT-LOT?
"I've defeated King Lot. Now what?"
"Remember the instructions of the lady of the lake?"
"Call Nimue."
		>

		"THE MEANING OF LIFE"

		<PLTABLE
<>
"What is the meaning of life?"
"Gee. We were sorta hoping you'd know."
		>
		<PLTABLE
<>
"How high is up?"
"Twice as far as half way."
		>

		"APPENDIX"

		<PLTABLE
RT-H-APPENDIX?
"Reality vs. romance"
"	There is inherent conflict built in to writing a game about King Arthur.
It is the conflict between history and legend - the way things were, versus
the way we wish they were.|	The historical Arthur probably lived in
Post-Roman Britain, and reigned between about 454 and 470 AD, although even
this is widely debated.|	The bulk of Arthurian legend, however, is based on
a series of romances written beginning in the 12th century. The writers of
these tales shamelessly projected then-current styles, fashions, and culture,
backwards across the centuries and fastened them to Arthur, where they have
stuck firmly ever since.|	Thus, the historical Arthur never jousted.
Camelot, if it existed, was not a stone castle with crenellated towers, but a
reinforced hill fort with a wooden palisades surrounding a few half-timbered,
thatched buildings. Chivalry hadn't been invented yet, nor had the idea of
courtly love. Armor consisted primarily of chain mail. The cumbersome suits
of plate armor one sees in the Tower of London did not come into vogue for at
least 500 years after Arthur's death at the battle of Camlann.|	Given the
fanciful nature of the game, it may seem silly to be concerned with the
accuracy of historical detail. Nevertheless, I have tried wherever possible
to cleave to the Britain of the true Arthur. A few glaring anachronisms - the
jousting scene, for example - have been included to make the game more
enjoyable. Others, like calling Britain England (Angle-Land), are included as
a bow to modern usage. But by and large, the setting is pre-Norman - and even
pre-Saxon - Britain."
		>
		<PLTABLE
RT-H-APPENDIX?
"Post-Roman Britain"
"The last Roman legions left England in the year 410. With their departure,
the Emperor Honorius authorized the Britons to take up arms to repel the
invading Angles and Saxons and Jutes.|	A series of leaders including the
historic Arthur (who ruled from about 454 to 470) fought with varying degrees
of success to keep the invaders at bay. After Arthur's death, however, the
barbarians overran the island, and Britain began the long slide into the Dark
Ages.|	The game is set in this period between the departure of the Romans
and the descent into darkness. During this time, central authority became
fragmented and regional kings came into power. Coinage passed out of use in
favor of a barter economy.|	One interesting feature of those years was the
curious blend of Christian and pagan beliefs that held sway in Britain. When
the Emperor Constantine converted to Christianity in 312, the new faith
spread rapidly through the empire. But resident Romans were notorious for
incorporating local religious beliefs into their own, and many Britons
worshipped both the new god and the old Celtic gods simultaneously (see the
appendix item on the Holy Thorn).|	Another prominent feature of the times
was the crumbling infrastructure. When the Romans left, they took their
knowledge of stonemasonry with them. The towns and fortresses fell into
disrepair, and no one knew how to build replacements. In the game, I have
modelled the town on the old Roman city of Portchester in the south of
England. Here there is an encircling town wall (which survives today) with a
fortress at one end. My fictional King Lot built his timber Great Hall behind
the old stone walls of the fortress, and positioned it so that his throne
backed up to the secret passage that led to the cells below."
		>
		<PLTABLE
RT-H-APPENDIX?
"Book of hours"
"Before the invention of the mechanical clock (the first public clock that
struck the hours wasn't built until 1335), people were far less concerned
with the precise measure of time than they are today.|	The members of a
monastic community, however, had strictly regimented lives consisting of
community service, scriptural study, and manual labor that included domestic,
garden, and craft work. Moreover, at regular intervals throughout the day
they were required to praise the Lord in prayer or song. The periods of time
into which they divided the day came to be known as the canonical hours, and
the sequence of prayers became known as the divine office.|	Through the
centuries, as the requirements of monastic life changed, the number,
duration, and nomenclature of the canonical hours changed as well. Thus, at
one time, Matins was approximately five hours long, beginning around
midnight. Later, it became associated with dawn, and was reduced in length to
around three hours.|	Because of these changes, it is impossible to determine
with accuracy the actual system that was in effect during Arthurian times.
Instead, I created a composite version of the divine office for the game,
using wherever possible the earliest known spelling and sequence of the
canonical hours:|	Matins:  Midnight - 3:00 a.m.|	Lauds:  3:00 - 6:00
a.m.|	Prime:  6:00 - 9:00 a.m.|	Terce:  9:00 a.m. - Noon|	Sext:  Noon -
3:00 p.m.|	None:  3:00 - 6:00 p.m.|	Vespers:  6:00 - 9:00 p.m.|	Compline:
 9:00 p.m. - Midnight|	Elaborately illuminated Celtic gospels - such as the
Book of Kells - survive from as long ago as the late 600's. These works of
art were too rare - and too heavy - for a monk to carry with him as he
performed his daily chores. Instead he would carry a smaller devotional book
that contained the prayers to be said at the canonical hours. This breviary
was called a Book of Hours.|	The game has adapted the idea of the Book of
Hours to help explain the canonical hours to the modern player. Although the
book would have contained prayers written in Latin, we have substituted poems
that deal with the various activities appropriate to each canonical hour.|	In
Arthur's day, centuries before the Norman Invasion, poets neither wrote in
rhyme nor counted syllables. The predominant style of poetry was called
alliterative verse, and it relied on the frequent repetition of consonant
sounds within any given line. The foremost example of this is the masterful
'Sir Gawain and the Green Knight.' The style died out completely when the
Conquest brought rhyming, metered poetry to England's shores in 1066.|	We
have chosen this style over the more familiar rhyming style for the book of
hours and for Lot's poem.|	Finally, for anyone who is wondering why a Book of
Hours contains a poem in praise of the evil King Lot, the explanation lies in
the system of patronage and indulgences that was popular in the Middle Ages.
Under this frequently corrupt scheme, wealthy individuals could buy
forgiveness for their less-than-pious acts by sponsoring the creation of holy
works of art. Thus, this particular Book of Hours was financed by Lot, who
insisted that the poem (which he also payed for) be included."
		>
		<PLTABLE
RT-H-APPENDIX?
"Thomas the Rhymer"
"Thomas the Rhymer was a real man, a seer and poet who lived in the 13th
Century. Records of him survive in the form of documents and deeds which he
signed as Thomas Rymour de Erceldoune. It is believed that he was the author
of the metrical 'Sir Tristrem,' the source from which the great Arthurian
romance 'Tristan and Isolde' was later taken.|	After his death, his name
passed into popular lore, and by the 15th century it was often linked closely
with Merlin's.|	In legend, Thomas the Rhymer acquired his prophetic powers
when he met the Queen of Elfland and followed her into the land of the
fairies. There he stayed for seven years, before returning to the outside
world with the gift of prophecy. After his return, he lived a long and happy
life in Erceldoune until one day, while he was feasting in his castle, word
came that a hart and a hind were wandering through his village. He left the
castle to look at them, and when they turned and went into the forest, he
followed them - never to return. Yet for years thereafter, mortals who
ventured into fairyland reported that he lived there still, as a councillor
to the queen of the fairies.|	In this game, Thomas belongs to the class of
supernatural creatures who place tremendous importance on the secrecy of
their names. A striking feature of this group of imps is that whenever one of
them finds himself alone, he is overwhelmed by an urge to shout out the very
name he is trying to conceal. The most famous example of this peculiar
behaviour can be found in the Grimm fairy tale 'Rumpelstiltskin.' While our
Thomas has managed to control the urge to shout his name aloud, perhaps the
player will understand his compensatory need to encrypt his name and write it
on one of the walls of his tower, while providing the key to the code on
another."
		>
		<PLTABLE
RT-H-APPENDIX?
"Holy thorn"
"Legend has it that after Joseph of Arimathea placed Jesus in the tomb, he
came to Britain with the Holy Grail, the cup used at the Last Supper. When he
arrived in Glastonbury, he thrust his staff into the ground on Weary-All
Hill, where it miraculously took root and grew into the Holy Thorn tree that
blossoms on Christmas day.|	Descendents of this tree (the original was cut
down in Cromwell's time) still grow around Glastonbury. But ever since the
calendar reform of 1752 that involved a shift of eleven days, the trees no
longer bloom exactly on Christmas Day itself, but rather sometime around
Christmas Week.|	In Arthur's day, Glastonbury was surrounded by marshes that
flooded each winter, turning the higher ground on which the Holy Thorn grew
into an island that the Celts held sacred and called Ynys-wittin - the Island
of Glass. Later traditions hold that this is the legendary Island of
Avalon.|	At the same time, some 100 miles to the east, lay another island
with sacred connotations. On it was a small church dedicated to St. Peter. A
few centuries later, Westminster Abbey was built on the foundations of that
church, and the land on which it stood was called Thorney Island.|	The urge
to have the game combine these two places into one island that was accessible
only through supernatural means proved irresistable, leaving unsolved the
mystery whether it was pagan magic or a Christian miracle (or a combination
of both) that brought Arthur to the throne of Britain."
		>
		<PLTABLE
RT-H-APPENDIX?
"Nudd"
"Nudd is really Gwyn ap Nudd, the Celtic king of the underworld, also known
variously as Nodons and Lludd. His name pops up from time to time throughout
the body of Arthurian legend. In the tale of St. Collen, for example, the
saint goes up to the top of Glastonbury Tor and enters the hill through a
magic opening. There he finds Nudd sitting on a golden throne, surrounded by
courtiers dressed in red and blue that the saint describes as \"the red of
burning fire and the blue of cold.\"|	In the Black Book of Carmarthen,
Arthur himself ventures into Nudd's realm of Annwn to bring back a miraculous
cauldron of inspiration and plenty. In the Old French verse 'Merlin,' written
about 1200 by Robert de Boron, we learn that Nudd was also responsible for
placing the two dragons underneath the foundations of Vortigern's tower. (It
was Merlin's subsequent discovery of these dragons that launched his career
as a prophet and magician.)|	The game takes bits and pieces of these
legends, pastes them together, and then invents a few more for good measure.
The first of these inventions is the idea that Nudd's evil influence spreads
over all the land east of the river. Merlin's magic has no power there, which
explains why the 'cyr' word will not work, and why the bag will no longer
hold an impossible number of objects.|	Another addition is the \"deal with
the devil,\" which is not found in Arthurian tradition. The unusual part of
these pacts is that the devil always seems to keep his word. One might think
that, since he is evil incarnate, he wouldn't bother to honor his promises. A
long tradition of tall tales, however, argues otherwise."
		>
		<PLTABLE
RT-H-APPENDIX?
"Riothamus"
"I cannot recommend highly enough a book called The Discovery of King Arthur,
by Geoffrey Ashe (copyright 1985, Henry Holt & Co). In it, Ashe puts forward
a persuasive argument that identifies King Arthur with a known historical
figure named Riothamus.|	Riothamus appears in French historical chronicles
as the King of the Britons who led a force of 12,000 men onto the continent
during the reign of Pope Leo. His existence is well documented, in fact a
letter still survives that was written to him in the year 469 or 470 by a man
named Sidonius.|	If Arthur was Riothamus, why didn't contemporary historians
refer to him as King Arthur? In its original British form, Riothamus would
have been Rigotamos, which meant \"king-most\" or \"supremely royal.\" Ashe
argues that this was an honorific or title (like 'generalissimo') given to
Arthur, by which he was known to his contemporaries. He points out that the
same sort of name substitution happened to the Mongol warlord Temujin, who
is better known to history by his honorific, \"very mighty ruler,\" or
Ghengis Khan."
		>
		<PLTABLE
RT-H-APPENDIX?
"Nimue"
"Through the centuries, the Lady of the Lake has had many different names,
including Viviane, Eviene, Niviene, and Nina. But in Le Morte D'Arthur, Sir
Thomas Malory calls her Nimue. The game follows Malory on this point, despite
the fact that other authors cast Nimue as an evil sorceress who sometimes
becomes Merlin's nemesis.|	In many versions of the legend, it is the Lady of
the Lake who gives the mighty Excalibur to Arthur. In some texts, however,
Excalibur appears in a churchyard as the sword in the stone, and Arthur must
prove his right to the throne by pulling it free on Christmas Day.|	This
game puts Excalibur into Arthur's hand in a way that satisfies both of these
traditions. Arthur does indeed pull the sword from the stone on Christmas
Day, but it is the Lady of the Lake who gives him the power to do so by
parting the waters of the lake when he calls her name."
		>
		<PLTABLE
RT-H-APPENDIX?
"The blank gravestone"
"So many people have asked the meaning of the blank gravestone in the
churchyard that I have decided to explain it here, rather than waiting for a
possible sequel.|	When Sir Lancelot was born, he was taken away from his
parents and raised by the Lady of the Lake (which is why he is sometimes
called Lancelot du Lac). Like Arthur, he grew up in ignorance of his name and
royal parentage.|	Lancelot does not learn his true name until he captures
Dolorous Gard and breaks the enchantment that lays over the castle. There, in
a magic cemetery, he finds a tomb in which he is told he will one day lie.
While he stands there, his name magically appears upon the previously blank
tombstone, and that is how he learns his true identity.|	In this game, this
is the tombstone that conceals Arthur from Lot's soldiers. Lancelot and the
other Knights of the Round Table do not belong in this game, but I thought it
appropriate that before he even comes into the world, Lancelot is already
acting as Arthur's friend and protector."
		>
		<PLTABLE
RT-H-APPENDIX?
"Geography"
"I have taken great liberties with geography, specifically by implying that
all the game's action takes place in Lot's kingdom.|	Lot was the king of
Lothian, which is in the north of Britain. The location of the sword in the
stone is most frequently given as London or Winchester. Merlin's cave was in
Carmarthen (Caer Myrddin) in Wales. The Lady of the Lake lived near
Glastonbury.|	For the sake of convenience, I have moved Lot's kingdom south,
Merlin's cave east, and the sword in the stone west (or north), so that they
all converge on a spot near the home of the Lady of the Lake, in a setting
that can be called Glastonbury-ish.|	One minor geographical note - the
precious spice that the cook keeps under lock and key is cinnamon, and it is
simply a coincidence that the ancient road that still runs from Glastonbury
to Glastonbury Tor is called Cinnamon Lane."
		>
		<PLTABLE
RT-H-APPENDIX?
"Bibliography"
"The following is a partial list of books I found useful and/or interesting
in the creation of this game.||	FICTION:||	Le Morte D'Arthur, by Sir Thomas
Mallory|	The History of the Kings of Britain, by Geoffrey of Monmouth|	Sir
Gawain and the Green Knight, translated by J.R.R Tolkein|	The Once and
Future King, by T.H. White|	The Crystal Cave, by Mary Stewart|	The Hollow
Hills, by Mary Stewart|	The Last Enchantment, by Mary Stewart|	The Wicked
Day, by Mary Stewart|	The Acts of King Arthur & His Noble Knights, by John
Steinbeck||	NON-FICTION:||	King Arthur's Avalon, by Geoffrey Ashe|	The
Quest for Arthur's Britain, by Geoffrey Ashe (Editor)|	The Discovery of
King Arthur, by Geoffrey Ashe|	The Landscape of King Arthur, by Geoffrey
Ashe|	Arthur's Britain, by Leslie Alcock|	Was This Camelot?, by Leslie
Alcock|	The Arthurian Encyclopedia, by Norris Lacy (Editor)||	Folklore,
Myths, & Legends of Britain, by Reader's Digest|	An Encyclopedia of
Fairies, by Katharine Briggs|	Brewer's Dictionary of Phrase & Fable, by Ivor
Evans (Editor)|	Literary Britain, by Frank Morley|	Intelligent Travellers
Guide to Historic Britain, by Philip A. Crowl|	Treasures of Britain, by
Drive Publications Ltd. for AA|	Art Treasures in the British Isles, by
Bernard S. Myers & Trewin Copplestone (Editors)"
		>
		<PLTABLE
RT-H-APPENDIX?
"Credits"
<CONSTANT K-CREDITS-MSG
"SENIOR PROGRAMMER|Duane Beck||TECHNICAL CONSULTANT, FRIEND, & SHERPA GUIDE
TO THE PARSER|Stu Galley||TESTERS (Alphabetically by first name)|Adam
Levesque, Amy Briggs, Avril Korman, Byron Goulding, Duncan Blanchard,
Elizabeth Langosy, Jake Galley, James Bates, Joe Prosser, Liz Cyr-Jones,
Patti Pizer, Peggy L. Bates, Richard Bates, Shaun Kelly, Steve Watkins,
Stuart Kirsch||PRODUCERS|Jon Palace, Christopher Erhardt, Mike Kawahara,
Jon Palace||COMPUTER GRAPHICS|Darrell Myers, Tanya Isaacson, Sophie Green,
Donna Dennison, Jim Sullivan||PACKAGE DESIGN|Carl Genatossio, Gayle
Syska||COVER ART|Greg Hildebrandt||PACKAGE POETRY|Antonio Alfredo
Giarraputo||BOOK OF HOURS ART|Ed Bradley||GRAPHICS WIZARD|Tom Veldran||MICRO
INTERPRETERS|Duncan Blanchard, Jon Arnold, Scott Fray||LATE INNING
RELIEVER|Dave Lebling||GURU|Tim Anderson||Special thanks also to Dave Wilt,
John May, Joel Berez, and Chris Reeve, who got the whole thing started.">
		>
	>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

