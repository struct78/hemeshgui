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

    static String getFolder(String file) {
      int slash = file.lastIndexOf("/");
      return slash != -1 ? file.substring(0, slash) : file;
    }

    static String getFolder(File file) {
      return getFolder(file.getAbsolutePath());
    }

    static String getFileName(String file) {
      int slash = file.lastIndexOf("/");
      return slash != -1 ? file.substring(slash) : file;
    }

    static String getFileName(File file) {
      return file.getName();
    }

    static String getFileNameWithoutExtension(File file) {
      return getFileNameWithoutExtension(file.getName());
    }

    static String getFileNameWithoutExtension(String file) {
      int dot = file.lastIndexOf(".");
      return dot != -1 ? getFileName(file).substring(0, dot) : file;
    }
}
