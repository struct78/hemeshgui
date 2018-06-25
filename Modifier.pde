class Modifier extends BaseModel {
  public int index;
  public int currentIndex;
  private ModifierCreator modifierCreator;

  Modifier (String name, int parameters) {
      super(name, parameters);
  }

  int getY(int parameter) {
    int z = my2;

    if (this.index > 0) {
      z += multiplyGrid(this.index);
    }

    for ( int x = 0 ; x < selectedModifiers.size() ; x++ ) {
      if (x < this.index) {
        Modifier m = selectedModifiers.get(x);
        z += multiplyGrid(m.parameters + 1);
      }
    }

    if (parameter >= 0) {
      z += multiplyGrid(parameter + 1);
    }

    return z;
  }

  // display gui elements for the modifier
  void menu() {
    String buttonName = getButtonName(this.index);
    Button button = cp5.addButton(buttonName, 0, mx2, getY(-1), Config.CP5.Controls.Width, Config.CP5.Controls.Height);
    button.setLabel(this.name + " [remove]");
    button.setId(this.index);
    button.onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        String buttonName = getButtonName(index);
        selectedModifiers.remove(index);
        cp5.remove(buttonName);
        for (int i = 0; i < values.length; i++) {
          cp5.remove(getSliderName(index, i));
        }
        createHemesh();
      }
    });

    for (int i = 0; i < this.parameters; i++) {
      cp5.addSlider(getSliderName(index, i), this.minValues[i], this.maxValues[i])
        .setSize(Config.CP5.Controls.Width, Config.CP5.Controls.Height)
        .setPosition(mx2, getY(i))
        .setLabel(this.labels[i])
        .setId(i)
        .setValue(this.defaultValues[i])
        .onChange(new CallbackListener() {
            public void controlEvent(CallbackEvent theEvent) {
                Modifier m = (Modifier) selectedModifiers.get(index);
                m.values[theEvent.getController().getId()] = theEvent.getController().getValue();

                createHemesh();
            }
        });
    }
  }

  // reposition modifier gui if an earlier modifier is removed (aka everything moves up one place)
  void update() {
    if (this.index != this.currentIndex) {
      cp5.remove(getButtonName(this.currentIndex));

      for (int i = 0; i < this.values.length; i++) {
          cp5.remove(getSliderName(this.currentIndex, i));
      }

      this.currentIndex = this.index;
      this.menu();
    }
  }

  Modifier setMaxValues(float[] maxValues) {
    this.maxValues = maxValues;
    return this;
  }

  Modifier setMinValues(float[] minValues) {
    this.minValues = minValues;
    return this;
  }

  Modifier setDefaultValues(float[] defaultValues) {
    this.defaultValues = defaultValues;
    this.values = defaultValues;
    return this;
  }

  Modifier setLabels(String[] labels) {
    this.labels = labels;
    return this;
  }

  Modifier setCreator(ModifierCreator creator) {
    this.modifierCreator = creator;
    return this;
  }

  Modifier setIndex(int index) {
    this.index = index;
    this.currentIndex = index;
    return this;
  }

  int getIndex() {
    return this.index;
  }

  boolean hasCreator() {
    return this.modifierCreator != null;
  }

  void create() {
    if (this.modifierCreator != null) {
      this.modifierCreator.create(values);
    } else {
      println("No modifier found");
    }
  }
}

interface ModifierCreator {
  public void create(float[] values);
}
