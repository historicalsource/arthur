;"***************************************************************************"
; "game : Arthur"
; "file : TAVERN.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   13 May 1989 17:40:56  $"
; "rev  : $Revision:   1.74  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Village tavern"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "RM-TAVERN"
;"---------------------------------------------------------------------------"

<ROOM RM-TAVERN
	(LOC ROOMS)
	(DESC "tavern")
	(FLAGS FL-INDOORS FL-LIGHTED)
	(SYNONYM TAVERN BUILDING)
	(NORTH TO RM-TOWN-SQUARE)
	(OUT TO RM-TOWN-SQUARE)
	(SOUTH TO RM-TAV-KITCHEN)
	(IN TO RM-TAV-KITCHEN)
	(GLOBAL LG-THATCH LG-WALL RM-TOWN-SQUARE RM-TAV-KITCHEN)
	(ACTION RT-RM-TAVERN)
	(THINGS
		<> SMOKE RT-PS-SMOKE
		<> (SHADOW SHADOWS) RT-PS-SHADOWS
		<> TABLE RT-PS-TABLE
	)
>

<ROUTINE RT-RM-TAVERN ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<AND <VERB? LISTEN>
						<MC-PRSO? <> ,ROOMS ,CH-FARMERS>
					>
					<SETG GL-MEN-TALK? T>
					<RT-I-MEN-TALK>
					<SETG GL-MEN-TALK? <>>
					<RTRUE>
				)
				(T
					<SETG GL-MEN-TALK? T>
					<COND
						(<VERB? YELL>
							<TELL ,K-FARMER-CUFFS-MSG>
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-TAVERN>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTERED>
			<COND
				(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
					<TELL
"|One of the farmers says," ,K-GET-OUT-MSG form ".\" He waves his arms and
shoos you out the door into the town square.||"
					>
					<RT-GOTO ,RM-TOWN-SQUARE T>
				)
				(<EQUAL? ,OHERE ,RM-TOWN-SQUARE>
					<COND
						(<ZERO? ,GL-MEN-NUM>
							<SETG GL-MEN-NUM 1>
						)
					>
					<SETG GL-MEN-START 0>
					<SETG GL-MEN-TALK? T>
					<RT-QUEUE ,RT-I-MEN-TALK <+ ,GL-MOVES 1>>
					<MOVE ,CH-COOK ,RM-TAV-KITCHEN>
					<RT-QUEUE ,RT-I-COOK <+ ,GL-MOVES 4 <RANDOM 4>>>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-EXIT>
			<COND
				(<EQUAL? ,P-WALK-DIR ,P?NORTH ,P?OUT>
					<RT-RESET-TAVERN>
					<RT-RESET-KITCHEN>
					<RFALSE>
				)
			>
		)
		(<MC-CONTEXT? ,M-END>
			<COND
				(<VERB? TRANSFORM>
					<COND
						(<NOT <MC-FORM? ,GL-OLD-FORM>>
							<TELL
"\"Sorcery!! Work of the Devil!!\" A farmer picks up a knife and skewers you
through the heart." ,K-HEEDED-WARNING-MSG
							>
							<RT-END-OF-GAME>
						)
						(,GL-FORM-ABORT
							<TELL
"|Fortunately, it all happened so quickly that" the ,CH-FARMERS " didn't notice." CR
							>
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL The+verb ,WINNER "are" standing " in">
				)
				(T
					<COND
						(<FSET? ,RM-TAVERN ,FL-TOUCHED>
							<TELL The+verb ,WINNER "go" " back into">
						)
						(T
							<TELL The+verb ,WINNER "enter">
						)
					>
				)
			>
			<TELL " the gloomy, smoke-filled tavern. ">
			<COND
				(<L? <MOD ,GL-MOVES 1440> 720>
					<TELL "Despite the early hour, s">
				)
				(T
					<TELL "S">
				)
			>
			<FSET ,CH-FARMERS ,FL-SEEN>
			<THIS-IS-IT ,CH-FARMERS>
			<TELL
"ome farmers are hunched around the fire in conspiratorial conversation."
			>
			<COND
				(<NOT <MC-CONTEXT? ,M-LOOK>>
					<COND
						(<MC-FORM? ,K-FORM-ARTHUR>
							<TELL
" They look up in alarm when you come in, then return to their conversation
when they see only a boy."
							>
						)
					>
				)
			>
			<COND
				(<IN? ,CH-COOK ,RM-TAVERN>
					<TELL "||The cook is here, serving more ale to the farmers.">
				)
			>
			<TELL "||The tavern's kitchen is to the south.|">
			<RFALSE>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<COND
				(<NOT <MC-HERE? ,RM-TAVERN ,RM-TAV-KITCHEN>>
					<FSET ,RM-TAVERN ,FL-SEEN>
					<TELL
"It is a half-timbered, one-story building with a thatched roof." CR
					>
				)
			>
		)
	>
>

<ROUTINE RT-RESET-TAVERN ()
	<RT-DEQUEUE ,RT-I-MEN-TALK>
	<MOVE ,CH-COOK ,RM-TAV-KITCHEN>
	<FSET ,TH-TAVERN-TABLE ,FL-NO-LIST>
	<FSET ,TH-CUPBOARD ,FL-NO-LIST>
	<FSET ,TH-CAGE ,FL-NO-LIST>
	<FSET ,TH-BIRD ,FL-NO-LIST>
	<FSET ,CH-COOK ,FL-NO-LIST>
	<RT-DEQUEUE ,RT-I-COOK>
>

<ROUTINE RT-PS-SMOKE ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
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
					<TELL "smoke">
				)
			>
		)
		(<VERB? EXAMINE>
			<TELL
"The smoke curls up and escapes through a hole in the thatched roof." CR
			>
		)
	>
>

<ROUTINE RT-PS-SHADOWS ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
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
					<TELL "shadows">
				)
			>
		)
		(<VERB? EXAMINE>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<TELL "The shadows dance and leap on the walls." CR>
		)
	>
>

<ROUTINE RT-PS-TABLE ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
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
					<TELL "table">
				)
			>
		)
		(<TOUCH-VERB?>
			<TELL ,K-FARMER-CUFFS-MSG>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-TAVERN-FIRE"
;"---------------------------------------------------------------------------"

<OBJECT TH-TAVERN-FIRE
	(LOC RM-TAVERN)
	(DESC "fire")
	(FLAGS FL-BURNABLE FL-CONTAINER FL-LIGHTED FL-OPEN FL-SEARCH FL-NO-DESC)
	(SYNONYM FIRE)
	(CAPACITY K-CAP-MAX)
	(CONTFCN RT-TH-TAVERN-FIRE)
	(ACTION RT-TH-TAVERN-FIRE)
>

<ROUTINE RT-TH-TAVERN-FIRE ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-CONT>
			<COND
				(<TOUCH-VERB?>
					<TELL ,K-HOT-MSG>
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
							<RT-PUT-WHISKY-IN-FIRE-MSG ,TH-TAVERN-FIRE>
						)
						(<FSET? ,PRSO ,FL-BURNABLE>
							<REMOVE ,PRSO>
							<TELL
"The flames leap higher, and soon" the ,PRSO " is completely consumed." CR
							>
						)
					>
				)
			>
		)
		(<OR	<VERB? EXAMINE>
				<AND
					<VERB? LOOK-IN LOOK-ON>
					<NOT <FIRST? ,TH-TAVERN-FIRE>>
				>
			>
			<FSET ,TH-TAVERN-FIRE ,FL-SEEN>
			<TELL
"The fire burns brightly, casting eerie shadows on the walls." CR
			>
		)
		(<TOUCH-VERB?>
			<COND
				(<OR	<MC-PRSI? <> ,ROOMS ,CH-PLAYER ,TH-HANDS ,TH-LEGS ,TH-HEAD ,TH-MOUTH>
						<AND
							<FSET? ,PRSI ,FL-BODY-PART>
							<EQUAL? <GET-OWNER ,PRSI> ,CH-PLAYER>
						>
					>
					<TELL ,K-HOT-MSG>
				)
				(T
					<TELL
The+verb ,WINNER "poke" " around in" the ,TH-TAVERN-FIRE " but find nothing
of interest." CR
					>
				)
			>
		)
		(<VERB? LISTEN>
			<TELL "The fire snaps, crackles, and pops." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "LG-THATCH"
;"---------------------------------------------------------------------------"

<OBJECT LG-THATCH
	(LOC LOCAL-GLOBALS)
	(DESC "thatch")
	(FLAGS FL-CONTAINER FL-OPEN FL-SEARCH)
	(SYNONYM THATCH ROOF HOLE)
	(ADJECTIVE THATCH)
	(ACTION RT-LG-THATCH)
>

<ROUTINE RT-LG-THATCH ("OPT" (CONTEXT <>))
	<COND
		(<VERB? EXAMINE>
			<FSET ,LG-THATCH ,FL-SEEN>
			<TELL The ,LG-THATCH " is densely matted straw." CR>
		)
		(<AND <VERB? PUT PUT-IN>
				<VERB-WORD? ,W?THROW ,W?TOSS ,W?HURL ,W?CHUCK ,W?FLING ,W?PITCH ,W?HEAVE>
			>
			<RT-WASTE-OF-TIME-MSG>
		)
		(<OR	<TOUCH-VERB?>
				<VERB? LOOK-IN>
			>
			<RT-CANT-REACH-MSG ,LG-THATCH>
		)
	>
>

;"---------------------------------------------------------------------------"
; "CH-FARMERS"
;"---------------------------------------------------------------------------"

<OBJECT CH-FARMERS
	(LOC RM-TAVERN)
	(DESC "farmers")
	(FLAGS FL-ALIVE FL-NO-DESC FL-OPEN FL-PERSON FL-PLURAL FL-SEARCH)
	(SYNONYM MEN FARMER FARMERS CONVERSATION PEOPLE)
	(ACTION RT-CH-FARMERS)
>

<CONSTANT K-FARMER-CUFFS-MSG
"A large farmer absentmindedly cuffs you on the head, says, \"Begone, lad,\"
and returns to the conversation.|">

<ROUTINE RT-CH-FARMERS ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-WINNER>
			<TELL ,K-FARMER-CUFFS-MSG>
		)
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<COND
				(<VERB? SHOW GIVE>
					<COND
						(<MC-PRSO? ,TH-WHISKY ,TH-WHISKY-JUG>
							<TELL
"One of the farmers snatches the jug away from you and says, \"Wot's the
world comin' to wen they let a child like you run around with sumpn' like
this? "
							>
							<COND
								(<IN? ,TH-WHISKY ,TH-WHISKY-JUG>
									<TELL
"He takes a slug of whisky and then passes the jug around the table. Each
of the farmers takes a gulp, and then the last one tosses the half-full jug
into the fire. The resulting explosion levels the tavern and everything in
it, including you." CR
									>
									<RT-END-OF-GAME>
								)
								(T
									<REMOVE ,TH-WHISKY-JUG>
									<TELL
"When he discovers there is no whisky in the jug, he tosses it over his
shoulder into the fire, where it shatters." CR
									>
									<RT-SCORE-MSG 0 -1 0 0>
								)
							>
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
		(<AND <SPEAKING-VERB?>
				<MC-HERE? ,RM-TAVERN>
			>
			<TELL ,K-FARMER-CUFFS-MSG>
		)
		(<VERB? EXAMINE>
			<FSET ,CH-FARMERS ,FL-SEEN>
			<THIS-IS-IT ,CH-FARMERS>
			<TELL
"The scraggly farmers are massive, bearded labourers who huddle around the
fire for warmth and mutter amongst themselves." CR
			>
		)
	>
>

<GLOBAL GL-MEN-TALK?:FLAG <> <> BYTE>
<GLOBAL GL-MEN-NUM 0 <> BYTE>
<GLOBAL GL-MEN-START 0 <> BYTE>
<CONSTANT K-MEN-MAX 5>

<ROUTINE RT-NEXT-NUM (N MAX "OPT" (D 1))
	<SET N <+ .N .D>>
	<REPEAT ()
		<COND
			(<G? .N .MAX>
				<SET N <- .N .MAX>>
			)
			(<L? .N 1>
				<SET N <+ .N .MAX>>
			)
			(T
				<RETURN>
			)
		>
	>
	<RETURN .N>
>

<ROUTINE RT-I-MEN-TALK ()
	<COND
		(<FSET? ,CH-PLAYER ,FL-ASLEEP>
			<RT-QUEUE ,RT-I-MEN-TALK <+ <RT-IS-QUEUED? ,RT-I-SLEEP> 1>>
			<RFALSE>
		)
		(,GL-CLK-RUN
			<RT-QUEUE ,RT-I-MEN-TALK <+ ,GL-MOVES 1>>
		)
	>
	<COND
		(<AND ,GL-MEN-TALK?
				<MC-HERE? ,RM-TAVERN>
			>
			<COND
				(,GL-CLK-RUN
					<CRLF>
				)
			>
			<COND
				(<AND ,GL-MEN-NUM
						<NOT <EQUAL? ,GL-MEN-NUM ,GL-MEN-START>>
					>
					<COND
						(<ZERO? ,GL-MEN-START>
							<TELL "A large farmer says, ">
						)
						(<EQUAL? ,GL-MEN-NUM <RT-NEXT-NUM ,GL-MEN-START ,K-MEN-MAX 1>>
							<TELL "Another farmer says, ">
						)
						(<EQUAL? ,GL-MEN-NUM <RT-NEXT-NUM ,GL-MEN-START ,K-MEN-MAX 2>>
							<TELL "The first farmer says, ">
						)
						(<EQUAL? ,GL-MEN-NUM <RT-NEXT-NUM ,GL-MEN-START ,K-MEN-MAX 3>>
							<TELL "A third man speaks up, ">
						)
					>
				)
			>
			<COND
				(<OR	<ZERO? ,GL-MEN-NUM>
						<EQUAL? ,GL-MEN-NUM ,GL-MEN-START>
					>
					<SETG GL-MEN-NUM 0>
					<RT-DEQUEUE ,RT-I-MEN-TALK>
					<TELL
"The farmers prudently lower their voices and continue to complain." CR
					>
				)
				(<EQUAL? ,GL-MEN-NUM 1>
					<TELL
"\"I'll believe in 'is tale of angels when me billy goat stands up on 'is
'ind legs and calls me Chauncey.\"" CR
					>
				)
				(<EQUAL? ,GL-MEN-NUM 2>
					<TELL
"\"'E's got 'is nerve, 'e 'as. Closin' up the castle so's nary a man can get
in excep'n as 'e knows the word.\"" CR
					>
				)
				(<EQUAL? ,GL-MEN-NUM 3>
					<TELL
"\"I've 'eard tell 'ow 'e duz it. 'E's got that one pome that 'e's so proud
on. So 'e sits there on 'is throne, an wenever them monks starts in t'prayin,
'e picks a line as strikes 'is fancy, an that's the new word.\"" CR
					>
				)
				(<EQUAL? ,GL-MEN-NUM 4>
					<TELL
"\"'E's right greedy, y'know. They say 'is knees gets weak wen 'e sees
silver, an 'e'd sell 'is soul for an ounce of gold.\"" CR
					>
				)
				(<EQUAL? ,GL-MEN-NUM 5>
					<TELL
"\"'E'll get 'is. 'E's no more King of England than me daughter's prize
pig.\" He glances around and lowers his voice. \"About as 'ansome too.\"" CR
					>
				)
			>
			<COND
				(,GL-MEN-NUM
					<COND
						(<ZERO? ,GL-MEN-START>
							<SETG GL-MEN-START ,GL-MEN-NUM>
						)
					>
					<SETG GL-MEN-NUM <RT-NEXT-NUM ,GL-MEN-NUM ,K-MEN-MAX>>
				)
			>
			<RTRUE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-TANKARDS"
;"---------------------------------------------------------------------------"

<OBJECT TH-TANKARDS
	(LOC CH-FARMERS)
	(DESC "tankards")
	(FLAGS FL-CONTAINER FL-NO-DESC FL-OPEN FL-PLURAL FL-SEARCH FL-TRY-TAKE)
	(SYNONYM TANKARD TANKARDS MUG MUGS)
	(ADJECTIVE BEER)
	(OWNER CH-FARMERS)
	(ACTION RT-TH-TANKARDS)
>

<ROUTINE RT-TH-TANKARDS ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-TANKARDS ,FL-SEEN>
			<FSET ,TH-BEER ,FL-SEEN>
			<THIS-IS-IT ,TH-TANKARDS>
			<THIS-IS-IT ,TH-BEER>
			<TELL "The farmers' tankards have ale in them." CR>
		)
		(<TOUCH-VERB?>
			<TELL ,K-FARMER-CUFFS-MSG>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-BEER"
;"---------------------------------------------------------------------------"

<OBJECT TH-BEER
	(LOC TH-TANKARDS)
	(DESC "ale")
	(FLAGS FL-NO-DESC FL-TRY-TAKE)
	(SYNONYM BEER ALE DRINK)
	(ACTION RT-TH-BEER)
>

<ROUTINE RT-TH-BEER ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-BEER ,FL-SEEN>
			<TELL "The ale is dark brown." CR>
		)
		(<TOUCH-VERB?>
			<TELL ,K-FARMER-CUFFS-MSG>
		)
	>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

