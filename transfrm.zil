;"***************************************************************************"
; "game : Arthur"
; "file : TRANSFRM.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   12 May 1989  0:41:52  $"
; "revs : $Revision:   1.68  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Transformation"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "Transmogrification verbs."
;"---------------------------------------------------------------------------"

<CONSTANT K-FORM-ARTHUR			0>
<CONSTANT K-FORM-OWL				1>
<CONSTANT K-FORM-BADGER			2>
<CONSTANT K-FORM-SALAMANDER	3>
<CONSTANT K-FORM-TURTLE			4>
<CONSTANT K-FORM-EEL				5>
<GLOBAL GL-PLAYER-FORM ,K-FORM-ARTHUR <> BYTE>
<GLOBAL GL-OLD-FORM 0 <> BYTE>
<GLOBAL GL-FORM-ABORT <> <> BYTE>

<CONSTANT K-NUM-CHANGE-TBL <TABLE (BYTE) 0 0 0 0 0 0>>

<ROUTINE RT-FORM-MSG ("OPT" (ART <>) (CAP? <>) "AUX" (MASK 0) (M2 32) N)
	<COND
		(<NOT .CAP?>
			<TELL " ">
			<SET MASK 32>
		)
		(<NOT .ART>
			<SET M2 0>
		)
	>
	<COND
		(.ART
			<COND
				(<EQUAL? .ART ,K-ART-A>
					<TELL C <BOR !\A .MASK>>
					<COND
						(<MC-FORM? ,K-FORM-EEL ,K-FORM-OWL>
							<TELL "n">
						)
					>
				)
			>
			<TELL " ">
		)
	>
	<COND
		(<MC-FORM? ,K-FORM-ARTHUR>
			<TELL C <BOR !\B .M2> "oy">
		)
		(<MC-FORM? ,K-FORM-OWL>
			<TELL C <BOR !\O .M2> "wl">
		)
		(<MC-FORM? ,K-FORM-BADGER>
			<TELL C <BOR !\B .M2> "adger">
		)
		(<MC-FORM? ,K-FORM-SALAMANDER>
			<TELL C <BOR !\S .M2> "alamander">
		)
		(<MC-FORM? ,K-FORM-TURTLE>
			<TELL C <BOR !\T .M2> "urtle">
		)
		(<MC-FORM? ,K-FORM-EEL>
			<TELL C <BOR !\E .M2> "el">
		)
	>
>

<ROUTINE RT-FORM-TYPE-MSG ("OPT" (CAP? <>) "AUX" (MASK 0))
	<COND
		(<NOT .CAP?>
			<TELL " ">
			<SET MASK 32>
		)
	>
	<COND
		(<MC-FORM? ,K-FORM-ARTHUR>
			<TELL C <BOR !\H .MASK> "uman">
		)
		(<MC-FORM? ,K-FORM-OWL>
			<TELL C <BOR !\A .MASK> "vian">
		)
		(<MC-FORM? ,K-FORM-BADGER>
			<TELL C <BOR !\M .MASK> "ustelid">
		)
		(<MC-FORM? ,K-FORM-SALAMANDER>
			<TELL C <BOR !\R .MASK> "eptilian">
		)
		(<MC-FORM? ,K-FORM-TURTLE>
			<TELL C <BOR !\T .MASK> "estudinal">
		)
		(<MC-FORM? ,K-FORM-EEL>
			<TELL C <BOR !\A .MASK> "nguillian">
		)
	>
>

<ROUTINE RT-ANIMAL-CANT-MSG ("OPT" (STR <>) (OBJ <>) "AUX" SIZE)
	<COND
		(<AND <NOT .OBJ>
				<NOT <EQUAL? ,PRSO ,ROOMS>>
			>
			<SET OBJ ,PRSO>
		)
	>
	<COND
		(<VERB? TAKE>
			<COND
				(<MC-FORM? ,K-FORM-EEL ,K-FORM-TURTLE ,K-FORM-SALAMANDER>
					<RT-TAKE-WITH-MSG .OBJ ,TH-MOUTH>
				)
				(T
					<RT-TAKE-WITH-MSG .OBJ ,TH-HANDS>
				)
			>
		)
		(T
			<TELL "You can't ">
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
				(.OBJ
					<TELL the .OBJ>
				)
			>
			<TELL ". You are" aform "." CR>
		)
	>
>

; "Place for storing player's clothes when an animal."
<OBJECT TH-CLOTHES-BIN>

<CONSTANT K-WOULD-DROWN-MSG "You would drown.|">
<CONSTANT K-RESTORED-GAME-MSG "Playing a restored game, are we?">
<CONSTANT K-NOTHING-HAPPENS-MSG "Nothing happens.">
<CONSTANT K-CLOTHES-REAPPEAR-MSG
"Everything you were wearing magically reappears in its place.">

<SYNTAX CYR OBJECT (FIND FL-ROOMS) (EVERYWHERE) = V-TRANSFORM>

<ROUTINE V-TRANSFORM ("OPT" (WORD <>) "AUX" (FORM <>) (C <>) M N L A?)
	<SETG GL-OLD-FORM ,GL-PLAYER-FORM>
	<SETG GL-FORM-ABORT <>>
	<COND
		(<MC-PRSO? ,ROOMS>
			<SETUP-ORPHAN "cyr ">
			<RT-AUTHOR-MSG "What shape do you want to assume?">
			<RTRUE>
		)
		(<NOT <FSET? ,CH-PLAYER ,FL-LOCKED>>
			<TELL ,K-NOTHING-HAPPENS-MSG CR>
			<SETG GL-QUESTION 1>
			<RT-AUTHOR-MSG ,K-RESTORED-GAME-MSG>
			<RTRUE>
		)
		(<INTBL? ,HERE <ZREST ,K-DEMON-DOMAIN-TBL 1> <GETB ,K-DEMON-DOMAIN-TBL 0> 1>
			<TELL ,K-NOTHING-HAPPENS-MSG CR>
			<RTRUE>
		)
		(<NOUN-USED? ,PRSO ,W?OWL ,W?BIRD>
			<SET FORM ,K-FORM-OWL>
		)
		(<NOUN-USED? ,PRSO ,W?BADGER>
			<SET FORM ,K-FORM-BADGER>
		)
		(<NOUN-USED? ,PRSO ,W?SALAMANDER>
			<SET FORM ,K-FORM-SALAMANDER>
		)
		(<NOUN-USED? ,PRSO ,W?TURTLE>
			<SET FORM ,K-FORM-TURTLE>
		)
		(<NOUN-USED? ,PRSO ,W?EEL>
			<SET FORM ,K-FORM-EEL>
		)
		(<MC-PRSO? ,CH-PLAYER>
			<SET FORM ,K-FORM-ARTHUR>
		)
		(T
			<TELL
,K-MERLIN-ECHOES-MSG "\"Only the owl, turtle, eel, salamander, and badger...\"" CR
			>
			<RTRUE>
		)
	>
	<COND
		(<MC-FORM? .FORM>
			<RT-ALREADY-MSG ,CH-PLAYER>
			<TELL aform ".">
			<RT-AUTHOR-OFF>
		)
		(<AND <NOT <MC-FORM? ,K-FORM-ARTHUR>>
				<NOT <EQUAL? .FORM ,K-FORM-ARTHUR>>
			>
			<TELL
,K-MERLIN-ECHOES-MSG "\"You cannot move directly from one foreign shape to
another...\"" CR
			>
		)
		(<AND <EQUAL? .FORM ,K-FORM-ARTHUR>
				<FSET? ,HERE ,FL-AIR>
			>
			<SETG GL-FORM-ABORT T>
			<TELL
"You begin the transformation and suddenly begin to lose altitude. Rather than
waiting to smash into the ground like a rotten pumpkin, you wisely revert to
your avian form and continue flying." CR
			>
		)
		(<AND <OR
					<FSET? ,HERE ,FL-WATER>
					<AND
						<IN? ,CH-PLAYER ,TH-BARREL>
						<IN? ,TH-BARREL-WATER ,TH-BARREL>
					>
				>
				<OR
					<EQUAL? .FORM ,K-FORM-BADGER ,K-FORM-SALAMANDER ,K-FORM-OWL>
					<AND
						<EQUAL? .FORM ,K-FORM-ARTHUR>
						<NOT <MC-HERE? ,RM-SHALLOWS ,RM-FORD ,RM-CAS-KITCHEN>>
					>
				>
			>
			<SETG GL-FORM-ABORT T>
			<TELL
"You make the change, but after thrashing around for a few moments, you
suddenly realize that you can't breathe underwater, and you quickly revert
to your" formtype " form." CR
			>
		)
		(<AND <EQUAL? .FORM ,K-FORM-ARTHUR>
				<MC-HERE? ,RM-HOLE ,RM-BADGER-TUNNEL>
			>
			<SETG GL-FORM-ABORT T>
			<TELL
"You start the transformation back into a human. You suddenly realize that
you are still in a narrow tunnel, and you quickly revert to your" formtype
" form. Had you actually made the change and lived, you would have gone
through life looking like a very long sausage-roll." CR
			>
		)
		(<AND <EQUAL? .FORM ,K-FORM-ARTHUR>
				<MC-HERE? ,RM-THORNEY-ISLAND>
			>
			<SETG GL-FORM-ABORT T>
			<TELL
"As you begin to change back to human form, your body begins to press up
against the sharp thorns that surround you. Suddenly you realize that
there is not enough room for you to complete the change, and you quickly
revert to your" formtype " form. Had you actually made the change and lived,
you would have gone through life looking like a very large pin cushion." CR
			>
		)
		(<AND <EQUAL? .FORM ,K-FORM-ARTHUR>
				<IN? ,TH-BRACELET ,CH-PLAYER>
			>
			<SETG GL-FORM-ABORT T>
			<TELL
"As your neck begins to expand to it's normal size," the ,TH-BRACELET
" begins to throttle you, and you quickly revert to your" formtype " form." CR
			>
		)
		(<AND <EQUAL? .FORM ,K-FORM-EEL>
				<NOT <FSET? ,HERE ,FL-WATER>>
				<OR
					<NOT <IN? ,CH-PLAYER ,TH-BARREL>>
					<NOT <IN? ,TH-BARREL-WATER ,TH-BARREL>>
				>
			>
			<SETG GL-FORM-ABORT T>
			<TELL
"You start the transformation into an eel, but when you try to breathe, your
gills fill with dust instead of water. After writhing around in agony for a
few moments, you quickly revert to your human form." CR
			>
		)
		(T
			<COND
				(<FSET? ,TH-HEAD ,FL-LOCKED>
					<FCLEAR ,TH-HEAD ,FL-LOCKED>
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
			<FCLEAR ,TH-LEGS ,FL-LOCKED>
			<COND
				(<EQUAL? .FORM ,K-FORM-EEL ,K-FORM-SALAMANDER ,K-FORM-TURTLE>
					<FCLEAR ,TH-HANDS ,FL-BY-HAND>
					<FCLEAR ,TH-HANDS ,FL-WEAPON>
					<FSET ,TH-MOUTH ,FL-BY-HAND>
					<FSET ,TH-MOUTH ,FL-WEAPON>
				)
				(T
					<FCLEAR ,TH-MOUTH ,FL-BY-HAND>
					<FCLEAR ,TH-MOUTH ,FL-WEAPON>
					<FSET ,TH-HANDS ,FL-BY-HAND>
					<FSET ,TH-HANDS ,FL-WEAPON>
				)
			>
			<COND
				(<EQUAL? .FORM ,K-FORM-ARTHUR>
					<FCLEAR ,TH-CRYSTAL ,FL-LOCKED>
				)
				(T
					<FSET ,TH-CRYSTAL ,FL-LOCKED>
				)
			>

			<SET M <GETB ,K-NUM-CHANGE-TBL ,GL-PLAYER-FORM>>
			<SETG GL-PLAYER-FORM .FORM>
			<PUTB ,K-NUM-CHANGE-TBL .FORM
				<SET N <+ <GETB ,K-NUM-CHANGE-TBL .FORM> 1>>
			>
			<COND
				(<MC-FORM? ,K-FORM-ARTHUR>
					<COND
						(<SET C <RT-MOVE-ALL ,TH-CLOTHES-BIN ,CH-PLAYER>>
							<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT>>
						)
					>
				)
				(T
					<SET L <LOC ,CH-PLAYER>>
					<COND
						(<MC-HERE? ,RM-BOG>
							<SET L <>>
						)
						(<EQUAL? .L ,TH-HORSE>
							<SET L <LOC .L>>
						)
					>
					<COND
						(<IN? ,TH-APPLE ,CH-PLAYER>
							<SET A? T>
						)
					>
					<COND
						(<RT-MOVE-ALL-BUT-WORN ,CH-PLAYER .L>
							<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT ,K-UPD-OBJS>>
							<TELL "Everything you are carrying falls">
							<COND
								(<IN? .L ,ROOMS>
									<TELL " to" the ,TH-GROUND>
								)
								(T
									<TELL in .L "to" the .L>
								)
							>
							<COND
								(<MC-HERE? ,RM-BOG>
									<TELL " and sinks into the mire">
								)
							>
							<TELL ". ">
							<COND
								(<OR	<FSET? .L ,FL-WATER>
										<AND
											<EQUAL? .L ,TH-BARREL>
											<IN? ,TH-BARREL-WATER ,TH-BARREL>
										>
									>
									<TELL
"Fortunately, it doesn't look as if the water will cause any damage. "
									>
								)
							>
							<COND
								(<AND .A? <EQUAL? .L ,RM-FORD>>
									<MOVE ,TH-APPLE ,RM-SHALLOWS>
									<TELL
"The apple quickly floats down the river and out of sight. "
									>
								)
							>
						)
					>
					<COND
						(<SET C <RT-MOVE-ALL ,CH-PLAYER ,TH-CLOTHES-BIN>>
							<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT>>
						)
					>
				)
			>
			<COND
				(<EQUAL? .N 1>
					<COND
						(<MC-FORM? ,K-FORM-ARTHUR>
							<TELL "Poof! You regain your human form.">
							<COND
								(.C
									<TELL CR CR ,K-CLOTHES-REAPPEAR-MSG>
								)
							>
						)
						(<MC-FORM? ,K-FORM-OWL>
							<TELL
"You feel yourself becoming smaller. Your feet become talons, your arms
become wings, your eyes are suddenly sharper. You are no longer wearing
anything, and your entire body is covered with feathers."
							>
						)
						(<MC-FORM? ,K-FORM-BADGER>
							<TELL
"You feel your body get smaller. You are no longer wearing anything, and your
entire body is covered with stiff bristles. Your hands and feet turn into
powerful claws."
							>
						)
						(<MC-FORM? ,K-FORM-SALAMANDER>
							<TELL
"You feel yourself shrinking. You are no longer wearing anything, and your
skin has become quite leathery. A tail sprouts out behind you, and you find
yourself crawling around on all fours."
							>
						)
						(<MC-FORM? ,K-FORM-TURTLE>
							<TELL
"You feel yourself getting smaller. Your skin becomes wrinkled, and your back
hardens into a tough shell. You have become a turtle."
							>
						)
						(<MC-FORM? ,K-FORM-EEL>
							<TELL
"Your body gets smaller, and your arms and legs disappear. You are no longer
wearing anything, and you start breathing through your newly-formed gills
instead of your mouth."
							>
							<COND
								(<OR	<FSET? ,HERE ,FL-WATER>
										<AND
											<IN? ,CH-PLAYER ,TH-BARREL>
											<IN? ,TH-BARREL-WATER ,TH-BARREL>
										>
									>
									<TELL
" You find that you are quite comfortable swimming around in the water."
									>
								)
							>
						)
					>
					<CRLF>
					<COND
						(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
							<RT-SCORE-MSG 0 0 3 1>
						)
					>
				)
				(T
					<TELL "Poof! You regain your" formtype " form." CR>
					<COND
						(<MC-FORM? ,K-FORM-ARTHUR>
							<COND
								(.C
									<COND
										(<EQUAL? .M 1>
											<TELL CR ,K-CLOTHES-REAPPEAR-MSG CR>
										)
									>
								)
							>
						)
					>
				)
			>
			<COND
				(<EQUAL? .FORM ,K-FORM-OWL>
					<FSET ,HERE ,FL-SEEN>
					<FSET ,CH-PLAYER ,FL-LIGHTED>
				)
				(T
					<FCLEAR ,CH-PLAYER ,FL-LIGHTED>
				)
			>
			<SETG LIT <LIT?>>
			<COND
				(<FSET? ,HERE ,FL-WATER>
					<COND
						(<EQUAL? .FORM ,K-FORM-EEL ,K-FORM-TURTLE>
							<SETG GL-PICTURE-NUM ,K-PIC-UNDERWATER>
							<COND
								(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
									<RT-UPDATE-PICT-WINDOW>
								)
							>
						)
						(<EQUAL? .FORM ,K-FORM-ARTHUR>
							<COND
								(<EQUAL? ,GL-OLD-FORM ,K-FORM-EEL ,K-FORM-TURTLE>
									<COND
										(<MC-HERE? ,RM-SHALLOWS>
											<SETG GL-PICTURE-NUM ,K-PIC-SHALLOWS>
										)
										(<MC-HERE? ,RM-FORD>
											<SETG GL-PICTURE-NUM ,K-PIC-FORD>
										)
									>
									<COND
										(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
											<RT-UPDATE-PICT-WINDOW>
										)
									>
								)
							>
						)
					>
				)
			>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>
					<COND
						(<OR	<MC-HERE? ,RM-SHALLOWS ,RM-FIELD-OF-HONOUR ,RM-FORD
									,RM-WEST-OF-FORD ,RM-EAST-OF-FORD
								>
								<AND
									<EQUAL? ,K-FORM-OWL .FORM ,GL-OLD-FORM>
									<NOT <FSET? ,HERE ,FL-INDOORS>>
								>
							>
							<RT-UPDATE-MAP-WINDOW>
						)
					>
				)
			>
			<COND
				(<AND <EQUAL? .FORM ,K-FORM-ARTHUR>
						<IN? ,TH-HAWTHORN ,CH-PLAYER>
					>
					<SETG GL-UPDATE-WINDOW
						<BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT ,K-UPD-OBJS>
					>
					<MOVE ,TH-HAWTHORN ,HERE>
					<FCLEAR ,TH-HAWTHORN ,FL-WORN>
					<PUTP ,TH-HAWTHORN ,P?SCORE <LSH 1 ,K-QUEST-SHIFT>>
					<TELL
CR The+verb ,TH-HAWTHORN "fall" " to" the ,TH-GROUND "." CR
					>
				)
			>
			<COND
				(<IN? ,CH-PRISONER ,HERE>
					<CRLF>
					<COND
						(<FSET? ,CH-PRISONER ,FL-BROKEN>
							<TELL
The ,CH-PRISONER " once again recoils in shock at your sudden transformation,
but makes no comment." CR
							>
						)
						(T
							<FSET ,CH-PRISONER ,FL-BROKEN>
							<TELL
The ,CH-PRISONER " cowers against the wall. One of his hands makes the sign
against evil magic, and he says, \"Take pity on me, oh enchanted one. I am
but a humble craftsman who was commissioned by the King to fashion a sword
after the enchanted sword in the stone. No sooner had I complied with his
request but he threw me in the dungeon.\"" CR
							>
						)
					>
				)
			>
		)
	>
	<RTRUE>
>

<SYNTAX CYR JONES OBJECT (FIND FL-ROOMS) = V-CYR-JONES>
<SYNTAX CYR-JONES OBJECT (FIND FL-ROOMS) = V-CYR-JONES>

<ROUTINE V-CYR-JONES ()
	<COND
		(<NOT <MC-PRSO? ,ROOMS>>
			<DONT-UNDERSTAND>
		)
		(T
			<TELL
"For a brief moment you assume the form of the lovely and talented former
goddess of testing, but then the magic fades and you return to your previous,
less exciting, existence." CR
			>
		)
	>
>

<GLOBAL GL-TAKEOFF-ROOM:OBJECT <> <> BYTE>

<CONSTANT K-NO-HIGHER-MSG "Your wings won't carry you any higher.">

<ROUTINE RT-FLY-UP ("OPT" (QUIET <>) "AUX" (RM <>))
	<COND
	;	(.QUIET
			<RFALSE>
		)
		(<MC-FORM? ,K-FORM-OWL>
			<COND
				(<NOT .QUIET>
					<RT-CLEAR-PUPPY>
				)
			>
			<COND
				(<MC-HERE?
						,RM-TOWN-SQUARE
						,RM-TOWN-GATE
						,RM-VILLAGE-GREEN
						,RM-CHURCHYARD
						,RM-SMITHY
						,RM-CASTLE-GATE
					>
					<SET RM ,RM-ABOVE-TOWN>
				)
				(<MC-HERE? ,RM-PARADE-AREA>
					<COND
						(<AND <NOT <FSET? ,CH-PRISONER ,FL-LOCKED>>
								<FSET? ,TH-SWORD ,FL-LOCKED>
								<NOT .QUIET>
							>
							<MOVE ,CH-MERLIN ,HERE>
							<TELL ,K-MERLIN-PRISONER-MSG CR>
							<RT-END-OF-GAME>
						)
						(T
							<SET RM ,RM-ABOVE-CASTLE>
						)
					>
				)
				(<MC-HERE? ,RM-WEST-OF-FORD>
					<SET RM ,RM-ABOVE-FORD>
				)
				(<MC-HERE? ,RM-BOG ,RM-EDGE-OF-BOG ,RM-THORNEY-ISLAND>
					<SET RM ,RM-ABOVE-BOG>
				)
				(<MC-HERE? ,RM-MEADOW ,RM-PAVILION>
					<SET RM ,RM-ABOVE-MEADOW>
				)
				(<MC-HERE? ,RM-FIELD-OF-HONOUR ,RM-END-OF-CAUSEWAY>
					<SET RM ,RM-ABOVE-FIELD>
				)
				(<MC-HERE? ,RM-ISLAND ,RM-SHALLOWS ,RM-CAUSEWAY>
					<SET RM ,RM-ABOVE-LAKE>
				)
				(<MC-HERE? ,RM-OUTSIDE-CRYSTAL-CAVE ,RM-MERPATH>
					<SET RM ,RM-ABOVE-MERCAVE>
				)
				(<MC-HERE? ,RM-EDGE-OF-WOODS ,RM-ROAD>
					<SET RM ,RM-ABOVE-EDGE-OF-WOODS>
				)
				(<MC-HERE?
						,RM-ENCHANTED-FOREST
						,RM-LEP-PATH
						,RM-CHESTNUT-PATH
						,RM-GLADE
						,RM-TOW-PATH
						,RM-TOW-CLEARING
						,RM-RAV-PATH
						,RM-GROVE
						,RM-RAVEN-NEST
						,RM-SOUTH-OF-CHASM
						,RM-NORTH-OF-CHASM
					>
					<SET RM ,RM-ABOVE-FOREST>
				)
				(<MC-HERE? ,RM-MOOR ,RM-FORK-IN-ROAD>
					<SET RM ,RM-ABOVE-MOOR>
				)
			>
			<COND
				(<NOT .QUIET>
					<COND
						(.RM
							<COND
								(<NOT <MC-HERE? ,RM-RAVEN-NEST ,RM-GROVE>>
									<SETG GL-TAKEOFF-ROOM ,HERE>
								)
							>
						)
					>
				)
			>
			<RETURN .RM>
		)
		(T
			<COND
				(<NOT .QUIET>
					<COND
						(<VERB-WORD? ,W?FLY>
							<TELL "You have no wings." CR>
						)
						(T
							<RT-YOU-CANT-MSG "go">
						)
					>
				)
			>
			<RFALSE>
		)
	>
>

<CONSTANT K-NO-LAND-MSG
"You swoop down into the fog, but immediately come upon an impenetrable
thicket of thorns that offers you nowhere to land.">

<ROUTINE RT-FLY-DOWN ("OPT" (QUIET <>))
	; "Makes the assumption that player is already an owl."
	<COND
		(,GL-TAKEOFF-ROOM
			<COND
				(<AND <NOT .QUIET>
						<EQUAL? ,GL-TAKEOFF-ROOM ,RM-BOG>
					>
					<TELL ,K-NO-LAND-MSG CR>
					<RFALSE>
				)
				(T
					<RETURN ,GL-TAKEOFF-ROOM>
				)
			>
		)
		(<MC-HERE? ,RM-ABOVE-TOWN>
			<RETURN ,RM-TOWN-SQUARE>
		)
		(<MC-HERE? ,RM-ABOVE-CASTLE>
			<RETURN ,RM-PARADE-AREA>
		)
		(<MC-HERE? ,RM-ABOVE-FORD>
			<RETURN ,RM-WEST-OF-FORD>
		)
		(<MC-HERE? ,RM-ABOVE-BOG>
			<COND
				(.QUIET
					<RETURN ,RM-BOG>
				)
				(T
					<TELL ,K-NO-LAND-MSG CR>
					<RFALSE>
				)
			>
		)
		(<MC-HERE? ,RM-ABOVE-MEADOW>
			<RETURN ,RM-MEADOW>
		)
		(<MC-HERE? ,RM-ABOVE-FIELD>
			<RETURN ,RM-FIELD-OF-HONOUR>
		)
		(<MC-HERE? ,RM-ABOVE-LAKE>
			<RETURN ,RM-ISLAND>
		)
		(<MC-HERE? ,RM-ABOVE-MERCAVE>
			<RETURN ,RM-OUTSIDE-CRYSTAL-CAVE>
		)
		(<MC-HERE? ,RM-ABOVE-EDGE-OF-WOODS>
			<RETURN ,RM-EDGE-OF-WOODS>
		)
		(<MC-HERE? ,RM-ABOVE-FOREST>
			<COND
				(.QUIET
					<RETURN ,RM-GROVE>
				)
				(T
					<SETUP-ORPHAN "land in ">
					<RT-AUTHOR-MSG "Where do you want to land, in the nest or in the grove?">
					<RETURN ,ROOMS>
				)
			>
		)
		(<MC-HERE? ,RM-ABOVE-MOOR>
			<RETURN ,RM-MOOR>
		)
	>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

