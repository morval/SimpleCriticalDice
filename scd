// Simple Critical Dice
//
// copyright pug games 2014
// please feel free to use this script, change it, add to it in any way you feel
// Script created by Roll20 user Konrad J.
//
// FrameWork Script
//
// these are the CONSTANTS for the FrameWork functions
var fwCONSTANTS = {
    COMMANDSEPERATOR : " ",
    GMIDS : ["all"],
    scdSCRIPTCOMMAND : "!!"
};

// these are the Globals for the FrameWork functions
var fwGlobal = {
	logToConsoleOn : false
};

function fwLtC(logMsg){
	if (fwGlobal.logToConsoleOn === true) {
		log(logMsg);
	}
}

function fwIsGM(playerid) {
	var player = getObj('player', playerid);
	var d20userid = player.get('_d20userid');
	var test = false;
	
	if (fwCONSTANTS.GMIDS.indexOf(d20userid) >= 0 || fwCONSTANTS.GMIDS.indexOf("all") >= 0) {
		test = true;
	}
	fwLtC("Is GM: " + test);
	return test;
}

function fwFindCommand(commandStringToFind, commands) {
	var i=0;
	var len = commands.length;
	var result = {
		found : "false",
		parm : ""
	};
	for (i; i<len; i++) {
		if (commands[i].indexOf(commandStringToFind) === 0) {
			result.found = true;
			result.parm = commands[i].substr(commandStringToFind.length);
			i=len;
		}
	}
    fwLtC("Command: " + result);
	return result; 
}

var processScriptTabs = function(msg) {
    // this will run the various other scripts depending upon the chat
    // window command.  Just add another Case statement to add a new command.

    var chatCommand = msg.content;
	var script = chatCommand.substr(0, chatCommand.indexOf(fwCONSTANTS.COMMANDSEPERATOR));
	chatCommand = chatCommand.replace(script + fwCONSTANTS.COMMANDSEPERATOR, "");

	fwLtC("Script: " + script);
	fwLtC("Chat Command: " + chatCommand);
    switch(script) {
    	case fwCONSTANTS.scdSCRIPTCOMMAND:
			if (fwIsGM(msg.playerid) === true) {
				processSimpleCriticalDice(chatCommand, msg);
			}
			break;
    }
};

on("chat:message", function(msg) {
    // returns the chat window command entered
    if (msg.type != 'api') {
        return;
    }
	fwLtC("Chat Msg: " + msg.content);
    return processScriptTabs(msg);
});

//
// Simple Critical Dice
//
var scdCONSTANTS = {
	FUMBLE : {
		A : ["Balance Lost", "Butter Fingers", "Embarrassed", "Pulled Muscle", "Fatigued", "Overextended"],
		AEFFECT : ["You fall Prone", "You throw your weapon or implement 1d4 squares in a random direction", "You receive a -2 penalty to attack rolls against the target until you successfully hit the target with an attack", "You are Weakened until the end of your next turn", "You are Dazed until the end of your next turn", "You are Stunned until the end of your next turn"],
		B : ["Item Broken", "Counter Attacked", "Bad Aim", "Critical Counter", "Friendly Fire", "Suicide Strike"],
		BEFFECT : ["Your weapon or implement is broken and must be repaired with the Make Whole Ritual", "The target hits you with a basic attack of its choice", "You hit your closest ally with a basic attack.  Hit yourself if it is impossible to reach an ally", "Your target crits you with a basic attack of its choice", "You crit your closest ally with a basic attack.  Crit yourself if it is impossible to reach an ally", "You crit yourself with the same attack you fumbled on, receiving all negative conditions and effects of the attack"]
	},
	CRITICAL : {
		A : ["Knockdown", "Hamstring", "Turn the Tide", "Eye Gouge", "Forceful Blow", "Stunning Blow"],
		AEFFECT : ["Your target is Prone", "Your target is Slowed (save ends)", "You have Combat Advantage against all enemies until the end of your next turn", "Your target is blinded until the end of its next turn", "Your target is Dazed until the end of its next turn", "Your target is stunned until the end of its next turn"],
		B : ["Parry", "Gaping Wound", "Pressure Point", "Opportunity", "Knockout", "Eviscerate"],
		BEFFECT : ["You gain a bonus to all Defenses until end of your next turn equal to +2H/+3P/+4E", "Your attack deals Ongoing Damage: 5 + 1/2 your level", "Your target is Weakened (save ends)", "You may take an extra Standard Action this turn", "Your target is Unconscious (save or damage ends)", "Maximize all extra Critical damage for the attack, then deal extra damage equal to +3d6 H/+3d8 P/+3d10 E"]
	},
	COLWIDTH : "250px",
	HEADERCOLOR : "#FF9999",
	EFFECTCOLOR : "#66C2FF",
	EFFECTDESCCOLOR : "#B2F0B2"
// Colours are in Hex values, please go here to help find a colour you wish to use.
// http://www.w3schools.com/tags/ref_colorpicker.asp
};

var scdGlobal = {
};

function processSimpleCriticalDice(chatCommand, msg){
	var row = randomInteger(6);
	var col = randomInteger(4);
	var TextLookupEffect = "";
	var TextResultEffect = "";
    var CritType = "";
	
		switch(chatCommand) {
			case "f":
				CritType = "FUMBLE";
				if (col <= 3) {
					TextLookup = scdCONSTANTS.FUMBLE.A[row-1];
					TextLookupEffect = scdCONSTANTS.FUMBLE.AEFFECT[row-1];
				}
				else {
					TextLookup = scdCONSTANTS.FUMBLE.B[row-1];
					TextLookupEffect = scdCONSTANTS.FUMBLE.BEFFECT[row-1];				
				}
				break;
			case "c":
				CritType = "CRITICAL";
				if (col <= 3) {
					TextLookup = scdCONSTANTS.CRITICAL.A[row-1];
					TextLookupEffect = scdCONSTANTS.CRITICAL.AEFFECT[row-1];
				}
				else {
					TextLookup = scdCONSTANTS.CRITICAL.B[row-1];
					TextLookupEffect = scdCONSTANTS.CRITICAL.BEFFECT[row-1];
				}
				break;
		}

		var htmlHeader = '<table style="border:none"><tr><th style="font-weight:bold;padding:0px 5px;border-style:solid;border-width:0px;width: ' + scdCONSTANTS.COLWIDTH + ';background-color:' + scdCONSTANTS.HEADERCOLOR + '";text-align:center">' + CritType + '</th></tr>'

		var htmlEffect = '<tr><td style="font-weight:bold;padding:0px 5px;border-style:solid;border-width:0px;width: ' + scdCONSTANTS.COLWIDTH + ';background-color:' + scdCONSTANTS.EFFECTCOLOR + ';text-align:center">' + TextLookup + '</td></tr>'

		var htmlEffectDesc = '<tr><td style="font-weight:bold;padding:0px 5px;border-style:solid;border-width:0px;width: ' + scdCONSTANTS.COLWIDTH + ';background-color:' + scdCONSTANTS.EFFECTDESCCOLOR + '">' + TextLookupEffect + '</td></tr></table>'
		
		sendChat(msg.who, htmlHeader + htmlEffect + htmlEffectDesc);
}
