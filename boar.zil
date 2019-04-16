;"***************************************************************************"
; "game : Arthur"
; "file : BOAR.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   15 May 1989 19:42:24  $"
; "revs : $Revision:   1.60  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Boar puzzle"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "RM-NORTH-OF-CHASM"
;"---------------------------------------------------------------------------"

<ROOM RM-NORTH-OF-CHASM
	(LOC ROOMS)
	(DESC "north of chasm")
	(FLAGS FL-LIGHTED FL-SURFACE)
	(SOUTH PER RT-OVER-CHASM)
	(UP PER RT-FLY-UP)
	(DOWN PER RT-ENTER-CHASM)
	(ADJACENT <TABLE (LENGTH BYTE PURE) RM-SOUTH-OF-CHASM T>)
	(GLOBAL LG-CHASM LG-ENCHANTED-TREES LG-FOREST RM-SOUTH-OF-CHASM)
	(ACTION RT-RM-NORTH-OF-CHASM)
>

<ROUTINE RT-RM-NORTH-OF-CHASM ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,LG-CHASM ,FL-SEEN>
			<FSET ,TH-BOAR ,FL-SEEN>
			<TELL
"You are on the northern lip of a narrow chasm in the heart of the forest. "
			>
			<THIS-IS-IT ,TH-BOAR>
			<COND
				(<FSET? ,TH-BOAR ,FL-ALIVE>
					<COND
						(<MC-FORM? ,K-FORM-ARTHUR>
							<TELL The ,TH-BOAR " ">
							<COND
								(<EQUAL? ,GL-BOAR-NUM 1>
									<TELL
"is a short distance away, madly pawing the ground as if he is about to make
a charge at you"
									>
								)
								(T
									<TELL
"is thundering towards you. There is a mad, wild gleam in his eyes, and his
single tusk is poised to strike your unprotected flesh"
									>
								)
							>
						)
						(T
							<TELL "Nearby you see" a ,TH-BOAR ,K-PACING-MSG>
						)
					>
				)
				(T
					<TELL A ,TH-BOAR>
					<COND
						(<IN? ,TH-TUSK ,TH-BOAR>
							<FSET ,TH-TUSK ,FL-SEEN>
							<TELL ,K-SINGLE-TUSK-MSG>
						)
					>
					<TELL " lies on" the ,TH-GROUND>
				;	<COND
						(<IN? ,TH-SWORD ,TH-BOAR>
							<TELL "," ,K-IMPALED-MSG>
						)
					>
				)
			>
			<TELL "." CR>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-NORTH-OF-CHASM>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-END>
			<COND
				(<AND <FSET? ,TH-BOAR ,FL-ALIVE>
						<VERB? TRANSFORM>
						<NOT <MC-FORM? ,GL-OLD-FORM>>
					>
					<CRLF>
					<COND
						(<MC-FORM? ,K-FORM-ARTHUR>
							<SETG GL-BOAR-NUM 1>
							<RT-QUEUE ,RT-I-BOAR <+ ,GL-MOVES 1>>
							<THIS-IS-IT ,TH-BOAR>
							<TELL
The ,TH-BOAR " looks startled, and then starts to paw the ground like a bull
about to charge.|"
							>
						)
						(T
							<SETG GL-BOAR-NUM 0>
							<RT-DEQUEUE ,RT-I-BOAR>
							<THIS-IS-IT ,TH-BOAR>
							<TELL
"Startled," the ,TH-BOAR " stops dead in his tracks, and then resumes his
wild pacing.|"
							>
						)
					>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
							<RT-UPDATE-DESC-WINDOW>
						)
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
							<RT-UPDATE-PICT-WINDOW>
						)
					>
					<RTRUE>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "LG-CHASM"
;"---------------------------------------------------------------------------"

<OBJECT LG-CHASM
	(LOC LOCAL-GLOBALS)
	(DESC "chasm")
	(SYNONYM CHASM CLIFF SIDE)
	(ADJECTIVE OTHER)
	(OWNER LG-CHASM)	; "For OTHER SIDE OF CHASM"
	(ACTION RT-LG-CHASM)
>

<ROUTINE RT-LG-CHASM ("OPT" (CONTEXT <>) "AUX" RM)
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<AND <NOUN-USED? ,LG-CHASM ,W?SIDE>
				<ADJ-USED? ,LG-CHASM ,W?OTHER>
			>
			<COND
				(,NOW-PRSI
					<COND
						(<AND <OR
									<VERB? THROW>
									<AND
										<VERB? PUT PUT-IN>
										<VERB-WORD? ,W?THROW ,W?TOSS ,W?HURL ,W?CHUCK ,W?FLING ,W?PITCH ,W?HEAVE>
									>
								>
								<IDROP>
							>
							<RT-MOVE-OVER-CHASM ,PRSO>
						)
					>
				)
				(<VERB? WALK-TO ENTER CLIMB-OVER>
					<COND
						(<MC-HERE? ,RM-SOUTH-OF-CHASM>
							<RT-DO-WALK ,P?NORTH>
						)
						(<MC-HERE? ,RM-NORTH-OF-CHASM>
							<RT-DO-WALK ,P?SOUTH>
						)
					>
				)
			>
		)
		(<VERB? PUT PUT-IN THROW>
			<COND
				(<IDROP>
					<REMOVE ,PRSO>
					<TELL
The+verb ,PRSO "sail" " into" the ,LG-CHASM " and quickly disappears from
sight." CR
					>
				)
			>
		)
		(<VERB? THROW-OVER>
			<COND
				(<IDROP>
					<RT-MOVE-OVER-CHASM ,PRSO>
				)
			>
		)
		(<VERB? CLIMB-OVER>
			<COND
				(<MC-HERE? ,RM-SOUTH-OF-CHASM>
					<RT-DO-WALK ,P?NORTH>
				)
				(<MC-HERE? ,RM-NORTH-OF-CHASM>
					<RT-DO-WALK ,P?SOUTH>
				)
			>
		)
		(<VERB? ENTER DISMOUNT>
			<COND
				(<MC-FORM? ,K-FORM-OWL>
					<TELL ,K-UPDRAFT-MSG>
					<RT-GOTO <RT-FLY-UP> T>
					<RTRUE>
				)
				(<VERB-WORD? ,W?JUMP ,W?DIVE ,W?LEAP>
					<TELL
"Throwing caution to the winds, you leap into the chasm. On the way down, you
notice that the walls are gray and jagged. When you land at the bottom, you
notice that you are squashed and dead.|"
					>
					<RT-END-OF-GAME>
				)
				(T
					<TELL "The steep cliffs are too dangerous to climb down." CR>
				)
			>
		)
		(<VERB? EXAMINE LOOK-IN LOOK-DOWN>
			<FSET ,LG-CHASM ,FL-SEEN>
			<TELL "It looks like a long way down." CR>
		)
	>
>

<CONSTANT K-UPDRAFT-MSG "A strong updraft pushes you high into the air.||">

<ROUTINE RT-ENTER-CHASM ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<RETURN ,LG-CHASM>
		)
		(<MC-FORM? ,K-FORM-OWL>
			<TELL ,K-UPDRAFT-MSG>
			<RT-GOTO <RT-FLY-UP> T>
			<RFALSE>
		)
		(T
			<TELL "The steep cliffs are too dangerous to climb down.|">
			<RFALSE>
		)
	>
>

<ROUTINE RT-MOVE-OVER-CHASM (OBJ)
	<COND
		(<MC-HERE? ,RM-SOUTH-OF-CHASM>
			<COND
				(<EQUAL? .OBJ ,TH-APPLE>
					<RT-APPLE-MSG>
				)
				(T
					<MOVE .OBJ ,RM-NORTH-OF-CHASM>
					<THIS-IS-IT .OBJ>
					<THIS-IS-IT ,TH-BOAR>
					<TELL
The+verb .OBJ "sail" " through the air and" verb .OBJ "fall" " on the ground
near" the ,TH-BOAR "." CR
					>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT ,K-UPD-DESC>>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
							<RT-UPDATE-DESC-WINDOW>
						)
					>
					<RTRUE>
				)
			>
		)
		(<MC-HERE? ,RM-NORTH-OF-CHASM>
			<MOVE .OBJ ,RM-SOUTH-OF-CHASM>
			<COND
				(<AND <EQUAL? .OBJ ,TH-TUSK>
						<NOT <FSET? ,TH-TUSK ,FL-BROKEN>>
					>
					<FSET ,TH-TUSK ,FL-BROKEN>
					<PUTP ,TH-TUSK ,P?SCORE %<LSH 2 ,K-WISD-SHIFT>>
				)
			>
			<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT>>
			<THIS-IS-IT .OBJ>
			<TELL
The+verb .OBJ "fall" " to the ground on the other side of" the ,LG-CHASM "." CR
			>
		)
	>
>

<ROUTINE RT-OVER-CHASM ("OPT" (QUIET <>))
	<COND
		(<OR	.QUIET
				<MC-FORM? ,K-FORM-OWL>
			>
			<COND
				(<EQUAL? ,P-WALK-DIR ,P?NORTH>
					<RETURN ,RM-NORTH-OF-CHASM>
				)
				(T
					<RETURN ,RM-SOUTH-OF-CHASM>
				)
			>
		)
		(T
			<THIS-IS-IT ,LG-CHASM>
			<TELL
"You gauge the distance and decide that" the ,LG-CHASM " is just a little too
wide to jump over.|"
			>
			<RFALSE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-SOUTH-OF-CHASM"
;"---------------------------------------------------------------------------"

<ROOM RM-SOUTH-OF-CHASM
	(LOC ROOMS)
	(DESC "south of chasm")
	(SYNONYM CLEARING)
	(FLAGS FL-LIGHTED)
	(SOUTH TO RM-LEP-PATH)
	(NORTH PER RT-OVER-CHASM)
	(UP PER RT-FLY-UP)
	(DOWN PER RT-ENTER-CHASM)
	(ADJACENT <TABLE (LENGTH BYTE PURE) RM-NORTH-OF-CHASM T>)
	(GLOBAL LG-CHASM LG-ENCHANTED-TREES LG-FOREST LG-PATH RM-NORTH-OF-CHASM RM-LEP-PATH)
	(ACTION RT-RM-SOUTH-OF-CHASM)
>

<ROUTINE RT-RM-SOUTH-OF-CHASM ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "You are" standing " in">
				)
				(T
					<COND
						(<EQUAL? ,OHERE ,RM-LEP-PATH>
							<TELL
"After a while the trees begin to thin out, and soon you find yourself in"
							>
						)
						(T
							<TELL "You are" standing " in">
						)
					>
				)
			>
			<FSET ,LG-CHASM ,FL-SEEN>
			<TELL
" a large clearing in the heart of the forest. The clearing is cleft by a
narrow chasm which lies directly to the north. A path leading into the
forest lies to the south. On the other side of the chasm you see"
			>
			<FSET ,TH-BOAR ,FL-LOCKED>
		;	<FCLEAR ,TH-BOAR ,FL-NO-DESC>
			<PRINT-CONTENTS ,RM-NORTH-OF-CHASM>
			<FCLEAR ,TH-BOAR ,FL-LOCKED>
		;	<FSET ,TH-BOAR ,FL-NO-DESC>
			<FSET ,TH-BOAR ,FL-SEEN>
			<TELL "." CR>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-SOUTH-OF-CHASM>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(.CONTEXT
			<RFALSE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-BOAR"
;"---------------------------------------------------------------------------"

<OBJECT TH-BOAR
	(LOC RM-NORTH-OF-CHASM)
	(FLAGS FL-ALIVE FL-HAS-SDESC FL-NO-LIST FL-OPEN FL-SEARCH)
	(SYNONYM BOAR ANIMAL)
	(ADJECTIVE WILD DEAD)
	(CONTFCN RT-TH-BOAR)
	(ACTION RT-TH-BOAR)
>

; "TH-BOAR flags:"
; "	FL-LOCKED - Give long desc"

<CONSTANT K-PACING-MSG " pacing back and forth">
;<CONSTANT K-IMPALED-MSG " impaled on a sword">
<CONSTANT K-SINGLE-TUSK-MSG " with a single tusk">
<CONSTANT K-BOAR-UNDERSTAND-MSG "The boar doesn't understand you.|">

<ROUTINE RT-TH-BOAR ("OPT" (CONTEXT <>) (ART <>) (CAP? <>) "AUX" P)
	<COND
		(<MC-CONTEXT? ,M-OBJDESC>
			<COND
				(.ART
					<PRINT-ARTICLE ,TH-BOAR .ART .CAP?>
				)
			>
			<COND
				(<EQUAL? .ART <> ,K-ART-THE ,K-ART-A ,K-ART-ANY>
					<COND
						(.ART
							<TELL " ">
						)
					>
					<COND
						(<NOT <FSET? ,TH-BOAR ,FL-ALIVE>>
							<TELL "dead">
						)
						(T
							<TELL "wild">
						)
					>
					<TELL " boar">
					<COND
						(<FSET? ,TH-BOAR ,FL-LOCKED>
							<COND
								(<FSET? ,TH-BOAR ,FL-ALIVE>
									<TELL ,K-PACING-MSG>
								)
							;	(<IN? ,TH-SWORD ,TH-BOAR>
									<TELL ,K-IMPALED-MSG>
								)
							>
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-WINNER>
			<TELL ,K-BOAR-UNDERSTAND-MSG>
		)
	;	(<MC-CONTEXT? ,M-CONT>
			<COND
				(<AND <VERB? TAKE>
						<NOT ,NOW-PRSI>
						<MC-PRSO? ,TH-SWORD>
						<RT-DO-TAKE ,PRSO>
					>
					<TELL
The+verb ,PRSO "pull" " free of the boar's head with a sickening \"thwuck.\"|"
					>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
							<RT-UPDATE-DESC-WINDOW>
						)
					>
					<RTRUE>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<COND
				(<VERB? THROW>
					<COND
						(<MC-PRSO? ,TH-SWORD>
							<TELL "The sword slices through the air and ">
						;	<COND
								(<MC-HERE? ,RM-NORTH-OF-CHASM>
									<SET P 25>
								)
								(T
									<SET P 15>
								)
							>
							<COND
							;	(<MC-PROB? .P>
									<RT-DEQUEUE ,RT-I-BOAR>
									<MOVE ,PRSO ,TH-BOAR>
									<FSET ,PRSO ,FL-NO-DESC>
									<TELL
"imbeds itself right between" the ,TH-BOAR "'s eyes, killing it instantly.|"
									>
									<RT-SCORE-MSG 0 3 7 4>
									<FCLEAR ,TH-BOAR ,FL-ALIVE>
									<FSET ,TH-BOAR ,FL-CONTAINER>
									<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
									<COND
										(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
											<RT-UPDATE-DESC-WINDOW>
										)
										(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
											<RT-UPDATE-PICT-WINDOW>
										)
									>
									<RTRUE>
								)
								(T
									<MOVE ,PRSO ,RM-NORTH-OF-CHASM>
									<TELL
"the hilt smacks" the ,TH-BOAR " right between the eyes"
									>
									<COND
										(<FSET? ,TH-BOAR ,FL-ALIVE> ;"RAB 4/25"
											<TELL ", stunning it momentarily">
										)
									>
									<TELL ".">
									<COND
										(<AND <MC-HERE? ,RM-NORTH-OF-CHASM>
												<FSET? ,TH-BOAR ,FL-ALIVE> ;"RAB 4/24/89"
											>
											<SETG GL-BOAR-NUM 1>
											<TELL
" " The ,TH-BOAR " staggers around for a second, but then recovers and
prepares to charge again."
											>
										)
									>
									<CRLF>
								)
							>
						)
						(<MC-PRSO? ,TH-APPLE>
							<RT-APPLE-MSG>
						)
						(<IDROP>
							<MOVE ,PRSO ,RM-NORTH-OF-CHASM>
							<TELL
The+verb ,PRSO "hit" the ,TH-BOAR " and" verb ,PRSO "fall" " to the ground."
							>
							<COND
								(<FSET? ,TH-BOAR ,FL-ALIVE>
									<TELL " " The ,TH-BOAR " looks madder than ever.">
								)
							>
							<CRLF>
						)
					>
				)
				(<VERB? PUT PUT-IN>
; "Bob - This is to prevent the player from putting things on or in the boar
	once it is dead. When it is dead, it becomes a container so the player can
	get to the tusk. I thought that you wouldn't want the player sticking
	things in the boar like it was a box."
					<TELL The ,WINNER " can't do that." CR>
				)
			>
		)
		(<AND <VERB? TELL>
				,P-CONT
			>
			<RFALSE>
		)
		(<AND <SPEAKING-VERB?>
				<MC-HERE? ,RM-NORTH-OF-CHASM ,RM-SOUTH-OF-CHASM>
			>
			<TELL ,K-BOAR-UNDERSTAND-MSG>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-BOAR ,FL-SEEN>
			<COND
				(<FSET? ,TH-BOAR ,FL-ALIVE>
					<TELL
The ,TH-BOAR " is several hundred angry pounds of pure visciousness. He has
only one tusk, and a gaping hole where the other one used to be." CR
					>
				)
				(T
					<COND
						(<NOT <IN? ,TH-TUSK ,TH-BOAR>>
							<TELL "The badly mangled boar">
						)
						(T
							<TELL The ,TH-BOAR>
						)
					>
					<TELL " lies on" the ,TH-GROUND>
				;	<COND
						(<IN? ,TH-SWORD ,TH-BOAR>
							<TELL "," ,K-IMPALED-MSG>
						)
					>
					<TELL "." CR>
				)
			>
		)
		(<VERB? TAKE MOVE RAISE LOWER THROW PUT-IN PUT>
			<TELL The ,TH-BOAR " is too heavy to move." CR>
		)
		(<VERB? ATTACK CUT>
			<COND
				(<NOT <FSET? ,TH-BOAR ,FL-ALIVE>>
					<TELL "It's already dead." CR>
				)
				(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
					<TELL
"Your feeble efforts fail even to attract" the ,TH-BOAR "'s attention." CR
					>
				)
				(<MC-PRSI? ,TH-SWORD>
				;	<MOVE ,PRSI ,TH-BOAR>
				;	<FSET ,PRSI ,FL-NO-DESC>
				;	<SETG GL-BOAR-NUM 0>
				;	<RT-DEQUEUE ,RT-I-BOAR>
				;	<FCLEAR ,TH-BOAR ,FL-ALIVE>
				;	<FSET ,TH-BOAR ,FL-CONTAINER>
					<TELL
"You brace yourself, hold the sword steady, and sight down the blade at the
onrushing boar. The wild creature charges headlong into the sword and impales
himself on the tip. His momentum carries him halfway up the blade before he
realizes that he is dead. Unfortunately, this still doesn't prevent him
from crashing into you with such force that his tusk rips open your flesh and
kills you instantly.|"
					>
					<RT-END-OF-GAME>
				;	<RT-SCORE-MSG 0 3 7 4>
				;	<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
				;	<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
							<RT-UPDATE-DESC-WINDOW>
						)
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
							<RT-UPDATE-PICT-WINDOW>
						)
					>
				;	<RTRUE>
				)
				(T
					<TELL The ,TH-BOAR " ignores your feeble defense">
					<COND
						(<G? ,GL-BOAR-NUM 1>
							<TELL " and continues his charge">
						)
					>
					<TELL "." CR>
				)
			>
		)
	>
>

<GLOBAL GL-BOAR-NUM 0 <> BYTE>

<ROUTINE RT-I-BOAR ("OPT" (PN? <>))
	<COND
		(,GL-CLK-RUN
			<CRLF>
		)
	>
	<INC GL-BOAR-NUM>
	<COND
		(<EQUAL? ,GL-BOAR-NUM 2>
			<RT-QUEUE ,RT-I-BOAR <+ ,GL-MOVES 1>>
			<TELL The ,TH-BOAR " starts his charge.|">
			<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
					<RT-UPDATE-DESC-WINDOW>
				)
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RTRUE>
		)
		(T
			<COND
				(.PN?
					<TELL He ,TH-BOAR>
				)
				(T
					<TELL The ,TH-BOAR>
				)
			>
			<TELL
" slams into you at full speed, ripping your flesh open with his tusk and
severing an artery. You fall to the ground and discover with dismay how
little time it takes to bleed to death.|"
			>
			<RT-END-OF-GAME>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-TUSK"
;"---------------------------------------------------------------------------"

<OBJECT TH-TUSK
	(LOC TH-BOAR)
	(DESC "tusk")
	(FLAGS FL-NO-DESC FL-TRY-TAKE)
	(SYNONYM TUSK TOOTH)
	(ADJECTIVE BOAR PURE IVORY CURLED)
	(OWNER TH-BOAR)
	(SCORE <LSH 1 ,K-QUEST-SHIFT>)
	(SIZE 5)
	(ACTION RT-TH-TUSK)
>

; "TH-TUSK flags:"
; "	FL-BROKEN - Player has received wisdom point for getting tusk over chasm"

<ROUTINE RT-TH-TUSK ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-TUSK ,FL-SEEN>
			<TELL The ,TH-TUSK " is a curled tooth of pure ivory." CR>
		)
		(<NOT <IN? ,TH-TUSK ,TH-BOAR>>
			<RFALSE>
		)
		(<VERB? TAKE>
			<TELL
"You tug on" the ,TH-TUSK ", but it is firmly attached to" the ,TH-BOAR "." CR>
			<RT-AUTHOR-MSG "Of course, in Alabama the Tuscaloosa.">
		)
		(<AND <VERB? CUT>
				<MC-PRSI? ,TH-SWORD>
			>
			<COND
				(<FSET? ,TH-BOAR ,FL-ALIVE>
					<TELL "You take a wild swing at" the ,TH-TUSK ", but miss." CR>
				)
				(T
					<FSET ,TH-TUSK ,FL-TAKEABLE>
					<FCLEAR ,TH-TUSK ,FL-TRY-TAKE>
					<COND
						(<RT-DO-TAKE ,TH-TUSK>
							<TELL
"You grasp" the ,TH-TUSK " with one hand and hack it off at the base with"
the ,PRSI ". You are now holding" the ,TH-TUSK "." CR
							>
							<RT-SCORE-OBJ ,TH-TUSK>
						)
					>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
							<RT-UPDATE-DESC-WINDOW>
						)
					>
					<RTRUE>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-APPLETREE"
;"---------------------------------------------------------------------------"

<OBJECT TH-APPLETREE
	(LOC RM-EAST-OF-FORD)
	(DESC "tree")
	(FLAGS FL-NO-DESC FL-SEARCH FL-SURFACE)
	(SYNONYM TREE BRANCH BRANCHES)
	(ADJECTIVE APPLE TREE WASTED GNARLED)
	(GENERIC RT-GN-TREE)
	(ACTION RT-TH-APPLETREE)
>

<ROUTINE RT-TH-APPLETREE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-APPLETREE ,FL-SEEN>
			<TELL
"Little remains of the tree except a shriveled-up trunk and a few branches."
			>
			<COND
				(<IN? ,TH-APPLE ,TH-APPLETREE>
					<THIS-IS-IT ,TH-APPLE>
					<TELL " A withered old apple hangs from one of the branches.">
				)
			>
			<CRLF>
		)
		(<VERB? CLIMB-UP CLIMB-ON>
			<RT-WASTE-OF-TIME-MSG>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-APPLE"
;"---------------------------------------------------------------------------"

<OBJECT TH-APPLE
	(LOC TH-APPLETREE)
	(DESC "apple")
	(FLAGS FL-BURNABLE FL-TAKEABLE FL-NO-DESC)
	(SYNONYM APPLE FOOD FRUIT)
	(ADJECTIVE WITHERED OLD BLACK)
	(SIZE 1)
	(GENERIC RT-GN-FOOD)
	(ACTION RT-TH-APPLE)
>

<ROUTINE RT-TH-APPLE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EAT>
			<TELL
"You take a bite from the apple. As its incredibly virulent poison courses
through your system, you begin to think that perhaps you've made a mistake.
Your suspicions are confirmed when, seconds later, you drop dead.|"
			>
			<RT-END-OF-GAME>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-APPLE ,FL-SEEN>
			<TELL "The apple is shriveled and black." CR>
		)
	>
>

<ROUTINE RT-APPLE-MSG ()
	<TELL
"The apple lands near the boar, who stops pacing long enough to gobble it up
in a couple of bites. He resumes pacing - apparently unharmed - until suddenly
he leaps several feet straight into the air, flips over on his back, and
crashes back to the ground, dead.|"
	>
	<SETG GL-BOAR-NUM 0>
	<RT-DEQUEUE ,RT-I-BOAR>
	<REMOVE ,TH-APPLE>
	<FCLEAR ,TH-BOAR ,FL-ALIVE>
	<FSET ,TH-BOAR ,FL-CONTAINER>
	<RT-SCORE-MSG 0 3 7 4>
	<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
	<COND
		(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
			<RT-UPDATE-DESC-WINDOW>
		)
		(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
			<RT-UPDATE-PICT-WINDOW>
		)
	>
	<RTRUE>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

