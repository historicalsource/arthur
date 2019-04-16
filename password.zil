;"***************************************************************************"
; "game : Arthur"
; "file : PASSWORD.ZIL"
; "auth :   $Author:   RAB  $"
; "date :     $Date:   15 May 1989 18:10:28  $"
; "revs : $Revision:   1.112  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Password"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

<INCLUDE "PDEFS">

;"---------------------------------------------------------------------------"
; "RM-CASTLE-GATE"
;"---------------------------------------------------------------------------"

<ROOM RM-CASTLE-GATE
	(LOC ROOMS)
	(DESC "outside castle gate")
	(FLAGS FL-LIGHTED)
	(EAST PER RT-ENTER-GATE)
	(IN PER RT-ENTER-GATE)
	(WEST TO RM-TOWN-SQUARE)
	(SOUTH TO RM-SMITHY)
	(UP PER RT-FLY-UP)
	(GLOBAL LG-CASTLE-GATE LG-WALL LG-CASTLE RM-SMITHY RM-TOWN-SQUARE)
	(ACTION RT-RM-CASTLE-GATE)
>

<CONSTANT K-MERLIN-PRISONER-MSG
"Merlin appears to you and says, \"You have failed, Arthur. By leaving the
prisoner within the castle, you have ensured the doom of an innocent man. No
man who would be King can allow an innocent subject to die.\"">

<ROUTINE RT-RM-CASTLE-GATE ("OPT" (CONTEXT <>) "AUX" PW)
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,LG-CASTLE-GATE ,FL-SEEN>
			<TELL "You">
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL " are" standing " outside">
				)
				(<EQUAL? ,OHERE ,RM-PARADE-AREA>
					<COND
						(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
							<COND
								(<MC-FORM? ,K-FORM-OWL>
									<TELL " fly over">
								)
								(T
									<TELL " crawl under">
								)
							>
						)
						(T
							<TELL walk " outside">
						)
					>
				)
				(T
					<TELL " come to">
				)
			>
			<TELL
" the gate to the castle of evil King Lot. " A+verb ,CH-SOLDIERS "are"
" standing guard"
			>
			<COND
				(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
					<TELL
", but" he+verb ,CH-SOLDIERS "pay" " no attention to you"
					>
				)
			>
			<FSET ,RM-SMITHY ,FL-SEEN>
			<TELL ". To the south is the village smithy.|">
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<AND <MC-FORM? ,K-FORM-ARTHUR>
						<OR
							<VERB? $PASSWORD>
							<AND
								<VERB? BE>
								<MC-PRSO? ,TH-PASSWORD>
							>
							<AND
								<VERB? SAY>
								<MC-PRSI? <> ,CH-SOLDIERS>
							>
						>
					>
					<COND
						(<VERB? BE>
							<SET PW ,PRSI>
						)
						(T
							<SET PW ,PRSO>
						)
					>
					<COND
						(<IN? ,TH-GAUNTLET ,WINNER>
							<TELL
"The guard sees" the ,TH-GAUNTLET " and says, \"Enter.\" He opens the massive
gate and steps aside as you" walk " through.||"
							>
							<SETG WINNER ,CH-PLAYER>
							<RT-GOTO ,RM-PARADE-AREA T>
						)
						(<OR	<VERB? $PASSWORD>
								<RT-CORRECT-PASSWORD? .PW>
							>
							<FSET ,CH-SOLDIERS ,FL-LOCKED>
							<TELL
"\"Enter,\" says the soldier, although he is clearly unhappy to let you in.
He opens the massive gate and steps aside as you" walk " through.||"
							>
							<SETG WINNER ,CH-PLAYER>
							<RT-GOTO ,RM-PARADE-AREA T>
						)
						(T
							<RT-SOLDIER-SUSPECT .PW>
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-CASTLE-GATE>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<MOVE ,CH-SOLDIERS ,RM-CASTLE-GATE>
			<MOVE ,TH-POLLAXE ,CH-SOLDIERS>
			<FCLEAR ,CH-SOLDIERS ,FL-PLURAL>
			<FSET ,CH-SOLDIERS ,FL-NO-DESC>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTERED>
			<COND
				(<EQUAL? ,OHERE ,RM-PARADE-AREA>
					<COND
						(<EQUAL? ,GL-PUPPY ,CH-PRISONER>
							<RT-CLEAR-PUPPY>
							<REMOVE ,CH-PRISONER>
							<FCLEAR ,TH-SWORD ,FL-LOCKED>
							<TELL
CR "The smith pulls you out of earshot of the guard and whispers, \"I am
grateful to you for freeing me, kind sir. I dare no longer stay in this
town for fear of being recaptured by King Lot. But as thanks for freeing
me, I will tell you where I have hidden another sword. It is plain, unlike
Lot's sword. But it is of the best quality. It is hidden under the roots
of the oak tree in the village green. Goodbye, sir. And thank you
again.\"" CR CR

"The smith walks off toward the town gate and quickly disappears from sight." CR
							>
							<RT-SCORE-MSG 10 2 3 4>
						)
						(<AND <FSET? ,CH-CELL-GUARD ,FL-ASLEEP>
								<FSET? ,TH-SWORD ,FL-LOCKED>
							>
							<MOVE ,CH-MERLIN ,HERE>
							<TELL CR ,K-MERLIN-PRISONER-MSG CR>
							<RT-END-OF-GAME>
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-EXIT>
			<FCLEAR ,CH-SOLDIERS ,FL-LOCKED>
			<SETG GL-SOLDIER-CNT 0>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-END>
			<COND
				(<VERB? TRANSFORM>
					<COND
						(<NOT <MC-FORM? ,GL-OLD-FORM>>
							<TELL
"\"Sorcery!! Work of the Devil!!\" " The+verb ,CH-SOLDIERS "skewer" " you
through the heart with" his ,CH-SOLDIERS " sword." ,K-HEEDED-WARNING-MSG
							>
							<RT-END-OF-GAME>
						)
						(,GL-FORM-ABORT
							<TELL
"|Fortunately, it all happened so quickly that" the ,CH-SOLDIERS " didn't notice." CR
							>
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

;"---------------------------------------------------------------------------"
; "CH-SOLDIERS"
;"---------------------------------------------------------------------------"

<OBJECT CH-SOLDIERS
	(FLAGS FL-ALIVE FL-HAS-SDESC FL-OPEN FL-PERSON FL-PLURAL FL-SEARCH)
	(SYNONYM SOLDIER SOLDIERS GUARD GUARDS MAN MEN PERSON PEOPLE)
	(OWNER CH-LOT)
	(GENERIC RT-GN-GUARD)
	(ACTION RT-CH-SOLDIERS)
>

; "CH-SOLDIERS flags:"
; "	FL-LOCKED - Player has said password to soldier."
; "	FL-BROKEN - Alarm has been raised."

<CONSTANT K-MUTTERING-MSG " muttering curses about the cold.|">
<CONSTANT K-GETTING-CLOSER-MSG
"It sounds as if the soldiers are getting closer.|">

<ROUTINE RT-CH-SOLDIERS ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<COND
		(<MC-CONTEXT? ,M-OBJDESC>
			<COND
				(.ART
					<PRINT-ARTICLE ,CH-SOLDIERS .ART .CAP?>
				)
			>
			<COND
				(<EQUAL? .ART <> ,K-ART-THE ,K-ART-A ,K-ART-ANY>
					<COND
						(.ART
							<TELL " ">
						)
					>
					<TELL "soldier">
					<COND
						(<FSET? ,CH-SOLDIERS ,FL-PLURAL>
							<TELL "s">
						)
					>
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
				(<AND <MC-FORM? ,K-FORM-ARTHUR>
						<MC-HERE? ,RM-CASTLE-GATE ,RM-PARADE-AREA ,RM-GREAT-HALL>
						<OR
							<VERB? $PASSWORD>
							<AND
								<VERB? BE>
								<MC-PRSO? ,TH-PASSWORD>
							>
							<AND
								<VERB? SAY>
								<MC-PRSI? <> ,CH-SOLDIERS>
							>
						>
					>
					<APPLY <GETP ,HERE ,P?ACTION> ,M-BEG>
				)
				(T
					<TELL
The+verb ,CH-SOLDIERS "growl" " back at you menacingly." CR
					>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<COND
				(<AND <VERB? SHOW>
						<MC-PRSO? ,TH-GAUNTLET>
						<IN? ,TH-GAUNTLET ,WINNER>
						<MC-HERE? ,RM-CASTLE-GATE>
					>
					<TELL
"The guard sees" the ,TH-GAUNTLET " and says, \"Enter.\" He opens the massive
gate and steps aside as you" walk " through.||"
					>
					<RT-GOTO ,RM-PARADE-AREA T>
				)
				(<AND <VERB? THROW>
						<IDROP>
					>
					<TELL
"The guard nimbly sidesteps the projectile and then absentmindedly lops off
your head with his pollaxe." CR
					>
					<RT-END-OF-GAME>
				)
			>
		)
		(<AND <VERB? TELL>
				,P-CONT
			>
		; "Message and RFATAL if don't want soldiers to become winner"
			<RFALSE>
		)
		(<VERB? CALL>
			<COND
				(<NOT <MC-HERE?
							,RM-CELL
							,RM-BOTTOM-OF-STAIRS
							,RM-HALL
							,RM-END-OF-HALL
							,RM-SMALL-CHAMBER
						>
					>
					<RFALSE>
				)
				(<FSET? ,CH-CELL-GUARD ,FL-ASLEEP>
					<RT-DEQUEUE ,RT-I-ALARM>
					<RT-I-ALARM>
				)
				(T
					<RT-DEQUEUE ,RT-I-GUARD-1>
					<RT-I-GUARD-1>
				)
			>
		)
		(<SPEAKING-VERB?>
			<TELL The+verb ,CH-SOLDIERS "growl" " back at you menacingly." CR>
		)
		(<VERB? EXAMINE>
			<FSET ,CH-SOLDIERS ,FL-SEEN>
			<COND
				(<MC-HERE? ,RM-CHURCHYARD>
					<COND
						(<IN? ,CH-SOLDIERS ,RM-TOWN-SQUARE>	;<FSET? ,CH-SOLDIERS ,FL-NO-DESC>
							<TELL
"All you can see is the light glinting off their helmets." CR
							>
						)
						(T
							<TELL He+verb ,CH-SOLDIERS "look" " nervous and alert." CR>
						)
					>
				)
				(<MC-HERE? ,RM-CASTLE-GATE ,RM-PARADE-AREA>
					<TELL
"Like all soldiers forced to stand guard-duty, he looks uncomfortable,
unhappy, and decidedly unfriendly." CR
					>
				)
				(<MC-HERE? ,RM-GREAT-HALL>
					<TELL He+verb ,CH-SOLDIERS "look" " nervous and alert." CR>
				)
			>
		)
		(<VERB? LISTEN>
			<COND
				(<IN? ,CH-SOLDIERS ,RM-CHURCHYARD>
					<TELL The+verb ,CH-SOLDIERS "are" ,K-MUTTERING-MSG>
				)
			>
		)
		(<VERB? ATTACK>
			<COND
				(<MC-HERE? ,RM-CHURCHYARD>
					<RT-SEIZE-MSG ,CH-SOLDIERS>
				)
				(<MC-FORM? ,K-FORM-ARTHUR>
					<TELL
"You attack the soldier, but he is immediately re-inforced by other soldiers
from inside the garrison and you are quickly overwhelmed. They haul you away
to rot in a prison cell.|"
					>
				)
				(T
					<TELL
The ,CH-SOLDIERS " absentmindedly" verb ,CH-SOLDIERS "sidestep" " your attack,
and" verb ,CH-SOLDIERS "skewer" " you neatly through the heart.|"
					>
				)
			>
			<RT-END-OF-GAME>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-POLLAXE"
;"---------------------------------------------------------------------------"

<OBJECT TH-POLLAXE
	(DESC "pollaxe")
	(FLAGS FL-NO-DESC FL-TRY-TAKE)
	(SYNONYM POLLAXE AXE)
	(OWNER CH-SOLDIERS)
	(ACTION RT-TH-POLLAXE)
>

<ROUTINE RT-TH-POLLAXE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<TOUCH-VERB?>
			<COND
				(<MC-FORM? ,K-FORM-ARTHUR>
					<TELL
The+verb ,CH-SOLDIERS "cuff" " you on the side of the head and snarls,
\"Hands off.\"" CR
					>
				)
				(T
					<TELL
"As you approach the guard, he says," ,K-LOVERLY-MSG form ,K-SKEWER-MSG
					>
					<RT-END-OF-GAME>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-POLLAXE ,FL-SEEN>
			<TELL "It looks like a cross between a pike and a battleaxe." CR>
		)
	>
>

<ROUTINE RT-ENTER-GATE ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<RETURN ,RM-PARADE-AREA>
		)
		(<OR	<NOT <MC-FORM? ,K-FORM-ARTHUR>>
				<FSET? ,CH-SOLDIERS ,FL-LOCKED>
			>
			<RETURN ,RM-PARADE-AREA>
		)
		(<IN? ,TH-GAUNTLET ,WINNER>
			<TELL
"The guard sees" the ,TH-GAUNTLET " and says, \"Enter.\" He opens the massive
gate and steps aside as you" walk " through.||"
			>
			<RETURN ,RM-PARADE-AREA>
		)
		(T
			<RT-NO-ONE-MSG "enters">
			<RFALSE>
		)
	>
>

<ROUTINE RT-NO-ONE-MSG (STR "OPT" (CAP? T))
	<COND
		(.CAP?
			<TELL "T">
		)
		(T
			<TELL " t">
		)
	>
	<TELL
"he guard lowers his pollaxe to block your path and sneers, \"No one " .STR "
the castle unless they know the password.\"" CR
	>
>

<ROUTINE RT-EXIT-GATE ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<RETURN ,RM-CASTLE-GATE>
		)
		(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
			<RT-CLEAR-PUPPY>
			<RETURN ,RM-CASTLE-GATE>
		)
		(<FSET? ,CH-SOLDIERS ,FL-LOCKED>
			<RETURN ,RM-CASTLE-GATE>
		)
		(T
			<RT-NO-ONE-MSG "leaves">
			<RFALSE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-PASSWORD"
;"---------------------------------------------------------------------------"

<OBJECT TH-PASSWORD
	(LOC GENERIC-OBJECTS)
	(DESC "password")
	(SYNONYM PASSWORD PASSWORDS WORD WORDS FAIR BEGOT THERE LOT)
	(ADJECTIVE PASS NO KING SO BY MAID WAS EVER THAN GOOD)
;	(GENERIC RT-GN-KING-LOT)
	(ACTION RT-TH-PASSWORD)
>

; "TH-PASSWORD flags:"
; "	FL-TOUCHED - Player has heard Lot give a password."

<ROUTINE RT-TH-PASSWORD ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<AND <NOUN-USED? ,TH-PASSWORD ,W?LOT>
				<NOT <VERB? SAY BE>>
			>
			<COND
				(,NOW-PRSI
					<PERFORM ,PRSA ,PRSO ,CH-LOT>
				)
				(T
					<PERFORM ,PRSA ,CH-LOT ,PRSI>
				)
			>
			<RTRUE>
		)
	>
>

<CONSTANT K-POEM-TBL
	<TABLE (PURE LENGTH)
		<TABLE (PURE LENGTH) <VOC "NO"> <VOC "KING"> <VOC "SO"> <VOC "FAIR">>
		<TABLE (PURE LENGTH) <VOC "BY"> <VOC "MAID"> <VOC "BEGOT">>
		<TABLE (PURE LENGTH) <VOC "WAS"> <VOC "EVER"> <VOC "THERE">>
		<TABLE (PURE LENGTH) <VOC "THAN"> <VOC "GOOD"> <VOC "KING"> <VOC "LOT">>
	>
>

<GLOBAL GL-POEM-LINE 0 <> BYTE>

<ROUTINE RT-CORRECT-PASSWORD? (PW "AUX" TBL M N PTR NP END)
	<COND
		(,GL-POEM-LINE
			<COND
				(<EQUAL? .PW ,INTQUOTE>
					<COND
						(<AND <SET NP <GET-NP ,INTQUOTE>>
								<SET PTR <NP-LEXBEG .NP>>
							>
							<COND
								(<EQUAL? <ZGET .PTR 0> ,W?QUOTE>
									<SET PTR <ZREST .PTR 8>>
								)
							>
							<COND
								(<SET END <NP-LEXEND .NP>>
									<SET M </ <- .END .PTR> 4>>
								)
							>
							<COND
								(<EQUAL? <ZGET .PTR 0> ,W?THE>
									<SET PTR <ZREST .PTR 4>>
									<DEC M>
								)
							>
							<COND
								(<EQUAL? <ZGET .PTR 0> ,W?PASSWORD ,W?PASSWORDS ,W?WORD ,W?WORDS>
									<SET PTR <ZREST .PTR 4>>
									<DEC M>
									<COND
										(<EQUAL? <ZGET .PTR 0> ,W?IS ,W?ARE>
											<SET PTR <ZREST .PTR 4>>
											<DEC M>
										)
									>
								)
								(<EQUAL? <ZGET .PTR 0> ,W?PASS>
									<COND
										(<EQUAL? <ZGET .PTR 2> ,W?WORD ,W?WORDS>
											<SET PTR <ZREST .PTR 8>>
											<SET M <- .M 2>>
											<COND
												(<EQUAL? <ZGET .PTR 0> ,W?IS ,W?ARE>
													<SET PTR <ZREST .PTR 4>>
													<DEC M>
												)
											>
										)
									>
								)
							>
							<SET TBL <ZGET ,K-POEM-TBL ,GL-POEM-LINE>>
							<SET N <ZGET .TBL 0>>
							<REPEAT ((I 0))
								<COND
									(<IGRTR? I .N>
										<COND
											(<OR	<G? .I .M>
													<EQUAL? <ZGET .PTR 0> ,W?QUOTE>
												>
												<RTRUE>
											)
											(T
												<RFALSE>
											)
										>
									)
									(<NOT <EQUAL? <ZGET .PTR 0> <ZGET .TBL .I>>>
										<RFALSE>
									)
								>
								<SET PTR <ZREST .PTR 4>>
							>
						)
					>
				)
				(<EQUAL? .PW ,TH-PASSWORD>
					<COND
						(<AND <SET NP <GET-NP ,TH-PASSWORD>>
								<SET PTR <NP-LEXEND .NP>>	;"Have to start at end and work backwards"
							>
							<SET TBL <ZGET ,K-POEM-TBL ,GL-POEM-LINE>>
							<SET N <ZGET .TBL 0>>
							<REPEAT ((I .N))
								<COND
									(<NOT <EQUAL? <ZGET .PTR 0> <ZGET .TBL .I>>>
										<RFALSE>
									)
									(<DLESS? I 1>
										<RTRUE>
									)
								>
								<SET PTR <ZBACK .PTR 4>>
							>
						)
					>
				)
			>
		)
	>
>

<GLOBAL GL-SOLDIER-CNT 0 <> BYTE>

<ROUTINE RT-SOLDIER-SUSPECT (PW "AUX" PQ PTR TBL N (S? <>) NP)
	<COND
		(<EQUAL? .PW ,INTQUOTE>
			<COND
				(<AND <SET NP <GET-NP ,INTQUOTE>>
						<SET PQ <NP-LEXBEG .NP>>
					>
					<COND
						(<EQUAL? <ZGET .PQ 0> ,W?QUOTE>
							<SET PQ <ZREST .PQ 8>>
						)
					>
					<COND
						(<EQUAL? <ZGET .PQ 0> ,W?THE>
							<SET PQ <ZREST .PQ 4>>
						)
					>
					<COND
						(<EQUAL? <ZGET .PQ 0> ,W?PASSWORD ,W?PASSWORDS ,W?WORD ,W?WORDS>
							<SET PQ <ZREST .PQ 4>>
							<COND
								(<EQUAL? <ZGET .PQ 0> ,W?IS ,W?ARE>
									<SET PQ <ZREST .PQ 4>>
								)
							>
						)
						(<EQUAL? <ZGET .PQ 0> ,W?PASS>
							<COND
								(<EQUAL? <ZGET .PQ 2> ,W?WORD ,W?WORDS>
									<SET PQ <ZREST .PQ 8>>
									<COND
										(<EQUAL? <ZGET .PQ 0> ,W?IS ,W?ARE>
											<SET PQ <ZREST .PQ 4>>
										)
									>
								)
							>
						)
					>
					<REPEAT ((I 0) (L <ZGET ,K-POEM-TBL 0>))
						<COND
							(<IGRTR? I .L>
								<RETURN>
							)
							(T
								<SET PTR .PQ>
								<SET TBL <ZGET ,K-POEM-TBL .I>>
								<SET N <ZGET .TBL 0>>
								<REPEAT ((J 0))
									<COND
										(<IGRTR? J .N>
											<SET S? T>
											<RETURN>
										)
										(<NOT <EQUAL? <ZGET .PTR 0> <ZGET .TBL .J>>>
											<RETURN>
										)
										(T
											<SET PTR <ZREST .PTR 4>>
										)
									>
								>
								<COND
									(.S?
										<RETURN>
									)
								>
							)
						>
					>
				)
			>
		)
		(<EQUAL? .PW ,TH-PASSWORD>
			<COND
				(<AND <SET NP <GET-NP ,TH-PASSWORD>>
						<SET PQ <NP-LEXEND .NP>>	;"Have to start at end and work backwards"
					>
					<REPEAT ((I 0) (L <ZGET ,K-POEM-TBL 0>))
						<COND
							(<IGRTR? I .L>
								<RETURN>
							)
							(T
								<SET PTR .PQ>
								<SET TBL <ZGET ,K-POEM-TBL .I>>
								<SET N <ZGET .TBL 0>>
								<REPEAT ((J .N))
									<COND
										(<NOT <EQUAL? <ZGET .PTR 0> <ZGET .TBL .J>>>
											<RETURN>
										)
										(<DLESS? J 1>
											<SET S? T>
											<RETURN>
										)
									>
									<SET PTR <ZBACK .PTR 4>>
								>
								<COND
									(.S?
										<RETURN>
									)
								>
							)
						>
					>
				)
			>
		)
	>
	<COND
		(.S?
			<INC GL-SOLDIER-CNT>
			<COND
				(<EQUAL? ,GL-SOLDIER-CNT 1>
					<TELL
"The soldier looks at you with contempt and says, \"That password is no
longer valid.\""
					>
				)
				(<EQUAL? ,GL-SOLDIER-CNT 2>
					<TELL
"The soldier looks at you suspiciously and says, \"That password is no longer
valid either.\""
					>
				)
				(<EQUAL? ,GL-SOLDIER-CNT 3>
					<TELL
"The soldier looks at you with great suspicion and says, \"None of those
passwords is valid any more.\""
					>
				)
				(<EQUAL? ,GL-SOLDIER-CNT 4>
					<TELL
"The soldier arrests you and says, \"That's it, mate. I don't know who you
are, or how you know so much about our passwords without knowing the current
one, but you sound like some kind of spy to me. But perhaps a few days in a
nice dark cell will clear things up.\" He hauls you off to the dungeon.|"
					>
					<RT-END-OF-GAME>
				)
			>
		)
		(T
			<TELL "The soldier sneers at you.">
		)
	>
	<COND
		(<MC-HERE? ,RM-CASTLE-GATE ,RM-PARADE-AREA>
			<TELL " He continues to block your path.">
		)
	>
	<CRLF>
	<RTRUE>
>

;"---------------------------------------------------------------------------"
; "LG-CASTLE-GATE"
;"---------------------------------------------------------------------------"

<OBJECT LG-CASTLE-GATE
	(LOC LOCAL-GLOBALS)
	(DESC "castle gate")
	(FLAGS FL-DOOR)
	(SYNONYM GATE DOOR)
	(ADJECTIVE CASTLE MASSIVE WOODEN)
	(ACTION RT-LG-CASTLE-GATE)
>

<ROUTINE RT-LG-CASTLE-GATE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<OR	<AND
					<VERB? WALK-UNDER>
					<MC-FORM? ,K-FORM-SALAMANDER ,K-FORM-BADGER>
				>
				<AND
					<VERB? CLIMB-OVER>
					<MC-FORM? ,K-FORM-OWL>
				>
			>
			<COND
				(<MC-HERE? ,RM-PARADE-AREA>
					<RT-DO-WALK ,P?WEST>
				)
				(<MC-HERE? ,RM-CASTLE-GATE>
					<RT-DO-WALK ,P?EAST>
				)
			>
		)
		(<TOUCH-VERB?>
			<TELL "As you reach for" the ,LG-CASTLE-GATE ",">
			<COND
				(<MC-FORM? ,K-FORM-ARTHUR>
					<COND
						(<MC-HERE? ,RM-CASTLE-GATE>
							<RT-NO-ONE-MSG "enters" <>>
						)
						(<MC-HERE? ,RM-PARADE-AREA>
							<RT-NO-ONE-MSG "leaves" <>>
						)
					>
				)
				(T
					<TELL " the guard says," ,K-LOVERLY-MSG form ,K-SKEWER-MSG>
					<RT-END-OF-GAME>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET LG-CASTLE-GATE ,FL-SEEN>
			<TELL "It's a massive wooden gate set into the stone wall." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-PARADE-AREA"
;"---------------------------------------------------------------------------"

<ROOM RM-PARADE-AREA
   (LOC ROOMS)
   (DESC "parade area")
   (FLAGS FL-LIGHTED)
   (SYNONYM AREA)
   (ADJECTIVE PARADE)
   (EAST TO RM-GREAT-HALL)
   (WEST PER RT-EXIT-GATE)
   (OUT PER RT-EXIT-GATE)
   (SOUTH TO RM-ARMOURY)
   (SE TO RM-CAS-KITCHEN IF LG-KITCHEN-DOOR IS OPEN)
	(UP PER RT-FLY-UP)
   (GLOBAL
		LG-CASTLE-GATE LG-KITCHEN-DOOR LG-WALL LG-CASTLE RM-GREAT-HALL
		RM-CAS-KITCHEN RM-ARMOURY
	)
   (ACTION RT-RM-PARADE-AREA)
   (THINGS (OLD STONE) (TOWER TOWERS) RT-PS-STONE-TOWER)
>

<ROUTINE RT-RM-PARADE-AREA ("OPT" (CONTEXT <>) "AUX" PW)
   <COND
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<AND <MC-FORM? ,K-FORM-ARTHUR>
						<OR
							<VERB? $PASSWORD>
							<AND
								<VERB? BE>
								<MC-PRSO? ,TH-PASSWORD>
							>
							<AND
								<VERB? SAY>
								<MC-PRSI? <> ,CH-SOLDIERS>
							>
						>
					>
					<COND
						(<VERB? BE>
							<SET PW ,PRSI>
						)
						(T
							<SET PW ,PRSO>
						)
					>
					<COND
					;	(<IN? ,TH-GAUNTLET ,WINNER>
							<TELL
"The guard sees" the ,TH-GAUNTLET " and says, \"Enter.\" He opens the massive
gate and steps aside as you" walk " through.||"
							>
							<SETG WINNER ,CH-PLAYER>
							<RT-GOTO ,RM-CASTLE-GATE T>
						)
						(<OR	<VERB? $PASSWORD>
								<RT-CORRECT-PASSWORD? .PW>
							>
							<FSET ,CH-SOLDIERS ,FL-LOCKED>
							<TELL
The ,CH-SOLDIERS " reluctantly" verb ,CH-SOLDIERS "step" " aside to let you
pass.||"
							>
							<SETG WINNER ,CH-PLAYER>
							<RT-GOTO ,RM-CASTLE-GATE T>
						)
						(T
							<RT-SOLDIER-SUSPECT .PW>
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-PARADE-AREA>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<MOVE ,CH-SOLDIERS ,RM-PARADE-AREA>
			<MOVE ,TH-POLLAXE ,CH-SOLDIERS>
			<FCLEAR ,CH-SOLDIERS ,FL-PLURAL>
			<FSET ,CH-SOLDIERS ,FL-NO-DESC>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTERED>
			<COND
				(<IN? ,CH-PRISONER ,RM-PARADE-AREA>
					<COND
						(<FSET? ,CH-SOLDIERS ,FL-BROKEN>
							<TELL
"|The soldier recognizes the prisoner and" ,K-GUARDS-COME-MSG
							>
							<RT-ARREST-PRISONER-MSG>
						)
						(<EQUAL? ,OHERE ,RM-CAS-KITCHEN>
							<FSET ,CH-PRISONER ,FL-AIR>
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-EXIT>
			<FCLEAR ,CH-SOLDIERS ,FL-LOCKED>
			<SETG GL-SOLDIER-CNT 0>
			<RFALSE>
		)
      (<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,LG-CASTLE-GATE ,FL-SEEN>
			<FSET ,RM-ARMOURY ,FL-SEEN>
			<FSET ,RM-GREAT-HALL ,FL-SEEN>
			<FSET ,RM-CAS-KITCHEN ,FL-SEEN>
			<TELL "You">
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL " are" standing " in">
				)
				(<EQUAL? ,OHERE ,RM-CASTLE-GATE>
					<COND
						(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
							<COND
								(<MC-FORM? ,K-FORM-OWL>
									<TELL " fly over">
								)
								(T
									<TELL " crawl under">
								)
							>
						)
						(T
							<TELL walk " inside">
						)
					>
					<TELL " the castle gate and are now in">
				)
				(T
					<TELL " come to">
				)
			>
         <TELL
" the parade area of King Lot's castle. The gate in the west wall is guarded
by a soldier. The armoury is to the south, the entrance to the great hall is
to the east, and the kitchen is to the southeast.|"
         >
         <RFALSE>
      )
		(<MC-CONTEXT? ,M-END>
			<COND
				(<VERB? TRANSFORM>
					<COND
						(<NOT <MC-FORM? ,GL-OLD-FORM>>
							<TELL
"\"Sorcery!! Work of the Devil!!\" " The+verb ,CH-SOLDIERS "skewer" " you
through the heart with" his ,CH-SOLDIERS " sword." ,K-HEEDED-WARNING-MSG
							>
							<RT-END-OF-GAME>
						)
						(,GL-FORM-ABORT
							<TELL
"|Fortunately, it all happened so quickly that" the ,CH-SOLDIERS " didn't notice." CR
							>
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

<ROUTINE RT-PS-STONE-TOWER ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
    <FCLEAR ,PSEUDO-OBJECT ,FL-PLURAL>
    <FCLEAR ,PSEUDO-OBJECT ,FL-VOWEL>
    <COND
        (<MC-CONTEXT? ,M-OBJDESC>
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
                    <TELL "tower">
                )
            >
        )
        (.CONTEXT
            <RFALSE>
        )
        (<VERB? EXAMINE>
            <TELL ,K-ROMAN-FORT-MSG CR>
        )
    >

;"---------------------------------------------------------------------------"
; "RM-GREAT-HALL"
;"---------------------------------------------------------------------------"

<ROOM RM-GREAT-HALL
   (LOC ROOMS)
   (DESC "great hall")
   (FLAGS FL-INDOORS FL-LIGHTED)
   (SYNONYM HALL BUILDING STRUCTURE)
   (ADJECTIVE GREAT WOODEN WOOD LONG)
   (EAST PER RT-MOVE-TAPESTRY)
   (WEST TO RM-PARADE-AREA)
   (OUT TO RM-PARADE-AREA)
	(GLOBAL LG-OWL-TAPESTRY LG-WALL)
   (ACTION RT-RM-GREAT-HALL)
>

<ROUTINE RT-RM-GREAT-HALL ("OPT" (CONTEXT <>) "AUX" PW)
   <COND
      (<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL
"You are" standing " in a circle of people surrounding the throne in"
					>
				)
				(T
					<TELL "You trade the bright ">
					<COND
						(<RT-TIME-OF-DAY? ,K-NIGHT>
							<TELL "moon">
						)
						(T
							<TELL "sun">
						)
					>
					<TELL "light for the dark interior of">
				)
			>
			<FSET ,CH-LOT ,FL-SEEN>
			<FSET ,TH-LOT-THRONE ,FL-SEEN>
			<FSET ,LG-OWL-TAPESTRY ,FL-SEEN>
			<FSET ,CH-COURTIERS ,FL-SEEN>
         <TELL
" King Lot's great hall. It is a large room with a dark, timbered ceiling.
King Lot is enthroned on a massive chair in front of an intricately-woven
tapestry. He is surrounded by his courtiers.|"
         >
         <RFALSE>
      )
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<OR	<VERB? $PASSWORD>
						<AND <VERB? BE> <MC-PRSO? ,TH-PASSWORD>>
						<AND <VERB? SAY> <MC-PRSI? <> ,CH-SOLDIERS>>
					>
					<COND
						(<AND <EQUAL? <MOD ,GL-MOVES 180> 179>
								<MC-PRSI? <> ,CH-SOLDIERS>
							>
							<COND
								(<VERB? BE>
									<SET PW ,PRSI>
								)
								(T
									<SET PW ,PRSO>
								)
							>
							<TELL "The soldier says ">
							<COND
								(<OR	<VERB? $PASSWORD>
										<RT-CORRECT-PASSWORD? .PW>
									>
									<FSET ,CH-SOLDIERS ,FL-LOCKED>
									<TELL
"reluctantly, \"That's correct. You may stay.\"" CR
									>
								)
								(T
									<TELL
"sternly, \"That's not the password. Come with me.\" He"
									>
									<RT-LEAVE-CASTLE>
								)
							>
						)
						(<VERB? SAY>
							<TELL "The king and all his court just laugh at you." CR>
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-END>
			<COND
				(<VERB? TRANSFORM>
					<COND
						(<NOT <MC-FORM? ,GL-OLD-FORM>>
							<TELL
"\"Sorcery!! Work of the Devil!!\" A soldier skewers you through the heart
with his sword." ,K-HEEDED-WARNING-MSG
							>
							<RT-END-OF-GAME>
						)
						(,GL-FORM-ABORT
							<TELL
"|Fortunately, it all happened so quickly that" the ,CH-SOLDIERS " didn't notice." CR
							>
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-GREAT-HALL>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<MOVE ,CH-SOLDIERS ,RM-GREAT-HALL>
			<REMOVE ,TH-POLLAXE>
			<FSET ,CH-SOLDIERS ,FL-PLURAL>
			<FCLEAR ,CH-SOLDIERS ,FL-LOCKED>
			<RT-QUEUE ,RT-I-SOLDIER-ASK
				<+ <- ,GL-MOVES
						<MOD ,GL-MOVES 180>
					>
					178
				>
				T
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTERED>
			<COND
				(<IN? ,CH-PRISONER ,RM-GREAT-HALL>
					<TELL
CR "After a few moments, Lot happens to glance at your companion. ">
                    <COND
                        (<IN? ,TH-HELMET ,CH-PRISONER>
                            <TELL
"He starts to look away, but then suddenly he leaps to his feet and knocks
the helmet off the smith's head."
                            >
                        )
                        (T
                            <TELL
"Suddenly, he leaps to his feet as he recognizes the smith."
                            >
                        )
                    >
                    <TELL
" He points at the two of you and calls out, \"Guards! Arrest them!\" His
guards quickly close around you"
					>
					<COND
						(<IN? ,TH-BRACELET ,CH-PLAYER>
							<TELL
". As they are carrying you away, Lot notices your bracelet and shouts,
\"Take his bracelet.\" The guards strip you of the bracelet, toss it
to Lot,"
							>
						)
					>
					<TELL " and then bear you off to rot in a dungeon.|">
					<RT-END-OF-GAME>
				)
				(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
					<TELL
"|One of the soldiers says," ,K-GET-OUT-MSG form ".\" He waves his arms and
shoos you out the door into the parade area.||"
					>
					<RT-GOTO ,RM-PARADE-AREA>
				)
			>
		)
		(<MC-CONTEXT? ,M-EXIT>
			<RT-DEQUEUE ,RT-I-SOLDIER-ASK>
			<RFALSE>
		)
      (.CONTEXT
         <RFALSE>
      )
        (<AND <VERB? EXAMINE>
                <NOT <MC-HERE? ,RM-GREAT-HALL>>
            >
            <TELL
"It's a long wooden structure that has been built against the old Roman
fortress wall." CR
            >
        )
   >
>

<ROUTINE RT-I-SOLDIER-ASK ()
	<FCLEAR ,CH-SOLDIERS ,FL-LOCKED>
	<COND
		(<FSET? ,CH-PLAYER ,FL-ASLEEP>
			<MOVE ,CH-PLAYER ,RM-CASTLE-GATE>
			<SETG OHERE ,HERE>
			<SETG HERE <LOC ,CH-PLAYER>>
			<RFALSE>
		)
		(T
			<RT-QUEUE ,RT-I-SOLDIER-ASK <+ ,GL-MOVES 180>>
			<TELL
"|One of Lot's soldiers approaches you and asks, \"What's the password?\"" CR
			>
		)
	>
>

<ROUTINE RT-LEAVE-CASTLE ()
	<TELL
" grabs your tunic, drags you out of the castle, and unceremoniously dumps
you outside the castle gate.||"
	>
	<RT-GOTO ,RM-CASTLE-GATE T>
>

;"---------------------------------------------------------------------------"
; "TH-LOT-THRONE"
;"---------------------------------------------------------------------------"

<OBJECT TH-LOT-THRONE
	(LOC RM-GREAT-HALL)
	(DESC "throne")
	(FLAGS FL-NO-DESC FL-SEARCH FL-SURFACE)
	(SYNONYM THRONE CHAIR)
	(OWNER CH-LOT)
	(ACTION RT-TH-LOT-THRONE)
>

<ROUTINE RT-TH-LOT-THRONE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<COND
				(<IN? ,CH-LOT ,TH-LOT-THRONE>
					<FSET ,TH-LOT-THRONE ,FL-SEEN>
					<FSET ,CH-LOT ,FL-SEEN>
					<TELL
The+verb ,CH-LOT "are" " sitting on" the ,TH-LOT-THRONE "." CR
					>
				)
			>
		)
		(<TOUCH-VERB?>
			<RT-ATTACK-LOT>
		)
	>
>

;"---------------------------------------------------------------------------"
; "CH-LOT"
;"---------------------------------------------------------------------------"

<OBJECT CH-LOT
	(LOC TH-LOT-THRONE)
	(DESC "King Lot")
	(FLAGS FL-ALIVE FL-NO-ARTICLE FL-NO-DESC FL-OPEN FL-PERSON FL-SEARCH)
	(SYNONYM KING LOT MAN PERSON)
	(ADJECTIVE KING)
;	(GENERIC RT-GN-KING-LOT)
	(ACTION RT-CH-LOT)
>

; "CH-LOT flags:"
; "	FL-BROKEN	FL-LOCKED"
; "	---------	---------"
; "		0				0		In Field of Honour - fight is raging"
; "								In Great Hall - Lot is on throne"
; "		1				0		Lot is distracted and bending over the bracelet"
; "		0				1		Lot is disarmed and at your mercy"
; "		1				1		The fight is over and you have spared Lot"

<CONSTANT K-LOT-GREED-MSG "Lot's eyes widen with greed when he sees">
<CONSTANT K-LOT-WANT-MSG
". Then, just as quickly, the look is gone. \"It doesn't look very
valuable,\" he says. \"But if you would like me to hold it in safekeeping
for you, I would be happy to.\"">

<ROUTINE RT-CH-LOT ("OPT" (CONTEXT <>))
	<COND
		(<AND <MC-CONTEXT? ,M-WINNER <>>
				<VERB? HELLO GOODBYE THANK>
			>
			<COND
				(<MC-HERE? ,RM-GREAT-HALL>
					<RT-LOT-IGNORE-MSG>
				)
				(<AND <MC-HERE? ,RM-FIELD-OF-HONOUR>
						<NOT <FSET? ,CH-LOT ,FL-LOCKED>>
					>
					<RT-LOT-IGNORE-MSG>
				)
				(<AND <MC-HERE? ,RM-FIELD-OF-HONOUR>
						<NOT <FSET? ,CH-LOT ,FL-BROKEN>>
						<FSET? ,CH-LOT ,FL-LOCKED>
					>
					<TELL "I am at your mercy, sir. Please do not toy with me so." CR>
				)
				(<VERB? HELLO>
					<TELL "\"Greetings, Arthur.\"" CR>
				)
				(<VERB? GOODBYE>
					<TELL "\"Farewell, Arthur.\"" CR>
				)
				(<VERB? THANK>
					<TELL "\"You're welcome, Arthur.\"" CR>
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
				(<MC-HERE? ,RM-GREAT-HALL>
					<RT-LOT-IGNORE-MSG>
				)
				(T
					<COND
						(<AND <FSET? ,CH-LOT ,FL-BROKEN>
								<FSET? ,CH-LOT ,FL-LOCKED>
							;	<NOT <SPEAKING-VERB?>> ; "to pass 'lot, hello' to default"
							>
							<TELL
"\"Let us get free of this mob and I will do whatever you ask.\"" CR
							>
						)
						(<AND <FSET? ,CH-LOT ,FL-LOCKED>
								<NOT <SPEAKING-VERB?>>
							>
							<TELL
"\"Spare my life and I will do whatever you ask.\"" CR
							>
						)
						(T
							<RT-LOT-IGNORE-MSG>
						)
					>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<AND <VERB? TELL>
				,P-CONT
			>
		; "Message and RFATAL if don't want knight to become winner"
			<RFALSE>
		)
		(,NOW-PRSI
			<COND
				(<AND <MC-HERE? ,RM-FIELD-OF-HONOUR>
						<VERB? SHOW GIVE THROW>
						<MC-PRSO? ,TH-BRACELET>
						<NOT <FSET? ,CH-LOT ,FL-LOCKED>>
					>
					<RT-DISTRACT-LOT>
				)
				(<VERB? GIVE>
					<COND
						(<MC-HERE? ,RM-GREAT-HALL>
							<COND
								(<MC-PRSO? ,TH-BRACELET ,TH-GOLD-KEY ,TH-SILVER-KEY ,TH-RAVEN-EGG>
									<TELL
"Lot takes" the ,PRSO " and holds it up for his courtiers to see. \"Look!\"
he cries. \"See how the people of the land trust their king with their valued
possessions.\"||He then drops" the ,PRSO " into his "
									>
									<COND
										(<G? <GETB <GETPT ,PRSO ,P?SIZE> ,K-SIZE> 5>
											<TELL "lap">
										)
										(T
											<TELL "pocket">
										)
									>
									<TELL
" and laughs. \"That is why they are the peasants, and we are their masters.\"
He gestures to his guards. \"Now take him away and find out where the urchin
stole an item of such great value.\"|"
									>
									<RT-END-OF-GAME>
								)
							>
						)
						(<AND <FSET? ,CH-LOT ,FL-BROKEN>
								<FSET? ,CH-LOT ,FL-LOCKED>
								<MC-PRSO? ,TH-BRACELET ,TH-GOLD-KEY ,TH-SILVER-KEY ,TH-RAVEN-EGG>
							>
							<TELL
"\"I've learned my lesson, milord. Please keep it.\"" CR
							>
						)
					>
				)
				(<VERB? SHOW>
					<COND
						(<MC-HERE? ,RM-GREAT-HALL>
							<COND
								(<MC-PRSO? ,TH-BRACELET ,TH-GOLD-KEY ,TH-SILVER-KEY ,TH-RAVEN-EGG>
									<TELL ,K-LOT-GREED-MSG the ,PRSO ,K-LOT-WANT-MSG CR>
								)
							>
						)
					>
				)
				(<VERB? THROW>
					<COND
						(<MC-HERE? ,RM-GREAT-HALL>
							<COND
								(<MC-PRSO? ,TH-GAUNTLET>
									<RT-TRIGGER-ENDGAME>
								)
								(T
									<RT-ATTACK-LOT>
								)
							>
						)
					>
				)
			>
		)
		(<VERB? ASK-ABOUT>
			<COND
				(<AND <MC-HERE? ,RM-FIELD-OF-HONOUR>
						<NOT <FSET? ,CH-LOT ,FL-LOCKED>>
					>
					<RT-LOT-IGNORE-MSG>
				)
				(<MC-PRSI? ,TH-EXCALIBUR ,TH-LOT-SWORD>
					<COND
						(<MC-HERE? ,RM-GREAT-HALL>
							<TELL
"\"The sword is mine. A gift from the angels. With it I shall rule all
England.\"" CR
							>
						)
						(T
							<COND
								(<AND <FSET? ,CH-LOT ,FL-BROKEN>
										<FSET? ,CH-LOT ,FL-LOCKED>
									>
									<TELL
"\"The sword is yours, to do with as you please.\"" CR
									>
								)
								(<FSET? ,CH-LOT ,FL-LOCKED>
									<TELL
"\"You are the victor. You may have the sword.\"" CR
									>
								)
							>
						)
					>
				)
				(<MC-PRSI? ,TH-BRACELET ,TH-GOLD-KEY ,TH-SILVER-KEY ,TH-RAVEN-EGG>
					<COND
						(<MC-HERE? ,RM-GREAT-HALL>
							<COND
								(<IN? ,PRSI ,CH-PLAYER>
									<TELL ,K-LOT-GREED-MSG the ,PRSI ,K-LOT-WANT-MSG CR>
								)
								(T
									<TELL "\"I would like to see this ">
									<NP-PRINT ,PRSI-NP>
									<TELL ".\"" CR>
								)
							>
						)
						(T
							<TELL
!\" The+verb ,PRSI "are" " yours. I was wrong to covet" him ,PRSI ".\"" CR
							>
						)
					>
				)
				(<MC-PRSI? ,CH-PRISONER>
					<COND
						(<MC-HERE? ,RM-GREAT-HALL>
							<TELL "\"Enough. Cease this prattling!\"" CR>
						)
						(T
							<TELL
"\"The smith was innocent. I will find him, ask his forgiveness, and
recompense him for the wrongs I did him.\"" CR
							>
						)
					>
				)
				(<MC-PRSI? ,CH-LOT>
					<COND
						(<MC-HERE? ,RM-GREAT-HALL>
							<TELL
"\"I am king of this region, and soon I shall be High King of all England.\"" CR
							>
						)
						(T
							<TELL "\"Henceforth, I shall be your devoted servant.\"" CR>
						)
					>
				)
				(<MC-PRSI? ,CH-MERLIN>
					<COND
						(<MC-HERE? ,RM-GREAT-HALL>
							<TELL
"\"That old fool? I have nothing to fear from him.\"" CR
							>
						)
						(T
							<TELL
"\"He has served you well, my lord. Henceforth he shall be welcome in my hall.\"" CR
							>
						)
					>
				)
				(T
					<COND
						(<MC-HERE? ,RM-GREAT-HALL>
							<TELL "King Lot ignores both you and your question." CR>
						)
						(T
							<TELL
"\"Of that I know nothing, sire. But if you wish it, I shall find out.\"" CR
							>
						)
					>
				)
			>
		)
		(<VERB? CHALLENGE>
			<COND
				(<MC-HERE? ,RM-GREAT-HALL>
					<COND
						(<MC-PRSI? ,TH-GAUNTLET>
							<RT-TRIGGER-ENDGAME>
						)
						(<AND ,PRSI
								<FSET? ,PRSI ,FL-WEAPON>
							>
							<RT-ATTACK-LOT>
						)
						(T
							<SETG GL-QUESTION 1>
							<TELL
"The evil king laughs. \"You! A mere boy? Challenge me? Ha!\" All the
courtiers follow the king's cue and laugh at you." CR
							>
							<COND
								(<AND <FSET? ,TH-BRACELET ,FL-WORN>
										<IN? ,TH-BRACELET ,CH-PLAYER>
									>
									<TELL
"|You notice the king glance at your bracelet." CR
									>
								)
							>
							<RTRUE>
						)
					>
				)
			>
		)
		(<VERB? ATTACK>
			<COND
				(<MC-HERE? ,RM-GREAT-HALL>
					<COND
						(<MC-PRSI? ,TH-GAUNTLET>
							<RT-TRIGGER-ENDGAME>
						)
						(T
							<RT-ATTACK-LOT>
						)
					>
				)
				(<MC-HERE? ,RM-FIELD-OF-HONOUR>
					<COND
						(<AND <FSET? ,CH-LOT ,FL-LOCKED>
								<FSET? ,CH-LOT ,FL-BROKEN>
							>
							<TELL
"The mob, outraged by your lack of chivalrous behaviour, kills you.|"
							>
							<RT-END-OF-GAME>
						)
						(<FSET? ,CH-LOT ,FL-LOCKED>
							<TELL
"You drive the point of the sword home. The crowd cheers and acclaim you the
victor. But Merlin's voice echoes in your head, \"To rule England you must be
merciful and chivalrous, Arthur. You have failed.\"|"
							>
							<RT-END-OF-GAME>
						)
						(<FSET? ,CH-LOT ,FL-BROKEN>
							<FSET ,CH-LOT ,FL-LOCKED>
							<FCLEAR ,CH-LOT ,FL-BROKEN>
							<THIS-IS-IT ,CH-LOT>
							<RT-QUEUE ,RT-I-LOT-TRICK <+ ,GL-MOVES 10>>
							<TELL
"Your gambit is successful. You knock aside Lot's sword and push him to the
ground. You are now standing over him with your sword at his throat." CR
							>
							<RT-SCORE-MSG 0 7 7 4>
							<SETG GL-PICTURE-NUM ,K-PIC-CROWD>
							<COND
								(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
									<RT-UPDATE-PICT-WINDOW>
								)
							>
							<RTRUE>
						)
						(T
							<RT-DEQUEUE ,RT-I-FIGHT>
							<RT-I-FIGHT>
						)
					>
				)
			>
		)
		(<VERB? EXAMINE>
			<COND
				(<MC-HERE? ,RM-GREAT-HALL>
					<FSET ,CH-LOT ,FL-SEEN>
					<TELL
"Lot's sharp features are arranged in a permanent scowl. His jet black
beard is finely trimmed, and his jewelry is of the highest quality." CR
					>
				)
				(T
					<FSET ,CH-LOT ,FL-SEEN>
					<COND
						(<AND <FSET? ,CH-LOT ,FL-BROKEN>
								<FSET? ,CH-LOT ,FL-LOCKED>
							>
							<TELL
"Lot stands peacefully by your side, no longer a threat to your inheritance." CR
							>
						)
						(<FSET? ,CH-LOT ,FL-BROKEN>
							<TELL
"Lot is reaching down to pick up the bracelet." CR
							>
						)
						(<FSET? ,CH-LOT ,FL-LOCKED>
							<TELL
"Your sword is at Lot's throat, and his eyes are filled with fear." CR
							>
						)
						(T
							<TELL
"Lot wields his sword with a concentrated ferocity. You won't be able
to withstand his attack for long." CR
							>
						)
					>
				)
			>
		)
		(<VERB? KNEEL>
			<RT-LOT-IGNORE-MSG>
		)
		(<TOUCH-VERB?>
			<COND
				(<MC-HERE? ,RM-GREAT-HALL>
					<RT-ATTACK-LOT>
				)
			>
		)
	>
>

<CONSTANT K-TAKE-BRACELET-MSG ". \"Take his bracelet,\" Lot shouts. They
strip you of your bracelet, toss it to Lot,">
<CONSTANT K-BEAR-OFF-MSG " and bear you off to rot in a dungeon.">

<ROUTINE RT-ATTACK-LOT ()
	<TELL
"As you approach the King, his guards quickly close around you"
	>
	<COND
		(<IN? ,TH-BRACELET ,CH-PLAYER>
			<TELL ,K-TAKE-BRACELET-MSG>
		)
	>
	<TELL ,K-BEAR-OFF-MSG CR>
	<RT-END-OF-GAME>
>

<ROUTINE RT-LOT-IGNORE-MSG ()
	<TELL "Lot ignores you">
	<COND
		(<MC-HERE? ,RM-GREAT-HALL>
			<TELL ", and continues to talk with his courtiers." CR>
		)
		(<AND <MC-HERE? ,RM-FIELD-OF-HONOUR>
				<NOT <FSET? ,CH-LOT ,FL-LOCKED>>
			>
			<TELL ", and ">
			<COND
				(<FSET? ,CH-LOT ,FL-BROKEN>
					<TELL "examines the bracelet." CR>
				)
				(T
					<TELL "continues his attack." CR>
				)
			>
		)
		(T
			<TELL "." CR>
		)
	>
>

;<ROUTINE RT-GN-KING-LOT (TBL FINDER)
	<RETURN ,CH-LOT>
>

<ROUTINE RT-MOVE-TAPESTRY ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<RFALSE>
		)
		(T
			<TELL
"You edge around to the side of the throne, but as soon as you start to pull
aside the tapestry, the King gives a surreptitious hand-signal. His guards
quickly close around you"
			>
			<COND
				(<IN? ,TH-BRACELET ,CH-PLAYER>
					<TELL ,K-TAKE-BRACELET-MSG>
				)
			>
			<TELL ,K-BEAR-OFF-MSG CR>
			<RT-END-OF-GAME>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-LOT-SWORD"
;"---------------------------------------------------------------------------"

<OBJECT TH-LOT-SWORD
	(LOC CH-LOT)
	(DESC "sword")
	(FLAGS FL-NO-DESC FL-TRY-TAKE)
	(SYNONYM SWORD)
	(OWNER CH-LOT)
	(GENERIC RT-GN-SWORD)
	(ACTION RT-TH-LOT-SWORD)
>

<ROUTINE RT-TH-LOT-SWORD ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<AND <VERB? ATTACK>
				<MC-HERE? ,RM-FIELD-OF-HONOUR>
			>
			<COND
				(<AND	<NOT <FSET? ,CH-LOT ,FL-LOCKED>>
						<NOT <FSET? ,CH-LOT ,FL-BROKEN>>
					>
					<RT-DEQUEUE ,RT-I-FIGHT>
					<RT-I-FIGHT>
				)
			>
		)
		(<AND <TOUCH-VERB?>
				<MC-HERE? ,RM-GREAT-HALL>
			>
			<RT-ATTACK-LOT>
		)
	>
>

;"---------------------------------------------------------------------------"
; "CH-COURTIERS"
;"---------------------------------------------------------------------------"

<OBJECT CH-COURTIERS
	(LOC RM-GREAT-HALL)
	(FLAGS FL-ALIVE FL-HAS-SDESC FL-NO-DESC FL-OPEN FL-PERSON FL-SEARCH FL-PLURAL)
	(SYNONYM COURTIER COURTIERS MOB CROWD PEOPLE)
	(ADJECTIVE NERVOUS CHEERING)
	(OWNER CH-LOT)
	(ACTION RT-CH-COURTIERS)
>

<ROUTINE RT-CH-COURTIERS ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<COND
		(<MC-CONTEXT? ,M-OBJDESC>
			<COND
				(.ART
					<PRINT-ARTICLE ,CH-SOLDIERS .ART .CAP?>
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
						(<IN? ,CH-COURTIERS ,RM-GREAT-HALL>
							<TELL "courtiers">
						)
						(T
							<TELL "mob">
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-WINNER>
			<TELL The+verb ,CH-COURTIERS "ignore" " you." CR>
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
			<RFALSE>
		)
		(<AND <SPEAKING-VERB?>
				<IN? ,CH-COURTIERS ,HERE>
			>
			<TELL The+verb ,CH-COURTIERS "ignore" " you." CR>
		)
		(<VERB? EXAMINE>
			<FSET ,CH-COURTIERS ,FL-SEEN>
			<THIS-IS-IT ,CH-COURTIERS>
			<COND
				(<MC-HERE? ,RM-GREAT-HALL>
					<TELL
The+verb ,CH-COURTIERS "chatter" " amongst themselves nervously. Clearly
they are afraid of King Lot." CR
					>
				)
				(<AND <NOT <FSET? ,CH-LOT ,FL-BROKEN>>
						<NOT <FSET? ,CH-LOT ,FL-LOCKED>>
					>
					<TELL
The+verb ,CH-COURTIERS "are" " anxiously awaiting the outcome of the
battle." CR
					>
				)
				(T
					<TELL The+verb ,CH-COURTIERS "are" " cheering wildly." CR>
				)
			>
		)
		(<VERB? ATTACK>
			<COND
				(<MC-HERE? ,RM-GREAT-HALL>
					<TELL
"You leap upon the back of one of" the ,CH-COURTIERS " and yell, \"Die you
mangy dog!\" Unfortunately, the guards quickly overwhelm you and carry you
off to a cold, dark dungeon where you spend the rest of your days counting
the hairs on your arm." CR
					>
					<RT-END-OF-GAME>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "LG-OWL-TAPESTRY"
;"---------------------------------------------------------------------------"

<OBJECT LG-OWL-TAPESTRY
	(LOC LOCAL-GLOBALS)
	(DESC "tapestry")
	(SYNONYM TAPESTRY)
	(ACTION RT-LG-OWL-TAPESTRY)
>

<ROUTINE RT-LG-OWL-TAPESTRY ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<AND <MC-HERE? ,RM-GREAT-HALL>
				<OR
					<TOUCH-VERB?>
					<VERB? LOOK-BEHIND>
				>
			>
			<RT-MOVE-TAPESTRY>
		)
		(<VERB? EXAMINE>
			<FSET ,LG-OWL-TAPESTRY ,FL-SEEN>
			<COND
				(<MC-HERE? ,RM-BEHIND-THRONE>
					<TELL "It's hard to tell from the back, but it looks like">
				)
				(T
					<TELL The ,LG-OWL-TAPESTRY " is">
				)
			>
			<TELL
" a hunting scene of men in armour mercilessly hunting down owls." CR
			>
		)
		(<VERB? MOVE LOOK-BEHIND>
			<TELL
"One of Lot's soldiers sees you behind the tapestry, and "
			>
			<COND
				(<MC-FORM? ,K-FORM-ARTHUR>
					<TELL "they quickly close around you">
					<COND
						(<AND <FSET? ,TH-BRACELET ,FL-WORN>
								<IN? ,TH-BRACELET ,CH-PLAYER>
							>
							<TELL ,K-TAKE-BRACELET-MSG>
						)
					>
					<TELL ,K-BEAR-OFF-MSG CR>
				)
				(T
					<TELL "says," ,K-LOVERLY-MSG form ,K-SKEWER-MSG>
				)
			>
			<RT-END-OF-GAME>
		)
		(<VERB? ENTER>
			<COND
				(<MC-HERE? ,RM-BEHIND-THRONE>
					<RT-DO-WALK ,P?WEST>
				)
				(<MC-HERE? ,RM-GREAT-HALL>
					<RT-DO-WALK ,P?EAST>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-BEHIND-THRONE"
;"---------------------------------------------------------------------------"

<ROOM RM-BEHIND-THRONE
   (LOC ROOMS)
   (DESC "behind the throne")
   (FLAGS FL-INDOORS FL-LIGHTED)
   (SOUTH TO RM-PASSAGE-2)
   (DOWN TO RM-PASSAGE-2)
   (WEST PER RT-EXIT-THRONE)
   (OUT PER RT-EXIT-THRONE)
	(GLOBAL LG-OWL-TAPESTRY LG-WALL)
   (ACTION RT-RM-BEHIND-THRONE)
	(THINGS
		KING (KING LOT COURTIER COURTIERS CONVERSATION THRONE) RT-PS-FAKE-LOT
	)
>

<ROUTINE RT-RM-BEHIND-THRONE ("OPT" (CONTEXT <>))
   <COND
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<AND <VERB? LISTEN>
						<MC-PRSO? <> ,ROOMS ,LG-OWL-TAPESTRY>
					>
					<RT-LISTEN-LOT>
				)
			;	(<AND <VERB? TELL>
						,P-CONT
					>
					<RFALSE>
				)
				(<SPEAKING-VERB?>
					<TELL
"Lot's guards hear you, dive through the tapestry, and seize you. Your
quest has ended.|"
					>
					<RT-END-OF-GAME>
				)
			>
		)
      (<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
		         <TELL "You are" standing " in">
				)
				(T
		         <TELL "The passage widens out and becomes">
				)
			>
			<FSET ,LG-OWL-TAPESTRY ,FL-SEEN>
         <TELL
" a small room. A tapestry covers the west wall and a dark passage leads down
to the south. You hear someone talking on the other side of the tapestry"
			>
			<COND
				(<NOT <MC-CONTEXT? ,M-LOOK>>
					<TELL
", and after a few moments you realize you are in a secret room directly
behind King Lot's throne in the Great Hall"
		         >
				)
			>
			<TELL "." CR>
         <RFALSE>
      )
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-PASSAGE>
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

<ROUTINE RT-LISTEN-LOT ()
	<TELL
"You can hear" the ,CH-LOT " discussing inconsequential matters with his
courtiers." CR
	>
>

<ROUTINE RT-PS-FAKE-LOT ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<COND
        (<NOUN-USED? ,PSEUDO-OBJECT ,W?COURTIER ,W?COURTIERS>
            <FSET ,PSEUDO-OBJECT ,FL-PLURAL>
        )
        (T
            <FCLEAR ,PSEUDO-OBJECT ,FL-PLURAL>
        )
    >
    <FCLEAR ,PSEUDO-OBJECT ,FL-VOWEL>
    <COND
		(<MC-CONTEXT? ,M-OBJDESC>
			<FCLEAR ,PSEUDO-OBJECT ,FL-VOWEL>
			<COND
				(.ART
					<COND
						(<OR	<NOUN-USED? ,PSEUDO-OBJECT ,W?COURTIER ,W?COURTIERS>
								<NOT <EQUAL? .ART ,K-ART-THE ,K-ART-A ,K-ART-ANY>>
							>
							<PRINT-ARTICLE ,PSEUDO-OBJECT .ART .CAP?>
						)
					>
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
						(<NOUN-USED? ,PSEUDO-OBJECT ,W?COURTIER ,W?COURTIERS>
							<TELL "courtiers">
						)
						(T
							<TELL D ,CH-LOT>
						)
					>
				)
			>
		)
		(<VERB? LISTEN>
			<RT-LISTEN-LOT>
		)
		(<SEE-VERB?>
			<TELL
"You can't see" the ,PSEUDO-OBJECT ". " He+verb ,PSEUDO-OBJECT "are" " on the
other side of the tapestry." CR
			>
		)
		(<TOUCH-VERB?>
			<TELL
"As soon as you brush aside the tapestry, Lot's guards seize you. Your
quest is ended.|"
			>
			<RT-END-OF-GAME>
		)
	>
>

<ROUTINE RT-EXIT-THRONE ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<RETURN ,RM-GREAT-HALL>
		)
		(T
			<TELL "As soon as you">
			<COND
				(<IN? ,CH-PRISONER ,HERE>
					<TELL " and the prisoner">
				)
			>
			<TELL " emerge from behind the tapestry,">
			<COND
				(<MC-FORM? ,K-FORM-ARTHUR>
					<TELL " you are seized by Lot's guards.">
					<COND
						(<AND <FSET? ,TH-BRACELET ,FL-WORN>
								<IN? ,TH-BRACELET ,CH-PLAYER>
							>
							<TELL ,K-TAKE-BRACELET-MSG>
						)
					>
					<CRLF>
				)
				(T
					<COND
						(<IN? ,CH-PRISONER ,HERE>
							<TELL
" the guards " ,K-REMOVE-PRISONER-MSG " In the process, one of them notices">
						)
						(T
							<TELL " one of the guards sees">
						)
					>
					<TELL " you and says" ,K-LOVERLY-MSG form ,K-SKEWER-MSG>
				)
			>
			<RT-END-OF-GAME>
		)
	>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"


