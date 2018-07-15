class ThreadRenderer implements Runnable {
    Thread thread;

    ThreadRenderer() {

    }

    public void start () {
        if (thread == null) {
            thread = new Thread (this);
            thread.start();
        }
    }

    public void run() {
      SunflowAPIAPI sunflow = new SunflowAPIAPI();
      sunflow.setWidth(int(sceneWidth * sunflowMultiply));
      sunflow.setHeight(int(sceneHeight * sunflowMultiply));

      if (savePreview) {
        sunflow.setAaMin(-2);
        sunflow.setAaMax(0);
        samples = 16;
      } else {
        if (saveContinuous) {
          sunflow.setAaMin(0);
          sunflow.setAaMax(2);
          samples = 16;
        } else {
          sunflow.setAaMin(1);
          sunflow.setAaMax(2);
          samples = 24;
        }
      }

      sunflow.setThinlensCamera("thinLensCamera", 40f, (float)sceneWidth/sceneHeight);
      sunflow.setCameraPosition(0, 0, (sceneHeight/2.0) / tan(PI*30.0 / 180.0));

      selectedShader.create(sunflow);

      sunflow.drawPlane("plane", new Point3(0, -sceneHeight/3, 0), new Vector3(0,1,0));
      sunflow.drawMesh("hemesh", verticesHemeshOneDim, facesHemeshOneDim, actualZoom, radians(-rotationX), radians(rotationY), radians(rotationZ));

      String path = "/renders/screenshots/";
      if (saveContinuous) path = "/renders/sequence/" + timestamp + "/";

      if (saveContinuous) {
        if (saveMask) {
          sunflow.render(sketchPath() + path + "mask-" + nf(frameCount,4) + ".png");
        }
        if (saveSunflow) {
          sunflowLights(sunflow);
          sunflow.setAmbientOcclusionEngine(new Color(255), new Color(0), samples, 7.5);
          sunflow.render(sketchPath() + path + "sunflow-" + nf(frameCount,4) + ".png");
        }
      } else {
        if (saveMask) {
          sunflow.render(sketchPath() + path + timestamp + "-sunflow-mask.png");
        }
        if (saveSunflow) {
          sunflowLights(sunflow);
          sunflow.setAmbientOcclusionEngine(new Color(255), new Color(0), samples, 7.5);
          sunflow.render(sketchPath() + path + timestamp + "-sunflow.png");
        }
      }
    }
}
