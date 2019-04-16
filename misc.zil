;"***************************************************************************"
; "game : Arthur"
; "file : MISC.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   11 May 1989 23:54:56  $"
; "revs : $Revision:   1.123  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Miscellaneous"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "CH-PLAYER"
;"---------------------------------------------------------------------------"

<OBJECT CH-PLAYER
	(LOC RM-CHURCHYARD)
	(DESC "yourself")
	(SYNONYM ME MYSELF SELF ARTHUR BOY HUMAN PERSON OWL BADGER SALAMANDER TURTLE EEL)
	(FLAGS FL-ALIVE FL-NO-DESC FL-NO-ARTICLE FL-OPEN FL-PERSON FL-SEARCH
		FL-SEEN FL-TOUCHED
	)
	(SIZE 100 CAPACITY 50)
	(ACTION RT-CH-PLAYER)
>

; "CH-PLAYER flags:"
; "	FL-AIR - Player has received points for thanking someone"
; "	FL-BROKEN - Player has already prayed once"
; "	FL-LOCKED - Merlin has enabled used of transformation spells"

<GLOBAL ME:OBJECT CH-PLAYER>

<GLOBAL GL-NEXT-WINNER:OBJECT <>>

<ROUTINE RT-CH-PLAYER ("OPT" (CONTEXT <>) "AUX" PERSON)
	<COND
		(<MC-CONTEXT? ,M-WINNER>
			<COND
				(,GL-NEXT-WINNER
					<SETG WINNER ,GL-NEXT-WINNER>
					<SETG GL-NEXT-WINNER <>>
					<PERFORM ,PRSA ,PRSO ,PRSI>
					<RTRUE>
				)
				(<AND <FSET? ,TH-HEAD ,FL-LOCKED>
						<SEE-VERB?>
					>
					<TELL
"You can't see anything with" the ,TH-HEAD " in your shell." CR
					>
				)
				(<AND <FSET? ,TH-LEGS ,FL-LOCKED>
						<VERB?
							WALK WALK-TO HIDE HIDE-BEHIND ENTER EXIT JUMP CLIMB-UP
							CLIMB-DOWN CLIMB-ON CLIMB-OVER DISMOUNT
						>
					>
					<TELL
"You can't go anywhere with" the ,TH-LEGS " in your shell." CR
					>
				)
				(<AND	<SPEAKING-VERB?>
						<NOT <MC-FORM? ,K-FORM-ARTHUR>>
						<OR
							<AND
								<EQUAL? ,PRSO <> ,ROOMS>
								<SET PERSON <FIND-FLAG-HERE ,FL-PERSON ,CH-PLAYER>>
							>
							<AND
								<SET PERSON ,PRSO>
								<FSET? ,PRSO ,FL-PERSON>
							>
						>
						<NOT <EQUAL? .PERSON ,CH-MERLIN ,CH-PLAYER>>
					>
					<TELL "Animals can't talk to people." CR>
					<SETG CLOCK-WAIT T>
					<RFATAL>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<AND	<NOT <EVERYWHERE-VERB? <COND (,NOW-PRSI 2) (T 1)>>>
				<NOT <VERB? TRANSFORM>>
				<OR
					<AND
						<NOUN-USED? ,CH-PLAYER ,W?ARTHUR>
						<NOT <MC-FORM? ,K-FORM-ARTHUR>>
					>
					<AND
						<NOUN-USED? ,CH-PLAYER ,W?OWL>
						<NOT <MC-FORM? ,K-FORM-OWL>>
					>
					<AND
						<NOUN-USED? ,CH-PLAYER ,W?BADGER>
						<NOT <MC-FORM? ,K-FORM-BADGER>>
					>
					<AND
						<NOUN-USED? ,CH-PLAYER ,W?SALAMANDER>
						<NOT <MC-FORM? ,K-FORM-SALAMANDER>>
					>
					<AND
						<NOUN-USED? ,CH-PLAYER ,W?TURTLE>
						<NOT <MC-FORM? ,K-FORM-TURTLE>>
					>
					<AND
						<NOUN-USED? ,CH-PLAYER ,W?EEL>
						<NOT <MC-FORM? ,K-FORM-EEL>>
					>
				>
			>
			<COND
			;	(<FSET? ,CH-PLAYER ,FL-LOCKED>
					<TELL The+verb ,CH-PLAYER "are" "n't a">
					<COND
						(<NOUN-USED? ,CH-PLAYER ,W?EEL ,W?OWL>
							<TELL "n">
						)
					>
					<TELL " ">
					<COND
						(,NOW-PRSI
							<NP-PRINT ,PRSI-NP>
						)
						(T
							<NP-PRINT ,PRSO-NP>
						)
					>
					<TELL "." CR>
				)
				(T
					<NP-CANT-SEE>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,CH-PLAYER ,FL-SEEN>
			<TELL "You look like a perfectly normal" form "." CR>
		)
		(<VERB? SCRATCH>
			<TELL
"You scratch yourself vigorously for a few moments and then sigh contentedly." CR
			>
			<RT-AUTHOR-MSG
"Haven't I seen you playing third base for the Red Sox?"
			>
		)
		(<VERB? ATTACK>
			<RT-WASTE-OF-TIME-MSG>
			<RT-AUTHOR-MSG
"Feeling self-desctructive? Dial 1-800-HIT-SELF for an incredibly expensive
but absolutely worthless brochure from Masochists Anonymous. Call
anytime - our lines are always busy!"
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "Accessible/Visible"
;"---------------------------------------------------------------------------"

;<GLOBAL GL-CLOSED-OBJECT:OBJECT <>>		; "Closed object preventing touch."
;<GLOBAL GL-IN-OUT:FLAG <>>					; "T=Inside, <>=Outside"
<GLOBAL GL-LOC-TRAIL:TABLE <ITABLE 8 0>>	; "Temporary table used by RT-SEEABLE? and RT-TOUCHABLE?"

<ROUTINE VISIBLE? (OBJ)
	<ACCESSIBLE? .OBJ T>
>

<ROUTINE CLOSED? (OBJ "OPT" (VIS? <>) ;(ON? <>))
	<COND
		(<NOT .OBJ>
			<RTRUE>
		)
		(<IN? .OBJ ,ROOMS>
			<RFALSE>
		)
	;	(<AND <FSET? .OBJ ,FL-SURFACE>
				<FSET? .OBJ ,FL-CONTAINER>
				.ON?
			>
			<RFALSE>
		)
		(<FSET? .OBJ ,FL-CONTAINER>
			<COND
				(<FSET? .OBJ ,FL-OPEN>
					<RFALSE>
				)
				(.VIS?
					<COND
						(<FSET? .OBJ ,FL-TRANSPARENT>
							<RFALSE>
						)
					>
				)
			>
		)
		(<OR	<FSET? .OBJ ,FL-SURFACE>
				<FSET? .OBJ ,FL-ALIVE>
				<FSET? .OBJ ,FL-PERSON>
			>
			<RFALSE>
		)
	>
	<RTRUE>
>

<ROUTINE ACCESSIBLE? (OBJ "OPTIONAL" (VIS? <>) "AUX" WLOC OLOC (CLSD-PTR <>) PTR (CNT 0) ;(ON? <>) TBL END L)
	<COND
		(<NOT .OBJ>
		;	<SETG GL-CLOSED-OBJECT <>>
			<RFALSE>
		)
		(<EQUAL? .OBJ ,ROOMS>
			<RTRUE>
		)
		(<IN? .OBJ ,GLOBAL-OBJECTS>
			<RTRUE>
		)
		(<EQUAL? .OBJ ,PSEUDO-OBJECT>
			<RETURN <EQUAL? ,HERE ,LAST-PSEUDO-LOC>>
		)
		(<IN? .OBJ ,GENERIC-OBJECTS>
			<RETURN .VIS?>
		)
	>
	<SET PTR ,GL-LOC-TRAIL>
	<SET OLOC .OBJ>
	<REPEAT ()
		<PUT .PTR 0 .OLOC>
		<INC CNT>
		<COND
			(<OR	<NOT .OLOC>
					<EQUAL? .OLOC ,WINNER>
					<IN? .OLOC ,ROOMS>
					<IN? .OLOC ,LOCAL-GLOBALS>
					<IN? .OLOC ,GLOBAL-OBJECTS>
					<IN? .OLOC ,GENERIC-OBJECTS>
				>
				<RETURN>
			)
		>
	;	<SET ON? <FSET? .OLOC ,FL-ON>>
		<SET OLOC <LOC .OLOC>>
		<SET PTR <REST .PTR 2>>
		<COND
			(.OLOC
				<COND
					(<CLOSED? .OLOC .VIS? ;.ON?>
					;	<COND
							(<NOT .VIS?>
								<SETG GL-CLOSED-OBJECT .OLOC>
								<SETG GL-IN-OUT T>
							)
						>
						<COND
							(<NOT .CLSD-PTR>
								<SET CLSD-PTR .PTR>
							)
						>
					)
				>
			)
		>
	>

	<SET PTR <>>
	<SET WLOC ,WINNER>
	<REPEAT ()
		<COND
			(<NOT .WLOC>
			;	<COND
					(<NOT .VIS?>
						<SETG GL-CLOSED-OBJECT <>>
						<SETG GL-IN-OUT <>>
					)
				>
				<RFALSE>
			)
			(<SET PTR <INTBL? .WLOC ,GL-LOC-TRAIL .CNT>>
				<RETURN>
			)
			(<IN? .WLOC ,ROOMS>
				<RETURN>
			)
		>
		<SET WLOC <LOC .WLOC>>
		<COND
			(.WLOC
				<COND
					(<CLOSED? .WLOC .VIS?>
					;	<COND
							(<NOT .VIS?>
								<SETG GL-CLOSED-OBJECT .WLOC>
								<SETG GL-IN-OUT <>>
							)
						>
						<RFALSE>
					)
				>
			)
		>
	>

	<COND
		(.WLOC
			<COND
				(<AND <NOT .PTR>
						<SET TBL <GETPT .WLOC ,P?GLOBAL>>
					>
					<SET END <REST .TBL <PTSIZE .TBL>>>
					<REPEAT ()
						<COND
							(<G=? .TBL .END>
								<RETURN>
							)
							(<SET PTR <INTBL? <GET .TBL 0> ,GL-LOC-TRAIL .CNT>>
								<RETURN>
							)
						>
						<SET TBL <REST .TBL 2>>
					>
				)
			>
			<COND
				(<NOT .PTR>
					<SET TBL <FIRST? ,GLOBAL-OBJECTS>>
					<REPEAT ()
						<COND
							(<NOT .TBL>
								<RETURN>
							)
							(<SET PTR <INTBL? .TBL ,GL-LOC-TRAIL .CNT>>
								<RETURN>
							)
						>
						<SET TBL <NEXT? .TBL>>
					>
				)
			>
			<COND
				(<AND .VIS?	;"Only check adjacent rooms for visible."
						<NOT .PTR>
						<SET TBL <GETP .WLOC ,P?ADJACENT>>
					>
					<SET END <GETB .TBL 0>>
					<SET TBL <ZREST .TBL 1>>
					<REPEAT ()
						<COND
							(<DLESS? END 0>
								<RETURN>
							)
							(<AND <GETB .TBL 1>
									<SET PTR <INTBL? <GETB .TBL 0> ,GL-LOC-TRAIL .CNT>>
								>
								<RETURN>
							)
						>
						<SET TBL <ZREST .TBL 2>>
					>
				)
			>
		)
	>

	<COND
		(<NOT .PTR>
			<RFALSE>
		)
		(<AND .CLSD-PTR
				<G? .PTR .CLSD-PTR>
			>
			<RFALSE>
		)
		(T
			<RTRUE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "Print routines"
;"---------------------------------------------------------------------------"

<CONSTANT K-ART-A		1>
<CONSTANT K-ART-THE	2>
<CONSTANT K-ART-ANY	3>
<CONSTANT K-ART-HE	4>
<CONSTANT K-ART-HIM	5>
<CONSTANT K-ART-HIS	6>

<ROUTINE RT-PRINT-DESC (OBJ)
	<COND
		(<FSET? .OBJ ,FL-HAS-SDESC>
			<APPLY <GETP .OBJ ,P?ACTION> ,M-OBJDESC>
		)
		(T
			<PRINTD .OBJ>
		)
	>
>

<ROUTINE PRINT-ARTICLE (OBJ ART CAP? "OPT" (SP? T) "AUX" (MASK 0))
	<COND
		(<NOT .CAP?>
			<COND
				(.SP?
					<TELL " ">
				)
			>
			<SET MASK 32>
		)
	>
	<COND
		(<EQUAL? .ART ,K-ART-A>
			<COND
				(<FSET? .OBJ ,FL-YOUR>
					<TELL C <BOR !\Y .MASK> "our">
				)
				(<FSET? .OBJ ,FL-PLURAL>
					<TELL C <BOR !\S .MASK> "ome">
				)
				(T
					<TELL C <BOR !\A .MASK>>
					<COND
						(<FSET? .OBJ ,FL-VOWEL>
							<TELL !\n>
						)
					>
				)
			>
		)
		(<EQUAL? .ART ,K-ART-THE>
			<COND
				(<FSET? .OBJ ,FL-YOUR>
					<TELL C <BOR !\Y .MASK> "our">
				)
				(T
					<TELL C <BOR !\T .MASK> "he">
				)
			>
		)
		(<EQUAL? .ART ,K-ART-ANY>
			<TELL C <BOR !\A .MASK> "ny">
		)
		(<EQUAL? .ART ,K-ART-HE>
			<COND
				(<AND <FSET? .OBJ ,FL-PLURAL>
						<NOT <FSET? .OBJ ,FL-COLLECTIVE>>
					>
					<TELL C <BOR !\T .MASK> "hey">
				)
				(<NOT <FSET? .OBJ ,FL-PERSON>>
					<TELL C <BOR !\I .MASK> "t">
				)
				(<EQUAL? .OBJ ,CH-PLAYER>
					<TELL C <BOR !\Y .MASK> "ou">
				)
				(<FSET? .OBJ ,FL-FEMALE>
					<TELL C <BOR !\S .MASK> "he">
				)
				(T
					<TELL C <BOR !\H .MASK> "e">
				)
			>
		)
		(<EQUAL? .ART ,K-ART-HIM>
			<COND
				(<AND <FSET? .OBJ ,FL-PLURAL>
						<NOT <FSET? .OBJ ,FL-COLLECTIVE>>
					>
					<TELL C <BOR !\T .MASK> "hem">
				)
				(<NOT <FSET? .OBJ ,FL-PERSON>>
					<TELL C <BOR !\I .MASK> "t">
				)
				(<EQUAL? .OBJ ,CH-PLAYER>
					<TELL C <BOR !\Y .MASK> "ou">
				)
				(<FSET? .OBJ ,FL-FEMALE>
					<TELL C <BOR !\H .MASK> "er">
				)
				(T
					<TELL C <BOR !\H .MASK> "im">
				)
			>
		)
		(<EQUAL? .ART ,K-ART-HIS>
			<COND
				(<AND <FSET? .OBJ ,FL-PLURAL>
						<NOT <FSET? .OBJ ,FL-COLLECTIVE>>
					>
					<TELL C <BOR !\T .MASK> "heir">
				)
				(<NOT <FSET? .OBJ ,FL-PERSON>>
					<TELL C <BOR !\I .MASK> "ts">
				)
				(<EQUAL? .OBJ ,CH-PLAYER>
					<TELL C <BOR !\Y .MASK> "our">
				)
				(<FSET? .OBJ ,FL-FEMALE>
					<TELL C <BOR !\H .MASK> "er">
				)
				(T
					<TELL C <BOR !\H .MASK> "is">
				)
			>
		)
	>
>

<ROUTINE RT-PRINT-OBJ ("OPT" (O <>) (ART ,K-ART-THE) (CAP? <>) (VERB <>) (SP? T) "AUX" (MASK 0))
	<COND
		(<NOT .O>
			<SET O ,PRSO>
		)
	>
;	<THIS-IS-IT .O>
	<COND
		(<FSET? .O ,FL-HAS-SDESC>
			<APPLY <GETP .O ,P?ACTION> ,M-OBJDESC .ART .CAP?>
		)
		(<EQUAL? .ART ,K-ART-HE ,K-ART-HIM ,K-ART-HIS>
			<FSET .O ,FL-SEEN>
			<PRINT-ARTICLE .O .ART .CAP?>
		)
		(<NOT <FSET? .O ,FL-NO-ARTICLE>>
			<FSET .O ,FL-SEEN>
			<PRINT-ARTICLE .O .ART .CAP?>
			<TELL " " D .O>
		)
		(T
			<COND
				(<NOT .CAP?>
					<TELL " ">
					<SET MASK 32>
				)
			>
			<COND
				(<EQUAL? .O ,CH-PLAYER>
					<TELL C <BOR !\Y .MASK> "ou">
				)
				(T
					<TELL D .O>
				)
			>
		)
	>
	<COND
		(.VERB
			<RT-PRINT-VERB .O .VERB>
		)
	>
>

<GLOBAL QCONTEXT:OBJECT <>>
<GLOBAL LIT:OBJECT <>>
<GLOBAL P-IT-OBJECT:OBJECT <>>
<GLOBAL P-THEM-OBJECT:OBJECT <>>
<GLOBAL P-HER-OBJECT:OBJECT <>>
<GLOBAL P-HIM-OBJECT:OBJECT <>>
;<GLOBAL P-ONE-NOUN <VOC "SWORD">>

<CONSTANT K-DIROUT-TBL <ITABLE 255 (LENGTH BYTE) 0>>

<ROUTINE THIS-IS-IT (OBJ)
	<COND
		(<EQUAL? .OBJ <> ,ROOMS ,NOT-HERE-OBJECT ,CH-PLAYER ,INTDIR ,GLOBAL-HERE>
			<RTRUE>
		)
		(<AND <DIR-VERB?>
				<==? .OBJ ,PRSO>
			>
			<RTRUE>
		)
	>
	<COND
		(<FSET? .OBJ ,FL-PERSON>
			<COND
				(<FSET? .OBJ ,FL-FEMALE>
					<FSET ,HER ,FL-TOUCHED>
					<SETG P-HER-OBJECT .OBJ>
				)
				(T
					<FSET ,HIM ,FL-TOUCHED>
					<SETG P-HIM-OBJECT .OBJ>
				)
			>
		)
		(<AND <FSET? .OBJ ,FL-PLURAL>
				<NOT <FSET? .OBJ ,FL-COLLECTIVE>>
			>
			<FSET ,THEM ,FL-TOUCHED>
			<SETG P-THEM-OBJECT .OBJ>
		)
		(T
			<FSET ,IT ,FL-TOUCHED>	;"to cause pronoun 'it' in output"
			<SETG P-IT-OBJECT .OBJ>
		)
	>
	<RTRUE>
>

;<ROUTINE NO-PRONOUN? (OBJ "OPTIONAL" (CAP 0))
	<COND
		(<EQUAL? .OBJ ,CH-PLAYER>
			<RFALSE>
		)
		(<NOT <FSET? .OBJ ,FL-PERSON>>
			<COND
				(<AND <EQUAL? .OBJ ,P-IT-OBJECT>
						<FSET? ,IT ,FL-TOUCHED>
					>
					<RFALSE>
				)
			>
		)
		(<FSET? .OBJ ,FL-FEMALE>
			<COND
				(<AND <EQUAL? .OBJ ,P-HER-OBJECT>
						<FSET? ,HER ,FL-TOUCHED>
					>
					<RFALSE>
				)
			>
		)
		(T
			<COND
				(<AND <EQUAL? .OBJ ,P-HIM-OBJECT>
						<FSET? ,HIM ,FL-TOUCHED>
					>
					<RFALSE>
				)
			>
		)
	>
	<COND
		(<ZERO? .CAP>
			<TELL the .OBJ>
		)
		(<ONE? .CAP>
			<TELL The .OBJ>
		)
	>
	<THIS-IS-IT .OBJ>
	<RTRUE>
>

<ROUTINE RT-PRINT-VERB (OBJ VERB)
	<TELL " ">
	<COND
		(<OR	<EQUAL? .OBJ ,CH-PLAYER>
				<AND
					<FSET? .OBJ ,FL-PLURAL>
					<NOT <FSET? .OBJ ,FL-COLLECTIVE>>
				>
			>
			<TELL .VERB>
		)
		(T
			<COND
				(<=? .VERB "are">
					<TELL "is">
				)
				(<=? .VERB "have">
					<TELL "has">
				)
				(<=? .VERB "try">
					<TELL "tries">
				)
				(<=? .VERB "empty">
					<TELL "empties">
				)
				(<=? .VERB "fly">
					<TELL "flies">
				)
				(<=? .VERB "dry">
					<TELL "dries">
				)
				(T
					<TELL .VERB>
					<COND
						(<EQUAL? .VERB
"do" "kiss" "push" "miss" "pass" "toss" "touch" "catch" "snatch" "brush">
							<TELL "e">
						)
					>
					<TELL "s">
				)
			>
		)
	>
>

<ROUTINE RT-IN-ON-MSG (OBJ "OPT" (CAP? <>) "AUX" (MASK 0))
	<COND
		(<NOT <EQUAL? .OBJ ,TH-BEHIND-G-STONE ,TH-BEHIND-ROCK ,TH-BEHIND-DOOR>>
			<COND
				(<NOT .CAP?>
					<TELL " ">
					<SET MASK 32>
				)
			>
			<COND
				(<FSET? .OBJ ,FL-CONTAINER>
					<TELL C <BOR !\I .MASK>>
				)
				(T
					<TELL C <BOR !\O .MASK>>
				)
			>
			<TELL "n">
		)
	>
>

<ROUTINE RT-OUT-OFF-MSG (OBJ "OPT" (CAP? <>))
	<COND
		(<OR	<FSET? .OBJ ,FL-SURFACE>
				<FSET? .OBJ ,FL-CONTAINER>
			>
			<COND
				(<NOT .CAP?>
					<TELL " o">
				)
				(T
					<TELL "O">
				)
			>
			<COND
				(<FSET? .OBJ ,FL-SURFACE>
					<TELL "ff">
				)
				(T
					<TELL "ut">
				)
			>
		)
	>
>

<ROUTINE RT-OPEN-MSG ("OPT" (OBJ <>))
	<COND
		(<NOT .OBJ>
			<SET OBJ ,PRSO>
		)
	>
	<TELL " ">
	<COND
		(<FSET? .OBJ ,FL-OPEN>
			<TELL "open">
		)
		(T
			<TELL "closed">
		)
	>
>

<ROUTINE RT-WALK-MSG ("OPT" (ING? <>) "AUX" N)
	<TELL " ">
	<COND
		(<MC-FORM? ,K-FORM-ARTHUR>
			<TELL "walk">
		)
		(<MC-FORM? ,K-FORM-OWL>
			<SET N <RANDOM 3>>
			<COND
				(<EQUAL? .N 1>
					<TELL "fly">
				)
				(<EQUAL? .N 2>
					<TELL "hop">
				)
				(T
					<TELL "scurry">
				)
			>
		)
		(<MC-FORM? ,K-FORM-BADGER ,K-FORM-SALAMANDER>
			<SET N <RANDOM 4>>
			<COND
				(<EQUAL? .N 1>
					<TELL "walk">
				)
				(<EQUAL? .N 2>
					<TELL "crawl">
				)
				(<EQUAL? .N 3>
					<TELL "scamper">
				)
				(T
					<TELL "scurry">
				)
			>
		)
		(<MC-FORM? ,K-FORM-EEL ,K-FORM-TURTLE>
			<SET N <RANDOM 2>>
			<COND
				(<EQUAL? .N 1>
					<TELL "swim">
					<COND
						(.ING?
							<TELL "m">
						)
					>
				)
				(T
					<TELL "glid">
					<COND
						(<NOT .ING?>
							<TELL "e">
						)
					>
				)
			>
		)
	>
	<COND
		(.ING?
			<TELL "ing">
		)
	>
>

<ROUTINE RT-STANDING-MSG ("AUX" N)
	<TELL " ">
	<COND
		(<MC-FORM? ,K-FORM-ARTHUR>
			<TELL "standing">
		)
		(T
			<COND
				(<MC-FORM? ,K-FORM-OWL>
					<TELL "scamper">
				)
				(<MC-FORM? ,K-FORM-BADGER ,K-FORM-SALAMANDER>
					<TELL "crawl">
				)
				(<MC-FORM? ,K-FORM-EEL>
					<SET N <RANDOM 2>>
					<COND
						(<EQUAL? .N 1>
							<TELL "swimm">
						)
						(T
							<TELL "float">
						)
					>
				)
				(<MC-FORM? ,K-FORM-TURTLE>
					<COND
						(<FSET? ,HERE ,FL-WATER>
							<TELL "swimm">
						)
						(T
							<TELL "crawl">
						)
					>
				)
			>
			<TELL "ing around">
		)
	>
>

;"---------------------------------------------------------------------------"
; "Canonical hour"
;"---------------------------------------------------------------------------"

<GLOBAL GL-BELL-WAIT:FLAG <> <> BYTE>

<ROUTINE RT-I-BELL ()
	<RT-QUEUE ,RT-I-BELL <+ ,GL-MOVES 180>>
	<COND
		(<NOT <FSET? ,CH-CELL-GUARD ,FL-ASLEEP>>
			<RT-QUEUE ,RT-I-GUARD-1 <+ ,GL-MOVES 1>>
		)
	>
	<SETG GL-POEM-LINE 0>
	<COND
		(<NOT <FSET? ,CH-PLAYER ,FL-ASLEEP>>
			<COND
				(<AND <NOT <MC-HERE? ,RM-GREAT-HALL ,RM-BEHIND-THRONE>>
						<VERB? WAIT>
						<OR
							,GL-BELL-WAIT
							<G? ,GL-NEW-TIME <+ ,GL-MOVES 180>>
						>
					>
					<COND
						(<NOT ,GL-BELL-WAIT>
							<SETG GL-BELL-WAIT T>
							<TELL
"|While you wait, you hear the bells in the distance tolling the hours.|"
							>
						)
					>
					<RFALSE>
				)
				(T
					<COND
						(<NOT <VERB? WAIT>>
							<SETG GL-BELL-WAIT <>>
						)
					>
					<TELL
"|In the distance, you hear the sound of the bells calling the monks to
prayer.|"
					>
					<COND
						(<AND <MC-HERE? ,RM-GREAT-HALL>
								<NOT <FSET? ,CH-SOLDIERS ,FL-LOCKED>>
							>
							<TELL "|The soldier">
							<RT-LEAVE-CASTLE>
							<RTRUE>
						)
						(<MC-HERE? ,RM-GREAT-HALL ,RM-BEHIND-THRONE>
							<SETG GL-POEM-LINE <RANDOM 4>>
							<TELL
"|King Lot calls out to the captain of his guards, \"The new password is
verse three, line" wn ,GL-POEM-LINE ".\"|"
							>
							<COND
								(<NOT <FSET? ,TH-PASSWORD ,FL-TOUCHED>>
									<FSET ,TH-PASSWORD ,FL-TOUCHED>
									<RT-SCORE-MSG 0 2 0 1>
								)
							>
							<RTRUE>
						)
					>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "Queue handling"
;"---------------------------------------------------------------------------"

<GLOBAL CLOCK-WAIT:FLAG <>>
<GLOBAL GL-CLK-RUN:FLAG <>>
<GLOBAL GL-Q-MAX 0 <> BYTE>
<CONSTANT K-Q-NUM 20>
<CONSTANT K-Q-SIZE <* ,K-Q-NUM 2>>
<GLOBAL GL-Q-TBL <ITABLE ,K-Q-SIZE 0>>
<GLOBAL GL-MOVES 1432>	; "Start 8 moves before midnight"
<GLOBAL GL-NEW-TIME 0>
<GLOBAL GL-QUESTION 0 <> BYTE>

<CONSTANT K-TIME-PASSES-MSG "Time passes...">

<ROUTINE CLOCKER ("AUX" NT (ABORT? <>))

	<SETG GL-DROP-HERE <>>	; "Reset this every turn."

	<COND
		(<EQUAL? ,GL-QUESTION 1>
			<INC GL-QUESTION>
		)
		(T
			<SETG GL-QUESTION 0>
		)
	>

	<COND
		(,CLOCK-WAIT
			<SETG CLOCK-WAIT <>>
			<RFALSE>
		)
	>
	<SETG GL-NEW-TIME ,GL-MOVES>
	<SET NT ,GL-MOVES>
	<REPEAT (RTN TIME ANY? MULT? DIF N (VAL <>))
		<COND
			(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-INVT>
				<COND
					(<BAND ,GL-UPDATE-WINDOW ,K-UPD-INVT>
						<RT-UPDATE-INVT-WINDOW>
					)
				>
			)
			(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
				<COND
					(<OR	<BAND ,GL-UPDATE-WINDOW ,K-UPD-DESC>
							<BAND ,GL-UPDATE-WINDOW ,K-UPD-OBJS>
						>
						<RT-UPDATE-DESC-WINDOW>
					)
				>
			)
		>
		<SET RTN <>>
		<SET TIME .NT>
		<SET ANY? <>>
		<SET MULT? <>>
		<REPEAT ((I 0) Z1 Z2)
			<SET Z1 <ZGET ,GL-Q-TBL .I>>
			<SET Z2 <ZGET ,GL-Q-TBL <+ .I 1>>>
			<COND
				(<AND .Z1
						<L=? .Z2 .TIME>
					>
					<COND
						(<AND .RTN
								<EQUAL? .Z2 .TIME>
							>
							<SET MULT? T>
						)
					>
					<SET RTN .Z1>
					<SET TIME .Z2>
					<SET N .I>
					<SET ANY? T>
				)
			>
			<SET I <+ .I 2>>
			<COND
				(<OR	<G=? .I ,K-Q-SIZE>
						<G=? .I ,GL-Q-MAX>
					>
					<RETURN>
				)
			>
		>
		<COND
			(.ANY?
				<SETG GL-MOVES .TIME>
				<COND
					(<NOT <FSET? ,CH-PLAYER ,FL-ASLEEP>>
						<UPDATE-STATUS-LINE>
					)
				>
				<SET DIF <L? .TIME .NT>>
				<PUT ,GL-Q-TBL .N 0>
				<PUT ,GL-Q-TBL <+ .N 1> 0>
				<COND
					(<EQUAL? <+ .N 2> ,GL-Q-MAX>
						<SETG GL-Q-MAX <- ,GL-Q-MAX 2>>
					)
				>
				<SETG GL-CLK-RUN T>
				<COND
					(<APPLY .RTN>
						<SET VAL T>
					)
				>
				<SETG GL-CLK-RUN <>>
				<COND
					(<G? ,GL-MOVES .NT>
						<SETG GL-NEW-TIME ,GL-MOVES>
						<SET NT ,GL-MOVES>
					)
				>
				<COND
					(<AND .VAL
							<NOT .MULT?>
							.DIF
							<VERB? WAIT>
							<NOT <FSET? ,CH-PLAYER ,FL-ASLEEP>>
						>
						<SET VAL <>>
						<TELL "|Do you want to continue waiting">
						<COND
							(<NOT <YES?>>
								<SET NT .TIME>
								<SET ABORT? T>
								<RETURN>
							)
							(T
								<TELL ,K-TIME-PASSES-MSG CR>
							)
						>
					)
				>
			)
			(T
				<RETURN>
			)
		>
	>
	<SETG GL-MOVES .NT>
	<INC GL-MOVES>

	;"Re-enable messages which happen only once during a wait."
	<SETG GL-IDIOT-WAIT <>>
	<SETG GL-BELL-WAIT <>>

	<COND
		(.ABORT?
			<RFATAL>
		)
		(T
			<RFALSE>
		)
	>
>

<ROUTINE RT-QUEUE (RTN TIME "OPT" (ABS? <>))
;	<COND
		(<AND <NOT ,GL-CLK-RUN>
				<NOT .ABS?>
			>
			<INC TIME>
		)
	>
	<REPEAT ((I 0))
		<COND
			(<ZERO? <GET ,GL-Q-TBL .I>>
				<PUT ,GL-Q-TBL .I .RTN>
				<PUT ,GL-Q-TBL <+ .I 1> .TIME>
				<COND
					(<G? <+ .I 2> ,GL-Q-MAX>
						<SETG GL-Q-MAX <+ .I 2>>
					)
				>
				<RTRUE>
			)
			(<G=? <SET I <+ .I 2>> ,K-Q-SIZE>
				<RFALSE>
			)
		>
	>
>

<ROUTINE RT-DEQUEUE (RTN)
	<REPEAT ((I 0))
		<COND
			(<EQUAL? <GET ,GL-Q-TBL .I> .RTN>
				<PUT ,GL-Q-TBL .I 0>
				<PUT ,GL-Q-TBL <+ .I 1> 0>
				<COND
					(<EQUAL? <+ .I 2> ,GL-Q-MAX>
						<SETG GL-Q-MAX <- ,GL-Q-MAX 2>>
					)
				>
				<RTRUE>
			)
			(<OR	<G=? <SET I <+ .I 2>> ,K-Q-SIZE>
					<G=? .I ,GL-Q-MAX>
				>
				<RFALSE>
			)
		>
	>
>

<ROUTINE RT-IS-QUEUED? (RTN "AUX" (TIME 0))
	<REPEAT ((I 0))
		<COND
			(<EQUAL? <ZGET ,GL-Q-TBL .I> .RTN>
				<SET TIME <ZGET ,GL-Q-TBL <+ .I 1>>>
				<RETURN>
			)
			(<OR	<G=? <SET I <+ .I 2>> ,K-Q-SIZE>
					<G=? .I ,GL-Q-MAX>
				>
				<RFALSE>
			)
		>
	>
	<RETURN .TIME>
>

;"---------------------------------------------------------------------------"
; "YZIP"
;"---------------------------------------------------------------------------"

<ROUTINE C-PIXELS (X) <+ <* <- .X 1> ,GL-FONT-X> 1>>
<ROUTINE L-PIXELS (Y) <+ <* <- .Y 1> ,GL-FONT-Y> 1>>
;<ROUTINE PIXELS-C (X) <+ </ <- .X 1> ,GL-FONT-X> 1>>
;<ROUTINE PIXELS-L (Y) <+ </ <- .Y 1> ,GL-FONT-Y> 1>>
<ROUTINE CCURSET (Y X "OPT" (W -3)) <CURSET <L-PIXELS .Y> <C-PIXELS .X> .W>>
;<ROUTINE CCURGET (TBL)
	<CURGET .TBL>
	<PUT .TBL 0 <PIXELS-L <GET .TBL 0>>>
	<PUT .TBL 1 <PIXELS-C <GET .TBL 1>>>
	.TBL
>
<ROUTINE CSPLIT (Y) <SPLIT <* .Y ,GL-FONT-Y>>>
;	<ROUTINE CWINPOS (W Y X) <WINPOS .W <L-PIXELS .Y> <C-PIXELS .X>>>
;	<ROUTINE CWINSIZE (W Y X) <WINSIZE .W <* .Y ,GL-FONT-Y> <* .X ,GL-FONT-X>>>
;	<ROUTINE CMARGIN (L R "OPT" (W -3)) <MARGIN <* .L ,GL-FONT-X> <* .R ,GL-FONT-X> .W>>
;	<ROUTINE CPICINF (P TBL)
	<PICINF .P .TBL>
	<PUT .TBL 0 </ <GET .TBL 0> ,GL-FONT-Y>>
	<PUT .TBL 1 </ <GET .TBL 1> ,GL-FONT-X>>
>
;	<ROUTINE CDISPLAY (P Y X)
	<DISPLAY .P
		<COND (<ZERO? .Y> 0) (ELSE <L-PIXELS .Y>)>
		<COND (<ZERO? .X> 0) (ELSE <C-PIXELS .X>)>
	>
>
;	<ROUTINE CDCLEAR (P Y X)
	<DCLEAR .P
		<COND (<ZERO? .Y> 0) (ELSE <L-PIXELS .Y>)>
		<COND (<ZERO? .X> 0) (ELSE <C-PIXELS .X>)>
	>
>
;	<ROUTINE CSCROLL (W "OPT" (Y 1)) <SCROLL .W <* .Y ,GL-FONT-Y>>>
<ROUTINE RT-SCRIPT-INBUF ("OPT" (BUF ,P-INBUF) "AUX" (CNT 0) N CHR)
	<SET N <GETB .BUF 1>>
	<DIROUT ,D-SCREEN-OFF>
	<SET BUF <REST .BUF>>
	<REPEAT ()
		<COND
			(<IGRTR? CNT .N>
				<RETURN>
			)
			(ELSE
				<SET CHR <GETB .BUF .CNT>>
				<COND
					(<AND <G=? .CHR !\a>
							<L=? .CHR !\z>
						>
						<PRINTC <- .CHR 32>>
					)
					(ELSE
						<PRINTC .CHR>
					)
				>
			)
		>
	>
	<CRLF>
	<DIROUT ,D-SCREEN-ON>
>

;"---------------------------------------------------------------------------"
; "Pictures"
;"---------------------------------------------------------------------------"

<GLOBAL GL-PICTURE-NUM ,K-PIC-CHURCHYARD>

;"---------------------------------------------------------------------------"
; "GO"
;"---------------------------------------------------------------------------"

<GLOBAL GL-SCR-WID:NUMBER 79>
<CONSTANT K-WIN-TBL <TABLE 0 0 0 0>>
<GLOBAL GL-FONT-X 7 <> BYTE>
<GLOBAL GL-FONT-Y 10 <> BYTE>
<GLOBAL GL-SPACE-WIDTH 0 <> BYTE>

<ROUTINE GO ()
	<SETG GL-SCR-WID <LOWCORE SCRH>>
;	<COND
		(<L? ,GL-SCR-WID 64>
			<TELL "[The screen is too narrow.]" CR>
			<QUIT>
		)
	>
	<SETG GL-FONT-Y <ANDB <SHIFT <WINGET 0 ,WFSIZE> -8> 255>>
	<SETG GL-FONT-X <ANDB <WINGET 0 ,WFSIZE> 255>>

	; "Determine width of space in pixels."
	<DIROUT ,K-D-TBL-ON ,K-DIROUT-TBL>
	<TELL " ">
	<DIROUT ,K-D-TBL-OFF>
	<SETG GL-SPACE-WIDTH <LOWCORE TWID>>
	<COND
		(<ZERO? ,GL-SPACE-WIDTH>
			; "The following is done this way so that no temporary locals are
				created by the compiler."
			<SETG GL-SPACE-WIDTH <LOWCORE HWRD>>
			<SETG GL-SPACE-WIDTH </ ,GL-SPACE-WIDTH <LOWCORE SCRH>>>
		)
	>

	<MOUSE-LIMIT -1>
	<CLEAR -1>
	<RT-CENTER-PIC ,K-PIC-TITLE>
	<CURSET -1>	;"Make cursor go away."
	<INPUT 1 150 ,RT-STOP-READ>
	<CURSET -2>	;"Make cursor come back."
	<CLEAR -1>
	<TELL
"Merlin appears before you and his voice thunders in your ears, \"Listen
well, Arthur, for now will the mysteries of your childhood be made clear to
you. Your true father was Uther Pendragon, high King of England. Your mother
was Ygraine of Cornwall. When you were born, you were given to me to raise
and keep safe until such time as England had need of you.\"" CR CR

"\"To you alone belongs the throne of England, Arthur. But the time is not
yet when you may take up this sword. Before you gain your birthright, you
must prove yourself a king. To rule England you must be both wise and
chivalrous. To lead her armies you must be strong and courageous. I believe
you have these qualities within you, but you must demonstrate them for all
to see. In so doing, you will gain the experience you need to claim the
sword.\"" CR CR

"\"Come seek me out at my cave beyond the meadow, and I will help you achieve
your quest. Be warned, however, that another plots to steal your throne. Go,
therefore, son of Uther, to earn and protect that which is yours.\"" CR
>
	<INPUT 1 600 ,RT-STOP-READ>
	<CLEAR -1>
	<REPEAT ()
		<TELL CR "Would you like to restore a saved position?" CR>
		<COND
			(<Y?>
				<V-RESTORE>
			)
			(T
				<RETURN>
			)
		>
	>
	<CLEAR -1>
	<RT-CENTER-PIC ,K-PIC-SWORD>
	<CURSET -1>	;"Make cursor go away."
	<INPUT 1 150 ,RT-STOP-READ>
	<CURSET -2>	;"Make cursor come back."
	<CLEAR -1>
	<TELL
"You are shivering in the cold night air of an English churchyard, unsure of
the forces that are driving you on this night of destiny. Here among the
gravestones, the most famous sword in all England grows out of a large,
oddly-shaped rock. A shaft of moonlight falls upon the magic runes that
shimmer in the polished steel:" CR CR

,K-WHOSO-PULLETH-MSG "." CR CR

"The local chieftain, King Lot, has declared a curfew, and you know that even
a boy such as yourself would be thrown in prison should you be caught by his
soldiers. Yet you have come anyway, irresistibly drawn by this sword of
mystery. Noblemen from far and wide have tried and failed to draw the sword
from the stone, yet something inside urges you to try." CR CR

"Slowly you approach the sword. Driven by some inner force, you clasp your
hand around the hilt. The two seem made for one another. You pull. Nothing
happens. You strain harder. The sword gives a little, and then...." CR
	>
	<INPUT 1 600 ,RT-STOP-READ>
	<CLEAR -1>
	<RT-CENTER-PIC ,K-PIC-SWORD>
	<RT-CENTER-PIC ,K-PIC-SWORD-MERLIN>
	<CURSET -1>	;"Make cursor go away."
	<INPUT 1 150 ,RT-STOP-READ>
	<CURSET -2>	;"Make cursor come back."
	<CLEAR -1>
	<INIT-STATUS-LINE>
	<SETG LIT <LIT?>>
	<SETG GL-PICTURE-NUM ,K-PIC-CHURCHYARD>
	<RT-UPDATE-PICT-WINDOW T>
	<V-FIRST-LOOK>
	<RT-QUEUE ,RT-I-SOLDIER-1 1437 T>
	<RT-QUEUE ,RT-I-BELL 1439 T>				;"1439 instead of 1440 - kludge"
	<RT-QUEUE ,RT-I-SUNSET 2490 T>			;"17:30 every day"
	<RT-QUEUE ,RT-I-BLOOM 4695 T>				;" 6:15 on day 3 (Christmas)"
	<RT-QUEUE ,RT-I-OUT-OF-TIME 5040 T>		;"12:00 on day 3"
	<MAIN-LOOP>
	<AGAIN>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

