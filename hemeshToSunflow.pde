
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


// http://sfwiki.geneome.net/index.php5?title=Shaders
// http://sourceforge.net/p/sunflow/code/HEAD/tree/trunk/src/org/sunflow/core/shader/
void sunflowShaders(SunflowAPIAPI sunflow, int shaderNum) {
  println(shaderNum);
  switch(shaderNum) {
    case 301: sunflow.setShinyDiffuseShader("myShader", new Color(shapecolor)/*Color diffuse*/, param0 /*float shiny = refl 0f_1f (0.25f)*/);break; //OK
    case 302: sunflow.setGlassShader("myShader",new Color(shapecolor),param0 /*float eta = index of refraction 0f_5f (1.5f)*/,param1/*float absorptionDistance 0f_10f (5.0f)*/,new Color(255,255,255)/*Color absorptionColor*/); break;
    case 303: sunflow.setDiffuseShader("myShader", new Color(shapecolor));break; //OK
    case 304: sunflow.setMirrorShader("myShader", new Color(shapecolor));break; // TODO : default color Shape color, White or lightsColor ?
    case 305: sunflow.setPhongShader("myShader", new Color(shapecolor)/*Color diffuse*/, new Color(lightsColor)/* Color specular*/,param0 /*float power 0f 500f (50f)*/,samples);break; //TODO : specular default White or lightsColor
    case 306: sunflow.setConstantShader("myShader", new Color(shapecolor)/*Color color*/);break; //OK
    case 307: sunflow.setWardShader("myShader", new Color(shapecolor)/*Color diffuse*/, new Color(lightsColor)/* Color specular*/,param0 /*float roughnessX 0f_1f (1.0f)*/, param1 /*float roughnessY 0f_1f (1.0f)*/, samples);break;  //TODO : specular default White or lightsColor
    case 308: sunflow.setWireframeShader("myShader",new Color(shapecolor)/*Color lineColor*/, new Color(lightsColor) /*Color fillColor*/, param0/*float width 0f_1f (1.0f) */); break; //TODO fillColor which one to pick ?
   default: break;
  }

}
