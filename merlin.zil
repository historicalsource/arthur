;"***************************************************************************"
; "game : Arthur"
; "file : MERLIN.ZIL"
; "auth :   $Author:   RAB  $"
; "date :     $Date:   15 May 1989 18:49:38  $"
; "revs : $Revision:   1.88  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Merlin"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "RM-MERPATH"
;"---------------------------------------------------------------------------"

<ROOM RM-MERPATH
	(LOC ROOMS)
	(DESC "path")
	(FLAGS FL-LIGHTED)
	(SYNONYM PATH)
	(NW TO RM-OUTSIDE-CRYSTAL-CAVE)
	(UP PER RT-MERPATH-UP)
	(SE TO RM-MEADOW)
	(DOWN TO RM-MEADOW)
	(GLOBAL LG-HILL LG-TOWN RM-MEADOW)
	(ACTION RT-RM-MERPATH)
>

<ROUTINE RT-RM-MERPATH ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL
"You are" standing " on a path that winds up a hill to the northwest, and
returns to the meadow to the southeast"
					>
				)
				(T
					<COND
						(<EQUAL? ,OHERE ,RM-MEADOW>
							<TELL
"As you leave the meadow, the path begins to wind up a"
							>
						)
						(T
							<TELL "The path winds down the">
						)
					>
					<TELL " hill that overlooks the town">
				)
			>
			<COND
				(<IN? ,TH-MIDGES ,RM-MERPATH>
					<FSET ,TH-MIDGES ,FL-SEEN>
					<TELL ". Hundreds of tiny midges are buzzing around your ">
					<COND
						(<MC-FORM? ,K-FORM-ARTHUR>
							<TELL "ankles">
						)
						(T
							<TELL "head">
						)
					>
				)
			>
			<TELL "." CR>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-MERLIN-PATH>
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

<ROUTINE RT-MERPATH-UP ("OPT" (QUIET <>))
	<COND
		(<MC-FORM? ,K-FORM-OWL>
			<RETURN <RT-FLY-UP .QUIET>>
		)
		(T
			<RETURN ,RM-OUTSIDE-CRYSTAL-CAVE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-OUTSIDE-CRYSTAL-CAVE"
;"---------------------------------------------------------------------------"

<ROOM RM-OUTSIDE-CRYSTAL-CAVE
	(LOC ROOMS)
	(DESC "outside Merlin's cave")
	(FLAGS FL-LIGHTED)
	(SYNONYM CLEARING)
	(NORTH TO RM-CRYSTAL-CAVE)
	(SE TO RM-MERPATH)
	(DOWN TO RM-MERPATH)
	(IN TO RM-CRYSTAL-CAVE)
	(UP PER RT-FLY-UP)
	(ACTION RT-RM-OUTSIDE-CRYSTAL-CAVE)
	(GLOBAL LG-HILL TH-SYMBOLS RM-CRYSTAL-CAVE RM-MERPATH)
>

<ROUTINE RT-RM-OUTSIDE-CRYSTAL-CAVE ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<THIS-IS-IT ,TH-SCROLL>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL
"You are" standing " in the clearing just to the south of Merlin's cave. A
path winds down the hill to the southeast."
					>
				)
				(T
					<COND
						(<EQUAL? ,OHERE ,RM-MERPATH>
							<TELL
"The path ends in the clearing just south of Merlin's cave."
							>
						)
						(<EQUAL? ,OHERE ,RM-CRYSTAL-CAVE>
							<TELL
"You blink you eyes as you emerge from the darkness of the cave into the "
							>
							<COND
								(<RT-TIME-OF-DAY? ,K-NIGHT>
									<TELL "bright moonlight">
								)
								(T
									<TELL "sunshine">
								)
							>
							<TELL ".">
						)
						(T
							<TELL
"You land in the clearing just to the south of Merlin's cave."
							>
						)
					>
				)
			>
			<COND
				(<MC-CONTEXT? ,M-F-LOOK>
					<FSET ,CH-MERLIN ,FL-SEEN>
					<THIS-IS-IT ,CH-MERLIN>
					<TELL
" An old man is sitting on a rock outside the cave, reading a scroll. A
minute passes before you realize that this shabbily-dressed hermit is the
same awe-inspiring Merlin who appeared to you in the churchyard." CR
					>
				)
				(T
					<CRLF>
					<RFALSE>
				)
			>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-OUTSIDE-CAVE>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTERED>
			<COND
				(<NOT <FSET? ,CH-PLAYER ,FL-LOCKED>>
					<FSET ,CH-PLAYER ,FL-LOCKED>	; "Enable use of transform verbs."
					<TELL
CR "Merlin looks up and says, \"Why hello, Arthur. I was just thinking about
you.\" He strokes his beard meditatively. \"I wish to help you, but if I
give you magic spells that instantly fulfill your every desire, you will only
prove that any man so favoured can accomplish a quest. Instead, I've been
pondering the idea of allowing you to assume shapes other than your human
form.\"" CR CR

"\"You see, as an animal, you could do things that humans can't. But at least
these things would not be done for you by spells. You would still have to
demonstrate the qualities which prove your worthiness to rule - and at the
same time you would be gaining respect for all forms of life.\"" CR CR

"His dark eyes bore into you for a second and then he seems to reach a
decision. \"Yes. That is what we shall do.\" He glances down at the scroll.
\"The creatures here should be sufficient for our purpose. The owl, the
badger, the salamander, the eel, and the turtle.\"" CR CR

"Merlin waves his hand over you and mumbles a few words. \"There. It is done.
The word you will need is 'Cyr,' the ancient word of transformation. When you
wish to become another creature, say 'Cyr' and the name of that creature.
Remember, however, that the people fear sorcery - if someone is present when
you change form, he may kill you. Remember also that you cannot move directly
from one foreign shape to another. You must become human first.\"" CR
					>
				)
				(<AND <EQUAL? ,OHERE ,RM-CRYSTAL-CAVE>
						<NOT <FSET? ,RM-CELL ,FL-TOUCHED>>
					>
					<TELL
"|Merlin glances up from his scroll and gives you a look of mild reproval.
\"Be on your way, Arthur - you have much to do. Even as we speak, a prisoner
languishes unjustly in a cell below Lot's castle. If you wish to be England's
king, you must help England's people.\"" CR
					>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
	>
>

;"---------------------------------------------------------------------------"
; "RM-CRYSTAL-CAVE"
;"---------------------------------------------------------------------------"

<ROOM RM-CRYSTAL-CAVE
	(LOC ROOMS)
	(DESC "crystal cave")
	(FLAGS FL-INDOORS FL-LIGHTED)
	(SYNONYM CAVE)
	(ADJECTIVE CRYSTAL)
	(OWNER CH-MERLIN)
	(SOUTH TO RM-OUTSIDE-CRYSTAL-CAVE)
	(OUT TO RM-OUTSIDE-CRYSTAL-CAVE)
	(GLOBAL LG-WALL)
	(ACTION RT-RM-CRYSTAL-CAVE)
>

<ROUTINE RT-RM-CRYSTAL-CAVE ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-F-LOOK>
					<TELL
"Your heart thumps with anticipation as you edge into the mysterious cave of
which you have heard so much.  The walls here seem to shimmer with their own
light.  The ceiling is lost in the darkness overhead. You hear the sound of
distant music, as if the earth itself were singing - and then the chord dies
away and you are left in silence." CR CR

"In the center of the room is a perfectly round crystal ball. On the ground
near the wall is a bag." CR
					>
				)
				(T
					<COND
						(<MC-CONTEXT? ,M-LOOK>
							<TELL "You are" standing " in">
						)
						(T
							<TELL "You enter">
						)
					>
					<TELL
the ,RM-CRYSTAL-CAVE ". The walls here seem to shimmer with their own
light. The only exit is to the south.|"
					>
					<RFALSE>
				)
			>
		)
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-CRYSTAL-CAVE>
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
		(<AND <VERB? EXAMINE LOOK-IN>
				<NOT <MC-HERE? ,RM-CRYSTAL-CAVE>>
			>
			<FSET ,RM-CRYSTAL-CAVE ,FL-SEEN>
			<TELL "An eerie light seems to emanate from within the cave." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "CH-MERLIN"
;"---------------------------------------------------------------------------"

<OBJECT CH-MERLIN
	(LOC RM-OUTSIDE-CRYSTAL-CAVE)
	(DESC "Merlin")
	(FLAGS FL-ALIVE FL-NO-ARTICLE FL-OPEN FL-PERSON FL-SEARCH)
	(SYNONYM MERLIN PERSON)
	(ACTION RT-CH-MERLIN)
>

<CONSTANT K-MERLIN-ECHOES-MSG "Merlin's voice echoes in your mind, ">
<CONSTANT K-HEEDED-WARNING-MSG " Perhaps you should have heeded Merlin's warning.|">
<CONSTANT K-MERLIN-WASTED-MSG
"Merlin appears before you and says sadly, \"I see you have learned nothing,
Arthur. I'm afraid my time with you has been wasted.\"">

<ROUTINE RT-CH-MERLIN ("OPT" (CONTEXT <>) "AUX" (FORM <>))
	<COND
		(<AND <MC-CONTEXT? ,M-WINNER <>>
				<VERB? HELLO GOODBYE THANK>
			>
			<COND
				(<VERB? HELLO>
					<TELL "\"Greetings, my young friend.\"" CR>
				)
				(<VERB? GOODBYE>
					<TELL "\"Farewell for now, Arthur. We shall meet again.\"" CR>
				)
				(<VERB? THANK>
					<TELL "\"You're welcome, my young friend.\"" CR>
					<COND
						(<NOT <FSET? ,CH-PLAYER ,FL-AIR>>
							<FSET ,CH-PLAYER ,FL-AIR>
							<RT-SCORE-MSG 10 0 0 0>
						)
					>
					<RTRUE>
				)
			>
		)
		(<MC-CONTEXT? ,M-WINNER>
			<COND
				(<AND <VERB? TELL-ABOUT>
						<MC-PRSO? ,CH-PLAYER>
					>
					<RFALSE>
				)
				(<VERB? WHO WHAT>
					<RFALSE>
				)
				(T
					<TELL
"\"You must not ask me to do too much, Arthur. It is you who must take
action.\"" CR
					>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<RFALSE>
		)
		(<AND <VERB? TELL>
				,P-CONT
			>
		; "Message and RFATAL if don't want Merlin to become winner"
			<RFALSE>
		)
		(<VERB? ASK-ABOUT>
			<COND
				(<NOUN-USED? ,PRSI ,W?OWL>
					<SET FORM ,K-FORM-OWL>
				)
				(<NOUN-USED? ,PRSI ,W?BADGER>
					<SET FORM ,K-FORM-BADGER>
				)
				(<NOUN-USED? ,PRSI ,W?SALAMANDER>
					<SET FORM ,K-FORM-SALAMANDER>
				)
				(<NOUN-USED? ,PRSI ,W?EEL>
					<SET FORM ,K-FORM-EEL>
				)
				(<NOUN-USED? ,PRSI ,W?TURTLE>
					<SET FORM ,K-FORM-TURTLE>
				)
				(<AND <MC-PRSI? ,CH-PLAYER>
						<NOT <MC-FORM? ,K-FORM-ARTHUR>>
					>
					<SET FORM ,GL-PLAYER-FORM>
				)
			>
			<COND
				(<EQUAL? .FORM ,K-FORM-OWL>
					<TELL
"\"From the owl you may learn to think. It is a noble bird indeed. Sacred to
the roman goddess Minerva.\"" CR
					>
				)
				(<EQUAL? .FORM ,K-FORM-BADGER>
					<TELL
"\"The badger is a fierce defender of his territory. He is a fine digger who
makes his nest and then fights to the death for it. So must you defend
England.\"" CR
					>
				)
				(<EQUAL? .FORM ,K-FORM-SALAMANDER>
					<TELL
"\"Ah yes. The lizard that they say lives in fire. He doesn't really - but he
does excrete a fluid that protects his skin from heat for short periods of
time. From him you will learn how to survive the heat of battle.\"" CR
					>
				)
				(<EQUAL? .FORM ,K-FORM-EEL>
					<TELL
"\"From the eel you will learn how to slip out of tight spots.\"" CR
					>
				)
				(<EQUAL? .FORM ,K-FORM-TURTLE>
					<TELL
"\"From the turtle you will learn that sometimes it is better to be slow and
sturdy than to be swift.\"" CR
					>
				)
				(<MC-PRSI? ,CH-DEMON>
					<COND
						(<FSET? ,CH-DEMON ,FL-BROKEN>
							<TELL
"\"Even though you have defeated him this time, Arthur, his magic remains
powerful.\"" CR
							>
						)
						(T
							<TELL
"\"He is evil incarnate. Many years ago, in a titanic struggle, my gods
overcame him and imprisoned him within a mountain. He sits there still,
bound by gold manacles, with a key of gold around his neck to taunt him.
Should he ever free himself, unspeakable evil will once again descend upon
England.\"" CR CR

"\"Even though he is manacled, he still has power. When you cross the river,
you will find that my magic is no longer of any use to you. That is his land.
Go there only if you must.\"" CR
							>
						)
					>
				)
				(<MC-PRSI? ,CH-LOT>
					<TELL
"\"He is an evil man, ruled by greed. He plots to steal your throne, yet
if you can defeat him in battle, he will become loyal to you.\"" CR
					>
				)
				(<MC-PRSI? ,CH-PRISONER>
					<TELL
"\"He is the village smith who has been wrongly and cruelly imprisoned by
Lot.\"" CR
					>
				)
				(<MC-PRSI? ,CH-MERLIN>
					<TELL
"\"I walk among men, yet I am not a man. I see the future, yet am powerless
to control it. I am but a tool to be used by my gods.\"" CR
					>
				)
				(<MC-PRSI? ,CH-NIMUE>
					<TELL
"\"She is Nimue, the Lady of the Lake. On cold evenings, when story-tellers
huddle close around the fire, they tell the legend of her enchantment. Little
do they know that the stories are all true.\"" CR
					>
				)
				(<MC-PRSI? ,TH-BAG>
					<TELL
"\"It is the bag my father's sister gave me when I first left home. Its
magic is small, but useful.\"" CR
					>
				)
				(<MC-PRSI? ,TH-SILVER-KEY>
					<TELL
"\"It is the key to a chamber wherein lies a beautiful lady.\"" CR
					>
				)
				(<MC-PRSI? ,RM-CRYSTAL-CAVE>
					<TELL
"\"The crystal cave holds much knowledge, Arthur. But be careful. Sometimes
it tells us things that we later wish we had learned for ourselves.\"" CR
					>
				)
				(<MC-PRSI? ,TH-CRYSTAL-BALL ,TH-TORQUE>
					<TELL
"\"The crystal contains the answers to all your questions. But use it
sparingly, Arthur. Sometimes it reveals things you wish you had reasoned out
for yourself.\"" CR
					>
				)
				(<MC-PRSI? ,TH-EXCALIBUR>
					<TELL
"\"It is the sword of destiny, meant to be wielded by you alone.\"" CR
					>
				)
				(<MC-PRSI? ,TH-MAGIC-RING>
					<TELL
"\"It's magic is useful. Remember well the words of the man who gave it to
you.\"" CR
					>
				)
				(<MC-PRSI? ,TH-FUTURE-OBJECT ,CH-PLAYER>
					<TELL
"A look of pain crosses Merlin's face. \"The future holds both triumph and
sorrow for you, Arthur. But do not dwell on it. Live each day as it is given
to you, and leave the future in the hands of the gods.\"" CR
					>
				)
				(<MC-PRSI? ,TH-SCROLL>
					<TELL
"\"It is of no use to you, Arthur. Its magic is useful only to those who
know how to wield it.\"" CR
					>
				)
				(<MC-PRSI? ,CH-BLACK-KNIGHT>
					<TELL
"\"One need only look at him to discern what master he serves.\"" CR
					>
				)
				(<MC-PRSI? ,CH-BLUE-KNIGHT>
					<TELL "\"A harmless old man who loves to joust.\"" CR>
				)
				(<MC-PRSI? ,CH-RED-KNIGHT>
					<TELL "\"His life's mission is to rid the land of evil.\"" CR>
				)
				(<MC-PRSI? ,CH-I-KNIGHT>
					<TELL
"\"He's just an ordinary man who is trying to turn a peculiar talent into
a dishonest living.\"" CR
					>
				)
				(<MC-PRSI? ,CH-CELL-GUARD>
					<TELL "\"Like most of Lot's minions, he's not very bright.\"" CR>
				)
				(<MC-PRSI? ,CH-COOK>
					<TELL "\"His own meals are far better than anyone suspects.\"" CR>
				)
				(<MC-PRSI? ,CH-DRAGON>
					<TELL "\"If I drank what he drinks, I would breathe fire too.\"" CR>
				)
				(<MC-PRSI? ,CH-FARMERS>
					<TELL
"\"They don't have much to do in the wintertime except sit in the tavern and
gossip.\"" CR
					>
				)
				(<MC-PRSI? ,CH-GIRL>
					<TELL
"\"I'm a poor one to ask for advice about women, Arthur. All I can say is, be
careful.\"" CR
					>
				)
				(<MC-PRSI? ,CH-IDIOT>
					<TELL "\"He only imagines half of what he thinks he imagines.\"" CR>
				)
				(<MC-PRSI? ,CH-PEASANT>
					<TELL
"\"He is but a humble man who makes his living from the soil.\"" CR
					>
				)
				(<MC-PRSI? ,TH-BIRD>
					<TELL
"\"He is an infrequent visitor to our shores, and he tells more than he knows.\"" CR
					>
				)
				(<MC-PRSI? ,CH-RHYMER>  ; "(Ask Merlin about the man in the tower)"
					<TELL "\"He seems inordinately fond of poetry, doesn't he?\"" CR>
				)
				(<MC-PRSI? ,TH-BOAR>
					<TELL
"\"Even though he has only one tusk, he is still very dangerous.\"" CR
					>
				)
				(<MC-PRSI? ,CH-RAVEN>
					<TELL
"\"The giant bird is a menace to all other life in the forest.\"" CR
					>
				)
				(<MC-PRSI? ,LG-TOWER>
					<TELL
"\"It is the home of a very interesting little old man.\"" CR
					>
				)
				(<MC-PRSI? ,RM-TAVERN> 
					<TELL
"\"Like all such places, it is frequented by men with little to do and much
to say.\"" CR
					>
				)
				(<MC-PRSI? ,LG-CASTLE>
					<TELL
"\"It is Lot's domain, Arthur. You must go in, but be careful when you do so.\"" CR
					>
				)
				(<MC-PRSI? ,RM-BOG>
					<TELL
"\"The ground there is treacherous and shifting, Arthur. Do not venture in
unless you are sure of your path.\"" CR
					>
				)
				(<MC-PRSI? ,LG-LAKE>
					<TELL "\"The lake is home to both beauty and the beast.\"" CR>
				)
				(<MC-PRSI? ,TH-SHERLOCK>
					<TELL "\"It's a wonderful game. I highly recommend it.\"" CR>
				)
				(<MC-PRSI? ,TH-HAWTHORN>
					<TELL
"Merlin's eyes cloud over as if he is looking far into the future. He mumbles
strange words that sound like 'anti-piracy' and 'documentation,' and then
he snaps out of his trance as if nothing had happened." CR
					>
				)
				(<MC-PRSI? ,INFOCOM>
					<TELL
"\"As magicians, they're OK. But you should see their Friday afternoon parties.\"" CR
					>
				)
				(<MC-PRSI? ,ZORK>
					<TELL "\"Didn't like the book, but I ">
					<HLIGHT ,K-H-BLD>
					<TELL "loved">
					<HLIGHT ,K-H-NRM>
					<TELL " Kim Novak in the movie.\"" CR>
				)
				(<MC-PRSI? ,ENCHANTER>
					<TELL "\"Now ">
					<HLIGHT ,K-H-BLD>
					<TELL "there's">
					<HLIGHT ,K-H-NRM>
					<TELL " a trilogy to frotz your heart.\"" CR>
				)
				(<MC-PRSI? ,TH-MASTER>
					<TELL "\"I answer only to the gods.\"" CR>
				)
				(<MC-PRSI? ,TH-SYMBOLS>
					<TELL "\"They do not concern you, Arthur.\"" CR>
				)
				(<MC-PRSI? ,TH-CHIVALRY>
					<TELL
"\"Chivalrous behaviour is nothing more than politeness and common sense,
Arthur. If you act with kindness, you have nothing to fear.\"" CR
					>
				)
				(<MC-PRSI? ,TH-ENGLAND>
					<TELL
"\"These are hard times, Arthur. Your country has need of you.\"" CR
					>
				)
				(<MC-PRSI? ,TH-UTHER>
					<TELL
"\"He was a great man, your father was. I was proud to know him.\"" CR
					>
				)
				(<MC-PRSI? ,TH-MOTHER>
					<TELL
"\"She is in a convent now. One day, when you are king, I will take you
to her.\"" CR
					>
				)
				(<MC-PRSI? ,TH-CELTIC-GODS>
					<TELL
"\"Their day may be passing, Arthur. But they are not gone yet.\"" CR
					>
				)
				(<MC-PRSI? ,TH-GOD>
					<TELL
"\"His day is dawning, Arthur. I cannot serve him, but you must make your
own choice.\"" CR
					>
				)
				(T
					<TELL
"Merlin shrugs his shoulders and nods toward the cave. \"Perhaps the answer
you seek lies within.\"" CR
					>
				)
			>
		)
		(<VERB? EXAMINE>
			<TELL
"The aged wizard gazes back at you with friendly eyes that seem to see the
future, as well as the past." CR
			>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-SCROLL"
;"---------------------------------------------------------------------------"

<OBJECT TH-SCROLL
	(LOC CH-MERLIN)
	(DESC "scroll")
	(FLAGS FL-NO-LIST FL-SURFACE FL-SEARCH FL-TRY-TAKE)
	(SYNONYM SCROLL)
	(OWNER CH-MERLIN)
	(ACTION RT-TH-SCROLL)
>

<CONSTANT K-NO-READ-SCROLL-MSG
"Merlin moves the scroll beyond your reach and says, \"Some secrets, Arthur,
are best kept hidden.\"|">

<ROUTINE RT-TH-SCROLL ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<TELL "The scroll is covered with strange symbols." CR>
		)
		(<OR	<VERB? READ>
				<TOUCH-VERB?>
			>
			<TELL ,K-NO-READ-SCROLL-MSG>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-SYMBOLS"
;"---------------------------------------------------------------------------"

<OBJECT TH-SYMBOLS
	(LOC RM-CRYSTAL-CAVE)
	(DESC "symbols")
	(FLAGS FL-NO-DESC FL-PLURAL FL-READABLE)
	(SYNONYM SYMBOL SYMBOLS)
	(OWNER K-SYMBOL-OWNER-TBL)
	(ACTION RT-TH-SYMBOLS)
>

<CONSTANT K-SYMBOL-OWNER-TBL
	<TABLE (PURE LENGTH)
		TH-GROUND
		TH-SCROLL
	>
>

<ROUTINE RT-TH-SYMBOLS ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<AND <VERB? READ>
				<MC-HERE? ,RM-OUTSIDE-CRYSTAL-CAVE>
			>
			<TELL ,K-NO-READ-SCROLL-MSG>
		)
		(<VERB? EXAMINE READ>
			<TELL "The symbols have no meaning to you." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-BAG"
;"---------------------------------------------------------------------------"

<OBJECT TH-BAG
	(LOC RM-CRYSTAL-CAVE)
	(DESC "bag")
	(FLAGS FL-CONTAINER FL-OPENABLE FL-READABLE FL-SEARCH FL-TAKEABLE)
	(SYNONYM BAG)
	(ADJECTIVE MAGIC)
	(OWNER CH-MERLIN)
	(SIZE 5 CAPACITY K-CAP-MAX)
	(ACTION RT-TH-BAG)
>

<ROUTINE RT-TH-BAG ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<COND
				(<VERB? PUT-IN>
					<COND
						(<MC-PRSO? ,TH-GOLD-KEY ,TH-APPLE>
							<TELL
"You try to put" the ,PRSO " in the bag, but they seem to repel each other,
and you fail." CR
							>
						)
						(<OR	<MC-PRSO? ,TH-SWORD ,TH-CRUTCH ,TH-SHIELD ,TH-SLEAN>
								<AND
									<G? ,P-MULT 1>
									<MC-PRSO? ,TH-RED-LANCE ,TH-GREEN-LANCE>
								>
							>
							<TELL
The+verb ,PRSO "are" " too large to fit in" the ,TH-BAG "." CR
							>
						)
						(<MC-PRSO? ,TH-RED-LANCE ,TH-GREEN-LANCE>
							<TELL
"You look at" the ,PRSO ". You look at" the ,TH-BAG ". You look at" the ,PRSO
". Slowly it dawns on you that it is just not going to work." CR
							>
						)
					>
				)
			>
		)
		(<VERB? EXAMINE LOOK-ON READ>
			<FSET ,TH-BAG ,FL-SEEN>
			<TELL "It is a small black bag, monogrammed with the initial M." CR>
		)
		(<VERB? FILL>
			<RT-WASTE-OF-TIME-MSG>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-CRYSTAL-BALL"
;"---------------------------------------------------------------------------"

<OBJECT TH-CRYSTAL-BALL
	(LOC TH-PEDESTAL)
	(DESC "crystal ball")
	(FLAGS FL-TRY-TAKE FL-TRANSPARENT FL-READABLE)
	(SYNONYM BALL CRYSTAL)
	(ADJECTIVE CRYSTAL)
	(OWNER CH-MERLIN)
	(ACTION RT-TH-CRYSTAL-BALL)
>

<CONSTANT K-NO-TOUCH-CRYSTAL-MSG
", the crystal walls of the cave start to vibrate ominously and you wisely
withdraw.|">

<ROUTINE RT-TH-CRYSTAL-BALL ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE LOOK-ON READ LOOK-IN>
			<FSET ,TH-CRYSTAL-BALL ,FL-SEEN>
			<V-HINT>
		)
		(<TOUCH-VERB?>
			<TELL "As you reach for the ball" ,K-NO-TOUCH-CRYSTAL-MSG>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-PEDESTAL"
;"---------------------------------------------------------------------------"

<OBJECT TH-PEDESTAL
	(LOC RM-CRYSTAL-CAVE)
	(DESC "pedestal")
	(FLAGS FL-SURFACE FL-SEARCH FL-TRY-TAKE FL-TRANSPARENT)
	(SYNONYM PEDESTAL)
	(ADJECTIVE CRYSTAL)
	(OWNER CH-MERLIN)
	(ACTION RT-TH-PEDESTAL)
>

<ROUTINE RT-TH-PEDESTAL ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<TOUCH-VERB?>
			<TELL "As you reach for the pedestal" ,K-NO-TOUCH-CRYSTAL-MSG>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-TORQUE"
;"---------------------------------------------------------------------------"

<OBJECT TH-TORQUE
	(LOC RM-CHURCHYARD)
	(DESC "torque")
	(FLAGS FL-CONTAINER FL-CLOTHING FL-OPEN FL-SEARCH FL-TAKEABLE)
	(SYNONYM PETER TORQUE)
	(ADJECTIVE PETER)
	(SIZE 2)
	(ACTION RT-TH-TORQUE)
>

<ROUTINE RT-TH-TORQUE ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,TH-TORQUE ,FL-SEEN>
			<THIS-IS-IT ,TH-TORQUE>
			<TELL The ,TH-TORQUE " is an open neckband made of twisted metal">
			<COND
				(<NOT <FSET? ,TH-TORQUE ,FL-WORN>>
					<TELL ", and it looks like it's about your size">
				)
			>
			<TELL
". It ends in two knobs, and imbedded in one of the knobs is a sliver of "
			>
			<COND
				(<FSET? ,TH-CRYSTAL ,FL-LOCKED>
					<TELL "darkened crystal">
				)
				(T
					<TELL "crystal that gives off a faint glow">
				)
			>
			<TELL "." CR>
		)
	>
>

;"---------------------------------------------------------------------------"
; "TH-CRYSTAL"
;"---------------------------------------------------------------------------"

<OBJECT TH-CRYSTAL
	(LOC TH-TORQUE)
	(DESC "sliver of crystal")
	(FLAGS FL-NO-DESC FL-READABLE FL-TRY-TAKE)
	(SYNONYM CRYSTAL SLIVER KNOB KNOBS)
	(ADJECTIVE CRYSTAL)
	(OWNER TH-CRYSTAL)
	(ACTION RT-TH-CRYSTAL)
>

; "TH-CRYSTAL flags:"
; "	FL-LOCKED - Crystal is dark, player cannot get hint"

<GLOBAL GL-CRYSTAL-HINT 0 <> BYTE>

<ROUTINE RT-TH-CRYSTAL ("OPT" (CONTEXT <>) "AUX" W)
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE LOOK-IN LOOK-ON READ>
			<FSET ,TH-CRYSTAL ,FL-SEEN>
			<COND
				(<MC-HERE? ,RM-CRYSTAL-CAVE>
					<V-HINT>
				)
				(<OR	<FSET? ,TH-CRYSTAL ,FL-LOCKED>
						<INTBL? ,HERE <ZREST ,K-DEMON-DOMAIN-TBL 1> <GETB ,K-DEMON-DOMAIN-TBL 0> 1>
					>
					<TELL "The crystal is dark." CR>
				)
				(T
					<TELL
"You gaze intently into the crystal. After a moment, your vision blurs and
you become disoriented.  It seems you are standing in a darkened cave,
gazing into a crystal ball.||"
					>
					<SET W ,GL-HINT-WARNING>
					<V-HINT>
					<COND
						(<NOT .W>
							<CRLF>
						)
					>
					<TELL "Your vision clears and you are no longer in the cave.|">
					<INC GL-CRYSTAL-HINT>
					<COND
						(<EQUAL? ,GL-CRYSTAL-HINT 2>
							<FSET ,TH-CRYSTAL ,FL-LOCKED>
							<RT-QUEUE ,RT-I-CRYSTAL <+ ,GL-MOVES 5>>
							<TELL
"|The crystal goes dark. Its limited power has been temporarily exhausted." CR
							>
						)
					>
					<RTRUE>
				)
			>
		)
		(<VERB? TAKE>
			<TELL "You can't remove the ">
			<NP-PRINT ,PRSO-NP>
			<TELL " from" the ,TH-TORQUE "." CR>
		)
	>
>

<ROUTINE RT-I-CRYSTAL ()
	<FCLEAR ,TH-CRYSTAL ,FL-LOCKED>
	<RFALSE>
>

;"---------------------------------------------------------------------------"
; "TH-SILVER-KEY"
;"---------------------------------------------------------------------------"

<OBJECT TH-SILVER-KEY
	(LOC TH-BAG)
	(DESC "silver key")
	(FLAGS FL-KEY FL-TAKEABLE)
	(SYNONYM KEY)
	(ADJECTIVE SILVER)
	(OWNER CH-MERLIN)
	(SIZE 1)
	(GENERIC RT-GN-KEY)
>

<NEW-ADD-WORD "KEYS" NOUN <VOC "KEY"> ,PLURAL-FLAG>

<ROUTINE RT-GN-KEY (TBL FINDER "AUX" PTR N (OBJ <>))
	<SET PTR <REST-TO-SLOT .TBL FIND-RES-OBJ1>>
	<SET N <FIND-RES-COUNT .TBL>>
	<COND
		(<INTBL? ,P-IT-OBJECT .PTR .N>
			<SET OBJ ,P-IT-OBJECT>
		)
		(<MC-HERE? ,RM-TAV-KITCHEN>
			<SET OBJ ,TH-CUPBOARD-KEY>
		)
		(<MC-HERE? ,RM-DEMON-HALL>
			<SET OBJ ,TH-GOLD-KEY>
		)
		(<MC-HERE? ,RM-TOW-CLEARING ,RM-CIRC-ROOM>
			<SET OBJ ,TH-IVORY-KEY>
		)
		(<MC-HERE? ,RM-ISLAND ,RM-UG-CHAMBER>
			<SET OBJ ,TH-SILVER-KEY>
		)
		(<MC-HERE? ,RM-CELL ,RM-HALL>
			<SET OBJ ,TH-MASTER-KEY>
		)
		(T
			<REPEAT ((I .N) O)
				<COND
					(<DLESS? I 0>
						<RETURN>
					)
					(<FSET? <SET O <ZGET .PTR 0>> ,FL-SEEN>
						<COND
							(.OBJ
								<SET OBJ <>>
								<RETURN>
							)
							(T
								<SET OBJ .O>
							)
						>
					)
				>
				<SET PTR <ZREST .PTR 2>>
			>
		)
	>
	<COND
		(.OBJ
			<TELL "[" The .OBJ "]" CR>
		)
	>
	<RETURN .OBJ>
>

;"---------------------------------------------------------------------------"
; "TH-FUTURE-OBJECT"
;"---------------------------------------------------------------------------"

<OBJECT TH-FUTURE-OBJECT
	(LOC GENERIC-OBJECTS)
	(DESC "that")
	(SYNONYM GUINEVERE LAUNCELOT GRAIL CAMELOT TABLE MORDRED FUTURE ;ENGLAND)
	(ADJECTIVE HOLY ROUND)
>

;"---------------------------------------------------------------------------"
; "RM-ABOVE-MERCAVE"
;"---------------------------------------------------------------------------"

<ROOM RM-ABOVE-MERCAVE
	(LOC ROOMS)
	(DESC "above merlin's cave")
	(FLAGS FL-AIR FL-LIGHTED)
	(DOWN PER RT-FLY-DOWN)
	(EAST TO RM-ABOVE-EDGE-OF-WOODS)
	(NE TO RM-ABOVE-FOREST)
	(SE TO RM-ABOVE-MEADOW)
	(UP SORRY K-NO-HIGHER-MSG)
	(GLOBAL LG-HILL RM-CRYSTAL-CAVE)
	(ACTION RT-RM-ABOVE-MERCAVE)
>

<ROUTINE RT-RM-ABOVE-MERCAVE ("OPT" (CONTEXT <>))
	<COND
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<FSET ,LG-FOREST ,FL-SEEN>
			<FSET ,RM-MOOR ,FL-SEEN>
			<FSET ,RM-MEADOW ,FL-SEEN>
			<TELL
"You are hovering over Merlin's cave. The prevailing northeast breeze would
carry you over the enchanted forest, and just to the south of that is the
edge of the woods. The meadow lies below you to the southeast.|"
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

;"---------------------------------------------------------------------------"
; "LG-HILL"
;"---------------------------------------------------------------------------"

<OBJECT LG-HILL
	(LOC LOCAL-GLOBALS)
	(DESC "hill")
	(SYNONYM HILL)
	(ADJECTIVE HOLLOW)
	(OWNER CH-MERLIN)
	(ACTION RT-LG-HILL)
>

<ROUTINE RT-LG-HILL ("OPT" (CONTEXT <>))
	<COND
		(.CONTEXT
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<TELL
"It looks like one of the 'hollow' hills, where wizards are said to dwell." CR
			>
		)
	>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

