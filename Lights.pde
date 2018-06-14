void lightsColorLikeShapeColor() {
  cp5.getController("lightsColorR").setValue(red(shapeColor));
  cp5.getController("lightsColorG").setValue(green(shapeColor));
  cp5.getController("lightsColorB").setValue(blue(shapeColor));
  cp5.getController("lightsColorA").setValue(alpha(shapeColor));

  lightsColor = color(lightsColorR, lightsColorG, lightsColorB, lightsColorA);
}
