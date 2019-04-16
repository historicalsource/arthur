;"***************************************************************************"
; "game : Arthur"
; "file : SWORD.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   12 May 1989  0:42:46  $"
; "revs : $Revision:   1.101  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Sword/Ford/Black knight"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

<INCLUDE "PDEFS">		; "Because PARSE-ACTION used in this file."

;"---------------------------------------------------------------------------"
; "TH-SWORD"
;"---------------------------------------------------------------------------"

<OBJECT TH-SWORD
	(LOC TH-OAK-HOLE)
	(DESC "sword")
	(FLAGS FL-KNIFE FL-LOCKED FL-TAKEABLE FL-WEAPON)
	(SYNONYM SWORD)
	(SCORE <ORB <LSH 2 ,K-WISD-SHIFT> <LSH 1 ,K-QUEST-SHIFT>>)
	(SIZE 10)
	(GENERIC RT-GN-SWORD)
	(ACTION RT-TH-SWORD)
>

; "TH-SWORD flags:"
; "	FL-LOCKED - Slave has not told player about sword"

<ROUTINE RT-TH-SWORD ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<COND
				(<IN? ,TH-SWORD ,TH-BOAR>
					<FSET ,TH-SWORD ,FL-SEEN>
					<FSET ,TH-BOAR ,FL-SEEN>
					<TELL The ,TH-SWORD " is impaled in" the ,TH-BOAR "." CR>
				)
			>
		)
	>
>

<NEW-ADD-WORD "SWORDS" NOUN <VOC "SWORD"> ,PLURAL-FLAG>

<ROUTINE RT-GN-SWORD (TBL FINDER)
	<COND
		(<EQUAL? <PARSE-ACTION ,PARSE-RESULT> ,V?ASK-ABOUT>
			<COND
				(<EQUAL? <PARSE-OBJ1 ,PARSE-RESULT> ,CH-PRISONER>
					<RETURN ,TH-SWORD>
				)
				(<EQUAL? <PARSE-OBJ1 ,PARSE-RESULT> ,CH-LOT>
					<RETURN ,TH-LOT-SWORD>
				)
				(T
					<RETURN ,TH-EXCALIBUR>
				)
			>
		)
		(<RT-META-IN? ,TH-STONE ,HERE>
			<RETURN ,TH-EXCALIBUR>
		)
		(<INTBL? ,P-IT-OBJECT
				<REST-TO-SLOT .TBL FIND-RES-OBJ1>
				<FIND-RES-COUNT .TBL>
			>
			<RETURN ,P-IT-OBJECT>
		)
		(T
			<RETURN ,TH-SWORD>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-FORD"
;"---------------------------------------------------------------------------"

<ROOM RM-FORD
	(LOC ROOMS)
	(DESC "ford")
	(FLAGS FL-LIGHTED FL-WATER)
	(SYNONYM FORD)
	(EAST PER RT-EXIT-FORD)
	(WEST PER RT-EXIT-FORD)
	(NORTH PER RT-RAPIDS-MSG)
	(SOUTH PER RT-ENTER-RIVER)
	(OUT PER RT-EXIT-FORD)
	(UP PER RT-FLY-UP)
	(GLOBAL LG-RIVER)
	(ACTION RT-RM-FORD)
>

<ROUTINE RT-RM-FORD ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<NOT <MC-CONTEXT? ,M-LOOK>>
					<TELL "You enter the ford. ">
				)
			>
			<TELL "You are" standing " in the middle of the river.">
			<COND
				(<MC-FORM? ,K-FORM-EEL ,K-FORM-TURTLE>
					<TELL
"||Light filters down from the surface above, and strong rapids block
passage to the north.|"
					>
				)
				(T
					<TELL
" Looking south, you see that the land along the west bank is rich and
lush, while the land along the east bank is wasted and barren.|"
					>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<AND <VERB? WALK>
						<IN? ,CH-KRAKEN ,RM-FORD>
						<FSET? ,CH-KRAKEN ,FL-LOCKED>
					>
					<TELL ,K-KRAKEN-HOLD-MSG>
				)
			>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<COND
				(<MC-FORM? ,K-FORM-EEL>
					<SETG GL-PICTURE-NUM ,K-PIC-UNDERWATER>
				)
				(T
					<SETG GL-PICTURE-NUM ,K-PIC-FORD>
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
			<FCLEAR ,TH-CRYSTAL ,FL-LOCKED>
			<COND
				(<IN? ,TH-BAG ,CH-PLAYER>
					<PUTB <GETPT ,TH-BAG ,P?SIZE> ,K-CAPACITY ,K-CAP-MAX>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<OR	<VERB? THROW>
				<AND
					<VERB? PUT PUT-IN>
					<OR
						<MC-HERE? ,RM-FORD>
						<VERB-WORD? ,W?THROW ,W?TOSS ,W?HURL ,W?CHUCK ,W?FLING ,W?PITCH ,W?HEAVE>
					>
				>
			>
			<COND
				(<AND <MC-HERE? ,RM-WEST-OF-FORD>
						<FSET? ,CH-BLACK-KNIGHT ,FL-ALIVE>
					>
					<COND
						(<IDROP>
							<THIS-IS-IT ,CH-BLACK-KNIGHT>
							<TELL
The ,CH-BLACK-KNIGHT " snatches" the ,PRSO " out of the air and flings it
down onto the ground with a contemptuous laugh." CR
							>
						)
						(T
							<RTRUE>
						)
					>
				)
				(<MC-HERE? ,RM-EAST-OF-FORD ,RM-WEST-OF-FORD>
					<COND
						(<IDROP>
							<COND
								(<MC-PRSO? ,TH-APPLE>
									<MOVE ,PRSO ,RM-SHALLOWS>
									<TELL
The ,PRSO " quickly" verb ,PRSO "float" " down the river and out of sight." CR
									>
								)
								(T
									<RT-THROW-INTO-ROOM-MSG ,PRSO ,RM-FORD>
								)
							>
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
>

<ROUTINE RT-RAPIDS-MSG ("OPT" (QUIET <>))
	<COND
		(<NOT .QUIET>
			<TELL "The current is too strong to go upriver.|">
		)
	>
	<RFALSE>
>

<ROUTINE RT-EXIT-FORD ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<COND
				(<MC-FORM? ,K-FORM-EEL>
					<RFALSE>
				)
				(<EQUAL? ,P-WALK-DIR ,P?WEST>
					<RETURN ,RM-WEST-OF-FORD>
				)
				(<EQUAL? ,P-WALK-DIR ,P?EAST>
					<RETURN ,RM-EAST-OF-FORD>
				)
			>
		)
		(<MC-FORM? ,K-FORM-EEL>
			<TELL "Eels can't survive out of water.|">
			<RFALSE>
		)
		(<EQUAL? ,P-WALK-DIR ,P?OUT>
			<V-WALK-AROUND>
			<RFALSE>
		)
		(<EQUAL? ,P-WALK-DIR ,P?WEST>
			<RETURN ,RM-WEST-OF-FORD>
		)
		(<EQUAL? ,P-WALK-DIR ,P?EAST>
			<COND
				(<AND <IN? ,TH-BRACELET ,CH-PLAYER>
						<FSET? ,TH-BRACELET ,FL-WORN>
						<NOT <MC-FORM? ,K-FORM-ARTHUR>>
					>
					<TELL
"As you climb out of" ,K-SHAPECHANGE-MSG " As your neck begins to expand to
it's normal size," the ,TH-BRACELET " begins to throttle you. You stagger
back into the water and quickly revert to your" formtype " form.|"
					>
					<RFALSE>
				)
				(T
					<COND
						(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
							<SETG GL-PLAYER-FORM ,K-FORM-ARTHUR>
							<TELL "As you climb out of" ,K-SHAPECHANGE-MSG CR CR>
						)
					>
					<RETURN ,RM-EAST-OF-FORD>
				)
			>
		)
	>
>

<ROUTINE RT-ENTER-RIVER ("OPT" (QUIET <>))
	<COND
		(<MC-FORM? ,K-FORM-EEL ,K-FORM-TURTLE>
			<RETURN ,RM-RIVER-1>
		)
		(T
			<COND
				(<NOT .QUIET>
					<TELL ,K-WOULD-DROWN-MSG>
				)
			>
			<RFALSE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-WEST-OF-FORD"
;"---------------------------------------------------------------------------"

<ROOM RM-WEST-OF-FORD
	(LOC ROOMS)
	(DESC "west of ford")
	(FLAGS FL-LIGHTED)
	(EAST PER RT-PASS-BLACK-KNIGHT)
	(WEST TO RM-BOG)
	(UP PER RT-FLY-UP)
	(GLOBAL LG-RIVER RM-FORD RM-BOG)
	(ACTION RT-RM-WEST-OF-FORD)
	(THINGS <> SIGN RT-PS-SIGN)
>

<ROUTINE RT-RM-WEST-OF-FORD ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "You are" standing " at the edge of a river.">
				)
				(T
					<COND
						(<EQUAL? ,OHERE ,RM-FORD>
							<TELL "You climb up out of the river.">
						)
						(<EQUAL? ,OHERE ,RM-BOG>
							<TELL
"You emerge safely from the bog, and come to a ford in a river."
							>
						)
						(T
							<TELL "You land next to a ford in a river.">
						)
					>
				)
			>
			<TELL " To the west ">
			<COND
				(<EQUAL? ,OHERE ,RM-BOG>
					<TELL "lies the path back into the">
				)
				(T
					<TELL "is a sign that marks the edge of a treacherous peat">
				)
			>
			<TELL " bog.">
			<COND
				(<FSET? ,CH-BLACK-KNIGHT ,FL-ALIVE>
					<FSET ,CH-BLACK-KNIGHT ,FL-SEEN>
					<FSET ,TH-BLACK-ARMOUR ,FL-SEEN>
					<TELL
" Passage across the ford to the east is blocked by a fearsome looking
knight in black armour."
					>
				)
			>
			<CRLF>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-BEG>
			<SETG GL-BLACK-FIGHT <>>
		)
		(<MC-CONTEXT? ,M-END>
			<COND
				(<VERB? TRANSFORM>
					<COND
						(<NOT <MC-FORM? ,GL-OLD-FORM ,K-FORM-ARTHUR>>
							<COND
								(<FSET? ,CH-BLACK-KNIGHT ,FL-ALIVE>
									<RT-RESET-BLACK-FIGHT>
									<TELL
CR The ,CH-BLACK-KNIGHT " looks at you and sneers maliciously, \"How well it
suits you, creature of Merlin, to crawl into the skin of a lowly animal. You
are so far beneath contempt that I shall not even bother to kill you.\""  CR
									>
								)
							>
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<COND
				(<FSET? ,CH-BLACK-KNIGHT ,FL-ALIVE>
					<SETG GL-PICTURE-NUM ,K-PIC-BLACK-KNIGHT>
				)
				(T
					<SETG GL-PICTURE-NUM ,K-PIC-EDGE-OF-BOG>
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
			<SETG GL-BOG-START ,HERE>
			<SETG GL-BOG-POS ,K-BOG-NUM>
			<COND
				(<EQUAL? ,OHERE ,RM-BOG>
					<COND
						(<AND <FSET? ,RM-BOG ,FL-BROKEN>
								<FSET? ,RM-BOG ,FL-LOCKED>
							>
							<FCLEAR ,RM-BOG ,FL-BROKEN>
							<FCLEAR ,RM-BOG ,FL-LOCKED>
							<RT-SCORE-MSG 0 2 3 2>
						)
					>
				)
				(<EQUAL? ,OHERE ,RM-FORD>
					<COND
						(<FSET? ,CH-BLACK-KNIGHT ,FL-ALIVE>
							<THIS-IS-IT ,CH-BLACK-KNIGHT>
							<TELL "|The Black Knight whirls around to face you." CR>
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-EXIT>
			<COND
				(<FSET? ,CH-BLACK-KNIGHT ,FL-ALIVE>
					<RT-RESET-BLACK-FIGHT>
					<TELL
The ,CH-BLACK-KNIGHT " calls after you as you leave, \"Coward! Go on - save
your precious skin. I expected nothing less from one of Merlin's whelps.\"||"
					>
					<RFALSE>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
	>
>

<ROUTINE RT-PASS-BLACK-KNIGHT ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<RETURN ,RM-FORD>
		)
		(<MC-FORM? ,K-FORM-BADGER ,K-FORM-OWL ,K-FORM-SALAMANDER>
			<TELL ,K-WOULD-DROWN-MSG>
			<RFALSE>
		)
		(<OR	<NOT <FSET? ,CH-BLACK-KNIGHT ,FL-ALIVE>>
				<NOT <MC-FORM? ,K-FORM-ARTHUR>>
			>
			<RETURN ,RM-FORD>
		)
		(<RT-IS-QUEUED? ,RT-I-BLACK-FIGHT>
			<TELL
The ,CH-BLACK-KNIGHT " blocks your path and deals you another mighty blow." CR
			>
			<RFALSE>
		)
		(T
			<TELL
The ,CH-BLACK-KNIGHT " blocks your path, saying \"All who would cross this
ford must first fight with me. I am the defender of the land that lies
beyond.\"" CR
			>
			<RFALSE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "CH-BLACK-KNIGHT"
;"---------------------------------------------------------------------------"

<OBJECT CH-BLACK-KNIGHT
	(LOC RM-WEST-OF-FORD)
	(DESC "black knight")
	(FLAGS FL-ALIVE FL-NO-DESC FL-OPEN FL-PERSON FL-SEARCH)
	(SYNONYM KNIGHT MAN PERSON)
	(ADJECTIVE BLACK)
	(ACTION RT-CH-BLACK-KNIGHT)
>

<ROUTINE RT-CH-BLACK-KNIGHT ("OPT" (CONTEXT <>) (ART <>) (CAP? <>) "AUX" N)
	<COND
		(<AND <MC-CONTEXT? ,M-WINNER <>>
				<VERB? HELLO GOODBYE THANK>
			>
			<COND
				(<VERB? HELLO>
					<TELL
"\"I offer no greetings to those who must die. All who would cross this ford
must first fight with me. I am the defender of the land that lies beyond.\"" CR
					>
				)
				(<VERB? GOODBYE>
					<TELL
"\"You do well to run. At least you escape with your life, if not your honour.\"" CR
					>
				)
				(<VERB? THANK>
					<TELL
"\"Keep your thanks to yourself. I have no use for your chivalrous
claptrap!\"" CR
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
				(T
					<TELL
"\"I will not waste my time in idle chatter. Prepare to defend thyself.\"" CR
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
		; "Message and RFATAL if don't want knight to become winner"
			<RFALSE>
		)
		(<VERB? ASK-ABOUT>
			<COND
				(<MC-PRSI? ,CH-BLACK-KNIGHT>
					<TELL "\"I am the guardian of the land that lies beyond.\"" CR>
				)
				(<MC-PRSI? ,CH-DEMON ,TH-MASTER>
					<TELL "\"He is my master. I do his bidding.\"" CR>
				)
				(<MC-PRSI? ,TH-BLACK-MEDALLION>
					<TELL "\"It was given to me by my master.\"" CR>
				)
				(<MC-PRSI? ,CH-MERLIN>
					<TELL
"\"An overrated parlour magician. He couldn't make a black cat disappear in a
dark room at midnight.\"" CR
					>
				)
				(<MC-PRSI? ,CH-LOT>
					<TELL "\"Not a bad fellow, once you get to know him.\"" CR>
				)
				(<MC-PRSI? ,TH-EXCALIBUR>
					<TELL
"\"Bring it, if you can. I'm not afraid of it.\"" CR
					>
				)
				(T
					<TELL
"\"I will not waste my time in idle chatter. Prepare to defend thyself.\"" CR
					>
				)
			>
		)
		(<VERB? ATTACK CUT>
			<RT-ATTACK-KNIGHT ,CH-BLACK-KNIGHT>
		)
		(<VERB? EXAMINE>
			<TELL "The knight towers above you">
			<COND
				(<IN? ,TH-BLACK-SWORD ,CH-BLACK-KNIGHT>
					<TELL ", brandishing a huge sword">
				)
			>
			<TELL
". He is encased from head to foot in jet-black armour, and from his neck
hangs a sinister medallion that glows a dull red." CR
			>
		)
		(<VERB? CHALLENGE>
			<THIS-IS-IT ,CH-BLACK-KNIGHT>
			<TELL
"The Black Knight snorts in derision and says, \"Words - mere words. If you
want to fight, boy, then let's fight.\"" CR
			>
		)
	>
>

<CONSTANT K-BLOOD-NUM <TABLE (BYTE LENGTH) 1 2 3>>
<CONSTANT K-FIGHT-NUM <TABLE (BYTE LENGTH) 1 2 3>>
<GLOBAL GL-BLACK-FIGHT <> <> BYTE>

<ROUTINE RT-ATTACK-KNIGHT ("OPT" (TARGET ,CH-BLACK-KNIGHT) "AUX" I M N PTR)
	<RT-DEQUEUE ,RT-I-RESET-BLOOD>
	<COND
		(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
			<TELL
The ,CH-BLACK-KNIGHT " sidesteps your attack and looks at you in surprise." CR
			>
		)
		(<NOT <MC-PRSI? ,TH-SWORD>>
			<COND
				(<L? ,GL-SC-EXP 66>
					<TELL
The ,CH-BLACK-KNIGHT " ignores your feeble attack and jeers, \"Until you have
a decent weapon, boy, I won't even bother to kill you.\"" CR
					>
				)
				(<NOT <IN? ,TH-BLACK-SWORD ,CH-BLACK-KNIGHT>>
					<RT-QUEUE ,RT-I-BLACK-FIGHT <+ ,GL-MOVES 1>>
					<MOVE ,TH-BLACK-SWORD ,CH-BLACK-KNIGHT>
					<TELL
The ,CH-BLACK-KNIGHT " dodges your feeble attack and retrieves his weapon." CR
					>
				)
				(T
					<TELL
The ,CH-BLACK-KNIGHT " nimbly avoids your feeble maneuver while launching an
attack of his own. He feints a blow to your head, and then suddenly whirls
and deals you a fatal blow across your midsection.|"
					>
					<RT-END-OF-GAME>
				)
			>
		)
		(<L? ,GL-SC-EXP 25>
			<TELL
The ,CH-BLACK-KNIGHT " easily fends off your clumsy attack and scoffs,
\"Begone, lad. I won't even fight a boy of such inexperience.\"" CR
			>
		)
		(<L? ,GL-SC-EXP 53>
			<MOVE ,TH-SWORD ,HERE>
			<TELL
"You advance towards" the ,CH-BLACK-KNIGHT ", swinging your sword wildly. He
casually blocks your attack, and then whirls his blade in a tight circle. Your
sword flies out of your hand and lands on" the ,TH-GROUND " nearby. As you
bend to pick it up," the ,CH-BLACK-KNIGHT " slaps you on your backside with
the flat of his sword and sends you sprawling on" the ,TH-GROUND
".||He laughs while you pick yourself up, and then he jeers, \"Come back when you
have learned enough to hold onto your sword in a fight, boy.\"" CR
			>
		)
		(<L? ,GL-SC-EXP 66>
			<SETG GL-BLACK-FIGHT T>
			<COND
				(<NOT <RT-IS-QUEUED? ,RT-I-BLACK-FIGHT>>
					<RT-QUEUE ,RT-I-BLACK-FIGHT <+ ,GL-MOVES 1>>
				)
			>
			<COND
				(<EQUAL? <GETB ,K-BLOOD-NUM 0> 0>
					<TELL
"You muster all your remaining strength and swing the sword, but it is not
enough. The knight avoids the blow, and then administers the coup de grace
with a quick thrust to your heart.|"
					>
					<RT-END-OF-GAME>
				)
				(<MC-PROB? 50>
					<SET N <RANDOM 4>>
					<COND
						(<EQUAL? .N 1>
							<TELL
"The knight blocks your attack with his sword and counters with a blow of his
own, which misses you by inches!" CR
							>
						)
						(<EQUAL? .N 2>
							<TELL
"You deal the knight a glancing blow. He staggers for a moment, but then
recovers." CR
							>
						)
						(<EQUAL? .N 3>
							<TELL "The two blades meet with a mighty clash." CR>
						)
						(T
							<TELL
"You lunge at the knight, but he steps aside at the last instant." CR
							>
						)
					>
				)
				(T
					<SET M <RANDOM <GETB ,K-BLOOD-NUM 0>>>
					<SET N <GETB ,K-BLOOD-NUM .M>>
					<COND
						(<EQUAL? .N 1>
							<TELL
"Your swing goes wild, and its momentum pulls you sideways for an instant.
The black knight takes advantage of the opening and cuts you on the shoulder." CR
							>
						)
						(<EQUAL? .N 2>
							<TELL
"You swing the sword with all your might, but the knight deflects the force of
the blow with his sword. Then he whirls and strikes at your head! The tip of
his blade grazes your forehead, and some blood starts to trickle down into
your eyes." CR
							>
						)
						(T
							<TELL
"A valiant effort, but the knight is too quick for you. He draws blood with a
low swipe at your leg." CR
							>
						)
					>
					<SET I <GETB ,K-BLOOD-NUM 0>>
					<COND
						(<G? .I .M>
							<SET PTR <ZREST ,K-BLOOD-NUM .M>>
							<COPYT <ZREST .PTR 1> .PTR <- .I .M>>
						)
					>
					<DEC I>
					<PUTB ,K-BLOOD-NUM 0 .I>
					<COND
						(<ZERO? .I>
							<TELL
"|You are bleeding all over and your strength is fading quickly. You realize
that the black knight is still more experienced than you, and that to continue
fighting him would mean certain death." CR
							>
						)
					>
					<RTRUE>
				)
			>
		)
		(T
			<SETG GL-BLACK-FIGHT T>
			<COND
				(<NOT <RT-IS-QUEUED? ,RT-I-BLACK-FIGHT>>
					<RT-QUEUE ,RT-I-BLACK-FIGHT <+ ,GL-MOVES 1>>
				)
			>
			<COND
				(<IN? ,TH-BLACK-SWORD ,CH-BLACK-KNIGHT>
					<COND
						(<EQUAL? <GETB ,K-FIGHT-NUM 0> 0>
							<RT-RESET-BLACK-FIGHT>
							<RT-QUEUE ,RT-I-GET-SWORD <+ ,GL-MOVES 1>>
							<MOVE ,TH-BLACK-SWORD ,HERE>
							<TELL
"Your blade slices through the air and knocks the knight's sword from his
grasp! It falls to the ground, and he is momentarily disarmed!" CR
							>
						)
						(T
							<SET M <RANDOM <GETB ,K-FIGHT-NUM 0>>>
							<SET N <GETB ,K-FIGHT-NUM .M>>
							<COND
								(<EQUAL? .N 1>
									<TELL
"You deal the knight a stunning blow. He tries to parry, but the sheer force
of it knocks him back a few steps." CR
									>
								)
								(<EQUAL? .N 2>
									<TELL
"You lunge at the knight's head. He raises his sword to ward off the blow,
but suddenly you drop your aim. He tries to twist aside at the last minute,
but you still pierce his armour and graze his ribs." CR
									>
								)
								(T
									<TELL
"You whirl the blade with blinding speed, missing the knight by inches!" CR
									>
								)
							>
							<SET I <GETB ,K-FIGHT-NUM 0>>
							<COND
								(<G? .I .M>
									<SET PTR <ZREST ,K-FIGHT-NUM .M>>
									<COPYT <ZREST .PTR 1> .PTR <- .I .M>>
								)
							>
							<DEC I>
							<PUTB ,K-FIGHT-NUM 0 .I>
						)
					>
				)
				(<EQUAL? .TARGET ,TH-BLACK-MEDALLION>
					<MOVE ,TH-BLACK-ARMOUR ,HERE>
					<FCLEAR ,TH-BLACK-ARMOUR ,FL-WORN>
					<FCLEAR ,TH-BLACK-ARMOUR ,FL-NO-DESC>
					<REMOVE ,CH-BLACK-KNIGHT>
					<REMOVE ,TH-BLACK-SWORD>
					<FCLEAR ,CH-BLACK-KNIGHT ,FL-ALIVE>
					<RT-DEQUEUE ,RT-I-BLACK-FIGHT>
					<RT-DEQUEUE ,RT-I-GET-SWORD>
					<TELL
"You sever the knight's source of power. " The ,TH-BLACK-MEDALLION " and
the knight's sword both incandesce into a fiery red, and then
they suddenly disappear in a thunderclap and a flash of lightning. "
The ,TH-BLACK-ARMOUR " teeters for a moment. Then it crumples to"
the ,TH-GROUND ", empty." CR
					>
					<RT-SCORE-MSG 0 4 7 4>
					<SETG GL-PICTURE-NUM ,K-PIC-EDGE-OF-BOG>
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
					<MOVE ,TH-BLACK-SWORD ,CH-BLACK-KNIGHT>
					<TELL
"With amazing agility, the knight recovers his sword in time to block
your blow." CR
					>
				)
			>
		)
	>
>

<ROUTINE RT-RESET-BLACK-FIGHT ("AUX" (I 0))
	<COND
		(<L? ,GL-SC-EXP 53>)
		(<L? ,GL-SC-EXP 66>
			<RT-DEQUEUE ,RT-I-BLACK-FIGHT>
			<RT-QUEUE ,RT-I-RESET-BLOOD <+ ,GL-MOVES 20>>
		)
		(T
			<RT-DEQUEUE ,RT-I-BLACK-FIGHT>
			<RT-DEQUEUE ,RT-I-GET-SWORD>
			<SET I 0>
			<PUTB ,K-FIGHT-NUM 0 3>
			<REPEAT ()
				<COND
					(<IGRTR? I 3>
						<RETURN>
					)
					(T
						<PUTB ,K-FIGHT-NUM .I .I>
					)
				>
			>
		)
	>
	<RTRUE>
>

<ROUTINE RT-I-RESET-BLOOD ("AUX" (I 0))
	<PUTB ,K-BLOOD-NUM 0 3>
	<REPEAT ()
		<COND
			(<IGRTR? I 3>
				<RETURN>
			)
			(T
				<PUTB ,K-BLOOD-NUM .I .I>
			)
		>
	>
	<RFALSE>
>

<ROUTINE RT-I-BLACK-FIGHT ()
	<COND
		(<IN? ,TH-BLACK-SWORD ,CH-BLACK-KNIGHT>
			<COND
				(<OR	<NOT ,GL-BLACK-FIGHT>
						<FSET? ,CH-PLAYER ,FL-ASLEEP>
					>
					<COND
						(<OR	<NOT <FSET? ,CH-PLAYER ,FL-ASLEEP>>
								<G=? ,GL-SC-EXP 66>
							>
							<TELL
CR The ,CH-BLACK-KNIGHT " takes advantage of your inactivity to "
							>
						)
					>
					<COND
						(<L? ,GL-SC-EXP 66>
							<COND
								(<NOT <FSET? ,CH-PLAYER ,FL-ASLEEP>>
									<RT-QUEUE ,RT-I-RESET-BLOOD <+ ,GL-MOVES 20>>
									<TELL "catch his breath." CR>
								)
							>
						)
						(<FSET? ,CH-PLAYER ,FL-ASLEEP>
							<TELL "kill you.|">
							<RT-END-OF-GAME>
						)
						(T
							<TELL
"launch a suprise attack. He feints a blow to your head, and then suddenly
whirls and deals you a fatal blow across your midsection.|"
							>
							<RT-END-OF-GAME>
						)
					>
				)
				(T
					<SETG GL-BLACK-FIGHT <>>
					<RT-QUEUE ,RT-I-BLACK-FIGHT <+ ,GL-MOVES 1>>
				)
			>
		)
	>
>

<ROUTINE RT-I-GET-SWORD ()
	<COND
		(<NOT <IN? ,TH-BLACK-SWORD ,CH-BLACK-KNIGHT>>
			<RT-QUEUE ,RT-I-BLACK-FIGHT <+ ,GL-MOVES 1>>
			<MOVE ,TH-BLACK-SWORD ,CH-BLACK-KNIGHT>
			<TELL CR The ,CH-BLACK-KNIGHT " picks up his sword." CR>
		)
	>
>

;<ROUTINE RT-GN-KNIGHT (TBL FINDER "AUX" PTR N (OBJ <>))
	<SET PTR <REST-TO-SLOT .TBL FIND-RES-OBJ1>>
	<SET N <FIND-RES-COUNT .TBL>>
	<COND
		(<INTBL? ,P-HIM-OBJECT .PTR .N>
			<SET OBJ ,P-HIM-OBJECT>
		)
		(T
			<REPEAT ((I .N) O)
				<COND
					(<DLESS? I 0>
						<RETURN>
					)
					(<FSET? <SET O <ZGET .PTR 0>> ,FL-SEEN>
						<COND
							(.OBJ
								<SET OBJ <>>
								<RETURN>
							)
							(T
								<SET OBJ .O>
							)
						>
					)
				>
				<SET PTR <ZREST .PTR 2>>
			>
		)
	>
	<COND
		(.OBJ
			<TELL "[" The .OBJ "]" CR>
		)
	>
	<RETURN .OBJ>
>

;"---------------------------------------------------------------------------"
; "TH-BLACK-ARMOUR"
;"---------------------------------------------------------------------------"

<OBJECT TH-BLACK-ARMOUR
	(LOC CH-BLACK-KNIGHT)
	(DESC "black armour")
	(FLAGS FL-CLOTHING FL-COLLECTIVE FL-NO-DESC FL-PLURAL FL-TRY-TAKE FL-WORN)
	(SYNONYM ARMOUR ARMOR)
	(ADJECTIVE BLACK)
	(OWNER CH-BLACK-KNIGHT)
	(GENERIC RT-GN-ARMOUR)
	(ACTION RT-TH-BLACK-ARMOUR)
>

<ROUTINE RT-TH-BLACK-ARMOUR ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<COND
				(<NOT <FSET? ,CH-BLACK-KNIGHT ,FL-ALIVE>>
					<TELL "The heap of armour is all that is left of the knight." CR>
				)
			>
		)
		(<VERB? TAKE MOVE RAISE>
			<COND
				(<NOT <FSET? ,CH-BLACK-KNIGHT ,FL-ALIVE>>
					<TELL The ,TH-BLACK-ARMOUR " is too heavy to move." CR>
				)
			>
		)
		(<VERB? ATTACK CUT>
			<COND
				(<FSET? ,CH-BLACK-KNIGHT ,FL-ALIVE>
					<RT-ATTACK-KNIGHT ,TH-BLACK-ARMOUR>
				)
				(T
					<RT-WASTE-OF-TIME-MSG>
				)
			>
		)
		(<VERB? FILL>
			<THIS-IS-IT ,TH-BLACK-ARMOUR>
			<TELL "There are too many holes in the armour." CR>
		)
		(<VERB? WEAR ENTER>
			<COND
				(<FSET? ,CH-BLACK-KNIGHT ,FL-ALIVE>
					<THIS-IS-IT ,CH-BLACK-KNIGHT>
					<THIS-IS-IT ,TH-BLACK-ARMOUR>
					<TELL "The black knight is wearing the armour." CR>
				)
				(T
					<TELL "The black armour is much too big for you." CR>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-BLACK-SWORD"
;"---------------------------------------------------------------------------"

<OBJECT TH-BLACK-SWORD
	(LOC CH-BLACK-KNIGHT)
	(DESC "sword")
	(FLAGS ;FL-KNIFE FL-NO-DESC FL-TRY-TAKE ;FL-WEAPON)
	(SYNONYM SWORD)
	(ADJECTIVE BLACK HUGE)
	(OWNER CH-BLACK-KNIGHT)
	(GENERIC RT-GN-SWORD)
	(ACTION RT-TH-BLACK-SWORD)
>

<ROUTINE RT-TH-BLACK-SWORD ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? ATTACK CUT>
			<RT-ATTACK-KNIGHT ,TH-BLACK-SWORD>
		)
		(<TOUCH-VERB?>
			<COND
				(<IN? ,TH-BLACK-SWORD ,CH-BLACK-KNIGHT>
					<TELL The ,CH-BLACK-KNIGHT " moves his sword out of reach." CR>
				)
				(T
					<RT-QUEUE ,RT-I-BLACK-FIGHT <+ ,GL-MOVES 1>>
					<MOVE ,TH-BLACK-SWORD ,CH-BLACK-KNIGHT>
					<TELL
"The knight is faster than you are. He retrieves the sword and deals you a
mighty blow." CR
					>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-BLACK-MEDALLION"
;"---------------------------------------------------------------------------"

<OBJECT TH-BLACK-MEDALLION
	(LOC CH-BLACK-KNIGHT)
	(DESC "medallion")
	(FLAGS FL-NO-DESC FL-TRY-TAKE FL-WORN)
	(SYNONYM MEDALLION MEDAL)
	(ADJECTIVE GLOWING DULL RED)
	(OWNER CH-BLACK-KNIGHT)
	(ACTION RT-TH-BLACK-MEDALLION)
>

<ROUTINE RT-TH-BLACK-MEDALLION ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<TELL The ,TH-BLACK-MEDALLION " glows a dull red." CR>
		)
		(<VERB? ATTACK CUT>
			<RT-ATTACK-KNIGHT ,TH-BLACK-MEDALLION>
		)
		(<TOUCH-VERB?>
			<TELL "As you approach, the knight ">
			<COND
				(<IN? ,TH-BLACK-SWORD ,CH-BLACK-KNIGHT>
					<TELL
"raises his sword threateningly. You think better of the idea and retreat." CR
					>
				)
				(T
					<RT-QUEUE ,RT-I-BLACK-FIGHT <+ ,GL-MOVES 1>>
					<MOVE ,TH-BLACK-SWORD ,CH-BLACK-KNIGHT>
					<TELL
"knocks your hand aside and quickly retrieves his sword." CR
					>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-EAST-OF-FORD"
;"---------------------------------------------------------------------------"

<ROOM RM-EAST-OF-FORD
	(LOC ROOMS)
	(DESC "east of ford")
	(FLAGS FL-LIGHTED)
	(WEST TO RM-FORD)
	(NE TO RM-FOOT-OF-MOUNTAIN)
	(UP PER RT-FLY-UP)
	(GLOBAL LG-RIVER LG-MOUNTAIN RM-FORD)
	(ACTION RT-RM-EAST-OF-FORD)
>

<ROUTINE RT-RM-EAST-OF-FORD ("OPT" (CONTEXT <>) "AUX" SIZE)
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "You are" standing " alongside a river.">
				)
				(T
					<COND
						(<EQUAL? ,OHERE ,RM-FORD>
							<TELL "You climb back up onto dry ground.">
						)
						(<EQUAL? ,OHERE ,RM-FOOT-OF-MOUNTAIN>
							<TELL "You return to the riverside.">
						)
						(T
							<TELL "You land alongside a river.">
						)
					>
				)
			>
			<TELL " You see the gnarled and wasted remains of tree here">
			<COND
				(<IN? ,TH-APPLE ,TH-APPLETREE>
					<TELL
", and from one of its branches hangs a withered old apple"
					>
				)
			>
			<FSET ,TH-APPLE ,FL-SEEN>
			<FSET ,TH-APPLETREE ,FL-SEEN>
			<TELL
". To the northeast, the land looks bleak and barren. The road leading
in that direction looks like it ends at the foot of a forbidding mountain
range. The ford across the river lies to the west.|"
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-EAST-OF-FORD>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTERED>
			<FSET ,TH-CRYSTAL ,FL-LOCKED>
			<COND
				(<IN? ,TH-BAG ,CH-PLAYER>
					<SET SIZE <GETB <GETPT ,TH-BAG ,P?SIZE> ,K-SIZE>>
					<COND
						(<G? <RT-TOTAL-SIZE ,TH-BAG> .SIZE>
							<THIS-IS-IT ,TH-BAG>
							<MOVE ,TH-BAG ,HERE>
							<RT-MOVE-ALL ,TH-BAG ,HERE>
							<PUTB <GETPT ,TH-BAG ,P?SIZE> ,K-CAPACITY .SIZE>
							<TELL CR
"Merlin's bag suddenly becomes too heavy for you to carry. It falls to"
the ,TH-GROUND " and the contents spill out." CR
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
; "RM-ABOVE-FORD"
;"---------------------------------------------------------------------------"

<ROOM RM-ABOVE-FORD
	(LOC ROOMS)
	(DESC "above the ford")
	(FLAGS FL-AIR FL-LIGHTED)
	(DOWN PER RT-FLY-DOWN)
	(EAST PER RT-SPELL-FAILS)
	(WEST TO RM-ABOVE-BOG)
	(SW TO RM-ABOVE-CASTLE)
	(UP SORRY K-NO-HIGHER-MSG)
	(GLOBAL LG-CASTLE RM-BOG RM-WEST-OF-FORD RM-FORD RM-EAST-OF-FORD)
	(ACTION RT-RM-ABOVE-FORD)
>

<ROUTINE RT-RM-ABOVE-FORD ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,RM-BOG ,FL-SEEN>
			<FSET ,LG-CASTLE ,FL-SEEN>
			<TELL
"You are hovering over the western edge of a ford. A large patch of fog
lies to the west, and to the south of that lies the castle. Below you to
the east, you see a road emerge from the ford and lead northeastward towards
a desolate looking mountain range.|"
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

<CONSTANT K-SHAPECHANGE-MSG
" the river, you feel yourself changing back into your human form."
>

<ROUTINE RT-SPELL-FAILS ("OPT" (QUIET <>))
	<COND
		(<NOT .QUIET>
			<SETG GL-PLAYER-FORM ,K-FORM-ARTHUR>
			<TELL
"As you fly over" ,K-SHAPECHANGE-MSG " Slowly, you drift to the ground, and
when you land you discover you are no longer an owl."
			>
			<COND
				(<RT-MOVE-ALL ,TH-CLOTHES-BIN ,CH-PLAYER>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT>>
					<TELL " " ,K-CLOTHES-REAPPEAR-MSG>
				)
			>
			<CRLF>
			<CRLF>
		)
	>
	<RETURN ,RM-EAST-OF-FORD>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

