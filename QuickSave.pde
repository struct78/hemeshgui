// TODO: Fix this
void quickSave() {
  //shaderList.setValue(selectedShaderIndex);
  //shapeList.setValue(selectedShapeIndex);
  // Set dynamic fields to be inactive
  saveSettings(quicksaveFilePath);
}

void quickLoad() {
  loadSettings(quicksaveFilePath);
}

void saveAs() {
  selectOutput("Select a file to write to", "onSettingsFileOutputSelected");
}

void onSettingsFileOutputSelected(File file) {
  if (file != null) {
    saveSettings(file.getAbsolutePath());
  }
}

void onSettingsFileInputSelected(File file) {
  if (file != null) {
    loadSettings(file.getAbsolutePath());
  }
}

void loadFrom() {
  selectInput("Selected a file to import", "onSettingsFileInputSelected");
}

void saveSettings(String filePath) {
  // Camera
  JSONObject jsonRoot = new JSONObject();
  jsonRoot = saveCamera(jsonRoot);
  jsonRoot = saveScene(jsonRoot);
  jsonRoot = saveLights(jsonRoot);
  jsonRoot = saveShader(jsonRoot);
  jsonRoot = saveShape(jsonRoot);
  jsonRoot = saveModifiers(jsonRoot);
  jsonRoot = saveRendering(jsonRoot);
  jsonRoot = saveTheme(jsonRoot);

  saveJSONObject(jsonRoot, filePath);
}

void loadSettings(String filePath) {
  for (Modifier modifier : selectedModifiers) {
    modifier.remove();
  }

  selectedModifiers.clear();

  JSONObject jsonRoot = loadJSONObject(filePath);
  loadCamera(jsonRoot);
  loadScene(jsonRoot);
  loadTheme(jsonRoot);
  loadLights(jsonRoot);
  loadShader(jsonRoot);
  loadShape(jsonRoot);
  loadModifiers(jsonRoot);
  loadRendering(jsonRoot);

  createHemesh();
}

JSONObject saveCamera(JSONObject jsonRoot) {
  JSONObject jsonCamera = new JSONObject();
  jsonCamera.setFloat("zoom", zoom);
  jsonCamera.setFloat("changeSpeedX", changeSpeedX);
  jsonCamera.setFloat("changeSpeedY", changeSpeedY);
  jsonCamera.setBoolean("autoRotate", autoRotate);
  jsonCamera.setFloat("rotationX", rotationX);
  jsonCamera.setFloat("rotationY", rotationY);
  jsonCamera.setFloat("rotationZ", rotationZ);
  jsonRoot.setJSONObject("camera", jsonCamera);

  return jsonRoot;
}

JSONObject saveScene(JSONObject jsonRoot) {
  JSONObject jsonScene = new JSONObject();
  jsonScene.setBoolean("sunflowSkyLightOn", sunflowSkyLightOn);
  jsonScene.setBoolean("sunflowWhiteBackgroundOn", sunflowWhiteBackgroundOn);
  jsonScene.setBoolean("sunflowBlackBackgroundOn", sunflowBlackBackgroundOn);
  jsonRoot.setJSONObject("scene", jsonScene);

  return jsonRoot;
}

JSONObject saveLights(JSONObject jsonRoot) {
  // Directional light
  JSONObject jsonDirectionalLights = new JSONObject();
  jsonDirectionalLights.setFloat("dirLightRadius", dirLightRadius);
  jsonDirectionalLights.setBoolean("dirLightTopOn", dirLightTopOn);
  jsonDirectionalLights.setBoolean("dirLightRightOn", dirLightRightOn);
  jsonDirectionalLights.setBoolean("dirLightFrontOn", dirLightFrontOn);
  jsonDirectionalLights.setBoolean("dirLightBottomOn", dirLightBottomOn);
  jsonDirectionalLights.setBoolean("dirLightLeftOn", dirLightLeftOn);
  jsonDirectionalLights.setBoolean("dirLightBehindOn", dirLightBehindOn);

  // Sphere light
  JSONObject jsonSphereLights = new JSONObject();
  jsonSphereLights.setFloat("sphereLightRadius", dirLightRadius);
  jsonSphereLights.setBoolean("sphereLightTopOn", dirLightTopOn);
  jsonSphereLights.setBoolean("sphereLightRightOn", dirLightRightOn);
  jsonSphereLights.setBoolean("sphereLightFrontOn", dirLightFrontOn);
  jsonSphereLights.setBoolean("sphereLightBottomOn", dirLightBottomOn);
  jsonSphereLights.setBoolean("sphereLightLeftOn", dirLightLeftOn);
  jsonSphereLights.setBoolean("sphereLightBehindOn", dirLightBehindOn);

  // Light colour
  JSONObject jsonLightColour = new JSONObject();
  jsonLightColour.setFloat("lightsColorR", lightsColorR);
  jsonLightColour.setFloat("lightsColorG", lightsColorG);
  jsonLightColour.setFloat("lightsColorB", lightsColorB);
  jsonLightColour.setFloat("lightsColorA", lightsColorA);

  jsonRoot.setJSONObject("directionalLights", jsonDirectionalLights);
  jsonRoot.setJSONObject("sphereLights", jsonSphereLights);
  jsonRoot.setJSONObject("lightColour", jsonLightColour);

  return jsonRoot;
}

JSONObject saveShader(JSONObject jsonRoot) {
  // Shader
  JSONObject jsonShader = new JSONObject();
  JSONArray jsonShaderParameters = new JSONArray();

  jsonShader.setString("name", selectedShader.name);

  for (int x = 0 ; x < selectedShader.values.length; x++) {
    jsonShaderParameters.setFloat(x, selectedShader.values[x]);
  }

  jsonShader.setJSONArray("parameters", jsonShaderParameters);
  jsonRoot.setJSONObject("shader", jsonShader);

  return jsonRoot;
}

JSONObject saveShape(JSONObject jsonRoot) {
  // Shape
  JSONObject jsonShape = new JSONObject();
  JSONArray jsonShapeParameters = new JSONArray();
  JSONObject jsonShapeColour = new JSONObject();
  jsonShape.setString("name", selectedShape.name);
  jsonShape.setBoolean("facesOn", facesOn);
  jsonShape.setBoolean("edgesOn", edgesOn);
  jsonShape.setBoolean("isCustom", selectedShape.getCustom());
  jsonShapeColour.setFloat("hue", shapeHue);
  jsonShapeColour.setFloat("saturation", shapeSaturation);
  jsonShapeColour.setFloat("brightness", shapeBrightness);
  jsonShapeColour.setFloat("alpha", shapeTransparency);

  for (int x = 0 ; x < selectedShape.values.length; x++) {
    jsonShapeParameters.setFloat(x, selectedShape.values[x]);
  }

  if (selectedShape.getCustom()) {
    jsonShape.setString("fileContents", selectedShape.getBase64EncodedFile());
    jsonShape.setString("fileExtension", FileExtensions.getExtensionLowerCase(selectedShape.file));
  }

  jsonShape.setJSONObject("colour", jsonShapeColour);
  jsonShape.setJSONArray("parameters", jsonShapeParameters);
  jsonRoot.setJSONObject("shape", jsonShape);

  return jsonRoot;
}

JSONObject saveModifiers(JSONObject jsonRoot) {
  // Modifiers
  JSONArray jsonModifiers = new JSONArray();
  for (int i = 0; i < selectedModifiers.size(); i++) {
    Modifier selectedModifier = selectedModifiers.get(i);
    JSONObject jsonModifier = new JSONObject();
    jsonModifier.setString("name", selectedModifier.name);
    jsonModifier.setInt("index", selectedModifier.getIndex());

    JSONArray jsonModifierParameters = new JSONArray();

    for ( int x = 0 ; x < selectedModifier.values.length; x++ ) {
      jsonModifierParameters.setFloat(x, selectedModifier.values[x]);
    }

    jsonModifier.setJSONArray("parameters", jsonModifierParameters);
    jsonModifiers.setJSONObject(i, jsonModifier);
  }

  jsonRoot.setJSONArray("modifiers", jsonModifiers);

  return jsonRoot;
}

JSONObject saveRendering(JSONObject jsonRoot) {
  // Rendering parameters
  JSONObject jsonRendering = new JSONObject();
  jsonRendering.setBoolean("opengl", saveOpenGL);
  jsonRendering.setBoolean("sunflow", saveSunflow);
  jsonRendering.setBoolean("gui", saveGui);
  jsonRendering.setBoolean("mask", saveMask);
  jsonRendering.setBoolean("preview", savePreview);
  jsonRendering.setBoolean("continuous", saveContinuous);
  jsonRoot.setJSONObject("rendering", jsonRendering);

  return jsonRoot;
}

JSONObject saveTheme(JSONObject jsonRoot) {
  jsonRoot.setString("theme", Config.getCurrentThemeName());
  return jsonRoot;
}

void loadCamera(JSONObject jsonRoot) {
  // Camera
  if (!jsonRoot.isNull("camera")) {
    JSONObject jsonCamera = jsonRoot.getJSONObject("camera");

    setFloatWithNullCheck(jsonCamera, "zoom");
    setFloatWithNullCheck(jsonCamera, "changeSpeedX");
    setFloatWithNullCheck(jsonCamera, "changeSpeedY");
    setBooleanWithNullCheck(jsonCamera, "autoRotate");

    if (!jsonCamera.isNull("rotationX")) {
      rotationX = jsonCamera.getFloat("rotationX");
    }

    if (!jsonCamera.isNull("rotationY")) {
      rotationY = jsonCamera.getFloat("rotationY");
    }

    if (!jsonCamera.isNull("rotationZ")) {
      rotationZ = jsonCamera.getFloat("rotationZ");
    }
  }
}

void loadScene(JSONObject jsonRoot) {
  // Scene
  JSONObject jsonScene = jsonRoot.getJSONObject("scene");
  setBooleanWithNullCheck(jsonScene, "sunflowSkyLightOn");
  setBooleanWithNullCheck(jsonScene, "sunflowWhiteBackgroundOn");
  setBooleanWithNullCheck(jsonScene, "sunflowBlackBackgroundOn");
}

void loadTheme(JSONObject jsonRoot) {
  // Theme
  int y = 0;
  for (HashMap.Entry<String, Theme> entry : themes.entrySet()) {
      String key = entry.getKey();

      if (key.equals(jsonRoot.getString("theme"))) {
          themeList.setValue(y);
      }

      y++;
  }
}

void loadLights(JSONObject jsonRoot) {
  // Directional light
  JSONObject jsonDirectionalLights = jsonRoot.getJSONObject("directionalLights");

  // Directional light
  setFloatWithNullCheck(jsonDirectionalLights, "dirLightRadius");
  setBooleanWithNullCheck(jsonDirectionalLights, "dirLightTopOn");
  setBooleanWithNullCheck(jsonDirectionalLights, "dirLightRightOn");
  setBooleanWithNullCheck(jsonDirectionalLights, "dirLightFrontOn");
  setBooleanWithNullCheck(jsonDirectionalLights, "dirLightBottomOn");
  setBooleanWithNullCheck(jsonDirectionalLights, "dirLightLeftOn");
  setBooleanWithNullCheck(jsonDirectionalLights, "dirLightBehindOn");

  // Sphere light
  JSONObject jsonSphereLights = jsonRoot.getJSONObject("sphereLights");
  setFloatWithNullCheck(jsonSphereLights, "sphereLightRadius");
  setBooleanWithNullCheck(jsonSphereLights, "sphereLightTopOn");
  setBooleanWithNullCheck(jsonSphereLights, "sphereLightRightOn");
  setBooleanWithNullCheck(jsonSphereLights, "sphereLightFrontOn");
  setBooleanWithNullCheck(jsonSphereLights, "sphereLightBottomOn");
  setBooleanWithNullCheck(jsonSphereLights, "sphereLightLeftOn");
  setBooleanWithNullCheck(jsonSphereLights, "sphereLightBehindOn");

  // Light colour
  JSONObject jsonLightColour = jsonRoot.getJSONObject("lightColour");
  setFloatWithNullCheck(jsonLightColour, "lightsColorR");
  setFloatWithNullCheck(jsonLightColour, "lightsColorG");
  setFloatWithNullCheck(jsonLightColour, "lightsColorB");
  setFloatWithNullCheck(jsonLightColour, "lightsColorA");
}

void loadShader(JSONObject jsonRoot) {
  JSONObject jsonShader = jsonRoot.getJSONObject("shader");
  JSONArray jsonShaderParameters = jsonShader.getJSONArray("parameters");

  for (int x = 0 ; x < shaders.size(); x++)  {
    Shader shader = shaders.get(x);
    if (shader.name.equals(jsonShader.getString("name"))) {
      shaderList.setValue(x);
    }
  }

  for (int x = 0 ; x < selectedShader.values.length; x++) {
    selectedShader.values[x] = jsonShaderParameters.getFloat(x);
    try {
      cp5.getController("param" + x).setValue(jsonShaderParameters.getFloat(x));
    } catch(Exception e) {
      e.printStackTrace();
    }
  }
}

void loadShape(JSONObject jsonRoot) {
  // Shape
  if (!jsonRoot.isNull("shape")) {
    JSONObject jsonShape = jsonRoot.getJSONObject("shape");
    JSONArray jsonShapeParameters = getArrayWithNullCheck(jsonShape, "parameters");
    JSONObject jsonShapeColour = getObjectWithNullCheck(jsonShape, "colour");
    boolean isCustom = getBooleanWithNullCheck(jsonShape, "isCustom");
    String fileContents = getStringWithNullCheck(jsonShape, "fileContents");
    String fileExtension = getStringWithNullCheck(jsonShape, "fileExtension");

    for (int x = 0 ; x < shapes.size(); x++)  {
      Shape shape = shapes.get(x);
      if (shape.name.equals(getStringWithNullCheck(jsonShape, "name"))) {
        shapeList.setValue(x);
      }
    }

    setBooleanWithNullCheck(jsonShape, "facesOn");
    setBooleanWithNullCheck(jsonShape, "edgesOn");

    if (jsonShapeColour != null) {
      setFloatWithNullCheck(jsonShapeColour, "hue", "shapeHue");
      setFloatWithNullCheck(jsonShapeColour, "saturation", "shapeSaturation");
      setFloatWithNullCheck(jsonShapeColour, "brightness", "shapeBrightness");
      setFloatWithNullCheck(jsonShapeColour, "alpha", "shapeTransparency");
    }

    if (jsonShapeParameters != null) {
      for (int x = 0 ; x < selectedShape.values.length; x++) {
        selectedShape.values[x] = jsonShapeParameters.getFloat(x);

        cp5.getController("create" + x).setValue(jsonShapeParameters.getFloat(x));
      }
    }

    if (isCustom && fileContents != null) {
      selectedShape.setFileFromBase64String(fileContents, fileExtension);
    }
  }
}

void loadModifiers(JSONObject jsonRoot) {
  // Modifiers
  if (!jsonRoot.isNull("modifiers")) {
    JSONArray jsonModifiers = jsonRoot.getJSONArray("modifiers");

    for (int i = 0; i < jsonModifiers.size(); i++) {
      JSONObject node = jsonModifiers.getJSONObject(i);

      String name = node.getString("name");
      int index = node.getInt("index");
      JSONArray parameters = node.getJSONArray("parameters");
      float[] values = new float[parameters.size()];
      Modifier selectedModifier = null;

      for ( Modifier modifier : modifiers ) {
        if (modifier.name.equals(name)) {
          selectedModifier = modifier;
          for (int j = 0; j < parameters.size(); j++) {
            values[j] = parameters.getFloat(j);
          }
          selectedModifier.values = values;
          selectedModifier.setIndex(index);
          selectedModifier.menu(false);
          selectedModifiers.add(selectedModifier);
        }
      }
    }
  }
}

void loadRendering(JSONObject jsonRoot) {
  // Rendering
  JSONObject jsonRendering = jsonRoot.getJSONObject("rendering");

  setBooleanWithNullCheck(jsonRendering, "opengl", "saveOpenGL");
  setBooleanWithNullCheck(jsonRendering, "sunflow", "saveSunflow");
  setBooleanWithNullCheck(jsonRendering, "gui", "saveGui");
  setBooleanWithNullCheck(jsonRendering, "mask", "saveMask");
  setBooleanWithNullCheck(jsonRendering, "preview", "savePreview");
  setBooleanWithNullCheck(jsonRendering, "continuous", "saveContinuous");
}

boolean getBooleanWithNullCheck(JSONObject jsonObject, String name) {
  return jsonObject != null && !jsonObject.isNull(name) ? jsonObject.getBoolean(name) : false;
}

String getStringWithNullCheck(JSONObject jsonObject, String name) {
  return jsonObject != null && !jsonObject.isNull(name) ? jsonObject.getString(name) : null;
}

JSONArray getArrayWithNullCheck(JSONObject jsonObject, String name) {
  return jsonObject != null && !jsonObject.isNull(name) ? jsonObject.getJSONArray(name) : null;
}

JSONObject getObjectWithNullCheck(JSONObject jsonObject, String name) {
  return jsonObject != null && !jsonObject.isNull(name) ? jsonObject.getJSONObject(name) : null;
}

float getBooleanAsFloatWithNullCheck(JSONObject jsonObject, String name) {
  return jsonObject != null && !jsonObject.isNull(name) ? jsonObject.getBoolean(name) ? 1 : 0 : 0;
}

void setBooleanWithNullCheck(JSONObject jsonObject, String name) {
  setBooleanWithNullCheck(jsonObject, name, name);
}

void setBooleanWithNullCheck(JSONObject jsonObject, String name, String controllerName) {
  if (!jsonObject.isNull(name)) {
    cp5.getController(controllerName).setValue(jsonObject.getBoolean(name) ? 1 : 0);
  }
}

void setFloatWithNullCheck(JSONObject jsonObject, String name) {
  setFloatWithNullCheck(jsonObject, name, name);
}

void setFloatWithNullCheck(JSONObject jsonObject, String name, String controllerName) {
  if (!jsonObject.isNull(name)) {
    cp5.getController(controllerName).setValue(jsonObject.getFloat(name));
  }
}
