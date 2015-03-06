I did find some source code on the processing website that I used found here.
https://processing.org/examples/gameoflife.html
What I modified the source to include zombies and predators. I also included the use of buttons and sliders.

The rules I applied were as follows.
1) If a cell of any kind (excluding zombies) has less then 2 neighbours the cell dies from under-population.
2) If a cell of any kind (excluding zombies) has more then 3 neighbours the cell dies from overpopulation.
3) If a cell of any kind (excluding zombies) has 2 or 3 neighbours of the same kind and no neighbours of other kind the cell lives.
4) If a zombie has any neighbours the neighbours become zombies
5) If the number of predator neighbours is greater then the number prey neighbours the prey die.
6) If a dead predator or prey have 3 neighbours of the same kind and no neighbours of other kind the cell becomes alive.

The program initializes with a random number of prey cell and no other kind.
To insert zombies press the pause button and right click where you would like the zombie.
To insert predators press the pause button and press your up arrow key where you would like the predator.
To insert prey press the pause button and left click where you would like the prey.

I created a slider that adjust the speed at witch generations happen.
I took this from other examples in the processing website and my own coding knowledge.

I was unable to properly export to mac. One will be able to view the source code from the GitHub repo from there one can run the code from processing.

ADDED FOR RESUBMIT
Added a way to count the total number of cell types (from lab 3). I did this because biologists might want to know how many cells are present.
Changed key mapping to p (add predators) and z (add zombies). I did this from your comments and because it seemed to make adding cells easier.
Changed background color of buttons and grid to white with a gray border. I did this from your comments and because it is more appealing.