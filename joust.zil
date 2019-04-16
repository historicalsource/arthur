;"***************************************************************************"
; "game : Arthur"
; "file : JOUST.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   16 May 1989  1:20:38  $"
; "revs : $Revision:   1.99  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Joust"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

<INCLUDE "PDEFS">		; "Because PARSE-ACTION used in this file."

;"---------------------------------------------------------------------------"
; "RM-EDGE-OF-WOODS"
;"---------------------------------------------------------------------------"

<ROOM RM-EDGE-OF-WOODS
	(LOC ROOMS)
	(DESC "edge of woods")
	(FLAGS FL-LIGHTED)
	(NORTH TO RM-ENCHANTED-FOREST)
	(SOUTH TO RM-ROAD)
	(IN PER RT-ENTER-BLUE-PAVILION)
	(UP PER RT-FLY-UP)
	(GLOBAL LG-ENCHANTED-TREES LG-FOREST RM-ROAD)
	(ACTION RT-RM-EDGE-OF-WOODS)
>

<ROUTINE RT-RM-EDGE-OF-WOODS ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<AND <VERB? CLIMB-ON>
						<MC-PRSO? ,ROOMS>
					>
					<PERFORM ,V?CLIMB-ON ,TH-HORSE>
					<RTRUE>
				)
				(<AND <VERB? TAKE>
						<MC-PRSO? ,ROOMS>
					>
					<SETUP-ORPHAN-NP "take lance" ,TH-RED-LANCE ,TH-GREEN-LANCE>
					<TELL
"The knight slaps you on the wrist and says, \"Musn't be greedy. "
,K-WHICH-LANCE-MSG
					>
					<RFATAL>
				)
			>
		)
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<TELL "You ">
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "are">
					<COND
						(<IN? ,CH-PLAYER ,TH-HORSE>
							<TELL " riding a horse">
						)
						(T
							<TELL standing>
						)
					>
					<TELL " at">
				)
				(T
					<TELL "come to">
				)
			>
			<FSET ,TH-BLUE-PAVILION ,FL-SEEN>
			<FSET ,TH-HORN ,FL-SEEN>
			<FSET ,TH-TREE ,FL-SEEN>
			<FSET ,TH-HORSE ,FL-SEEN>
			<TELL
" the edge of the woods, where you see a knight's pavilion decked out in
blue. A curved horn is hanging from the branches of one of the trees, and a
large horse is tied to another. The path continues north into the woods,
and south towards the town.|"
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-END>
			<COND
				(<AND <VERB? TRANSFORM>
						<IN? ,CH-BLUE-KNIGHT ,RM-EDGE-OF-WOODS>
					>
					<COND
						(<NOT <MC-FORM? ,GL-OLD-FORM>>
							<TELL
"|The knight looks at you curiously, says \"Damned odd,\" and runs you
through with his lance.|"
							>
							<RT-END-OF-GAME>
						)
						(,GL-FORM-ABORT
							<TELL
"|Fortunately, it all happened so quickly that" the ,CH-BLUE-KNIGHT " didn't
notice." CR
							>
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-EDGE-OF-WOODS>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTERED>
			<SETG GL-HORN-CNT 0>
			<SETG GL-HORSE-CNT 0>
		)
		(<MC-CONTEXT? ,M-EXIT>
			<COND
				(<IN? ,CH-BLUE-KNIGHT ,RM-EDGE-OF-WOODS>
					<MOVE ,TH-RED-LANCE ,CH-BLUE-KNIGHT>
					<MOVE ,TH-GREEN-LANCE ,CH-BLUE-KNIGHT>
					<REMOVE ,CH-BLUE-KNIGHT>
					<REMOVE ,TH-BLUE-HORSE>
					<RFALSE>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-RED-LANCE"
; "TH-GREEN-LANCE"
;"---------------------------------------------------------------------------"

<OBJECT TH-RED-LANCE
	(LOC CH-BLUE-KNIGHT)
	(DESC "red lance")
	(FLAGS FL-TAKEABLE FL-WEAPON)
	(SYNONYM RED LANCE LANCES)
	(ADJECTIVE RED)
	(SIZE 15)
	(GENERIC RT-GN-LANCE)
	(ACTION RT-TH-LANCE)
>

<OBJECT TH-GREEN-LANCE
	(LOC CH-BLUE-KNIGHT)
	(DESC "green lance")
	(FLAGS FL-TAKEABLE FL-WEAPON)
	(SYNONYM GREEN LANCE)
	(ADJECTIVE GREEN)
	(SIZE 15)
	(GENERIC RT-GN-LANCE)
	(ACTION RT-TH-LANCE)
>

<ROUTINE RT-GN-LANCE (TBL FINDER)
	<COND
		(<EQUAL? <PARSE-ACTION ,PARSE-RESULT> ,V?ASK-ABOUT>
			<RETURN ,TH-RED-LANCE>
		)
	>
>

<ROUTINE RT-TH-LANCE ("OPT" (CONTEXT <>) "AUX" OTHER)
	<COND
		(<MC-PRSO? ,TH-RED-LANCE>
			<SET OTHER ,TH-GREEN-LANCE>
		)
		(T
			<SET OTHER ,TH-RED-LANCE>
		)
	>
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? TAKE>
			<RT-TAKE-LANCE ,PRSO>
		)
		(<VERB? EXAMINE>
			<FSET ,PRSO ,FL-SEEN>
			<COND
				(<NOUN-USED? ,TH-RED-LANCE ,W?LANCES>
					<TELL "They both look the same, except for the colour." CR>
				)
				(T
					<TELL "It looks just the same as the other lance." CR>
				)
			>
		)
	>
>

<ROUTINE RT-TAKE-LANCE (LANCE)
	<COND
		(<NOT <IN? ,CH-PLAYER ,TH-HORSE>>
			<TELL
"The knight moves the lance beyond your reach and says, \"Haven't you read
Hoyle, lad? First you mount up, then you choose your lance.\"" CR
			>
		)
		(T
			<COND
				(<RT-DO-TAKE .LANCE>
					<RT-JOUST .LANCE>
				)
			>
			<RTRUE>
		)
	>
>

<GLOBAL GL-SH 0 <> BYTE>
<GLOBAL GL-LN 0 <> BYTE>
<GLOBAL GL-K-SH 0 <> BYTE>
<GLOBAL GL-K-LN 0 <> BYTE>

<ROUTINE RT-JOUST (LANCE "AUX" S L KS KL)
	<TELL "You take" the .LANCE ". The knight keeps the ">
	<COND
		(<EQUAL? .LANCE ,TH-RED-LANCE>
			<TELL "green">
		)
		(T
			<TELL "red">
		)
	>
	<TELL " one">
	<COND
		(<FSET? ,TH-HORSE ,FL-LOCKED>
			<FCLEAR ,TH-HORSE ,FL-LOCKED>
			<MOVE ,TH-BLUE-HORSE ,HERE>
			<TELL
"and fetches his horse from behind the pavilion. He unties your horse, which"
			>
		)
		(T
			<TELL ". Your horse">
		)
	>
	<TELL
" canters a little distance away and then turns to face the blue knight.
After a moment's hesitation the two well-trained horses start to gallop
towards one another.||"
	>

	<SETG GL-PICTURE-NUM ,K-PIC-JOUST>
	<COND
		(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
			<RT-UPDATE-PICT-WINDOW>
		)
	>

	<SET KS <RANDOM 3>>
	<SET KL <RANDOM 4>>
	<REPEAT ()
		<TELL "The knight">
		<RT-JOUST-STATUS-MSG ,CH-BLUE-KNIGHT ,CH-PLAYER .KS .KL>
		<CRLF>
		<CRLF>
		<SETG GL-K-SH .KS>
		<SETG GL-K-LN .KL>
		<REPEAT ()
			<SET S <RT-JOUST-READ <>>>
			<COND
				(<EQUAL? .S -1>
					<V-UNDO>
				)
				(T
					<RETURN>
				)
			>
		>
		<REPEAT ()
			<SET L <RT-JOUST-READ T>>
			<COND
				(<EQUAL? .L -1>
					<V-UNDO>
				)
				(T
					<RETURN>
				)
			>
		>
		<TELL The ,CH-PLAYER>
		<RT-JOUST-STATUS-MSG ,CH-PLAYER ,CH-BLUE-KNIGHT .S .L>
		<SETG GL-SH .S>
		<SETG GL-LN .L>
		<SET KS <RANDOM 3>>
		<SET KL <RANDOM 4>>
		<TELL " ">
		<SETG P-CAN-UNDO <ISAVE>>
		<COND
			(<EQUAL? ,P-CAN-UNDO 2>
				<SETG P-CONT -1>
				<V-$REFRESH>
			)
		>
		<TELL
"The two horses thunder toward each other. You are about to clash when you
see that the knight"
		>
		<RT-JOUST-STATUS-MSG ,CH-BLUE-KNIGHT ,CH-PLAYER .KS .KL>
		<CRLF>
		<CRLF>
		<SETG GL-K-SH .KS>
		<SETG GL-K-LN .KL>
		<COND
			(<OR	<EQUAL? <SET S <RT-JOUST-READ <>>> -1>
					<EQUAL? <SET L <RT-JOUST-READ T>> -1>
				>
				<SETG P-CAN-UNDO <>>
				<TELL
"After a moment's hesitation the two well-trained horses start to gallop
towards one another.||"
				>
				<AGAIN>
			)
			(T
				<RETURN>
			)
		>
	>
	<TELL The ,CH-PLAYER>
	<RT-JOUST-STATUS-MSG ,CH-PLAYER ,CH-BLUE-KNIGHT .S .L>
	<MOVE ,CH-PLAYER ,HERE>
	<MOVE .LANCE ,CH-BLUE-KNIGHT>
	<COND
		(<EQUAL? .L 4>
			<REMOVE ,CH-BLUE-KNIGHT>
			<REMOVE ,TH-BLUE-HORSE>
			<FSET ,TH-HORSE ,FL-LOCKED>
			<TELL
" The knight pulls up short to prevent you from injuring his horse. He knocks
you from your horse, and says, \"That's no way for a gentleman to fight.\" He
collects your lance, ties" the ,TH-HORSE " to" the ,TH-TREE " and disappears
into his pavilion saying, \"Come back when you're ready to joust properly.\"" CR
			>
			<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-OBJS>>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
					<RT-UPDATE-DESC-WINDOW>
				)
			>
		)
		(T
			<SET KS .L>
			<SET KL 2>
			<TELL " The knight">
			<RT-JOUST-STATUS-MSG ,CH-BLUE-KNIGHT ,CH-PLAYER .KS .KL>
		)
	>
	<COND
		(<AND <EQUAL? .S 2>
				<EQUAL? .L 2>
			>
			<FSET ,CH-BLUE-KNIGHT ,FL-BROKEN>
			<REMOVE ,CH-BLUE-KNIGHT>
			<REMOVE ,TH-BLUE-HORSE>
			<FSET ,TH-HORSE ,FL-LOCKED>
			<SETG WINNER ,CH-PLAYER>
			<RT-DO-TAKE ,TH-IVORY-KEY T>
			<SETG GL-QUESTION 1>
			<TELL
" The blue knight crashes to the turf. You try to stay upright on the horse,
but seconds later you, too, hit the ground. \"Well struck, lad!\" the knight
cries out. \"And by virtue of the fact that I was the first to be unseated,
you are declared the winner.\" After a few moments he staggers to his feet
and disappears into the pavilion. He emerges moments later with an ivory key,
which he hands to you." CR CR

"\"Congratulations, old chap. Spoils of war, what?\"" CR CR

"The knight stumbles around the clearing, cleaning up after the joust. He
ties the horse to the tree, collects the lances and disappears into the
pavilion." CR
			>
			<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-OBJS>>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
					<RT-UPDATE-DESC-WINDOW>
				)
			>
			<RT-SCORE-MSG 10 5 7 4>
		)
		(<NOT <EQUAL? .L 4>>
			<TELL " The knight deals you a stunning blow on your ">
			<COND
				(<EQUAL? .S 2>
					<TELL "shield">
				)
				(T
					<TELL "chest">
				)
			>
			<TELL
", knocking you from the horse. He took the blow from your lance on his
shield, and stayed on his horse."
			>
			<COND
				(<NOT <EQUAL? .L 2>>
					<TELL
" He cuffs you on the head as he rides by and says, \"And that's for not
jousting like a gentleman.\""
					>
				)
			;	(T
					<TELL
" He cuffs you on the head as he rides by and says, \"And that's for thinking
that I would not joust like a gentleman.\""
					>
				)
			>
			<TELL
"||Your horse stands next to you. The knight says, \"Tough luck, old
bean. Care to try again?\"|"
			>
			<UPDATE-STATUS-LINE>
			<COND
				(<YES? T>
					<TELL "\"Mount up, then.\"|">
				)
				(T
					<REMOVE ,CH-BLUE-KNIGHT>
					<REMOVE ,TH-BLUE-HORSE>
					<FSET ,TH-HORSE ,FL-LOCKED>
					<TELL
"\"Pity. I'll be running along then. Cheerio!\" The knight ties the horse to
the tree, collects the lances and disappears into the pavilion." CR
					>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-OBJS>>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
							<RT-UPDATE-DESC-WINDOW>
						)
					>
				)
			>
		)
	>

	<SETG GL-PICTURE-NUM ,K-PIC-EDGE-OF-WOODS>
	<COND
		(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
			<RT-UPDATE-PICT-WINDOW>
		)
	>

	<RTRUE>
>

<ROUTINE RT-JOUST-STATUS-MSG (ATT DEF S L)
	<TELL verb .ATT "shield" his .ATT " ">
	<RT-TARGET-MSG .S>
	<TELL " and" verb .ATT "aim" his .ATT " lance at" his .DEF " ">
	<RT-TARGET-MSG .L>
	<TELL ".">
>

<ROUTINE RT-TARGET-MSG (T)
	<COND
		(<EQUAL? .T 1>
			<TELL "head">
		)
		(<EQUAL? .T 2>
			<TELL "body">
		)
		(<EQUAL? .T 3>
			<TELL "leg">
		)
		(<EQUAL? .T 4>
			<TELL "horse">
		)
	>
>

<VOC "HEAD" NOUN>
<VOC "BODY" NOUN>
<VOC "LEG" NOUN>
<VOC "LEGS" NOUN>
<VOC "HORSE" NOUN>

<ROUTINE RT-JOUST-READ (LANCE? "AUX" VAL WORD)
	<REPEAT ()
		<PUTB ,P-INBUF 1 0>
		<TELL "Do you want to ">
		<COND
			(.LANCE?
				<SET VAL 4>
				<TELL "aim your lance at his">
			)
			(T
				<SET VAL 3>
				<TELL "shield your">
			)
		>
		<REPEAT ((I 1))
			<TELL " (" N .I ") ">
			<RT-TARGET-MSG .I>
			<COND
				(<IGRTR? .I .VAL>
					<RETURN>
				)
				(T
					<TELL ",">
					<COND
						(<EQUAL? .I .VAL>
							<TELL " or">
						)
					>
				)
			>
		>
		<TELL "?" CR ">">
		<REPEAT ()
			<SET VAL <ZREAD ,P-INBUF ,P-LEXV>>
			<COND
				(<EQUAL? .VAL 10 13>
					<RETURN>
				)
				(T
					<RT-HOT-KEY .VAL>
				)
			>
		>
		<VERSION?
			(YZIP
				<RT-SCRIPT-INBUF>
			)
		>
		<SET WORD <ZGET ,P-LEXV ,P-LEXSTART>>
		<SET VAL 0>
		<COND
			(<EQUAL? .WORD ,W?HEAD>
				<SET VAL 1>
			)
			(<EQUAL? .WORD ,W?BODY>
				<SET VAL 2>
			)
			(<EQUAL? .WORD ,W?LEG ,W?LEGS>
				<SET VAL 3>
			)
			(<AND .LANCE?
					<EQUAL? .WORD ,W?HORSE>
				>
				<SET VAL 4>
			)
			(<AND ,P-CAN-UNDO
					<EQUAL? .WORD ,W?UNDO>
				>
			;	<V-UNDO>
				<SET VAL -1>
			)
			(<EQUAL? .WORD ,W?RESTART>
				<V-RESTART>
			)
			(<EQUAL? .WORD ,W?RESTORE>
				<V-RESTORE>
			)
			(<EQUAL? .WORD ,W?QUIT ,W?Q>
				<V-QUIT>
			)
			(<NUMBER? <ZREST ,P-LEXV <* ,P-LEXSTART 2>>>
				<COND
					(<OR	<EQUAL? ,P-NUMBER 1 2 3>
							<AND .LANCE? <EQUAL? ,P-NUMBER 4>>
						>
						<SET VAL ,P-NUMBER>
					)
				>
			)
		>
		<COND
			(<NOT <ZERO? .VAL>>
				<RETURN>
			)
		>
	>
	<RETURN .VAL>
>

;"---------------------------------------------------------------------------"
; "TH-TREE"
;"---------------------------------------------------------------------------"

<OBJECT TH-TREE
	(LOC RM-EDGE-OF-WOODS)
	(DESC "tree")
	(FLAGS FL-NO-DESC FL-SURFACE FL-SEARCH)
	(SYNONYM TREE BRANCH BRANCHES)
	(ACTION RT-TH-TREE)
>

<ROUTINE RT-TH-TREE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-TREE ,FL-SEEN>
			<FSET ,TH-HORN ,FL-SEEN>
			<TELL
"It's a large shade tree that has a horn hanging from one of its lower
branches." CR
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-HORN"
;"---------------------------------------------------------------------------"

<OBJECT TH-HORN
	(LOC TH-HORN-CHAIN)
	(DESC "horn")
	(FLAGS FL-NO-LIST FL-TRY-TAKE)
	(SYNONYM HORN)
	(ACTION RT-TH-HORN)
>

; "TH-HORN flags:"
; "	FL-LOCKED - Horn has been blown"

<GLOBAL GL-HORN-CNT 0 <> BYTE>

<ROUTINE RT-TH-HORN ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<RFALSE>
		)
		(<VERB? BLOW>
			<THIS-IS-IT ,TH-HORN>
			<COND
				(<MC-FORM? ,K-FORM-ARTHUR>
					<FSET ,TH-HORN ,FL-LOCKED>
					<INC GL-HORN-CNT>
					<COND
						(<EQUAL? ,GL-HORN-CNT 1>
							<COND
								(<IN? ,CH-BLUE-KNIGHT ,HERE>
									<TELL "The knight">
								)
								(T
									<TELL "The door to the pavilion opens and ">
									<COND
										(<FSET? ,CH-BLUE-KNIGHT ,FL-SEEN>
											<TELL "the knight">
										)
										(T
											<FSET ,CH-BLUE-KNIGHT ,FL-SEEN>
											<TELL
"a knight with a bushy white mustache and splendid side-whiskers"
											>
										)
									>
									<TELL " pokes his head out and">
								)
							>
							<TELL
" splutters, \"I say, I say. I mean, after all... What the deuce has happened
to manners? Doesn't anyone knock anymore? It's not my fault that some damned
fool hung that horn there. Why don't you knock on the door like a proper
person?\""
							>
						)
						(<EQUAL? ,GL-HORN-CNT 2>
							<COND
								(<IN? ,CH-BLUE-KNIGHT ,HERE>
									<TELL "The">
								)
								(T
									<TELL "The door swings open again and the">
								)
							>
							<TELL
" knight says, \"I really must insist that you cease blowing that infernal
horn. Otherwise I shall smite you.\""
							>
						)
						(T
							<TELL "The knight">
							<COND
								(<NOT <IN? ,CH-BLUE-KNIGHT ,HERE>>
									<TELL " emerges from the pavilion and">
								)
							>
							<TELL
" says, \"I'm sorry to have to do this, old chap. But you leave
me no choice.\" He deals you a mighty blow that puts a dent in his mailed
fist and has the unfortunate side-effect of killing you.|"
							>
							<RT-END-OF-GAME>
						)
					>
					<COND
						(<NOT <IN? ,CH-BLUE-KNIGHT ,HERE>>
							<TELL ,K-RETREATS-INSIDE-MSG>
						)
					>
					<CRLF>
				)
				(T
					<TELL "You can't reach the horn. You're" aform "." CR>
				)
			>
		)
		(<VERB? TAKE MOVE>
			<THIS-IS-IT ,TH-HORN>
			<TELL "You can't. The horn is chained to the tree." CR>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-HORN ,FL-SEEN>
			<THIS-IS-IT ,TH-HORN>
			<TELL "It is the kind of curved horn used in hunting." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-HORN-CHAIN"
;"---------------------------------------------------------------------------"

<OBJECT TH-HORN-CHAIN
	(LOC TH-TREE)
	(DESC "chains")
	(FLAGS FL-NO-LIST FL-PLURAL FL-SURFACE FL-SEARCH FL-TRY-TAKE)
	(SYNONYM CHAIN CHAINS)
	(ACTION RT-TH-HORN-CHAIN)
>

<ROUTINE RT-TH-HORN-CHAIN ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<RFALSE>
		)
		(<VERB? TAKE MOVE>
			<FSET ,TH-TREE ,FL-SEEN>
			<TELL "The chains are firmly attached to the tree." CR>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-TREE ,FL-SEEN>
			<TELL "The chains firmly attach the horn to the tree." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-BLUE-HORSE"
;"---------------------------------------------------------------------------"

<OBJECT TH-BLUE-HORSE
	(DESC "blue knight's horse")
	(FLAGS FL-ALIVE FL-NO-LIST FL-SEARCH FL-SURFACE FL-VEHICLE FL-TRY-TAKE)
	(SYNONYM HORSE HORSES)
	(ADJECTIVE BLUE)
	(OWNER CH-BLUE-KNIGHT)
	(GENERIC RT-GN-HORSE)
	(ACTION RT-TH-BLUE-HORSE)
>

<ROUTINE RT-TH-BLUE-HORSE ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-WINNER>
			<TELL "The horse doesn't seem to understand you." CR>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? CLIMB-ON>
			<TELL "The blue knight is already on the horse." CR>
		)
		(<VERB? EXAMINE>
			<COND
				(<NOUN-USED? ,TH-BLUE-HORSE ,W?HORSES>
					<SETG P-THEM-OBJECT <>>
					<FCLEAR ,THEM ,FL-TOUCHED>
					<TELL "The horses look evenly matched." CR>
				)
				(T
					<FSET ,TH-BLUE-HORSE ,FL-SEEN>
					<TELL "It is a sturdy creature, obviously bred for jousting." CR>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-HORSE"
;"---------------------------------------------------------------------------"

<OBJECT TH-HORSE
	(LOC RM-EDGE-OF-WOODS)
	(DESC "white horse")
	(FLAGS FL-ALIVE FL-LOCKED FL-NO-LIST FL-SEARCH FL-SURFACE FL-VEHICLE FL-TRY-TAKE)
	(SYNONYM HORSE)
	(ADJECTIVE WHITE)
	(NORTH PER RT-HORSE-TIED)
	(SOUTH PER RT-HORSE-TIED)
	(EAST PER RT-HORSE-TIED)
	(WEST PER RT-HORSE-TIED)
	(NE PER RT-HORSE-TIED)
	(NW PER RT-HORSE-TIED)
	(SE PER RT-HORSE-TIED)
	(SW PER RT-HORSE-TIED)
	(GENERIC RT-GN-HORSE)
	(ACTION RT-TH-HORSE)
>

<GLOBAL GL-HORSE-CNT 0 <> BYTE>

<CONSTANT K-WHICH-LANCE-MSG
"Which lance would you like, the red one or the green one?\"|">

<ROUTINE RT-TH-HORSE ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-WINNER>
			<TELL "The horse doesn't seem to understand you." CR>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<OR	<AND <VERB? WALK> <EQUAL? ,P-WALK-DIR ,P?DOWN>>
						<AND <VERB? WALK-TO CLIMB-DOWN CLIMB-ON> <MC-PRSO? ,TH-GROUND>>
						<AND <VERB? CLIMB-DOWN> <MC-PRSO? ,TH-HORSE>>
					>
					<MOVE ,WINNER ,HERE>
					<TELL The+verb ,WINNER "are" " back on" the ,TH-GROUND "." CR>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? CLIMB-ON>
			<COND
				(<MC-FORM? ,K-FORM-ARTHUR>
					<COND
						(<IN? ,CH-PLAYER ,TH-HORSE>
							<TELL "You are already on the horse." CR>
						)
						(T
							<MOVE ,WINNER ,TH-HORSE>
							<TELL The+verb ,WINNER "are" " now on the horse.">
							<COND
								(<IN? ,CH-BLUE-KNIGHT ,RM-EDGE-OF-WOODS>
									<SETUP-ORPHAN-NP "take lance" ,TH-RED-LANCE ,TH-GREEN-LANCE>
									<TELL
" \"Jolly good,\" says the knight. \"" ,K-WHICH-LANCE-MSG
									>
								)
								(T
									<CRLF>
								)
							>
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
				(T
					<TELL "The horse shies away from you." CR>
				)
			>
		)
		(<AND <VERB? DISMOUNT>
				<IN? ,CH-PLAYER ,TH-HORSE>
			>
			<MOVE ,WINNER ,HERE>
			<TELL The+verb ,WINNER "are" " back on" the ,TH-GROUND "." CR>
		)
		(<VERB? UNTIE RELEASE TAKE>
			<COND
				(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
					<RT-ANIMAL-CANT-MSG "untie" ,TH-HORSE>
				)
				(<IN? ,WINNER ,TH-HORSE>
					<TELL
The ,WINNER " can't do that while you are on the horse." CR
					>
				)
				(T
					<INC GL-HORSE-CNT>
					<COND
						(<EQUAL? ,GL-HORSE-CNT 1>
							<TELL "As you start to untie the horse, ">
							<COND
								(<IN? ,CH-BLUE-KNIGHT ,RM-EDGE-OF-WOODS>
									<TELL "the knight">
								)
								(T
									<TELL
"a knight pokes his head out of the door of the pavilion and"
									>
								)
							>
							<TELL
" says, \"I'm awfully sorry, old chap. But if you steal that horse I shall be
forced to kill you.\""
							>
							<COND
								(<NOT <IN? ,CH-BLUE-KNIGHT ,RM-EDGE-OF-WOODS>>
									<TELL ,K-RETREATS-INSIDE-MSG>
								)
							>
							<CRLF>
						)
						(<EQUAL? ,GL-HORSE-CNT 2>
							<TELL "The knight ">
							<COND
								(<NOT <IN? ,CH-BLUE-KNIGHT ,RM-EDGE-OF-WOODS>>
									<TELL
"pokes his head out of the door long enough to say"
									>
								)
								(T
									<TELL "says">
								)
							>
							<TELL
", \"I'm not joking, you know. If you persist in trying to steal that
horse, I shall smite you.\"" CR
							>
						)
						(<EQUAL? ,GL-HORSE-CNT 3>
							<TELL "The knight ">
							<COND
								(<NOT <IN? ,CH-BLUE-KNIGHT ,RM-EDGE-OF-WOODS>>
									<TELL "comes out of the pavilion and ">
								)
							>
							<TELL
"smites you. You are now smitten. You are also dead.|"
							>
							<RT-END-OF-GAME>
						)
					>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-HORSE ,FL-SEEN>
			<TELL "It is a sturdy creature, obviously bred for jousting." CR>
		)
		(<AND <VERB? ATTACK>
				<VERB-WORD? ,W?KICK>
				<IN? ,WINNER ,TH-HORSE>
			>
			<RT-HORSE-TIED>
			<RTRUE>
		)
	>
>

<ROUTINE RT-HORSE-TIED ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<RFALSE>
		)
		(<IN? ,CH-BLUE-KNIGHT ,RM-EDGE-OF-WOODS>
			<TELL "The knight cuts you off and says, \"That's my horse, lad.\"|">
		)
		(T
			<TELL
"The horse isn't going anywhere while it's tied to that tree.|">
		)
	>
	<RFALSE>
>

<ROUTINE RT-GN-HORSE (TBL FINDER)
	<RETURN ,TH-HORSE>
>

;"---------------------------------------------------------------------------"
; "CH-BLUE-KNIGHT"
;"---------------------------------------------------------------------------"

<OBJECT CH-BLUE-KNIGHT
	(DESC "blue knight")
	(FLAGS FL-ALIVE FL-OPEN FL-PERSON FL-SEARCH)
	(SYNONYM KNIGHT MAN PERSON)
	(ADJECTIVE BLUE OLD)
	(GENERIC RT-GN-OLD-MAN)
	(ACTION RT-CH-BLUE-KNIGHT)
>

; "CH-BLUE-KNIGHT flags:"
; "	FL-LOCKED - Knight has made comment about horn"
; "	FL-BROKEN - Knight has lost joust"

<ROUTINE RT-CH-BLUE-KNIGHT ("OPT" (CONTEXT <>))
	<COND
		(<AND <MC-CONTEXT? <> ,M-WINNER>
				<VERB? HELLO GOODBYE>
			>
			<COND
				(<VERB? HELLO>
					<TELL "\"Greetings, lad.\"" CR>
				)
				(<VERB? GOODBYE>
					<TELL
"\"Leaving so soon? Perhaps it's just as well. Come back when you've learned
to joust like a gentleman.\"" CR
					>
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
				(<VERB? JOUST>
					<TELL "\"I'd love to. ">
					<COND
						(<NOT <IN? ,CH-PLAYER ,TH-HORSE>>
							<TELL "Mount up">
						)
						(T
							<TELL "Take a lance">
						)
					>
					<TELL ", lad.\"" CR>
				)
				(<AND <VERB? GIVE>
						<MC-PRSI? ,CH-PLAYER>
					>
					<COND
						(<MC-PRSO? ,TH-RED-LANCE ,TH-GREEN-LANCE>
							<RT-TAKE-LANCE ,PRSO>
						)
					>
				)
				(T
					<TELL
"The knight looks at you and says, \"Not now, old chap. Let's joust.\"" CR
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
				(<MC-PRSI? ,TH-RED-LANCE ,TH-GREEN-LANCE>
					<TELL
"\"They're both the same, old bean. Knight's honour and all that.\"" CR
					>
				)
				(<MC-PRSI? ,CH-BLUE-KNIGHT>
					<TELL
"\"Oh, I'm just an old campaigner who enjoys a sportsmanlike joust every now
and again.\"" CR
					>
				)
				(<MC-PRSI? ,TH-HORSE ,TH-BLUE-HORSE>
					<COND
						(<NOUN-USED? ,PRSI ,W?HORSES>
							<TELL
"\"You'll not find two better trained, more evenly matched jousting horses
in the country.\"" CR
							>
						)
						(T
							<TELL
"\"He's one of the best-trained jousting horses in the county.\"" CR
							>
						)
					>
				)
				(<MC-PRSI? ,CH-MERLIN>
					<TELL
"\"I've never heard of him. What team does he joust for?\"" CR
					>
				)
				(<MC-PRSI? ,CH-LOT>
					<TELL
"The knight snorts in derision. \"Nasty piece of business, there. I'd steer
clear of him if I were you, lad.\"" CR
					>
				)
				(<MC-PRSI? ,TH-HORN>
					<TELL
"\"Some blasted fool hung it up there while I was away on holiday and I
haven't been able to get it down since.\"" CR
					>
				)
				(<MC-PRSI? ,TH-JOUST>
					<TELL
"\"Jolly good question. King of sports, don't you know? Flower of chivalry
and all that, what?\"" CR
					>
				)
				(<MC-PRSI? ,TH-EXCALIBUR>
					<TELL
"\"Sorry - jousting's my sport. I leave swordplay to the younger set.\"" CR
					>
				)
				(<MC-PRSI? ,TH-CHIVALRY>
					<TELL
"\"It's all quite simple, you know. 'Do unto others,' and all that.\"" CR
					>
				)
				(<MC-PRSI? ,TH-BLUE-PAVILION>
					<TELL
"\"They say an Englishman's home is his castle. But you'll notice they
keep their mouths shut about these bloody cheap pavilions.\"" CR
					>
				)
				(T
					<TELL
"\"Afraid I don't know too much about that, old fellow. Sorry.\"" CR
					>
				)
			>
		)
		(<VERB? ATTACK>
			<MOVE ,TH-RED-LANCE ,CH-BLUE-KNIGHT>
			<MOVE ,TH-GREEN-LANCE ,CH-BLUE-KNIGHT>
			<REMOVE ,CH-BLUE-KNIGHT>
			<REMOVE ,TH-BLUE-HORSE>
			<TELL
"The knight easily avoids your awkward attempt to " vw " him and cuffs you on
the head. \"That's no way for a gentleman to fight,\" he says, disappearing
into his pavilion. \"Come back when you're ready to joust.\"" CR
			>
			<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-OBJS>>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
					<RT-UPDATE-DESC-WINDOW>
				)
			>
			<RTRUE>
		)
		(<VERB? EXAMINE>
			<FSET ,CH-BLUE-KNIGHT ,FL-SEEN>
			<TELL
"The knight is an elderly gentleman with a bushy white mustache and splendid
side-whiskers." CR
			>
		)
		(<VERB? ASK-FOR>
			<COND
				(<MC-PRSI? ,TH-RED-LANCE ,TH-GREEN-LANCE>
					<RT-TAKE-LANCE ,PRSI>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-BLUE-PAVILION"
;"---------------------------------------------------------------------------"

<OBJECT TH-BLUE-PAVILION
	(LOC RM-EDGE-OF-WOODS)
	(DESC "pavilion")
	(FLAGS FL-NO-DESC)
	(SYNONYM PAVILION PAVILLION DOOR TENT)
	(ACTION RT-TH-BLUE-PAVILION)
>

<CONSTANT K-RETREATS-INSIDE-MSG " He retreats inside the pavilion and closes the door.">

<ROUTINE RT-TH-BLUE-PAVILION ("OPT" (CONTEXT <>) "AUX" (J <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<AND <TOUCH-VERB?>
				<IN? ,CH-PLAYER ,TH-HORSE>
			>
			<TELL The ,WINNER " can't reach">
			<COND
				(<NOUN-USED? ,TH-BLUE-PAVILION ,W?DOOR>
					<TELL " the door">
				)
				(T
					<TELL the ,TH-BLUE-PAVILION>
				)
			>
			<TELL " while you're on the horse." CR>
		)
		(<VERB? KNOCK SCRATCH>
			<COND
				(<IN? ,CH-BLUE-KNIGHT ,HERE>
					<TELL
"The knight says, \"Have ye gone daft, lad? I'm already here.\"" CR
					>
				)
				(T
					<TELL "The door to the pavilion opens and ">
					<COND
						(<FSET? ,CH-BLUE-KNIGHT ,FL-SEEN>
							<TELL "the knight">
						)
						(T
							<FSET ,CH-BLUE-KNIGHT ,FL-SEEN>
							<TELL
"a knight with a bushy white mustache and splendid side-whiskers"
							>
						)
					>
					<TELL " emerges. ">
					<COND
						(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
							<TELL
"He looks around, says \"Damn teenagers,\" and retreats inside." CR
							>
						)
						(<FSET? ,CH-BLUE-KNIGHT ,FL-BROKEN>
							<TELL
"\"You again? You've beaten me once already. Go away.\"" ,K-RETREATS-INSIDE-MSG CR
							>
						)
						(T
							<COND
								(<NOT <FSET? ,CH-BLUE-KNIGHT ,FL-LOCKED>>
									<FSET ,CH-BLUE-KNIGHT ,FL-LOCKED>
									<COND
										(<FSET? ,TH-HORN ,FL-LOCKED>
											<TELL
"\"That's better,\" he fusses. \"Don't know what the world's coming to. "
											>
										)
										(T
											<TELL
"\"I say, frightfully kind of you to knock. Most people just start to blow
away on that beastly horn. "
											>
										)
									>
								)
							>
							<TELL
"I suppose you're here to joust?\" He looks you up and down. "
							>
							<COND
								(<NOT <IN? ,TH-ARMOUR ,CH-PLAYER>>
									<TELL
"\"I see you have no armour. A man without armour is no nobleman, therefore I
cannot joust with you.\"" ,K-RETREATS-INSIDE-MSG CR
									>
								)
								(<NOT <IN? ,TH-SHIELD ,CH-PLAYER>>
									<TELL
"\"I see you have no shield. I can't joust with a man who has no shield. It
wouldn't be cricket - although I don't suppose that's been invented yet.
Still, if it had, it wouldn't be, if you see what I mean. Sorry.\""
,K-RETREATS-INSIDE-MSG CR
									>
								)
								(<FSET? ,TH-SHIELD ,FL-BROKEN>
									<TELL
"\"I see your shield is tarnished. Can't joust with a man with a tarnished
shield. It's just not done. Knight in shining armour and all that, don't you
know. Sorry.\"" ,K-RETREATS-INSIDE-MSG CR
									>
								)
								(T
									<MOVE ,CH-BLUE-KNIGHT ,RM-EDGE-OF-WOODS>
									<FSET ,TH-RED-LANCE ,FL-SEEN>
									<FSET ,TH-GREEN-LANCE ,FL-SEEN>
									<TELL
"\"Splendid. I see you are a gentleman and prefer to joust without a helmet.
Let's have at it then.\"" CR CR

"The knight disappears into the pavilion for a moment and then emerges
carrying two lances that are identical save that one is red and one is green.
\"Mount up, lad,\" says the knight, \"And I shall give you your choice of
lances.\"" CR
									>
									<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-OBJS>>
									<COND
										(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
											<RT-UPDATE-DESC-WINDOW>
										)
									>
									<RTRUE>
								)
							>
						)
					>
				)
			>
		)
		(<VERB? ENTER>
			<TELL "The door is closed." CR>
		)
		(<NOUN-USED? ,TH-BLUE-PAVILION ,W?DOOR>
			<COND
				(<VERB? OPEN UNLOCK>
					<TELL "The door is locked from the inside." CR>
				)
			>
		)
		(<VERB? LOOK-BEHIND>
			<TELL "It's not polite to look in other people's back yard." CR>
		)
	>
>

<ROUTINE RT-ENTER-BLUE-PAVILION ("OPT" (QUIET <>))
	<COND
		(<NOT .QUIET>
			<TELL "The door is closed." CR>
		)
	>
	<RFALSE>
>

;"---------------------------------------------------------------------------"
; "TH-SHIELD"
;"---------------------------------------------------------------------------"

<OBJECT TH-SHIELD
	(LOC RM-ARMOURY)
	(DESC "shield")
	(FLAGS FL-BROKEN FL-TAKEABLE FL-NO-DESC)
	(SYNONYM SHIELD)
	(SCORE <LSH 1 ,K-QUEST-SHIFT>)
	(SIZE 10)
	(ACTION RT-TH-SHIELD)
>

; "TH-SHIELD flags:"
; "	FL-BROKEN - Shield is tarnished"

<ROUTINE RT-TH-SHIELD ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<RFALSE>
		)
		(<VERB? EXAMINE LOOK-IN>
			<FSET ,TH-SHIELD ,FL-SEEN>
			<COND
				(<FSET? ,TH-SHIELD ,FL-BROKEN>
					<TELL
The ,TH-SHIELD " looks old and tarnished, but serviceable." CR
					>
				)
				(T
					<FSET ,TH-SHIELD ,FL-SEEN>
					<TELL
The+verb ,WINNER "see" " an amazingly clear reflection of yourself in"
the ,TH-SHIELD "." CR
					>
					<RT-AUTHOR-MSG "Not a pretty sight.">
				)
			>
		)
		(<VERB? POLISH>
			<COND
				(<FSET? ,TH-SHIELD ,FL-BROKEN>
					<COND
						(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
							<RT-ANIMAL-CANT-MSG>
						)
						(<MC-PRSI? ,TH-PUMICE>
							<FCLEAR ,TH-SHIELD ,FL-BROKEN>
							<TELL
"A few minutes work puts a mirror-like shine on" the ,TH-SHIELD "." CR
							>
							<RT-SCORE-MSG 0 2 0 0>
						)
						(T
							<TELL
The ,WINNER " can't shine" the ,TH-SHIELD " with" the ,PRSI "." CR
							>
						)
					>
				)
			>
		)
		(<VERB? POINT>
			<COND
				(<AND <MC-PRSI? ,CH-BASILISK>
						<FSET? ,CH-BASILISK ,FL-ALIVE>
						<NOT <FSET? ,TH-SHIELD ,FL-BROKEN>>
					>
					<RT-KILL-BASILISK>
				)
				(<OR	<FSET? ,TH-SHIELD ,FL-BROKEN>
						<NOT <FSET? ,PRSI ,FL-ALIVE>>
						<FSET? ,PRSI ,FL-ASLEEP>
					>
					<TELL
"You point" the ,TH-SHIELD " at" the ,PRSI ", but nothing happens." CR
					>
				)
				(T
					<TELL
The+verb ,PRSI "glance" " at" his ,PRSI " reflection, but then" verb ,PRSI
"ignore" " it." CR
					>
				)
			>
		)
		(<AND <VERB? HIDE-BEHIND RAISE>
				<MC-HERE? ,RM-BAS-LAIR>
				<FSET? ,CH-BASILISK ,FL-ALIVE>
				<NOT <FSET? ,TH-SHIELD ,FL-BROKEN>>
			>
			<RT-KILL-BASILISK>
		)
		(<AND <VERB? HIDE-BEHIND RAISE>
				<MC-HERE? ,RM-NORTH-OF-CHASM>
				<FSET? ,TH-BOAR ,FL-ALIVE>
			>
			; "Duane - have the boar run right through the shield & kill Arthur."
			<COND
				(<IN? ,TH-SHIELD ,CH-PLAYER>
					<TELL
"The boar crashes through the shield as if it were made of paper. "
					>
					<RT-I-BOAR T>
				)
				(T
					<TELL "You're not holding the shield." CR>
					<SETG CLOCK-WAIT T>
					<RFATAL>
				)
			>
		)
		(<AND <VERB? SHOW>
				<MC-PRSI? ,CH-BASILISK>
				<FSET? ,CH-BASILISK ,FL-ALIVE>
				<NOT <FSET? ,TH-SHIELD ,FL-BROKEN>>
			>
			<RT-KILL-BASILISK>
		)
		(<VERB? HIDE-BEHIND>
			<TELL The ,TH-SHIELD " is too small to hide behind." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-ARMOUR"
;"---------------------------------------------------------------------------"

<OBJECT TH-ARMOUR
	(LOC RM-ARMOURY)
	(DESC "armour")
	(FLAGS FL-CLOTHING FL-COLLECTIVE FL-PLURAL FL-TAKEABLE FL-VOWEL FL-NO-DESC)
	(SYNONYM ARMOUR ARMOR MAIL COAT)
	(ADJECTIVE CHAIN)
	(OWNER TH-ARMOUR)		;"coat of armour"
	(SIZE 50)
	(SCORE <LSH 1 ,K-QUEST-SHIFT>)
	(GENERIC RT-GN-ARMOUR)
	(ACTION RT-TH-ARMOUR)
>

<ROUTINE RT-TH-ARMOUR ("OPT" (CONTEXT <>) "AUX" (CR? <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? WEAR>
			<COND
				(<FSET? ,TH-ARMOUR ,FL-WORN>
					<RT-ALREADY-MSG ,WINNER "wearing the armour">
				)
				(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
					<RT-ANIMAL-CANT-MSG>
				)
				(T
					<COND
						(<IN? ,TH-ARMOUR ,WINNER>
							<TELL
The+verb ,WINNER "slide" " the chain mail on over" the ,TH-TUNIC "."
							>
						)
						(T
							<RT-DO-TAKE ,TH-ARMOUR T>
							<SET CR? T>
							<TELL
"You stick your head into the chain mail, work it down over your tunic,
and then manage to straighten up." CR
							>
							<RT-SCORE-OBJ ,TH-ARMOUR>
						)
					>
					<FSET ,TH-ARMOUR ,FL-WORN>
					<COND
					;	(<IN? ,CH-PRISONER ,HERE>
							<COND
								(.CR?
									<CRLF>
								)
								(T
									<TELL " ">
								)
							>
							<TELL
"\"A knight in shining armour,\" says the prisoner, looking you up and down."
							>
							<COND
								(<AND <FSET? ,TH-SHIELD ,FL-BROKEN>
										<VISIBLE? ,TH-SHIELD>
									>
									<TELL
" Then he glances at your tarnished shield and adds, \"Almost.\""
									>
								)
							>
							<CRLF>
						)
						(<NOT .CR?>
							<CRLF>
						)
					>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT>>
					<RTRUE>
				)
			>
		)
		(<VERB? UNWEAR>
			<COND
				(<OR	<NOT <FSET? ,TH-ARMOUR ,FL-WORN>>
						<NOT <IN? ,TH-ARMOUR ,WINNER>>
					>
					<RT-AUTHOR-ON>
					<TELL The+verb ,WINNER "are" "n't wearing" the ,TH-ARMOUR ".">
					<RT-AUTHOR-OFF>
				)
				(<AND <IN? ,CH-KRAKEN ,HERE>
						<FSET? ,CH-KRAKEN ,FL-LOCKED>
					>
					<TELL
The ,WINNER " can't remove" the ,TH-ARMOUR " while that kraken is holding on
to" him ,WINNER "." CR
					>
				)
				(T
					<MOVE ,TH-ARMOUR ,HERE>
					<FCLEAR ,TH-ARMOUR ,FL-WORN>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT>>
					<TELL
The+verb ,WINNER "wriggle" " out of the chain mail, and it falls to"
the ,TH-GROUND "." CR
					>
					<COND
						(<MC-HERE? ,RM-BOG>
							<CRLF>
							<RT-DROP-IN-BOG ,TH-ARMOUR>
						)
					>
					<RTRUE>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-ARMOUR ,FL-SEEN>
			<TELL The ,TH-ARMOUR " is a brightly polished coat of chain mail." CR>
		)
	>
>

<ROUTINE RT-GN-ARMOUR (TBL FINDER)
	<RETURN ,TH-ARMOUR>
>

;"---------------------------------------------------------------------------"
; "RM-ABOVE-EDGE-OF-WOODS"
;"---------------------------------------------------------------------------"

<ROOM RM-ABOVE-EDGE-OF-WOODS
	(LOC ROOMS)
	(DESC "above edge of the woods")
	(FLAGS FL-AIR FL-LIGHTED)
	(DOWN PER RT-FLY-DOWN)
	(NORTH TO RM-ABOVE-FOREST)
	(SOUTH TO RM-ABOVE-MEADOW)
	(WEST TO RM-ABOVE-MERCAVE)
	(EAST TO RM-ABOVE-MOOR)
	(SE TO RM-ABOVE-TOWN)
	(UP SORRY K-NO-HIGHER-MSG)
	(ACTION RT-RM-ABOVE-EDGE-OF-WOODS)
>

<ROUTINE RT-RM-ABOVE-EDGE-OF-WOODS ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,LG-FOREST ,FL-SEEN>
			<FSET ,RM-MEADOW ,FL-SEEN>
			<FSET ,RM-MOOR ,FL-SEEN>
			<TELL
"You are hovering over the edge of the woods. The depths of the forest lie to
the north, while to the south you can see the openness of the meadow. Merlin's
hollow hill lies to the west, and to the east you see the desolate moor.|"
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

