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
	return current.storyScreenObj != 0 && current.screenNum == 0;
}

split
{
	return (current.boardObj != 0 && current.interfaceObj != 0 && current.levelNum >= 1 && current.levelNum <= 5 && current.levelNum > old.levelNum && current.levelNum != 1) || (current.storyScreenObj != 0 && current.screenNum > old.screenNum);
}

reset
{
	return current.mainMenuObj != 0;
}