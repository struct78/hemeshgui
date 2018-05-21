
import controlP5.*;
import java.util.Iterator;
ControlP5 controlP5;
ScrollableList shapeList;
ScrollableList shaderList;
ScrollableList modifyList;
Group g1;
Group g2;
Group g3;
Group g4;

Group gl1;
Group gl2;
Group gl3;
Group gl4;

void gui() {
  // Create groups

  controlP5 = new ControlP5(this);
  controlP5.setAutoDraw(false);

  g1 = controlP5.addGroup("g1");
  g2 = controlP5.addGroup("g2");
  g3 = controlP5.addGroup("g3");
  g4 = controlP5.addGroup("g4");

  // gui colors
  controlP5.setColorBackground(color(162, 153, 125));
  controlP5.setColorForeground(color(204, 204, 0));
  controlP5.setColorCaptionLabel(color(0, 0, 0));
  controlP5.setColorValueLabel(color(0, 0, 0));
  controlP5.setColorActive(color(224, 224, 0));

  // camera control
  controlP5.addTextlabel("lblCamera")
    .setText("CAMERA CONTROL")
    .setPosition(17, 8)
    .setColorValue(0x0)
    .moveTo(g1)
    ;
  controlP5.addSlider("zoom", 0, 300, 20, 20, 200, 15).setDecimalPrecision(0).moveTo(g1);
  controlP5.addSlider("changeSpeedX", -5, 5, 20, 40, 200, 15).setLabel("Change X").moveTo(g1);
  controlP5.addSlider("changeSpeedY", -5, 5, 20, 60, 200, 15).setLabel("Change Y").moveTo(g1);
  controlP5.addToggle("autoRotate", 20, 80, 63, 15).setLabel("autoRotate (r)").moveTo(g1);
  controlP5.addToggle("translationOn", 88, 80, 64, 15).setLabel("translation\n(t or L-mouse)").moveTo(g1);
  controlP5.addToggle("rotationOn", 157, 80, 63, 15).setLabel("rotation\n(y or R-mouse)").moveTo(g1);

  // shape color and frame
  controlP5.addTextlabel("lblShape")
    .setText("SHAPE COLOR")
    .setPosition(17, 118)
    .setColorValue(0x0)
    .moveTo(g2)
    ;
  controlP5.addSlider("shapeHue", 0, 360, 20, 130, 200, 15).setLabel("Hue").setDecimalPrecision(0).moveTo(g2);
  controlP5.addSlider("shapeSaturation", 0, 100, 20, 150, 200, 15).setLabel("Saturation").setDecimalPrecision(0).moveTo(g2);
  controlP5.addSlider("shapeBrightness", 0, 100, 20, 170, 200, 15).setLabel("Brightness").setDecimalPrecision(0).moveTo(g2);
  controlP5.addSlider("shapeTransparency", 0, 100, 20, 190, 200, 15).setLabel("Transparency").setDecimalPrecision(0).moveTo(g2);


  controlP5.addToggle("facesOn", 20, 220, 63, 15).setLabel("Toggle Faces").moveTo(g2);
  controlP5.addToggle("edgesOn", 88, 220, 64, 15).setLabel("Toggle Edges").moveTo(g2);

  // reset controls
  controlP5.addButton("resetView", 0, 20, 285, 63, 40).setLabel("Reset Cam &\nShape Color");
  controlP5.addButton("resetLights", 0, 87, 285, 62, 40).setLabel("Reset Lights");
  controlP5.addButton("reset", 0, 153, 285, 63, 40).setLabel("Reset\nEverything");

  // lights control
  gl1 = controlP5.addGroup("gl1").setLabel("BASIC SUNFLOW SCENE LIGHT").setHeight(15);
  controlP5.addTextlabel("lblBasic")
    .setText("Basic scene elements")
    .setPosition(0, 0)
    .setColorValue(0x0)
    .setGroup(gl1)
    ;
  controlP5.addToggle("sunSkyLightOn", 20, 15, 40, 15)
    .setLabel("Basic Sunsky")
    .setGroup(gl1)
    ;

  controlP5.addToggle("sunflowWhiteBackgroundOn", 20, 55, 40, 15)
    .setLabel("White Background")
    .setGroup(gl1)
    ;

  controlP5.addToggle("sunflowBlackBackgroundOn", 100, 55, 40, 15)
    .setLabel("Black Background")
    .setGroup(gl1)
    ;


  gl2 = controlP5.addGroup("gl2").setLabel("DIRECTIONAL LIGHT").setHeight(15);
  controlP5.addTextlabel("lblDirLight")
    .setText("Pointed to center of mesh object")
    .setPosition(0, 0)
    .setColorValue(0x0)
    .setGroup(gl2)
    ;

  controlP5.addToggle("dirLightTopOn", 70, 20, 40, 15).setLabel("TOP").setGroup(gl2);
  controlP5.addToggle("dirLightRightOn", 118, 20, 40, 15).setLabel("RIGHT").setGroup(gl2);
  controlP5.addToggle("dirLightFrontOn", 166, 20, 40, 15).setLabel("FRONT").setGroup(gl2);
  controlP5.addToggle("dirLightBottomOn", 70, 50, 40, 15).setLabel("BOTTOM").setGroup(gl2);
  controlP5.addToggle("dirLightLeftOn", 118, 50, 40, 15).setLabel("LEFT").setGroup(gl2);
  controlP5.addToggle("dirLightBehindOn", 166, 50, 40, 15).setLabel("BEHIND").setGroup(gl2);
  controlP5.addKnob("dirLightRadius")
    .setRange(0, 30)
    .setPosition(3, 25)
    .setRadius(20)
    .setLabel("Radius")
    .setDragDirection(Knob.HORIZONTAL)
    .setGroup(gl2)
    ;

  gl3 = controlP5.addGroup("gl3").setLabel("SPHERE LIGHT").setHeight(15);
  controlP5.addTextlabel("lblSphereLight")
    .setText("Sphere lights around mesh object")
    .setPosition(0, 0)
    .setColorValue(0x0)
    .setGroup(gl3)
    ;
  controlP5.addToggle("sphereLightTopOn", 70, 10, 40, 15).setLabel("TOP").setGroup(gl3);
  controlP5.addToggle("sphereLightRightOn", 118, 10, 40, 15).setLabel("RIGHT").setGroup(gl3);
  controlP5.addToggle("sphereLightFrontOn", 166, 10, 40, 15).setLabel("FRONT").setGroup(gl3);
  controlP5.addToggle("sphereLightBottomOn", 70, 40, 40, 15).setLabel("BOTTOM").setGroup(gl3);
  controlP5.addToggle("sphereLightLeftOn", 118, 40, 40, 15).setLabel("LEFT").setGroup(gl3);
  controlP5.addToggle("sphereLightBehindOn", 166, 40, 40, 15).setLabel("BEHIND").setGroup(gl3);
  controlP5.addKnob("sphereLightRadius")
    .setRange(0, 30)
    .setPosition(3, 15)
    .setRadius(20)
    .setLabel("Radius")
    .setDragDirection(Knob.HORIZONTAL)
    .setGroup(gl3)
    ;

  gl4 = controlP5.addGroup("gl4").setLabel("COLOR LIGHTS").setHeight(15).setBackgroundColor(lightsColor);
  controlP5.addTextlabel("lblLightsColor")
    .setText("Color lights used by all light (and some shader)")
    .setPosition(0, 0)
    .setColorValue(0x0)
    .setGroup(gl4)
    ;
  controlP5.addSlider("lightsColorR", 0, 255, 10, 20, 150, 10).setLabel("R").setDecimalPrecision(0).setGroup(gl4);
  controlP5.addSlider("lightsColorG", 0, 255, 10, 35, 150, 10).setLabel("G").setDecimalPrecision(0).setGroup(gl4);
  controlP5.addSlider("lightsColorB", 0, 255, 10, 50, 150, 10).setLabel("B").setDecimalPrecision(0).setGroup(gl4);
  controlP5.addSlider("lightsColorA", 0, 255, 10, 65, 150, 10).setLabel("A").setDecimalPrecision(0).setGroup(gl4);

  controlP5.addButton("lightsColorLikeShapeColor", 0, 40, 85, 80, 15).setLabel("Like Shape Color").setGroup(gl4);

  Accordion lightsControl = controlP5.addAccordion("lights")
    .setPosition(17, 350)
    .setWidth(200)
    .addItem(gl1)
    .addItem(gl2)
    .addItem(gl3)
    .addItem(gl4)
    .setItemHeight(120)
    ;


  // basic shape variables
  controlP5.addTextlabel("lblShapeParameters")
    .setText("SHAPE PARAMETERS")
    .setPosition(width-253, 8)
    .setColorValue(0x0)
    .moveTo(g3)
    ;
  controlP5.addTextlabel("lblCurrentShape")
    .setText("SHAPE :" + numToName(creator))
    .setPosition(width-123, 8)
    .setColorValue(color(255, 0, 0))
    .moveTo(g3)
    ;
  controlP5.addSlider("create0", 0, 50, width-250, 20, 200, 15).setDecimalPrecision(0).moveTo(g3);
  controlP5.addSlider("create1", 0, 50, width-250, 40, 200, 15).setDecimalPrecision(0).moveTo(g3);
  controlP5.addSlider("create2", 0, 50, width-250, 60, 200, 15).setDecimalPrecision(0).moveTo(g3);
  controlP5.addSlider("create3", 0, 50, width-250, 80, 200, 15).setDecimalPrecision(0).moveTo(g3);
  setShapeParameters(creator);

  // ShapeList
  shapeList = controlP5.addScrollableList("myShapeList", width-250, 125, 96, 400).setGroup(g3);

  shapeList.setBarHeight(20);
  shapeList.setItemHeight(15);
  shapeList.getCaptionLabel().set("Select Shape");
  shapeList.getCaptionLabel().getStyle().marginTop = 6;
  shapeList.getCaptionLabel().getStyle().marginLeft = 3;
  shapeList.setBackgroundColor(color(30, 30, 30));
  shapeList.close();

  for (int i=0; i<numForLoop; i++) {
    if (numToName(i) != "None") {
      shapeList.addItem(numToName(i), i);
    }
  }

  // ModifyList
  modifyList = controlP5.addScrollableList("myModifyList", width-146, 125, 96, 400).setGroup(g3);
  modifyList.setBarHeight(20);
  modifyList.setItemHeight(15);
  modifyList.getCaptionLabel().set("Select Modifier");
  modifyList.getCaptionLabel().getStyle().marginTop = 6;
  modifyList.getCaptionLabel().getStyle().marginLeft = 3;
  modifyList.setBackgroundColor(color(30, 30, 30));

  // modifiers
  for (int i=101; i<101 + numForLoop; i++) {
    if (numToName(i) != "None") {
      modifyList.addItem(numToName(i), i);
    }
  }

  // ===
  modifyList.addItem(numToName(-1), -1);

  // subdividors
  for (int i=201; i<201 + numForLoop; i++) {
    if (numToName(i) != "None") {
      modifyList.addItem(numToName(i), i);
    }
  }

  modifyList.close();



  // sunflow shaders
  controlP5.addTextlabel("lblShaderParameters")
    .setText("SUNFLOW SHADER")
    .setPosition(width-253, 448)
    .setColorValue(0x0)
    .setGroup(g4)
    ;
  controlP5.addTextlabel("lblCurrentShader")
    .setText("SHADER :" + numToName(shader))
    .setPosition(width-250, 548)
    .setColorValue(color(255, 0, 0))
    .moveTo(g4)
    ;
  controlP5.addSlider("param0", 0.0f, 1.0f, width-250, 460, 200, 15).setGroup(g4);
  controlP5.addSlider("param1", 0.0f, 1.0f, width-250, 480, 200, 15).setGroup(g4);
  controlP5.addSlider("param2", 0.0f, 1.0f, width-250, 500, 200, 15).setGroup(g4);
  controlP5.addSlider("param3", 0.0f, 1.0f, width-250, 520, 200, 15).setGroup(g4);
  setShaderParameters(shader);

  // ShaderList
  shaderList = controlP5.addScrollableList("myShaderList", width-250, 565, 96, 400).setGroup(g4);
  shaderList.setBarHeight(20);
  shaderList.setItemHeight(15);
  shaderList.getCaptionLabel().set("Select Shader");
  shaderList.getCaptionLabel().getStyle().marginTop = 6;
  shaderList.getCaptionLabel().getStyle().marginLeft = 3;
  shaderList.setBackgroundColor(color(30, 30, 30));
  shaderList.close();

  for (int i=301; i<numForLoop+301; i++) {
    if (numToName(i) != "None") {
      shaderList.addItem(numToName(i), i);
    }
  }

  // render type & saving variables
  controlP5.addTextlabel("lblSave")
    .setText("WHAT TO SAVE")
    .setPosition(17, height-172)
    .setColorValue(0x0)
    ;
  controlP5.addToggle("saveOpenGL", 20, height-160, 65, 15).setLabel("OpenGL Current View");
  controlP5.addToggle("saveSunflow", 120, height-160, 65, 15).setLabel("Sunflow Rendering");

  controlP5.addToggle("saveGui", 20, height-130, 65, 15).setLabel("GUI");
  controlP5.addToggle("saveMask", 120, height-130, 65, 15).setLabel("Sunflow Mask");

  controlP5.addToggle("preview", 20, height-85, 65, 15).setLabel("Sunflow Preview");
  controlP5.addToggle("saveContinuous", 20, height-55, 65, 15).setLabel("Continuously").setColorCaptionLabel(color(0, 0, 0));

  controlP5.addButton("save", 0, 120, height-85, 70, 45).setLabel("SAVE / RENDER");

  controlP5.addTextlabel("lblSunflowSize")
    .setText("SUNFLOW RENDERING SIZE : " + int(sceneWidth*sunflowMultiply)+ " x " + int(sceneHeight*sunflowMultiply))
    .setPosition(17, height-20)
    .setColorValue(color(255, 0, 0))
    ;


  controlP5.addButton("quickSave", 0, width-186, height-60, 60, 45).setLabel("  Quick Save\n  Settings");
  controlP5.addButton("quickLoad", 0, width-106, height-60, 60, 45).setLabel("  Quick Load\n  Settings");

  //title
  controlP5.addTextlabel("lblTitle")
    .setText(version)
    .setPosition(width/2-250, 8)
    .setColorValue(0x0)
    ;

  // help text
  controlP5.addTextlabel("lblShortcuts")
    .setText("[SHORTCUTS]")
    .setPosition(width/2-20, 8)
    .setColorValue(0x0)
    ;

  controlP5.getTooltip().setDelay(150).setColorLabel(0x0) ;
  String helpTxt  = "c : high quality sunflow render\n";
  helpTxt += "x : preview quality sunflow render\n";
  helpTxt += "z : save a single screenshot\n";
  helpTxt += "r : toggle autoRotate\n";
  helpTxt += "t : toggle translation\n";
  helpTxt += "y : toggle rotation\n";
  helpTxt += "5 : toggle GUI\n";
  helpTxt += "0 : set X & Y speed of translation & rotation to zero\n";
  helpTxt += "s : toggle sunflow mode\n";
  helpTxt += "l : export to STL file\n";
  helpTxt += "./, : increase/decrease sunflow rendering size (x0.5)";
  controlP5.getTooltip().register("lblShortcuts", helpTxt);

  // ===========================================>
  // some non-gui stuff that needs to run @ setup

  // hemesh Renderer
  render = new WB_Render(this);

  // move origin to center of the screen
  translateX = width/2;
  translateY = height/2;

  // listen to mouseWheel (used for zooming)
  /*addMouseWheelListener(new java.awt.event.MouseWheelListener() {
   public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) {
   mouseWheel(evt.getWheelRotation());
   }});*/
}

// zooming with the mouseWheel
void mouseWheel(int delta) {
  if      (delta > 0) {
    if (zoom > 20) {
      controlP5.getController("zoom").setValue(zoom - 10);
    } else {
      controlP5.getController("zoom").setValue(zoom - 1);
    }
  } else if (delta < 0) {
    if (zoom >= 20) {
      controlP5.getController("zoom").setValue(zoom + 10);
    } else {
      controlP5.getController("zoom").setValue(zoom + 1);
    }
  }
}


void mouseReleased() {
  if (flagMouseControlTranslationMouvement && mouseButton == LEFT) {
    flagMouseControlTranslationMouvement = false;
    resetTranslationMouvement();
  } else if (flagMouseControlRotationMouvement && mouseButton == RIGHT) {
    flagMouseControlRotationMouvement = false;
    resetRotationMouvement();
  }
}


void mousePressed() {
  if (!controlP5.isMouseOver()) {
    if (mouseButton == LEFT) {
      flagMouseControlTranslationMouvement = true;
      controlP5.getController("translationOn").setValue(0);
    } else if (mouseButton == RIGHT) {
      flagMouseControlRotationMouvement = true;
      controlP5.getController("rotationOn").setValue(0);
      controlP5.getController("autoRotate").setValue(0);
    }
  }
}

void updateGui() {
  onMouseOver();
  gl4.setBackgroundColor(lightsColor);
}



void onMouseOver() {
  //println(controlP5.getMouseOverList());
  //http://www.sojamo.de/libraries/controlP5/reference/controlP5/ControlWindow.html

  String mouseOverList =  controlP5.getMouseOverList().toString();

  if (mouseOverList.contains("myShapeList")) {
    g3.bringToFront();
    shaderList.close();
    modifyList.close();
  }
  if (mouseOverList.contains("myModifyList")) {
    g3.bringToFront();
    shaderList.close();
    shapeList.close();
  }
  if (mouseOverList.contains("myShaderList") && !mouseOverList.contains("myShapeList")) {
    g4.bringToFront();
    shapeList.close();
    modifyList.close();
  }
  if (mouseOverList.contains("myShapeListButton0")) setShapeParameters(0);
  if (mouseOverList.contains("myShapeListButton1")) setShapeParameters(1);
  if (mouseOverList.contains("myShapeListButton2")) setShapeParameters(2);
  if (mouseOverList.contains("myShapeListButton3")) setShapeParameters(3);
  if (mouseOverList.contains("myShapeListButton4")) setShapeParameters(4);
  if (mouseOverList.contains("myShapeListButton5")) setShapeParameters(5);
  if (mouseOverList.contains("myShapeListButton6")) setShapeParameters(6);
  if (mouseOverList.contains("myShapeListButton7")) setShapeParameters(7);
  if (mouseOverList.contains("myShapeListButton8")) setShapeParameters(8);
  if (mouseOverList.contains("myShapeListButton9")) setShapeParameters(9);
  if (mouseOverList.contains("myShapeListButton10")) setShapeParameters(10);
  if (mouseOverList.contains("myShapeListButton11")) setShapeParameters(11);

  if (mouseOverList.contains("myShaderListButton0")) setShaderParameters(301);
  if (mouseOverList.contains("myShaderListButton1")) setShaderParameters(302);
  if (mouseOverList.contains("myShaderListButton2")) setShaderParameters(303);
  if (mouseOverList.contains("myShaderListButton3")) setShaderParameters(304);
  if (mouseOverList.contains("myShaderListButton4")) setShaderParameters(305);
  if (mouseOverList.contains("myShaderListButton5")) setShaderParameters(306);
  if (mouseOverList.contains("myShaderListButton6")) setShaderParameters(307);
  if (mouseOverList.contains("myShaderListButton7")) setShaderParameters(308);
}

void setShapeParameters(int shapeNum) {
  controlP5.getController("create0").setLabel("");
  controlP5.getController("create1").setLabel("");
  controlP5.getController("create2").setLabel("");
  controlP5.getController("create3").setLabel("");

  switch(shapeNum) {
  case 0 :
    controlP5.getController("create0").setLabel("Depth");
    controlP5.getController("create1").setLabel("Height");
    controlP5.getController("create2").setLabel("Width");
    break;
  case 1 :
    controlP5.getController("create0").setLabel("Radius");
    controlP5.getController("create1").setLabel("Height");
    controlP5.getController("create2").setLabel("Facets");
    controlP5.getController("create3").setLabel("Steps");
    break;
  case 2 :
    controlP5.getController("create0").setLabel("Edge");
    break;
  case 3 :
    controlP5.getController("create0").setLabel("Radius");
    controlP5.getController("create1").setLabel("Level");
    break;
  case 4 :
    controlP5.getController("create0").setLabel("Radius");
    controlP5.getController("create1").setLabel("UFacets");
    controlP5.getController("create2").setLabel("VFacets");
    break;
  case 5 :
    controlP5.getController("create0").setLabel("Radius");
    controlP5.getController("create1").setLabel("Height");
    controlP5.getController("create2").setLabel("Facets");
    controlP5.getController("create3").setLabel("Steps");
    break;
  case 6 :
    controlP5.getController("create0").setLabel("Edge");
    break;
  case 7 :
    controlP5.getController("create0").setLabel("Edge");
    break;
  case 8 :
    controlP5.getController("create0").setLabel("Edge");
    break;
  case 9 :
    controlP5.getController("create0").setLabel("Radius1");
    controlP5.getController("create1").setLabel("Radius2");
    controlP5.getController("create2").setLabel("TubeFacets");
    controlP5.getController("create3").setLabel("TorusFacets");
    break;
  case 10 :
    controlP5.getController("create0").setLabel("Width");
    controlP5.getController("create1").setLabel("Height");
    controlP5.getController("create2").setLabel("Disturb");
    break;
  case 11 :
    controlP5.getController("create0").setLabel("NB POINT\nx10000");
    controlP5.getController("create1").setLabel("Width");
    controlP5.getController("create2").setLabel("Height");
    controlP5.getController("create3").setLabel("Depth");
    break;

  default:
    break;
  }
}

void setShaderParameters(int shaderNum) {
  ((Slider)controlP5.getController("param0")).setLabel("").setRange(0.0f, 1.0f).setValue(0.0f).setDecimalPrecision(2);
  ((Slider)controlP5.getController("param1")).setLabel("").setRange(0.0f, 1.0f).setValue(0.0f).setDecimalPrecision(2);
  ((Slider)controlP5.getController("param2")).setLabel("").setRange(0.0f, 1.0f).setValue(0.0f).setDecimalPrecision(2);
  ((Slider)controlP5.getController("param3")).setLabel("").setRange(0.0f, 1.0f).setValue(0.0f).setDecimalPrecision(2);

  switch(shaderNum) {
  case 301 :
    ((Slider)controlP5.getController("param0")).setLabel("shinyness").setRange(0.0f, 1.0f).setValue(0.25f);
    break;
  case 302 :
    ((Slider)controlP5.getController("param0")).setLabel("Index Refraction").setRange(0.0f, 5.0f).setValue(1.5f);
    ((Slider)controlP5.getController("param1")).setLabel("absorptionDistance").setRange(0.0f, 10.0f).setValue(5.0f);
    break;
  case 305 :
    ((Slider)controlP5.getController("param0")).setLabel("power").setRange(0, 500).setValue(50).setDecimalPrecision(0);
    break;
  case 307 :
    ((Slider)controlP5.getController("param0")).setLabel("roughnessX").setRange(0.0f, 1.0f).setValue(1.0f);
    ((Slider)controlP5.getController("param1")).setLabel("roughnessY").setRange(0.0f, 1.0f).setValue(1.0f);
    break;
  case 308 :
    ((Slider)controlP5.getController("param0")).setLabel("width").setRange(0.0f, 1.0f).setValue(1.0f);
    break;
  default:
    break;
  }
}

void lightsColorLikeShapeColor() {
  controlP5.getController("lightsColorR").setValue(red(shapecolor));
  controlP5.getController("lightsColorG").setValue(green(shapecolor));
  controlP5.getController("lightsColorB").setValue(blue(shapecolor));
  controlP5.getController("lightsColorA").setValue(alpha(shapecolor));

  lightsColor = color(lightsColorR, lightsColorG, lightsColorB, lightsColorA);
}

// resel all
void reset() {
  resetView();
  resetLights();
  // basic shape variables
  creator = 2;
  controlP5.getController("create0").setValue(4);
  controlP5.getController("create1").setValue(4);
  controlP5.getController("create2").setValue(4);
  controlP5.getController("create3").setValue(4);
  setShapeParameters(creator);
  controlP5.getController("lblCurrentShape").setValueLabel("SHAPE : " + numToName(creator));

  // sunflow shaders variables
  shader = 301;
  ((Slider)controlP5.getController("param0")).setValue(0.0f).setDecimalPrecision(2);
  ((Slider)controlP5.getController("param1")).setValue(0.0f).setDecimalPrecision(2);
  ((Slider)controlP5.getController("param2")).setValue(0.0f).setDecimalPrecision(2);
  ((Slider)controlP5.getController("param3")).setValue(0.0f).setDecimalPrecision(2);
  setShaderParameters(shader);
  controlP5.getController("lblCurrentShader").setValueLabel("SHADER : " + numToName(shader));

  // saving variables
  controlP5.getController("saveOpenGL").setValue(0);
  controlP5.getController("saveGui").setValue(1);
  controlP5.getController("saveSunflow").setValue(1);
  controlP5.getController("saveMask").setValue(0);
  controlP5.getController("preview").setValue(1);
  ((Toggle)controlP5.getController("saveContinuous")).setValue(0).setLabel("Continuously").setColorCaptionLabel(color(0, 0, 0));
  sunflowMultiply = 1;
  controlP5.getController("lblSunflowSize").setValueLabel("SUNFLOW RENDERING SIZE : " + int(sceneWidth*sunflowMultiply)+ " x " + int(sceneHeight*sunflowMultiply));

  // ShapeList + ModifyList
  shapeList.getCaptionLabel().set("Select Shape");
  modifyList.getCaptionLabel().set("Select Modifier");

  // remove the gui elements for all modifiers
  for (int i=0; i<modifiers.size(); i++) {
    controlP5.remove("remove" + i);
    for (int j=0; j<5; j++) {
      controlP5.remove(i+"v"+j);
    }
  }

  // remove all modifiers
  modifiers.clear();

  // start up again
  createHemesh();
}

void resetLights() {

  controlP5.getController("sunflowWhiteBackgroundOn").setValue(0);
  controlP5.getController("sunflowBlackBackgroundOn").setValue(0);

  // sunflow lights
  controlP5.getController("sunSkyLightOn").setValue(1);
  controlP5.getController("dirLightTopOn").setValue(0);
  controlP5.getController("dirLightRightOn").setValue(0);
  controlP5.getController("dirLightFrontOn").setValue(0);
  controlP5.getController("dirLightBottomOn").setValue(0);
  controlP5.getController("dirLightLeftOn").setValue(0);
  controlP5.getController("dirLightBehindOn").setValue(0);
  controlP5.getController("dirLightRadius").setValue(10);
  controlP5.getController("sphereLightTopOn").setValue(0);
  controlP5.getController("sphereLightRightOn").setValue(0);
  controlP5.getController("sphereLightFrontOn").setValue(0);
  controlP5.getController("sphereLightBottomOn").setValue(0);
  controlP5.getController("sphereLightLeftOn").setValue(0);
  controlP5.getController("sphereLightBehindOn").setValue(0);
  controlP5.getController("sphereLightRadius").setValue(10);

  // sunflow color lights
  controlP5.getController("lightsColorR").setValue(230);
  controlP5.getController("lightsColorG").setValue(230);
  controlP5.getController("lightsColorB").setValue(230);
  controlP5.getController("lightsColorA").setValue(255);
  lightsColor = color(lightsColorR, lightsColorG, lightsColorB, lightsColorA);
}

// reset the camera view & color
void resetView() {

  // view
  controlP5.getController("zoom").setValue(20);
  controlP5.getController("changeSpeedX").setValue(1.5);
  controlP5.getController("changeSpeedY").setValue(1.5);
  controlP5.getController("autoRotate").setValue(1);
  controlP5.getController("translationOn").setValue(0);
  controlP5.getController("rotationOn").setValue(0);
  translateX = width/2;
  translateY = height/2;
  rotationX = 0;
  rotationY = 0;
  actualZoom = 20;
  flagMouseControlRotationMouvement = false;
  flagMouseControlTranslationMouvement = false;
  resetRotationMouvement();
  resetTranslationMouvement();

  // presentation
  controlP5.getController("shapeHue").setValue(57);
  controlP5.getController("shapeSaturation").setValue(100);
  controlP5.getController("shapeBrightness").setValue(96);
  controlP5.getController("shapeTransparency").setValue(100);
  controlP5.getController("facesOn").setValue(1);
  controlP5.getController("edgesOn").setValue(1);
}


void quickSave() {
  shaderList.setValue(shader);
  shapeList.setValue(creator);
  controlP5.saveProperties(sketchPath() + "/output/quicksave");
}

void quickLoad() {
  controlP5.loadProperties(sketchPath() + "/output/quicksave");
  shader = (int) shaderList.getValue();
  creator = (int) shapeList.getValue();
  setShapeParameters(creator);
  setShaderParameters(shader);
}

// toggle saving function (with console feedback)
void save() {
  if (saveOn) {
    saveOn = false;
    ((Toggle)controlP5.getController("saveContinuous")).setLabel("Continuously").setColorCaptionLabel(color(0, 0, 0));
    println("Saving stopped");
  } else {
    drawControlP5 = true;
    if (saveContinuous) ((Toggle)controlP5.getController("saveContinuous")).setLabel("Continuously [Saving]").setColorCaptionLabel(color(255, 0, 0));
    timestamp = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    saveOn = true;
    print("\nSaving started (" + timestamp +")");
    if (saveOpenGL) {
      print(" | OpenGL Current View");
    }
    if (saveGui) {
      print(" | Gui");
    }
    if (saveSunflow) {
      print(" | Render Sunflow");
    }
    if (saveMask) {
      print(" | Save Sunflow Mask");
    }
    print("\n");
  }
}

// command & control center ;-)
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isController()) {

    if (theEvent.getController().getName() == "myShapeList") {
      creator = int(theEvent.getController().getValue());
      controlP5.getController("lblCurrentShape").setValueLabel("SHAPE : " + numToName(creator));
      createHemesh();
    }

    // when a shader is selected
    if (theEvent.getController().getName() == "myShaderList") {
      int selected = int(theEvent.getController().getValue());
      shader = (int)controlP5.get(ScrollableList.class, "myShaderList").getItem(selected).get("value");
      controlP5.getController("lblCurrentShader").setValueLabel("SHADER : " + numToName(shader));
    }

    // when a modifier is selected
    if (theEvent.getController().getName() == "myModifyList" && int(theEvent.getController().getValue()) > 0) {
      int selected = int(theEvent.getController().getValue());
      int value = (int)controlP5.get(ScrollableList.class, "myModifyList").getItem(selected).get("value");
      modifiers.add( new Modifier(modifiers.size(), value, numToFloats(value)) );
      createHemesh();
      modifyList.getCaptionLabel().set("Select Modifier");
    }

    // when a remove button is pressed
    if (theEvent.getController().getName().startsWith("remove")) {
      modifiers.remove(theEvent.getController().getId());
      controlP5.remove("remove" + theEvent.getController().getId());
      for (int i=0; i<5; i++) {
        controlP5.remove(theEvent.getController().getId()+"v"+i);
      }
      createHemesh();
    }

    for (int i=0; i<5; i++) {
      // forward modify values from controlP5 into seperate classes
      if (theEvent.getController().getName().endsWith("v" + i)) {
        Modifier m = (Modifier) modifiers.get(theEvent.getController().getId());
        for (int j=0; j<5; j++) {
          if (i==j) {
            m.values[j] = theEvent.getValue();
          }
        }
        createHemesh();
      }

      // force createHemesh after changes in create variables
      if (theEvent.getName().matches("create" + i)) {
        createHemesh();
      }
    }
  }
}

// some useful keyboard actions
void keyPressed() {

  // toggle autoRotate, translation & rotation
  if (key == 'r') {
    if (autoRotate == false) {
      controlP5.getController("autoRotate").setValue(1);
    } else {
      controlP5.getController("autoRotate").setValue(0);
    }
  }
  if (key == 't') {
    if (translationOn == false) {
      controlP5.getController("translationOn").setValue(1);
    } else {
      controlP5.getController("translationOn").setValue(0);
    }
  }
  if (key == 'y') {
    if (rotationOn == false) {
      controlP5.getController("rotationOn").setValue(1);
    } else {
      controlP5.getController("rotationOn").setValue(0);
    }
  }

  // toggle the controlP5 gui
  if (key == '5') {
    drawControlP5 = !drawControlP5;
  }

  // set X & Y speed of translation & rotation to zero
  if (key == '0') {
    controlP5.getController("changeSpeedX").setValue(0);
    controlP5.getController("changeSpeedY").setValue(0);
  }

  // toggle sunflow manually
  if (key == 's') {
    if (saveSunflow) {
      controlP5.getController("saveSunflow").setValue(0);
    } else {
      controlP5.getController("saveSunflow").setValue(1);
    }
  }

  // save a single screenshot
  if (key == 'z') {
    timestamp = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    save("output/screenshots/" + timestamp + " (gui).png");
    println("Screenshot of current GUI saved");
  }

  // preview quality sunflow render (+ gui screenshot)
  if (key == 'x') {
    controlP5.getController("autoRotate").setValue(0);
    ((Toggle)controlP5.getController("saveContinuous")).setValue(0).setLabel("Continuously").setColorCaptionLabel(color(0, 0, 0));
    controlP5.getController("saveGui").setValue(1);
    controlP5.getController("preview").setValue(1);
    controlP5.getController("saveSunflow").setValue(1);
    save();
  }

  // high quality sunflow render (+ gui screenshot)
  if (key == 'c') {
    controlP5.getController("autoRotate").setValue(0);
    ((Toggle)controlP5.getController("saveContinuous")).setValue(0).setLabel("Continuously").setColorCaptionLabel(color(0, 0, 0));
    controlP5.getController("saveGui").setValue(1);
    controlP5.getController("preview").setValue(0);
    controlP5.getController("saveSunflow").setValue(1);
    save();
  }

  // export shape to a STL file
  if (key == 'l') {
    timestamp = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    String path = sketchPath() + "/output/export_stl/" + timestamp + ".stl";
    HET_Export exporter = new HET_Export();
    //exporter.saveToSTL(myShape, path, 1);
    println("STL exported");
  }

  // decrease sunflow multiplication factor by 0.5 (key: <)
  if (key == ',') {
    if (sunflowMultiply >= 1) {
      sunflowMultiply -= 0.5;
    }
    println("Sunflow render output: " + int(sceneWidth*sunflowMultiply) + " x " + int(sceneHeight*sunflowMultiply));
    controlP5.getController("lblSunflowSize")
      .setValueLabel("SUNFLOW RENDERING SIZE : " + int(sceneWidth*sunflowMultiply)+ " x " + int(sceneHeight*sunflowMultiply));
  }

  // increase sunflow multiplication factor by 0.5 (key: >)
  if (key == '.') {
    sunflowMultiply += 0.5;
    println("Sunflow render output: " + int(sceneWidth*sunflowMultiply) + " x " + int(sceneHeight*sunflowMultiply));
    controlP5.getController("lblSunflowSize")
      .setValueLabel("SUNFLOW RENDERING SIZE : " + int(sceneWidth*sunflowMultiply)+ " x " + int(sceneHeight*sunflowMultiply));
  }
}
