;"***************************************************************************"
; "game : Arthur"
; "file : CHESTNUT.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   11 May 1989 23:51:28  $"
; "revs : $Revision:   1.43  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Horse Chestnuts"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "RM-CHESTNUT-PATH"
;"---------------------------------------------------------------------------"

<ROOM RM-CHESTNUT-PATH
	(LOC ROOMS)
	(DESC "track")
	(FLAGS FL-LIGHTED)
	(SYNONYM PATH TRACK)
	(ADJECTIVE FOREST)
	(NORTH PER RT-SURVIVE-CONKERS)
	(SE TO RM-LEP-PATH)
	(UP PER RT-FLY-UP)
	(GLOBAL LG-CHESTNUT-TREES LG-FOREST RM-GLADE)
	(ACTION RT-RM-CHESTNUT-PATH)
>

<ROUTINE RT-RM-CHESTNUT-PATH ("OPT" (CONTEXT <>) "AUX" OBJ)
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,LG-CHESTNUT-TREES ,FL-SEEN>
			<TELL
"You are" standing " on a track next to a stand of horse chestnut trees. The
track continues to the north and the southeast.|"
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(,GL-CONKERS-RUNNING
					<COND
						(<VERB? RAISE HIDE-BEHIND>
							<COND
								(<HELD? ,PRSO>
									<TELL
"You hold up" the ,PRSO ", but" he+verb ,PRSO "are" " not large enough to
stop all the conkers from getting through." CR
									>
								)
							>
						)
						(<VERB? SHIELD>
							<COND
								(<MC-PRSI? <> ,ROOMS>
									<COND
										(<IN? ,TH-SHIELD ,WINNER>
											<SET OBJ ,TH-SHIELD>
										)
										(T
											<SET OBJ ,TH-HANDS>
										)
									>
								)
								(T
									<SET OBJ ,PRSI>
								)
							>
							<COND
								(<HELD? .OBJ>
									<COND
										(<EQUAL? .OBJ ,TH-SHIELD>
											<COND
												(<MC-PRSO? ,TH-HEAD>
													<SETG GL-SHIELD-CONKERS 1>
												)
												(<MC-PRSO? ,TH-LEGS>
													<SETG GL-SHIELD-CONKERS 2>
												)
												(T
													<SETG GL-SHIELD-CONKERS 0>
												)
											>
										)
									>
									<TELL
The+verb ,WINNER "hold" " up" the .OBJ ", but" he+verb .OBJ "are" " not large
enough to stop all the conkers from getting through." CR
									>
								)
							>
						)
						(<VERB? SHIELD-FROM>
							<COND
								(<MC-PRSO? ,CH-PLAYER ,TH-HEAD ,TH-LEGS>
									<COND
										(<MC-PRSI? ,PSEUDO-OBJECT>
											<COND
												(<IN? ,TH-SHIELD ,WINNER>
													<COND
														(<MC-PRSO? ,TH-HEAD>
															<SETG GL-SHIELD-CONKERS 1>
														)
														(<MC-PRSO? ,TH-LEGS>
															<SETG GL-SHIELD-CONKERS 2>
														)
														(T
															<SETG GL-SHIELD-CONKERS 0>
														)
													>
													<TELL
The+verb ,WINNER "hold" " up" the ,TH-SHIELD ", but it is not large enough to
stop all the conkers from getting through." CR
													>
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
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-CONKERS-RUNNING <>>
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

<ROUTINE RT-SURVIVE-CONKERS ("OPT" (QUIET <>))
	<COND
		(<OR	.QUIET
				,GL-CONKERS-DONE
				<AND
					<NOT <MC-FORM? ,K-FORM-ARTHUR>>
					<NOT ,GL-CONKERS-RUNNING>
				>
			>
			<RETURN ,RM-GLADE>
		)
		(,GL-CONKERS-RUNNING
			<TELL ,K-BARRAGE-MSG CR>
			<RFALSE>
		)
		(T
			<RT-QUEUE ,RT-I-CONKERS-1 <+ ,GL-MOVES 1>>
			<SETG GL-CONKERS-RUNNING T>
			<TELL
"When you try to pass, the horse chestnut trees suddenly start to pluck
conkers from their branches and pelt you with them. " ,K-BARRAGE-MSG " The
enchanted conkers hit you with amazing force, then fall to the ground
and disappear.|"
			>
			<RFALSE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-CONKERS"
;"---------------------------------------------------------------------------"

<OBJECT TH-CONKERS
	(LOC RM-CHESTNUT-PATH)
	(DESC "conkers")
	(FLAGS FL-PLURAL FL-TRY-TAKE)
	(SYNONYM CONKER CONKERS)
	(ACTION RT-TH-CONKERS)
>

<ROUTINE RT-TH-CONKERS ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<COND
				(,GL-CONKERS-RUNNING
					<THIS-IS-IT ,PSEUDO-OBJECT>
					<TELL "They come at you in a blur." CR>
				)
				(T
					<THIS-IS-IT ,PSEUDO-OBJECT>
					<TELL
"The conkers are hard brown nuts surrounded by spiky green shells." CR
					>
				)
			>
		)
		(<TOUCH-VERB?>
			<COND
				(,GL-CONKERS-RUNNING
					<THIS-IS-IT ,PSEUDO-OBJECT>
					<TELL
"You can't catch any before they hit you, and after they hit you they
disappear." CR
					>
				)
				(T
					<THIS-IS-IT ,PSEUDO-OBJECT>
					<TELL "They're all out of reach." CR>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "LG-CHESTNUT-TREES"
;"---------------------------------------------------------------------------"

<OBJECT LG-CHESTNUT-TREES
	(LOC LOCAL-GLOBALS)
	(DESC "chestnut trees")
	(FLAGS FL-PLURAL)
	(SYNONYM TREE TREES BRANCH BRANCHES)
	(ADJECTIVE HORSE CHESTNUT)
	(ACTION RT-LG-CHESTNUT-TREES)
>

<ROUTINE RT-LG-CHESTNUT-TREES ("OPT" (CONTEXT <>))
	<COND
		(<VERB? EXAMINE>
			<FSET ,LG-CHESTNUT-TREES ,FL-SEEN>
			<COND
				(,GL-CONKERS-RUNNING
					<TELL
The+verb ,LG-CHESTNUT-TREES "are" " plucking conkers from their own branches
and pelting you with them." CR
					>
				)
				(<MC-HERE? ,RM-CHESTNUT-PATH>
					<TELL
The+verb ,LG-CHESTNUT-TREES "are" " loaded with conkers." CR
					>
				)
				(T
					<THIS-IS-IT ,LG-CHESTNUT-TREES>
					<TELL
"The stand of horse chestnut trees lies to the northwest." CR
					>
				)
			>
		)
		(<VERB? ATTACK CUT>
			<TELL "The sturdy bark is impervious to your assault." CR>
		)
		(<VERB? CLIMB-UP CLIMB-ON>
			<TELL ,K-CLIMB-TREE-MSG>
		)
		(<TOUCH-VERB?>
			<COND
				(<NOT <MC-HERE? ,RM-CHESTNUT-PATH>>
					<TELL The+verb ,LG-CHESTNUT-TREES "are" " too far away." CR>
				)
			>
		)
	>
>

<GLOBAL GL-CONKERS-DONE:FLAG <> <> BYTE>
<GLOBAL GL-CONKERS-RUNNING:FLAG <> <> BYTE>
<GLOBAL GL-SHIELD-CONKERS 0 <> BYTE>

<CONSTANT K-BARRAGE-MSG
"You try to move forward into the barrage, but get nowhere.">

<CONSTANT K-TREES-ATTACK-MSG "The horse chestnut trees continue to attack">
<CONSTANT K-PAIN-TOO-MUCH-MSG " The force of the repeated blows finally
overwhelms you. You fall to the ground and die.|">
<CONSTANT K-CONKER-HARMLESS-MSG "The conkers bounce harmlessly off your shell.|">

<ROUTINE RT-I-CONKERS-1 ()
	<COND
		(<MC-HERE? ,RM-CHESTNUT-PATH>
			<RT-QUEUE ,RT-I-CONKERS-2 <+ ,GL-MOVES 1>>
			<TELL
"|The horse chestnut trees are still bombarding you with conkers. "
			>
			<COND
				(<OR	<MC-FORM? ,K-FORM-TURTLE>
						<EQUAL? ,GL-SHIELD-CONKERS 1 2>
						<AND
							<FSET? ,TH-ARMOUR ,FL-WORN>
							<IN? ,TH-ARMOUR ,CH-PLAYER>
						>
					>
					<TELL "Some bounce off your ">
					<COND
						(<MC-FORM? ,K-FORM-TURTLE>
							<TELL "shell">
						)
						(<EQUAL? ,GL-SHIELD-CONKERS 1 2>
							<TELL "shield">
						)
						(T
							<TELL "armour">
						)
					>
					<TELL " but others">
				)
				(T
					<TELL "They">
				)
			>
			<TELL " hit you on the ">
			<COND
				(<EQUAL? ,GL-SHIELD-CONKERS 0>
					<TELL "head and legs">
				)
				(<EQUAL? ,GL-SHIELD-CONKERS 1>	; "shielded head"
					<TELL "legs">
				)
				(<EQUAL? ,GL-SHIELD-CONKERS 2>	; "shielded legs"
					<TELL "head">
				)
			>
			<TELL
", causing intense pain. You won't be able to stand much more of this." CR
			>
		)
	>
>

<ROUTINE RT-I-CONKERS-2 ()
	<COND
		(<MC-HERE? ,RM-CHESTNUT-PATH>
			<RT-QUEUE ,RT-I-CONKERS-3 <+ ,GL-MOVES 1>>
			<CRLF>
			<COND
				(<NOT <MC-FORM? ,K-FORM-TURTLE>>
					<TELL
,K-TREES-ATTACK-MSG " you with conkers." ,K-PAIN-TOO-MUCH-MSG
					>
					<RT-END-OF-GAME>
				)
				(<OR	<NOT <FSET? ,TH-HEAD ,FL-LOCKED>>
						<NOT <FSET? ,TH-LEGS ,FL-LOCKED>>
					>
					<TELL "The conkers are still pelting against">
					<COND
						(<NOT <FSET? ,TH-HEAD ,FL-LOCKED>>
							<TELL the ,TH-HEAD>
						)
					>
					<COND
						(<NOT <FSET? ,TH-LEGS ,FL-LOCKED>>
							<COND
								(<NOT <FSET? ,TH-HEAD ,FL-LOCKED>>
									<TELL " and">
								)
							>
							<TELL the ,TH-LEGS>
						)
					>
					<TELL "." CR>
				)
				(T
					<TELL ,K-CONKER-HARMLESS-MSG>
				)
			>
		)
	>
>

<ROUTINE RT-I-CONKERS-3 ()
	<COND
		(<MC-HERE? ,RM-CHESTNUT-PATH>
			<CRLF>
			<COND
				(<RT-TREES-ATTACK?>
					<RT-END-OF-GAME>
				)
				(T
					<RT-QUEUE ,RT-I-CONKERS-4 <+ ,GL-MOVES 1>>
					<TELL ,K-CONKER-HARMLESS-MSG>
				)
			>
		)
	>
>

<ROUTINE RT-I-CONKERS-4 ()
	<COND
		(<MC-HERE? ,RM-CHESTNUT-PATH>
			<CRLF>
			<COND
				(<RT-TREES-ATTACK?>
					<RT-END-OF-GAME>
				)
				(T
					<RT-QUEUE ,RT-I-CONKERS-5 <+ ,GL-MOVES 1>>
					<TELL
"The conkers continue to rain off your shell, but the barrage seems to be
lessening." CR
					>
				)
			>
		)
	>
>

<ROUTINE RT-I-CONKERS-5 ()
	<COND
		(<MC-HERE? ,RM-CHESTNUT-PATH>
			<CRLF>
			<COND
				(<RT-TREES-ATTACK?>
					<RT-END-OF-GAME>
				)
				(T
					<SETG GL-CONKERS-RUNNING <>>
					<SETG GL-CONKERS-DONE T>
					<TELL "The hailstorm of conkers ceases." CR>
					<RT-SCORE-MSG 0 3 7 3>
				)
			>
		)
	>
>

<ROUTINE RT-TREES-ATTACK? ("AUX" T H L)
	<COND
		(<OR	<SET T <NOT <MC-FORM? ,K-FORM-TURTLE>>>
				<SET H <NOT <FSET? ,TH-HEAD ,FL-LOCKED>>>
				<SET L <NOT <FSET? ,TH-LEGS ,FL-LOCKED>>>
			>
			<TELL ,K-TREES-ATTACK-MSG>
			<COND
				(.T
					<TELL the ,CH-PLAYER>
				)
				(T
					<COND
						(.H
							<TELL the ,TH-HEAD>
						)
					>
					<COND
						(.L
							<COND
								(.H
									<TELL " and">
								)
							>
							<TELL the ,TH-LEGS>
						)
					>
				)
			>
			<TELL " with conkers." ,K-PAIN-TOO-MUCH-MSG>
		)
	>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

