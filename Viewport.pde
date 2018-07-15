void createAnimations() {
  Ani.init(this);
	zoomAnimation = new Ani(this, 0.35, "actualZoom", zoom, Ani.SINE_OUT);
  spinnerAnimationStart = new Ani(this, 1.0, 0.25, "spinnerAngleStart", Config.Spinner.StartAngle + 360, Ani.SINE_OUT);
  spinnerAnimationEnd = new Ani(this, 1.25, "spinnerAngleEnd", Config.Spinner.EndAngle + 360, Ani.SINE_OUT, "onEnd:onSequenceEnd");
}

void onSequenceEnd() {
  spinnerAngleStart = Config.Spinner.StartAngle;
  spinnerAngleEnd = Config.Spinner.EndAngle;
  spinnerAnimationStart.start();
  spinnerAnimationEnd.start();
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

void viewport() {
  resetRotationMovement();
  if (autoRotate) {
    rotationXchange = changeSpeedX/2;
    rotationYchange = -changeSpeedY/2;
  }

  updateViewport();
}

void updateViewport() {
  translate(translateX, translateY);

  // rotation
  rotationX += rotationXchange;
  rotationY += rotationYchange;

  rotateX(radians(rotationX));
  rotateY(radians(rotationY));
  rotateZ(radians(rotationZ));

  // zoom
  scale(actualZoom);
}
