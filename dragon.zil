;"***************************************************************************"
; "game : Arthur"
; "file : DRAGON.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   15 May 1989 19:42:34  $"
; "revs : $Revision:   1.78  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Dragon Puzzle"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "RM-FOOT-OF-MOUNTAIN"
;"---------------------------------------------------------------------------"

<ROOM RM-FOOT-OF-MOUNTAIN
	(LOC ROOMS)
	(DESC "foot of mountain")
	(FLAGS FL-LIGHTED)
	(SYNONYM FOOT)
	(OWNER LG-MOUNTAIN)
	(NE TO RM-LEDGE)
	(SW TO RM-EAST-OF-FORD)
	(UP TO RM-LEDGE)
	(GLOBAL LG-MOUNTAIN LG-PATH)
	(ACTION RT-RM-FOOT-OF-MOUNTAIN)
>

<ROUTINE RT-RM-FOOT-OF-MOUNTAIN ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<TELL "You ">
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "are" standing " at">
				)
				(T
					<COND
						(<EQUAL? ,OHERE ,RM-LEDGE>
							<TELL "descend to">
						)
						(T
							<TELL "walk along until you come to">
						)
					>
				)
			>
			<TELL " the foot of ">
			<COND
				(<EQUAL? ,OHERE ,RM-LEDGE>
					<TELL "the">
				)
				(T
					<TELL "an">
				)
			>
			<TELL
" evil-looking mountain. A path winds up the slope to the northeast. The ford
lies to the southwest.|"
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-FOOT-OF-MOUNTAIN>
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
; "LG-MOUNTAIN"
;"---------------------------------------------------------------------------"

<OBJECT LG-MOUNTAIN
	(LOC LOCAL-GLOBALS)
	(DESC "mountain")
	(SYNONYM MOUNTAIN)
	(ADJECTIVE FORBIDDING)
	(ACTION RT-LG-MOUNTAIN)
>

<ROUTINE RT-LG-MOUNTAIN ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? CLIMB-UP>
			<COND
				(<MC-HERE? ,RM-FOOT-OF-MOUNTAIN>
					<RT-DO-WALK ,P?NE>
				)
			>
		)
		(<VERB? CLIMB-DOWN>
			<COND
				(<MC-HERE? ,RM-LEDGE>
					<RT-DO-WALK ,P?SW>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET LG-MOUNTAIN ,FL-SEEN>
			<TELL
"It's an evil and treacherous place where few men have ever journeyed, and
even fewer have returned." CR
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-LEDGE"
;"---------------------------------------------------------------------------"

<ROOM RM-LEDGE
	(LOC ROOMS)
	(DESC "ledge")
	(FLAGS FL-LIGHTED)
	(NORTH PER RT-PAST-DRAGON)
	(IN PER RT-PAST-DRAGON)
	(SW TO RM-FOOT-OF-MOUNTAIN)
	(DOWN TO RM-FOOT-OF-MOUNTAIN)
	(SYNONYM LEDGE)
	(GLOBAL LG-MOUNTAIN RM-CAVE)
	(ACTION RT-RM-LEDGE)
	(THINGS
		<> (ROCK ROCKS STONE STONES RUBBLE) RT-PS-RUBBLE
	)
>

<ROUTINE RT-RM-LEDGE ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<NOT <MC-CONTEXT? ,M-LOOK>>
					<COND
						(<EQUAL? ,OHERE ,RM-FOOT-OF-MOUNTAIN>
							<TELL
"You inch your way up the treacherous path, until it finally broadens
out on a ledge at the entrance to a cave."
							>
						)
						(T
							<TELL
"You emerge from the cave and find yourself once again on the ledge."
							>
						)
					>
					<TELL " ">
				)
			>
			<FSET ,CH-DRAGON ,FL-SEEN>
			<TELL "A fierce-looking dragon is ">
			<COND
				(<MC-CONTEXT? ,M-F-LOOK>
					<TELL "sleeping">
				)
				(<FSET? ,CH-DRAGON ,FL-ASLEEP>
					<TELL "passed out">
				)
				(,GL-DRAGON-CNT
					<TELL "weaving drunkenly">
				)
				(T
					<TELL "resting his eyes">
				)
			>
			<TELL " in the entrance to the cave.|">
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<COND
				(<FSET? ,CH-DRAGON ,FL-ASLEEP>
					<SETG GL-PICTURE-NUM ,K-PIC-DRAGON-OUT>
				)
				(<ZERO? ,GL-DRAGON-CNT>
					<SETG GL-PICTURE-NUM ,K-PIC-DRAGON-ASLEEP>
				)
				(T
					<SETG GL-PICTURE-NUM ,K-PIC-DRAGON-DRUNK>
				)
			>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<AND <VERB? YELL>
						<NOT <FSET? ,CH-DRAGON ,FL-ASLEEP>>
						<NOT ,GL-DRAGON-CNT>
					>
					<RT-DRAGON-ANGRY-MSG>
				)
				(<AND <VERB? DISMOUNT>
						<VERB-WORD? ,W?JUMP ,W?LEAP ,W?DIVE>
						<MC-PRSO? <> ,ROOMS ,RM-LEDGE ,GLOBAL-HERE ,LG-MOUNTAIN>
					>
					<RT-END-OF-GAME>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
	>
>

<ROUTINE RT-PS-RUBBLE ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
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
					<TELL "stones">
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<NOT <FSET? ,CH-DEMON ,FL-BROKEN>>
			<NP-CANT-SEE>
		)
		(<VERB? TAKE MOVE RAISE>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<TELL "The stones are much too heavy to move." CR>
		)
	>
>

<ROUTINE RT-PAST-DRAGON ("OPT" (QUIET <>))
	<COND
		(<OR	.QUIET
				<AND
					<FSET? ,CH-DRAGON ,FL-ASLEEP>
					<NOT <FSET? ,CH-DEMON ,FL-BROKEN>>
				>
			>
			<RETURN ,RM-CAVE>
		)
		(<FSET? ,CH-DEMON ,FL-BROKEN>
			<TELL
"The entrance to the cave is sealed off with large stones." CR
			>
			<RFALSE>
		)
		(,GL-DRAGON-CNT
			<TELL The ,WINNER " still can't get past" the ,CH-DRAGON "." CR>
			<RFALSE>
		)
		(T
			<RT-DRAGON-ANGRY-MSG>
			<RFALSE>
		)
	>
>

<CONSTANT K-WAKE-DRAGON-MSG
"The dragon opens one eye and casually swats you away with his tail, saying
\"Get away from me kid. Ya bother me.\" Lazily, he closes his eye again.|">
<CONSTANT K-HUSH-BOY-MSG
"\"Hush, boy! You're interrupting a valuable experiment in
self-anaesthesiology.\"|">

;"---------------------------------------------------------------------------"
; "CH-DRAGON"
;"---------------------------------------------------------------------------"

<OBJECT CH-DRAGON
	(LOC RM-LEDGE)
	(DESC "dragon")
	(FLAGS FL-ALIVE FL-NO-DESC FL-OPEN FL-PERSON FL-SEARCH)
	(SYNONYM DRAGON PEARLFENDER)
	(ADJECTIVE SLEEPING WALDO G)
	(CONTFCN RT-CH-DRAGON)
	(ACTION RT-CH-DRAGON)
>

; "CH-DRAGON flags:"
; "	FL-ASLEEP - Dragon has passed out from booze"

<CONSTANT K-AMOROUS-APPROACH-MSG
"In his drunken stupor, the dragon mistakes your action for an amorous
approach and he directs a playful wall of flame in your direction.
Fortunately, he currently sees two of you, and he flames the wrong one.|">

<ROUTINE RT-CH-DRAGON ("OPT" (CONTEXT <>))
	<COND
		(<AND <MC-CONTEXT? ,M-WINNER <>>
				<VERB? HELLO GOODBYE THANK>
			>
			<COND
				(<NOT <FSET? ,CH-DRAGON ,FL-ASLEEP>>
					<COND
						(,GL-DRAGON-CNT
							<TELL ,K-HUSH-BOY-MSG>
						)
						(T
							<TELL ,K-WAKE-DRAGON-MSG>
						)
					>
					<COND
						(<VERB? THANK>
							<COND
								(<NOT <FSET? ,CH-PLAYER ,FL-AIR>>
									<FSET ,CH-PLAYER ,FL-AIR>
									<RT-SCORE-MSG 10 0 0 0>
								)
							>
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
				(<FSET? ,CH-DRAGON ,FL-ASLEEP>
					<TELL The+verb ,CH-DRAGON "do" "n't respond." CR>
				)
			;	(<AND <VERB? WAKE>
						<MC-PRSO? ,ROOMS>
					>
				)
				(,GL-DRAGON-CNT
					<TELL ,K-HUSH-BOY-MSG>
				)
				(T
					<TELL ,K-WAKE-DRAGON-MSG>
				)
			>
		)
		(<MC-CONTEXT? ,M-CONT>
			<COND
				(<AND <NOT <FSET? ,CH-DRAGON ,FL-ASLEEP>>
						<TOUCH-VERB?>
					>
					<COND
						(,GL-DRAGON-CNT
							<TELL ,K-AMOROUS-APPROACH-MSG>
						)
						(T
							<RT-DRAGON-ANGRY-MSG>
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
				(<AND <VERB? GIVE SHOW>
						<MC-PRSO? ,TH-WHISKY-JUG ,TH-WHISKY>
					>
					<COND
						(<IN? ,TH-WHISKY ,TH-WHISKY-JUG>
							<SETG GL-DRAGON-CNT 1>
							<RT-QUEUE ,RT-I-DRAGON <+ ,GL-MOVES 1>>
							<MOVE ,TH-WHISKY-JUG ,CH-DRAGON>
							<REMOVE ,TH-WHISKY>
							<TELL The ,CH-DRAGON " ">
							<COND
								(<VERB? SHOW>
									<TELL "snatches the jug out of your hand">
								)
								(T
									<TELL "takes the jug">
								)
							>
							<TELL " and drains it. He begins to get tipsy." CR>
							<SETG GL-PICTURE-NUM ,K-PIC-DRAGON-DRUNK>
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
							<THIS-IS-IT ,TH-WHISKY-JUG>
							<TELL
"The dragon sniffs at the jug, but doesn't appear to be interested in it." CR
							>
						)
					>
				)
			>
		)
		(<AND <VERB? TELL>
				,P-CONT
			>
		; "Message and RFATAL if don't want dragon to become winner"
			<RFALSE>
		)
		(<VERB? ASK-ABOUT>
			<COND
				(<FSET? ,CH-DRAGON ,FL-ASLEEP>
					<TELL
The+verb ,CH-DRAGON "are" " in no condition to answer." CR
					>
				)
				(,GL-DRAGON-CNT
					<TELL ,K-HUSH-BOY-MSG>
				)
				(<MC-PRSI? ,RM-CAVE>
					<TELL
"\"A cozy little domicile. Free of the two banes of medieval life - children
and small dogs.\"" CR
					>
				)
				(<MC-PRSI? ,TH-WHISKY-JUG ,TH-WHISKY>
					<TELL
"\"Ah yes! I've heard of it. A tasty libation, no doubt.\"" CR
					>
				)
				(<MC-PRSI? ,CH-DRAGON ,CH-DEMON ,TH-MASTER>
					<TELL
"\"I was recently offered a choice by the gentleman who inhabits the cave. He
said he would either kill me and sell my hide for shoes, or let me become
the guardian of the cave. Times being what they were, I accepted the
job.\"" CR
					>
				)
				(<MC-PRSI? ,CH-MERLIN>
					<TELL
"\"Ah yes. A most auspicious practitioner of the mystical arts. Perhaps he
would be interested in retaining my cave-guarding expertise.\"" CR
					>
				)
				(<MC-PRSI? ,CH-LOT>
					<TELL
"\"He has greed in his eyes and larceny in his soul. A man after my own
heart.\"" CR
					>
				)
				(<MC-PRSI? ,TH-EXCALIBUR>
					<TELL
"\"The official position of the National Brotherhood of Dragons is that magic
swords are unreasonably dangerous and should be outlawed. I say leave the
blasted toad-sticker in the stone.\"" CR
					>
				)
				(<MC-PRSI? ,TH-NAME>
					<TELL "\"G. Waldo Pearlfender. At your service.\"" CR>
				)
				(<MC-PRSI? ,TH-CHIVALRY>
					<TELL
"\"Take my advice, my boy. Never give a sucker an even break.\"" CR
					>
				)
				(T
					<SETG GL-QUESTION 1>
					<TELL "\"Not now, boy. Can't you see I'm in misery?\"" CR>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,CH-DRAGON ,FL-SEEN>
			<TELL "The dragon has the bulbous red nose of a hard drinker">
			<COND
				(<IN? ,TH-DRAGON-HAIR ,CH-DRAGON>
					<TELL " and a single hair growing between his eyes">
				)
			>
			<TELL ".">
			<COND
				(<FSET? ,CH-DRAGON ,FL-ASLEEP>
					<TELL " It looks like he has passed out.">
				)
			>
			<CRLF>
		)
		(<VERB? WAKE>
			<COND
				(<FSET? ,CH-DRAGON ,FL-ASLEEP>
					<THIS-IS-IT ,CH-DRAGON>
					<TELL "You prod the dragon with your foot, but he doesn't stir." CR>
					<RT-AUTHOR-MSG "You'd have better luck trying to wake the dead.">
				)
				(,GL-DRAGON-CNT
					<TELL ,K-AMOROUS-APPROACH-MSG>
				)
				(T
					<RT-DRAGON-ANGRY-MSG>
				)
			>
		)
		(<VERB? ATTACK>
			<COND
				(<FSET? ,CH-DRAGON ,FL-ASLEEP>
					<THIS-IS-IT ,CH-DRAGON>
					<TELL "The dragon's tough hide repels your attack." CR>
				)
				(,GL-DRAGON-CNT
					<TELL ,K-AMOROUS-APPROACH-MSG>
				)
				(T
					<RT-DRAGON-ANGRY-MSG>
				)
			>
		)
	>
>

<ROUTINE RT-DRAGON-ANGRY-MSG ()
	<COND
		(<G? ,GL-ANGRY-CNT 2>
			<TELL
"The dragon says, \"Fine. OK. Have it your way.\" He slowly and painfully
pulls himself to his feet. Then he yawns, stretches, and casually fries you
to a cinder.|"
			>
			<RT-END-OF-GAME>
		)
		(T
			<INC GL-ANGRY-CNT>
			<COND
				(<VERB? YELL>
					<TELL "The dragon winces in pain, opens one eye,">
				)
				(<VERB? WAKE>
					<TELL
"You prod the dragon with your foot. He pries open one eye"
					>
				)
				(<VERB? ATTACK>
					<TELL
"The dragon's tough hide repels your attack. However, it annoys him enough
that he pries open one eye"
					>
				)
				(T
					<TELL
"As you approach the dragon, he opens an eye, swats you with his tail,"
					>
				)
			>
			<TELL " and says, ">
			<COND
				(<EQUAL? ,GL-ANGRY-CNT 1>
					<TELL
"\"Get away from me kid. Ya bother me.\" Lazily, he closes his eye again." CR
					>
				)
				(<EQUAL? ,GL-ANGRY-CNT 2>
					<TELL
"\"Now don't get me mad, son. I missed my last dose of medicinal spirits and
I'm in no mood for levity.\"" CR
					>
				)
				(<EQUAL? ,GL-ANGRY-CNT 3>
					<TELL "\"Don't push your luck, junior.\"" CR>
				)
			>
		)
	>
>

<GLOBAL GL-DRAGON-CNT 0 <> BYTE>
<GLOBAL GL-ANGRY-CNT 0 <> BYTE>

<ROUTINE RT-I-DRAGON ()
	<INC GL-DRAGON-CNT>
	<COND
		(<L? ,GL-DRAGON-CNT 4>
			<RT-QUEUE ,RT-I-DRAGON <+ ,GL-MOVES 1>>
		)
		(T
			<FSET ,CH-DRAGON ,FL-ASLEEP>
		)
	>
	<COND
		(<MC-HERE? ,RM-LEDGE>
			<TELL CR The ,CH-DRAGON " ">
			<COND
				(<EQUAL? ,GL-DRAGON-CNT 2>
					<TELL "starts to sing dragon drinking songs." CR>
				)
				(<EQUAL? ,GL-DRAGON-CNT 3>
					<TELL "tries to walk a straight line, and fails." CR>
				)
				(T
					<REMOVE ,TH-WHISKY-JUG>
					<TELL
"gets a lop-sided grin on his face and says, \"I'm not so think as you
drunk I am.\" He then crashes to the ground, out cold, smashing"
the ,TH-WHISKY-JUG " in the process.|"
					>
					<SETG GL-PICTURE-NUM ,K-PIC-DRAGON-OUT>
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
; "TH-DRAGON-HAIR"
;"---------------------------------------------------------------------------"

<OBJECT TH-DRAGON-HAIR
	(LOC CH-DRAGON)
	(DESC "dragon hair")
	(FLAGS FL-NO-DESC FL-TRY-TAKE)
	(SYNONYM HAIR)
	(ADJECTIVE DRAGON)
	(OWNER CH-DRAGON)
	(SCORE <ORB <LSH 3 ,K-EXPR-SHIFT> <LSH 1 ,K-QUEST-SHIFT>>)
	(SIZE 1)
	(ACTION RT-TH-DRAGON-HAIR)
>

<ROUTINE RT-TH-DRAGON-HAIR ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-DRAGON-HAIR ,FL-SEEN>
			<TELL "The hair is thick and wiry." CR>
		)
		(<NOT <IN? ,TH-DRAGON-HAIR ,CH-DRAGON>>
			<RFALSE>
		)
		(<VERB? TAKE>
			<TELL
The+verb ,WINNER "tug" " on" the ,TH-DRAGON-HAIR ", but it is too firmly
embedded to pluck out." CR
			>
		)
		(<AND <VERB? CUT>
				<FSET? ,PRSI ,FL-KNIFE>
			>
			<COND
				(<RT-DO-TAKE ,TH-DRAGON-HAIR T>
					<FCLEAR ,TH-DRAGON-HAIR ,FL-TRY-TAKE>
					<FSET ,TH-DRAGON-HAIR ,FL-TAKEABLE>
					<TELL "You now have" the ,TH-DRAGON-HAIR "." CR>
					<RT-SCORE-OBJ ,TH-DRAGON-HAIR>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-DRAGON-BODY"
;"---------------------------------------------------------------------------"

<OBJECT TH-DRAGON-BODY
	(LOC CH-DRAGON)
	(DESC "that part of the dragon's body")
	(FLAGS FL-NO-ARTICLE FL-NO-DESC FL-TRY-TAKE)
	(SYNONYM NOSE EYE EYES TAIL HEAD LEG LEGS FOOT FEET MOUTH BODY SKIN NECK CLAW)
	(ADJECTIVE RED BULBOUS LEFT RIGHT)
	(OWNER CH-DRAGON)
	(ACTION RT-TH-DRAGON-BODY)
>

<ROUTINE RT-TH-DRAGON-BODY ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(T
			<TELL ,K-NO-REFER-MSG D ,TH-DRAGON-BODY ".]" CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-CAVE"
;"---------------------------------------------------------------------------"

<ROOM RM-CAVE
	(LOC ROOMS)
	(DESC "cave")
	(FLAGS FL-LIGHTED FL-INDOORS)
	(SYNONYM CAVE)
	(ADJECTIVE MOUNTAIN)
	(SOUTH TO RM-LEDGE)
	(OUT TO RM-LEDGE)
	(NE TO RM-ICE-ROOM)
	(NW TO RM-BAS-LAIR)
	(SCORE <LSH 2 ,K-QUEST-SHIFT>)
	(GLOBAL LG-WALL)
	(ACTION RT-RM-CAVE)
	(THINGS
		(GHOSTLY SPECTRAL BLACK) (BOAR KRAKEN KNIGHT SPIRIT) RT-PS-GHOSTS
		(NE NW) (TUNNEL TUNNELS) RT-PS-TUNNEL
	)
>

<ROUTINE RT-RM-CAVE ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "You are" standing " in the entrance of">
				)
				(T
					<COND
						(<EQUAL? ,OHERE ,RM-LEDGE>
							<TELL "You enter">
						)
						(T
							<TELL "You return to the entrance of">
						)
					>
				)
			>
			<TELL
" the cave. A tunnel at the rear of the cave splits into two branches that
appear to go down into the mountain to the northwest and northeast.|"
			>
			<COND
				(<IN? ,TH-GHOSTS ,RM-CAVE>
					<FSET ,TH-GHOSTS ,FL-SEEN>
					<TELL
"|Ghostly apparitions rise up in front of you. They appear to block your
path.|"
					>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-EXIT>
			<COND
				(<AND <IN? ,TH-GHOSTS ,RM-CAVE>
						<NOT <EQUAL? ,P-WALK-DIR ,P?SOUTH ,P?OUT>>
					>
					<TELL
"You" walk " through the apparitions as if they weren't there.||"
					>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-CAVE>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTERED>
			<RT-QUEUE ,RT-I-GHOST ,GL-MOVES>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<AND <VERB? LISTEN>
						<MC-PRSO? <> ,ROOMS ,TH-GHOSTS>
					>
					<TELL
"The ghosts are wailing and howling like demons possessed."
					>
					<RT-GHOST-MORE>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
	>
>

<ROUTINE RT-PS-GHOSTS ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
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
					<TELL "ghosts">
				)
			>
		)
		(<MC-CONTEXT? ,M-WINNER>
			<TELL ,K-HOWL-MSG>
			<RT-GHOST-MORE>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<TOUCH-VERB?>
			<COND
				(<EQUAL? ,GL-GHOST-CNT 0>
					<THIS-IS-IT ,TH-GHOSTS>
					<TELL
"You clutch at the air around you, but the ghosts only seem to close in tighter."
					>
				)
				(<EQUAL? ,GL-GHOST-CNT 1>
					<THIS-IS-IT ,TH-GHOSTS>
					<TELL "They seem to crowd around you, shrieking in your ears.">
				)
				(T
					<THIS-IS-IT ,TH-GHOSTS>
					<TELL "You claw wildly at the ghosts.">
				)
			>
			<RT-GHOST-MORE>
		)
		(<AND <VERB? TELL>
				,P-CONT
			>
			<RFALSE>
		)
		(<AND <SPEAKING-VERB?>
				<IN? ,TH-GHOSTS ,HERE>
			>
			<TELL ,K-HOWL-MSG>
			<RT-GHOST-MORE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-GHOSTS"
;"---------------------------------------------------------------------------"

<OBJECT TH-GHOSTS
	(LOC RM-CAVE)
	(DESC "ghosts")
	(FLAGS FL-ALIVE FL-NO-DESC FL-PERSON FL-PLURAL)
	(SYNONYM GHOST GHOSTS APPARITION)
	(ADJECTIVE GHOSTLY)
	(ACTION RT-TH-GHOSTS)
>

<GLOBAL GL-GHOST-CNT 0 <> BYTE>

<CONSTANT K-HOWL-MSG "They howl at you in reply.">

<ROUTINE RT-TH-GHOSTS ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-WINNER>
			<TELL ,K-HOWL-MSG>
			<RT-GHOST-MORE>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<TELL
"The ghosts look terrifyingly real. They shriek and howl until you can barely
hear yourself think."
			>
			<RT-GHOST-MORE>
		)
		(<TOUCH-VERB?>
			<COND
				(<EQUAL? ,GL-GHOST-CNT 0>
					<THIS-IS-IT ,TH-GHOSTS>
					<TELL
"You clutch at the air around you, but the ghosts only seem to close in tighter."
					>
				)
				(<EQUAL? ,GL-GHOST-CNT 1>
					<THIS-IS-IT ,TH-GHOSTS>
					<TELL "They seem to crowd around you, shrieking in your ears.">
				)
				(T
					<THIS-IS-IT ,TH-GHOSTS>
					<TELL "You claw wildly at the ghosts.">
				)
			>
			<RT-GHOST-MORE>
		)
		(<AND <VERB? TELL>
				,P-CONT
			>
			<RFALSE>
		)
		(<AND <SPEAKING-VERB?>
				<IN? ,TH-GHOSTS ,HERE>
			>
			<TELL ,K-HOWL-MSG>
			<RT-GHOST-MORE>
		)
	>
>

<ROUTINE RT-GHOST-MORE ()
	<INC GL-GHOST-CNT>
	<THIS-IS-IT ,TH-GHOSTS>
	<TELL " The apparitions ">
	<COND
		(<L? ,GL-GHOST-CNT 3>
			<COND
				(<EQUAL? ,GL-GHOST-CNT 1>
					<TELL "begin to ">
				)
			>
			<TELL "take on more substance." CR>
		)
		(T
			<TELL "become real. They overpower you and you die.|">
			<RT-END-OF-GAME>
		)
	>
>

<CONSTANT K-GHOST-MSG-TBL
	<TABLE (PATTERN (BYTE WORD))
		<BYTE 1>
		<TABLE (PURE LENGTH)
"|Ghosts close in around you, shrieking and howling. They stand between you
and the interior of the cave.|"
"|A ghostly boar lowers his head and starts to charge at you!|"
"|Suddenly, the spirit of the black knight leaps forward and swings a phantom
sword at your head!|"
"|A spectral kraken slithers forward. His wraithlike tentacles start to wrap
themselves around you.|"
"|The apparitions join ghostly hands and dance in a circle around you.|"
		>
	>
>

<ROUTINE RT-I-GHOST ()
	<COND
		(<MC-HERE? ,RM-CAVE>
			<RT-QUEUE ,RT-I-GHOST <+ ,GL-MOVES 1>>
			<TELL <RT-PICK-NEXT ,K-GHOST-MSG-TBL>>
		)
	>
>

<ROUTINE RT-PS-TUNNEL ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
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
					<TELL "tunnel">
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE LOOK-IN LOOK-THRU>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<TELL "The tunnel is dark and forbidding." CR>
		)
		(<VERB? ENTER WALK-TO>
			<COND
				(<ADJ-USED? ,PSEUDO-OBJECT ,W?NE>
					<RT-DO-WALK ,P?NE>
				)
				(<ADJ-USED? ,PSEUDO-OBJECT ,W?NW>
					<RT-DO-WALK ,P?NW>
				)
			>
		)
	>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

