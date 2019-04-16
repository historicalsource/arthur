;"***************************************************************************"
; "game : Arthur"
; "file : PLACES.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   11 May 1989  3:46:06  $"
; "revs : $Revision:   1.52  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Rooms not yet placed with associated code"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

<ROOM RM-FORK-IN-ROAD
	(LOC ROOMS)
	(DESC "fork in the road")
	(FLAGS FL-LIGHTED)
	(SYNONYM FORK ROAD)
	(SOUTH TO RM-TOWN-GATE)
	(NE TO RM-MOOR)
	(NW TO RM-ROAD)
	(UP PER RT-FLY-UP)
	(GLOBAL RM-MOOR)
	(ACTION RT-RM-FORK-IN-ROAD)
	(THINGS
		<> (ROCK ROCKS STONE STONES BOULDER BOULDERS) RT-PS-FORK-ROCKS
		<> (TREE TREES BRANCH BRANCHES) RT-PS-TREES
	)
>

<ROUTINE RT-RM-FORK-IN-ROAD ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "You are" standing " at">
				)
				(T
					<TELL "You come to">
				)
			>
			<TELL
" a fork in the road. One route goes northwest, the other northeast. The
road back to the town is to the south.|"
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-FORK>
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
				(<MC-HERE? ,RM-TOWN-GATE>
					<TELL "The road leads north along the town wall." CR>
				)
			>
		)
	>
>

<ROUTINE RT-PS-FORK-ROCKS ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<COND
		(<MC-CONTEXT? ,M-OBJDESC>
			<FSET ,PSEUDO-OBJECT ,FL-PLURAL>
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
					<TELL "rocks">
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<TELL "The boulders line the road that leads northeast." CR>
		)
	>
>

<ROUTINE RT-PS-TREES ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<COND
		(<MC-CONTEXT? ,M-OBJDESC>
			<FSET ,PSEUDO-OBJECT ,FL-PLURAL>
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
					<TELL "trees">
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<TELL "The trees are surprisingly full for this time of year." CR>
		)
	>
>

<ROOM RM-ROAD
	(LOC ROOMS)
	(DESC "road")
	(FLAGS FL-LIGHTED)
	(SYNONYM ROAD)
	(NORTH TO RM-EDGE-OF-WOODS)
	(SE TO RM-FORK-IN-ROAD)
	(UP PER RT-FLY-UP)
	(ACTION RT-RM-ROAD)
>

<ROUTINE RT-RM-ROAD ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL
"You are" standing " on a road that leads north towards the woods and off
to the southeast.|"
					>
				)
				(T
					<TELL "The road takes you ">
					<COND
						(<EQUAL? ,OHERE ,RM-EDGE-OF-WOODS>
							<TELL "away from the woods, and curves to the southeast.|">
						)
						(T
							<TELL "towards the woods, which lie to the north.|">
						)
					>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-ROAD>
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

