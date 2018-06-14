void lightsColorLikeShapeColor() {
  cp5.getController("lightsColorR").setValue(red(shapecolor));
  cp5.getController("lightsColorG").setValue(green(shapecolor));
  cp5.getController("lightsColorB").setValue(blue(shapecolor));
  cp5.getController("lightsColorA").setValue(alpha(shapecolor));

  lightsColor = color(lightsColorR, lightsColorG, lightsColorB, lightsColorA);
}
