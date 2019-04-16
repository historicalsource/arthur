;"***************************************************************************"
; "game : Arthur"
; "file : BOG.ZIL"
; "auth :   $Author:   RAB  $"
; "date :     $Date:   15 May 1989 17:29:10  $"
; "revs : $Revision:   1.119  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Peat Bog/Cottage"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "RM-MOOR"
;"---------------------------------------------------------------------------"

<ROOM RM-MOOR
	(LOC ROOMS)
	(DESC "moor")
	(SYNONYM MOOR)
	(FLAGS FL-LIGHTED)
	(NORTH TO RM-COTTAGE IF LG-COTTAGE-DOOR IS OPEN)
	(NE TO RM-EDGE-OF-BOG)
	(SW TO RM-FORK-IN-ROAD)
	(IN TO RM-COTTAGE IF LG-COTTAGE-DOOR IS OPEN)
	(UP PER RT-FLY-UP)
	(GLOBAL LG-THATCH LG-COTTAGE-DOOR ;LG-COTTAGE-WINDOW LG-PATH RM-COTTAGE RM-BOG)
	(ACTION RT-RM-MOOR)
>

<ROUTINE RT-RM-MOOR ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL
"You are" standing " in the middle of a desolate moor, just outside a lonely"
					>
				)
				(T
					<COND
						(<EQUAL? ,OHERE ,RM-COTTAGE>
							<TELL "You leave the">
						)
						(<EQUAL? ,OHERE ,RM-EDGE-OF-BOG>
							<TELL "You" walk " back toward the">
						)
						(<EQUAL? ,OHERE ,RM-FORK-IN-ROAD>
							<TELL
"The road leads you across a desolate moor. After a while, you come to a
lonely"
							>
						)
						(T
							<TELL
"You land in the middle of the desolate moor, just outside a lonely"
							>
						)
					>
				)
			>
			<FSET ,RM-COTTAGE ,FL-SEEN>
			<TELL " cottage">
			<COND
				(<EQUAL? ,OHERE ,RM-COTTAGE>
					<TELL ".">
				)
				(T
					<TELL ", which lies to the north.">
				)
			>
			<FSET ,RM-BOG ,FL-SEEN>
			<TELL
" The road disappears off into the moor to the southwest, and to the
northeast lies a large peat bog."
			>
			<COND
				(<MC-CONTEXT? ,M-F-LOOK>
					<FSET ,TH-SLEAN ,FL-SEEN>
					<FSET ,TH-CRUTCH ,FL-SEEN>
					<TELL
" A slean leans against the side of the house, and a crude crutch is lying
on the ground nearby." CR
					>
					<RTRUE>
				)
				(T
					<CRLF>
					<RFALSE>
				)
			>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-MOOR>
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
; "TH-SLEAN"
;"---------------------------------------------------------------------------"

<OBJECT TH-SLEAN
	(LOC RM-MOOR)
	(DESC "slean")
	(FLAGS FL-BURNABLE FL-KNIFE FL-TAKEABLE FL-TOOL)
	(SYNONYM SLEAN HANDLE)
	(SIZE 5)
	(ACTION RT-TH-SLEAN)
>

<ROUTINE RT-TH-SLEAN ("AUX" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<COND
				(<VERB? CUT DIG>
					<COND
						(<FSET? ,TH-SLEAN ,FL-BROKEN>
							<TELL The ,TH-SLEAN " is broken." CR>
						)
						(<AND	<MC-PRSO? ,TH-GROUND ,LG-PEAT <> ,ROOMS>
								<MC-HERE? ,RM-EDGE-OF-BOG>
							>
							<FSET ,TH-SLEAN ,FL-BROKEN>
							<COND
								(<RT-DO-TAKE ,TH-PEAT-BRICK>
									<THIS-IS-IT ,TH-PEAT-BRICK>
									<TELL
"You cut a brick of peat from the ground. As you pry it loose, the handle of"
the ,TH-SLEAN " snaps, rendering it useless. You now have the peat.|"
									>
									<RT-SCORE-OBJ ,TH-PEAT-BRICK>
								)
							>
							<RTRUE>
						)
						(<VERB? DIG>
							<COND
								(<MC-PRSO? <> ,ROOMS>
									<SETG PRSO ,TH-GROUND>
								)
							>
							<TELL
The+verb ,WINNER "try" " to dig up" the ,PRSO " with" the ,TH-SLEAN ", but"
verb ,WINNER "make" " little progress." CR
							>
						)
					>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-SLEAN ,FL-SEEN>
			<TELL
The ,TH-SLEAN " looks like a cross between a hoe and a spade"
			>
			<COND
				(<FSET? ,TH-SLEAN ,FL-BROKEN>
					<TELL ", but it is broken">
				)
			>
			<TELL "." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "LG-PEAT"
;"---------------------------------------------------------------------------"

<OBJECT LG-PEAT
	(LOC LOCAL-GLOBALS)
	(DESC "peat")
	(SYNONYM PEAT)
>

;"---------------------------------------------------------------------------"
; "TH-PEAT-BRICK"
;"---------------------------------------------------------------------------"

<OBJECT TH-PEAT-BRICK
	(DESC "brick of peat")
	(FLAGS ;FL-BURNABLE FL-TAKEABLE)
	(SYNONYM BRICK PEAT)
	(ADJECTIVE PEAT BRICK)
	(OWNER TH-PEAT-BRICK)
	(SCORE <LSH 1 ,K-QUEST-SHIFT>)
	(SIZE 5)
	(ACTION RT-TH-PEAT-BRICK)
>

<ROUTINE RT-TH-PEAT-BRICK ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-PEAT-BRICK ,FL-SEEN>
			<THIS-IS-IT ,TH-PEAT-BRICK>
			<TELL "The brick is dry and crumbly." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-COTTAGE"
;"---------------------------------------------------------------------------"

<ROOM RM-COTTAGE
	(LOC ROOMS)
	(DESC "cottage")
	(FLAGS FL-INDOORS FL-LIGHTED)
	(SYNONYM COTTAGE STONE HUT HOUSE)
	(ADJECTIVE STONE)
	(SOUTH TO RM-MOOR IF LG-COTTAGE-DOOR IS OPEN)
	(OUT TO RM-MOOR IF LG-COTTAGE-DOOR IS OPEN)
	(GLOBAL LG-COTTAGE-DOOR ;LG-COTTAGE-WINDOW LG-THATCH LG-WALL RM-MOOR)
	(GENERIC RT-GN-STONE)
	(ACTION RT-RM-COTTAGE)
	(THINGS
		<> SMOKE RT-PS-SMOKE
		<> (WINDOW WINDOWS) RT-PS-WINDOW
	)
>

<ROUTINE RT-RM-COTTAGE ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<TELL "You ">
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "are" standing " in a ">
				)
				(T
					<COND
						(<NOT <FSET? ,TH-COTTAGE-FIRE ,FL-LIGHTED>>
							<TELL "shiver as you ">
						)
					>
					<TELL "enter the ">
				)
			>
			<FSET ,TH-PALLET ,FL-SEEN>
			<THIS-IS-IT ,TH-PALLET>
			<COND
				(<NOT <FSET? ,TH-COTTAGE-FIRE ,FL-LIGHTED>>
					<TELL "cold">
				)
				(T
					<TELL "warm and cozy">
				)
			>
			<TELL
" one-room cottage. On a simple pallet in the corner "
			>
			<COND
				(<FSET? ,CH-PEASANT ,FL-ASLEEP>
					<TELL "lies an unconscious">
				)
				(T
					<TELL "sits a">
				)
			>
			<FSET ,CH-PEASANT ,FL-SEEN>
			<THIS-IS-IT ,CH-PEASANT>
			<TELL " peasant. His leg has a crude splint on it">
			<COND
				(<IN? ,TH-CRUTCH ,RM-COTTAGE>
					<TELL ", and there is a crutch next to the pallet">
				)
			>
			<TELL ". ">
			<COND
				(<FSET? ,TH-COTTAGE-FIRE ,FL-LIGHTED>
					<TELL "A">
				)
				(T
					<TELL "The remains of a">
				)
			>
			<FSET ,TH-COTTAGE-FIRE ,FL-SEEN>
			<THIS-IS-IT ,TH-COTTAGE-FIRE>
			<TELL " small fire ">
			<COND
				(<FSET? ,TH-COTTAGE-FIRE ,FL-LIGHTED>
					<TELL "burns">
				)
				(T
					<TELL "smoulder">
				)
			>
			<TELL " on the stone hearth in the middle of the room.">
			<COND
				(<NOT <FSET? ,TH-COTTAGE-FIRE ,FL-LIGHTED>>
					<TELL " A thin wisp of smoke rises from the ashes.">
				)
			>
			<CRLF>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<COND
				(<FSET? ,CH-PEASANT ,FL-ASLEEP>
					<SETG GL-PICTURE-NUM ,K-PIC-COTTAGE>
				)
				(T
					<SETG GL-PICTURE-NUM ,K-PIC-COTTAGE-AWAKE>
				)
			>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		;(<MC-CONTEXT? ,M-EXIT>
			<COND
				(<AND <MC-FORM? ,K-FORM-ARTHUR>
						<NOT <FSET? ,CH-PEASANT ,FL-ASLEEP>>
						<NOT <FSET? ,CH-PEASANT ,FL-LOCKED>>
					>
					<TELL
The ,CH-PEASANT " calls out, \"If it's the bog you're heading for sir, I beg
you - don't go in there without getting directions. You'll drown for
sure.\"||"
					>
					<RFALSE>
				)
			>
		)
		(<MC-CONTEXT? ,M-END>
			<COND
				(<AND <VERB? TRANSFORM>
						<NOT <FSET? ,CH-PEASANT ,FL-ASLEEP>>
					>
					<COND
						(<NOT <MC-FORM? ,GL-OLD-FORM>>
							<TELL CR The ,CH-PEASANT " recoils in horror">
							<COND
								(<IN? ,TH-CRUTCH ,RM-COTTAGE>
									<TELL ", hits you with" the ,TH-CRUTCH>
								)
							>
							<TELL " and kills you." ,K-HEEDED-WARNING-MSG>
							<RT-END-OF-GAME>
						)
						(,GL-FORM-ABORT
							<TELL
"|Fortunately, it all happened so quickly that" the ,CH-PEASANT " didn't
notice." CR
							>
						)
					>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,RM-COTTAGE ,FL-SEEN>
			<COND
				(<NOT <MC-HERE? ,RM-COTTAGE>>
					<TELL "It is a simple stone cottage, covered by aging thatch." CR>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "LG-COTTAGE-DOOR"
;"---------------------------------------------------------------------------"

<OBJECT LG-COTTAGE-DOOR
	(LOC LOCAL-GLOBALS)
	(DESC "door")
	(FLAGS FL-AUTO-ENTER FL-DOOR FL-OPENABLE)
	(SYNONYM DOOR)
	(ADJECTIVE COTTAGE)
	(ACTION RT-LG-COTTAGE-DOOR)
>

<ROUTINE RT-LG-COTTAGE-DOOR ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? KNOCK>
			<COND
				(<AND <MC-HERE? ,RM-MOOR>
						<NOT <FSET? ,CH-PEASANT ,FL-ASLEEP>>
					>
					<TELL "\"Come in.\"" CR>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "LG-COTTAGE-WINDOW"
;"---------------------------------------------------------------------------"

;<OBJECT LG-COTTAGE-WINDOW
	(LOC LOCAL-GLOBALS)
	(DESC "window")
	(SYNONYM WINDOW)
	(ADJECTIVE COTTAGE)
	(ACTION RT-LG-COTTAGE-WINDOW)
>

;<ROUTINE RT-LG-COTTAGE-WINDOW ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? LOOK-THRU>
			<TELL The ,WINNER " can't see much from here." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "CH-PEASANT"
;"---------------------------------------------------------------------------"

<OBJECT CH-PEASANT
	(LOC TH-PALLET)
	(DESC "peasant")
	(FLAGS FL-ALIVE FL-ASLEEP FL-NO-LIST FL-OPEN FL-PERSON FL-SEARCH)
	(SYNONYM PEASANT COTTAGER STILICHO MAN LEG LEGS ARM ARMS HAND HANDS PERSON)
	(ADJECTIVE BROKEN LEFT RIGHT)
	(OWNER CH-PEASANT)
	(ACTION RT-CH-PEASANT)
>

; "CH-PEASANT flags:"
; "	FL-LOCKED - Peasant has given directions through bog."

<CONSTANT K-PEASANT-GROAN-MSG "The peasant groans in pain and you quickly withdraw.|">

<ROUTINE RT-CH-PEASANT ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<COND
		(<AND <VERB? HELLO GOODBYE THANK>
				<MC-CONTEXT? ,M-WINNER <>>
			>
			<COND
				(<FSET? ,CH-PEASANT ,FL-ASLEEP>
					<RFALSE>
				)
				(<VERB? HELLO>
					<TELL "\"Good ">
					<COND
						(<RT-TIME-OF-DAY? ,K-EARLY-MORNING ,K-MORNING>
							<TELL "morning">
						)
						(<RT-TIME-OF-DAY? ,K-AFTERNOON>
							<TELL "afternoon">
						)
						(<RT-TIME-OF-DAY? ,K-EVENING ,K-NIGHT>
							<TELL "evening">
						)
					>
					<TELL ".\"" CR>
				)
				(<VERB? GOODBYE>
					<TELL "\"Farewell. And thank you.\"" CR>
				)
				(<VERB? THANK>
					<TELL "\"It's you deserves the thanks, sir.\"|">
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
				(<FSET? ,CH-PEASANT ,FL-ASLEEP>
					<RT-NO-RESPONSE-MSG ,CH-PEASANT>
				)
				(<AND <VERB? TELL-ABOUT>
						<MC-PRSO? ,CH-PLAYER>
					>
					<RFALSE>
				)
				(<VERB? WHO WHAT>
					<RFALSE>
				)
				(<OR	<AND
							<VERB? GIVE>
							<MC-PRSO? ,TH-DIRECTIONS>
							<MC-PRSI? ,CH-PLAYER>
						>
						<AND
							<VERB? GIVE-SWP>
							<MC-PRSO? ,CH-PLAYER>
							<MC-PRSI? ,TH-DIRECTIONS>
						>
					>
					<RT-BOG-DIRECTIONS>
				)
				(T
					<TELL
"\"I shouldn't try to do too much. My leg won't mend for some time.\"" CR
					>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<COND
				(<AND <VERB? GIVE>
						<NOT <FSET? ,CH-PEASANT ,FL-ASLEEP>>
					>
					<COND
						(<MC-PRSO? ,TH-CRUTCH>
							<RT-GIVE-CRUTCH>
						)
						(T
							<TELL
"\"No thank you, sir. You've done enough for me already.\"" CR
							>
						)
					>
				)
				(<AND <VERB? SHOW>
						<MC-PRSO? ,TH-CRUTCH>
						<NOT <FSET? ,CH-PEASANT ,FL-ASLEEP>>
					>
					<TELL "\"Oh! You found my crutch. God bless you, sir!\"" CR>
				)
				(<AND <TOUCH-VERB?>
						<FSET? ,CH-PEASANT ,FL-ASLEEP>
					>
		 			<TELL ,K-PEASANT-GROAN-MSG>
				)
			>
		)
		(<AND <VERB? TELL>
				,P-CONT
			>
		; "Message and RFATAL if don't want peasant to become winner"
			<RFALSE>
		)
		(<AND <VERB? ASK-FOR>
				<NOT <FSET? ,CH-PEASANT ,FL-ASLEEP>>
			>
			<COND
				(<MC-PRSI? ,RM-BOG ,TH-DIRECTIONS>
					<RT-BOG-DIRECTIONS>
				)
			>
		)
		(<AND <VERB? ASK-ABOUT>
				<NOT <FSET? ,CH-PEASANT ,FL-ASLEEP>>
			>
			<COND
				(<MC-PRSI? ,RM-BOG ,TH-DIRECTIONS>
					<RT-BOG-DIRECTIONS>
				)
				(<MC-PRSI? ,TH-CRUTCH>
					<TELL
"\"I left it outside when I carried in the last peat that I had cut. But when
the fire went out, I didn't have the strength to crawl back outside, and
all I could do was hope that somebody would come by and help me.\"" CR
					>
				)
				(<MC-PRSI? ,TH-COTTAGE-FIRE>
					<TELL "\"Oh, It'll burn fine now. Thank ye, sir.\"" CR>
				)
				(<MC-PRSI? ,CH-PEASANT ,TH-SPLINT>
					<TELL "\"Oh, I'll be fine now. I just need to rest.\"" CR>
				)
				(<MC-PRSI? ,CH-MERLIN>
					<TELL
"The peasant's eyes widen. \"They say he is twice as tall as a normal man,
and older than the earth itself.\"" CR
					>
				)
				(<MC-PRSI? ,CH-LOT>
					<TELL
"\"He might as well drop this foolishness about being the High King. The
common folk won't stand for it, and if Merlin finds out, he'll change him
into a newt.\"" CR
					>
				)
				(<MC-PRSI? ,TH-SLEAN>
					<TELL "\"Once they break, they're of no use to anyone.\"" CR>
				)
				(<MC-PRSI? ,TH-PEAT-BRICK>
					<TELL
"\"It's a hard living, digging peat is. But it was my father's trade - and
his father before him.\"" CR
					>
				)
				(<MC-PRSI? ,CH-PEASANT ,RM-COTTAGE ,GLOBAL-HERE>
					<TELL 
"\"I built this cottage with me own hands. It'll win no prizes for beauty,
but it's served me well.\"" CR
					>
				)
				(<MC-PRSI? ,TH-NAME>
					<TELL "\"Men call me Stilicho.\"" CR>
				)
				(<MC-PRSI? ,TH-EXCALIBUR>
					<TELL
"\"I know little about it. Swords are of no use to someone who makes his
living in a peat bog.\"" CR
					>
				)
				(T
					<TELL "\"I'm afraid I can't tell you anything about">
					<COND
						(<FSET? ,PRSI ,FL-PERSON>
							<TELL him ,PRSI>
						)
						(T
							<TELL " that">
						)
					>
					<TELL ".\"" CR>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,CH-PEASANT ,FL-SEEN>
			<COND
				(<NOUN-USED? ,CH-PEASANT ,W?LEG ,W?LEGS>
					<TELL The ,CH-PEASANT "'s leg is broken." CR>
				)
				(<FSET? ,CH-PEASANT ,FL-ASLEEP>
					<TELL
"The peasant is huddled on his pallet, with his thin cloak pulled tightly
around him. He is scarcely breathing and his lips are blue." CR
					>
				)
				(T
					<TELL
The ,CH-PEASANT " looks happy that you have saved his life." CR
					>
				)
			>
		)
		(<OR	<VERB? RUB>
				<AND
					<VERB-WORD? ,W?SLAP ,W?HIT>
					<MC-PRSI? ,TH-HANDS>
				>
			>
			<COND
				(<FSET? ,CH-PEASANT ,FL-ASLEEP>
					<TELL
"This seems to revive him for a moment, but then he shivers and lapses back
into unconsciousness." CR
					>
				)
			>
		)
		(<TOUCH-VERB?>
 			<TELL ,K-PEASANT-GROAN-MSG>
		)
	>
>

<ROUTINE RT-BOG-DIRECTIONS ("AUX" (X 1) (Y 5) (MAX 5) PTR)
	<TELL
"\"It's a right treacherous bog, it is. There's not many can find their way
through it without help. But what you do is go northeast from the edge of the
bog, then "
	>
	<SET PTR <ZREST <ZGET ,K-MAP-TBL ,K-MAP-BOG-TBL-NUM> 1>>
	<PUTB .PTR 0 5>
	<PUTB .PTR 1 1>
	<SET PTR <ZREST .PTR 2>>
	<REPEAT ((I 0) N D1 D2)
		<COND
			(<FSET? ,CH-PEASANT ,FL-LOCKED>
				<SET D1 <ZGET ,K-BOG-DIR-TBL .I>>
			)
			(T
				<SET N <RANDOM 4>>
				<COND
					(<EQUAL? .N 1>
						<DEC Y>
						<SET D1 ,P?NORTH>
						<SET D2 ,P?SOUTH>
					)
					(<EQUAL? .N 2>
						<DEC Y>
						<INC X>
						<SET D1 ,P?NE>
						<SET D2 ,P?SW>
					)
					(<EQUAL? .N 3>
						<INC X>
						<SET D1 ,P?EAST>
						<SET D2 ,P?WEST>
					)
					(<EQUAL? .N 4>
						<COND
							(<IGRTR? Y .MAX>
								<SET MAX .Y>
							)
						>
						<INC X>
						<SET D1 ,P?SE>
						<SET D2 ,P?NW>
					)
				>
				<ZPUT ,K-BOG-DIR-TBL .I .D1>
				<PUTB .PTR 0 .Y>
				<PUTB .PTR 1 .X>
				<SET PTR <ZREST .PTR 2>>
				<COND
					(<EQUAL? .I </ ,K-BOG-NUM 2>>
						<REPEAT (ID)
							<SET N <RANDOM 8>>
							<COND
								(<EQUAL? .N 1>
									<SET ID ,P?NORTH>
								)
								(<EQUAL? .N 2>
									<SET ID ,P?NE>
								)
								(<EQUAL? .N 3>
									<SET ID ,P?EAST>
								)
								(<EQUAL? .N 4>
									<SET ID ,P?SE>
								)
								(<EQUAL? .N 5>
									<SET ID ,P?SOUTH>
								)
								(<EQUAL? .N 6>
									<SET ID ,P?SW>
								)
								(<EQUAL? .N 7>
									<SET ID ,P?WEST>
								)
								(<EQUAL? .N 8>
									<SET ID ,P?NW>
								)
							>
							<COND
								(<NOT <EQUAL? .ID .D1 .D2>>
									<SETG GL-ISLAND-DIR .ID>
									<RETURN>
								)
							>
						>
					)
				>
			)
		>
		<COND
			(<G? .I 0>
				<TELL ", ">
			)
		>
		<COND
			(<EQUAL? .D1 ,P?NORTH ,P?NE>
				<TELL "north">
			)
			(<EQUAL? .D1 ,P?SOUTH ,P?SE>
				<TELL "south">
			)
		>
		<COND
			(<EQUAL? .D1 ,P?EAST ,P?NE ,P?SE>
				<TELL "east">
			)
		>
		<COND
			(<IGRTR? I ,K-BOG-LAST>
				<TELL " and east">
				<COND
					(<EQUAL? .D1 ,P?EAST>
						<TELL " again">
					)
				>
				<RETURN>
			)
		>
	>
	<TELL ".\"|">
	<COND
		(<NOT <FSET? ,CH-PEASANT ,FL-LOCKED>>
			<COND
				(<G? .MAX 5>
					<SET Y <- .MAX 5>>
					<SET PTR <ZREST <ZGET ,K-MAP-TBL ,K-MAP-BOG-TBL-NUM> 1>>
					<REPEAT ((I 0))
						<PUTB .PTR 0 <- <GETB .PTR 0> .Y>>
						<SET PTR <ZREST .PTR 2>>
						<COND
							(<IGRTR? I ,K-BOG-NUM>
								<RETURN>
							)
						>
					>
				)
			>
		)
	>
	<FSET ,CH-PEASANT ,FL-LOCKED>
	<RTRUE>
>

;"---------------------------------------------------------------------------"
; "TH-DIRECTIONS"
;"---------------------------------------------------------------------------"

<OBJECT TH-DIRECTIONS
	(LOC CH-PEASANT)
	(DESC "directions")
	(FLAGS FL-NO-DESC FL-TRY-TAKE)
	(SYNONYM DIRECTIONS)
	(ACTION RT-TH-DIRECTIONS)
>

<ROUTINE RT-TH-DIRECTIONS ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<OR	<AND
					<VERB? GIVE>
					<MC-PRSI? ,CH-PLAYER>
				>
				<AND
					<VERB? GIVE-SWP>
					<MC-PRSO? ,CH-PLAYER>
				>
				<VERB? TAKE>
			>
			<COND
				(<FSET? ,CH-PEASANT ,FL-ASLEEP>
					<RT-NO-RESPONSE-MSG ,CH-PEASANT>
				)
				(T
					<RT-BOG-DIRECTIONS>
				)
			>
		)
		(<NOT <EVERYWHERE-VERB? <COND (,NOW-PRSI 2) (T 1)>>>
			<NP-CANT-SEE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-SPLINT"
;"---------------------------------------------------------------------------"

<OBJECT TH-SPLINT
	(LOC CH-PEASANT)
	(DESC "splint")
	(FLAGS FL-NO-DESC FL-TRY-TAKE)
	(SYNONYM SPLINT)
	(OWNER CH-PEASANT)
	(ACTION RT-TH-SPLINT)
>

<ROUTINE RT-TH-SPLINT ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<TELL "The splint is bound securely to the cottager's leg." CR>
		)
		(<TOUCH-VERB?>
			<TELL ,K-PEASANT-GROAN-MSG>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-PALLET"
;"---------------------------------------------------------------------------"

<OBJECT TH-PALLET
	(LOC RM-COTTAGE)
	(DESC "pallet")
	(FLAGS FL-NO-DESC FL-SURFACE FL-SEARCH)
	(SYNONYM PALLET BED)
	(CAPACITY 50)
	(ACTION RT-TH-PALLET)
>

<ROUTINE RT-TH-PALLET ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<COND
				(<VERB? PUT>
					<RT-GIVE-CRUTCH>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-PALLET ,FL-SEEN>
			<FSET ,CH-PEASANT ,FL-SEEN>
			<TELL "You see a">
			<COND
				(<FSET? ,CH-PEASANT ,FL-ASLEEP>
					<TELL "n unconscious">
				)
			>
			<TELL " peasant on" the ,TH-PALLET "." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-CRUTCH"
;"---------------------------------------------------------------------------"

<OBJECT TH-CRUTCH
	(LOC RM-MOOR)
	(DESC "crutch")
	(FLAGS FL-BURNABLE FL-TAKEABLE)
	(SYNONYM CRUTCH)
	(OWNER CH-PEASANT)
	(SIZE 5)
	(ACTION RT-TH-CRUTCH)
>

; "TH-CRUTCH flags:"
; "	FL-BROKEN - Crutch is laying by peasant's pallet."
; "	FL-LOCKED - Player has given it to the peasant at least once."

<ROUTINE RT-TH-CRUTCH ("OPT" (CONTEXT <>) "AUX" V)
	<COND
		(.CONTEXT
			<RFALSE>
		)
	;	(<VERB? TAKE>
			<COND
				(<AND <IN? ,TH-CRUTCH ,RM-COTTAGE>
						<FSET? ,TH-CRUTCH ,FL-BROKEN>
						<SET V <ITAKE ,TH-CRUTCH>>
					>
					<COND
						(<EQUAL? .V ,M-FATAL>
							<SETG CLOCK-WAIT T>
							<RFATAL>
						)
					>
					<FCLEAR ,TH-CRUTCH ,FL-BROKEN>
					<RT-SCORE-MSG -10 0 0 0>
				)
			>
		)
	>
>

<ROUTINE RT-GIVE-CRUTCH ()
	<COND
		(<NOT <FSET? ,CH-PEASANT ,FL-ASLEEP>>
			<MOVE ,TH-CRUTCH ,RM-COTTAGE>
			<FSET ,TH-CRUTCH ,FL-NO-DESC>
			<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT>>
			<TELL
"The peasant takes the crutch. \"Thank you, sir. It's not much, but it helps
me move around.\"|"
			>
			<COND
				(<NOT <FSET? ,TH-CRUTCH ,FL-LOCKED>>
					<FSET ,TH-CRUTCH ,FL-LOCKED>
					<FSET ,TH-CRUTCH ,FL-BROKEN>
					<RT-SCORE-MSG 10 0 0 0>
				)
			>
			<RTRUE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-COTTAGE-FIRE"
;"---------------------------------------------------------------------------"

<OBJECT TH-COTTAGE-FIRE
	(LOC RM-COTTAGE)
	(FLAGS FL-BURNABLE FL-CONTAINER FL-HAS-SDESC FL-NO-ALL FL-NO-DESC FL-OPEN FL-SEARCH FL-SURFACE FL-TRY-TAKE FL-VOWEL)
	(SYNONYM FIRE HEARTH COAL COALS ASH ASHES)
	(CAPACITY K-CAP-MAX)
	(CONTFCN RT-TH-COTTAGE-FIRE)
	(ACTION RT-TH-COTTAGE-FIRE)
>

<CONSTANT K-HOT-MSG "Yeeeouch! Hot hot hot....|">

<ROUTINE RT-TH-COTTAGE-FIRE ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<COND
		(<MC-CONTEXT? ,M-OBJDESC>
			<COND
				(.ART
					<PRINT-ARTICLE ,TH-COTTAGE-FIRE .ART .CAP?>
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
						(<FSET? ,TH-COTTAGE-FIRE ,FL-LIGHTED>
							<TELL "fire">
						)
						(T
							<TELL "ashes">
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-CONT>
			<COND
				(<NOT <FSET? ,TH-COTTAGE-FIRE ,FL-LIGHTED>>
					<RFALSE>
				)
				(<TOUCH-VERB?>
					<COND
						(<MC-FORM? ,K-FORM-SALAMANDER>
							<TELL
The+verb ,WINNER "poke" " around in" the ,TH-COTTAGE-FIRE " but find nothing
of interest." CR
							>
						)
						(T
							<TELL ,K-HOT-MSG>
						)
					>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<COND
				(<VERB? PUT PUT-IN>
					<COND
						(<MC-PRSO? ,TH-PEAT-BRICK>
							<RT-LIGHT-FIRE>
						)
						(<AND <MC-PRSO? ,TH-WHISKY-JUG>
								<IN? ,TH-WHISKY ,TH-WHISKY-JUG>
							>
							<RT-PUT-WHISKY-IN-FIRE-MSG ,TH-COTTAGE-FIRE>
						)
						(<NOT <FSET? ,TH-COTTAGE-FIRE ,FL-LIGHTED>>
							<RFALSE>
						)
						(<OR	<MC-PRSO? ,CH-PLAYER ,TH-HANDS ,TH-LEGS ,TH-HEAD ,TH-MOUTH>
								<AND
									<FSET? ,PRSO ,FL-BODY-PART>
									<EQUAL? <GET-OWNER ,PRSO> ,CH-PLAYER>
								>
							>
							<TELL ,K-HOT-MSG>
						)
						(<FSET? ,PRSO ,FL-BURNABLE>
							<REMOVE ,PRSO>
							<TELL
"The flames leap higher, and soon" the ,PRSO " can no longer be seen.|"
							>
							<COND
								(<MC-PRSO? ,TH-CRUTCH>
									<RT-SCORE-MSG -10 0 0 0>
								)
							>
							<RTRUE>
						)
					>
				)
			>
		)
		(<VERB? EXAMINE LOOK-IN LOOK-ON>
			<FSET ,TH-COTTAGE-FIRE ,FL-SEEN>
			<COND
				(<FSET? ,TH-COTTAGE-FIRE ,FL-LIGHTED>
					<TELL "The fire is burning brightly.">
				)
				(<NOUN-USED? ,TH-COTTAGE-FIRE ,W?FIRE>
					<TELL
"All that is left of the fire is a few coals smouldering below the ashes."
					>
				)
				(T
					<TELL "A few coals smoulder below the ashes.">
				)
			>
			<COND
				(<SEE-ANYTHING-IN? ,TH-COTTAGE-FIRE>
					<TELL
" " In ,TH-COTTAGE-FIRE the ,TH-COTTAGE-FIRE the+verb ,WINNER "see"
					>
					<PRINT-CONTENTS ,TH-COTTAGE-FIRE>
					<TELL ".">
				)
			>
			<CRLF>
		)
		(<AND <VERB? LIGHT>
				<NOT <FSET? ,TH-COTTAGE-FIRE ,FL-LIGHTED>>
				<MC-PRSI? ,TH-PEAT-BRICK>
			>
			<RT-LIGHT-FIRE>
		)
		(<VERB? ENTER CLIMB-ON>
			<COND
				(<MC-FORM? ,K-FORM-SALAMANDER>
					<TELL
"You step" in ,TH-COTTAGE-FIRE "to" the ,TH-COTTAGE-FIRE " and look around
for a few moments. Finding nothing of interest, you step" out ,TH-COTTAGE-FIRE
" again." CR
					>
				)
				(T
					<TELL ,K-HOT-MSG>
				)
			>
		)
		(<VERB? BLOW>
			<COND
				(<FSET? ,TH-COTTAGE-FIRE ,FL-LIGHTED>
					<TELL "The flames dance around a little">
				)
				(T
					<TELL "The coals glow a little more brightly">
				)
			>
			<TELL ", but otherwise nothing happens." CR>
		)
		(<TOUCH-VERB?>
			<COND
				(<AND <NOT <MC-FORM? ,K-FORM-SALAMANDER>>
						<OR
							<MC-PRSI? <> ,ROOMS ,CH-PLAYER ,TH-HANDS ,TH-LEGS ,TH-HEAD ,TH-MOUTH>
							<AND
								<FSET? ,PRSI ,FL-BODY-PART>
								<EQUAL? <GET-OWNER ,PRSI> ,CH-PLAYER>
							>
						>
					>
					<TELL ,K-HOT-MSG>
				)
				(T
					<TELL
The+verb ,WINNER "poke" " around in" the ,TH-COTTAGE-FIRE " but find nothing
of interest." CR
					>
				)
			>
		)
		(<AND <VERB? LISTEN>
				<FSET? ,TH-COTTAGE-FIRE ,FL-LIGHTED>
			>
			<TELL "The fire snaps, crackles, and pops." CR>
		)
	>
>

<ROUTINE RT-LIGHT-FIRE ("AUX" OBJ NXT)
;	<REMOVE ,TH-PEAT-BRICK>
	<FSET ,TH-COTTAGE-FIRE ,FL-LIGHTED>
	<FCLEAR ,TH-COTTAGE-FIRE ,FL-VOWEL>
;	<FSET ,TH-COTTAGE-FIRE ,FL-CONTAINER>
;	<FCLEAR ,TH-COTTAGE-FIRE ,FL-SURFACE>
	<FCLEAR ,CH-PEASANT ,FL-ASLEEP>
	<SET OBJ <FIRST? ,TH-COTTAGE-FIRE>>

	; "Remove burnable objects on hearth."
	<REPEAT ()
		<COND
			(<NOT .OBJ>
				<RETURN>
			)
			(T
				<SET NXT <NEXT? .OBJ>>
				<COND
					(<FSET? .OBJ ,FL-BURNABLE>
						<REMOVE .OBJ>
					)
				>
				<SET OBJ .NXT>
			)
		>
	>
	<MOVE ,TH-PEAT-BRICK ,TH-COTTAGE-FIRE>
	<FSET ,TH-PEAT-BRICK ,FL-NO-LIST>
	<TELL
"You put the peat on the coals. It catches fire quickly, and soon the room is
filled with warmth." CR CR
"After a few moments, the peasant begins to stir. When he
is fully conscious he sits up and looks from the fire to you. \"Why, God
bless you, sir,\" he says. \"There's not many would take pity on a poor man who makes his living in a peat bog.\"" CR
	>
	<RT-SCORE-MSG 10 0 0 0>
	<SETG GL-PICTURE-NUM ,K-PIC-COTTAGE-AWAKE>
	<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC ,K-UPD-INVT>>
	<COND
		(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
			<RT-UPDATE-DESC-WINDOW>
		)
		(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-INVT>
			<RT-UPDATE-INVT-WINDOW>
		)
		(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
			<RT-UPDATE-PICT-WINDOW>
		)
	>
	<RTRUE>
>

;"---------------------------------------------------------------------------"
; "RM-EDGE-OF-BOG"
;"---------------------------------------------------------------------------"

<ROOM RM-EDGE-OF-BOG
	(LOC ROOMS)
	(DESC "edge of bog")
	(FLAGS FL-LIGHTED)
	(NE TO RM-BOG)
	(SW TO RM-MOOR)
	(UP PER RT-FLY-UP)
	(GLOBAL LG-PEAT LG-PATH RM-BOG RM-COTTAGE RM-MOOR)
	(ACTION RT-RM-EDGE-OF-BOG)
	(THINGS <> SIGN RT-PS-SIGN)
>

<ROUTINE RT-RM-EDGE-OF-BOG ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "You are" standing " at">
				)
				(T
					<COND
						(<EQUAL? ,OHERE ,RM-BOG>
							<TELL
"You take a few steps and suddenly emerge from the mists at"
							>
						)
						(T
							<TELL "You come to">
						)
					>
				)
			>
			<FSET ,RM-BOG ,FL-SEEN>
			<TELL
" the edge of the peat bog. The peat below your feet here is firm and dry,
but to the northeast, the path leads into the soggy, treacherous bog. The
house is to the southwest. There is a sign here.|"
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-EDGE-OF-BOG>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTERED>
			<SETG GL-BOG-START ,HERE>
			<SETG GL-BOG-POS 0>
			<COND
				(<AND <EQUAL? ,OHERE ,RM-BOG>
						<FSET? ,RM-BOG ,FL-BROKEN>
						<FSET? ,RM-BOG ,FL-LOCKED>
					>
					<FCLEAR ,RM-BOG ,FL-BROKEN>
					<FCLEAR ,RM-BOG ,FL-LOCKED>
					<RT-SCORE-MSG 0 2 3 2>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
	>
>

<ROUTINE RT-PS-SIGN ("OPT" (CONTEXT <>) (ART <>) (CAP? <>) "AUX" N)
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
					<TELL "sign">
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE READ>
		 <THIS-IS-IT ,PSEUDO-OBJECT>
			<RT-CENTER-STRING "WARNING">
			<RT-CENTER-STRING "BOG">
			<RT-CENTER-STRING "DANGER">
			<RT-CENTER-STRING "PERIL">
			<RT-CENTER-STRING "STAY OUT">
			<RT-CENTER-STRING "THIS MEANS YOU!">
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-BOG"
;"---------------------------------------------------------------------------"

<ROOM RM-BOG
	(LOC ROOMS)
	(DESC "peat bog")
	(FLAGS FL-LIGHTED FL-LOCKED)
	(SYNONYM BOG)
	(ADJECTIVE PEAT)
	(NORTH PER RT-WALK-BOG)
	(SOUTH PER RT-WALK-BOG)
	(EAST PER RT-WALK-BOG)
	(WEST PER RT-WALK-BOG)
	(NE PER RT-WALK-BOG)
	(NW PER RT-WALK-BOG)
	(SE PER RT-WALK-BOG)
	(SW PER RT-WALK-BOG)
	(UP PER RT-FLY-UP)
	(GLOBAL LG-PEAT RM-THORNEY-ISLAND)
	(ACTION RT-RM-BOG)
>

; "RM-BOG flags:"
; "	FL-BROKEN - Player has gotten thru bog"
; "	FL-LOCKED - Player hasn't gotten points for getting thru bog"

<ROUTINE RT-RM-BOG ("OPT" (CONTEXT <>) "AUX" L BD1 BD2)
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<EQUAL? ,P-WALK-DIR ,P?NORTH ,P?NE ,P?EAST ,P?SE>
					<SET L 1>
				)
				(T
					<SET L 0>
				)
			>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<COND
						(<NOT <EQUAL? ,GL-BOG-POS </ ,K-BOG-NUM 2>>>
							<TELL "The fog is so thick that you can't see a thing.|">
						)
					>
				)
				(<OR	<AND
							<EQUAL? .L 1>
							<EQUAL? ,GL-BOG-POS 0>
						>
						<AND
							<EQUAL? .L 0>
							<EQUAL? ,GL-BOG-POS ,K-BOG-NUM>
						>
					>
					<TELL
"You enter the swirling fog and soon lose sight of the path. Any step you
take is likely to propel you into the treacherous bog.|"
					>
				)
				(T
					<TELL
"Cautiously, you feel your way through the fog. The ground below your feet
seems firm enough, but one false step would be fatal.|"
					>
				)
			>
			<COND
				(<EQUAL? ,GL-BOG-POS </ ,K-BOG-NUM 2>>
					<COND
						(<NOT <MC-CONTEXT? ,M-LOOK>>
							<CRLF>
						)
					>
					<TELL "Across the bog to the ">
					<COND
						(<EQUAL? ,GL-ISLAND-DIR ,P?NORTH ,P?NE ,P?NW>
							<TELL "north">
						)
						(<EQUAL? ,GL-ISLAND-DIR ,P?SOUTH ,P?SE ,P?SW>
							<TELL "south">
						)
					>
					<COND
						(<EQUAL? ,GL-ISLAND-DIR ,P?EAST ,P?NE ,P?SE>
							<TELL "east">
						)
						(<EQUAL? ,GL-ISLAND-DIR ,P?WEST ,P?NW ,P?SW>
							<TELL "west">
						)
					>
					<FSET ,RM-THORNEY-ISLAND ,FL-SEEN>
					<TELL
", you see the vague outline of an island with what appears to be a large
thornbush on it. Unfortunately, the ground between here and there looks too
treacherous to walk on"
					>
					<COND
						(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
							<TELL ", even for" aform>
						)
					>
					<TELL "." CR>
				)
			>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<OR  <VERB? DROP>
						<AND
							<VERB? PUT PUT-IN THROW>
							<MC-PRSI? ,RM-BOG ,TH-GROUND ,GLOBAL-HERE>
						>
					>
					<COND
						(<OR	<PRE-PUT>	;"Should be <PRE-DROP>?"
								<NOT <IDROP>>
							>
							<RTRUE>
						)
						(T
							<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT>>
							<RT-DROP-IN-BOG ,PRSO>
						)
					>
				)
				(<AND <EQUAL? ,RM-THORNEY-ISLAND ,PRSO ,PRSI>
						<NOT <EQUAL? ,GL-BOG-POS </ ,K-BOG-NUM 2>>>
					>
					<NP-CANT-SEE>
				)
				(<AND <VERB? WALK>
						<EQUAL? ,GL-BOG-POS </ ,K-BOG-NUM 2>>
						<EQUAL? ,P-WALK-DIR ,GL-ISLAND-DIR>
						<MC-FORM? ,K-FORM-OWL>
					>
					<RT-FLY-TO-ISLAND>
				)
				(<OR	<VERB? JUMP>
						<AND
							<VERB? ENTER>
							<MC-PRSO? ,RM-BOG>
						>
					>
					<TELL
"In a fit of youthful exuberance, you dive headlong into the bog. Moments
later, as you begin to drown, you decide that youthful exuberance isn't all
it's cracked up to be.|"
					>
					<RT-END-OF-GAME>
				)
			>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-BOG>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTERED>
			<FCLEAR ,RM-BOG ,FL-BROKEN>
		;	<SETG GL-BOG-START ,OHERE>
		;	<COND
				(<EQUAL? ,OHERE ,RM-EDGE-OF-BOG>
					<SETG GL-BOG-POS 0>
				)
				(<EQUAL? ,OHERE ,RM-WEST-OF-FORD>
					<SETG GL-BOG-POS ,K-BOG-NUM>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<AND <VERB? EXAMINE>
				<NOT <MC-HERE? ,RM-BOG>>
			>
			<TELL "The bog looks ominous and forbidding." CR>
		)
	>
>

<ROUTINE RT-DROP-IN-BOG (OBJ)
	<REMOVE .OBJ>
	<TELL
"With a sickening, slurping sound," the .OBJ " slowly" verb .OBJ "sink"
" into the mire until the bog finally closes over" him .OBJ " with a faint
\"plop.\"" CR
	>
>

<ROUTINE RT-WRONG-BOG-MSG ()
	<TELL "You take a few cautious ">
	<COND
		(<MC-FORM? ,K-FORM-OWL>
			<TELL "hops">
		)
		(T
			<TELL "steps">
		)
	>
	<TELL
" onto what appears to be solid ground. Suddenly, however, it begins to sink
beneath you. The bog sucks your body under with amazing force, and as your
head sinks below the murky surface, your last thoughts are of Merlin and your
inability to live up to his trust." CR
	>
>

<CONSTANT K-BOG-NUM 4>
<CONSTANT K-BOG-LAST <- ,K-BOG-NUM 1>>
<GLOBAL GL-BOG-POS 0 <> BYTE>
<GLOBAL GL-ISLAND-DIR <>>
<CONSTANT K-BOG-DIR-TBL <ITABLE ,K-BOG-NUM 0>>
<GLOBAL GL-BOG-START <> <> BYTE>

<ROUTINE RT-WALK-BOG ("OPT" (QUIET <>) "AUX" D L)
	<COND
		(.QUIET
			<COND
				(<AND <EQUAL? ,GL-BOG-POS </ ,K-BOG-NUM 2>>
						<EQUAL? ,P-WALK-DIR ,GL-ISLAND-DIR>
					>
					<RETURN ,RM-THORNEY-ISLAND>
				)
			>
		)
		(T
			<COND
				(<EQUAL? ,P-WALK-DIR ,P?NORTH ,P?NE ,P?EAST ,P?SE>
					<SET L 1>
				)
				(T
					<SET L 0>
					<DEC GL-BOG-POS>
				)
			>
			<COND
				(<NOT <FSET? ,CH-PEASANT ,FL-LOCKED>>
					<RT-WRONG-BOG-MSG>
					<RT-END-OF-GAME>
				)
				(<AND <EQUAL? .L 0>
						<L? ,GL-BOG-POS 0>
					>
					<COND
						(<EQUAL? ,P-WALK-DIR ,P?SW>
							<COND
								(<EQUAL? ,GL-BOG-START ,RM-WEST-OF-FORD>
									<FSET ,RM-BOG ,FL-BROKEN>
								)
							>
							<SETG GL-BOG-POS 0>
							<RETURN ,RM-EDGE-OF-BOG>
						)
						(T
							<RT-WRONG-BOG-MSG>
							<RT-END-OF-GAME>
						)
					>
				)
				(<AND <EQUAL? .L 1>
						<G? ,GL-BOG-POS ,K-BOG-LAST>
					>
					<COND
						(<EQUAL? ,P-WALK-DIR ,P?EAST>
							<COND
								(<EQUAL? ,GL-BOG-START ,RM-EDGE-OF-BOG>
									<FSET ,RM-BOG ,FL-BROKEN>
								)
							>
							<SETG GL-BOG-POS ,K-BOG-NUM>
							<RETURN ,RM-WEST-OF-FORD>
						)
						(T
							<RT-WRONG-BOG-MSG>
							<RT-END-OF-GAME>
						)
					>
				)
				(T
					<SET D <ZGET ,K-BOG-DIR-TBL ,GL-BOG-POS>>
					<COND
						(<EQUAL? .L 0>
							<COND
								(<EQUAL? .D ,P?NORTH>
									<SET D ,P?SOUTH>
								)
								(<EQUAL? .D ,P?NE>
									<SET D ,P?SW>
								)
								(<EQUAL? .D ,P?EAST>
									<SET D ,P?WEST>
								)
								(<EQUAL? .D ,P?SE>
									<SET D ,P?NW>
								)
							>
						)
					>
					<COND
						(<NOT <EQUAL? ,P-WALK-DIR .D>>
							<RT-WRONG-BOG-MSG>
							<RT-END-OF-GAME>
						)
					>
				)
			>
			<COND
				(<NOT <ZERO? .L>>
					<INC GL-BOG-POS>
				)
			>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>
					<RT-UPDATE-MAP-WINDOW>
				)
			>
			<RT-RM-BOG ,M-V-LOOK>
			<SETG OHERE ,HERE>
			<RFALSE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-ABOVE-MOOR"
;"---------------------------------------------------------------------------"

<ROOM RM-ABOVE-MOOR
	(LOC ROOMS)
	(DESC "above moor")
	(FLAGS FL-AIR FL-LIGHTED)
	(DOWN PER RT-FLY-DOWN)
	(EAST TO RM-ABOVE-BOG)
	(WEST TO RM-ABOVE-EDGE-OF-WOODS)
	(SOUTH TO RM-ABOVE-TOWN)
	(NW TO RM-ABOVE-FOREST)
	(SW TO RM-ABOVE-MEADOW)
	(SE TO RM-ABOVE-CASTLE)
	(UP SORRY K-NO-HIGHER-MSG)
	(GLOBAL RM-MOOR RM-COTTAGE)
	(ACTION RT-RM-ABOVE-MOOR)
>

<ROUTINE RT-RM-ABOVE-MOOR ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,RM-BOG ,FL-SEEN>
			<FSET ,LG-CASTLE ,FL-SEEN>
			<FSET ,LG-TOWN ,FL-SEEN>
			<TELL
"You are hovering over the moor. To the west lies the edge of the enchanted
forest, and to the northwest is the forest proper. Below you to the east is
the thick cloud of fog, and south of that you can see the castle. The roofs
of the town lie to the south, and the meadow outside the town lies to the
southwest.|"
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

;"---------------------------------------------------------------------------"
; "RM-ABOVE-BOG"
;"---------------------------------------------------------------------------"

<ROOM RM-ABOVE-BOG
	(LOC ROOMS)
	(DESC "above bog")
	(FLAGS FL-AIR FL-LIGHTED)
	(DOWN PER RT-FLY-DOWN)
	(EAST TO RM-ABOVE-FORD)
	(WEST TO RM-ABOVE-MOOR)
	(SOUTH TO RM-ABOVE-CASTLE)
	(SW TO RM-ABOVE-TOWN)
	(UP SORRY K-NO-HIGHER-MSG)
	(GLOBAL RM-BOG RM-EDGE-OF-BOG RM-THORNEY-ISLAND)
	(ACTION RT-RM-ABOVE-BOG)
>

<ROUTINE RT-RM-ABOVE-BOG ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,RM-BOG ,FL-SEEN>
			<FSET ,RM-THORNEY-ISLAND ,FL-SEEN>
			<FSET ,LG-TOWN ,FL-SEEN>
			<FSET ,RM-BOG ,FL-SEEN>
			<TELL
"You are hovering over a thick patch of fog. Below, you can make out the
vague outline of an island with what looks like a large bush or tree on it.
The skies are clearer to the west and southwest, where you see the moor
and roofs of the town. The castle lies below you to the south, and to the
east you can see a road emerge from the fog and come to a ford in the
river.|"
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

