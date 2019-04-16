;"***************************************************************************"
; "game : Arthur"
; "file : ICE-HOT.ZIL"
; "auth :   $Author:   RAB  $"
; "date :     $Date:   15 May 1989 16:20:44  $"
; "revs : $Revision:   1.54  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Ice Room/Hot Room"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "RM-ICE-ROOM"
;"---------------------------------------------------------------------------"

<ROOM RM-ICE-ROOM
	(LOC ROOMS)
	(DESC "ice room")
	(FLAGS FL-LIGHTED FL-INDOORS)
	(SYNONYM ROOM)
	(ADJECTIVE ICE COLD)
	(SW TO RM-CAVE)
	(OUT TO RM-CAVE)
	(GLOBAL LG-WALL)
	(ACTION RT-RM-ICE-ROOM)
	(THINGS
		ICE (ICE ICICLE ICICLES STALACTITE STALAGMITE) RT-PS-ICE
	)
>

<ROUTINE RT-RM-ICE-ROOM ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "You are" standing " in">
				)
				(T
					<TELL "The tunnel broadens out to">
				)
			>
			<TELL
" a frigid room whose walls are lined with ice. It is so cold that your
breath freezes as soon as it comes out of your mouth - whereupon it falls
to the ground and shatters.|"
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<VERB? SAY $PASSWORD HELLO GOODBYE YELL>
					<COND
						(<AND <IN? ,TH-ICE ,RM-ICE-ROOM>
								<NOT <FSET? ,TH-ICE ,FL-TOUCHED>>
							>
							<FCLEAR ,TH-ICE ,FL-SEEN>
							<FCLEAR ,TH-ICE ,FL-TOUCHED>
							<REMOVE ,TH-ICE>
							<RT-DEQUEUE ,RT-I-ICE-FALL>
							<TELL The ,TH-ICE ,K-ICE-FALL-MSG CR CR>
						)
					>
					<DIROUT ,D-TABLE-ON ,GL-ICE-TEXT>
					<COND
						(<VERB? $PASSWORD>
							<TELL "nudd">
						)
						(<VERB? HELLO>
							<TELL "hello">
						)
						(<VERB? GOODBYE>
							<TELL "goodbye">
						)
						(<VERB? YELL>
							<TELL "AAAaaaarrrrrrrrrgh">
						)
						(<EQUAL? ,INTQUOTE ,PRSO ,PRSI>
							<PRINT-INTQUOTE>
						)
						(<VERB? SAY>
							<NP-PRINT ,PRSO-NP>
						)
					>
					<DIROUT ,D-TABLE-OFF>
					<MOVE ,TH-ICE ,RM-ICE-ROOM>
					<RT-QUEUE ,RT-I-ICE-FALL <+ ,GL-MOVES 1>>
					<SETG GL-ICE-TEMP 0>
					<TELL
"The words freeze into a block of ice as soon as they come out of your mouth.
It hangs in the air for a second before it starts to fall.|"
					>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-OBJS>>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
							<RT-UPDATE-DESC-WINDOW>
						)
					>
					<RTRUE>
				)
			>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-ICE-ROOM>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTERED>
			<COND
				(<NOT <RT-IS-QUEUED? ,RT-I-TEMP>>
					<RT-QUEUE ,RT-I-TEMP ,GL-MOVES>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-EXIT>
			<COND
				(<RT-META-IN? ,TH-ICE ,CH-PLAYER>
					<RT-QUEUE ,RT-I-ICE-MELT ,GL-MOVES>
				)
				(<RT-META-IN? ,TH-ICE ,RM-ICE-ROOM>
					<REMOVE ,TH-ICE>
				)
			>
			<RFALSE>
		)
		(.CONTEXT
			<RFALSE>
		)
	>
>

<CONSTANT K-EAT-ICE-MSG
"Your tongue immediately freezes to the ice. Panic-stricken, you struggle to
free it, wondering all the while what Merlin will do to you if he discovers
how incredibly stupid you've been. Suddenly you wrench yourself free. Your
tongue hurts so much you'd like to lick it, but you can't figure out how.">

<ROUTINE RT-PS-ICE ("OPT" (CONTEXT <>) (ART <>) (CAP? <>))
	<COND
		(<MC-CONTEXT? ,M-OBJDESC>
			<FCLEAR ,PSEUDO-OBJECT ,FL-PLURAL>
			<FSET ,PSEUDO-OBJECT ,FL-VOWEL>
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
					<TELL "ice">
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<TELL "The stalagmites and stalactites are made of solid ice." CR>
		)
		(<VERB? EAT>
			<TELL ,K-EAT-ICE-MSG CR>
		)
		(<TOUCH-VERB?>
			<TELL "The rock-solid ice remains unaffected by your actions." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-ICE"
;"---------------------------------------------------------------------------"

<OBJECT TH-ICE
	(DESC "block of ice")
	(FLAGS FL-TAKEABLE)
	(SYNONYM BLOCK ICE WORD WORDS)
	(ADJECTIVE ICE)
	(OWNER TH-ICE)
	(SIZE 5)
	(ACTION RT-TH-ICE)
>

<GLOBAL GL-ICE-TEXT:TABLE <ITABLE 80 (BYTE LENGTH) 0>>

<CONSTANT K-ICE-FALL-MSG " falls to the ground and shatters.">

<ROUTINE RT-TH-ICE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<AND <VERB? TAKE>
				<NOT <FSET? ,TH-ICE ,FL-TOUCHED>>
			>
			<COND
				(<RT-DO-TAKE ,TH-ICE>
					<TELL "You catch the block of ice before it hits the ground." CR>
				)
			>
			<RTRUE>
		)
		(<VERB? DROP>
			<COND
				(<IDROP>
					<REMOVE ,TH-ICE>
					<TELL
The+verb ,WINNER "drop" " the block of ice. It strikes" the ,TH-GROUND " and shatters." CR
					>
				)
			>
		)
		(<VERB? EAT>
			<TELL ,K-EAT-ICE-MSG CR>
		)
	>
>

<ROUTINE RT-I-ICE-FALL ()
	<COND
		(<AND <IN? ,TH-ICE ,RM-ICE-ROOM>
				<NOT <FSET? ,TH-ICE ,FL-TOUCHED>>
			>
			<FCLEAR ,TH-ICE ,FL-SEEN>
			<FCLEAR ,TH-ICE ,FL-TOUCHED>
			<REMOVE ,TH-ICE>
			<COND
				(<MC-HERE? ,RM-ICE-ROOM>
					<TELL CR The ,TH-ICE ,K-ICE-FALL-MSG CR>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-OBJS>>
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
>

<GLOBAL GL-ICE-TEMP 0 <> BYTE>

<ROUTINE RT-I-ICE-MELT ("AUX" H L)
	<INC GL-ICE-TEMP>
	<SET H <RT-META-IN? ,TH-ICE ,HERE>>
	<SET L <LOC ,TH-ICE>>
	<COND
		(<AND .H
				<MC-HERE? ,RM-ICE-ROOM>
			>
			<SETG GL-ICE-TEMP 0>
			<TELL CR The ,TH-ICE " refreezes in the cold air." CR>
			<RTRUE>
		)
		(<EQUAL? ,GL-ICE-TEMP 3>
			<COND
				(.H
					<CRLF>
					<COND
						(<ACCESSIBLE? ,TH-ICE>
							<TELL The ,TH-ICE " melts completely, and \"">
							<PRINTT <ZREST ,GL-ICE-TEXT 2> <ZGET ,GL-ICE-TEXT 0>>
							<TELL "\" rings out loud and clear.">
							<COND
								(<AND <MC-HERE? ,RM-HOT-ROOM>
										<EQUAL? <ZGET ,GL-ICE-TEXT 0> 4>
										<EQUAL? <GETB ,GL-ICE-TEXT 2> !\n !\N>
										<EQUAL? <GETB ,GL-ICE-TEXT 3> !\u !\U>
										<EQUAL? <GETB ,GL-ICE-TEXT 4> !\d !\D>
										<EQUAL? <GETB ,GL-ICE-TEXT 5> !\d !\D>
									>
									<TELL
" The face in the door smiles and says, \"Yes. That's it. Very good. Now you
may enter.\"" CR CR

"The door swings open and you walk through. It closes behind you with an
ominous \"clank.\"" CR CR
									>
									<RT-GOTO ,RM-DEMON-HALL T>
								)
								(T
									<CRLF>
								)
							>
						)
						(T
							<TELL
"You hear a muffled voice from within" the <LOC ,TH-ICE> ". It sounded like \""
							>
							<PRINTT <ZREST ,GL-ICE-TEXT 2> <ZGET ,GL-ICE-TEXT 0>>
							<TELL ".\"" CR>
						)
					>
					<COND
						(<EQUAL? .L ,CH-PLAYER>
							<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT>>
							<COND
								(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-INVT>
									<RT-UPDATE-INVT-WINDOW>
								)
							>
						)
						(.H
							<COND
								(<VISIBLE? ,TH-ICE>
									<COND
										(<OR	<EQUAL? .L ,HERE>
												<FSET? .L ,FL-SURFACE>
												<FSET? .L ,FL-TRANSPARENT>
											>
											<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-OBJS>>
											<COND
												(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
													<RT-UPDATE-DESC-WINDOW>
												)
											>
										)
									>
								)
							>
						)
					>
					<REMOVE ,TH-ICE>
					<RTRUE>
				)
			>
		)
		(T
			<RT-QUEUE ,RT-I-ICE-MELT <+ ,GL-MOVES 1>>
		)
	>
	<COND
		(<OR	<NOT .H>
				<NOT <VISIBLE? ,TH-ICE>>
			>
			<RFALSE>
		)
		(<EQUAL? ,GL-ICE-TEMP 1>
			<SET L <LOC ,TH-ICE>>
			<COND
				(<EQUAL? .L ,CH-PLAYER>
					<SET L ,TH-HANDS>
				)
			>
			<TELL "|The block of ice" in .L the .L " begins to melt." CR>
		)
		(<EQUAL? ,GL-ICE-TEMP 2>
			<TELL "|The block is rapidly shrinking." CR>
		)
	>
>

<GLOBAL GL-TEMP 0 <> BYTE>

<ROUTINE RT-I-TEMP ("AUX" (DOWN? <>))
	<COND
		(<MC-HERE? ,RM-ICE-ROOM>
			<SET DOWN? T>
			<COND
				(<G? ,GL-TEMP 0>
					<SETG GL-TEMP -1>
				)
				(T
					<DEC GL-TEMP>
				)
			>
		)
		(<MC-HERE? ,RM-HOT-ROOM>
			<COND
				(<L? ,GL-TEMP 0>
					<SETG GL-TEMP 1>
				)
				(T
					<INC GL-TEMP>
				)
			>
		)
		(<G? ,GL-TEMP 0>
			<SET DOWN? T>
			<DEC GL-TEMP>
		)
		(<L? ,GL-TEMP 0>
			<INC GL-TEMP>
		)
		(T
			<RFALSE>
		)
	>
	<COND
		(<OR	<NOT <ZERO? ,GL-TEMP>>
				<MC-HERE? ,RM-ICE-ROOM ,RM-HOT-ROOM>
			>
			<RT-QUEUE ,RT-I-TEMP <+ ,GL-MOVES 1>>
		)
	>
	<CRLF>
	<COND
		(<EQUAL? ,GL-TEMP 4>
			<TELL "You pass out from the heat and die.|">
			<RT-END-OF-GAME>
		)
		(<EQUAL? ,GL-TEMP -4>
			<TELL "The cold finally overpowers you and you freeze to death.|">
			<RT-END-OF-GAME>
		)
		(<EQUAL? ,GL-TEMP 3 -3>
			<TELL "You won't last much longer in this ">
			<COND
				(<L? ,GL-TEMP 0>
					<TELL "cold">
				)
				(T
					<TELL "heat">
				)
			>
			<TELL "." CR>
		)
		(<EQUAL? ,GL-TEMP 2>
			<TELL "Your blood is beginning to ">
			<COND
				(.DOWN?
					<TELL "cool">
				)
				(T
					<TELL "boil">
				)
			>
			<TELL "." CR>
		)
		(<EQUAL? ,GL-TEMP -2>
			<COND
				(.DOWN?
					<TELL "Your blood is starting to slow down." CR>
				)
				(T
					<TELL "You're beginning to thaw out." CR>
				)
			>
		)
		(<EQUAL? ,GL-TEMP 1>
			<COND
				(.DOWN?
					<TELL "You're feeling much cooler." CR>
				)
				(T
					<TELL "The heat begins to make you sweat." CR>
				)
			>
		)
		(<EQUAL? ,GL-TEMP -1>
			<COND
				(.DOWN?
					<TELL "The cold begins to creep into your bones." CR>
				)
				(T
					<TELL "Your blood is warming up." CR>
				)
			>
		)
		(<EQUAL? ,GL-TEMP 0>
			<TELL "Your body temperature returns to normal." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-HOT-ROOM"
;"---------------------------------------------------------------------------"

<ROOM RM-HOT-ROOM
	(LOC ROOMS)
	(DESC "hot room")
	(FLAGS FL-LIGHTED FL-INDOORS)
	(SYNONYM ROOM)
	(ADJECTIVE HOT)
	(NORTH TO RM-DEMON-HALL IF LG-HOT-DOOR IS OPEN)
	(IN TO RM-DEMON-HALL IF LG-HOT-DOOR IS OPEN)
	(SW TO RM-BAS-LAIR)
	(OUT TO RM-BAS-LAIR)
	(GLOBAL ;LG-HOT-DOOR LG-WALL RM-BAS-LAIR)
	(ACTION RT-RM-HOT-ROOM)
>

<CONSTANT K-DRY-THROAT-MSG
"Your throat is so dry, you can't manage to say a word.">

<ROUTINE RT-RM-HOT-ROOM ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<TELL "You ">
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL "are" standing " in">
				)
				(T
					<COND
						(<NOT <MC-CONTEXT? ,M-F-LOOK>>
							<TELL "re">
						)
					>
					<TELL "enter">
				)
			>
			<TELL
" a room that is unbearably hot. There is a closed door directly to
the north. The door has a face in it.|"
			>
			<COND
				(<MC-CONTEXT? ,M-F-LOOK>
					<TELL
"|The face smiles at you for a moment and then says, \"Welcome to the Hall
of the Demon. Entry to the hall is simple. All you have to do is tell me the
password. I'll even make it simple for you. The password is the name of the
demon who rules within. I'll even tell you his name. It's Nudd.\"||All the
while he speaks, you get hotter and hotter. You begin to feel very
uncomfortable, and your throat becomes parched and dry.|"
					>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<AND <VERB? TELL>
						,P-CONT
					>
					<RFALSE>
				)
				(<SPEAKING-VERB?>
					<TELL ,K-DRY-THROAT-MSG CR>
				)
			>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-HOT-ROOM>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<COND
				(<NOT <RT-IS-QUEUED? ,RT-I-TEMP>>
					<RT-QUEUE ,RT-I-TEMP ,GL-MOVES>
				)
			>
			<COND
				(<FSET? ,LG-HOT-DOOR ,FL-OPEN>
					<FCLEAR ,LG-HOT-DOOR ,FL-OPEN>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-EXIT>
			<FCLEAR ,LG-HOT-DOOR ,FL-OPEN>
			<RFALSE>
		)
		(.CONTEXT
			<RFALSE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "LG-HOT-DOOR"
;"---------------------------------------------------------------------------"

<OBJECT LG-HOT-DOOR
; "So that >DOOR, TELL ME ABOUT FOO won't respond 'The door doesn't see any me here.'"
	(LOC RM-HOT-ROOM)
	(DESC "door")
	(FLAGS FL-ALIVE FL-DOOR FL-OPENABLE)
	(SYNONYM DOOR FACE)
	(ACTION RT-LG-HOT-DOOR)
>

<ROUTINE RT-LG-HOT-DOOR ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-WINNER>
			<COND
				(<MC-HERE? ,RM-HOT-ROOM>
					<TELL ,K-DRY-THROAT-MSG CR>
				)
				(T
					<TELL The+verb ,LG-HOT-DOOR "do" "n't respond." CR>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(<MC-HERE? ,RM-HOT-ROOM>
			<COND
				(<TOUCH-VERB?>
					<TELL
"You edge nearer the door, but it radiates such intense heat that you pull
back." CR
					>
				)
				(<VERB? EXAMINE>
					<COND
						(<NOUN-USED? ,LG-HOT-DOOR ,W?FACE>
							<TELL "It looks like an honest, friendly face." CR>
						)
						(T
							<TELL "The door glows with intense heat." CR>
						)
					>
				)
			>
		)
		(<MC-HERE? ,RM-DEMON-HALL>
			<COND
				(<NOUN-USED? ,LG-HOT-DOOR ,W?FACE>
					<NP-CANT-SEE>
				)
				(<VERB? OPEN>
					<COND
						(<NOT <FSET? ,CH-DEMON ,FL-LOCKED>>
							<COND
								(<NOT <FSET? ,CH-DEMON ,FL-BROKEN>>
									<TELL
"\"Traitor!\" shrieks the demon. A thunderbolt of electricity streaks across
the room and kills you where you stand.|"
									>
									<RT-END-OF-GAME>
								)
							>
						)
					>
				)
				(<VERB? EXAMINE>
					<TELL "From this side, the door doesn't look hot at all." CR>
				)
			>
		)
	>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

