void mouseDragged() {
  if (!cp5.isMouseOver()) {
    if (isHoldingCtrl) {
      rotationX -= (mouseY - pmouseY) / TWO_PI;
      rotationY += 0;
      rotationZ += 0;
    } else if (isHoldingShift) {
      rotationX -= 0;
      rotationY += (mouseX - pmouseX) / TWO_PI;
      rotationZ += 0;
    } else if (isHoldingAlt) {
      rotationX -= 0;
      rotationY += 0;
      rotationZ += (mouseX - pmouseX) / TWO_PI;
    } else {
      rotationX -= (mouseY - pmouseY) / TWO_PI;
      rotationY += (mouseX - pmouseX) / TWO_PI;
      rotationZ += (mouseX - pmouseX) / TWO_PI;
    }
  }
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
