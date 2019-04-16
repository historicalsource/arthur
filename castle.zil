;"***************************************************************************"
; "game : Arthur"
; "file : CASTLE.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   15 May 1989 19:41:50  $"
; "revs : $Revision:   1.116  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Castle Puzzle"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "RM-PASSAGE-1"
;"---------------------------------------------------------------------------"

<ROOM RM-PASSAGE-1
	(LOC ROOMS)
	(DESC "dark passage")
	(FLAGS FL-INDOORS FL-LIGHTED)
	(SYNONYM PASSAGE PASSAGEWAY)
	(ADJECTIVE DARK SECRET)
	(WEST TO RM-SMALL-CHAMBER)
	(NORTH TO RM-PASSAGE-2)
	(SOUTH TO RM-PASSAGE-3)
	(OUT TO RM-SMALL-CHAMBER)
	(UP PER RT-EXIT-PASSAGE-1)
	(SCORE <ORB <LSH 2 ,K-WISD-SHIFT> <LSH 1 ,K-QUEST-SHIFT>>)
	(GLOBAL LG-BADGER-TAPESTRY LG-WALL RM-SMALL-CHAMBER)
	(ACTION RT-RM-PASSAGE-1)
>

<ROUTINE RT-RM-PASSAGE-1 ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,LG-BADGER-TAPESTRY ,FL-SEEN>
			<TELL
"You are in a dark underground passageway whose walls have been carved out of
solid rock. You peer into the darkness and "
			>
			<COND
				(<MC-CONTEXT? ,M-F-LOOK>
					<TELL "discover">
				)
				(T
					<TELL "see">
				)
			>
			<TELL
" a secret passage leading upward to both the north and south. To the west is
the back of a tapestry.|"
			>
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
		(<NOT <EVERYWHERE-VERB? <COND (,NOW-PRSI 2) (T 1)>>>
			<COND
				(<FSET? ,LG-BADGER-TAPESTRY ,FL-LOCKED>
					<NP-CANT-SEE>
				)
			>
		)
	>
>

<ROUTINE RT-EXIT-PASSAGE-1 ("OPT" (QUIET <>))
	<COND
		(<NOT .QUIET>
			<TELL "[Which way, north or south?]|">
		)
	>
	<RFALSE>
>

;"---------------------------------------------------------------------------"
; "RM-PASSAGE-2"
;"---------------------------------------------------------------------------"

<ROOM RM-PASSAGE-2
	(LOC ROOMS)
	(DESC "dark passage")
	(FLAGS FL-INDOORS FL-LIGHTED)
	(SYNONYM PASSAGE)
	(ADJECTIVE DARK)
	(NORTH TO RM-BEHIND-THRONE)
	(SOUTH TO RM-PASSAGE-1)
	(UP TO RM-BEHIND-THRONE)
	(DOWN TO RM-PASSAGE-1)
	(GLOBAL LG-WALL)
	(ACTION RT-RM-PASSAGE-2)
>

<ROUTINE RT-RM-PASSAGE-2 ("OPT" (CONTEXT <>))
   <COND
      (<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
         <TELL "You are in a dark passage that continues ">
			<COND
				(<EQUAL? ,OHERE ,RM-PASSAGE-1>
					<TELL "up to the north and back down behind you to the south.|">
				)
				(T
					<TELL "down to the south and back up behind you to the north.|">
				)
			>
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

;"---------------------------------------------------------------------------"
; "RM-PASSAGE-3"
;"---------------------------------------------------------------------------"

<ROOM RM-PASSAGE-3
	(LOC ROOMS)
	(DESC "dark passage")
	(FLAGS FL-INDOORS FL-LIGHTED)
	(SYNONYM PASSAGE)
	(ADJECTIVE DARK)
	(NORTH TO RM-PASSAGE-1)
	(SOUTH TO RM-BEHIND-FIRE)
	(UP TO RM-BEHIND-FIRE)
	(DOWN TO RM-PASSAGE-1)
	(GLOBAL LG-WALL)
	(ACTION RT-RM-PASSAGE-3)
>

<ROUTINE RT-RM-PASSAGE-3 ("OPT" (CONTEXT <>))
   <COND
      (<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
         <TELL "You are in a dark passage that continues ">
			<COND
				(<EQUAL? ,OHERE ,RM-PASSAGE-1>
					<TELL
"up to the south and back down behind you to the north.|"
					>
				)
				(T
					<TELL
"down to the north and back up behind you to the south.|"
					>
				)
			>
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

;"---------------------------------------------------------------------------"
; "RM-BEHIND-FIRE"
;"---------------------------------------------------------------------------"

<ROOM RM-BEHIND-FIRE
   (LOC ROOMS)
   (DESC "end of passage")
   (FLAGS FL-INDOORS FL-LIGHTED)
	(SYNONYM PASSAGE)
	(ADJECTIVE DARK)
   (WEST PER RT-THRU-FIRE)
   (OUT PER RT-THRU-FIRE)
   (NORTH TO RM-PASSAGE-3)
   (DOWN TO RM-PASSAGE-3)
	(ADJACENT <TABLE (LENGTH BYTE PURE) RM-CAS-KITCHEN T>)
	(GLOBAL LG-WALL RM-CAS-KITCHEN RM-PASSAGE-3)
   (ACTION RT-RM-BEHIND-FIRE)
>

<ROUTINE RT-RM-BEHIND-FIRE ("OPT" (CONTEXT <>))
   <COND
      (<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL
"You are in a small, cramped room that is solid on three sides."
					>
				)
				(T
					<COND
						(<EQUAL? ,OHERE ,RM-CAS-KITCHEN>
							<TELL "You" walk " back through the fire">
							<COND
								(<NOT <FSET? ,TH-CASTLE-FIRE ,FL-LIGHTED>>
									<TELL "place">
								)
							>
							<TELL " to the small room.">
						)
						(T
							<TELL
"The passage ends in a small, cramped room that is solid on three sides."
							>
						)
					>
				)
			>
			<COND
				(<FSET? ,TH-CASTLE-FIRE ,FL-LIGHTED>
					<FSET ,TH-CASTLE-FIRE ,FL-SEEN>
					<TELL
" The fourth side is a blazing wall of fire whose bright flames leap high
into the air.">
				)
			>
			<TELL " A dark passage leads down to the north. The fire">
			<COND
				(<NOT <FSET? ,TH-CASTLE-FIRE ,FL-LIGHTED>>
					<TELL "place">
				)
			>
			<TELL " is to the west.|">
         <RFALSE>
      )
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-PASSAGE>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<MOVE ,TH-CASTLE-FIRE ,RM-BEHIND-FIRE>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<AND <NOT ,GL-PUPPY>
						<IN? ,CH-PRISONER ,RM-BEHIND-FIRE>
					>
					<RT-SET-PUPPY ,CH-PRISONER>
				)
			>
		)
      (.CONTEXT
         <RFALSE>
      )
   >
>

<ROUTINE RT-THRU-FIRE ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<COND
				(<MC-HERE? ,RM-CAS-KITCHEN>
					<RETURN ,RM-BEHIND-FIRE>
				)
				(<MC-HERE? ,RM-BEHIND-FIRE>
					<RETURN ,RM-CAS-KITCHEN>
				)
			>
		)
		(<OR	<MC-FORM? ,K-FORM-SALAMANDER>
				<NOT <FSET? ,TH-CASTLE-FIRE ,FL-LIGHTED>>
			>
			<COND
				(<FSET? ,TH-CASTLE-FIRE ,FL-LIGHTED>
					<RT-CLEAR-PUPPY>
				)
			>
			<COND
				(<MC-HERE? ,RM-CAS-KITCHEN>
					<RETURN ,RM-BEHIND-FIRE>
				)
				(<MC-HERE? ,RM-BEHIND-FIRE>
					<RETURN ,RM-CAS-KITCHEN>
				)
			>
		)
		(T
			<TELL The ,WINNER " would surely perish in the flames.|">
		;	<COND
				(<NOT <EQUAL? ,WINNER ,CH-PLAYER>>
					<RT-AUTHOR-ON>
					<TELL The+verb ,WINNER "are" "n't as stupid as you look.">
					<RT-AUTHOR-OFF>
				)
			>
			<RFALSE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-CASTLE-FIRE"
;"---------------------------------------------------------------------------"

<OBJECT TH-CASTLE-FIRE
	(LOC LOCAL-GLOBALS)
	(FLAGS FL-BURNABLE FL-CONTAINER FL-HAS-SDESC FL-LIGHTED FL-NO-DESC FL-OPEN FL-SEARCH)
	(SYNONYM FIRE FLAMES FIREPLACE PLACE)
	(ADJECTIVE FIRE)
	(CAPACITY K-CAP-MAX)
	(CONTFCN RT-TH-CASTLE-FIRE)
	(ACTION RT-TH-CASTLE-FIRE)
>

; "TH-CASTLE-FIRE flags:"
; "	FL-LOCKED - Things in fire are cooling off"

<ROUTINE RT-TH-CASTLE-FIRE ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<COND
		(<MC-CONTEXT? ,M-OBJDESC>
			<COND
				(.ART
					<PRINT-ARTICLE ,TH-CASTLE-FIRE .ART .CAP?>
				)
			>
			<COND
				(<EQUAL? .ART <> ,K-ART-THE ,K-ART-A ,K-ART-ANY>
					<COND
						(.ART
							<TELL " ">
						)
					>
					<TELL "fire">
					<COND
						(<NOT <FSET? ,TH-CASTLE-FIRE ,FL-LIGHTED>>
							<TELL "place">
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-CONT>
			<COND
				(<TOUCH-VERB?>
					<COND
						(<MC-FORM? ,K-FORM-SALAMANDER>
							<TELL
The+verb ,WINNER "poke" " around in" the ,TH-CASTLE-FIRE " but find nothing
of interest." CR
							>
						)
						(<FSET? ,TH-CASTLE-FIRE ,FL-LIGHTED>
							<TELL ,K-HOT-MSG>
						)
						(<OR	<AND ,NOW-PRSI <FSET? ,PRSI ,FL-AIR>>
								<AND <NOT ,NOW-PRSI> <FSET? ,PRSO ,FL-AIR>>
							>
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
				(<VERB? EMPTY>
					<COND
						(<MC-PRSO? ,TH-BARREL ,TH-BARREL-WATER>
							<COND
								(<IN? ,TH-BARREL-WATER ,TH-BARREL>
									<COND
										(<MC-FORM? ,K-FORM-ARTHUR>
											<RT-PUT-OUT-FIRE-MSG>
										)
									>
								)
							>
						)
					>
				)
				(<VERB? PUT PUT-IN>
					<COND
						(<NOT <FSET? ,TH-CASTLE-FIRE ,FL-LIGHTED>>
							<RFALSE>
						)
						(<OR	<MC-PRSO? ,CH-PLAYER ,TH-HANDS ,TH-LEGS ,TH-HEAD ,TH-MOUTH>
								<AND
									<FSET? ,PRSI ,FL-BODY-PART>
									<EQUAL? <GET-OWNER ,PRSI> ,CH-PLAYER>
								>
							>
							<TELL ,K-HOT-MSG>
						)
						(<AND <MC-PRSO? ,TH-WHISKY-JUG>
								<IN? ,TH-WHISKY ,TH-WHISKY-JUG>
							>
							<RT-PUT-WHISKY-IN-FIRE-MSG ,TH-CASTLE-FIRE>
						)
						(<FSET? ,PRSO ,FL-BURNABLE>
							<REMOVE ,PRSO>
							<TELL
"The flames leap higher, and soon" the ,PRSO " can no longer be seen." CR
							>
						)
					>
				)
				(<VERB? PUT-THRU>
					<COND
						(<MC-HERE? ,RM-BEHIND-FIRE>
							<COND
								(<IDROP>
									<RT-THROW-INTO-ROOM-MSG ,PRSO ,RM-CAS-KITCHEN>
								)
							>
						)
						(<MC-HERE? ,RM-CAS-KITCHEN>
							<COND
								(<IDROP>
									<RT-THROW-INTO-ROOM-MSG ,PRSO ,RM-BEHIND-FIRE>
								)
							>
						)
						(T
							<NOT-HERE ,PRSI>	; "not close enough"
						)
					>
				)
			>
		)
		(<VERB? ENTER>
			<COND
				(<MC-HERE? ,RM-BEHIND-FIRE>
					<RT-DO-WALK ,P?WEST>
				)
				(<MC-HERE? ,RM-CAS-KITCHEN>
					<RT-DO-WALK ,P?EAST>
				)
			>
		)
		(<VERB? CLIMB-ON>
			<COND
				(<MC-FORM? ,K-FORM-SALAMANDER>
					<TELL
"You step" in ,TH-CASTLE-FIRE "to" the ,TH-CASTLE-FIRE " and look around
for a few moments. Finding nothing of interest, you step" out ,TH-CASTLE-FIRE
" again." CR
					>
				)
				(T
					<TELL ,K-HOT-MSG>
				)
			>
		)
		(<VERB? EXTINGUISH>
			<COND
				(<MC-PRSI? ,TH-BARREL ,TH-BARREL-WATER>
					<COND
						(<IN? ,TH-BARREL-WATER ,TH-BARREL>
							<COND
								(<MC-FORM? ,K-FORM-ARTHUR>
									<RT-PUT-OUT-FIRE-MSG>
								)
								(T
									<RT-ANIMAL-CANT-MSG "put out">
								)
							>
						)
					>
				)
			>
		)
		(<OR	<VERB? EXAMINE>
			;	<AND
					<VERB? LOOK-IN LOOK-ON>
					<NOT <FIRST? ,TH-CASTLE-FIRE>>
				>
			>
			<FSET ,TH-CASTLE-FIRE ,FL-SEEN>
			<COND
				(<FSET? ,TH-CASTLE-FIRE ,FL-LIGHTED>
					<TELL "It's a roaring fire that gives off intense heat." CR>
				)
				(T
					<TELL "The fire has gone out." CR>
				)
			>
		)
		(<VERB? LOOK-THRU>
			<TELL The ,WINNER " can't see much from here." CR>
		)
		(<VERB? LISTEN>
			<COND
				(<FSET? ,TH-CASTLE-FIRE ,FL-LIGHTED>
					<TELL "The fire roars like a furnace." CR>
				)
			>
		)
		(<TOUCH-VERB?>
			<COND
				(<FSET? ,TH-CASTLE-FIRE ,FL-LIGHTED>
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
The+verb ,WINNER "poke" " around in" the ,TH-CASTLE-FIRE " but find nothing
of interest." CR
							>
						)
					>
				)
			>
		)
	>
>

<ROUTINE RT-PUT-OUT-FIRE-MSG ("AUX" OBJ)
	<RT-QUEUE ,RT-I-COOL-FIRE <+ ,GL-MOVES 60>>
	<FCLEAR ,TH-CASTLE-FIRE ,FL-LIGHTED>
;	<FSET ,TH-CASTLE-FIRE ,FL-LOCKED>
;	<FSET ,TH-CASTLE-FIRE ,FL-INVISIBLE>
	<REMOVE ,TH-BARREL-WATER>
	<RT-MOVE-ALL ,TH-BARREL ,HERE>
	<SET OBJ <FIRST? ,TH-CASTLE-FIRE>>
	<REPEAT ()
		<COND
			(<NOT .OBJ>
				<RETURN>
			)
			(T
				<FSET .OBJ ,FL-AIR>
				<SET OBJ <NEXT? .OBJ>>
			)
		>
	>
	<TELL
"You strain against the barrel. It teeters for a moment, but then finally
crashes over on its side, sending a flood of water directly onto the blaze.
The roar of the fire disappears in a loud hiss, and a huge cloud of steam
pours out of the fireplace. When the steam clears, you see that the fire has
gone out."
	>
	<SETG GL-PICTURE-NUM ,K-PIC-CAS-FIREPLACE>
	<COND
		(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
			<RT-UPDATE-PICT-WINDOW>
		)
	>
	<COND
		(<IN? ,CH-PRISONER ,RM-BEHIND-FIRE>
			<RT-SET-PUPPY ,CH-PRISONER>
			<MOVE ,CH-PRISONER ,HERE>
			<THIS-IS-IT ,CH-PRISONER>
			<TELL " The prisoner steps through to join you in the kitchen.">
		)
	>
	<CRLF>
	<RT-SCORE-MSG 0 2 0 1>
>

<ROUTINE RT-I-COOL-FIRE ("AUX" OBJ)
;	<FCLEAR ,TH-CASTLE-FIRE ,FL-LOCKED>
	<SET OBJ <FIRST? ,TH-CASTLE-FIRE>>
	<REPEAT ()
		<COND
			(<NOT .OBJ>
				<RETURN>
			)
			(T
				<FCLEAR .OBJ ,FL-AIR>
				<SET OBJ <NEXT? .OBJ>>
			)
		>
	>
	<RFALSE>
>

;"---------------------------------------------------------------------------"
; "RM-CAS-KITCHEN"
;"---------------------------------------------------------------------------"

<ROOM RM-CAS-KITCHEN
   (LOC ROOMS)
   (DESC "castle kitchen")
   (FLAGS FL-INDOORS FL-LIGHTED)
   (SYNONYM KITCHEN)
   (ADJECTIVE CASTLE)
   (EAST PER RT-THRU-FIRE)
   (IN PER RT-THRU-FIRE)
   (NW TO RM-PARADE-AREA IF LG-KITCHEN-DOOR IS OPEN)
   (OUT TO RM-PARADE-AREA IF LG-KITCHEN-DOOR IS OPEN)
	(ADJACENT <TABLE (LENGTH BYTE PURE) RM-BEHIND-FIRE T>)
   (GLOBAL LG-KITCHEN-DOOR LG-WALL)
   (ACTION RT-RM-CAS-KITCHEN)
>

<ROUTINE RT-RM-CAS-KITCHEN ("OPT" (CONTEXT <>))
   <COND
      (<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<TELL "You">
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<COND
						(<IN? ,CH-PLAYER ,TH-BARREL>
							<TELL " are in" a ,TH-BARREL ", in">
						)
						(T
							<TELL " are" standing " in">
						)
					>
				)
				(T
					<COND
						(<AND <EQUAL? ,OHERE ,RM-BEHIND-FIRE>
								<FSET? ,TH-CASTLE-FIRE ,FL-LIGHTED>
							>
							<TELL walk " through the flames unharmed and are now in">
						)
						(T
							<TELL " enter">
						)
					>
				)
			>
			<FSET ,LG-KITCHEN-DOOR ,FL-SEEN>
         <TELL
" the castle's kitchen. It is a huge stone room with a cavernous fireplace
along the east wall. There is a door in the northwest corner of the room."
			>
			<COND
				(<NOT <IN? ,CH-PLAYER ,TH-BARREL>>
					<FSET ,TH-BARREL ,FL-SEEN>
					<TELL
" On the floor next to a nearby table you see a barrel."
					>
				)
			>
			<CRLF>
			<RFALSE>
      )
		(<MC-CONTEXT? ,M-ENTER>
			<COND
				(<FSET? ,TH-CASTLE-FIRE ,FL-LIGHTED>
					<SETG GL-PICTURE-NUM ,K-PIC-CAS-KITCHEN>
				)
				(T
					<SETG GL-PICTURE-NUM ,K-PIC-CAS-FIREPLACE>
				)
			>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<MOVE ,TH-CASTLE-FIRE ,RM-CAS-KITCHEN>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTERED>
			<COND
				(<NOT <FSET? ,RM-CAS-KITCHEN ,FL-BROKEN>>
					<COND
						(<EQUAL? ,OHERE ,RM-BEHIND-FIRE>
							<COND
								(<FSET? ,TH-CASTLE-FIRE ,FL-LIGHTED>
									<FSET ,RM-CAS-KITCHEN ,FL-BROKEN>
									<RT-SCORE-MSG 0 3 3 1>
								)
							>
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-EXIT>
			<COND
				(<AND <EQUAL? ,P-WALK-DIR ,P?NW ,P?OUT>
						<EQUAL? ,GL-PUPPY ,CH-PRISONER>
						<NOT <IN? ,TH-HELMET ,CH-PRISONER>>
					;	<FSET? ,LG-KITCHEN-DOOR ,FL-OPEN>
					>
					<TELL
"Before you step through the door, the smith taps you on the shoulder and
says, \"I can't go out there. Someone might recognize me.\"" CR
					>
				)
			>
		)
      (.CONTEXT
         <RFALSE>
      )
		(,NOW-PRSI
			<COND
				(<OR	<VERB? THROW>
						<AND
							<VERB? PUT PUT-IN>
							<VERB-WORD? ,W?THROW ,W?TOSS ,W?HURL ,W?CHUCK ,W?FLING ,W?PITCH ,W?HEAVE>
						>
					>
					<COND
						(<MC-HERE? ,RM-BEHIND-FIRE>
							<COND
								(<IDROP>
									<RT-THROW-INTO-ROOM-MSG ,PRSO ,RM-CAS-KITCHEN>
								)
								(T
									<RTRUE>
								)
							>
						)
						(T
							<NOT-HERE ,PRSI>	; "not close enough"
						)
					>
				)
			>
		)
		(<VERB? EXAMINE>
			<COND
				(<NOT <MC-HERE? ,RM-CAS-KITCHEN>>
					<FSET ,RM-CAS-KITCHEN ,FL-SEEN>
					<COND
						(<MC-HERE? ,RM-BEHIND-FIRE>
							<TELL The ,WINNER " can't see much from here." CR>
						)
						(T
							<TELL "It's a small building to the south of the great hall." CR>
						)
					>
				)
			>
		)
   >
>

;"---------------------------------------------------------------------------"
; "TH-CASTLE-TABLE"
;"---------------------------------------------------------------------------"

<OBJECT TH-CASTLE-TABLE
	(LOC RM-CAS-KITCHEN)
	(DESC "kitchen table")
	(FLAGS FL-NO-LIST FL-SEARCH FL-SURFACE)
	(SYNONYM TABLE)
	(ADJECTIVE KITCHEN WOODEN)
	(CAPACITY 50)
	(ACTION RT-TH-CASTLE-TABLE)
>

<ROUTINE RT-TH-CASTLE-TABLE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? CLIMB-UP CLIMB-ON CLIMB-OVER>
			<RT-AUTHOR-ON>
			<TELL "It's not polite to " vw " on tables.">
			<RT-AUTHOR-OFF>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-BARREL"
;"---------------------------------------------------------------------------"

<OBJECT TH-BARREL
	(LOC RM-CAS-KITCHEN)
	(DESC "barrel")
	(FLAGS FL-CONTAINER FL-NO-LIST FL-OPEN FL-SEARCH FL-TRY-TAKE)
	(SYNONYM BARREL)
	(ADJECTIVE BIG WOODEN WATER)
	(CAPACITY 150)
	(ACTION RT-TH-BARREL)
>

<ROUTINE RT-TH-BARREL ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<AND <VERB? EXIT>
						<MC-FORM? ,K-FORM-EEL>
						<MC-PRSO? ,TH-BARREL <> ,ROOMS>
					>
					<TELL "Eels can't live out of water." CR>
				)
				(<OR	<AND
							<VERB? EMPTY MOVE TIP>
							<MC-PRSO? ,TH-BARREL>
						>
						<AND
							<TOUCH-VERB?>
							<NOT <RT-META-IN? ,PRSO ,TH-CASTLE-TABLE>>
							<NOT <RT-META-IN? ,PRSO ,TH-BARREL>>
							<NOT <RT-META-IN? ,PRSO ,CH-PLAYER>>
						>
					>
					<TELL
The ,WINNER " would have to get out of" the ,TH-BARREL " first." CR
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
		(<VERB? DRINK-FROM>
			<COND
				(<IN? ,TH-BARREL-WATER ,TH-BARREL>
					<PERFORM ,V?DRINK ,TH-BARREL-WATER>
					<RTRUE>
				)
				(T
					<TELL "There is nothing to drink in" the ,TH-BARREL "." CR>
				)
			>
		)
		(<VERB? TAKE RAISE>
			<TELL The+verb ,TH-BARREL "are" " too heavy to lift." CR>
		)
		(<VERB? EMPTY>
			<COND
				(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
					<RT-ANIMAL-CANT-MSG>
				)
				(<IN? ,TH-BARREL-WATER ,TH-BARREL>
					<COND
						(<MC-PRSI? <> ,ROOMS ,TH-GROUND ,TH-CASTLE-FIRE>
							<RT-PUT-OUT-FIRE-MSG>
						)
						(T
							<RT-WASTE-OF-TIME-MSG>
						)
					>
				)
			>
		)
		(<VERB? MOVE TIP>
			<COND
				(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
					<RT-ANIMAL-CANT-MSG "tip over">
				)
				(<IN? ,TH-BARREL-WATER ,TH-BARREL>
					<RT-PUT-OUT-FIRE-MSG>
				)
				(T
					<RT-NO-POINT-MSG "Moving">
				)
			>
		)
		(<VERB? ENTER>
			<COND
				(<AND <IN? ,TH-BARREL-WATER ,TH-BARREL>
						<NOT <MC-FORM? ,K-FORM-ARTHUR>>
					>
					<COND
						(<MC-FORM? ,K-FORM-OWL ,K-FORM-BADGER ,K-FORM-SALAMANDER>
							<TELL ,K-WOULD-DROWN-MSG>
						)
						(<MC-FORM? ,K-FORM-TURTLE>
							<RT-ANIMAL-CANT-MSG "climb into">
						)
					>
					<RTRUE>
				)
			>
			<MOVE ,WINNER ,TH-BARREL>
			<TELL The+verb ,WINNER "get" " into" the ,TH-BARREL "." CR>
			<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
					<RT-UPDATE-DESC-WINDOW>
				)
			>
			<RTRUE>
		)
		(<VERB? EXIT>
			<MOVE ,WINNER ,HERE>
			<TELL The+verb ,WINNER "get" " out of" the ,TH-BARREL "." CR>
			<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
					<RT-UPDATE-DESC-WINDOW>
				)
			>
			<RTRUE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-BARREL-WATER"
;"---------------------------------------------------------------------------"

<OBJECT TH-BARREL-WATER
	(LOC TH-BARREL)
	(DESC "water")
	(FLAGS FL-COLLECTIVE FL-PLURAL FL-WATER)
	(SYNONYM WATER)
	(SIZE 30)
	(ACTION RT-TH-BARREL-WATER)
>

<ROUTINE RT-TH-BARREL-WATER ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? DRINK EAT>
			<TELL The+verb ,WINNER "take" " a small, refreshing sip of water." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-PUMICE"
;"---------------------------------------------------------------------------"

<OBJECT TH-PUMICE
	(LOC TH-CASTLE-TABLE)
	(DESC "pumice stone")
	(FLAGS FL-TAKEABLE)
	(SYNONYM STONE PUMICE)
	(ADJECTIVE PUMICE)
	(SCORE <LSH 1 ,K-QUEST-SHIFT>)
	(SIZE 5)
	(GENERIC RT-GN-STONE)
	(ACTION RT-TH-PUMICE)
>

<ROUTINE RT-TH-PUMICE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-PUMICE ,FL-SEEN>
			<TELL "It is a small, rough stone." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "LG-KITCHEN-DOOR"
;"---------------------------------------------------------------------------"

<OBJECT LG-KITCHEN-DOOR
   (LOC LOCAL-GLOBALS)
   (DESC "kitchen door")
	(FLAGS FL-DOOR FL-OPENABLE FL-LOCKED FL-NO-DESC)
   (SYNONYM DOOR BAR)
   (ADJECTIVE KITCHEN)
   (ACTION RT-LG-KITCHEN-DOOR)
>

<ROUTINE RT-LG-KITCHEN-DOOR ("OPT" (CONTEXT <>))
	<COND
		(<NOUN-USED? ,LG-KITCHEN-DOOR ,W?BAR>
			<COND
				(<MC-HERE? ,RM-PARADE-AREA>
					<NP-CANT-SEE>
				)
				(<VERB? EXAMINE>
					<TELL "It's a stout piece of wood that has been ">
					<COND
						(<FSET? ,LG-KITCHEN-DOOR ,FL-LOCKED>
							<TELL "lowered">
						)
						(T
							<TELL "raised">
						)
					>
					<TELL " to ">
					<COND
						(<FSET? ,LG-KITCHEN-DOOR ,FL-LOCKED>
							<TELL "bar">
						)
						(T
							<TELL "unbar">
						)
					>
					<TELL " the door." CR>					
				)
				(<AND <TOUCH-VERB?>
						<NOT <MC-FORM? ,K-FORM-ARTHUR>>
					>
					<TELL The ,WINNER " can't reach the bar." CR>
				)
				(<VERB? TAKE>
					<TELL
The+verb ,WINNER "tug" " at the bar, but it is firmly attached to the
wall." CR
					>
				)
				(<VERB? RAISE OPEN UNLOCK>
					<COND
						(<NOT <FSET? ,LG-KITCHEN-DOOR ,FL-LOCKED>>
							<SETG CLOCK-WAIT T>
							<TELL "The bar is already up." CR>
						)
						(T
							<FCLEAR ,LG-KITCHEN-DOOR ,FL-LOCKED>
							<TELL "You lift the bar." CR>
						)
					>
				)
				(<VERB? LOWER CLOSE LOCK>
					<COND
						(<FSET? ,LG-KITCHEN-DOOR ,FL-LOCKED>
							<SETG CLOCK-WAIT T>
							<TELL "The bar is already down." CR>
						)
						(T
							<FSET ,LG-KITCHEN-DOOR ,FL-LOCKED>
							<TELL "You lower the bar." CR>
						)
					>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,LG-KITCHEN-DOOR ,FL-SEEN>
			<TELL "It's a massive wooden door">
			<COND
				(<MC-HERE? ,RM-CAS-KITCHEN>
					<TELL " with a stout bar to lock it">
				)
			>
			<TELL "." CR>
		)
		(<VERB? OPEN>
			<COND
				(<FSET? ,LG-KITCHEN-DOOR ,FL-OPEN>
					<TELL The ,LG-KITCHEN-DOOR " is already open." CR>
				)
				(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
					<RT-ANIMAL-CANT-MSG>
				)
				(<AND <FSET? ,LG-KITCHEN-DOOR ,FL-LOCKED>
						<MC-HERE? ,RM-PARADE-AREA>
					>
					<TELL
"You rattle" the ,LG-KITCHEN-DOOR " for a few moments, but it refuses
to open. It must be barred from the other side." CR
					>
				)
				(T
					<FSET ,LG-KITCHEN-DOOR ,FL-OPEN>
					<RT-CHECK-ADJ ,LG-KITCHEN-DOOR>
					<TELL "You ">
					<COND
						(<FSET? ,LG-KITCHEN-DOOR ,FL-LOCKED>
							<FCLEAR ,LG-KITCHEN-DOOR ,FL-LOCKED>
							<TELL "lift the bar and ">
						)
					>
					<TELL "open" the ,LG-KITCHEN-DOOR "." CR>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>
							<RT-UPDATE-MAP-WINDOW>
						)
					>
					<RTRUE>
				)
			>
		)
		(<VERB? CLOSE>
			<COND
				(<NOT <FSET? ,LG-KITCHEN-DOOR ,FL-OPEN>>
					<TELL The ,LG-KITCHEN-DOOR " is already closed." CR>
				)
				(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
					<RT-ANIMAL-CANT-MSG>
				)
				(T
					<FCLEAR ,LG-KITCHEN-DOOR ,FL-OPEN>
					<RT-CHECK-ADJ ,LG-KITCHEN-DOOR>
					<TELL "You close" the ,LG-KITCHEN-DOOR "." CR>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>
							<RT-UPDATE-MAP-WINDOW>
						)
					>
					<RTRUE>
				)
			>				
		)
		(<VERB? LOCK>
			<COND
				(<NOT <MC-VERB-WORD? ,W?BAR>>
					<RT-NO-KEYHOLE-MSG ,LG-KITCHEN-DOOR>
				)
				(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
					<RT-ANIMAL-CANT-MSG>
				)
				(<MC-HERE? ,RM-PARADE-AREA>
					<TELL "There is no bar on this side." CR>
				)
				(<FSET? ,LG-KITCHEN-DOOR ,FL-LOCKED>
					<TELL The ,LG-KITCHEN-DOOR " is already barred." CR>
				)
				(<AND <EQUAL? ,P-PRSA-WORD ,W?BAR>
						<NOT <MC-PRSI? ,ROOMS>>
					>
					<TELL
The ,WINNER " can't bar" the ,LG-KITCHEN-DOOR " with" the ,PRSI "." CR
					>
				)
				(T
					<TELL "You ">
					<COND
						(<FSET? ,LG-KITCHEN-DOOR ,FL-OPEN>
							<FCLEAR ,LG-KITCHEN-DOOR ,FL-OPEN>
							<RT-CHECK-ADJ ,LG-KITCHEN-DOOR>
							<TELL "close and ">
						)
					>
					<FSET ,LG-KITCHEN-DOOR ,FL-LOCKED>
					<TELL "bar" the ,LG-KITCHEN-DOOR "." CR>
				)
			>
		)
		(<VERB? UNLOCK>
			<COND
				(<NOT <MC-VERB-WORD? ,W?UNBAR>>
					<RT-NO-KEYHOLE-MSG ,LG-KITCHEN-DOOR>
				)
				(<NOT <FSET? ,LG-KITCHEN-DOOR ,FL-LOCKED>>
					<TELL The ,LG-KITCHEN-DOOR " is already un-barred." CR>
				)
				(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
					<RT-ANIMAL-CANT-MSG>
				)
				(T
					<FCLEAR ,LG-KITCHEN-DOOR ,FL-LOCKED>
					<TELL "You lift the bar." CR>
				)
			>
		)
	>
>

<ROUTINE RT-NO-KEYHOLE-MSG ("OPT" (DOOR <>))
	<COND
		(<NOT .DOOR>
			<SET DOOR ,PRSO>
		)
	>
	<TELL The+verb .DOOR "have" " no keyhole. You will have to ">
	<COND
		(<VERB? LOCK>
			<TELL "lower">
		)
		(T
			<TELL "raise">
		)
	>
	<TELL " the bar." CR>
>

;"---------------------------------------------------------------------------"
; "RM-SMALL-CHAMBER"
;"---------------------------------------------------------------------------"

<ROOM RM-SMALL-CHAMBER
   (LOC ROOMS)
   (DESC "small chamber")
   (FLAGS FL-INDOORS FL-LIGHTED)
   (SYNONYM CHAMBER)
   (ADJECTIVE SMALL)
   (EAST PER RT-EXIT-CHAMBER)
   (IN PER RT-EXIT-CHAMBER)
   (WEST TO RM-END-OF-HALL)
   (OUT TO RM-END-OF-HALL)
	(GLOBAL LG-BADGER-TAPESTRY LG-WALL RM-PASSAGE-1 RM-END-OF-HALL)
   (ACTION RT-RM-SMALL-CHAMBER)
	(THINGS
		<> (CHAIR CHAIRS) RT-PS-CHAIRS
	)
>

<ROUTINE RT-RM-SMALL-CHAMBER ("OPT" (CONTEXT <>))
   <COND
      (<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,LG-BADGER-TAPESTRY ,FL-SEEN>
         <TELL
"You are in" a ,RM-SMALL-CHAMBER " that looks oddly out of place in this
underground prison. Its rich furnishings include a fine stonework floor,
comfortable chairs, and a beautifully woven tapestry on the wall. It looks
like a king's secret consultation chamber.|"
			>
         <RFALSE>
      )
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-SMALL-CHAMBER>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<VERB? YELL>
					<COND
						(<MC-FORM? ,K-FORM-ARTHUR>
							<RT-CALL-GUARD>
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

<ROUTINE RT-EXIT-CHAMBER ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<COND
				(<NOT <FSET? ,LG-BADGER-TAPESTRY ,FL-LOCKED>>
				   <RETURN ,RM-PASSAGE-1>
				)
			>
		)
		(<FSET? ,LG-BADGER-TAPESTRY ,FL-LOCKED>
			<RT-YOU-CANT-MSG "go">
			<RFALSE>
		)
		(T
		   <RETURN ,RM-PASSAGE-1>
		)
	>
>

<ROUTINE RT-PS-CHAIRS ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
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
					<TELL "chairs">
				)
			>
		)
		(<VERB? EXAMINE LOOK-ON>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<TELL "The chairs look soft and cozy." CR>
		)
		(<VERB? SIT ENTER>
			<TELL
"You settle into one of the chairs for a few moments, and then leap up again,
nervous that someone might come in." CR
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "LG-BADGER-TAPESTRY"
;"---------------------------------------------------------------------------"

<OBJECT LG-BADGER-TAPESTRY
	(LOC LOCAL-GLOBALS)
	(DESC "tapestry")
	(FLAGS FL-LOCKED)
	(SYNONYM TAPESTRY CLOTH)
	(ADJECTIVE HANGING BIG UGLY)
	(ACTION RT-LG-BADGER-TAPESTRY)
>

; "LG-BADGER-TAPESTRY flags:"
; "	FL-LOCKED - Player hasn't seen passage behind tapestry"

<ROUTINE RT-LG-BADGER-TAPESTRY ("OPT" (CONTEXT <>))
	<COND
		(<VERB? EXAMINE>
			<FSET ,LG-BADGER-TAPESTRY ,FL-SEEN>
			<COND
				(<MC-HERE? ,RM-PASSAGE-1>
					<TELL "It's hard to tell from the back, but it looks like">
				)
				(T
					<TELL The ,LG-BADGER-TAPESTRY " is">
				)
			>
			<TELL
" a hunting scene of men in armour mercilessly hunting down badgers." CR
			>
		)
		(<VERB? MOVE LOOK-BEHIND>
			<FCLEAR ,LG-BADGER-TAPESTRY ,FL-LOCKED>
			<TELL "Behind the tapestry is">
			<COND
				(<MC-HERE? ,RM-SMALL-CHAMBER>
					<TELL a ,RM-PASSAGE-1>
				)
				(T
					<TELL a ,RM-SMALL-CHAMBER>
				)
			>
			<TELL "." CR>
			<COND
				(<MC-HERE? ,RM-SMALL-CHAMBER>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>
							<RT-UPDATE-MAP-WINDOW>
						)
					>
				)
			>
			<RTRUE>
		)
		(<VERB? HIDE-BEHIND>
			<COND
				(<FSET? ,LG-BADGER-TAPESTRY ,FL-LOCKED>
					<FCLEAR ,LG-BADGER-TAPESTRY ,FL-LOCKED>
					<TELL
"You pull back the tapestry and discover a hidden passage! Cautiously, you
feel your way into the darkness.||"
					>
				)
			>
			<COND
				(<MC-HERE? ,RM-SMALL-CHAMBER>
					<RT-DO-WALK ,P?EAST>
				)
				(T
					<RT-DO-WALK ,P?WEST>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-END-OF-HALL"
;"---------------------------------------------------------------------------"

<ROOM RM-END-OF-HALL
   (LOC ROOMS)
   (DESC "end of hall")
   (FLAGS FL-INDOORS FL-LIGHTED)
   (SYNONYM HALL)
   (ADJECTIVE END)
   (EAST TO RM-SMALL-CHAMBER)
   (WEST TO RM-HALL)
   (IN TO RM-SMALL-CHAMBER)
	(GLOBAL LG-WALL RM-SMALL-CHAMBER)
   (ACTION RT-RM-END-OF-HALL)
>

<ROUTINE RT-RM-END-OF-HALL ("OPT" (CONTEXT <>))
   <COND
      (<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,RM-SMALL-CHAMBER ,FL-SEEN>
         <TELL
"You are at the end of an underground corridor that runs east and west. To
the east is" a ,RM-SMALL-CHAMBER "." CR
         >
         <RFALSE>
      )
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-HALL>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<VERB? YELL>
					<COND
						(<MC-FORM? ,K-FORM-ARTHUR>
							<RT-CALL-GUARD>
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
; "RM-HALL"
;"---------------------------------------------------------------------------"

<ROOM RM-HALL
   (LOC ROOMS)
   (DESC "hall")
   (FLAGS FL-INDOORS FL-LIGHTED)
   (SYNONYM HALL)
   (EAST TO RM-END-OF-HALL)
   (WEST TO RM-BOTTOM-OF-STAIRS)
   (SOUTH TO RM-CELL IF LG-CELL-DOOR IS OPEN)
   (IN TO RM-CELL IF LG-CELL-DOOR IS OPEN)
	(ADJACENT <TABLE (LENGTH BYTE) RM-CELL <>>)
   (GLOBAL LG-CELL-DOOR LG-WALL RM-CELL)
   (ACTION RT-RM-HALL)
>

<ROUTINE RT-RM-HALL ("OPT" (CONTEXT <>))
   <COND
      (<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,LG-CELL-DOOR ,FL-SEEN>
         <TELL
"You are in an underground corridor that runs east and west. To the south is
the door to a cell.|"
         >
         <RFALSE>
      )
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-HALL>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<VERB? YELL>
					<COND
						(<MC-FORM? ,K-FORM-ARTHUR>
							<RT-CALL-GUARD>
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
; "RM-BOTTOM-OF-STAIRS"
;"---------------------------------------------------------------------------"

<ROOM RM-BOTTOM-OF-STAIRS
   (LOC ROOMS)
   (DESC "bottom of stairs")
   (FLAGS FL-INDOORS FL-LIGHTED)
   (EAST TO RM-HALL)
   (WEST PER RT-EXIT-STAIRS)
   (UP PER RT-EXIT-STAIRS)
	(GLOBAL LG-WALL LG-STAIRS CH-CELL-GUARD)
   (ACTION RT-RM-BOTTOM-OF-STAIRS)
>

<ROUTINE RT-RM-BOTTOM-OF-STAIRS ("OPT" (CONTEXT <>))
   <COND
      (<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
         <TELL
"You are at the west end of an underground corridor, at the bottom of a long
flight of stairs. At the top, you see a soldier standing guard. To
go up would mean certain capture.|"
         >
         <RFALSE>
      )
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-HALL>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<VERB? YELL>
					<COND
						(<MC-FORM? ,K-FORM-ARTHUR>
							<RT-CALL-GUARD>
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

<ROUTINE RT-EXIT-STAIRS ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<RFALSE>
		)
		(<MC-FORM? ,K-FORM-ARTHUR>
			<TELL
"You steal up the stairs as quietly as you can, but the soldier sees you
immediately. He quickly overpowers you and drags you back down into the
dungeon and puts you in chains.|"
			>
			<RT-END-OF-GAME>
		)
		(T
			<TELL
"As soon as you reach the top of the stairs, the guard notices you and
says," ,K-LOVERLY-MSG form ,K-SKEWER-MSG
			>
			<RT-END-OF-GAME>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-ARMOURY"
;"---------------------------------------------------------------------------"

<ROOM RM-ARMOURY
   (LOC ROOMS)
   (DESC "armoury")
   (FLAGS FL-INDOORS FL-LIGHTED)
   (SYNONYM ARMOURY ARMORY)
   (NORTH TO RM-PARADE-AREA)
   (OUT TO RM-PARADE-AREA)
	(GLOBAL LG-WALL)
   (ACTION RT-RM-ARMOURY)
	(THINGS
		<> (SHIELD SHIELDS) RT-PS-SHIELDS
		PIKE (PIKESTAFFS STAFF STAFFS PIKE PIKES) RT-PS-PIKESTAFFS
	)
>

<ROUTINE RT-RM-ARMOURY ("OPT" (CONTEXT <>))
   <COND
      (<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "You are in">
				)
				(T
					<TELL "You have entered">
				)
			>
			<TELL
" a deserted armoury. A few shields are fixed to the wall, and some
pikestaffs are locked up as well. A broken dagger lies on the table
awaiting the armourer's attention, but right now it's worthless."
			>
			<COND
				(<MC-CONTEXT? ,M-F-LOOK>
					<FCLEAR ,TH-ARMOUR ,FL-NO-DESC>
					<FCLEAR ,TH-SHIELD ,FL-NO-DESC>
					<FSET ,TH-ARMOUR ,FL-SEEN>
					<FSET ,TH-SHIELD ,FL-SEEN>
					<TELL
" The only things not broken or locked down are a tarnished shield and
some armour that lie in the corner." CR
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
			<SETG GL-PICTURE-NUM ,K-PIC-ARMOURY>
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

<ROUTINE RT-PS-SHIELDS ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
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
					<TELL "shields">
				)
			>
		)
		(<VERB? EXAMINE LOOK-IN LOOK-ON TAKE>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<TELL "The shields are fastened firmly to the wall." CR>
		)
	>
>

<ROUTINE RT-PS-PIKESTAFFS ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
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
					<TELL "pikestaffs">
				)
			>
		)
		(<VERB? EXAMINE TAKE>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<TELL "The pikestaffs are securely locked down." CR>
		)
		(<VERB? UNLOCK>
			<TELL The ,WINNER " can't unlock the pikestaffs." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-ARMOURY-TABLE"
;"---------------------------------------------------------------------------"

<OBJECT TH-ARMOURY-TABLE
	(LOC RM-ARMOURY)
	(DESC "armoury table")
	(FLAGS FL-NO-LIST FL-SEARCH FL-SURFACE)
	(SYNONYM TABLE)
	(ADJECTIVE ARMOURY ARMORY WOODEN)
	(CAPACITY 50)
	(ACTION RT-TH-ARMOURY-TABLE)
>

<ROUTINE RT-TH-ARMOURY-TABLE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? CLIMB-UP CLIMB-ON CLIMB-OVER>
			<RT-AUTHOR-ON>
			<TELL "It's not polite to " vw " on tables.">
			<RT-AUTHOR-OFF>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-BROKEN-DAGGER"
;"---------------------------------------------------------------------------"

<OBJECT TH-BROKEN-DAGGER
	(LOC TH-ARMOURY-TABLE)
	(DESC "dagger")
	(FLAGS FL-NO-LIST FL-TRY-TAKE)
	(SYNONYM DAGGER KNIFE)
	(ADJECTIVE BROKEN)
	(ACTION RT-TH-BROKEN-DAGGER)
>

<ROUTINE RT-TH-BROKEN-DAGGER ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<TELL "The dagger is broken and quite useless." CR>
		)
		(<VERB? TAKE>
			<TELL
"You pick up the broken pieces and examine them. Realizing that they
could be of no possible use to anyone, you put them back down and turn your
attention elsewhere." CR
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "LG-CASTLE"
;"---------------------------------------------------------------------------"

<OBJECT LG-CASTLE
	(LOC LOCAL-GLOBALS)
	(DESC "castle")
	(SYNONYM CASTLE FORT FORTRESS)
	(OWNER CH-LOT)
	(ACTION RT-LG-CASTLE)
>

<ROUTINE RT-LG-CASTLE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<AND <VERB? ENTER>
				<MC-HERE? ,RM-CASTLE-GATE>
			>
			<RT-DO-WALK ,P?EAST>
		)
		(<AND <VERB? EXIT>
				<MC-HERE? ,RM-PARADE-AREA>
			>
			<RT-DO-WALK ,P?WEST>
		)
		(<VERB? EXAMINE>
			<FSET ,LG-CASTLE ,FL-SEEN>
			<TELL
"It's a centuries-old fort built during the Roman occupation of Britain. It
has fallen into considerable disrepair since the legions left, although King
Lot has tried to preserve its crumbling walls." CR
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-ABOVE-CASTLE"
;"---------------------------------------------------------------------------"

<ROOM RM-ABOVE-CASTLE
	(LOC ROOMS)
	(DESC "above the castle")
	(FLAGS FL-AIR FL-LIGHTED)
	(DOWN PER RT-FLY-DOWN)
	(WEST TO RM-ABOVE-TOWN)
	(NORTH TO RM-ABOVE-BOG)
	(NW TO RM-ABOVE-MOOR)
	(NE TO RM-ABOVE-FORD)
	(UP SORRY K-NO-HIGHER-MSG)
	(GLOBAL RM-PARADE-AREA RM-ARMOURY RM-GREAT-HALL RM-CAS-KITCHEN LG-CASTLE)
	(ACTION RT-RM-ABOVE-CASTLE)
>

<ROUTINE RT-RM-ABOVE-CASTLE ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,RM-BOG ,FL-SEEN>
			<FSET ,LG-TOWN ,FL-SEEN>
			<FSET ,LG-CASTLE ,FL-SEEN>
			<TELL
"You are hovering over the castle. Below you to the north you see a patch
of fog. To the northeast you see a road emerge from the fog and come to a
ford in the river. Flying to the northwest would put you over the moor. To
the west you see the roofs of the town.|"
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

