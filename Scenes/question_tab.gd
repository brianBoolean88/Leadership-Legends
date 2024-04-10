extends Control

@onready var moveLabel = $BG/MoveLabel
@onready var questionLabel = $BG/QuestionLabel
@onready var aOption = $BG/OptionA
@onready var bOption = $BG/OptionB
@onready var cOption = $BG/OptionC
@onready var dOption = $BG/OptionD

var questionReady : bool = false
var currCorrectIndex = 0
var currMoveName = ""

var questions = [
	{
		"question": "What charitable organization does FBLA primarily support?",
		"options": ["The Salvation Army", "Goodwill", "March of Dimes", "City Harvest"],
		"correct": 3
	},
	{
		"question": "What is the first line of the FBLA creed?",
		"options": ["I believe education is the right of every person.", "All shall run a business.", "Together we are one.", 	"Business is the best fitness."],
		"correct": 0
	},
	{
		"question": "When is American Enterprise Day?",
		"options": ["November 31", "November 15", "February 15", "February 31"],
		"correct": 1
	},
	{
		"question": "FBLA-PBL is headquartered in what city?",
		"options": ["Reston, Virginia", "Richmond, Virginia", "Greensboro, GA", "
	Atlanta, GA"],
		"correct": 0
	},
	{
		"question": "Who developed the FBLA Concept?",
		"options": ["President Franklin D. Roosevelt", "Dr. Edward D. Miller", "Mrs. Tanya Morgan", "Dr. Hamden L. Forkner"],
		"correct": 3
	},
	{
		"question": "What is the advantage of email access?",
		"options": ["quicker, easier, cheaper and environmentally friendly", "quicker and it's harsh on the environment", "it's 	free", "cheaper and is more meaningful"],
		"correct": 0
	},
	{
		"question": "What is the protocol for introducing people?",
		"options": ["It doesn't matter the order.", "Always say the least important persons name first.", "Always say the most 	important peoples names first.", "Don't worry about introducing them."],
		"correct": 2
	},
	{
		"question": "For meeting etiquette, which one of these would be okay to do?",
		"options": ["Use swear words and vulgar references just now and then", "Ask personal questions during first meeting", 	"Whoever gets to the door first should open it and hold for others who are following", "Leave your cell phone on because 	you are expecting and emergency call"],
		"correct": 2
	},
	{
		"question": "Business etiquette...",
		"options": ["is the behavior to be followed in the business world and corporate culture.", "is all the same in every 	country.", "should not be practiced in the United States.", "should only be practiced in Mexico."],
		"correct": 0
	},
	{
		"question": "When giving a presentation to a group, one should...",
		"options": ["read very quickly and quietly", "never look up at the audience", "read with moderate speed and tone, and look 	at audience periodically", "burst into laughter frequently"],
		"correct": 2
	},
	{
		"question": "If you get a text message while in a meeting, what should you do?",
		"options": ["Reply right away it is far less diverting than talking on the phone", "Wait until later to read it, as it is 	rude to read and reply to the message", "read the message, but wait until later to response", "all of the above"],
		"correct": 1
	},
	{
		"question": "Which one of these is poor etiquette?",
		"options": ["Listen to your favorite radio station when your manager is giving you a directive.", "Use your cell phone when 	your co-workers are discussing a possible solution to a problem.", "Calling your parent when you are having computer 	issues", "All of the above"],
		"correct": 3
	},
	{
		"question": "What should you always do before sending an email?",
		"options": ["Re-Read", "Copy", "Forward", "Reply"],
		"correct": 0
	},
	{
		"question": "Which of the following is NOT proper business etiquette?",
		"options": ["Good Manners", "Speaking Unnecessarily Loud", "Posture and Poise", "Internet/email - Netiquette"],
		"correct": 1
	},
	{
		"question": "Which of the following is NOT one of the four types of basic written communication documents?",
		"options": ["reports", "letter", "email", "thesis"],
		"correct": 3
	},
	{
		"question": "What group of individuals establishes the policies that govern FBLA-PBL?",
		"options": ["Board of Directors", "Board of Governors", "FBLA CEO", "National Executive Council"],
		"correct": 0
	},
	{
		"question": "If business of the National Executive Council is conducted by mail, what is the vote required for action?",
		"options": ["1/2 Vote", "Majority", "Plurality", "3/4 Vote"],
		"correct": 3
	},
	{
		"question": "Which of the following is not an official publication of FBLA-PBL?",
		"options": ["Tomorrow's Business Leader", "FBLA Adviser's Hotline", "Business Leaders of Tomorrow", "The PBL Business Leader"],
		"correct": 2
	},
	{
		"question": "Why is it often important to take notes during meetings or presentations?",
		"options": ["The audience needs something to do", "The speaker is difficult to understand", "This information will be 	needed later", "Writing keeps the mind focused"],
		"correct": 2
	},
	{
		"question": "Which is an example of a textual graphic that is used in a business report?",
		"options": ["Pie chart", "Pictograph", "Map", "Flowchart"],
		"correct": 3
	},
	{
		"question": "The primary reason customers give for not returning to a business is a lack of:",
		"options": ["Speak from notes", "Use technical terminology", "Enunciate clearly", "Speak rapidly"],
		"correct": 2
	},
	{
		"question": "In order to be understood on the telephone, a business's employees should always:",
		"options": ["Pie chart", "Pictograph", "Map", "Flowchart"],
		"correct": 3
	},
	{
		"question": "What type of communication style is usually appropriate for evaluation or counseling interviews with 	employees?",
		"options": ["Casual", "Formal", "Routine", "Technical"],
		"correct": 1
	},
	{
		"question": "Which is not a tool that people use when participating in discussions?",
		"options": ["Pointing out missing information", "Commentating a personal experience", "Building on someone else's comment", 	"Helping the group summarize what has been said"],
		"correct": 1
	},
	{
		"question": "Which is a reason why it is important to organize information before preparing a business report?",
		"options": ["To investigate the cause of the problem", "To understand the purpose of the report", "To identify the target 	audience", "To arrange findings in a logical manner"],
		"correct": 3
	},
	{
		"question": "As Kevin edits a professional report, he is not sure whether to italicize or underscore a book title. To 	obtain the correct information, Kevin should:",
		"options": ["Refer to the appropriate publisher's style manual", "Ask his coworker for advice", "Look up the information in 	a current dictionary", "Identify the reader's preferences"],
		"correct": 0
	},
	{
		"question": "When Steven asks questions in an open-minded way, he avoids:",
		"options": ["Stating his own opinion", "Attacking some else's idea", "Suggesting a better way to do something", "Mentioning 	the truth"],
		"correct": 1
	},
	{
		"question": "It is easier for employees to develop positive customer/ client relations if employees understand that each 	customer is:",
		"options": ["A possible problem", "A unique individual", "In a hurry", "Like most others"],
		"correct": 1
	},
	{
		"question": "Your coworkers and your supervisor both deserve the same...",
		"options": ["Disrespect", "praise", "level of authority", "Respect"],
		"correct": 3
	},
	{
		"question": "Listening without interrupting the speaker is an example of...",
		"options": ["Netiquette", "Ethics", "Business Etiquette", "Etiquette"],
		"correct": 2
	},

]

func askQuestion():
	var randomQuestionIndex = randi() % questions.size()
	questionLabel.text = questions[randomQuestionIndex]["question"]
	var options = questions[randomQuestionIndex]["options"]
	var correctOption = questions[randomQuestionIndex]["correct"]
	
	aOption.text = "A. " + options[0]
	bOption.text = "B. " + options[1]
	cOption.text = "C. " + options[2]
	dOption.text = "D. " + options[3]
	
	currCorrectIndex = correctOption
	questionReady = true

func init(moveName):
	visible = true
	AttackData.passedQuestion = false
	questionReady = false
	moveLabel.text = "USING MOVE: %s" % [moveName]
	
	aOption.grab_focus()
	
	askQuestion()
	# TODO: add functionality to accomodate to specific moves, when asking questions
	
	currMoveName = moveName
	if moveName == "Question!":
		print("do something")
	elif moveName == "Pathos":
		print("do something else")
	else:
		print("do something")

func onButtonPress(index):
	if questionReady:
		AttackData.passedQuestion = true
		visible = false
		if currCorrectIndex == index:
			AttackData.correctAnswer = true
		get_parent().answered_question(currMoveName)
		currMoveName = ""

func _on_option_a_pressed():
	onButtonPress(0)

func _on_option_b_pressed():
	onButtonPress(1)


func _on_option_c_pressed():
	onButtonPress(2)


func _on_option_d_pressed():
	onButtonPress(3)
