;"***************************************************************************"
; "game : Arthur"
; "file : LEPRCHAN.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   16 May 1989  1:18:10  $"
; "revs : $Revision:   1.96  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Leprechaun"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

<INCLUDE "PDEFS">		; "Because PARSE-ACTION used in this file."

;"---------------------------------------------------------------------------"
; "RM-GLADE"
;"---------------------------------------------------------------------------"

<ROOM RM-GLADE
	(LOC ROOMS)
	(DESC "glade")
	(FLAGS FL-LIGHTED)
	(SYNONYM GLADE CLEARING)
	(ADJECTIVE LEAFY FOREST)
	(NORTH PER RT-UNDERGROWTH)
	(NE PER RT-UNDERGROWTH)
	(EAST PER RT-UNDERGROWTH)
	(SE PER RT-UNDERGROWTH)
	(SOUTH TO RM-CHESTNUT-PATH)
	(SW PER RT-UNDERGROWTH)
	(WEST PER RT-BEHIND-ROCK)
	(NW PER RT-UNDERGROWTH)
	(UP PER RT-FLY-UP)
	(GLOBAL LG-ENCHANTED-TREES LG-FOREST RM-CHESTNUT-PATH)
	(ACTION RT-RM-GLADE)
	(THINGS
		FOOT (TRACKS FOOTPRINTS PRINTS) RT-PS-TRACKS
		<> (BUSH BUSHES UNDERGROWTH) RT-PS-UNDERGROWTH
	)
>

<ROUTINE RT-RM-GLADE ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "You are ">
					<COND
						(<IN? ,CH-PLAYER ,TH-BEHIND-ROCK>
							<COND
								(<EQUAL? ,GL-HIDING ,TH-ROCK>
									<TELL "hiding">
								)
								(T
									<TELL "standing">
								)
							>
							<TELL " behind" the ,TH-ROCK>
						)
						(T
							<TELL "standing">
						)
					>
				)
				(T
					<TELL "The track ends">
				)
			>
			<TELL
" in a leafy glade that is ringed by dense undergrowth. A well-worn path
of tiny footprints emerges from the bushes on one side of the clearing and
disappears into the undergrowth on the other side"
			>
			<COND
				(<NOT <EQUAL? ,GL-HIDING ,TH-ROCK>>
					<FSET ,TH-ROCK ,FL-SEEN>
					<TELL
", passing near a large rock that sits at the glade's westernmost edge"
					>
				)
			>
			<TELL ". The track leading back into the forest lies to the south.|">
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-GLADE>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTERED>
			<COND
				(<NOT <FSET? ,CH-LEPRECHAUN ,FL-LOCKED>>
					<FCLEAR ,TH-ROCK ,FL-LOCKED>
					<RT-QUEUE ,RT-I-LEP-3 <+ ,GL-MOVES 2>>
				)
			>
		)
		(<MC-CONTEXT? ,M-EXIT>
			<RT-DEQUEUE ,RT-I-LEP-1>
			<RT-DEQUEUE ,RT-I-LEP-2>
			<RT-DEQUEUE ,RT-I-LEP-3>
			<RT-DEQUEUE ,RT-I-LEP-4>
			<RFALSE>
		)
		(.CONTEXT
			<RFALSE>
		)
	>
>

<ROUTINE RT-PS-TRACKS ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<FSET ,PSEUDO-OBJECT ,FL-PLURAL>
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
					<TELL "footprints">
				)
			>
		)
		(<VERB? EXAMINE>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<TELL "They look like footprints from tiny shoes." CR>
		)
	;	(<VERB? FOLLOW>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<TELL
"The tracks disappear into the dense undergrowth. You can't follow them." CR
			>
		)
	>
>

<ROUTINE RT-PS-UNDERGROWTH ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<FCLEAR ,PSEUDO-OBJECT ,FL-PLURAL>
	<FSET ,PSEUDO-OBJECT ,FL-VOWEL>
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
					<TELL "undergrowth">
				)
			>
		)
		(<VERB? EXAMINE LOOK-IN>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<TELL
"You peer into the undergrowth, but it's so dense that you can't see much." CR
			>
		)
		(<VERB? ENTER>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<RT-UNDERGROWTH>
			<RTRUE>
		)
	>
>

<ROUTINE RT-UNDERGROWTH ("OPT" (QUIET <>))
	<COND
		(<NOT .QUIET>
			<TELL "The undergrowth is too thick to pass through." CR>
		)
	>
	<RFALSE>
>

;"---------------------------------------------------------------------------"
; "CH-LEPRECHAUN"
;"---------------------------------------------------------------------------"

<OBJECT CH-LEPRECHAUN
	(FLAGS FL-ALIVE FL-HAS-SDESC FL-TRY-TAKE FL-OPEN FL-PERSON FL-SEARCH)
	(SYNONYM LEPRECHAUN SPRITE MAN PERSON)
	(ADJECTIVE LITTLE SMALL)
	(ACTION RT-CH-LEPRECHAUN)
>

; "CH-LEPRECHAUN flags:"
; "	FL-LOCKED - Leprechaun has gotten spices and stays home."

<CONSTANT K-DISAPPEARS-MSG " disappears into the undergrowth.">

<GLOBAL GL-VOICE?:FLAG <> <> BYTE>

<ROUTINE RT-CH-LEPRECHAUN ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<COND
		(<MC-CONTEXT? ,M-OBJDESC>
			<COND
				(.ART
					<PRINT-ARTICLE ,CH-LEPRECHAUN .ART .CAP?>
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
						(<MC-PROB? 50>
							<TELL "leprechaun">
						)
						(T
							<TELL "small person">
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-WINNER>
			<RT-L-STARTLED-MSG>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,CH-LEPRECHAUN ,FL-SEEN>
			<TELL The ,CH-LEPRECHAUN " is dressed all in green." CR>
		)
		(<VERB? TAKE CLIMB-ON>
			<RT-JUMP-L-MSG>
		)
	>
>

<ROUTINE RT-JUMP-L-MSG ()
	<MOVE ,CH-PLAYER ,RM-GLADE>
	<SETG GL-HIDING <>>
	<TELL "You">
	<COND
		(<MC-FORM? ,K-FORM-ARTHUR>
			<TELL " leap">
		)
		(T
			<TELL walk>
		)
	>
	<TELL " out from behind the stone">
	<COND
		(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
			<RT-DEQUEUE ,RT-I-LEP-4>
			<RT-DEQUEUE ,RT-I-LEP-5>
			<REMOVE ,CH-LEPRECHAUN>
			<RT-QUEUE ,RT-I-LEP-1 <+ ,GL-MOVES 3>>
			<TELL ". Startled by your sudden movement," the ,CH-LEPRECHAUN>
			<COND
				(<IN? ,TH-SPICE-BOTTLE ,CH-LEPRECHAUN>
					<MOVE ,TH-SPICE-BOTTLE ,RM-GLADE>
					<TELL " drops the bottle and">
				)
			>
			<TELL " dives into the undergrowth saying," ,K-SPRITE-MSG CR>
		)
		(<IN? ,TH-SPICE-BOTTLE ,CH-LEPRECHAUN>
			<RT-DEQUEUE ,RT-I-LEP-4>
			<RT-DEQUEUE ,RT-I-LEP-5>
			<REMOVE ,CH-LEPRECHAUN>
			<FSET ,CH-LEPRECHAUN ,FL-LOCKED>
			<TELL
" and grab the leprechaun. He struggles to get free, but you hold on tight and
after a while he gives up. \"Ye caught me fair n' square, laddie,\" he says.
\"Now I'm beholden t'give ye something special. I regret t'tell ye that
the tales of the leprechaun's crock of gold are truly nought but a crock
themselves. But what I can give ye is this jug of home-brewed whisky, which
to any drinkin' man is worth more than gold itself.\" He produces a jug
and gives it to you. As you take it from him, he wriggles free
and" ,K-DISAPPEARS-MSG CR
			>
			<COND
				(<RT-DO-TAKE ,TH-WHISKY-JUG T>
					<RT-SCORE-MSG 0 3 0 1>
				)
			>
		)
		(T
			<TELL " and make a dive for the little man. ">
			<RT-L-STARTLED-MSG>
		)
	>
	<SETG GL-PICTURE-NUM ,K-PIC-GLADE>
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

<CONSTANT K-SPRITE-MSG
" \"Try, try, as hard as ye might. Ye won't catch me, I'm too fast a sprite.\""
>

<ROUTINE RT-L-STARTLED-MSG ()
	<REMOVE ,CH-LEPRECHAUN>
	<RT-DEQUEUE ,RT-I-LEP-4>
	<RT-DEQUEUE ,RT-I-LEP-5>
	<RT-QUEUE ,RT-I-LEP-1 <+ ,GL-MOVES 3>>
	<COND
		(<VERB? TRANSFORM>
			<TELL
"The leprechaun catches sight of you before you can crouch down. "
			>
		)
	>
	<TELL "Momentarily startled, ">
	<COND
		(<VERB? TRANSFORM>
			<TELL "he">
		)
		(T
			<TELL "the leprechaun">
		)
	>
	<TELL
" quickly recovers his composure and leaps into the bushes at the edge of the
clearing. As he disappears, his tiny voice trails after him in triumph,"
,K-SPRITE-MSG CR
	>
	<COND
		(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
			<RT-UPDATE-PICT-WINDOW>
		)
	>
	<RTRUE>
>

<ROUTINE RT-I-LEP-1 ()
	<COND
		(<FSET? ,CH-PLAYER ,FL-ASLEEP>
			<RT-QUEUE ,RT-I-LEP-1 <+ <RT-IS-QUEUED? ,RT-I-SLEEP> 3>>
			<RFALSE>
		)
		(<MC-HERE? ,RM-GLADE>
			<RT-QUEUE ,RT-I-LEP-2 <+ ,GL-MOVES 1>>
			<SETG GL-VOICE? T>
			<COND
				(<EQUAL? ,GL-HIDING ,TH-ROCK>
					<TELL
"|You hear a strange murmuring coming from beneath" the ,TH-ROCK "." CR
					>
				)
			>
		)
	>
>

<ROUTINE RT-I-LEP-2 ()
	<COND
		(<MC-HERE? ,RM-GLADE>
			<RT-QUEUE ,RT-I-LEP-3 <+ ,GL-MOVES 2>>
			<SETG GL-VOICE? <>>
			<RFALSE>
		)
	>
>

<ROUTINE RT-I-LEP-3 ()
	<COND
		(<FSET? ,CH-PLAYER ,FL-ASLEEP>
			<RT-QUEUE ,RT-I-LEP-1 <+ <RT-IS-QUEUED? ,RT-I-SLEEP> 3>>
			<RFALSE>
		)
		(<MC-HERE? ,RM-GLADE>
			<TELL "|You ">
			<COND
				(<EQUAL? ,GL-HIDING ,TH-ROCK>
					<COND
						(<FSET? ,TH-HEAD ,FL-LOCKED>
							<FCLEAR ,TH-HEAD ,FL-LOCKED>
							<TELL
"hear a noise and decide to poke your head out for a look. You "
							>
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
					<FSET ,CH-LEPRECHAUN ,FL-SEEN>
					<TELL
"see a leprechaun dressed all in green emerge from one side of"
the ,RM-GLADE "."
					>
					<COND
						(<IN? ,TH-SPICE-BOTTLE ,RM-GLADE>
							<TELL
" In the middle of" the ,RM-GLADE "," the ,CH-LEPRECHAUN " sees"
the ,TH-SPICE-BOTTLE ". He picks it up and says, \"Faith and it's just what
I've been lookin' for. A fine bottle of spices from the east.\" He "
							>
							<COND
								(<IN? ,TH-SPICE ,TH-SPICE-BOTTLE>
									<RT-QUEUE ,RT-I-LEP-4 <+ ,GL-MOVES 1>>
									<MOVE ,CH-LEPRECHAUN ,RM-GLADE>
									<MOVE ,TH-SPICE-BOTTLE ,CH-LEPRECHAUN>
									<TELL "examines the label intently." CR>
									<COND
										(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
											<RT-UPDATE-PICT-WINDOW>
										)
									>
								)
								(T
									<RT-QUEUE ,RT-I-LEP-1 <+ ,GL-MOVES 3>>
									<REMOVE ,CH-LEPRECHAUN>
									<TELL
"peers into the bottle and exclaims, \"Bah! Empty.\" He drops the bottle and
looks around saying, \"Now what silly ass has been littering the forest with
empty bottles?\" He spies you hiding behind the rock, dives into the
undergrowth, and cries out," ,K-SPRITE-MSG CR
									>
								)
							>
						)
						(T
							<CRLF>
							<RT-QUEUE ,RT-I-LEP-4 <+ ,GL-MOVES 1>>
							<MOVE ,CH-LEPRECHAUN ,RM-GLADE>
							<COND
								(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
									<RT-UPDATE-PICT-WINDOW>
								)
							>
						)
					>
					<RTRUE>
				)
				(T
					<RT-QUEUE ,RT-I-LEP-1 <+ ,GL-MOVES 3>>
					<TELL
"hear a rustling in the undergrowth, as if something had approached"
the ,RM-GLADE ", but decided not to cross upon seeing you there." CR
					>
				)
			>
		)
	>
>

<ROUTINE RT-I-LEP-4 ()
	<COND
		(<FSET? ,CH-PLAYER ,FL-ASLEEP>
			<REMOVE ,CH-LEPRECHAUN>
			<COND
				(<IN? ,TH-SPICE-BOTTLE ,CH-LEPRECHAUN>
					<FSET ,CH-LEPRECHAUN ,FL-LOCKED>
				)
				(T
					<RT-QUEUE ,RT-I-LEP-1 <+ <RT-IS-QUEUED? ,RT-I-SLEEP> 3>>
				)
			>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
					<RT-UPDATE-DESC-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-HERE? ,RM-GLADE>
			<COND
				(<IN? ,CH-LEPRECHAUN ,RM-GLADE>
					<COND
						(<IN? ,TH-SPICE-BOTTLE ,CH-LEPRECHAUN>
							<RT-QUEUE ,RT-I-LEP-5 <+ ,GL-MOVES 1>>
							<TELL CR The ,CH-LEPRECHAUN " finishes reading the label." CR>
						)
						(T
							<RT-QUEUE ,RT-I-LEP-1 <+ ,GL-MOVES 2>>
							<REMOVE ,CH-LEPRECHAUN>
							<TELL CR The ,CH-LEPRECHAUN ,K-DISAPPEARS-MSG CR>
							<COND
								(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
									<RT-UPDATE-PICT-WINDOW>
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

<ROUTINE RT-I-LEP-5 ()
	<COND
		(<AND <MC-HERE? ,RM-GLADE>
				<IN? ,CH-LEPRECHAUN ,RM-GLADE>
			>
			<REMOVE ,CH-LEPRECHAUN>
			<FSET ,CH-LEPRECHAUN ,FL-LOCKED>
			<TELL CR The ,CH-LEPRECHAUN ,K-DISAPPEARS-MSG CR>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RTRUE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-ROCK"
;"---------------------------------------------------------------------------"

<OBJECT TH-ROCK
	(LOC RM-GLADE)
	(DESC "rock")
	(FLAGS FL-NO-DESC)
	(SYNONYM ROCK STONE MURMUR MURMURING MURMURRING VOICE SOUND)
	(ADJECTIVE LARGE)
	(ACTION RT-TH-ROCK)
>

; "TH-ROCK flags:"
; "	FL-BROKEN - Player has heard murmuring"
; "	FL-LOCKED - Leprechaun loop shouldn't be reset when hide behind rock."

<ROUTINE RT-TH-ROCK ("OPT" (CONTEXT <>))
	<COND
	;	(<AND <VERB? LISTEN>
				<RT-IS-QUEUED? ,RT-I-LEP-2>
			>
			<SETG GL-VOICE? T>
		)
		(<VERB? HIDE-BEHIND>
			<RT-BEHIND-ROCK>
			<RTRUE>
		)
		(<VERB? LOOK-BEHIND>
			<COND
				(<SEE-ANYTHING-IN? ,TH-BEHIND-ROCK>
					<TELL "You see">
					<PRINT-CONTENTS ,TH-BEHIND-ROCK>
					<TELL " behind" the ,TH-ROCK "." CR>
				)
			>
		)
		(<AND <VERB? EXIT>
				<IN? ,CH-PLAYER ,TH-BEHIND-ROCK>
			>
			<RT-DO-WALK ,P?EAST>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-BEHIND-ROCK"
;"---------------------------------------------------------------------------"

<OBJECT TH-BEHIND-ROCK
	(LOC RM-GLADE)
	(DESC "behind the rock")
	(FLAGS FL-CONTAINER FL-NO-ARTICLE FL-NO-DESC FL-OPEN FL-SEARCH)
	(NORTH PER RT-UNDERGROWTH)
	(EAST PER RT-LEAVE-ROCK)
	(SOUTH PER RT-UNDERGROWTH)
	(WEST PER RT-UNDERGROWTH)
	(OUT PER RT-LEAVE-ROCK)
	(CAPACITY K-CAP-MAX)
	(ACTION RT-TH-BEHIND-ROCK)
>

<ROUTINE RT-TH-BEHIND-ROCK ("OPT" (CONTEXT <>) "AUX" L)
	<COND
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<VERB? LISTEN>
					<COND
						(<MC-PRSO? <> ,ROOMS ,TH-GROUND ,TH-ROCK>
							<COND
								(,GL-VOICE?
									<FSET ,TH-ROCK ,FL-BROKEN>
									<TELL
"A tiny voice floats up from somewhere below" the ,TH-ROCK ". \"'Tis no good
t'all. There's no taste to't. 'Tis flat as an Englishman's head. I'll cook it
a while longer and then try't again.\"" CR
									>
								)
								(<FSET? ,TH-ROCK ,FL-BROKEN>
									<TELL "The murmuring has stopped." CR>
								)
							>
						)
					>
				)
				(<AND <VERB? TELL>
						,P-CONT
					>
					<RFALSE>
				)
				(<AND <VERB? TAKE CLIMB-ON>
						<MC-PRSO? ,CH-LEPRECHAUN>
					>
					<RFALSE>
				)
				(<VERB? WALK>
					<RFALSE>
				)
				(<OR	<AND
							<VERB? PUT-IN>
							<MC-PRSI? ,RM-GLADE>
						>
						<AND
							<VERB? THROW>
							<IN? ,PRSI ,RM-GLADE>
						>
					>
					<COND
						(<OR	<PRE-PUT>
								<NOT <IDROP>>
							>
							<RTRUE>
						)
						(<IN? ,CH-LEPRECHAUN ,RM-GLADE>
							<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT ,K-UPD-OBJS>>
							<MOVE ,PRSO ,RM-GLADE>
							<RT-L-STARTLED-MSG>
						)
						(T
							<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT ,K-UPD-OBJS>>
							<MOVE ,PRSO ,RM-GLADE>
							<TELL
The+verb ,WINNER "toss" the ,PRSO " into" the ,RM-GLADE "." CR
							>
						)
					>
				)
				(<AND <IN? ,CH-LEPRECHAUN ,RM-GLADE>
						<UNHIDE-VERB?>
					>
					<RT-L-STARTLED-MSG>
					<RTRUE>
				)
				(<TOUCH-VERB?>
					<SET L <LOC ,CH-PLAYER>>
					<COND
						(,PRSO
							<COND
								(<OR	<MC-PRSO? ,ROOMS>
										<EQUAL? <LOC ,PRSO> ,GLOBAL-OBJECTS ,GENERIC-OBJECTS>
									>
								)
								(<NOT <RT-META-IN? ,PRSO .L>>
									<COND
										(<MC-PRSO? ,TH-ROCK>
											<>
										)
										(T
											<RT-CANT-REACH-MSG ,PRSO .L>
											<RTRUE>
										)
									>
								)
							>
						)
					>
					<COND
						(,PRSI
							<COND
								(<OR	<MC-PRSI? ,ROOMS>
										<EQUAL? <LOC ,PRSI> ,GLOBAL-OBJECTS ,GENERIC-OBJECTS>
									>
									<RFALSE>
								)
								(<NOT <RT-META-IN? ,PRSI .L>>
									<COND
										(<MC-PRSI? ,TH-ROCK>
											<RFALSE>
										)
										(T
											<RT-CANT-REACH-MSG ,PRSI .L>
										)
									>
								)
							>
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-END>
			<COND
				(<AND <IN? ,CH-LEPRECHAUN ,RM-GLADE>
						<VERB? TRANSFORM>
						<NOT <MC-FORM? ,GL-OLD-FORM>>
						<MC-FORM? ,K-FORM-ARTHUR>
					>
					<RT-L-STARTLED-MSG>
				)
			>
		)
	>
>

<ROUTINE RT-BEHIND-ROCK ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<RFALSE>
		)
		(<EQUAL? ,GL-HIDING ,TH-ROCK>
			<RT-ALREADY-MSG ,WINNER "behind the rock">
		)
		(<AND <MC-FORM? ,K-FORM-TURTLE>
				<PRE-WALK>
			>
			<RTRUE>
		)
		(T
			<MOVE ,WINNER ,TH-BEHIND-ROCK>
			<SETG GL-HIDING ,TH-ROCK>
			<TELL
The+verb ,WINNER "hide" " behind" the ,TH-ROCK ". You peer around it and
discover that your hiding place affords an excellent view of the
clearing." CR
			>
			<COND
				(<NOT <FSET? ,CH-LEPRECHAUN ,FL-LOCKED>>
					<COND
						(<NOT <FSET? ,TH-ROCK ,FL-LOCKED>>
							<FSET ,TH-ROCK ,FL-LOCKED>
							<RT-DEQUEUE ,RT-I-LEP-1>
							<RT-DEQUEUE ,RT-I-LEP-2>
							<RT-DEQUEUE ,RT-I-LEP-3>
							<RT-DEQUEUE ,RT-I-LEP-4>
							<RT-QUEUE ,RT-I-LEP-1 ,GL-MOVES>
						)
					>
				)
			>
			<SETG GL-PICTURE-NUM ,K-PIC-GLADE-ROCK>
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
	<RFALSE>
>

<ROUTINE RT-LEAVE-ROCK ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<RETURN ,RM-GLADE>
		)
		(<EQUAL? ,GL-HIDING ,TH-ROCK>
			<MOVE ,WINNER ,RM-GLADE>
			<SETG GL-HIDING <>>
			<COND
				(<IN? ,CH-LEPRECHAUN ,RM-GLADE>
					<RT-JUMP-L-MSG>
				)
				(T
					<TELL The+verb ,WINNER "emerge" " from">
					<COND
						(<EQUAL? ,GL-HIDING ,TH-ROCK>
							<TELL " hiding">
						)
					>
					<TELL
the ,TH-BEHIND-ROCK " and" verb ,WINNER "are" " now in" the ,RM-GLADE "." CR
					>
				)
			>
			<SETG GL-PICTURE-NUM ,K-PIC-GLADE>
			<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
					<RT-UPDATE-DESC-WINDOW>
				)
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(T
			<RT-UNDERGROWTH>
			<RFALSE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-WHISKY-JUG"
;"---------------------------------------------------------------------------"

<OBJECT TH-WHISKY-JUG
	(DESC "whisky jug")
	(FLAGS FL-CONTAINER FL-OPEN FL-SEARCH FL-TAKEABLE)
	(SYNONYM JUG WHISKY WHISKEY NECK)
	(ADJECTIVE WHISKY WHISKEY)
	(OWNER TH-WHISKY-JUG)	;"for JUG'S NECK"
	(SIZE 5 CAPACITY 1)
	(GENERIC RT-GN-WHISKY)
	(ACTION RT-TH-WHISKY-JUG)
>

<CONSTANT K-EVAPORATES-MSG " It quickly evaporates.">

<ROUTINE RT-TH-WHISKY-JUG ("OPT" (CONTEXT <>) "AUX" N TBL OBJ)
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<COND
				(<VERB? PUT-IN EMPTY>
					<THIS-IS-IT ,TH-WHISKY-JUG>
					<TELL "The jug's neck is too narrow." CR>
				)
			>
		)
		(<VERB? DRINK-FROM>
			<COND
				(<IN? ,TH-WHISKY ,TH-WHISKY-JUG>
					<PERFORM ,V?DRINK ,TH-WHISKY>
					<RTRUE>
				)
				(<IN? ,TH-WATER ,TH-WHISKY-JUG>
					<PERFORM ,V?DRINK ,TH-WATER>
					<RTRUE>
				)
				(T
					<TELL "There is nothing to drink in" the ,TH-WHISKY-JUG "." CR>
				)
			>
		)
		(<VERB? EXAMINE READ>
			<FSET ,TH-WHISKY-JUG ,FL-SEEN>
			<RT-CENTER-STRING "XXX">
			<RT-CENTER-STRING "MOTHER MACREE'S IRISH WHISKY">
		)
		(<VERB? FILL>
			<COND
				(<AND <MC-PRSI? ,TH-BARREL>
						<NOT <IN? ,TH-BARREL-WATER ,TH-BARREL>>
					>
					<TELL "There isn't any water in" the ,TH-BARREL "." CR>
				)
				(<MC-PRSI? ,LG-LAKE ,RM-SHALLOWS ,LG-RIVER ,RM-FORD ,TH-BARREL-WATER ,TH-BARREL>
					<COND
						(<OR	<IN? ,TH-WHISKY ,TH-WHISKY-JUG>
								<IN? ,TH-WATER ,TH-WHISKY-JUG>
							>
							<TELL
The ,TH-WHISKY-JUG " is already filled with " D <FIRST? ,TH-WHISKY-JUG> "." CR
							>
						)
						(T
							<MOVE ,TH-WATER ,TH-WHISKY-JUG>
							<TELL
The+verb ,WINNER "fill" the ,TH-WHISKY-JUG " with " D ,TH-WATER "." CR
							>
						)
					>
				)
			>
		)
		(<VERB? EMPTY>
			<COND
				(<OR	<IN? ,TH-WHISKY ,TH-WHISKY-JUG>
						<IN? ,TH-WATER ,TH-WHISKY-JUG>
					>
					<SET OBJ <FIRST? ,TH-WHISKY-JUG>>
					<REMOVE .OBJ>
					<TELL
The+verb ,WINNER "pour" the .OBJ " out of" the ,TH-WHISKY-JUG "."
					>
					<COND
						(<AND <EQUAL? .OBJ ,TH-WHISKY>
								<MC-PRSI? ,TH-COTTAGE-FIRE ,TH-TAVERN-FIRE ,TH-CASTLE-FIRE>
							>
							<TELL
" As soon as the first drop of the incredibly potent brew hits" the ,PRSI
", a powerful explosion rips through" the ,HERE ", levelling everything in
it, including you." CR
							>
							<RT-END-OF-GAME>
						)
						(<FSET? ,HERE ,FL-WATER>
							<TELL " It disappears into the water.">
						)
						(T
							<TELL ,K-EVAPORATES-MSG>
						)
					>
					<CRLF>
					<COND
						(<EQUAL? .OBJ ,TH-WHISKY>
							<RT-SCORE-MSG 0 -1 0 0>
						)
					>
					<RTRUE>
				)
			>
		)
		(<VERB? OPEN>
			<RT-ALREADY-MSG ,TH-WHISKY-JUG "open">
		)
		(<VERB? BREAK>
			<REMOVE ,TH-WHISKY-JUG>
			<TELL "You smash" the ,TH-WHISKY-JUG ", and it shatters into a thousand pieces." CR>
			<RT-SCORE-MSG 0 -3 0 0>
		)
	>
>

<ROUTINE RT-GN-WHISKY (TBL FINDER)
	<COND
		(<EQUAL? <PARSE-ACTION ,PARSE-RESULT> ,V?DRINK ,V?EAT ,V?ASK-ABOUT>
			<RETURN ,TH-WHISKY>
		)
		(T
			<TELL "[" The ,TH-WHISKY-JUG "]" CR>
			<RETURN ,TH-WHISKY-JUG>
		)
	>
>

<ROUTINE RT-PUT-WHISKY-IN-FIRE-MSG (FIRE)
	<TELL
"You toss the jug" in .FIRE "to" the .FIRE ". Seconds later, a powerful
explosion rips through" the ,HERE ", levelling everything in it, including
you." CR
	>
	<RT-END-OF-GAME>
>

;"---------------------------------------------------------------------------"
; "TH-WHISKY"
;"---------------------------------------------------------------------------"

<OBJECT TH-WHISKY
	(LOC TH-WHISKY-JUG)
	(DESC "whisky")
	(FLAGS FL-COLLECTIVE FL-PLURAL FL-WATER)
	(SYNONYM WHISKY WHISKEY ELIXIR)
	(ADJECTIVE GOLDEN)
	(SIZE 1)
	(GENERIC RT-GN-WHISKY)
	(ACTION RT-TH-WHISKY)
>

<GLOBAL GL-WHISKY-DRINK 0 <> BYTE>

<ROUTINE RT-TH-WHISKY ("OPT" (CONTEXT <>))
	<COND
		(<VERB? DRINK EAT>
			<INC GL-WHISKY-DRINK>
			<COND
				(<L? ,GL-WHISKY-DRINK 4>
					<TELL "You take a few sips. ">
					<COND
						(<EQUAL? ,GL-WHISKY-DRINK 1>
							<TELL
"Unaccustomed as you are to alcohol, your head soon starts to spin and you
realize that it would be unwise to drink any more." CR
							>
						)
						(T
							<TELL "Your head spins." CR>
							<RT-SCORE-MSG 0 -3 0 0>
							<COND
								(<EQUAL? ,GL-WHISKY-DRINK 3>
									<RT-AUTHOR-MSG "Lush.">
								)
							>
						)
					>
				)
				(T
					<TELL
"You drain the bottle and pass out. You sleep for a long time, awakened
finally by the noise of the celebration of Lot's coronation.|"
					>
					<RT-END-OF-GAME>
				)
			>
			<RTRUE>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-WHISKY ,FL-SEEN>
			<TELL "It has a deep, amber colour." CR>
		)
	>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

