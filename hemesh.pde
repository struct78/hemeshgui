

HE_Mesh myShape;
HEM_Extrude extrude1 = new HEM_Extrude();
HEM_Extrude extrude2 = new HEM_Extrude();
WB_Render render;

// create shape and run modifiers
void createHemesh() {
  hemeshCreate(creator, create0, create1, create2, create3);

  for (int i=0; i<modifiers.size(); i++) {
    Modifier m = (Modifier) modifiers.get(i);
    m.index = i;
    m.newMenu();
    m.hemesh();
  }
}

// display shape
void drawHemesh() {
  colorMode(HSB,360,100,100,100);
  shapecolor = color(shapeHue, shapeSaturation, shapeBrightness, shapeTransparency);
  colorMode(RGB,255,255,255,255);
  if (facesOn) {
    noStroke();
    fill(shapecolor);
    render.drawFaces(myShape);
  }
  if (edgesOn) {
    strokeWeight(1);
    stroke(0);
    render.drawEdges(myShape);
  }

  if (creator == 14) {
    if (triangles != null) {
      for (int i = 0; i < triangles.length; i += 3) {
        pushMatrix();
        render.drawTriangle(points[triangles[i]], points[triangles[i+1]], points[triangles[i+2]]);
        popMatrix();
      }
    }
  }
}

// names of shapes & modifiers & shaders
String numToName(int num) {
  String name = null;

  switch(num) {

    // shapes
    case 0: name = "Box"; break;
    case 1: name = "Cone"; break;
    case 2: name = "Dodecahedron"; break;
    case 3: name = "Geodesic"; break;
    case 4: name = "Sphere"; break;
    case 5: name = "Cylinder"; break;
    case 6: name = "Icosahedron"; break;
    case 7: name = "Octahedron"; break;
    case 8: name = "Tetrahedron"; break;
    case 9: name = "Torus"; break;
    case 10: name = "Grid"; break;
    case 11: name = "ConvexHull"; break;
    case 12: name = "Beethoven"; break;
    case 13: name = "Super Duper"; break;
    case 14: name = "Alpha"; break;
    case 15: name = "Archimedes"; break;

    // modifiers
    case 101: name = "ChamferCorners"; break;
    case 102: name = "Extrude"; break;
    case 103: name = "Extrude-Extruded"; break;
    case 104: name = "Chamfer"; break;
    case 105: name = "Extrude-Chamfered"; break;
    case 106: name = "Lattice"; break;
    case 107: name = "Skew"; break;
    case 108: name = "Stretch"; break;
    case 109: name = "Twist (X)"; break;
    case 110: name = "Twist (Y)"; break;
    case 111: name = "Bend"; break;
    case 112: name = "VertexExpand"; break;
    case 113: name = "ChamferEdges"; break;
    case 114: name = "Slice (Capped)"; break;
    case 115: name = "Slice (Open)"; break;
    case 116: name = "Mirror"; break;
    case 117: name = "Kaleidoscope"; break;

    // subdividors
    case 201: name = "Planar"; break;
    case 202: name = "Planar-Random"; break;
    case 203: name = "PlanarMidEdge"; break;
    case 204: name = "CatmullClark"; break;
    case 205: name = "Smooth"; break;

    // sunflow shaders
    case 301: name = "ShinyDiffuse"; break;
    case 302: name = "Glass"; break;
    case 303: name = "Diffuse"; break;
    case 304: name = "Mirror"; break;
    case 305: name = "Phong"; break;
    case 306: name = "Constant"; break;
    case 307: name = "Anisotropic Ward"; break;
    case 308: name = "Wireframe"; break;



    // default
    default: name = "None"; break;

    // other
    case -1: name = "================="; break;
  }

  return name;
}

// default values per modifier
float[] numToFloats(int num) {
  float[] floatArray = new float[5];

  floatArray[3] = random(10);  // randomSeed for selection
  floatArray[4] = 50;          // default selection percentage

  switch(num) {
    // modifiers
    case 101: floatArray[0] = 0.5; floatArray[1] = 1;   floatArray[2] = 1; break;                      // ChamferCorners
    case 102: floatArray[0] = 1;   floatArray[1] = 1;   floatArray[2] = 1; break;                      // Extrude
    case 103: floatArray[0] = 1;   floatArray[1] = 1;   floatArray[2] = 1; break;                      // Extrude-Extruded
    case 104: floatArray[0] = 0.5; floatArray[1] = 0;   floatArray[2] = 0; break;                      // Chamfer
    case 105: floatArray[0] = 1;   floatArray[1] = 1;   floatArray[2] = 1; break;                      // Extrude-Chamfered
    case 106: floatArray[0] = 0.3; floatArray[1] = 0.3; floatArray[2] = 0; floatArray[4] = 100; break; // Lattice
    case 107: floatArray[0] = 1;   floatArray[1] = 0;   floatArray[2] = 0; break;                      // Skew
    case 108: floatArray[0] = 1;   floatArray[1] = 1;   floatArray[2] = 0; break;                      // Stretch
    case 109: floatArray[0] = 1;   floatArray[1] = 1;   floatArray[2] = 1; floatArray[4] = 100; break; // Twist (X)
    case 110: floatArray[0] = 1;   floatArray[1] = 1;   floatArray[2] = 1; floatArray[4] = 100; break; // Twist (Y)
    case 111: floatArray[0] = 1;   floatArray[1] = 1;   floatArray[2] = 1; floatArray[4] = 100; break; // Bend
    case 112: floatArray[0] = 1;   floatArray[1] = 1;   floatArray[2] = 1; break;                      // VertexExpand
    case 113: floatArray[0] = 0.5; floatArray[1] = 1;   floatArray[2] = 1; break;                      // ChamferEdges
    case 114: floatArray[0] = 0.5; floatArray[1] = 0.5; floatArray[2] = 0; break;                      // Slice (Capped)
    case 115: floatArray[0] = 0.5; floatArray[1] = 0.5; floatArray[2] = 0; break;                      // Slice (Open)
    case 116: floatArray[0] = 0;   floatArray[1] = 1;   floatArray[2] = 0; break;                      // Mirror
    case 117: floatArray[0] = 5;   floatArray[1] = 0.5; floatArray[2] = 0; break;                      // Kaleidoscope

    // subdividors
    case 201: floatArray[0] = 1; floatArray[1] = 0;   floatArray[2] = 0; break;                        // Planar
    case 202: floatArray[0] = 1; floatArray[1] = 0;   floatArray[2] = 0; break;                        // Planar-Random
    case 203: floatArray[0] = 1; floatArray[1] = 0;   floatArray[2] = 0; break;                        // PlanarMidEdge
    case 204: floatArray[0] = 1; floatArray[1] = 0;   floatArray[2] = 0; floatArray[4] = 100; break;   // CatmullClark
    case 205: floatArray[0] = 1; floatArray[1] = 0.5; floatArray[2] = 0.5; break;                      // Smooth
  }

  return floatArray;
}

void hemeshCreate(int select, float value1, float value2, float value3, float value4) {
  switch(select) {

    // =====================================================================================//
    // cases 000-100 = hemesh.creators

    case 0: myShape = new HE_Mesh(new HEC_Box().setDepth(value1).setHeight(value2).setWidth(value3)); break;
    case 1: myShape = new HE_Mesh(new HEC_Cone().setRadius(value1).setHeight(value2).setFacets(int(value3)).setSteps(int(value4))); break;
    case 2: myShape = new HE_Mesh(new HEC_Dodecahedron().setEdge(value1)); break;
    case 3: myShape = new HE_Mesh(new HEC_Geodesic().setRadius(value1).setB(int(value2)).setC(int(value3))); break;
    case 4: myShape = new HE_Mesh(new HEC_Sphere().setRadius(value1).setUFacets(int(value2)).setVFacets(int(value3))); break;
    case 5: myShape = new HE_Mesh(new HEC_Cylinder().setRadius(value1).setHeight(value2).setFacets(int(value3)).setSteps(int(value4))); break;
    case 6: myShape = new HE_Mesh(new HEC_Icosahedron().setEdge(value1)); break;
    case 7: myShape = new HE_Mesh(new HEC_Octahedron().setEdge(value1)); break;
    case 8: myShape = new HE_Mesh(new HEC_Tetrahedron().setEdge(value1)); break;
    case 9: myShape = new HE_Mesh(new HEC_Torus().setRadius(value1,value2).setTubeFacets(int(value3)).setTorusFacets(int(value4)));break;
    case 10:
            float[][] values=new float[11][11];
            for (int j = 0; j < 11; j++)
               for (int i = 0; i < 11; i++) values[i][j]=value3*noise(0.35*i, 0.35*j);
            myShape = new HE_Mesh(new HEC_Grid().setU(10).setUSize(value1).setV(10).setVSize(value2).setWValues(values));break;
    case 11:
            float[][] randomPoints =new float[int(value1)*10000][3];
            for (int i=0;i<int(value1)*10000;i++) {
              randomPoints[i][0]=random(-value2/2, value2/2);
              randomPoints[i][1]=random(-value3/2, value3/2);
              randomPoints[i][2]=random(-value4/2, value4/2);
            }
            myShape = new HE_Mesh(new HEC_ConvexHull().setN(int(value1)).setPoints(randomPoints));
            break;
    case 12: myShape = new HE_Mesh(new HEC_Beethoven()); break;
    case 13: myShape = new HE_Mesh(new HEC_SuperDuper().setGeneralParameters(0, 11, 0, 0,13, 10, 15, 10, 4, 0, 0, 0, 5, 0.3, 2.2).setU(int(value2 * 10)).setV(int(value3 * 5)).setUWrap(true).setVWrap(false).setRadius(int(value1))); break;
    case 14:
      WB_RandomOnSphere source = new WB_RandomOnSphere();
      int numPoints = int(value2) * 10;
      points = new WB_Point[numPoints];

      for (int i=0; i < numPoints; i++) {
        points[i] = source.nextPoint().mulSelf(value1);
      }

      WB_AlphaTriangulation3D triangulation = WB_Triangulate.alphaTriangulate3D(points);
      int[] tetrahedra = triangulation.getAlphaTetrahedra(value3 * 5);// 1D array of indices of tetrahedra, 4 indices per tetrahedron

      triangles = triangulation.getAlphaTriangles(value3 * 5);

      myShape = new HE_Mesh(new HEC_AlphaShape().setTriangulation(triangulation).setAlpha(value3 * 10));

      break;
    case 15:
      myShape = new HE_Mesh(new HEC_Archimedes().setEdge(value1).setType(int(value2)));
      break;
  }
}

void hemeshModify(float select, float value1, float value2, float value3, float value4, float value5) {
  HE_Selection selection = new HE_Selection(myShape);
  Iterator <HE_Face> fItr = myShape.fItr();
  HE_Face f;
  randomSeed(int(value4));
  while (fItr.hasNext()) { f = fItr.next(); if (random(100) < value5) { selection.add(f); } }

  switch(int(select)) {

    // =====================================================================================//
    // cases 101-200 = hemesh.modifiers

    case 101:
      myShape.modify(new HEM_ChamferCorners().setDistance(value1*value2*value3));
    break;

    case 102:
      extrude1.setDistance(value1).setChamfer(value2).setHardEdgeChamfer(value3);
      myShape.modify(extrude1);
    break;

    case 103:
      extrude1.setDistance(value1*value2*value3);
      myShape.modify(extrude1);
    break;

    case 104:
      extrude2.setDistance(0).setChamfer(value1);
      myShape.modify(extrude2);
    break;

    case 105:
      extrude2.setDistance(value1*value2*value3).setChamfer(0);
      myShape.modify(extrude2);
    break;

    case 106:
      myShape.modify(new HEM_Lattice().setDepth(value1).setWidth(value2).setThresholdAngle(radians(value3*45)).setFuse(true));
    break;

    case 107:
     myShape.modify(new HEM_Skew().setSkewFactor(value1).setGroundPlane(new WB_Plane(new WB_Point(0,0,0), new WB_Vector(0,1,0))).setSkewDirection(new WB_Point(0,1,0)));
    break;

    case 108:
      myShape.modify(new HEM_Stretch().setStretchFactor(value1).setCompressionFactor(value2).setGroundPlane(new WB_Plane(new WB_Point(0,0,0), new WB_Vector(0,1,0))));
    break;

    case 109:
      myShape.modify(new HEM_Twist().setAngleFactor(value1*value2*value3).setTwistAxis(new WB_Line(new WB_Point(0,0,0), new WB_Vector(1,0,0))));
    break;

    case 110:
      myShape.modify(new HEM_Twist().setAngleFactor(value1*value2*value3).setTwistAxis(new WB_Line(new WB_Point(0,0,0), new WB_Vector(0,1,0))));
    break;

    case 111:
      myShape.modify(new HEM_Bend().setAngleFactor(value1*value2*value3).setGroundPlane(new WB_Plane(new WB_Point(0,0,0), new WB_Vector(0,1,0))).setBendAxis(new WB_Line(new WB_Point(0,0,0), new WB_Vector(0,1,0))));
    break;

    case 112:
      myShape.modify(new HEM_VertexExpand().setDistance(value1*value2*value3));
    break;

    case 113:
      myShape.modify(new HEM_ChamferEdges().setDistance(value1*value2*value3));
    break;

    case 114:
      myShape.modify(new HEM_Slice().setCap(true).setPlane(new WB_Plane(new WB_Point(0,0,-value1), new WB_Vector(value3,0,1))));
      myShape.modify(new HEM_Slice().setCap(true).setPlane(new WB_Plane(new WB_Point(0,0,value2), new WB_Vector(value3,0,-1))));
    break;

    case 115:
      myShape.modify(new HEM_Slice().setCap(false).setPlane(new WB_Plane(new WB_Point(0,0,-value1), new WB_Vector(value3,0,1))));
      myShape.modify(new HEM_Slice().setCap(false).setPlane(new WB_Plane(new WB_Point(0,0,value2), new WB_Vector(value3,0,-1))));
    break;

    case 116:
      myShape.modify(new HEM_Mirror().setPlane(new WB_Plane(0, 0, 0, 0, 1, 1)).setOffset(int(value1)).setReverse(false));
    break;

    case 117:
      myShape.modify(new HEM_Kaleidoscope().setSymmetry(int(value1)).setAngle(int(value2)).setOrigin(new WB_Point(0, 0, 0)).setAxis(new WB_Vector(0, 1, 0)).setAngle(int(value3)));

    // =====================================================================================//
    // cases 201-300 = hemesh.subdividors

    case 201:
      myShape.subdivide(new HES_Planar().setRandom(false),int(value1));
    break;

    case 202:
      myShape.subdivide(new HES_Planar().setRandom(true),int(value1));
    break;

    case 203:
      myShape.subdivide(new HES_PlanarMidEdge(),int(value1));
    break;

    case 204:
      myShape.subdivide(new HES_CatmullClark(),int(value1));
    break;

    case 205:
      myShape.subdivide(new HES_Smooth().setWeight(value2,value3),int(value1));
    break;

    // =====================================================================================//
    // default (all other cases)

    default:
      println("No Action Selected");
    break;
  }
}
