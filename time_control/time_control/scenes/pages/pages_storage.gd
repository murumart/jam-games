class_name StoredPages

const IMAGE_PATH := "res://scenes/pages/%s.png"

const NEXT := &"==>"


static var pages : Dictionary = {
	0: [
		"""This is the beginning of the week. Not much to do here.""",
		[NEXT],
		"0",
		[1],
		0
	],

	3: [
		"""You are a person gifted with a "spirit" "imprinted" to you.
This makes you someone known as a "spirit master".
Your own spirit has the power to travel to the future and to the past with you.
Within the confines of this current week, at least. """,
		[NEXT],
		"3"
	],

	4: [
		"""You can also sporadically see what will happen and has happened during the week.
And it seems like there's gonna be trouble in 7 days from now.
Big trouble...
Like, "you will die along with most people in the city" kind of trouble. """,
		["Get shot", "Be lawnmowed"],
		"4"
	],

	5: [
		"""It's not as easy as that. If you want to choose how you'll die, you have to intercept fate.
You'll have to travel in the temporal dimension and make sure to change things accordingly.
Don't worry, you can hop around time as long as you're still alive. """,
		["Darn. I hate effort"],
		"5"
	],

	6: [
		"""Unfortunately, you can't really live without some effort. And in your case, you can't die either.

Not that I'd imagine that you'd want to die. Maybe there is still hope...""",
		["Jump out of the window"],
		"5"
	],

	7: [
		"""There are no windows, remember? Try to keep up.
""",
		["Look out the window"],
		"2"
	],

	8: [
		"""You live in the beautiful small city of [CITY NAME HERE]. The view from the window reveals old buildings, along with the sea in the background, stretching towards the horizon.

Today is a sunny day. The whole week will be sunny.
""",
		["Go outside"],
		"6"
	],

	9 : [
		"""You jump out the window.""",
		[NEXT],
		"7"
	],

	10 : [
		"""Now, it would be quite silly of me to end the game here, after you splatter on the ground.

Surely there is more to this unconcealed homestuck reference. """,
		["Time Control"],
		"8"
	],

	11 : [
		"""

		 """,
		["HOP"],
		"9"
	],

	12 : [
		"""Your spirit power, HOP, has the ability to travel in time within the current week.
You however cannot hop back from death.
And you just hopped out of a 6-story building.

I suppose you won't have to worry about the weekend apocalypse for much longer, then.
		 """,
		["4 hours ago..."],
		"10"
	],

	13 : [
		"""Absolute control over time and occasional absolute perception of everything in time.
		""",
		[NEXT],
		"11"
	],

	14 : [
		"""You don't need much else to know that a while ago...
		""",
		[NEXT],
		"12"
	],

	15 : [
		"""... a truck carrying pillows went by under your window.
		""",
		[NEXT],
		"13"
	],

	16 : [
		"""An open truck carrying pillows is a bad idea, since it can rain. So the pillows are wet and soggy.
But you're alive. At least you've got that.
		""",
		["Take a look around the city"],
		"14"
	],

	17 : [
		"""I can't be bothered to draw the city properly. Where to next?""",
		["Residency", "Commerce", "Industry"],
		"15",
		[100, 200, 300]
	],

	100 : [
		"""We are now in the residential district of the city.""",
		["Go visit grandma"],
		"residential",
		[101],
		17
	],

	101 : [
		"""Here we are. She is happy to see you. You love your grandma.""",
		["Help her with stuff"],
		"r1",
	],

	102 : [
		"""You spend a few days helping her with household chores and stuff. It's great for taking your mind off the fact that most people in town will die soon.""",
		["Watch TV with her"],
		"r2",
	],

	103 : [
		"""This TV sucks. It's honestly so bad. Your eyes are starting to water. How can she stand this?""",
		[NEXT],
		"r3",
	],

	104 : [
		"""The quality is like something from the 2000s. Surprising it's not in greyscale.""",
		["Plot getting a new TV"],
		"r4",
	],

	105 : [
		"""Grandma deserves better than this. You have to get a newer and better TV if you can call yourself a caring grandson.""",
		["Have a premonition"],
		"r5",
	],

	106 : [
		"""A perfect moment for one! A dumb alternate timeline past self is robbing a store sometime. You could take the TV and frame him!""",
		["Delightfully devilish!"],
		"r6",
	],

	107 : [
		"""Indeed! And you spare no time for thinking about how your power suddenly also can cross into alternate timelines (hint: it's grandma's vegetables that unlocked this)!""",
		["Alert the past alternate police"],
		"r5",
	],

	108 : [
		"""You inform the police that a criminal will attempt a robbery in a TV store in a few hours. You don't forget to wear a ski mask, to hide the fact that you and the robber have the same face.

They trust you completely!""",
		["Acquire the TV"],
		"r7",
	],

	109 : [
		"""Look at that dumb dolt. He has no idea what's going to happen to him.""",
		[NEXT],
		"c5",
	],

	110 : [
		"""You leave him crying on the floor. God, your past selves are so dumb. This is why you avoid contact with them.""",
		["TV time"],
		"c24",
	],

	111 : [
		"""Now you and grandma can watch some proper high quality television.""",
		["Check the room"],
		"r3",
	],

	112 : [
		"""You notice that the vegetable bowl that you had been snacking from periodically is empty. There is also a note on the table, addressed to you.""",
		["Read the note"],
		"r8",
	],

	113 : [
		"""The note reads as follows:
"Dear past alternate me,
You are stupid. This is all your fault.
Yours truly,
MTY" """,
		["Who is MTY??"],
		"r9",
	],

	114 : [
		"""It obviously stands for "Master Timeline You".
Damn, you hate dealing with future selves. They all think they are soooo high and mighty. And even worse, a you from the "Master Timeline"? That's as snobbish as it can get, really. """,
		[NEXT],
		"r10",
	],

	115 : [
		"""But then again, if Master Timeline you has seen the entire week from multiple perspectives and timelines, he must be knowledgeable? Maybe you did screw up by time traveling somewhere? Maybe the TV robbery set off some horrible sequence of events? """,
		["Timeskip!"],
		"r10",
	],

	116 : [
		"""You were spooked enough by MTY's pissy letter that you decided to hold off on time-hopping for the rest of the week. So now it's the end of the week.""",
		[NEXT],
		"r11"
	],

	117 : [
		"""Out over there is the apocalypse.""",
		[NEXT],
		"r12",
		[118],
		116,
		preload("res://scenes/pages/220/ambient.ogg")
	],

	118 : [
		"""You wonder...""",
		[NEXT],
		"r13",
		[119],
		117,
		preload("res://scenes/pages/220/ambient.ogg")
	],

	119 : [
		"""What has MTY seen? What stemmed from your fooling around in time?""",
		[NEXT],
		"r13",
		[120],
		118,
		preload("res://scenes/pages/220/ambient.ogg")
	],

	120 : [
		"""His letter never outright said "stop time traveling". All it really did was sour your mood, so that's how you interpreted it.""",
		[NEXT],
		"r13",
		[121],
		119,
		preload("res://scenes/pages/220/ambient.ogg")
	],

	121 : [
		"""But really, time has run out. You have to do something now.""",
		[NEXT],
		"r13",
		[122],
		120,
		preload("res://scenes/pages/220/ambient.ogg")
	],

	122 : [
		"""Your grandma.""",
		[NEXT],
		"r13",
		[123],
		121,
		preload("res://scenes/pages/220/ambient.ogg")
	],

	123 : [
		"""You'd really prefer to not watch her die.""",
		["Escape"],
		"r14",
		[124],
		122,
	],

	124: [
		"""Time to escape to another time. You haven't really tried transporting multiple people through time. But judging by the colours, something is happening! """,
		["HOP back in time"],
		"r15",
	],

	125: [
		"""That was unbelievably stupid, actually. You and grandma traveled back in time around one day and now there are two grandmas. It's amazing how little foresight you have, despite being able to travel to and see (sometimes) the future. """,
		["Undo that"],
		"r16",
	],

	126: [
		"""You go back in time - I mean, forward in time. But you forget to bring grandma with you. So she was left behind. """,
		["Contemplate the logic of time travel"],
		"r12",
	],

	127: [
		"""By all sense and logic, you should be still seeing two grandmas, because in the past there were two of them. But it seems that created a new timeline instead, and now, hopping back without grandma created another one? How do you keep track of this shit??""",
		["Damn"],
		"r17",
	],

	128: [
		"""You'd better go back and see what you can do about the double grandma problem.""",
		["Yeah do that"],
		"r12",
	],

	129: [
		"""WHAT THE HELL""",
		["Wtf."],
		"r18",
	],

	131: [
		""""I am from the Master Timeline, because I killed my grandma when it became clear that shit was gonna go bad. Then I realised my mistake, and while attempting to bring back grandma, discovered some interesting things." """,
		[NEXT],
		"r19",
	],

	132: [
		""""The vegetables from grandma's vegetable bowl temporarily unlock HOP's hidden power of jumping between timelines. I used this and tricked a bunch of myself to going to the master timeline form an army, while storing all grandmas here." """,
		[NEXT],
		"r19",
	],

	133: [
		""""This army will be used to save the day. And the city and perhaps even the world." """,
		[NEXT],
		"r19",
	],

	134: [
		""""In related news, you're drafted. See you on the battlefield." """,
		["Darn"],
		"r19",
	],

	135: [
		"""You are cannon fodder. """,
		["The End"],
		"bigman/bg",
		[667],
		135
	],

	200 : [
		"""We are now in the commercial district of the city.""",
		["Check out TV ads"],
		"commercial",
		[201],
		17
	],

	201 : [
		"""You take a closer look on the ads aired in the TVs on show behind shop windows.

Nothing suggests the nearing doom as you know it.""",
		["Rob the store"],
		"c1",
	],

	202 : [
		"""Might as well. There are no consequences to it with your power, after all.""",
		[NEXT],
		"c2",
	],

	203 : [
		"""You HAVE the TV.""",
		[NEXT],
		"c3",
	],

	204 : [
		"""Huh?""",
		[NEXT],
		"c4",
	],

	205 : [
		"""Oh, wow. It's you from the future. Looks like he also wants the TV. For some reason.

Usually, you avoid contact with future selves. But this time, the TV is on the line. What to do...""",
		["Fight him", "Persuade him"],
		"c5",
		[206, 250]
	],

	206 : [
		"""You decide to engage your future self in a fight to the death, over the TV.

You can feel the smidgens of developed and logical personality you had slip away forever.""",
		[NEXT],
		"c6",
	],

	207 : [
		"""You lose horribly. Of course your future self would have had more experience with brawling. Stupid to even try fighting him.""",
		[NEXT],
		"c7",
	],

	208 : [
		"""And he prances away victoriously with the TV. Bye, I guess...""",
		[NEXT],
		"c8",
	],

	209 : [
		"""And now. The police are involved.

They can't BELIEVE what you made take place.""",
		["I'm begging you to stop referencing homestuck"],
		"c9",
	],

	210 : [
		"""Okay asshole. What do we do now though.""",
		["Use HOP to hop away to safety!"],
		"c9",
	],

	211 : [
		"""You travel back in time a few more hours, but it looks like the police had been informed that you'd appear there at that moment! And they are intending to catch you! Who told them that!
""",
		["Go to prison"],
		"c10",
	],

	212 : [
		"""You could've tried HOPping away, you know. But you're in prison now. Oh well. I guess you don't feel like escaping yourself.
""",
		["Get broken out of prison"],
		"c11",
	],

	213 : [
		"""You wait for six days. Oh look, someone actually showed up to break you out.
""",
		["Follow the stranger"],
		"c12",
	],

	214 : [
		"""That was really easy actually, breaking out of prison. All the guards just were not there. Did he do something with them?
""",
		["Follow the stranger"],
		"c13",
		[215],
		214
	],

	215 : [
		"""He seems to keep arguing out loud with himself about something. Doesn't he care what you think? Because you're a bit creeped out.

You feel compelled to follow still.
""",
		["Follow the stranger"],
		"c14",
	],

	216 : [
		"""You reach the stranger's base of operations. He explains that he has had his eye over you for a while now, because your time-hopping powers could prove useful to him.
Luckily for you, he is not a vampire, so he can't just steal your power for himself.

You have been employed. No arguing that.
""",
		["Obey the stranger"],
		"c15",
		[217],
		216
	],

	217 : [
		"""While your new master plans nefariously, you are left to your own devices.

Also, you got this cool cape outfit and these neat pink shades.
""",
		["Study the blade"],
		"c16",
	],

	218 : [
		"""You realise this is like the most egregious Homestuck reference yet.
""",
		["This sucks"],
		"c17",
	],

	219 : [
		"""You spend the next day training up your cool sword skillz for the Big Event, as your employer calls it.

Turns out your employer is in fact the main cause of the weekend apocalypse that you saw in a premonition earlier.
""",
		["The big event?"],
		"c18",
	],

	220 : [
		"""Your master knows more about spirit mechanisms than you do.

But from what you can tell, the indiscriminate bloodbath that is going to happen is for luring out a specific kind of spirit.
""",
		[NEXT],
		"bigman/bg2",
		[221],
		219,
		preload("res://scenes/pages/220/ambient.ogg")
	],

	221 : [
		"""One with which your employer could become unstoppable, rule the world, etc..

The usual villanous plan.
""",
		[NEXT],
		"bigman/bg2",
		[222],
		220,
		preload("res://scenes/pages/220/ambient.ogg")
	],

	222 : [
		"""Usually, you would be against these sorts of nefarious plots. The loss of life, especially on such a scale, is very upsetting. But your employer, at the same time, is very... convincing.

You feel safer here than ever before, anywhere.
""",
		[NEXT],
		"c19",
		[223],
		221,
		preload("res://scenes/pages/220/ambient.ogg")
	],

	223 : [
		"""Seriously, how could you ever have thought that you could live a normal life down there? With the laypeople and the powerless?
People fear what they don't understand. Fear leads to hatred and violence.

And they certainly don't understand you.
""",
		[NEXT],
		"c20",
		[224],
		222,
		preload("res://scenes/pages/220/ambient.ogg")
	],

	224 : [
		"""You were very lucky and should be thankful that he found you, and took care of you, and enlightened you. Even if it's just been less than two days, you would give everything, do anything for him.
You are thankful. You are thankful...
""",
		[NEXT],
		"c20",
		[225],
		223,
		preload("res://scenes/pages/220/ambient.ogg")
	],

	225 : [
		"""You are THANKFUL that someone recognised your true power.
And SAVED you.
And ENLIGHTENED you.
...
""",
		[NEXT],
		"c21",
		[226],
		224,
		preload("res://scenes/pages/220/ambient.ogg")
	],

	226 : [
		"""...damn it...
""",
		[NEXT],
		"c21",
		[227],
		225,
		preload("res://scenes/pages/220/ambient.ogg")
	],

	227 : [
		"""You can feel your master's wonderful power subsiding.

To believe the truth, you only have yourself to rely on now.
""",
		[NEXT],
		"c22",
		[228],
		226,
		preload("res://scenes/pages/220/ambient.ogg")
	],

	228 : [
		"""Thankful. Thankful.
""",
		[NEXT],
		"c22",
		[229],
		227,
		preload("res://scenes/pages/220/ambient.ogg")
	],

	229 : [
		"""Where did he go? It must've begun already.
""",
		["The End"],
		"c22",
		[667],
		228,
	],

	250: [
		"""You attempt to persuade your future self to let you keep the TV. Unfortunately, your arguments fall flat, because there really is no reason for you to steal it.""",
		[NEXT],
		"c5"
	],

	251: [
		"""And he, of course, argues that this TV is for his grandma, who is also your grandma, and you love your grandma. In the end, you must concur that his use case for the TV is the best possible.""",
		[NEXT],
		"c23"
	],

	252: [
		"""He leaves you behind, defeated. This is why you never interact with future selves. They are always better than you, in every way.""",
		[NEXT],
		"c24"
	],

	253: [
		"""And now the police are here. Great.""",
		["Go to prison"],
		"c25",
		[212]
	],

	300 : [
		"""We are now in the industrial district of the city.""",
		["Check out abandoned building"],
		"industrial",
		[301],
		17
	],

	301 : [
		"""Abandoned buildings are always so cool. You go inside one.""",
		[NEXT],
		"i1"
	],

	302 : [
		"""It's like a maze in here.""",
		["Explore"],
		"i2"
	],

	303 : [
		"""What a cool and unique room.""",
		["Explore"],
		"i3"
	],

	304 : [
		"""Woooooah. (free me from this torture)""",
		["Explore"],
		"i4"
	],

	305 : [
		"""At another unique junction, you catch a glimpse of yourself. You hide in a corner to not be seen. Future selves are annoyingly better than you, so you avoid them.""",
		["Explore"],
		"i5"
	],

	306 : [
		"""You come across an open doorframe. You can hear a faint conversation in the room.""",
		["Sneak inside"],
		"i6"
	],

	307 : [
		"""It's some Shady Figures discussing Nefarious Plans.""",
		["Be found out and attacked"],
		"i7"
	],

	308 : [
		"""You don't need to be told that twice. This vampiric ghoul attacks you and the plotters begin shouting.""",
		["HOP away!"],
		"i8"
	],

	309 : [
		"""You don't need to be told that twice.""",
		[NEXT],
		"i9"
	],

	310 : [
		"""Escaping out the labyrinthine corridors, you wonder where your past self is. You'd like to kick him a bit for being a dumbass and coming here. But you remember that you never saw your past self, rather, your past self remained hidden to your future self, but you're the future self now, so you won't be seeing your past self here.""",
		[NEXT],
		"i5"
	],

	311 : [
		"""You spend a moment dispairing at the realisation that the ruthless passage of time keeps outdating your current self, turning you from the perfect future self into the stupid dumbass past self.""",
		[NEXT],
		"i3"
	],

	312 : [
		"""It is terrifying, what people are up to these days...""",
		[NEXT],
		"i1"
	],

	313: [
		"""You should probably alert the authorities.""",
		["Think about it"],
		"i1"
	],

	314: [
		"""But then again, if the villains have been left to their own devices for so long, maybe the authorities already know of this and aren't doing anything?""",
		[NEXT],
		"r17"
	],

	315: [
		"""So, wouldn't it be - you can feel the thoughts wriggling around in your head -""",
		[NEXT],
		"r17"
	],

	316: [
		"""- most SENSIBLE to try and stop them yourself? Man, you're a genius!""",
		[NEXT],
		"r17"
	],

	317: [
		"""Your future self shows up and tells you how much of a dumbass you are.""",
		[NEXT],
		"i10"
	],

	318: [
		"""Of course, you both know that if the future self knows that, he must've also tried stopping the villains, to no avail, and then came here to warn you about it, but for that to happen you still have to go and hassle the schemers to have the experience to come back and yell at a past self in the future.""",
		[NEXT],
		"i10"
	],

	319: [
		"""It is futile.""",
		["Hassle the schemers"],
		"i10"
	],

	320: [
		"""For a moment you almost stop to think of the fact that paradoxes don't really happen. If you would've heeded future you's warning, you would've been safe and future you would have just disappeared. You didn't have to repeat future you's mistakes just because you'd need to make those mistakes to warn yourself about them.
This all is way too complicated of a thought process for you. Very uncharacteristic. So, again, you don't actually think this.""",
		["Hassle the schemers"],
		"r17"
	],

	321: [
		"""""",
		[NEXT],
		"i11"
	],

	322: [
		"""""",
		[NEXT],
		"i12"
	],

	323: [
		"""""",
		[NEXT],
		"i13"
	],

	324: [
		"""You stole their table.""",
		["Inspect plans and documents"],
		"i14"
	],

	325: [
		"""Woah... it seems like those guys were aware of the weekend apocalypse in the city. Their info on it... """,
		[NEXT],
		"i15"
	],

	326: [
		"""Something about exploiting the spirits' lust for blood to lure out and complete an ancient power hidden within Mana? Mana is, like, the dimension where spirits reside and get energy from. You learned this in basic school. """,
		[NEXT],
		"i16"
	],

	327: [
		"""The plan is to simultaneously kill the several thousand spirit masters in the city. Many of them were lured here recently, somehow... All the death and suddenly freed spirits together... This is what the plotter is betting on, this somehow breaches into Mana and brings forth one horrible thing after another.""",
		[NEXT],
		"i16"
	],

	328: [
		"""Those guys seem to be at odds with the actual perpetrator, though. They look to be ex-lackeys of him that really don't want to die at the end of the week. Who knew that people don't want to die. """,
		["Plot to ally with the rebels"],
		"i14"
	],

	329: [
		"""You decide you have to get in touch with the guys more. Surely your power could help them in some way. """,
		[NEXT],
		"i14"
	],

	330: [
		"""""",
		[NEXT],
		"i17"
	],

	331: [
		"""""",
		[NEXT],
		"i18"
	],

	332: [
		"""Before you do that, you tick off your stupid past self to ensure that he also does all this. You are on the right path.""",
		[NEXT],
		"i10"
	],

	333: [
		"""And here you are, with the rebels. Happy happy! It was so easy becoming their ally and friend.""",
		["Spend the week plotting"],
		"i19"
	],

	334: [
		"""You do that. See you.""",
		["The End"],
		"bigman/bg2",
		[667]
	],
}


class StoredPage:
	var text := ""
	var next_choices : Array[StringName] = [&"-->"]
	var image := ""
	var previous := 0
	var next : Array[int] = []
	var music : AudioStream


	func _init(which: int) -> void:
		var array := StoredPages.pages.get(which) as Array
		text = array[0]
		next_choices.clear()
		next_choices.append_array(array[1])
		array.resize(6)
		if not array[3]:
			array[3] = []
			for i in next_choices.size():
				array[3].append(which + 1)
		if not array[4]:
			array[4] = maxi(which - 1, 0)
		previous = array[4]
		next.append_array(array[3])
		music = (array[5])

		image = array[2]
