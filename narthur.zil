;"***************************************************************************"
; "game : Arthur"
; "file : ARTHUR.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   06 Apr 1989 17:54:20  $"
; "rev  : $Revision:   1.7  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Compile/Load file"
; "Copyright (C) 1988 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

<SETG ZDEBUGGING? T>
<DEFINE DEBUG-CODE ('X "OPTIONAL" ('Y T))
	<COND
		(,ZDEBUGGING?
			.X
		)
		(ELSE
			.Y
		)
	>
>

<SETG NEW-PARSER? T>
<FREQUENT-WORDS?>
<LONG-WORDS?>
<ZIP-OPTIONS UNDO COLOR MOUSE DISPLAY>
<ORDER-OBJECTS? ROOMS-FIRST>

<PICFILE "ARTHUR.MAC.1">

<VERSION YZIP>

<IFFLAG
	(IN-ZILCH
		<PRINC "Compiling">
	)
	(T
		<PRINC "Loading">
	)
>

<PRINC ": King Arthur, by Challenge, Inc.
">

ON!-INITIAL	"for DEBUGR"
OFF!-INITIAL
ENABLE!-INITIAL
DISABLE!-INITIAL

<SET REDEFINE T>

<COMPILATION-FLAG P-BE-VERB T>

;<SETG L-SEARCH-PATH (["~PARSER" ""] !,L-SEARCH-PATH)>

<INSERT-FILE "DEFS">

<XFLOAD "PARSER.REST">

<INSERT-FILE "PICDEF">
<INSERT-FILE "MACROS">
<INSERT-FILE "MISC">
<INSERT-FILE "SYNTAX">
<INSERT-FILE "UTIL">
<INSERT-FILE "VERBS">
<INSERT-FILE "TRANSFRM">
<IF-P-BE-VERB <INSERT-FILE "BE">>
<INSERT-FILE "FOOD">
<INSERT-FILE "CELL">
<INSERT-FILE "BOAR">
<INSERT-FILE "WINDOW">
<INSERT-FILE "SWORD">
<INSERT-FILE "PASSWORD">
<INSERT-FILE "ENDGAME">
<INSERT-FILE "EEL">
<INSERT-FILE "BADGER">
<INSERT-FILE "BASIL">
<INSERT-FILE "DRAGON">
<INSERT-FILE "RAVEN">
<INSERT-FILE "CASTLE">
<INSERT-FILE "REDNITE">
<INSERT-FILE "LADY">
<INSERT-FILE "FOREST">
<INSERT-FILE "JOUST">
<INSERT-FILE "DEMON">
<INSERT-FILE "ICE-HOT">
<INSERT-FILE "CHESTNUT">
<INSERT-FILE "TOWER">
<INSERT-FILE "BOG">
<INSERT-FILE "LEPRCHAN">
<INSERT-FILE "MERLIN">
<INSERT-FILE "TAVERN">
<INSERT-FILE "KITCHEN">
<INSERT-FILE "IKNIGHT">
<INSERT-FILE "TOWN">
<INSERT-FILE "IDIOT">
<INSERT-FILE "CHURCH">
<INSERT-FILE "PLACES">
<INSERT-FILE "GLOBAL">
<INSERT-FILE "CLUES">
<INSERT-FILE "HINTS">

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

