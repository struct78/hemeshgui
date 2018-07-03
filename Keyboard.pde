

// some useful keyboard actions
void keyPressed() {
  isHoldingShift = (keyCode == SHIFT);
  isHoldingAlt = (keyCode == ALT);
  isHoldingCtrl = (keyCode == CONTROL);

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
    save("renders/screenshots/" + timestamp + " (gui).png");
    println("Screenshot of current GUI saved");
  }

  // preview quality sunflow render (+ gui screenshot)
  if (key == 'x') {
    cp5.getController("autoRotate").setValue(0);
    ((Toggle)cp5.getController("saveContinuous")).setValue(0).setLabel("Continuously").setColorCaptionLabel(currentTheme.ControlCaptionLabel);
    cp5.getController("saveGui").setValue(1);
    cp5.getController("savePreview").setValue(1);
    cp5.getController("saveSunflow").setValue(1);
    save();
  }

  // high quality sunflow render (+ gui screenshot)
  if (key == 'c') {
    cp5.getController("autoRotate").setValue(0);
    ((Toggle)cp5.getController("saveContinuous")).setValue(0).setLabel("Continuously").setColorCaptionLabel(currentTheme.ControlCaptionLabel);
    cp5.getController("saveGui").setValue(1);
    cp5.getController("savePreview").setValue(0);
    cp5.getController("saveSunflow").setValue(1);
    save();
  }

  // export shape to a STL file
  if (key == 'l') {
    timestamp = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    String path = sketchPath() + "/renders/export_stl/";
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

void keyReleased() {
  if (keyCode == SHIFT) isHoldingShift = false;
  if (keyCode == ALT) isHoldingAlt = false;
  if (keyCode == CONTROL) isHoldingCtrl = false;
}
