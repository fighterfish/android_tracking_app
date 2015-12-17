import ketai.camera.*;
import ketai.ui.*;
import controlP5.*;
import de.looksgood.ani.*;

KetaiVibrate vibe;
KetaiCamera cam;
ControlP5 cp5;
// Variable for capture device 
//Capture video; 
color trackColor; 
boolean drawCamera = true;
// Previous vid Frame 
PImage prevFrame;
// How different must a pixel be to be a "motion" pixel
float threshold = 50;
color c;
// for MENU UI
float x = 0;
float y = 0;
String menuState = "closed";

void setup() {
  fullScreen(P3D);
  //size(320,240,P3D);
  orientation(LANDSCAPE);
  frameRate(120); 
  //imageMode(CENTER);
    colorMode(RGB,255,255,255,100); 
  cam = new KetaiCamera(this, 320, 240, 120);
  //trackColor = color(255,160,100); // Start off tracking for white
  noFill(); 
  strokeWeight(4.0); 
  stroke(0); 
  cam.setCameraID(1); // use front facing camera
  vibe = new KetaiVibrate(this);
  // Start off tracking for red
  trackColor = color(255,0,0);
  //smooth();
   // Create an empty image the same size as the video
 // prevFrame = createImage(cam.width, cam.height, RGB);
 //registerPre(this);
// you have to call always Ani.init() first!
  Ani.init(this);
  cp5 = new ControlP5(this);
  cp5.addButton("SAMPLE_COLOUR")
     .setPosition(x,y)
     .setSize(200,50)
     .setValue(0)
     ;

  cp5.addButton("MENU")
     .setPosition(x,y-41)
     .setSize(200,40)
     .setValue(0)
     ;
  // add a vertical slider
  cp5.addSlider("slider")
     .setPosition(x,y+51)
     .setSize(200,50)
     .setRange(0,height)
     .setValue(128)
     ;
  
  y = height;
}

void draw() {
/* ---------------------UI ELEMENTS ----------------------- */
  // cp5.getName("colorC").setPosition(x,y);
   cp5.getController("SAMPLE_COLOUR").setPosition(x,y);
 //  cp5.getController("colorB").setPosition(x,y+51);
   cp5.getController("slider").setPosition(x,y+51);
     // reposition the Label for controller 'slider'
  //cp5.getController("slider").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("slider").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
   //cp5.getController("play").setPosition(x+150,y-51);
   cp5.getController("MENU").setPosition(x,y-41);
/* ---------------------UI ELEMENTS ----------------------- */   
   textSize(64);
text("touch to start tracking", displayWidth/2, displayHeight/2); 
fill(0, 102, 153);
   // Draw the video image on the background 
    //image(cam,0,0,320,240); 
    if (drawCamera){
      //loadPixels();
  image(cam, 0, 0, displayWidth, displayHeight);
    }
  //rect(width/2, height/2, 55, 55);
  //cam.loadPixels();
  //prevFrame.loadPixels();
      // You don't need to display it to analyze it!
  //image(cam, 0, 0);
  //loadPixels();
  
  // Local variables to track the color 
  float closestDiff = 500.0f; 
  int closestX = 0; 
  int closestY = 0; 
  cam.loadPixels();
  // Begin loop to walk through every pixel 
  for ( int x = 0; x < cam.width; x++) { 
    for ( int y = 0; y < cam.height; y++) { 
      int loc = x + y*cam.width; 
      // What is current color 
      color currentColor = cam.pixels[loc]; 
      float r1 = red(currentColor); float g1 = green(currentColor); float b1 = blue(currentColor); 
      float r2 = red(trackColor);   float g2 = green(trackColor);   float b2 = blue(trackColor); 
      // Using euclidean distance to compare colors 
      float d = dist(r1,g1,b1,r2,g2,b2); 
      // If current color is more similar to tracked color than 
      // closest color, save current location and current difference 
      if (d < closestDiff) { 
        closestDiff = d; 
        closestX = x; 
        closestY = y; 
      } 
    } 
  } 
  cam.updatePixels();
  //println(displayHeight);
  //calculate the offset since we are scaling the vid
  float xOffset = displayWidth / 320;
  float yOffset = displayHeight / 240;
  // Draw a circle at the tracked pixel 
  fill(c);
  ellipse(closestX*xOffset,closestY*yOffset,32,32); 
/*---------------------- The Threshhold Bar ---------------------- */
  stroke(255,20,147);
  line(0, height - cp5.getController("slider").getValue(), width, height - cp5.getController("slider").getValue());//X1, X2 , Y1, Y2
noStroke();
fill(255,20,147, 20);
rect(0,height - cp5.getController("slider").getValue(),width, height);
noFill();
}
/*
void pre(){
   // do all the state calculations here
}
*/
//cam.loadPixels();
void onCameraPreviewEvent()
{
   // Save previous frame for motion detection!!
  //prevFrame.copy(cam, 0, 0, cam.width, cam.height, 0, 0, cam.width, cam.height);
  //prevFrame.updatePixels(); 
  cam.read();
}

public void controlEvent(ControlEvent theEvent) {
  println(theEvent.getController().getName());
  //n = 0;
}
public void SAMPLE_COLOUR(int theValue) {
  println("a button event from SAMPLE_COLOUR: "+theValue);
}
public void MENU(int theValue) {  
   println("a button event from Menu: "+theValue);
     //y = height;
    if (menuState == "closed"){
    Ani.to(this, 1.0, "y", height-100, Ani.EXPO_OUT); // OPEN MENU   
     menuState = "open";
     cp5.getController("MENU").setCaptionLabel("MENU    [-]"); 
     } else {
     Ani.to(this, 1.0, "y", height, Ani.EXPO_OUT); // close Menu
     menuState = "closed";
     cp5.getController("MENU").setCaptionLabel("MENU    [+]"); 
  }
}

// start/stop camera preview by tapping the screen
void mousePressed()
{
  vibe.vibrate(100);
  if (cam.isStarted())
  {
    //cam.stop();
    //drawCamera = false;
        // Save color where the mouse is clicked in trackColor variable 
  // int loc = mouseX + mouseY*displayWidth; 
    //println(loc);
    //trackColor = cam.pixels[loc]; 
    trackColor = get(mouseX,mouseY); 
    c = trackColor;
    fill(c);
      // Draw a circle at the tracked pixel 
     ellipse(mouseX,mouseY,100,100); 
     noFill();
  }
  else
    cam.start();

}
/*
void keyPressed() {
  if (key == CODED) {
    if (keyCode == MENU) {
      if (cam.isFlashEnabled())
        cam.disableFlash();
      else
        cam.enableFlash();
    }
  }
  
}*/