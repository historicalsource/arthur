;"***************************************************************************"
; "game : Arthur"
; "file : VERBS.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   16 May 1989  1:19:22  $"
; "rev  : $Revision:   1.221  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Verbs"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

<INCLUDE "BASEDEFS" "PDEFS">

<GLOBAL VERBOSITY 2>

<ROUTINE V-DESC-LEVEL ()
	<TELL "[">
	<COND
		(<EQUAL? ,P-PRSA-WORD ,W?SUPER ,W?SUPERBRIEF>
		;	<SETG VERBOSITY 0>
			<TELL "Super brief is not supported">
		)
		(T
			<COND
				(<EQUAL? ,P-PRSA-WORD ,W?BRIEF>
					<SETG VERBOSITY 1>
					<TELL "Brief">
				)
				(T
					<SETG VERBOSITY 2>
					<TELL "Verbose">
				)
			>
			<TELL " descriptions">
		)
	>
	<TELL ".]" CR>
>

<ROUTINE TRANSCRIPT (STR)
	<TELL "Transcript: " .STR CR>
>

<ROUTINE V-SCRIPT ()
	<COND
		(<EQUAL? ,P-PRSA-WORD ,W?SCRIPT>
			<DIROUT ,K-D-PRT-ON>
			<TRANSCRIPT "Begin">
		)
		(T
			<TRANSCRIPT "End">
			<DIROUT ,K-D-PRT-OFF>
		)
	>
	<RTRUE>
>

<ROUTINE V-VERIFY ()
	<COND
		(,PRSO
			<COND
				(<AND <MC-PRSO? ,INTNUM>
						<EQUAL? ,P-NUMBER 105>
					>
					<TELL N ,SERIAL CR>
				)
				(T
					<DONT-UNDERSTAND>
				)
			>
		)
		(T
			<TELL "Verifying... ">
			<COND
				(<VERIFY>
					<TELL "Correct">
				)
				(T
					<TELL "Error">
				)
			>
			<TELL "." CR>
		)
	>
>

<ROUTINE V-UNDO ()
	<COND
		(,P-CAN-UNDO
			<COND
				(<ZERO? <IRESTORE>>
					<TELL "[UNDO failed.]" CR>
					<RTRUE>
				)
			>
		)
	>
	<TELL "[UNDO is not available.]" CR>
>

%<DEBUG-CODE <ROUTINE V-COMMAND () <DIRIN 1> <RTRUE>>>
%<DEBUG-CODE <ROUTINE V-RECORD () <DIROUT ,D-RECORD-ON> <RTRUE>>>
%<DEBUG-CODE <ROUTINE V-UNRECORD () <DIROUT ,D-RECORD-OFF> <RTRUE>>>

<ROUTINE V-INVENTORY ("AUX" OBJ NXT (H? <>))
	<SET OBJ <FIRST? ,WINNER>>
	<REPEAT ()
		<COND
			(<NOT .OBJ>
				<RETURN>
			)
			(T
				<SET NXT <NEXT? .OBJ>>
				<COND
					(<FSET? .OBJ ,FL-WORN>
						<MOVE .OBJ ,PSEUDO-OBJECT>
						<COND
							(<EQUAL? .OBJ ,TH-HAWTHORN>
								<SET H? T>
								<FSET ,TH-HAWTHORN ,FL-NO-DESC>
							)
						>
					)
				>
				<SET OBJ .NXT>
			)
		>
	>
	<TELL The+verb ,WINNER "are" " holding">
	<COND
		(<NOT <PRINT-CONTENTS ,WINNER T>>
			<TELL " nothing">
		)
	>
	<COND
		(<SEE-ANYTHING-IN? ,PSEUDO-OBJECT>
			<TELL ". " He+verb ,WINNER "are" " wearing">
			<PRINT-CONTENTS ,PSEUDO-OBJECT>
			<RT-MOVE-ALL ,PSEUDO-OBJECT ,WINNER>
		)
	>
	<COND
		(.H?
			<FCLEAR ,TH-HAWTHORN ,FL-NO-DESC>
			<TELL ". " A+verb ,TH-HAWTHORN "are" " attached to your fur">
		)
	>
	<TELL "." CR>
>

<ROUTINE V-QUIT ("OPTIONAL" (ASK? T))
	<V-SCORE>
	<TELL CR "Are you sure you wish to quit?" CR>
	<COND
		(<Y?>
			<QUIT>
		)
		(T
			<TELL "[Continuing...]" CR>
		)
	>
>

<ROUTINE RT-FAILED-MSG (STR)
	<TELL "[" .STR " failed.]" CR>
>

<ROUTINE V-RESTART ()
	<V-SCORE>
	<TELL CR "Are you sure you wish to restart?" CR>
	<COND
		(<Y?>
			<RESTART>
			<RT-FAILED-MSG "Restart">
		)
		(T
			<TELL "[Continuing...]" CR>
		)
	>
>

<ROUTINE V-SAVE ("AUX" X CW)
	<PUTB ,G-INBUF 1 0>
	<SETG P-CONT <>> ; "flush anything on input line after SAVE"
	<SET X <SAVE>>
	<COND
		(<ZERO? .X>
			<RT-FAILED-MSG "Save">
		)
		(T
			<TELL "[Okay.]" CR>
		)
	>
	<COND
		(<OR	<EQUAL? .X 2 3>
				<FLAG-ON? ,F-REFRESH>
			>
			<COLOR ,GL-F-COLOR ,GL-B-COLOR>
			<MOUSE-LIMIT -1>
			<V-REFRESH <EQUAL? .X 2 3>>
		)
	>
	<SETG CLOCK-WAIT T>
	<RFATAL>
>

<ROUTINE V-RESTORE ()
	<COND
		(<NOT <RESTORE>>
			<RT-FAILED-MSG "Restore">
			<RFALSE>
		)
	>
>

<ROUTINE V-FIRST-LOOK ()
	<COND
		(<DESCRIBE-ROOM>
			<COND
				(<NOT <0? ,VERBOSITY>>
					<RT-DESCRIBE-OBJECTS>
				)
			>
		)
	>
	<RTRUE>
>

"SUBTITLE - GENERALLY USEFUL ROUTINES & CONSTANTS"

<ROUTINE PRINT-CONTENTS (CONT "OPT" (RECUR? <>) (CNT 0) "AUX" OBJ (1ST? T) NXT)
	<SET OBJ <FIRST? .CONT>>
    <REPEAT ()
        <COND
            (<NOT .OBJ>
                <RETURN>
            )
            (<OR    <FSET? .OBJ ,FL-INVISIBLE>
                    <FSET? .OBJ ,FL-NO-DESC>
                    <EQUAL? .OBJ ,WINNER>
                >
                <SET OBJ <NEXT? .OBJ>>
            )
            (T
                <RETURN>
            )
        >
    >
	<COND
		(.OBJ
			<REPEAT ()
				<COND
					(<NOT .OBJ>
						<RETURN>
					)
					(T
					 <SET NXT <NEXT? .OBJ>>
					 <REPEAT ()
					    <COND
					     (<NOT .NXT>
					      <RETURN>
					      )
					     (<OR    <FSET? .NXT ,FL-INVISIBLE>
						     <FSET? .NXT ,FL-NO-DESC>
						     <EQUAL? .NXT ,WINNER>
						     >
					      <SET NXT <NEXT? .NXT>>
					      )
					     (T
					      <RETURN>
					      )
					     >
					    >
					 <COND
					  (.1ST?
								<INC CNT>
								<SET 1ST? <>>
							)
							(T
								<TELL comma .NXT>
							)
						>
						<TELL a .OBJ>
						<THIS-IS-IT .OBJ>
						<FSET .OBJ ,FL-SEEN>
					)
				>
				<SET OBJ .NXT>
			>
			<COND
				(.RECUR?
					<SET OBJ <FIRST? .CONT>>
					<REPEAT ()
						<COND
							(<NOT .OBJ>
								<RETURN>
							)
							(<OR	<FSET? .OBJ ,FL-INVISIBLE>
									<FSET? .OBJ ,FL-NO-DESC>
									<EQUAL? .OBJ ,WINNER>
								>
							)
							(<OR	<FSET? .OBJ ,FL-SURFACE>
									<AND
										<FSET? .OBJ ,FL-CONTAINER>
										<OR
											<FSET? .OBJ ,FL-OPEN>
											<FSET? .OBJ ,FL-TRANSPARENT>
										>
									>
								>
								<COND
									(<SEE-ANYTHING-IN? .OBJ>
										<TELL ". " In .OBJ the .OBJ the+verb ,WINNER "see">
										<SET CNT <PRINT-CONTENTS .OBJ T .CNT>>
									)
								>
							)
						>
						<SET OBJ <NEXT? .OBJ>>
					>
				)
			>
		)
	>
	.CNT
>

<ROUTINE RT-DESCRIBE-OBJECTS ("OPT" (CONT ,HERE) (CNT 0) "AUX" OBJ NXT (1ST? T) (P-CNT 0) (P-PL? <>) A?)
	<SET OBJ <FIRST? .CONT>>
	<COND
		(<AND <EQUAL? .CONT ,RM-SHALLOWS>
				<IN? ,TH-APPLE .CONT>
			>
			<SET A? T>
			<FSET ,TH-APPLE ,FL-NO-DESC>
		)
	>
	<COND
		(<AND <EQUAL? .CONT ,HERE>
				<NOT <IN? ,CH-PLAYER .CONT>>
			>
			<SET CNT <RT-DESCRIBE-OBJECTS <LOC ,CH-PLAYER> .CNT>>
		)
	>
	<REPEAT ()
		<COND
			(<NOT .OBJ>
				<RETURN>
			)
			(<OR	<FSET? .OBJ ,FL-NO-DESC>
					<FSET? .OBJ ,FL-NO-LIST>
					<FSET? .OBJ ,FL-INVISIBLE>
				>
				<SET OBJ <NEXT? .OBJ>>
				<AGAIN>
			)
			(<FSET? .OBJ ,FL-PERSON>
				<INC P-CNT>
				<SET OBJ <NEXT? .OBJ>>
				<AGAIN>
			)
			(.1ST?
				<COND
					(<G? .CNT 0>
						<TELL " ">
					)
					(T
						<CRLF>
					)
				>
				<SET 1ST? <>>
				<COND
					(<IN? .CONT ,ROOMS>
						<TELL "Y">
					)
					(<EQUAL? .CONT ,TH-BEHIND-G-STONE ,TH-BEHIND-ROCK ,TH-BEHIND-DOOR>
						<TELL "Behind the ">
						<COND
							(<EQUAL? .CONT ,TH-BEHIND-G-STONE>
								<TELL "gravestone">
							)
							(<EQUAL? .CONT ,TH-BEHIND-ROCK>
								<TELL "rock">
							)
							(T
								<TELL "door">
							)
						>
						<TELL " y">
					)
					(T
						<TELL In .CONT the .CONT " y">
					)
				>
				<TELL "ou see">
			)
		>
		<TELL a .OBJ>
		<THIS-IS-IT .OBJ>
		<FSET .OBJ ,FL-SEEN>
		<INC CNT>
		<SET OBJ <NEXT? .OBJ>>
		<REPEAT ()
			<COND
				(<NOT .OBJ>
					<RETURN>
				)
				(<FSET? .OBJ ,FL-NO-DESC>)
				(<FSET? .OBJ ,FL-NO-LIST>)
				(<FSET? .OBJ ,FL-INVISIBLE>)
				(<FSET? .OBJ ,FL-PERSON>
					<INC P-CNT>
				)
				(T
					<RETURN>
				)
			>
			<SET OBJ <NEXT? .OBJ>>
		>
		<COND
			(.OBJ
				<SET NXT <NEXT? .OBJ>>
				<REPEAT ()
					<COND
						(<NOT .NXT>
							<RETURN>
						)
						(<AND <NOT <FSET? .NXT ,FL-NO-DESC>>
								<NOT <FSET? .NXT ,FL-NO-LIST>>
								<NOT <FSET? .NXT ,FL-INVISIBLE>>
								<NOT <FSET? .NXT ,FL-PERSON>>
							>
							<RETURN>
						)
					>
					<SET NXT <NEXT? .NXT>>
				>
				<COND
					(<NOT .NXT>
						<TELL " and">
					)
					(T
						<TELL ",">
					)
				>
			)
			(T
				<COND
					(<IN? .CONT ,ROOMS>
						<TELL " here">
					)
				>
				<TELL ".">
			)
		>
	>
	<COND
		(<G? .P-CNT 0>
			<COND
				(<G? .CNT 0>
					<TELL " ">
				)
				(T
					<CRLF>
				)
			>
			<SET CNT <+ .CNT .P-CNT>>
			<COND
				(<G? .P-CNT 1>
					<SET P-PL? T>
				)
			>
			<SET OBJ <FIRST? .CONT>>
			<SET 1ST? T>
			<REPEAT ()
				<COND
					(<OR	<FSET? .OBJ ,FL-NO-DESC>
							<FSET? .OBJ ,FL-NO-LIST>
							<FSET? .OBJ ,FL-INVISIBLE>
						>
					)
					(<FSET? .OBJ ,FL-PERSON>
						<COND
							(.1ST?
								<TELL A .OBJ>
							)
							(T
								<TELL a .OBJ>
							)
						>
						<THIS-IS-IT .OBJ>
						<FSET .OBJ ,FL-SEEN>
						<SET 1ST? <>>
						<COND
							(<FSET? .OBJ ,FL-PLURAL>
								<SET P-PL? T>
							)
						>
						<COND
							(<DLESS? P-CNT 1>
								<COND
									(.P-PL?
										<TELL " are">
									)
									(T
										<TELL " is">
									)
								>
								<TELL " here.">
								<RETURN>
							)
							(<EQUAL? .P-CNT 1>
								<TELL " and">
							)
							(T
								<TELL ",">
							)
						>
					)
				>
				<SET OBJ <NEXT? .OBJ>>
			>
		)
	>
	<SET OBJ <FIRST? .CONT>>
	<REPEAT ()
		<COND
			(<NOT .OBJ>
				<RETURN>
			)
			(<FSET? .OBJ ,FL-INVISIBLE>)
			(<OR	<FSET? .OBJ ,FL-SURFACE>
					<AND
						<FSET? .OBJ ,FL-CONTAINER>
						<FSET? .OBJ ,FL-TRANSPARENT>
					>
				>
				<SET CNT <RT-DESCRIBE-OBJECTS .OBJ .CNT>>
			)
		>
		<SET OBJ <NEXT? .OBJ>>
	>
	<COND
		(<EQUAL? .CONT ,HERE>
			<COND
				(<G? .CNT 0>
					<CRLF>
				)
			>
		)
	>
	<COND
		(.A?
			<FCLEAR ,TH-APPLE ,FL-NO-DESC>
			<TELL
"|There is an apple here, gently bobbing up and down in the water.|"
			>
		)
	>
	<RETURN .CNT>
>

<ROUTINE SEE-ANYTHING-IN? (CONT "AUX" OBJ)
	<SET OBJ <FIRST? .CONT>>
	<REPEAT ()
		<COND
			(.OBJ
				<COND
					(<AND <NOT <FSET? .OBJ ,FL-INVISIBLE>>
							<NOT <FSET? .OBJ ,FL-NO-DESC>>
							<NOT <EQUAL? .OBJ ,WINNER>>
						>
						<RTRUE>
					)
				>
				<SET OBJ <NEXT? .OBJ>>
			)
			(T
				<RFALSE>
			)
		>
	>
>

<ROUTINE DESCRIBE-ROOM ("OPTIONAL" (LOOK? <>) "AUX" V? STR L (VAL <>) P)
	<COND
		(.LOOK?
			<SET V? T>
		)
		(<==? 2 ,VERBOSITY>
			<SET V? T>
		)
		(<==? 0 ,VERBOSITY>
			<SET V? <>>
		)
		(<NOT <FSET? ,HERE ,FL-TOUCHED>>
			<SET V? T>
		)
	>
	<COND
		(<ZERO? ,LIT>
			<TELL ,K-TOO-DARK-MSG>
			<FSET ,HERE ,FL-TOUCHED>
			<RFALSE>
		)
		(<FSET? ,TH-HEAD ,FL-LOCKED>
			<TELL "You can't see anything with" the ,TH-HEAD " in your shell." CR>
			<FSET ,HERE ,FL-TOUCHED>
			<RFALSE>
		)
		(<NOT <EQUAL? ,LIT ,HERE ,CH-PLAYER>>
			<TELL "Light comes from" the ,LIT "." CR CR>
		)
	>
	<COND
		(<SET P <GETP ,HERE ,P?ACTION>>
			<COND
				(.LOOK?
					<SET VAL <APPLY .P ,M-LOOK>>
				)
				(<NOT <FSET? ,HERE ,FL-TOUCHED>>
					<SET VAL <APPLY .P ,M-F-LOOK>>
				)
				(<EQUAL? ,VERBOSITY 2>
					<SET VAL <APPLY .P ,M-V-LOOK>>
				)
				(T
					<SET VAL <APPLY .P ,M-B-LOOK>>
				)
			>
		)
	>
	<FSET ,HERE ,FL-TOUCHED>
	<FSET ,HERE ,FL-SEEN>
	<RETURN <NOT .VAL>>
>

"Lengths:"
<CONSTANT REXIT 0>
<CONSTANT UEXIT <VERSION? (ZIP 1) (T 2)>>
	"Uncondl EXIT:	(dir TO rm)		 = rm"
<CONSTANT NEXIT <VERSION? (ZIP 2) (T 3)>>
	"Non EXIT:	(dir ;SORRY string)	 = str-ing"
<CONSTANT FEXIT <VERSION? (ZIP 3) (T 4)>>
	"Fcnl EXIT:	(dir PER rtn)		 = rou-tine, 0"
<CONSTANT CEXIT <VERSION? (ZIP 4) (T 5)>>
	"Condl EXIT:	(dir TO rm IF f)	 = rm, f, str-ing"
<CONSTANT DEXIT <VERSION? (ZIP 5) (T 6)>>
	"Door EXIT:	(dir TO rm IF dr IS OPEN)= rm, dr, str-ing, 0"

<CONSTANT NEXITSTR 0>
<CONSTANT FEXITFCN 0>
<CONSTANT CEXITFLAG <VERSION? (ZIP 1) (T 4)>>	"GET/B"
<CONSTANT CEXITSTR 1>		"GET"
<CONSTANT DEXITOBJ 1>		"GET/B"
<CONSTANT DEXITSTR <VERSION? (ZIP 1) (T 2)>>	"GET"

<ROUTINE RT-NOT-HOLDING-MSG? (OBJ)
	<COND
		(<AND <NOT <IN? .OBJ ,WINNER>>
				<NOT <IN? <LOC .OBJ> ,WINNER>>
			>
			<SETG CLOCK-WAIT T>
			<TELL
"[" He+verb ,WINNER "are" "n't holding" the .OBJ ".]" CR
			>
		)
	>
>

<ROUTINE HELD? (OBJ "OPTIONAL" (CONT <>) "AUX" L)
	<COND
		(<ZERO? .CONT>
			<SET CONT ,CH-PLAYER>
		)
	>
	<REPEAT ()
		<SET L <LOC .OBJ>>
		<COND
			(<NOT .L>
				<RFALSE>
			)
			(<EQUAL? .L .CONT>
				<RTRUE>
			)
			(<EQUAL? .CONT ,CH-PLAYER ,WINNER>
				<COND
					(<EQUAL? .OBJ
							,TH-HANDS
							,TH-HEAD
							,TH-LEGS
							,TH-MOUTH
							,TH-PLAYER-BODY
							,TH-ANIMAL-BODY
							,TH-SHELL
						;	,TH-EYES
						>
						<RTRUE>
					)
					(<AND <FSET? .OBJ ,FL-BODY-PART>
							<EQUAL? <GET-OWNER .OBJ> .CONT>
						>
						<RTRUE>
					)
					(T
						<SET OBJ .L>
					)
				>
			)
			(<EQUAL? .L ,ROOMS ,GLOBAL-OBJECTS>
				<RFALSE>
			)
			(T
				<SET OBJ .L>
			)
		>
	>
>

;<ROUTINE ROOM-CHECK ("AUX" P PA)
	<SET P ,PRSO>
	<COND
		(<EQUAL? .P ,ROOMS>
			<RFALSE>
		)
		(<IN? .P ,ROOMS>
			<COND
				(<MC-HERE? .P>
					<RFALSE>
				)
				(<NOT <SEE-INTO? .P>>
					<RTRUE>
				)
				(T
					<RFALSE>
				)
			>
		)
		(<EQUAL? <META-LOC .P> ,HERE ,GLOBAL-OBJECTS ,LOCAL-GLOBALS>
			<RFALSE>
		)
		(<NOT <VISIBLE? .P>>
			<NOT-HERE .P>
		)
	>
>

<ROUTINE SEE-INSIDE? (OBJ "OPTIONAL" (ONLY-IN <>))
	<COND
		(<FSET? .OBJ ,FL-INVISIBLE>
			<RFALSE>		;"for LIT? - CH-PLAYER"
		)
		(<IN? .OBJ ,ROOMS>
			<RTRUE>
		)
		(<FSET? .OBJ ,FL-TRANSPARENT>
			<RTRUE>
		)
		(<FSET? .OBJ ,FL-OPEN>
			<RTRUE>
		)
		(.ONLY-IN
			<RFALSE>
		)
		(<FSET? .OBJ ,FL-SURFACE>
			<RTRUE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "A"
;"---------------------------------------------------------------------------"

<CONSTANT K-NOBODY-TO-ASK-MSG "There's no one here to ask.|">

<ROUTINE V-ASK-WHO-ABOUT ("AUX" WHO)
	<COND
		(<SET WHO <FIND-A-WINNER>>
			<SETG PRSI-NP ,PRSO-NP>
			<SETG PRSO-NP <>>
			<TELL-SAID-TO .WHO>
			<PERFORM ,V?ASK-ABOUT .WHO ,PRSO>
		)
		(T
			<TELL ,K-NOBODY-TO-ASK-MSG>
			<SETG CLOCK-WAIT T>
			<RFATAL>
		)
	>
>

<ROUTINE V-ASK-WHO-FOR ("AUX" WHO)
	<COND
		(<SET WHO <FIND-A-WINNER>>
			<SETG PRSI-NP ,PRSO-NP>
			<SETG PRSO-NP <>>
			<TELL-SAID-TO .WHO>
			<PERFORM ,V?ASK-FOR .WHO ,PRSO>
		)
		(T
			<TELL ,K-NOBODY-TO-ASK-MSG>
			<SETG CLOCK-WAIT T>
			<RFATAL>
		)
	>
>

<ROUTINE V-ASK-ABOUT ()
	<RT-NO-RESPONSE-MSG>
>

<ROUTINE V-ASK-FOR ("AUX" WHO)
	<COND
		(<RT-FOOLISH-TO-TALK?>
			<SETG CLOCK-WAIT T>
			<RFATAL>
		)
		(<EQUAL? ,WINNER ,PRSI>
			<RT-IMPOSSIBLE-MSG>
		)
		(<NOT <FSET? ,PRSI ,FL-TAKEABLE>>
			<TELL The+verb ,PRSO "say" ", \"Unfortunately, ">
			<COND
				(<AND <FSET? ,PRSO ,FL-PLURAL>
						<NOT <FSET? ,PRSO ,FL-COLLECTIVE>>
					>
					<TELL "we">
				)
				(T
					<TELL "I">
				)
			>
			<TELL " can't help you with that.\"" CR>
		)
		(T
			<RT-NO-RESPONSE-MSG>
		)
	>
>

<ROUTINE V-ATTACK ()
	<COND
		(<AND <MC-VERB-WORD? ,W?BITE>
				<NOT <FSET? ,PRSO ,FL-ALIVE>>
			>
			<PERFORM ,V?EAT ,PRSO>
			<RTRUE>
		)
		(<FSET? ,PRSO ,FL-ALIVE>
			<TELL "That would be most unchivalrous." CR>
		)
		(T
			<RT-NO-POINT-MSG "Attacking">
			<SETG CLOCK-WAIT T>
			<RFATAL>
		)
	>
>

;"---------------------------------------------------------------------------"
; "B"
;"---------------------------------------------------------------------------"

<ROUTINE V-BITE ()
	<COND
		(<MC-PRSO? ,TH-CHEESE ,TH-DEAD-MOUSE ,TH-WEEDS ,TH-MINNOW ,TH-MIDGES>
			<PERFORM ,V?EAT ,PRSO>
			<RTRUE>
		)
		(T
			<PERFORM ,V?ATTACK ,PRSO ,TH-MOUTH>
			<RTRUE>
		)
	>
>

<ROUTINE V-BLOW ()
	<COND
		(<FSET? ,PRSO ,FL-PERSON>
			<TELL The ,PRSO " might resent that." CR>
			<RT-AUTHOR-MSG "And you'd DEFINITELY lose chivalry points.">
		)
		(T
			<RT-NO-POINT-MSG "Blowing">
		)
	>
>

<ROUTINE V-BREAK ()
	<COND
		(<FSET? ,PRSO ,FL-DOOR>
			<TELL "The door is impervious to your assault." CR>
		)
		(T
			<RT-NO-POINT-MSG "Trying to destroy">
		)
	>
>

<ROUTINE V-BUY ()
	<TELL The+verb ,WINNER "do" "n't have any money." CR>
	<RT-AUTHOR-MSG "Which isn't surprising, considering this is a barter economy.">
>

;"---------------------------------------------------------------------------"
; "C"
;"---------------------------------------------------------------------------"

<ROUTINE PRE-CALL ("AUX" NP PTR W)
	<COND
		(<MC-PRSO? ,ROOMS>
			<TELL "Helllloooooooo." CR>
		)
		(<AND <MC-PRSO? ,INTQUOTE>
				<SET NP <GET-NP ,INTQUOTE>>
				<SET PTR <NP-LEXBEG .NP>>
			>
			<COND
				(<EQUAL? <ZGET .PTR 0> ,W?QUOTE>
					<SET PTR <ZREST .PTR 8>>
				)
			>
			<COND
				(<AND <SET W <ZGET .PTR 0>>
						<EQUAL? .W ,W?NIMUE>
					>
					<PERFORM ,V?CALL ,CH-NIMUE>
					<RTRUE>
				)
			>
		)
		(<NOT <FSET? ,PRSO ,FL-ALIVE>>
			<TELL ,K-NOTHING-HAPPENS-MSG CR>
		)
	>
>

<ROUTINE V-CALL ()
	<COND
		(<IN? ,PRSO ,HERE>
			<TELL The+verb ,PRSO "are" " right in front of you." CR>
		)
		(T
			<TELL ,K-NOTHING-HAPPENS-MSG CR>
		)
	>
>

<ROUTINE V-CHALLENGE ()
	<COND
		(<NOT <FSET? ,PRSO ,FL-ALIVE>>
			<TELL ,K-NOTHING-HAPPENS-MSG CR>
			<SETG GL-QUESTION 1>
			<RT-AUTHOR-MSG
"Don't you feel a little silly challenging an inanimate object?"
			>
		)
		(T
			<TELL The+verb ,PRSO "ignore" " your challenge." CR>
		)
	>
>

<ROUTINE V-CLIMB-DOWN ()
	<COND
		(<MC-PRSO? ,ROOMS>
			<RT-DO-WALK ,P?DOWN>
			<RTRUE>
		)
		(<EQUAL? ,P-PRSA-WORD ,W?JUMP ,W?LEAP>
			<PERFORM ,V?ENTER ,PRSO>
			<RTRUE>
		)
		(<MC-FORM? ,K-FORM-SALAMANDER>
			<RT-CLIMB-ON-MSG ,PRSO <>>
		)
		(T
			<RT-WASTE-OF-TIME-MSG>
		)
	>
>

<ROUTINE V-CLIMB-ON ()
	<COND
		(<EQUAL? ,P-PRSA-WORD ,W?TAKE>
			<RT-NOT-LIKELY-MSG ,PRSO "is looking for a fight">
			<RTRUE>
		)
		(<EQUAL? ,P-PRSA-WORD ,W?MOUNT>
			<COND
				(<FSET? ,PRSO ,FL-PERSON>
					<TELL The ,PRSO " might resent that." CR>
					<RT-AUTHOR-MSG "Please try to control these unchivalrous urges.">
				)
				(<FSET? ,PRSO ,FL-ALIVE>
					<TELL The ,PRSO " might resent that." CR>
					<RT-AUTHOR-MSG "Kinky!">
				)
				(T
					<RT-YOU-CANT-MSG "mount">
					<RT-AUTHOR-MSG
"And it probably wouldn't be much fun if you could."
					>
				)
			>
			<RTRUE>
		)
	;	(<AND <FSET? ,PRSO ,FL-VEHICLE>		; "If it's a vehicle, move winner there."
				<FSET? ,PRSO ,FL-SURFACE>
			>
			<MOVE ,WINNER ,PRSO>
			<TELL The+verb ,WINNER "get" in ,PRSO the ,PRSO "." CR>
		)
		(<MC-FORM? ,K-FORM-SALAMANDER>
			<RT-CLIMB-ON-MSG ,PRSO>
		)
		(T
			<TELL The ,WINNER " can't " vw " on">
			<COND
				(<NOT <EQUAL? ,P-PRSA-WORD ,W?STAND>>
					<TELL "to">
				)
			>
			<TELL the ,PRSO "." CR>
		)
	>
>

<ROUTINE V-CLIMB-OVER ()
	<COND
		(<MC-PRSO? ,ROOMS>
			<V-WALK-AROUND>
			<RTRUE>
		)
		(<MC-FORM? ,K-FORM-SALAMANDER>
			<RT-CLIMB-ON-MSG ,PRSO>
		)
		(T
			<TELL The ,WINNER " can't " vw " over" the ,PRSO "." CR>
		)
	>
>

<ROUTINE RT-CLIMB-ON-MSG ("OPT" (OBJ ,PRSO) (UP? T) "AUX" P)
	<COND
		(<AND <SET P <GET-OWNER .OBJ>>
				<NOT <EQUAL? .P .OBJ>>
			>
			<PERFORM ,PRSA .P>
			<RTRUE>
		)
		(<EQUAL? .OBJ
,LG-LAKE ,LG-RIVER ,LG-FOREST ,LG-TOWN ,TH-BEER ,TH-BARREL-WATER ,TH-WATER
,TH-MIDGES
			>
			<RT-YOU-CANT-MSG "climb on" .OBJ>
		)
		(<EQUAL? .OBJ ,INTDIR>
			<COND
				(<NOUN-USED? ,INTDIR ,W?NORTH>
					<RT-DO-WALK ,P?NORTH>
				)
				(<NOUN-USED? ,INTDIR ,W?SOUTH>
					<RT-DO-WALK ,P?SOUTH>
				)
				(<NOUN-USED? ,INTDIR ,W?EAST>
					<RT-DO-WALK ,P?EAST>
				)
				(<NOUN-USED? ,INTDIR ,W?WEST>
					<RT-DO-WALK ,P?WEST>
				)
				(<NOUN-USED? ,INTDIR ,W?NE ,W?NORTHEAST>
					<RT-DO-WALK ,P?NE>
				)
				(<NOUN-USED? ,INTDIR ,W?SE ,W?SOUTHEAST>
					<RT-DO-WALK ,P?SE>
				)
				(<NOUN-USED? ,INTDIR ,W?NW ,W?NORTHWEST>
					<RT-DO-WALK ,P?NW>
				)
				(<NOUN-USED? ,INTDIR ,W?SW ,W?SOUTHWEST>
					<RT-DO-WALK ,P?SW>
				)
			>
		)
		(<FSET? .OBJ ,FL-ALIVE>
			<TELL The .OBJ " absentmindedly" verb .OBJ "brush" " you off." CR>
		)
		(T
			<TELL "You scamper ">
			<COND
				(.UP?
					<TELL "up">
				)
				(T
					<TELL "down">
				)
			>
			<TELL the .OBJ ", have a quick look around, and then return." CR>
		)
	>
>

<ROUTINE V-CLIMB-UP ()
	<COND
		(<MC-PRSO? ,ROOMS>
			<RT-DO-WALK ,P?UP>
			<RTRUE>
		)
		(<MC-FORM? ,K-FORM-SALAMANDER>
			<RT-CLIMB-ON-MSG ,PRSO>
		)
		(T
			<RT-WASTE-OF-TIME-MSG>
		)
	>
>

<ROUTINE V-CLOSE ()
	<COND
		(<AND <EQUAL? ,WINNER ,CH-PLAYER>
				<NOT <MC-FORM? ,K-FORM-ARTHUR>>
			>
			<RT-ANIMAL-CANT-MSG>
		)
		(<NOT <FSET? ,PRSO ,FL-OPENABLE>>
			<RT-YOU-CANT-MSG>
		)
		(T
			<COND
				(<FSET? ,PRSO ,FL-OPEN>
					<FCLEAR ,PRSO ,FL-OPEN>
					<COND
						(<FSET? ,PRSO ,FL-DOOR>
							<RT-CHECK-ADJ ,PRSO>
							<COND
								(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>
									<RT-UPDATE-MAP-WINDOW>
								)
							>
						)
					>
					<COND
						(<G? ,P-MULT 1>
							<TELL "Closed">
						)
						(T
							<TELL The+verb ,WINNER "close" the ,PRSO>
						)
					>
					<TELL "." CR>
				)
				(T
					<RT-ALREADY-MSG ,PRSO "closed">
				)
			>
		)
	>
>

<ROUTINE V-CUT ()
	<COND
		(<MC-PRSI? ,TH-SWORD>
			<TELL
"Merlin's voice whispers in your ear, \"A true knight only uses his sword to
further his quest, Arthur. Leave" the ,PRSO " alone.\"" CR
			>
		)
		(T
			<TELL The ,WINNER " can't cut" the ,PRSO " with" the ,PRSI "." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "D"
;"---------------------------------------------------------------------------"

<ROUTINE V-DIG ("AUX" DIR)
	<COND
		(<MC-PRSO? <> ,ROOMS>
			<SETG PRSO ,TH-GROUND>
		)
	>
	<COND
	;	(<IN? ,CH-KRAKEN ,HERE>
			<TELL "\"Yeah. Like wow, man.\"" CR>
		)
		(<MC-FORM? ,K-FORM-BADGER>
			<COND
				(<MC-PRSO? ,INTDIR>
					<COND
						(<SET DIR <RT-NOUN-TO-DIR>>
							<RT-DO-WALK .DIR>
						)
					>
				)
				(T
					<TELL
"You claw at" the ,PRSO " for a few moments but find nothing of interest." CR
					>
				)
			>
		)
		(<AND <MC-PRSI? <> ,ROOMS>
				<IN? ,TH-SLEAN ,WINNER>
			>
			<PERFORM ,V?DIG ,PRSO ,TH-SLEAN>
			<RTRUE>
		)
		(<FSET? ,PRSO ,FL-ALIVE>
			<TELL "That's impossible." CR>
			<RT-AUTHOR-ON>
			<TELL "Like wow, man. " He ,PRSO "'">
			<COND
				(<OR	<MC-PRSO? ,CH-PLAYER>
						<AND
							<FSET? ,PRSO ,FL-PLURAL>
							<NOT <FSET? ,PRSO ,FL-COLLECTIVE>>
						>
					>
					<TELL "re">
				)
				(T
					<TELL "s">
				)
			>
			<TELL " the most!">
			<RT-AUTHOR-OFF>
		)
		(<AND <MC-PRSO? ,TH-GROUND>
				<FSET? ,HERE ,FL-WATER>
			>
			<TELL
"You dig around for a few moments but find nothing of interest." CR
			>
		)
		(T
			<TELL The+verb ,TH-GROUND "are" " too hard for digging here." CR>
		)
	>
>

<ROUTINE V-DIG-IN ()
	<COND
		(<MC-PRSO? ,TH-HOLE>
			<SETG PRSO-NP ,PRSI-NP>
			<SETG PRSI-NP <>>
			<PERFORM ,V?DIG ,PRSI>
		)
		(T
			; "Bob"
			<TELL The ,WINNER " can't dig" a ,PRSO in ,PRSI the ,PRSI "." CR>
			<RFATAL>
		)
	>
>

<ROUTINE V-DISMOUNT ()
	<COND
		(<IN? ,WINNER ,TH-HORSE>
			<MOVE ,WINNER ,HERE>
			<TELL The+verb ,WINNER "are" " back on" the ,TH-GROUND "." CR>
			<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
					<RT-UPDATE-DESC-WINDOW>
				)
			>
			<RTRUE>
		)
		(T
			<TELL The+verb ,WINNER "are" "n't on anything." CR>
		)
	>
>

<ROUTINE V-DISTRACT ()
	<COND
		(<NOT <FSET? ,PRSO ,FL-ALIVE>>
			<TELL The ,WINNER " can't distract " a ,PRSO "." CR>
		)
		(T
			<SETG CLOCK-WAIT T>
			<RT-AUTHOR-MSG ,K-HOW-INTEND-MSG>
		)
	>
>

<ROUTINE V-DRINK ("OPT" (FROM? <>))
	<TELL The ,WINNER " can't drink">
	<COND
		(.FROM?
			<TELL " from">
		)
	>
	<TELL the ,PRSI "." CR>
>

<ROUTINE V-DRINK-FROM ()
	<V-DRINK T>
>

<ROUTINE IDROP ()
	<COND
		(<RT-NOT-HOLDING-MSG? ,PRSO>
			<RFALSE>
		)
		(<AND <NOT <IN? ,PRSO ,WINNER>>
				<NOT <FSET? <LOC ,PRSO> ,FL-OPEN>>
			>
			<TELL The+verb <LOC ,PRSO> "are" " closed." CR>
			<RFALSE>
		)
		(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
			<RT-AUTHOR-MSG ,K-HOW-INTEND-MSG>
			<RFALSE>
		)
		(T
			<COND
				(<FSET? ,PRSO ,FL-WORN>
					<COND
						(<NOT <MC-PRSO? ,TH-BREECHES ,TH-TUNIC ,TH-ARMOUR>>
							<RT-FIRST-YOU-MSG "take off" ,PRSO>
						)
						(T
							<TELL
The ,WINNER " would have to take off" the ,PRSO " first." CR
							>
							<RFALSE>
						)
					>
				)
			>
			<COND
				(,GL-DROP-HERE
					<MOVE ,PRSO ,HERE>
				)
				(T
					<MOVE ,PRSO <LOC ,WINNER>>
				)
			>
			<FCLEAR ,PRSO ,FL-WORN>
			<FCLEAR ,PRSO ,FL-NO-DESC>
			<FCLEAR ,PRSO ,FL-NO-LIST>
			<FCLEAR ,PRSO ,FL-INVISIBLE>
			<SETG GL-UPDATE-WINDOW
				<BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT ,K-UPD-OBJS>
			>
			<RTRUE>
		)
	>
>

<GLOBAL GL-DROP-HERE:FLAG <>>

<ROUTINE V-DROP ("AUX" L)
	<COND
		(<IDROP>
			<COND
				(<G? ,P-MULT 1>
					<TELL "Dropped">
				)
				(T
					<TELL The+verb ,WINNER "drop" the ,PRSO>
				;	<COND
						(<SET L <FIND-FLAG-HERE ,FL-VEHICLE ,PRSO>>
							<MOVE ,PRSO .L>
							<TELL in .L "to" the .L>
						)
					>
				)
			>
			<TELL ".">
			<COND
				(<AND <MC-PRSO? ,TH-APPLE>
						<MC-HERE? ,RM-FORD>
					>
					<MOVE ,PRSO ,RM-SHALLOWS>
					<TELL
" " The ,PRSO " quickly" verb ,PRSO "float" " down the river and out of sight."
					>
				)
			>
			<CRLF>
		)
	>
>

;"---------------------------------------------------------------------------"
; "E"
;"---------------------------------------------------------------------------"

<ROUTINE V-EAT ()
	<COND
		(,GL-HUNGER
			<TELL
The+verb ,PRSO "do" "n't look very appetizing to" the ,WINNER "." CR
			>
		)
		(T
			<TELL The+verb ,WINNER "are" "n't ">
			<COND
				(<FSET? ,PRSO ,FL-WATER>
					<TELL "thirsty">
				)
				(T
					<TELL "hungry">
				)
			>
			<TELL " right now." CR>
		)
	>
>

<ROUTINE PRE-EMPTY ("AUX" L)
	<COND
		(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
			<RT-ANIMAL-CANT-MSG>
		)
		(<AND <NOT <FSET? ,PRSO ,FL-SURFACE>>
				<NOT <FSET? ,PRSO ,FL-CONTAINER>>
			>
			<SET L <LOC ,PRSO>>
			<COND
				(<AND .L
						<OR
							<FSET? .L ,FL-SURFACE>
							<FSET? .L ,FL-CONTAINER>
						>
					>
					<PERFORM ,V?EMPTY .L ,PRSI>
					<RTRUE>
				)
				(T
					<TELL The ,WINNER " can't empty" the ,PRSO "." CR>
				)
			>
		)
		(<AND <FSET? ,PRSO ,FL-CONTAINER>
				<NOT <FSET? ,PRSO ,FL-OPEN>>
			>
			<TELL The+verb ,PRSO "are" "n't open." CR>
		)
		(<NOT <EQUAL? ,PRSI <> ,ROOMS ,TH-HANDS>>
			<COND
				(<AND <NOT <FSET? ,PRSI ,FL-SURFACE>>
						<NOT <FSET? ,PRSI ,FL-CONTAINER>>
					>
					<TELL The ,WINNER " can't empty" the ,PRSO " into" the ,PRSI "." CR>
				)
			>
		)
	>
>

<ROUTINE V-EMPTY ()
	<RT-EMPTY-MSG ,PRSO ,PRSI>
>

<ROUTINE RT-TOTAL-SIZE (CONT "AUX" OBJ (TOTSIZ 0))
	<SET OBJ <FIRST? .CONT>>
	<REPEAT ()
		<COND
			(<MC-F? .OBJ>
				<RETURN>
			)
			(<FSET? .OBJ ,FL-WORN>)
			(T
				<SET TOTSIZ <+ .TOTSIZ <GETB <GETPT .OBJ ,P?SIZE> ,K-SIZE>>>
			)
		>
		<SET OBJ <NEXT? .OBJ>>
	>
	<RETURN .TOTSIZ>
>

<ROUTINE RT-OBJ-TOO-LARGE? (OBJ1 OBJ2 "AUX" CAP PT)
	<COND
		(<SET PT <GETPT .OBJ2 ,P?SIZE>>)
		(<SET PT <GETPT .OBJ2 ,P?CAPACITY>>)
		(T
			<RTRUE>
		)
	>
	<SET CAP <GETB .PT ,K-CAPACITY>>
	<COND
		(<EQUAL? .CAP ,K-CAP-MAX>
			<RFALSE>
		)
		(<G?	<+ <GETB <GETPT .OBJ1 ,P?SIZE> ,K-SIZE>	; "Size"
					<RT-TOTAL-SIZE .OBJ2>
				>
				.CAP
			>
			<RTRUE>
		)
	>
>

<ROUTINE RT-ROOM-IN-MSG? (OBJ1 OBJ2)
	<COND
		(<RT-OBJ-TOO-LARGE? .OBJ1 .OBJ2>
			<TELL "There is not enough room" in .OBJ2 the .OBJ2 "." CR>
		)
	>
>

<ROUTINE RT-CHECK-MOVE-MSG? (SRC DEST "AUX" PTR OLOC CNT)
	<COND
		(.DEST
			<SET PTR ,GL-LOC-TRAIL>
			<SET OLOC .DEST>
			<REPEAT ()
				<ZPUT .PTR 0 .OLOC>
				<INC CNT>
				<COND
					(<OR	<MC-F? .OLOC>
							<IN? .OLOC ,ROOMS>
							<IN? .OLOC ,LOCAL-GLOBALS>
							<IN? .OLOC ,GLOBAL-OBJECTS>
						>
						<RETURN>
					)
				>
				<SET OLOC <LOC .OLOC>>
				<SET PTR <ZREST .PTR 2>>
				<COND
					(<EQUAL? .OLOC .DEST>
						<RETURN>
					)
				>
			>
			<COND
				(<INTBL? .SRC ,GL-LOC-TRAIL .CNT>
					<TELL
The ,WINNER " can't put" the .SRC in .SRC him .SRC "self, or" in .SRC
"something that is already" in .SRC him .SRC "." CR
					>
					<RTRUE>
				)
			>
		)
	>
>

<ROUTINE RT-EMPTY-MSG (CONT "OPT" (DEST <>) "AUX" OBJ NXT X OM)
	<SET OM ,P-MULT>
	<SETG P-MULT 0>
	<SET OBJ <FIRST? .CONT>>
	<REPEAT ()
		<COND
			(<NOT .OBJ>
				<RETURN>
			)
			(<AND	<NOT <FSET? .OBJ ,FL-INVISIBLE>>
					<FSET? .OBJ ,FL-TAKEABLE>
				>
				<INC P-MULT>
			)
		>
		<SET OBJ <NEXT? .OBJ>>
	>
	<COND
		(<ZERO? ,P-MULT>
			<TELL "There is nothing" in ,PRSO the ,PRSO "." CR>
			<SETG P-MULT .OM>
			<RTRUE>
		)
	>
	<SET OBJ <FIRST? .CONT>>
	<COND
		(<EQUAL? .DEST <> ,ROOMS ,TH-GROUND ,GLOBAL-HERE>
			<SET DEST ,HERE>
		)
		(<EQUAL? .DEST ,TH-HANDS>
			<SET DEST ,CH-PLAYER>
		)
	>
	<REPEAT ()
		<COND
			(<MC-F? .OBJ>
				<RETURN>
			)
			(<AND	<NOT <FSET? .OBJ ,FL-INVISIBLE>>
					<FSET? .OBJ ,FL-TAKEABLE>
				>
				<COND
					(<G? ,P-MULT 1>
						<TELL The .OBJ ": ">
					)
				>
				<SET NXT <NEXT? .OBJ>>
				<COND
					(<EQUAL? .DEST ,CH-PLAYER>
						<SET X <RT-PERFORM ,V?TAKE .OBJ ,PRSO>>
						<COND
							(<EQUAL? .X ,M-FATAL>
								<RETURN>
							)
						>
					)
					(<EQUAL? .DEST ,HERE>
						<MOVE .OBJ ,HERE>
						<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-OBJS>>
						<COND
							(<G? ,P-MULT 1>
								<TELL He+verb .OBJ "land">
							)
							(T
								<TELL The+verb .OBJ "land">
							)
						>
						<TELL " on" the ,TH-GROUND " nearby." CR>
					)
					(<RT-ROOM-IN-MSG? .OBJ .DEST>
						T
					)
					(<RT-CHECK-MOVE-MSG? .OBJ .DEST>
						<RETURN>
					)
					(T
						<MOVE .OBJ .DEST>
						<COND
							(<AND <OR
										<IN? .DEST ,HERE>
										<FSET? .DEST ,FL-SURFACE>
										<FSET? .DEST ,FL-TRANSPARENT>
									>
									<RT-META-IN? .DEST ,HERE>
								>
								<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-OBJS>>
							)
						>
						<TELL "Done." CR>
					)
				>
				<SET OBJ .NXT>
			)
		>
	>
	<SETG P-MULT .OM>
	<RTRUE>
>

<ROUTINE V-EMPTY-FROM ()
	<COND
		(<AND <IN? ,PRSI ,PRSO>
				<FSET? ,PRSI ,FL-WORN>
			>
			<SETG PRSO-NP ,PRSI-NP>
			<SETG PRSI-NP <>>
			<PERFORM ,V?UNWEAR ,PRSI>
		)
		(<NOT <IN? ,PRSO ,PRSI>>
			<TELL The+verb ,PRSO "are" "n't" in ,PRSI the ,PRSI "." CR>
		)
		(T
			<PERFORM ,V?EMPTY ,PRSI>
			<RTRUE>
		)
	>
>

;<ROUTINE PRE-ENTER ("AUX" OBJ DEST)
	<COND
		(<MC-PRSO? ,ROOMS>
			<COND
				(<OR	<FSET? .OBJ ,FL-SURFACE>
						<FSET? .OBJ ,FL-OPEN>
					>
					<MOVE ,WINNER .DEST>
					<TELL The+verb ,WINNER "get">
					<COND
						(<VERB? ENTER>
							<TELL in .OBJ>
						)
						(T
							<TELL out .OBJ " of">
						)
					>
					<TELL the .OBJ "." CR>
				)
				(<FSET? .OBJ ,FL-OPENABLE>
					<TELL The+verb .OBJ "are" " closed." CR>
				)
				(T
					<TELL The ,WINNER " can't get">
					<COND
						(<VERB? ENTER>
							<TELL in .OBJ>
						)
						(T
							<TELL out .OBJ " of">
						)
					>
					<TELL the .OBJ "." CR>
				)
			>
		)
	>
>

<ROUTINE V-ENTER ("AUX" VEH DIR RM)
	<COND
		(<MC-PRSO? ,ROOMS>
			<COND
				(<SET VEH <FIND-FLAG-HERE ,FL-VEHICLE>>
					<COND
						(<IN? ,WINNER .VEH>
							<RT-ALREADY-MSG ,WINNER>
							<TELL in .VEH the .VEH ".">
							<RT-AUTHOR-OFF>
						)
						(<OR	<FSET? .VEH ,FL-SURFACE>
								<FSET? .VEH ,FL-OPEN>
							>
							<MOVE ,WINNER .VEH>
							<TELL The+verb ,WINNER "get" in .VEH the .VEH "." CR>
						)
						(<FSET? .VEH ,FL-OPENABLE>
							<TELL The+verb .VEH "are" " closed." CR>
						)
						(T
							<TELL The ,WINNER " can't get" in .VEH the .VEH "." CR>
						)
					>
				)
				(<EQUAL? <RT-DO-WALK ,P?IN> <> ,M-FATAL>
					<SETG CLOCK-WAIT T>
				)
			>
		)
		(<MC-PRSO? ,HERE ,GLOBAL-HERE>
			; "Enter the room you're in"
			<RT-ALREADY-MSG ,WINNER>
			<TELL in ,HERE the ,HERE ".">
			<RT-AUTHOR-OFF>
		)
		(<IN? ,PRSO ,ROOMS>
			<COND
				(<AND <SET DIR <RT-FIND-DIR ,PRSO>>
						<RT-DO-WALK .DIR>
					>
				)
				(<FSET? ,PRSO ,FL-AUTO-ENTER>
					<RT-GOTO ,PRSO>
				)
				(T
					<TELL The ,WINNER " can't get there from here." CR>
				)
			>
		)
		(<FSET? ,PRSO ,FL-DOOR>
			<COND
				(<RT-OTHER-SIDE ,PRSO>
					<RT-DO-WALK ,GL-DOOR-DIR>
				)
				(T
					<TELL The+verb ,PRSO "do" "n't seem to go anywhere." CR>
				)
			>
		)
		(<FSET? ,PRSO ,FL-VEHICLE>		; "If it's a vehicle, move winner there."
			<COND
				(<OR	;<FSET? ,PRSO ,FL-SURFACE>
						<FSET? ,PRSO ,FL-OPEN>
					>
					<MOVE ,WINNER ,PRSO>
					<TELL The+verb ,WINNER "get" in ,PRSO the ,PRSO "." CR>
				)
				(<FSET? ,PRSO ,FL-OPENABLE>
					<TELL The+verb ,PRSO "are" " closed." CR>
				)
				(T
					<RT-YOU-CANT-MSG "get in">
				;	<TELL The ,WINNER " can't get" in ,PRSO the ,PRSO "." CR>
				)
			>
		)
		(<AND <MC-FORM? ,K-FORM-SALAMANDER>
				<OR
				;	<FSET? ,PRSO ,FL-SURFACE>
					<FSET? ,PRSO ,FL-CONTAINER>
				>
			>
			<COND
				(<OR	;<FSET? ,PRSO ,FL-SURFACE>
						<FSET? ,PRSO ,FL-OPEN>
					>
					<TELL
"You scamper" in ,PRSO "to" the ,PRSO ", have a quick look around, and then return." CR
					>
				)
				(<FSET? ,PRSO ,FL-OPENABLE>
					<TELL The+verb ,PRSO "are" " closed." CR>
				)
				(T
					<RT-YOU-CANT-MSG "get in">
				)
			>
		)
		(T
			<RT-YOU-CANT-MSG "get in">
			<COND
				(<FSET? ,PRSO ,FL-PERSON>
					<RT-AUTHOR-MSG "Please try to control these unchivalrous urges.">
				)
				(<FSET? ,PRSO ,FL-ALIVE>
					<RT-AUTHOR-MSG "So now we're into bestiality, eh?">
				)
			>
		)
	>
	<RTRUE>
>

<ROUTINE RT-DO-WALK (DIR1 "OPTIONAL" (DIR2 <>) (DIR3 <>) "AUX" X)
	<SETG P-WALK-DIR .DIR1>
	<SET X <PERFORM ,V?WALK .DIR1>>
	<COND
		(<AND .DIR2
				<NOT <EQUAL? .X <> ,M-FATAL>>
			>
			<SETG P-WALK-DIR .DIR2>
			<SET X <PERFORM ,V?WALK .DIR2>>
			<COND
				(<AND .DIR3
						<NOT <EQUAL? .X <> ,M-FATAL>>
					>
					<SETG P-WALK-DIR .DIR3>
					<SET X <PERFORM ,V?WALK .DIR3>>
				)
			>
		)
	>
	<RETURN .X>
>

;<ROUTINE PRE-EXAMINE ()
	<ROOM-CHECK>
>

<ROUTINE V-EXAMINE ()
	<COND
		(<MC-PRSO? ,HERE ,GLOBAL-HERE>
			<PERFORM ,V?LOOK>
		)
		(<MC-PRSO? ,INTDIR>
			<SETG CLOCK-WAIT T>
			<TELL "[If you want to see what's there, go there.]" CR>
		)
		(<FSET? ,PRSO ,FL-DOOR>
			<FSET ,PRSO ,FL-SEEN>
			<TELL The+verb ,PRSO "are" open ,PRSO "." CR>
		)
		(<OR	<FSET? ,PRSO ,FL-CONTAINER>
				<FSET? ,PRSO ,FL-SURFACE>
			>
			<FSET ,PRSO ,FL-SEEN>
			<V-LOOK-IN>
		)
		(T
			<FSET ,PRSO ,FL-SEEN>
			<RT-NOTHING-SPECIAL-MSG>
		)
	>
>

<ROUTINE RT-NOTHING-SPECIAL-MSG ()
	<TELL
"You see nothing " <RT-PICK-NEXT ,K-UNUSUAL-TBL> " about" the ,PRSO "." CR
	>
>

<ROUTINE V-EXIT ("AUX" VEH L DIR)
	<COND
		(<MC-PRSO? ,ROOMS>
			<SET L <LOC ,WINNER>>
			<COND
				(<IN? .L ,ROOMS>
					<RT-DO-WALK ,P?OUT>
				)
				(<EQUAL? .L ,TH-BEHIND-ROCK ,TH-BEHIND-G-STONE ,TH-BEHIND-DOOR>
					<RT-DO-WALK ,P?OUT>
				)
				(<OR	<FSET? .L ,FL-VEHICLE>
						<FSET? .L ,FL-SURFACE>
						<FSET? .L ,FL-CONTAINER>
					>
					<COND
						(<OR	<FSET? .L ,FL-SURFACE>
								<FSET? .L ,FL-OPEN>
							>
							<MOVE ,WINNER <LOC .L>>
							<TELL The+verb ,WINNER "get" out .L " of" the .L "." CR>
						)
						(<FSET? .L ,FL-OPENABLE>
							<TELL The+verb .L "are" " closed." CR>
						)
						(T
							<TELL The ,WINNER " can't get" out .L " of" the .L "." CR>
						)
					>
				)
				(<SET VEH <FIND-FLAG-HERE ,FL-VEHICLE>>
					<TELL The+verb ,WINNER "are" "n't" in .VEH the .VEH "." CR>
				)
			>
		)
		(<MC-PRSO? ,HERE ,GLOBAL-HERE>
			<RT-DO-WALK ,P?OUT>
		)
		(<IN? ,PRSO ,ROOMS>
			<RT-NOT-IN-ROOM-MSG>
		)
		(<AND <MC-PRSO? ,TH-ROCK ,TH-GRAVESTONE ,LG-CELL-DOOR>
				<EQUAL? ,GL-HIDING ,PRSO>
			>
			<RT-DO-WALK ,P?OUT>
		)
		(<FSET? ,PRSO ,FL-DOOR>
			<COND
				(<RT-OTHER-SIDE ,PRSO>
					<RT-DO-WALK ,GL-DOOR-DIR>
				)
				(T
					<TELL The+verb ,PRSO "do" "n't seem to go anywhere." CR>
				)
			>
		)
		(<OR	<FSET? ,PRSO ,FL-VEHICLE>
				<FSET? ,PRSO ,FL-CONTAINER>
				<FSET? ,PRSO ,FL-SURFACE>
			>
			<COND
				(<IN? ,WINNER ,PRSO>
					<COND
						(<OR	<FSET? ,PRSO ,FL-SURFACE>
								<FSET? ,PRSO ,FL-OPEN>
							>
							<MOVE ,WINNER <LOC <LOC ,WINNER>>>
							<TELL The+verb ,WINNER "get" out ,PRSO " of" the ,PRSO "." CR>
						)
						(<FSET? ,PRSO ,FL-OPENABLE>
							<TELL The+verb ,PRSO "are" " closed." CR>
						)
						(T
							<TELL The ,WINNER " can't get" out ,PRSO " of" the ,PRSO "." CR>
						)
					>
				)
				(T
					<TELL The+verb ,WINNER "are" "n't" in ,PRSO the ,PRSO "." CR>
				)
			>
		)
		(<FSET? <SET L <LOC ,PRSO>> ,FL-CONTAINER>
			<TELL "[from" the .L "]" CR>
			<RT-PERFORM ,V?TAKE ,PRSO>
		)
		(T
			<RT-IMPOSSIBLE-MSG>
		)
	>
	<RTRUE>
>

<ROUTINE RT-NOT-IN-ROOM-MSG ()
	<TELL The+verb ,WINNER "are" "n't" in ,PRSO the ,PRSO "." CR>
>

<ROUTINE V-EXTEND ()
	<RT-IMPOSSIBLE-MSG>
>

<ROUTINE V-EXTINGUISH ()
	<COND
		(<AND <EQUAL? ,P-PRSA-WORD ,W?PUT ,W?STICK>
				<MC-PRSI? <> ,ROOMS>
				<MC-PRSO? ,TH-HEAD ,TH-LEGS ,TH-HANDS ,TH-FEET>
			>
			<PERFORM ,V?EXTEND ,PRSO>
		)
		(<NOT <FSET? ,PRSO ,FL-LIGHTED>>
			<TELL The+verb ,PRSO "are" "n't on fire." CR>
		)
		(<MC-PRSI? <> ,ROOMS>
			<SETG CLOCK-WAIT T>
			<RT-AUTHOR-MSG ,K-HOW-INTEND-MSG>
		)
		(T
			<TELL
The ,WINNER " can't put out" the ,PRSO " with" the ,PRSI "." CR
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "F"
;"---------------------------------------------------------------------------"

<ROUTINE V-FILL ()
	<RT-WASTE-OF-TIME-MSG>
>

;"---------------------------------------------------------------------------"
; "G"
;"---------------------------------------------------------------------------"

<CONSTANT K-REFERRING-MSG "What are you referring to?">

<ROUTINE PRE-GIVE ("OPTIONAL" (FEED? <>))
	<COND
		(<OR  <NOT ,PRSO>
   			<NOT ,PRSI>
			>
			<TELL ,K-REFERRING-MSG CR>
		)
		(<OR  <MC-PRSO? ,PRSI>
   			<IN? ,PRSI ,GLOBAL-OBJECTS>
			>
			<RT-IMPOSSIBLE-MSG>
		)
		(<NOT <FSET? ,PRSI ,FL-ALIVE>>
			<TELL The ,WINNER " can't " vw " anything to " a ,PRSI "." CR>
		)
		(<AND <FSET? ,PRSI ,FL-ASLEEP>
				<NOT
					<AND
						<MC-PRSO? ,TH-HAWTHORN>
						<MC-PRSI? ,CH-NIMUE>
					>
				>
			>
			<TELL
The+verb ,PRSI "are" " in no condition to accept" his ,WINNER " offer." CR
			>
		)
		(<AND <MC-PRSI? ,CH-PLAYER>
				<IN? ,PRSO ,CH-PLAYER>
			>
			<TELL The ,CH-PLAYER " already have" the ,PRSO "." CR>
		)
		(<AND <NOT <MC-PRSI? ,CH-PLAYER>>
				<NOT <RT-META-IN? ,PRSO ,WINNER>>
			>
			<TELL The+verb ,WINNER "do" "n't have" the ,PRSO "." CR>
		)
		(<AND <FSET? ,PRSO ,FL-WORN>
				<IN? ,PRSO ,WINNER>
			>
			<COND
				(<NOT <MC-PRSO? ,TH-BREECHES ,TH-TUNIC>>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT>>
					<FCLEAR ,PRSO ,FL-WORN>
					<RT-FIRST-YOU-MSG "take off" ,PRSO>
					<RFALSE>
				)
				(T
					<TELL
The ,WINNER " would have to take off" the ,PRSO " first." CR
					>
				)
			>
		)
	>
>

<ROUTINE V-GIVE ()
	<COND
		(<MC-PRSI? ,CH-PLAYER>
			<TELL "There's nobody to ask." CR>
		)
	;	(<AND <MC-PRSI? ,CH-SOLDIERS>	; "Goes in soldier's action rtn."
				<FSET? ,PRSO ,FL-MONEY>
			>
			<TELL
The+verb ,PRSI "do" "n't even glance at" the ,PRSO ". Clearly" he ,PRSI
" cannot be bribed." CR
			>
		)
		(<FSET? ,PRSI ,FL-ALIVE>
			<TELL
The+verb ,PRSI "do" "n't appear to be interested in" the ,PRSO "." CR
			>
		)
		(T
			<TELL The ,WINNER " can't give things to" the ,PRSI "." CR>
		)
	>
>

<ROUTINE V-GIVE-SWP ("AUX" TMP)
	<SET TMP ,PRSO-NP>
	<SETG PRSO-NP ,PRSI-NP>
	<SETG PRSI-NP .TMP>
	<PERFORM ,V?GIVE ,PRSI ,PRSO>
	<RTRUE>
>

<ROUTINE V-GOODBYE ()
	<RT-HI-BYE-MSG>
>

<ROUTINE RT-HI-BYE-MSG ()
	<COND
		(<RT-FOOLISH-TO-TALK?>
			<SETG CLOCK-WAIT T>
			<RFATAL>
		)
		(T
			<RT-NO-RESPONSE-MSG>
			<RTRUE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "H"
;"---------------------------------------------------------------------------"

<ROUTINE V-HELLO ()
	<RT-HI-BYE-MSG>
>

<ROUTINE V-HELP ()
	<COND
		(<MC-HERE? ,RM-CRYSTAL-CAVE>
			<RT-AUTHOR-MSG "To get a hint, look into the crystal ball.">
		)
		(T
			<RT-AUTHOR-MSG "If only you had a crystal ball....">
		)
	>
>

<ROUTINE V-HIDE ()
	<SETG CLOCK-WAIT T>
	<TELL "[You will have to be more specific.]" CR>
>

<ROUTINE V-HIDE-BEHIND ()
	<TELL "Behind" the ,PRSO " is not a very good place to hide." CR>
>

<ROUTINE V-HIDE-UNDER ()
	<TELL "Under" the ,PRSO " is not a very good place to hide." CR>
>

<ROUTINE V-HOLD-UNDER ()
	<TELL
The+verb ,WINNER "hold" the ,PRSO " under" the ,PRSI ", but nothing happens." CR
	>
>

<ROUTINE GLOBAL-IN? (OBJ1 OBJ2)
	<RT-GLOBAL-IN? .OBJ1 .OBJ2>
>

<ROUTINE RT-GLOBAL-IN? (OBJ1 OBJ2 "AUX" TBL)
	<COND
		(<EQUAL? .OBJ1 .OBJ2>
			<RTRUE>
		)
		(<SET TBL <GETPT .OBJ2 ,P?GLOBAL>>
			<INTBL? .OBJ1 .TBL </ <PTSIZE .TBL> 2>>
		)
	>
>

<CONSTANT YOU-DIDNT-SAY-W "[You didn't say w">

<ROUTINE RT-FIRST-YOU-MSG (STR "OPTIONAL" (OBJ 0) (OBJ2 0))
	<TELL "[">
	<RT-PRINT-OBJ ,WINNER ,K-ART-THE T .STR>
	<COND
		(.OBJ
			<TELL the .OBJ>
			<COND
				(<AND .OBJ2
						<NOT <IN? .OBJ2 ,ROOMS>>
					>
					<TELL " from" the .OBJ2>
				)
			>
		)
	>
	<TELL " first.]" CR>
>

;<ROUTINE SEE-INTO? (THERE "OPTIONAL" (TELL? T) (IGNORE-DOOR <>)"AUX" P L TBL O)
	<SET P 0>
	<REPEAT ()
		<COND
			(<OR	<0? <SET P <NEXTP ,HERE .P>>>
					<L? .P ,LOW-DIRECTION>
				>
				<COND
					(.TELL?
						<TELL-CANT-FIND>
					)
				>
				<RFALSE>
			)
		>
		<SET TBL <GETPT ,HERE .P>>
		<SET L <PTSIZE .TBL>>
		<COND
			(<==? .L ,UEXIT>
				<COND
					(<==? <GET/B .TBL ,REXIT> .THERE>
						<RTRUE>
					)
				>
			)
			(<==? .L ,DEXIT>
				<COND
					(<==? <GET/B .TBL ,REXIT> .THERE>
						<COND
							(<FSET? <GET/B .TBL ,DEXITOBJ> ,FL-OPEN>
								<RTRUE>
							)
							(<WALK-THRU-DOOR? .TBL <GET/B .TBL ,DEXITOBJ> <>>
								<RTRUE>
							)
							(.IGNORE-DOOR
								<RTRUE>
							)
							(T
								<COND
									(.TELL?
										<SETG CLOCK-WAIT T>
										<TELL "[The door to that room is closed.]" CR>
									)
								>
								<RFALSE>
							)
						>
					)
				>
			)
			(<==? .L ,CEXIT>
				<COND
					(<==? <GET/B .TBL ,REXIT> .THERE>
						<COND
							(<VALUE <GETB .TBL ,CEXITFLAG>>
								<RTRUE>
							)
							(T
								<COND
									(.TELL?
										<TELL-CANT-FIND>
									)
								>
								<RFALSE>
							)
						>
					)
				>
			)
		>
	>
>

<ROUTINE TELL-CANT-FIND ()
	<SETG CLOCK-WAIT T>
	<TELL "[That place isn't close enough.]" CR>
>

;"---------------------------------------------------------------------------"
; "J"
;"---------------------------------------------------------------------------"

<ROUTINE V-JOUST ()
	<TELL The ,WINNER " can't joust unless">
	<COND
		(<IN? ,WINNER ,TH-HORSE>
			<TELL the+verb ,WINNER "have" " a lance." CR>
		)
		(T
			<TELL the+verb ,WINNER "are" " on a horse." CR>
		)
	>
>

<ROUTINE V-JUMP ()
	<TELL "Wheeeeee!|">
	<RT-AUTHOR-MSG "Boy, we're having fun now!">
>

;"---------------------------------------------------------------------------"
; "K"
;"---------------------------------------------------------------------------"

<ROUTINE V-KISS ()
	<COND
		(<FSET? ,PRSO ,FL-ALIVE>
			<RT-NOT-LIKELY-MSG ,PRSO "would appreciate your advances">
		)
		(T
			<TELL
"You pucker up and give" the ,PRSO " a quick peck, but nothing happens.|"
			>
		)
	>
	<RT-AUTHOR-MSG "You must have a very strange social life.">
>

<ROUTINE V-KNEEL ()
	<COND
		(,PRSO
			<RT-NO-POINT-MSG "Paying respect to">
		)
		(T
			<TELL
The+verb ,WINNER "kneel" " for a moment and then" verb ,WINNER "resume"
" standing." CR
			>
		)
	>
>

<ROUTINE V-KNOCK ()
	<COND
		(<FSET? ,PRSO ,FL-DOOR>
			<COND
				(<FSET? ,PRSO ,FL-OPEN>
					<RT-ALREADY-MSG ,PRSO "open">
				)
				(<MC-FORM? ,K-FORM-ARTHUR>
					<TELL "There's no answer." CR>
				)
				(T
					<TELL
The+verb ,WINNER "scratch" " at" the ,PRSO " but" verb ,WINNER "get" " no answer." CR
					>
				)
			>
		)
		(<FSET? ,PRSO ,FL-ALIVE>
			<PERFORM ,V?ATTACK ,PRSO>
			<RTRUE>
		)
		(T
			<RT-WASTE-OF-TIME-MSG>
		)
	>
>

;"---------------------------------------------------------------------------"
; "L"
;"---------------------------------------------------------------------------"

<ROUTINE PRE-LAND ()
	<COND
		(<AND <NOT <FSET? ,HERE ,FL-AIR>>
				<NOT <MC-HERE? ,RM-RAVEN-NEST>>
			>
			<TELL "You're not flying." CR>
		)
	>
>

<ROUTINE V-LAND ()
	<COND
		(<MC-PRSO? ,ROOMS ,CH-PLAYER>
			<RT-DO-WALK ,P?DOWN>
		)
		(<MC-PRSO? ,INTDIR>
			<RT-DO-WALK ,P?DOWN>
		)
		(T
			<TELL "You aren't flying" the ,PRSO "." CR>
		)
	>
>

<CONSTANT K-PERCH-MSG
"You perch there for a moment, see nothing of interest, and then take off
again.|">

<ROUTINE V-LAND-ON ("AUX" DIR)
	<COND
		(<IN? ,PRSO ,ROOMS>
			<COND
				(<AND <SET DIR <RT-FIND-DIR ,PRSO>>
						<RT-DO-WALK .DIR>
					>
					<RTRUE>
				)
				(<FSET? ,PRSO ,FL-AUTO-ENTER>
					<RT-GOTO ,PRSO>
				)
				(T
				;	<RT-YOU-CANT-MSG "go">
					<TELL ,K-PERCH-MSG>
				)
			>
		)
		(T
			<TELL ,K-PERCH-MSG>
		)
	>
>

<ROUTINE V-LIE-DOWN ()
	<COND
		(<AND <IN? ,CH-PLAYER ,TH-BEHIND-G-STONE>
				<MC-PRSO? ,ROOMS ,TH-GROUND>
			>
			<SETG GL-HIDING ,TH-GRAVESTONE>
			<TELL "You cower low to the ground." CR>
		)
		(,GL-SLEEP
			<V-SLEEP>
		)
		(T
			<TELL "With so much at stake, resting is out of the question." CR>
		)
	>
>

<ROUTINE V-LIGHT ()
	<SETG CLOCK-WAIT T>
	<RT-AUTHOR-MSG ,K-HOW-INTEND-MSG>
>

<ROUTINE V-LISTEN ()
	<TELL "At the moment," the+verb ,WINNER "hear" " nothing." CR>
>

<ROUTINE V-LOCK ()
	<COND
		(<AND <EQUAL? ,WINNER ,CH-PLAYER>
				<NOT <MC-FORM? ,K-FORM-ARTHUR>>
			>
			<RT-ANIMAL-CANT-MSG>
		)
		(<EQUAL? ,P-PRSA-WORD ,W?BAR>
			<TELL The ,WINNER " can't bar" the ,PRSO "." CR>
		)
		(<NOT <FSET? ,PRSO ,FL-OPENABLE>>
			<RT-YOU-CANT-MSG>
		)
		(<FSET? ,PRSO ,FL-LOCKED>
			<RT-ALREADY-MSG ,PRSO "locked">
		)
		(<NOT <RT-MATCH-KEY ,PRSO ,PRSI>>
			<TELL The ,WINNER " can't lock" the ,PRSO " with" the ,PRSI "." CR>
		)
		(T
			<FSET ,PRSO ,FL-LOCKED>
			<COND
				(<FSET? ,PRSO ,FL-OPEN>
					<FCLEAR ,PRSO ,FL-OPEN>
					<COND
						(<FSET? ,PRSO ,FL-DOOR>
							<RT-CHECK-ADJ ,PRSO>
						)
					>
					<TELL
The+verb ,WINNER "close" the ,PRSO " and" verb ,WINNER "lock" him ,PRSO "." CR
					>
				)
				(T
					<RT-LOCK-MSG ,PRSO ,PRSI T>
					<TELL "." CR>
				)
			>
		)
	>
>

<ROUTINE V-LOOK ()
	<COND
		(<DESCRIBE-ROOM T>
			<RT-DESCRIBE-OBJECTS>
		)
	>
	<RTRUE>
>

<ROUTINE V-LOOK-BEHIND ()
	<TELL
The+verb ,WINNER "do" "n't see anything " <RT-PICK-NEXT ,K-UNUSUAL-TBL>
" behind" the ,PRSO "." CR
	>
>

<ROUTINE V-LOOK-DOWN ()
	<COND
		(<AND <MC-PRSO? ,ROOMS ,RM-STAIRS-1 ,RM-STAIRS-2 ,GLOBAL-HERE>
				<MC-HERE? ,RM-LANDING ,RM-STAIRS-2 ,RM-STAIRS-2 ,RM-CIRC-ROOM>
			>
			<COND
				(<MC-HERE? ,RM-STAIRS-2>
					<TELL "The stairs disappear into the total darkness below." CR>
				)
				(T
					<TELL "The stairs wind down out of sight." CR>
				)
			>
		)
		(<MC-PRSO? ,ROOMS>
			<PERFORM ,V?EXAMINE ,TH-GROUND>
			<RTRUE>
		)
		(T
			<RT-YOU-CANT-MSG "stare down">
			<RT-AUTHOR-MSG "You blink first.">
		)
	>
>

<ROUTINE PRE-LOOK-IN ()
;	<ROOM-CHECK>
	<RFALSE>
>

<ROUTINE V-LOOK-IN ("OPTIONAL" (DIR ,P?IN) "AUX" RM)
	<COND
		(<MC-PRSO? ,ROOMS>
			<COND
				(<OR	<FSET? <SET RM ,P-IT-OBJECT> ,FL-CONTAINER>
						<SET RM <FIND-FLAG-HERE ,FL-CONTAINER>>
						<SET RM <FIND-FLAG-LG ,HERE ,FL-OPENABLE>>
					>
				;	<TELL-I-ASSUME .RM>
					<PERFORM ,PRSA .RM ,PRSI>
					<RTRUE>
				)
				(T
					<SETUP-ORPHAN "look in ">
					<TELL "[What do you want to look in?]" CR>
					<SETG CLOCK-WAIT T>
					<RFATAL>
				)
			>
		)
	>
	<COND
	;	(<AND <IN? ,PRSO ,ROOMS>
				<OR
					<RT-GLOBAL-IN? ,PRSO ,HERE>
					<SEE-INTO? ,PRSO <>>
				>
			>
			<ROOM-PEEK ,PRSO>
		)
		(<AND <NOT <FSET? ,PRSO ,FL-OPEN>>
				<NOT <FSET? ,PRSO ,FL-TRANSPARENT>>
				<FSET? ,PRSO ,FL-OPENABLE>
			>
			<TELL The+verb ,PRSO "are" " closed." CR>
		)
		(<AND <OR
					<FSET? ,PRSO ,FL-CONTAINER>
					<FSET? ,PRSO ,FL-SURFACE>
				>
				<SEE-INSIDE? ,PRSO>
			>
		;	<COND
				(<NOT <SEE-INSIDE? ,PRSO>>
					<RT-FIRST-YOU-MSG "open" ,PRSO>
					<FSET ,PRSO ,FL-OPEN>
				)
			>
			<COND
				(<SEE-ANYTHING-IN? ,PRSO>
					<TELL "You can see">
					<PRINT-CONTENTS ,PRSO>
					<TELL in ,PRSO>
					<COND
						(<NOT <FSET? ,PRSO ,FL-SURFACE>>
							<TELL "side">
						)
					>
					<TELL the ,PRSO "." CR>
				)
				(T
					<TELL "There's nothing" in ,PRSO the ,PRSO "." CR>
				)
			>
		)
		(<==? .DIR ,P?IN>
			<RT-YOU-CANT-MSG "see inside">
		)
		(T
			<RT-YOU-CANT-MSG "see outside">
		)
	>
>

<ROUTINE V-LOOK-ON ()
	<COND
		(<FSET? ,PRSO ,FL-SURFACE>
			<V-LOOK-IN>
		)
		(T
			<TELL "There's no good surface on" the ,PRSO "." CR>
		)
	>
>

<ROUTINE V-LOOK-THRU ("AUX" RM)
	<COND
		(<FSET? ,PRSO ,FL-DOOR>
			<COND
				(<OR	<NOUN-USED? ,PRSO ,W?KEYHOLE>
						<AND
							<NOUN-USED? ,PRSO ,W?HOLE>
							<ADJ-USED? ,PRSO ,W?KEY>
						>
					>
					<TELL The ,WINNER " can't see much from here." CR>
				)
				(<AND <NOT <FSET? ,PRSO ,FL-OPEN>>
						<NOT <FSET? ,PRSO ,FL-TRANSPARENT>>
					>
					<TELL The+verb ,PRSO "are" " closed." CR>
				)
				(<SET RM <RT-OTHER-SIDE ,PRSO>>
					<TELL The+verb ,WINNER "see">
					<COND
						(<SEE-ANYTHING-IN? .RM>
							<PRINT-CONTENTS .RM>
						)
						(T
							<TELL the .RM>
						)
					>
					<TELL "." CR>
				)
				(T
					<RT-YOU-CANT-MSG "look through">
				)
			>
		)
		(<FSET? ,PRSO ,FL-CONTAINER>
			<PERFORM ,V?LOOK-IN ,PRSO>
		)
		(<FSET? ,PRSO ,FL-TRANSPARENT>
			<TELL
The+verb ,WINNER "do" "n't see anything " <RT-PICK-NEXT ,K-UNUSUAL-TBL> "." CR
			>
		)
		(T
			<RT-YOU-CANT-MSG "look through">
		)
	>
>

<ROUTINE V-LOOK-UP ()
	<COND
		(<AND <MC-PRSO? ,ROOMS ,RM-STAIRS-1 ,RM-STAIRS-2 ,GLOBAL-HERE>
				<MC-HERE? ,RM-CELLAR ,RM-STAIRS-2 ,RM-STAIRS-2 ,RM-CIRC-ROOM>
			>
			<TELL "The stairs wind up out of sight." CR>
		)
		(<MC-PRSO? ,ROOMS>
			<PERFORM ,V?EXAMINE ,TH-SKY>
			<RTRUE>
		)
		(T
			<RT-YOU-CANT-MSG "look up">
			<RT-AUTHOR-MSG "Dictionaries haven't been invented yet.">
		)
	>
>

<ROUTINE V-LOOK-UNDER ()
	<COND
		(<FSET? ,HERE ,FL-AIR>
			<TELL The ,WINNER " can't do that from here." CR>
		)
		(T
			<TELL The+verb ,WINNER "see" " nothing but medieval ">
			<COND
				(<MC-HERE? ,RM-BOG ,RM-EDGE-OF-BOG>
					<TELL "peat">
				)
				(<FSET? ,HERE ,FL-WATER>
					<TELL "mud">
				)
				(T
					<TELL "dust">
				)
			>
			<TELL " there." CR>
		)
	>
>

<ROUTINE V-LOWER ()
	<RT-NO-POINT-MSG "Toying in this way with">
>

;"---------------------------------------------------------------------------"
; "M"
;"---------------------------------------------------------------------------"

<ROUTINE V-MELT ()
	<RT-AUTHOR-MSG ,K-HOW-INTEND-MSG>
>

<ROUTINE V-MOVE ()
	<COND
		(<MC-PRSO? ,ROOMS>
			<V-WALK-AROUND>
			<RTRUE>
		)
		(<AND <EQUAL? ,P-PRSA-WORD ,W?POKE>
				<MC-PRSI? ,ROOMS>
			>
			<PERFORM ,V?EXTEND ,PRSO>
		)
		(<FSET? ,PRSO ,FL-TAKEABLE>
			<COND
				(<EQUAL? ,P-PRSA-WORD ,W?PUSH>
					<RT-NO-POINT-MSG "Pushing">
				)
				(<EQUAL? ,P-PRSA-WORD ,W?PULL>
					<RT-NO-POINT-MSG "Pulling">
				)
				(T
					<RT-NO-POINT-MSG "Moving">
				)
			>
		)
		(T
			<TELL "You couldn't possibly move" the ,PRSO "." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "N"
;"---------------------------------------------------------------------------"

<ROUTINE V-NO ()
	<COND
		(,GL-QUESTION
			<TELL "That was just a rhetorical question." CR>
		)
		(T
			<TELL "No one asked you a question." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "O"
;"---------------------------------------------------------------------------"

<ROUTINE RT-MATCH-KEY (DOOR "OPT" (KEY <>))
	<COND
		(<EQUAL? .DOOR ,TH-CUPBOARD>
			<COND
				(<EQUAL? .KEY ,TH-CUPBOARD-KEY>
					<RTRUE>
				)
			>
		)
		(<EQUAL? .DOOR ,LG-IVORY-DOOR>
			<COND
				(<EQUAL? .KEY ,TH-IVORY-KEY>
					<RTRUE>
				)
			>
		)
		(<EQUAL? .DOOR ,TH-CHAINS ,LG-CELL-DOOR>
			<COND
				(<EQUAL? .KEY ,TH-MASTER-KEY>
					<RTRUE>
				)
			>
		)
		(<EQUAL? .DOOR ,LG-SILVER-DOOR>
			<COND
				(<EQUAL? .KEY ,TH-SILVER-KEY>
					<RTRUE>
				)
			>
		)
		(<EQUAL? .DOOR ,TH-LEFT-MANACLE ,TH-RIGHT-MANACLE>
			<COND
				(<EQUAL? .KEY ,TH-GOLD-KEY>
					<RTRUE>
				)
			>
		)
	>
>

<GLOBAL GL-DOOR-DIR <>>

<ROUTINE RT-OTHER-SIDE (DOOR "AUX" (RM <>) L)
	<SET L <LOC ,WINNER>>
	<REPEAT ((P 0) OBJ PT PTS)
		<COND
			(<OR	<ZERO? <SET P <NEXTP .L .P>>>
					<L? .P ,LOW-DIRECTION>
				>
				<RFALSE>
			)
			(<SET PT <GETPT .L .P>>
				<SET PTS <PTSIZE .PT>>
				<COND
					(<AND <==? .PTS ,DEXIT>
							<EQUAL? .DOOR <GET/B .PT ,DEXITOBJ>>
						>
						<SETG GL-DOOR-DIR .P>
						<SET RM <GET/B .PT ,REXIT>>
						<RETURN>
					)
				>
			)
		>
	>
	<RETURN .RM>
>

<ROUTINE RT-LOCK-MSG (DOOR KEY LOCK?)
	<TELL
The+verb ,WINNER "put" the .KEY " in the lock and" verb ,WINNER "give" " it a
turn"
	>
	<COND
		(.LOCK?
			<TELL ". " The .DOOR " locks with">
		)
		(T
			<TELL ", and" verb ,WINNER "hear">
		)
	>
	<TELL " a satisfying click">
>

<ROUTINE RT-OPEN-DOOR-MSG (DOOR "OPT" (KEY <>) "AUX" RM (LOCK? <>) TMP1 TMP2)
	<COND
		(<FSET? .DOOR ,FL-LOCKED>
			<SET LOCK? T>
			<FCLEAR .DOOR ,FL-LOCKED>
			<RT-LOCK-MSG .DOOR .KEY <>>
			<COND
				(<OR	<FSET? .DOOR ,FL-AUTO-OPEN>
						<VERB? OPEN>
					>
					<FSET .DOOR ,FL-OPEN>
					<COND
						(<FSET? .DOOR ,FL-DOOR>
							<RT-CHECK-ADJ .DOOR>
						)
					>
					<TELL ". " The+verb .DOOR "swing" " open">
				)
			>
		)
		(T
			<FSET .DOOR ,FL-OPEN>
			<COND
				(<FSET? .DOOR ,FL-DOOR>
					<RT-CHECK-ADJ .DOOR>
				)
			>
			<TELL The+verb ,WINNER "open" the .DOOR>
		)
	>
	<COND
		(<FSET? .DOOR ,FL-OPEN>
			<COND
				(<FSET? .DOOR ,FL-DOOR>
					<COND
						(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>
							<RT-UPDATE-MAP-WINDOW>
						)
					>
					<COND
						(<NOT <SET RM <RT-OTHER-SIDE .DOOR>>>)
						(<FSET? .DOOR ,FL-AUTO-ENTER>
							<TELL ",">
							<COND
								(.LOCK?
									<TELL the ,WINNER>
								)
							>
							<FCLEAR .DOOR ,FL-OPEN>
							<TELL
verb ,WINNER "step" " through, and" verb ,WINNER "close" him .DOOR " behind"
him ,WINNER "." CR CR
							>
							<RT-GOTO .RM>
							<RT-SCORE-OBJ .DOOR>
							<RTRUE>
						)
						(<AND <SET TMP2 <GETP ,HERE ,P?ADJACENT>>
						      <SET TMP1 <INTBL? .RM <REST .TMP2 1> <GETB .TMP2 0> 1>>
						      <GETB .TMP1 1>
						      <SEE-ANYTHING-IN? .RM>>
						 <TELL " and">
						 <COND (.LOCK?
							<TELL the ,WINNER>)>
						 <TELL verb ,WINNER "see">
						 <PRINT-CONTENTS .RM>)
									>
								)
				(<NOT <FSET? .DOOR ,FL-TRANSPARENT>>
					<COND
						(<SEE-ANYTHING-IN? .DOOR>
							<TELL ". Inside you see">
							<PRINT-CONTENTS .DOOR>
						)
					>
				)
			>
		)
	>
	<TELL "." CR>
	<COND
		(<AND <NOT <FSET? .DOOR ,FL-TAKEABLE>>
				<FSET? .DOOR ,FL-OPEN>
			>
			<RT-SCORE-OBJ .DOOR>
		)
	>
	<RTRUE>
>

<ROUTINE V-OPEN ("AUX" F STR RM)
	<COND
		(<NOT <FSET? ,PRSO ,FL-OPENABLE>>
			<RT-YOU-CANT-MSG>
		)
		(<FSET? ,PRSO ,FL-OPEN>
			<RT-ALREADY-MSG ,PRSO "open">
		)
		(<AND <EQUAL? ,WINNER ,CH-PLAYER>
				<NOT <MC-FORM? ,K-FORM-ARTHUR>>
			>
			<RT-ANIMAL-CANT-MSG "open">
		)
		(<AND <NOT ,PRSI>
				<FSET? ,PRSO ,FL-LOCKED>
			>
			<TELL The+verb ,PRSO "are" " locked." CR>
		)
		(<AND ,PRSI
				<NOT <RT-MATCH-KEY ,PRSO ,PRSI>>
			>
			<TELL The ,WINNER " can't open" the ,PRSO " with" the ,PRSI "." CR>
		)
		(T
			<RT-OPEN-DOOR-MSG ,PRSO ,PRSI>
		)
	>
>

;"---------------------------------------------------------------------------"
; "P"
;"---------------------------------------------------------------------------"

<ROUTINE V-POINT ()
	<RT-NO-POINT-MSG "Pointing">
>

<ROUTINE V-POINT-SWP ("AUX" TMP)
	<SET TMP ,PRSO-NP>
	<SETG PRSO-NP ,PRSI-NP>
	<SETG PRSI-NP .TMP>
	<PERFORM ,V?POINT ,PRSI ,PRSO>
>

<ROUTINE V-POLISH ()
	<TELL The+verb ,PRSO "do" "n't need ">
	<COND
		(<EQUAL? ,P-PRSA-WORD ,W?RUB>
			<TELL "rubb">
		)
		(<EQUAL? ,P-PRSA-WORD ,W?SHINE>
			<TELL "shin">
		)
		(T
			<TELL vw>
		)
	>
	<TELL "ing." CR>
>

<ROUTINE V-POLISH-SWP ("AUX" TMP)
	<SET TMP ,PRSO-NP>
	<SETG PRSO-NP ,PRSI-NP>
	<SETG PRSI-NP .TMP>
	<PERFORM ,V?POLISH ,PRSI ,PRSO>
>

<ROUTINE V-PRAY ()
	<COND
		(<FSET? ,CH-PLAYER ,FL-BROKEN>
			<TELL The+verb ,WINNER "mutter" " a brief prayer." CR>
			<RT-AUTHOR-MSG
"You won't get any more chivalry points for it, but it looks like you could
still use the help."
			>
		)
		(T
			<TELL
"As is your knightly duty, you bow your head in silent prayer and ask for
guidance in your quest." CR
			>
			<FSET ,CH-PLAYER ,FL-BROKEN>
			<RT-SCORE-MSG 10 0 0 0>
		)
	>
>

<ROUTINE PRE-PUT ()
	<COND
		(<AND <MC-PRSO? ,TH-HEAD>
				<MC-PRSI? ,TH-BRACELET>
			>
			<RFALSE>
		)
		(<MC-PRSO? ,TH-HEAD ,TH-HANDS ,TH-LEGS ,TH-MOUTH ,TH-FEET>
			<RT-WONT-HELP-MSG>
			<RTRUE>
		)
		(<AND <VERB? PUT>
				<MC-PRSI? ,ROOMS>
			>
			<PERFORM ,V?WEAR ,PRSO>
			<RTRUE>
		)
		(<IN? ,PRSO ,GLOBAL-OBJECTS>
			<RT-IMPOSSIBLE-MSG>
			<RTRUE>
		)
		(<MC-PRSI? ,TH-GROUND ,GLOBAL-HERE ,HERE>
			<SETG GL-DROP-HERE T>
			<SETG P-PRSA-WORD ,W?DROP>
			<PERFORM ,V?DROP ,PRSO>
			<RTRUE>
		)
		(<MC-PRSI? <> ,INTDIR ,TH-MOUTH>
			<RFALSE>
		)
		(<IN? ,PRSI ,GLOBAL-OBJECTS>
			<RT-IMPOSSIBLE-MSG>
			<RTRUE>
		)
		(<HELD? ,PRSI ,PRSO>
			<RT-YOU-CANT-MSG "put" ,PRSI "in it">
		)
	>
>

<ROUTINE V-PUT ()
	<COND
		(<FSET? ,PRSI ,FL-ALIVE>
			<TELL The ,PRSO " wouldn't look good on" the ,PRSI "." CR>
			<RT-AUTHOR-MSG "Have you no fashion sense at all?">
		)
		(<NOT <FSET? ,PRSI ,FL-SURFACE>>
			<TELL "There's not a good surface on" the ,PRSI "." CR>
		)
		(T
			<RT-PUT-ON-OR-IN>
		)
	>
>

;<ROUTINE TELL-FIND-NONE (STR "OPTIONAL" (OBJ <>))
	<TELL "You search for " .STR>
	<COND
		(.OBJ
			<TELL the .OBJ>
		)
	>
	<TELL " but find none." CR>
>

<ROUTINE PRE-PUT-IN ()
	<COND
		(<MC-PRSI? ,ROOMS>
			<PERFORM ,V?RETRACT ,PRSO>
			<RTRUE>
		)
		(<AND <VERB-WORD? ,W?STICK>
				<FSET? ,PRSO ,FL-WEAPON>
				<FSET? ,PRSI ,FL-ALIVE>
			>
			<PERFORM ,V?ATTACK ,PRSI ,PRSO>
			<RTRUE>
		)
		(<AND <FSET? ,PRSO ,FL-KEY>
				<FSET? ,PRSI ,FL-OPENABLE>
				<RT-MATCH-KEY ,PRSI ,PRSO>
			>
			<COND
				(<FSET? ,PRSI ,FL-LOCKED>
					<PERFORM ,V?UNLOCK ,PRSI ,PRSO>
				)
				(T
					<PERFORM ,V?LOCK ,PRSI ,PRSO>
				)
			>
			<RTRUE>
		)
		(<MC-PRSI? ,PSEUDO-OBJECT>
			<RETURN <PRE-PUT>>
		)
		(<MC-PRSI? ,TH-HANDS ,TH-FEET>
			<RT-WONT-HELP-MSG>
			<SETG CLOCK-WAIT T>
			<RFATAL>
		)
	>
	<COND
		(<AND <FSET? ,PRSI ,FL-OPENABLE>
				<NOT <FSET? ,PRSI ,FL-OPEN>>
				<NOT <FSET? ,PRSI ,FL-LOCKED>>
				<FSET? ,PRSI ,FL-TAKEABLE>	;"Game specific -- Only open takeable objects."
			>
			<FSET ,PRSI ,FL-OPEN>
			<RT-FIRST-YOU-MSG "open" ,PRSI>
		)
	>
	<PRE-PUT>
>

<ROUTINE V-PUT-IN ()
	<COND
		(<NOT <FSET? ,PRSI ,FL-CONTAINER>>
			<TELL The ,WINNER " can't put anything into" the ,PRSI "." CR>
			<SETG CLOCK-WAIT T>
			<RFATAL>
		)
		(<NOT <FSET? ,PRSI ,FL-OPEN>>
			<COND
				(<FSET? ,PRSI ,FL-OPENABLE>
					<TELL The+verb ,PRSI "are" " closed">
				)
				(T
					<TELL The ,WINNER " can't open" the ,PRSI>
				)
			>
			<TELL "." CR>
		)
		(T
			<RT-PUT-ON-OR-IN>
		)
	>
>

<CONSTANT NOT-ENOUGH-ROOM "There's not enough room.|">

<ROUTINE RT-PUT-ON-OR-IN ()
	<COND
		(<ZERO? ,PRSI>
			<RT-YOU-CANT-MSG>
		)
		(<MC-PRSI? ,PRSO>
			<HAR-HAR>
		)
		(<IN? ,PRSO ,PRSI>
			<RT-ALREADY-MSG ,PRSO>
			<TELL in ,PRSI the ,PRSI ".">
			<COND
				(<G? ,P-MULT 1>
					<CRLF>
				)
				(T
					<RT-AUTHOR-OFF>
				)
			>
		)
		(<RT-ROOM-IN-MSG? ,PRSO ,PRSI>
			<RTRUE>
		)
		(<AND <NOT <HELD? ,PRSO>>
				<NOT <ITAKE>>
			>
			<RTRUE>
		)
		(T
			<COND
				(<FSET? ,PRSO ,FL-WORN>
					<COND
						(<NOT <MC-PRSO? ,TH-BREECHES ,TH-TUNIC ,TH-ARMOUR>>
							<FCLEAR ,PRSO ,FL-WORN>
							<RT-FIRST-YOU-MSG "take off" ,PRSO>
						)
						(T
							<TELL
The ,WINNER " would have to take off" the ,PRSO " first." CR
							>
							<RTRUE>
						)
					>
				)
			>
			<MOVE ,PRSO ,PRSI>
			<FSET ,PRSO ,FL-TOUCHED>
			<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT>>
			<COND
				(<AND <OR
							<IN? ,PRSI ,HERE>
							<FSET? ,PRSI ,FL-SURFACE>
							<FSET? ,PRSI ,FL-TRANSPARENT>
						>
						<RT-META-IN? ,PRSI ,HERE>
					>
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-OBJS>>
				)
			>
		;	<COND
				(<VERB? PUT>
					<FSET ,PRSO ,FL-ON>
				)
				(T
					<FCLEAR ,PRSO ,FL-ON>
				)
			>
			<COND
				(<AND <FSET? ,PRSI ,FL-PERSON>
						<FSET? ,PRSO ,FL-CLOTHING>
					>
					<FSET ,PRSO ,FL-WORN>
					<TELL The+verb ,WINNER "put" " on" the ,PRSO>
				)
				(<G? ,P-MULT 1>
					<TELL "Done">
				)
				(T
					<TELL The+verb ,WINNER "put" the ,PRSO " ">
					<COND
						(<OR	<FSET? ,PRSI ,FL-SURFACE>
								<FSET? ,PRSI ,FL-PERSON>
							;	<FSET? ,PRSO ,FL-ON>
							>
							<TELL "o">
						)
						(T
							<TELL "i">
						)
					>
					<TELL "nto" the ,PRSI>
				)
			>
			<TELL "." CR>
		)
	>
>

<ROUTINE V-PUT-THRU ("AUX" RM)
	<COND
		(<AND <EQUAL? ,P-PRSA-WORD ,W?PUT ,W?STICK>
				<MC-PRSO? ,TH-HANDS>
			>
			<COND
				(<FSET? ,PRSI ,FL-DOOR>
					<COND
						(<FSET? ,PRSI ,FL-OPEN>
							<TELL
The+verb ,WINNER "put" the ,PRSO " through" the ,PRSI ", but can't reach
anything on the other side." CR
							>
						)
						(T
							<TELL The+verb ,PRSI "are" " closed." CR>
						)
					>
				)
				(T
					<TELL
The ,WINNER " can't " vw the ,PRSO " through" the ,PRSI "." CR
					>
				)
			>
		)
		(<AND <EQUAL? ,P-PRSA-WORD ,W?PUT ,W?STICK>
				<OR
					<FSET? ,PRSO ,FL-WEAPON>
					<FSET? ,PRSO ,FL-KNIFE>
				>
			>
			<PERFORM ,V?ATTACK ,PRSI ,PRSO>
			<RTRUE>
		)
		(<AND <FSET? ,PRSO ,FL-BODY-PART>
				<EQUAL? <GET-OWNER ,PRSO> ,CH-PLAYER>
			>
			<RT-WASTE-OF-TIME-MSG>
		)
		(<IN? ,PRSO ,GLOBAL-OBJECTS>
			<RT-IMPOSSIBLE-MSG>
		)
		(<FSET? ,PRSI ,FL-DOOR>
			<COND
				(<FSET? ,PRSI ,FL-OPEN>
					<COND
						(<SET RM <RT-OTHER-SIDE ,PRSI>>
							<COND
								(<IDROP>
									<MOVE ,PRSO .RM>
									<TELL
The+verb ,WINNER "toss" the ,PRSO " through" the ,PRSI "." CR
									>
								)
							>
						)
						(T
							<TELL
The ,WINNER " can't " vw the ,PRSO " through" the ,PRSI "." CR
							>
						)
					>
				)
				(T
					<TELL The+verb ,PRSI "are" " closed." CR>
				)
			>
		)
		(T
			<TELL The ,WINNER " can't " vw the ,PRSO " through" the ,PRSI "." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "R"
;"---------------------------------------------------------------------------"

<ROUTINE V-RAISE ()
	<RT-NO-POINT-MSG "Toying in this way with">
>

<ROUTINE V-READ ()
	<COND
		(<NOT ,LIT>
			<TELL ,K-TOO-DARK-MSG>
			<SETG CLOCK-WAIT T>
			<RFATAL>
		)
	;	(<NOT <FSET? ,PRSO ,FL-READABLE>>
			<RT-HOW-READ-MSG>
			<TELL "?" CR>
		)
		(T
			<TELL "There's nothing written on" the ,PRSO "." CR>
		)
	>
>

<ROUTINE V-RELEASE ()
	<COND
		(<IN? ,PRSO ,WINNER>
			<PERFORM ,V?DROP ,PRSO>
			<RTRUE>
		)
		(T
			<TELL The+verb ,PRSO "are" "n't confined by anything." CR>
		)
	>
>

<ROUTINE V-RESCUE ()
	<SETG CLOCK-WAIT T>
	<RT-AUTHOR-MSG ,K-HOW-INTEND-MSG>
>

<ROUTINE V-RETRACT ()
	<RT-IMPOSSIBLE-MSG>
>

<ROUTINE V-RUB ()
	<TELL The+verb ,PRSO "do" "n't need rubbing." CR>
>

;"---------------------------------------------------------------------------"
; "S"
;"---------------------------------------------------------------------------"

<ROUTINE V-SAY ("AUX" PTR W NP OBJ C)
	<COND
		(<MC-PRSI? <> ,ROOMS ,CH-PLAYER>
			<COND
				(<MC-PRSI? <> ,ROOMS>
					<COND
						(<OR	<SET OBJ <FIND-FLAG-HERE ,FL-PERSON ,CH-PLAYER>>
								<SET OBJ <FIND-FLAG-HERE ,FL-ALIVE ,CH-PLAYER>>
							>
							<PERFORM ,V?SAY ,PRSO .OBJ>
							<RTRUE>
						)
					>
				)
			>
			<TELL "You say \"">
			<DIROUT ,K-D-TBL-ON ,K-DIROUT-TBL>
			<COND
				(<MC-PRSO? ,INTQUOTE>
					<PRINT-INTQUOTE>
				)
				(T
					<NP-PRINT ,PRSO-NP>
				)
			>
			<DIROUT ,K-D-TBL-OFF>
			<SET C <GETB ,K-DIROUT-TBL 2>>
			<COND
				(<AND <G=? .C !\a>
						<L=? .C !\z>
					>
					<PUTB ,K-DIROUT-TBL 2 <- .C 32>>
				)
			>
			<PRINTT <ZREST ,K-DIROUT-TBL 2> <ZGET ,K-DIROUT-TBL 0>>
			<TELL "\" to yourself, but fail to get a reaction." CR>
			<RTRUE>
		)
		(<MC-PRSO? ,INTQUOTE>
			<COND
				(<SET NP <GET-NP ,INTQUOTE>>
					<COND
						(<SET PTR <NP-LEXBEG .NP>>
							<COND
								(<EQUAL? <ZGET .PTR 0> ,W?QUOTE>
									<SET PTR <ZREST .PTR 8>>
								)
							>
							<COND
								(<SET W <ZGET .PTR 0>>
									<COND
										(<EQUAL? .W ,W?HELLO>
											<PERFORM ,V?HELLO ,PRSI>
											<RTRUE>
										)
										(<EQUAL? .W ,W?GOODBYE>
											<PERFORM ,V?GOODBYE ,PRSI>
											<RTRUE>
										)
										(<EQUAL? .W ,W?THANK ,W?THANKS>
											<PERFORM ,V?THANK ,PRSI>
											<RTRUE>
										)
									;	(<EQUAL? .W ,W?CYR>
											<SET PTR <ZREST .PTR 4>>
											<COND
												(<SET W <ZGET .PTR 0>>
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
	>
	<RT-AUTHOR-MSG
"Please refer to your instruction manual about how to talk to characters."
	>
>

<ROUTINE V-SCRATCH ()
	<COND
		(<AND <FSET? ,PRSO ,FL-ALIVE>
				<NOT <MC-FORM? ,K-FORM-ARTHUR>>
			>
			<SETG PRSI-NP <>>
			<PERFORM ,V?ATTACK ,PRSO ,TH-HANDS>
		)
		(<FSET? ,PRSO ,FL-DOOR>
			<COND
				(<FSET? ,PRSO ,FL-OPEN>
					<RT-ALREADY-MSG ,PRSO "open">
				)
				(T
					<TELL
The+verb ,WINNER "scratch" " at" the ,PRSO " but" verb ,WINNER "get" " no answer." CR
					>
				)
			>
		)
		(T
			<RT-NO-POINT-MSG "Scratching">
		)
	>
>

<ROUTINE V-SHIELD ()
	<COND
		(<MC-PRSI? <> ,ROOMS ,TH-SHIELD>
			<COND
				(<IN? ,TH-SHIELD ,WINNER>
					<TELL
"You hold up the shield, but it doesn't seem to make any difference." CR
					>
				)
				(T
					<TELL The+verb ,WINNER "are" "n't holding a shield." CR>
				)
			>
		)
		(T
			<TELL The ,WINNER " can't shield anything with" the ,PRSI "." CR>
		)
	>
>

<ROUTINE V-SHIELD-FROM ()
	<COND
		(<IN? ,TH-SHIELD ,WINNER>
			<TELL The+verb ,PRSI "are" "n't attacking" the ,PRSO "." CR>
		)
		(T
			<TELL The+verb ,WINNER "do" "n't have anything to shield" the ,PRSI " with." CR>
		)
	>
>

<ROUTINE V-SHOCK ()
	<COND
		(<NOT <FSET? ,PRSO ,FL-ALIVE>>
			<RT-AUTHOR-MSG ,K-HOW-INTEND-MSG>
			<SETG CLOCK-WAIT T>
			<RFATAL>
		)
		(<NOT <MC-FORM? ,K-FORM-EEL>>
			<COND
				(<EQUAL? ,P-PRSA-WORD ,W?SHOCK>
					<TELL
"You tell an off-colour story to" the ,PRSO " but fail to get a response." CR
					>
				)
				(T
					<RT-AUTHOR-MSG ,K-HOW-INTEND-MSG>
					<SETG CLOCK-WAIT T>
					<RFATAL>
				)
			>
		)
		(T
			<TELL "You zap" the ,PRSO ", but nothing happens." CR>
		)
	>
>

;"Duane"

<ROUTINE PRE-SHOW ()
	<COND
		(<EQUAL? <> ,PRSO ,PRSI>
			<TELL ,K-REFERRING-MSG CR>
		)
		(<MC-PRSI? ,CH-PLAYER>
			<COND
				(<RT-META-IN? ,PRSO ,CH-PLAYER>
					<PERFORM ,V?EXAMINE ,PRSO>
				)
			>
		)
		(<OR  <MC-PRSO? ,PRSI>
				<IN? ,PRSI ,GLOBAL-OBJECTS>
			>
			<RT-IMPOSSIBLE-MSG>
		)
		(<NOT <FSET? ,PRSI ,FL-ALIVE>>
			<TELL "You can't show things to" the ,PRSI "." CR>
		)
;		(<FSET? ,PRSI ,FL-ASLEEP>
			<TELL The+verb ,PRSI "are" "n't in any condition to appreciate" the ,PRSO "." CR>
		)
;		(<AND <NOT <MC-PRSI? CH-ME>>
				<RT-DONT-HAVE-MSG ,PRSO>
			>
			<RTRUE>
		)
	>
>

<ROUTINE V-SHOW ()
	<COND
		(<FSET? ,PRSI ,FL-ASLEEP>
			<TELL
The+verb ,PRSI "are" " in no condition to appreciate" the ,PRSO "." CR
			>
		)
		(<MC-PRSI? ,CH-PLAYER>
			<PERFORM ,V?EXAMINE ,PRSO>
		)
		(T
			<TELL
The+verb ,PRSI "do" "n't appear to be interested in" the ,PRSO "." CR
			>
		)
	>
	<RTRUE>
>

<ROUTINE V-SHOW-SWP ("AUX" TMP)
	<SET TMP ,PRSO-NP>
	<SETG PRSO-NP ,PRSI-NP>
	<SETG PRSI-NP .TMP>
	<PERFORM ,V?SHOW ,PRSI ,PRSO>
	<RTRUE>
>

<CONSTANT K-NO-RESTING-MSG "This is no time for resting.">

<ROUTINE V-SIT ()
	<COND
		(<OR  <MC-PRSO? ,TH-GROUND ,ROOMS>
				<FSET? ,PRSO ,FL-SURFACE>
			>
			<TELL ,K-NO-RESTING-MSG CR>
		)
		(T
			<RT-IMPOSSIBLE-MSG>
		)
	>
>

<ROUTINE V-SLEEP ()
	<COND
		(,GL-SLEEP
			<RT-DEQUEUE ,RT-I-SLEEP>
			<SETG GL-SLEEP 2>
			<RT-I-SLEEP>
		)
		(<RT-IS-QUEUED? ,RT-I-SOLDIER-4>
			<RT-DEQUEUE ,RT-I-SOLDIER-4>
			<RT-I-SOLDIER-4>
		)
		(T
			<TELL The+verb ,WINNER "are" "n't tired right now." CR>
		)
	>
>

<ROUTINE V-SPARE ()
	<TELL The+verb ,PRSO "are" "n't at your mercy." CR>
>

<ROUTINE V-STAND ()
	<COND
		(<EQUAL? ,GL-HIDING ,TH-GRAVESTONE>
			<SETG GL-HIDING <>>
			<TELL "You stand up." CR>
		)
		(T
			<TELL "You are already standing." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "T"
;"---------------------------------------------------------------------------"

<ROUTINE V-TALK-TO ()
	<COND
		(<FSET? ,PRSO ,FL-ALIVE>
			<TELL The+verb ,PRSO "do" "n't respond." CR>
		)
		(T
			<RT-YOU-CANT-MSG "talk to">
		)
	>
>

<ROUTINE PRE-TAKE ("AUX" L)
	<SET L <LOC ,PRSO>>
	<COND
		(<MC-PRSI? ,ROOMS>	; "TAKE obj OFF"
			<PERFORM ,V?UNWEAR ,PRSO>
			<RTRUE>
		)
		(<AND <MC-PRSO? ,TH-HEAD ,TH-LEGS>
				<MC-PRSI? <> ,ROOMS ,TH-SHELL>
			>
			; "For >TAKE OUT HEAD and >PULL LEGS OUT OF SHELL"
			<RFALSE>
		)
	;	(<MC-PRSO? ,TH-HANDS ,YOU>
			<RFALSE>
		)
	;	(<==? .L ,GLOBAL-OBJECTS>
			<NOT-HERE ,PRSO>
		)
		(<RT-META-IN? ,WINNER ,PRSO>
			<RT-ALREADY-MSG ,WINNER>
			<TELL in ,PRSO the ,PRSO ".">
			<COND
				(<G? ,P-MULT 1>
					<CRLF>
				)
				(T
					<RT-AUTHOR-OFF>
				)
			>
		)
		(<AND .L
				<OR
					<NOT <FSET? .L ,FL-SURFACE>>
				;	<NOT <FSET? ,PRSO ,FL-ON>>
				>
				<FSET? .L ,FL-OPENABLE>
				<NOT <FSET? .L ,FL-OPEN>>
			>
			<TELL
The ,WINNER " can't take" the ,PRSO " because" the+verb .L "are" " closed." CR
			>
			<RTRUE>
		)
		(<AND <NOT <FSET? ,PRSO ,FL-TAKEABLE>>
				<NOT <FSET? ,PRSO ,FL-TRY-TAKE>>
			>
			<RT-YOU-CANT-MSG "take">
		)
		(<IN? ,PRSO ,WINNER>
			<RT-ALREADY-MSG ,WINNER>
			<TELL " ">
			<COND
				(<FSET? ,PRSO ,FL-WORN>
					<TELL "wearing">
				)
				(T
					<TELL "holding">
				)
			>
			<TELL the ,PRSO ".">
			<COND
				(<G? ,P-MULT 1>
					<CRLF>
				)
				(T
					<RT-AUTHOR-OFF>
				)
			>
		)
		(<AND <EQUAL? ,WINNER ,CH-PLAYER>
				<NOT <MC-FORM? ,K-FORM-ARTHUR>>
			>
			<COND
				(<AND <MC-PRSO? ,TH-BRACELET>
						<IN? ,TH-BRACELET ,CH-KRAKEN>
					>
					<RFALSE>
				)
				(<MC-PRSO? ,CH-LEPRECHAUN>
					<RFALSE>
				)
				(<AND <MC-PRSO? ,PSEUDO-OBJECT>
						<MC-HERE? ,RM-RIVER-3>
					>
					<RFALSE>
				)
				(<MC-PRSO? ,TH-CHEESE ,TH-DEAD-MOUSE ,TH-WEEDS ,TH-MINNOW ,TH-MIDGES>
					<PERFORM ,V?EAT ,PRSO>
					<RTRUE>
				)
				(<AND <FSET? ,PRSO ,FL-WATER>
						<NOT <IN? ,PRSO ,ROOMS>>
					>
					<PERFORM ,V?DRINK ,PRSO>
					<RTRUE>
				)
				(T
					<RT-ANIMAL-CANT-MSG "take">
				)
			>
		)
		(,PRSI
			<COND
				(<OR	<AND
							<MC-PRSO? ,TH-CHAINS>
							<MC-PRSI? ,LG-WALL>
						>
						<AND
							<MC-PRSO? ,TH-PADLOCK>
							<MC-PRSI? ,TH-CHAINS>
						>
						<AND
							<MC-PRSO? ,TH-HORN>
							<MC-PRSI? ,TH-HORN-CHAIN ,TH-TREE>
						>
						<AND
							<MC-PRSO? ,TH-HORN-CHAIN>
							<MC-PRSI? ,TH-TREE>
						>
					>
					<RFALSE>
				)
				(<MC-PRSI? .L>
					<SETG PRSI <>>
					<RFALSE>
				)
				(<AND <OR
							<NOT <FSET? .L ,FL-SURFACE>>
						;	<NOT <FSET? ,PRSO ,FL-ON>>
						>
						<FSET? ,PRSI ,FL-OPENABLE>
						<NOT <FSET? ,PRSI ,FL-OPEN>>
					>
					<TELL
The ,WINNER "can't take" the ,PRSO " because" the+verb ,PRSI "are" " closed." CR
					>
					<RTRUE>
				)
				(<NOT <==? ,PRSI .L>>
					<COND
						(<FSET? ,PRSI ,FL-PERSON>
							<TELL The+verb ,PRSI "do" "n't have" the ,PRSO>
						)
						(T
							<TELL The+verb ,PRSO "are" "n't" in ,PRSI the ,PRSI>
						)
					>
					<TELL "." CR>
				)
			>
		)
	;	(T
			<PRE-TAKE-WITH>
		)
	>
>

<ROUTINE ITAKE ("OPTIONAL" (OB 0) (V? T) "AUX" CNT OBJ L SC)
	<COND
		(<ZERO? .OB>
			<SET OB ,PRSO>
		)
	>
	<SET L <LOC .OB>>
	<COND
		(<OR	<NOT <FSET? .OB ,FL-TAKEABLE>>
			;	<NOT <ACCESSIBLE? .OB>>
			>
			<COND
				(.V?
					<RT-YOU-CANT-MSG "take">
				)
			>
			<RFALSE>
		)
		(<RT-OBJ-TOO-LARGE? .OB ,WINNER>
			<COND
			;	(.FORCED?
					<TELL "As" the+verb ,WINNER "reach" " for" the .OB>
					<SET CNT 0>
					<REPEAT ((1ST? T))
						<COND
							(<NOT <RT-OBJ-TOO-LARGE? .OB ,WINNER>>
								<RETURN>
							)
							(<SET OBJ <FIND-FLAG-NOT ,WINNER ,FL-WORN>>
								<MOVE .OBJ ,HERE>
								<INC CNT>
								<SETG GL-UPDATE-WINDOW
									<BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT ,K-UPD-OBJS>
								>
								<TELL "," the .OBJ>
							)
						>
					>
					<COND
						(<EQUAL? .CNT 1>
							<TELL verb .OBJ "slip">
						)
						(T
							<TELL " slip">
						)
					>
					<TELL " to" the ,TH-GROUND "." CR>
					<RT-DO-TAKE .OB>
				)
				(T
					<COND
						(.V?
							<TELL The+verb ,WINNER "are" " holding too much." CR>
						)
					>
					<RFALSE>
				)
			>
		)
	;	(<AND <G? <SET CNT <CCOUNT ,WINNER>> ,FUMBLE-NUMBER>
				<PROB <* .CNT ,FUMBLE-PROB>>
				<SET OBJ <FIND-FLAG-NOT ,WINNER ,FL-WORN>>
			>
			<TELL
The .OBJ " slips from" his ,WINNER " arms while" he+verb ,WINNER "are"
" taking" the .OB ", and both tumble to" the ,TH-GROUND ". "
The+verb ,WINNER "are" " carrying too many things." CR
			>
			<MOVE .OBJ ,HERE>
			<MOVE .OB ,HERE>
			<SETG GL-UPDATE-WINDOW
				<BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT ,K-UPD-OBJS>
			>
			<RFATAL>
		)
		(T
			<COND
				(<AND <NOT <VERB? TAKE>>
						<NOT <EQUAL? .L ,WINNER>>
					>
					<RT-FIRST-YOU-MSG "take" .OB .L>
				)
			>
			<RT-DO-TAKE .OB>
		)
	>
>

<ROUTINE RT-DO-TAKE (OBJ "OPT" (FORCED? <>) "AUX" L)
	<SET L <LOC .OBJ>>
	<COND
		(<AND .L
				<OR
					<IN? .OBJ ,HERE>
					<FSET? .L ,FL-SURFACE>
					<FSET? .L ,FL-TRANSPARENT>
				>
				<RT-META-IN? .OBJ ,HERE>
			>
			<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-OBJS>>
		)
	>
	<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT>>
	<MOVE .OBJ ,WINNER>
	<FSET .OBJ ,FL-SEEN>
	<FSET .OBJ ,FL-TOUCHED>
	<FCLEAR .OBJ ,FL-NO-DESC>
	<FCLEAR .OBJ ,FL-NO-LIST>
	<FCLEAR .OBJ ,FL-INVISIBLE>
	<FCLEAR .OBJ ,FL-WORN>
;	<COND
		(<AND .SC?
				<EQUAL? ,WINNER ,CH-PLAYER>
			>
			<RT-SCORE-OBJ .OBJ>
		)
	>
	<RTRUE>
>

<ROUTINE V-TAKE ("AUX" L V (NL? T))
	<SET L <LOC ,PRSO>>
	<SET V <ITAKE>>
	<COND
		(<EQUAL? .V ,M-FATAL>
			<SETG CLOCK-WAIT T>
			<RFATAL>
		)
		(.V
			<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT>>
			<COND
				(<G? ,P-MULT 1>
					<TELL "Taken.">
				)
				(T
					<TELL The+verb ,WINNER "take" the ,PRSO>
					<COND
						(<AND <NOT <IN? .L ,ROOMS>>
								<NOT <EQUAL? .L ,GLOBAL-OBJECTS ,LOCAL-GLOBALS>>
							>
							<TELL " from">
							<COND
								(<AND <EQUAL? .L ,CH-PLAYER>
										<NOT <EQUAL? ,WINNER ,CH-PLAYER>>
									>
									<TELL " you">
								)
								(T
									<TELL the .L>
								)
							>
						)
					>
					<TELL ".">
				)
			>
			<COND
				(<OR	<FSET? .L ,FL-WATER>
						<AND
							<EQUAL? .L ,TH-BARREL>
							<IN? ,TH-BARREL-WATER ,TH-BARREL>
						>
					>
					<TELL " " He+verb ,PRSO "dry" " quickly.">
				)
			>
			<COND
				(<AND <MC-PRSO? ,TH-CRUTCH>
						<IN? ,TH-CRUTCH ,RM-COTTAGE>
						<FSET? ,TH-CRUTCH ,FL-BROKEN>
					>
					<FCLEAR ,TH-CRUTCH ,FL-BROKEN>
					<RT-SCORE-MSG -10 0 0 0>
				)
				(T
					<COND
						(<G? ,P-MULT 1>
							<TELL " ">
							<SET NL? <>>
						)
						(T
							<CRLF>
						)
					>
					<RT-SCORE-OBJ ,PRSO .NL?>
					<COND
						(<G? ,P-MULT 1>
							<CRLF>
						)
					>
				)
			>
		)
	>
>

<ROUTINE PRE-TAKE-WITH ("AUX" X L)
	<COND
	;	(<MC-PRSO? ,YOU>
			<RFALSE>
		)
		(<AND <EQUAL? ,WINNER ,CH-PLAYER>
				<MC-PRSI? ,TH-HANDS ,TH-MOUTH>
				<MC-VERB? TAKE-WITH>
			>
			<COND
				(<MC-FORM? ,K-FORM-ARTHUR>
					<COND
						(<MC-PRSI? ,TH-HANDS>
							<PERFORM ,V?TAKE ,PRSO>
						)
						(T
							<PERFORM ,V?EAT ,PRSO>
						)
					>
					<RTRUE>
				)
				(<AND <MC-PRSI? ,TH-MOUTH>
						<FSET? ,PRSO ,FL-FOOD>
					>
					<PERFORM ,V?EAT ,PRSO>
					<RTRUE>
				)
				(T
					<RT-TAKE-WITH-MSG ,PRSO ,PRSI>
				)
			>
		)
	;	(<AND <EQUAL? ,WINNER ,CH-PLAYER>
				<NOT <MC-FORM? ,K-FORM-ARTHUR>>
			>
			<RT-ANIMAL-CANT-MSG "take">
		)
	;	(<EQUAL? <META-LOC ,PRSO> ,GLOBAL-OBJECTS>
			<COND
				(<AND <NOT <HELD? ,PRSO>>
						<NOT <FSET? ,PRSO ,FL-PERSON>>
					>
					<NOT-HERE ,PRSO>
				)
			>
		)
		(<IN? ,PRSO ,WINNER>
			<RT-ALREADY-MSG ,WINNER>
			<TELL " ">
			<COND
				(<FSET? ,PRSO ,FL-WORN>
					<TELL "wearing">
				)
				(T
					<TELL "holding">
				)
			>
			<TELL the ,PRSO ".">
			<COND
				(<G? ,P-MULT 1>
					<CRLF>
				)
				(T
					<RT-AUTHOR-OFF>
				)
			>
		)
		(<AND <FSET? <LOC ,PRSO> ,FL-CONTAINER>
				<OR
					<NOT <FSET? <LOC ,PRSO> ,FL-SURFACE>>
				;	<NOT <FSET? ,PRSO ,FL-ON>>
				>
				<NOT <FSET? <LOC ,PRSO> ,FL-OPEN>>
			>
			<RT-YOU-CANT-MSG "reach">
		)
		(<IN? ,WINNER ,PRSO>
			<RT-ALREADY-MSG ,WINNER>
			<TELL in ,PRSO the ,PRSO ".">
			<COND
				(<G? ,P-MULT 1>
					<CRLF>
				)
				(T
					<RT-AUTHOR-OFF>
				)
			>
		)
	>
>

<ROUTINE V-TAKE-WITH ()
	<TELL The ,WINNER " can't take anything with" the ,PRSI "." CR>
>

<ROUTINE V-TELL ()
	<COND
		(<MC-PRSO? ,CH-PLAYER>
			<COND
				(,QCONTEXT
					<SETG QCONTEXT <>>
					<COND
						(,P-CONT
							<SETG WINNER ,CH-PLAYER>
						)
						(T
							<TELL
"Okay, you're not talking to anyone else." CR
							>
						)
					>
				)
				(T
					<WONT-HELP-TO-TALK-TO ,CH-PLAYER>
				;	<SETG QUOTE-FLAG <>>
					<SETG P-CONT <>>
					<SETG CLOCK-WAIT T>
					<RFATAL>
				)
			>
		)
		(<FSET? ,PRSO ,FL-ALIVE>
			<SETG QCONTEXT ,PRSO>
			<COND
				(,P-CONT
					<SETG CLOCK-WAIT T>
					<SETG WINNER ,PRSO>
					<RFALSE>
				)
				(T
					<TELL
The+verb ,PRSO "look" " at you expectantly, as if you seemed to be about to
talk." CR
					>
				)
			>
		)
		(T
			<WONT-HELP-TO-TALK-TO ,PRSO>
		;	<SETG QUOTE-FLAG <>>
			<SETG P-CONT <>>
			<SETG CLOCK-WAIT T>
			<RFATAL>
		)
	>
>

<ROUTINE WONT-HELP-TO-TALK-TO (OBJ)
	<TELL "Talking to">
	<COND
		(<EQUAL? .OBJ ,CH-PLAYER>
			<TELL D .OBJ>
		)
		(T
			<TELL the .OBJ>
		)
	>
	<TELL " would be of no use." CR>
>

<ROUTINE V-TELL-ABOUT ("AUX" PERSON)
	<COND
		(<MC-PRSO? ,CH-PLAYER>
			<COND
				(<EQUAL? ,WINNER ,CH-PLAYER>
					<COND
						(<SET PERSON <FIND-A-WINNER>>
							<SETG PRSO-NP <>>
							<PERFORM ,V?ASK-ABOUT .PERSON ,PRSI>
						)
						(T
							<RT-AUTHOR-MSG ,K-TALK-TO-SELF-MSG>
						)
					>
				)
				(T
					<SET PERSON ,WINNER>
					<SETG WINNER ,CH-PLAYER>
					<SETG PRSO-NP <>>
					<PERFORM ,V?ASK-ABOUT .PERSON ,PRSI>
				)
			>
			<RTRUE>
		)
		(<NOT <FSET? ,PRSO ,FL-ALIVE>>
			<TELL The ,WINNER "can't tell anything to" the ,PRSO "." CR>
		)
		(<FSET? ,PRSO ,FL-ASLEEP>
			<TELL
"Talking to" the ,PRSO " in" his ,PRSO " current condition would be a waste
of time." CR
			>
		)
		(T
			<TELL The+verb ,PRSO "shrug" " indifferently." CR>
		)
	>
>

<ROUTINE V-THANK ()
	<COND
;		(<NOT <RT-ANYONE-HERE?>>
			<TELL "[There's nobody here to thank.]" CR>
		)
		(<EQUAL? ,WINNER ,CH-PLAYER>
			<COND
				(<MC-PRSO? ,CH-PLAYER>
					<TELL "Patting yourself on the back won't help." CR>
				)
				(<FSET? ,PRSO ,FL-ASLEEP>
					<TELL
The+verb ,PRSO "are" "n't in any condition to accept your thanks." CR
					>
				)
				(<FSET? ,PRSO ,FL-ALIVE>
					<TELL "\"You're welcome.\"" CR>
				)
				(T
					<RT-NO-RESPONSE-MSG ,PRSO>
				)
			>
		)
		(T
			<RT-FOOLISH-TO-TALK?>
			<RTRUE>
		)
	>
>


<ROUTINE V-THROW ()
	<COND
		(<IN? ,PRSO ,GLOBAL-OBJECTS>
			<RT-IMPOSSIBLE-MSG>
		)
		(<IDROP>
			<SETG GL-UPDATE-WINDOW
				<BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT ,K-UPD-OBJS>
			>
			<COND
				(<MC-PRSI? ,TH-GROUND>
					<TELL The+verb ,WINNER "drop" the ,PRSO "." CR>
				)
				(T
					<COND
						(<MC-PRSI? <> ,ROOMS ,INTDIR>
							<TELL
The+verb ,WINNER "toss" the ,PRSO " into the air. " He+verb ,PRSO "land"
							>
						)
						(T
							<TELL
The+verb ,PRSO "miss" the ,PRSI " and" verb ,PRSO "land"
							>
						)
					>
					<COND
						(<FSET? ,HERE ,FL-WATER>
							<TELL " in the water. Plop." CR>
						)
						(T
							<TELL " on" the ,TH-GROUND " nearby." CR>
						)
					>
				)
			>
		)
	>
>

<ROUTINE V-THROW-SWP ("AUX" TMP)
	<COND
		(<MC-PRSI? <> ,ROOMS ,INTDIR>
			<PERFORM ,V?THROW ,PRSO ,PRSI>
		)
		(T
			<SET TMP ,PRSO-NP>
			<SETG PRSO-NP ,PRSI-NP>
			<SETG PRSI-NP .TMP>
			<PERFORM ,V?THROW ,PRSI ,PRSO>
		)
	>
	<RTRUE>
>

<ROUTINE V-THROW-OVER ()
	<COND
		(<EQUAL? ,PRSO ,PRSI>
			<RT-IMPOSSIBLE-MSG>
		)
		(<IDROP>
			<SETG GL-UPDATE-WINDOW
				<BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT ,K-UPD-OBJS>
			>
			<TELL
The+verb ,PRSO "sail" " into air, hits" the ,PRSI " and lands on" the ,TH-GROUND " nearby." CR
			>
		)
	>
>

<ROUTINE V-TIME ("AUX" N)
	<SET N <MOD ,GL-MOVES 180>>
	<COND
		(<L? .N 15>
			<TELL "The bells of ">
			<RT-HOUR-NAME-MSG ,GL-MOVES>
			<TELL " just rang">
			<COND
				(<G? .N 0>
					<TELL " a few minutes ago">
				)
			>
			<TELL "." CR>
		)
		(T
			<TELL "It seems like it has been ">
			<COND
				(<L? .N 67>
					<TELL "about a quarter of">
				)
				(<L? .N 112>
					<TELL "about half">
				)
				(<L? .N 157>
					<TELL "about three quarters of">
				)
				(T
					<TELL "nearly">
				)
			>
			<TELL " a canonical hour since the bells last rang." CR>
		)
	>
>

<ROUTINE V-TIP ()
	<COND
		(<FSET? ,PRSO ,FL-PERSON>
			<TELL
The+verb ,WINNER "whisper" " confidentially, \"Buy low, sell high.\"" CR 
			>
			<RT-AUTHOR-ON>
			<TELL He+verb ,PRSO "do" "n't look impressed.">
			<RT-AUTHOR-OFF>
		)
		(T
			<RT-YOU-CANT-MSG "tip over">
		)
	>
>

<ROUTINE V-TOUCH ()
	<TELL The+verb ,WINNER "touch" the ,PRSO>
	<COND
		(<NOT <MC-PRSI? ,ROOMS <>>>
			<TELL " with" the ,PRSI>
		)
	>
	<TELL ", but nothing happens." CR>
>

<ROUTINE V-TRADE-FOR ()
	<COND
		(<MC-PRSO? ,PRSI>
			<TELL The ,WINNER " can't trade" the ,PRSO " for" him ,PRSO "self." CR>
		)
		(<AND <FSET? ,PRSO ,FL-PERSON>
				<EQUAL? ,PRSO ,WINNER>
			>
			<TELL The ,WINNER " can't trade with">
			<COND
				(<EQUAL? ,WINNER ,CH-PLAYER>
					<TELL " your">
				)
				(T
					<TELL him ,WINNER>
				)
			>
			<TELL "self." CR>
		)
		(<OR	<FSET? ,PRSO ,FL-PERSON>
				<MC-PRSI? ,ROOMS>
			>
			<SETG CLOCK-WAIT T>
			<COND
				(<MC-PRSI? ,ROOMS>
					<SETUP-ORPHAN "give " ,PRSO>
				)
				(T
					<SETUP-ORPHAN "trade " ,PRSI " for">
				)
			>
			<TELL "[What do you want give" the ,PRSO>
			<COND
				(<NOT <MC-PRSI? ,ROOMS>>
					<TELL " in exchange for" the ,PRSI>
				)
			>
			<TELL "?]" CR>
		)
		(T
			<TELL
The+verb ,WINNER "do" "n't want to trade" the ,PRSO " for" the ,PRSI "." CR
			>
		)
	>
>

<ROUTINE V-TRADE-WITH ()
	<COND
		(<NOT <FSET? ,PRSI ,FL-PERSON>>
			<TELL The ,WINNER " can't trade with" a ,PRSI "." CR>
		)
		(<FSET? ,PRSI ,FL-ASLEEP>
			<TELL The+verb ,PRSI "are" " in no condition to trade anything." CR>
		)
		(T
			<TELL The+verb ,PRSI "do" "n't want to trade." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "U"
;"---------------------------------------------------------------------------"

<ROUTINE V-UNDRESS ()
	<COND
		(<MC-PRSO? ,ROOMS>
			<TELL ,K-UNDRESS-MSG>
		)
		(<FSET? ,PRSO ,FL-PERSON>
			<TELL The ,PRSO " might resent that." CR>
		)
		(<FSET? ,PRSO ,FL-ALIVE>
			<TELL The+verb ,PRSO "are" "'nt wearing anything." CR>
		)
		(T
			<RT-YOU-CANT-MSG "undress">
		)
	>
	<RTRUE>
>

<ROUTINE V-UNLOCK ()
	<COND
		(<AND <EQUAL? ,WINNER ,CH-PLAYER>
				<NOT <MC-FORM? ,K-FORM-ARTHUR>>
			>
			<RT-ANIMAL-CANT-MSG>
		)
		(<EQUAL? ,P-PRSA-WORD ,W?UNBAR>
			<TELL The+verb ,PRSO "are" "n't barred." CR>
		)
		(<NOT <FSET? ,PRSO ,FL-OPENABLE>>
			<RT-YOU-CANT-MSG>
		)
		(<FSET? ,PRSO ,FL-OPEN>
			<RT-ALREADY-MSG ,PRSO "open">
		)
		(<NOT <FSET? ,PRSO ,FL-LOCKED>>
			<RT-ALREADY-MSG ,PRSO "unlocked">
		)
		(<NOT <RT-MATCH-KEY ,PRSO ,PRSI>>
			<TELL The ,WINNER " can't unlock" the ,PRSO " with" the ,PRSI "." CR>
		)
		(T
			<RT-OPEN-DOOR-MSG ,PRSO ,PRSI>
		)
	>
>

<ROUTINE V-UNTIE ()
	<TELL The ,WINNER " can't untie" a ,PRSO "." CR>
>

<ROUTINE V-UNWEAR ()
	<COND
		(<AND <VERB-WORD? ,W?TAKE>
				<MC-PRSO? ,ROOMS>
			>
			<RT-DO-WALK ,P?UP>		; ">TAKE OFF"
		)
		(<IN? ,PRSO ,WINNER>
			<COND
				(<NOT <FSET? ,PRSO ,FL-WORN>>
					<TELL The+verb ,WINNER "are" "n't wearing" the ,PRSO "." CR>
				)
				(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
					<RT-AUTHOR-MSG ,K-HOW-INTEND-MSG>
					<SETG CLOCK-WAIT T>
					<RFATAL>
				)
				(T
					<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT>>
					<FCLEAR ,PRSO ,FL-WORN>
					<TELL The+verb ,WINNER "take" " off" the ,PRSO "." CR>
				)
			>
		)
		(T
			<PERFORM ,V?TAKE ,PRSO>
			<RTRUE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "W"
;"---------------------------------------------------------------------------"

<ROUTINE V-WAIT ("AUX" (N -1) (ABS? <>))
	<COND
		(<NOT ,PRSO>
			<SET N 10>
		)
		(<MC-PRSO? ,INTNUM>
			<COND
				(<G? ,P-NUMBER 0>
					<SET N ,P-NUMBER>
				)
			>
		)
		(<MC-PRSO? ,TH-TIME>
			<COND
				(<OR	<NOUN-USED? ,PRSO ,W?CHRISTMAS ,W?XMAS>
						<AND
							<NOUN-USED? ,PRSO ,W?MORNING>
							<ADJ-USED? ,PRSO ,W?CHRISTMAS ,W?XMAS>
						>
					>
					<SET ABS? T>
					<SET N <- 4680 ,GL-MOVES>>
				)
				(<AND <NOUN-USED? ,PRSO ,W?EVE>
						<ADJ-USED? ,PRSO ,W?CHRISTMAS ,W?XMAS>
					>
					<SET ABS? T>
					<SET N <- 3240 ,GL-MOVES>>
				)
				(<NOUN-USED? ,PRSO ,W?TOMORROW ,W?MORNING>
					<SET N <- 1800 <MOD ,GL-MOVES 1440>>>
				)
				(<OR	<NOUN-USED? ,PRSO ,W?MATINS ,W?LAUD ,W?PRIME>
						<NOUN-USED? ,PRSO ,W?TIERCE ,W?SEXT ,W?NONE>
						<NOUN-USED? ,PRSO ,W?VESPERS ,W?COMPLINE ,W?HOUR>
						<NOUN-USED? ,PRSO ,W?HOURS>
					>
					<COND
						(<NOUN-USED? ,PRSO ,W?MATINS>
							<SET N <- 1440 <MOD ,GL-MOVES 1440>>>
						)
						(<NOUN-USED? ,PRSO ,W?LAUD>
							<SET N <- 180 <MOD ,GL-MOVES 1440>>>
						)
						(<NOUN-USED? ,PRSO ,W?PRIME>
							<SET N <- 360 <MOD ,GL-MOVES 1440>>>
						)
						(<NOUN-USED? ,PRSO ,W?TIERCE>
							<SET N <- 540 <MOD ,GL-MOVES 1440>>>
						)
						(<NOUN-USED? ,PRSO ,W?SEXT>
							<SET N <- 720 <MOD ,GL-MOVES 1440>>>
						)
						(<NOUN-USED? ,PRSO ,W?NONE>
							<SET N <- 900 <MOD ,GL-MOVES 1440>>>
						)
						(<NOUN-USED? ,PRSO ,W?VESPERS>
							<SET N <- 1080 <MOD ,GL-MOVES 1440>>>
						)
						(<NOUN-USED? ,PRSO ,W?COMPLINE>
							<SET N <- 1260 <MOD ,GL-MOVES 1440>>>
						)
						(<NOUN-USED? ,PRSO ,W?HOUR>
							<SET N <- 180 <MOD ,GL-MOVES 180>>>
							<COND
								(<AND <ADJ-USED? ,PRSO ,W?INT.NUM>
										<G? ,P-NUMBER 1>
									>
									<SET N <+ .N <* 180 <- ,P-NUMBER 1>>>>
								)
							>
						)
					>
					<REPEAT ()
						<COND
							(<L? .N 0>
								<SET N <+ .N 1440>>
							)
							(T
								<RETURN>
							)
						>
					>
				)
				(<OR	<NOUN-USED? ,PRSO ,W?TURN ,W?TURNS>
						<NOUN-USED? ,PRSO ,W?MIN ,W?MINUTE ,W?MINUTES>
					>
					<COND
						(<AND <ADJ-USED? ,PRSO ,W?INT.NUM>
								<G? ,P-NUMBER 0>
							>
							<SET N ,P-NUMBER>
						)
						(T
							<SET N 1>
						)
					>
				)
			>
		)
		(<MC-PRSO? ,TH-BELLS>
			<SET N <- 180 <MOD ,GL-MOVES 180>>>
		)
	;	(T
			<TELL "You can't wait for that." CR>
			<SETG CLOCK-WAIT T>
			<RFATAL>
		)
	>
	<COND
		(<G? .N 0>
			<SETG GL-MOVES <+ ,GL-MOVES <- .N 1>>>
			<TELL ,K-TIME-PASSES-MSG CR>
		)
		(.ABS?
			<RT-AUTHOR-MSG "That time has already passed.">
			<SETG CLOCK-WAIT T>
			<RFATAL>
		)
		(T
			<RT-AUTHOR-MSG "You can't wait for that.">
			<SETG CLOCK-WAIT T>
			<RFATAL>
		)
	>
>

<ROUTINE V-WAKE ()
	<COND
	;	(<RT-FOOLISH-TO-TALK?>
			<SETG CLOCK-WAIT T>
			<RFATAL>
		)
		(<MC-PRSO? ,ROOMS>
         <RT-ALREADY-MSG ,WINNER "wide awake">
		)
		(<FSET? ,PRSO ,FL-ALIVE>
			<COND
				(<FSET? ,PRSO ,FL-ASLEEP>
					<TELL
The+verb ,PRSO "do" "n't respond to your attempts to wake" him ,PRSO "." CR
               >
				)
				(T
               <RT-ALREADY-MSG ,PRSO "wide awake">
				)
			>
		)
		(T
			<TELL The+verb ,PRSO "are" "n't asleep." CR>
			<SETG CLOCK-WAIT T>
			<RFATAL>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RT-FIND-DIR"
;"---------------------------------------------------------------------------"

<ROUTINE RT-FIND-DIR (RM "AUX" (P 0) OD L)
	<SET OD ,P-WALK-DIR>
	<SET L <LOC ,WINNER>>
	<REPEAT (OBJ PT PTS)
		<COND
			(<OR	<ZERO? <SET P <NEXTP .L .P>>>
					<L? .P ,LOW-DIRECTION>
				>
				<RFALSE>
			)
		>
		<SETG P-WALK-DIR .P>
		<COND
			(<SET PT <GETPT .L .P>>
				<SET PTS <PTSIZE .PT>>
				<COND
					(<EQUAL? .PTS ,UEXIT>
						<COND
							(<EQUAL? .RM <GET/B .PT ,REXIT>>
								<RETURN>
							)
						>
					)
					(<EQUAL? .PTS ,FEXIT>
						<COND
							(<EQUAL? .RM <APPLY <GET .PT ,FEXITFCN> T>>
								<RETURN>
							)
						>
					)
					(<EQUAL? .PTS ,CEXIT>
						<COND
							(<EQUAL? .RM <GET/B .PT ,REXIT>>
								<RETURN>
							)
						>
					)
					(<EQUAL? .PTS ,DEXIT>
						<COND
							(<EQUAL? .RM <GET/B .PT ,REXIT>>
								<COND
									(<SET OBJ <GET/B .PT ,DEXITOBJ>>
										<RETURN>
									)
								>
							)
						>
					)
				>
			)
		>
	>
	<SETG P-WALK-DIR .OD>
	<RETURN .P>
>

<ROUTINE RT-FIND-ROOM (DIR "OPT" (L <LOC ,WINNER>) "AUX" OD PT PTS RM)
	<COND
		(<SET PT <GETPT .L .DIR>>
			<SET PTS <PTSIZE .PT>>
			<COND
				(<EQUAL? .PTS ,UEXIT ,CEXIT ,DEXIT>
					<RETURN <GET/B .PT ,REXIT>>
				)
				(<EQUAL? .PTS ,FEXIT>
					<SET OD ,P-WALK-DIR>
					<SET RM <APPLY <GET .PT ,FEXITFCN> T>>
					<SETG P-WALK-DIR .OD>
					<RETURN .RM>
				)
			>
		)
	>
>

<GLOBAL GL-PUPPY:OBJECT <>>

<ROUTINE RT-SET-PUPPY (OBJ)
	<COND
		(,GL-PUPPY
			<FCLEAR ,GL-PUPPY ,FL-NO-DESC>
		)
	>
	<SETG GL-PUPPY .OBJ>
	<FSET ,GL-PUPPY ,FL-NO-DESC>
>

<ROUTINE RT-CLEAR-PUPPY ()
	<COND
		(,GL-PUPPY
			<FCLEAR ,GL-PUPPY ,FL-NO-DESC>
			<SETG GL-PUPPY <>>
		)
	>
	<RTRUE>
>

<ROUTINE PRE-WALK ()
	<COND
		(<IN? ,WINNER ,TH-BARREL>
			<TELL
The ,WINNER " would have to get out of" the ,TH-BARREL " first." CR
			>
		)
		(<VERB-WORD? ,W?FLY>
			<COND
				(<NOT <MC-FORM? ,K-FORM-OWL>>
					<COND
						(<MC-FORM? ,K-FORM-ARTHUR>
							<TELL "You don't have any wings." CR>
						)
						(T
							<TELL Aform " can't fly." CR>
						)
					>
				)
			>
		)
		(<VERB-WORD? ,W?SWIM>
			<COND
				(<NOT <MC-FORM? ,K-FORM-EEL ,K-FORM-TURTLE>>
					<COND
						(<MC-FORM? ,K-FORM-ARTHUR>
							<TELL "You">
						)
						(T
							<TELL Aform>
						)
					>
					<TELL " can't swim." CR>
				)
				(<AND <NOT <FSET? ,HERE ,FL-WATER>>
						<OR
							<NOT <IN? ,WINNER ,TH-BARREL>>
							<NOT <IN? ,TH-BARREL-WATER ,TH-BARREL>>
						>
					>
					<TELL "You're not in the water." CR>
				)
			>
		)
		(<MC-FORM? ,K-FORM-TURTLE>
			<COND
				(<AND <MC-HERE? ,RM-FIELD-OF-HONOUR>
						<EQUAL? ,P-WALK-DIR ,P?SOUTH>
					>
					<RFALSE>
				)
				(<AND <MC-HERE? ,RM-WEST-OF-FORD>
						<EQUAL? ,P-WALK-DIR ,P?EAST>
					>
					<RFALSE>
				)
				(<AND <NOT <FSET? ,HERE ,FL-WATER>>
						<EQUAL? ,P-WALK-DIR ,P?IN ,P?OUT>
						<NOT <GETPT <LOC ,WINNER> ,P-WALK-DIR>>
					>
					<RFALSE>
				)
				(<AND <NOT <FSET? ,HERE ,FL-WATER>>
						,P-WALK-DIR
						<NOT <EQUAL? ,P-WALK-DIR ,P?UP ,P?DOWN>>
					>
					<TELL
"You plod off in that " D ,INTDIR " for some time. After a while you"
					>
					<COND
						(<FSET? ,TH-HEAD ,FL-LOCKED>
							<TELL " poke your head out briefly and">
						)
					>
					<TELL
" look up, only to discover that you have made very little progress." CR
					>
				)
			>
		)
	>
>

<ROUTINE V-WALK ("AUX" PT PTS STR RM V)
	<COND
		(<MC-PRSO? <> ,ROOMS>
			<COND
				(<VERB-WORD? ,W?FLY>
					<RT-DO-WALK ,P?UP>
					<RTRUE>
				)
				(<SET V <PRE-WALK>>
					<RETURN .V>
				)
				(T
					<TELL "[What direction do you want to " vw "?]" CR>
					<SETG CLOCK-WAIT T>
					<RFATAL>
				)
			>
		)
	>
	<COND
		(<ZERO? ,P-WALK-DIR>
			<V-WALK-AROUND>
			<SETG CLOCK-WAIT T>
			<RFATAL>
		)
		(<SET V <PRE-WALK>>
			<RETURN .V>
		)
	>
	<COND
		(<SET PT <GETPT <LOC ,WINNER> ,PRSO>>
			<COND
				(<==? <SET PTS <PTSIZE .PT>> ,UEXIT>
					<RT-GOTO <GET/B .PT ,REXIT>>
					<RTRUE>
				)
				(<==? .PTS ,NEXIT>
					<TELL <GET .PT ,NEXITSTR> CR>
					<SETG CLOCK-WAIT T>
					<RFATAL>
				)
				(<==? .PTS ,FEXIT>
					<SET RM <APPLY <GET .PT ,FEXITFCN>>>
					<COND
						(<EQUAL? .RM ,ROOMS>
							<SETG CLOCK-WAIT T>
							<RFATAL>
						)
						(T
							<COND
								(.RM
									<RT-GOTO .RM>
								)
							>
							<RTRUE>
						)
					>
				)
				(<==? .PTS ,CEXIT>
					<COND
						(<VALUE <GETB .PT ,CEXITFLAG>>
							<RT-GOTO <GET/B .PT ,REXIT>>
							<RTRUE>
						)
						(<SET STR <GET .PT ,CEXITSTR>>
							<TELL .STR CR>
							<SETG CLOCK-WAIT T>
							<RFATAL>
						)
						(T
							<RT-YOU-CANT-MSG "go">
							<SETG CLOCK-WAIT T>
							<RFATAL>
						)
					>
				)
				(<==? .PTS ,DEXIT>
					<COND
						(<WALK-THRU-DOOR? .PT>
							<RT-GOTO <GET/B .PT ,REXIT>>
							<RTRUE>
						)
						(T
							<SETG CLOCK-WAIT T>
							<RFATAL>
						)
					>
				)
			>
		)
		(<MC-PRSO? ,P?IN ,P?OUT>
			<V-WALK-AROUND>
		)
		(<AND <FSET? ,HERE ,FL-WATER>
				<MC-FORM? ,K-FORM-EEL ,K-FORM-TURTLE>
			>
			<COND
				(<MC-PRSO? ,P?UP ,P?DOWN>
					<COND
						(<MC-PRSO? ,P?UP>
							<TELL The+verb ,WINNER "ascend">
						)
						(T
							<TELL The+verb ,WINNER "descend">
						)
					>
					<TELL
" for a quick look around, but see nothing interesting." CR
					>
				)
				(T
					<TELL
"The reeds in that " D ,INTDIR " are too thick to swim through." CR
					>
				)
			>
			<RFATAL>
		)
		(<FSET? ,HERE ,FL-AIR>
			<TELL
"Suddenly, a tricky breeze springs up that prevents you from flying in that
direction." CR
			>
			<SETG GL-QUESTION 1>
			<RT-AUTHOR-MSG
"Pretty convenient for the game writer, wouldn't you say?"
			>
		)
		(T
			<RT-YOU-CANT-MSG "go">
			<SETG CLOCK-WAIT T>
			<RFATAL>
		)
	>
>

<ROUTINE WALK-THRU-DOOR? (PT "OPTIONAL" (OBJ 0) (TELL? T) "AUX" RM)
	<COND
		(<ZERO? .OBJ>
			<SET OBJ <GET/B .PT ,DEXITOBJ>>
		)
	>
	<COND
		(<FSET? .OBJ ,FL-OPEN>
			<RTRUE>
		)
		(<AND .PT
				<SET RM <GET .PT ,DEXITSTR>>
			>
			<COND
				(.TELL?
					<TELL .RM CR>
				)
			>
			<RFALSE>
		)
		(T
			<THIS-IS-IT .OBJ>
			<TELL The+verb .OBJ "are" "n't open." CR>
			<RFALSE>
		)
	>
>

<ROUTINE RT-GOTO (RM "OPT" (FORCED? <>))
	<COND
		(<IN? ,WINNER .RM>
			<RT-WALK-WITHIN-ROOM-MSG>
			<RFALSE>
		)
		(<AND <RT-IS-QUEUED? ,RT-I-KRAKEN-FOLLOW>
				<EQUAL? .RM ,GL-OLD-KRAKEN-LOC>
			>
			<TELL
"You turn around and try to slip past the kraken, but he grabs you as you go
by. He wraps his bone-crushing tentacles around you and then slowly,
inexorably, squeezes the life out of you.|"
			>
			<RT-END-OF-GAME>
		)
	>
	<COND
		(<APPLY <GETP ,HERE ,P?ACTION> ,M-EXIT>
			<RFALSE>
		)
	>
	<COND
		(<AND <NOT .FORCED?>
				<MC-FORM? ,K-FORM-OWL>
			>
			<COND
				(<AND <FSET? ,HERE ,FL-AIR>
						<FSET? .RM ,FL-AIR>
					>
				;	<TELL "You flap your wings briefly.||">
				)
				(<FSET? ,HERE ,FL-AIR>
					<TELL "You swoop down and land.||">
				)
				(<FSET? .RM ,FL-AIR>
					<TELL "You launch yourself into the air.||">
				)
				(T
					<TELL "You flap your wings briefly....||">
				)
			>
		)
	>
	<MOVE ,WINNER .RM>
	<SETG GL-HIDING <>>
	<COND
		(<FSET? ,HERE ,FL-AIR>
			<SETG GL-TAKEOFF-ROOM <>>
		)
	>
	<COND
		(<==? ,WINNER ,CH-PLAYER>
			<COND
				(,GL-PUPPY
					<MOVE ,GL-PUPPY .RM>
				)
			>
			<SETG OHERE ,HERE>
			<SETG HERE .RM>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-MAP>
					<RT-UPDATE-MAP-WINDOW>
				)
			>
			<RT-ENTER-ROOM>
		)
	>
	<COND
		(,GL-PUPPY
			<TELL CR The+verb ,GL-PUPPY "follow" " you." CR>
		)
	>
	<RTRUE>
>

<ROUTINE RT-ENTER-ROOM ("AUX" VAL CNT TBL)
	<SETG LIT <LIT?>>
	<DIROUT ,D-TABLE-ON ,K-DIROUT-TBL>
	<RT-ROOM-NAME-MSG>
	<DIROUT ,D-TABLE-OFF>
	<SET TBL <ZREST ,K-DIROUT-TBL 2>>
	<SET CNT <ZGET ,K-DIROUT-TBL 0>>
	<REPEAT ((I 0) C)
		<COND
			(<G=? .I .CNT>
				<RETURN>
			)
			(<AND <G=? <SET C <GETB .TBL .I>> !\a>
					<L=? .C !\z>
				>
				<PUTB .TBL .I <- .C 32>>
			)
		>
		<INC I>
	>
	<HLIGHT ,H-BOLD>
	<PRINTT .TBL .CNT>
	<HLIGHT ,H-NORMAL>
	<CRLF>
	<COND
		(<OR	<EQUAL? ,VERBOSITY 2>
				<AND
					<EQUAL? ,VERBOSITY 1>
					<NOT <FSET? ,HERE ,FL-TOUCHED>>
				>
			>
			<CRLF>
		)
	>
	<APPLY <GETP ,HERE ,P?ACTION> ,M-ENTER>
	<SET VAL <V-FIRST-LOOK>>
	<APPLY <GETP ,HERE ,P?ACTION> ,M-ENTERED>
	<RT-SCORE-OBJ ,HERE>
	<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-DESC>>
	<COND
		(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
			<RT-UPDATE-DESC-WINDOW>
		)
	>
	.VAL
>

<ROUTINE RT-ROOM-NAME-MSG ()
	<COND
		(,LIT
			<TELL D ,HERE>
		)
		(T
			<TELL "darkness">
		)
	>
>

<ROUTINE V-WALK-AROUND ()
	<TELL ,K-WHICH-DIR-MSG>
	<SETG CLOCK-WAIT T>
	<RFATAL>
>

<CONSTANT K-WHICH-DIR-MSG "[Which direction do you want to go?]|">

<ROUTINE RT-WALK-WITHIN-ROOM-MSG ()
	<NO-NEED "move around within" ,HERE>
>

<ROUTINE V-WALK-TO ("AUX" DIR)
	<COND
		(<IN? ,PRSO ,ROOMS>
			<COND
				(<AND <SET DIR <RT-FIND-DIR ,PRSO>>
						<RT-DO-WALK .DIR>
					>
					<RTRUE>
				)
				(<FSET? ,PRSO ,FL-AUTO-ENTER>
					<RT-GOTO ,PRSO>
				)
				(T
					<RT-YOU-CANT-MSG "go">
				)
			>
		)
		(<OR	<RT-META-IN? ,PRSO ,HERE>
				<RT-GLOBAL-IN? ,PRSO ,HERE>
			>
			<RT-WALK-WITHIN-ROOM-MSG>
		)
		(T
			<RT-YOU-CANT-MSG "go">
		)
	>
>

<ROUTINE V-WALK-UNDER ()
	<COND
		(<AND <FSET? ,PRSO ,FL-DOOR>
				<MC-FORM? ,K-FORM-SALAMANDER ,K-FORM-BADGER>
			>
			<TELL
The+verb ,PRSO "fit" " too tightly in its frame to crawl under." CR
			>
		)
		(T
			<RT-YOU-CANT-MSG "walk under">
		)
	>
>

<ROUTINE V-WAVE-AT ()
	<TELL The+verb ,WINNER "wave">
	<COND
		(<NOT <MC-PRSO? <> ,ROOMS>>
			<TELL the ,PRSO>
		)
	>
	<COND
		(<NOT <MC-PRSI? <> ,ROOMS>>
			<TELL " at" the ,PRSI>
		)
	>
	<TELL ", but nothing happens." CR>
>

<ROUTINE V-WAVE-AT-SWP ("AUX" TMP)
	<SET TMP ,PRSO-NP>
	<SETG PRSO-NP ,PRSI-NP>
	<SETG PRSI-NP .TMP>
	<PERFORM ,V?WAVE-AT ,PRSI ,PRSO>
	<RTRUE>
>

<ROUTINE V-WEAR ("AUX" V)
	<COND
		(<AND <EQUAL? ,WINNER ,CH-PLAYER>
				<NOT <MC-FORM? ,K-FORM-ARTHUR>>
			>
			<RT-ANIMAL-CANT-MSG "wear">
		)
		(<AND <NOT <IN? ,PRSO ,WINNER>>
				<SET V <ITAKE ,PRSO <>>>
			>
			<COND
				(<EQUAL? .V ,M-FATAL>
					<RFATAL>
				)
			>
			<TELL The+verb ,WINNER "do" "n't have" the ,PRSO "." CR>
		)
		(<FSET? ,PRSO ,FL-WORN>
			<RT-ALREADY-MSG ,WINNER>
			<TELL " wearing" the ,PRSO ".">
			<COND
				(<G? ,P-MULT 1>
					<CRLF>
				)
				(T
					<RT-AUTHOR-OFF>
				)
			>
		)
		(<FSET? ,PRSO ,FL-CLOTHING>
			<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT>>
			<FSET ,PRSO ,FL-WORN>
			<TELL The+verb ,WINNER "put" " on" the ,PRSO "." CR>
		)
		(T
			<RT-YOU-CANT-MSG "put on">
		)
	>
>

;"---------------------------------------------------------------------------"
; "Y"
;"---------------------------------------------------------------------------"

<ROUTINE V-YELL ("AUX" NP PTR W)
	<COND
		(<NOT <MC-FORM? ,K-FORM-ARTHUR>>
			<RT-ANIMAL-CANT-MSG>
			<RTRUE>
		)
		(<MC-PRSO? ,ROOMS>
			<COND
				(<EQUAL? ,P-PRSA-WORD ,W?CRY>
					<TELL "Nothing happens." CR>
					<RT-AUTHOR-MSG
"Awww. Don't cry. You'll figure it out eventually."
					>
				)
				(T
					<TELL "AAAaaaarrrrrrrrrgh." CR>
					<SETG GL-QUESTION 1>
					<RT-AUTHOR-MSG "Good. Let it out. Now do you feel better?">
				)
			>
			<RTRUE>
		)
		(<AND <MC-PRSO? ,INTQUOTE>
				<SET NP <GET-NP ,INTQUOTE>>
				<SET PTR <NP-LEXBEG .NP>>
			>
			<COND
				(<EQUAL? <ZGET .PTR 0> ,W?QUOTE>
					<SET PTR <ZREST .PTR 8>>
				)
			>
			<COND
				(<SET W <ZGET .PTR 0>>
					<COND
						(<EQUAL? .W ,W?NIMUE>
							<PERFORM ,V?CALL ,CH-NIMUE>
							<RTRUE>
						)
					;	(<EQUAL? .W ,W?HELLO>
							<PERFORM ,V?HELLO ,PRSI>
							<RTRUE>
						)
					;	(<EQUAL? .W ,W?GOODBYE>
							<PERFORM ,V?GOODBYE ,PRSI>
							<RTRUE>
						)
					;	(<EQUAL? .W ,W?THANK ,W?THANKS>
							<PERFORM ,V?THANK ,PRSI>
							<RTRUE>
						)
					;	(<EQUAL? .W ,W?CYR>
							<SET PTR <ZREST .PTR 4>>
							<COND
								(<SET W <ZGET .PTR 0>>
								)
							>
						)
					>
				)
			>
		)
	>
	<TELL "You " vw ", but nothing happens." CR>
>

<ROUTINE V-YELL-AT ()
	<RT-NOT-LIKELY-MSG ,PRSO "would respond">
>

<ROUTINE V-YES ()
	<COND
		(,GL-QUESTION
			<RT-AUTHOR-MSG "That was just a rhetorical question.">
		)
		(T
			<TELL "No one asked you a question." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "Z"
;"---------------------------------------------------------------------------"

<ROUTINE V-ZORK ()
	<TELL "Gesundheit." CR>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

