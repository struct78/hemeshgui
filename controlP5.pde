int getInlineX(int index, int count) {
  if (index == 1) {
    return 0;
  }

  return ((Config.CP5.Controls.Width/count) * (index-1)) + (Config.CP5.Controls.Margin / 2);
}

int getLineHeight() {
    return int(Config.CP5.Controls.Height * .2);
}

int multiplyGrid(int ref) {
  return (ref * Config.CP5.Grid);
}

int multiplyControlHeight(int rows) {
  return (Config.CP5.Controls.Height * rows) + Config.CP5.Controls.Margin;
}

int divideControlWidth(int index, int count) {
  int newWidth = Config.CP5.Controls.Width / count;

  if (index == 1 && count != 1 || index == count) {
    newWidth -= (Config.CP5.Controls.Margin / 2);
  } else {
    newWidth -= Config.CP5.Controls.Margin;
  }

  if (index == count) {
    newWidth = Config.CP5.Controls.Width - getInlineX(index, count);
  }

  return newWidth;
}

void createModifiersXY() {
    mx2 = multiplyGrid(15);
    my2 = multiplyGrid(2);
}

void createGui() {
  // Create groups

  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);

  g1 = cp5.addGroup("g1");
  g2 = cp5.addGroup("g2");
  g3 = cp5.addGroup("g3");
  g4 = cp5.addGroup("g4");

  // gui colors
  cp5.setColorBackground(Config.CurrentTheme().ControlBackground);
  cp5.setColorForeground(Config.CurrentTheme().ControlForeground);
  cp5.setColorCaptionLabel(Config.CurrentTheme().ControlCaptionLabel);
  cp5.setColorValueLabel(Config.CurrentTheme().ControlValueLabel);
  cp5.setColorActive(Config.CurrentTheme().ControlActive);

  // camera control

  x2 = multiplyGrid(1);
  y2 = multiplyGrid(1);

  createGroup1();

  y2 += multiplyGrid(4);

  createGroup2();

  x2 = width - (Config.CP5.Grid * 3) - Config.CP5.Controls.Width;
  y2 = Config.CP5.Grid;

  createGroup3();

  x2 = width - (Config.CP5.Grid * 3) - Config.CP5.Controls.Width;
  y2 = height - multiplyGrid(12);

  createGroup4();

  // title
  cp5.addTextlabel("lblTitle")
    .setText(version.toUpperCase())
    .setPosition(width/2, y2)
    .setColorValue(Config.CurrentTheme().ControlCaptionLabel);

  cp5.getTooltip().setDelay(150).setColorLabel(Config.CurrentTheme().ControlValueLabel);
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
  cp5.getTooltip().register("lblShortcuts", helpTxt);

  // ===========================================>
  // some non-gui stuff that needs to run @ setup

  // hemesh Renderer
  render = new WB_Render(this);

  // move origin to center of the screen
  translateX = width/2;
  translateY = height/2;
}

void createGroup1() {
  cp5.addTextlabel("lblCamera")
    .setText("CAMERA CONTROL")
    .setPosition(x2, y2)
    .setColorValue(Config.CurrentTheme().ControlCaptionLabel)
    .moveTo(g1);

  y2 += multiplyGrid(1);

  cp5.begin(Config.CP5.Grid, y2);

  cp5.addSlider("zoom", 0, 300)
    .setDecimalPrecision(0)
    .setSize(Config.CP5.Controls.Width, Config.CP5.Controls.Height)
    .setPosition(x2, y2)
    .moveTo(g1);

  y2 += multiplyGrid(1);

  cp5.addSlider("changeSpeedX", -5, 5)
    .setLabel("Change X")
    .setSize(Config.CP5.Controls.Width, Config.CP5.Controls.Height)
    .setPosition(x2, y2)
    .moveTo(g1);

  y2 += multiplyGrid(1);

  cp5.addSlider("changeSpeedY", -5, 5)
    .setLabel("Change Y")
    .setSize(Config.CP5.Controls.Width, Config.CP5.Controls.Height)
    .setPosition(x2, y2)
    .moveTo(g1);

  y2 += multiplyGrid(1);

  cp5.addToggle("autoRotate", x2 + getInlineX(1, 3), y2, divideControlWidth(1, 3), Config.CP5.Controls.Height)
    .setLabel("autoRotate (r)")
    .moveTo(g1);

  cp5.addToggle("translationOn", x2 + getInlineX(2, 3), y2, divideControlWidth(2, 3), Config.CP5.Controls.Height)
    .setLabel("translation\n(t or L-mouse)")
    .moveTo(g1);

  cp5.addToggle("rotationOn", x2 + getInlineX(3, 3), y2, divideControlWidth(3, 3), Config.CP5.Controls.Height)
    .setLabel("rotation\n(y or R-mouse)")
    .moveTo(g1);

  cp5.end();

  y2 += multiplyGrid(3);

  cp5.begin(x2, y2);

  cp5.addButton("resetView", 0, x2, y2, divideControlWidth(1, 2), multiplyControlHeight(2))
    .setColorBackground(Config.CurrentTheme().ButtonBackground)
    .setColorLabel(Config.CurrentTheme().ButtonForeground)
    .setLabel("Reset Cam & Color");

  cp5.addButton("resetLights", 0, x2 + getInlineX(2, 2), y2, divideControlWidth(2, 2), multiplyControlHeight(2))
    .setColorBackground(Config.CurrentTheme().ButtonBackground)
    .setColorLabel(Config.CurrentTheme().ButtonForeground)
    .setLabel("Reset Lights");

  y2 += multiplyGrid(2);

  cp5.addButton("reset", 0, x2, y2, Config.CP5.Controls.Width, multiplyControlHeight(2))
    .setColorBackground(Config.CurrentTheme().ButtonBackground)
    .setColorLabel(Config.CurrentTheme().ButtonForeground)
    .setLabel("Reset Everything");

  cp5.end();
}

void createGroup2() {

    cp5.begin(x2, y2);

    // Sunflow: Scene
    //
    cp5.addTextlabel("lblSunflow")
      .setText("SUNFLOW SETTINGS")
      .setPosition(x2, y2)
      .setColorValue(Config.CurrentTheme().ControlCaptionLabel)
      .moveTo(g2);

    y2 += multiplyGrid(1);

    cp5.addTextlabel("lblSunflowScene")
      .setText("SCENE")
      .setPosition(x2, y2)
      .setColorValue(Config.CurrentTheme().ControlSubLabel)
      .moveTo(g2);

    y2 += multiplyGrid(1);

    // Option 1: Sunsky
    sunsky = cp5.addToggle("sunSkyLightOn", x2, y2, divideControlWidth(1, 4), Config.CP5.Controls.Height)
      .setLabel("")
      .setGroup(g2);

    sunsky.onClick(new CallbackListener() {
        public void controlEvent(CallbackEvent theEvent) {
          if (sunsky.getBooleanValue()) {
            //whiteBackground.setState(false);
            //blackBackground.setState(false);
          }
        }
      });

    cp5.addTextlabel("lblSkylights")
      .setText("BASIC SUNSKY")
      .setPosition(x2 + getInlineX(2, 4), y2 + getLineHeight())
      .setColorValue(Config.CurrentTheme().ControlSubLabel)
      .setGroup(g2);

    y2 += multiplyGrid(1);

    // Option 2: White
    whiteBackground = cp5.addToggle("sunflowWhiteBackgroundOn", x2, y2, divideControlWidth(1, 4), Config.CP5.Controls.Height)
      .setLabel("")
      .setPosition(x2, y2)
      .setGroup(g2);

    whiteBackground.onClick(new CallbackListener() {
        public void controlEvent(CallbackEvent theEvent) {
          if (whiteBackground.getBooleanValue()) {
            //blackBackground.setState(false);
            //sunsky.setState(false);
          }
        }
      });

    cp5.addTextlabel("lblWhite")
      .setText("WHITE BACKGROUND")
      .setPosition(x2 + getInlineX(2, 4), y2 + getLineHeight())
      .setColorValue(Config.CurrentTheme().ControlSubLabel)
      .setGroup(g2);

    y2 += multiplyGrid(1);

    // Option 3: Black
    blackBackground = cp5.addToggle("sunflowBlackBackgroundOn", x2, y2, divideControlWidth(1, 4), Config.CP5.Controls.Height)
      .setLabel("")
      .setPosition(x2, y2)
      .setGroup(g2);

    blackBackground.onClick(new CallbackListener() {
        public void controlEvent(CallbackEvent theEvent) {
          if (blackBackground.getBooleanValue()) {
            //whiteBackground.setState(false);
            //sunsky.setState(false);
          }
        }
      });

    cp5.addTextlabel("lblBlack")
      .setText("BLACK BACKGROUND")
      .setPosition(x2 + getInlineX(2, 4), y2 + getLineHeight())
      .setColorValue(Config.CurrentTheme().ControlSubLabel)
      .setGroup(g2);

    y2 += multiplyGrid(2);

    // Sunflow: Directional light
    cp5.addTextlabel("lblDirectionalLight")
      .setText("DIRECTIONAL LIGHT")
      .setPosition(x2, y2)
      .setColorValue(Config.CurrentTheme().ControlSubLabel)
      .setGroup(g2);

    y2 += multiplyGrid(1);

    cp5.addKnob("dirLightRadius")
      .setRange(0, 30)
      .setPosition(x2, y2)
      .setRadius((divideControlWidth(1, 4) - Config.CP5.Controls.Margin) / 2)
      .setLabel("Radius")
      .setDragDirection(Knob.VERTICAL)
      .setGroup(g2);

    cp5.addToggle("dirLightTopOn", x2 + getInlineX(2, 4), y2, divideControlWidth(2, 4), Config.CP5.Controls.Height)
      .setLabel("TOP")
      .setGroup(g2);

    cp5.addToggle("dirLightRightOn", x2 + getInlineX(3, 4), y2, divideControlWidth(3, 4), Config.CP5.Controls.Height)
      .setLabel("RIGHT")
      .setGroup(g2);

    cp5.addToggle("dirLightFrontOn", x2 + getInlineX(4, 4), y2, divideControlWidth(4, 4), Config.CP5.Controls.Height)
      .setLabel("FRONT")
      .setGroup(g2);

    y2 += multiplyGrid(2);

    cp5.addToggle("dirLightBottomOn", x2 + getInlineX(2, 4), y2, divideControlWidth(2, 4), Config.CP5.Controls.Height)
      .setLabel("BOTTOM")
      .setGroup(g2);

    cp5.addToggle("dirLightLeftOn", x2 + getInlineX(3, 4), y2, divideControlWidth(3, 4), Config.CP5.Controls.Height)
      .setLabel("LEFT")
      .setGroup(g2);

    cp5.addToggle("dirLightBehindOn", x2 + getInlineX(4, 4), y2, divideControlWidth(4, 4), Config.CP5.Controls.Height)
      .setLabel("BEHIND")
      .setGroup(g2);


    // Sunflow: Sphere light

    y2 += multiplyGrid(2);

    cp5.addTextlabel("lblSphereLight")
      .setText("SPHERE LIGHT")
      .setPosition(x2, y2)
      .setColorValue(Config.CurrentTheme().ControlSubLabel)
      .setGroup(g2);

    y2 += multiplyGrid(1);

    cp5.addKnob("sphereLightRadius")
      .setRange(0, 30)
      .setPosition(x2, y2)
      .setRadius((divideControlWidth(1, 4) - Config.CP5.Controls.Margin) / 2)
      .setLabel("Radius")
      .setDragDirection(Knob.VERTICAL)
      .setGroup(g2);

    cp5.addToggle("sphereLightTopOn", x2 + getInlineX(2, 4), y2, divideControlWidth(2, 4), Config.CP5.Controls.Height)
      .setLabel("TOP")
      .setGroup(g2);

    cp5.addToggle("sphereLightRightOn", x2 + getInlineX(3, 4), y2, divideControlWidth(3, 4), Config.CP5.Controls.Height)
      .setLabel("RIGHT")
      .setGroup(g2);

    cp5.addToggle("sphereLightFrontOn", x2 + getInlineX(4, 4), y2, divideControlWidth(4, 4), Config.CP5.Controls.Height)
      .setLabel("FRONT")
      .setGroup(g2);

    y2 += multiplyGrid(2);

    cp5.addToggle("sphereLightBottomOn", x2 + getInlineX(2, 4), y2, divideControlWidth(2, 4), Config.CP5.Controls.Height)
      .setLabel("BOTTOM")
      .setGroup(g2);

    cp5.addToggle("sphereLightLeftOn",  x2 + getInlineX(3, 4), y2, divideControlWidth(3, 4), Config.CP5.Controls.Height)
      .setLabel("LEFT")
      .setGroup(g2);

    cp5.addToggle("sphereLightBehindOn", x2 + getInlineX(4, 4), y2, divideControlWidth(4, 4), Config.CP5.Controls.Height)
      .setLabel("BEHIND")
      .setGroup(g2);


    y2 += multiplyGrid(2);


    cp5.addTextlabel("lblLightsColor")
      .setText("LIGHT COLOUR")
      .setPosition(x2, y2)
      .setColorValue(Config.CurrentTheme().ControlSubLabel)
      .setGroup(g2);

    y2 += multiplyGrid(1);

    cp5.addSlider("lightsColorR", 0, 255, x2, y2, Config.CP5.Controls.Width, Config.CP5.Controls.Height)
      .setLabel("R")
      .setDecimalPrecision(0)
      .setGroup(g2);

    y2 += multiplyGrid(1);

    cp5.addSlider("lightsColorG", 0, 255, x2, y2, Config.CP5.Controls.Width, Config.CP5.Controls.Height)
      .setLabel("G")
      .setDecimalPrecision(0)
      .setGroup(g2);

    y2 += multiplyGrid(1);

    cp5.addSlider("lightsColorB", 0, 255, x2, y2, Config.CP5.Controls.Width, Config.CP5.Controls.Height)
      .setLabel("B")
      .setDecimalPrecision(0)
      .setGroup(g2);

    y2 += multiplyGrid(1);

    cp5.addSlider("lightsColorA", 0, 255, x2, y2, Config.CP5.Controls.Width, Config.CP5.Controls.Height)
      .setLabel("A")
      .setDecimalPrecision(0)
      .setGroup(g2);

    y2 += multiplyGrid(1);

    cp5.addButton("lightsColorLikeShapeColor", 0, x2, y2, divideControlWidth(1, 2), Config.CP5.Controls.Height * 2)
      .setColorBackground(Config.CurrentTheme().ButtonBackground)
      .setColorLabel(Config.CurrentTheme().ButtonForeground)
      .setLabel("Like Shape Color")
      .setGroup(g2);

    y2 += multiplyGrid(4);

    // sunflow shaders
    cp5.addTextlabel("lblShader")
      .setPosition(x2, y2)
      .setText("SHADER")
      .setColorValue(Config.CurrentTheme().ControlSubLabel)
      .setGroup(g2);

    y2 += multiplyGrid(1);

    // ShaderList
    shaderList = cp5.addScrollableList("shaderList", x2, y2, Config.CP5.Controls.Width, 400)
      .setGroup(g2)
      .setBarHeight(Config.CP5.Controls.Height)
      .setItemHeight(Config.CP5.Controls.Height)
      .setBackgroundColor(Config.CurrentTheme().ControlBackground)
      .setColorLabel(Config.CurrentTheme().ControlValueLabel)
      .setColorValue(Config.CurrentTheme().ControlValueLabel);

    shaderList.close();
    shaderList.getCaptionLabel()
      .set("Select Shader")
      .alignY(cp5.CENTER);

    shaderList.onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        shaderList.bringToFront();
      }
    }).onChange(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        int selected = int(theEvent.getController().getValue());
        shader = (int)shaderList.getItem(selected).get("value");
      }
    });


    for (int i=301; i<numForLoop+301; i++) {
      if (numToName(i) != "None") {
        shaderList.addItem(numToName(i), i);
      }
    }

    y2 += multiplyGrid(2);

    cp5.addTextlabel("lblShaderParameters")
      .setPosition(x2, y2)
      .setText("SHADER PARAMETERS")
      .setColorValue(Config.CurrentTheme().ControlSubLabel)
      .setGroup(g2);

    y2 += multiplyGrid(1);

    cp5.addSlider("param0", 0.0f, 1.0f, x2, y2, Config.CP5.Controls.Width, Config.CP5.Controls.Height).setGroup(g2);

    y2 += multiplyGrid(1);

    cp5.addSlider("param1", 0.0f, 1.0f, x2, y2, Config.CP5.Controls.Width, Config.CP5.Controls.Height).setGroup(g2);

    y2 += multiplyGrid(1);

    cp5.addSlider("param2", 0.0f, 1.0f, x2, y2, Config.CP5.Controls.Width, Config.CP5.Controls.Height).setGroup(g2);

    y2 += multiplyGrid(1);

    cp5.addSlider("param3", 0.0f, 1.0f, x2, y2, Config.CP5.Controls.Width, Config.CP5.Controls.Height).setGroup(g2);

    y2 += multiplyGrid(1);

    setShaderParameters(shader);

    y2 = height - multiplyGrid(7);

    cp5.addButton("quickSave", 0, x2, y2, Config.CP5.Controls.Width, multiplyControlHeight(3))
      .setColorBackground(Config.CurrentTheme().ButtonBackground)
      .setColorLabel(Config.CurrentTheme().ButtonForeground)
      .setLabel("Quick Save Settings");

    y2 += multiplyGrid(3);

    cp5.addButton("quickLoad", 0, x2, y2, Config.CP5.Controls.Width, multiplyControlHeight(3))
      .setColorBackground(Config.CurrentTheme().ButtonBackground)
      .setColorLabel(Config.CurrentTheme().ButtonForeground)
      .setLabel("Quick Load Settings");

    cp5.end();
}

void createGroup3() {


  cp5.addTextlabel("lblShapesModifiers")
    .setText("SHAPE & MODIFIERS")
    .setPosition(x2, y2)
    .setColorValue(Config.CurrentTheme().ControlCaptionLabel)
    .moveTo(g3);

  y2 += multiplyGrid(1);

  // ShapeList
  shapeList = cp5.addScrollableList("shapeList", x2, y2, Config.CP5.Controls.Width, 400)
    .setGroup(g3)
    .setBarHeight(Config.CP5.Controls.Height)
    .setItemHeight(Config.CP5.Controls.Height)
    .setBackgroundColor(Config.CurrentTheme().ControlBackground)
    .setColorLabel(Config.CurrentTheme().ControlValueLabel)
    .setColorValue(Config.CurrentTheme().ControlValueLabel)
    .close();

  shapeList.getCaptionLabel()
    .set("Select Shape")
    .alignY(cp5.CENTER);

  for (int i = 0; i < shapes.size(); i++) {
    Shape shape = shapes.get(i);
    shapeList.addItem(shape.name, i);
  }

  shapeList.setValue(selectedShapeIndex);
  shapeList.onChange(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      selectedShapeIndex = int(shapeList.getValue());
      setShapeParameters(selectedShapeIndex);
      createHemesh();
    }
  }).onClick(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if (shapeList.isOpen()) {
        modifyList.close();
        shapeList.bringToFront();
      }
    }
  });

  y2 += multiplyGrid(1);

  // ModifyList
  modifyList = cp5.addScrollableList("modifyList", x2, y2, Config.CP5.Controls.Width, 500)
    .setGroup(g3)
    .setBarHeight(Config.CP5.Grid)
    .setItemHeight(Config.CP5.Controls.Height)
    .setBackgroundColor(Config.CurrentTheme().ControlBackground)
    .setColorLabel(Config.CurrentTheme().ControlValueLabel)
    .setColorValue(Config.CurrentTheme().ControlValueLabel)
    .onChange(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        int selected = int(theEvent.getController().getValue());
        Modifier modifier = modifiers.get(selected);

        if (modifier.hasCreator()) {
          modifier.index = selectedModifiers.size();
          modifier.menu();
          selectedModifiers.add(modifier);

          createHemesh();
        }

        modifyList.setCaptionLabel("Select Modifier");
      }
    }).onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        if (modifyList.isOpen()) {
          shapeList.close();
          modifyList.bringToFront();
        }
      }
    });

  modifyList.getCaptionLabel()
    .set("Select Modifier")
    .alignY(cp5.CENTER);

  // modifiers

  for (int x = 0 ; x < modifiers.size(); x++) {
    Modifier modifier = modifiers.get(x);
    modifyList.addItem(modifier.name, x);
  }

  modifyList.close();

  y2 += multiplyGrid(2);

  // Shape parameters
  cp5.addTextlabel("lblShapeParameters")
    .setText("SHAPE PARAMETERS")
    .setPosition(x2, y2)
    .setColorValue(Config.CurrentTheme().ControlCaptionLabel)
    .moveTo(g3);

  y2 += multiplyGrid(1);

  cp5.addSlider("create0", 0, 500, x2, y2, Config.CP5.Controls.Width, Config.CP5.Controls.Height)
    .setDecimalPrecision(0)
    .moveTo(g3)
    .onRelease(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        create0 = int(theEvent.getController().getValue());
        createHemesh();
      }
    })
    .onDrag(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        create0 = int(theEvent.getController().getValue());
        createHemesh();
      }
    });

  y2 += multiplyGrid(1);

  cp5.addSlider("create1", 0, 500, x2, y2, Config.CP5.Controls.Width, Config.CP5.Controls.Height)
    .setDecimalPrecision(0)
    .moveTo(g3)
    .onRelease(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        create1 = int(theEvent.getController().getValue());
        createHemesh();
      }
    })
    .onDrag(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        create1 = int(theEvent.getController().getValue());
        createHemesh();
      }
    });

  y2 += multiplyGrid(1);

  cp5.addSlider("create2", 0, 500, x2, y2, Config.CP5.Controls.Width, Config.CP5.Controls.Height)
    .setDecimalPrecision(0)
    .moveTo(g3)
    .onRelease(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        create2 = int(theEvent.getController().getValue());
        createHemesh();
      }
    })
    .onDrag(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        create2 = int(theEvent.getController().getValue());
        createHemesh();
      }
    });

  y2 += multiplyGrid(1);

  cp5.addSlider("create3", 0, 500, x2, y2, Config.CP5.Controls.Width, Config.CP5.Controls.Height)
    .setDecimalPrecision(0)
    .moveTo(g3)
    .onRelease(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        create3 = int(theEvent.getController().getValue());
        createHemesh();
      }
    })
    .onDrag(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        create3 = int(theEvent.getController().getValue());
        createHemesh();
      }
    });

  setShapeParameters(selectedShapeIndex);

  y2 += multiplyGrid(2);

  // shape color and frame
  cp5.addTextlabel("lblShape")
    .setText("SHAPE COLOR")
    .setPosition(x2, y2)
    .setColorValue(Config.CurrentTheme().ControlCaptionLabel)
    .moveTo(g3);

  y2 += multiplyGrid(1);

  cp5.begin(x2, y2);
  cp5.addSlider("shapeHue", 0, 360)
    .setSize(Config.CP5.Controls.Width, Config.CP5.Controls.Height)
    .setPosition(x2, y2)
    .setLabel("Hue")
    .setDecimalPrecision(0)
    .moveTo(g3);

  y2 += multiplyGrid(1);

  cp5.addSlider("shapeSaturation", 0, 100)
    .setSize(Config.CP5.Controls.Width, Config.CP5.Controls.Height)
    .setPosition(x2, y2)
    .setLabel("Saturation")
    .setDecimalPrecision(0)
    .moveTo(g3);

  y2 += multiplyGrid(1);

  cp5.addSlider("shapeBrightness", 0, 100)
    .setSize(Config.CP5.Controls.Width, Config.CP5.Controls.Height)
    .setPosition(x2, y2)
    .setLabel("Brightness")
    .setDecimalPrecision(0)
    .moveTo(g3);

  y2 += multiplyGrid(1);

  cp5.addSlider("shapeTransparency", 0, 100)
    .setSize(Config.CP5.Controls.Width, Config.CP5.Controls.Height)
    .setPosition(x2, y2)
    .setLabel("Alpha")
    .setDecimalPrecision(0)
    .moveTo(g3);

  y2 += multiplyGrid(1);

  cp5.addToggle("facesOn", x2 + getInlineX(1, 2), y2, divideControlWidth(1, 2), Config.CP5.Controls.Height)
    .setLabel("Toggle Faces")
    .moveTo(g3);

  cp5.addToggle("edgesOn", x2 + getInlineX(2, 2), y2, divideControlWidth(2, 2), Config.CP5.Controls.Height)
    .setLabel("Toggle Edges")
    .moveTo(g3);


  cp5.end();
}

void createGroup4() {
    // render type & saving variables
    cp5.addTextlabel("lblSave")
      .setText("WHAT TO SAVE")
      .setPosition(x2, y2)
      .setColorValue(Config.CurrentTheme().ControlCaptionLabel);

    y2 += multiplyGrid(1);

    cp5.addToggle("saveOpenGL", x2, y2, divideControlWidth(1, 2), Config.CP5.Controls.Height)
      .setLabel("OpenGL Current View");

    cp5.addToggle("saveSunflow", x2 + getInlineX(2, 2), y2, divideControlWidth(2, 2), Config.CP5.Controls.Height)
      .setLabel("Sunflow Rendering");

    y2 += multiplyGrid(2);

    cp5.addToggle("saveGui", x2, y2, divideControlWidth(1, 2), Config.CP5.Controls.Height)
      .setLabel("GUI");

    cp5.addToggle("saveMask", x2 + getInlineX(2, 2), y2, divideControlWidth(2, 2), Config.CP5.Controls.Height)
      .setLabel("Sunflow Mask");

    y2 += multiplyGrid(2);

    cp5.addToggle("preview", x2, y2, divideControlWidth(1, 2), Config.CP5.Controls.Height)
      .setLabel("Sunflow Preview");

    cp5.addToggle("saveContinuous", x2 + getInlineX(2, 2), y2, divideControlWidth(2, 2), Config.CP5.Controls.Height)
      .setLabel("Continuously")
      .setColorCaptionLabel(Config.CurrentTheme().ControlCaptionLabel);

    y2 += multiplyGrid(3);

    cp5.addButton("save", 0, x2, y2, Config.CP5.Controls.Width, multiplyControlHeight(3))
      .setColorBackground(Config.CurrentTheme().ButtonBackground)
      .setColorLabel(Config.CurrentTheme().ButtonForeground)
      .setLabel("SAVE / RENDER");

    y2 += multiplyGrid(3);

    cp5.addTextlabel("lblSunflowSize")
      .setText("SUNFLOW RENDERING SIZE : " + int(sceneWidth*sunflowMultiply)+ " x " + int(sceneHeight*sunflowMultiply))
      .setPosition(x2, y2)
      .setColorValue(Config.CurrentTheme().ControlCaptionLabel);
}


// zooming with the mouseWheel
void mouseWheel(int delta) {
  if (delta > 0) {
    if (zoom > 20) {
      cp5.getController("zoom").setValue(zoom - 10);
    } else {
      cp5.getController("zoom").setValue(zoom - 1);
    }
  } else if (delta < 0) {
    if (zoom >= 20) {
      cp5.getController("zoom").setValue(zoom + 10);
    } else {
      cp5.getController("zoom").setValue(zoom + 1);
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
  if (!cp5.isMouseOver()) {
    if (mouseButton == LEFT) {
      flagMouseControlTranslationMouvement = true;
      cp5.getController("translationOn").setValue(0);
    } else if (mouseButton == RIGHT) {
      flagMouseControlRotationMouvement = true;
      cp5.getController("rotationOn").setValue(0);
      cp5.getController("autoRotate").setValue(0);
    }
  }
}

void updateGui() {
  //gl4.setBackgroundColor(lightsColor);
}

void setShapeParameters(int shape) {
  Controller controller;
  selectedShape = shapes.get(shape);
  defaultShapeValues = selectedShape.getDefaultValues();
  maxShapeValues = selectedShape.getMaxValues();
  minShapeValues = selectedShape.getMinValues();
  shapeLabels = selectedShape.getLabels();

  for ( int x = 0 ; x < selectedShape.parameters; x++ ) {
    controller = cp5.getController("create" + x);
    if (controller != null) {
      controller.setLabel(shapeLabels[x]);
      controller.setValue(defaultShapeValues[x]);
      controller.setLock(false);
      controller.setMax(maxShapeValues[x]);
      controller.setMin(minShapeValues[x]);
      controller.setColorBackground(Config.CurrentTheme().ControlBackground);
      controller.setColorForeground(Config.CurrentTheme().ControlForeground);
      controller.setColorCaptionLabel(Config.CurrentTheme().ControlCaptionLabel);
      controller.setColorValueLabel(Config.CurrentTheme().ControlValueLabel);
      controller.setColorActive(Config.CurrentTheme().ControlActive);
      controller.setVisible(true);
    }
  }

  for ( int y = selectedShape.parameters ; y < 4 ; y++ ) {
    controller = cp5.getController("create" + y);
    if (controller != null) {
      controller.setVisible(false);
    }
  }
}

void setShaderParameters(int shaderNum) {
  ((Slider)cp5.getController("param0")).setLabel("").setRange(0.0f, 1.0f).setValue(0.0f).setDecimalPrecision(2);
  ((Slider)cp5.getController("param1")).setLabel("").setRange(0.0f, 1.0f).setValue(0.0f).setDecimalPrecision(2);
  ((Slider)cp5.getController("param2")).setLabel("").setRange(0.0f, 1.0f).setValue(0.0f).setDecimalPrecision(2);
  ((Slider)cp5.getController("param3")).setLabel("").setRange(0.0f, 1.0f).setValue(0.0f).setDecimalPrecision(2);

  switch(shaderNum) {
  case 301 :
    ((Slider)cp5.getController("param0")).setLabel("shinyness").setRange(0.0f, 1.0f).setValue(0.25f);
    break;
  case 302 :
    ((Slider)cp5.getController("param0")).setLabel("Index Refraction").setRange(0.0f, 5.0f).setValue(1.5f);
    ((Slider)cp5.getController("param1")).setLabel("absorptionDistance").setRange(0.0f, 10.0f).setValue(5.0f);
    break;
  case 305 :
    ((Slider)cp5.getController("param0")).setLabel("power").setRange(0, 500).setValue(50).setDecimalPrecision(0);
    break;
  case 307 :
    ((Slider)cp5.getController("param0")).setLabel("roughnessX").setRange(0.0f, 1.0f).setValue(1.0f);
    ((Slider)cp5.getController("param1")).setLabel("roughnessY").setRange(0.0f, 1.0f).setValue(1.0f);
    break;
  case 308 :
    ((Slider)cp5.getController("param0")).setLabel("width").setRange(0.0f, 1.0f).setValue(1.0f);
    break;
  default:
    break;
  }
}

void lightsColorLikeShapeColor() {
  cp5.getController("lightsColorR").setValue(red(shapecolor));
  cp5.getController("lightsColorG").setValue(green(shapecolor));
  cp5.getController("lightsColorB").setValue(blue(shapecolor));
  cp5.getController("lightsColorA").setValue(alpha(shapecolor));

  lightsColor = color(lightsColorR, lightsColorG, lightsColorB, lightsColorA);
}

// resel all
void reset() {
  // basic shape variables
  selectedShapeIndex = 0;

  defaultShapeValues = selectedShape.getDefaultValues();
  maxShapeValues = selectedShape.getMaxValues();

  resetView();
  resetLights();

  println(defaultShapeValues[0]);

  cp5.getController("create0").setValue(defaultShapeValues[0]);
  cp5.getController("create1").setValue(defaultShapeValues[1]);
  cp5.getController("create2").setValue(defaultShapeValues[2]);
  cp5.getController("create3").setValue(defaultShapeValues[3]);
  cp5.getController("create0").setMax(maxShapeValues[0]);
  cp5.getController("create1").setMax(maxShapeValues[1]);
  cp5.getController("create2").setMax(maxShapeValues[2]);
  cp5.getController("create3").setMax(maxShapeValues[3]);

  // TODO: Set min values

  setShapeParameters(selectedShapeIndex);

  // sunflow shaders variables
  shader = 301;
  ((Slider)cp5.getController("param0")).setValue(0.0f).setDecimalPrecision(2);
  ((Slider)cp5.getController("param1")).setValue(0.0f).setDecimalPrecision(2);
  ((Slider)cp5.getController("param2")).setValue(0.0f).setDecimalPrecision(2);
  ((Slider)cp5.getController("param3")).setValue(0.0f).setDecimalPrecision(2);

  setShaderParameters(shader);

  cp5.getController("lblCurrentShader").setValueLabel("SHADER : " + numToName(shader));

  // saving variables
  cp5.getController("saveOpenGL").setValue(0);
  cp5.getController("saveGui").setValue(1);
  cp5.getController("saveSunflow").setValue(1);
  cp5.getController("saveMask").setValue(0);
  cp5.getController("preview").setValue(1);
  ((Toggle)cp5.getController("saveContinuous"))
    .setValue(0)
    .setLabel("Continuously")
    .setColorCaptionLabel(Config.CurrentTheme().ControlCaptionLabel);
  sunflowMultiply = 1;
  cp5.getController("lblSunflowSize").setValueLabel("SUNFLOW RENDERING SIZE : " + int(sceneWidth*sunflowMultiply)+ " x " + int(sceneHeight*sunflowMultiply));

  // ShapeList + ModifyList
  shapeList.getCaptionLabel().set("Select Shape");
  modifyList.getCaptionLabel().set("Select Modifier");

  // remove the gui elements for all modifiers
  for (int i=0; i<modifiers.size(); i++) {
    cp5.remove("remove" + i);
    for (int j=0; j<5; j++) {
      cp5.remove(i+"v"+j);
    }
  }

  // remove all modifiers
  selectedModifiers.clear();

  // start up again
  createHemesh();
}

void resetLights() {
  cp5.getController("sunflowWhiteBackgroundOn").setValue(0);
  cp5.getController("sunflowBlackBackgroundOn").setValue(0);

  // sunflow lights
  cp5.getController("sunSkyLightOn").setValue(1);
  cp5.getController("dirLightTopOn").setValue(0);
  cp5.getController("dirLightRightOn").setValue(0);
  cp5.getController("dirLightFrontOn").setValue(0);
  cp5.getController("dirLightBottomOn").setValue(0);
  cp5.getController("dirLightLeftOn").setValue(0);
  cp5.getController("dirLightBehindOn").setValue(0);
  cp5.getController("dirLightRadius").setValue(10);
  cp5.getController("sphereLightTopOn").setValue(0);
  cp5.getController("sphereLightRightOn").setValue(0);
  cp5.getController("sphereLightFrontOn").setValue(0);
  cp5.getController("sphereLightBottomOn").setValue(0);
  cp5.getController("sphereLightLeftOn").setValue(0);
  cp5.getController("sphereLightBehindOn").setValue(0);
  cp5.getController("sphereLightRadius").setValue(10);

  // sunflow color lights
  cp5.getController("lightsColorR").setValue(230);
  cp5.getController("lightsColorG").setValue(230);
  cp5.getController("lightsColorB").setValue(230);
  cp5.getController("lightsColorA").setValue(255);
  lightsColor = color(lightsColorR, lightsColorG, lightsColorB, lightsColorA);
}

// reset the camera view & color
void resetView() {

  // view
  cp5.getController("zoom").setValue(1);
  cp5.getController("changeSpeedX").setValue(1.5);
  cp5.getController("changeSpeedY").setValue(1.5);
  cp5.getController("autoRotate").setValue(1);
  cp5.getController("translationOn").setValue(0);
  cp5.getController("rotationOn").setValue(0);
  translateX = width/2;
  translateY = height/2;
  rotationX = 0;
  rotationY = 0;
  actualZoom = 1;
  flagMouseControlRotationMouvement = false;
  flagMouseControlTranslationMouvement = false;
  resetRotationMouvement();
  resetTranslationMouvement();
  resetShapeColors();

  // presentation
  cp5.getController("shapeHue").setValue(shapeHue);
  cp5.getController("shapeSaturation").setValue(shapeSaturation);
  cp5.getController("shapeBrightness").setValue(shapeBrightness);
  cp5.getController("shapeTransparency").setValue(shapeTransparency);
  cp5.getController("facesOn").setValue(1);
  cp5.getController("edgesOn").setValue(0);
}

void quickSave() {
  shaderList.setValue(shader);
  shapeList.setValue(selectedShapeIndex);
  cp5.saveProperties(sketchPath() + "/output/quicksave");
}

void quickLoad() {
  cp5.loadProperties(sketchPath() + "/output/quicksave");
  shader = (int) shaderList.getValue();
  selectedShapeIndex = (int) shapeList.getValue();
  setShapeParameters(selectedShapeIndex);
  setShaderParameters(shader);
}

// toggle saving function (with console feedback)
void save() {
  if (saveOn) {
    saveOn = false;
    ((Toggle)cp5.getController("saveContinuous")).setLabel("Continuously").setColorCaptionLabel(Config.CurrentTheme().ControlCaptionLabel);
    println("Saving stopped");
  } else {
    drawcp5 = true;
    if (saveContinuous) {
      ((Toggle)cp5.getController("saveContinuous"))
          .setLabel("Continuously [Saving]")
          .setColorCaptionLabel(Config.CurrentTheme().ControlCaptionLabel);
    }

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


// some useful keyboard actions
void keyPressed() {

  // toggle autoRotate, translation & rotation
  if (key == 'r') {
    if (autoRotate == false) {
      cp5.getController("autoRotate").setValue(1);
    } else {
      cp5.getController("autoRotate").setValue(0);
    }
  }
  if (key == 't') {
    if (translationOn == false) {
      cp5.getController("translationOn").setValue(1);
    } else {
      cp5.getController("translationOn").setValue(0);
    }
  }
  if (key == 'y') {
    if (rotationOn == false) {
      cp5.getController("rotationOn").setValue(1);
    } else {
      cp5.getController("rotationOn").setValue(0);
    }
  }

  // toggle the cp5 gui
  if (key == '5') {
    drawcp5 = !drawcp5;
  }

  // set X & Y speed of translation & rotation to zero
  if (key == '0') {
    cp5.getController("changeSpeedX").setValue(0);
    cp5.getController("changeSpeedY").setValue(0);
  }

  // toggle sunflow manually
  if (key == 's') {
    if (saveSunflow) {
      cp5.getController("saveSunflow").setValue(0);
    } else {
      cp5.getController("saveSunflow").setValue(1);
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
    cp5.getController("autoRotate").setValue(0);
    ((Toggle)cp5.getController("saveContinuous")).setValue(0).setLabel("Continuously").setColorCaptionLabel(Config.CurrentTheme().ControlCaptionLabel);
    cp5.getController("saveGui").setValue(1);
    cp5.getController("preview").setValue(1);
    cp5.getController("saveSunflow").setValue(1);
    save();
  }

  // high quality sunflow render (+ gui screenshot)
  if (key == 'c') {
    cp5.getController("autoRotate").setValue(0);
    ((Toggle)cp5.getController("saveContinuous")).setValue(0).setLabel("Continuously").setColorCaptionLabel(Config.CurrentTheme().ControlCaptionLabel);
    cp5.getController("saveGui").setValue(1);
    cp5.getController("preview").setValue(0);
    cp5.getController("saveSunflow").setValue(1);
    save();
  }

  // export shape to a STL file
  if (key == 'l') {
    timestamp = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    String path = sketchPath() + "/output/export_stl/";
    HET_Export exporter = new HET_Export();
    exporter.saveToSTL(mesh, path, timestamp);
    println("STL exported");
  }

  // decrease sunflow multiplication factor by 0.5 (key: <)
  if (key == ',') {
    if (sunflowMultiply >= 1) {
      sunflowMultiply -= 0.5;
    }
    println("Sunflow render output: " + int(sceneWidth*sunflowMultiply) + " x " + int(sceneHeight*sunflowMultiply));
    cp5.getController("lblSunflowSize")
      .setValueLabel("SUNFLOW RENDERING SIZE : " + int(sceneWidth*sunflowMultiply)+ " x " + int(sceneHeight*sunflowMultiply));
  }

  // increase sunflow multiplication factor by 0.5 (key: >)
  if (key == '.') {
    sunflowMultiply += 0.5;
    println("Sunflow render output: " + int(sceneWidth*sunflowMultiply) + " x " + int(sceneHeight*sunflowMultiply));
    cp5.getController("lblSunflowSize")
      .setValueLabel("SUNFLOW RENDERING SIZE : " + int(sceneWidth*sunflowMultiply)+ " x " + int(sceneHeight*sunflowMultiply));
  }
}
