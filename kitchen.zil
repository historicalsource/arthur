;"***************************************************************************"
; "game : Arthur"
; "file : KITCHEN.ZIL"
; "auth :   $Author:   RAB  $"
; "date :     $Date:   15 May 1989 18:09:56  $"
; "rev  : $Revision:   1.108  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Tavern kitchen"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

<INCLUDE "PDEFS">		; "Because PARSE-ACTION used in this file."

;"---------------------------------------------------------------------------"
; "RM-TAV-KITCHEN"
;"---------------------------------------------------------------------------"

<ROOM RM-TAV-KITCHEN
	(LOC ROOMS)
	(DESC "tavern kitchen")
	(FLAGS FL-INDOORS FL-LIGHTED)
	(SYNONYM KITCHEN)
	(ADJECTIVE TAVERN)
	(NORTH TO RM-TAVERN)
	(OUT TO RM-TAVERN)
	(GLOBAL LG-THATCH LG-WALL RM-TAVERN)
	(ACTION RT-RM-TAV-KITCHEN)
>

<ROUTINE RT-RM-TAV-KITCHEN ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<IN? ,CH-COOK ,RM-TAV-KITCHEN>
					<FSET ,CH-COOK ,FL-SEEN>
					<FSET ,TH-CUPBOARD ,FL-SEEN>
					<TELL
"The kitchen is dominated by a mean-looking cook who is working at a table
with his back to a" open ,TH-CUPBOARD " cupboard."
					>
					<COND
						(<IN? ,TH-BIRD ,TH-CAGE>
							<FSET ,TH-BIRD ,FL-SEEN>
							<FSET ,TH-CAGE ,FL-SEEN>
							<TELL " Above his head is a beautiful caged bird who ">
							<COND
								(<MC-CONTEXT? ,M-LOOK>
									<TELL "is chattering frantically at you">
								)
								(T
									<TELL "starts to chatter as soon as you come in">
								)
							>
							<TELL ".">
						)
					>
					<COND
						(<AND <IN? ,TH-CHEESE ,TH-TAVERN-TABLE>
								<FSET? ,TH-CHEESE ,FL-NO-LIST>
							>
							<TELL
" Near the edge of the table is a small, stale piece of cheese."
							>
						)
					>
					<CRLF>
				;	<FSET ,TH-TAVERN-TABLE ,FL-NO-DESC>
				;	<FSET ,TH-CUPBOARD ,FL-NO-DESC>
				;	<FSET ,TH-CAGE ,FL-NO-DESC>
				;	<FSET ,TH-BIRD ,FL-NO-DESC>
				;	<FSET ,CH-COOK ,FL-NO-DESC>
					<RFALSE>
				)
				(T
					<TELL
"You are in the small kitchen that is tucked away in the back of the tavern.
The only exit lies to the north.|"
					>
					<RFALSE>
				)
			>
		)
	;	(<MC-CONTEXT? ,M-BEG>
			<FCLEAR ,TH-TAVERN-TABLE ,FL-NO-DESC>
			<FCLEAR ,TH-CUPBOARD ,FL-NO-DESC>
			<FCLEAR ,TH-CAGE ,FL-NO-DESC>
			<FCLEAR ,TH-BIRD ,FL-NO-DESC>
			<FCLEAR ,CH-COOK ,FL-NO-DESC>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<COND
				(<IN? ,CH-COOK ,RM-TAV-KITCHEN>
					<SETG GL-PICTURE-NUM ,K-PIC-COOK>
				)
				(T
					<SETG GL-PICTURE-NUM ,K-PIC-TAV-KITCHEN>
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
			<COND
				(<IN? ,CH-COOK ,RM-TAV-KITCHEN>
					<COND
						(<IN? ,TH-BIRD ,TH-CAGE>
							<TELL
"|The cook takes a backhanded swipe at the bird and mutters, \"Sharrup.\"" CR
							>
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-END>
			<COND
				(<VERB? TRANSFORM>
					<COND
						(<IN? ,CH-COOK ,RM-TAV-KITCHEN>
							<COND
								(<NOT <MC-FORM? ,GL-OLD-FORM>>
									<TELL
"|\"Sorcery!! Work of the Devil!!\" The cook picks up a knife and skewers
you through the heart." ,K-HEEDED-WARNING-MSG
									>
									<RT-END-OF-GAME>
								)
								(,GL-FORM-ABORT
									<TELL
"|Fortunately, it all happened so quickly that" the ,CH-COOK " didn't notice." CR
									>
								)
							>
						)
						(<AND <MC-FORM? ,K-FORM-OWL>
								<NOT <MC-FORM? ,GL-OLD-FORM>>
								<NOT <FSET? ,TH-BIRD ,FL-LOCKED>>
							>
							<FSET ,TH-BIRD ,FL-LOCKED>
							<TELL
"|The bird watches your transformation without surprise. Its chattering
suddenly becomes intelligible to you. \"Mon dieu, but you are slow! I know
you must 'ate zat man because of ze way ee cooks. In my country we would
'ave 'im killed. But ee 'as some spices 'idden away in ze cupboard, and ze
key to ze cupboard ees 'idden in ze thatch. "
							>
							<COND
								(<IN? ,TH-BIRD ,TH-CAGE>
									<TELL
"Queekly now, before ze sadist returns. Open ze cage and I weel get ze key
for you.\"" CR
									>
								)
								(T
									<TELL "Would you like me to get eet for you?\"|">
									<COND
										(<YES? T>
											<MOVE ,TH-CUPBOARD-KEY ,RM-TAV-KITCHEN>
											<TELL ,K-BIRD-GETS-KEY-MSG>
										)
										(T
											<TELL
"\"No? Non? You do not want ze spices?\" He shakes his bird-like head. \"I
will never understand ze English. Au revoir, mon ami.\" " The ,TH-BIRD
											>
										)
									>
									<REMOVE ,TH-BIRD>
									<MOVE ,TH-DROPPING ,TH-TAVERN-TABLE>
									<TELL ,K-DROPPING-MSG>
								)
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

<ROUTINE RT-RESET-KITCHEN ()
	<COND
		(<IN? ,TH-BIRD ,RM-TAV-KITCHEN>
			<MOVE ,TH-BIRD ,TH-CAGE>
		)
		(<NOT <LOC ,TH-BIRD>>
			<FSET ,TH-BIRD ,FL-ASLEEP>
		)
	>
	<COND
		(<OR	<IN? ,TH-SPICE-BOTTLE ,RM-TAV-KITCHEN>
				<IN? ,TH-SPICE-BOTTLE ,TH-TAVERN-TABLE>
				<IN? ,TH-SPICE-BOTTLE ,TH-CAGE>
			>
			<MOVE ,TH-SPICE-BOTTLE ,TH-CUPBOARD>
			<FCLEAR ,TH-CUPBOARD ,FL-LOCKED>
		)
	>
	<COND
		(<OR	<IN? ,TH-CUPBOARD-KEY ,RM-TAV-KITCHEN>
				<IN? ,TH-CUPBOARD-KEY ,TH-TAVERN-TABLE>
				<IN? ,TH-CUPBOARD-KEY ,TH-CAGE>
			>
			<MOVE ,TH-CUPBOARD-KEY ,TH-CUPBOARD>
			<FCLEAR ,TH-CUPBOARD ,FL-LOCKED>
		)
	>
	<FCLEAR ,TH-CAGE ,FL-OPEN>
	<FCLEAR ,TH-CUPBOARD ,FL-OPEN>
>

;"---------------------------------------------------------------------------"
; "CH-COOK"
;"---------------------------------------------------------------------------"

<OBJECT CH-COOK
	(LOC RM-TAV-KITCHEN)
	(DESC "cook")
	(FLAGS FL-ALIVE FL-NO-LIST FL-OPEN FL-PERSON FL-SEARCH)
	(SYNONYM COOK RUFFIAN MAN PERSON)
	(ADJECTIVE FAT NASTY LOOKING NASTY-LOOKING)
	(ACTION RT-CH-COOK)
>

<CONSTANT K-COOK-IGNORES-MSG "The cook ignores you and continues about his business.|">
<CONSTANT K-NOT-NOW-MSG "\"Not now, boy. I'm busy.\"|">
<CONSTANT K-GET-OUT-MSG " \"Get out of here, you mangy">
<CONSTANT K-FAT-CHANCE-MSG "\"Fat chance.\"|">
<CONSTANT K-COOK-RESUMES-WORK-MSG " and resumes his work at the table.|">
<CONSTANT K-HANDS-OFF-MSG "The cook cuffs you on the head. \"Hands off.\"|">
<CONSTANT K-NO-SPICE-MSG
"The cook takes a sidelong glance at the cupboard and then says gruffly, \"I
don't use no spices. Too 'ard to come by.\"|">

<ROUTINE RT-CH-COOK ("OPT" (CONTEXT <>))
	<COND
		(<AND <MC-CONTEXT? ,M-WINNER <>>
				<VERB? HELLO GOODBYE THANK>
			>
			<TELL ,K-COOK-IGNORES-MSG>
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
		(<MC-CONTEXT? ,M-WINNER>
			<COND
				(<IN? ,CH-COOK ,RM-TAVERN>
					<TELL ,K-NOT-NOW-MSG>
				)
				(<AND <VERB? TELL-ABOUT>
						<MC-PRSO? ,CH-PLAYER>
					>
					<RFALSE>
				)
				(<VERB? WHO WHAT>
					<RFALSE>
				)
				(<VERB? WHERE>
					<COND
						(<MC-PRSO? ,TH-CUPBOARD-KEY>
							<TELL "\"None o' yer business.\"" CR>
						)
						(<MC-PRSO? ,CH-FARMERS>
							<TELL
"\"Sittin' out there with their noses in their ale. Same as always.\"" CR
							>
						)
						(<MC-PRSO? ,TH-SPICE-BOTTLE ,TH-SPICE>
							<TELL ,K-NO-SPICE-MSG>
						)
						(T
							<TELL "\"Don't know nuthin' 'bout no ">
							<NP-PRINT ,PRSO-NP>
							<TELL ".\"" CR>
						)
					>
				)
				(<VERB? OPEN>
					<COND
						(<MC-PRSO? ,TH-CUPBOARD ,TH-CAGE>
							<TELL ,K-FAT-CHANCE-MSG>
						)
						(T
							<TELL ,K-COOK-IGNORES-MSG>
						)
					>
				)
				(T
					<TELL ,K-COOK-IGNORES-MSG>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<COND
				(<VERB? SHOW GIVE>
					<COND
						(<MC-PRSO? ,TH-SPICE-BOTTLE ,TH-SPICE>
							<MOVE ,TH-SPICE-BOTTLE ,TH-CUPBOARD>
							<FCLEAR ,TH-CUPBOARD ,FL-OPEN>
							<TELL
The ,CH-COOK " snatches the bottle away from you and says, \"'Ow did you get
that?\" He cuffs you on the side of the head"
							>
							<COND
								(<MC-HERE? ,RM-TAV-KITCHEN>
									<TELL
", replaces the bottle in the cupboard, and closes the door." CR
									>
								)
								(T
									<MOVE ,CH-COOK ,RM-TAV-KITCHEN>
									<COND
										(<IN? ,TH-CHEESE ,TH-TAVERN-TABLE>
											<FSET ,TH-CHEESE ,FL-NO-LIST>
										)
									>
									<FSET ,TH-TAVERN-TABLE ,FL-NO-LIST>
									<FSET ,TH-CUPBOARD ,FL-NO-LIST>
									<FSET ,TH-CAGE ,FL-NO-LIST>
									<FSET ,TH-BIRD ,FL-NO-LIST>
								;	<FSET ,CH-COOK ,FL-NO-LIST>
									<RT-DEQUEUE ,RT-I-COOK>
									<RT-QUEUE ,RT-I-COOK <+ ,GL-MOVES <+ 4 <RANDOM 4>>>>
									<TELL " and returns to the kitchen." CR>
								)
							>
						)
						(<MC-PRSO? ,TH-WHISKY ,TH-WHISKY-JUG>
							<MOVE ,TH-WHISKY-JUG ,TH-CUPBOARD>
							<FCLEAR ,TH-CUPBOARD ,FL-OPEN>
							<TELL
The ,CH-COOK " snatches the jug away from you and says, \"A young lad like
you shouldn't be messin with the likes of that. \""
							>
							<COND
								(<MC-HERE? ,RM-TAV-KITCHEN>
									<TELL
"He puts the jug in the cupboard and closes the door." CR
									>
								)
								(T
									<MOVE ,CH-COOK ,RM-TAV-KITCHEN>
									<COND
										(<IN? ,TH-CHEESE ,TH-TAVERN-TABLE>
											<FSET ,TH-CHEESE ,FL-NO-LIST>
										)
									>
									<FSET ,TH-TAVERN-TABLE ,FL-NO-LIST>
									<FSET ,TH-CUPBOARD ,FL-NO-LIST>
									<FSET ,TH-CAGE ,FL-NO-LIST>
									<FSET ,TH-BIRD ,FL-NO-LIST>
								;	<FSET ,CH-COOK ,FL-NO-LIST>
									<RT-DEQUEUE ,RT-I-COOK>
									<RT-QUEUE ,RT-I-COOK <+ ,GL-MOVES <+ 4 <RANDOM 4>>>>
									<TELL "He glances at the jug and returns to the kitchen." CR>
								)
							>
							<RT-SCORE-MSG 0 -1 0 0>
						)
						(<MC-PRSO? ,TH-CHEESE>
							<REMOVE ,TH-CHEESE>
							<TELL
"The cook snatches the cheese away from you and pops it into his mouth. \"Why
you little thief!\" he says. \"I should have you thrown in Lot's dungeon. But
instead I'll settle for this.\" He gives you a swift kick in the rear end." CR
							>
							<RT-SCORE-MSG 0 -1 0 0>
						)
						(<MC-PRSO? ,TH-BRACELET ,TH-GOLD-KEY ,TH-SILVER-KEY ,TH-RAVEN-EGG>
							<TELL
"\"Where did the likes of you get the likes of that? I want no part of your
stolen loot.\"" CR
							>
						)
					>
				)
			>
		)
		(<AND <VERB? TELL>
				,P-CONT
			>
		; "Message and RFATAL if don't want knight to become winner"
			<RFALSE>
		)
		(<VERB? ASK-FOR>
			<TELL ,K-FAT-CHANCE-MSG>
		)
		(<VERB? ASK-ABOUT>
			<COND
				(<IN? ,CH-COOK ,RM-TAVERN>
					<TELL ,K-NOT-NOW-MSG>
				)
				(<MC-PRSI? ,CH-FARMERS>
					<TELL "\"Mangy bunch of lie-abouts.\"" CR>
				)
				(<MC-PRSI? ,TH-PASSWORD>
					<TELL "\"How should I know? I don't read poetry.\"" CR>
				)
				(<MC-PRSI? ,CH-LOT ,TH-MASTER>
					<TELL
"\"How would I know anything about Lot, him with his castles and passwords
and such?\"" CR
					>
				)
				(<MC-PRSI? ,TH-BIRD>
					<COND
						(<IN? ,TH-BIRD ,TH-CAGE>
							<TELL
"\"A proper nuisance, he is. But come Lot's coronation, his goose will be
cooked. Heh Heh.\"" CR
							>
						)
						(T
							<TELL
"The cook fixes you with a viscious stare and says, \"If I ever find out who
opened that cage, I'll throttle him with my own hands.\"" CR
							>
						)
					>
				)
				(<MC-PRSI? ,TH-SPICE>
					<TELL ,K-NO-SPICE-MSG>
				)
				(<MC-PRSI? ,TH-CUPBOARD-KEY>
					<TELL "\"None o' yer business.\"" CR>
				)
				(<MC-PRSI? ,TH-CUPBOARD>
					<TELL "\"Keep yer hands off. There's nothing in there.\"" CR>
				)
				(<MC-PRSI? ,RM-TAVERN ,RM-TAV-KITCHEN ,GLOBAL-HERE>
					<TELL
The ,CH-COOK " shrugs his shoulders and mumbles, \"It's a livin'.\"" CR
					>
				)
				(<MC-PRSI? ,TH-CHEESE>
					<COND
						(<IN? ,TH-CHEESE ,TH-TAVERN-TABLE>
							<TELL "\"Keep yer hands off.\"" CR>
						)
						(T
							<TELL
"\"Somebody nicked it, and I'd better not find out who it was\"" CR
							>
						)
					>
				)
				(<MC-PRSI? ,CH-COOK>
					<TELL
"\"I prepare plain food for plain people. Nothin' fancy about me.\"" CR
					>
				)
				(<MC-PRSI? ,TH-BEER ,TH-TANKARDS>
					<TELL "\"Come back when you're older.\"" CR>
				)
				(<MC-PRSI? ,CH-MERLIN>
					<TELL
"\"Don't get too many wizards in here. They don't drink much, you know.\"" CR
					>
				)
				(<MC-PRSI? ,CH-PLAYER>
					<TELL
"\"You're nowt but a meddlesome lad. Go away before I box your ears.\"" CR
					>
				)
				(<MC-PRSI? ,CH-IDIOT>
					<TELL
"\"He's just here on holiday. Monday he goes back to his regular job at
the Post Office.\"" CR
					>
				)
				(<MC-PRSI? ,TH-CAGE>
					<TELL
"\"If you was just a little smaller, I'd pop you in there and keep you for a
pet. Har har.\"" CR
					>
				)
				(<MC-PRSI? ,TH-EXCALIBUR>
					<TELL
"\"Having it right across the way was good for business. I'm sorry to see it
gone.\"" CR
					>
				)
				(T
					<TELL "\"Don't know nuthin' 'bout no ">
					<NP-PRINT ,PRSI-NP>
					<TELL ".\"" CR>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,CH-COOK ,FL-SEEN>
			<TELL "He is a fat, nasty-looking ruffian." CR>
		)
		(<AND <VERB? CALL>
				<MC-HERE? ,RM-TAVERN ,RM-TAV-KITCHEN>
				<NOT <IN? ,CH-COOK ,HERE>>
			>
			<TELL The+verb ,CH-COOK "stalk" " ">
			<COND
				(<MC-HERE? ,RM-TAVERN>
					<TELL "out of">
				)
				(T
					<TELL "into">
				)
			>
			<TELL
" the kitchen. When he sees it is you who has disturbed him, he cuffs you on
the head and throws you out of the tavern.||"
			>
			<RT-RESET-TAVERN>
			<RT-RESET-KITCHEN>
			<RT-GOTO ,RM-TOWN-SQUARE T>
		)
		(<TOUCH-VERB?>
			<TELL
The ,CH-COOK " cuffs you on the head and says, \"Quit your silly games, boy.
Else I'll thrash you proper.\"" CR
			>
		)
	>
>

<GLOBAL GL-COOK-NUM:NUMBER 0 <> BYTE>

<ROUTINE RT-I-COOK ()
	<COND
		(<FSET? ,CH-PLAYER ,FL-ASLEEP>
			<MOVE ,CH-COOK ,RM-TAV-KITCHEN>
			<COND
				(<IN? ,TH-CHEESE ,TH-TAVERN-TABLE>
					<FSET ,TH-CHEESE ,FL-NO-LIST>
				)
			>
			<FSET ,TH-TAVERN-TABLE ,FL-NO-LIST>
			<FSET ,TH-CUPBOARD ,FL-NO-LIST>
			<FSET ,TH-CAGE ,FL-NO-LIST>
			<FSET ,TH-BIRD ,FL-NO-LIST>
		;	<FSET ,CH-COOK ,FL-NO-LIST>
			<SETG GL-PICTURE-NUM ,K-PIC-COOK>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
					<RT-UPDATE-DESC-WINDOW>
				)
			>
			<RT-RESET-KITCHEN>
			<RT-QUEUE ,RT-I-COOK <+ <RT-IS-QUEUED? ,RT-I-SLEEP> <+ 3 <RANDOM 4>>>>
			<RFALSE>
		)
		(<IN? ,CH-COOK ,RM-TAV-KITCHEN>
			<SETG GL-COOK-NUM 0>
			<MOVE ,CH-COOK ,RM-TAVERN>
			<COND
				(<IN? ,TH-CHEESE ,TH-TAVERN-TABLE>
					<FCLEAR ,TH-CHEESE ,FL-NO-LIST>
				)
			>
			<FCLEAR ,TH-TAVERN-TABLE ,FL-NO-LIST>
			<FCLEAR ,TH-CUPBOARD ,FL-NO-LIST>
			<FCLEAR ,TH-CAGE ,FL-NO-LIST>
			<FCLEAR ,TH-BIRD ,FL-NO-LIST>
		;	<FCLEAR ,CH-COOK ,FL-NO-LIST>
			<RT-QUEUE ,RT-I-COOK <+ ,GL-MOVES <+ 3 <RANDOM 4>>>>
			<COND
				(<MC-HERE? ,RM-TAVERN>
					<TELL
"|One of the customers calls for more ale, and the cook comes out of the
kitchen." CR
					>
				)
				(<MC-HERE? ,RM-TAV-KITCHEN>
					<SETG GL-PICTURE-NUM ,K-PIC-TAV-KITCHEN>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
							<RT-UPDATE-PICT-WINDOW>
						)
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
							<RT-UPDATE-DESC-WINDOW>
						)
					>
					<TELL
"|The cook leaves the room in response to a shout from a thirsty customer." CR
					>
				)
			>
		)
		(<ZERO? ,GL-COOK-NUM>
			<SETG GL-COOK-NUM 1>
			<RT-QUEUE ,RT-I-COOK <+ ,GL-MOVES 1>>
			<COND
				(<MC-HERE? ,RM-TAV-KITCHEN>
					<TELL
"|You hear a step outside the door. The cook is returning." CR
					>
				)
			>
		)
		(T
			<SETG GL-COOK-NUM 0>
			<MOVE ,CH-COOK ,RM-TAV-KITCHEN>
			<COND
				(<IN? ,TH-CHEESE ,TH-TAVERN-TABLE>
					<FSET ,TH-CHEESE ,FL-NO-LIST>
				)
			>
			<FSET ,TH-TAVERN-TABLE ,FL-NO-LIST>
			<FSET ,TH-CUPBOARD ,FL-NO-LIST>
			<FSET ,TH-CAGE ,FL-NO-LIST>
			<FSET ,TH-BIRD ,FL-NO-LIST>
		;	<FSET ,CH-COOK ,FL-NO-LIST>
			<RT-QUEUE ,RT-I-COOK <+ ,GL-MOVES 4 <RANDOM 4>>>
			<COND
				(<MC-HERE? ,RM-TAVERN>
					<TELL "|The cook disappears into the kitchen." CR>
				)
				(<MC-HERE? ,RM-TAV-KITCHEN>
					<SETG GL-PICTURE-NUM ,K-PIC-COOK>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
							<RT-UPDATE-PICT-WINDOW>
						)
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
							<RT-UPDATE-DESC-WINDOW>
						)
					>
					<TELL "|The cook comes into the kitchen">
					<COND
						(<MC-FORM? ,K-FORM-ARTHUR>
							<COND
								(<IN? ,TH-BIRD ,RM-TAV-KITCHEN>
									<TELL
" and sees that the bird has escaped. He chases it around the room for
several minutes before finally catching it. He stuffs it back into the cage,
gives you a suspicious glance," ,K-COOK-RESUMES-WORK-MSG
									>
								)
								(<OR	<FSET? ,TH-CUPBOARD ,FL-OPEN>
										<AND
											<NOT <LOC ,TH-BIRD>>
											<NOT <FSET? ,TH-BIRD ,FL-ASLEEP>>
										>
									>
									<TELL " and sees that">
									<COND
										(<FSET? ,TH-CUPBOARD ,FL-OPEN>
											<TELL the ,TH-CUPBOARD " is open">
										)
									>
									<COND
										(<NOT <LOC ,TH-BIRD>>
											<FSET ,TH-BIRD ,FL-ASLEEP>
											<COND
												(<FSET? ,TH-CUPBOARD ,FL-OPEN>
													<TELL " and">
												)
											>
											<TELL the ,TH-BIRD " is gone">
										)
									>
									<TELL
", he cuffs you on the side of the head and boots you out the door, saying,"
,K-GET-OUT-MSG " brat.\"||"
									>
									<RT-GOTO ,RM-TAVERN T>
								)
								(T
									<COND
										(<IN? ,TH-BIRD ,TH-CAGE>
											<TELL
", takes a backhanded swipe at the bird, mutters, \"Sharrup.\""
											>
										)
									>
									<TELL ,K-COOK-RESUMES-WORK-MSG>
								)
							>
						)
						(T
							<COND
								(<MC-FORM? ,K-FORM-TURTLE>
									<TELL
", sees you on the floor, and picks you up. He carries you out of the tavern
and drops you in the town square."
									>
								)
								(T
									<TELL
". He sees you and says" ,K-GET-OUT-MSG form ".\" He shoos you out into the
tavern, and the farmers shoo you out into the town square."
									>
								)
							>
							<CRLF>
							<CRLF>
							<RT-RESET-TAVERN>
							<RT-GOTO ,RM-TOWN-SQUARE T>
						)
					>
				)
			>
			<RT-RESET-KITCHEN>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-CAGE"
;"---------------------------------------------------------------------------"

<OBJECT TH-CAGE
	(LOC RM-TAV-KITCHEN)
	(DESC "cage")
	(FLAGS FL-CONTAINER FL-NO-LIST FL-OPENABLE FL-SEARCH FL-TRANSPARENT)
	(SYNONYM CAGE BIRDCAGE)
	(ADJECTIVE BIRD)
	(CAPACITY 20)
	(ACTION RT-TH-CAGE)
>

<ROUTINE RT-TH-CAGE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<AND <TOUCH-VERB?>
				<IN? ,CH-COOK ,RM-TAV-KITCHEN>
			>
			<TELL ,K-HANDS-OFF-MSG>
		)
		(<AND <TOUCH-VERB?>
				<NOT <MC-FORM? ,K-FORM-ARTHUR>>
			>
			<COND
				(<MC-FORM? ,K-FORM-OWL>
					<TELL
"You flutter around the cage for a few moments, but don't make any progess." CR
					>
				)
				(<MC-FORM? ,K-FORM-SALAMANDER>
					<TELL
"You try to scope out a route that will take you up the wall, across the
roof, and down towards the cage - but it looks like such a long journey
that you decide to stay where you are." CR
					>
				)
				(T
					<RT-CANT-REACH-MSG ,TH-CAGE>
				)
			>
		)
		(<VERB? OPEN>
			<COND
				(<FSET? ,TH-CAGE ,FL-OPEN>
					<RT-ALREADY-MSG ,TH-CAGE "open">
				)
				(<NOT <IN? ,TH-BIRD ,TH-CAGE>>
					<RFALSE>
				)
				(T
					<RT-FREE-BIRD-MSG>
				)
			>
		)
		(<VERB? ENTER>
			<COND
				(<NOT <MC-FORM? ,K-FORM-SALAMANDER>>		;<RT-OBJ-TOO-LARGE? ,WINNER ,TH-CAGE>
					<TELL The+verb ,WINNER "are" " too big to fit in" the ,TH-CAGE "." CR>
				)
			>
		)
		(<AND <VERB? LISTEN>
				<NOT <FSET? ,TH-BIRD ,FL-LOCKED>>
			>
			<THIS-IS-IT ,TH-BIRD>
			<TELL ,K-BIRD-SOUNDS-MSG>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-BIRD"
;"---------------------------------------------------------------------------"

<OBJECT TH-BIRD
	(LOC TH-CAGE)
	(DESC "bird")
	(FLAGS FL-ALIVE FL-NO-LIST)
	(SYNONYM BIRD)
	(SIZE 5)
	(GENERIC RT-GN-BIRD)
	(ACTION RT-TH-BIRD)
>

; "TH-BIRD Flags:"
; "	FL-BROKEN - Player has gotten points for releasing bird."
; "	FL-LOCKED - Player has understood bird by becoming an owl."
; "	FL-ASLEEP - Cook has seen that the bird is gone."

<CONSTANT K-BIRD-CHATTERS-MSG
"The bird chatters an answer back to you and then looks frustrated that you
don't understand.|">
<CONSTANT K-BIRD-GETS-KEY-MSG
"The bird flies up and disappears into the thatch of the roof. Moments
later, a key falls to the floor. The bird pokes his head out of the thatch,">
<CONSTANT K-DROPPING-MSG
" leaves a small present on the table for the cook, and then flies out the
door.|">
<CONSTANT K-LET-OUT-MSG
"\"Sacre bleu! Ze time she ees flying, and I am not. Open ze cage and let me
out of 'ere.\"|">
<CONSTANT K-BIRD-SOUNDS-MSG
"It sounds as if the bird is trying to tell you something.|">

<ROUTINE RT-TH-BIRD ("OPT" (CONTEXT <>))
	<COND
		(<AND <VERB? HELLO GOODBYE THANK>
				<MC-CONTEXT? ,M-WINNER <>>
			>
			<COND
				(<MC-FORM? ,K-FORM-OWL>
					<COND
						(<VERB? HELLO>
							<TELL "\"'Allo.\"" CR>
						)
						(<VERB? GOODBYE>
							<TELL
"\"Mon Dieu! You can not leeve me 'ere. Zis man intends to COOK me. And with
no spices!!! You cannot be so cruel.\"" CR
							>
						)
						(<VERB? THANK>
							<TELL "\"Mais non. It is I who will be thanking you.\"|">
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
				(T
					<TELL ,K-BIRD-CHATTERS-MSG>
				)
			>
		)
		(<MC-CONTEXT? ,M-WINNER>
			<COND
				(<MC-FORM? ,K-FORM-OWL>
					<COND
						(<AND <VERB? TELL-ABOUT>
								<MC-PRSO? ,CH-PLAYER>
							>
							<RFALSE>
						)
						(<VERB? WHO WHAT>
							<RFALSE>
						)
						(<VERB? WHERE>
							<COND
								(<MC-PRSO? ,TH-CUPBOARD-KEY>
									<TELL
"\"I 'ave already told you thees. Ze key is in ze thatch.\"" CR
									>
								)
								(<MC-PRSO? ,TH-SPICE ,TH-SPICE-BOTTLE>
									<TELL
"\"Ze spices, zey are 'idden away in ze cupboard.\"" CR
									>
								)
							>
						)
						(T
							<TELL ,K-LET-OUT-MSG>
						)
					>
				)
				(T
					<TELL ,K-BIRD-CHATTERS-MSG>
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
		; "Message and RFATAL if don't want bird to become winner"
			<RFALSE>
		)
		(<VERB? ASK-ABOUT>
			<COND
				(<MC-FORM? ,K-FORM-OWL>
					<COND
						(<MC-PRSI? ,TH-BIRD>
							<TELL
"\"I 'ave just flown in from ze coast, and mon dieu are my arms tired.\"" CR
							>
						)
						(<MC-PRSI? ,TH-CUPBOARD-KEY>
							<TELL
"\"I 'ave already told you thees. Ze key is in ze thatch.\"" CR
							>
						)
						(<MC-PRSI? ,CH-COOK>
							<TELL
"\"Ee ees a barbarian. 'Ow do I know thees? Ee overcooks ze food and ee 'as
no knowledge of ze sauces. But I suppose eet ees not 'is fault - Ee ees
English.\"" CR
							>
						)
						(<MC-PRSI? ,TH-SPICE-BOTTLE ,TH-SPICE>
							<TELL
"\"In thees country, ze spice is rare. Eet ees why I only come 'ere on
'olidays.\"" CR
							>
						)
						(<MC-PRSI? ,CH-MERLIN>
							<TELL
"\"Eef 'ee ees such a great weezard, why does 'ee not make 'eemself ze
gourmet dejeuner, instead of all ze time eating ze nuts and berries?\"" CR
							>
						)
						(<MC-PRSI? ,CH-LOT>
							<TELL
"\"Bah! I weel not speak of 'eem. 'Ee drinks red wine with ze feesh and white
wine with ze meats. Surely when 'ee dies 'ee weel go to hell.\"" CR
							>
						)
						(T
							<TELL ,K-LET-OUT-MSG>
						)
					>
				)
				(T
					<TELL ,K-BIRD-CHATTERS-MSG>
				)
			>
		)
		(<AND <TOUCH-VERB?>
				<IN? ,CH-COOK ,RM-TAV-KITCHEN>
			>
			<TELL ,K-HANDS-OFF-MSG>
		)
		(<AND <TOUCH-VERB?>
				<NOT <MC-FORM? ,K-FORM-ARTHUR>>
			>
			<RT-CANT-REACH-MSG ,TH-CAGE>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-BIRD ,FL-SEEN>
			<COND
				(<FSET? ,TH-BIRD ,FL-LOCKED>
					<TELL
The ,TH-BIRD " is looking at you quizzically, waiting for you to make up
your mind." CR
					>
				)
				(<IN? ,TH-BIRD ,TH-CAGE>
					<TELL
The ,TH-BIRD " is hopping up and down in the cage, chattering at you." CR
					>
				)
				(T
					<TELL
The ,TH-BIRD " is flying around and chattering at you as if it is trying to
tell you something." CR
					>
				)
			>
		)
		(<AND <VERB? LISTEN>
				<NOT <FSET? ,TH-BIRD ,FL-LOCKED>>
			>
			<TELL ,K-BIRD-SOUNDS-MSG>
		)
		(<AND <SPEAKING-VERB?>
				<MC-HERE? ,RM-TAV-KITCHEN>
			>
			<COND
				(<MC-FORM? ,K-FORM-OWL>
					<TELL ,K-LET-OUT-MSG>
				)
				(T
					<TELL ,K-BIRD-CHATTERS-MSG>
				)
			>
		)
		(<AND <VERB? TAKE>
				<NOT <IN? ,TH-BIRD ,TH-CAGE>>
			>
			<TELL The ,TH-BIRD " flutters just out of your reach." CR>
		)
		(<AND <VERB? RELEASE>
				<IN? ,TH-BIRD ,TH-CAGE>
			>
			<RT-FREE-BIRD-MSG>
		)
	>
>

<ROUTINE RT-FREE-BIRD-MSG ()
	<FSET ,TH-CAGE ,FL-OPEN>
	<COND
		(<FSET? ,TH-BIRD ,FL-LOCKED>
			<REMOVE ,TH-BIRD>
			<MOVE ,TH-CUPBOARD-KEY ,RM-TAV-KITCHEN>
			<MOVE ,TH-DROPPING ,TH-TAVERN-TABLE>
			<TELL ,K-BIRD-GETS-KEY-MSG ,K-DROPPING-MSG>
		)
		(T
			<MOVE ,TH-BIRD ,RM-TAV-KITCHEN>
			<TELL
The ,TH-BIRD " comes out and flies around and around the room, pecking at
your head and chattering as if it is trying to tell you something." CR
			>
		)
	>
	<COND
		(<NOT <FSET? ,TH-BIRD ,FL-BROKEN>>
			<FSET ,TH-BIRD ,FL-BROKEN>
			<RT-SCORE-MSG 10 0 0 0>
		)
	>
	<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
	<COND
		(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
			<RT-UPDATE-DESC-WINDOW>
		)
	>
	<RTRUE>
>

<ROUTINE RT-GN-BIRD (TBL FINDER)
	<RETURN ,TH-BIRD>
>

;"---------------------------------------------------------------------------"
; "TH-CUPBOARD"
;"---------------------------------------------------------------------------"

<OBJECT TH-CUPBOARD
	(LOC RM-TAV-KITCHEN)
	(DESC "cupboard")
	(FLAGS FL-CONTAINER FL-LOCKED FL-NO-LIST FL-OPENABLE FL-SEARCH)
	(SYNONYM CUPBOARD CABINET DOOR)
	(ADJECTIVE KITCHEN)
	(CAPACITY 20)
	(ACTION RT-TH-CUPBOARD)
>

<ROUTINE RT-TH-CUPBOARD ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<AND <TOUCH-VERB?>
				<IN? ,CH-COOK ,RM-TAV-KITCHEN>
			>
			<TELL ,K-HANDS-OFF-MSG>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-CUPBOARD ,FL-SEEN>
			<TELL "It's an old wooden cupboard that's" open ,TH-CUPBOARD "." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-CUPBOARD-KEY"
;"---------------------------------------------------------------------------"

<OBJECT TH-CUPBOARD-KEY
	(DESC "wooden key")
	(FLAGS FL-BURNABLE FL-KEY FL-TAKEABLE)
	(SYNONYM KEY)
	(ADJECTIVE CUPBOARD WOODEN WOOD)
	(SCORE <LSH 1 ,K-QUEST-SHIFT>)
	(SIZE 1)
	(GENERIC RT-GN-KEY)
	(ACTION RT-TH-CUPBOARD-KEY)
>

<ROUTINE RT-TH-CUPBOARD-KEY ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<AND <VERB? UNLOCK>
				<MC-PRSO? ,TH-CUPBOARD>
			>
			<COND
				(<NOT <FSET? ,TH-CUPBOARD ,FL-LOCKED>>
					<TELL "The cupboard isn't locked." CR>
				)
				(T
					<FCLEAR ,TH-CUPBOARD ,FL-LOCKED>
					<TELL
The+verb ,WINNER "unlock" the ,TH-CUPBOARD " with" the ,TH-CUPBOARD-KEY "." CR
					>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-SPICE-BOTTLE"
;"---------------------------------------------------------------------------"

<OBJECT TH-SPICE-BOTTLE
	(LOC TH-CUPBOARD)
	(DESC "bottle")
	(FLAGS FL-CONTAINER FL-OPEN FL-SEARCH FL-TAKEABLE)
	(SYNONYM BOTTLE LABEL SPICE)
	(ADJECTIVE SPICE)
	(OWNER TH-SPICE-BOTTLE)
	(SCORE <LSH 1 ,K-QUEST-SHIFT>)
	(SIZE 5 CAPACITY 1)
	(GENERIC RT-GN-SPICE)
	(ACTION RT-TH-SPICE-BOTTLE)
>

<ROUTINE RT-TH-SPICE-BOTTLE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<AND <NOUN-USED? ,TH-SPICE-BOTTLE ,W?SPICE>
				<NOT <IN? ,TH-SPICE ,TH-SPICE-BOTTLE>>
				<NOT <EVERYWHERE-VERB? <COND (,NOW-PRSI 2) (T 1)>>>
			>
			<NP-CANT-SEE>
		)
		(,NOW-PRSI
			<COND
				(<VERB? PUT-IN EMPTY>
					<TELL "The neck is too narrow." CR>
				)
			>
		)
		(<VERB? DRINK-FROM>
			<COND
				(<IN? ,TH-WATER ,TH-SPICE-BOTTLE>
					<PERFORM ,V?DRINK ,TH-WATER>
					<RTRUE>
				)
				(T
					<TELL "There is nothing to drink in" the ,TH-SPICE-BOTTLE "." CR>
				)
			>
		)
		(<VERB? EXAMINE LOOK-ON READ>
			<FSET ,TH-SPICE-BOTTLE ,FL-SEEN>
			<TELL "The label on the bottle says \"Oriental Spices.\"" CR>
		)
		(<VERB? FILL>
			<COND
				(<AND <MC-PRSI? ,TH-BARREL>
						<NOT <IN? ,TH-BARREL-WATER ,TH-BARREL>>
					>
					<TELL "There isn't any " D ,TH-WATER " in" the ,TH-BARREL "." CR>
				)
				(<MC-PRSI? ,LG-LAKE ,RM-SHALLOWS ,LG-RIVER ,RM-FORD ,TH-BARREL-WATER ,TH-BARREL ,TH-WATER>
					<COND
						(<OR	<IN? ,TH-SPICE ,TH-SPICE-BOTTLE>
								<IN? ,TH-WATER ,TH-SPICE-BOTTLE>
							>
							<TELL
The ,TH-SPICE-BOTTLE " is already filled with " D <FIRST? ,TH-SPICE-BOTTLE> "." CR
							>
						)
						(T
							<MOVE ,TH-WATER ,TH-SPICE-BOTTLE>
							<TELL
The+verb ,WINNER "fill" the ,TH-SPICE-BOTTLE " with " D ,TH-WATER "." CR
							>
						)
					>
				)
			>
		)
		(<VERB? EMPTY>
			<COND
				(<IN? ,TH-SPICE ,TH-SPICE-BOTTLE>
					<REMOVE ,TH-SPICE>
					<TELL
The+verb ,WINNER "pour" " the spice out of the bottle, but it scatters in the
breeze before it reaches"
					>
					<COND
						(<MC-PRSI? <> ,ROOMS ,GLOBAL-HERE>
							<TELL the ,TH-GROUND>
						)
						(T
							<TELL the ,PRSI>
						)
					>
					<TELL "." CR>
					<RT-SCORE-MSG 0 -1 0 0>
				)
				(<IN? ,TH-WATER ,TH-SPICE-BOTTLE>
					<REMOVE ,TH-WATER>
					<TELL
The+verb ,WINNER "pour" the ,TH-WATER " out of" the ,TH-SPICE-BOTTLE "."
					>
					<COND
						(<FSET? ,HERE ,FL-WATER>
							<TELL " It disappears into the water.">
						)
						(T
							<TELL ,K-EVAPORATES-MSG>
						)
					>
					<CRLF>
				)
			>
		)
		(<VERB? OPEN>
			<RT-ALREADY-MSG ,TH-SPICE-BOTTLE "open">
		)
		(<VERB? BREAK>
			<REMOVE ,TH-SPICE-BOTTLE>
			<TELL "You smash" the ,TH-SPICE-BOTTLE ", and it shatters into a thousand pieces." CR>
			<RT-SCORE-MSG 0 -3 0 0>
		)
	>
>

<ROUTINE RT-GN-SPICE (TBL FINDER)
	<COND
		(<EQUAL? <PARSE-ACTION ,PARSE-RESULT> ,V?DROP>
			<RETURN ,TH-SPICE-BOTTLE>
		)
		(T
			<RETURN ,TH-SPICE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-SPICE"
;"---------------------------------------------------------------------------"

<OBJECT TH-SPICE
	(LOC TH-SPICE-BOTTLE)
	(DESC "spice")
	(FLAGS FL-COLLECTIVE FL-PLURAL FL-TRY-TAKE)
	(SYNONYM SPICE SPICES CINNAMON)
	(ADJECTIVE BROWN)
	(SIZE 1)
	(GENERIC RT-GN-SPICE)
	(ACTION RT-TH-SPICE)
>

<ROUTINE RT-TH-SPICE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EAT>
			<TELL
"Carefully," the+verb ,WINNER "taste" " a little of the spice. It tastes
like cinnamon." CR
			>
		)
		(<VERB? TAKE>
			<REMOVE ,TH-SPICE>
			<TELL
The+verb ,WINNER "pour" " the spice out of the bottle and it scatters on"
the ,TH-GROUND "." CR
			>
		)
		(<VERB? EXAMINE>
			<TELL
"The spice is light brown in colour, and it is very fine-grained." CR
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-TAVERN-TABLE"
;"---------------------------------------------------------------------------"

<OBJECT TH-TAVERN-TABLE
	(LOC RM-TAV-KITCHEN)
	(DESC "table")
	(FLAGS FL-NO-LIST FL-SEARCH FL-SURFACE)
	(SYNONYM TABLE)
	(CAPACITY 50)
	(ACTION RT-TH-TAVERN-TABLE)
>

<ROUTINE RT-TH-TAVERN-TABLE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? CLIMB-UP CLIMB-ON CLIMB-OVER>
			<TELL "It's not polite to " vw " on tables." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-DROPPING"
;"---------------------------------------------------------------------------"

<OBJECT TH-DROPPING
	(DESC "bird dropping")
	(FLAGS FL-TRY-TAKE)
	(SYNONYM DROPPING PRESENT)
	(ADJECTIVE BIRD)
	(ACTION RT-TH-DROPPING)
>

<ROUTINE RT-TH-DROPPING ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<TOUCH-VERB?>
			<RT-AUTHOR-MSG "Oooooh, gross!">
		)
	>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

