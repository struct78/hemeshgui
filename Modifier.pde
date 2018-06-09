class Modifier extends Machine {
    public int index;
    public int currentIndex;
    private ModifierCreator modifierCreator;

    Modifier (String name, int parameters) {
        super(name, parameters);
    }

    // display gui elements for the modifier
    void menu() {
        Button button = cp5.addButton("remove" + index, 0, mx2, my2, Config.CP5.Controls.Width, Config.CP5.Controls.Height);
        button.setLabel(this.name + " [remove]");
        button.setId(index);
        button.onClick(new CallbackListener() {
            public void controlEvent(CallbackEvent theEvent) {
                selectedModifiers.remove(index);
                cp5.remove("remove" + index);
                for (int i = 0; i < values.length; i++) {
                    cp5.remove(index + "v" + i);
                }
                createHemesh();
            }
        });

        my2 += multiplyGrid(1);

        for (int i = 0; i < this.parameters; i++) {
            cp5.addSlider(index + "v" + i, this.minValues[i], this.maxValues[i])
                .setSize(Config.CP5.Controls.Width, Config.CP5.Controls.Height)
                .setPosition(mx2, my2)
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

            my2 += multiplyGrid(1);
        }

        my2 += multiplyGrid(1);
    }

    // reposition modifier gui if an earlier modifier is removed (aka everything moves up one place)
    void update() {
        if (index != currentIndex) {
            cp5.remove("remove" + currentIndex);

            for (int i = 0; i < this.values.length; i++) {
                cp5.remove(currentIndex + "v" + i);
            }

            currentIndex = index;
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
