;"***************************************************************************"
; "game : Arthur"
; "file : CELL.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   16 May 1989  1:23:12  $"
; "revs : $Revision:   1.104  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Cell puzzle"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "RM-CELL"
;"---------------------------------------------------------------------------"

<ROOM RM-CELL
	(LOC ROOMS)
	(DESC "cell")
	(FLAGS FL-INDOORS FL-LIGHTED)
	(SYNONYM CELL DUNGEON)
	(NORTH TO RM-HALL IF LG-CELL-DOOR IS OPEN)
	(OUT PER RT-CELL-OUT)
	(WEST PER RT-ENTER-HOLE)
	(IN PER RT-ENTER-HOLE)
	(SCORE <ORB <LSH 2 ,K-WISD-SHIFT> <LSH 2 ,K-QUEST-SHIFT>>)
	(ADJACENT <TABLE (LENGTH BYTE) RM-HALL <>>)
	(GLOBAL LG-CELL-DOOR LG-WALL RM-HALL RM-HOLE ;RM-BADGER-TUNNEL)
	(ACTION RT-RM-CELL)
>

<ROUTINE RT-RM-CELL ("OPT" (CONTEXT <>) "AUX" N)
	<COND
      (<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<TELL "You ">
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "are">
				)
				(<MC-CONTEXT? ,M-F-LOOK>
					<TELL
"crawl through the hole in the wall and plop to the ground on the other side.
You find yourself"
					>
				)
				(T
					<TELL "find yourself">
				)
			>
			<FSET ,LG-CELL-DOOR ,FL-SEEN>
			<TELL
" in a dank, cramped cell far below Lot's castle. The room was originally
used by the Romans for food storage, but someone converted it into a miserable
dungeon by bolting chains to the clammy stone walls." CR CR

"There is a cell door of stout wood to the north"
			>
			<COND
				(<NOT <FSET? ,TH-CELL-STONE ,FL-LOCKED>>
					<TELL
", and a hole in the wall to the west where a stone has been pushed out"
		         >
				)
			>
			<TELL ".">
			<COND
				(<FSET? ,CH-PRISONER ,FL-LOCKED>
					<FSET ,CH-PRISONER ,FL-SEEN>
					<TELL " " A ,CH-PRISONER " is chained to the wall.">
				)
			>
			<COND
				(<AND <IN? ,CH-CELL-GUARD ,RM-CELL>
						<FSET? ,CH-CELL-GUARD ,FL-ASLEEP>
					>
					<TELL " " A ,CH-CELL-GUARD " is lying unconscious on the floor.">
				)
			>
			<CRLF>
			<RFALSE>
      )
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<VERB? YELL>
					<COND
						(<MC-FORM? ,K-FORM-ARTHUR>
							<RT-CALL-GUARD>
						)
					>
				)
				(<AND <VERB? PUT-IN>
						<MC-PRSI? ,LG-WALL>
						<NOT <FSET? ,TH-CELL-STONE ,FL-LOCKED>>
					>
					<PERFORM ,PRSA ,PRSO ,RM-HOLE>
					<RTRUE>
				)
				(<AND <VERB? WAIT>
						<MC-PRSO? ,CH-CELL-GUARD>
					>
					<COND
						(<SET N <RT-IS-QUEUED? ,RT-I-ALARM>>
							<SET N <- .N GL-MOVES>>
						)
						(T
							<SET N <- 182 <MOD ,GL-MOVES 180>>>
						)
					>
					<COND
						(<G? .N 0>
							<SETG GL-MOVES <+ ,GL-MOVES <- .N 1>>>
							<TELL ,K-TIME-PASSES-MSG CR>
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<COND
				(<AND <IN? ,CH-PRISONER ,RM-CELL>
						<FSET? ,CH-PRISONER ,FL-LOCKED>
					>
					<SETG GL-PICTURE-NUM ,K-PIC-CELL-PRISONER>
				)
				(T
					<SETG GL-PICTURE-NUM ,K-PIC-CELL>
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
				(<AND <IN? ,CH-PRISONER ,RM-CELL>
						<NOT <FSET? ,CH-PRISONER ,FL-LOCKED>>
					>
					<RT-SET-PUPPY ,CH-PRISONER>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? OPEN>
			<PERFORM ,PRSA ,LG-CELL-DOOR>
			<RTRUE>
		)
	>
>

<ROUTINE RT-CELL-OUT ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<RETURN ,RM-HALL>
		)
		(<EQUAL? ,GL-HIDING ,LG-CELL-DOOR>
			<SETG GL-HIDING <>>
			<TELL The+verb ,WINNER "step" " out from behind" the ,LG-CELL-DOOR "." CR>
			<RFALSE>
		)
		(<FSET? ,LG-CELL-DOOR ,FL-OPEN>
			<RETURN ,RM-HALL>
		)
		(T
			<THIS-IS-IT ,LG-CELL-DOOR>
			<TELL The+verb ,LG-CELL-DOOR "are" "n't open.|">
			<RFALSE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-BEHIND-DOOR"
;"---------------------------------------------------------------------------"

<OBJECT TH-BEHIND-DOOR
	(LOC RM-CELL)
	(DESC "behind the door")
	(FLAGS FL-CONTAINER FL-NO-ARTICLE FL-NO-DESC FL-OPEN FL-SEARCH)
	(SOUTH PER RT-LEAVE-DOOR)
	(OUT PER RT-LEAVE-DOOR)
	(GLOBAL LG-CELL-DOOR LG-WALL RM-CELL)
	(CAPACITY K-CAP-MAX)
	(ACTION RT-TH-BEHIND-DOOR)
>

<ROUTINE RT-TH-BEHIND-DOOR ("OPT" (CONTEXT <>) "AUX" L)
	<COND
		(<MC-CONTEXT? ,M-BEG>
			<COND
			;	(<AND <VERB? TELL>
						,P-CONT
					>
					<RFALSE>
				)
				(<AND <VERB? ATTACK BREAK>
						<MC-PRSO? ,CH-CELL-GUARD>
						<NOT <FSET? ,CH-CELL-GUARD ,FL-ASLEEP>>
					>
					<RFALSE>
				)
				(<AND <IN? ,CH-CELL-GUARD ,RM-CELL>
						<NOT <FSET? ,CH-CELL-GUARD ,FL-ASLEEP>>
						<UNHIDE-VERB?>
					>
					<RT-SEIZE-MSG ,CH-CELL-GUARD>
				)
				(<OR	<AND
							<VERB? PUT-IN>
							<MC-PRSI? ,RM-CELL>
						>
						<AND
							<VERB? THROW>
							<IN? ,PRSI ,RM-CELL>
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
							<MOVE ,PRSO ,RM-CELL>
							<TELL
The+verb ,WINNER "toss" the ,PRSO " into" the ,RM-CELL "." CR
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
										(<MC-PRSO? ,LG-CELL-DOOR>
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
										(<MC-PRSI? ,LG-CELL-DOOR>
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
				(<AND <IN? ,CH-CELL-GUARD ,RM-CELL>
						<NOT <FSET? ,CH-CELL-GUARD ,FL-ASLEEP>>
						<VERB? TRANSFORM>
						<NOT <MC-FORM? ,GL-OLD-FORM>>
						<MC-FORM? ,K-FORM-ARTHUR>
					>
					<RT-SEIZE-MSG ,CH-CELL-GUARD>
				)
			>
		)
	>
>

<ROUTINE RT-BEHIND-DOOR ("OPT" (QUIET <>) "AUX" (HIDE <>))
	<COND
		(.QUIET
			<RFALSE>
		)
		(<IN? ,WINNER ,TH-BEHIND-DOOR>
			<RT-ALREADY-MSG ,WINNER "behind the cell door">
		)
		(T
			<MOVE ,WINNER ,TH-BEHIND-DOOR>
			<SETG GL-HIDING ,LG-CELL-DOOR>
			<TELL "You flatten yourself up against the cold stone wall">
			<COND
				(<MC-FORM? ,K-FORM-ARTHUR>
					<TELL ".">
				)
				(T
					<TELL ", as much as" aform " can flatten itself.">
				)
			>
			<CRLF>
		)
	>
	<RFALSE>
>

<ROUTINE RT-LEAVE-DOOR ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<RETURN ,RM-CELL>
		)
		(<IN? ,WINNER ,TH-BEHIND-DOOR>
			<SETG GL-HIDING <>>
			<MOVE ,WINNER ,RM-CELL>
			<TELL
The+verb ,WINNER "step" " out from behind" the ,LG-CELL-DOOR "." CR
			>
			<RFALSE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "CH-PRISONER"
;"---------------------------------------------------------------------------"

<OBJECT CH-PRISONER
	(LOC RM-CELL)
	(DESC "prisoner")
	(FLAGS FL-ALIVE FL-LOCKED FL-OPEN FL-PERSON FL-SEARCH FL-NO-LIST)
	(SYNONYM PRISONER MAN PERSON SMITH BLACKSMITH CRAFTSMAN CASSO)
	(ADJECTIVE DIRTY TIRED CHAINED CAPTIVE)
	(ACTION RT-CH-PRISONER)
	(CONTFCN RT-CH-PRISONER)
>

; "CH-PRISONER flags:"
; "	FL-AIR - Player has brought prisoner out of kitchen"
; "	FL-BROKEN - Slave has made comment re xformation"
; "	FL-LOCKED - Slave is chained to wall in cell"

<CONSTANT K-TAKE-SMITH-HELMET-MSG
" says, \"If I give it to you, someone might recognize me.\"|">

<ROUTINE RT-CH-PRISONER ("OPT" (CONTEXT <>))
	<COND
		(<AND <VERB? HELLO GOODBYE THANK>
				<MC-CONTEXT? ,M-WINNER <>>
			>
			<COND
				(<VERB? HELLO>
					<TELL "\"Hello, enchanted one.\"" CR>
				)
				(<VERB? GOODBYE>
					<TELL
"\"Please don't leave me here. They are sure to kill me.\"" CR
					>
				)
				(<VERB? THANK>
					<TELL
"\"I've done nothing to earn your thanks, sir. But you're welcome just the
same.\"|"
					>
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
				(<AND <MC-HERE?
							,RM-CELL
							,RM-BOTTOM-OF-STAIRS
							,RM-HALL
							,RM-END-OF-HALL
							,RM-SMALL-CHAMBER
						>
						<OR
							<VERB? YELL>
							<AND
								<VERB? CALL>
								<MC-PRSO? ,CH-CELL-GUARD ,CH-SOLDIERS>
							>
						>
					>
					<RT-CALL-GUARD>
				)
				(<AND <VERB? TAKE WEAR>
						<MC-PRSO? ,TH-HELMET>
					>
					<RT-SMITH-HELMET-MSG>
				)
				(<AND <IN? ,TH-HELMET ,CH-PRISONER>
						<VERB? GIVE GIVE-SWP>
						<EQUAL? ,TH-HELMET ,PRSO ,PRSI>
						<EQUAL? ,CH-PLAYER ,PRSO ,PRSI>
					>
					<TELL "The smith" ,K-TAKE-SMITH-HELMET-MSG>
				)
				(T
					<TELL
"The man is so much in awe of you that he gets tongue-tied and can't answer.|"
					>
					<RFATAL>
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
						(<MC-PRSO? ,TH-MASTER-KEY>
							<COND
								(<FSET? ,CH-PRISONER ,FL-LOCKED>
									<TELL
The ,CH-PRISONER " can't use" the ,TH-MASTER-KEY ". " His ,CH-PRISONER
" hands are shackled." CR
									>
								)
							>
						)
						(<OR	<MC-PRSO? ,TH-SHIELD ,TH-ARMOUR ,TH-BROKEN-DAGGER>
								<AND
									<MC-PRSO? ,PSEUDO-OBJECT>
									<EQUAL? ,LAST-PSEUDO-LOC ,RM-ARMOURY>
								>
							>
							<RT-SMITH-EVALUATE-MSG ,PRSO>
						)
						(<MC-PRSO? ,TH-HELMET>
							<RT-SMITH-HELMET-MSG>
						)
					>
				)
			>
		)
		(<AND <VERB? TELL>
				,P-CONT
			>
		; "Message and RFATAL if don't want prisoner to become winner"
			<RFALSE>
		)
		(<VERB? ASK-ABOUT>
			<COND
				(<AND <MC-PRSI? ,TH-TIME>
						<NOUN-USED? ,PRSI ,W?CHRISTMAS ,W?XMAS>
					>
					<TELL
"\"I really enjoying decking the halls, but I'm not too wild about the gay
apparel.\"" CR
					>
				)
				(<OR	<AND <MC-PRSI? ,GLOBAL-HERE> <MC-HERE? ,RM-CELL>>
						<MC-PRSI? ,RM-CELL ,CH-SOLDIERS ,CH-CELL-GUARD
							,LG-CELL-DOOR ,TH-TIME ,TH-MASTER-KEY
						>
						<NOUN-USED? ,PRSI ,W?FOOD>
					>
					<COND
						(<NOT <FSET? ,CH-PRISONER ,FL-LOCKED>>
							<TELL
"\"I was blindfolded when they arrested me. I cannot tell you anything
more.\"" CR
							>
						)
						(T
							<TELL
"\"A guard comes to look at me when the bells ring. Or if I shout, sometimes
he will come.\"" CR
							>
						)
					>
				)
				(<MC-PRSI? ,CH-LOT ,TH-SWORD ,TH-EXCALIBUR>
					<TELL
"\"King Lot came to me and asked me to fashion a sword in the likeness of the
famous sword in the stone. He told me it was to be a gift to the new High
King, whoever that may be. But when I completed it, he imprisoned me in this
cell.\"" CR
					>
				)
				(<MC-PRSI? ,CH-PRISONER>
					<TELL "\"I am but a humble craftsman.\"" CR>
				)
				(<MC-PRSI? ,RM-SMITHY>
					<TELL
"\"It must have become abandoned since I was imprisoned.\"" CR
					>
				)
				(<OR	<MC-PRSI? ,TH-SHIELD ,TH-ARMOUR ,TH-BROKEN-DAGGER>
						<AND
							<MC-PRSI? ,PSEUDO-OBJECT>
							<EQUAL? ,LAST-PSEUDO-LOC ,RM-ARMOURY>
						>
					>
					<RT-SMITH-EVALUATE-MSG ,PRSI>
				)
				(<MC-PRSI? ,CH-MERLIN>
					<TELL
"\"In the town, they say he has made a pact with the devil. But I have never
heard of him doing evil.\"" CR
					>
				)
				(<MC-PRSI? ,TH-NAME>
					<TELL "\"My name is Casso.\"" CR>
				)
				(<MC-PRSI? ,TH-MASTER>
					<TELL "\"I have no master.\"" CR>
				)
				(<MC-PRSI? ,TH-CHAINS ,TH-PADLOCK>
					<COND
						(<FSET? ,CH-PRISONER ,FL-LOCKED>
							<TELL
"His head droops in despair. \"Finest quality,\" he mumbles. \"Cannot be
broken.\"" CR
							>
						)
						(T
							<TELL
"The prisoner shudders and says, \"Now that you have freed me, I don't
even want to think about such things.\"" CR
							>
						)
					>
				)
				(<MC-PRSI? ,TH-PUMICE>
					<TELL
"\"I use pumice all the time. There's nothing like it to make an old weapon
look like new.\"" CR
					>
				)
				(<MC-PRSI? ,TH-HELMET>
					<TELL
"\"It's a perfect disguise. No one will recognize me.\"" CR
					>
				)
				(T
					<TELL "\"I know nothing about">
					<COND
						(<FSET? ,PRSI ,FL-PERSON>
							<TELL him ,PRSI>
						)
						(T
							<TELL " that">
						)
					>
					<TELL ".\"" CR>
				)
			>
		)
		(<VERB? ASK-FOR>
			<COND
				(<AND <MC-PRSI? ,TH-HELMET>
						<IN? ,TH-HELMET ,CH-PRISONER>
					>
					<TELL "The smith" ,K-TAKE-SMITH-HELMET-MSG>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,CH-PRISONER ,FL-SEEN>
			<COND
				(<FSET? ,CH-PRISONER ,FL-LOCKED>
					<TELL
"The prisoner's wrists are crossed and bound together by a chain. The chain is
fastened with a large padlock." CR
					>
				)
				(T
					<TELL
The+verb ,CH-PRISONER "look" " grateful that you have freed him, but worried
about how you will manage your escape from the castle." CR
					>
				)
			>
		)
		(<VERB? RELEASE>
			<COND
				(<NOT <FSET? ,CH-PRISONER ,FL-LOCKED>>
					<RFALSE>
				)
				(<IN? ,TH-MASTER-KEY ,WINNER>
					<RT-FREE-PRISONER-MSG>
				)
				(T
					<SETG CLOCK-WAIT T>
					<RT-AUTHOR-MSG ,K-HOW-INTEND-MSG>
				)
			>
		)
		(<VERB? UNLOCK>
			<COND
				(<AND <FSET? ,CH-PRISONER ,FL-LOCKED>
						<MC-PRSI? ,TH-MASTER-KEY>
					>
					<RT-FREE-PRISONER-MSG>
				)
			>
		)
		(<VERB? KNEEL>
			<TELL "The prisoner bows in return." CR>
		)
		(<VERB? TALK-TO>
			<TELL "The prisoner babbles a few incoherent words in response." CR>
		)
		(<VERB? ATTACK>
			<COND
				(<MC-FORM? ,K-FORM-ARTHUR>
					<TELL "You launch an attack against the prisoner, but">
					<COND
						(<FSET? ,CH-PRISONER ,FL-LOCKED>
							<TELL " even though he is chained,">
						)
					>
					<TELL " you are no match for his superior strength. He">
					<COND
						(<FSET? ,CH-PRISONER ,FL-LOCKED>
							<TELL " wraps a chain around your throat and">
						)
					>
					<TELL " strangles you to death." CR>
					<RT-END-OF-GAME>
				)
			>
		)
	>
>

<ROUTINE RT-FREE-PRISONER-MSG ()
	<FCLEAR ,TH-CHAINS ,FL-LOCKED>
	<FCLEAR ,TH-PADLOCK ,FL-LOCKED>
	<FSET ,TH-CHAINS ,FL-OPEN>
	<FSET ,TH-PADLOCK ,FL-OPEN>
	<FCLEAR ,CH-PRISONER ,FL-LOCKED>
	<RT-SET-PUPPY ,CH-PRISONER>
	<SETG GL-PICTURE-NUM ,K-PIC-CELL>
	<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
	<TELL
"You unlock the padlock. The prisoner struggles to his feet and looks
at you gratefully. \"Thank you, kind sir,\" he says. \"Let us escape from
here together.\"|"
	>
	<RT-SCORE-MSG 10 0 0 0>
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

<ROUTINE RT-SMITH-EVALUATE-MSG (OBJ)
	<COND
		(<VISIBLE? .OBJ>
			<TELL
"The smith eyes" the .OBJ " professionally and says, "
			>
		)
	>
	<COND
		(<EQUAL? .OBJ ,PSEUDO-OBJECT>
			<COND
				(<NOUN-USED? ,PSEUDO-OBJECT ,W?SHIELD ,W?SHIELDS>
					<TELL
"\"They're not top quality, but I suppose they're good enough for government
work.\"" CR
					>
				)
				(T		;"Pikestaffs"
					<TELL
"\"They're imported from Gaul. You can tell by the inferior workmanship along
the shafts.\"" CR
					>
				)
			>
		)
		(<EQUAL? .OBJ ,TH-SHIELD>
			<TELL
"\"It's a perfectly good shield. They just haven't taken very good care of
it.\"" CR
			>
		)
		(<EQUAL? .OBJ ,TH-ARMOUR>
			<TELL
"\"The chap it was made for must be awfully small - about your size, I'd
say.\"" CR
			>
		)
		(<EQUAL? .OBJ ,TH-BROKEN-DAGGER>
			<TELL
"\"It's beyond repair. Even I couldn't fix it.\"" CR
			>
		)
	>
>

<ROUTINE RT-SMITH-HELMET-MSG ()
	<MOVE ,TH-HELMET ,CH-PRISONER>
	<FSET ,TH-HELMET ,FL-WORN>
	<TELL
"The smith puts on the helmet. It covers enough of his face to make a
suitable disguise." CR
	>
>

;"---------------------------------------------------------------------------"
; "TH-CELL-STONE"
;"---------------------------------------------------------------------------"

<OBJECT TH-CELL-STONE
	(LOC RM-CELL)
	(DESC "building stone")
	(FLAGS FL-TAKEABLE FL-LOCKED FL-NO-DESC)
	(SYNONYM STONE ROCK)
	(ADJECTIVE OLD BUILDING)
	(SIZE 5)
	(GENERIC RT-GN-STONE)
	(ACTION RT-TH-CELL-STONE)
>

; "TH-CELL-STONE flags:"
; "	FL-LOCKED - Stone is in wall"

<ROUTINE RT-TH-CELL-STONE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-CELL-STONE ,FL-SEEN>
			<TELL
"It's an old building stone whose corners are rounded with age." CR
			>
		)
		(<OR	<VERB? TAKE>
				<AND <VERB? MOVE> <VERB-WORD? ,W?PULL>>
			>
			<COND
				(<AND <FSET? ,TH-CELL-STONE ,FL-LOCKED>
						<MC-HERE? ,RM-CELL>
					>
					<COND
						(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
							<RT-ANIMAL-CANT-MSG>
						)
						(<RT-DO-TAKE ,TH-CELL-STONE>
							<FCLEAR ,TH-CELL-STONE ,FL-LOCKED>
							<TELL "You pull the loose stone out of the wall.|">
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
		(<VERB? MOVE EXTEND>
			<COND
				(<AND <MC-HERE? ,RM-CELL>
						<FSET? ,TH-CELL-STONE ,FL-LOCKED>
					>
					<TELL
"You push on the stone, but you can't seem to move it from this side." CR
					>
				)
			>
		)
		(<VERB? CLIMB-ON>
			<RT-WASTE-OF-TIME-MSG>
		)
		(<VERB? PUT>
			<COND
				(<VERB-WORD? ,W?DROP ,W?THROW ,W?HURL>
					<PERFORM ,V?BREAK ,PRSI ,PRSO>
					<RTRUE>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "LG-CELL-DOOR"
;"---------------------------------------------------------------------------"

<OBJECT LG-CELL-DOOR
	(LOC LOCAL-GLOBALS)
	(DESC "cell door")
	(FLAGS FL-AUTO-OPEN FL-DOOR FL-OPENABLE FL-LOCKED FL-NO-DESC)
	(SYNONYM DOOR LOCK KEYHOLE)
	(ADJECTIVE WOOD WOODEN CELL)
	(ACTION RT-LG-CELL-DOOR)
>

<ROUTINE RT-LG-CELL-DOOR ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,LG-CELL-DOOR ,FL-SEEN>
			<TELL "It is a massive wooden door that is ">
			<COND
				(<FSET? ,LG-CELL-DOOR ,FL-OPEN>
					<TELL "standing open">
				)
				(T
					<TELL "firmly closed">
				)
			>
			<TELL "." CR>
		)
		(<AND <VERB? HIDE-BEHIND>
				<MC-HERE? ,RM-CELL>
			>
			<RT-BEHIND-DOOR>
			<RTRUE>
		)
		(<VERB? ATTACK BREAK>
			<TELL The ,WINNER " can't break down the door." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-CHAINS"
;"---------------------------------------------------------------------------"

<OBJECT TH-CHAINS
	(LOC RM-CELL)
	(DESC "chains")
	(FLAGS FL-LOCKED FL-OPENABLE FL-PLURAL FL-TRY-TAKE FL-NO-DESC)
	(SYNONYM CHAIN CHAINS)
	(ADJECTIVE IRON)
	(OWNER CH-PRISONER)
	(ACTION RT-TH-CHAINS)
>

<ROUTINE RT-TH-CHAINS ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? TAKE MOVE>
			<THIS-IS-IT ,LG-WALL>
			<THIS-IS-IT ,TH-CHAINS>
			<TELL The ,TH-CHAINS " are firmly attached to the wall." CR>
		)
		(<AND <VERB? OPEN>
				<NOT <FSET? ,TH-CHAINS ,FL-LOCKED>>
				<FSET? ,CH-PRISONER ,FL-LOCKED>
			>
			<RT-FREE-PRISONER-MSG>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-CHAINS ,FL-SEEN>
			<THIS-IS-IT ,TH-CHAINS>
			<TELL "The chains are forged of the strongest iron." CR>
		)
		(<VERB? BREAK ATTACK>
			<THIS-IS-IT ,TH-CHAINS>
			<TELL The ,WINNER " can't break the chains." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-PADLOCK"
;"---------------------------------------------------------------------------"

<OBJECT TH-PADLOCK
	(LOC RM-CELL)
	(DESC "padlock")
	(FLAGS FL-LOCKED FL-OPENABLE FL-TRY-TAKE FL-NO-DESC)
	(SYNONYM LOCK PADLOCK KEYHOLE)
	(ADJECTIVE PAD IRON)
	(OWNER CH-PRISONER)
	(ACTION RT-TH-PADLOCK)
>

<ROUTINE RT-TH-PADLOCK ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? TAKE MOVE>
			<FSET ,TH-PADLOCK ,FL-SEEN>
			<THIS-IS-IT ,TH-CHAINS>
			<THIS-IS-IT ,TH-PADLOCK>
			<TELL The ,TH-PADLOCK " is firmly attached to" the ,TH-CHAINS "." CR>
		)
		(<AND <VERB? OPEN>
				<NOT <FSET? ,TH-CHAINS ,FL-LOCKED>>
				<FSET? ,CH-PRISONER ,FL-LOCKED>
			>
			<RT-FREE-PRISONER-MSG>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-CHAINS ,FL-SEEN>
			<THIS-IS-IT ,TH-PADLOCK>
			<TELL The ,TH-PADLOCK " is forged of the strongest iron." CR>
		)
		(<VERB? BREAK ATTACK>
			<FSET ,TH-CHAINS ,FL-SEEN>
			<THIS-IS-IT ,TH-PADLOCK>
			<TELL The ,WINNER " can't break" the ,TH-PADLOCK "." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-HELMET"
;"---------------------------------------------------------------------------"

<OBJECT TH-HELMET
	(LOC CH-CELL-GUARD)
	(DESC "helmet")
	(FLAGS FL-NO-LIST FL-TAKEABLE FL-WORN)
	(SYNONYM HELMET DENT)
	(ADJECTIVE DENTED)
	(OWNER CH-CELL-GUARD)
	(ACTION RT-TH-HELMET)
>

; "TH-HELMET flags:"
; "	FL-BROKEN = Helmet is dented."

<ROUTINE RT-TH-HELMET ("OPT" (CONTEXT <>) "AUX" L)
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<COND
				(<VERB? PUT-IN EMPTY>
					<RT-WASTE-OF-TIME-MSG>
				)
			>
		)
		(<AND <VERB? ATTACK BREAK>
				<FSET? ,TH-HELMET ,FL-WORN>
				<SET L <LOC ,TH-HELMET>>
				<FSET? .L ,FL-PERSON>
			>
			<PERFORM ,PRSA .L ,PRSI>
		)
		(<VERB? WEAR>
			<TELL "The helmet is much too big for you." CR>
		)
		(<VERB? EXAMINE>
			<TELL "It's a rather large helmet">
			<COND
				(<FSET? ,TH-HELMET ,FL-BROKEN>
					<TELL ", with a dent in it">
				)
			>
			<TELL "." CR>
		)
		(<AND <VERB? TAKE>
				<IN? ,TH-HELMET ,CH-PRISONER>
			>
			<TELL "The smith stops you and" ,K-TAKE-SMITH-HELMET-MSG>
		)
		(<VERB? FILL>
			<RT-WASTE-OF-TIME-MSG>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-GUARD-CLOTHES"
;"---------------------------------------------------------------------------"

<OBJECT TH-GUARD-CLOTHES
	(LOC CH-CELL-GUARD)
	(DESC "clothes")
	(FLAGS FL-NO-DESC FL-TRY-TAKE FL-WORN)
	(SYNONYM CLOTHES CLOTHING PANTS SHIRT)
	(OWNER CH-CELL-GUARD)
	(ACTION RT-TH-GUARD-CLOTHES)
>

<ROUTINE RT-TH-GUARD-CLOTHES ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? WEAR TAKE EXAMINE>
			<TELL ,K-UNDRESS-GUARD-MSG>
		)
	>
>

;"---------------------------------------------------------------------------"
; "CH-CELL-GUARD"
;"---------------------------------------------------------------------------"

<OBJECT CH-CELL-GUARD
	(DESC "guard")
	(FLAGS FL-ALIVE FL-OPEN FL-PERSON FL-SEARCH)
	(SYNONYM GUARD MAN SOLDIER PERSON)
	(ADJECTIVE CELL DUNGEON)
	(OWNER CH-LOT)
	(GENERIC RT-GN-GUARD)
	(ACTION RT-CH-CELL-GUARD)
>

<CONSTANT K-UNDRESS-GUARD-MSG
"It looks like the guard's clothes are too big for you, yet too small for the
muscular blacksmith.|">

<ROUTINE RT-CH-CELL-GUARD ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-WINNER>
			<COND
				(<OR	<MC-HERE? ,RM-BOTTOM-OF-STAIRS>
						<NOT <FSET? ,CH-CELL-GUARD ,FL-ASLEEP>>
					>
					<RT-SEIZE-MSG ,CH-CELL-GUARD>
				)
				(T
					<RT-NO-RESPONSE-MSG ,CH-CELL-GUARD>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<RFALSE>
		)
		(<VERB? ATTACK BREAK>
			<RT-KNOCK-OUT-GUARD>
		)
		(<AND <VERB? CALL>
				<MC-HERE? ,RM-CELL ,RM-BOTTOM-OF-STAIRS ,RM-HALL ,RM-END-OF-HALL ,RM-SMALL-CHAMBER>
			>
			<RT-CALL-GUARD>
		)
		(<VERB? EXAMINE>
			<FSET ,CH-CELL-GUARD ,FL-SEEN>
			<COND
				(<OR	<MC-HERE? ,RM-BOTTOM-OF-STAIRS>
						<NOT <FSET? ,CH-CELL-GUARD ,FL-ASLEEP>>
					>
					<TELL
"It's hard to tell what he looks like. His back is turned towards you." CR
					>
				)
				(T
					<TELL
"The guard is lying on the floor, unconscious. It doesn't look as if he will
recover anytime soon."
					>
					<COND
						(<IN? ,TH-HELMET ,CH-CELL-GUARD>
							<TELL " He is wearing a helmet.">
						)
					>
					<CRLF>
				)
			>
		)
		(<VERB? UNDRESS>
			<COND
				(<OR	<MC-HERE? ,RM-BOTTOM-OF-STAIRS>
						<NOT <FSET? ,CH-CELL-GUARD ,FL-ASLEEP>>
					>
					<RT-SEIZE-MSG ,CH-CELL-GUARD>
				)
				(T
				;	<RT-WASTE-OF-TIME-MSG>
					<TELL ,K-UNDRESS-GUARD-MSG>
				)
			>
		)
	>
>

<ROUTINE RT-GN-GUARD (TBL FINDER "AUX" PTR N)
	<SET PTR <REST-TO-SLOT .TBL FIND-RES-OBJ1>>
	<SET N <FIND-RES-COUNT .TBL>>
	<COND
		(<INTBL? ,P-HIM-OBJECT .PTR .N>
			<RETURN ,P-HIM-OBJECT>
		)
		(T
			<RETURN ,CH-CELL-GUARD>
		)
	>
>

<ROUTINE RT-KNOCK-OUT-GUARD ()
	<COND
		(<AND <IN? ,CH-CELL-GUARD ,HERE>
				<FSET? ,CH-CELL-GUARD ,FL-ASLEEP>
			>
			<TELL
"He's already unconscious. There's no need to hit him again." CR
			>
			<RTRUE>
		)
		(<AND <IN? ,CH-CELL-GUARD ,HERE>
				<MC-PRSI? ,TH-CELL-STONE>
			>
			<FSET ,TH-HELMET ,FL-BROKEN>
			<FSET ,CH-CELL-GUARD ,FL-ASLEEP>
			<FSET ,CH-CELL-GUARD ,FL-NO-LIST>
			<RT-MOVE-ALL ,CH-CELL-GUARD ,HERE>
			<RT-QUEUE ,RT-I-ALARM
				<+ <- ,GL-MOVES <MOD ,GL-MOVES 180>> 225>
				T
			>
			<TELL The ,WINNER>
			<COND
				(<EQUAL? ,GL-HIDING ,LG-CELL-DOOR>
					<MOVE ,WINNER ,RM-CELL>
					<SETG GL-HIDING <>>
					<TELL
verb ,WINNER "step" " out from behind" the ,LG-CELL-DOOR " and"
					>
				)
			>
			<THIS-IS-IT ,CH-CELL-GUARD>
			<THIS-IS-IT ,TH-MASTER-KEY>
			; "Bob"
			<TELL
verb ,WINNER "bean" " the guard with the stone. It puts a dent in his helmet
and he slumps to the floor, unconscious. As he falls, you notice a key
dangling at his side.|"
			>
			<RT-SCORE-MSG 0 3 3 2>
			<RTRUE>
		)
		(T
			<COND
				(<MC-FORM? ,K-FORM-ARTHUR>
					<TELL "You hit the guard">
					<COND
						(<NOT <MC-PRSI? ,TH-HANDS>>
							<TELL " with" the ,PRSI>
						)
					>
				;	<TELL
", but only manage to stun him for a moment. He quickly recovers and" ,K-GUARDS-COME-MSG
					>
					; "Bob"
					<TELL
", but the blow glances off his helmet. He quickly recovers and" ,K-GUARDS-COME-MSG
					>
					<RT-OVERPOWER-MSG>
				)
				(T
					<TELL
"You leave your hiding place, but before you can carry out your plan of
attack, the guard says," ,K-LOVERLY-MSG form ,K-SKEWER-MSG
					>
				)
			>
			<RT-END-OF-GAME>
		)
	>
>

<GLOBAL GL-GUARD-CNT:NUMBER 0>
<GLOBAL GL-CALLED-GUARD? <>>

<CONSTANT K-GUARDS-COME-MSG " calls out for help. Other guards come">
<CONSTANT K-LOVERLY-MSG " \"Ooo. What a loverly">
<CONSTANT K-SKEWER-MSG ".\" He skewers you with his sword.|">
<CONSTANT K-FOOTSTEPS-MSG " hear footsteps in the hall outside the door.|">

<ROUTINE RT-CALL-GUARD ()
	<INC GL-GUARD-CNT>
	<SETG GL-CALLED-GUARD? T>
	<TELL The+verb ,WINNER "call" " out.">
	<COND
		(<FSET? ,CH-CELL-GUARD ,FL-ASLEEP>
			<CRLF>
			<CRLF>
			<RT-DEQUEUE ,RT-I-ALARM>
			<RT-I-ALARM>
		)
		(<OR	<RT-IS-QUEUED? ,RT-I-GUARD-1>
				<RT-IS-QUEUED? ,RT-I-GUARD-2>
			>
			<CRLF>
		)
		(T
			<RT-QUEUE ,RT-I-GUARD-2 <+ ,GL-MOVES 1>>
			<TELL " Moments later, you" ,K-FOOTSTEPS-MSG>
		)
	>
>

<ROUTINE RT-I-GUARD-1 ()
	<RT-QUEUE ,RT-I-GUARD-2 <+ ,GL-MOVES 1>>
	<SETG GL-CALLED-GUARD? <>>
	<COND
		(<MC-HERE? ,RM-CELL>
			<TELL "|You" ,K-FOOTSTEPS-MSG>
		)
	>
>

<ROUTINE RT-I-GUARD-2 ("AUX" OBJ)
	<RT-QUEUE ,RT-I-GUARD-3 <+ ,GL-MOVES 1>>
	<COND
		(<OR	<MC-HERE? ,RM-CELL>
				<AND
					<MC-HERE? ,RM-HOLE>
					<NOT <FSET? ,TH-CELL-STONE ,FL-LOCKED>>
				>
			>
			<MOVE ,CH-CELL-GUARD ,RM-CELL>
			<FSET ,CH-CELL-GUARD ,FL-SEEN>
			<FCLEAR ,LG-CELL-DOOR ,FL-LOCKED>
			<FSET ,LG-CELL-DOOR ,FL-OPEN>
			<RT-CHECK-ADJ ,LG-CELL-DOOR>
			<TELL
"|You hear keys fumbling in the lock, and then the door swings back and a
guard steps into the cell. He "
			>
			<COND
				(<MC-HERE? ,RM-HOLE>
					<MOVE ,TH-CELL-STONE ,RM-CELL>
					<FSET ,TH-CELL-STONE ,FL-LOCKED>
					<TELL "sees the stone and replaces it in the hole.|">
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
							<RT-UPDATE-DESC-WINDOW>
						)
					>
					<RTRUE>
				)
				(<EQUAL? ,GL-HIDING ,LG-CELL-DOOR>
					<SET OBJ <FIRST? ,RM-CELL>>
					<REPEAT ()
						<COND
							(<NOT .OBJ>
								<RETURN>
							)
							(<AND <NOT <EQUAL? .OBJ ,TH-CELL-STONE>>
									<FSET? .OBJ ,FL-TAKEABLE>
								>
								<TELL
"sees" the .OBJ " and says, \"Hmmm. Never noticed this before.\" He looks
around the room. When he "
								>
								<COND
									(<MC-FORM? ,K-FORM-ARTHUR>
										<TELL "sees you he" ,K-GUARDS-COME-MSG>
										<RT-OVERPOWER-MSG>
									)
									(T
										<TELL
"notices you he says," ,K-LOVERLY-MSG form ,K-SKEWER-MSG
										>
									)
								>
								<RT-END-OF-GAME>
							)
						>
						<SET OBJ <NEXT? .OBJ>>
					>
					<COND
						(<AND <NOT <FSET? ,TH-CELL-STONE ,FL-LOCKED>>
								<IN? ,TH-CELL-STONE ,RM-CELL>
							>
							<FSET ,TH-CELL-STONE ,FL-LOCKED>
							<FSET ,TH-CELL-STONE ,FL-NO-DESC>
							<TELL
"sees the stone, replaces it in the hole and then "
							>
						)
					>
					<COND
						(<AND ,GL-CALLED-GUARD?
								<G? ,GL-GUARD-CNT 2>
							>
							<COND
								(<EQUAL? ,GL-GUARD-CNT 3>
									<TELL
"says, \"Right, mate. That's it! One more scream out of you and the dogs will
be eating prisoner casserole for tomorrow's dinner.\" He "
									>
								)
								(T
									<TELL
"hauls the prisoner away to a fate so gruesome, so bloody, so terrifyingly
horrible, that you feel compelled to die also." CR
									>
									<RT-END-OF-GAME>
								)
							>
						)
					>
					<TELL
"stands for a moment with his back to you, looking at the prisoner.|"
					>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-OBJS>>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
							<RT-UPDATE-DESC-WINDOW>
						)
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>
							<RT-UPDATE-MAP-WINDOW>
						)
					>
					<RTRUE>
				)
				(<MC-FORM? ,K-FORM-ARTHUR>
					<TELL "sees you immediately and" ,K-GUARDS-COME-MSG>
					<RT-OVERPOWER-MSG>
					<RT-END-OF-GAME>
				)
				(T
					<COND
						(<NOT <FSET? ,TH-CELL-STONE ,FL-LOCKED>>
							<TELL "sees the stone, and ">
						)
					>
					<TELL
"looks around the room. When he notices you he says," ,K-LOVERLY-MSG form
,K-SKEWER-MSG
					>
					<RT-END-OF-GAME>
				)
			>
		)
		(<NOT <FSET? ,TH-CELL-STONE ,FL-LOCKED>>
			<MOVE ,CH-CELL-GUARD ,RM-CELL>
			<FCLEAR ,LG-CELL-DOOR ,FL-LOCKED>
			<FSET ,LG-CELL-DOOR ,FL-OPEN>
			<RT-CHECK-ADJ ,LG-CELL-DOOR>
		;	<MOVE ,TH-CELL-STONE ,RM-HOLE>
			<FSET ,TH-CELL-STONE ,FL-LOCKED>
			<FSET ,TH-CELL-STONE ,FL-NO-DESC>
			<RFALSE>
		)
	>
>

<ROUTINE RT-I-GUARD-3 ()
	<COND
		(<NOT <FSET? ,CH-CELL-GUARD ,FL-ASLEEP>>
			<REMOVE ,CH-CELL-GUARD>
			<FSET ,LG-CELL-DOOR ,FL-LOCKED>
			<FCLEAR ,LG-CELL-DOOR ,FL-OPEN>
			<RT-CHECK-ADJ ,LG-CELL-DOOR>
			<COND
				(<MC-HERE? ,RM-CELL>
					<TELL "|The guard leaves the cell and relocks the door.|">
				;	<RT-MOVE-ALL ,CH-CELL-GUARD>
				;	<MOVE ,TH-MASTER-KEY ,CH-CELL-GUARD>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-OBJS>>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
							<RT-UPDATE-DESC-WINDOW>
						)
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>
							<RT-UPDATE-MAP-WINDOW>
						)
					>
					<RTRUE>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RT-I-ALARM"
;"---------------------------------------------------------------------------"

<CONSTANT K-SHOUT-FOOTSTEP-MSG "|In the distance you hear shouts and running footsteps. ">
<CONSTANT K-REMOVE-PRISONER-MSG "remove the prisoner to another cell.">

<ROUTINE RT-ESCAPE-MSG ()
	<TELL " \"There's been an escape">
	<COND
		(<FSET? ,CH-PRISONER ,FL-LOCKED>
			<TELL " attempt">
		)
	>
>

<ROUTINE RT-OVERPOWER-MSG ()
	<TELL " and ">
	<COND
		(<MC-HERE? ,RM-CELL>
			<TELL "overpower">
		)
		(T
			<TELL "arrest both of">
		)
	>
	<TELL " you, leaving you to rot in another cell.|">
	<RT-END-OF-GAME>
>

<ROUTINE RT-ARREST-PRISONER-MSG ()
	<COND
		(<MC-FORM? ,K-FORM-ARTHUR>
			<COND
				(,GL-HIDING
					<TELL ", find you hiding behind" the ,GL-HIDING ",">
				)
			>
			<RT-OVERPOWER-MSG>
		)
		(T
			<TELL
" " ,K-REMOVE-PRISONER-MSG " In the process, one of them notices you and
says," ,K-LOVERLY-MSG form ,K-SKEWER-MSG
			>
			<RT-END-OF-GAME>
		)
	>
>

<ROUTINE RT-I-ALARM ("AUX" (CAP? <>) (CALL? <>))
	<COND
		(<AND <MC-HERE? ,RM-HOLE>
				<NOT <FSET? ,TH-CELL-STONE ,FL-LOCKED>>
			>
			<TELL "Inside" the ,RM-CELL ",">
			<COND
				(<NOT <FSET? ,LG-CELL-DOOR ,FL-OPEN>>
					<FSET ,LG-CELL-DOOR ,FL-OPEN>
					<TELL the ,LG-CELL-DOOR " swings open and you see">
				)
			>
			<TELL " a">
			<COND
				(<IN? ,CH-CELL-GUARD ,RM-CELL>
					<TELL "nother">
				)
			>
			<TELL " guard enters. He sees ">
			<COND
				(<IN? ,CH-CELL-GUARD ,RM-CELL>
					<TELL "the unconscious guard">
				)
				(<AND <IN? ,CH-PRISONER ,RM-CELL>
						<NOT <FSET? ,CH-PRISONER ,FL-LOCKED>>
					>
					<TELL "the freed prisoner">
				)
				(T
					<TELL "that the prisoner has escaped">
				)
			>
			<TELL " and immediately" ,K-GUARDS-COME-MSG>
			<COND
				(<IN? ,CH-PRISONER ,RM-CELL>
					<REMOVE ,CH-PRISONER>
					<TELL " and " ,K-REMOVE-PRISONER-MSG CR>
				)
				(<IN? ,CH-CELL-GUARD ,RM-CELL>
					<TELL " and they remove the unconscious guard.|">
				)
				(T
					<TELL ", search the cell briefly, and then leave.|">
				)
			>
		)
		(<MC-HERE? ,RM-CELL>
			<COND
				(,GL-CLK-RUN
					<CRLF>
				)
			>
			<SET CAP? T>
			<COND
				(<NOT <FSET? ,LG-CELL-DOOR ,FL-OPEN>>
					<RT-PRINT-OBJ ,LG-CELL-DOOR ,K-ART-THE .CAP?>
					<SET CAP? <>>
					<FSET ,LG-CELL-DOOR ,FL-OPEN>
					<TELL " swings open and">
				)
			>
			<COND
				(.CAP?
					<TELL "A">
				)
				(T
					<TELL " a">
				)
			>
			<COND
				(<IN? ,CH-CELL-GUARD ,RM-CELL>
					<TELL "nother">
				)
			>
			<TELL " guard enters the cell. He sees ">
			<COND
				(<AND <IN? ,CH-PRISONER ,RM-CELL>
						<NOT <FSET? ,CH-PRISONER ,FL-LOCKED>>
					>
					<TELL "the freed prisoner">
				)
				(<IN? ,CH-CELL-GUARD ,RM-CELL>
					<TELL "the unconscious guard">
				)
				(T
					<TELL "you">
					<COND
						(,GL-HIDING
							<TELL " behind" the ,GL-HIDING>
						)
					>
					<COND
						(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
							<TELL " and says," ,K-LOVERLY-MSG form ,K-SKEWER-MSG>
							<RT-END-OF-GAME>
						)
					>
				)
			>
			<TELL " and immediately" ,K-GUARDS-COME-MSG>
			<COND
				(<IN? ,CH-PRISONER ,RM-CELL>
					<RT-ARREST-PRISONER-MSG>
				)
				(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
					<TELL
". One of them sees you and says," ,K-LOVERLY-MSG form ,K-SKEWER-MSG
					>
					<RT-END-OF-GAME>
				)
				(T
					<RT-OVERPOWER-MSG>
				)
			>
		)
		(<MC-HERE? ,RM-BOTTOM-OF-STAIRS ,RM-HALL ,RM-END-OF-HALL>
			<COND
				(,GL-CLK-RUN
					<CRLF>
				)
			>
			<TELL
"Another guard comes down the corridor, gives you a curious glance and enters
the cell. "
			>
			<COND
				(<OR <IN? ,CH-PRISONER ,HERE> <IN? ,CH-PRISONER ,RM-CELL>>
					<TELL
"Seconds later he bursts out again and" ,K-GUARDS-COME-MSG
					>
					<COND
						(<IN? ,CH-PRISONER ,HERE>
							<RT-ARREST-PRISONER-MSG>
						)
						(T
							<REMOVE ,CH-PRISONER>
							<TELL " and " ,K-REMOVE-PRISONER-MSG CR>
						)
					>
				)
				(T
					<TELL
"Moments later he emerges again and disappears down the hall." CR
					>
				)
			>
		)
		(<AND <MC-HERE? ,RM-SMALL-CHAMBER>
				,GL-CALLED-GUARD?
				<NOT ,GL-CLK-RUN>
			>
			<TELL
"Another guard comes down the corridor, gives you a curious glance, and then
disappears again." CR
			>
		)
		(<MC-HERE? ,RM-GREAT-HALL>
			<TELL
,K-SHOUT-FOOTSTEP-MSG "A soldier bursts into the hall and cries,"
			>
			<RT-ESCAPE-MSG>
			<TELL
".\" Lot calls out, \"Find the prisoner. He must not be allowed to leave the
castle.\" The soldier rushes out again." CR
			>
		)
		(<AND <MC-HERE?
					,RM-SMALL-CHAMBER ,RM-ARMOURY ,RM-CAS-KITCHEN
					,RM-PARADE-AREA ,RM-PASSAGE-1 ,RM-PASSAGE-2 ,RM-PASSAGE-3
					,RM-BEHIND-THRONE ,RM-BEHIND-FIRE
				>
				<NOT <FSET? ,CH-SOLDIERS ,FL-BROKEN>>
			>
			<TELL ,K-SHOUT-FOOTSTEP-MSG "Someone calls out">
			<RT-ESCAPE-MSG>
			<TELL "\"">
			<COND
				(<MC-HERE? ,RM-SMALL-CHAMBER ,RM-ARMOURY ,RM-CAS-KITCHEN ,RM-PARADE-AREA>
					<TELL " Moments later some guards burst into the ">
					<COND
						(<MC-HERE? ,RM-PARADE-AREA>
							<TELL "area">
						)
						(T
							<TELL "room">
						)
					>
					<COND
						(<IN? ,CH-PRISONER ,HERE>
							<TELL ", see the prisoner,">
							<RT-ARREST-PRISONER-MSG>
						)
						(T
							<TELL
", give you a curious glance, and then leave the way they came."
							>
						)
					>
				)
			>
			<CRLF>
		)
	>
	<FSET ,CH-SOLDIERS ,FL-BROKEN>
	<REMOVE ,CH-CELL-GUARD>
>

;"---------------------------------------------------------------------------"
; "TH-MASTER-KEY"
;"---------------------------------------------------------------------------"

<OBJECT TH-MASTER-KEY
	(LOC CH-CELL-GUARD)
	(DESC "cell key")
	(FLAGS FL-KEY FL-TAKEABLE)
	(SYNONYM KEY)
	(ADJECTIVE CELL)
	(SIZE 1)
	(GENERIC RT-GN-KEY)
	(ACTION RT-TH-MASTER-KEY)
>

<ROUTINE RT-TH-MASTER-KEY ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<AND <VERB? UNLOCK>
				,NOW-PRSI
				<MC-PRSO? ,TH-CHAINS ,TH-PADLOCK>
				<FSET? ,TH-CHAINS ,FL-LOCKED>
				<FSET? ,CH-PRISONER ,FL-LOCKED>
			>
			<RT-FREE-PRISONER-MSG>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-HOLE"
;"---------------------------------------------------------------------------"

<ROOM RM-HOLE
	(LOC ROOMS)
	(DESC "den")
	(FLAGS FL-LIGHTED FL-CONTAINER FL-OPEN FL-SEARCH)
	(SYNONYM HOLE DEN TUNNEL)
	(ADJECTIVE BADGER EARTH DIRT)
	(EAST PER RT-EXIT-HOLE)
	(UP TO RM-SMITHY)
	(OUT TO RM-SMITHY)
	(SOUTH TO RM-BADGER-TUNNEL)
	(IN PER RT-EXIT-HOLE)
	(GLOBAL LG-WALL RM-SMITHY RM-CELL)
	(ACTION RT-RM-HOLE)
	(THINGS
		(OLD CRUMBLY CRUMBLING) MORTAR RT-PS-MORTAR
		(OLD BUILDING) (STONE STONES ROCK ROCKS) RT-PS-STONES
	)
>

<ROUTINE RT-RM-HOLE ("OPT" (CONTEXT <>))
   <COND
      (<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "You are huddled up in">
				)
				(T
					<COND
						(<EQUAL? ,OHERE ,RM-SMITHY>
							<TELL
"You burrow down into the cold earth. After a while, the tunnel broadens
out into"
							>
						)
						(<EQUAL? ,OHERE ,RM-CELL>
							<TELL "You crawl into the hole and find yourself in">
						)
						(T
							<TELL "You emerge into">
						)
					>
				)
			>
         <TELL
" a comfortable badger's den that nestles up against the castle wall to the
east. The stones in the wall look very old"
			>
			<COND
				(<FSET? ,TH-CELL-STONE ,FL-LOCKED>
					<TELL
", and the mortar around one in particular is cracked and crumbling"
					>
				)
				(T
					<TELL
", and there is a hole in the wall where one has been pushed out"
					>
				)
			>
			<TELL ". Some ">
			<COND
				(<RT-TIME-OF-DAY? ,K-NIGHT>
					<TELL "moon">
				)
				(T
					<TELL "sun">
				)
			>
			<FSET ,RM-BADGER-TUNNEL ,FL-SEEN>
			<TELL
"light filters down from the opening over your head, and another tunnel leads
away to the south."
			>
			<COND
				(<GETB ,K-TUNNEL-CNT-TBL ,GL-TUNNEL-NUM>
					<TELL " ">
					<RT-NUM-MARKS-MSG>
				)
				(T
					<CRLF>
				)
			>
         <RFALSE>
      )
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<AND <VERB? DIG SCRATCH>
						<MC-PRSO? <> ,ROOMS ,TH-GROUND ,TH-SKY ,HERE ,GLOBAL-HERE ,LG-WALL>
					>
					<RT-MAKE-MARK <GETB ,K-TUNNEL-CNT-TBL ,GL-TUNNEL-NUM>>
				)
			>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-HOLE>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<SETG GL-TUNNEL-NUM 0>
			<RFALSE>
		)
      (.CONTEXT
         <RFALSE>
      )
		(<AND <MC-HERE? ,RM-CELL>
				<FSET? ,TH-CELL-STONE ,FL-LOCKED>
				<NOT <EVERYWHERE-VERB? <COND (,NOW-PRSI 2) (T 1)>>>
			>
			; "Bob - This is for >LOOK AT HOLE when the hole is blocked."
			<THIS-IS-IT ,TH-CELL-STONE>
			<TELL "The hole is blocked by a stone." CR>
		)
		(,NOW-PRSI
			<COND
				(<AND <VERB? PUT-IN>
						<MC-HERE? ,RM-CELL>
						<MC-PRSO? ,TH-CELL-STONE>
						<IN? ,TH-CELL-STONE ,WINNER>
					>
					<MOVE ,TH-CELL-STONE ,HERE>
					<FSET ,TH-CELL-STONE ,FL-LOCKED>
					<FSET ,TH-CELL-STONE ,FL-NO-DESC>
					<TELL
The+verb ,WINNER "slide" the ,TH-CELL-STONE " back into the hole.|"
					>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
							<RT-UPDATE-DESC-WINDOW>
						)
					>
					<RTRUE>
				)
				(<VERB? DROP PUT PUT-IN>
					<COND
						(<NOT <MC-HERE? ,RM-HOLE>>
							<RT-WASTE-OF-TIME-MSG>
						)
					>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,RM-HOLE ,FL-SEEN>
			<COND
				(<MC-HERE? ,RM-SMITHY>
					<TELL "It looks like a badger tunnel leading underground." CR>
				)
				(<MC-HERE? ,RM-CELL>
					<TELL
"There is a hole in the wall, leading into the badger tunnel." CR
					>
				)
			>
		)
		(<VERB? LOOK-DOWN LOOK-IN>
			<TELL "You peer">
			<COND
				(<MC-HERE? ,RM-SMITHY>
					<TELL " down">
				)
			>
			<TELL " into the hole, but can't see very far." CR>
		)
   >
>

<ROUTINE RT-PS-MORTAR ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<FCLEAR ,PSEUDO-OBJECT ,FL-PLURAL>
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
					<TELL "mortar">
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<TELL
"The mortar is cracked and crumbling. It barely holds the stones together." CR
			>
		)
		(<VERB? TAKE>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<TELL
"You scratch at the mortar, but you can't seem to remove it." CR
			>
		)
	>
>

<ROUTINE RT-PS-STONES ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
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
					<TELL "stones">
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<COND
				(<AND <FSET? ,TH-CELL-STONE ,FL-LOCKED>
						<NOUN-USED? ,PSEUDO-OBJECT ,W?STONE ,W?ROCK>
					>
					<FSET ,TH-CELL-STONE ,FL-SEEN>
					<THIS-IS-IT ,TH-CELL-STONE>
					<TELL
"It's an old building stone whose corners are rounded with age." CR
					>
				)
				(T
					<TELL "The stones look very old, and ">
					<COND
						(<FSET? ,TH-CELL-STONE ,FL-LOCKED>
							<THIS-IS-IT ,TH-CELL-STONE>
							<TELL
"the mortar around one in particular is cracked and crumbling." CR
							>
						)
						(T
							<TELL
"there is a hole in the wall where one has been pushed out." CR
							>
						)
					>
				)
			>
		)
		(<VERB? MOVE EXTEND SCRATCH>
			<COND
				(<MC-FORM? ,K-FORM-BADGER>
					<COND
						(<NOT <FSET? ,TH-CELL-STONE ,FL-LOCKED>>
							<THIS-IS-IT ,PSEUDO-OBJECT>
							<TELL "You ">
							<COND
								(<OR	<VERB? SCRATCH>
										<VERB-WORD? ,W?PULL>
									>
									<TELL "claw at">
								)
								(T
									<TELL "push on">
								)
							>
							<TELL
" the remaining stones, but none of them are loose." CR
							>
						)
						(T
						;	<MOVE ,TH-CELL-STONE ,RM-CELL>
							<FCLEAR ,TH-CELL-STONE ,FL-LOCKED>
							<FCLEAR ,TH-CELL-STONE ,FL-NO-DESC>
							<TELL "You ">
							<COND
								(<OR	<VERB? SCRATCH>
										<VERB-WORD? ,W?PULL>
									>
									<TELL "claw at">
								)
								(T
									<TELL "push on">
								)
							>
							<TELL " the stone. It wobbles. You give it a">
							<COND
								(<AND <NOT <VERB? SCRATCH>>
										<NOT <VERB-WORD? ,W?PULL>>
									>
									<TELL "nother">
								)
							>
							<TELL " push and it falls into the room beyond!|">
							<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
							<COND
								(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
									<RT-UPDATE-DESC-WINDOW>
								)
								(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>
									<RT-UPDATE-MAP-WINDOW>
								)
							>
							<RTRUE>
						)
					>
				)
				(T
					<TELL
Aform " isn't nearly strong enough to move such a stone." CR
					>
				)
			>
		)
	>
>

<CONSTANT K-TOO-BIG-MSG "You are too big to fit in the hole.|">

<ROUTINE RT-ENTER-HOLE ("OPT" (QUIET <>))
	<COND
		(<AND <MC-HERE? ,RM-CELL>
				<FSET? ,TH-CELL-STONE ,FL-LOCKED>
			>
			<COND
				(<NOT .QUIET>
					<TELL "A large stone blocks your path.|">
				)
			>
			<RFALSE>
		)
		(.QUIET
			<RETURN ,RM-HOLE>
		)
		(<MC-FORM? ,K-FORM-BADGER ,K-FORM-SALAMANDER>
			<RT-CLEAR-PUPPY>
		   <RETURN ,RM-HOLE>
		)
		(T
			<TELL ,K-TOO-BIG-MSG>
			<RFALSE>
		)
	>
>

<ROUTINE RT-EXIT-HOLE ("OPT" (QUIET <>))
	<COND
		(<FSET? ,TH-CELL-STONE ,FL-LOCKED>
			<COND
				(<NOT .QUIET>
					<TELL "A large stone blocks your path.|">
				)
			>
			<RFALSE>
		)
		(T
		   <RETURN ,RM-CELL>
		)
	>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

