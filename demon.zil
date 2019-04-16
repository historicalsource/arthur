;"***************************************************************************"
; "game : Arthur"
; "file : DEMON.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   12 May 1989  0:41:38  $"
; "revs : $Revision:   1.76  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Hall of Demon"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "RM-DEMON-HALL"
;"---------------------------------------------------------------------------"

<ROOM RM-DEMON-HALL
	(LOC ROOMS)
	(DESC "hall")
	(FLAGS FL-LIGHTED FL-INDOORS)
	(SYNONYM HALL)
	(ADJECTIVE DEMON)
	(OWNER CH-DEMON)
	(SOUTH TO RM-HOT-ROOM IF LG-HOT-DOOR IS OPEN)
	(OUT TO RM-HOT-ROOM IF LG-HOT-DOOR IS OPEN)
	(SCORE <ORB <LSH 5 ,K-WISD-SHIFT> <LSH 3 ,K-QUEST-SHIFT>>)
	(GLOBAL LG-HOT-DOOR LG-WALL)
	(ACTION RT-RM-DEMON-HALL)
	(THINGS
		<> (SHIELD SHIELDS) RT-PS-DEMON-SHIELDS
	)
>

<ROUTINE RT-RM-DEMON-HALL ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,CH-DEMON ,FL-SEEN>
			<FSET ,TH-DEMON-THRONE ,FL-SEEN>
			<FSET ,TH-LEFT-MANACLE ,FL-SEEN>
			<FSET ,TH-RIGHT-MANACLE ,FL-SEEN>
			<FSET ,TH-MANACLES ,FL-SEEN>
			<FSET ,TH-FLEECE ,FL-SEEN>
			<FSET ,TH-GOLD-KEY ,FL-SEEN>
			<TELL "You ">
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "are" standing " in">
				)
				(T
					<TELL "have entered">
				)
			>
			<TELL
" a long, narrow banqueting hall that is panelled in dark walnut. High above
you, the walls are lined with the shields of vanquished knights. At the
far end "
			>
			<COND
				(<MC-CONTEXT? ,M-F-LOOK>
					<TELL
"is a golden throne, upon which sits a beautiful girl. As you walk the length
of the hall, you see that the girl's wrists are manacled to the throne, and
that she is sitting on a Golden Fleece."
					>
				)
				(T
					<TELL "of the hall, a ">
					<COND
						(<FSET? ,CH-DEMON ,FL-LOCKED>
							<TELL "beautiful girl">
						)
						(T
							<TELL "hideous demon">
						)
					>
					<TELL " is sitting on">
					<COND
						(<IN? ,TH-FLEECE ,TH-DEMON-THRONE>
							<TELL a ,TH-FLEECE ", which covers">
						)
					>
					<TELL " ">
					<COND
						(<FSET? ,CH-DEMON ,FL-LOCKED>
							<TELL "her">
						)
						(T
							<TELL "his">
						)
					>
					<TELL " throne. ">
					<COND
						(<FSET? ,CH-DEMON ,FL-LOCKED>
							<TELL "Her">
						)
						(T
							<TELL "His">
						)
					>
					<TELL " ">
					<COND
						(<OR	<FSET? ,TH-LEFT-MANACLE ,FL-OPEN>
								<FSET? ,TH-RIGHT-MANACLE ,FL-OPEN>
							>
							<COND
								(<FSET? ,TH-LEFT-MANACLE ,FL-OPEN>
									<TELL "right ">
								)
								(T
									<TELL "left ">
								)
							>
							<TELL "hand is">
						)
						(T
							<TELL "hands are">
						)
					>
					<TELL " manacled to" the ,TH-DEMON-THRONE ".">
					<COND
						(<OR	<IN? ,TH-GOLD-KEY ,CH-GIRL>
								<IN? ,TH-GOLD-KEY ,CH-DEMON>
							>
							<TELL " A golden key hangs around ">
							<COND
								(<FSET? ,CH-DEMON ,FL-LOCKED>
									<TELL "her">
								)
								(T
									<TELL "his">
								)
							>
							<TELL " neck.">
						)
					>
				)
			>
			<CRLF>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<COND
				(<FSET? ,CH-DEMON ,FL-LOCKED>
					<SETG GL-PICTURE-NUM ,K-PIC-GIRL>
				)
				(T
					<SETG GL-PICTURE-NUM ,K-PIC-DEMON>
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
				(<FSET? ,CH-DEMON ,FL-LOCKED>
					<COND
						(<FSET? ,CH-GIRL ,FL-LOCKED>
							<FCLEAR ,CH-GIRL ,FL-LOCKED>
							<TELL
"|The girl's image seems to shimmer for a second, and then she says, \"Oh
kind sir, I have been imprisoned by the evil demon who rules this place. But
if you release me, I will keep you by my side evermore.\"" CR
							>
						)
						(T
							<TELL
"|The girl smiles at you demurely and says, \"Thank goodness you've returned!
Won't you please remove these unmaidenly manacles so that we might be
together for always?\"" CR
							>
						)
					>
				)
				(T
					<RT-DEMON-OFFER-MSG>
				)
			>
		)
		(<MC-CONTEXT? ,M-EXIT>
			<COND
				(<FSET? ,CH-DEMON ,FL-LOCKED>
					<COND
						(<IN? ,TH-GOLD-KEY ,CH-PLAYER>
							<RT-DEMON-OFFER-MSG T>
							<RTRUE>
						)
						(T
							<TELL
"The girl calls out after you, \"Oh prithee, sir! Please do not abandon me
to this cruel fate!\"||"
							>
						)
					>
				)
			>
			<COND
				(<FSET? ,LG-HOT-DOOR ,FL-OPEN>
					<FCLEAR ,LG-HOT-DOOR ,FL-OPEN>
					<TELL
The ,LG-HOT-DOOR " swings shut behind you with an ominous \"clank.\"||"
					>
				)
			>
			<RFALSE>
		)
		(.CONTEXT
			<RFALSE>
		)
	>
>

<ROUTINE RT-PS-DEMON-SHIELDS ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
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
					<TELL "shields">
				)
			>
		)
		(<VERB? EXAMINE LOOK-IN LOOK-ON>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<TELL "The shields are trophies of the demon's past conquests." CR>
		)
		(<TOUCH-VERB?>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<TELL "The shields are too high to reach." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "CH-GIRL"
;"---------------------------------------------------------------------------"

<OBJECT CH-GIRL
	(DESC "girl")
	(LOC TH-DEMON-THRONE)
	(FLAGS FL-ALIVE FL-FEMALE FL-LOCKED FL-NO-DESC FL-OPEN FL-PERSON FL-SEARCH)
	(SYNONYM GIRL WOMAN PERSON)
	(ADJECTIVE BEAUTIFUL FEMALE)
	(GENERIC RT-GN-BEAUTIFUL-WOMAN)
	(ACTION RT-CH-GIRL)
>

; "CH-GIRL flags:"
; "	FL-LOCKED - Girl has not given first speech."

<ROUTINE RT-CH-GIRL ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<COND
		(<AND <MC-CONTEXT? ,M-WINNER <>>
				<VERB? HELLO>
			>
			<TELL
"The girl flutters her eyelashes demurely. \"Greetings, kind sir.\"" CR
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
"\"If you will but release me from these cruel manacles, I shall do whatever
you wish.\"" CR
					>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<COND
				(<AND <VERB? SHOW>
						<MC-PRSO? ,TH-GOLD-KEY>
					>
					<TELL
"The girl inclines her head towards the manacles and says, \"If you would be
so kind....\"" CR
					>
				)
				(<AND <VERB? GIVE>
						<MC-PRSO? ,TH-GOLD-KEY>
					>
					<COND
						(<OR	<FSET? ,TH-LEFT-MANACLE ,FL-OPEN>
								<FSET? ,TH-RIGHT-MANACLE ,FL-OPEN>
							>
							<RT-FREE-DEMON-MSG T>
						)
						(T
							<TELL
"The girl refuses your offer and cries, \"Oh why do you torment me so? To put
a key into a hand that is manacled is surely the cruelest of jests.\"" CR
							>
						)
					>
				)
			>
		)
		(<AND <VERB? TELL>
				,P-CONT
			>
		; "Message and RFATAL if don't want the demon to become winner"
			<RFALSE>
		)
		(<VERB? ASK-ABOUT>
			<COND
				(<NOUN-USED? ,PRSI ,W?TEETH>
					<RT-DEMON-OFFER-MSG>
				)
				(<MC-PRSI? ,CH-DEMON>
					<TELL "\"He hath imprisoned me most cruelly.\"" CR>
				)
				(<MC-PRSI? ,TH-GOLD-KEY>
					<TELL "\"It is the key that will unlock these cruel manacles.\"" CR>
				)
				(<MC-PRSI? ,CH-MERLIN>
					<SETG GL-QUESTION 1>
					<TELL
"The girl's eyes flash with anger. \"Are you going to help me or not?\"" CR
					>
				)
				(<MC-PRSI? ,CH-LOT>
					<TELL
"\"I have not met him.\" She lowers her eyes demurely and continues, \"But
surely he cannot be as handsome as you.\"" CR
					>
				)
				(<MC-PRSI? ,TH-EXCALIBUR>
					<TELL
"\"I've heard it is a mighty sword, but even Excalibur would be powerless
against these manacles.\"" CR
					>
				)
				(T
					<TELL
"She looks at you imploringly and says, \"If you would but release me, I
will tell you all I know.\"" CR
					>
				)
			>
		)
		(<VERB? ASK-FOR>
			<TELL
"She looks at you imploringly and says, \"I will give you whatever you wish,
if you would only unlock these cruel manacles.\"" CR
			>
		)
		(<VERB? ATTACK>
			<RT-DEMON-OFFER-MSG>
		)
		(<VERB? EXAMINE>
			<FSET ,CH-GIRL ,FL-SEEN>
			<TELL "The girl is sitting on">
			<COND
				(<IN? ,TH-FLEECE ,TH-DEMON-THRONE>
					<TELL a ,TH-FLEECE ", which covers">
				)
			>
			<TELL " her throne. Her ">
			<COND
				(<FSET? ,TH-LEFT-MANACLE ,FL-OPEN>
					<TELL "left hand is">
				)
				(<FSET? ,TH-RIGHT-MANACLE ,FL-OPEN>
					<TELL "right hand is">
				)
				(T
					<TELL "hands are">
				)
			>
			<TELL " manacled to the arms of the throne.">
			<COND
				(<IN? ,TH-GOLD-KEY ,CH-GIRL>
					<TELL " A golden key hangs around her neck.">
				)
			>
			<TELL
"||As you look at her, her image seems to shimmer slightly." CR
			>
		)
		(<VERB? KISS>
			<TELL
"As you approach, her lips part to meet yours and you see that her teeth are
pointed. At the last second, you pull away." CR
			>
		)
		(<VERB? RELEASE>
			<COND
				(<IN? ,TH-GOLD-KEY ,WINNER>
					<RT-FREE-DEMON-MSG>
				)
				(T
					<SETG CLOCK-WAIT T>
					<RT-AUTHOR-MSG ,K-HOW-INTEND-MSG>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "CH-DEMON"
;"---------------------------------------------------------------------------"

<OBJECT CH-DEMON
	(DESC "demon")
	(LOC TH-DEMON-THRONE)
	(FLAGS FL-ALIVE FL-NO-DESC FL-LOCKED FL-OPEN FL-PERSON FL-SEARCH)
	(SYNONYM DEMON NUDD TEETH PERSON)
	(ADJECTIVE UGLY)
	(ACTION RT-CH-DEMON)
>

; "CH-DEMON flags:"
; "	FL-BROKEN - Demon has been foiled, will not stop player from leaving."
; "	FL-LOCKED - Demon is disguised."

<ROUTINE RT-CH-DEMON ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<COND
		(<AND <MC-CONTEXT? ,M-WINNER <>>
				<VERB? HELLO>
			>
			<COND
				(<FSET? ,CH-DEMON ,FL-LOCKED>
					<RT-DEMON-OFFER-MSG>
				)
				(T
					<TELL
"\"Hello yourself!\" the demon roars. \"Now open these manacles!\"" CR
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-WINNER>
			<COND
				(<FSET? ,CH-DEMON ,FL-LOCKED>
					<RT-DEMON-OFFER-MSG>
				)
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
"\"Open these manacles and I'll do whatever you want.\"" CR
					>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<AND <FSET? ,CH-DEMON ,FL-LOCKED>
				<MC-HERE? ,RM-DEMON-HALL>
				<NOT <EVERYWHERE-VERB? <COND (,NOW-PRSI 2) (T 1)>>>
			>
			<RT-DEMON-OFFER-MSG>
			<COND
				(<AND <VERB? TELL>
						,P-CONT
					>
					<RFATAL>
				)
				(T
					<RTRUE>
				)
			>
		)
		(,NOW-PRSI
			<COND
				(<AND <VERB? SHOW>
						<MC-PRSO? ,TH-GOLD-KEY>
					>
					<TELL
"The demon roars in anguish, \"Stop tormenting me and open these damnable
manacles!\"" CR
					>
				)
				(<AND <VERB? GIVE>
						<MC-PRSO? ,TH-GOLD-KEY>
					>
					<COND
						(<OR	<FSET? ,TH-LEFT-MANACLE ,FL-OPEN>
								<FSET? ,TH-RIGHT-MANACLE ,FL-OPEN>
							>
							<RT-FREE-DEMON-MSG T>
						)
						(T
							<TELL
"The demon screams at you. \"Idiot! What good does the key do me when my
hands are manacled? Unlock the manacles, moron!\"" CR
							>
						)
					>
				)
			>
		)
		(<AND <VERB? TELL>
				,P-CONT
			>
		; "Message and RFATAL if don't want the demon to become winner"
			<RFALSE>
		)
		(<VERB? ASK-ABOUT>
			<COND
				(<MC-PRSI? ,CH-DEMON>
					<TELL
"\"I am the glorious epitome of all that is evil.\"" CR
					>
				)
				(<MC-PRSI? ,TH-GOLD-KEY>
					<TELL
"\"It is the key that will unlock these accursed manacles.\"" CR
					>
				)
				(<MC-PRSI? ,TH-LEFT-MANACLE ,TH-RIGHT-MANACLE ,TH-MANACLES>
					<TELL
"\"They were fastened upon me by Merlin's gods. Then they hung that damned
key about my neck to further torment me.\"" CR
					>
				)
				(<MC-PRSI? ,TH-FLEECE>
					<TELL
"\"I have already given you the fleece. Now release me!\"" CR
					>
				)
				(<MC-PRSI? ,CH-MERLIN>
					<TELL
"\"He is nothing but a third rate conjurer. His days are numbered.\"" CR
					>
				)
				(<MC-PRSI? ,CH-LOT>
					<TELL
"\"Yes, yes. I'll kill him for you. I'll chain him to a rock and have rats
gnaw at his liver; or perhaps I'll roast him slowly on a spit over red-hot
coals. But first you must release me.\"" CR
					>
				)
				(<MC-PRSI? ,TH-EXCALIBUR>
					<TELL
"\"Fancy swords will do you no good in here, boy.\"" CR
					>
				)
				(T
					<TELL "\"Enough of this chatter. Release me!\"" CR>
				)
			>
		)
		(<VERB? ATTACK>
			<TELL
"You feel a jolt of electricity pass through your body and the demon cackles,
\"Fool! You can't hurt me!\"" CR
			>
		)
		(<VERB? EXAMINE>
			<FSET ,CH-DEMON ,FL-SEEN>
			<TELL "The hideously ugly demon is sitting on">
			<COND
				(<IN? ,TH-FLEECE ,TH-DEMON-THRONE>
					<TELL a ,TH-FLEECE ", which covers">
				)
			>
			<TELL " his throne. His ">
			<COND
				(<FSET? ,TH-LEFT-MANACLE ,FL-OPEN>
					<TELL "left hand is">
				)
				(<FSET? ,TH-RIGHT-MANACLE ,FL-OPEN>
					<TELL "right hand is">
				)
				(T
					<TELL "hands are">
				)
			>
			<TELL " manacled to the arms of the throne.">
			<COND
				(<IN? ,TH-GOLD-KEY ,CH-DEMON>
					<TELL " A golden key hangs around his neck.">
				)
			>
			<TELL " He leers at you through his obscene red eyes." CR>
		)
		(<VERB? KISS>
			<TELL "Ugh.|">
			<RT-AUTHOR-MSG "You're even sicker than I thought.">
		)
		(<VERB? RELEASE>
			<COND
				(<IN? ,TH-GOLD-KEY ,WINNER>
					<RT-FREE-DEMON-MSG>
				)
				(T
					<SETG CLOCK-WAIT T>
					<RT-AUTHOR-MSG ,K-HOW-INTEND-MSG>
				)
			>
		)
	>
>

<CONSTANT K-DEMON-SCREAMS-MSG
"The word comes at you in a explosion of incredible force that blasts you
out of the hall, through the outer rooms, and dumps you on the ledge next to
the slumbering dragon.">

<ROUTINE RT-DEMON-OFFER-MSG ("OPT" (KEY? <>))
	<COND
		(<FSET? ,CH-DEMON ,FL-LOCKED>
			<FCLEAR ,CH-DEMON ,FL-LOCKED>
			<COND
				(<IN? ,TH-GOLD-KEY ,CH-GIRL>
					<MOVE ,TH-GOLD-KEY ,CH-DEMON>
				)
			>
			<REMOVE ,CH-GIRL>
			<TELL
"The girl's shimmering features dissolve into those of a hideously ugly demon
who leers at you through obscene, red eyes. "
			>
			<SETG GL-PICTURE-NUM ,K-PIC-DEMON>
			<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
					<RT-UPDATE-DESC-WINDOW>
				)
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<COND
				(<FSET? ,LG-HOT-DOOR ,FL-OPEN>
					<FCLEAR ,LG-HOT-DOOR ,FL-OPEN>
					<TELL
The ,LG-HOT-DOOR " slams shut behind you with an ominous \"clank.\" "
					>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>
							<RT-UPDATE-MAP-WINDOW>
						)
					>
				)
			>
			<TELL "\"So, Arthur, you ">
			<COND
				(.KEY?
					<TELL
"really didn't think I'd let you leave with that key, did you?"
					>
				)
				(T
					<TELL "have seen through my little disguise.">
				)
			>
			<TELL
" But as I am feeling generous, I shall make you a bargain. We each have
something the other wants. I have" the ,TH-FLEECE ", without which you cannot
claim your kingdom. You have the power to free me. I propose a
trade.\"||\"Heed closely the words of my offer, for I will fulfill them to
the letter. If you agree to unlock my "
			>
			<COND
				(<OR	<FSET? ,TH-LEFT-MANACLE ,FL-OPEN>
						<FSET? ,TH-RIGHT-MANACLE ,FL-OPEN>
					>
					<TELL "other manacle">
				)
				(T
					<TELL "manacles">
				)
			>
			<TELL
", I will give you" the ,TH-FLEECE " and allow you to finish your quest
unmolested.\"||\"Remember. If you agree, we will each be bound to the terms
of the contract. If you accept my offer, and then fail to honour the contract
to the letter, you will die a horribly painful death.\"||\"Do you accept my
offer?\"|"
			>
		)
		(T
			<TELL
"|The demon says, \"I see that you have returned. Do you accept my offer?\"|"
			>
		)
	>
	<COND
		(<YES? T>
			<MOVE ,TH-FLEECE ,HERE>
			<FCLEAR ,TH-FLEECE ,FL-NO-DESC>
			<TELL
"The demon smiles with pleasure. He allows the fleece to slide onto"
the ,TH-GROUND ". \"Proceed, then.\"|"
			>
			<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
					<RT-UPDATE-DESC-WINDOW>
				)
			>
		)
		(T
			<TELL
"The demon's face contorts in fury and he screams maniacally, \"Then
BEGONE!\" " ,K-DEMON-SCREAMS-MSG CR CR
			>
			<COND
				(<IN? ,TH-GOLD-KEY ,CH-PLAYER>
					<MOVE ,TH-GOLD-KEY ,RM-DEMON-HALL>
				)
			>
			<REPEAT ((OBJ <FIRST? ,RM-DEMON-HALL>) NXT)
				<COND
					(<NOT .OBJ>
						<RETURN>
					)
					(T
						<SET NXT <NEXT? .OBJ>>
						<COND
							(<NOT <EQUAL? .OBJ ,TH-DEMON-THRONE ,CH-PLAYER>>
								<MOVE .OBJ ,RM-LEDGE>
							)
						>
						<SET OBJ .NXT>
					)
				>
			>
			<RT-GOTO ,RM-LEDGE T>
		)
	>
	<RTRUE>
>

<ROUTINE RT-FREE-DEMON-MSG ("OPT" (DEMON? <>))
	<COND
		(.DEMON?
			<COND
				(<FSET? ,CH-DEMON ,FL-LOCKED>
					<TELL The ,CH-GIRL>
				)
				(T
					<TELL The ,CH-DEMON>
				)
			>
			<TELL " takes the key and unlocks the other manacle. ">
		)
	>
	<COND
		(<NOT <IN? ,TH-FLEECE ,TH-DEMON-THRONE>>
			<COND
				(.DEMON?
					<TELL "He">
				)
				(T
					<TELL "The demon">
				)
			>
			<TELL
" rises up and screams with crazed, triumphant laughter, \"Keep the fleece,
you fool! Finish your ridiculous quest if you like. It will do you no good.
For now I shall finally defeat those so-called gods of righteousness and
their feeble prophet, Merlin.\"||The demon suddenly dissolves into a cloud of
grey smoke and streams out of the hall, leaving behind only the echo of his
maniacal laughter. You are free to go, but when you realize the enormity of
the evil you have unleashed on the world, you collapse to the floor, bereft
of the will to move.|"
			>
		)
		(T
			<TELL "As soon as the manacles are open, the ">
			<COND
				(<FSET? ,CH-DEMON ,FL-LOCKED>
					<TELL
"girl's features dissolve into those of a hideously evil demon who"
					>
				)
				(T
					<TELL "demon">
				)
			>
			<TELL
" rises up and rubs his wrists, saying, \"Free at last!.\" He stretches and
then glances down, as if surprised to still see you there. \"Ah yes!\" he
cackles, \"There is that small matter of the promise I made you. Let me see -
I said I would keep you by my side for evermore. Well, I always keep my
word.\" He laughs and points at you. Electricity crackles from his fingertips
and suddenly you find yourself stretched out on the floor next to him, in the
form of a dog.|"
			>
		)
	>
	<RT-END-OF-GAME>
>

;"---------------------------------------------------------------------------"
; "TH-GOLD-KEY"
;"---------------------------------------------------------------------------"

<OBJECT TH-GOLD-KEY
	(LOC CH-GIRL)
	(DESC "gold key")
	(FLAGS FL-NO-DESC FL-KEY FL-TAKEABLE FL-WORN)
	(SYNONYM KEY)
	(ADJECTIVE GOLD GOLDEN)
	(SIZE 1)
	(GENERIC RT-GN-KEY)
	(ACTION RT-TH-GOLD-KEY)
>

<ROUTINE RT-TH-GOLD-KEY ("OPT" (CONTEXT <>) "AUX" L)
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<AND <VERB? TAKE>
				<EQUAL? <SET L <LOC ,TH-GOLD-KEY>> ,CH-DEMON ,CH-GIRL>
			>
			<COND
				(<RT-DO-TAKE ,TH-GOLD-KEY>
					<THIS-IS-IT ,TH-GOLD-KEY>
					<TELL "You remove the key from" the .L "'s neck." CR>
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
; "TH-LEFT-MANACLE"
; "TH-RIGHT-MANACLE"
;"---------------------------------------------------------------------------"

<OBJECT TH-LEFT-MANACLE
   (LOC TH-DEMON-THRONE)
	(DESC "left manacle")
   (FLAGS FL-LOCKED FL-NO-DESC FL-OPENABLE)
   (SYNONYM MANACLE)
   (ADJECTIVE LEFT GOLD GOLDEN)
   (ACTION RT-TH-MANACLE)
>

; "TH-LEFT-MANACLE flags:"
; "	FL-BROKEN - Manacle has been opened and closed again."

<OBJECT TH-RIGHT-MANACLE
   (LOC TH-DEMON-THRONE)
   (DESC "right manacle")
   (FLAGS FL-LOCKED FL-NO-DESC FL-OPENABLE)
   (SYNONYM MANACLE)
   (ADJECTIVE RIGHT GOLD GOLDEN)
   (ACTION RT-TH-MANACLE)
>

; "TH-RIGHT-MANACLE flags:"
; "	FL-BROKEN - Manacle has been opened and closed again."

<ROUTINE RT-TH-MANACLE ("OPT" (CONTEXT <>) "AUX" OTHER)
	<COND
		(<MC-PRSO? ,TH-LEFT-MANACLE>
			<SET OTHER ,TH-RIGHT-MANACLE>
		)
		(T
			<SET OTHER ,TH-LEFT-MANACLE>
		)
	>
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? OPEN UNLOCK>
			<COND
				(<AND <MC-PRSI? <> ,TH-GOLD-KEY>
						<IN? ,TH-GOLD-KEY ,WINNER>
					>
					<COND
						(<FSET? ,PRSO ,FL-OPEN>
							<RT-ALREADY-MSG ,PRSO "open">
						)
						(<FSET? .OTHER ,FL-OPEN>
							<RT-FREE-DEMON-MSG>
						)
						(T
							<FCLEAR ,PRSO ,FL-LOCKED>
							<FSET ,PRSO ,FL-OPEN>
							<COND
								(<AND <NOT <FSET? ,CH-DEMON ,FL-LOCKED>>
										<FSET? .OTHER ,FL-BROKEN>
									>
									<FSET ,CH-DEMON ,FL-BROKEN>
									<REMOVE ,TH-GHOSTS>
									<TELL
"You open" the ,PRSO ". The demon catches on to your plan and screams at you
in fury. \"Trapped! Trapped by my own words. You have won this round, Arthur,
but the final victory shall yet be mine, for I now lay a triple curse upon
your head.\"||\"You may gain the throne of England, but you shall gain no
solace from it. Your wife shall be barren, you shall be betrayed by your best
friend, and you shall die at the hand of your own son. Thus have I thrice
cursed you.\"||\"Now BEGONE!\""
									>
									<COND
										(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
											<CRLF>
											<INPUT 1 300 ,RT-STOP-READ>
											<SCREEN 7>
											<CLEAR 7>
											<RT-CENTER-PIC ,K-PIC-ANGRY-DEMON>
											<CURSET -1>	;"Make cursor go away."
											<INPUT 1 100 ,RT-STOP-READ>
											<CURSET -2>	;"Make cursor come back."
											<SCREEN 0>
											; "This is done so that the refresh doesn't
												show the picture of the demon again."
											<SETG GL-PICTURE-NUM ,K-PIC-DRAGON-OUT>
											<V-REFRESH <>>
										)
										(T
											<TELL " ">
										)
									>
									<TELL
,K-DEMON-SCREAMS-MSG " The force of the blast dislodges the stones on the
mountainside above the cave entrance, and they fall down and seal off the
mouth of the cave.||"
									>
									<REPEAT ((OBJ <FIRST? ,RM-DEMON-HALL>) NXT)
										<COND
											(<NOT .OBJ>
												<RETURN>
											)
											(T
												<SET NXT <NEXT? .OBJ>>
												<COND
													(<NOT <EQUAL? .OBJ ,TH-DEMON-THRONE ,CH-PLAYER>>
														<MOVE .OBJ ,RM-LEDGE>
													)
												>
												<SET OBJ .NXT>
											)
										>
									>
									<RT-GOTO ,RM-LEDGE T>
									<RT-SCORE-MSG 0 7 10 5>
								)
								(T
									<TELL "You open" the ,PRSO ". The ">
									<COND
										(<FSET? ,CH-DEMON ,FL-LOCKED>
											<TELL "girl">
										)
										(T
											<TELL "demon">
										)
									>
									<TELL " smiles.|">
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
					>
				)
			>
		)
		(<VERB? CLOSE LOCK>
			<COND
				(<AND <MC-PRSI? <> ,TH-GOLD-KEY>
						<IN? ,TH-GOLD-KEY ,WINNER>
					>
					<COND
						(<NOT <FSET? ,PRSO ,FL-OPEN>>
							<RT-ALREADY-MSG ,PRSO "closed">
						)
						(T
							<FCLEAR ,PRSO ,FL-OPEN>
							<FSET ,PRSO ,FL-LOCKED>
							<COND
								(<NOT <FSET? ,CH-DEMON ,FL-LOCKED>>
									<FSET ,PRSO ,FL-BROKEN>
								)
							>
							<TELL
"You snap" the ,PRSO " shut. The smile vanishes from the "
							>
							<COND
								(<FSET? ,CH-DEMON ,FL-LOCKED>
									<TELL "girl">
								)
								(T
									<TELL "demon">
								)
							>
							<TELL "'s face.|">
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
			>
		)
		(<VERB? EXAMINE>
			<FSET ,PRSO ,FL-SEEN>
			<TELL The ,PRSO " is made of pure gold and is" open ,PRSO "." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-MANACLES"
;"---------------------------------------------------------------------------"

<OBJECT TH-MANACLES
	(LOC TH-DEMON-THRONE)
	(DESC "manacles")
	(FLAGS FL-LOCKED FL-NO-DESC FL-OPENABLE FL-PLURAL)
	(SYNONYM MANACLES)
   (ADJECTIVE GOLD GOLDEN)
	(ACTION RT-TH-MANACLES)
>

<ROUTINE RT-TH-MANACLES ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-MANACLES ,FL-SEEN>
			<FSET ,TH-LEFT-MANACLE ,FL-SEEN>
			<FSET ,TH-RIGHT-MANACLE ,FL-SEEN>
			<TELL The+verb ,TH-MANACLES "are" " made of pure gold.">
			<COND
				(<FSET? ,TH-LEFT-MANACLE ,FL-OPEN>
					<THIS-IS-IT ,TH-LEFT-MANACLE>
					<TELL " The left one is open.">
				)
				(<FSET? ,TH-RIGHT-MANACLE ,FL-OPEN>
					<THIS-IS-IT ,TH-RIGHT-MANACLE>
					<TELL " The right one is open.">
				)
			>
			<CRLF>
		)
		(<VERB? OPEN UNLOCK>
			<COND
				(<AND <MC-PRSI? <> ,TH-GOLD-KEY>
						<IN? ,TH-GOLD-KEY ,WINNER>
					>
					<RT-FREE-DEMON-MSG>
				)
				(T
					<SETG CLOCK-WAIT T>
					<RT-AUTHOR-MSG ,K-HOW-INTEND-MSG>
				)
			>
		)
		(<VERB? CLOSE LOCK>
; "The following is based on the assumption that both manacles can't be open
	at the same time."
			<COND
				(<FSET? ,TH-LEFT-MANACLE ,FL-OPEN>
					<RT-ALREADY-MSG ,TH-RIGHT-MANACLE "closed">
				)
				(<FSET? ,TH-RIGHT-MANACLE ,FL-OPEN>
					<RT-ALREADY-MSG ,TH-LEFT-MANACLE "closed">
				)
				(T
					<RT-ALREADY-MSG ,TH-MANACLES "closed">
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-FLEECE"
;"---------------------------------------------------------------------------"

<OBJECT TH-FLEECE
	(LOC TH-DEMON-THRONE)
	(DESC "Golden Fleece")
	(FLAGS FL-BURNABLE FL-NO-DESC FL-TAKEABLE)
	(SYNONYM FLEECE)
	(ADJECTIVE GOLD GOLDEN)
	(SCORE <ORB <LSH 2 ,K-WISD-SHIFT> <LSH 1 ,K-QUEST-SHIFT>>)
	(SIZE 5)
	(ACTION RT-TH-FLEECE)
>

<ROUTINE RT-TH-FLEECE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<AND <VERB? TAKE>
				<IN? ,TH-FLEECE ,TH-DEMON-THRONE>
				<FSET? ,CH-DEMON ,FL-LOCKED>
			>
			<TELL
"The girl looks at you with a tear in her eye. \"If you would only free me,\"
she pleads, \"the fleece shall be yours.\"" CR
			>
		)
		(<VERB? EXAMINE>
			<TELL "The legendary fleece shimmers with a golden glow." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-DEMON-THRONE"
;"---------------------------------------------------------------------------"

<OBJECT TH-DEMON-THRONE
	(LOC RM-DEMON-HALL)
	(DESC "throne")
	(FLAGS FL-NO-DESC FL-SEARCH FL-SURFACE)
	(ADJECTIVE GOLD GOLDEN)
	(SYNONYM THRONE CHAIR ARM ARMS)
	(ACTION RT-TH-DEMON-THRONE)
>

<ROUTINE RT-TH-DEMON-THRONE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-DEMON-THRONE ,FL-SEEN>
			<TELL "It's a throne with">
			<COND
				(<FSET? ,CH-DEMON ,FL-LOCKED>
					<TELL a ,CH-GIRL>
				)
				(T
					<TELL a ,CH-DEMON>
				)
			>
			<TELL " manacled to it." CR>
		)
	>
>

<CONSTANT K-DEMON-DOMAIN-TBL
	<TABLE (PURE BYTE LENGTH)
		RM-EAST-OF-FORD
		RM-FOOT-OF-MOUNTAIN
		RM-LEDGE
		RM-CAVE
		RM-ICE-ROOM
		RM-BAS-LAIR
		RM-HOT-ROOM
		RM-DEMON-HALL
	>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

