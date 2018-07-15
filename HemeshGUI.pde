import wblut.core.*;
import wblut.geom.*;
import wblut.hemesh.*;
import wblut.math.*;
import wblut.nurbs.*;
import wblut.processing.*;

import controlP5.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
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
import java.util.Base64;

String version = "HemeshGui v0.6-alpha";

Ani zoomAnimation;
Ani spinnerAnimationStart;
Ani spinnerAnimationEnd;

boolean autoRotate = false; // toggle autorotation
boolean dirLightBehindOn = false;
boolean dirLightBottomOn = false;
boolean dirLightFrontOn = false;
boolean dirLightLeftOn = false;
boolean dirLightRightOn = false;
boolean dirLightTopOn = false;
boolean drawcp5 = true; // toggle drawing of cp5 gui
boolean edgesOn = false; // toggle display of edges
boolean facesOn = true; // toggle display of faces
boolean isHoldingAlt = false;
boolean isHoldingShift = false;
boolean isHoldingCtrl = false;
boolean isMeshCollection = false;
boolean isUpdatingMesh = false;
boolean savePreview = false; // toggle sunflow render quality
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
boolean sunflowSkyLightOn = true;
boolean validateMesh = false;

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
float dirLightRadius = Config.Lights.Radius.Default;
float lightsColorA = Config.Lights.Color.Alpha;
float lightsColorB = Config.Lights.Color.Blue;
float lightsColorG = Config.Lights.Color.Green;
float lightsColorR = Config.Lights.Color.Red;
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
float sphereLightRadius = Config.Lights.Radius.Default;
float spinnerAngleStart = Config.Spinner.StartAngle;
float spinnerAngleEnd = Config.Spinner.EndAngle;
float sunflowMultiply = 1; // multiplication factor for the width & height of the sunflow render (screen width/screen height by default)
float translateX, translateXchange; // (change in) translation in the X-direction
float translateY, translateYchange; // (change in) translation in the Y-direction
float rotationZ;
float xDelta, yDelta;
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
int sceneHeight; // sketch height
int sceneWidth; // sketch width
int selectedShapeIndex, selectedShaderIndex = 0; // selected shape index: box
int x2;
int y2;
int waitTime = 250;
int maxShapeParameters = 0;
int[] triangles;

long renderingTime = millis();
String timestamp; // timestamp to distinguish saves
String currentThemeName = Config.getCurrentThemeName();
String quicksaveFilePath = sketchPath() + "/settings/quicksave.json";
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
WB_Render3D render;
WB_RandomOnSphere randomSphere = new WB_RandomOnSphere();

void setup() {
  sceneWidth = width;
  sceneHeight = height;
  rotationY = 45;
  rotationX = -30;
  lightsColor = color(lightsColorR, lightsColorG, lightsColorB, lightsColorA);

  updateShapeColors();
  createAnimations();
  createModifiersXY();
  createShapes();
  createModifiers();
  createShaders();
  createGui();
  createHemesh();
}

void settings() {
  fullScreen(OPENGL);
  smooth(4);
}

void draw() {
  lightsColor = color(lightsColorR, lightsColorG, lightsColorB, lightsColorA);

  background(currentTheme.Background);
  perspective(perspective, (float)width/height, 1, 100000);
  lights();
  camera();

  pushMatrix();
  viewport();
  drawHemesh();
  popMatrix();

  pushMatrix();
  drawWaitState();
  popMatrix();

  // save frame(s) without gui
  if (saveOn == true && saveOpenGL == true) {
    if (saveContinuous) {
      save("renders/sequence/" + timestamp + "/opengl-" + nf(frameCount-1,4) + ".tga");
    }
    else {
      save("renders/screenshots/" + timestamp + "-opengl.png");
    }
  }

  if (drawcp5) {
    noLights();
    perspective();
    hint(DISABLE_DEPTH_TEST);
    try {
      cp5.draw();
    } catch(ConcurrentModificationException ex) {
      ex.printStackTrace();
      println("Received ConcurrentModificationException. This happens a fair bit, trying to continue...");
    } catch(Exception ex) {
      ex.printStackTrace();
    }
    hint(ENABLE_DEPTH_TEST);
    lights();
  }

  // save frame(s) with gui
  if (saveOn == true && saveGui == true) {
    if (saveContinuous) {
      save("renders/sequence/" + timestamp + "/gui-" + nf(frameCount-1,4) + ".tga");
    }
    else {
      save("renders/screenshots/" + timestamp + "-gui.png");
    }
  }

  // sunflow rendering (mask and/or regular sunflow render)
  if (saveOn) {
    if (saveSunflow == true || saveMask == true) {
      hemeshToSunflow();
      sunflow();
    }
  }

  // turn off saving after one frame if continuous is set to false
  if (saveOn == true && saveContinuous == false) {
    saveOn = false;
    println("Saving stopped after one frame (non-continuous)");
  }
}
