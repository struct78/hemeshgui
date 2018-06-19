class Shader extends BaseModel {
  private ShaderCreator shaderCreator;

  Shader (String name, int parameters) {
    super(name, parameters);
  }

  Shader setMaxValues(float[] maxValues) {
    this.maxValues = maxValues;
    return this;
  }

  Shader setMinValues(float[] minValues) {
    this.minValues = minValues;
    return this;
  }

  Shader setDefaultValues(float[] defaultValues) {
    this.defaultValues = defaultValues;
    this.values = defaultValues;
    return this;
  }

  Shader setLabels(String[] labels) {
    this.labels = labels;
    return this;
  }

  Shader setCreator(ShaderCreator creator) {
    this.shaderCreator = creator;
    return this;
  }

  void create(SunflowAPIAPI sunflow) {
    if (this.shaderCreator != null) {
      this.shaderCreator.create(sunflow, values);
    } else {
      println("No creator found");
    }
  }
}

interface ShaderCreator {
  public void create(SunflowAPIAPI sunflow, float[] values);
}
