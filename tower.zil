;"***************************************************************************"
; "game : Arthur"
; "file : TOWER.ZIL"
; "auth :   $Author:   RAB  $"
; "date :     $Date:   15 May 1989 18:50:32  $"
; "revs : $Revision:   1.105  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Ivory tower"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

<INCLUDE "PDEFS">

;"---------------------------------------------------------------------------"
; "RM-TOW-PATH"
;"---------------------------------------------------------------------------"

<ROOM RM-TOW-PATH
	(LOC ROOMS)
	(DESC "path")
	(FLAGS FL-LIGHTED)
	(SYNONYM PATH)
	(ADJECTIVE FOREST DARK)
	(NORTH TO RM-TOW-CLEARING)
	(SOUTH TO RM-ENCHANTED-FOREST)
	(UP PER RT-FLY-UP)
	(GLOBAL LG-ENCHANTED-TREES LG-FOREST ;LG-PATH)
	(ACTION RT-RM-TOW-PATH)
>

<ROUTINE RT-RM-TOW-PATH ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<TELL
"You are" walking " along a dark path that runs from north to south.|"
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-FOREST-PATH>
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
; "RM-TOW-CLEARING"
;"---------------------------------------------------------------------------"

<ROOM RM-TOW-CLEARING
	(LOC ROOMS)
	(DESC "clearing")
	(FLAGS FL-LIGHTED)
	(SYNONYM CLEARING)
	(ADJECTIVE TOWER)
	(EAST TO RM-CIRC-ROOM IF LG-IVORY-DOOR IS OPEN)
	(IN TO RM-CIRC-ROOM IF LG-IVORY-DOOR IS OPEN)
	(SOUTH TO RM-TOW-PATH)
	(UP PER RT-FLY-UP)
	(ADJACENT <TABLE (LENGTH BYTE) RM-CIRC-ROOM <>>)
	(GLOBAL LG-IVORY-DOOR LG-ENCHANTED-TREES LG-FOREST LG-TOWER LG-WALL LG-PATH RM-CIRC-ROOM)
	(ACTION RT-RM-TOW-CLEARING)
>

<ROUTINE RT-RM-TOW-CLEARING ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<FSET ,LG-TOWER ,FL-SEEN>
					<TELL
"You are" standing " in a clearing in the forest, at the base of an
ivory tower which rises out of the ground to your east. There is a path
here that leads south into the woods.|"
					>
				)
				(<EQUAL? ,OHERE ,RM-CIRC-ROOM>
					<TELL
"You emerge from the ivory tower and look around the clearing. The path
leads south back into the woods.|"
					>
				)
				(T
					<FSET ,LG-TOWER ,FL-SEEN>
					<FSET ,LG-IVORY-DOOR ,FL-SEEN>
					<TELL
"The path ends in a clearing. To the east is an amazing tower, built entirely
of ivory. There is a wooden door set into the wall nearest you.|"
					>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-TOWER-CLEARING>
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
; "RM-CIRC-ROOM"
;"---------------------------------------------------------------------------"

<ROOM RM-CIRC-ROOM
	(LOC ROOMS)
	(DESC "circular room")
	(FLAGS FL-INDOORS FL-LIGHTED)
	(SYNONYM ROOM)
	(ADJECTIVE CIRCULAR)
	(WEST TO RM-TOW-CLEARING IF LG-IVORY-DOOR IS OPEN)
	(OUT TO RM-TOW-CLEARING IF LG-IVORY-DOOR IS OPEN)
	(UP TO RM-STAIRS-1)
	(DOWN TO RM-STAIRS-2)
	(ADJACENT <TABLE (LENGTH BYTE) RM-TOW-CLEARING <>>)
	(GLOBAL LG-IVORY-DOOR LG-WALL LG-TOWER RM-TOW-CLEARING RM-STAIRS-1)
	(ACTION RT-RM-CIRC-ROOM)
>

<ROUTINE RT-RM-CIRC-ROOM ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<TELL "You ">
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "are" standing " in">
				)
				(T
					<TELL "enter">
				)
			>
			<TELL
" the circular room. There are stairs that lead up and down from here, and an
exit to the west.|"
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-CIRCULAR-STAIRS>
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
; "LG-IVORY-DOOR"
;"---------------------------------------------------------------------------"

<OBJECT LG-IVORY-DOOR
	(LOC LOCAL-GLOBALS)
	(DESC "wooden door")
	(FLAGS FL-AUTO-ENTER FL-AUTO-OPEN FL-DOOR FL-LOCKED FL-OPENABLE)
	(SYNONYM DOOR KEYHOLE LOCK)
	(ADJECTIVE WOODEN)
	(SCORE <LSH 1 ,K-QUEST-SHIFT>)
	(ACTION RT-LG-IVORY-DOOR)
>

<ROUTINE RT-LG-IVORY-DOOR ("OPT" (CONTEXT <>))
	<COND
		(<NOUN-USED? ,LG-IVORY-DOOR ,W?KEYHOLE ,W?LOCK>
			<COND
				(<VERB? LISTEN>
					<TELL The ,WINNER " can't hear anything." CR>
				)
			;	(<VERB? LOOK-THRU>
					<TELL The ,WINNER " can't see anything." CR>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,LG-IVORY-DOOR ,FL-SEEN>
			<TELL "It is a wooden door, with an ivory keyhole set into it." CR>
		)
		(<VERB? KNOCK>
			<TELL "No one answers." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-STAIRS-1"
;"---------------------------------------------------------------------------"

<ROOM RM-STAIRS-1
	(LOC ROOMS)
	(DESC "stairs")
	(FLAGS FL-INDOORS FL-LIGHTED)
	(SYNONYM STAIRS)
	(ADJECTIVE CIRCULAR)
	(UP TO RM-LANDING)
	(DOWN TO RM-CIRC-ROOM)
	(GLOBAL LG-WALL LG-TOWER RM-LANDING RM-CIRC-ROOM)
	(ACTION RT-RM-STAIRS-1)
>

<ROUTINE RT-RM-STAIRS-1 ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<TELL "You ">
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "are" standing " on">
				)
				(T
					<COND
						(<EQUAL? ,OHERE ,RM-CIRC-ROOM>
							<TELL "climb">
						)
						(T
							<TELL "descend">
						)
					>
				)
			>
			<TELL " the stairs. They continue up and down from here.|">
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-CIRCULAR-STAIRS>
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
		(<VERB? CLIMB-UP>
			<RT-DO-WALK ,P?UP>
		)
		(<VERB? CLIMB-DOWN>
			<RT-DO-WALK ,P?DOWN>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-LANDING"
;"---------------------------------------------------------------------------"

<ROOM RM-LANDING
	(LOC ROOMS)
	(DESC "landing")
	(FLAGS FL-INDOORS FL-LIGHTED)
	(SYNONYM LANDING)
	(ADJECTIVE TOWER)
	(WEST PER RT-ENTER-CRACK)
	(NORTH TO RM-TOWER-ROOM IF LG-WOODEN-DOOR IS OPEN)
	(IN PER RT-IN-LANDING)
	(DOWN TO RM-STAIRS-1)
	(ADJACENT <TABLE (LENGTH BYTE) RM-TOWER-ROOM <>>)
	(GLOBAL LG-WOODEN-DOOR LG-CRACK LG-WALL LG-TOWER RM-STAIRS-1 RM-TOWER-ROOM)
	(ACTION RT-RM-LANDING)
	(THINGS
		<> MORTAR RT-PS-MORTAR
	)
>

<ROUTINE RT-RM-LANDING ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "You are" standing " on a">
				)
				(T
					<COND
						(<EQUAL? ,OHERE ,RM-STAIRS-1>
							<TELL "The stairs end in a">
						)
						(<EQUAL? ,OHERE ,RM-TOWER-ROOM>
							<TELL "You leave the company of the strange man for the">
						)
						(T
							<TELL "You crawl back through the crack to the">
						)
					>
				)
			>
			<TELL " landing at the top of the tower. ">
			<FSET ,LG-WOODEN-DOOR ,FL-SEEN>
			<FSET ,LG-CRACK ,FL-SEEN>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL
"There is a wooden door set into the northern wall, a crack in the wall
to your west, and a set of circular stairs leading downwards."
					>
				)
				(<EQUAL? ,OHERE ,RM-TOWER-ROOM>
					<TELL
"The door through which you just came is set into the northern wall. There is
a crack in the west wall, and a set of circular stairs leading downwards."
					>
				)
				(<EQUAL? ,OHERE ,RM-CRACK-ROOM>
					<TELL
"The crack through which you just crawled is in the west wall. There is
a door to your north, and a set of circular stairs leading downwards."
					>
				)
				(T
					<TELL
"There is a wooden door set into the northern wall, and a crack in
the west wall."
					>
				)
			>
			<CRLF>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-LANDING>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-END>
			<COND
				(<AND <VERB? TRANSFORM>
						<NOT <MC-FORM? ,GL-OLD-FORM>>
						<MC-FORM? ,K-FORM-SALAMANDER>
						<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>
					>
					<RT-UPDATE-MAP-WINDOW>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
	>
>

<ROUTINE RT-ENTER-CRACK ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<COND
				(<OR	<MC-FORM? ,K-FORM-SALAMANDER>
						<FSET? ,RM-CRACK-ROOM ,FL-TOUCHED>
					>
					<RETURN ,RM-CRACK-ROOM>
				)
			>
		)
		(<MC-FORM? ,K-FORM-SALAMANDER>
			<RETURN ,RM-CRACK-ROOM>
		)
		(T
			<TELL ,K-TOO-BIG-CRACK-MSG CR>
			<RFALSE>
		)
	>
>

<ROUTINE RT-IN-LANDING ("OPT" (QUIET <>))
	<COND
		(<MC-FORM? ,K-FORM-SALAMANDER>
			<COND
				(<NOT .QUIET>
					<V-WALK-AROUND>
				)
			>
			<RFALSE>
		)
		(<FSET? ,LG-WOODEN-DOOR ,FL-OPEN>
			<RETURN ,RM-TOWER-ROOM>
		)
		(T
			<COND
				(<NOT .QUIET>
					<TELL The+verb ,LG-WOODEN-DOOR "are" "n't open." CR>
				)
			>
			<RFALSE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-TOWER-ROOM"
;"---------------------------------------------------------------------------"

<ROOM RM-TOWER-ROOM
	(LOC ROOMS)
	(DESC "tower room")
	(FLAGS FL-INDOORS FL-LIGHTED)
	(SYNONYM ROOM)
	(ADJECTIVE TOWER)
	(SOUTH TO RM-LANDING IF LG-WOODEN-DOOR IS OPEN)
	(OUT TO RM-LANDING IF LG-WOODEN-DOOR IS OPEN)
	(ADJACENT <TABLE (LENGTH BYTE) RM-LANDING <>>)
	(GLOBAL LG-WOODEN-DOOR LG-WALL LG-TOWER RM-LANDING)
	(ACTION RT-RM-TOWER-ROOM)
	(THINGS
		<> WINDOW RT-PS-WINDOW
	)
>

<ROUTINE RT-RM-TOWER-ROOM ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,CH-RHYMER ,FL-SEEN>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL
"The tower room is empty, save for some furniture and the withered old man.|"
					>
				)
				(T
					<TELL
"You" walk " into the sparsely-furnished room at the top of the tower. In it
sits a withered old man.|"
					>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-TOWER-ROOM>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTERED>
			<COND
				(<AND <NOT <FSET? ,CH-RHYMER ,FL-LOCKED>>
						<MC-FORM? ,K-FORM-ARTHUR>
					>
					<CRLF>
					<RT-RHYMER-MSG>
				)
			>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<MC-FORM? ,K-FORM-ARTHUR>
					<COND
					;	(<NOT <FSET? ,CH-RHYMER ,FL-LOCKED>>
							<RFALSE>
						)
						(<VERB? SAY $PASSWORD>
							<RT-CHECK-RHYMER-NAME ,PRSO>
						)
						(<AND <VERB? BE>
								<MC-PRSO? ,TH-NAME ,CH-RHYMER>
							>
							<RT-CHECK-RHYMER-NAME ,PRSI>
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-END>
			<COND
				(<AND <VERB? TRANSFORM>
						<NOT <MC-FORM? ,GL-OLD-FORM>>
					>
					<TELL
"|The old man notices your transformation and shrugs indifferently."
					>
					<COND
						(<AND <MC-FORM? ,K-FORM-ARTHUR>
								<NOT <FSET? ,CH-RHYMER ,FL-LOCKED>>
							>
							<TELL " ">
							<RT-RHYMER-MSG>
						)
						(T
							<CRLF>
						)
					>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
	>
>

<ROUTINE RT-PS-WINDOW ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<COND
		(<MC-CONTEXT? ,M-OBJDESC>
			<FCLEAR ,PSEUDO-OBJECT ,FL-PLURAL>
			<FCLEAR ,PSEUDO-OBJECT ,FL-VOWEL>
			<COND
				(.ART
					<PRINT-ARTICLE ,PSEUDO-OBJECT .ART .CAP?>
				)
			>
			<COND
				(<EQUAL? .ART <> ,K-ART-THE ,K-ART-A ,K-ART-ANY>
					<COND
						(.ART
							<TELL " ">
						)
					>
					<TELL "window">
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE LOOK-THRU>
			<TELL "The window looks out onto the forest below." CR>
		)
	>
>


<VOC "RUMPLESTILTSKIN">
<VOC "AMU">
<VOC "AMHTIR">
<VOC "SMOTUS">

<ROUTINE RT-CHECK-RHYMER-NAME (OBJ "AUX" NP PTR END N (Q? <>) (C? <>) (S 0))
	<COND
		(<FSET? ,CH-RHYMER ,FL-LOCKED>
			<TELL
"|\"Now that you've guessed my appellation.| Continue your quest to rule this
nation.\"" CR
			>
			<RTRUE>
		)
		(<VERB? $PASSWORD>
			<SET C? T>
		)
		(<EQUAL? ,INTQUOTE .OBJ>
			<SET Q? T>
			<COND
				(<SET NP <GET-NP ,INTQUOTE>>
					<COND
						(<SET PTR <NP-LEXBEG .NP>>
							<COND
								(<EQUAL? <ZGET .PTR 0> ,W?QUOTE>
									<SET PTR <ZREST .PTR 8>>
								)
							>
							<SET END <NP-LEXEND .NP>>
							<COND
								(<EQUAL? <ZGET .PTR 0> ,W?THOMAS>
									<SET S 5>
									<SET PTR <ZREST .PTR 4>>
									<COND
										(<EQUAL? <ZGET .PTR 0> ,W?THE>
											<SET PTR <ZREST .PTR 4>>
										)
									>
									<COND
										(<EQUAL? <ZGET .PTR 0> ,W?RHYMER>
											<COND
												(<NOT .END>
													<SET C? T>
												)
												(<EQUAL? .PTR .END>
													<SET C? T>
												)
												(<AND <EQUAL? <SET PTR <ZREST .PTR 4>> .END>
														<EQUAL? <ZGET .PTR 0> ,W?QUOTE>
													>
													<SET C? T>
												)
											>
										)
									>
								)
								(<EQUAL? <ZGET .PTR 0> ,W?RHYMER>
									<SET S 5>
								)
								(<EQUAL? <ZGET .PTR 0> ,W?MOTHER>
									<SET S 1>
								)
								(<EQUAL? <ZGET .PTR 0> ,W?RUMPLESTILTSKIN>
									<SET S 2>
								)
								(<EQUAL? <ZGET .PTR 0> ,W?AMU ,W?AMHTIR ,W?SMOTUS>
									<SET S 3>
								)
								(<EQUAL? <ZGET .PTR 0> ,W?RIOTHAMUS>
									<SET S 4>
								)
							>
						)
					>
				)
			>
		)
		(<EQUAL? .OBJ ,TH-MOTHER>
			<SET S 1>
		)
		(<EQUAL? .OBJ ,TH-RIOTHAMUS>
			<SET S 4>
		)
		(T
			<COND
				(<MC-PRSI? .OBJ>
					<SET NP ,PRSI-NP>
				)
				(T
					<SET NP ,PRSO-NP>
				)
			>
			<COND
				(<AND <NOUN-USED? ,CH-RHYMER ,W?RHYMER>
						<ADJ-USED? ,CH-RHYMER ,W?THOMAS>
					>
					<SET C? T>
				)
				(<NOUN-USED? ,CH-RHYMER ,W?THOMAS ,W?RHYMER>
					<SET S 5>
				)
			>
		)
	>

	<COND
		(.C?
			<FSET ,CH-RHYMER ,FL-LOCKED>
			<TELL
"The old man jumps up and claps his hands with glee.||\"You win! You win! To
thee I sing.| And give to you this magic ring.| When unseen forces you
surprise,| Just rub this ring to clear your eyes.\"||He gives you a ring.|"
			>
			<COND
				(<RT-DO-TAKE ,TH-MAGIC-RING T>
					<RT-SCORE-OBJ ,TH-MAGIC-RING>
				)
			>
			<RTRUE>
		)
		(<EQUAL? .S 1>
			<TELL
"|\"These guesses often greatly vex.| At least please try to match my sex!\"" CR
			>
		)
		(<EQUAL? .S 2>
			<TELL
"|\"If Rumplestiltskin were my name,| Then this would be an wimpy game.\"" CR
			>
		)
		(<EQUAL? .S 3>
			<TELL
"|\"I guess you've seen my secret room,| But that is not my nom de plume.\"" CR
			>
		)
		(<EQUAL? .S 4>
			<TELL
"|\"Riothamus means 'the king most high,'| A height to which you'll one day fly.\"" CR
			>
		)
		(<EQUAL? .S 5>
			<TELL
"|\"I'd have to say you're on the track,| But still there's something else
you lack.\"" CR
			>
		)
		(T
			<DIROUT ,K-D-TBL-ON ,K-DIROUT-TBL>
			<COND
				(.Q?
					<PRINT-INTQUOTE>
				)
				(T
					<NP-PRINT .NP>
				)
			>
			<DIROUT ,K-D-TBL-OFF>
			<TELL CR "\"">
			<COND
				(<AND <G=? <SET N <GETB ,K-DIROUT-TBL 2>> !\a>
						<L=? .N !\z>
					>
					<PUTB ,K-DIROUT-TBL 2 <- .N 32>>
				)
			>
			<PRINTT <ZREST ,K-DIROUT-TBL 2> <ZGET ,K-DIROUT-TBL 0>>
			<TELL " is not my name,| As a guess, that's pretty lame.\"" CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "CH-RHYMER"
;"---------------------------------------------------------------------------"

<OBJECT CH-RHYMER
	(LOC TH-RHYMER-CHAIR)
	(DESC "old man")
	(FLAGS FL-ALIVE FL-NO-DESC FL-OPEN FL-PERSON FL-SEARCH FL-VOWEL)
	(SYNONYM MAN THOMAS RHYMER PERSON)
	(ADJECTIVE OLD LITTLE WITHERED THOMAS)
	(GENERIC RT-GN-OLD-MAN)
	(ACTION RT-CH-RHYMER)
>

; "CH-RHYMER flags:"
; "	FL-BROKEN - Rhymer has made first speech to player"

<ROUTINE RT-CH-RHYMER ("OPT" (CONTEXT <>))
	<COND
		(<AND <VERB? HELLO GOODBYE THANK>
				<MC-CONTEXT? ,M-WINNER <>>
			>
			<COND
				(<VERB? HELLO>
					<TELL
"|\"Hello is such a friendly greeting.| 'Specially when it's friends you're
meeting.\"" CR
					>

				)
				(<VERB? GOODBYE>
					<TELL
"|\"Goodbyes are always filled with sorrow.| 'Til we say hello tomorrow.\"" CR
					>
				)
				(<VERB? THANK>
					<TELL
"|\"You're kind to give your thanks to me,| It speaks well of your chivalry.\"" CR
					>
					<COND
						(<NOT <FSET? ,CH-PLAYER ,FL-AIR>>
							<FSET ,CH-PLAYER ,FL-AIR>
							<RT-SCORE-MSG 10 0 0 0>
						)
					>
					<RTRUE>
				)
			>
		)
		(<MC-CONTEXT? ,M-WINNER>
			<COND
				(<AND <VERB? TELL-ABOUT>
						<MC-PRSO? ,CH-PLAYER>
					>
					<RFALSE>
				)
				(<VERB? WHO WHAT>
					<RFALSE>
				)
				(<VERB? SAY BE>
					<RFALSE>
				)
				(T
					<TELL
"|\"I cannot do the thing you ask.| I'm busy with another task.\"" CR
					>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<RFALSE>
		)
		(<AND <VERB? TELL>
				,P-CONT
			>
		; "Message and RFATAL if don't want Rhymer to become winner"
			<RFALSE>
		)
		(<VERB? ASK-ABOUT>
			<COND
				(<MC-PRSI? ,CH-I-KNIGHT>
					<TELL
"|\"You speak of him who robs you blind| I tell you, 'See, and ye shall find.'\"" CR
					>
				)
				(<MC-PRSI? ,CH-MERLIN>
					<TELL
"|\"A wizard better versed than I| In magic arts that mystify.\"" CR
					>
				)
				(<MC-PRSI? ,TH-MAGIC-RING>
					<COND
						(<FSET? ,TH-MAGIC-RING ,FL-TOUCHED>
							<TELL
"|\"The ring has magic potency,| To clear your eyes and help you see.\"" CR
							>
						)
						(T
							<TELL
"The old man cocks his head at you and winks.||\"You must have played this
game before,| And used the magic of restore.| For knowledge of the ring is
privit,| And known to none until I give it.\"" CR
							>
						)
					>
				)
				(<MC-PRSI? ,CH-RHYMER>
					<COND
						(<FSET? ,TH-MAGIC-RING ,FL-TOUCHED>
							<TELL
"|\"Perhaps you've never heard of me,| But I truly lived in history.\"" CR
							>
						)
						(T
							<TELL
"|\"I speak in rhymes, and riddles too.| And even there's a little clue.\"" CR
							>
						)
					>
				)
				(<MC-PRSI? ,TH-NAME>
					<COND
						(<FSET? ,TH-MAGIC-RING ,FL-TOUCHED>
							<TELL
"|\"I'm called the Rhymer, it's plain to see,| Because I so love poetry.\"" CR
							>
						)
						(T
							<TELL
"|\"It's mine to know, and yours to guess,| To bring to you much happiness.\"" CR
							>
						)
					>
				)
				(<MC-PRSI? ,TH-MASTER>
					<TELL
"|\"I have no boss, and well I know it,| I'd rather stay a freelance poet.\"" CR
					>
				)
				(<MC-PRSI? ,TH-RHYME>
					<TELL "\"I dunno. I've always talked like dis.\"" CR>
				)
				(<MC-PRSI? ,TH-RIOTHAMUS>
					<TELL
"|\"One day you'll earn all England's trust,| And you'll be called Riothamus.\"" CR
					>
				)
				(<MC-PRSI? ,TH-MOTHER>
					<TELL
"|\"'Tis good to think of mother dear,| However, that won't help you here.\"" CR
					>
				)
				(<MC-PRSI? ,CH-LOT>
					<TELL
"|\"The man's our king, alack, alas| But nevertheless, he's still an ass.\"" CR
					>
				)
				(<MC-PRSI? ,CH-DEMON>
					<TELL
"|\"His wickedness will stay restrained| As long as to his throne he's chained.\"" CR
					>
				)
				(<MC-PRSI? ,LG-TOWER>
					<TELL
"|\"This tower has become my home| And from it I quite seldom roam.\"" CR
					>
				)
				(<MC-PRSI? ,RM-CELLAR ,RM-CRACK-ROOM>
					<TELL
"|\"The room contains a little clue| A token gift from me to you.\"" CR
					>
				)
				(<MC-PRSI? ,TH-EXCALIBUR>
					<TELL
"|\"The sword that's now within the stone| Is destined for your hand alone.\"" CR
					>
				)
				(<MC-PRSI? ,TH-CHIVALRY>
					<TELL
"|\"Be nice. Be kind. And do your duty,| That's how to get a sweet patootie.\"" CR>
				)
				(<MC-PRSI? ,TH-UTHER>
					<TELL
"|\"Uther was your dad, it's true,| But proving it is up to you.\"" CR>
				)
				(T
					<TELL
"|\"I have no knowledge of what you speak.| In fact to me, it all sounds greek.\"" CR
					>
				)
			>
		)
		(<VERB? EXAMINE>
			<TELL
"The old man has a twinkle in his eye, and he is smiling to himself at some
private joke." CR
			>
		)
	>
>

<ROUTINE RT-RHYMER-MSG ()
	<SETUP-ORPHAN "say">
	<TELL "\"Welcome,\" he says:||">
	<COND
		(<FSET? ,CH-RHYMER ,FL-BROKEN>
			<TELL
"\"I see that you have ventured back| To claim the loot which now you lack|
But first I must make truly sure| That you have learned my moniker.\"" CR
			>
		)
		(T
			<FSET ,CH-RHYMER ,FL-BROKEN>
			<TELL
"\"You come in search of gold and loot.| I have all that, and more to boot.|
To get it you must play my game.| Just say to me my secret name.\"" CR
			>
		)
	>
>

<ROUTINE RT-GN-OLD-MAN (TBL FINDER)
	<RETURN ,CH-RHYMER>
>

;"---------------------------------------------------------------------------"
; "TH-RHYMER-CHAIR"
;"---------------------------------------------------------------------------"

<OBJECT TH-RHYMER-CHAIR
	(LOC RM-TOWER-ROOM)
	(DESC "chair")
	(FLAGS FL-CONTAINER FL-NO-LIST FL-OPEN FL-SEARCH)
	(SYNONYM CHAIR)
	(OWNER CH-RHYMER)
>

;"---------------------------------------------------------------------------"
; "TH-TOWER-TABLE"
;"---------------------------------------------------------------------------"

<OBJECT TH-TOWER-TABLE
	(LOC RM-TOWER-ROOM)
	(DESC "table")
	(FLAGS FL-SEARCH FL-SURFACE)
	(SYNONYM TABLE)
	(CAPACITY 50)
	(ACTION RT-TH-TOWER-TABLE)
>

<ROUTINE RT-TH-TOWER-TABLE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? CLIMB-UP CLIMB-ON CLIMB-OVER>
			<TELL "It's not polite to " vw " on tables." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-RHYME"
;"---------------------------------------------------------------------------"

<OBJECT TH-RHYME
	(LOC GENERIC-OBJECTS)
	(DESC "rhyme")
	(SYNONYM RHYME RHYMES POETRY VERSE)
>

;"---------------------------------------------------------------------------"
; "LG-WOODEN-DOOR"
;"---------------------------------------------------------------------------"

<OBJECT LG-WOODEN-DOOR
	(LOC LOCAL-GLOBALS)
	(DESC "wooden door")
	(FLAGS FL-DOOR FL-OPENABLE)
	(SYNONYM DOOR)
	(ADJECTIVE WOODEN)
	(ACTION RT-LG-WOODEN-DOOR)
>

<ROUTINE RT-LG-WOODEN-DOOR ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? KNOCK>
			<TELL
"A voice calls out:||\"Come in, come in. I'm all alone.| And you don't need
a chaperone.\"" CR
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-CRACK-ROOM"
;"---------------------------------------------------------------------------"

<ROOM RM-CRACK-ROOM
	(LOC ROOMS)
	(DESC "abandoned room")
	(FLAGS FL-INDOORS FL-LIGHTED)
	(SYNONYM ROOM)
	(ADJECTIVE ABANDONED)
	(EAST PER RT-LEAVE-CRACK)
	(OUT PER RT-LEAVE-CRACK)
	(SCORE <ORB <LSH 2 ,K-WISD-SHIFT> <LSH 1 ,K-QUEST-SHIFT>>)
	(GLOBAL LG-CRACK LG-WALL LG-TOWER RM-LANDING)
	(ACTION RT-RM-CRACK-ROOM)
	(THINGS
		<> (LETTERS WORDS) RT-PS-LETTERS
	)
>

<CONSTANT K-TOO-BIG-CRACK-MSG "You are too big to fit through the crack.">

<CONSTANT K-WALL-LETTERS-MSG
"On the wall are written the following letters: AMHTIR AMU SMOTUS."
>

<ROUTINE RT-RM-CRACK-ROOM ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "You are">
				)
				(T
					<TELL
"You crawl up the crack until it widens just enough for you to squirm
through. You find yourself"
					>
				)
			>
			<TELL
" in an abandoned room in the tower. " ,K-WALL-LETTERS-MSG " The crack
through which you entered is in the east wall.|"
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-ABANDONED-ROOM>
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

<ROUTINE RT-LEAVE-CRACK ("OPT" (QUIET <>))
	<COND
		(<OR	.QUIET
				<MC-FORM? ,K-FORM-SALAMANDER>
			>
			<RETURN ,RM-LANDING>
		)
		(T
			<TELL ,K-TOO-BIG-CRACK-MSG CR>
			<RFALSE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "LG-CRACK"
;"---------------------------------------------------------------------------"

<OBJECT LG-CRACK
	(LOC LOCAL-GLOBALS)
	(DESC "crack")
	(SYNONYM CRACK HOLE STONE STONES)
	(ADJECTIVE SMALL)
	(ACTION RT-LG-CRACK)
>

<ROUTINE RT-LG-CRACK ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<COND
				(<VERB? PUT-IN>
					<COND
						(<G? <GETB <GETPT ,PRSO ,P?SIZE> ,K-SIZE> 1>
							<TELL
The+verb ,PRSO "are" " too big to fit in the crack." CR
							>
						)
						(T
							<COND
								(<MC-HERE? ,RM-LANDING>
									<MOVE ,PRSO ,RM-CRACK-ROOM>
								)
								(T
									<MOVE ,PRSO ,RM-LANDING>
								)
							>
							<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT>>
							<TELL
The+verb ,WINNER "push" the ,PRSO " into the crack. " He+verb ,PRSO "fall"
" out on the other side." CR
							>
						)
					>
				)
			>
		)
		(<VERB? LOOK-THRU>
			<COND
				(<MC-HERE? ,RM-LANDING>
					<TELL
"You can see into a sealed room. There is some writing on the opposite wall,
but you can't quite make it out." CR
					>
				)
				(T
					<TELL
"You peer through the crack at the landing, but see nothing of interest." CR
					>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,LG-CRACK ,FL-SEEN>
			<TELL
"The crack is just a small hole in the mortar between two stones." CR
			>
		)
		(<VERB? ENTER>
			<COND
				(<MC-HERE? ,RM-CRACK-ROOM>
					<RT-DO-WALK ,P?EAST>
				)
				(<MC-HERE? ,RM-LANDING>
					<RT-DO-WALK ,P?WEST>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-STAIRS-2"
;"---------------------------------------------------------------------------"

<ROOM RM-STAIRS-2
	(LOC ROOMS)
	(DESC "stairs")
	(FLAGS FL-INDOORS FL-LIGHTED)
	(SYNONYM STAIRS)
	(ADJECTIVE CIRCULAR)
	(UP TO RM-CIRC-ROOM)
	(DOWN TO RM-CELLAR)
	(GLOBAL LG-WALL LG-TOWER RM-CELLAR RM-CIRC-ROOM)
	(ACTION RT-RM-STAIRS-2)
>

<ROUTINE RT-RM-STAIRS-2 ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<TELL "You ">
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "are" standing " on">
				)
				(T
					<COND
						(<EQUAL? ,OHERE ,RM-CIRC-ROOM>
							<TELL "descend">
						)
						(T
							<TELL "climb">
						)
					>
				)
			>
			<TELL
" the circular stairs. Below you, the stairs disappear into total darkness.
You may either descend, or go return to the safety of the circular room.|"
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-CIRCULAR-STAIRS>
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
		(<VERB? CLIMB-UP>
			<RT-DO-WALK ,P?UP>
		)
		(<VERB? CLIMB-DOWN>
			<RT-DO-WALK ,P?DOWN>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-CELLAR"
;"---------------------------------------------------------------------------"

<ROOM RM-CELLAR
	(LOC ROOMS)
	(DESC "cellar")
	(FLAGS FL-INDOORS FL-LOCKED)
	(SYNONYM CELLAR)
	(ADJECTIVE TOWER SMALL DAMP)
	(UP TO RM-STAIRS-2)
	(GLOBAL LG-WALL LG-TOWER RM-STAIRS-2)
	(ACTION RT-RM-CELLAR)
	(THINGS
		<> (LINES LETTERS) RT-PS-LETTERS
	)
>

; "RM-CELLAR flags:"
; "	FL-LOCKED - Player has not seen message on wall"

<ROUTINE RT-RM-CELLAR ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<TELL
"This is a small damp room, with two lines of letters written on the wall.|"
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-END>
			<COND
				(<VERB? TRANSFORM>
					<COND
						(<NOT <MC-FORM? ,GL-OLD-FORM>>
							<COND
								(<MC-FORM? ,K-FORM-OWL>
									<RT-CELLAR-MSG T>
									<SETG GL-PICTURE-NUM ,K-PIC-CELLAR>
								)
								(T
									<SETG GL-PICTURE-NUM 0>
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
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<COND
				(<MC-FORM? ,K-FORM-OWL>
					<SETG GL-PICTURE-NUM ,K-PIC-CELLAR>
				)
				(T
					<SETG GL-PICTURE-NUM 0>
				)
			>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTERED>
			<COND
				(<AND <MC-FORM? ,K-FORM-OWL>
						<FSET? ,RM-CELLAR ,FL-LOCKED>
					>
					<FCLEAR ,RM-CELLAR ,FL-LOCKED>
					<RT-SCORE-MSG 0 4 0 1>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
	>
>

<ROUTINE RT-PS-LETTERS ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<COND
		(<MC-CONTEXT? ,M-OBJDESC>
			<FSET ,PSEUDO-OBJECT ,FL-PLURAL>
			<FCLEAR ,PSEUDO-OBJECT ,FL-VOWEL>
			<COND
				(.ART
					<PRINT-ARTICLE ,PSEUDO-OBJECT .ART .CAP?>
				)
			>
			<COND
				(<EQUAL? .ART <> ,K-ART-THE ,K-ART-A ,K-ART-ANY>
					<COND
						(.ART
							<TELL " ">
						)
					>
					<TELL "letters">
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE READ>
			<COND
				(<MC-HERE? ,RM-CELLAR>
					<RT-CELLAR-MSG>
				)
				(<MC-HERE? ,RM-CRACK-ROOM>
					<TELL ,K-WALL-LETTERS-MSG CR>
				)
			>
		)
	>
>

<ROUTINE RT-CELLAR-MSG ("OPT" (CR? <>))
	<COND
		(.CR?
			<CRLF>
		)
	>
	<TELL
"With your improved night-vision, you can see that this is a small damp
room, with two lines of letters written on the wall:|   SAYMOTHER|   RIOTHAMUS" CR
	>
	<COND
		(<FSET? ,RM-CELLAR ,FL-LOCKED>
			<FCLEAR ,RM-CELLAR ,FL-LOCKED>
			<RT-SCORE-MSG 0 4 0 1>
		)
	>
	<RTRUE>
>

;"---------------------------------------------------------------------------"
; "TH-MAGIC-RING"
;"---------------------------------------------------------------------------"

<OBJECT TH-MAGIC-RING
	(DESC "magic ring")
	(FLAGS FL-CLOTHING FL-TAKEABLE)
	(SYNONYM RING BAND)
	(ADJECTIVE MAGIC)
	(SCORE <ORB <LSH 7 ,K-WISD-SHIFT> <LSH 3 ,K-QUEST-SHIFT>>)
	(SIZE 1)
	(ACTION RT-TH-MAGIC-RING)
>

<ROUTINE RT-TH-MAGIC-RING ("OPT" (CONTEXT <>))
	<COND
		(<VERB? RUB>
			<COND
				(<NOT <IN? ,TH-MAGIC-RING ,WINNER>>
					<TELL The+verb ,WINNER "do" "n't have" the ,TH-MAGIC-RING "." CR>
				)
				(<AND <MC-HERE? ,RM-MEADOW ,RM-PAVILION>
						<FSET? ,RM-PAVILION ,FL-LOCKED>
					>
					<FCLEAR ,RM-PAVILION ,FL-LOCKED>
					<FSET ,RM-PAVILION ,FL-INDOORS>
					<FCLEAR ,CH-I-KNIGHT ,FL-INVISIBLE>
					<FCLEAR ,TH-COUNTER ,FL-INVISIBLE>
					<FSET ,TH-GLITTER ,FL-INVISIBLE>
					<COND
						(<MC-HERE? ,RM-PAVILION>
							<FCLEAR ,RM-PAVILION ,FL-TOUCHED>
							<FCLEAR ,RM-PAVILION ,FL-SEEN>
							<INIT-STATUS-LINE>
							<UPDATE-STATUS-LINE>
							<SETG GL-PICTURE-NUM ,K-PIC-PAVILION>
							<COND
								(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
									<RT-UPDATE-PICT-WINDOW>
								)
							>
							<RT-RM-PAVILION ,M-F-LOOK>
							<FSET ,RM-PAVILION ,FL-TOUCHED>
							<FSET ,RM-PAVILION ,FL-SEEN>
						)
						(T
							<TELL
"As you rub the ring, the air to the east begins to shimmer. Moments later,
a knight's pavilion appears where before there had been nothing." CR
							>
						;	<RT-SCORE-MSG 0 3 0 2>
						)
					>
					<RT-SCORE-OBJ ,RM-PAVILION>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
							<RT-UPDATE-DESC-WINDOW>
						)
					>
					<RTRUE>
				)
				(T
					<TELL "Nothing happens here." CR>
				)
			>
		)
		(<VERB? EXAMINE>
			<TELL
"The ring is a simple band made of a dull metal that is unfamiliar to you." CR
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-IVORY-KEY"
;"---------------------------------------------------------------------------"

<OBJECT TH-IVORY-KEY
	(DESC "ivory key")
	(FLAGS FL-BURNABLE FL-KEY FL-TAKEABLE FL-VOWEL)
	(SYNONYM KEY)
	(ADJECTIVE IVORY)
	(SIZE 1)
	(GENERIC RT-GN-KEY)
>

;"---------------------------------------------------------------------------"
; "LG-TOWER"
;"---------------------------------------------------------------------------"

<OBJECT LG-TOWER
	(LOC LOCAL-GLOBALS)
	(DESC "ivory tower")
	(FLAGS FL-VOWEL)
	(SYNONYM TOWER)
	(ADJECTIVE IVORY ROUND)
	(ACTION RT-LG-TOWER)
>

<ROUTINE RT-LG-TOWER ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE LOOK-ON>
			<FSET ,LG-TOWER ,FL-SEEN>
			<TELL "It's a tall round tower with sheer ivory walls." CR>
		)
		(<VERB? ENTER>
			<COND
				(<MC-HERE? ,RM-TOW-CLEARING>
					<RT-DO-WALK ,P?EAST>
				)
			>
		)
		(<VERB? EXIT>
			<COND
				(<MC-HERE? ,RM-CIRC-ROOM>
					<RT-DO-WALK ,P?WEST>
				)
			>
		)
		(<VERB? CLIMB-UP>
			<TELL "The ivory walls are too smooth to climb">
			<COND
				(<MC-FORM? ,K-FORM-SALAMANDER>
					<TELL ", even for a salamander">
				)
			>
			<TELL "." CR>
		)
	>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

