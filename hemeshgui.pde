import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

import java.applet.*;
import java.awt.Dimension;
import java.awt.Frame;
import java.awt.event.MouseEvent;
import java.awt.event.KeyEvent;
import java.awt.event.FocusEvent;
import java.awt.Image;
import java.io.*;
import java.net.*;
import java.text.*;
import java.util.*;
import java.util.zip.*;
import java.util.regex.*;
import processing.opengl.*;

String version = "HemeshGui v0.4-alpha";

// general settings
int sceneWidth;                        // sketch width
int sceneHeight;                       // sketch height

// view
float zoom = 20;                       // zoom factor
float actualZoom = 20;                 // zoom smoothing
boolean autoRotate = true;             // toggle autorotation
boolean translationOn = false;                   // toggle translation
boolean rotationOn = false;                      // toggle rotation
float translateX, translateXchange;    // (change in) translation in the X-direction
float translateY, translateYchange;    // (change in) translation in the Y-direction
float rotationX, rotationXchange;      // (change in) rotation around the X-axis
float rotationY, rotationYchange;      // (change in) rotation around the Y-axis
float changeSpeedX = 1.5;              // speed of changes for X in translation and rotation
float changeSpeedY = 1.5;              // speed of changes for Y in translation and rotation
float maxSpeedY = changeSpeedY*8;
float maxSpeedX = changeSpeedX*8;
boolean flagMouseControlRotationMouvement = false;
boolean flagMouseControlTranslationMouvement = false;

// presentation
color bgcolor = color(230,230,230);    // background color
color shapecolor;                      // shape color
boolean facesOn = true;                // toggle display of faces
boolean edgesOn = false;                // toggle display of edges
float shapeHue = 57;                   // default hue
float shapeSaturation = 100;           // default saturation
float shapeBrightness = 96;            // default brightness
float shapeTransparency = 100;         // default transparency

// basic shape variables
int creator = 2;                       // default shape: Dodecahedron
float create0 = 4;                     // default shape value
float create1 = 4;                     // default shape value
float create2 = 4;                     // default shape value
float create3 = 4;                     // default shape value


// sunflow shader
int shader = 301;
float param0=0.0f;
float param1=0.0f;
float param2=0.0f;
float param3=0.0f;

// sunflow lights
boolean sunSkyLightOn = true;
boolean sunflowWhiteBackgroundOn = false;
boolean sunflowBlackBackgroundOn = false;
boolean dirLightTopOn = false;
boolean dirLightRightOn = false;
boolean dirLightFrontOn = false;
boolean dirLightBottomOn = false;
boolean dirLightLeftOn = false;
boolean dirLightBehindOn = false;
boolean sphereLightTopOn = false;
boolean sphereLightRightOn = false;
boolean sphereLightFrontOn = false;
boolean sphereLightBottomOn = false;
boolean sphereLightLeftOn = false;
boolean sphereLightBehindOn = false;
float dirLightRadius = 10.0f;
float sphereLightRadius = 10.0f;

// sunflow color lights
float lightsColorR = 230;
float lightsColorG = 230;
float lightsColorB = 230;
float lightsColorA = 255;   
color lightsColor = color(lightsColorR,lightsColorG,lightsColorB,lightsColorA);

// saving variables
boolean saveOn;                        // toggle saving: globally
boolean saveContinuous;                // toggle saving: continuous (versus just once)
boolean saveOpenGL;                    // toggle saving: regular opengl (without gui)
boolean saveGui = true;                // toggle saving: regular opengl (with gui)
boolean saveSunflow = true;            // toggle saving: sunflow (regular render)
boolean saveMask;                      // toggle saving: sunflow (mask)
boolean preview = true;                // toggle sunflow render quality
String timestamp;                      // timestamp to distinguish saves

// assorted
ArrayList modifiers = new ArrayList(); // arraylist to hold all the modifiers
int numForLoop = 20;                   // max number of shapes, modifiers and/or subdividors in the gui (for convenience, just increase when there are more)
boolean drawControlP5 = true;          // toggle drawing of controlP5 gui
float sunflowMultiply = 1;             // multiplication factor for the width & height of the sunflow render (1280x720 by default)

WB_Point[] points;
int[] triangles;

void setup() {
  //size(1280,720,OPENGL);
  fullScreen(OPENGL);
  //hint(ENABLE_OPENGL_4X_SMOOTH);
  smooth(4);
  
  
  sceneWidth = width;
  sceneHeight = height;
  
  gui();
  createHemesh();
}

void draw() {

  lightsColor = color(lightsColorR,lightsColorG,lightsColorB,lightsColorA);
  background(bgcolor);
  perspective(0.518,(float)width/height,1,100000);
  lights();

  pushMatrix();
  viewport();
  drawHemesh();
  popMatrix();

  // save frame(s) without gui
  if (saveOn == true && saveOpenGL == true) {
    if (saveContinuous) { save("output/sequence/" + timestamp + "/OpenGLView_" + nf(frameCount-1,4) + ".tga"); }
    else { save("output/screenshots/" + timestamp + " (openglview).png"); }
  }

  if (drawControlP5) {
    noLights();
    perspective();
    hint(DISABLE_DEPTH_TEST);
    updateGui();
    controlP5.draw();
    hint(ENABLE_DEPTH_TEST);
    lights();
  }

  // save frame(s) with gui
  if (saveOn == true && saveGui == true) {
    if (saveContinuous) { save("output/sequence/" + timestamp + "/GUI_" + nf(frameCount-1,4) + ".tga"); }
    else { save("output/screenshots/" + timestamp + " (gui).png"); }
  }

  // sunflow rendering (mask and/or regular sunflow render)
  if (saveOn) { if (saveSunflow == true || saveMask == true) { hemeshToSunflow(); sunflow(); } }

  // turn off saving after one frame if continuous is set to false
  if (saveOn == true && saveContinuous == false) {
    saveOn = false;
    println("Saving stopped after one frame (non-continuous)");
  }
}
