;"***************************************************************************"
; "game : Arthur"
; "file : IDIOT.ZIL"
; "auth :   $Author:   DEB  $"
; "date :     $Date:   13 May 1989 15:43:56  $"
; "rev  : $Revision:   1.85  $"
; "vers : 1.0"
;"---------------------------------------------------------------------------"
; "Town square/Village idiot"
; "Copyright (C) 1989 Infocom, Inc.  All rights reserved."
;"***************************************************************************"

;"---------------------------------------------------------------------------"
; "RM-TOWN-SQUARE"
;"---------------------------------------------------------------------------"

<ROOM RM-TOWN-SQUARE
	(LOC ROOMS)
	(DESC "town square")
	(FLAGS FL-LIGHTED)
	(SYNONYM SQUARE)
	(ADJECTIVE TOWN)
	(NORTH TO RM-CHURCHYARD IF LG-CHURCH-GATE IS OPEN)
	(WEST TO RM-VILLAGE-GREEN)
	(EAST TO RM-CASTLE-GATE)
	(SOUTH TO RM-TAVERN)
	(IN TO RM-TAVERN)
	(UP PER RT-FLY-UP)
	(ADJACENT <TABLE (LENGTH BYTE PURE) RM-CHURCHYARD T>)
	(GLOBAL LG-THATCH LG-CHURCH-GATE LG-TOWN LG-CASTLE RM-TAVERN RM-CHURCHYARD RM-CHURCH RM-VILLAGE-GREEN)
	(ACTION RT-RM-TOWN-SQUARE)
>

<ROUTINE RT-RM-TOWN-SQUARE ("OPT" (CONTEXT <>) "AUX" (OBJ1 <>) (OBJ2 <>) N)
	<COND
		(<MC-CONTEXT? ,M-ENTER>
			<SETG GL-PICTURE-NUM ,K-PIC-TOWN-SQUARE>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-PICT>
					<RT-UPDATE-PICT-WINDOW>
				)
			>
			<COND
				(<IN? ,TH-ARMOUR ,CH-I-KNIGHT>
					<SET OBJ1 ,TH-ARMOUR>
				)
				(<IN? ,TH-SHIELD ,CH-I-KNIGHT>
					<SET OBJ1 ,TH-SHIELD>
				)
				(<IN? ,TH-PUMICE ,CH-I-KNIGHT>
					<SET OBJ1 ,TH-PUMICE>
				)
				(<IN? ,TH-IVORY-KEY ,CH-I-KNIGHT>
					<SET OBJ1 ,TH-IVORY-KEY>
				)
			>
			<COND
				(.OBJ1
					<COND
						(<IN? ,TH-ARMOUR ,CH-IDIOT>
							<SET OBJ2 ,TH-ARMOUR>
						)
						(<IN? ,TH-SHIELD ,CH-IDIOT>
							<SET OBJ2 ,TH-SHIELD>
						)
						(<IN? ,TH-PUMICE ,CH-IDIOT>
							<SET OBJ2 ,TH-PUMICE>
						)
						(<IN? ,TH-IVORY-KEY ,CH-IDIOT>
							<SET OBJ2 ,TH-IVORY-KEY>
						)
					>
					<COND
						(.OBJ2
							<RT-IDIOT-GIVE .OBJ2 ,CH-I-KNIGHT>
						)
					>
					<RT-IDIOT-TAKE .OBJ1>
					<FSET ,CH-I-KNIGHT ,FL-BROKEN>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-ENTERED>
			<RT-QUEUE ,RT-I-IDIOT-MSG ,GL-MOVES>
		)
		(<MC-CONTEXT? ,M-EXIT>
			<RT-DEQUEUE ,RT-I-IDIOT-MSG>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-BEG>
			<COND
				(<NOT <RT-IS-QUEUED? ,RT-I-IDIOT-MSG>>
					<RT-QUEUE ,RT-I-IDIOT-MSG ,GL-MOVES>
				)
			>
			<SETG GL-IDIOT-MSG T>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK ,M-LOOK>
			<COND
				(<MC-CONTEXT? ,M-LOOK>
					<TELL The+verb ,WINNER "are" standing " in">
				)
				(T
					<TELL The ,WINNER walk " into">
				)
			>
			<FSET ,LG-CASTLE ,FL-SEEN>
			<FSET ,RM-TAVERN ,FL-SEEN>
			<FSET ,RM-VILLAGE-GREEN ,FL-SEEN>
			<FSET ,CH-IDIOT ,FL-SEEN>
			<THIS-IS-IT ,CH-IDIOT>
			<TELL
" the town square. The churchyard lies to the north, and the castle to the
east. To your south you see the entrance to the town's only tavern, and to
the west is the village green.||The village idiot is here, idly playing with"
			>
			<RT-IDIOT-PLAY-MSG>
			<COND
				(<OR	<MC-CONTEXT? ,M-F-LOOK ,M-V-LOOK>
						<VERB? LOOK>
					>
					<COND
						(<NOT <RT-I-IDIOT-MSG T>>
							<CRLF>
						)
					>
				)
				(T
					<CRLF>
				)
			>
			<RFALSE>
		)
		(<MC-CONTEXT? ,M-END>
			<COND
				(<AND <VERB? TRANSFORM>
						<NOT <MC-FORM? ,GL-OLD-FORM>>
					>
					<SETG GL-IDIOT-MSG <>>
					<THIS-IS-IT ,CH-IDIOT>
					<TELL
CR The ,CH-IDIOT " placidly accepts your transformation and drools on you." CR
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
; "CH-IDIOT"
;"---------------------------------------------------------------------------"

<OBJECT CH-IDIOT
	(LOC RM-TOWN-SQUARE)
	(DESC "idiot")
	(FLAGS FL-ALIVE FL-NO-LIST FL-OPEN FL-PERSON FL-SEARCH)
	(SYNONYM IDIOT ;BOY PERSON MAN FLOYD)
	(ADJECTIVE VILLAGE)
	(CONTFCN RT-CH-IDIOT)
	(ACTION RT-CH-IDIOT)
>

<CONSTANT K-IDIOT-TRADE-MSG "\"We could trade if you want.\"">
<CONSTANT K-IDIOT-DIRECTION-MSG
"\"Go out to where the gate used to be and turn right. Then go to where the
big tree used to be and turn left. When you get to the place where the
whatsis was until they moved it to the spot where it was before they put it
where it is now, then take two quick rights. After that, go straight for
about twice as far, and when you hit the trees, you're almost there. You
can't miss it.\"|">

<GLOBAL GL-IDIOT-STUFF <>>

<ROUTINE RT-CH-IDIOT ("OPT" (CONTEXT <>) "AUX" OTHER (OBJ <>) N)
	<COND
		(<AND <MC-CONTEXT? ,M-WINNER <>>
				<VERB? HELLO GOODBYE THANK>
			>
			<COND
				(<VERB? HELLO>
					<SETG GL-IDIOT-MSG <>>
					<TELL
"The idiot says brightly, \"Hello!\" and looks at you expectantly." CR
					>
				)
				(<VERB? GOODBYE>
					<SETG GL-IDIOT-MSG <>>
					<TELL
"A cloud passes over the idiot's face. \"Goodbye,\" he says sadly." CR
					>
				)
				(<VERB? THANK>
					<SETG GL-IDIOT-MSG <>>
					<TELL "The idiot smiles brightly and says, \"OK.\"" CR>
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
					<RT-IDIOT-WHISPERS-MSG>
				)
			>
		)
		(<MC-CONTEXT? ,M-CONT>
			<COND
				(<AND <VERB? ASK-FOR>
						<MC-PRSO? ,CH-IDIOT>
						,NOW-PRSI
					>
					<SETG GL-IDIOT-MSG <>>
					<TELL ,K-IDIOT-TRADE-MSG CR>
				)
				(<AND <VERB? ASK-ABOUT>
						<MC-PRSO? ,CH-IDIOT>
						,NOW-PRSI
					>
					<SETG GL-IDIOT-MSG <>>
					<TELL
"\"I got" him ,PRSI " from my invisible playmate,\" he says, giving" him ,PRSI
" a little kick with his foot. " ,K-IDIOT-TRADE-MSG CR
					>
				)
				(<VERB? TRADE-FOR>
					<COND
						(<MC-PRSO? ,CH-IDIOT>
							<RFALSE>
						)
						(,NOW-PRSI
							<RT-IDIOT-TRADE ,PRSO ,PRSI>
						)
						(T
							<RT-IDIOT-TRADE ,PRSI ,PRSO>
						)
					>
				)
				(<TOUCH-VERB?>
					<SETG GL-IDIOT-MSG <>>
					<THIS-IS-IT ,CH-IDIOT>
					<TELL
The ,CH-IDIOT " smacks you on the head and says, \"Nasty" form ". Keep away
from my "
					>
					<SETG GL-IDIOT-STUFF T>
					<COND
						(,NOW-PRSI
							<TELL D ,PRSI>
						)
						(T
							<TELL D ,PRSO>
						)
					>
					<SETG GL-IDIOT-STUFF <>>
					<TELL ".\"" CR>
				)
			>
		)
		(.CONTEXT
			<RFALSE>
		)
		(,NOW-PRSI
			<COND
				(<VERB? GIVE TRADE-WITH SHOW>
					<RT-IDIOT-TRADE ,PRSO>
				)
			>
		)
		(<AND <VERB? TELL>
				,P-CONT
			>
			<RFALSE>
		)
		(<VERB? EXAMINE>
			<FSET ,CH-IDIOT ,FL-SEEN>
			<TELL
"The idiot smiles back at you with a lopsided grin, and continues to play with"
			>
			<RT-IDIOT-PLAY-MSG>
			<COND
				(<NOT <RT-I-IDIOT-MSG T>>
					<CRLF>
				)
			>
			<RTRUE>
		)
		(<VERB? LISTEN>
			<RT-I-IDIOT-MSG>
		)
		(<VERB? ASK-ABOUT>
			<SETG GL-IDIOT-MSG <>>
			<COND
				(<MC-PRSI? ,TH-ANYTHING>
					<TELL "\"I meant anything in the ">
					<HLIGHT ,K-H-BLD>
					<TELL "game">
					<HLIGHT ,K-H-NRM>
					<TELL ", stupid.\"" CR>
				)
				(<MC-PRSI? ,CH-BLUE-KNIGHT ,TH-BLUE-PAVILION>
					<TELL
"\"The Blue Knight likes it when you blow the horn. Sometimes I go there
in the middle of the night and play "
					>
					<HLIGHT ,K-H-ITL>
					<TELL "Bugler's Holiday.">
					<HLIGHT ,K-H-NRM>
					<TELL "\"" CR>
				)
				(<MC-PRSI? ,CH-RED-KNIGHT>
					<TELL
"\"He didn't want to be red, but all the other colours were taken, so they
made him.\"" CR
					>
				)
				(<MC-PRSI? ,CH-BLACK-KNIGHT>
					<TELL
"\"They usually are. But then they get brighter towards dawn.\"" CR
					>
				)
				(<MC-PRSI? ,CH-KRAKEN>
					<TELL
"\"He looks more like an octopus to me. Maybe Bates is too stupid to know
the difference.\"" CR
					>
				)
				(<MC-PRSI? ,CH-RAVEN>
					<TELL
"\"If he weren't quite so big, then he'd be a lot smaller.\"" CR
					>
				)
				(<MC-PRSI? ,CH-DRAGON>
					<TELL
"\"If you tickle his nose and then hold his mouth, he'll explode!\"" CR
					>
				)
				(<MC-PRSI? ,CH-PEASANT>
					<SETG GL-QUESTION 1>
					<TELL
"\"Why would I know anything about him?\" He looks at you strangely for a
minute. \"Hey! Are you just asking me stuff for the fun of it?\"" CR
					>
				)
				(<MC-PRSI? ,CH-BASILISK>
					<TELL
"The idiot looks in his pockets and then says, \"Sorry, I don't have any
with me right now.\"" CR
					>
				)
				(<MC-PRSI? ,CH-PRISONER>
					<TELL
"\"Big guy? Thick muscles? Used to run the smithy? Disappeared a couple days
ago? Never heard of him.\"" CR
					>
				)
				(<MC-PRSI? ,CH-DEMON>
					<TELL "\"He's cute when he's mad.\"" CR>
				)
				(<MC-PRSI? ,CH-NIMUE CH-GIRL>
					<SETUP-ORPHAN "ask idiot about ">
					<TELL
"\"Hubba-hubba! Hotcha-cha! Hot-diggity-dog! Don't spare the horses!
Remember the Maine! Exact change only! What were we talking about?\"" CR
					>
				)
				(<MC-PRSI? ,CH-LEPRECHAUN>
					<TELL
"The idiot wiggles his finger in his ear and says, \"Excuse me. I could have
sworn you just asked me about a leprechaun.\"" CR
					>
				)
				(<MC-PRSI? ,CH-PLAYER>
					<TELL
"\"Sorry. I haven't seen you. Maybe you should look somewhere else.\"" CR
					>
				)
				(<MC-PRSI? ,CH-RHYMER>
					<TELL
"\"He told me a poem once. 'There was an old woman who lived in a shoe. Then
a giant came along and put it on, and he squashed her.' It doesn't rhyme, but
he said it's because people shouldn't live in shoes - and so far, I
haven't.\"" CR
					>
				)
				(<MC-PRSI? ,CH-FARMERS>
					<TELL "\"They're in the tavern, plowing themselves under.\"" CR>
				)
				(<MC-PRSI? ,CH-COURTIERS>
					<TELL
"\"If I had known there was going to be a quiz, I wouldn't have studied
so hard!\"" CR
					>
				)
				(<MC-PRSI? ,CH-LOT>
					<TELL "The idiot frowns and says, \"He's not a very nice man.\"" CR>
				)
				(<MC-PRSI? ,CH-MERLIN>
					<TELL
"The idiot smiles and says, \"He's silly. Sometimes he turns me into a frog.\"" CR
					>
				)
				(<MC-PRSI? ,CH-COOK>
					<TELL
"\"He's only there to make the game harder. But don't tell him I said so.\"" CR
					>
				)
				(<MC-PRSI? ,CH-IDIOT>
					<TELL
"\"Hi! My name's Floyd. Ducks go quack and geese go honk. Your name's Arthur,
but I'm not supposed to know that because I'm an idiot.\"" CR
					>
				)
				(<MC-PRSI? ,CH-I-KNIGHT>
					<TELL "\"Sometimes he brings me presents, and we trade for them.\"" CR>
				)
				(<MC-PRSI?  ,CH-CELL-GUARD ,CH-SOLDIERS ,TH-SWORD ,TH-RED-LANCE
								,TH-GREEN-LANCE ,TH-ARMOUR ,TH-BLACK-ARMOUR
								,TH-POLLAXE ,TH-SHIELD
					>
					<TELL
"\"I don't have much use for soldiers or weapons. I do all my fighting with
my keen intellect and razor wit. Those are the only sharp things they let me
have.\"" CR
					>
				)
				(<MC-PRSI? ,TH-BOAR>
					<TELL
"\"Well, you're not very interesting, but I wouldn't go that far.\"" CR
					>
				)
				(<MC-PRSI? ,TH-BIRD>
					<SETG GL-QUESTION 1>
					<TELL "\"How many other 6'7\" white guys can shoot like that?\"" CR>
				)
				(<MC-PRSI? ,TH-APPLE>
					<TELL
"\"I don't think they should have sued, but what do I know - I'm just an
idiot.\"" CR
					>
				)
				(<MC-PRSI? ,TH-BELLS>
					<TELL "\"They've got a nice beat, but you can't dance to them.\"" CR>
				)
				(<MC-PRSI? ,TH-BRACELET>
					<TELL
"The idiot furrows his brow and thinks furiously for a moment. Then he says,
\"OK. Go ahead and ask me about the bracelet.\"" CR
					>
				)
				(<MC-PRSI? ,TH-BRASS-EGG ,TH-RAVEN-EGG>
					<SETG GL-QUESTION 1>
					<TELL "\"Are you sure you don't mean the ">
					<COND
						(<MC-PRSI? ,TH-BRASS-EGG>
							<TELL "raven's">
						)
						(T
							<TELL "brass">
						)
					>
					<TELL " egg? I get them confused.\"" CR>
				)
				(<MC-PRSI? ,TH-CRYSTAL-BALL>
					<TELL
"\"Sometimes, when Merlin's not around, I use it to go bowling.\"" CR
					>
				)
				(<MC-PRSI? ,TH-FLEECE>
					<TELL
"\"I used to have them too. But if you take enough baths, they go away.\"" CR
					>
				)
				(<MC-PRSI? ,TH-DRAGON-HAIR>
					<TELL "\"Yes! Yes! Exactly!\"" CR>
				)
				(<MC-PRSI? ,TH-CONKERS>
					<SETG GL-QUESTION 1>
					<TELL
"The idiot slaps himself on the forehead and says, \"Wow! Why didn't I think
of that?\"" CR
					>
				)
				(<MC-PRSI? ,TH-HAWTHORN>
					<TELL "\"You can't make me talk if I don't want to.\"" CR>
				)
				(<MC-PRSI? ,TH-HORN>
					<TELL "\"I hung it on a tree outside a pretty blue pavilion.\"" CR>
				)
				(<MC-PRSI? ,TH-HORSE ,TH-BLUE-HORSE>
					<TELL
"\"Well, let's see. It should have four legs - unless one is missing, in
which case it would only have three. But if two were missing, then it would
have two. Not the two that were missing, you understand, but the other two,
the ones that were left. After that, it gets pretty complicated.\"" CR
					>
				)
				(<MC-PRSI? ,TH-MAGIC-RING>
					<SETG GL-QUESTION 1>
					<TELL "\"Don't you think we should go steady first?\"" CR>
				)
				(<MC-PRSI? ,TH-OAK>
					<TELL
"The idiot claps his hands with glee and cries, \"I knew you were going to
ask me that!\"" CR
					>
				)
				(<MC-PRSI? ,TH-PASSWORD>
					<TELL
"\"I know what it is, because I can look in the game code when you're not
here. But I'm not supposed to tell you.\"" CR
					>
				)
				(<MC-PRSI? ,TH-PUMICE>
					<TELL
"\"The stones are quarried by a man named Proctor, who sells them to a man
named Gamble. But no one thinks anything will come of it.\"" CR
					>
				)
				(<MC-PRSI? ,TH-TUSK>
					<TELL
"\"I suppose you could put one where your nose is now. But it would be awfully
hard to see around.\"" CR
					>
				)
				(<MC-PRSI? ,TH-WHISKY TH-WHISKY-JUG ,TH-BEER ,TH-TANKARDS>
					<TELL "\"The more people drink, the more they understand me.\"" CR>
				)
				(<MC-PRSI? ,TH-JOUST>
					<TELL
"\"No thanks!\" the idiot says brightly. \"I always drop my lance a lot.\"" CR
					>
				)
				(<MC-PRSI? ,TH-BAG>
					<TELL
"\"I used to have one just like it, but a tester put it inside itself and it
disappeared.\"" CR
					>
				)
				(<MC-PRSI? ,TH-BARREL>
					<TELL
"\"I have a cousin named Beryl - but I guess that doesn't count.\"" CR
					>
				)
				(<MC-PRSI? ,TH-CAGE>
					<TELL
"\"If everyone lived in a cage, then there wouldn't be anyone who didn't.\"" CR
					>
				)
				(<MC-PRSI? ,TH-CASTLE-FIRE ,TH-COTTAGE-FIRE ,TH-TAVERN-FIRE>
					<SETG GL-QUESTION 1>
					<TELL
"\"When a fire goes out, where does it go? And who pays for the drinks?\"" CR
					>
				)
				(<MC-PRSI? ,TH-CRUTCH>
					<SETG GL-QUESTION 1>
					<TELL
"\"People use them to lean on when they break their legs. Geez, don't you
know anything?\"" CR
					>
				)
				(<MC-PRSI? ,TH-GHOSTS>
					<TELL "\"Ghosts don't exist - except for the ones that do.\"" CR>
				)
				(<MC-PRSI? ,TH-GLASS>
					<SETG GL-QUESTION 1>
					<TELL "\"Say, isn't that the piece of red glass from Sherlock?\"" CR>
				)
				(<MC-PRSI? ,TH-MANACLES>
					<TELL
"\"Geez, you know about them already? I haven't figured out how to get
through the bog yet.\"" CR
					>
				)
				(<MC-PRSI? ,TH-SCROLL>
					<TELL
"\"Scroll spelled backwards is llorcs, which is the Welsh name for nasty
creatures that live in adventure games.\"" CR
					>
				)
				(<MC-PRSI? ,TH-SLEAN ,TH-GAUNTLET>
					<TELL
"\"I know you need it to win the game, but they didn't tell me why.\"" CR
					>
				)
				(<MC-PRSI? ,TH-TORQUE ,TH-CRYSTAL>
					<TELL
"\"If you look in the crystal, you get a hint. But it's not as much fun
that way.\"" CR
					>
				)
				(<MC-PRSI?	,TH-MINNOW ,TH-MIDGES ,TH-CHEESE ,TH-SPICE
								,TH-SPICE-BOTTLE ,TH-DEAD-MOUSE ,TH-WEEDS
					>
					<TELL
"\"No thanks! If I eat anything now, I'll just be hungry again later.\"" CR
					>
				)
				(<MC-PRSI? ,TH-STONE>
					<TELL
"\"It's just a stone's throw from here, if you could throw a stone that far.\""
					>
				)
				(<MC-PRSI? ,RM-BOG>
					<TELL
"A cloud passes over the idiot's face. \"I dunno. Every time I go in there, I
get killed.\"" CR
					>
				)
				(<MC-PRSI? ,RM-TAVERN>
					<SETG GL-QUESTION 1>
					<TELL
"The idiot looks around nervously and says, \"What tavern?\"" CR
					>
				)
				(<MC-PRSI? ,RM-FORD>
					<TELL
"\"The T-bird is nice, but management's gone to hell since Iacocca left.\"" CR
					>
				)
				(<MC-PRSI? ,RM-CHURCH ,RM-CHURCHYARD>
					<TELL "\"That's where the dead people live.\"" CR>
				)
				(<MC-PRSI? ,RM-TOWN-SQUARE>
					<TELL
"\"It's prime real estate. I'm thinking of leasing the air rights to Trump.\"" CR
					>
				)
				(<MC-PRSI? ,TH-SKY ,RM-MEADOW ,TH-GROUND>
					<TELL
"\"Grass is green. The sky is blue. Some dragons are purple, and some are
not.\"" CR
					>
				)
				(<MC-PRSI?  ,LG-FOREST ,LG-ENCHANTED-TREES ,LG-CHASM ,LG-TOWER
								,RM-RAVEN-TREE ,RM-GLADE ,RM-GROVE ,TH-ROCK
								,TH-DIRECTIONS
					>
					<TELL ,K-IDIOT-DIRECTION-MSG>
				)
				(<MC-PRSI? ,LG-CASTLE-GATE ,LG-CHURCH-GATE>
					<TELL
"\"I don't know much about gates - except for all that secret stuff about
Bill Gates, but I'm not supposed to tell.\"" CR
					>
				)
				(<MC-PRSI? ,LG-PEAT ,TH-PEAT-BRICK>
					<TELL
"\"I peat. You peat. He, she or it peats. We peat, you peat, they peat.
Pretty good, huh? Ask me another.\"" CR
					>
				)
				(<MC-PRSI? ,LG-THATCH>
					<TELL "\"It's sorta like hair, except it's harder to scratch.\"" CR>
				)
				(<MC-PRSI? ,LG-TOWN>
					<TELL
"\"It's an OK burg, I guess. But it's not nearly as exciting as Blicester
on Rumpleston.\"" CR
					>
				)
				(<MC-PRSI? ,LG-CASTLE>
					<TELL
"\"It's a fun place to play. It's got secret passages and everything.\"" CR
					>
				)
				(<MC-PRSI? ,TH-EXCALIBUR>
					<SETG GL-QUESTION 1>
					<TELL "\"I don't think I know it. Could you hum a few bars?\"" CR>
				)
				(<MC-PRSI? ,TH-SHERLOCK>
					<TELL "\"It was lots of fun. I got to drive the growler cab.\"" CR>
				)
				(<MC-PRSI? ,ZORK>
					<TELL
"\"I fell asleep in the kitchen and when I woke up, the game was over.\"" CR
					>
				)
				(<MC-PRSI? ,TH-STATIONFALL>
					<TELL "\"It's even more fun than hider-seeker!\"" CR>
				)
				(<MC-PRSI? ,TH-BECK>
					<TELL "\"It tickles when he types on me.\"" CR>
				)
				(<MC-PRSI? ,TH-BATES>
					<TELL
"\"If he had any real creativity, he would have made up his own character,
instead of stealing me from Meretzky.\"" CR
					>
				)
				(<MC-PRSI? ,TH-MERETZKY>
					<TELL
"The idiot puffs out his chest with pride and says, \"He's my daddy!\"" CR
					>
				)
				(<MC-PRSI? ,INFOCOM>
					<TELL "\"Somehow, I seem to fit right in.\"" CR>
				)
				(<OR  <FSET? ,PRSI ,FL-KEY>
						<MC-PRSI? ,TH-CUPBOARD>
					>
					<TELL
"\"I have a simple way of remembering which key fits where. Just say to
yourself, 'Every Good Boy Deserves Favour.' Then take the first letters
and swap them with the last letters, multiply by nine-fifths and add
thirty-two. Whatever is left over at the end is the answer.\"" CR
					>
				)
				(<FSET? ,PRSI ,FL-DOOR>
					<TELL
"\"I know all about doors. If you're standing behind one when you close it,
you can get your nose stuck in the crack.\"" CR
					>
				)
				(<IN? ,PRSI ,ROOMS>
					<TELL "\"Oooh. I haven't been THERE in ages.\"" CR>
				)
				(T
					<RT-IDIOT-WHISPERS-MSG>
				)
			>
		)
		(<VERB? ASK-FOR>
			<SETG GL-IDIOT-MSG <>>
			<COND
				(<MC-PRSI? ,TH-DIRECTIONS>
					<TELL ,K-IDIOT-DIRECTION-MSG>
				)
				(T
					<TELL
The+verb ,CH-IDIOT "look" " puzzled, and says, \"I'd give" him ,PRSI " to
you, but I don't have" him ,PRSI ".\"" CR
					>
				)
			>
		)
		(<AND <SPEAKING-VERB?>
				<IN? ,CH-IDIOT ,HERE>
			>
			<RT-IDIOT-WHISPERS-MSG>
		)
		(<VERB? ATTACK>
			<COND
				(<MC-FORM? ,K-FORM-ARTHUR>
					<MOVE ,CH-MERLIN ,HERE>
					<TELL
"The idiot is powerless to stop your attack, and you slay him mercilessly. "
,K-MERLIN-WASTED-MSG CR
					>
					<RT-END-OF-GAME>
				)
			>
		)
		(<VERB? EAT>
			<TELL
"You gnaw briefly on the idiot's leg, but quit when he begins to put salt
and pepper on your"
			>
			<COND
				(<MC-FORM? ,K-FORM-ARTHUR>
					<TELL "arm">
				)
				(T
					<TELL "tail">
				)
			>
			<TELL "." CR>
		)
	>
>

<ROUTINE RT-IDIOT-PLAY-MSG ("AUX" N (OBJ <>))
	<SET N <ZGET ,K-IDIOT-OBJ-TBL 0>>
	<REPEAT ((I 0) (1ST? T))
		<COND
			(<IGRTR? I .N>
				<RETURN>
			)
			(T
				<COND
					(.1ST?
						<SET 1ST? <>>
					)
					(T
						<TELL comma <NOT <EQUAL? .I .N>>>
					)
				>
				<SET OBJ <ZGET ,K-IDIOT-OBJ-TBL .I>>
				<TELL a .OBJ>
			)
		>
	>
	<TELL " that lie">
	<COND
		(<AND <EQUAL? .N 1>
				.OBJ
				<OR
					<NOT <FSET? .OBJ ,FL-PLURAL>>
					<FSET? .OBJ ,FL-COLLECTIVE>
				>
			>
			<TELL "s">
		)
	>
	<TELL " at his feet.">
>

<ROUTINE RT-IDIOT-WHISPERS-MSG ()
	<SETG GL-IDIOT-MSG <>>
	<TELL
"The idiot looks around to make sure no one is watching the two of you.
Beckoning you to come closer, he whispers in your ear,"
<RT-PICK-NEXT ,K-IDIOT-MSG-TBL> CR
	>
>

<GLOBAL GL-IDIOT-MSG:FLAG T <> BYTE>

<CONSTANT K-IDIOT-MSG-TBL
	<TABLE (PATTERN (BYTE WORD))
		<BYTE 1>
		<TABLE (PURE LENGTH)
			" \"Beware the Invisible Knight.\""
			" \"I'm not as dumb as you look. Go ahead. Ask me about anything.\""
			" \"Wherever I go, there I am.\""
			" \"King Lot is a greedy goat.\""
			" \"I'm not really an idiot. I'm just extremely stupid.\""
			" \"Sometimes my invisible playmate gives me things.\""
			"|   \"Roses are red,|    Violets are blue.|    I'm schizophrenic,|    And so am I.\""
			" \"When the tough get tough, the going get going.\""
		>
	>
>

<GLOBAL GL-IDIOT-WAIT:FLAG <> <> BYTE>

<ROUTINE RT-I-IDIOT-MSG ("OPT" (SP? <>))
	<COND
		(<NOT <MC-HERE? ,RM-TOWN-SQUARE>>
			<RFALSE>
		)
		(<AND <VERB? WAIT>
				,GL-IDIOT-WAIT
			>
			<RFALSE>
		)
	>
	<COND
		(<FSET? ,CH-PLAYER ,FL-ASLEEP>
			<RT-QUEUE ,RT-I-IDIOT-MSG <+ <RT-IS-QUEUED? ,RT-I-SLEEP> 1>>
			<RFALSE>
		)
		(,GL-CLK-RUN
			<RT-QUEUE ,RT-I-IDIOT-MSG <+ ,GL-MOVES 1>>
		)
	>
	<COND
		(<VERB? WAIT>
			<SETG GL-IDIOT-WAIT T>
			<THIS-IS-IT ,CH-IDIOT>
			<TELL
"|While you wait," the ,CH-IDIOT " mumbles quietly to himself." CR
			>
			<RFALSE>
		)
		(,GL-IDIOT-MSG
			<SETG GL-IDIOT-WAIT <>>
			<THIS-IS-IT ,CH-IDIOT>
			<COND
				(,GL-CLK-RUN
					<TELL CR The ,CH-IDIOT>
				)
				(T
					<SETG GL-IDIOT-MSG <>>
					<COND
						(.SP?
							<TELL " ">
						)
					>
					<TELL He ,CH-IDIOT>
				)
			>
			<TELL " mumbles," <RT-PICK-NEXT ,K-IDIOT-MSG-TBL> CR>
		)
	>
>

<CONSTANT K-IDIOT-OBJ-MAX 5>	; "Max num of objs in K-IDIOT-OBJ-TBL"
<CONSTANT K-IDIOT-BYTE-MAX <* ,K-IDIOT-OBJ-MAX 2>>
<CONSTANT K-IDIOT-OBJ-TBL
	<TABLE
		1
		TH-DEAD-MOUSE
		0
		0
		0
		0
	>
>

<ROUTINE RT-IDIOT-TRADE (OBJ "OPT" (ID <>))
	<COND
		(<NOT .ID>
			<SET ID <ZGET ,K-IDIOT-OBJ-TBL <RANDOM <ZGET ,K-IDIOT-OBJ-TBL 0>>>>
		)
	>
	<COND
		(<EQUAL? .OBJ .ID>
			<SETG GL-IDIOT-MSG <>>
			<TELL The ,CH-IDIOT " looks puzzled." CR>
			<RT-AUTHOR-MSG "Stop trying to confuse the poor boy.">
		)
		(<IN? .OBJ ,CH-IDIOT>
			<SETG GL-IDIOT-MSG <>>
			<TELL
The ,CH-IDIOT " carefully exchanges" the .OBJ " with" the .ID "." CR
			>
			<RT-AUTHOR-MSG "The idiot isn't as dumb as you look.">
		)
		(<NOT <FSET? .OBJ ,FL-TAKEABLE>>
			<SETG GL-IDIOT-MSG <>>
			<TELL
The ,CH-IDIOT " says, \"Hey, you can't trade" the .OBJ ".\"" CR
			>
		)
		(<RT-NOT-HOLDING-MSG? .OBJ>
			T
		)
		(T
			<RT-IDIOT-GIVE .ID>
			<RT-IDIOT-TAKE .OBJ>
			<SETG GL-IDIOT-MSG <>>
			<TELL "\"Oooh look! ">
			<SETG GL-IDIOT-STUFF T>
			<TELL A .OBJ>
			<SETG GL-IDIOT-STUFF <>>
			<TELL
"!\" " The ,CH-IDIOT " takes" the .OBJ " and gives you" the .ID "." CR
			>
			<SETG GL-UPDATE-WINDOW <BOR ,GL-UPDATE-WINDOW ,K-UPD-INVT ,K-UPD-DESC>>
			<COND
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-INVT>
					<RT-UPDATE-INVT-WINDOW>
				)
				(<EQUAL? ,GL-WINDOW-TYPE ,K-WIN-DESC>
					<RT-UPDATE-DESC-WINDOW>
				)
			>
			<RTRUE>
		)
	>
>

<ROUTINE RT-IDIOT-TAKE (OBJ "AUX" N)
	<MOVE .OBJ ,CH-IDIOT>
	<FSET .OBJ ,FL-NO-LIST>
	<SET N <+ <ZGET ,K-IDIOT-OBJ-TBL 0> 1>>
	<ZPUT ,K-IDIOT-OBJ-TBL 0 .N>
	<ZPUT ,K-IDIOT-OBJ-TBL .N .OBJ>
>

<ROUTINE RT-IDIOT-GIVE (OBJ "OPT" (PERSON ,CH-PLAYER) "AUX" L N PTR)
	<MOVE .OBJ .PERSON>
	<FCLEAR .OBJ ,FL-NO-LIST>
	<SET N <ZGET ,K-IDIOT-OBJ-TBL 0>>
	<COND
		(<SET PTR <INTBL? .OBJ <ZREST ,K-IDIOT-OBJ-TBL 2> .N>>
			<COND
				(<G? <SET L <- <ZREST ,K-IDIOT-OBJ-TBL ,K-IDIOT-BYTE-MAX> .PTR>> 0>
					<COPYT <ZREST .PTR 2> .PTR .L>
				)
			>
			<ZPUT ,K-IDIOT-OBJ-TBL ,K-IDIOT-OBJ-MAX 0>
			<ZPUT ,K-IDIOT-OBJ-TBL 0 <- .N 1>>
		)
	>
>

;"***************************************************************************"
; "end of file"
;"***************************************************************************"

