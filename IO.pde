static class FileExtensions {
    static String getExtension(File file) {
      return getExtension(file.getName());
    }

    static String getExtensionLowerCase(File file) {
      return getExtensionLowerCase(file.getName());
    }

    static String getExtension(String file) {
      int idx = file.lastIndexOf('.');

      if (idx > 0) {
        return file.substring(idx+1);
      }

      return null;
    }

    static String getExtensionLowerCase(String file) {
      String extension = getExtension(file);
      if (extension != null) {
        return extension.toLowerCase();
      }
      return extension;
    }
}
