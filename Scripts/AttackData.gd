extends Node
class_name Attack_Data

@export var anim : String
@export var damage : int

@export var move1Name : String = "Question!";
@export var move2Name : String = "n/a";
@export var unlockRun : bool = false;

@export var dmgData = {
	"Question!" : 50,
	"Pathos": 100,
}

@export var minionData = [
	"Shadow Strategist",
]

var passedQuestion : bool = false
var correctAnswer : bool = false
