// TODO: Fix this
void quickSave() {
  //shaderList.setValue(selectedShaderIndex);
  //shapeList.setValue(selectedShapeIndex);
  cp5.saveProperties(sketchPath() + "/output/quicksave");
}

void quickLoad() {
  cp5.loadProperties(sketchPath() + "/output/quicksave");
  selectedShaderIndex = (int) shaderList.getValue();
  selectedShapeIndex = (int) shapeList.getValue();
  setShapeParameters(selectedShapeIndex);
  setShaderParameters(selectedShaderIndex);
  createHemesh();
}
