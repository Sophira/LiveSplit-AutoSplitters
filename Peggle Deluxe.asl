state("popcapgame1")
{
	// The pointer paths start on the stack, which is before the program base, hence the unusual base addresses.
	// Unfortunately I can't do "-0x2720B8" because it complains, so I have to wrap around instead :(
	int storyScreenObj : "popcapgame1.exe", 0xFFD8FD48;
	int screenNum : "popcapgame1.exe", 0xFFD8FD48, 0x9C;

	// likewise for "-0x2702D4".
	int boardObj : "popcapgame1.exe", 0xFFD8FD2C;
	int interfaceObj : "popcapgame1.exe", 0xFFD8FD2C, 0x14C;
	int levelNum : "popcapgame1.exe", 0xFFD8FD2C, 0x14C, 0x90;

	// and again for "-0x2702C0".
	int mainMenuObj : "popcapgame1.exe", 0xFFD8FD40
}

start
{
	if (current.storyScreenObj != 0 && current.screenNum == 0) {
		vars.currentSet = 1;
		vars.currentLevel = 1;
		return true;
	}
	return false;
}

split
{
	if (current.boardObj != 0 && current.interfaceObj != 0) {
		// we're in a level
		if (vars.currentLevel != current.levelNum && vars.currentLevel != 5) {
			// we were on levels 1-4
			if (current.levelNum == 1) {
				vars.currentLevel = 1;
				return false;   // no split on the first level since we split on the story screen instead
			}
			else if (current.levelNum >= 2 && current.levelNum <= 5) {
				vars.currentLevel = current.levelNum;
				return true;
			}
		}
	}
	else if (current.storyScreenObj != 0) {
		// we're on a story screen
		if (vars.currentSet != (current.screenNum + 1)) {
			vars.currentSet = current.screenNum + 1;
			vars.currentLevel = 1;
			return true;
		}
	}
	return false;
}

reset
{
	return current.mainMenuObj != 0;
}