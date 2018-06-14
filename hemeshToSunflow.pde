
import java.awt.Color;

float [] verticesHemeshOneDim;
int [] facesHemeshOneDim;
int samples;

// convert hemeshShape into sunflow-ready arrays
void hemeshToSunflow() {

  // for accurate rendering the rotatation is processed into the shape (temporarily)
  mesh.rotateAboutAxis(radians(rotationY), 0,0,0, 0,1,0); // Rotation around Y axis
  mesh.rotateAboutAxis(radians(rotationX), 0,0,0, 1,0,0); // Rotation around X axis

  mesh.validate();
  mesh.triangulate();

  float [][] verticesHemesh = mesh.getVerticesAsFloat();
  verticesHemeshOneDim = new float[verticesHemesh.length * 3];

  int [][] facesHemesh = mesh.getFacesAsInt();
  facesHemeshOneDim = new int[facesHemesh.length * 3];

  int hemeshCounter = 0;

  for (int y=0; y<verticesHemesh.length; y++) {
    for (int x=0; x<3; x++) {
      // for accurate rendering of the x & y position the translate values are processed into the sunflow coordinates
      if      (x==0) { verticesHemeshOneDim[hemeshCounter] =  verticesHemesh[y][x] + (translateX-width/2) / actualZoom; }
      else if (x==1) { verticesHemeshOneDim[hemeshCounter] = -verticesHemesh[y][x] - (translateY-height/2) / actualZoom; }
      else           { verticesHemeshOneDim[hemeshCounter] =  verticesHemesh[y][x]; }
      hemeshCounter++;
    }
  }

  hemeshCounter = 0;

  for (int y=0; y<facesHemesh.length; y++) {
    for (int x=0; x<3; x++) {
      facesHemeshOneDim[hemeshCounter] = facesHemesh[y][x];
      hemeshCounter++;
    }
  }
}




// render shape in sunflow
void sunflow() {
  ThreadRenderer renderer = new ThreadRenderer();
  renderer.start();
  renderers.add(renderer);
}


void sunflowLights(SunflowAPIAPI sunflow) {

  if (sunflowWhiteBackgroundOn) sunflow.setBackground(255,255,255);
  else if (sunflowBlackBackgroundOn) sunflow.setBackground(0,0,0);

  if (sunSkyLightOn) sunflow.setSunSkyLight("mySunSkyLight", new Vector3(0,1,0), new Vector3(1,0,0), new Vector3(-0.15, 0.2, -0.2), new Color(lightsColor), samples, 1.2, true);

  if (dirLightTopOn) sunflow.setDirectionalLight("myDirectionalLight1", new Point3(0, 31.5, 0), new Vector3 (0, -1, 0), dirLightRadius, new Color(lightsColor)); //OK directional light targeting center
  if (dirLightRightOn) sunflow.setDirectionalLight("myDirectionalLight2", new Point3(31.5, 0, 0), new Vector3 (-1, 0, 0), dirLightRadius, new Color(lightsColor)); //OK directional light targeting center
  if (dirLightFrontOn) sunflow.setDirectionalLight("myDirectionalLight3", new Point3(0, 0, 31.5), new Vector3 (0, 0,-1), dirLightRadius, new Color(lightsColor)); //OK directional light targeting center
  if (dirLightBottomOn) sunflow.setDirectionalLight("myDirectionalLight4", new Point3(0, -31.5, 0), new Vector3 (0, 1, 0), dirLightRadius, new Color(lightsColor)); //OK directional light targeting center
  if (dirLightLeftOn) sunflow.setDirectionalLight("myDirectionalLight5", new Point3(-31.5, 0, 0), new Vector3 (1, 0, 0), dirLightRadius, new Color(lightsColor)); //OK directional light targeting center
  if (dirLightBehindOn) sunflow.setDirectionalLight("myDirectionalLight6", new Point3(0, 0, -31.5), new Vector3 (0, 0, 1), dirLightRadius, new Color(lightsColor)); //OK directional light targeting center

  if (sphereLightTopOn) sunflow.setSphereLight("mySphereLight1",  new Point3(0,15,0),new Color(lightsColor), samples,sphereLightRadius); //OK
  if (sphereLightRightOn) sunflow.setSphereLight("mySphereLight2",  new Point3(15,0,0),new Color(lightsColor), samples,sphereLightRadius); //OK
  if (sphereLightFrontOn) sunflow.setSphereLight("mySphereLight3",  new Point3(0,0,15),new Color(lightsColor), samples,sphereLightRadius); //OK
  if (sphereLightBottomOn) sunflow.setSphereLight("mySphereLight4",  new Point3(0,-15,0),new Color(lightsColor), samples,sphereLightRadius); //OK
  if (sphereLightLeftOn) sunflow.setSphereLight("mySphereLight5",  new Point3(-15,0,0),new Color(lightsColor), samples,sphereLightRadius); //OK
  if (sphereLightBehindOn) sunflow.setSphereLight("mySphereLight6",  new Point3(0,0,-15),new Color(lightsColor), samples,sphereLightRadius); //OK
}
