import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

import controlP5.*;
import java.applet.*;
import java.awt.Dimension;
import java.awt.event.FocusEvent;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.awt.Frame;
import java.awt.Image;
import java.io.*;
import java.net.*;
import java.text.*;
import java.util.*;
import java.util.Iterator;
import java.util.regex.*;
import java.util.zip.*;
import processing.opengl.*;

String version = "HemeshGui v0.5-alpha";

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
boolean isMeshCollection = false;
boolean isUpdatingMesh = false;
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
color shapeColor; // shape color

final String SHADER_NAME = "hemeshShader";

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
float perspective = 0.518f;
float rotationX, rotationXchange; // (change in) rotation around the X-axis
float rotationY, rotationYchange; // (change in) rotation around the Y-axis
float shapeBrightness; // default brightness
float shapeHue; // default hue
float shapeSaturation; // default saturation
float shapeTransparency; // default transparency
float sphereLightRadius = 10.0f;
float sunflowMultiply = 1; // multiplication factor for the width & height of the sunflow render (screen width/screen height by default)
float translateX, translateXchange; // (change in) translation in the X-direction
float translateY, translateYchange; // (change in) translation in the Y-direction
float zoom = 1; // zoom factor

float[] defaultShapeValues;
float[] defaultShaderValues;
float[] maxShapeValues;
float[] minShapeValues;
float[] maxShaderValues;
float[] minShaderValues;

int eventValue;
int mx2;
int my2;
int numForLoop = 20; // max number of shapes, modifiers and/or subdividors in the gui (for convenience, just increase when there are more)
int sceneHeight; // sketch height
int sceneWidth; // sketch width
int selectedShapeIndex = 0; // selected shape index: box
int selectedShaderIndex = 0;
int x2;
int y2;
int waitTime = 250;
int[] triangles;

long renderingTime = millis();
String timestamp; // timestamp to distinguish saves
String currentThemeName = Config.getCurrentThemeName();
String[] shapeLabels;
String[] shaderLabels;
WB_Point[] points;

// ControlP5 variables
ControlP5 cp5;
Group g1;
Group g2;
Group g3;
Group g4;
HashMap<String, Theme> themes = Config.getThemes();
ScrollableList modifyList;
ScrollableList shaderList;
ScrollableList shapeList;
ScrollableList themeList;
Toggle sunsky;
Toggle whiteBackground;
Toggle blackBackground;

// Hemesh GUI variables
Shape selectedShape;
Shader selectedShader;
ArrayList<Modifier> modifiers = new ArrayList<Modifier>();
ArrayList<Modifier> selectedModifiers = new ArrayList<Modifier>();
ArrayList<Shape> shapes = new ArrayList<Shape>();
ArrayList<ThreadRenderer> renderers = new ArrayList<ThreadRenderer>();
ArrayList<Shader> shaders = new ArrayList<Shader>();
Theme currentTheme = Config.getCurrentTheme();

// Hemesh variables
HE_MeshCollection meshes;
HE_MeshCollection meshesBuffer;
HE_Mesh mesh;
HE_Mesh meshBuffer;
HEM_Extrude extrude1 = new HEM_Extrude();
HEM_Extrude extrude2 = new HEM_Extrude();
WB_Render render;

void setup() {
  fullScreen(OPENGL);
  smooth(4);

  sceneWidth = width;
  sceneHeight = height;
  lightsColor = color(lightsColorR, lightsColorG, lightsColorB, lightsColorA);

  updateShapeColors();
  createModifiersXY();
  createShapes();
  createModifiers();
  createShaders();
  createGui();
  createHemesh();
}

void draw() {

  lightsColor = color(lightsColorR, lightsColorG, lightsColorB, lightsColorA);
  background(currentTheme.Background);
  perspective(perspective, (float)width/height, 1, 100000);
  lights();

  pushMatrix();
  viewport();
  drawHemesh();
  popMatrix();

  pushMatrix();
  drawWaitState();
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
