extends Resource
class_name riddle_library

var phone:Dictionary = {
	"riddle":"What has many rings but no fingers?",
	"answers":["a telephone","telephone","phone","cellphone","cell phone","cellular phone"]
}
var age:Dictionary = {
	"riddle":"What goes up but never comes back down?",
	"answers":["your age", "age"]
}
var mirror:Dictionary = {
	"riddle":"If you drop me, I’m sure to crack, but smile at me and I’ll smile back. What am I?",
	"answers":["mirror", "a mirror"]
}
var breakfast:Dictionary = {
	"riddle":"What can you never eat for breakfast?",
	"answers":["lunch", "dinner", "brunch", "supper"]
}
var clock:Dictionary = {
	"riddle":"What has hands and a face, but can’t hold anything or smile?",
	"answers":["a clock", "clock","watch", "a watch"]
}
var promise:Dictionary = {
	"riddle":"What can you break, even if you never pick it up or touch it?",
	"answers":["a promise", "promise"]
}
var anchor:Dictionary = {
	"riddle":"What do you throw out when you want to use it, but take in when you don't want to use it?",
	"answers":["an anchor", "anchor"]
}
var name:Dictionary = {
	"riddle":"What belongs to you, but your friends use it more. What is it?",
	"answers":["your name", "my name", "name", "nickname"]
}
var coin:Dictionary = {
	"riddle":"I have a tail and a head, but no body. What am I?",
	"answers":["a coin", "coin"]
}
var piano:Dictionary = {
	"riddle":"What has keys but can't open locks?",
	"answers":["a piano", "piano"]
}
var sponge:Dictionary = {
	"riddle":"I am full of holes but still holds water, What am I?",
	"answers":["a sponge", "sponge"]
}
var comb:Dictionary = {
	"riddle":"What has many teeth, but can’t bite?",
	"answers":["a comb", "comb"]
}
var deck:Dictionary = {
	"riddle":"What is cut on a table, but is never eaten?",
	"answers":["a deck of card", "cards", "deck"]
}
var book:Dictionary = {
	"riddle":"What has words, but never speaks?",
	"answers":["a book", "book"]
}
var fence:Dictionary = {
	"riddle":"What runs all around a backyard, yet never moves?",
	"answers":["a fence", "fence"]
}
var river:Dictionary = {
	"riddle":"I have no legs. I will never walk but always run. What am I?",
	"answers":["a river", "river"]
}
var joke:Dictionary = {
	"riddle":"I can be cracked, made, told, and played. What am I?",
	"answers":["a joke", "joke"]
}
var future:Dictionary = {
	"riddle":"What is always in front of you, but can’t be seen?",
	"answers":["the future", "future"]
}

var riddles = [phone,age,mirror,breakfast,clock,promise,anchor,name,coin,piano,sponge,comb,deck,fence,river,joke,future]
var results_text:Dictionary = {
	true:["The Sphinx nods solemnly. A hidden door rumbles open, revealing your reward.","A slow smile crosses the Sphinx’s face as a door swings open to your prize.","Stone grinds against stone as the sealed door unlocks, granting you your reward.","The Sphinx steps aside, and a secret door opens, offering you your earned treasure.","With a satisfied purr, the Sphinx gestures as a door creaks open to reveal riches within."],
	false:["The Sphinx growls, its eyes glowing with fury. It lunges to attack!","Ancient stone cracks and shifts—the Sphinx awakens to punish your failure.","You answered wrong. The Sphinx roars and leaps at you, claws ready.","‘Wrong,’ hisses the Sphinx. ‘Then you shall face me!’ It springs to life!","Your failure awakens the Sphinx. Battle begins!"]
}
