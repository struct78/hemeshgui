class BaseModel {
  String name;
  int parameters;
  float[] minValues;
  float[] maxValues;
  float[] defaultValues;
  float[] values;
  String[] labels;

  BaseModel (String name, int parameters) {
    this.name = name;
    this.parameters = parameters;
    this.minValues = new float[parameters];
    this.maxValues = new float[parameters];
    this.defaultValues = new float[parameters];
    this.labels = new String[parameters];

    for ( int x = 0 ; x < parameters; x++ ) {
      this.minValues[x] = Config.Hemesh.Values.Min;
      this.maxValues[x] = Config.Hemesh.Values.Max;
      this.defaultValues[x] = Config.Hemesh.Values.Default;
    }

    this.values = this.defaultValues;
  }

  float[] getMaxValues() {
    return this.maxValues;
  }

  float[] getMinValues() {
    return this.minValues;
  }

  float[] getDefaultValues() {
    return this.defaultValues;
  }

  String[] getLabels() {
    return this.labels;
  }
}
