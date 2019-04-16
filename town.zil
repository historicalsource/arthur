;"***************************************************************************"
; "game : Arthur"
; "file : TOWN.ZIL"
; "auth :   $Author:   RAB  $"
; "date :     $Date:   15 May 1989 16:20:06  $"
; "revs : $Revision:   1.41  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Town stuff"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "RM-TOWN-GATE"
;"---------------------------------------------------------------------------"

<ROOM RM-TOWN-GATE
	(LOC ROOMS)
	(DESC "outside town gate")
	(FLAGS FL-LIGHTED)
	(EAST TO RM-VILLAGE-GREEN)
	(NORTH TO RM-FORK-IN-ROAD)
	(SW TO RM-MEADOW)
	(IN TO RM-VILLAGE-GREEN)
	(UP PER RT-FLY-UP)
	(GLOBAL LG-TOWN-GATE LG-TOWN LG-WALL RM-MEADOW RM-FORK-IN-ROAD RM-VILLAGE-GREEN)
	(ACTION RT-RM-TOWN-GATE)
	(THINGS
		(THATCH THATCHED WATTLE)
		(HUTS HOUSES HUT HOUSE BUILDING BUILDINGS WINDOWS WINDOW) RT-PS-HUTS
	)
>

<ROUTINE RT-RM-TOWN-GATE ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "You are now" standing " just outside">
				)
				(T
					<COND
						(<EQUAL? ,OHERE ,RM-VILLAGE-GREEN>
							<TELL "You leave the town and pause outside">
						)
						(<EQUAL? ,OHERE ,RM-FORK-IN-ROAD>
							<TELL
"The road takes you southward. Soon you are" walking " alongside the
wall of the town, and you pause outside"
							>
						)
						(T
							<TELL "You" walk " to the northeast until you come to">
						)
					>
				)
			>
			<FSET ,LG-TOWN-GATE ,FL-SEEN>
			<FSET ,RM-MEADOW ,FL-SEEN>
			<TELL
" the town gate, which lies to the east. A road leads to the north, and to
the southwest is a meadow.|"
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-TOWN-GATE>
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
; "LG-TOWN-GATE"
;"---------------------------------------------------------------------------"

<OBJECT LG-TOWN-GATE
	(LOC LOCAL-GLOBALS)
	(DESC "town gate")
	(SYNONYM GATE)
	(ADJECTIVE TOWN VILLAGE)
	(ACTION RT-LG-TOWN-GATE)
>

<ROUTINE RT-LG-TOWN-GATE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<NOT <EVERYWHERE-VERB? <COND (,NOW-PRSI 2) (T 1)>>>
			<TELL
"The old Roman wall has fallen into disrepair and there is no longer an
actual gate here - merely a gap in the wall where it used to be." CR
			>
		)
	>
>

<ROUTINE RT-PS-HUTS ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
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
					<TELL "houses">
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
		 <THIS-IS-IT ,PSEUDO-OBJECT>
		 <TELL
"The houses are little more than huts made of wattle and thatch." CR
			>
		)
		(<VERB? ENTER LOOK-IN LOOK-THRU>
		 <THIS-IS-IT ,PSEUDO-OBJECT>
		 <TELL
"Closer investigation reveals that the houses are even less interesting than
when seen from a distance." CR
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-VILLAGE-GREEN"
;"---------------------------------------------------------------------------"

<ROOM RM-VILLAGE-GREEN
	(LOC ROOMS)
	(DESC "village green")
	(FLAGS FL-LIGHTED)
	(SYNONYM GREEN)
	(ADJECTIVE VILLAGE)
	(EAST TO RM-TOWN-SQUARE)
	(WEST TO RM-TOWN-GATE)
	(OUT TO RM-TOWN-GATE)
	(UP PER RT-FLY-UP)
	(GLOBAL LG-TOWN-GATE LG-WALL RM-TOWN-SQUARE)
	(ACTION RT-RM-VILLAGE-GREEN)
	(THINGS
		(THATCH THATCHED WATTLE)
		(HUTS HOUSES HUT HOUSE BUILDING BUILDINGS WINDOWS WINDOW) RT-PS-HUTS
	)
>

<ROUTINE RT-RM-VILLAGE-GREEN ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<TELL "You ">
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "are" standing " on">
				)
				(T
					<TELL "enter">
				)
			>
			<FSET ,LG-TOWN-GATE ,FL-SEEN>
			<FSET ,TH-OAK ,FL-SEEN>
			<TELL
" the village green, which is a common area just inside the town's western
defences. The old Roman wall is crumbling into disrepair here, and there is a
gaping hole where the west gate used to be. The town square lies to the east,
and an ancient oak dominates the center of the green, towering over its roots
like an aging druid over a group of prostrated initiates.|"
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<AND <VERB? DIG>
						<MC-PRSO? <> ,ROOMS ,TH-GROUND ,TH-OAK>
					>
					<COND
						(<MC-FORM? ,K-FORM-BADGER>
							<COND
								(<FSET? ,TH-SWORD ,FL-LOCKED>
									<TELL
"There are so many places to dig here, you wouldn't know where to begin." CR
									>
								)
								(<IN? ,TH-OAK-HOLE ,RM-VILLAGE-GREEN>
									<TELL The ,WINNER " can't dig any deeper." CR>
								)
								(T
									<MOVE ,TH-OAK-HOLE ,RM-VILLAGE-GREEN>
									<THIS-IS-IT ,TH-SWORD>
									<TELL
"Dirt starts to fly all around you as your claws dig at a furious pace. Soon
you have dug a nice hole between the roots of the tree. You see a sword
glinting at the bottom of the hole." CR
									>
								)
							>
						)
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-VILLAGE-GREEN>
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
; "TH-OAK"
;"---------------------------------------------------------------------------"

<OBJECT TH-OAK
	(LOC RM-VILLAGE-GREEN)
	(DESC "oak")
	(FLAGS FL-NO-DESC)
	(SYNONYM OAK TREE ROOTS BRANCH BRANCHES)
	(ADJECTIVE OAK ANCIENT)
	(GENERIC RT-GN-TREE)
	(ACTION RT-TH-OAK)
>

<ROUTINE RT-TH-OAK ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-OAK ,FL-SEEN>
			<COND
				(<NOUN-USED? ,TH-OAK ,W?ROOTS>
					<TELL
"The gnarled roots clutch the earth like an old man's fingers." CR
					>
				)
				(T
					<TELL "It's a majestic old tree with huge gnarled roots." CR>
				)
			>
		)
		(<VERB? CLIMB-UP CLIMB-ON>
			<TELL
"You clamber up the tree for a quick look around. Unfortunately, you find
nothing of interest, and quickly return to the ground." CR
			>
		)
		(<VERB? LOOK-UNDER>
			<SETG CLOCK-WAIT T>
			<RT-AUTHOR-MSG ,K-HOW-INTEND-MSG>
		)
	>
>


;"---------------------------------------------------------------------------"
; "TH-OAK-HOLE"
;"---------------------------------------------------------------------------"

<OBJECT TH-OAK-HOLE
	(DESC "hole")
	(FLAGS FL-CONTAINER FL-OPEN FL-SEARCH)
	(SYNONYM HOLE ;DIRT)
	(CAPACITY 50)
	(ACTION RT-TH-OAK-HOLE)
>

<ROUTINE RT-TH-OAK-HOLE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE LOOK-IN>
			<COND
				(<EQUAL? <FIRST? ,TH-OAK-HOLE> ,TH-SWORD>
					<COND
						(<NOT <NEXT? ,TH-SWORD>>
							<THIS-IS-IT ,TH-SWORD>
							<TELL
"There is a sword gleaming at the bottom of the hole." CR
							>
						)
					>
				)
			>
		)
		(<VERB? ENTER>
			<COND
				(<MC-FORM? ,K-FORM-ARTHUR>
					<TELL The+verb ,WINNER "are" " too big to fit in" the ,TH-OAK-HOLE "." CR>
				)
				(T
					<TELL
"You crawl into the hole and have a quick look around. "
					>
					<COND
						(<SEE-ANYTHING-IN? ,TH-OAK-HOLE>
							<TELL "You find">
							<PRINT-CONTENTS ,TH-OAK-HOLE>
							<TELL " in the hole, and then">
						)
						(T
							<TELL "Finding nothing of interest, you">
						)
					>
					<TELL " crawl out again." CR>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-SMITHY"
;"---------------------------------------------------------------------------"

<ROOM RM-SMITHY
   (LOC ROOMS)
   (DESC "smithy")
   (FLAGS FL-LIGHTED)
   (SYNONYM SMITHY)
   (NORTH TO RM-CASTLE-GATE)
   (DOWN PER RT-ENTER-HOLE)
   (IN PER RT-ENTER-HOLE)
	(UP PER RT-FLY-UP)
	(GLOBAL LG-WALL LG-CASTLE RM-HOLE)
   (ACTION RT-RM-SMITHY)
	(THINGS
		<> (BUSH BUSHES SHRUB PLANT) RT-PS-BUSH
	)
>

<ROUTINE RT-RM-SMITHY ("OPT" (CONTEXT <>))
   <COND
      (<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "You are" standing " outside">
				)
				(<EQUAL? ,OHERE ,RM-CASTLE-GATE>
					<TELL "You" walk " southward alongside">
				)
				(<EQUAL? ,OHERE ,RM-HOLE>
				 <TELL "You" walk " upwards, and soon find yourself next to">)
				(T
				 <TELL "You land near">)
			>
			<FSET ,TH-SMITH-HEARTH ,FL-SEEN>
         <TELL
" the castle wall. Set into the ground is the stone hearth of the village
smithy. There is a bush growing next to the wall, and under it appears to be
a hole.|"
         >
         <RFALSE>
      )
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-SMITHY>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTERED>
			<COND
				(<AND <FSET? ,CH-CELL-GUARD ,FL-ASLEEP>
						<FSET? ,TH-SWORD ,FL-LOCKED>
					>
					<MOVE ,CH-MERLIN ,HERE>
					<TELL CR ,K-MERLIN-PRISONER-MSG CR>
					<RT-END-OF-GAME>
				)
			>
		)
      (.CONTEXT
         <RFALSE>
      )
   >
>

<ROUTINE RT-PS-BUSH ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
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
					<TELL "bush">
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? LOOK-UNDER EXAMINE>
		 <THIS-IS-IT ,PSEUDO-OBJECT>
			<TELL
"It's just a small bush nestled up against the castle wall. Below it, you
see a hole." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-SMITH-HEARTH"
;"---------------------------------------------------------------------------"

<OBJECT TH-SMITH-HEARTH
	(LOC RM-SMITHY)
	(FLAGS FL-NO-DESC FL-SURFACE FL-TRY-TAKE)
	(DESC "hearth")
	(SYNONYM SLAB HEARTH STONE)
	(ADJECTIVE STONE SMITHY)
	(OWNER CH-PRISONER)
	(CAPACITY 50)
	(GENERIC RT-GN-STONE)
	(ACTION RT-TH-SMITH-HEARTH)
>

<ROUTINE RT-TH-SMITH-HEARTH ("OPT" (CONTEXT <>))
	<COND
		(<VERB? EXAMINE>
			<FSET ,TH-SMITH-HEARTH ,FL-SEEN>
			<TELL
"It is a simple stone slab set into the ground. It looks as if it hasn't
been used for several days." CR
			>
		)
		(<VERB? RAISE MOVE TAKE>
			<TELL "You cannot move the hearth." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "LG-TOWN"
;"---------------------------------------------------------------------------"

<OBJECT LG-TOWN
	(LOC LOCAL-GLOBALS)
	(DESC "town")
	(SYNONYM TOWN)
	(ACTION RT-LG-TOWN)
>

<ROUTINE RT-LG-TOWN ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? ENTER>
			<COND
				(<MC-HERE? ,RM-TOWN-GATE>
					<RT-DO-WALK ,P?EAST>
				)
				(<MC-HERE? ,RM-PARADE-AREA ,RM-CASTLE-GATE>
					<RT-DO-WALK ,P?WEST>
				)
			>
		)
		(<VERB? EXIT>
			<COND
				(<MC-HERE? ,RM-TOWN-GATE>
					<RT-DO-WALK ,P?WEST>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,LG-TOWN ,FL-SEEN>
			<TELL "It is a small town that grew up around the Roman fort." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-ABOVE-TOWN"
;"---------------------------------------------------------------------------"

<ROOM RM-ABOVE-TOWN
	(LOC ROOMS)
	(DESC "above the town")
	(FLAGS FL-AIR FL-LIGHTED)
	(DOWN PER RT-FLY-DOWN)
	(EAST TO RM-ABOVE-CASTLE)
	(WEST TO RM-ABOVE-MEADOW)
	(NORTH TO RM-ABOVE-MOOR)
	(SW TO RM-ABOVE-FIELD)
	(NE TO RM-ABOVE-BOG)
	(NW TO RM-ABOVE-EDGE-OF-WOODS)
	(UP SORRY K-NO-HIGHER-MSG)
	(GLOBAL RM-TOWN-SQUARE RM-VILLAGE-GREEN RM-CHURCHYARD RM-CHURCH RM-TAVERN LG-TOWN)
	(ACTION RT-RM-ABOVE-TOWN)
>

<ROUTINE RT-RM-ABOVE-TOWN ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,RM-MOOR ,FL-SEEN>
			<FSET ,RM-BOG ,FL-SEEN>
			<FSET ,RM-MEADOW ,FL-SEEN>
			<FSET ,RM-FIELD-OF-HONOUR ,FL-SEEN>
			<FSET ,LG-CASTLE ,FL-SEEN>
			<TELL
"You are hovering over the town. Way off to the north you can see the moor,
and east of that you see a large patch of fog. A flick of your wings would
take you westward to the meadow, or southwestward to the Field of Honour. In
the distance to the northwest lies the edge of the forest. If you flew east,
you would be over the castle.|"
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

