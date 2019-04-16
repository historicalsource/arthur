;"***************************************************************************"
; "game : Arthur"
; "file : FOOD.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   13 May 1989 17:44:36  $"
; "revs : $Revision:   1.47  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Food, eating and sleeping"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

<GLOBAL GL-HUNGER 0 <> BYTE>

<ROUTINE RT-I-HUNGER ()
	<INC GL-HUNGER>
	<CRLF>
	<COND
		(<EQUAL? ,GL-HUNGER 2>
			<RT-QUEUE ,RT-I-HUNGER <+ ,GL-MOVES 120>>
			<TELL "Your stomach makes grumbling noises." CR>
		)
		(<EQUAL? ,GL-HUNGER 3>
			<RT-QUEUE ,RT-I-HUNGER <+ ,GL-MOVES 120>>
			<TELL "You are really getting very hungry." CR>
		)
		(<EQUAL? ,GL-HUNGER 4>
			<RT-QUEUE ,RT-I-HUNGER <+ ,GL-MOVES 60>>
			<TELL "You are getting faint from lack of food." CR>
		)
		(T
			<COND
				(<FSET? ,HERE ,FL-AIR>
					<TELL
"You finally become so weak from lack of food that you no longer have the
strength to fly. You fall "
					>
					<COND
						(<MC-HERE? ,RM-ABOVE-LAKE>
							<TELL "into the water">
						)
						(<MC-HERE? ,RM-ABOVE-BOG>
							<TELL "into the bog">
						)
						(T
							<TELL "to the ground">
						)
					>
					<TELL " below, killing yourself." CR>
				)
				(T
					<TELL "You collapse from hunger.|">
				)
			>
			<RT-END-OF-GAME>
		)
	>
>

<GLOBAL GL-SLEEP 0 <> BYTE>

<ROUTINE RT-I-SLEEP ("AUX" L (CAP? T) N)
	<INC GL-SLEEP>
	<CRLF>
	<COND
		(<AND <EQUAL? ,GL-SLEEP 1 2>
				<MC-FORM? ,K-FORM-OWL>
			>
			<SET CAP? <>>
			<TELL "Even though you are" aform ", ">
		)
	>
	<COND
		(<EQUAL? ,GL-SLEEP 1>
			<RT-QUEUE ,RT-I-SLEEP <+ ,GL-MOVES 10>>
			<COND
				(.CAP?
					<TELL "Y">
				)
				(T
					<TELL "y">
				)
			>
			<TELL "ou are starting to get sleepy." CR>
		)
		(<EQUAL? ,GL-SLEEP 2>
			<RT-QUEUE ,RT-I-SLEEP <+ ,GL-MOVES 15>>
			<COND
				(.CAP?
					<TELL "Y">
				)
				(T
					<TELL "y">
				)
			>
			<TELL "ou can hardly keep your eyes open." CR>
		)
		(<EQUAL? ,GL-SLEEP 3>
			; "Set time to 6:00 the next day."
			<SET N <- 360 <MOD ,GL-MOVES 1440>>>
			<COND
				(<L? .N 0>
					<SET N <+ .N 1440>>
				)
			>
			<SETG GL-MOVES <+ ,GL-MOVES .N>>
			<RT-QUEUE ,RT-I-SLEEP ,GL-MOVES>
			<SET L <LOC ,CH-PLAYER>>
			<COND
				(<EQUAL? .L ,TH-HORSE>
					<SET L <LOC .L>>
					<MOVE ,CH-PLAYER .L>
				)
			>
			<COND
				(<RT-MOVE-ALL-BUT-WORN ,CH-PLAYER .L>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT ,K-UPD-OBJS>>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
							<RT-UPDATE-DESC-WINDOW>
						)
					>
				)
			>
			<FSET ,CH-PLAYER ,FL-ASLEEP>
			<TELL "Exhausted, you ">
			<COND
				(<AND <MC-HERE? ,RM-SHALLOWS ,RM-FORD>
						<MC-FORM? ,K-FORM-ARTHUR>
					>
					<TELL
"fall asleep and drop into the water. Too tired to drag yourself to dry
land, you eventually drown.|"
					>
					<RT-END-OF-GAME>
				)
				(<FSET? ,HERE ,FL-WATER>
					<TELL "close your eyes and go into a deep sleep." CR>
				)
				(<FSET? ,HERE ,FL-AIR>
					<TELL "fall asleep in mid-air and fall ">
					<COND
						(<MC-HERE? ,RM-ABOVE-LAKE>
							<TELL "into the water">
						)
						(<MC-HERE? ,RM-ABOVE-BOG>
							<TELL "into the bog">
						)
						(T
							<TELL "to the ground">
						)
					>
					<TELL " below, killing yourself.|">
					<RT-END-OF-GAME>
				)
				(T
					<TELL
"slump to" the ,TH-GROUND " and go into a deep, troubled sleep."
					>
					<COND
						(<MC-HERE? ,RM-ICE-ROOM ,RM-HOT-ROOM>
							<TELL " Your body is quickly overwhelmed by the ">
							<COND
								(<MC-HERE? ,RM-ICE-ROOM>
									<TELL "cold, and you freeze to death">
								)
								(T
									<TELL
"high temperature, and you die of heat stroke"
									>
								)
							>
							<TELL "." CR>
							<RT-END-OF-GAME>
						)
						(<INTBL? ,HERE <ZREST ,K-DEMON-DOMAIN-TBL 1> <GETB ,K-DEMON-DOMAIN-TBL 0> 1>
							<TELL
" You have good reason to be troubled, for sometime in the night, an
unspeakably slimy creature with gruesome fangs slithers up alongside you and
devours you whole. You awaken to find yourself dead.|"
							>
							<RT-END-OF-GAME>
						)
						(T
							<CRLF>
						)
					>
				)
			>
		)
		(T
			<FCLEAR ,CH-PLAYER ,FL-ASLEEP>
			<SETG GL-SLEEP 0>
			<SETG GL-HUNGER 1>
			; "Next sleepy message at 22:05 same day"
			<SET N <- 1325 <MOD ,GL-MOVES 1440>>>
			<COND
				(<L? .N 0>
					<SET N <+ .N 1440>>
				)
			>
			<RT-QUEUE ,RT-I-SLEEP <+ ,GL-MOVES .N>>
			<RT-QUEUE ,RT-I-HUNGER <+ ,GL-MOVES 30>>
			<COND
				(<MC-HERE? ,RM-CASTLE-GATE>
					<COND
						(<EQUAL? ,OHERE ,RM-GREAT-HALL>
							<TELL
"While sleeping, you are vaguely aware of someone picking you up and
carrying you outside the castle. "
							>
						)
					>
				)
			>
			<COND
				(<FSET? ,HERE ,FL-WATER>
					<TELL "You drift in the water overnight, and">
				)
				(<NOT <FSET? ,HERE ,FL-INDOORS>>
					<TELL
"Fortunately the winter night is milder than usual, and you suffer no ill
effects from the night spent in the open. You"
					>
				)
				(T
					<TELL "You">
				)
			>
			<TELL
" awaken the next morning to the sound of the bells calling the monks to
prayer. You feel refreshed from your sleep, but hungry. "
			>
			<COND
				(<FSET? ,HERE ,FL-WATER>
					<TELL "Merlin's voice seems to echo in your head,">
				)
				(T
					<TELL "The air around you seems to echo with Merlin's voice,">
				)
			>
			<TELL " \"Hurry, Arthur only ">
			<SET N </ ,GL-MOVES 1440>>
			<COND
			;	(<EQUAL? .N 1>
					<TELL "two days">
				)
				(<EQUAL? .N 2>
					<TELL "one day">
				)
				(T
					<TELL "a few hours">
				)
			>
			<TELL " remain">
			<COND
				(<EQUAL? .N 2>
					<TELL "s">
				)
			>
			<TELL ".\"" CR>
		)
	>
>

<ROUTINE RT-EAT (OBJ "OPT" (PN? <>) "AUX" N L)
	<TELL " ">
	<SET N <RANDOM 3>>
	<COND
		(<EQUAL? .N 1>
			<TELL "munch">
			<COND
				(.PN?
					<TELL him .OBJ>
				)
			>
			<TELL " down">
		)
		(<EQUAL? .N 2>
			<TELL "gobble">
			<COND
				(.PN?
					<TELL him .OBJ>
				)
			>
			<TELL " up">
		)
		(T
			<TELL "eat">
			<COND
				(.PN?
					<TELL him .OBJ>
				)
			>
		)
	>
	<COND
		(,GL-HUNGER
			<SETG GL-HUNGER 0>
			<RT-DEQUEUE ,RT-I-HUNGER>
			<COND
				(.PN?
					<TELL ". Y">
				)
				(T
					<TELL the .OBJ " and y">
				)
			>
			<TELL "our hunger disappears." CR>
			<RT-SCORE-MSG 0 1 1 0>
		)
		(T
			<COND
				(<NOT .PN?>
					<TELL the .OBJ " ">
				)
			>
			<TELL "anyway." CR>
		)
	>
	<RT-CHOW-MSG>
	<SET L <LOC .OBJ>>
	<REMOVE .OBJ>
	<COND
		(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-INVT>
			<COND
				(<EQUAL? .L ,CH-PLAYER>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT>>
					<RT-UPDATE-INVT-WINDOW>
				)
			>
		)
		(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
			<COND
				(<OR	<EQUAL? .L ,HERE>
						<RT-META-IN? .L ,HERE>
					>
					<COND
						(<OR	<FSET? .L ,FL-SURFACE>
								<AND
									<FSET? .L ,FL-CONTAINER>
									<FSET? .L ,FL-TRANSPARENT>
								>
							>
							<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-OBJS>>
							<RT-UPDATE-DESC-WINDOW>
						)
					>
				)
			>
		)
	>
	<RTRUE>
>

<ROUTINE RT-CHOW-MSG ()
	<COND
		(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
			<RT-AUTHOR-ON>
			<TELL "Yum. Almost as good as Purina" form "-chow.">
			<RT-AUTHOR-OFF>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-CHEESE"
;"---------------------------------------------------------------------------"

<OBJECT TH-CHEESE
	(LOC TH-TAVERN-TABLE)
	(DESC "piece of cheese")
	(FLAGS FL-BURNABLE FL-NO-LIST FL-TAKEABLE)
	(SYNONYM CHEESE PIECE FOOD STILTON)
	(ADJECTIVE TASTY LOOKING TASTY-LOOKING SMALL NICELY AGED STALE)
	(OWNER TH-CHEESE)
	(SIZE 1)
	(GENERIC RT-GN-FOOD)
	(ACTION RT-TH-CHEESE)
>

<CONSTANT K-TASTY-MSG "tasty-looking ">

<ROUTINE RT-TH-CHEESE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<AND <IN? ,TH-CHEESE ,TH-TAVERN-TABLE>
				<IN? ,CH-COOK ,RM-TAV-KITCHEN>
				<TOUCH-VERB?>
			>
			<TELL ,K-HANDS-OFF-MSG CR>
		)
		(<VERB? EAT>
			<COND
				(,GL-HUNGER
					<TELL "You">
					<RT-EAT ,TH-CHEESE>
				)
				(<MC-FORM? ,K-FORM-ARTHUR>
					<TELL "You're not hungry, but you">
					<RT-EAT ,TH-CHEESE>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-CHEESE ,FL-SEEN>
			<TELL "The cheese is a small, but nicely aged piece of Stilton." CR>
		)
	;	(<VERB? SMELL>
			<TELL "The cheese has a delicate, pleasant fragrance." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-DEAD-MOUSE"
;"---------------------------------------------------------------------------"

<OBJECT TH-DEAD-MOUSE
	(LOC CH-IDIOT)
	(FLAGS FL-BURNABLE FL-HAS-SDESC FL-NO-LIST FL-TAKEABLE)
	(SYNONYM MOUSE FOOD)
	(ADJECTIVE DEAD TASTY LOOKING TASTY-LOOKING)
	(SIZE 1)
	(GENERIC RT-GN-FOOD)
	(ACTION RT-TH-DEAD-MOUSE)
>

<ROUTINE RT-TH-DEAD-MOUSE ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<COND
		(<MC-CONTEXT? ,M-OBJDESC>
			<COND
				(.ART
					<PRINT-ARTICLE ,TH-DEAD-MOUSE .ART .CAP?>
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
						(<AND <NOT ,GL-IDIOT-STUFF>
								<MC-FORM? ,K-FORM-OWL ,K-FORM-BADGER>
							>
							<TELL ,K-TASTY-MSG>
						)
					>
					<TELL "dead mouse">
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<AND <VERB? EAT>
				<MC-FORM? ,K-FORM-OWL ,K-FORM-BADGER>
				,GL-HUNGER
			>
			<TELL "You">
			<RT-EAT ,TH-DEAD-MOUSE>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-DEAD-MOUSE ,FL-SEEN>
			<TELL
"It looks a little ragged from the treatment the idiot has given it"
			>
			<COND
				(<AND <MC-FORM? ,K-FORM-OWL ,K-FORM-BADGER>
						,GL-HUNGER
					>
					<TELL ", but pretty tasty nonetheless">
				)
			>
			<TELL "." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-WEEDS"
;"---------------------------------------------------------------------------"

<OBJECT TH-WEEDS
	(LOC RM-ROAD)
	(FLAGS FL-BURNABLE FL-HAS-SDESC FL-TAKEABLE FL-PLURAL)
	(SYNONYM WEED WEEDS FOOD)
	(ADJECTIVE WEED TASTY LOOKING TASTY-LOOKING)
	(SIZE 1)
	(GENERIC RT-GN-FOOD)
	(ACTION RT-TH-WEEDS)
>

<ROUTINE RT-TH-WEEDS ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<COND
		(<MC-CONTEXT? ,M-OBJDESC>
			<COND
				(.ART
					<PRINT-ARTICLE ,TH-WEEDS .ART .CAP?>
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
						(<MC-FORM? ,K-FORM-BADGER ,K-FORM-TURTLE>
							<TELL ,K-TASTY-MSG>
						)
					>
					<TELL "weeds">
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<AND <VERB? EAT>
				<MC-FORM? ,K-FORM-BADGER ,K-FORM-TURTLE>
				,GL-HUNGER
			>
			<TELL "You">
			<RT-EAT ,TH-WEEDS>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-WEEDS ,FL-SEEN>
			<TELL "The weeds are fresh and green." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-MINNOW"
;"---------------------------------------------------------------------------"

<OBJECT TH-MINNOW
	(LOC RM-RIVER-3)
	(FLAGS FL-BURNABLE FL-ALIVE FL-HAS-SDESC)
	(SYNONYM MINNOW FISH FOOD TASTY-LOOKING MORSEL)
	(ADJECTIVE TASTY LOOKING FINE FRESH BITE SIZED BITE-SIZED)
	(GENERIC RT-GN-FOOD)
	(ACTION RT-TH-MINNOW)
>

; "TH-MINNOW flags:"
; "	FL-LOCKED - Minnow has been killed and does not reappear"

<ROUTINE RT-TH-MINNOW ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<COND
		(<MC-CONTEXT? ,M-OBJDESC>
			<COND
				(.ART
					<PRINT-ARTICLE ,TH-MINNOW .ART .CAP?>
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
						(<MC-FORM? ,K-FORM-EEL>
							<TELL ,K-TASTY-MSG>
						)
					>
					<TELL "minnow">
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<AND <VERB? EAT>
				<MC-FORM? ,K-FORM-EEL ,K-FORM-TURTLE>
				,GL-HUNGER
			>
			<FSET ,TH-MINNOW ,FL-LOCKED>
			<RT-DEQUEUE ,RT-I-MINNOW>
			<TELL "You">
			<COND
				(<AND <FSET? ,TH-MINNOW ,FL-ALIVE>
						<MC-FORM? ,K-FORM-EEL>
					>
					<TELL " shock and kill the minnow, and then">
					<RT-EAT ,TH-MINNOW T>
				)
				(T
					<RT-EAT ,TH-MINNOW>
				)
			>
			<FCLEAR ,TH-MINNOW ,FL-ALIVE>
		)
		(<AND <VERB? SHOCK>
				<MC-FORM? ,K-FORM-EEL>
			>
			<FSET ,TH-MINNOW ,FL-LOCKED>
			<FCLEAR ,TH-MINNOW ,FL-ALIVE>
			<RT-DEQUEUE ,RT-I-MINNOW>
			<RT-QUEUE ,RT-I-MINNOW <+ ,GL-MOVES 1>>
			<TELL
"You kill" the ,TH-MINNOW ". It starts to float to the surface." CR
			>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-MINNOW ,FL-SEEN>
			<TELL "The minnow is a bite-sized morsel of fine fresh fish." CR>
		)
	>
>

<ROUTINE RT-I-MINNOW ("AUX" L)
	<SET L <LOC ,TH-MINNOW>>
	<REMOVE ,TH-MINNOW>
	<COND
		(<EQUAL? .L ,HERE>
			<TELL CR The ,TH-MINNOW " ">
			<COND
				(<FSET? ,TH-MINNOW ,FL-ALIVE>
					<TELL "quickly scurries">
				)
				(T
					<TELL "floats up">
				)
			>
			<TELL " out of sight." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-MIDGES"
;"---------------------------------------------------------------------------"

<OBJECT TH-MIDGES
	(LOC RM-MERPATH)
	(FLAGS FL-BURNABLE FL-HAS-SDESC FL-NO-DESC FL-TRY-TAKE FL-PLURAL)
	(SYNONYM MIDGE MIDGES FOOD BUGS BUG)
	(ADJECTIVE MIDGE TASTY LOOKING TASTY-LOOKING)
	(GENERIC RT-GN-FOOD)
	(ACTION RT-TH-MIDGES)
>

<ROUTINE RT-TH-MIDGES ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<COND
		(<MC-CONTEXT? ,M-OBJDESC>
			<COND
				(.ART
					<PRINT-ARTICLE ,TH-MIDGES .ART .CAP?>
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
						(<MC-FORM? ,K-FORM-SALAMANDER>
							<TELL ,K-TASTY-MSG>
						)
					>
					<TELL "midges">
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EAT>
			<COND
				(<AND ,GL-HUNGER
						<MC-FORM? ,K-FORM-SALAMANDER>
					>
					<SETG GL-HUNGER 0>
					<RT-DEQUEUE ,RT-I-HUNGER>
					<REMOVE ,TH-MIDGES>
					<TELL
"Your tongue flicks in and out quickly, and in a matter of seconds,"
the ,TH-MIDGES " are no more. You are no longer hungry." CR
					>
					<RT-SCORE-MSG 0 1 1 0>
					<RT-CHOW-MSG>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
							<RT-UPDATE-DESC-WINDOW>
						)
					>
					<RTRUE>
				)
			>
		)
		(<TOUCH-VERB?>
			<COND
				(<MC-FORM? ,K-FORM-ARTHUR>
					<TELL
The+verb ,TH-HANDS "pass" " right through" the ,TH-MIDGES "." CR
					>
				)
				(T
					<RT-WASTE-OF-TIME-MSG>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-MIDGES ,FL-SEEN>
			<TELL
"You peer intently at the cloud of tiny bugs, but discover nothing new about
them." CR
			>
		)
	>
>

<ROUTINE RT-GN-FOOD (TBL FINDER)
	<COND
		(<MC-FORM? ,K-FORM-ARTHUR>
			<RETURN ,TH-CHEESE>
		)
		(<MC-FORM? ,K-FORM-OWL ,K-FORM-BADGER>
			<RETURN ,TH-DEAD-MOUSE>
		)
		(<MC-FORM? ,K-FORM-EEL>
			<RETURN ,TH-MINNOW>
		)
		(<MC-FORM? ,K-FORM-SALAMANDER>
			<RETURN ,TH-MIDGES>
		)
		(<MC-FORM? ,K-FORM-TURTLE>
			<RETURN ,TH-WEEDS>
		)
	>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

