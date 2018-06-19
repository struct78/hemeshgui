
void resetRotationMouvement() {
  rotationYchange = 0;
  rotationXchange = 0;
}

void resetTranslationMouvement() {
  translateXchange = 0;
  translateYchange = 0;
}

void progressiveRotation() {

  if(mouseX<width/2) {
    rotationYchange = ((width/2) - mouseX) * maxSpeedY / (width/2);
  } else {
    rotationYchange = - ( (mouseX - (width/2)) * maxSpeedY / (width/2));
  }

  if(mouseY<height/2) {
    rotationXchange = -( ((height/2) - mouseY) * maxSpeedX / (height/2));
  } else {
    rotationXchange = (mouseY - (height/2)) * maxSpeedX / (height/2);
  }
}

void progressiveTranslation() {

  if(mouseX<width/2) {
    translateXchange = ((width/2) - mouseX) * maxSpeedX / (width/2);
  } else {
    translateXchange = - ( (mouseX - (width/2)) * maxSpeedX / (width/2));
  }

  if(mouseY<height/2) {
    translateYchange = ((height/2) - mouseY) * maxSpeedY / (height/2);
  } else {
    translateYchange = -( (mouseY - (height/2)) * maxSpeedY / (height/2));
  }
}


void rotation() {
    if (mouseX > 2*width/3)  { rotationYchange = changeSpeedY;  } else if (mouseX < width/3)  { rotationYchange = -changeSpeedY; } else { rotationYchange = 0; }
    if (mouseY > 2*height/3) { rotationXchange = -changeSpeedX; } else if (mouseY < height/3) { rotationXchange = changeSpeedX;  } else { rotationXchange = 0; }
}

void translation() {
    if (mouseX > 2*width/3)  { translateXchange = changeSpeedX; } else if (mouseX < width/3)  { translateXchange = -changeSpeedX; } else { translateXchange = 0; }
    if (mouseY > 2*height/3) { translateYchange = changeSpeedY; } else if (mouseY < height/3) { translateYchange = -changeSpeedY; } else { translateYchange = 0; }
}

void viewport() {

  if(flagMouseControlRotationMouvement) {
    progressiveRotation();
  } else {
     resetRotationMouvement();
     if (rotationOn) rotation();
     if (autoRotate) {
       rotationXchange = changeSpeedX/2;
       rotationYchange = -changeSpeedY/2;
     }
  }

  if(flagMouseControlTranslationMouvement) {
    //progressiveTranslation();
  } else {
     resetTranslationMouvement();
     if (translationOn) translation();
  }

  updateViewport();


}


void updateViewport() {

  //translation
  translateX += translateXchange;
  translateY += translateYchange;
  translate(translateX,translateY);

  // rotation
  rotationX += rotationXchange;
  rotationY += rotationYchange;
  rotateX(radians(rotationX));
  rotateY(radians(rotationY));

  if (abs(actualZoom - zoom) > 1)   { actualZoom = 0.99 * actualZoom + 0.01 * zoom; }
  scale(actualZoom);
}
