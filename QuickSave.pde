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
  jsonShapeColour.setFloat("hue", shapeHue);
  jsonShapeColour.setFloat("saturation", shapeSaturation);
  jsonShapeColour.setFloat("brightness", shapeBrightness);
  jsonShapeColour.setFloat("alpha", shapeTransparency);

  for (int x = 0 ; x < selectedShape.values.length; x++) {
    jsonShapeParameters.setFloat(x, selectedShape.values[x]);
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
  JSONObject jsonCamera = jsonRoot.getJSONObject("camera");
  cp5.getController("zoom").setValue(jsonCamera.getFloat("zoom"));
  cp5.getController("changeSpeedX").setValue(jsonCamera.getFloat("changeSpeedX"));
  cp5.getController("changeSpeedY").setValue(jsonCamera.getFloat("changeSpeedY"));
  cp5.getController("autoRotate").setValue(jsonCamera.getBoolean("autoRotate") ? 1 : 0);

  rotationX = jsonCamera.getFloat("rotationX");
  rotationY = jsonCamera.getFloat("rotationY");
  rotationZ = jsonCamera.getFloat("rotationZ");
}

void loadScene(JSONObject jsonRoot) {
  // Scene
  JSONObject jsonScene = jsonRoot.getJSONObject("scene");
  cp5.getController("sunflowSkyLightOn").setValue(jsonScene.getBoolean("sunflowSkyLightOn") ? 1 : 0);
  cp5.getController("sunflowWhiteBackgroundOn").setValue(jsonScene.getBoolean("sunflowWhiteBackgroundOn") ? 1 : 0);
  cp5.getController("sunflowBlackBackgroundOn").setValue(jsonScene.getBoolean("sunflowBlackBackgroundOn") ? 1 : 0);
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
  cp5.getController("dirLightRadius").setValue(jsonDirectionalLights.getFloat("dirLightRadius"));
  cp5.getController("dirLightTopOn").setValue(jsonDirectionalLights.getBoolean("dirLightTopOn") ? 1 : 0);
  cp5.getController("dirLightRightOn").setValue(jsonDirectionalLights.getBoolean("dirLightRightOn") ? 1 : 0);
  cp5.getController("dirLightFrontOn").setValue(jsonDirectionalLights.getBoolean("dirLightFrontOn") ? 1 : 0);
  cp5.getController("dirLightBottomOn").setValue(jsonDirectionalLights.getBoolean("dirLightBottomOn") ? 1 : 0);
  cp5.getController("dirLightLeftOn").setValue(jsonDirectionalLights.getBoolean("dirLightLeftOn") ? 1 : 0);
  cp5.getController("dirLightBehindOn").setValue(jsonDirectionalLights.getBoolean("dirLightBehindOn") ? 1 : 0);

  // Sphere light
  JSONObject jsonSphereLights = jsonRoot.getJSONObject("sphereLights");
  cp5.getController("sphereLightRadius").setValue(jsonSphereLights.getFloat("sphereLightRadius"));
  cp5.getController("sphereLightTopOn").setValue(jsonSphereLights.getBoolean("sphereLightTopOn") ? 1 : 0);
  cp5.getController("sphereLightRightOn").setValue(jsonSphereLights.getBoolean("sphereLightRightOn") ? 1 : 0);
  cp5.getController("sphereLightFrontOn").setValue(jsonSphereLights.getBoolean("sphereLightFrontOn") ? 1 : 0);
  cp5.getController("sphereLightBottomOn").setValue(jsonSphereLights.getBoolean("sphereLightBottomOn") ? 1 : 0);
  cp5.getController("sphereLightLeftOn").setValue(jsonSphereLights.getBoolean("sphereLightLeftOn") ? 1 : 0);
  cp5.getController("sphereLightBehindOn").setValue(jsonSphereLights.getBoolean("sphereLightBehindOn") ? 1 : 0);


  // Light colour
  JSONObject jsonLightColour = jsonRoot.getJSONObject("lightColour");
  cp5.getController("lightsColorR").setValue(jsonLightColour.getFloat("lightsColorR"));
  cp5.getController("lightsColorG").setValue(jsonLightColour.getFloat("lightsColorG"));
  cp5.getController("lightsColorB").setValue(jsonLightColour.getFloat("lightsColorB"));
  cp5.getController("lightsColorA").setValue(jsonLightColour.getFloat("lightsColorA"));
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
    cp5.getController("param" + x).setValue(jsonShaderParameters.getFloat(x));
  }
}

void loadShape(JSONObject jsonRoot) {
  // Shape
  JSONObject jsonShape = jsonRoot.getJSONObject("shape");
  JSONArray jsonShapeParameters = jsonShape.getJSONArray("parameters");
  JSONObject jsonShapeColour = jsonShape.getJSONObject("colour");

  for (int x = 0 ; x < shapes.size(); x++)  {
    Shape shape = shapes.get(x);
    if (shape.name.equals(jsonShape.getString("name"))) {
      shapeList.setValue(x);
    }
  }

  cp5.getController("facesOn").setValue(jsonShape.getBoolean("facesOn") ? 1 : 0);
  cp5.getController("edgesOn").setValue(jsonShape.getBoolean("edgesOn") ? 1 : 0);
  cp5.getController("shapeHue").setValue(jsonShapeColour.getFloat("hue"));
  cp5.getController("shapeSaturation").setValue(jsonShapeColour.getFloat("saturation"));
  cp5.getController("shapeBrightness").setValue(jsonShapeColour.getFloat("brightness"));
  cp5.getController("shapeTransparency").setValue(jsonShapeColour.getFloat("alpha"));

  for (int x = 0 ; x < selectedShape.values.length; x++) {
    selectedShape.values[x] = jsonShapeParameters.getFloat(x);
    cp5.getController("create" + x).setValue(jsonShapeParameters.getFloat(x));
  }
}

void loadModifiers(JSONObject jsonRoot) {
  // Modifiers
  JSONArray json = jsonRoot.getJSONArray("modifiers");

  for (int i = 0; i < json.size(); i++) {
    JSONObject node = json.getJSONObject(i);

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

void loadRendering(JSONObject jsonRoot) {
  // Rendering
  JSONObject jsonRendering = jsonRoot.getJSONObject("rendering");
  cp5.getController("saveOpenGL").setValue(jsonRendering.getBoolean("opengl") ? 1 : 0);
  cp5.getController("saveSunflow").setValue(jsonRendering.getBoolean("sunflow") ? 1 : 0);
  cp5.getController("saveGui").setValue(jsonRendering.getBoolean("gui") ? 1 : 0);
  cp5.getController("saveMask").setValue(jsonRendering.getBoolean("mask") ? 1 : 0);
  cp5.getController("savePreview").setValue(jsonRendering.getBoolean("preview") ? 1 : 0);
  cp5.getController("saveContinuous").setValue(jsonRendering.getBoolean("continuous") ? 1 : 0);
}
