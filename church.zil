;"***************************************************************************"
; "game : Arthur"
; "file : CHURCH.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   13 May 1989 17:41:46  $"
; "rev  : $Revision:   1.127  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Churchyard"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

<INCLUDE "PDEFS">		; "Because PARSE-ACTION used in this file."

;"---------------------------------------------------------------------------"
; "RM-CHURCHYARD"
;"---------------------------------------------------------------------------"

<ROOM RM-CHURCHYARD
	(LOC ROOMS)
	(DESC "churchyard")
	(FLAGS FL-LIGHTED)
	(SYNONYM CHURCHYARD YARD)
	(ADJECTIVE CHURCH)
	(WEST PER RT-BEHIND-STONE)
	(EAST TO RM-CHURCH)
	(IN TO RM-CHURCH)
	(SOUTH TO RM-TOWN-SQUARE IF LG-CHURCH-GATE IS OPEN)
	(OUT TO RM-TOWN-SQUARE IF LG-CHURCH-GATE IS OPEN)
	(UP PER RT-FLY-UP)
	(ADJACENT <TABLE (LENGTH BYTE PURE) RM-TOWN-SQUARE T>)
	(GLOBAL LG-CHURCH-GATE LG-WALL RM-CHURCH RM-TOWN-SQUARE)
	(ACTION RT-RM-CHURCHYARD)
	(THINGS
		(STONE CHURCH) (STEPS STAIRS) RT-PS-STEPS
		<> (SOLDIER SOLDIERS) RT-PS-FAKE-SOLDIERS
	)
>

<ROUTINE RT-RM-CHURCHYARD ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-ENTER>
			<COND
				(<AND <EQUAL? ,OHERE ,RM-CHURCH>
						<RT-IS-QUEUED? ,RT-I-SOLDIER-3>
					>
					<TELL
"You dash out of the church, only to see the churchyard gate swing open. You
come face-to-face with a group of Lot's soldiers." ,K-ARREST-MSG
					>
					<RT-END-OF-GAME>
				)
				(T
					<SETG GL-PICTURE-NUM ,K-PIC-CHURCHYARD>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
							<RT-UPDATE-PICT-WINDOW>
						)
					>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-F-LOOK>
			<FSET ,CH-MERLIN ,FL-SEEN>
			<THIS-IS-IT ,TH-TORQUE>
			;<TELL
"Merlin appears before you and his voice thunders in your ears, \"Listen
well, Arthur, for now will the mysteries of your childhood be made clear to
you. Your true father was Uther Pendragon, high King of England. Your mother
was Ygraine of Cornwall. When you were born, you were given to me to raise
and keep safe until such time as England had need of you.\"" CR CR

"\"To you alone belongs the throne of England, Arthur. But the time is not
yet when you may take up this sword. Before you gain your birthright, you
must prove yourself a king. To rule England you must be both wise and
chivalrous. To lead her armies you must be strong and courageous. I believe
you have these qualities within you, but you must demonstrate them for all
to see. In so doing, you will gain the experience you need to claim the
sword.\"" CR CR

"\"Come seek me out at my cave beyond the meadow, and I will help you achieve
your quest. Be warned, however, that another plots to steal your throne. Go,
therefore, son of Uther, to earn and protect that which is yours.\"" CR CR>
<TELL
"Merlin disappears as suddenly as he came. In the space where he had been, a
torque hangs in mid-air for a second and then falls to the ground." CR
			>
		)
		(<MC-CONTEXT? ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL The+verb ,WINNER "are">
					<COND
						(,GL-HIDING
							<TELL " lying down">
						)
						(T
							<TELL standing>
						)
					>
					<TELL " ">
					<COND
						(<IN? ,CH-PLAYER ,TH-BEHIND-G-STONE>
							<FSET ,TH-GRAVESTONE ,FL-SEEN>
							<TELL "behind a large gravestone">
						)
						(T
							<TELL "in the ">
							<COND
								(<RT-TIME-OF-DAY? ,K-NIGHT>
									<TELL "bright moonlight">
								)
								(T
									<COND
										(<RT-TIME-OF-DAY? ,K-EVENING>
											<TELL "fading">
										)
										(T
											<TELL "bright">
										)
									>
									<TELL " sunlight">
								)
							>
							<TELL " of a mid-winter's ">
							<COND
								(<RT-TIME-OF-DAY? ,K-NIGHT>
									<TELL "night">
								)
								(<RT-TIME-OF-DAY? ,K-EVENING>
									<TELL "evening">
								)
								(<RT-TIME-OF-DAY? ,K-AFTERNOON>
									<TELL "afternoon">
								)
								(T
									<TELL "morning">
								)
							>
							<TELL " in a deserted English churchyard">
						)
					>
				)
				(T
					<TELL "You return to" the ,RM-CHURCHYARD>
				)
			>
			<TELL ".">
			<COND
				(<IN? ,TH-STONE ,RM-CHURCHYARD>
					<FSET ,TH-STONE ,FL-SEEN>
					<FSET ,TH-EXCALIBUR ,FL-SEEN>
					<TELL
" At the foot of the church steps is a large stone with a jewelled sword
protruding from it."
					>
				)
			>
			<FSET ,RM-CHURCH ,FL-SEEN>
			<COND
				(<IN? ,WINNER ,TH-BEHIND-G-STONE>
				;	<TELL
" The church entrance lies to the southeast, and" the ,RM-CHURCHYARD " itself
is to the south"
					>
					<TELL " The churchyard lies to the east">
				)
				(T
					<FSET ,TH-GRAVESTONE ,FL-SEEN>
					<FSET ,LG-CHURCH-GATE ,FL-SEEN>
					<TELL
" The church entrance lies to the east, and just west of you is a large
gravestone. A stone wall encircles the churchyard, but there is an ironwork
gate in the wall to your south"
					>
				)
			>
			<TELL "." CR>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<AND <VERB? LISTEN>
						<MC-PRSI? <> ,ROOMS>
					>
					<COND
						(<RT-IS-QUEUED? ,RT-I-SOLDIER-2>
							<TELL ,K-GETTING-CLOSER-MSG>
						)
						(<OR	<IN? ,CH-SOLDIERS ,RM-TOWN-SQUARE>
								<IN? ,CH-SOLDIERS ,RM-CHURCHYARD>
							>
							<TELL The+verb ,CH-SOLDIERS "are" ,K-MUTTERING-MSG>
						)
					>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? HIDE-BEHIND>
			<RT-YOU-CANT-MSG "go">
		)
	>
>

<ROUTINE RT-PS-STEPS ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
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
					<TELL "steps">
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE LOOK-ON>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<TELL "The steps are old and worn." CR>
		)
		(<VERB? STAND SIT LIE-DOWN>
		 <THIS-IS-IT ,PESUDO-OBJECT>
		 <RT-WASTE-OF-TIME-MSG>
		)
		(<VERB? CLIMB-ON CLIMB-UP>
			<RT-DO-WALK ,P?EAST>
		)
	>
>

<ROUTINE RT-PS-FAKE-SOLDIERS ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
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
					<TELL "soldiers">
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? LISTEN>
			<COND
				(<RT-IS-QUEUED? ,RT-I-SOLDIER-2>
					<TELL ,K-GETTING-CLOSER-MSG>
				)
				(<IN? ,CH-SOLDIERS ,RM-TOWN-SQUARE>
					<TELL The+verb ,CH-SOLDIERS "are" ,K-MUTTERING-MSG>
				)
			>
		)
		(<NOT <EVERYWHERE-VERB? <COND (,NOW-PRSI 2) (T 1)>>>
			<NP-CANT-SEE>
		)
		(,NOW-PRSI
			<PERFORM ,PRSA ,PRSO ,CH-SOLDIERS>
		)
		(T
			<PERFORM ,PRSA ,CH-SOLDIERS ,PRSI>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-GRAVESTONE"
;"---------------------------------------------------------------------------"

<OBJECT TH-GRAVESTONE
	(LOC RM-CHURCHYARD)
	(DESC "gravestone")
	(FLAGS FL-NO-DESC)
	(SYNONYM GRAVESTONE GRAVE TOMB STONE TOMBSTONE)
	(ADJECTIVE GRAVE TOMB)
	(GENERIC RT-GN-STONE)
	(ACTION RT-TH-GRAVESTONE)
>

<ROUTINE RT-TH-GRAVESTONE ("OPT" (CONTEXT <>) "AUX" WRD)
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<AND <NOUN-USED? ,TH-GRAVESTONE ,W?GRAVE ,W?TOMB>
				<NOT <EVERYWHERE-VERB? <COND (,NOW-PRSI 2) (T 1)>>>
			>
			<TELL "There is no ">
			<COND
				(<NOUN-USED? ,TH-GRAVESTONE ,W?GRAVE>
					<TELL "grave">
				)
				(T
					<TELL "tomb">
				)
			>
			<TELL
" here yet. Only a blank gravestone that marks where a man will one day be
buried.|"
			>
			<COND
				(<VERB? OPEN>
					<SETG GL-QUESTION 1>
					<RT-AUTHOR-MSG "Let's not get morbid, shall we?">
				)
			>
			<RTRUE>
		)
		(<VERB? EXAMINE LOOK-ON READ>
			<FSET ,TH-GRAVESTONE ,FL-SEEN>
			<TELL
The ,TH-GRAVESTONE " is blank. The man who will lie there has not yet been
born." CR
			>
		)
		(<VERB? PUT>
			<TELL
The ,TH-GRAVESTONE " is upright. You can't put anything on it." CR
			>
		)
		(<VERB? HIDE-BEHIND>
			<RT-BEHIND-STONE>
			<RTRUE>
		)
		(<VERB? LOOK-BEHIND>
			<COND
				(<SEE-ANYTHING-IN? ,TH-BEHIND-G-STONE>
					<TELL "You see">
					<PRINT-CONTENTS ,TH-BEHIND-G-STONE>
					<TELL " behind" the ,TH-GRAVESTONE "." CR>
				)
			>
		)
		(<AND <VERB? EXIT>
				<IN? ,CH-PLAYER ,TH-BEHIND-G-STONE>
			>
			<RT-DO-WALK ,P?EAST>
		)
	>
>

<NEW-ADD-WORD "STONES" NOUN <VOC "STONE"> ,PLURAL-FLAG>

<ROUTINE RT-GN-STONE (TBL FINDER "AUX" PTR N V)
	<SET PTR <REST-TO-SLOT .TBL FIND-RES-OBJ1>>
	<SET N <FIND-RES-COUNT .TBL>>
	<SET V <PARSE-ACTION ,PARSE-RESULT>>
	<COND
		(<AND <EQUAL? .V ,V?HIDE-BEHIND ,V?EXIT ,V?READ>
				<MC-HERE? ,RM-CHURCHYARD>
			>
			<TELL "[" The ,TH-GRAVESTONE "]" CR>
			<RETURN ,TH-GRAVESTONE>
		)
		(<AND <EQUAL? .V ,V?HIDE-BEHIND ,V?EXIT ,V?LISTEN ,V?CLIMB-ON ,V?CLIMB-OVER ,V?CLIMB-UP>
				<MC-HERE? ,RM-GLADE>
			>
			<RETURN ,TH-ROCK>
		)
		(<AND <EQUAL? .V ,V?POLISH>
				<INTBL? ,TH-PUMICE .PTR .N>
			>
			<TELL "[" The ,TH-PUMICE "]" CR>
			<RETURN ,TH-PUMICE>
		)
		(<AND <INTBL? ,TH-STONE .PTR .N>
				<MC-HERE? ,RM-BOAT-ROOM>
			>
			<RETURN ,TH-STONE>
		)
		(<INTBL? ,P-IT-OBJECT .PTR .N>
			<RETURN ,P-IT-OBJECT>
		)
		(<INTBL? ,TH-CELL-STONE .PTR .N>
			<RETURN ,TH-CELL-STONE>
		)
		(<INTBL? ,TH-STONE .PTR .N>
			<RETURN ,TH-STONE>
		)
		(<INTBL? ,TH-PUMICE .PTR .N>
			<TELL "[" The ,TH-PUMICE "]" CR>
			<RETURN ,TH-PUMICE>
		)
		(<INTBL? ,TH-ROCK .PTR .N>
			<RETURN ,TH-ROCK>
		)
		(<INTBL? ,TH-GRAVESTONE .PTR .N>
			<TELL "[" The ,TH-GRAVESTONE "]" CR>
			<RETURN ,TH-GRAVESTONE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-BEHIND-G-STONE"
;"---------------------------------------------------------------------------"

<OBJECT TH-BEHIND-G-STONE
	(LOC RM-CHURCHYARD)
	(DESC "behind the gravestone")
	(FLAGS FL-CONTAINER FL-NO-ARTICLE FL-NO-DESC FL-OPEN FL-SEARCH)
	(EAST PER RT-LEAVE-STONE)
	(OUT PER RT-LEAVE-STONE)
;	(SE PER RT-LEAVE-STONE)
	(UP PER RT-FLY-UP)
	(GLOBAL LG-CHURCH-GATE LG-WALL RM-CHURCH)
	(CAPACITY K-CAP-MAX)
	(ACTION RT-TH-BEHIND-G-STONE)
>

<ROUTINE RT-TH-BEHIND-G-STONE ("OPT" (CONTEXT <>) "AUX" L)
	<COND
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<AND <IN? ,CH-SOLDIERS ,RM-CHURCHYARD>
						<UNHIDE-VERB?>
					>
					<RT-SEIZE-MSG ,CH-SOLDIERS>
				)
				(<AND <VERB? WALK>
						<EQUAL? ,P-WALK-DIR ,P?UP>
						,GL-HIDING
					>
					<SETG GL-HIDING <>>
					<TELL "You stand up and dust yourself off." CR>
				)
				(<OR	<AND
							<VERB? PUT-IN>
							<MC-PRSI? ,RM-CHURCHYARD>
						>
						<AND
							<VERB? THROW>
							<IN? ,PRSI ,RM-CHURCHYARD>
						>
					>
					<COND
						(<OR	<PRE-PUT>
								<NOT <IDROP>>
							>
							<RTRUE>
						)
						(T
							<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT ,K-UPD-OBJS>>
							<MOVE ,PRSO ,RM-CHURCHYARD>
							<TELL
The+verb ,WINNER "toss" the ,PRSO " into" the ,RM-CHURCHYARD "." CR
							>
						)
					>
				)
				(<TOUCH-VERB?>
					<SET L <LOC ,CH-PLAYER>>
					<COND
						(,PRSO
							<COND
								(<OR	<MC-PRSO? ,ROOMS>
										<EQUAL? <LOC ,PRSO> ,GLOBAL-OBJECTS ,GENERIC-OBJECTS>
									>
									<>
								)
								(<NOT <RT-META-IN? ,PRSO .L>>
									<COND
										(<MC-PRSO? ,TH-GRAVESTONE>
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
										(<MC-PRSI? ,TH-GRAVESTONE>
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
	>
>

<ROUTINE RT-BEHIND-STONE ("OPT" (QUIET <>) "AUX" (HIDE <>))
	<COND
		(.QUIET
			<RFALSE>
		)
		(<IN? ,WINNER ,TH-BEHIND-G-STONE>
			<RT-ALREADY-MSG ,WINNER "behind the gravestone">
		)
		(T
			<MOVE ,WINNER ,TH-BEHIND-G-STONE>
			<TELL The ,WINNER>
			<COND
				(<SET HIDE
						<OR
							<IN? ,CH-SOLDIERS ,RM-CHURCHYARD>
							<VERB? HIDE-BEHIND>
						>
					>
					<COND
						(T ;<MC-HERE? ,RM-CHURCHYARD>
							<TELL verb ,WINNER "jump">
						)
					;	(T
							<TELL
verb ,WINNER "run" " out of the church," verb ,WINNER "dive"
							>
						)
					>
				)
				(T
					<COND
						(T ;<MC-HERE? ,RM-CHURCHYARD>
							<TELL verb ,WINNER "walk" " around">
						)
					;	(T
							<TELL
verb ,WINNER "leave" " the church and" verb ,WINNER "walk" " around"
							>
						)
					>
				)
			>
		;	<COND
				(<MC-HERE? ,RM-CHURCH>
					<SETG OHERE ,HERE>
					<SETG HERE ,RM-CHURCHYARD>
					<SETG LIT <LIT?>>
				)
			>
			<TELL " behind" the ,TH-GRAVESTONE>
			<COND
				(.HIDE
					<SETG GL-HIDING ,TH-GRAVESTONE>
					<TELL " and" verb ,WINNER "cower" " low to the ground">
				)
			>
		;	<TELL
". The church entrance lies to the southeast, and the churchyard itself is
to the south.|"
			>
			<TELL ". The churchyard lies to the east.|">
			<SETG GL-PICTURE-NUM ,K-PIC-GRAVESTONE>
			<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
					<RT-UPDATE-DESC-WINDOW>
				)
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>
					<RT-UPDATE-MAP-WINDOW>
				)
			>
		)
	>
	<RFALSE>
>

<ROUTINE RT-LEAVE-STONE ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<COND
			;	(<EQUAL? ,P-WALK-DIR ,P?SE>
					<RETURN ,RM-CHURCH>
				)
				(T
					<RETURN ,RM-CHURCHYARD>
				)
			>
		)
		(<IN? ,WINNER ,TH-BEHIND-G-STONE>
			<SETG GL-HIDING <>>
			<MOVE ,WINNER ,RM-CHURCHYARD>
			<TELL The+verb ,WINNER "step" " out from behind" the ,TH-GRAVESTONE>
		;	<COND
				(<EQUAL? ,P-WALK-DIR ,P?SE>
					<TELL " and" verb ,WINNER "enter" the ,RM-CHURCH>
				)
			>
			<TELL "." CR>
			<SETG GL-PICTURE-NUM ,K-PIC-CHURCHYARD>
			<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
			<COND
			;	(<EQUAL? ,P-WALK-DIR ,P?SE>
					<CRLF>
					<RT-DO-WALK ,P?EAST>
				)
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
					<RT-UPDATE-DESC-WINDOW>
				)
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>
					<RT-UPDATE-MAP-WINDOW>
				)
			>
		)
		(T
			<V-WALK>
		)
	>
	<RFALSE>
>

;"---------------------------------------------------------------------------"
; "LG-CHURCH-GATE"
;"---------------------------------------------------------------------------"

<OBJECT LG-CHURCH-GATE
	(LOC LOCAL-GLOBALS)
	(DESC "gate")
	(FLAGS FL-DOOR FL-NO-DESC FL-OPENABLE FL-TRANSPARENT)
	(SYNONYM GATE DOOR)
	(ADJECTIVE IRON CHURCH CHURCHYARD)
	(ACTION RT-LG-CHURCH-GATE)
>

<CONSTANT K-GATE-CREAKS-MSG "The gate creaks as it swings">

<ROUTINE RT-LG-CHURCH-GATE ("OPT" (CONTEXT <>))
	<COND
		(<VERB? EXAMINE>
			<FSET ,LG-CHURCH-GATE ,FL-SEEN>
			<TELL
"It is an elaborate wrought-iron gate that is" open ,LG-CHURCH-GATE "." CR
			>
		)
		(<VERB? OPEN>
			<COND
				(<RT-IS-QUEUED? ,RT-I-SOLDIER-1>
					<TELL "A noise makes you hesitate.|">
					<RT-DEQUEUE ,RT-I-SOLDIER-1>
					<RT-I-SOLDIER-1>
				)
				(<FSET? ,LG-CHURCH-GATE ,FL-OPEN>
					<RT-ALREADY-MSG ,LG-CHURCH-GATE "open">
				)
				(T
					<FSET ,LG-CHURCH-GATE ,FL-OPEN>
					<TELL ,K-GATE-CREAKS-MSG open ,LG-CHURCH-GATE>
					<COND
						(<RT-IS-QUEUED? ,RT-I-SOLDIER-2>
							<TELL
", and you come face-to-face with a group of Lot's soldiers." ,K-ARREST-MSG
							>
							<RT-END-OF-GAME>
						)
						(T
							<TELL "." CR>
						)
					>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>
							<RT-UPDATE-MAP-WINDOW>
						)
					>
					<RTRUE>
				)
			>
		)
		(<VERB? CLOSE>
			<COND
				(<NOT <FSET? ,LG-CHURCH-GATE ,FL-OPEN>>
					<RT-ALREADY-MSG ,LG-CHURCH-GATE "closed">
				)
				(T
					<FCLEAR ,LG-CHURCH-GATE ,FL-OPEN>
					<TELL ,K-GATE-CREAKS-MSG open ,LG-CHURCH-GATE "." CR>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>
							<RT-UPDATE-MAP-WINDOW>
						)
					>
					<RTRUE>
				)
			>
		)
		(<VERB? ENTER>
			<COND
				(<MC-HERE? ,RM-CHURCHYARD>
					<RT-DO-WALK ,P?SOUTH>
				)
				(<MC-HERE? ,RM-TOWN-SQUARE>
					<RT-DO-WALK ,P?NORTH>
				)
			>
		)
      (<VERB? CLIMB-UP CLIMB-ON CLIMB-OVER>
			<TELL The ,LG-CHURCH-GATE " is too high to " vw "." CR>
      )
	>
>

<CONSTANT K-ARREST-MSG
" They seize you immediately and arrest you for violating the curfew. Then
they drag you through the streets to the castle, where they toss you into a
dungeon and forget about you.|">

<ROUTINE RT-SEIZE-MSG (PERSON)
	<TELL "As soon as you draw attention to yourself,">
	<COND
		(<EQUAL? .PERSON ,CH-SOLDIERS>
			<TELL
the+verb .PERSON "seize" " you and" verb .PERSON "drag" " you off
to the castle, where they leave you to rot in the dungeon." CR
			>
		)
		(T
			<TELL the .PERSON>
			<COND
				(<MC-FORM? ,K-FORM-ARTHUR>
					<TELL ,K-GUARDS-COME-MSG>
					<RT-OVERPOWER-MSG>
				)
				(T
					<TELL " says," ,K-LOVERLY-MSG form ,K-SKEWER-MSG>
				)
			>
		)
	>
	<RT-END-OF-GAME>
>

<ROUTINE RT-I-SOLDIER-1 ()
	<RT-QUEUE ,RT-I-SOLDIER-2 <+ ,GL-MOVES 1>>
	<TELL
"|From down the street you hear the sound of approaching voices. It sounds
like soldiers. Suddenly, you remember the curfew." CR
	>
>

<ROUTINE RT-I-SOLDIER-2 ()
	<MOVE ,CH-SOLDIERS ,RM-TOWN-SQUARE>
;	<FSET ,CH-SOLDIERS ,FL-NO-DESC>
	<RT-QUEUE ,RT-I-SOLDIER-3 <+ ,GL-MOVES 1>>
	<TELL "|You hear steps outside the gate">
	<COND
		(<MC-HERE? ,RM-CHURCHYARD>
			<TELL " and see moonlight glinting off soldiers' helmets">
		)
	>
	<TELL ". A voice calls out, \"Search the church.\"">
	<COND
		(<AND <IN? ,CH-PLAYER ,TH-BEHIND-G-STONE>
				<NOT <EQUAL? ,GL-HIDING ,TH-GRAVESTONE>>
			>
			<TELL " You drop to the ground.">
			<SETG GL-HIDING ,TH-GRAVESTONE>
			<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
					<RT-UPDATE-DESC-WINDOW>
				)
			>
		)
		(<MC-HERE? ,RM-CHURCH>
			<TELL " You look around quickly but see no place to hide.">
		)
	>
	<CRLF>
	<RTRUE>
>

<ROUTINE RT-I-SOLDIER-3 ()
	<MOVE ,CH-SOLDIERS ,RM-CHURCHYARD>
	<FCLEAR ,CH-SOLDIERS ,FL-NO-DESC>
	<RT-QUEUE ,RT-I-SOLDIER-4 <+ ,GL-MOVES 2>>
	<CRLF>
	<COND
		(<NOT <FSET? ,LG-CHURCH-GATE ,FL-OPEN>>
			<FSET ,LG-CHURCH-GATE ,FL-OPEN>
			<COND
				(<MC-HERE? ,RM-CHURCH>
					<TELL
"From out in the churchyard, you hear the sound of the church gate creaking"
 					>
				)
				(T
		 			<TELL ,K-GATE-CREAKS-MSG>
				)
			>
			<TELL open ,LG-CHURCH-GATE>
		)
	>
	<COND
		(<EQUAL? ,GL-HIDING ,TH-GRAVESTONE>
			<TELL
". Peering around the base of the stone, you see a group of soldiers enter"
the ,RM-CHURCHYARD ". Two of them disappear briefly into the church. They
report back to their captain, who gives the all-clear signal to someone
waiting outside the gate." CR
			>
		)
		(<MC-HERE? ,RM-CHURCHYARD>
			<TELL
", and a group of soldiers enters" the ,RM-CHURCHYARD "." ,K-ARREST-MSG
			>
			<RT-END-OF-GAME>
		)
		(<MC-HERE? ,RM-CHURCH>
			<TELL
". Two soldiers enter the church and discover you." ,K-ARREST-MSG
			>
			<RT-END-OF-GAME>
		)
	>
	<FCLEAR ,CH-SOLDIERS ,FL-PLURAL>
	<MOVE ,TH-STONE ,TH-BOAT>
	<FCLEAR ,LG-CHURCH-GATE ,FL-OPEN>
	<TELL
"|Suddenly, the evil King Lot strides through the gate, followed by four
soldiers wheeling a sturdy cart. \"There it is!\" Lot snaps, gesturing
angrily at the stone. \"Load it up. Quickly!\" The soldiers gather around
the stone and strain against its massive weight. They tilt it up, and then
slide the cart beneath it.||\"One of you stay here,\" Lot commands. \"Let no
one enter until we return in the morning. The rest of you, follow me.\" Lot
turns and marches out of the churchyard, followed at a distance by the men
pushing the heavy cart. One soldier remains behind to guard the gate.|"
	>
	<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC ,K-UPD-OBJS>>
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

<ROUTINE RT-I-SOLDIER-4 ("AUX" N)
	<FSET ,CH-PLAYER ,FL-ASLEEP>
	<COND
		(,GL-CLK-RUN
			<CRLF>
		)
	>
	<TELL
"You settle down to a long vigil of waiting. Despite the excitement of the
evening, you soon become drowsy and fall asleep.|"
	>
	; "Set time to 09:00"
	<SET N <- 540 <MOD ,GL-MOVES 1440>>>
	<COND
		(<L? .N 0>
			<SET N <+ .N 1440>>
		)
	>
	<SETG GL-MOVES <+ ,GL-MOVES .N>>
	<RT-QUEUE ,RT-I-LOT ,GL-MOVES>
	<RTRUE>
>

<ROUTINE RT-I-LOT ("AUX" N)
	<REMOVE ,CH-SOLDIERS>
	<FCLEAR ,CH-PLAYER ,FL-ASLEEP>
	<SET N <- 1325 <MOD ,GL-MOVES 1440>>>
	<COND
		(<L? .N 0>
			<SET N <+ .N 1440>>
		)
	>
	<RT-QUEUE ,RT-I-SLEEP <+ ,GL-MOVES .N>>
	<RT-QUEUE ,RT-I-HUNGER <+ ,GL-MOVES 15>>
	<SETG GL-SLEEP 0>
	<SETG GL-HUNGER 1>
	<TELL
"|Hours later you are awakened by the sound of the church bell ringing. A
crowd is gathering in the churchyard, and King Lot is standing on the steps
of the church. Above his head, he brandishes a jewelled sword that looks
exactly like the sword that was imbedded in the stone.||\"See,\" he shouts,
\"I have the magic sword! I had a vision that told me to come here at
midnight. When I arrived, the stone was surrounded by angels. They told me
that Uther's son was dead and that I was to be the new High King. Humbly, I
grasped the sword and lo, it came up into my hand. Suddenly there came a
beam of bright light and a rush of wind. Despite its great weight, the
stone was miraculously drawn up by the beam, and it disappeared into
heaven!\"||\"Three days hence - at noon on Christmas day - shall I be
coronated on this very spot. If any man dares to contest my claim, let him
come to my hall and challenge me in the traditional manner of knighthood,
and I will do battle with him.\"||At this last pronouncement, the crowd
cheers and rushes toward Lot. His guards clear a path for him to the church
gate, and he leaves the churchyard in triumph, surrounded by the cheering
mob. Soon no one is left nearby, and once again you find yourself alone.|"
	>
	<RT-SCORE-MSG 0 0 5 2>
	<FSET ,LG-CHURCH-GATE ,FL-OPEN>
	<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-OBJS>>
	<COND
		(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
			<RT-UPDATE-DESC-WINDOW>
		)
	>
	<RTRUE>
>

;"---------------------------------------------------------------------------"
; "RM-CHURCH"
;"---------------------------------------------------------------------------"

<ROOM RM-CHURCH
	(LOC ROOMS)
	(DESC "church")
	(FLAGS FL-INDOORS FL-LIGHTED)
	(SYNONYM CHURCH BUILDING)
	(WEST TO RM-CHURCHYARD)
	(OUT TO RM-CHURCHYARD)
;	(NW PER RT-BEHIND-STONE)
	(GLOBAL LG-WALL RM-CHURCHYARD)
	(ACTION RT-RM-CHURCH)
	(THINGS
		(WOOD WOODEN) (BENCH BENCHES) RT-PS-BENCHES
		<> (WINDOW WINDOWS) RT-PS-WINDOW
	)
>

<ROUTINE RT-RM-CHURCH ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-CHURCH>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "You are" standing " in the church.">
				)
				(T
					<TELL The ,WINNER walk " up the steps and into the church.">
				)
			>
			<FSET ,TH-ALTAR ,FL-SEEN>
			<TELL
" It is a simple, one-room building with only a few rough-hewn wooden
benches facing an altar. The only exit is to the west.|"
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<AND <VERB? KNEEL>
						<MC-PRSO? <> ,ROOMS ,HERE ,GLOBAL-HERE ,TH-ALTAR>
					>
					<TELL The+verb ,WINNER "kneel" " for a moment">
					<COND
						(<NOT <FSET? ,CH-PLAYER ,FL-BROKEN>>
							<TELL "," verb ,WINNER "mutter" " a brief prayer,">
						)
					>
					<TELL " and then" verb ,WINNER "resume" " standing.|">
					<COND
						(<FSET? ,CH-PLAYER ,FL-BROKEN>
							<RT-AUTHOR-MSG "Let's not overdo the chivalry bit.">
						)
						(T
							<FSET ,CH-PLAYER ,FL-BROKEN>
							<RT-SCORE-MSG 10 0 0 0>
						)
					>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,RM-CHURCH ,FL-SEEN>
			<COND
				(<NOT <MC-HERE? ,RM-CHURCH>>
					<TELL
"It is a simple, stone building that was built long ago and is now falling
into disrepair." CR
					>
				)
			>
		)
	>
>

<ROUTINE RT-PS-BENCHES ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
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
					<TELL "benches">
				)
			>
		)
		(<VERB? EXAMINE LOOK-ON>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<TELL
"The benches seats all tilt forward. They look very uncomfortable." CR
			>
		)
		(<VERB? PUT SIT LIE-DOWN>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<TELL
"The bench seats all tilt forward. " The ,WINNER " can't "
			>
			<COND
				(<VERB? PUT>
					<TELL "put anything">
				)
				(T
					<TELL vw " down">
				)
			>
			<TELL " on them." CR>
		)
		(<VERB? TAKE>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<RT-YOU-CANT-MSG "take">
			<SETG GL-QUESTION 1>
			<RT-AUTHOR-MSG ,K-HEATHEN-MSG>
		)
	>
>

<CONSTANT K-HEATHEN-MSG "What kind of heathen would try to steal from a church?">

;"---------------------------------------------------------------------------"
; "TH-ALTAR"
;"---------------------------------------------------------------------------"

<OBJECT TH-ALTAR
	(LOC RM-CHURCH)
	(DESC "altar")
	(FLAGS FL-NO-DESC FL-SEARCH FL-SURFACE FL-TRY-TAKE FL-VOWEL)
	(SYNONYM ALTAR)
	(CAPACITY 50)
	(ACTION RT-TH-ALTAR)
>

<ROUTINE RT-TH-ALTAR ("OPT" (CONTEXT <>))
	<COND
		(<VERB? EXAMINE LOOK-ON>
			<COND
				(<SEE-ANYTHING-IN? ,TH-ALTAR>
					<RFALSE>
				)
				(T
					<FSET ,TH-ALTAR ,FL-SEEN>
					<TELL The ,TH-ALTAR " is bare." CR>
				)
			>
		)
		(<VERB? TAKE>
			<RT-YOU-CANT-MSG "take">
			<SETG GL-QUESTION 1>
			<RT-AUTHOR-MSG ,K-HEATHEN-MSG>
		)
	>
>

<GLOBAL HERE:OBJECT RM-CHURCHYARD>
<GLOBAL OHERE:OBJECT <>>

<GLOBAL GL-HIDING:OBJECT <>>

;"---------------------------------------------------------------------------"
; "TH-TUNIC"
;"---------------------------------------------------------------------------"

<OBJECT TH-TUNIC
	(LOC CH-PLAYER)
	(DESC "tunic")
	(FLAGS FL-CLOTHING FL-NO-ALL FL-TRY-TAKE FL-WORN FL-YOUR)
	(SYNONYM TUNIC SHIRT)
	(ADJECTIVE LEATHER)
	(OWNER CH-PLAYER)
	(ACTION RT-TH-TUNIC)
>

<CONSTANT K-UNDRESS-MSG
"You hear Merlin's voice echo from a previous lesson: \"It is not seeming
to venture forth unclothed, Arthur.\"|">

<ROUTINE RT-TH-TUNIC ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<RFALSE>
		)
		(<VERB? TAKE UNWEAR DROP THROW PUT PUT-IN>
			<TELL ,K-UNDRESS-MSG>
		)
		(<VERB? EXAMINE LOOK-ON>
			<FSET ,TH-TUNIC ,FL-SEEN>
			<TELL "It is a simple leather tunic." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-BREECHES"
;"---------------------------------------------------------------------------"

<OBJECT TH-BREECHES
	(LOC CH-PLAYER)
	(DESC "breeches")
	(FLAGS FL-CLOTHING FL-NO-ALL FL-PLURAL FL-TRY-TAKE FL-WORN FL-YOUR)
	(SYNONYM BREECHES PANTS TROUSERS)
	(ADJECTIVE CLOTH)
	(OWNER CH-PLAYER)
	(ACTION RT-TH-BREECHES)
>

<ROUTINE RT-TH-BREECHES ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<RFALSE>
		)
		(<VERB? TAKE UNWEAR DROP THROW PUT PUT-IN>
			<TELL ,K-UNDRESS-MSG>
		)
		(<VERB? EXAMINE LOOK-ON>
			<FSET ,TH-BREECHES ,FL-SEEN>
			<THIS-IS-IT ,TH-BREECHES>
			<TELL "They are simple cloth breeches." CR>
		)
	>
>


;"---------------------------------------------------------------------------"
; "TH-GLASS"
;"---------------------------------------------------------------------------"

<OBJECT TH-GLASS
	(LOC CH-PLAYER)
	(DESC "red piece of glass")
	(FLAGS FL-TAKEABLE)
	(SYNONYM GLASS PIECE)
	(ADJECTIVE RED)
	(OWNER TH-GLASS)
	(SIZE 1)
	(ACTION RT-TH-GLASS)
>

<ROUTINE RT-TH-GLASS ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE LOOK-ON>
			<FSET ,TH-GLASS ,FL-SEEN>
			<TELL "It's just a bauble you picked up somewhere." CR>
		)
		(<VERB? LOOK-THRU>
			<TELL
"When you peer through the glass, everything looks distorted and red." CR
			>
		)
	>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

