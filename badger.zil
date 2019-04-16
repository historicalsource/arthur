;"***************************************************************************"
; "game : Arthur"
; "file : BADGER.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   11 May 1989  3:46:24  $"
; "revs : $Revision:   1.70  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Badger Tunnel Puzzle"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "RM-BADGER-TUNNEL"
;"---------------------------------------------------------------------------"

<ROOM RM-BADGER-TUNNEL
	(LOC ROOMS)
	(DESC "den")
	(FLAGS FL-INDOORS FL-LIGHTED)
	(SYNONYM DEN TUNNEL DIRT)
	(ADJECTIVE BADGER EARTH DIRT)
	(NORTH PER RT-WALK-TUNNEL)
	(SOUTH PER RT-WALK-TUNNEL)
	(EAST PER RT-WALK-TUNNEL)
	(WEST PER RT-WALK-TUNNEL)
	(NE PER RT-WALK-TUNNEL)
	(SE PER RT-WALK-TUNNEL)
	(NW PER RT-WALK-TUNNEL)
	(SW PER RT-WALK-TUNNEL)
	(UP PER RT-WALK-TUNNEL)
	(DOWN PER RT-WALK-TUNNEL)
	(OUT PER RT-WALK-TUNNEL)
	(GLOBAL LG-WALL)
	(ACTION RT-RM-BADGER-TUNNEL)
>

<ROUTINE RT-RM-BADGER-TUNNEL ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-B-LOOK ,M-LOOK>
			<TELL
"You are in a den of twisty little passages - all alike. Tunnels exit in all
directions. "
			>
			<RT-NUM-MARKS-MSG>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<AND <VERB? DIG SCRATCH>
						<MC-PRSO? <> ,ROOMS ,TH-GROUND ,TH-SKY ,HERE ,GLOBAL-HERE ,LG-WALL>
					>
					<COND
						(<G? ,GL-TUNNEL-NUM 0>
							<RT-MAKE-MARK <GETB ,K-TUNNEL-CNT-TBL ,GL-TUNNEL-NUM>>
						)
					>
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
			<COND
				(<EQUAL? ,OHERE ,RM-HOLE>
					<SETG GL-TUNNEL-NUM 1>
				)
				(<EQUAL? ,OHERE ,RM-THORNEY-ISLAND>
					<SETG GL-TUNNEL-NUM 10>
				)
			>
			<RFALSE>
		)
		(.CONTEXT
			<RFALSE>
		)
	>
>

<ROUTINE RT-MAKE-MARK (COUNT "OPT" (N 1))
	<SET COUNT <+ .COUNT .N>>
	<PUTB ,K-TUNNEL-CNT-TBL ,GL-TUNNEL-NUM .COUNT>
	<COND
		(<G? .COUNT 11>
			<TELL
"You scratch at the dirt with your claw. A trickle starts to fall from the
ceiling, and then suddenly the wall collapses. In a matter of seconds, you
are buried alive, with no hope of digging your way out.|"
			>
			<RT-END-OF-GAME>
		)
		(<EQUAL? .COUNT 11>
			<TELL
"You add an eleventh claw mark alongside the others. You have scraped
so much dirt from the wall that another scratch might bring the entire
warren down around your ears.|"
			>
		)
		(<EQUAL? .COUNT 1>
			<TELL "You make a distinct claw mark in the dirt.|">
		)
		(T
			<TELL
"You add another claw mark next to the" wn <- .COUNT .N> " already in the dirt.|"
			>
		)
	>
	<RETURN .COUNT>
>

<ROUTINE RT-NUM-MARKS-MSG ("AUX" COUNT)
	<SET COUNT <GETB ,K-TUNNEL-CNT-TBL ,GL-TUNNEL-NUM>>
	<COND
		(<ZERO? .COUNT>
			<TELL "The soft earthen walls of the den are smooth and even." CR>
		)
		(T
			<TELL "In the dirt you can see">
			<COND
				(<EQUAL? .COUNT 1>
					<TELL " a distinct">
				)
				(T
					<TELL wn .COUNT>
				)
			>
			<TELL " claw mark">
			<COND
				(<NOT <EQUAL? .COUNT 1>>
					<TELL "s">
				)
			>
			<TELL "." CR>
		)
	>
>

<CONSTANT K-TUNNEL-DIR-TBL
	<TABLE (PURE)
		<TABLE (PURE)
P?NORTH P?SOUTH P?EAST P?WEST P?NE P?SE P?NW P?SW P?UP P?DOWN
		>
								; "N	S	E	W	NE	SE	NW	SW	UP	DN"
; 1	<TABLE (PURE BYTE)	0	2	4	6	8	5	3	7	9	2>
; 2	<TABLE (PURE BYTE)	1	7	9	5	3	6	4	8	1	9>
; 3	<TABLE (PURE BYTE)	8	4	6	2	9	5	7	8	1	6>
; 4	<TABLE (PURE BYTE)	8	6	7	1	2	6	3	5	9	2>
; 5	<TABLE (PURE BYTE)	1	2	4	3	9	7	6	8	2	1>
; 6	<TABLE (PURE BYTE)	4	8	5	9	1	3	2	5	2	7>
; 7	<TABLE (PURE BYTE)	9	8	1	6	4	3	5	6	5	2>
; 8	<TABLE (PURE BYTE)	1	1	1	1	9	7	2	6	5	4>
; 9	<TABLE (PURE BYTE)	8	4	6	2	1	5	3	7	8	10>
;10	<TABLE (PURE BYTE)	1	3	2	4	5	7	6	8	11	9>
	>
>

<CONSTANT K-TUNNEL-CNT-TBL
	<TABLE (BYTE) 0 0 0 0 0 0 0 0 0 0 0>
>

<GLOBAL GL-TUNNEL-NUM 0 <> BYTE>

<ROUTINE RT-WALK-TUNNEL ("OPT" (QUIET <>) "AUX" TBL N)
	<COND
		(.QUIET
			<RFALSE>
		)
		(<EQUAL? ,P-WALK-DIR ,P?OUT>
			<COND
				(<EQUAL? ,GL-TUNNEL-NUM 10>
					<SETG GL-TUNNEL-NUM 0>
					<RETURN ,RM-THORNEY-ISLAND>
				)
				(T
					<SETG CLOCK-WAIT T>
					<TELL ,K-WHICH-DIR-MSG>
					<RFALSE>
				)
			>
		)
		(T
			<SET TBL <ZGET ,K-TUNNEL-DIR-TBL 0>>
			<COND
				(<SET N <INTBL? ,P-WALK-DIR .TBL 10>>
					<SET N </ <- .N .TBL> 2>>
				)
				(T
					<SET N -1>
				)
			>
			<SET TBL <ZGET ,K-TUNNEL-DIR-TBL ,GL-TUNNEL-NUM>>
			<SETG GL-TUNNEL-NUM <GETB .TBL .N>>
			<COND
				(<EQUAL? ,GL-TUNNEL-NUM 0>
					<SETG GL-TUNNEL-NUM 0>
					<RETURN ,RM-HOLE>
				)
				(<EQUAL? ,GL-TUNNEL-NUM 11>
					<SETG GL-TUNNEL-NUM 0>
					<RETURN ,RM-THORNEY-ISLAND>
				)
				(T
					<RT-RM-BADGER-TUNNEL ,M-V-LOOK>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
							<RT-UPDATE-DESC-WINDOW>
						)
					>
					<RFALSE>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-THORNEY-ISLAND"
;"---------------------------------------------------------------------------"

<ROOM RM-THORNEY-ISLAND
	(LOC ROOMS)
	(DESC "thorney island")
	(FLAGS FL-LIGHTED)
	(SYNONYM ISLAND TREE BUSH THORNBUSH THORN THORNS BRANCH BRANCHES)
	(ADJECTIVE THORNEY THORNY THORN SMALL HAWTHORNE HAWTHORN)
	(NORTH SORRY K-THORN-BUSH-MSG)
	(SOUTH SORRY K-THORN-BUSH-MSG)
	(EAST SORRY K-THORN-BUSH-MSG)
	(WEST SORRY K-THORN-BUSH-MSG)
	(IN PER RT-ENTER-TUNNEL)
	(DOWN PER RT-ENTER-TUNNEL)
	(UP SORRY K-THORN-BUSH-MSG)
	(SCORE <LSH 2 ,K-QUEST-SHIFT>)
	(GENERIC RT-GN-ISLAND)
	(GLOBAL RM-BADGER-TUNNEL)
	(ACTION RT-RM-THORNEY-ISLAND)
;	(THINGS
		(HAWTHORNE HAWTHORN THORN THORNY) (THORN THORNS BUSH) RT-PS-HAW-BUSH
	)
>

<CONSTANT K-THORN-BUSH-MSG
"One look at those sharp thorns convinces you that it would be suicide to try
to pass through.">

<ROUTINE RT-RM-THORNEY-ISLAND ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<TELL "You ">
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "are">
				)
				(T
					<TELL
"poke your head out of the badger hole and look around. Seeing no one, you
crawl out of the hole and find yourself"
					>
				)
			>
			<FSET ,RM-BOG ,FL-SEEN>
			<TELL
" deep within the confines of a hawthorn bush on a small, foggy island. The
thorny branches of the bush form an impenetrable barrier on all sides.|"
			>
			<COND
				(<IN? ,TH-HAWTHORN ,RM-THORNEY-ISLAND>
					<FSET ,TH-HAWTHORN ,FL-SEEN>
					<TELL
"|On the ground is a thorny sprig that has fallen from the bush.|"
					>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<IN? ,TH-HAWTHORN ,RM-THORNEY-ISLAND>
					<COND
						(<MC-PRSO? ,TH-HAWTHORN ,RM-THORNEY-ISLAND ,GLOBAL-HERE>
							<COND
								(<TOUCH-VERB?>
									<COND
										(<MC-FORM? ,K-FORM-BADGER>
											<RT-DO-TAKE ,TH-HAWTHORN>
											<FSET ,TH-HAWTHORN ,FL-WORN>
											<THIS-IS-IT ,TH-HAWTHORN>
											<TELL
"As you brush up against the sprig, the thorn catches on your fur.|"
											>
											<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC ,K-UPD-INVT>>
											<COND
												(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
													<RT-UPDATE-DESC-WINDOW>
												)
												(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-INVT>
													<RT-UPDATE-INVT-WINDOW>
												)
											>
											<RTRUE>
										)
										(<MC-FORM? ,K-FORM-SALAMANDER>
											<THIS-IS-IT ,TH-HAWTHORN>
											<TELL
"The thorn scratches your bare, unprotected skin." CR
											>
										)
										(T
											<TELL
"You shouldn't be able to get here as" aform "." CR
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
			<SETG GL-PICTURE-NUM ,K-PIC-THORNEY-ISLAND>
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
		(<VERB? EXAMINE>
			<COND
				(<NOT <MC-HERE? ,RM-THORNEY-ISLAND>>
					<COND
						(<NOUN-USED? ,RM-THORNEY-ISLAND ,W?ISLAND>
							<FSET ,RM-THORNEY-ISLAND ,FL-SEEN>
							<TELL
"You peer through the fog at the island. Dimly, you see the vague outline of
a single, large thornbush." CR
							>
						)
						(T
							<TELL
"It looks like a large thornbush, but the fog is too thick to be sure." CR
							>
						)
					>
				)
			>
		)
		(<AND <VERB? ENTER WALK-TO LAND-ON>
				<MC-FORM? ,K-FORM-OWL>
			>
			<RT-FLY-TO-ISLAND>
		)
		(<VERB? LOOK-UNDER>
			<TELL The+verb ,WINNER "see" " a hole under the bush." CR>
		)
	>
>

<ROUTINE RT-GN-ISLAND (TBL FINDER)
	<COND
		(<MC-HERE? ,RM-COTTAGE>
			<RETURN ,RM-THORNEY-ISLAND>
		)
		(T
			<RETURN ,RM-ISLAND>
		)
	>
>

;<ROUTINE RT-PS-HAW-BUSH ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<COND
		(<MC-CONTEXT? ,M-OBJDESC>
			<FCLEAR ,PSEUDO-OBJECT ,FL-PLURAL>
			<FCLEAR ,PSEUDO-OBJECT ,FL-VOWEL>
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
					<TELL "hawthorn bush">
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? LOOK-UNDER>
			<TELL The+verb ,WINNER "see" " a hole under the bush." CR>
		)
		(<VERB? EXAMINE>
			<TELL "It is a dense bush covered with sharp thorns." CR>
		)
	>
>


<ROUTINE RT-ENTER-TUNNEL ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<RETURN ,RM-BADGER-TUNNEL>
		)
		(<MC-FORM? ,K-FORM-BADGER ,K-FORM-SALAMANDER>
			<RT-CLEAR-PUPPY>
		   <RETURN ,RM-BADGER-TUNNEL>
		)
		(T
			<TELL ,K-TOO-BIG-MSG>
			<RFALSE>
		)
	>
>

<ROUTINE RT-FLY-TO-ISLAND ()
	<TELL "You swoop">
	<COND
		(<MC-HERE? ,RM-ABOVE-BOG>
			<TELL " down">
		)
	>
	<TELL
" through the fog towards the island and come upon an impenetrable barrier
of sharp thorns. You search for a way through the thicket but find none, so
you fly back"
	>
	<COND
		(<MC-HERE? ,RM-ABOVE-BOG>
			<TELL " up in into the air over the bog">
		)
	>
	<TELL "." CR>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

