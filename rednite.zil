;"***************************************************************************"
; "game : Arthur"
; "file : REDNITE.ZIL"
; "auth :   $Author:   RAB  $"
; "date :     $Date:   15 May 1989 17:29:56  $"
; "revs : $Revision:   1.62  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Red Knight Puzzle"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "RM-END-OF-CAUSEWAY"
;"---------------------------------------------------------------------------"

<ROOM RM-END-OF-CAUSEWAY
	(LOC ROOMS)
	(DESC "end of causeway")
	(FLAGS FL-LIGHTED)
	(WEST TO RM-FIELD-OF-HONOUR)
	(SOUTH PER RT-RED-KNIGHT-GIFTS)
	(UP PER RT-FLY-UP)
	(GLOBAL LG-LAKE RM-ISLAND RM-CAUSEWAY RM-FIELD-OF-HONOUR)
	(ACTION RT-RM-END-OF-CAUSEWAY)
>

<CONSTANT K-RAVEN-EGG-MSG " the egg of a giant raven">
<CONSTANT K-DRAGON-HAIR-MSG " the hair that grows between the eyes of a dragon">
<CONSTANT K-BOAR-TUSK-MSG " the tusk of the wild boar that stalks the enchanted forest">
<CONSTANT K-GOLDEN-FLEECE-MSG " the golden fleece of the evil demon Nudd">

<ROUTINE RT-RM-END-OF-CAUSEWAY ("OPT" (CONTEXT <>) "AUX" N)
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,CH-RED-KNIGHT ,FL-SEEN>
			<FSET ,LG-LAKE ,FL-SEEN>
			<FSET ,RM-ISLAND ,FL-SEEN>
			<FSET ,RM-FIELD-OF-HONOUR ,FL-SEEN>
			<TELL
"You are at the end of a causeway which is guarded by" a ,CH-RED-KNIGHT
". The causeway leads south across the lake to an island. The Field of Honour
lies to the west.|"
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-RED-KNIGHT>
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
					<RFALSE>
				)
				(<EQUAL? ,GL-GIFT-COUNT 255>
					<SETG GL-GIFT-COUNT 0>
					<TELL CR The ,CH-RED-KNIGHT " stands ">
					<COND
						(<EQUAL? ,OHERE ,RM-FIELD-OF-HONOUR>
							<TELL
"at attention before you, staring off into the distance. He acknowleges
your presence enough to say,"
							>
						)
						(T
							<TELL
"at attention with his back to you. Suddenly he looks around and says, \"How
did you get there? ... No matter.\" He eyes you warily and continues,"
							>
						)
					>
					<TELL
" \"You shall get no further unless you bring me" ,K-RAVEN-EGG-MSG ","
,K-DRAGON-HAIR-MSG "," ,K-BOAR-TUSK-MSG ", and" ,K-GOLDEN-FLEECE-MSG ".\"" CR
					>
				)
				(<EQUAL? ,GL-GIFT-COUNT 4>
					<TELL
CR The ,CH-RED-KNIGHT " acknowledges your arrival with a polite nod and
indicates that you are free to pass by." CR
					>
				)
				(T
					<TELL
"|The knight removes his stare from the horizon long enough to say, "
					>
					<RT-RED-GIFTS-MSG>
				)
			>
		)
		(<MC-CONTEXT? ,M-END>
			<COND
				(<AND <VERB? TRANSFORM>
						<NOT <MC-FORM? ,GL-OLD-FORM>>
					>
					<TELL
CR The ,CH-RED-KNIGHT " cries, \"Sorcery! Work of the Devil!!\" He kills
you instantly." ,K-HEEDED-WARNING-MSG
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

<GLOBAL GL-GIFT-COUNT 255 <> BYTE>

<ROUTINE RT-RED-GIFTS-MSG ("AUX" N)
	<TELL "\"You ">
	<COND
		(<G? ,GL-GIFT-COUNT 0>
			<TELL "have given me">
			<REPEAT ((OBJ <FIRST? ,CH-RED-KNIGHT>) (1ST? T) NXT)
				<COND
					(<NOT .OBJ>
						<RETURN>
					)
					(T
						<SET NXT <NEXT? .OBJ>>
						<COND
							(.1ST?
								<SET 1ST? <>>
							)
							(T
								<TELL comma .NXT>
							)
						>
						<TELL the .OBJ>
					)
				>
				<SET OBJ .NXT>
			>
			<TELL " but you ">
		)
	>
	<TELL "still may not pass until you have given me">
	<SET N 0>
	<COND
		(<NOT <IN? ,TH-RAVEN-EGG ,CH-RED-KNIGHT>>
			<INC N>
			<TELL ,K-RAVEN-EGG-MSG>
		)
	>
	<COND
		(<NOT <IN? ,TH-DRAGON-HAIR ,CH-RED-KNIGHT>>
			<INC N>
			<COND
				(<G? .N 1>
					<TELL comma <L? <+ .N ,GL-GIFT-COUNT> 4>>
				)
			>
			<TELL ,K-DRAGON-HAIR-MSG>
		)
	>
	<COND
		(<NOT <IN? ,TH-TUSK ,CH-RED-KNIGHT>>
			<INC N>
			<COND
				(<G? .N 1>
					<TELL comma <L? <+ .N ,GL-GIFT-COUNT> 4>>
				)
			>
			<TELL ,K-BOAR-TUSK-MSG>
		)
	>
	<COND
		(<NOT <IN? ,TH-FLEECE ,CH-RED-KNIGHT>>
			<INC N>
			<COND
				(<G? .N 1>
					<TELL comma <L? <+ .N ,GL-GIFT-COUNT> 4>>
				)
			>
			<TELL ,K-GOLDEN-FLEECE-MSG>
		)
	>
	<TELL ".\"" CR>
>

;"---------------------------------------------------------------------------"
; "CH-RED-KNIGHT"
;"---------------------------------------------------------------------------"

<OBJECT CH-RED-KNIGHT
	(LOC RM-END-OF-CAUSEWAY)
	(DESC "red knight")
	(FLAGS FL-ALIVE FL-PERSON FL-NO-DESC FL-SEARCH FL-OPEN FL-TRYTAKE)
	(SYNONYM KNIGHT PERSON MAN ARMOUR ARMOR)
	(ADJECTIVE RED)
	(ACTION RT-CH-RED-KNIGHT)
	(CONTFCN RT-CH-RED-KNIGHT)
	(GENERIC RT-GN-ARMOUR)
>

<ROUTINE RT-CH-RED-KNIGHT ("OPT" (CONTEXT <>) "AUX" (NL? T))
	<COND
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
The+verb ,CH-RED-KNIGHT "continue" " to stare straight ahead, ignoring your
presence." CR
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-CONT>
			<COND
				(<VERB? ASK-FOR>
					<TELL
The+verb ,CH-RED-KNIGHT "steal" " a quick glance at you. \"It's very good of
you to ask. The answer is no.\"" CR
					>
				)
				(<AND <VERB? ASK-ABOUT>
						<NOT ,NOW-PRSI>
					>
					<TELL
The ,CH-RED-KNIGHT " nods imperceptibly and says out of the side of his
mouth, \"Yes, I have it. Thank you very much.\"" CR
					>
				)
				(<VERB? TRADE-FOR>
					<TELL
The ,CH-RED-KNIGHT " refuses your offer, saying, \"I'm sorry. No
substitutions.\"" CR
					>
				)
				(<TOUCH-VERB?>
					<TELL
The ,CH-RED-KNIGHT " moves" the ,PRSO " beyond your grasp and cuffs you on
the head, saying, \"It's not polite to take things without asking.\"" CR
					>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<COND
				(<VERB? GIVE SHOW>
					<COND
						(<EQUAL? ,PRSO
								,TH-RAVEN-EGG
								,TH-DRAGON-HAIR
								,TH-TUSK
								,TH-FLEECE
							>
							<MOVE ,PRSO ,CH-RED-KNIGHT>
							<FSET ,PRSO ,FL-TRY-TAKE>
							<FSET ,PRSO ,FL-NO-DESC>
							<SETG GL-GIFT-COUNT <+ ,GL-GIFT-COUNT 1>>
							<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT>>
							<TELL The ,CH-RED-KNIGHT " takes" the ,PRSO>
							<COND
								(<EQUAL? ,GL-GIFT-COUNT 1>
									<TELL
" and says, \"Now this is a very nice start. But I must have the other items
to let you by.\""
									>
								)
								(<EQUAL? ,GL-GIFT-COUNT 2>
									<TELL
", looks at you with delight and says, \"Well done. These aren't easy to come
by.\""
									>
								)
								(<EQUAL? ,GL-GIFT-COUNT 3>
									<TELL
" and says, \"You have been busy, haven't you. Still, there is that one other
item I mentioned.\""
									>
								)
								(<EQUAL? ,GL-GIFT-COUNT 4>
									<TELL
" and looks at you with new-found respect. \"Appearances deceive,\" he says.
\"The one who has done these things must be more than a mere boy.\" He steps
aside to let you pass."
									>
								)
							>
							<COND
								(<G? ,P-MULT 1>
									<TELL " ">
									<SET NL? <>>
								)
								(T
									<CRLF>
								)
							>
							<RT-SCORE-MSG 0 0 0 1 .NL?>
							<COND
								(<G? ,P-MULT 1>
									<CRLF>
								)
							>
						)
						(<EQUAL? ,PRSO ,TH-BRASS-EGG>
							<TELL
The ,CH-RED-KNIGHT " refuses your offer, saying, \"This imitation might take
in a giant raven, but it would never fool me.\"" CR
							>
						)
						(T
							<TELL
The ,CH-RED-KNIGHT " refuses your offer, saying, \"I'm sorry. No substitutions.\"" CR
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
		(<VERB? ASK-ABOUT>
			<COND
				(<MC-PRSI? ,TH-RAVEN-EGG ,CH-RAVEN>
					<TELL
"\"The giant raven nests deep within the enchanted forest. It cannot be
killed, but if I have the egg, I can lessen its evil.\"" CR
					>
				)
				(<MC-PRSI? ,TH-DRAGON-HAIR ,CH-DRAGON>
					<TELL
"\"The dragon guards the entrance to the demon's mountain.\"" CR
					>
				)
				(<MC-PRSI? ,TH-TUSK ,TH-BOAR>
					<TELL
"\"The boar roams the enchanted forest, making it unsafe for all who dwell
there.\"" CR
					>
				)
				(<MC-PRSI? ,TH-FLEECE>
					<TELL
"\"It was stolen by an evil demon who lets no one come near it.\"" CR
					>
				)
				(<MC-PRSI? ,TH-BRASS-EGG>
					<TELL
"He glances around quickly to see if anyone is looking, and then he
lowers his voice and says, \"It looks like the kind of the trash the
invisible knight deals in. Why they don't put that guy out of business
is beyond me.\"" CR
					>
				)
				(<MC-PRSI? ,CH-RED-KNIGHT>
					<TELL
"\"I stand here night and day. Anyone who would pass by me must prove his
worth by helping rid the countryside of the evils that beset it.\"" CR
					>
				)
				(<MC-PRSI? ,CH-MERLIN>
					<TELL "\"Like myself, he seeks to rid the land of evil.\"" CR>
				)
				(<MC-PRSI? ,CH-DEMON>
					<TELL
"\"He is evil incarnate. I shall never rest until he is slain.\"" CR
					>
				)
				(<MC-PRSI? ,CH-LOT>
					<TELL
"\"Let him come here himself and he will find out soon enough what I think of
him.\"" CR
					>
				)
				(<MC-PRSI? ,CH-PLAYER>
					<TELL
"\"I know nothing about you. Yet there is something in your manner that
tells me you will succeed in your quest.\"" CR
					>
				)
				(<MC-PRSI? ,TH-MASTER>
					<TELL "\"I answer only to the gods.\"" CR>
				)
				(<MC-PRSI? ,TH-EXCALIBUR>
					<TELL
"\"With such a sword, a brave and true knight could rid the land of all
evil.\"" CR
					>
				)
				(T
					<TELL
"\"I'm sorry. I am not at liberty to reveal anything about" him ,PRSI ".\"" CR
					>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,CH-RED-KNIGHT ,FL-SEEN>
			<COND
				(<NOUN-USED? ,CH-RED-KNIGHT ,W?ARMOUR ,W?ARMOR>
					<TELL
"It's bright red, symbolizing the knight's magnanimity and fortitude." CR
					>
				)
				(T
					<TELL
"He stands stiffly at attention and stares straight ahead. His uniform is
bright red armour." CR
					>
				)
			>
		)
		(<VERB? ASK-FOR>
			<TELL
The ,CH-RED-KNIGHT " responds, \"I do not have" him ,PRSI ".\"" CR
			>
		)
		(<VERB? ATTACK>
			<COND
				(<OR	<NOT <MC-FORM? ,K-FORM-ARTHUR>>
						<EQUAL? ,GL-GIFT-COUNT 4>
					>
					<TELL
The ,CH-RED-KNIGHT " sidesteps your attack and looks at you in surprise." CR
					>
				)
				(T
					<TELL
The ,CH-RED-KNIGHT " easily fends you off and says, \"No need to get
violent, young fella. Just bring me the items I have asked for and you'll
find me willing enough to let you by.\"" CR
					>
				)
			>
		)
		(<VERB? POLISH>
			<TELL
"You give the knight a quick spit-shine. He says, \"Thanks, kid. I'd give
you a dime, but they haven't been invented yet. Take this instead.\" He
cuffs you on the side of the head." CR
			>
		)
		(<VERB? HELLO GOODBYE>
			<TELL
The+verb ,CH-RED-KNIGHT "continue" " to stare straight ahead, ignoring your
presence." CR
			>
		)
		(<AND <VERB? TAKE>
				<NOUN-USED? ,CH-RED-KNIGHT ,W?ARMOUR ,W?ARMOR>
			>
			<TELL
The+verb ,CH-RED-KNIGHT "cuff" " you on the side of the head and says, \"This
is my armour. "
			>
			<COND
				(<NOT <IN? ,TH-ARMOUR ,CH-PLAYER>>
					<TELL "Go find some of your own">
				)
				(T
					<TELL "Hands off"> 
				)
			>
			<TELL ".\"" CR>
		)
		(<VERB? CHALLENGE>
			<TELL
"\"You can challenge me all you like, lad. But you're still not getting
past until you've brought me the items I mentioned.\"" CR
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RT-RED-KNIGHT-GIFTS"
;"---------------------------------------------------------------------------"

<ROUTINE RT-RED-KNIGHT-GIFTS ("OPT" (QUIET <>))
	<COND
		(<OR	.QUIET
				<NOT <MC-FORM? ,K-FORM-ARTHUR>>
			>
			<RETURN ,RM-CAUSEWAY>
		)
		(<EQUAL? ,GL-GIFT-COUNT 4>
			<TELL The ,CH-RED-KNIGHT " steps aside to let you pass.||">
			<RETURN ,RM-CAUSEWAY>
		)
		(T
			<TELL The ,CH-RED-KNIGHT " blocks your path and says, ">
			<RT-RED-GIFTS-MSG>
			<RFALSE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-CAUSEWAY"
;"---------------------------------------------------------------------------"

<ROOM RM-CAUSEWAY
	(LOC ROOMS)
	(DESC "causeway")
	(FLAGS FL-LIGHTED)
	(SYNONYM CAUSEWAY)
	(EAST PER RT-YOU-WOULD-DROWN)
	(WEST PER RT-YOU-WOULD-DROWN)
	(NORTH TO RM-END-OF-CAUSEWAY)
	(SOUTH TO RM-ISLAND)
	(UP PER RT-FLY-UP)
	(DOWN PER RT-YOU-WOULD-DROWN)
	(GLOBAL RM-ISLAND)
	(ACTION RT-RM-CAUSEWAY)
	(THINGS <> (ROCK ROCKS) RT-PS-ROCKS)
>

<ROUTINE RT-RM-CAUSEWAY ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<FSET ,RM-ISLAND ,FL-SEEN>
					<TELL
"You are" standing " on a causeway that leads from the mainland south to the island."
					>
				)
				(<EQUAL? ,OHERE ,RM-END-OF-CAUSEWAY>
					<FSET ,RM-ISLAND ,FL-SEEN>
					<TELL
"You" walk " past the knight onto the causeway that leads south to the island."
					>
				)
				(<EQUAL? ,OHERE ,RM-ISLAND>
					<TELL
"You step onto the causeway that leads north to the mainland."
					>
				)
				(T
					<TELL
"You land on the causeway that leads south to the island, and north to the
mainland."
					>
				)
			>
			<CRLF>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-CAUSEWAY>
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
; "RT-YOU-WOULD-DROWN"
;"---------------------------------------------------------------------------"

<ROUTINE RT-YOU-WOULD-DROWN ("OPT" (QUIET <>))
	<COND
		(<NOT .QUIET>
			<TELL
"If you went that way, you would drown." CR
			>
		)
	>
	<RFALSE>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

