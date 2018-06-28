void createZoomAnimation() {
  Ani.init(this);
	zoomAnimation = new Ani(this, 0.35, "actualZoom", zoom, Ani.QUART_OUT);
}

void updateZoomAnimation(float value) {
  zoomAnimation.setBegin(actualZoom);
  zoomAnimation.setEnd(value);
  zoomAnimation.start();
}

void resetRotationMovement() {
  rotationYchange = 0;
  rotationXchange = 0;
}

void progressiveRotation() {
  if (mouseX < width/2) {
    rotationYchange = ((width/2) - mouseX) * maxSpeedY / (width/2);
  } else {
    rotationYchange = - ( (mouseX - (width/2)) * maxSpeedY / (width/2));
  }

  if (mouseY < height/2) {
    rotationXchange = -( ((height/2) - mouseY) * maxSpeedX / (height/2));
  } else {
    rotationXchange = (mouseY - (height/2)) * maxSpeedX / (height/2);
  }
}

void rotation() {
    if (mouseX > 2*width/3)  { rotationYchange = changeSpeedY;  } else if (mouseX < width/3)  { rotationYchange = -changeSpeedY; } else { rotationYchange = 0; }
    if (mouseY > 2*height/3) { rotationXchange = -changeSpeedX; } else if (mouseY < height/3) { rotationXchange = changeSpeedX;  } else { rotationXchange = 0; }
}

void viewport() {
  isDraggingOnly = (!rotationOn && !autoRotate);

  resetRotationMovement();
  if (rotationOn) rotation();
  if (autoRotate) {
    rotationXchange = changeSpeedX/2;
    rotationYchange = -changeSpeedY/2;
  }

  updateViewport();
}

void updateViewport() {
  translate(translateX,translateY);

  // rotation
  rotationX += rotationXchange;
  rotationY += rotationYchange;

  rotateX(radians(rotationX));
  rotateY(radians(rotationY));
  rotateZ(radians(rotationZ));

  // zoom
  scale(actualZoom);
}
