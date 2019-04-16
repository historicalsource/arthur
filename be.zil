;"***************************************************************************"
; "game : Arthur"
; "file : BE.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   12 May 1989  0:47:36  $"
; "revs : $Revision:   1.10  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Be verbs"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "BE verbs"
;"---------------------------------------------------------------------------"

<SYNTAX BE OBJECT (EVERYWHERE) = V-BE>
<SYNTAX BE OBJECT (EVERYWHERE) OBJECT (EVERYWHERE) = V-BE>

<SYNTAX BE? OBJECT (EVERYWHERE) = V-BE?>
<SYNTAX BE? OBJECT (EVERYWHERE) OBJECT (EVERYWHERE) = V-BE?>
<SYNTAX WHO OBJECT (EVERYWHERE) = V-WHO>
<SYNTAX WHO OBJECT (EVERYWHERE) OBJECT (EVERYWHERE) = V-WHO>
<SYNTAX WHAT OBJECT (EVERYWHERE) = V-WHAT>
<SYNTAX WHAT OBJECT (EVERYWHERE) OBJECT (EVERYWHERE) = V-WHAT>
<SYNTAX WHERE OBJECT (EVERYWHERE) = V-WHERE>
<SYNTAX WHERE OBJECT (EVERYWHERE) OBJECT (EVERYWHERE) = V-WHERE>
;<SYNTAX WHEN OBJECT (EVERYWHERE) = V-WHEN>
;<SYNTAX WHEN OBJECT (EVERYWHERE) OBJECT (EVERYWHERE) = V-WHEN>
;<SYNTAX WHY OBJECT (EVERYWHERE) = V-WHY>
;<SYNTAX WHY OBJECT (EVERYWHERE) OBJECT (EVERYWHERE) = V-WHY>
;<SYNTAX HOW OBJECT (EVERYWHERE) = V-HOW>
;<SYNTAX HOW OBJECT (EVERYWHERE) OBJECT (EVERYWHERE) = V-HOW>

;<SYNTAX CAN OBJECT (EVERYWHERE) = V-CAN?>
;<SYNTAX MAY OBJECT (EVERYWHERE) = V-MAY?>
;<SYNTAX DO OBJECT (EVERYWHERE) = V-DO?>
;<SYNTAX COULD OBJECT (EVERYWHERE) = V-COULD?>
;<SYNTAX WOULD OBJECT (EVERYWHERE) = V-WOULD?>
;<SYNTAX SHOULD OBJECT (EVERYWHERE) = V-SHOULD?>
;<SYNTAX MIGHT OBJECT (EVERYWHERE) = V-MIGHT?>
;<SYNTAX WILL OBJECT (EVERYWHERE) = V-WILL?>
;<SYNTAX MUST OBJECT (EVERYWHERE) = V-MUST?>

;"---------------------------------------------------------------------------"
; "BE verb routines"
;"---------------------------------------------------------------------------"

<CONSTANT QACTIONS
	<TABLE (PURE LENGTH)
		V-BE V-BE? 0
	>
>

<ROUTINE V-BE ("AUX" TMP NOT? ADJ? LOC? OBJ PREP)
	<SET NOT? <ANDB ,PARSE-NOT <PARSE-FLAGS ,PARSE-RESULT>>>
	<SET ADJ? <PARSE-ADJ ,PARSE-RESULT>>
	<SET LOC? <PARSE-LOC ,PARSE-RESULT>>
	<COND
		(<VERB? BE? WHO WHAT WHERE ;WHY ;WHEN ;HOW>
			<COND
				(<MC-PRSI? ,INTADJ>
					<TELL The+verb ,PRSO "are">
					<COND
						(<NOT <IS-PRSO-ADJ? .ADJ?>>
							<TELL "n't">
						)
					>
					<TELL " ">
					<PRINTB .ADJ?>
					<TELL "." CR>
				)
				(<MC-PRSI? ,INTPP>
					<COND
						(<AND <SET PREP <P-PP-PREP>>
								<SET OBJ <P-PP-OBJ>>
							>
							<COND
								(<VERB? BE?>
									<TELL The+verb ,PRSO "are">
									<COND
										(<NOT <RIGHT-PREP? .PREP ,PRSO .OBJ>>
											<TELL "n't">
										)
									>
									<TELL " ">
									<PRINTB .PREP>
									<TELL the .OBJ "." CR>
								)
								(T
									<TELL "You want to know ">
									<TELL-Q-WORD>
									<PRSO-IS .NOT?>
									<TELL " ">
									<PRINTB .PREP>
									<TELL the .OBJ "." CR>
								)
							>
						)
						(T
							<TELL "You want to know ">
							<TELL-Q-WORD>
							<PRSO-IS .NOT?>
							<TELL " ">
							<PRINTB <PP-PREP .LOC?>>
							<TELL " ">
							<NP-PRINT <PP-NOUN .LOC?>>
							<TELL "." CR>
						)
					>
				)
				(<AND <NOT ,PRSI>
						<VERB? WHERE>
					>
					<SET LOC? <LOC ,PRSO>>
					<COND
						(<IN? ,PRSO ,HERE>
							<PRSO-IS <> T>
							<TELL " here." CR>
						)
						(<EQUAL? .LOC? ,GLOBAL-OBJECTS>
							<TELL "No doubt" the ,PRSO verb ,PRSO "are" " around here somewhere." CR>
						)
						(<AND <EQUAL? .LOC? ,LOCAL-GLOBALS>
								<RT-GLOBAL-IN? ,PRSO ,HERE>
							>
							<TELL The+verb ,PRSO "are" " nearby." CR>
						)
						(<FSET? .LOC? ,FL-PERSON>
							<TELL The+verb .LOC? "have" the ,PRSO "." CR>
						)
						(<EQUAL? <META-LOC ,PRSO> ,HERE>
							<TELL The+verb ,PRSO "are" in .LOC? the .LOC? "." CR>
						)
						(<IN? .LOC? ,ROOMS>
							<TELL The ,PRSO " is probably ">
							<COND
								(<FSET? ,PRSO ,TOUCHBIT>
									<TELL "still in" the .LOC? "." CR>
								)
								(T
									<TELL "lying around somewhere." CR>
								)
							>
						)
						(T
							<SETG GL-QUESTION 1>
							<TELL "That's an excellent question. Just where" verb ,PRSO "are" the ,PRSO "?" CR>
						)
					>
				)
				(T
					<SETG GL-QUESTION 1>
					<TELL "You want to know ">
					<TELL-Q-WORD>
					<PRSO-IS .NOT?>
					<COND
						(,PRSI
							<TELL a ,PRSI>
						)
					>
					<TELL "?" CR>
				)
			>
		)
		(T
			<COND
				(<MC-PRSI? ,INTADJ>
					<COND
						(<IS-PRSO-ADJ? .ADJ?>
							<COND
								(.NOT?
									<TELL "Wrong,">
								)
								(T
									<TELL "Right,">
								)
							>
							<PRSO-IS <>>
						)
						(T
							<COND
								(.NOT?
									<TELL "Right,">
								)
								(T
									<TELL "Wrong,">
								)
							>
							<PRSO-IS T>
						)
					>
					<TELL " ">
					<PRINTB .ADJ?>
					<TELL "." CR>
				)
				(<MC-PRSI? ,INTPP>
					<TELL "So, you say">
					<PRSO-IS .NOT?>
					<COND
						(<AND <SET PREP <P-PP-PREP>>
								<SET OBJ <P-PP-OBJ>>
							>
							<PRINTB .PREP>
							<TELL the .OBJ>
						)
						(T
							<PRINTB <PP-PREP .LOC?>>
							<TELL the <NP-PRINT <PP-NOUN .LOC?>>>
						)
					>
					<TELL "." CR>
				)
				(T
					<SETG GL-QUESTION 1>
					<TELL "So you think">
					<PRSO-IS .NOT?>
					<COND
						(,PRSI
							<TELL a ,PRSI>
						)
					>
					<TELL "?" CR>
				)
			>
		)
	>
>

;<ROUTINE P-NEGATIVE? ()
	<ANDB ,PARSE-NOT <PARSE-FLAGS ,PARSE-RESULT>>
>

<ROUTINE TELL-Q-WORD ()
	<COND
		(<VERB? BE?>
			<TELL "if">
		)
	;	(<VERB? WHY>
			<TELL "why">
		)
		(<VERB? WHO>
			<TELL "who">
		)
		(<VERB? WHAT>
			<TELL "what">
		)
		(<VERB? WHERE>
			<TELL "where">
		)
	;	(<VERB? WHEN>
			<TELL "when">
		)
	;	(<VERB? HOW>
			<TELL "how">
		)
		(T
			<PRINTB ,P-PRSA-WORD>
		)
	>
>

<ROUTINE RIGHT-PREP? (PREP OBJ CONT)
	<COND
		(<NOT <RT-META-IN? .OBJ .CONT>>
			<RFALSE>
		)
		(<EQUAL? .PREP ,W?IN ,W?INSIDE>
			<COND
				(<SEE-INSIDE? .CONT>
					<RTRUE>
				)
				(T
					<RFALSE>
				)
			>
		)
		(<AND <EQUAL? .PREP ,W?ON>
				<FSET? .CONT ,FL-SURFACE>
			>
			<RTRUE>
		)
	>
>

<CONSTANT ADJ-TABLE
	<TABLE (PURE LENGTH)
		<VOC "OUT" ;"OUTSIDE" ADJ>	; "OUTSIDE is a synonym of OUT"
		IS-OUTSIDE?
	;	<VOC "INSIDE" ADJ>
	;	IS-INSIDE?
		<VOC "OPEN" ADJ>
		IS-OPEN?
		<VOC "CLOSED" ADJ>
		IS-CLOSED?
		<VOC "LOCKED" ADJ>
		IS-LOCKED?
		<VOC "UNLOCKED" ADJ>
		IS-UNLOCKED?
		<VOC "DEAD" ADJ>
		IS-DEAD?
		<VOC "ALIVE" ADJ>
		IS-ALIVE?
		<VOC "QUIET" ADJ>
		IS-QUIET?
		<VOC "HERE" ADJ>
		IS-HERE?
	>
>

<ROUTINE IS-QUIET? (OBJ)
	<RTRUE>
>

<ROUTINE IS-OUTSIDE? (OBJ)
	<NOT <FSET? ,HERE ,FL-INDOORS>>
>

;<ROUTINE IS-INSIDE? (OBJ)
	<FSET? ,HERE ,FL-INDOORS>
>

<ROUTINE IS-OPEN? (OBJ)
	<AND
		<FSET? .OBJ ,FL-OPENABLE>
		<FSET? .OBJ ,FL-OPEN>
	>
>

<ROUTINE IS-CLOSED? (OBJ)
	<AND
		<FSET? .OBJ ,FL-OPENABLE>
		<NOT <FSET? .OBJ ,FL-OPEN>>
	>
>

<ROUTINE IS-LOCKED? (OBJ)
	<AND
		<FSET? .OBJ ,FL-OPENABLE>
		<FSET? .OBJ ,FL-LOCKED>
	>
>

<ROUTINE IS-UNLOCKED? (OBJ)
	<AND
		<FSET? .OBJ ,FL-OPENABLE>
		<NOT <FSET? .OBJ ,FL-LOCKED>>
	>
>

<ROUTINE IS-DEAD? (OBJ)
	<NOT <FSET? .OBJ ,FL-ALIVE>>
>

<ROUTINE IS-ALIVE? (OBJ)
	<FSET? .OBJ ,FL-ALIVE>
>

<ROUTINE IS-HERE? (OBJ "AUX" L)
	<SET L <LOC .OBJ>>
	<REPEAT ()
		<COND
			(<OR	<ZERO? .L>
					<EQUAL? .L ,GLOBAL-OBJECTS ,LOCAL-GLOBALS ,ROOMS>
				>
				<RFALSE>
			)
			(<EQUAL? .L ,HERE>
				<RTRUE>
			)
			(T
				<SET L <LOC .L>>
			)
		>
	>
>

<ROUTINE PRSO-IS (NOT? "OPT" (CAP? <>))
	<COND
		(.CAP?
			<TELL The ,PRSO>
		)
		(T
			<TELL the ,PRSO>
		)
	>
	<TELL verb ,PRSO "are">
	<COND
		(.NOT?
			<TELL "n't">
		)
	>
>

<ROUTINE IS-PRSO-ADJ? (ADJ "AUX" TMP)
	<COND
		(<AND <SET TMP <GETPT ,PRSO ,P?ADJECTIVE>>
				<INTBL? .ADJ .TMP </ <PTSIZE .TMP> 2>>
			>
			<RTRUE>
		)
		(<AND <SET TMP <INTBL? .ADJ ,ADJ-TABLE <GET ,ADJ-TABLE 0>>>
				<APPLY <GET .TMP 1> ,PRSO>
			>
			<RTRUE>
		)
	>
>

;<ROUTINE PP? (P N "AUX" (TMP <PARSE-LOC ,PARSE-RESULT>))
	<COND
		(<NOT .TMP>
			<RFALSE>
		)
		(<NOT <AND
					.P
					<EQUAL? .P <P-PP-PREP>>
				>
			>
			<RFALSE>
		)
		(<NOT <AND
					.N
					<EQUAL? .N <P-PP-OBJ>>
				>
			>
			<RFALSE>
		)
		(T
			<RTRUE>
		)
	>
>

;<ROUTINE YES-BUT? (STR1 STR2)
	<COND
		(<NOT <PARSE-QW ,PARSE-RESULT>>
			<TELL The ,PRSO " " .STR1 ", but " .STR2 he ,PRSO "?" CR>
		)
	>
>

;<ROUTINE V-CAN? ()
	<YES-BUT? "can" "may">
>

;<ROUTINE V-MAY? ()
	<YES-BUT? "may" "can">
>

<ROUTINE V-STATEMENT ()
	<V-DO?>
>

<ROUTINE V-DO? ()
	<COND
		(<NOT <PARSE-QW ,PARSE-RESULT>>
			<TELL The+verb ,PRSO "do" ", but why?" CR>
		)
	>
>

;<ROUTINE V-COULD? ()
	<YES-BUT? "could" "would">
>

;<ROUTINE V-WOULD? ()
	<YES-BUT? "would" "could">
>

;<ROUTINE V-SHOULD? ()
	<YES-BUT? "should" "will">
>

;<ROUTINE V-MIGHT? ()
	<YES-BUT? "might" "will">
>

;<ROUTINE V-WILL? ()
	<YES-BUT? "will" "should">
>

;<ROUTINE V-MUST? ()
	<YES-BUT? "must" "can">
>

<ROUTINE V-BE? ()
	<V-BE>
>

<ROUTINE V-WHO ("AUX" ASK)
;	<V-BE>
	<COND
		(<EQUAL? ,WINNER ,CH-PLAYER>
			<SET ASK <FIND-A-WINNER>>
		)
		(T
			<SET ASK ,WINNER>
		)
	>
	<SETG WINNER ,CH-PLAYER>
	<SETG PRSI-NP ,PRSO-NP>
	<SETG PRSO-NP <>>
	<PERFORM ,V?ASK-ABOUT .ASK ,PRSO>
>

<ROUTINE V-WHAT ()
;	<V-BE>
	<V-WHO>
>

;<ROUTINE V-WHEN ()
	<V-BE>
>

<ROUTINE V-WHERE ()
	<V-BE>
>

;<ROUTINE V-WHY ()
	<V-BE>
>

;<ROUTINE V-HOW ()
	<V-BE>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

