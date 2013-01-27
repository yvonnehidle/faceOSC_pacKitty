// Homeworcherryk #6, 48-757, 11:30AM
// Copyright M. Yvonne Hidle
// M. Yvonne Hidle
// yvonnehidle@gmail.com
//
// CREDITS
// 1. Some code borrowed from class notes cc08 - GameDemo
// 2. FaceOSC code from Interactie Art and Computational Design,
//    which in turn was derived from the FaceOSCReciever demo
//
// GAMEPLAY
// See how many cherries you can help Pacman eat in 60 seconds!
// Move your face to move Pacman
// Open your mouth to eat the cherry
// Good luck!

//----------------------------------------------------//
// global variables
// face osc things
import oscP5.*;
OscP5 oscP5;
int found;
PVector poseOrientation;
PVector posePosition;
PVector cursorPosition;
float mouthHeight;

// cherry variables
float cherryX; // cherry's x position
float cherryY; // cherry's y position
float cherryW; // cherry's width
float cherryH; // cherry's height
float cherrySpeedX; // speed of cherry's movement in X direction
float cherrySpeedY; // speed of cherry's movement in Y direction

// packitty variables
PShape packitty;
float kittyW;
float kittyH;
float lipBottom;
float lipTop;
float pacmanSpeed;
boolean lipBottomClosed;
boolean lipTopClosed;

// general game variables
int scoreCount;
int gameTime;
int startTime;
int gamePhase;

// fluff, no seriously...
float dottySize;
color dottyColor;
//----------------------------------------------------//


//----------------------------------------------------//
void setup()
{
background(255);
size(800,400);
smooth();

// global variable values
// faceosc things
oscP5 = new OscP5(this, 8338);
oscP5.plug(this, "found", "/found");
oscP5.plug(this, "poseOrientation", "/pose/orientation");
oscP5.plug(this, "posePosition", "/pose/position");
oscP5.plug(this, "mouthHeightReceived", "/gesture/mouth/height");
poseOrientation = new PVector();
posePosition = new PVector();
cursorPosition = new PVector();
  
// cherry variale values
cherryX=random(width);
cherryY=random(height);
cherryW=20;
cherryH=20;
cherrySpeedX=2;
cherrySpeedY=1.5;

// all pacman's variables!
packitty = loadShape("packitty.svg");
kittyW=50;
kittyH=kittyW;
lipBottom=radians(2);
lipTop=radians(358);
pacmanSpeed=30;
lipBottomClosed=false;
lipTopClosed=false;

// general game variables
scoreCount=0;
startTime=0;
gameTime=60000;
gamePhase=0;

// fluff variables
dottySize=10;
dottyColor=color(240);
}
//----------------------------------------------------//


//----------------------------------------------------//
void draw()
{
  // game phases
  if ( gamePhase == 0 )
  {
    showInstructions( );
  }
  else if ( gamePhase == 1 )
  {
     playGame( );
  }
  else 
  {
    score( );
  }
}
//----------------------------------------------------//


//----------------------------------------------------//
void playGame()
{
transparentStage(); // make the background semi-transparent
backgroundNoise();

cherry(cherryX,cherryY,cherryW,cherryH); // spawn the cherry

pacmanMove(); // move pacman
cherryBounce(); // move cherry

myScore(); // score counter
checkCollisons(); // collisons between cherry and pacman

myTimer(); // show time that has ellasped
}
//----------------------------------------------------//


//----------------------------------------------------//
void backgroundNoise()
{
  
  for (int i=20; i<width; i=i+50)
  {
    for (int j=20; j<height; j=j+50)
    {
      strokeWeight(random(5,10));
      stroke(random(255));
      point(i,j);      
    }
  }
  
  for (int k=20; k<width; k=k+50)
  {
    for (int g=20; g<height; g=g+50)
    {
      strokeWeight(dottySize);
      stroke(dottyColor);
      point(k,g);
    }
  }
  
}
//----------------------------------------------------//


//----------------------------------------------------//
void showInstructions()
{
transparentStage(); // make the background semi-transparent
  
// draw pacman, nom nom nom
pacman(frameCount%width,height*.2);

// tasty cherry!
cherry((frameCount*1.1+70)%width,height*.25,cherryW,cherryH);

fill(0);
text("See how many cherries you can help Pacman eat in 60 seconds!", width*.3, height*.4);
text("Move your face to move Pacman.", width*.3,height*.45);
text("Open your mouth to eat the cherry.", width*.3,height*.5);
text("Press any key to start the game. Good luck!",width*.3,height*.55);

if (keyPressed==true)
{
  gamePhase=1;
  startTime=millis();
}

}
//----------------------------------------------------//


//----------------------------------------------------//
void score()
{
transparentStage(); // make the background semi-transparent

fill(255,0,0);
text("TIMES UP. GAME OVER!", width*.3, height*.4);
text("You ate " + scoreCount + " cherries!", width*.3,height*.45);

fill(0);
if (scoreCount < 1)
{
text("Wow, you really suck :P Press any key to try again!", width*.3,height*.5);
}

else if (scoreCount < 3)
{
text("You did decent... Press any key to try again!", width*.3,height*.5);
}

else if (scoreCount < 6)
{
text("Okay, you're pretty good :) Press any key to play again!", width*.3,height*.5);
}

else if (scoreCount < 10)
{
text("Wow wow wow! You're REALLY good! Press any key to play again!", width*.3,height*.5);
}

else
{
text("WOW! You're GODLY there :o", width*.3,height*.5);
text("I don't think you need to play anymore...", width*.3,height*.55);
text("...But if you still want to play again press any key!", width*.3,height*.6);
}


if (keyPressed==true)
{
  gamePhase=1;
  startTime=millis();
  scoreCount=0;
}
}
//----------------------------------------------------//


//----------------------------------------------------//
void myTimer()
{
  fill(0);
  text("Time Remaining: " + (gameTime/1000 - ((millis()-startTime))/1000) + " Seconds",width*.01,height*.09);  
  if ((millis()-startTime) > gameTime)
  {
    gamePhase=2;
  }
  
}
//----------------------------------------------------//


//----------------------------------------------------//
void myScore()
{
  fill(255);
  noStroke();
  rect(0,0,200,60);
  
  fill(255,0,0);
  text("Cherries Eaten: " + scoreCount, width*.01,height*.05);
}
//----------------------------------------------------//


//----------------------------------------------------//
// if collison is detected this is what happens
void collison()
{
  // insert flashy cool graphics here
  dottySize=random(5,10);
  dottyColor=color(random(255),random(255),random(255));
  
  // relocate the cherry
  cherryX=random(width);
  cherryY=random(height);
  cherrySpeedX=random(0,5);
  cherrySpeedY=random(0,5);
  
  // add one point to the score
  scoreCount=scoreCount+1;
}
//----------------------------------------------------//


//----------------------------------------------------//
// checking for collisons between the cherry and pacman
void checkCollisons()
{
  
  float d = dist(cherryX,cherryY,cursorPosition.x,cursorPosition.y);
  
  if (d < cherryW & mouthHeight > 4 || d < cherryH*2 & mouthHeight > 4)
  {
    collison();
  }
  
}
//----------------------------------------------------//


//----------------------------------------------------//
// make packitty move using your face
void pacmanMove()
{

// move packitty with your face
if (found > 0)
{
  cursorPosition.x += pacmanSpeed * poseOrientation.y;
  cursorPosition.y += pacmanSpeed * poseOrientation.x;
  cursorPosition.x = constrain(cursorPosition.x, 0, width);
  cursorPosition.y = constrain(cursorPosition.y, 0, height);
}


// keep packitty on the screen
if (cursorPosition.x > width)
{
  cursorPosition.x=0;
}
else if (cursorPosition.x < 0)
{
  cursorPosition.x=width;
}

if (cursorPosition.y > height)
{
  cursorPosition.y=0;
}
else if (cursorPosition.y < 0)
{
  cursorPosition.y=height;
}


// rotate packitty accordingly
// rotate packitty LEFT
else if (posePosition.x > 286)
{
pushMatrix();
  scale(-1, 1);
  pacman(-cursorPosition.x, cursorPosition.y);
popMatrix();
}

// rotate packitty RIGHT
else if (posePosition.x < 286)
{
pushMatrix();
  pacman(cursorPosition.x, cursorPosition.y);
popMatrix();
}

}
//----------------------------------------------------//


//----------------------------------------------------//
// make the cherry bounce off the walls
void cherryBounce()
{
  
  cherryX=cherryX+cherrySpeedX;
  if (cherryX-cherryW < 0 || cherryX+cherryW > width)
  {
    cherrySpeedX=cherrySpeedX*-1;
  }

  cherryY=cherryY+cherrySpeedY;
  if (cherryY-cherryH < 0 || cherryY+cherryH > height)
  {
    cherrySpeedY=cherrySpeedY*-1;
  }
  
}
//----------------------------------------------------//


//----------------------------------------------------//
void transparentStage()
{
  noStroke();
  fill(255,150);
  rect(0,0,width,height);
}
//----------------------------------------------------//


//----------------------------------------------------//
// drawing the cherry
void cherry(
float cherryX,
float cherryY,
float cherryW,
float cherryH)
{

  // cherry base
  ellipseMode(CENTER);
  fill(209,105,105);
  noStroke();
  ellipse(cherryX,cherryY,cherryW,cherryH);
  
  // cherry shadow
  fill(157,59,59);
  ellipse(cherryX,cherryY-cherryH/5,cherryW/2,cherryH/3);
  
  // cherry stem
  noFill();
  stroke(72,183,73);
  strokeWeight(2);
  arc(cherryX-cherryW/3.5,cherryY-cherryH/.9,cherryW,cherryH*2,radians(-50),radians(60));
}
//----------------------------------------------------//


//----------------------------------------------------//
// lets draw pacman!
void pacman(float kittyX, float kittyY)
{
noStroke();

// open/close packitty's mouth when you open/close your mouth
float mouthNumB = map(mouthHeight, 0, 7, 0, 30);
float mouthNumT = map(mouthHeight, 0, 7, 360, 330);
lipBottom=radians(mouthNumB);
lipTop=radians(mouthNumT);

// packitty's body & mouth
fill(137, 172, 191);
arc(kittyX, kittyY, kittyW, kittyH, lipBottom, lipTop);

// packitty's accessories!
shapeMode(CENTER);
shape(packitty, kittyX-6, kittyY-4, 100, 100);
}
//----------------------------------------------------//


//----------------------------------------------------//
// faceosc stuff
public void found(int i) {
  found = i;
}
//----------------------------------------------------//


//----------------------------------------------------//
// orientation of face
public void poseOrientation(float x, float y, float z)
{
//println("pose orientation\tX: " + x + " Y: " + y + " Z: " + z);
poseOrientation.set(x, y, z);
}
//----------------------------------------------------//


//----------------------------------------------------//
// position of face
public void posePosition(float x, float y)
{
println("pose position\tX: " + x + " Y: " + y );
posePosition.set(x, y, 0);
}
//----------------------------------------------------//


//----------------------------------------------------//
// height of mouth
public void mouthHeightReceived(float h)
{
  //println("mouth height: " + h);
  mouthHeight = h;
}
//----------------------------------------------------//


//----------------------------------------------------//
// all other OSC messages end up here
void oscEvent(OscMessage m) 
{
  if (m.isPlugged() == false) {
  }
}
//----------------------------------------------------//

