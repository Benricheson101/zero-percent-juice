## JQ TODO

#### TODO:
 - A square that moves up and down on the y-axis (for now we will ignore x)
 - The square starts at 20% of the width of the screen (ex. 1920 * .2) (could change as we see fit)
 - Display that we are changing the background to give the illusion of the player moving forward.
 - A score that is calculated while we "move" foreward (use x velocity to calculate this (at least a part of it))
 - Figure out how to package and distribute the game. (Documentation -> https://love2d.org/wiki/Game_Distribution)


 #### Implementation Specifics:
  - We will have a x-velocity that will allow the score scale faster while we are move faster and vice versa
  - Figure out the best way to have the background move behind the play (multiple frames? panoramic image? how does it stitch back to the front)