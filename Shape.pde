class Shape extends BaseModel {
  private boolean isMeshCollection;
  private ShapeCreator shapeCreator;

  Shape (String name, int parameters) {
    super(name, parameters);
    this.isMeshCollection = false;
  }

  Shape setMaxValues(float[] maxValues) {
    this.maxValues = maxValues;
    return this;
  }

  Shape setMinValues(float[] minValues) {
    this.minValues = minValues;
    return this;
  }

  Shape setDefaultValues(float[] defaultValues) {
    this.defaultValues = defaultValues;
    this.values = defaultValues;
    return this;
  }

  Shape setLabels(String[] labels) {
    this.labels = labels;
    return this;
  }

  Shape setMeshCollection(boolean isMeshCollection) {
    this.isMeshCollection = isMeshCollection;
    return this;
  }

  boolean getMeshCollection() {
    return this.isMeshCollection;
  }

  Shape setCreator(ShapeCreator creator) {
    this.shapeCreator = creator;
    return this;
  }

  void create() {
    if (this.shapeCreator != null) {
      this.shapeCreator.create(values);
    } else {
      println("No creator found");
    }
  }
}

interface ShapeCreator {
  public void create(float[] values);
}

class UVFunction implements WB_VectorParameter {
    WB_Point evaluate(double... u) {
      double pi23 = 2 * Math.PI / 3;
      double ua = Math.PI * 2 * u[0];
      double va = Math.PI * 2 * u[1];
      double sqrt2 = Math.sqrt(2.0d);
      double px = Math.sin(ua) / Math.abs(sqrt2+ Math.cos(va));
      double py = Math.sin(ua + pi23) / Math.abs(sqrt2 + Math.cos(va + pi23));
      double pz = Math.cos(ua - pi23) / Math.abs(sqrt2 + Math.cos(va - pi23));

      return new WB_Point(px, py, pz);
    }
}
