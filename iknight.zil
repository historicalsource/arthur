;"***************************************************************************"
; "game : Arthur"
; "file : IKNIGHT.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   15 May 1989 19:42:12  $"
; "revs : $Revision:   1.91  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Meadow/Invisible Knight"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

<INCLUDE "PDEFS">		; "Because PARSE-ACTION used in this file."

;"---------------------------------------------------------------------------"
; "RM-MEADOW"
;"---------------------------------------------------------------------------"

<ROOM RM-MEADOW
	(LOC ROOMS)
	(DESC "meadow")
	(FLAGS FL-LIGHTED)
	(SYNONYM MEADOW)
	(EAST PER RT-ENTER-IPAVILION)
	(NE TO RM-TOWN-GATE)
	(SE TO RM-FIELD-OF-HONOUR)
	(NW TO RM-MERPATH)
	(IN PER RT-ENTER-IPAVILION)
	(UP PER RT-MEADOW-UP)
	(GLOBAL LG-HILL RM-PAVILION RM-MERPATH RM-FIELD-OF-HONOUR)
	(ACTION RT-RM-MEADOW)
	(GENERIC RT-GN-MEADOW)
>

<CONSTANT K-GLITTER-MSG
"You see something glittering on the ground to the east.">

<ROUTINE RT-RM-MEADOW ("OPT" (CONTEXT <>) "AUX" ANY?)
	<COND
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-MEADOW>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTERED>
			<COND
				(<AND <NOT <FSET? ,CH-I-KNIGHT ,FL-LOCKED>>
						<NOT <EQUAL? ,OHERE ,RM-PAVILION>>
						<MC-FORM? ,K-FORM-ARTHUR>
					>
					<THIS-IS-IT ,CH-I-KNIGHT>
					<COND
						(<FSET? ,RM-PAVILION ,FL-LOCKED>
							<SET ANY? <RT-MOVE-ALL-BUT-WORN ,CH-PLAYER ,CH-I-KNIGHT>>
							<TELL
"|You hear the thunder of approaching hooves, but see nothing. Moments
later you feel ghostly fingers pluck at your clothing, and "
							>
							<COND
								(.ANY?
									<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT>>
									<TELL "everything you were carrying suddenly disappears. You">
								)
								(T
									<TELL "then">
								)
							>
							<TELL " hear a ghostly ">
							<COND
								(.ANY?
									<TELL "chuckle,">
								)
								(T
									<TELL "voice say, \"Curses,\"">
								)
							>
							<TELL " and then the hoofbeats recede once again to the east.|">
							<COND
								(<RT-META-IN? ,TH-MAGIC-RING ,CH-I-KNIGHT>
									<MOVE ,TH-MAGIC-RING ,RM-PAVILION>
									<FCLEAR ,TH-MAGIC-RING ,FL-INVISIBLE>
									<FCLEAR ,TH-GLITTER ,FL-INVISIBLE>
									<COND
										(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>
											<RT-UPDATE-MAP-WINDOW>
										)
									>
								)
							>
							<COND
								(<AND <IN? ,TH-MAGIC-RING ,RM-PAVILION>
										<FSET? ,RM-PAVILION ,FL-LOCKED>
									>
									<THIS-IS-IT ,TH-GLITTER>
									<TELL CR ,K-GLITTER-MSG CR>
								)
							>
						)
						(T
							<TELL
"|You hear the thunder of approaching hooves and suddenly a knight on
horseback pulls up next ot you. Startled that you can see him, he wheels his
horse around, shouts, \"Tally ho!\" and gallops away again, leaving your
possessions intact." CR
							>
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<TELL "You ">
			<COND
				(<MC-CONTEXT? ,M-F-LOOK>
					<TELL "come to">
				)
				(T
					<TELL "are" standing " in">
				)
			>
			<TELL
" a meadow. Paths lead off to the northeast, northwest, and southeast."
			>
			<COND
				(<NOT <FSET? ,RM-PAVILION ,FL-LOCKED>>
					<TELL " To the east you see a knight's pavilion.">
				)
				(<AND <IN? ,TH-MAGIC-RING ,RM-PAVILION>
						<MC-CONTEXT? ,M-LOOK>
					>
					<TELL " " ,K-GLITTER-MSG>
				)
			>
			<CRLF>
			<RFALSE>
		)
		(.CONTEXT
			<RFALSE>
		)
	>
>

<ROUTINE RT-MEADOW-UP ("OPT" (QUIET <>))
	<COND
		(<MC-FORM? ,K-FORM-OWL>
			<RETURN <RT-FLY-UP .QUIET>>
		)
		(T
			<RETURN ,RM-MERPATH>
		)
	>
>

<ROUTINE RT-ENTER-IPAVILION ("OPT" (QUIET <>))
	<COND
		(<AND <FSET? ,RM-PAVILION ,FL-LOCKED>
				<NOT <FSET? ,RM-PAVILION ,FL-TOUCHED>>
			>
			<COND
				(<EQUAL? ,P-WALK-DIR ,P?EAST>
					<COND
						(<IN? ,TH-MAGIC-RING ,RM-PAVILION>
							<RETURN ,RM-PAVILION>
						)
						(<NOT .QUIET>
							<TELL
"You walk around the eastern part of the meadow for a while, but you don't
see anything interesting, so you return." CR
							>
						)
					>
				)
				(<NOT .QUIET>
					<RT-IMPOSSIBLE-MSG>
				)
			>
			<RFALSE>
		)
		(T
			<RETURN ,RM-PAVILION>
		)
	>
>

<ROUTINE RT-GN-MEADOW (TBL FINDER)
	<RETURN ,RM-MEADOW>
>

;"---------------------------------------------------------------------------"
; "TH-GLITTER"
;"---------------------------------------------------------------------------"

<OBJECT TH-GLITTER
	(LOC RM-MEADOW)
	(DESC "glittering object")
	(FLAGS FL-INVISIBLE FL-NO-DESC)
	(SYNONYM GLITTER OBJECT)
	(ADJECTIVE GLITTERING)
	(ACTION RT-TH-GLITTER)
>

<ROUTINE RT-TH-GLITTER ("OPT" (CONTEXT <>))
	<COND
		(<NOT <IN? ,TH-MAGIC-RING ,RM-PAVILION>>
			<NP-CANT-SEE>
		)
		(<TOUCH-VERB?>
			<TELL The ,TH-GLITTER " is too far away." CR>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-GLITTER ,FL-SEEN>
			<TELL The ,TH-GLITTER " is on the ground to the east." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-PAVILION"
;"---------------------------------------------------------------------------"

<ROOM RM-PAVILION
	(LOC ROOMS)
	(FLAGS FL-HAS-SDESC FL-LIGHTED FL-LOCKED)
	(SYNONYM MEADOW PAVILION)
	(ADJECTIVE EAST)
	(WEST TO RM-MEADOW)
	(OUT TO RM-MEADOW)
	(SCORE <ORB <LSH 2 ,K-QUEST-SHIFT> <LSH 3 ,K-WISD-SHIFT>>)
	(GLOBAL RM-MEADOW)
	(ACTION RT-RM-PAVILION)
	(GENERIC RT-GN-MEADOW)
>

; "RM-PAVILION flags:"
; "	FL-LOCKED - Player has not seen pavilion"

<CONSTANT K-JUNK-SHOP-MSG
" It looks like an overcrowded junk shop. Bric-a-brac is piled everywhere."
>

<ROUTINE RT-RM-PAVILION ("OPT" (CONTEXT <>) (ART <>) (CAP? <>) "AUX" OBJ)
	<COND
		(<MC-CONTEXT? ,M-OBJDESC>
			<COND
				(.ART
					<PRINT-ARTICLE ,RM-PAVILION .ART .CAP?>
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
						(<FSET? ,RM-PAVILION ,FL-LOCKED>
							<TELL "east meadow">
						)
						(T
							<TELL "pavilion">
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-F-LOOK>
			<COND
				(<FSET? ,RM-PAVILION ,FL-LOCKED>
					<TELL "You" walk " a little to the east." CR>
					<RFALSE>
				)
				(T
					<COND
						(<VERB? WALK>
							<TELL "You enter the">
						)
						(T
							<TELL "Suddenly you find yourself in the middle of a">
						)
					>
					<TELL " knight's pavilion." ,K-JUNK-SHOP-MSG CR>
				;	<COND
						(<MC-CONTEXT? ,M-F-LOOK>
							<RT-SCORE-MSG 0 3 0 2>
						)
					>
					<COND
						(<AND <NOT <VERB? WALK>>
								<NOT <FSET? ,CH-I-KNIGHT ,FL-LOCKED>>
							>
							<RT-KNIGHT-RETURN-STUFF>
							<RT-KNIGHT-ASK>
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-V-LOOK ,M-LOOK>
			<COND
				(<FSET? ,RM-PAVILION ,FL-LOCKED>
					<TELL
"You are" standing " at the eastern edge of" the ,RM-MEADOW "." CR
					>
				)
				(T
					<TELL
The+verb ,WINNER "are" standing " in the knight's pavilion." ,K-JUNK-SHOP-MSG CR
					>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<COND
				(<FSET? ,RM-PAVILION ,FL-LOCKED>
					<SETG GL-PICTURE-NUM ,K-PIC-MEADOW>
				)
				(T
					<SETG GL-PICTURE-NUM ,K-PIC-PAVILION>
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
				(<FSET? ,RM-PAVILION ,FL-LOCKED>
					<RFALSE>
				)
				(<MC-FORM? ,K-FORM-ARTHUR>
					<COND
						(<NOT <FSET? ,CH-I-KNIGHT ,FL-LOCKED>>
							<RT-KNIGHT-RETURN-STUFF>
						)
					>
					<RT-KNIGHT-ASK>
				)
				(T
					<TELL "|The knight doesn't even glance at you." CR>
				)
			>
		)
		(<MC-CONTEXT? ,M-END>
			<COND
				(<FSET? ,RM-PAVILION ,FL-LOCKED>
					<RFALSE>
				)
				(<AND <VERB? TRANSFORM>
						<NOT <MC-FORM? ,GL-OLD-FORM>>
					>
					<TELL
"|The knight notices your transformation and shrugs indifferently." CR
					>
					<COND
						(<MC-FORM? ,K-FORM-ARTHUR>
							<COND
								(<NOT <FSET? ,CH-I-KNIGHT ,FL-LOCKED>>
									<RT-KNIGHT-RETURN-STUFF>
								)
							>
							<RT-KNIGHT-ASK>
						)
					>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<AND <FSET? ,RM-PAVILION ,FL-LOCKED>
				<NOT <EVERYWHERE-VERB? <COND (,NOW-PRSI 2) (T 1)>>>
				<NOUN-USED? ,RM-PAVILION ,W?PAVILION>
			>
			<NP-CANT-SEE>
		)
		(<VERB? EXAMINE>
			<COND
				(<MC-HERE? ,RM-PAVILION>
					<RFALSE>
				)
				(<NOT <FSET? ,RM-PAVILION ,FL-LOCKED>>
					<FSET ,RM-PAVILION ,FL-SEEN>
					<TELL
"It looks old and rundown, sort of like an old pawn shop." CR
					>
				)
				(<IN? ,TH-MAGIC-RING ,RM-PAVILION>
					<FSET ,TH-GLITTER ,FL-SEEN>
					<TELL ,K-GLITTER-MSG CR>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-COUNTER"
;"---------------------------------------------------------------------------"

<OBJECT TH-COUNTER
	(LOC RM-PAVILION)
	(DESC "counter")
	(FLAGS FL-INVISIBLE FL-SEARCH FL-SURFACE)
	(SYNONYM COUNTER)
	(CAPACITY 50)
	(ACTION RT-TH-COUNTER)
>

<ROUTINE RT-TH-COUNTER ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? LOOK-BEHIND LOOK-UNDER>
			<TELL
"You lean over the counter to take a look, but the invisible knight cuffs
you on the side of the head and says, \"Employees only.\"" CR
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "CH-I-KNIGHT"
;"---------------------------------------------------------------------------"

<OBJECT CH-I-KNIGHT
	(DESC "invisible knight")
	(FLAGS FL-ALIVE FL-NO-DESC FL-PERSON)
	(SYNONYM KNIGHT MAN PERSON)
	(ADJECTIVE INVISIBLE)
	(ACTION RT-CH-I-KNIGHT)
>

; "CH-I-KNIGHT flags:"
; "	FL-LOCKED - Player has entered pavilion, knight doesn't steal anymore."
; "	FL-BROKEN - Knight has stolen vital item(s) and given them to idiot."

<CONSTANT K-PITY-MSG "\"Pity.\" The knight turns his attention elsewhere.">

<ROUTINE RT-CH-I-KNIGHT ("OPT" (CONTEXT <>))
	<COND
		(<AND <VERB? HELLO GOODBYE THANK>
				<MC-CONTEXT? ,M-WINNER <>>
			>
			<COND
				(<VERB? HELLO>
					<TELL "\"Hello. Nice to see you again.\"" CR>
				)
				(<VERB? GOODBYE>
					<TELL "The knight grunts a goodbye without even looking up." CR>
				)
				(<VERB? THANK>
					<TELL "\"You're welcome.\"" CR>
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
				(<AND <VERB? YES NO>
						<NOT <FSET? ,TH-BRASS-EGG ,FL-LOCKED>>
					>
					<TELL "\"You already have" the ,TH-BRASS-EGG ".\"" CR>
				)
				(<VERB? YES>
					<RT-QUIZ>
				)
				(<VERB? NO>
					<TELL ,K-PITY-MSG CR>
				)
				(T
					<TELL
"He brushes you aside without really hearing what you said. \"Sorry, lad.
Too busy at the moment.\"" CR
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
				(<MC-PRSI? ,TH-BRASS-EGG>
					<TELL
"\"It's a solid brass egg that is so real that a giant raven itself can't
tell the difference between it and the real thing."
					>
					<COND
						(<FSET? ,TH-BRASS-EGG ,FL-LOCKED>
							<TELL " Are you interested?\"" CR>
							<COND
								(<YES? T>
									<RT-QUIZ>
								)
								(T
									<TELL ,K-PITY-MSG CR>
								)
							>
						)
						(T
							<TELL "\"" CR>
						)
					>
				)
				(<MC-PRSI? ,CH-I-KNIGHT>
					<TELL
"\"Oh, I do all right. Business is better in the summer, though.\"" CR
					>
				)
				(<MC-PRSI? ,CH-MERLIN>
					<TELL
"\"He and I reached an understanding years ago. If I don't pick his pockets,
then he won't turn me into a frog.\"" CR
					>
				)
				(<MC-PRSI? ,CH-LOT>
					<TELL
"\"Tainted goods. I don't go near him, and neither should you.\"" CR
					>
				)
				(<MC-PRSI? ,TH-EXCALIBUR>
					<TELL
"\"Bring it in. I may be able to get you a good price for it.\"" CR
					>
				)
				(<MC-PRSI? ,RM-PAVILION>
					<TELL
"\"It's a great location, but being invisible cuts down on the walk-in trade.\"" CR
					>
				)
				(T
					<COND
						(<FSET? ,PRSI ,FL-ALIVE>
							<TELL "\"Sorry, I deal only in inanimate objects.\"" CR>
						)
						(<OR  <IN? ,PRSI ,CH-PLAYER>
								<IN? ,PRSI ,TH-COUNTER>
							>
							<TELL
"The knight looks" the ,PRSI " over dubiously. \"Hmmmm. Don't think it's
worth much on the open market. Sorry.\"" CR
							>
						)
						(T
							<TELL
"\"I'd have to have a look at" him ,PRSI " to give you a good estimate.\"" CR
							>
						)
					>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,CH-I-KNIGHT ,FL-SEEN>
			<TELL
"He is a pleasant-looking fellow, although somewhat indistinct around the
edges." CR
			>
			<COND
				(<ADJ-USED? ,CH-I-KNIGHT ,W?INVISIBLE>
					<SETG GL-QUESTION 1>
					<RT-AUTHOR-MSG
"Don't you feel a little silly trying to look at an invisible knight?"
					>
				)
			>
			<RTRUE>
		)
		(<VERB? ATTACK>
			<COND
				(<MC-FORM? ,K-FORM-ARTHUR>
					<TELL
"The knight suddenly disappears. Seconds later, you feel yourself being
lifted up by the scruff of your neck and the seat of your pants, and then you
find yourself sailing through the air and landing on the hard turf outside.
A voice calls after you, \"And stay out!\" " ,K-MERLIN-WASTED-MSG CR
					>
					<RT-END-OF-GAME>
				)
			>
		)
		(<VERB? LOOK-THRU>
			<TELL "You can see right through the knight." CR>
			<RT-AUTHOR-MSG "But then, some people are like that.">
		)
	>
>

<ROUTINE RT-KNIGHT-RETURN-STUFF ()
	<FSET ,CH-I-KNIGHT ,FL-LOCKED>
	<MOVE ,CH-I-KNIGHT ,RM-PAVILION>
	<TELL
"|The knight sitting behind the counter looks up suddenly and says, \"Oh!
Hallo! Got one of those magic rings, have you? Well, I suppose you'll be
wanting your things back.\" He rummages around behind the counter and then "
	>
	<COND
		(<FIRST? ,CH-I-KNIGHT>
			<RT-MOVE-ALL ,CH-I-KNIGHT ,TH-COUNTER>
			<COND
				(<FSET? ,CH-I-KNIGHT ,FL-BROKEN>
					<TELL
"says, \"Hmmm. I seem to have traded some of them away.\" He brightens up,
\"but the rest of them are here.\" He "
					>
				)
			>
			<TELL
"dumps the contents of a basket onto the counter. \"Here you are.\"" CR
			>
		)
		(<FSET? ,CH-I-KNIGHT ,FL-BROKEN>
			<TELL
"says, \"Hmmm. I seem to have traded them all away.\"" CR
			>
		)
		(T
			<TELL
"says, \"That's funny. I don't seem to have anything for you.\"" CR
			>
		)
	>
>

<ROUTINE RT-KNIGHT-ASK ()
	<CRLF>
	<COND
		(<FSET? ,TH-BRASS-EGG ,FL-LOCKED>
			<COND
				(<FSET? ,TH-BRASS-EGG ,FL-BROKEN>
					<FCLEAR ,TH-BRASS-EGG ,FL-BROKEN>
					<TELL
"\"I wonder if I could interest you in a solid brass giant raven's egg.
It's so real that a giant raven itself can't tell the difference between it
and the real thing. Are you interested?\""
					>
				)
				(T
					<TELL
"The knight looks up and says, \"Back again? Would you like to try
for" the ,TH-BRASS-EGG "?\""
					>
				)
			>
			<CRLF>
			<COND
				(<YES? T>
					<RT-QUIZ>
				)
				(T
					<TELL ,K-PITY-MSG CR>
				)
			>
		)
		(T
			<TELL
"The knight glances up as you enter and then returns to his work." CR
			>
		)
	>
	<RTRUE>
>

<VOC "TH">

<ROUTINE RT-QUIZ ("AUX" VAL I N PTR (WIN? <>))
	<TELL
"|\"All right then. I'm a sporting man. If you can tell me the next two
letters in the following sequence, the egg is yours: ST ND RD TH.\"" CR
	>
	<REPEAT ()
		<TELL CR ">">
		<VERSION?
			(XZIP
				<PUTB ,P-INBUF 1 0>
			)
			(YZIP
				<PUTB ,P-INBUF 1 0>
			)
		>
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
		<SET PTR <ZREST ,P-LEXV <* ,P-LEXSTART 2>>>
		<SET N <GETB ,P-LEXV 1>>
		<COND
			(<AND <EQUAL? .N 1>
					<EQUAL? <ZGET .PTR 0> ,W?TH>
				>
				<SET WIN? T>
			)
			(<EQUAL? <ZGET .PTR 0> ,W?QUOTE>
				<SET PTR <ZREST .PTR 4>>
				<COND
					(<EQUAL? <ZGET .PTR 0> ,W?TH>
						<COND
							(<EQUAL? .N 2>
								<SET WIN? T>
							)
							(<AND <EQUAL? <ZGET <ZREST .PTR 4> 0> ,W?QUOTE>
									<EQUAL? .N 3>
								>
								<SET WIN? T>
							)
						>
					)
				>
			)
			(<EQUAL? <ZGET .PTR 0> ,W?SAY>
				<SET PTR <ZREST .PTR 4>>
				<COND
					(<AND <EQUAL? <ZGET .PTR 0> ,W?TH>
							<EQUAL? .N 2>
						>
						<SET WIN? T>
					)
					(<EQUAL? <ZGET .PTR 0> ,W?QUOTE>
						<SET PTR <ZREST .PTR 4>>
						<COND
							(<EQUAL? <ZGET .PTR 0> ,W?TH>
								<COND
									(<EQUAL? .N 3>
										<SET WIN? T>
									)
									(<EQUAL? .N 4>
										<SET PTR <ZREST .PTR 4>>
										<COND
											(<EQUAL? <ZGET .PTR 0> ,W?QUOTE>
												<SET WIN? T>
											)
										>
									)
								>
							)
						>
					)
				>
			)
		>
		<COND
			(.WIN?
				<COND
					(<RT-DO-TAKE ,TH-BRASS-EGG T>
						<FCLEAR ,TH-BRASS-EGG ,FL-LOCKED>
						<TELL
"\"Yes. That's it. Very Good. Here you are.\" He hands you the brass egg." CR
						>
						<RT-SCORE-OBJ ,TH-BRASS-EGG>
					)
				>
				<RTRUE>
			)
			(T
				<TELL "\"Sorry.">
			)
		>
		<TELL " Do you want to try again?\"" CR>
		<COND
			(<NOT <YES? T>>
				<RETURN>
			)
		>
		<TELL "\"All right then. What is your next guess?\"" CR>
	>
	<TELL "\"Please do return when you have calculated the answer.\"" CR>
>

;"---------------------------------------------------------------------------"
; "TH-BRASS-EGG"
;"---------------------------------------------------------------------------"

<OBJECT TH-BRASS-EGG
	(DESC "brass egg")
	(FLAGS FL-BROKEN FL-LOCKED FL-TAKEABLE)
	(SYNONYM EGG)
	(ADJECTIVE BRASS)
	(SCORE <ORB <LSH 7 ,K-WISD-SHIFT> <LSH 3 ,K-QUEST-SHIFT>>)
	(SIZE 15)
	(GENERIC RT-GN-EGG)
	(ACTION RT-TH-BRASS-EGG)
>

; "TH-BRASS-EGG flags:"
; "	FL-BROKEN - Knight has not asked initial question about egg"
; "	FL-LOCKED - Player has not yet received the egg"

<ROUTINE RT-TH-BRASS-EGG ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? SIT>
			<TELL
"You squat down on top of the egg, clucking to yourself occasionally and
dutifully trying to fool the egg into thinking that you are a medieval hen.
Unfortunately, this has no effect, other than to make you feel ridiculous,
so after a while you get up." CR
			>
			<SETG GL-QUESTION 1>
			<RT-AUTHOR-MSG "Geez! You'll try anything, won't you?">
		)
		(<VERB? EXAMINE>
			<TELL "It's a large, shiny egg made of solid brass." CR>
		)
	>
>

<ROUTINE RT-GN-EGG (TBL FINDER "AUX" PTR N OBJ)
	<SET PTR <REST-TO-SLOT .TBL FIND-RES-OBJ1>>
	<SET N <FIND-RES-COUNT .TBL>>
	<COND
		(<INTBL? ,P-IT-OBJECT .PTR .N>
			<SET OBJ ,P-IT-OBJECT>
		)
		(<AND <EQUAL? <PARSE-ACTION ,PARSE-RESULT> ,V?ASK-ABOUT>
				<MC-HERE? ,RM-PAVILION>
			>
			<SET OBJ ,TH-BRASS-EGG>
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
; "RM-ABOVE-MEADOW"
;"---------------------------------------------------------------------------"

<ROOM RM-ABOVE-MEADOW
	(LOC ROOMS)
	(DESC "above the meadow")
	(FLAGS FL-AIR FL-LIGHTED)
	(DOWN PER RT-FLY-DOWN)
	(NORTH TO RM-ABOVE-EDGE-OF-WOODS)
	(EAST TO RM-ABOVE-TOWN)
	(NW TO RM-ABOVE-MERCAVE)
	(NE TO RM-ABOVE-MOOR)
	(SOUTH TO RM-ABOVE-FIELD)
	(UP SORRY K-NO-HIGHER-MSG)
	(GLOBAL RM-MEADOW)
	(ACTION RT-RM-ABOVE-MEADOW)
>

<ROUTINE RT-RM-ABOVE-MEADOW ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,RM-MEADOW ,FL-SEEN>
			<FSET ,LG-FOREST ,FL-SEEN>
			<FSET ,RM-FIELD-OF-HONOUR ,FL-SEEN>
			<FSET ,LG-TOWN ,FL-SEEN>
			<FSET ,RM-MOOR ,FL-SEEN>
			<TELL
"You are hovering over the meadow. In the distance to the north you can see
the trees at the edge of the enchanted forest. To the northwest, Merlin's
hollow hill breaks the horizon. Below you to the south you see the field of
honour, and to the east you see the town. If you followed the breeze
northeast, you would be over the moor.|"
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

