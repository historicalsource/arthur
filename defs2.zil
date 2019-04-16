;"***************************************************************************"
; "game : Arthur"
; "file : DEFS2.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   12 May 1989  0:49:00  $"
; "rev  : $Revision:   1.33  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Default substitutions after PDEFS"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

<INCLUDE "PDEFS" "BASEDEFS" "PBITDEFS">

<USE "PMEM">

<CONSTANT SEARCH-ADJACENT <ORB ,SEARCH-MUST-HAVE ,SEARCH-MOBY>>

<REPLACE-DEFINITION PSEUDO-OBJECTS
	<PUTPROP THINGS PROPSPEC HACK-PSEUDOS>

	<DEFINE20 HACK-PSEUDOS (LIST "AUX" (N 0) (CT 0) NL)
		<SET LIST <REST .LIST>>
		<SET LIST
			<MAPF
				,LIST
				<FUNCTION (X)
					<COND
						(<0? .N>			; "Adjective(s)"
							<SET CT <+ .CT 1>>
							<SET N 1>
							<COND
								(<NOT .X>
									<>
								)
								(<TYPE? .X ATOM>
									<TABLE (PURE PATTERN (BYTE [REST WORD]))
										<BYTE 1>
										<VOC <SPNAME .X> ADJ>
									>
								)
								(<TYPE? .X LIST>
									<EVAL
										<CHTYPE
											(TABLE (PURE PATTERN (BYTE [REST WORD]))
												<BYTE <LENGTH .X>>
												!<MAPF ,LIST
													<FUNCTION (Y)
														<VOC <SPNAME .Y> ADJ>
													>
													.X
												>
											)
											FORM
										>
									>
								)
							>
						)
						(<1? .N>			; "Noun(s)"
							<SET N 2>
							<COND
								(<TYPE? .X ATOM>
									<TABLE (PURE PATTERN (BYTE [REST WORD]))
										<BYTE 1>
										<VOC <SPNAME .X> NOUN>
									>
								)
								(<TYPE? .X LIST>
									<EVAL
										<CHTYPE
											(TABLE (PURE PATTERN (BYTE [REST WORD]))
												<BYTE <LENGTH .X>>
												!<MAPF ,LIST
													<FUNCTION (Y)
														<VOC <SPNAME .Y> NOUN>
													>
													.X
												>
											)
											FORM
										>
									>
								)
								(T
									<>
								)
							>
						)
						(T		; "Routine"
							<SET N 0>
							.X
						)
					>
				>
				.LIST
			>
		>
		(<>
			<EVAL
				<CHTYPE
					(TABLE (PURE PATTERN (BYTE [REST WORD]))
						<BYTE .CT>
						!.LIST
					)
					FORM
				>
			>
		)
	>

	<GLOBAL LAST-PSEUDO-LOC:OBJECT <>>

	<COND
		(<CHECK-VERSION? ZIP>
			<OBJECT PSEUDO-OBJECT
				(LOC LOCAL-GLOBALS)
				(DESC "pseudo")
				(ACTION 0)
			>
		)
		(T
			<OBJECT PSEUDO-OBJECT
				(LOC LOCAL-GLOBALS)
				(FLAGS ;FL-HAS-LDESC FL-HAS-SDESC FL-NO-ARTICLE FL-TRY-TAKE)
				(ACTION 0)
			>
		)
	>

	<DEFINE TEST-THINGS (RM F "AUX" CT GLBS N)
		<SET GLBS <GETP .RM ,P?THINGS>>
		<SET N <GETB .GLBS 0>>
		<SET GLBS <REST .GLBS>>

		;"? maybe use theory from B'cy?"
		<COND
			(<T? <SET CT <FIND-ADJS .F>>>
				<SET CT <ADJS-COUNT .CT>>
			)
		>
		<REPEAT (
				(NOUN <FIND-NOUN .F>)
				(V <REST-TO-SLOT <FIND-ADJS .F> ADJS-COUNT 1>)
				TTBL
				(MATCH <>)
			)
			<COND
				(<AND <SET TTBL <GET .GLBS 1>>
						<INTBL? .NOUN <ZREST .TTBL 1> <GETB .TTBL 0>>
					>
					<COND
						(<ZERO? .CT>
							<SET MATCH T>
						)
						(<SET TTBL <ZGET .GLBS 0>>
							<REPEAT ((I 0))
								<COND
									(<INTBL? <ZGET .V .I> <ZREST .TTBL 1> <GETB .TTBL 0>>
										<SET MATCH T>
										<RETURN>
									)
									(<IGRTR? .I <- .CT 1>>
										<RETURN>
									)
								>
							>
						)
					>
					<COND
						(.MATCH
							<SETG LAST-PSEUDO-LOC .RM>
							<PUTP ,PSEUDO-OBJECT ,P?ACTION <ZGET .GLBS 2>>
							<ADD-OBJECT ,PSEUDO-OBJECT .F>
							<RFALSE>
						)
					>
				)
			>
			<SET GLBS <REST .GLBS 6>>
			<COND
				(<DLESS? .N 1>
					<RTRUE>
				)
			>
		>
	>
>

<REPLACE-DEFINITION WHICH-PRINT
	<DEFINE WHICH-PRINT ("OPT" (NP <GET-NP>))
		<REPEAT ((PTR <NP-LEXEND .NP>) (NOUN <NP-NAME .NP>))
			<COND
				(<==? .NOUN <ZGET .PTR 0>>
					<SETG P-OFLAG </ <- .PTR ,P-LEXV> 2>>
					<COPYT ,G-LEXV ,O-LEXV ,LEXV-LENGTH-BYTES>
					<COPYT ,G-INBUF ,O-INBUF <+ 1 ,INBUF-LENGTH>>
					<ZPUT ,OOPS-TABLE ,O-AGAIN <ZGET ,OOPS-TABLE ,O-START>>
					<RETURN>
				)
				(<G? ,P-LEXV <SET PTR <- .PTR ,LEXV-ELEMENT-SIZE-BYTES>>>
					<RFALSE>
				)
			>
		>
		<PROG ((SR ,ORPHAN-SR) (TMP <>) (LEN <FIND-RES-COUNT .SR>) (SZ <FIND-RES-SIZE .SR>) (NS 0))
			<COND
				(<WHICH-LIST? .NP .SR>
					; "Count the number of objects to print (only FL-SEEN)"
					<SET NS 0>
					<REPEAT ((N .LEN) (S .SZ) (VEC <REST-TO-SLOT .SR FIND-RES-OBJ1>))
						<COND
							(<L? <SET N <- .N 1>> 0>
								<RETURN>
							)
							(<L? <SET S <- .S 1>> 0>
								<RETURN>
							)
						>
						<COND
							(<FSET? <ZGET .VEC 0> ,FL-SEEN>
								<SET NS <+ .NS 1>>
							)
						>
						<SET VEC <ZREST .VEC 2>>
					>
				)
			>
			<COND
				(<AND <NOT <==? ,WINNER ,CH-PLAYER>>
						<NOT <SET TMP <WINNER-SAYS-WHICH? .NP>>>
					>
					<RT-AUTHOR-ON>
					<TELL "You must specify ">
					<COND
						(<AND <WHICH-LIST? .NP .SR>
								<G? .NS 1>
							>
							<TELL "if">
						)
						(T
							<TELL "which">
							<COND
								(<T? .NP>
									<TELL " ">
									<NP-PRINT .NP>
								)
							>
						)
					>
				)
				(<EQUAL? .TMP T>
					<RTRUE>
				)
				(T
					<RT-AUTHOR-ON>
					<TELL "Which">
					<COND
						(<T? .NP>
							<TELL " ">
							<NP-PRINT .NP>
						)
					>
					<TELL " do">
				)
			>
			<TELL " you mean">
			<COND
				(<AND <WHICH-LIST? .NP .SR>
						<G? .NS 1>
					>
					<COND
						(<OR .TMP <==? ,WINNER ,CH-PLAYER>>
							<TELL ",">
						)
					>
					<REPEAT ((N .LEN) (S .SZ) (VEC <REST-TO-SLOT .SR FIND-RES-OBJ1>) (REM .NS) OBJ)
						<COND
							(<DLESS? N 0>
								<RETURN>
							)
							(<DLESS? S 0>
								<RETURN>
							)
						>
						<COND
							(<FSET? <SET OBJ <ZGET .VEC 0>> ,FL-SEEN>
								<TELL the .OBJ>
								<COND
									(<EQUAL? .OBJ ,TH-WATER ,TH-BARREL-WATER>
										<TELL in <LOC .OBJ> the <LOC .OBJ>>
									)
								>
								<SET REM <- .REM 1>>
								<COND
									(<==? .REM 1>
										<COND
											(<NOT <==? .NS 2>>
												<TELL ",">
											)
										>
										<TELL " or">
									)
									(<G? .REM 1>
										<TELL ",">
									)
								>
							)
						>
						<SET VEC <ZREST .VEC 2>>
					>
				)
			>
			<COND
				(<==? ,WINNER ,CH-PLAYER>
					<TELL "?">
				)
				(T
					<TELL ".">
				)
			>
			<RT-AUTHOR-OFF>
		>
	>
>

<REPLACE-DEFINITION CANT-FIND-OBJECT
	<DEFINE CANT-FIND-OBJECT (NP PART ;SEARCH "AUX" TMP)
		<COND
			(<ZERO? <NP-QUANT .NP>>	;<EQUAL? .NP ,ORPHAN-NP>
				<NP-CANT-SEE .NP>
			)
			(T
				<RT-AUTHOR-ON>
				<TELL "There isn't anything to ">
				<COND
					(<SET TMP <PARSE-VERB ,PARSE-RESULT>>
						<PRINT-VOCAB-WORD .TMP>
					;	<SET TMP <PARSE-PARTICLE1 ,PARSE-RESULT>>
						<COND
							(<NOT <EQUAL? .PART ;.TMP 0 1>>
								<TELL " ">
								<PRINT-VOCAB-WORD .TMP>
							)
						>
					)
					(T
						<TELL "do that to">
					)
				>
				<TELL "!">
				<RT-AUTHOR-OFF>
			)
		>
	>

	<DEFINE NP-CANT-SEE ("OPT" (NP <GET-NP>) (SYN 0) "AUX" TMP (SHAVE <>))
		<COND
			(<SET TMP <NP-NAME .NP>>
				<RT-AUTHOR-ON>
				<TELL The ,WINNER>
				<COND
					(<AND ;<T? .SYN>
							<BTST .SYN ,SEARCH-MUST-HAVE>
							<NOT <BTST .SYN ,SEARCH-MOBY>>
						>
						<SET SHAVE T>
						<TELL verb ,WINNER "do" "n't have">
					)
					(T
						<TELL " can't see">
					)
				>
				<TELL " ">
				<COND
					(<OR	<CAPITAL-NOUN? .TMP>
							<AND
								<SET TMP <NP-ADJS .NP>>
								<ADJS-POSS .TMP>
							>
						>
						<NP-PRINT .NP T>
					)
					(T
						<TELL "any ">
						<NP-PRINT .NP>
					)
				>
				<COND
					(<NOT .SHAVE>
						<TELL " ">
						<COND
							(<AND <SET TMP <NP-LOC .NP>>
									<OR
										<AND
										;	"removed for HIT MAN ON HEAD WITH ROCK"
										;	<EQUAL? .NP ,ORPHAN-NP>
											<PMEM-TYPE? .TMP NOUN-PHRASE>
											<TELL "in">
										>
										<AND
											<PMEM-TYPE? .TMP LOCATION>
											<SET TMP <LOCATION-OBJECT .TMP>>
											<PRINT-VOCAB-WORD <LOCATION-PREP .TMP>>
										>
									>
								>
								<TELL the <NOUN-PHRASE-OBJ1 .TMP>>
								<THIS-IS-IT <NOUN-PHRASE-OBJ1 .TMP>>
							)
							(T
								<COND
								;	(<MOBY-FIND? .SEARCH>
										<TELL "anyw">
									)
									(T
										<TELL "right ">
									)
								>
								<TELL "here">
							)
						>
					)
				>
				<TELL ".">
				<RT-AUTHOR-OFF>
			)
			(T
				<MORE-SPECIFIC>
			)
		>
	>
>

<REPLACE-DEFINITION TELL-GWIM-MSG
	<DEFINE TELL-GWIM-MSG ("AUX" WD VB OBJ PTR N)
		<SET OBJ <ZGET ,GWIM-MSG 1>>
		<COND
			(<NOT <EQUAL? .OBJ ,TH-HANDS ,TH-MOUTH>>
				<TELL "[">
				<COND
					(<SET WD <ZGET ,GWIM-MSG 0>>
						<PRINT-VOCAB-WORD .WD>
						<SET VB <PARSE-VERB ,PARSER-RESULT>>
						<COND
							(<EQUAL? .VB ,W?SIT ,W?LIE>
								<COND
									(<EQUAL? .WD ,W?DOWN>
										<TELL " on">
									)
								>
							)
							(<EQUAL? .VB ,W?GET>
								<COND
									(<EQUAL? .WD ,W?OUT>
										<TELL " of">
									)
								>
							)
						>
					)
					(T
						<DIROUT ,K-D-TBL-ON ,K-DIROUT-TBL>
					)
				>
				<TELL the .OBJ>
				<COND
					(<NOT .WD>
						<DIROUT ,K-D-TBL-OFF>
						<SET PTR <ZREST ,K-DIROUT-TBL 2>>
						<SET N <ZGET ,K-DIROUT-TBL 0>>
						<COND
							(<EQUAL? <GETB .PTR 0> !\ >
								<SET PTR <ZREST .PTR 1>>
								<DEC N>
							)
						>
						<PRINTT .PTR .N>
					)
				>
				<TELL "]" CR>
			)
		>
	>
>

<REPLACE-DEFINITION DONT-UNDERSTAND
	<DEFINE DONT-UNDERSTAND ()
		<SETG CLOCK-WAIT T>
		<COND
			(<AND <EQUAL? 1 <GETB ,P-LEXV ,P-LEXWORDS>>
					<OR
						<COMPARE-WORD-TYPES
							<WCN <ZGET ,P-LEXV ,P-LEXSTART>>
							<GET-CLASSIFICATION NOUN>
						>
						<COMPARE-WORD-TYPES
							<WCN <ZGET ,P-LEXV ,P-LEXSTART>>
							<GET-CLASSIFICATION ADJ>
						>
					>
				;	<WORD-TYPE? <ZGET ,P-LEXV ,P-LEXSTART> ,P-NOUN-CODE ,P-ADJ-CODE>
				>
				<MISSING "verb">
				<RETURN T>
			)
		>
		<IFN-P-BE-VERB
			<COND
				(<COUNT-ERRORS 1>
					<RETURN T>
				)
			>
		>
		<RT-AUTHOR-MSG
"Sorry, but I don't understand. Please rephrase that, or try something else."
		>
	>
>

"If this returns true, then main loop does <PERFORM ,PRSA ,ROOMS>."

<REPLACE-DEFINITION COLLECTIVE-VERB?
	<ROUTINE COLLECTIVE-VERB? ("AUX" (TBL <REST-TO-SLOT ,P-PRSO NOUN-PHRASE-OBJ1>))
		<AND
			<VERB? TAKE>
			<EQUAL? 2 <NOUN-PHRASE-COUNT ,P-PRSO>>
			<EQUAL? <ZGET .TBL 0> ,TH-RED-LANCE ,TH-GREEN-LANCE>
			<EQUAL? <ZGET .TBL 2> ,TH-GREEN-LANCE ,TH-RED-LANCE>
		>
	>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

