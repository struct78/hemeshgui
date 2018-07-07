class Shape extends BaseModel {
  boolean isMeshCollection;
  boolean isCustom;
  ShapeCreator shapeCreator;
  File file;

  Shape (String name, int parameters) {
    super(name, parameters);
    this.isMeshCollection = false;
    this.isCustom = false;
    this.file = null;
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

  Shape setCustom(boolean isCustom) {
    this.isCustom = isCustom;
    return this;
  }

  boolean getCustom() {
    return this.isCustom;
  }

  Shape setFile(File file) {
    this.file = file;
    return this;
  }

  Shape setFileFromBase64String(String fileContents, String fileExtension) {
    UUID uuid = UUID.randomUUID();
    String path = System.getProperty("java.io.tmpdir") + "/" + uuid.toString() + "." + fileExtension;
    try {
      FileOutputStream stream = new FileOutputStream(path);
      stream.write(Base64.getDecoder().decode(fileContents));
      stream.close();
    } catch (FileNotFoundException e) {
        e.printStackTrace();
    } catch (IOException e) {
        e.printStackTrace();
    }

    this.file = new File(path);
    return this;
  }

  String getBase64EncodedFile() {
    String encodedFile = null;
    try {
        FileInputStream stream = new FileInputStream(this.file);
        byte[] bytes = new byte[(int)this.file.length()];
        stream.read(bytes);
        encodedFile = new String(Base64.getEncoder().encode(bytes));
    } catch (FileNotFoundException e) {
        e.printStackTrace();
    } catch (IOException e) {
        e.printStackTrace();
    }

    return encodedFile;
  }

  boolean getMeshCollection() {
    return this.isMeshCollection;
  }

  File getFile() {
    return this.file;
  }

  Shape setCreator(ShapeCreator creator) {
    this.shapeCreator = creator;
    return this;
  }

  void create() {
    if (this.shapeCreator != null) {
      if (this.isCustom) {
        this.shapeCreator.create(values, file);
      } else {
        this.shapeCreator.create(values);
      }
    } else {
      println("No creator found");
    }
  }

  void validate(HE_Mesh mesh) {
    HET_Diagnosis.validate(mesh);
  }
}

interface ShapeCreator {
  public void create(float[] values);
  public void create(float[] values, File file);
}

class UVFunction implements WB_VectorParameter {
    public double sq = 2.0;
    public double dv = 2.0;

    public UVFunction(double sq, double dv) {
      this.sq = sq;
      this.dv = dv;
    }

    WB_Point evaluate(double... u) {
      double pi23 = TWO_PI / this.dv;
      double ua = Math.PI * 2 * u[0];
      double va = Math.PI * 2 * u[1];
      double sqrt2 = Math.sqrt(this.sq);
      double px = Math.sin(ua) / Math.abs(sqrt2+ Math.cos(va));
      double py = Math.sin(ua + pi23) / Math.abs(sqrt2 + Math.cos(va + pi23));
      double pz = Math.cos(ua - pi23) / Math.abs(sqrt2 + Math.cos(va - pi23));

      return new WB_Point(px, py, pz);
    }
}
