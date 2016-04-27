state("popcapgame1")
{
  // The pointer paths start on the stack (to be precise, at 0x18F574), which is before the program base, hence the unusual base addresses.
  // Unfortunately I can't do "-0x2702B8" because LiveSplit complains, so I have to wrap around instead :(

  // (0x18F574 + 0x7D4) - 0x400000
  int storyScreenObj : "popcapgame1.exe", 0xFFD8FD48;
  int screenNum : "popcapgame1.exe", 0xFFD8FD48, 0x9C;
  // This next one is just to confirm that we've properly initialised the StoryScreen object so the timer doesn't start prematurely.
  int storyParent : "popcapgame1.exe", 0xFFD8FD48, 0x8C;

  // likewise with the wraparound address for "-0x2702D4".
  // (0x18F574 + 0x7B8) - 0x400000
  int boardObj : "popcapgame1.exe", 0xFFD8FD2C;
  int interfaceObj : "popcapgame1.exe", 0xFFD8FD2C, 0x14C;
  int levelNum : "popcapgame1.exe", 0xFFD8FD2C, 0x14C, 0x90;

  // and again for "-0x2702C0".
  // (0x18F574 + 0x7CC) - 0x400000
  int mainMenuObj : "popcapgame1.exe", 0xFFD8FD40
}

init
{
  vars.currentSet = 0;
  vars.currentLevel = 0;
}

start
{
  if (current.storyScreenObj != 0 && current.screenNum == 0 && current.storyParent == 0x18F574 ) {
    print("starting");
    vars.currentSet = 0;
    vars.currentLevel = 0;
    print("start - vars.currentSet=" + vars.currentSet + ", vars.currentLevel=" + vars.currentLevel);
    return true;
  }
  return false;
}

split
{
  if (current.boardObj != 0 && current.interfaceObj != 0) {
    // we're in a level
    if (vars.currentLevel != current.levelNum && vars.currentLevel != 5) {
      if (vars.currentLevel == 0 && current.levelNum != 1) {
        print("spurious levelnum change to " + current.levelNum + " after story screen, ignoring");
        return false;
      }
      // we were on levels 1-4
      print("setting vars.currentLevel to " + current.levelNum);
      vars.currentLevel = current.levelNum;
      if (current.levelNum == 1) {
        print("no split on level 1 - vars.currentSet=" + vars.currentSet + ", vars.currentLevel=" + vars.currentLevel);
        return false;   // no split on the first level since we split on the story screen instead
      }
      else if (current.levelNum >= 2 && current.levelNum <= 5) {
        print("split - level - vars.currentSet=" + vars.currentSet + ", vars.currentLevel=" + vars.currentLevel);
        return true;
      }
    }
  }
  else if (current.storyScreenObj != 0) {
    // we're on a story screen
    if (vars.currentSet != (current.screenNum + 1)) {
      print("split - story screen " + current.screenNum + " - setting vars.currentSet to " + (current.screenNum + 1));
      vars.currentSet = current.screenNum + 1;
      vars.currentLevel = 0;
      print("split - story screen - vars.currentSet=" + vars.currentSet + ", vars.currentLevel=" + vars.currentLevel);
      if (vars.currentSet > 1) {
        // don't advance the split if we're on set 1
        return true;
      }
    }
  }
  return false;
}

reset
{
  return current.mainMenuObj != 0;
}
