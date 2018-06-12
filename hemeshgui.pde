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
import controlP5.*;
import java.util.Iterator;

String version = "HemeshGui v0.4-alpha";

boolean autoRotate = true; // toggle autorotation
boolean dirLightBehindOn = false;
boolean dirLightBottomOn = false;
boolean dirLightFrontOn = false;
boolean dirLightLeftOn = false;
boolean dirLightRightOn = false;
boolean dirLightTopOn = false;
boolean drawcp5 = true; // toggle drawing of cp5 gui
boolean edgesOn = false; // toggle display of edges
boolean facesOn = true; // toggle display of faces
boolean flagMouseControlRotationMouvement = false;
boolean flagMouseControlTranslationMouvement = false;
boolean preview = false; // toggle sunflow render quality
boolean rotationOn = false; // toggle rotation
boolean saveContinuous; // toggle saving: continuous (versus just once)
boolean saveGui = false; // toggle saving: regular opengl (with gui)
boolean saveMask; // toggle saving: sunflow (mask)
boolean saveOn; // toggle saving: globally
boolean saveOpenGL; // toggle saving: regular opengl (without gui)
boolean saveSunflow = true; // toggle saving: sunflow (regular render)
boolean sphereLightBehindOn = false;
boolean sphereLightBottomOn = false;
boolean sphereLightFrontOn = false;
boolean sphereLightLeftOn = false;
boolean sphereLightRightOn = false;
boolean sphereLightTopOn = false;
boolean sunflowBlackBackgroundOn = false;
boolean sunflowWhiteBackgroundOn = false;
boolean sunSkyLightOn = true;
boolean translationOn = false; // toggle translation

color lightsColor;
color shapecolor; // shape color

float actualZoom = 1; // zoom smoothing
float changeSpeedX = 1.5; // speed of changes for X in translation and rotation
float changeSpeedY = 1.5; // speed of changes for Y in translation and rotation
float create0;
float create1;
float create2;
float create3;
float dirLightRadius = 10.0f;
float lightsColorA = 255;
float lightsColorB = 230;
float lightsColorG = 230;
float lightsColorR = 230;
float maxSpeedX = changeSpeedX*8;
float maxSpeedY = changeSpeedY*8;
float param0 = 0.0f;
float param1 = 0.0f;
float param2 = 0.0f;
float param3 = 0.0f;
float rotationX, rotationXchange; // (change in) rotation around the X-axis
float rotationY, rotationYchange; // (change in) rotation around the Y-axis
float shapeBrightness; // default brightness
float shapeHue; // default hue
float shapeSaturation; // default saturation
float shapeTransparency; // default transparency
float sphereLightRadius = 10.0f;
float sunflowMultiply = 1; // multiplication factor for the width & height of the sunflow render (1280x720 by default)
float translateX, translateXchange; // (change in) translation in the X-direction
float translateY, translateYchange; // (change in) translation in the Y-direction
float zoom = 1; // zoom factor

float[] defaultShapeValues;
float[] maxShapeValues;
float[] minShapeValues;

int eventValue;
int mx2;
int my2;
int numForLoop = 20; // max number of shapes, modifiers and/or subdividors in the gui (for convenience, just increase when there are more)
int sceneHeight; // sketch height
int sceneWidth; // sketch width
int selectedShapeIndex = 0; // selected shape index: Dodecahedron
int shader = 301;
int x2;
int y2;
int[] triangles;

String timestamp; // timestamp to distinguish saves
String[] shapeLabels;
WB_Point[] points;

// ControlP5 variables
ControlP5 cp5;
Group g1;
Group g2;
Group g3;
Group g4;
ScrollableList modifyList;
ScrollableList shaderList;
ScrollableList shapeList;
Toggle sunsky;
Toggle whiteBackground;
Toggle blackBackground;

// Hemesh GUI variables
Shape selectedShape; // the selected shape object
ArrayList<Modifier> modifiers = new ArrayList<Modifier>();
ArrayList<Modifier> selectedModifiers = new ArrayList<Modifier>();
ArrayList<Shape> shapes = new ArrayList<Shape>();
ArrayList<ThreadRenderer> renderers = new ArrayList<ThreadRenderer>();

void setup() {
  fullScreen(OPENGL);
  smooth(4);

  sceneWidth = width / 2;
  sceneHeight = height / 2;
  lightsColor = color(lightsColorR, lightsColorG, lightsColorB, lightsColorA);

  resetShapeColors();
  createModifiersXY();
  createShapes();
  createModifiers();
  createGui();
  createHemesh();
}

void draw() {

  lightsColor = color(lightsColorR,lightsColorG,lightsColorB,lightsColorA);
  background(Config.CurrentTheme().Background);
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

  if (drawcp5) {
    noLights();
    perspective();
    hint(DISABLE_DEPTH_TEST);
    updateGui();
    cp5.draw();
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
