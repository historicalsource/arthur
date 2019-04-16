;"***************************************************************************"
; "game : Arthur"
; "file : LADY.ZIL"
; "auth :   $Author:   RAB  $"
; "date :     $Date:   15 May 1989 12:17:18  $"
; "revs : $Revision:   1.58  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Lady of the Lake puzzle"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "RM-ISLAND"
;"---------------------------------------------------------------------------"

<ROOM RM-ISLAND
	(LOC ROOMS)
	(DESC "island")
	(FLAGS FL-LIGHTED)
	(SYNONYM ISLAND)
	(ADJECTIVE ROCKY MYSTERIOUS)
	(NORTH TO RM-CAUSEWAY)
	(IN TO RM-UG-CHAMBER IF LG-SILVER-DOOR IS OPEN)
	(DOWN TO RM-UG-CHAMBER IF LG-SILVER-DOOR IS OPEN)
	(UP PER RT-FLY-UP)
	(GLOBAL LG-SILVER-DOOR RM-CAUSEWAY RM-UG-CHAMBER)
	(ACTION RT-RM-ISLAND)
	(THINGS <> (ROCK ROCKS) RT-PS-ROCKS)
>

<GLOBAL GL-PICT-SILVER-DOOR? <> <> BYTE>	; "Is silver door open in picture?"

<ROUTINE RT-RM-ISLAND ("OPT" (CONTEXT <>) "AUX" OPEN?)
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "You are" standing " on">
				)
				(T
					<COND
						(<EQUAL? ,OHERE ,RM-CAUSEWAY>
							<TELL "You" walk " along the causeway, which ends on">
						)
						(<EQUAL? ,OHERE, RM-UG-CHAMBER>
							<TELL "You climb the stairs and emerge once again onto">
						)
						(T
							<TELL "You fold your wings and land gracefully on">
						)
					>
				)
			>
			<TELL " the rocky island. ">
			<COND
				(<EQUAL? ,OHERE ,RM-UG-CHAMBER>
					<TELL "Behind you">
				)
				(T
					<TELL "In front of you">
				)
			>
			<FSET ,LG-SILVER-DOOR ,FL-SEEN>
			<TELL " is a silver door set into the rocks.">
			<COND
				(<FSET? ,LG-SILVER-DOOR ,FL-OPEN>
					<TELL
" Beyond the open door, a staircase leads down into the rocks."
					>
				)
			>
			<TELL " The causeway runs north to the mainland." CR>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-ISLAND>
			<COND
				(<FSET? ,LG-SILVER-DOOR ,FL-OPEN>
					<SETG GL-PICT-SILVER-DOOR? T>
				)
				(T
					<SETG GL-PICT-SILVER-DOOR? <>>
				)
			>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-END>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<COND
						(<FSET? ,LG-SILVER-DOOR ,FL-OPEN>
							<SET OPEN? T>
						)
						(T
							<SET OPEN? <>>
						)
					>
					<COND
						(<NOT <EQUAL? .OPEN? ,GL-PICT-SILVER-DOOR?>>
							<SETG GL-PICT-SILVER-DOOR? .OPEN?>
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
		(<AND <VERB? EXAMINE>
				<NOT <MC-HERE? ,RM-ISLAND>>
			>
			<TELL
"The island is rocky and mysterious, as if it were home to some enchanted
being." CR
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-UG-CHAMBER"
;"---------------------------------------------------------------------------"

<ROOM RM-UG-CHAMBER
	(LOC ROOMS)
	(DESC "underground chamber")
	(FLAGS FL-INDOORS FL-LIGHTED)
	(SYNONYM CHAMBER)
	(ADJECTIVE UNDERGROUND)
	(OUT TO RM-ISLAND IF LG-SILVER-DOOR IS OPEN)
	(UP TO RM-ISLAND IF LG-SILVER-DOOR IS OPEN)
	(GLOBAL LG-SILVER-DOOR LG-WINDOW LG-WALL RM-ISLAND)
	(ACTION RT-RM-UG-CHAMBER)
>

<ROUTINE RT-RM-UG-CHAMBER ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "You are" standing>
				)
				(T
					<TELL "You" walk " down the stairs and find yourself">
				)
			>
			<TELL " in an underground chamber, far below the lake's surface.">
			<FSET ,TH-BIER ,FL-SEEN>
			<COND
				(<IN? ,CH-NIMUE ,TH-BIER>
					<FSET ,CH-NIMUE ,FL-SEEN>
					<TELL
" Lying on a bier in the middle of the chamber is a beautiful woman.|"
					>
				)
				(T
					<TELL	" In the middle of the chamber is" a ,TH-BIER "." CR>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<COND
				(<IN? ,CH-NIMUE ,TH-BIER>
					<SETG GL-PICTURE-NUM ,K-PIC-CHAMBER-WOMAN>
				)
				(T
					<SETG GL-PICTURE-NUM ,K-PIC-CHAMBER>
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
				(<NOT <FSET? ,CH-NIMUE ,FL-ASLEEP>>
					<RT-WAKE-LADY>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "CH-NIMUE"
;"---------------------------------------------------------------------------"

<OBJECT CH-NIMUE
	(LOC TH-BIER)
	(DESC "beautiful woman")
	(FLAGS FL-ALIVE FL-ASLEEP FL-FEMALE FL-NO-LIST FL-OPEN FL-PERSON FL-SEARCH)
	(SYNONYM LADY WOMAN NIMUE PERSON)
	(ADJECTIVE BEAUTIFUL LOVELY RESTING SLEEPING)
	(OWNER LG-LAKE)
	(SIZE 50)
	(CONTFCN RT-CH-NIMUE)
	(GENERIC RT-GN-BEAUTIFUL-WOMAN)
	(ACTION RT-CH-NIMUE)
>

<CONSTANT K-ENCHANTMENT-MSG "She's under a spell. She can't hear you.">

<ROUTINE RT-CH-NIMUE ("OPT" (CONTEXT <>))
	<COND
		(<OR	<MC-CONTEXT? ,M-WINNER>
				<AND
					<VERB? HELLO GOODBYE THANK>
					<MC-CONTEXT? <>>
				>
			>
			<TELL ,K-ENCHANTMENT-MSG CR>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,CH-NIMUE ,FL-SEEN>
			<COND
				(<FSET? ,CH-NIMUE ,FL-ASLEEP>
					<TELL
"She is lying on a bier. Her eyes are closed and her cheeks are pale. Her
breathing is very shallow." CR
					>
					<RT-AUTHOR-MSG "Everything you always wanted on a bier....">
				)
				(T
					<TELL "She has the beauty of a goddess." CR>
				)
			>
		)
		(<VERB? KISS>
			<COND
				(<MC-FORM? ,K-FORM-ARTHUR>
					<TELL
"Kissing" the ,CH-NIMUE " fails to break the enchantment." CR
					>
					<RT-AUTHOR-MSG "But it was worth a shot.">
				)
				(T
					<TELL ,K-NOTHING-HAPPENS-MSG CR>
					<RT-AUTHOR-ON>
					<TELL Form " kisses don't do a thing for her.">
					<RT-AUTHOR-OFF>
				)
			>
		)
		(<VERB? CALL SAY YELL>
			<RT-CALL-NIMUE>
		)
	>
>

<ROUTINE RT-WAKE-LADY ()
	<COND
		(<NOT <IN? ,CH-NIMUE ,TH-BIER>>
			<RFALSE>
		)
		(<FSET? ,TH-HAWTHORN ,FL-BROKEN>
			<TELL
The ,TH-HAWTHORN " has no effect. Perhaps because it has not yet bloomed." CR
			>
		)
		(T
			<FCLEAR ,TH-BIER ,FL-NO-DESC>
			<MOVE ,TH-GAUNTLET ,TH-BIER>
			<REMOVE ,CH-NIMUE>
			<COND
				(<FSET? ,CH-NIMUE ,FL-ASLEEP>
					<FCLEAR ,CH-NIMUE ,FL-ASLEEP>
					<TELL
"The woman's eyelids flutter briefly, and then she awakes. She"
					>
				)
				(T
					<TELL "|The woman">
				)
			>
			<TELL
" arises and says \"Welcome, Arthur. I am Nimue, the Lady of the Lake. Lo
these many years have I languished under the spell of the evil mountain
demon. But even in my enchantment have I followed your adventures.||Because
you have freed me, I too shall help you. Take this gauntlet and use it to
challenge King Lot. You will have to fight him upon the Field of Honour, but
if you keep your wits about you, he will be at your mercy. When you have
dealt with him, call my name. Then shall the mighty sword Excalibur become
yours.\"||Before you can thank her she vanishes in a flash of light leaving
the gauntlet behind lying on the bier.|"
			>
			<RT-SCORE-MSG 10 0 0 2>
			<SETG GL-PICTURE-NUM ,K-PIC-CHAMBER>
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
>

<ROUTINE RT-CALL-NIMUE ()
	<COND
		(<AND <FSET? ,CH-LOT ,FL-LOCKED>
				<FSET? ,CH-LOT ,FL-BROKEN>
				<FSET? ,RM-MID-LAKE ,FL-WATER>
			>
			<FCLEAR ,RM-SHALLOWS ,FL-WATER>
			<FCLEAR ,RM-MID-LAKE ,FL-WATER>
			<FCLEAR ,RM-MID-LAKE ,FL-TOUCHED>	; "To cause F-LOOK upon entering lake"
			<FCLEAR ,RM-MID-LAKE ,FL-SEEN>
			<MOVE ,TH-BOAT ,RM-MID-LAKE>
		;	<FCLEAR ,TH-STONE ,FL-NO-DESC>
		;	<FCLEAR ,TH-EXCALIBUR ,FL-NO-DESC>
			<FCLEAR ,TH-EXCALIBUR ,FL-TRY-TAKE>
			<FSET ,TH-EXCALIBUR ,FL-TAKEABLE>
			<TELL
"When you cry out, the winds come up and the sky goes dark. The waters of the
lake begin to churn, and suddenly they pull back on either side to reveal
a perfectly dry path that leads south to the center of the lake." CR
			>
			<RT-SCORE-MSG 0 0 0 1>
		;	<COND
				(<MC-HERE? ,RM-SHALLOWS>
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

<ROUTINE RT-GN-BEAUTIFUL-WOMAN (TBL FINDER)
	<RETURN ,CH-NIMUE>
>

;"---------------------------------------------------------------------------"
; "TH-LADY-NOSE"
;"---------------------------------------------------------------------------"

<OBJECT TH-LADY-NOSE
	(LOC CH-NIMUE)
	(DESC "nose")
	(FLAGS FL-NO-DESC)
	(SYNONYM NOSE)
	(OWNER CH-NIMUE)
>

;"---------------------------------------------------------------------------"
; "TH-BIER"
;"---------------------------------------------------------------------------"

<OBJECT TH-BIER
	(LOC RM-UG-CHAMBER)
	(DESC "stone bier")
	(FLAGS FL-NO-DESC FL-SEARCH FL-SURFACE)
	(SYNONYM BIER)
	(ADJECTIVE STONE)
	(ACTION RT-TH-BIER)
	(CAPACITY 50)
>

<ROUTINE RT-TH-BIER ("OPT" (CONTEXT <>))
	<COND
		(<VERB? EXAMINE>
			<FSET ,TH-BIER ,FL-SEEN>
			<TELL "It looks like an ordinary bier">
			<COND
				(<IN? ,CH-NIMUE ,TH-BIER>
					<FCLEAR ,CH-NIMUE ,FL-NO-DESC>
				)
			>
			<COND
				(<SEE-ANYTHING-IN? ,TH-BIER>
					<TELL " with">
					<PRINT-CONTENTS ,TH-BIER>
					<TELL " lying on it">
				)
			>
			<COND
				(<IN? ,CH-NIMUE ,TH-BIER>
					<FSET ,CH-NIMUE ,FL-NO-DESC>
				)
			>
			<TELL "." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-GAUNTLET"
;"---------------------------------------------------------------------------"

<OBJECT TH-GAUNTLET
	(DESC "gauntlet")
	(FLAGS FL-TAKEABLE)
	(SYNONYM GAUNTLET GLOVE)
	(ADJECTIVE METAL HEAVY ARMOURED)
	(SCORE <LSH 1 ,K-QUEST-SHIFT>)
	(SIZE 5)
	(ACTION RT-TH-GAUNTLET)
>

<ROUTINE RT-TH-GAUNTLET ("OPT" (CONTEXT <>) "AUX" V)
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-GAUNTLET ,FL-SEEN>
			<TELL "It looks like an armoured glove." CR>
		)
		(<VERB? WEAR>
			<FSET ,TH-GAUNTLET ,FL-SEEN>
			<TELL "The gauntlet is much too big for you." CR>
		)
		(<MC-HERE? ,RM-GREAT-HALL>
			<COND
				(<OR	<VERB? DROP>
						<AND
							<VERB? THROW>
							<MC-PRSI? ,CH-LOT>
						>
					>
					<RT-TRIGGER-ENDGAME>
				)
			>
		)
		(<VERB? TAKE>
			<COND
				(<IN? ,TH-GAUNTLET ,TH-BIER>
					<COND
						(<NOT <FSET? ,TH-GAUNTLET ,FL-TOUCHED>>
							<SET V <ITAKE>>
							<COND
								(<EQUAL? .V <> ,M-FATAL>
									<SETG CLOCK-WAIT T>
									<RFATAL>
								)
								(T
									<TELL
The+verb ,WINNER "take" the ,PRSO " from" the ,TH-BIER "." CR
									>
									<RT-SCORE-OBJ ,TH-GAUNTLET>
									<COND
										(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
											<RT-UPDATE-PICT-WINDOW>
										)
									>
									<RT-DO-TAKE ,TH-GAUNTLET>
									<RTRUE>
								)
							>
						)
					>
				)
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "LG-SILVER-DOOR"
;"---------------------------------------------------------------------------"

<OBJECT LG-SILVER-DOOR
	(LOC LOCAL-GLOBALS)
	(DESC "silver door")
	(FLAGS FL-AUTO-OPEN FL-DOOR FL-OPENABLE FL-LOCKED FL-NO-DESC)
	(SYNONYM DOOR LOCK KEYHOLE)
	(ADJECTIVE SILVER)
	(SCORE <LSH 1 ,K-QUEST-SHIFT>)
	(ACTION RT-LG-SILVER-DOOR)
>

<ROUTINE RT-LG-SILVER-DOOR ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,LG-SILVER-DOOR ,FL-SEEN>
			<TELL "It's a solid silver door, with a solid silver keyhole." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-HAWTHORN"
;"---------------------------------------------------------------------------"

<OBJECT TH-HAWTHORN
	(LOC RM-THORNEY-ISLAND)
	(DESC "sprig of hawthorn")
	(FLAGS FL-BURNABLE FL-BROKEN FL-NO-LIST FL-TAKEABLE)
	(SYNONYM THORN HAWTHORN HAWTHORNE SPRIG TWIG BUD FLOWER BLOOM BLOSSOM)
	(ADJECTIVE THORNY BEAUTIFUL)
	(OWNER TH-HAWTHORN)
	(SCORE 0)	; "Set when player drops thorn by xform"
	(SIZE 1)
	(ACTION RT-TH-HAWTHORN)
>

; "TH-HAWTHORN flags:"
; "	FL-BROKEN - Flower has not bloomed"

<ROUTINE RT-TH-HAWTHORN ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<COND
				(<VERB? TOUCH>
					<COND
						(<MC-PRSO? ,CH-NIMUE ,TH-LADY-NOSE>
							<RT-WAKE-LADY>
						)
					>
				)
			>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-HAWTHORN ,FL-SEEN>
			<COND
				(<NOUN-USED? ,TH-HAWTHORN ,W?BUD>
					<COND
						(<FSET? ,TH-HAWTHORN ,FL-BROKEN>
							<TELL "It looks about ready to burst into flower." CR>
						)
						(T
							<TELL "It has blossomed into a beautiful flower." CR>
						)
					>
				)
				(<NOUN-USED? ,TH-HAWTHORN ,W?FLOWER ,W?BLOSSOM ,W?BLOOM>
					<COND
						(<FSET? ,TH-HAWTHORN ,FL-BROKEN>
							<TELL "The bud has not yet blossomed." CR>
						)
						(T
							<TELL "It is a beautiful hawthorn flower." CR>
						)
					>
				)
				(T
					<TELL "It is a thorny hawthorn twig with a small ">
					<COND
						(<FSET? ,TH-HAWTHORN ,FL-BROKEN>
							<TELL "bud">
						)
						(T
							<TELL "flower">
						)
					>
					<TELL " on the end." CR>
				)
			>
		)
		(<OR	<AND
					<VERB? HOLD-UNDER>
					<MC-PRSI? ,TH-LADY-NOSE>
				>
				<AND
					<VERB? GIVE WAVE-AT PUT>
					<MC-PRSI? ,CH-NIMUE>
				>
			>
			<COND
				(<VERB? GIVE PUT>
					<MOVE ,TH-HAWTHORN ,CH-NIMUE>
					<TELL
The+verb ,WINNER "place" the ,TH-HAWTHORN " in her hands. "
					>
				)
			>
			<RT-WAKE-LADY>
		)
	>
>

<ROUTINE RT-I-BLOOM ("AUX" (MSG? <>))
	<FCLEAR ,TH-HAWTHORN ,FL-BROKEN>
	<COND
		(<VISIBLE? ,TH-HAWTHORN>
			<SET MSG? T>
			<TELL CR The ,TH-HAWTHORN " blossoms into a beautiful flower." CR>
		)
	>
	<COND
		(<IN? ,TH-HAWTHORN ,CH-NIMUE>
			<COND
				(<MC-HERE? ,RM-UG-CHAMBER>
					<SET MSG? T>
					<CRLF>
					<RT-WAKE-LADY>
				)
				(T
					<FCLEAR ,CH-NIMUE ,FL-ASLEEP>
					<RFALSE>
				)
			>
		)
	>
	<RETURN .MSG?>
>

;"---------------------------------------------------------------------------"
; "RM-LAKE-WINDOW"
;"---------------------------------------------------------------------------"

<ROOM RM-LAKE-WINDOW
	(LOC ROOMS)
	(DESC "lake")
	(FLAGS FL-LIGHTED FL-WATER)
	(WEST TO RM-MID-LAKE)
	(EAST PER RT-WINDOW-UP)
	(UP PER RT-WINDOW-UP)
	(ADJACENT <TABLE (PURE LENGTH BYTE) RM-UG-CHAMBER T>)
	(GLOBAL LG-WINDOW LG-LAKE RM-ISLAND)
	(ACTION RT-RM-LAKE-WINDOW)
	(THINGS <> (ROCK ROCKS) RT-PS-ROCKS)
>

<ROUTINE RT-RM-LAKE-WINDOW ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "You are" walking " near">
				)
				(T
					<TELL "You" walk " towards">
				)
			>
			<FSET ,LG-WINDOW ,FL-SEEN>
			<TELL
" the island. There is a window in the rock through which light is coming.
The middle of the lake lies behind you to the west.|"
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<COND
				(<IN? ,CH-NIMUE ,TH-BIER>
					<SETG GL-PICTURE-NUM ,K-PIC-WINDOW-WOMAN>
				)
				(T
					<SETG GL-PICTURE-NUM ,K-PIC-WINDOW>
				)
			>
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

<CONSTANT K-ROCKS-STEEP-MSG "The rocks are too steep to climb.|">

<ROUTINE RT-WINDOW-UP ("OPT" (QUIET <>))
	<COND
		(.QUIET
			<RFALSE>
		)
		(T
			<COND
				(<MC-FORM? ,K-FORM-EEL>
					<TELL
The+verb ,WINNER "ascend" " for a quick look around, but see nothing
interesting." CR
					>
				)
				(T
					<TELL ,K-ROCKS-STEEP-MSG>
				)
			>
			<RETURN ,ROOMS>
		)
	>
>

<ROUTINE RT-PS-ROCKS ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
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
		(<AND <NOT <MC-HERE? ,RM-LAKE-WINDOW ,RM-ISLAND>>
				<OR
					<TOUCH-VERB?>
					<VERB? EXAMINE ENTER>
				>
			>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<TELL "The rocks lie well to the ">
			<COND
				(<MC-HERE? ,RM-MID-LAKE>
					<TELL "east">
				)
				(<MC-HERE? ,RM-CAUSEWAY>
					<TELL "south">
				)
			>
			<TELL "." CR>
		)
		(<VERB? EXAMINE>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<TELL "The sheer rocks rise straight out of the water." CR>
		)
		(<VERB? ENTER>
			<COND
				(<MC-HERE? ,RM-LAKE-WINDOW>
					<THIS-IS-IT ,LG-WINDOW>
					<TELL "The window is firmly sealed. It can't be opened." CR>
				)
			>
		)
		(<VERB? CLIMB-ON CLIMB-UP CLIMB-OVER>
			<THIS-IS-IT ,PSEUDO-OBJECT>
			<TELL ,K-ROCKS-STEEP-MSG>
		)
	>
>

;"---------------------------------------------------------------------------"
; "LG-WINDOW"
;"---------------------------------------------------------------------------"

<OBJECT LG-WINDOW
	(LOC LOCAL-GLOBALS)
	(DESC "window")
	(SYNONYM WINDOW)
	(ACTION RT-LG-WINDOW)
>

<ROUTINE RT-LG-WINDOW ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE LOOK-THRU LOOK-IN>
			<FSET ,LG-WINDOW ,FL-SEEN>
			<COND
				(<MC-HERE? ,RM-LAKE-WINDOW>
					<FSET ,RM-UG-CHAMBER ,FL-SEEN>
					<FSET ,TH-BIER ,FL-SEEN>
					<TELL "Through the window you see an underground chamber. ">
					<COND
						(<IN? ,CH-NIMUE ,TH-BIER>
							<FSET ,CH-NIMUE ,FL-SEEN>
							<TELL
"Lying on a bier in the middle of the chamber is a beautiful woman." CR
							>
						)
						(T
							<TELL
"In the middle of the chamber is an empty bier." CR
							>
						)
					>
				)
				(T
					<TELL "Through the window you see only water." CR>
				)
			>
		)
		(<VERB? OPEN ENTER>
			<TELL "The window is firmly sealed. It can't be opened." CR>
		)
		(<VERB? BREAK>
			<TELL The ,WINNER " can't break the window." CR>
		)
	>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

