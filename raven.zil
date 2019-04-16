;"***************************************************************************"
; "game : Arthur"
; "file : RAVEN.ZIL"
; "auth :   $Author:   RAB  $"
; "date :     $Date:   15 May 1989 18:50:48  $"
; "revs : $Revision:   1.80  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Giant Raven Puzzle"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

<CONSTANT K-CLIMB-UP 1>
<CONSTANT K-CLIMB-DN 0>

<CONSTANT K-RAVEN-TREE-MAX 6>
<CONSTANT K-RAVEN-TREE-HALF </ ,K-RAVEN-TREE-MAX 2>>

<GLOBAL GL-RAV-P-CNT 0 <> BYTE>

;"***************************************************************************"
; "SUPPORT ROUTINES - NEEDED BUT WITH SILLY PARTS"
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "RT-RAV-CANT-CLIMB-UP"
;"---------------------------------------------------------------------------"

<ROUTINE RT-RAV-CANT-CLIMB-UP ()
	<COND
		(<MC-FORM? ,K-FORM-ARTHUR>
			<TELL
"You can't climb the tree. There are no branches near the ground." CR
			>
		)
		(<MC-FORM? ,K-FORM-BADGER>
			<TELL "Your claws were designed for digging, not climbing." CR>
		)
		(<MC-FORM? ,K-FORM-TURTLE>
			<TELL "Turtles can't climb trees." CR>
		)
	>
>

;"***************************************************************************"
; "SUPPORT ROUTINES - SERIOUS"
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "RT-RAV-CLIMBING"
;"---------------------------------------------------------------------------"

<ROUTINE RT-RAV-CLIMBING (UD-FLAG)
	<TELL "You continue to climb ">
	<COND
		(<EQUAL? .UD-FLAG ,K-CLIMB-UP>
			<TELL "up">
		)
		(T
			<TELL "down">
		)
	>
	<TELL " the tree. It looks like a long way ">
	<COND
		(<EQUAL? .UD-FLAG ,K-CLIMB-UP>
			<COND
				(<L=? ,GL-RAV-P-CNT ,K-RAVEN-TREE-HALF>
					<TELL "up">
				)
				(T
					<TELL "back down">
				)
			>
		)
		(T
			<COND
				(<L=? ,GL-RAV-P-CNT ,K-RAVEN-TREE-HALF>
					<TELL "back up">
				)
				(T
					<TELL "down">
				)
			>
		)
	>
	<TELL "." CR>
>

;"---------------------------------------------------------------------------"
; "RT-FALL-OFF-TREE"
;"---------------------------------------------------------------------------"

<ROUTINE RT-FALL-OFF-TREE ()
	<TELL
"|You lose your grip on" the ,RM-RAVEN-TREE " and fall to the ground. "
	>
	<COND
		(<L? ,GL-RAV-P-CNT 4>
			<MOVE ,CH-PLAYER ,RM-GROVE>
			<TELL "You are a bit bruised and battered but otherwise alright." CR>
		)
		(T
			<TELL "Too bad you were so far up. The fall was fatal.|">
			<RT-END-OF-GAME>
		)
	>
>

;"***************************************************************************"
; "OBJECTS & OBJECT ACTIONS"
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "TH-RAVEN-EGG"
;"---------------------------------------------------------------------------"

<OBJECT TH-RAVEN-EGG
	(LOC RM-RAVEN-NEST)
	(DESC "gold egg")
	(FLAGS FL-TAKEABLE)
	(SYNONYM EGG)
	(ADJECTIVE GIANT GOLD GOLDEN RAVEN)
	(OWNER CH-RAVEN)
	(SCORE 0)
	(SIZE 15)
	(GENERIC RT-GN-EGG)
	(ACTION RT-TH-RAVEN-EGG)
>

; "TH-RAVEN-EGG flags:"
; "	FL-BROKEN - Player has received points for taking egg from grove"

<ROUTINE RT-TH-RAVEN-EGG ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-RAVEN-EGG ,FL-SEEN>
			<TELL "It is a huge hunk of gold in the shape of a perfect egg." CR>
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
	>
>

;"***************************************************************************"
; "CHARACTERS & CHARACTER ACTIONS"
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "CH-RAVEN"
;"---------------------------------------------------------------------------"

<OBJECT CH-RAVEN
	(LOC RM-ABOVE-FOREST)
	(DESC "giant raven")
	(FLAGS FL-ALIVE FL-NO-DESC FL-OPEN FL-SEARCH)
	(SYNONYM RAVEN BIRD)
	(ADJECTIVE GIANT BLACK)
	(GENERIC RT-GN-BIRD)
	(ACTION RT-CH-RAVEN)
	(CONTFCN RT-CH-RAVEN)
>

; "CH-RAVEN flags:"
; "	FL-BROKEN - Raven has returned one egg to the nest"
; "	FL-LOCKED - Raven is retrieving an egg"

<CONSTANT K-RAVEN-SQUAWKS-MSG "The giant raven squawks at you in response.">

<ROUTINE RT-CH-RAVEN ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-WINNER>
			<TELL ,K-RAVEN-SQUAWKS-MSG CR>
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
			<RFALSE>
		)
		(<AND <SPEAKING-VERB?>
				<IN? ,CH-RAVEN ,HERE>
			>
			<TELL ,K-RAVEN-SQUAWKS-MSG CR>
		)
		(<VERB? EXAMINE>
			<FSET ,CH-RAVEN ,FL-SEEN>
			<COND
				(<IN? ,CH-RAVEN ,HERE>
					<TELL
The ,CH-RAVEN " is a huge bird with a wingspan of around twenty feet. It has
a long, sharp beak and "
					>
					<COND
					; "Assumes the raven only carries one thing at a time."
						(<FIRST? ,CH-RAVEN>
							<TELL "is holding" the <FIRST? ,CH-RAVEN> " in its ">
						)
					>
					<TELL "huge talons." CR>
				)
				(<IN? ,CH-RAVEN ,RM-GROVE>
					<TELL
The ,CH-RAVEN " is below you in" the ,RM-GROVE "." CR
					>
				)
				(<IN? ,CH-RAVEN ,RM-RAVEN-NEST>
					<TELL
The ,CH-RAVEN " is in" the ,RM-RAVEN-NEST " at the top of" the ,RM-RAVEN-TREE "." CR
					>
				)
				(<IN? ,CH-RAVEN ,RM-ABOVE-FOREST>
					<COND
					; "Assumes the raven only carries one thing at a time."
						(<FIRST? ,CH-RAVEN>
							<TELL
The ,CH-RAVEN " is struggling to bring" the <FIRST? ,CH-RAVEN> " up to its nest." CR
							>
						)
						(T
							<TELL
The ,CH-RAVEN " is circling far above you in the sky." CR
							>
						)
					>
				)
			>
		)
		(<VERB? ATTACK>
			<COND
				(<AND <MC-HERE? ,RM-RAVEN-NEST>
						<IN? ,CH-RAVEN ,RM-RAVEN-NEST>
					>
					<TELL
The+verb ,WINNER "flail" " wildly at the raven, but" his ,WINNER " blows have
no effect." CR
					>
				)
				(T
					<TELL The ,CH-RAVEN " isn't close enough." CR>
				)
			>
		)
	>
>

<GLOBAL GL-RAVEN-OBJ:OBJECT <>>

<CONSTANT K-RAVEN-APPROACH-MSG "You hear the beat of approaching wings.">

<ROUTINE RT-I-RAV-GROVE-1 ()
	<COND
		(<OR	<NOT ,GL-RAVEN-OBJ>
				<NOT <IN? ,GL-RAVEN-OBJ ,RM-GROVE>>
			>
			<RFALSE>
		)
	>
	<FSET ,CH-RAVEN ,FL-LOCKED>	; "Raven on an egg mission."
	<RT-QUEUE ,RT-I-RAV-GROVE-2 <+ ,GL-MOVES 1>>
	<COND
		(<FSET? ,CH-PLAYER ,FL-ASLEEP>
			<RFALSE>
		)
		(<MC-HERE? ,RM-GROVE>
			<TELL CR ,K-RAVEN-APPROACH-MSG CR>
		)
		(<MC-HERE? ,RM-ABOVE-FOREST ,RM-RAVEN-TREE>
			<TELL
"|The glint catches the giant raven's eye and it swoops down towards"
the ,RM-GROVE "." CR
			>
			<COND
				(<MC-HERE? ,RM-ABOVE-FOREST>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
							<RT-UPDATE-DESC-WINDOW>
						)
					>
				)
			>
			<RTRUE>
		)
		(<MC-HERE? ,RM-RAVEN-NEST>
			<TELL
"|You see" the ,CH-RAVEN " swoop down towards" the ,RM-GROVE "." CR
			>
		)
	>
>

<CONSTANT K-RAVEN-SWOOP-MSG
"Suddenly a giant raven swoops down from the sky. ">

<ROUTINE RT-I-RAV-GROVE-2 ()
	<COND
		(<OR	<NOT ,GL-RAVEN-OBJ>
				<NOT <IN? ,GL-RAVEN-OBJ ,RM-GROVE>>
			>
			<FCLEAR ,CH-RAVEN ,FL-LOCKED>
			<COND
				(<FSET? ,CH-PLAYER ,FL-ASLEEP>
					<RFALSE>
				)
				(<MC-HERE? ,RM-GROVE>
					<TELL
CR ,K-RAVEN-SWOOP-MSG "It gets a very puzzled look on its face, and then
it flies back up out of sight." CR
					>
				)
			>
		)
		(T
			<RT-QUEUE ,RT-I-RAV-NEST-1 <+ ,GL-MOVES 2>>
			<MOVE ,GL-RAVEN-OBJ ,CH-RAVEN>
			<COND
				(<FSET? ,CH-PLAYER ,FL-ASLEEP>
					<RFALSE>
				)
				(<MC-HERE? ,RM-GROVE>
					<TELL
CR ,K-RAVEN-SWOOP-MSG "It clutches" the ,GL-RAVEN-OBJ " in its talons and,
struggling from the weight, flies up out of sight." CR
					>
				)
				(<MC-HERE? ,RM-ABOVE-FOREST ,RM-RAVEN-TREE>
					<TELL
CR The ,CH-RAVEN " takes" the ,GL-RAVEN-OBJ " and begins struggling upward." CR
					>
					<COND
						(<MC-HERE? ,RM-ABOVE-FOREST>
							<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
							<COND
								(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
									<RT-UPDATE-DESC-WINDOW>
								)
							>
						)
					>
					<RTRUE>
				)
			>
		)
	>
>

<ROUTINE RT-I-RAV-NEST-1 ()
	<RT-QUEUE ,RT-I-RAV-NEST-2 <+ ,GL-MOVES 1>>
	<COND
		(<FSET? ,CH-PLAYER ,FL-ASLEEP>
			<RFALSE>
		)
		(<MC-HERE? ,RM-RAVEN-NEST>
			<TELL CR ,K-RAVEN-APPROACH-MSG CR>
		)
		(<MC-HERE? ,RM-ABOVE-FOREST ,RM-RAVEN-TREE>
			<TELL "|The raven approaches its nest." CR>
		)
	>
>

<ROUTINE RT-I-RAV-NEST-2 ("AUX" (1ST? <>) RM)
	<COND
		(<MC-HERE? ,RM-RAVEN-NEST>
			<TELL CR The ,CH-RAVEN>
			<COND
				(<NOT <IN? ,CH-RAVEN ,RM-RAVEN-NEST>>
					<COND
						(<NOT <FSET? ,CH-PLAYER ,FL-ASLEEP>>
							<SET 1ST? T>
						)
					>
					<MOVE ,CH-RAVEN ,RM-RAVEN-NEST>
					<FCLEAR ,CH-RAVEN ,FL-LOCKED>
					<TELL " arrives in the nest">
					<COND
						(,GL-RAVEN-OBJ
							<MOVE ,GL-RAVEN-OBJ ,RM-RAVEN-NEST>
							<TELL ", drops" the ,GL-RAVEN-OBJ ",">
							<COND
								(<AND <EQUAL? ,GL-RAVEN-OBJ ,TH-RAVEN-EGG>
										<GETP ,TH-RAVEN-EGG ,P?SCORE>
									>
									<FCLEAR ,TH-RAVEN-EGG ,FL-BROKEN>
									<PUTP ,TH-RAVEN-EGG ,P?SCORE 0>
								)
							>
							<SETG GL-RAVEN-OBJ <>>
						)
					>
					<TELL " and ">
				)
			>
			<COND
				(<OR	<MC-FORM? ,K-FORM-ARTHUR>
						<FSET? ,CH-PLAYER ,FL-ASLEEP>
					>
					<COND
						(.1ST?
							<RT-QUEUE ,RT-I-RAV-NEST-2 <+ ,GL-MOVES 1>>
							<TELL
" starts buffeting you with it's huge wings. The deafening squawks emerging
from it's sharp beak quickly convince you that it is unhappy at your presence.
The raven unsheathes its talons and fixes you with a glassy-eyed stare." CR
							>
						)
						(T
							<TELL
"'s razor-like talons dig into your flesh and kill you instantly.|"
							>
							<RT-END-OF-GAME>
						)
					>
				)
				(<MC-FORM? ,K-FORM-OWL ,K-FORM-SALAMANDER>
					<RT-QUEUE ,RT-I-RAV-NEST-3 <+ ,GL-MOVES 2>>
					<TELL " chases you out.||">
					<COND
						(<MC-FORM? ,K-FORM-OWL>
							<RT-GOTO ,RM-ABOVE-FOREST T>
						)
						(T
							<COND
								(<SET RM <RT-CLIMB-DOWN>>
									<RT-GOTO .RM T>
								)
							>
						)
					>
				)
				(<MC-FORM? ,K-FORM-TURTLE>
					<TELL
" picks you up. He carries you off and drops you from a great height onto
a hard rock.|"
					>
					<RT-END-OF-GAME>
				)
				(<MC-FORM? ,K-FORM-BADGER>
					<TELL " kills you.|">
					<RT-END-OF-GAME>
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
		(T
			<RT-QUEUE ,RT-I-RAV-NEST-3 <+ ,GL-MOVES 2>>
			<MOVE ,CH-RAVEN ,RM-RAVEN-NEST>
			<FCLEAR ,CH-RAVEN ,FL-LOCKED>
			<COND
				(,GL-RAVEN-OBJ
					<MOVE ,GL-RAVEN-OBJ ,RM-RAVEN-NEST>
					<COND
						(<AND <EQUAL? ,GL-RAVEN-OBJ ,TH-RAVEN-EGG>
								<GETP ,TH-RAVEN-EGG ,P?SCORE>
							>
							<FCLEAR ,TH-RAVEN-EGG ,FL-BROKEN>
							<PUTP ,TH-RAVEN-EGG ,P?SCORE 0>
						)
					>
					<SETG GL-RAVEN-OBJ <>>
				)
			>
			<COND
				(<FSET? ,CH-PLAYER ,FL-ASLEEP>
					<RFALSE>
				)
				(<MC-HERE? ,RM-ABOVE-FOREST ,RM-RAVEN-TREE>
					<TELL CR The ,CH-RAVEN " lands in the nest." CR>
					<COND
						(<MC-HERE? ,RM-ABOVE-FOREST>
							<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
							<COND
								(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
									<RT-UPDATE-DESC-WINDOW>
								)
							>
						)
					>
					<RTRUE>
				)
			>
		)
	>
>

<ROUTINE RT-I-RAV-NEST-3 ("AUX" (EGG? <>))
	<FSET ,CH-RAVEN ,FL-BROKEN>
	<MOVE ,CH-RAVEN ,RM-ABOVE-FOREST>
	<COND
		(<AND <IN? ,TH-BRASS-EGG ,RM-RAVEN-NEST>
				<IN? ,TH-RAVEN-EGG ,RM-RAVEN-NEST>
			>
			<SET EGG? T>
			<MOVE ,TH-BRASS-EGG ,RM-GROVE>
			<RT-RAVEN-WAIT-FOR ,TH-BRASS-EGG>
		)
		(<IN? ,TH-RAVEN-EGG ,RM-GROVE>
			<RT-RAVEN-WAIT-FOR ,TH-RAVEN-EGG>
		)
		(<IN? ,TH-BRASS-EGG ,RM-GROVE>
			<RT-RAVEN-WAIT-FOR ,TH-BRASS-EGG>
		)
	>
	<COND
		(<MC-HERE? ,RM-ABOVE-FOREST ,RM-RAVEN-TREE ,RM-GROVE>
			<CRLF>
			<COND
				(.EGG?
					<COND
						(<MC-HERE? ,RM-GROVE>
							<COND
								(<FSET? ,CH-PLAYER ,FL-ASLEEP>
									<TELL
"Suddenly, you are awakened by the sound of something crashing through the
leaves above. Your eyes fly open in a panic, and the last thing you ever
see is a large brass egg approaching your head at terminal velocity.
Seconds later, you, too, become terminal." CR
									>
									<RT-END-OF-GAME>
								)
								(T
									<TELL
"Suddenly from above, you hear the sound of something heavy crashing through
leaves and branches. You glance up and then jump aside just in time to avoid
being killed by" the ,TH-BRASS-EGG ", which hits" the ,TH-GROUND " with a
loud \"WHUMP!\"||"
									>
								)
							>
						)
						(T
							<TELL
The ,CH-RAVEN " pushes" the ,TH-BRASS-EGG " out of the nest. It lands in"
the ,RM-GROVE ". "
							>
						)
					>
				)
			>
			<TELL
The ,CH-RAVEN " leaves the nest and resumes circling the forest.|"
			>
			<COND
				(<MC-HERE? ,RM-ABOVE-FOREST>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
							<RT-UPDATE-DESC-WINDOW>
						)
					>
				)
			>
			<RTRUE>
		)
	>
>

<ROUTINE RT-RAVEN-WAIT-FOR (OBJ "AUX" N)
	<SETG GL-RAVEN-OBJ .OBJ>
	<COND
		(<FSET? ,CH-RAVEN ,FL-BROKEN>
			<SET N 6>
		)
		(T
			<SET N 2>
		)
	>
	<RT-QUEUE ,RT-I-RAV-GROVE-1 <+ ,GL-MOVES .N>>
>

;"***************************************************************************"
; "ROOMS & ROOM ACTIONS"
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "RM-ABOVE-FOREST"
;"---------------------------------------------------------------------------"

<ROOM RM-ABOVE-FOREST
	(LOC ROOMS)
	(DESC "above forest")
	(FLAGS FL-AIR FL-LIGHTED)
	(DOWN PER RT-FLY-DOWN)
	(SOUTH TO RM-ABOVE-EDGE-OF-WOODS)
	(SW TO RM-ABOVE-MERCAVE)
	(SE TO RM-ABOVE-MOOR)
	(IN TO RM-RAVEN-NEST)
	(UP SORRY K-NO-HIGHER-MSG)
	(ADJACENT <TABLE (LENGTH BYTE PURE) RM-RAVEN-NEST T>)
	(GLOBAL LG-FOREST LG-TOWER CH-RAVEN RM-RAVEN-NEST RM-RAVEN-TREE RM-GROVE)
	(ACTION RT-RM-ABOVE-FOREST)
>

<CONSTANT K-FLY-HIGH-MSG "You are flying high above the forest.">

<ROUTINE RT-RM-ABOVE-FOREST ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,RM-RAVEN-NEST ,FL-SEEN>
			<FSET ,RM-RAVEN-TREE ,FL-SEEN>
			<TELL ,K-FLY-HIGH-MSG " ">
			<COND
				(<EQUAL? ,OHERE ,RM-TOW-CLEARING>
					<TELL "Y">
				)
				(T
					<TELL "In the distance, y">
				)
			>
			<TELL "ou see an ivory tower rising above the trees">
			<COND
				(<EQUAL? ,OHERE ,RM-TOW-CLEARING>
					<TELL " nearby. In the distance,">
				)
				(T
					<TELL ". Nearby, you see">
				)
			>
			<TELL
" one tall tree sticks up above the rest. In its uppermost branches is a huge
nest"
			>
			<COND
				(<OR	<IN? ,CH-RAVEN ,RM-RAVEN-NEST>
						<IN? ,TH-RAVEN-EGG ,RM-RAVEN-NEST>
					>
					<TELL ", and sitting in the nest is">
					<COND
						(<IN? ,CH-RAVEN ,RM-RAVEN-NEST>
							<TELL the ,CH-RAVEN>
							<COND
								(<IN? ,TH-RAVEN-EGG ,RM-RAVEN-NEST>
									<FSET ,TH-RAVEN-EGG ,FL-SEEN>
									<TELL " and its solid gold egg">
								)
							>
						)
						(T
							<FSET ,TH-RAVEN-EGG ,FL-SEEN>
							<TELL " a solid gold giant raven's egg">
						)
					>
				)
			>
			<TELL ".">
			<COND
				(<IN? ,CH-RAVEN ,RM-ABOVE-FOREST>
					<FSET ,CH-RAVEN ,FL-SEEN>
					<TELL " Looking around, you see the giant raven ">
					<COND
						(<AND ,GL-RAVEN-OBJ
								<IN? ,GL-RAVEN-OBJ ,CH-RAVEN>
							>
							<TELL "struggling to bring" a ,GL-RAVEN-OBJ " up to its nest.">
						)
						(<FSET? ,CH-RAVEN ,FL-LOCKED>
							<TELL "swooping down towards the grove.">
						)
						(T
							<TELL "circling nearby.">
						)
					>
				)
			>
			<FSET ,RM-GROVE ,FL-SEEN>
			<TELL " Far below you, you see a grove." CR>
		)
	;	(<MC-CONTEXT? ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "You are hovering over the forest.">
				)
				(T
					<TELL ,K-FLY-HIGH-MSG>
				)
			>
			<FSET ,RM-RAVEN-NEST ,FL-SEEN>
			<FSET ,RM-RAVEN-TREE ,FL-SEEN>
			<TELL
" You see a large raven's nest in the top of a nearby tree." CR
			>
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

;"---------------------------------------------------------------------------"
; "RM-RAV-PATH"
;"---------------------------------------------------------------------------"

<ROOM RM-RAV-PATH
	(LOC ROOMS)
	(DESC "trail")
	(FLAGS FL-LIGHTED)
	(SYNONYM PATH TRAIL)
	(ADJECTIVE FOREST)
	(NE TO RM-GROVE)
	(SW TO RM-ENCHANTED-FOREST)
	(UP PER RT-FLY-UP)
	(GLOBAL LG-ENCHANTED-TREES LG-FOREST LG-PATH RM-GROVE)
	(ACTION RT-RM-RAV-PATH)
>

<ROUTINE RT-RM-RAV-PATH ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL
"You are" standing " on a narrow trail, deep within the enchanted forest."
					>
				)
				(T
					<COND
						(<EQUAL? ,OHERE ,RM-ENCHANTED-FOREST>
							<TELL
"The path soon peters out into little more than a trail that continues to
run to the northeast."
							>
						)
						(T
							<TELL
"The trail looks like it broadens into a path up ahead."
							>
						)
					>
				)
			>								
			<CRLF>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-FOREST-PATH>
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
; "RM-GROVE"
;"---------------------------------------------------------------------------"

<ROOM RM-GROVE
	(LOC ROOMS)
	(DESC "grove")
	(FLAGS FL-LIGHTED)
	(SYNONYM GROVE)
	(ADJECTIVE FOREST)
	(SW TO RM-RAV-PATH)
	(UP PER RT-UP-RAV-GROVE)
	(GLOBAL LG-ENCHANTED-TREES LG-FOREST LG-PATH RM-RAVEN-TREE RM-RAVEN-NEST)
	(ACTION RT-RM-GROVE)
>

<ROUTINE RT-RM-GROVE ("OPT" (CONTEXT <>) "AUX" (RM <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL
"You are in a grove of tall trees, deep within the enchanted forest."
					>
				)
				(T
					<COND
						(<EQUAL? ,OHERE ,RM-RAV-PATH>
							<TELL "The trail ends in a grove of tall trees.">
						)
						(T
							<TELL "You descend to the forest floor below.|">
							<RFALSE>
						)
					>
				)
			>
			<FSET ,RM-RAVEN-TREE ,FL-SEEN>
			<TELL
" One tree in particular seems taller than the rest. A path to the southwest
leads back into the forest.|"
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<AND <VERB? LOOK-UP>
						<MC-PRSO? ,ROOMS ,RM-RAVEN-TREE>
					>
					<FSET ,RM-RAVEN-NEST ,FL-SEEN>
					<TELL "At the very top of the tree you can see a large nest." CR>
				)
			>
		)
		(<MC-CONTEXT? ,M-END>
			<COND
				(,GL-RAVEN-OBJ
					<COND
						(<IN? ,GL-RAVEN-OBJ ,CH-RAVEN>
							<RFALSE>
						)
						(<NOT <IN? ,GL-RAVEN-OBJ ,RM-GROVE>>
							<SETG GL-RAVEN-OBJ <>>
							<RT-DEQUEUE ,RT-I-RAV-GROVE-1>
						)
					>
				)
				(<IN? ,TH-RAVEN-EGG ,RM-GROVE>
					<RT-RAVEN-WAIT-FOR ,TH-RAVEN-EGG>
				)
				(<IN? ,TH-BRASS-EGG ,RM-GROVE>
					<RT-RAVEN-WAIT-FOR ,TH-BRASS-EGG>
				)
			>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-GROVE>
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
		(<VERB? WALK-TO ENTER LAND-ON>
			<COND
				(<MC-HERE? ,RM-RAVEN-NEST>
					<COND
						(<MC-FORM? ,K-FORM-OWL>
							<RT-GOTO ,RM-GROVE>
						)
						(<MC-FORM? ,K-FORM-SALAMANDER>
							<COND
								(<SET RM <RT-CLIMB-DOWN>>
									<RT-GOTO .RM>
								)
							>
							<RTRUE>
						)
						(T
							<TELL ,K-DEADLY-FALL-MSG CR>
						)
					>
				)
				(<MC-HERE? ,RM-ABOVE-FOREST>
					<RT-GOTO ,RM-GROVE>
				)
			>
		)
	>
>

<ROUTINE RT-UP-RAV-GROVE ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<COND
				(<OR	<MC-FORM? ,K-FORM-OWL ,K-FORM-SALAMANDER>
						<FSET? ,RM-RAVEN-TREE ,FL-TOUCHED>
					>
					<RETURN ,RM-RAVEN-TREE>
				)
			>
		)
		(<MC-FORM? ,K-FORM-OWL>
			<RT-FLY-UP>
		)
		(<MC-FORM? ,K-FORM-SALAMANDER>
			<RT-CLIMB-UP>
		)
		(T
			<RT-RAV-CANT-CLIMB-UP>
			<RFALSE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-RAVEN-TREE"
;"---------------------------------------------------------------------------"

<ROOM RM-RAVEN-TREE
	(LOC ROOMS)
	(DESC "huge tree")
	(FLAGS FL-LIGHTED)
	(SYNONYM TREE BRANCH BRANCHES)
	(ADJECTIVE HUGE BIG TALL TALLER TALLEST RAVEN GIANT)
	(OWNER CH-RAVEN)
	(UP PER RT-CLIMB-UP)
	(DOWN PER RT-CLIMB-DOWN)
	(GLOBAL LG-FOREST RM-GROVE RM-RAVEN-NEST)
	(GENERIC RT-GN-TREE)
	(ACTION RT-RM-RAVEN-TREE)
>

<CONSTANT K-DEADLY-FALL-MSG "You would fall and kill yourself.">

<ROUTINE RT-RM-RAVEN-TREE ("OPT" (CONTEXT <>) "AUX" RM)
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<TELL "You are">
			<COND
				(<NOT <MC-CONTEXT? ,M-LOOK>>
					<TELL " now">
				)
			>
			<TELL " clinging to the side of" the ,RM-RAVEN-TREE "." CR>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-RAVEN-TREE>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<AND <VERB? WALK-TO CLIMB-DOWN CLIMB-ON CLIMB-OVER ENTER>
						<MC-PRSO? ,TH-GROUND>
					>
					<COND
						(<VERB-WORD? ,W?JUMP ,W?LEAP ,W?DIVE>
							<RT-JUMP-OFF-TREE-MSG>
						)
						(T
							<RT-CLIMB-DOWN-TREE-MSG>
						)
					>
				)
				(<AND <VERB? WALK-TO CLIMB-UP ENTER>
						<MC-PRSO? ,TH-SKY>
					>
					<RT-CLIMB-UP-TREE-MSG>
				)
				(<VERB? JUMP>
					<RT-JUMP-OFF-TREE-MSG>
				)
				(<AND <VERB? EXAMINE LOOK-ON>
						<MC-PRSO? ,TH-GROUND>
					>
					<TELL "The ground is ">
					<COND
						(<G? ,GL-RAV-P-CNT 3>
							<TELL "far">
						)
						(<G? ,GL-RAV-P-CNT 1>
							<TELL "a short distance">
						)
						(T
							<TELL "just">
						)
					>
					<TELL " below you." CR>
				)
			>
		)
		(<MC-CONTEXT? ,M-END>
			<COND
				(<NOT <MC-FORM? ,K-FORM-SALAMANDER>>
					<RT-FALL-OFF-TREE>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,RM-RAVEN-TREE ,FL-SEEN>
			<COND
				(<MC-HERE? ,RM-GROVE>
					<TELL "The tree towers above you." CR>
				)
				(<MC-HERE? ,RM-RAVEN-NEST>
					<TELL "The tree supports the raven's nest." CR>
				)
				(<MC-HERE? ,RM-ABOVE-FOREST>
					<TELL "The tree is far below you." CR>
				)
			>
		)
		(<VERB? CLIMB-UP>
			<RT-CLIMB-UP-TREE-MSG>
		)
		(<VERB? CLIMB-DOWN>
			<RT-CLIMB-DOWN-TREE-MSG>
		)
		(<VERB? DISMOUNT>
			<COND
				(<MC-HERE? ,RM-RAVEN-TREE>
					<RT-JUMP-OFF-TREE-MSG>
				)
				(T
					<RT-AUTHOR-ON>
					<TELL The+verb ,WINNER "are" "n't on" the ,RM-RAVEN-TREE ".">
					<RT-AUTHOR-OFF>
				)
			>
		)
		(<AND <VERB? WALK-TO LAND-ON ENTER>
				<FSET? ,HERE ,FL-AIR>
			>
			<RT-GOTO ,RM-RAVEN-NEST>
		)
	>
>

<ROUTINE RT-GN-TREE (TBL FINDER "AUX" PTR N)
	<SET PTR <REST-TO-SLOT .TBL FIND-RES-OBJ1>>
	<SET N <FIND-RES-COUNT .TBL>>
	<COND
		(<INTBL? ,RM-RAVEN-TREE .PTR .N>
			<RETURN ,RM-RAVEN-TREE>
		)
		(<INTBL? ,P-IT-OBJECT .PTR .N>
			<RETURN ,P-IT-OBJECT>
		)
	>
>

<ROUTINE RT-CLIMB-UP ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<COND
				(<MC-HERE? ,RM-RAVEN-TREE>
					<RETURN ,RM-RAVEN-NEST>
				)
				(T
					<RETURN ,RM-RAVEN-TREE>
				)
			>
		)
		(<MC-HERE? ,RM-RAVEN-TREE>
			<COND
				(<IGRTR? GL-RAV-P-CNT ,K-RAVEN-TREE-MAX>
					<TELL
"You reach the top of" the ,RM-RAVEN-TREE " and climb into" the ,RM-RAVEN-NEST ".||"
					>
					<RETURN ,RM-RAVEN-NEST>
				)
				(T
					<RT-RAV-CLIMBING ,K-CLIMB-UP>
					<RFALSE>
				)
			>
		)
		(T
			<SETG GL-RAV-P-CNT 0>
			<RETURN ,RM-RAVEN-TREE>
		)
	>
>

<ROUTINE RT-CLIMB-DOWN ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<COND
				(<MC-HERE? ,RM-RAVEN-TREE>
					<RETURN ,RM-GROVE>
				)
				(T
					<RETURN ,RM-RAVEN-TREE>
				)
			>
		)
		(<MC-HERE? ,RM-RAVEN-TREE>
			<COND
				(<DLESS? GL-RAV-P-CNT 1>
					<TELL
"You reach the foot of" the ,RM-RAVEN-TREE " and jump off onto the ground.||"
					>
					<RETURN ,RM-GROVE>
				)
				(T
					<RT-RAV-CLIMBING ,K-CLIMB-DN>
					<RFALSE>
				)
			>
		)
		(T
			<SETG GL-RAV-P-CNT ,K-RAVEN-TREE-MAX>
			<RETURN ,RM-RAVEN-TREE>
		)
	>
>

<ROUTINE RT-CLIMB-UP-TREE-MSG ("AUX" RM)
	<COND
		(<MC-FORM? ,K-FORM-OWL>
			<COND
				(<MC-HERE? ,RM-RAVEN-NEST>
					<RT-YOU-CANT-MSG "climb up" ,RM-RAVEN-TREE>
				)
				(T
					<RT-GOTO ,RM-RAVEN-NEST>
				)
			>
		)
		(<MC-FORM? ,K-FORM-SALAMANDER>
			<COND
				(<SET RM <RT-CLIMB-UP>>
					<RT-GOTO .RM>
				)
			>
			<RTRUE>
		)
		(T
			<RT-RAV-CANT-CLIMB-UP>
		)
	>
>

<ROUTINE RT-CLIMB-DOWN-TREE-MSG ("AUX" RM)
	<COND
		(<MC-FORM? ,K-FORM-OWL>
			<COND
				(<MC-HERE? ,RM-GROVE>
					<RT-YOU-CANT-MSG "climb down" ,RM-RAVEN-TREE>
				)
				(T
					<RT-GOTO ,RM-GROVE>
				)
			>
		)
		(<MC-FORM? ,K-FORM-SALAMANDER>
			<COND
				(<SET RM <RT-CLIMB-DOWN>>
					<RT-GOTO .RM>
				)
			>
			<RTRUE>
		)
		(T
			<TELL ,K-DEADLY-FALL-MSG CR>
		)
	>
>

<ROUTINE RT-JUMP-OFF-TREE-MSG ()
	<COND
		(<L? ,GL-RAV-P-CNT 4>
			<MOVE ,CH-PLAYER ,RM-GROVE>
			<SETG OHERE ,HERE>
			<SETG HERE ,RM-GROVE>
			<TELL
"You leap off of" the ,RM-RAVEN-TREE " and fall to" the ,TH-GROUND ", a bit
bruised and battered but otherwise alright." CR
			>
			<SETG GL-PICTURE-NUM ,K-PIC-GROVE>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
					<RT-UPDATE-DESC-WINDOW>
				)
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>
					<RT-UPDATE-MAP-WINDOW>
				)
			>
			<RTRUE>
		)
		(T
			<TELL ,K-DEADLY-FALL-MSG CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-RAVEN-NEST"
;"---------------------------------------------------------------------------"

<ROOM RM-RAVEN-NEST
	(LOC ROOMS)
	(DESC "giant raven's nest")
	(FLAGS FL-LIGHTED)
	(SYNONYM NEST SIDE)
	(ADJECTIVE RAVEN)
	(OWNER CH-RAVEN)
	(UP PER RT-FLY-UP)
	(OUT PER RT-EXIT-NEST)
	(DOWN PER RT-EXIT-NEST)
	(GLOBAL LG-FOREST CH-RAVEN RM-GROVE RM-RAVEN-TREE)
	(ACTION RT-RM-RAVEN-NEST)
>

<GLOBAL GL-EGG-IN-NEST? T <> BYTE>

<ROUTINE RT-RM-RAVEN-NEST ("OPT" (CONTEXT <>) "AUX" RM EGG?)
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<TELL "You ">
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "are in">
				)
				(<MC-FORM? ,K-FORM-OWL>
					<TELL "land in">
				)
				(T
					<TELL "climb into">
				)
			>
			<FSET ,RM-GROVE ,FL-SEEN>
			<TELL
the ,RM-RAVEN-NEST ".|Far below you, you see" the ,RM-GROVE "."
			>
			<COND
				(<IN? ,CH-RAVEN ,RM-RAVEN-NEST>
					<FSET ,CH-RAVEN ,FL-SEEN>
					<TELL
" The other occupant of the nest is a giant raven that is clearly unhappy
with your presence."
					>
				)
				(<AND	<NOT <FSET? ,CH-RAVEN ,FL-LOCKED>>
						<NOT ,GL-RAVEN-OBJ>
					>
					<FSET ,CH-RAVEN ,FL-SEEN>
					<TELL " You can see" the ,CH-RAVEN " circling above.">
				)
			>
			<CRLF>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-RAVEN-NEST>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTERED>
			<COND
				(<IN? ,CH-RAVEN ,RM-RAVEN-NEST>
					<TELL
CR The ,CH-RAVEN "'s razor-like talons dig into your flesh and kill you
instantly.|"
					>
					<RT-END-OF-GAME>
				)
				(<FSET? ,CH-RAVEN ,FL-LOCKED>)
				(,GL-RAVEN-OBJ
					<RT-DEQUEUE ,RT-I-RAV-GROVE-1>
					<RT-I-RAV-GROVE-1>
				)
				(T
					<RT-I-RAV-NEST-1>
				)
			>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<OR	<AND <VERB? DROP> <VERB-WORD? ,W?THROW>>
						<AND <VERB? PUT PUT-IN> <MC-PRSI? ,TH-GROUND ,RM-GROVE>>
						<AND <VERB? THROW> <MC-PRSI? <> ,ROOMS ,TH-GROUND ,RM-GROVE>>
						<AND <VERB? EXTEND> <MC-PRSI? <> ,ROOMS ,RM-RAVEN-NEST ,GLOBAL-HERE>>
						<VERB? MOVE>
					>
					<COND
						(<MC-FORM? ,K-FORM-ARTHUR>
							<MOVE ,PRSO ,RM-GROVE>
							<COND
								(<AND <MC-PRSO? ,TH-RAVEN-EGG>
										<NOT <FSET? ,TH-RAVEN-EGG ,FL-BROKEN>>
									>
									<FSET ,TH-RAVEN-EGG ,FL-BROKEN>
									<PUTP ,TH-RAVEN-EGG ,P?SCORE
										%<ORB
											<LSH 4 ,K-WISD-SHIFT>
											<LSH 5 ,K-EXPR-SHIFT>
											<LSH 2 ,K-QUEST-SHIFT>
										>
									>
								)
							>
							<TELL
"You throw" the ,PRSO " to" the ,RM-GROVE " below." CR
							>
							<COND
								(<MC-PRSO? ,TH-RAVEN-EGG ,TH-BRASS-EGG>
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
							<COND
								(<MC-PRSO? ,TH-RAVEN-EGG ,TH-BRASS-EGG>
									<TELL "The egg is solid ">
									<COND
										(<MC-PRSO? ,TH-RAVEN-EGG>
											<TELL "gold">
										)
										(T
											<TELL "brass">
										)
									>
									<TELL
". It's too heavy for" aform " to move." CR
									>
								)
								(T
									<RT-ANIMAL-CANT-MSG "move">
								)
							>
						)
					>
				)
				(<AND <VERB? WALK-TO CLIMB-DOWN CLIMB-ON CLIMB-OVER ENTER>
						<MC-PRSO? ,TH-GROUND>
					>
					<COND
						(<MC-FORM? ,K-FORM-OWL ,K-FORM-SALAMANDER>
							<RT-DO-WALK ,P?DOWN>
						)
						(T ;<VERB-WORD? ,W?JUMP ,W?LEAP ,W?DIVE>
							<TELL
"Throwing caution to the winds, you stand on the edge of the nest and execute
a perfect swan dive into the air. Just as it occurs to you that you are not
a swan, it occurs to the ground to smash into - and kill - you." CR
							>
							<RT-END-OF-GAME>
						)
						;(T
							<RT-CLIMB-DOWN-TREE-MSG>
						)
					>
				)
				(<AND <VERB? WALK-TO CLIMB-UP ENTER>
						<MC-PRSO? ,TH-SKY>
					>
					<RT-DO-WALK ,P?UP>
				)
			>
		)
		(<MC-CONTEXT? ,M-END>
			<SET EGG?
				<OR
					<IN? ,TH-RAVEN-EGG ,RM-RAVEN-NEST>
					<IN? ,TH-BRASS-EGG ,RM-RAVEN-NEST>
				>
			>
			<COND
				(<NOT <EQUAL? .EGG? ,GL-EGG-IN-NEST?>>
					<SETG GL-EGG-IN-NEST? .EGG?>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
							<RT-UPDATE-PICT-WINDOW>
						)
					>
				)
			>
			<RFALSE>
		)
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<COND
				(<VERB? THROW PUT PUT-IN>
					<COND
						(<MC-HERE? ,RM-GROVE>
							<TELL
The+verb ,WINNER "are" "n't strong enough to throw" the ,PRSO " that high." CR
							>
						)
					>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,RM-RAVEN-NEST ,FL-SEEN>
			<COND
				(<MC-HERE? ,RM-GROVE>
					<TELL "The nest is at the very top of the tree." CR>
				)
				(<MC-HERE? ,RM-RAVEN-TREE>
					<TELL "It looks like the home of a giant raven." CR>
				)
				(<MC-HERE? ,RM-ABOVE-FOREST>
					<TELL "The nest is below you in the top of the tree." CR>
				)
			>
		)
		(<VERB? WALK-TO ENTER LAND-ON>
			<COND
				(<MC-HERE? ,RM-GROVE>
					<COND
						(<MC-FORM? ,K-FORM-OWL>
							<RT-GOTO ,RM-RAVEN-NEST>
						)
						(<MC-FORM? ,K-FORM-SALAMANDER>
							<COND
								(<SET RM <RT-CLIMB-UP>>
									<RT-GOTO .RM>
								)
							>
							<RTRUE>
						)
						(T
							<RT-RAV-CANT-CLIMB-UP>
						)
					>
				)
				(<MC-HERE? ,RM-ABOVE-FOREST>
					<RT-GOTO ,RM-RAVEN-NEST>
				)
			>
		)
		(<VERB? LOOK-IN>
			<COND
				(<MC-HERE? ,RM-ABOVE-FOREST>
					<TELL "You see">
					<PRINT-CONTENTS ,RM-RAVEN-NEST>
					<TELL in ,RM-RAVEN-NEST the ,RM-RAVEN-NEST "." CR>
				)
			>
		)
	>
>

<ROUTINE RT-EXIT-NEST ("OPT" (QUIET <>))
	<COND
		(<MC-FORM? ,K-FORM-OWL>
			<COND
				(<EQUAL? ,P-WALK-DIR ,P?DOWN>
					<RETURN ,RM-GROVE>
				)
				(T
					<RT-FLY-UP .QUIET>
				)
			>
		)
		(<MC-FORM? ,K-FORM-SALAMANDER>
			<RT-CLIMB-DOWN .QUIET>
		)
		(T
			<COND
				(<NOT .QUIET>
					;<TELL "You would fall and hurt yourself." CR>
                    <TELL
"Throwing caution to the winds, you stand on the edge of the nest and execute
a perfect swan dive into the air. Just as it occurs to you that you are not
a swan, it occurs to the ground to smash into - and kill - you." CR
                    >
                    <RT-END-OF-GAME>
				)
			>
			<RFALSE>
		)
	>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

