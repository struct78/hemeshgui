public static class Config {
  private static HashMap<String, Theme> _themes;
  private static String _currentTheme;

  static {
      // Default
      Theme classic = new Theme();
      classic.Background = 0xffe6e6e6;
      classic.Faces = 0xffcccc00;
      classic.Edges = 0x00000000;
      classic.ControlBackground = 0xffa2997d;
      classic.ControlForeground = 0xffcccc00;
      classic.ControlActive = 0xffe0e000;
      classic.ControlCaptionLabel = 0xff000000;
      classic.ControlValueLabel = 0xff000000;
      classic.ControlSubLabel = 0x90000000;
      classic.ButtonBackground = 0xffcccc00;
      classic.ButtonForeground = 0xff000000;
      classic.Spinner = 0xff000000;

      // Flat
      Theme flat = new Theme();
      flat.Background = 0xff1b1c1c;
      flat.Faces = 0xff2980b9;
      flat.Edges = 0xff2c3e50;
      flat.ControlBackground = 0xffff7263;
      flat.ControlForeground = 0xffe74c3c;
      flat.ControlActive = 0xffFFD156;
      flat.ControlCaptionLabel = 0xffecf0f1;
      flat.ControlValueLabel = 0xff0f0504;
      flat.ControlSubLabel = 0x90ecf0f1;
      flat.ButtonBackground = 0xff03a187;
      flat.ButtonForeground = 0xffecf0f1;
      flat.Spinner = 0xffFFD156;

      Theme monochrome = new Theme();
      monochrome.Background = 0xff141e26;
      monochrome.Faces = 0xff1fa698;
      monochrome.Edges = 0xfff2f2f2;
      monochrome.ControlBackground = 0xff1d736a;
      monochrome.ControlForeground = 0xff1fa698;
      monochrome.ControlActive = 0xff35d4c3;
      monochrome.ControlCaptionLabel = 0xfff2f2f2;
      monochrome.ControlValueLabel = 0xfff2f2f2;
      monochrome.ControlSubLabel = 0xAAf2f2f2;
      monochrome.ButtonBackground = 0xff35d4c3;
      monochrome.ButtonForeground = 0xff141e26;
      monochrome.Spinner = 0xfff2f2f2;

      Theme pastel = new Theme();
      pastel.Background = 0xfff4cda5;
      pastel.Faces = 0xff3c989e;
      pastel.Edges = 0xff2b6c70;
      pastel.ControlBackground = 0xfff57a82;
      pastel.ControlForeground = 0xffed5276;
      pastel.ControlActive = 0xfff57a82;
      pastel.ControlCaptionLabel = 0xff444854;
      pastel.ControlValueLabel = 0xfff4cda5;
      pastel.ControlSubLabel = 0x90444854;
      pastel.ButtonBackground = 0xff50d4a5;
      pastel.ButtonForeground = 0xff1b1d21;
      pastel.Spinner = 0xfff4cda5;

      Theme neon = new Theme();
      neon.Background = 0xff270dff;
      neon.Faces = 0xffff0da5;
      neon.Edges = 0xffa700ff;
      neon.ControlBackground = 0xffd80ce8;
      neon.ControlForeground = 0xffa700ff;
      neon.ControlActive = 0xffACFD04;
      neon.ControlCaptionLabel = 0xffffffff;
      neon.ControlValueLabel = 0xffffffff;
      neon.ControlSubLabel = 0x90ffffff;
      neon.ButtonBackground = 0xff000000;
      neon.ButtonForeground = 0xff02a9fe;
      neon.Spinner = 0xffACFD04;

      Theme summerFruit = new Theme();
      summerFruit.Background = 0xfff78d0a;
      summerFruit.Faces = 0xff4f9e3f;
      summerFruit.Edges = 0xfff7dc0a;
      summerFruit.ControlBackground = 0xffc7283e;
      summerFruit.ControlForeground = 0xff8a0336;
      summerFruit.ControlActive = 0xff8a0336;
      summerFruit.ControlCaptionLabel = 0xfffaf0ca;
      summerFruit.ControlValueLabel = 0xfffaf0ca;
      summerFruit.ControlSubLabel = 0xaafaf0ca;
      summerFruit.ButtonBackground = 0xff4f9e3f;
      summerFruit.ButtonForeground = 0xff190600;
      summerFruit.Spinner = 0xfff7dc0a;

      Theme coteDAzur = new Theme();
      coteDAzur.Background = 0xfff0edbb;
      coteDAzur.Faces = 0xffff3800;
      coteDAzur.Edges = 0xfffffcc4;
      coteDAzur.ControlBackground = 0xff009393;
      coteDAzur.ControlForeground = 0xff00585F;
      coteDAzur.ControlActive = 0xff00585F;
      coteDAzur.ControlCaptionLabel = 0xff190600;
      coteDAzur.ControlValueLabel = 0xfff0edbb;
      coteDAzur.ControlSubLabel = 0x90190600;
      coteDAzur.ButtonBackground = 0xffff5729;
      coteDAzur.ButtonForeground = 0xff190600;
      coteDAzur.Spinner = 0xfffffcc4;

      _themes = new HashMap<String, Theme>();
      _themes.put("Classic", classic);
      _themes.put("Flat", flat);
      _themes.put("Monochrome", monochrome);
      _themes.put("Pastel", pastel);
      _themes.put("Neon", neon);
      _themes.put("Summer Fruit", summerFruit);
      _themes.put("Cote d'Azur", coteDAzur);

      _currentTheme = "Classic";
  }

  public static HashMap<String, Theme> getThemes() {
      return _themes;
  }

  public static Theme getCurrentTheme() {
      return _themes.get(_currentTheme);
  }

  public static String getCurrentThemeName() {
      return _currentTheme;
  }

  public static void setTheme(String theme) {
      _currentTheme = theme;
  }

  public static class Hemesh {
    public static class Values {
      public static int Default = 100;
      public static int Min = 1;
      public static int Max = 500;
    }
  }

  public static class CP5 {
    public static int Grid = 20;

    public static class Controls {
      public static int Margin = 4;
      public static int Width = 200;
      public static int Height = 16;
    }
  }
}
