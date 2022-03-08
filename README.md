# Slider-Puzzle

This is an implementation of sliding tile puzzle made for Flutter Puzzle Hack 2022.

## 1. Design Theme
###     **Neumorphic**

## 2. About the game
This game is based on sliding tile to rearrange to the original position. After starting tthe game all the tiles will be shuffled to a random position. The player have to reorder all the tiles back to their original position.


## 3. About the app

Lets familiarize with the various pages-

### 3.1. Initial Pages
<img src="app_images/Initial Loading Page.png" width="330" title="Initial Loading Page"> <img src="app_images/Cool Theme Front Page.png" width="330" title="Cool Theme Front Page"> 

### 3.2. Main Menu
<img src="app_images/Cool Theme Main Menu Page.png" width="330" title="Cool Theme Main Menu Page">

This page is the collection of all the types, modes and background option available in the game. The player will be able to pick various combination of the options according to his/her choice and continue to play with it.

Lets see what each interface does- 
1. The top row gives the option of to select **number of tiles** to play with.
2. The middle row gives 3 different modes to play with-

    a. **Basic** mode: This is a normal mode where you will get the specified number of tiles and accesories. 
    <img src="app_images/Warm Theme Basic Mode.png" width="230" title="Warm Theme Basic Mode">
    
    b. **Refer Timer** mode: This mode is based on timer. On starting the game, the player will get a time limit of a reference image. After the time expires the reference image             will be gone and the tiles will be shuffled. The player have to memorize the reference image within that time limit. 
    <img src="app_images/Warm Theme Refer Timer Mode.png" width="230" title="Warm Theme Refer Timer Mode">
    
    c. **Timer** mode: This mode is also based on timer. On starting the game, a timer will start and the player have to finish the whole game within that time limit. 
    <img src="app_images/Warm Theme TImer Mode.png" width="230" title="Warm Theme TImer Mode">

3. The last row gives 2/3 tile background option to play with-

    a. **Same Color** mode: In this mode all the tiles have the same color. Each tiles is identified with an unique ID.
    
    b. **Image** mode: In this mode a saved image will be loaded and split into selected number to tiles and set as tile background.
    
    c. **Random Image** mode: This mode is dependant on an API. In this mode, the player will get a random image from **Unsplash** and use that as tile background. Each refresh will give a new image.
    
### 3.3. Settings

The settings is loaded with customization which the player wants and customize some small changes according to their preferences.

#### 3.3.1. Theme
3 available theme- **Warm**, **Cool**, **Cyberpunk**
<img src="app_images/Warm Theme Settings Page.png" width="230" title="Warm Theme Settings Page"> <img src="app_images/Cool Theme Settings Page.png" width="230" title="Cool Theme Settings Page"> <img src="app_images/Cyberpunk Theme Settings Page.png" width="230" title="Cyberpunk Theme Settings Page"> 

#### 3.3.2. Tile Curve
The tile movement animation while sliding

#### 3.3.3. Background Music
2 available background music. The background music will play on loop in the background. The player can choose to on/off the music.

#### 3.3.4. Interface Music
This is the UI sound effects. Player can choose on/off the effects.

### 3.4. Mode Pages UI
Lets see what each UI does in mode.

1. **Start**: It will shuffle the tiles to arandom position.
2. **Reset**: It will bring all the tiles to their shuffled position.
3. **Restart**: It will bring all the tiles to their original position i.e. in start state.
4. **Moves**: It will count the taps.
5. **Log Trench**: It will display the history of tapped tiles.




--- Have Fun
