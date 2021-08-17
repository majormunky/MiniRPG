# Updates for 2021-08-16

## Battle Scene Updates
We now use progress bars as health bars for both the player and enemies.  The health values should all now
be loading from data files intead of hardcoded values that we were using before.

When we start a battle, the main functionality of the battle is all that works right now.  The first character is the one that fights, and the monsters do not get a turn.  We currently can attack all the monsters in the battle, and when the battle is over, a panel comes up that will show the results of the battle.  Currently, we jus thit the button to go back to the game, and no battle stats or treasure / gold is shown.

## Bugs found
When we first start a game, loading into the test battle works fine.  If we first go to a town, then return to the main world, and then go to the battle screen, we get an error about not being able to access some data about the encounter.  Need to investigate how we load the world initially vs when we move between them, and be sure that they both do the same thing.
