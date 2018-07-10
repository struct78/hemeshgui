
// resel all
void reset() {
  // basic shape variables
  selectedShapeIndex = 0;
  selectedShaderIndex = 0;

  defaultShapeValues = selectedShape.getDefaultValues();
  maxShapeValues = selectedShape.getMaxValues();
  minShapeValues = selectedShape.getMinValues();

  resetView();
  resetLights();

  for ( int x = 0 ; x < maxShapeParameters ; x++ ) {
    cp5.getController("create" + x).setValue(defaultShapeValues[0]);
    cp5.getController("create" + x).setMax(maxShapeValues[0]);
    cp5.getController("create" + x).setMin(minShapeValues[0]);
  }

  setShapeParameters(selectedShapeIndex);
  setShaderParameters(selectedShaderIndex);

  // saving variables
  cp5.getController("saveOpenGL").setValue(0);
  cp5.getController("saveGui").setValue(0);
  cp5.getController("saveSunflow").setValue(1);
  cp5.getController("saveMask").setValue(0);
  cp5.getController("savePreview").setValue(0);

  ((Toggle)cp5.getController("saveContinuous"))
    .setValue(0)
    .setLabel("Continuously")
    .setColorCaptionLabel(currentTheme.ControlCaptionLabel);

  sunflowMultiply = 1;
  cp5.getController("lblSunflowSize").setValueLabel("SUNFLOW RENDERING SIZE : " + int(sceneWidth*sunflowMultiply)+ " x " + int(sceneHeight*sunflowMultiply));

  // ShapeList + ModifyList
  shapeList.getCaptionLabel().set("Select Shape");
  modifyList.getCaptionLabel().set("Select Modifier");

  // remove the gui elements for all modifiers
  for (int i = 0; i < selectedModifiers.size(); i++) {
    Modifier modifier = selectedModifiers.get(i);
    cp5.remove(getButtonName(i));
    for (int j=0; j<modifier.parameters; j++) {
      cp5.remove(getSliderName(i, j));
    }
  }

  // remove all modifiers
  selectedModifiers.clear();

  // start up again
  createHemesh();
}

void resetLights() {
  cp5.getController("sunflowSkyLightOn").setValue(1);
  cp5.getController("sunflowWhiteBackgroundOn").setValue(0);
  cp5.getController("sunflowBlackBackgroundOn").setValue(0);

  // sunflow lights
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
  cp5.getController("autoRotate").setValue(0);

  translateX = width/2;
  translateY = height/2;
  rotationY = 45;
  rotationX = -30;
  actualZoom = 1;

  resetRotationMovement();
  updateShapeColors();

  // presentation
  cp5.getController("shapeHue").setValue(shapeHue);
  cp5.getController("shapeSaturation").setValue(shapeSaturation);
  cp5.getController("shapeBrightness").setValue(shapeBrightness);
  cp5.getController("shapeTransparency").setValue(shapeTransparency);
  cp5.getController("facesOn").setValue(1);
  cp5.getController("edgesOn").setValue(0);
}
