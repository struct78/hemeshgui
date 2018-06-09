class Machine {
  String name;
  int parameters;
  float[] minValues;
  float[] maxValues;
  float[] defaultValues;
  float[] values;
  String[] labels;

  Machine (String name, int parameters) {
    this.name = name;
    this.minValues = new float[] { Config.Hemesh.Values.Min, Config.Hemesh.Values.Min, Config.Hemesh.Values.Min, Config.Hemesh.Values.Min };
    this.maxValues = new float[] { Config.Hemesh.Values.Max, Config.Hemesh.Values.Max, Config.Hemesh.Values.Max, Config.Hemesh.Values.Max };
    this.defaultValues = new float[] { Config.Hemesh.Values.Default, 5, 5, 5 };
    this.values = this.defaultValues;
    this.labels = new String[] { null, null, null, null };
    this.parameters = parameters;
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
