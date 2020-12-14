# BlackGarden

Black Garden Final Project Description

Tory Farmer, Marissa Kalkar, Alex Stepansky, Owen Zhang

Our game is a top-down open world RPG, where the user’s goal is to collect all 5 crowns scattered throughout the map. 
If all 5 of these crowns are collected, the player wins. However, there are a number of enemies called “Ravens” scattered throughout the map. 
If you touch a raven, you lose health. If your health hits 0, you lose and the game restarts. 

A few features about the game:
-This game is designed for landscape mode and will force the user to play in this way.

-To move the character, simply tap where you want to go. 

-To collect an item, simply run over it.

-There are weapons scattered throughout the map that will let you kill the ravens.  There are two kinds of weapons: guns and swords. 
If you collect a sword, tapping a raven deals 20 damage to it. Ravens have 20 health and get removed on death. Notice that swords have short range, so tapping on them outside melee range will not do any damage. The other weapon is a gun that has 35 damage and massively increased range. 
These are slightly harder to find, as only 5 guns spawn compared to 10 swords, but they are obviously more effective. 

-The map generation is governed by a random noise map, and the “height” of the terrain affects a number of things about the game. The player moves faster on dryer land (grass > sand > water), and items (not counting ravens) can only spawn on land. 
Notice that player run speed can vary within a single tap (such as if you started on land but went into water). This took quite some time to implement!

-The world map is a total of 3232 units in width and height, with 0,0 being the center and player spawn. Dying respawns you here. If the player attempts to move out of bounds, the character will just run into a wall and stay there. No boundary breaking!

-Raven damage is gradual and is based on SKPhysicsBody contact. Try to stay away!  

-Tapping the 2-rectangle item in the upper right hand corner opens up the character menu. Here, you can view your crown count, health, and any items you’ve collected. Duplicates do not appear. 

-The game saves your position, items, health, crowns, and enemy locations in user defaults. Restarting the game will move around collectables. This feature lets the player to save their progress between sessions while not taking up too much space. 

-In the spirit of MVC, we made the player and raven characters conform to “Player” and “Raven” classes. Note that the “RavenEnemy” class is deprecated.

-The tile set we used is the default one, as creating a new one is a frankly excessive amount of artistic work for one individual to do. However, all of the sprite design (enemies, characters, and items) were done by hand. This took a while!

-We cite 2 sources that helped us out with some of the most challenging parts of our project, mostly with getting the tile grid and noise maps working. See GameScene.swift for these sources.
