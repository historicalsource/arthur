;"***************************************************************************"
; "game : Arthur"
; "file : ENDGAME.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   15 May 1989 18:00:42  $"
; "revs : $Revision:   1.77  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "End Game Puzzle"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "RM-FIELD-OF-HONOUR"
;"---------------------------------------------------------------------------"

<ROOM RM-FIELD-OF-HONOUR
	(LOC ROOMS)
	(DESC "field of honour")
	(FLAGS FL-LIGHTED)
	(SYNONYM FIELD)
	(ADJECTIVE HONOUR HONOR)
	(EAST TO RM-END-OF-CAUSEWAY)
	(NW TO RM-MEADOW)
	(SOUTH PER RT-ENTER-SHALLOWS)
	(UP PER RT-FLY-UP)
	(GLOBAL
		LG-LAKE LG-PATH RM-ISLAND RM-END-OF-CAUSEWAY RM-MEADOW RM-SHALLOWS
		RM-CAUSEWAY
	)
	(ACTION RT-RM-FIELD-OF-HONOUR)
>

<ROUTINE RT-RM-FIELD-OF-HONOUR ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "You are" standing " in">
				)
				(T
					<COND
						(<EQUAL? ,OHERE ,RM-SHALLOWS>
							<TELL "You climb up out of the water and are now in">
						)
						(<EQUAL? ,OHERE ,RM-ABOVE-FIELD>
							<TELL "You float down into">
						)
						(T
							<TELL "You enter">
						)
					>
				)
			>
			<FSET ,RM-ISLAND ,FL-SEEN>
			<TELL
" the Field of Honour. To the south is a lake with an island in the middle
of it. To the east is a causeway leading to the island. The meadow lies
to the northwest.|"
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<IN? ,CH-LOT ,RM-FIELD-OF-HONOUR>
					<COND
						(<VERB? WALK>
							<COND
								(<OR	<NOT <FSET? ,CH-LOT ,FL-LOCKED>>
										<NOT <FSET? ,CH-LOT ,FL-BROKEN>>
										<FSET? ,RM-MID-LAKE ,FL-WATER>
										<NOT <EQUAL? ,P-WALK-DIR ,P?SOUTH>>
									>
									<TELL
"The mob blocks your path. Out of the corner of your eye, you catch
occasional glimpses of the invisible knight picking pockets at the edge of
the crowd." CR
									>
								)
							>
						)
						(<AND <NOT <FSET? ,CH-LOT ,FL-BROKEN>>
								<NOT <FSET? ,CH-LOT ,FL-LOCKED>>
							>
							<COND
								(<VERB? YELL>
									<TELL
"You cry out, but fail to break Lot's concentration. He re-doubles his
efforts and drives you back." CR
									>
								)
								(<VERB? DROP THROW>
									<COND
										(<MC-PRSO? ,TH-BRACELET>
											<RT-DISTRACT-LOT>
										)
									>
								)
							>
						)
						(<AND <FSET? ,CH-LOT ,FL-LOCKED>
								<NOT <FSET? ,CH-LOT ,FL-BROKEN>>
								<OR
									<AND
										<VERB? UNWEAR DROP>
										<MC-PRSO? ,TH-SWORD>
									>
									<AND
										<VERB? SPARE RELEASE>
										<MC-PRSO? ,CH-LOT>
									>
								>
							>
							<FSET ,CH-LOT ,FL-BROKEN>
							<RT-DEQUEUE ,RT-I-LOT-TRICK>
							<TELL
"You remove your sword. King Lot kneels at your feet and thanks you, swearing
eternal loyalty." CR
							>
							<RT-SCORE-MSG 10 0 0 0>
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-END>
			<COND
				(<NOT <IN? ,CH-LOT ,RM-FIELD-OF-HONOUR>>
					<RFALSE>
				)
				(<AND <VERB? TRANSFORM>
						<NOT <MC-FORM? ,GL-OLD-FORM>>
					>
					<COND
						(<AND <FSET? ,CH-LOT ,FL-LOCKED>
								<FSET? ,CH-LOT ,FL-BROKEN>
							>
							<TELL
"|The mob recoils in horror for a moment, and then they close in and kill
you.|"
							>
						)
						(<FSET? ,CH-LOT ,FL-LOCKED>
							<TELL
"|Lot picks up his sword and runs you through.|"
							>
						)
						(T
							<TELL
"|Lot never hesitates for a second. He runs you through with his sword.|"
							>
						)
					>
					<RT-END-OF-GAME>
				)
				(<AND <NOT <FSET? ,CH-LOT ,FL-BROKEN>>
						<OR
							<AND
								<VERB? DROP>
								<MC-PRSO? ,TH-SHIELD ,TH-SWORD>
							>
							<AND
								<VERB? UNWEAR>
								<MC-PRSO? ,TH-ARMOUR>
							>
						>
					>
					<TELL
"|Lot immediately presses home his advantage and kills you.|"
					>
					<RT-END-OF-GAME>
				)
			>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-FIELD>
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

<ROUTINE RT-ENTER-SHALLOWS ("OPT" (QUIET <>))
	<COND
		(<MC-FORM? ,K-FORM-BADGER ,K-FORM-OWL ,K-FORM-SALAMANDER>
			<COND
				(<NOT .QUIET>
					<TELL ,K-WOULD-DROWN-MSG>
				)
			>
			<RFALSE>
		)
		(<NOT <FSET? ,RM-MID-LAKE ,FL-WATER>>
			<RETURN ,RM-MID-LAKE>
		)
		(T
			<RETURN ,RM-SHALLOWS>
		)
	>
>

<ROUTINE RT-TRIGGER-ENDGAME ()
	<MOVE ,CH-LOT ,RM-FIELD-OF-HONOUR>
	<MOVE ,CH-COURTIERS ,RM-FIELD-OF-HONOUR>	; "Mob"
	<FSET ,CH-COURTIERS ,FL-COLLECTIVE>
	<RT-DEQUEUE ,RT-I-SOLDIER-ASK>
	<RT-QUEUE ,RT-I-FIGHT <+ ,GL-MOVES 1>>
	<TELL
"As you approach the throne, Lot's soldiers close around you. Suddenly,
however, they see the gauntlet and draw back, allowing you to step forward
to deliver your challenge.||Anger flashes in the evil king's
eyes. \"Enough!\" he cries. \"This stripling has impugned the honour of the
king. He must answer for it on the Field of Honour.\"||He stands up and
stalks out of the Great Hall. His guards seize you and strip you of
everything you were carrying"
	>
	<COND
		(<IN? ,TH-SWORD ,CH-PLAYER>
			<TELL " except your sword,">
		)
		(T
			<TELL ". They thrust a sword into your hand">
		)
	>
	<RT-MOVE-ALL-BUT-WORN ,CH-PLAYER>
	<RT-DO-TAKE ,TH-SWORD T>
	<TELL
" and then they force-march you along behind Lot. The entourage sweeps out of
the Castle, into the town, and south to the Field of Honour. Townspeople
follow the procession, and by the time the guards turn you loose, you face
King Lot man to man, surrounded by a cheering mob.|"
	>
	<RT-SCORE-MSG 10 0 0 5>
;	<CRLF>
;	<RT-GOTO ,RM-FIELD-OF-HONOUR T>
	<SETG OHERE ,HERE>
	<MOVE ,CH-PLAYER ,RM-FIELD-OF-HONOUR>
	<SETG HERE ,RM-FIELD-OF-HONOUR>
	<SETG GL-PICTURE-NUM ,K-PIC-LOT-FIGHT>
	<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
	<COND
		(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
			<RT-UPDATE-DESC-WINDOW>
		)
		(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
			<RT-UPDATE-PICT-WINDOW>
		)
		(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>
			<RT-UPDATE-MAP-WINDOW>
		)
	>
	<RTRUE>
>

<GLOBAL GL-FIGHT-CNT 0 <> BYTE>

<ROUTINE RT-I-FIGHT ()
	<RT-QUEUE ,RT-I-FIGHT <+ ,GL-MOVES 1>>
	<INC GL-FIGHT-CNT>
	<COND
		(,GL-CLK-RUN
			<CRLF>
		)
	>
	<COND
		(<L? ,GL-FIGHT-CNT 4>
			<TELL
"The two of you trade blows. Lot attacks with intense concentration."
			>
			<COND
				(<EQUAL? ,GL-FIGHT-CNT 1>
					<TELL
" He appears to be a slightly better swordsman than you."
					>
				)
			>
			<CRLF>
		)
		(T
			<TELL
"Lot finds a fatal weakness in your defense and runs you through with his
sword. You fall to the ground, and as your life's blood slowly drains away,
the crowd cheers Lot's victory. He stands over your prostrate body and
proclaims, \"Let this be a warning to all who would challenge the honour of
the High King.\"|"
			>
			<RT-END-OF-GAME>
		)
	>
>

<ROUTINE RT-I-LOT-WIN ()
	<COND
		(<NOT <FSET? ,CH-LOT ,FL-LOCKED>>
			<TELL
"|Lot picks up" the ,TH-BRACELET ", thanks you, and then runs you through.|"
			>
			<RT-END-OF-GAME>
		)
	>
>

<ROUTINE RT-DISTRACT-LOT ()
	<RT-DEQUEUE ,RT-I-FIGHT>
	<RT-QUEUE ,RT-I-LOT-WIN <+ ,GL-MOVES 1>>
	<FSET ,CH-LOT ,FL-BROKEN>
	<MOVE ,TH-BRACELET ,HERE>
	<FCLEAR ,TH-BRACELET ,FL-WORN>
	<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT ,K-UPD-OBJS>>
	<TELL
"As you handle" the ,TH-BRACELET ", you pretend to let it slip through your
fingers and drop it on" the ,TH-GROUND ". Lot's concentration is broken.
His eyes widen at the sight of the gold and he stoops to pick it up." CR
	>
>

<ROUTINE RT-I-LOT-TRICK ()
	<TELL
CR "Your attention is distracted by something at the edge of the crowd. Lot
seizes the moment to leap up, knock your sword aside and run you through." CR
	>
	<RT-END-OF-GAME>
>

;"---------------------------------------------------------------------------"
; "RT-I-OUT-OF-TIME"
;"---------------------------------------------------------------------------"

<CONSTANT K-MOMENTS-LATER-MSG " Moments later you hear the distant">
<CONSTANT K-REALIZE-MSG " sound of crowds cheering, and you realize that
Lot's coronation has taken place.">
<CONSTANT K-PARADE-MSG "Suddenly, a parade led by King Lot ">

<ROUTINE RT-I-OUT-OF-TIME ()
	<CRLF>
	<COND
		(<MC-HERE? ,RM-GREAT-HALL>
			<TELL
"Lot rises from his throne and declares, \"It is time.\" He strides from the
hall, followed by his courtiers." ,K-MOMENTS-LATER-MSG ,K-REALIZE-MSG
			>
		)
		(<MC-HERE? ,RM-PARADE-AREA ,RM-CASTLE-GATE ,RM-TOWN-SQUARE>
			<TELL
,K-PARADE-MSG "emerges from the castle and makes its way to the churchyard."
,K-MOMENTS-LATER-MSG ,K-REALIZE-MSG
			>
		)
		(<MC-HERE? ,RM-CHURCHYARD>
			<TELL
,K-PARADE-MSG "enters the churchyard, and you become the unwilling witness to
his coronation on the church steps. After the cheering crowds leave, you are
once again alone."
			>
		)
		(<AND	<MC-HERE? ,RM-FIELD-OF-HONOUR ,RM-SHALLOWS ,RM-MID-LAKE>
				<NOT <IN? ,CH-LOT ,TH-LOT-THRONE>>
			>
			<TELL
"Suddenly, a great cheer goes up from the crowd. \"The time of coronation has
come! King Lot shall be our High King.\" They hoist Lot on their shoulders
and carry him away to be coronated."
			>
		)
		(T
			<TELL "In the distance, you hear the" ,K-REALIZE-MSG>
		)
	>
	<CRLF>
	<RT-END-OF-GAME>
>

;"---------------------------------------------------------------------------"
; "TH-STONE"
;"---------------------------------------------------------------------------"

<OBJECT TH-STONE
	(LOC RM-CHURCHYARD)
	(DESC "stone")
	(FLAGS FL-CONTAINER FL-NO-DESC FL-OPEN FL-SEARCH FL-TRY-TAKE)
	(SYNONYM STONE ROCK)
	(GENERIC RT-GN-STONE)
	(ACTION RT-TH-STONE)
>

<ROUTINE RT-TH-STONE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<RFALSE>
		)
		(<VERB? TAKE MOVE RAISE>
			<TELL The ,TH-STONE " is too heavy to move." CR>
		)
		(<VERB? EXAMINE LOOK-ON>
			<FSET ,TH-STONE ,FL-SEEN>
			<THIS-IS-IT ,TH-STONE>
			<THIS-IS-IT ,TH-SWORD>
			<TELL
"It is a large stone that has a jewelled sword protruding from it." CR
			>
		)
		(<VERB? BREAK>
			<TELL The ,WINNER " can't break" the ,TH-STONE "." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-EXCALIBUR"
;"---------------------------------------------------------------------------"

<OBJECT TH-EXCALIBUR
	(LOC TH-STONE)
	(DESC "sword")
	(FLAGS FL-KNIFE FL-NO-DESC FL-SURFACE FL-SEARCH FL-TRY-TAKE)
	(SYNONYM SWORD EXCALIBUR HILT SHAFT RUNES)
	(ADJECTIVE JEWELLED)
	(GENERIC RT-GN-SWORD)
	(ACTION RT-TH-EXCALIBUR)
>

<CONSTANT K-WHOSO-PULLETH-MSG
"WHOSO PULLETH OUT THIS SWORD OF THIS STONE, IS RIGHTWISE KING BORN OF ALL
ENGLAND">

<ROUTINE RT-TH-EXCALIBUR ("OPT" (CONTEXT <>) "AUX" N)
	<COND
		(<VERB? EXAMINE LOOK-ON READ>
			<FSET ,TH-EXCALIBUR ,FL-SEEN>
			<THIS-IS-IT ,TH-EXCALIBUR>
			<TELL
"The magnificent, jewelled sword has runes on the shaft that read, \""
,K-WHOSO-PULLETH-MSG ".\"" CR
			>
		)
		(<VERB? TAKE MOVE RAISE>
			<COND
				(<NOT <EQUAL? ,WINNER ,CH-PLAYER>>
					<RT-YOU-CANT-MSG>
				)
				(<OR	<NOT <FSET? ,CH-LOT ,FL-LOCKED>>
						<NOT <FSET? ,CH-LOT ,FL-BROKEN>>
					>
					<COND
						(<IN? ,TH-STONE ,RM-CHURCHYARD>
							<TELL
,K-MERLIN-ECHOES-MSG "\"The time is not yet, Arthur...\"" CR
							>
						)
					>
				)
				(T
					<TELL
"You grasp the hilt and pull. At first nothing happens, but then"
					>
					<COND
						(<OR	<L? ,GL-SC-CHV 100>
								<L? ,GL-SC-WIS 100>
							>
							<TELL
" Merlin appears before you and says, \"He who would rule all England must be
both wise and chivalrous, Arthur, yet you have shown yourself lacking in "
							>
							<COND
								(<AND <L? ,GL-SC-CHV 100>
										<L? ,GL-SC-WIS 100>
									>
									<TELL "both">
								)
								(T
									<TELL "one">
								)
							>
							<TELL
" of these qualities. Think back over the past few days."
							>
							<COND
								(<L? ,GL-SC-CHV 100>
									<TELL
" Were there times when you were discourteous or unhelpful?"
									>
								)
							>
							<COND
								(<L? ,GL-SC-WIS 100>
									<TELL
" Were there times when you did foolish things?"
									>
								)
							>
							<TELL " Think! I will help you if I can, Arthur.\"|">
							<RT-END-OF-GAME <> T>
						)
						(T
							<MOVE ,TH-EXCALIBUR ,CH-PLAYER>
							<TELL "...|">
							<INPUT 1 50 ,RT-STOP-READ>
							<CLEAR -1>
							<SCREEN 7>
							<CLEAR 7>
							<RT-CENTER-PIC ,K-PIC-ENDGAME>
							<CURSET -1>	;"Make cursor go away."
							<INPUT 1 150 ,RT-STOP-READ>
							<CURSET -2>	;"Make cursor come back."
							<SCREEN 0>
							<CLEAR -1>
							<TELL
"The sword slides out easily. You wave it over your head and the crowd
cheers, \"Long Live King Arthur. The Once and Future King.\"" CR CR

"Thank you for Beta testing this game." CR CR
							>
							<DIROUT ,K-D-TBL-ON ,K-DIROUT-TBL>
							<TELL "THE END">
							<DIROUT ,K-D-TBL-OFF>
							<CURSET
								<WINGET 0 ,K-W-YCURPOS>
								<+ </ <- <WINGET 0 ,K-W-XSIZE> <LOWCORE TWID>> 2> 1>
							>
							<HLIGHT ,H-BOLD>
							<PRINTT <ZREST ,K-DIROUT-TBL 2> <ZGET ,K-DIROUT-TBL 0>>
							<HLIGHT ,H-NORMAL>
							<CRLF>
							<CRLF>
							<RT-END-OF-GAME T>
						)
					>
				)
			>
		)
		(<VERB? BREAK>
			<TELL The ,WINNER " can't break" the ,TH-EXCALIBUR "." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-EXCALIBUR-JEWELS"
;"---------------------------------------------------------------------------"

<OBJECT TH-EXCALIBUR-JEWELS
	(LOC TH-EXCALIBUR)
	(DESC "jewels")
	(FLAGS FL-NO-DESC FL-PLURAL)
	(SYNONYM JEWEL JEWELS)
	(ACTION RT-TH-EXCALIBUR-JEWELS)
>

<ROUTINE RT-TH-EXCALIBUR-JEWELS ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<TELL "They look like rare and precious gemstones." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-ABOVE-FIELD"
;"---------------------------------------------------------------------------"

<ROOM RM-ABOVE-FIELD
	(LOC ROOMS)
	(DESC "above the field")
	(FLAGS FL-AIR FL-LIGHTED)
	(DOWN PER RT-FLY-DOWN)
	(SOUTH TO RM-ABOVE-LAKE)
	(NORTH TO RM-ABOVE-MEADOW)
	(NE TO RM-ABOVE-TOWN)
	(UP SORRY K-NO-HIGHER-MSG)
	(GLOBAL LG-LAKE LG-TOWN RM-FIELD-OF-HONOUR RM-MEADOW RM-ISLAND)
	(ACTION RT-RM-ABOVE-FIELD)
>

<ROUTINE RT-RM-ABOVE-FIELD ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,RM-FIELD-OF-HONOUR ,FL-SEEN>
			<FSET ,LG-LAKE ,FL-SEEN>
			<FSET ,LG-TOWN ,FL-SEEN>
			<FSET ,RM-MEADOW ,FL-SEEN>
			<TELL
"You are hovering over the Field of Honour. Below you to the south is the
lake. The town lies to the northeast, and the meadow is just north of you.|"
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-AIR-SCENE>
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

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

