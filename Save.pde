void save() {
  if (saveOn) {
    saveOn = false;
    ((Toggle)cp5.getController("saveContinuous")).setLabel("Continuously").setColorCaptionLabel(currentTheme.ControlCaptionLabel);
    println("Saving stopped");
  } else {
    drawcp5 = true;
    if (saveContinuous) {
      ((Toggle)cp5.getController("saveContinuous"))
          .setLabel("Continuously [Saving]")
          .setColorCaptionLabel(currentTheme.ControlCaptionLabel);
    }

    timestamp = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    saveOn = true;
    print("\nSaving started (" + timestamp +")");
    if (saveOpenGL) {
      print(" | OpenGL Current View");
    }
    if (saveGui) {
      print(" | Gui");
    }
    if (saveSunflow) {
      print(" | Render Sunflow");
    }
    if (saveMask) {
      print(" | Save Sunflow Mask");
    }
    print("\n");
  }
}
