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

// Shader list: http://sourceforge.net/p/sunflow/code/HEAD/tree/trunk/src/org/sunflow/core/shader/
void createShaders() {
  shaders.add(
    new Shader("Ambient Occlusion", 1)
      .setMinValues(new float[] { 0.0 })
      .setMaxValues(new float[] { 100.0 })
      .setDefaultValues(new float[] { 10.0 })
      .setLabels(new String[] { "Distance" })
      .setCreator(new ShaderCreator() {
        public void create(SunflowAPIAPI sunflow, float[] values) {
          sunflow.setAmbientOcclusionShader(SHADER_NAME, new Color(shapeColor), new Color(lightsColor), samples, values[0]);
        }
      }
    )
  );

  shaders.add(
    new Shader("Shiny Diffuse", 1)
      .setMinValues(new float[] { 0.0 })
      .setMaxValues(new float[] { 1.0 })
      .setDefaultValues(new float[] { 0.25 })
      .setLabels(new String[] { "Shininess" })
      .setCreator(new ShaderCreator() {
        public void create(SunflowAPIAPI sunflow, float[] values) {
          sunflow.setShinyDiffuseShader(SHADER_NAME, new Color(shapeColor), values[0]);
        }
      }
    )
  );

  shaders.add(
    new Shader("Glass", 2)
      .setMinValues(new float[] { 0.0, 0.0 })
      .setMaxValues(new float[] { 10.0, 5.0 })
      .setDefaultValues(new float[] { 1.5, 5.0 })
      .setLabels(new String[] { "Index Refraction", "Absorption Distance" })
      .setCreator(new ShaderCreator() {
        public void create(SunflowAPIAPI sunflow, float[] values) {
          sunflow.setGlassShader(SHADER_NAME, new Color(shapeColor), values[0], values[1], new Color(lightsColor));
        }
      }
    )
  );

  shaders.add(
    new Shader("Diffuse", 0)
      .setMinValues(new float[] {})
      .setMaxValues(new float[] {})
      .setDefaultValues(new float[] {})
      .setLabels(new String[] {})
      .setCreator(new ShaderCreator() {
        public void create(SunflowAPIAPI sunflow, float[] values) {
          sunflow.setDiffuseShader(SHADER_NAME, new Color(shapeColor));
        }
      }
    )
  );

  shaders.add(
    new Shader("Mirror", 0)
      .setMinValues(new float[] {})
      .setMaxValues(new float[] {})
      .setDefaultValues(new float[] {})
      .setLabels(new String[] {})
      .setCreator(new ShaderCreator() {
        public void create(SunflowAPIAPI sunflow, float[] values) {
          sunflow.setMirrorShader(SHADER_NAME, new Color(shapeColor));
        }
      }
    )
  );

  shaders.add(
    new Shader("Phong", 1)
      .setMinValues(new float[] { 0.0 })
      .setMaxValues(new float[] { 500.0 })
      .setDefaultValues(new float[] { 50 })
      .setLabels(new String[] { "Power" })
      .setCreator(new ShaderCreator() {
        public void create(SunflowAPIAPI sunflow, float[] values) {
          sunflow.setPhongShader(SHADER_NAME, new Color(shapeColor), new Color(lightsColor), values[0], samples);
        }
      }
    )
  );

  shaders.add(
    new Shader("Constant", 0)
      .setMinValues(new float[] {})
      .setMaxValues(new float[] {})
      .setDefaultValues(new float[] {})
      .setLabels(new String[] {})
      .setCreator(new ShaderCreator() {
        public void create(SunflowAPIAPI sunflow, float[] values) {
          sunflow.setConstantShader(SHADER_NAME, new Color(shapeColor));
        }
      }
    )
  );

  shaders.add(
    new Shader("Ward", 2)
      .setMinValues(new float[] { 0.0, 0.0 })
      .setMaxValues(new float[] { 1.0, 1.0 })
      .setDefaultValues(new float[] { 1.0, 1.0 })
      .setLabels(new String[] { "Roughness X", "Roughness Y"})
      .setCreator(new ShaderCreator() {
        public void create(SunflowAPIAPI sunflow, float[] values) {
          sunflow.setWardShader(SHADER_NAME, new Color(shapeColor), new Color(lightsColor), values[0], values[1], samples);
        }
      }
    )
  );

  shaders.add(
    new Shader("Wireframe", 1)
      .setMinValues(new float[] { 0.0 })
      .setMaxValues(new float[] { 1.0 })
      .setDefaultValues(new float[] { 1.0 })
      .setLabels(new String[] { "Width"})
      .setCreator(new ShaderCreator() {
        public void create(SunflowAPIAPI sunflow, float[] values) {
          sunflow.setWireframeShader(SHADER_NAME, new Color(shapeColor), new Color(lightsColor), values[0]);
        }
      }
    )
  );
}

void createGui() {
  // Create groups

  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);

  g1 = cp5.addGroup("g1");
  g2 = cp5.addGroup("g2");
  g3 = cp5.addGroup("g3");
  g4 = cp5.addGroup("g4");

  // camera control

  x2 = multiplyGrid(1);
  y2 = multiplyGrid(1);

  createGroup1();

  y2 += multiplyGrid(2);

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
    .setColorValue(currentTheme.ControlCaptionLabel);

  cp5.getTooltip().setDelay(150).setColorLabel(currentTheme.ControlValueLabel);
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

  updateControlColors();

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
    .setColorValue(currentTheme.ControlCaptionLabel)
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
    .setColorBackground(currentTheme.ButtonBackground)
    .setColorLabel(currentTheme.ButtonForeground)
    .setLabel("Reset Cam & Color");

  cp5.addButton("resetLights", 0, x2 + getInlineX(2, 2), y2, divideControlWidth(2, 2), multiplyControlHeight(2))
    .setColorBackground(currentTheme.ButtonBackground)
    .setColorLabel(currentTheme.ButtonForeground)
    .setLabel("Reset Lights");

  y2 += multiplyGrid(2);

  cp5.addButton("reset", 0, x2, y2, Config.CP5.Controls.Width, multiplyControlHeight(2))
    .setColorBackground(currentTheme.ButtonBackground)
    .setColorLabel(currentTheme.ButtonForeground)
    .setLabel("Reset Everything");

  y2 += multiplyGrid(3);

  cp5.addTextlabel("lblTheme")
    .setText("UI THEME")
    .setPosition(x2, y2)
    .setColorValue(currentTheme.ControlCaptionLabel)
    .moveTo(g1);

  y2 += multiplyGrid(1);

  themeList = cp5.addScrollableList("themeList", x2, y2, Config.CP5.Controls.Width, 400)
    .setGroup(g1)
    .setBarHeight(Config.CP5.Controls.Height)
    .setItemHeight(Config.CP5.Controls.Height)
    .setBackgroundColor(currentTheme.ControlBackground)
    .setColorLabel(currentTheme.ControlValueLabel)
    .setColorValue(currentTheme.ControlValueLabel)
    .close();

  themeList.getCaptionLabel()
    .set("Switch Theme")
    .alignY(cp5.CENTER);

  int i = 0;
  for (HashMap.Entry<String, Theme> entry : themes.entrySet()) {
      String key = entry.getKey();
      themeList.addItem(key, i);

      if (key == currentThemeName) {
          themeList.setValue(i);
      }

      i++;
  }

  themeList.onChange(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      String themeName = (String)themeList.getItem(int(themeList.getValue())).get("text");
      Config.setTheme(themeName);
      currentTheme = Config.getCurrentTheme();
      currentThemeName = Config.getCurrentThemeName();

      updateControlColors();
      updateShapeColors();
    }
  }).onClick(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if (themeList.isOpen()) {
        themeList.bringToFront();
      }
    }
  });

  cp5.end();
}

void createGroup2() {

    cp5.begin(x2, y2);

    // Sunflow: Scene
    //
    Textlabel lblSunflow = cp5.addTextlabel("lblSunflow")
      .setText("SUNFLOW SETTINGS")
      .setPosition(x2, y2)
      .setColorValue(currentTheme.ControlCaptionLabel)
      .moveTo(g2);

    y2 += multiplyGrid(1);

    cp5.addTextlabel("subLblSunflowScene")
      .setText("SCENE")
      .setPosition(x2, y2)
      .setColorValue(currentTheme.ControlSubLabel)
      .moveTo(g2);

    y2 += multiplyGrid(1);

    // Option 1: Sunsky
    sunsky = cp5.addToggle("sunSkyLightOn", x2, y2, divideControlWidth(1, 4), Config.CP5.Controls.Height)
      .setLabel("")
      .setGroup(g2);

    sunsky.onClick(new CallbackListener() {
        public void controlEvent(CallbackEvent theEvent) {
          if (sunsky.getBooleanValue()) {
            whiteBackground.setState(false);
            blackBackground.setState(false);
          }
        }
      });

    cp5.addTextlabel("subLblSkylights")
      .setText("BASIC SUNSKY")
      .setPosition(x2 + getInlineX(2, 4), y2 + getLineHeight())
      .setColorValue(currentTheme.ControlSubLabel)
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
            blackBackground.setState(false);
            sunsky.setState(false);
          }
        }
      });

    cp5.addTextlabel("subLblWhite")
      .setText("WHITE BACKGROUND")
      .setPosition(x2 + getInlineX(2, 4), y2 + getLineHeight())
      .setColorValue(currentTheme.ControlSubLabel)
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
            whiteBackground.setState(false);
            sunsky.setState(false);
          }
        }
      });

    cp5.addTextlabel("subLblBlack")
      .setText("BLACK BACKGROUND")
      .setPosition(x2 + getInlineX(2, 4), y2 + getLineHeight())
      .setColorValue(currentTheme.ControlSubLabel)
      .setGroup(g2);

    y2 += multiplyGrid(2);

    // Sunflow: Directional light
    cp5.addTextlabel("subLblDirectionalLight")
      .setText("DIRECTIONAL LIGHT")
      .setPosition(x2, y2)
      .setColorValue(currentTheme.ControlSubLabel)
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

    cp5.addTextlabel("subLblSphereLight")
      .setText("SPHERE LIGHT")
      .setPosition(x2, y2)
      .setColorValue(currentTheme.ControlSubLabel)
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


    cp5.addTextlabel("subLblLightsColor")
      .setText("LIGHT COLOUR")
      .setPosition(x2, y2)
      .setColorValue(currentTheme.ControlSubLabel)
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
      .setColorBackground(currentTheme.ButtonBackground)
      .setColorLabel(currentTheme.ButtonForeground)
      .setLabel("Like Shape Color")
      .setGroup(g2);

    y2 += multiplyGrid(4);

    // sunflow shaders
    cp5.addTextlabel("subLblShader")
      .setPosition(x2, y2)
      .setText("SHADER")
      .setColorValue(currentTheme.ControlSubLabel)
      .setGroup(g2);

    y2 += multiplyGrid(1);

    // ShaderList
    shaderList = cp5.addScrollableList("shaderList", x2, y2, Config.CP5.Controls.Width, 400)
      .setGroup(g2)
      .setBarHeight(Config.CP5.Controls.Height)
      .setItemHeight(Config.CP5.Controls.Height)
      .setBackgroundColor(currentTheme.ControlBackground)
      .setColorLabel(currentTheme.ControlValueLabel)
      .setColorValue(currentTheme.ControlValueLabel);


    for (int i = 0; i < shaders.size(); i++) {
      Shader shader = shaders.get(i);
      shaderList.addItem(shader.name, i);
    }

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
        setShaderParameters(int(shaderList.getValue()));
      }
    });

    y2 += multiplyGrid(2);

    cp5.addTextlabel("subLblShaderParameters")
      .setPosition(x2, y2)
      .setText("SHADER PARAMETERS")
      .setColorValue(currentTheme.ControlSubLabel)
      .setGroup(g2);

    y2 += multiplyGrid(1);

    cp5.addSlider("param0", 0.0f, 1.0f, x2, y2, Config.CP5.Controls.Width, Config.CP5.Controls.Height).setGroup(g2);

    y2 += multiplyGrid(1);

    cp5.addSlider("param1", 0.0f, 1.0f, x2, y2, Config.CP5.Controls.Width, Config.CP5.Controls.Height).setGroup(g2);

    y2 += multiplyGrid(1);

    cp5.addSlider("param2", 0.0f, 1.0f, x2, y2, Config.CP5.Controls.Width, Config.CP5.Controls.Height).setGroup(g2);

    y2 += multiplyGrid(1);

    cp5.addSlider("param3", 0.0f, 1.0f, x2, y2, Config.CP5.Controls.Width, Config.CP5.Controls.Height).setGroup(g2);

    y2 = height - multiplyGrid(7);

    cp5.addButton("quickSave", 0, x2, y2, Config.CP5.Controls.Width, multiplyControlHeight(3))
      .setColorBackground(currentTheme.ButtonBackground)
      .setColorLabel(currentTheme.ButtonForeground)
      .setLabel("Quick Save Settings");

    y2 += multiplyGrid(3);

    cp5.addButton("quickLoad", 0, x2, y2, Config.CP5.Controls.Width, multiplyControlHeight(3))
      .setColorBackground(currentTheme.ButtonBackground)
      .setColorLabel(currentTheme.ButtonForeground)
      .setLabel("Quick Load Settings");

    cp5.end();

    shaderList.setValue(selectedShaderIndex);
    setShaderParameters(selectedShaderIndex);
}

void createGroup3() {


  cp5.addTextlabel("lblShapesModifiers")
    .setText("SHAPE & MODIFIERS")
    .setPosition(x2, y2)
    .setColorValue(currentTheme.ControlCaptionLabel)
    .moveTo(g3);

  y2 += multiplyGrid(1);

  // ShapeList
  shapeList = cp5.addScrollableList("shapeList", x2, y2, Config.CP5.Controls.Width, 400)
    .setGroup(g3)
    .setBarHeight(Config.CP5.Controls.Height)
    .setItemHeight(Config.CP5.Controls.Height)
    .setBackgroundColor(currentTheme.ControlBackground)
    .setColorLabel(currentTheme.ControlValueLabel)
    .setColorValue(currentTheme.ControlValueLabel)
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
      setShapeParameters(int(shapeList.getValue()));
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
    .setBackgroundColor(currentTheme.ControlBackground)
    .setColorLabel(currentTheme.ControlValueLabel)
    .setColorValue(currentTheme.ControlValueLabel)
    .onChange(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        int selected = int(theEvent.getController().getValue());
        Modifier modifier = modifiers.get(selected);

        if (modifier.hasCreator()) {
          modifier.setIndex(selectedModifiers.size());
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
    .setColorValue(currentTheme.ControlCaptionLabel)
    .moveTo(g3);

  y2 += multiplyGrid(1);

  cp5.addSlider("create0", 0, 500, x2, y2, Config.CP5.Controls.Width, Config.CP5.Controls.Height)
    .setDecimalPrecision(0)
    .moveTo(g3)
    .onRelease(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        selectedShape.values[0] = int(theEvent.getController().getValue());
        createHemesh();
      }
    })
    .onDrag(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        selectedShape.values[0] = int(theEvent.getController().getValue());
        createHemesh();
      }
    });

  y2 += multiplyGrid(1);

  cp5.addSlider("create1", 0, 500, x2, y2, Config.CP5.Controls.Width, Config.CP5.Controls.Height)
    .setDecimalPrecision(0)
    .moveTo(g3)
    .onRelease(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        selectedShape.values[1] = int(theEvent.getController().getValue());
        createHemesh();
      }
    })
    .onDrag(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        selectedShape.values[1] = int(theEvent.getController().getValue());
        createHemesh();
      }
    });

  y2 += multiplyGrid(1);

  cp5.addSlider("create2", 0, 500, x2, y2, Config.CP5.Controls.Width, Config.CP5.Controls.Height)
    .setDecimalPrecision(0)
    .moveTo(g3)
    .onRelease(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        selectedShape.values[2] = int(theEvent.getController().getValue());
        createHemesh();
      }
    })
    .onDrag(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        selectedShape.values[2] = int(theEvent.getController().getValue());
        createHemesh();
      }
    });

  y2 += multiplyGrid(1);

  cp5.addSlider("create3", 0, 500, x2, y2, Config.CP5.Controls.Width, Config.CP5.Controls.Height)
    .setDecimalPrecision(0)
    .moveTo(g3)
    .onRelease(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        selectedShape.values[3] = int(theEvent.getController().getValue());
        createHemesh();
      }
    })
    .onDrag(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        selectedShape.values[3] = int(theEvent.getController().getValue());
        createHemesh();
      }
    });

  setShapeParameters(selectedShapeIndex);

  y2 += multiplyGrid(2);

  // shape color and frame
  cp5.addTextlabel("lblShape")
    .setText("SHAPE COLOR")
    .setPosition(x2, y2)
    .setColorValue(currentTheme.ControlCaptionLabel)
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
      .setColorValue(currentTheme.ControlCaptionLabel);

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
      .setColorCaptionLabel(currentTheme.ControlCaptionLabel);

    y2 += multiplyGrid(3);

    cp5.addButton("save", 0, x2, y2, Config.CP5.Controls.Width, multiplyControlHeight(3))
      .setColorBackground(currentTheme.ButtonBackground)
      .setColorLabel(currentTheme.ButtonForeground)
      .setLabel("SAVE / RENDER");

    y2 += multiplyGrid(3);

    cp5.addTextlabel("lblSunflowSize")
      .setText("SUNFLOW RENDERING SIZE : " + int(sceneWidth*sunflowMultiply)+ " x " + int(sceneHeight*sunflowMultiply))
      .setPosition(x2, y2)
      .setColorValue(currentTheme.ControlCaptionLabel);
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
      controller.setColorBackground(currentTheme.ControlBackground);
      controller.setColorForeground(currentTheme.ControlForeground);
      controller.setColorCaptionLabel(currentTheme.ControlCaptionLabel);
      controller.setColorValueLabel(currentTheme.ControlValueLabel);
      controller.setColorActive(currentTheme.ControlActive);
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

void updateControlColors() {
    cp5.setColorBackground(currentTheme.ControlBackground);
    cp5.setColorForeground(currentTheme.ControlForeground);
    cp5.setColorCaptionLabel(currentTheme.ControlCaptionLabel);
    cp5.setColorValueLabel(currentTheme.ControlValueLabel);
    cp5.setColorActive(currentTheme.ControlActive);

    List<Button> buttons = cp5.getAll(Button.class);
    for ( Button button : buttons ) {
        button.setColorBackground(currentTheme.ButtonBackground);
        button.setColorLabel(currentTheme.ButtonForeground);
    }

    List<Textlabel> textlabels = cp5.getAll(Textlabel.class);
    for ( Textlabel textlabel : textlabels ) {
        textlabel.setColorValue(currentTheme.ControlCaptionLabel);
        if (textlabel.getName().startsWith("sub")) {
            textlabel.setColorValue(currentTheme.ControlSubLabel);
        }
    }
}

void setShaderParameters(int shader) {
    Controller controller;
    selectedShader = shaders.get(shader);
    defaultShaderValues = selectedShader.getDefaultValues();
    maxShapeValues = selectedShader.getMaxValues();
    minShapeValues = selectedShader.getMinValues();
    shaderLabels = selectedShader.getLabels();

    cp5.getController("subLblShaderParameters").setVisible(selectedShader.parameters > 0);

    for ( int x = 0 ; x < selectedShader.parameters; x++ ) {
      controller = cp5.getController("param" + x);
      if (controller != null) {
        controller.setLabel(shaderLabels[x]);
        controller.setValue(defaultShaderValues[x]);
        controller.setLock(false);
        controller.setMax(maxShapeValues[x]);
        controller.setMin(minShapeValues[x]);
        controller.setColorBackground(currentTheme.ControlBackground);
        controller.setColorForeground(currentTheme.ControlForeground);
        controller.setColorCaptionLabel(currentTheme.ControlCaptionLabel);
        controller.setColorValueLabel(currentTheme.ControlValueLabel);
        controller.setColorActive(currentTheme.ControlActive);
        controller.setVisible(true);
      }
    }

    for ( int y = selectedShader.parameters ; y < 4 ; y++ ) {
      controller = cp5.getController("param" + y);
      if (controller != null) {
        controller.setVisible(false);
      }
    }
  }
