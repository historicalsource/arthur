;"***************************************************************************"
; "game : Arthur"
; "file : BASIL.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   15 May 1989 19:43:24  $"
; "revs : $Revision:   1.41  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Basilisk Puzzle"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

;"***************************************************************************"
; "ROOMS & ROOM ACTIONS"
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "RM-BAS-LAIR"
;"---------------------------------------------------------------------------"

<ROOM RM-BAS-LAIR
	(LOC ROOMS)
	(DESC "basilisk's lair")
	(FLAGS FL-LIGHTED FL-INDOORS)
	(SYNONYM LAIR)
	(ADJECTIVE BASILISK)
	(OWNER CH-BASILISK)
 	(NE PER RT-EXIT-BAS-LAIR)
	(IN PER RT-EXIT-BAS-LAIR)
	(SE TO RM-CAVE)
	(OUT TO RM-CAVE)
	(GLOBAL LG-WALL)
	(ACTION RT-RM-BAS-LAIR)
	(THINGS
		STONE (STATUE STATUES KNIGHT KNIGHTS) RT-PS-STATUES
		NE (TUNNEL TUNNELS) RT-PS-TUNNEL
	)
>

<ROUTINE RT-RM-BAS-LAIR ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "You are" standing " in">
				)
				(T
					<TELL "The tunnel widens out into">
				)
			>
			<TELL
" a chamber full of grotesque statues. Upon closer examination, you realize
with horror that they are knights who have been turned into stone. The tunnel
takes a turn to the "
			>
			<COND
				(<EQUAL? ,OHERE ,RM-HOT-ROOM>
					<TELL "sou">
				)
				(T
					<TELL "nor">
				)
			>
			<TELL "theast">
			<COND
				(<IN? ,CH-BASILISK ,RM-BAS-LAIR>
					<FSET ,CH-BASILISK ,FL-SEEN>
					<THIS-IS-IT ,CH-BASILISK>
					<COND
						(<FSET? ,CH-BASILISK ,FL-ALIVE>
							<TELL
", but the passage into the mountain is blocked by a sleeping basilisk"
							>
						)
						(T
							<TELL
", and in the middle of the room is a basilisk made of solid stone"
							>
						)
					>
				)
			>
			<TELL "." CR>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-BASILISK-LAIR>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTERED>
			<COND
				(<AND <IN? ,CH-BASILISK ,RM-BAS-LAIR>
						<FSET? ,CH-BASILISK ,FL-ALIVE>
					>
					<RT-QUEUE ,RT-I-BASILISK-1 <+ ,GL-MOVES 1>>
					<THIS-IS-IT ,CH-BASILISK>
					<TELL
"|The noise of your entry awakens the basilisk, who begins to cast around
bleary-eyed for the source of the sound." CR
					>
				)
			>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<AND <VERB? TELL>
						,P-CONT
					>
					<RFALSE>
				)
				(<AND <SPEAKING-VERB?>
						<FSET? ,CH-BASILISK ,FL-ALIVE>
					>
					<THIS-IS-IT ,CH-BASILISK>
					<TELL
"Making noise only seems to help the basilisk find you faster." CR
					>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
	>
>

<ROUTINE RT-EXIT-BAS-LAIR ("OPT" (QUIET <>))
	<COND
		(<AND <FSET? ,CH-BASILISK ,FL-ALIVE>
				<NOT .QUIET>
			>
			<TELL
"As you try to step over" the ,CH-BASILISK ", it looks up at you and you are
turned to stone in mid-step. You topple to the floor and shatter, although by
the time you hit the ground you are too dead to care.|"
			>
			<RT-END-OF-GAME>
		)
		(T
			<RETURN ,RM-HOT-ROOM>
		)
	>
>

<ROUTINE RT-PS-STATUES ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
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
					<TELL "statues">
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "CH-BASILISK"
;"---------------------------------------------------------------------------"

<OBJECT CH-BASILISK
	(LOC RM-BAS-LAIR)
	(DESC "basilisk")
	(FLAGS FL-ALIVE FL-NO-DESC FL-OPEN FL-SEARCH FL-TRY-TAKE)
	(SYNONYM BASILISK)
	(ACTION RT-CH-BASILISK)
>

<ROUTINE RT-CH-BASILISK ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-WINNER>
			<COND
				(<FSET? ,CH-BASILISK ,FL-ALIVE>
					<THIS-IS-IT ,CH-BASILISK>
					<TELL
"Making noise only seems to help the basilisk find you faster." CR
					>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<AND <VERB? TELL>
				,P-CONT
			>
			<RFALSE>
		)
		(<AND <TOUCH-VERB?>
				<FSET? ,CH-BASILISK ,FL-ALIVE>
			>
			<TELL
"As you approach" the ,CH-BASILISK ", it looks up at you and you are turned
to stone in mid-step. You topple to the floor and shatter, although by the
time you hit the ground you are too dead to care.|"
			>
			<RT-END-OF-GAME>
		)
		(<VERB? TAKE>
			<TELL
The ,CH-BASILISK " is firmly rooted to the floor of the cave." CR
			>
		)
		(<VERB? EXAMINE>
			<FSET ,CH-BASILISK ,FL-SEEN>
			<TELL
The ,CH-BASILISK " looks like either a large lizard or a small dragon."
			>
			<COND
				(<NOT <FSET? ,CH-BASILISK ,FL-ALIVE>>
					<TELL " It has turned to solid stone.">
				)
			>
			<CRLF>
		)
	>
>

<ROUTINE RT-I-BASILISK-1 ()
	<COND
		(<MC-HERE? ,RM-BAS-LAIR>
			<RT-QUEUE ,RT-I-BASILISK-2 <+ ,GL-MOVES 1>>
			<TELL
"|The basilisk turns towards you. Its glance is about to fall upon you." CR
			>
		)
	>
>

<ROUTINE RT-I-BASILISK-2 ()
	<COND
		(<MC-HERE? ,RM-BAS-LAIR>
			<TELL
"|The basilisk's eye falls upon you and suddenly your feet feel very cold.
Glancing down, you see with horror that they have turned to stone. The
deadening sensation quickly works its way up your legs. A terrified cry forms
in your throat, but it never makes it out of your mouth. In an instant, the
petrification is complete.|"
			>
			<RT-END-OF-GAME>
		)
	>
>

<ROUTINE RT-KILL-BASILISK ()
	<FCLEAR ,CH-BASILISK ,FL-ALIVE>
	<RT-DEQUEUE ,RT-I-BASILISK-1>
	<RT-DEQUEUE ,RT-I-BASILISK-2>
	<THIS-IS-IT ,CH-BASILISK>
	<TELL
"The glint of the highly-polished shield attracts the basilisk's attention.
Slowly it turns its head towards you, and then suddenly it catches a glimpse
of its own reflection. The life immediately drains out of the creature, and
you realize with fascination that it has turned itself into stone.|"
	>
	<RT-SCORE-MSG 0 2 5 2>
	<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
	<COND
		(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
			<RT-UPDATE-DESC-WINDOW>
		)
	>
	<RTRUE>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

