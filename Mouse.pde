void mouseDragged() {
  if (!cp5.isMouseOver()) {
    rotationX -= isHoldingAlt ? 0 : (mouseY - pmouseY) / TWO_PI;
    rotationY += isHoldingCtrl ? 0 : (mouseX - pmouseX) / TWO_PI;
    rotationZ += isHoldingCtrl ? (mouseX - pmouseX) / TWO_PI : 0;
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
