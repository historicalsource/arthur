;"***************************************************************************"
; "game : Arthur"
; "file : FOREST.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   11 May 1989 23:54:18  $"
; "revs : $Revision:   1.25  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Enchanted forest"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "RM-ENCHANTED-FOREST"
;"---------------------------------------------------------------------------"

<ROOM RM-ENCHANTED-FOREST
	(LOC ROOMS)
	(DESC "enchanted forest")
	(FLAGS FL-LIGHTED)
	(NORTH TO RM-TOW-PATH)
	(SOUTH TO RM-EDGE-OF-WOODS)
	(NE TO RM-RAV-PATH)
	(NW TO RM-LEP-PATH)
	(OUT TO RM-EDGE-OF-WOODS)
	(UP PER RT-FLY-UP)
	(GLOBAL LG-ENCHANTED-TREES LG-FOREST LG-PATH)
	(ACTION RT-RM-ENCHANTED-FOREST)
>

<ROUTINE RT-RM-ENCHANTED-FOREST ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<TELL "You">
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL " are" standing " in">
				)
				(T
					<TELL " follow the road into">
				)
			>
			<FSET ,LG-ENCHANTED-TREES ,FL-SEEN>
			<TELL
" the gloom of the enchanted forest. It is dark, mysterious and unnaturally
quiet. The trees loom up at you as you pass by. "
			>
			<COND
				(<MC-FORM? ,K-FORM-ARTHUR>
					<TELL
"Their branches seem to reach out and pluck at you, as if they resent
human presence. "
					>
				)
			>
			<TELL
"Paths disappear into the forest to the northeast, northwest, and north.
The edge of the forest lies to the south.|"
			>
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
; "RM-LEP-PATH"
;"---------------------------------------------------------------------------"

<ROOM RM-LEP-PATH
	(LOC ROOMS)
	(DESC "path")
	(FLAGS FL-LIGHTED)
	(SYNONYM PATH)
	(ADJECTIVE FOREST)
	(NORTH TO RM-SOUTH-OF-CHASM)
	(NW TO RM-CHESTNUT-PATH)
	(SE TO RM-ENCHANTED-FOREST)
	(UP PER RT-FLY-UP)
	(GLOBAL LG-CHESTNUT-TREES LG-ENCHANTED-TREES LG-FOREST LG-PATH)
	(ACTION RT-RM-LEP-PATH)
>

<ROUTINE RT-RM-LEP-PATH ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,LG-CHESTNUT-TREES ,FL-SEEN>
			<TELL
"You are deep within the enchanted forest. A path leads north into the woods,
and to the northwest is a stand of horse chestnut trees. To the southeast you
see the edge of the forest.|"
			>
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
; "LG-ENCHANTED-TREES"
;"---------------------------------------------------------------------------"

<OBJECT LG-ENCHANTED-TREES
	(LOC LOCAL-GLOBALS)
	(DESC "enchanted trees")
	(SYNONYM TREE TREES BRANCH BRANCHES)
	(ADJECTIVE ENCHANTED)
	(GENERIC RT-GN-TREE)
	(ACTION RT-LG-ENCHANTED-TREES)
>

<CONSTANT K-CLIMB-TREE-MSG
"A gnarled, leafy hand knocks you sprawling on the ground and the tree says,
\"'Ere now. 'Ow would you like it if folks was climbin' all over you? Keep to
yourself, mate.\"|">

<ROUTINE RT-LG-ENCHANTED-TREES ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? CLIMB-UP CLIMB-ON>
			<TELL ,K-CLIMB-TREE-MSG>
		)
		(<VERB? EXAMINE>
			<FSET ,LG-ENCHANTED-TREES ,FL-SEEN>
			<TELL
"The trees are dark and sinister. They seem to resent your presence, and you
get the feeling they are closing in on you." CR
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "LG-FOREST"
;"---------------------------------------------------------------------------"

<OBJECT LG-FOREST
	(LOC LOCAL-GLOBALS)
	(DESC "enchanted forest")
	(SYNONYM FOREST WOODS)
	(ADJECTIVE ENCHANTED MAGIC)
	(ACTION RT-LG-FOREST)
>

<ROUTINE RT-LG-FOREST ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? ENTER>
			<COND
				(<MC-HERE? ,RM-EDGE-OF-WOODS>
					<RT-DO-WALK ,P?NORTH>
				)
				(<MC-HERE? ,RM-GLADE>
					<RT-DO-WALK ,P?SOUTH>
				)
				(<MC-HERE? ,RM-GROVE>
					<RT-DO-WALK ,P?SW>
				)
				(<MC-HERE? ,RM-TOW-CLEARING>
					<RT-DO-WALK ,P?SOUTH>
				)
				(<MC-HERE? ,RM-SOUTH-OF-CHASM>
					<RT-DO-WALK ,P?SOUTH>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,LG-ENCHANTED-TREES ,FL-SEEN>
			<THIS-IS-IT ,LG-ENCHANTED-TREES>
			<TELL
"The trees are dark and sinister. They seem to resent your presence, and you
get the feeling they are closing in on you." CR
			>
		)
	>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

