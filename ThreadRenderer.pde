class ThreadRenderer implements Runnable {
    Thread thread;

    ThreadRenderer() {

    }

    public void start () {
        println("Starting thread");
        if (thread == null) {
            thread = new Thread (this);
            thread.start();
        }
    }

    public void run() {
      SunflowAPIAPI sunflow = new SunflowAPIAPI();
      sunflow.setWidth(int(sceneWidth*sunflowMultiply));
      sunflow.setHeight(int(sceneHeight*sunflowMultiply));

      if (preview) {
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

      sunflow.setThinlensCamera("thinLensCamera", 50f, (float)sceneWidth/sceneHeight);
      sunflow.setCameraPosition(0, 0, 30);
      sunflow.setCameraTarget(0, 0, 0);

      selectedShader.create(sunflow);

      sunflow.drawMesh("myHemesh", verticesHemeshOneDim, facesHemeshOneDim, actualZoom/20, 0,0,0);

      String path = "/output/screenshots/";
      if (saveContinuous) path = "/output/sequence/" + timestamp + "/";

      if (saveContinuous) {
        if (saveMask) {
          sunflow.render(sketchPath() + path + "Mask_" + nf(frameCount,4) + ".png");
        }
        if (saveSunflow) {
          sunflowLights(sunflow);
          sunflow.setAmbientOcclusionEngine(new Color(255), new Color(0), samples, 7.5);
          sunflow.render(sketchPath() + path + "Sunflow_" + nf(frameCount,4) + ".png");
        }
      } else {
        if (saveMask) {
          sunflow.render(sketchPath() + path + timestamp + " (sunflowMask).png");
        }
        if (saveSunflow) {
          sunflowLights(sunflow);
          sunflow.setAmbientOcclusionEngine(new Color(255), new Color(0), samples, 7.5);
          sunflow.render(sketchPath() + path + timestamp + " (sunflow).png");
        }
      }

      createHemesh(); // to reset the shape's rotation (which was internalised into the shape temporarily for sunflow rendering)
    }
}
