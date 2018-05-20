
class Modifier {
  int select;
  float[] values = new float[5];
  int index, currentIndex;

  Modifier (int index, int select, float[] values) {
    this.index = index;
    this.select = select;
    this.values = values;
    currentIndex = index;
    menu();
  }

  // run the modifier
  void hemesh() {
    hemeshModify(select, values[0], values[1], values[2], values[3], values[4]);
  }

  // display gui elements for the modifier
  void menu() {
    controlP5.Button myButton = controlP5.addButton("remove" + index, 0, 300 + int(index/5) * 240, 20 + index * 130 - int(index/5) * 650, 200, 15);
    myButton.setLabel(numToName(select) + "   [remove]");
    myButton.setId(index);

    for (int i=0; i<4; i++) {
      controlP5.addSlider(index + "v" + i, 0,10, values[i], 300 + int(index/5) * 240, 20 + index * 130 - int(index/5) * 650 + (i+1) * 20, 200, 15).setLabel("");
      Slider temp = (Slider)controlP5.getController(index + "v" + i);
      temp.setId(index);
    }

    controlP5.addSlider(index + "v" + 4, 0,100, values[4], 300 + int(index/5) * 240, 20 + index * 130 - int(index/5) * 650 + (4+1) * 20, 200, 15).setLabel("");
    Slider temp = (Slider)controlP5.getController(index + "v" + 4);
    temp.setId(index);
  }

  // reposition modifier gui if an earlier modifier is removed (aka everything moves up one place)
  void newMenu() {
    if (index != currentIndex) {
      controlP5.remove("remove" + currentIndex);
      for (int i=0; i<5; i++) {
        controlP5.remove(currentIndex+"v"+i);
      }
      currentIndex = index;
      menu();
    }
  }
}