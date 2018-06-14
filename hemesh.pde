
HE_MeshCollection meshes;
HE_Mesh mesh;
boolean isMeshCollection = false;
HEM_Extrude extrude1 = new HEM_Extrude();
HEM_Extrude extrude2 = new HEM_Extrude();
WB_Render render;

void updateShapeColors() {
  colorMode(HSB, 360, 100, 100, 100);
  shapeHue = hue(currentTheme.Faces);
  shapeSaturation = saturation(currentTheme.Faces);
  shapeBrightness = brightness(currentTheme.Faces);
  shapeTransparency = alpha(currentTheme.Faces);
  colorMode(RGB, 255, 255, 255, 255);
}

// create shape collection
void createShapes() {
  // Box
  shapes.add(
    new Shape("Box", 3)
      .setDefaultValues(new float[] { 200, 200, 200 })
      .setLabels(new String[] { "Depth", "Width", "Height" })
      .setCreator(new ShapeCreator() {
          public void create(float[] values) {
               mesh = new HE_Mesh(
                   new HEC_Box()
                      .setDepth(values[0])
                      .setHeight(values[1])
                      .setWidth(values[2])
                 );
             }
         })
     );

   shapes.add(
     new Shape("Cone", 4)
       .setMaxValues(new float[] { 500, 500, 500, 10 })
       .setDefaultValues(new float[] { 75, 150, 25, 1 })
       .setLabels(new String[] { "Radius", "Height", "Facets", "Steps" })
       .setCreator(new ShapeCreator() {
           public void create(float[] values) {
               mesh = new HE_Mesh(
                 new HEC_Cone()
                    .setRadius(values[0])
                    .setHeight(values[1])
                    .setFacets(int(values[2]))
                    .setSteps(int(values[3]))
               );
           }
       })
   );

   shapes.add(
     new Shape("Dodecahedron", 1)
        .setLabels(new String[] { "Edge" })
        .setCreator(new ShapeCreator() {
            public void create(float[] values) {
               mesh = new HE_Mesh(
                 new HEC_Dodecahedron()
                    .setEdge(values[0])
               );
           }
       })
   );

   shapes.add(
     new Shape("Geodesic", 3)
       .setMaxValues(new float[] { Config.Hemesh.Values.Max, 10, 10 })
       .setDefaultValues(new float[] { Config.Hemesh.Values.Default, 1, 1 })
       .setLabels(new String[] { "Radius", "B", "C" })
       .setCreator(new ShapeCreator() {
           public void create(float[] values) {
              mesh = new HE_Mesh(
                  new HEC_Geodesic()
                      .setRadius(values[0])
                      .setB(int(values[1]))
                      .setC(int(values[2]))
              );
          }
      })
   );

   shapes.add(
     new Shape("Sphere", 3)
       .setMaxValues(new float[] { Config.Hemesh.Values.Max, 150, 150 })
       .setDefaultValues(new float[] { 100, 300, 20 })
       .setLabels(new String[] { "Radius", "UFacets", "VFacets" })
       .setCreator(new ShapeCreator() {
           public void create(float[] values) {
              mesh = new HE_Mesh(
                  new HEC_Sphere()
                      .setRadius(values[0])
                      .setUFacets(int(values[1]))
                      .setVFacets(int(values[2]))
              );
          }
       })
   );

   shapes.add(
     new Shape("Cylinder", 4)
        .setDefaultValues(new float[] { 100, 300, 20, 2 })
        .setLabels(new String[] { "Radius", "Height", "Facets", "Steps" })
        .setCreator(new ShapeCreator() {
            public void create(float[] values) {
               mesh = new HE_Mesh(
                   new HEC_Cylinder()
                      .setRadius(values[0])
                      .setHeight(values[1])
                      .setFacets(int(values[2]))
                      .setSteps(int(values[3]))
               );
           }
        })
   );

   shapes.add(
      new Shape("Icosahedron", 1)
        .setLabels(new String[] { "Edge" })
        .setCreator(new ShapeCreator() {
            public void create(float[] values) {
               mesh = new HE_Mesh(
                   new HEC_Icosahedron()
                      .setEdge(values[0])
               );
           }
        })
   );

   shapes.add(
      new Shape("Octahedron", 1)
        .setLabels(new String[] { "Edge" })
        .setCreator(new ShapeCreator() {
            public void create(float[] values) {
               mesh = new HE_Mesh(
                   new HEC_Octahedron()
                      .setEdge(values[0])
               );
           }
        })
   );

   shapes.add(
      new Shape("Tetrahedron", 1)
        .setLabels(new String[] { "Edge" })
        .setCreator(new ShapeCreator() {
            public void create(float[] values) {
               mesh = new HE_Mesh(
                   new HEC_Tetrahedron()
                      .setEdge(values[0])
               );
           }
        })
   );

   shapes.add(
      new Shape("Torus", 4)
        .setDefaultValues(new float[] { 100, 100, 20, 20 })
        .setLabels(new String[] { "Ex. Radius", "Int. Radius", "Tube Facets", "Torus Facets" })
        .setCreator(new ShapeCreator() {
            public void create(float[] values) {
               mesh = new HE_Mesh(
                   new HEC_Torus()
                      .setRadius(values[0], values[1])
                      .setTubeFacets(int(values[2]))
                      .setTorusFacets(int(values[3]))
               );
           }
        })
   );


   shapes.add(
      new Shape("Grid", 4)
        .setDefaultValues(new float[] { 400, 400, 128, 10 })
        .setLabels(new String[] { "Width", "Height", "Disturb", "Facets" })
        .setCreator(new ShapeCreator() {
            public void create(float[] values) {
                float[][] wvalues = new float[int(values[3])][int(values[3])];
                for (int j = 0; j < int(values[3]); j++) {
                   for (int i = 0; i < int(values[3]); i++) {
                     wvalues[i][j] = values[2] * noise(0.35*i, 0.35*j);
                   }
                }

                mesh = new HE_Mesh(
                    new HEC_Grid()
                        .setU(int(values[3])-1)
                        .setUSize(values[0])
                        .setV(int(values[3])-1)
                        .setVSize(values[1])
                        .setWValues(wvalues));
            }
        })
   );

   shapes.add(
      new Shape("Convex Hull", 4)
        .setLabels(new String[] { "Points x 1000", "Width", "Height", "Depth" })
        .setCreator(new ShapeCreator() {
            public void create(float[] values) {
                float[][] randomPoints = new float[int(values[0])*1000][3];
                for (int i = 0; i < int(values[0])*1000; i++) {
                  randomPoints[i][0] = random(-values[1]/2, values[1]/2);
                  randomPoints[i][1] = random(-values[2]/2, values[2]/2);
                  randomPoints[i][2] = random(-values[3]/2, values[3]/2);
                }

                mesh = new HE_Mesh(
                    new HEC_ConvexHull()
                        .setN(int(values[0]))
                        .setPoints(randomPoints)
                );
            }
        })
   );

   shapes.add(
      new Shape("Beethoven", 1)
        .setLabels(new String[] { "Scale" })
        .setDefaultValues(new float[] { 5 })
        .setMaxValues(new float[] { 10 })
        .setCreator(new ShapeCreator() {
            public void create(float[] values) {
                mesh = new HE_Mesh(
                    new HEC_Beethoven()
                        .setScale(int(values[0]))
                        .setZAxis(0, -90, 0)
                );
            }
        })
   );

   shapes.add(
      new Shape("Super Duper", 3)
        .setLabels(new String[] { "Radius", "UFacets", "VFacets" })
        .setCreator(new ShapeCreator() {
            public void create(float[] values) {
                mesh = new HE_Mesh(
                    new HEC_SuperDuper()
                        .setGeneralParameters(0, 11, 0, 0, 13, 10, 15, 10, 4, 0, 0, 0, 5, 0.3, 2.2)
                        .setU(int(values[1]))
                        .setV(int(values[2]))
                        .setUWrap(true)
                        .setVWrap(false)
                        .setRadius(int(values[0]))
                );
            }
        })
   );

   shapes.add(
      new Shape("Alpha", 3)
        .setLabels(new String[] { "Scale", "Points", "Triangles" })
        .setCreator(new ShapeCreator() {
            public void create(float[] values) {
                WB_RandomOnSphere source = new WB_RandomOnSphere();
                int numPoints = int(values[1]);
                points = new WB_Point[numPoints];

                for (int i=0; i < numPoints; i++) {
                  points[i] = source.nextPoint().mulSelf(values[0]);
                }

                WB_AlphaTriangulation3D triangulation = WB_Triangulate.alphaTriangulate3D(points);
                int[] tetrahedra = triangulation.getAlphaTetrahedra(values[2]);// 1D array of indices of tetrahedra, 4 indices per tetrahedron

                triangles = triangulation.getAlphaTriangles(values[2]);

                mesh = new HE_Mesh(
                    new HEC_AlphaShape()
                        .setTriangulation(triangulation)
                        .setAlpha(values[2])
                );
            }
        })
   );

   shapes.add(
      new Shape("Archimedes", 2)
        .setLabels(new String[] { "Edge", "Type" })
        .setCreator(new ShapeCreator() {
            public void create(float[] values) {
                mesh = new HE_Mesh(
                    new HEC_Archimedes()
                        .setEdge(values[0])
                        .setType(int(values[1]))
                );
            }
        })
   );

   shapes.add(
      new Shape("Voronoi Cells", 3)
        .setMeshCollection(true)
        .setMaxValues(new float[] { 400, 500, 20 })
        .setDefaultValues(new float[] { 200, 100, 5 })
        .setLabels(new String[] { "Radius", "Points", "Offset" })
        .setCreator(new ShapeCreator() {
            public void create(float[] values) {
                mesh = new HE_Mesh(
                    new HEC_Geodesic()
                        .setRadius(values[0])
                );

                float[][] points = new float[int(values[1])][3];
                for (int i = 0; i < int(values[1]); i++) {
                    points[i][0] = random(-int(values[0]), int(values[0]));
                    points[i][1] = random(-int(values[0]), int(values[0]));
                    points[i][2] = random(-int(values[0]), int(values[0]));
                }

                HEMC_VoronoiCells multiCreator = new HEMC_VoronoiCells();
                multiCreator.setPoints(points);
                multiCreator.setContainer(mesh);
                multiCreator.setOffset(int(values[2]));
                multiCreator.setSurface(false);
                meshes = multiCreator.create();
            }
        })
   );

   shapes.add(
      new Shape("UV Parametric", 2)
        .setMinValues(new float[] { 10, 4 })
        .setMaxValues(new float[] { 500, 200 })
        .setDefaultValues(new float[] { 100, 50 })
        .setLabels(new String[] { "Scale", "Radius" })
        .setCreator(new ShapeCreator() {
            public void create(float[] values) {
                mesh = new HE_Mesh(
                    new HEC_UVParametric()
                        .setUVSteps(int(values[1]), int(values[1]))
                        .setScale(values[0])
                        .setEvaluator(new UVFunction())
                );
            }
        })
   );
}

void createModifiers() {
    modifiers.add(
      new Modifier("Chamfer Corners", 1)
          .setDefaultValues(new float[] { 10 })
          .setMaxValues(new float[] { 100 })
          .setLabels(new String[] { "Distance" })
          .setCreator(new ModifierCreator() {
            public void create(float[] values) {
                mesh.modify(
                    new HEM_ChamferCorners()
                        .setDistance(values[0])
                );
            }
        })
   );


    modifiers.add(
     new Modifier("Basic Extrude", 1)
         .setDefaultValues(new float[] { 50 })
         .setLabels(new String[] { "Distance" })
         .setCreator(new ModifierCreator() {
           public void create(float[] values) {
               extrude1.setDistance(values[0]);
               mesh.modify(extrude1);
           }
       })
    );

    modifiers.add(
        new Modifier("Hard Edge Extrude", 3)
            .setDefaultValues(new float[] { 10, 1, 100 })
            .setMaxValues(new float[] { 100, 1, 500 })
            .setMinValues(new float[] { 0, 0, 0 })
            .setLabels(new String[] { "Distance", "Chamfer", "Hard Edge Chamfer" })
            .setCreator(new ModifierCreator() {
              public void create(float[] values) {
                  extrude1
                     .setDistance(values[0])
                     .setChamfer(values[1])
                     .setHardEdgeChamfer(values[2]);
                  mesh.modify(extrude1);
              }
          })
    );

    modifiers.add(
       new Modifier("Lattice", 3)
           .setDefaultValues(new float[] { 15, 15, 1 })
           .setMaxValues(new float[] { 100, 100, 360 })
           .setLabels(new String[] { "Depth", "Width", "Threshold Angle" })
           .setCreator(new ModifierCreator() {
             public void create(float[] values) {
                 mesh.modify(
                    new HEM_Lattice()
                        .setDepth(values[0])
                        .setWidth(values[1])
                        .setThresholdAngle(radians(values[2]*45))
                        .setFuse(true)
                 );
             }
         })
    );

    modifiers.add(
       new Modifier("Skew", 1)
           .setDefaultValues(new float[] { 1 })
           .setMinValues(new float[] { .05 })
           .setMaxValues(new float[] { 10 })
           .setLabels(new String[] { "Factor" })
           .setCreator(new ModifierCreator() {
             public void create(float[] values) {
                 mesh.modify(
                     new HEM_Skew()
                        .setSkewFactor(values[0])
                        .setGroundPlane(new WB_Plane(new WB_Point(0, 0, 0), new WB_Vector(0, 1, 0)))
                        .setSkewDirection(new WB_Point(0, 1, 0))
                 );
             }
         })
    );

    modifiers.add(
       new Modifier("Stretch", 2)
           .setDefaultValues(new float[] { 1, 1 })
           .setLabels(new String[] { "Factor", "Compression" })
           .setCreator(new ModifierCreator() {
             public void create(float[] values) {
                 mesh.modify(
                     new HEM_Stretch()
                        .setStretchFactor(values[0])
                        .setCompressionFactor(values[1])
                        .setGroundPlane(new WB_Plane(new WB_Point(0, 0, 0), new WB_Vector(0, 1, 0)))
                 );
             }
         })
    );

    modifiers.add(
       new Modifier("Stretch", 2)
           .setDefaultValues(new float[] { 1, 1 })
           .setLabels(new String[] { "Factor", "Compression" })
           .setCreator(new ModifierCreator() {
             public void create(float[] values) {
                 mesh.modify(
                     new HEM_Stretch()
                        .setStretchFactor(values[0])
                        .setCompressionFactor(values[1])
                        .setGroundPlane(new WB_Plane(new WB_Point(0, 0, 0), new WB_Vector(0, 1, 0)))
                 );
             }
         })
    );

    modifiers.add(
       new Modifier("Twist (X)", 1)
           .setDefaultValues(new float[] { 1 })
           .setMinValues(new float[] { 0 })
           .setMaxValues(new float[] { 10 })
           .setLabels(new String[] { "Angle" })
           .setCreator(new ModifierCreator() {
             public void create(float[] values) {
                 mesh.modify(
                     new HEM_Twist()
                        .setAngleFactor(values[0])
                        .setTwistAxis(new WB_Line(new WB_Point(0,0,0), new WB_Vector(1,0,0)))
                 );
             }
         })
    );

    modifiers.add(
       new Modifier("Twist (Y)", 1)
           .setDefaultValues(new float[] { 1 })
           .setMinValues(new float[] { 0 })
           .setMaxValues(new float[] { 10 })
           .setLabels(new String[] { "Angle" })
           .setCreator(new ModifierCreator() {
             public void create(float[] values) {
                 mesh.modify(
                     new HEM_Twist()
                        .setAngleFactor(values[0])
                        .setTwistAxis(new WB_Line(new WB_Point(0,0,0), new WB_Vector(0,1,0)))
                 );
             }
         })
    );

    modifiers.add(
       new Modifier("Twist (Z)", 1)
           .setDefaultValues(new float[] { 1 })
           .setMinValues(new float[] { 0 })
           .setMaxValues(new float[] { 10 })
           .setLabels(new String[] { "Angle" })
           .setCreator(new ModifierCreator() {
             public void create(float[] values) {
                 mesh.modify(
                     new HEM_Twist()
                        .setAngleFactor(values[0])
                        .setTwistAxis(new WB_Line(new WB_Point(0,0,0), new WB_Vector(0,0,1)))
                 );
             }
         })
    );

    modifiers.add(
       new Modifier("Bend", 3)
           .setDefaultValues(new float[] { 1, 1, 1 })
           .setLabels(new String[] { "Angle", "Angle", "Angle" })
           .setCreator(new ModifierCreator() {
             public void create(float[] values) {
                 mesh.modify(
                     new HEM_Bend()
                        .setAngleFactor(values[0] * values[1] * values[2])
                        .setGroundPlane(new WB_Plane(new WB_Point(0, 0, 0), new WB_Vector(0, 1, 0)))
                        .setBendAxis(new WB_Line(new WB_Point(0, 0, 0), new WB_Vector(0, 1, 0)))
                 );
             }
         })
    );


    modifiers.add(
       new Modifier("Vertex Expand", 3)
           .setDefaultValues(new float[] { 1, 1, 1 })
           .setLabels(new String[] { "Distance", "Distance", "Distance" })
           .setCreator(new ModifierCreator() {
             public void create(float[] values) {
                 mesh.modify(
                     new HEM_VertexExpand()
                        .setDistance(values[0] * values[1] * values[2])
                 );
             }
         })
    );

    modifiers.add(
        new Modifier("Sliced (Capped)", 3)
            .setDefaultValues(new float[] { 50, 50, 0 })
            .setMaxValues(new float[] { 100, 100, 10 })
            .setMinValues(new float[] { 1, 1, -10 })
            .setLabels(new String[] { "-ve Z", "+ve Z", "Vec X" })
            .setCreator(new ModifierCreator() {
              public void create(float[] values) {
                  mesh.modify(
                      new HEM_Slice()
                          .setCap(true)
                          .setPlane(
                              new WB_Plane(
                                  new WB_Point(0, 0, -values[0]),
                                  new WB_Vector(values[2], 0, 1)
                              )
                          )
                  );

                  mesh.modify(
                      new HEM_Slice()
                          .setCap(true)
                          .setPlane(
                              new WB_Plane(
                                  new WB_Point(0, 0, values[1]),
                                  new WB_Vector(values[2], 0, -1)
                              )
                          )
                  );
              }
        })
    );

    modifiers.add(
        new Modifier("Sliced (Open)", 3)
            .setDefaultValues(new float[] { 50, 50, 0 })
            .setMaxValues(new float[] { 100, 100, 10 })
            .setMinValues(new float[] { 1, 1, -10 })
            .setLabels(new String[] { "-ve Z", "+ve Z", "Vec X" })
            .setCreator(new ModifierCreator() {
              public void create(float[] values) {
                  mesh.modify(
                      new HEM_Slice()
                          .setCap(false)
                          .setPlane(
                              new WB_Plane(
                                  new WB_Point(0, 0, -values[0]),
                                  new WB_Vector(values[2], 0, 1)
                              )
                          )
                  );

                  mesh.modify(
                      new HEM_Slice()
                          .setCap(false)
                          .setPlane(
                              new WB_Plane(
                                  new WB_Point(0, 0, values[1]),
                                  new WB_Vector(values[2], 0, -1)
                              )
                          )
                  );
              }
        })
    );

    modifiers.add(
        new Modifier("Mirror", 1)
            .setDefaultValues(new float[] { 0 })
            .setMaxValues(new float[] { 100 })
            .setMinValues(new float[] { 0 })
            .setLabels(new String[] { "Offset" })
            .setCreator(new ModifierCreator() {
              public void create(float[] values) {
                  mesh.modify(
                      new HEM_Mirror()
                          .setPlane(new WB_Plane(0, 0, 0, 0, 1, 1))
                          .setOffset(values[0])
                          .setReverse(false)
                  );
              }
        })
    );

    modifiers.add(
        new Modifier("Kaleidoscope", 1)
            .setDefaultValues(new float[] { 5, 0, 0 })
            .setMaxValues(new float[] { 10, 1, 1 })
            .setMinValues(new float[] { 1, 0, 0 })
            .setLabels(new String[] { "Symmetry", "Angle", "Angle" })
            .setCreator(new ModifierCreator() {
              public void create(float[] values) {
                  mesh.modify(
                      new HEM_Kaleidoscope()
                          .setSymmetry(int(values[0]))
                          .setAngle(values[1])
                          .setOrigin(new WB_Point(0, 0, 0))
                          .setAxis(new WB_Vector(0, 1, 0))
                          .setAngle(values[2])
                  );
              }
        })
    );

    modifiers.add(
       new Modifier("Noise", 1)
           .setDefaultValues(new float[] { 1 })
           .setMinValues(new float[] { .1 })
           .setMaxValues(new float[] { 5 })
           .setLabels(new String[] { "Distance" })
           .setCreator(new ModifierCreator() {
             public void create(float[] values) {
                 mesh.modify(
                     new HEM_Noise()
                        .setDistance(values[0])
                 );
             }
         })
    );

    modifiers.add(
       new Modifier("Spherical Inversion", 2)
           .setDefaultValues(new float[] { 1, 1, 0 })
           .setLabels(new String[] { "Radius", "Cutoff" })
           .setCreator(new ModifierCreator() {
             public void create(float[] values) {
                 mesh.modify(
                     new HEM_SphericalInversion()
                        .setRadius(values[0])
                        .setCenter(0, 0, 0)
                        .setCutoff(values[1])
                        .setLinear(true)
                 );
             }
         })
    );

    modifiers.add(
        new Modifier("============", 0)
    );


    modifiers.add(
        new Modifier("Planar", 1)
            .setDefaultValues(new float[] { 5 })
            .setMaxValues(new float[] { 5 })
            .setMinValues(new float[] { 1 })
            .setLabels(new String[] { "Iterations" })
            .setCreator(new ModifierCreator() {
              public void create(float[] values) {
                  mesh.subdivide(
                      new HES_Planar()
                          .setRandom(false),
                      int(values[0])
                  );
              }
        })
    );

    modifiers.add(
        new Modifier("Planar (Random)", 2)
            .setDefaultValues(new float[] { 2, .5 })
            .setMaxValues(new float[] { 5, 1 })
            .setMinValues(new float[] { 1, 0})
            .setLabels(new String[] { "Iterations", "Range" })
            .setCreator(new ModifierCreator() {
              public void create(float[] values) {
                  mesh.subdivide(
                      new HES_Planar()
                          .setRandom(true)
                          .setRange(values[1]),
                      int(values[0])
                  );
              }
        })
    );

    modifiers.add(
        new Modifier("Planar Mid Edge", 1)
            .setDefaultValues(new float[] { 2 })
            .setMaxValues(new float[] { 5 })
            .setMinValues(new float[] { 1 })
            .setLabels(new String[] { "Iterations" })
            .setCreator(new ModifierCreator() {
              public void create(float[] values) {
                  mesh.subdivide(
                      new HES_PlanarMidEdge(),
                      int(values[0])
                  );
              }
        })
    );

    modifiers.add(
        new Modifier("Catmull–Clark", 1)
            .setDefaultValues(new float[] { 2 })
            .setMaxValues(new float[] { 5 })
            .setMinValues(new float[] { 1 })
            .setLabels(new String[] { "Iterations" })
            .setCreator(new ModifierCreator() {
              public void create(float[] values) {
                  mesh.subdivide(
                      new HES_CatmullClark(),
                      int(values[0])
                  );
              }
        })
    );

    modifiers.add(
        new Modifier("Smooth", 1)
            .setDefaultValues(new float[] { 2 })
            .setMaxValues(new float[] { 5 })
            .setMinValues(new float[] { 1 })
            .setLabels(new String[] { "Iterations" })
            .setCreator(new ModifierCreator() {
              public void create(float[] values) {
                  mesh.subdivide(
                      new HES_Smooth(),
                      int(values[0])
                  );
              }
        })
    );

    modifiers.add(
        new Modifier("Doo–Sabin", 2)
            .setDefaultValues(new float[] { 2, 5 })
            .setMaxValues(new float[] { 5, 100 })
            .setMinValues(new float[] { 1, 1 })
            .setLabels(new String[] { "Iterations", "Distance" })
            .setCreator(new ModifierCreator() {
              public void create(float[] values) {
                  mesh.subdivide(
                      new HES_DooSabin()
                          .setFactors(2, 2)
                          .setAbsolute(false)
                          .setDistance(int(values[1])),
                      int(values[0])
                  );
              }
        })
    );
}

// create shape and run modifiers
void createHemesh() {
    selectedShape.create();

    for (int i = 0; i < selectedModifiers.size(); i++) {
        Modifier m = selectedModifiers.get(i);
        m.index = i;
        m.create();
        m.update();
    }
}

// display shape
void drawHemesh() {
  colorMode(HSB, 360, 100, 100, 100);
  shapecolor = color(shapeHue, shapeSaturation, shapeBrightness, shapeTransparency);
  colorMode(RGB, 255, 255, 255, 255);

  if (facesOn) {
    noStroke();
    fill(shapecolor);

    if (selectedShape.getMeshCollection()) {
      render.drawFaces(meshes);
    } else {
      render.drawFaces(mesh);
    }
  }

  if (edgesOn) {
    strokeWeight(1);
    stroke(currentTheme.Edges);

    if (selectedShape.getMeshCollection()) {
      render.drawEdges(meshes);
    } else {
      render.drawEdges(mesh);
    }
  }

  if (selectedShapeIndex == 14) {
    if (triangles != null) {
      for (int i = 0; i < triangles.length; i += 3) {
        pushMatrix();
        render.drawTriangle(points[triangles[i]], points[triangles[i+1]], points[triangles[i+2]]);
        popMatrix();
      }
    }
  }
}
/*
// names of shapes & modifiers & shaders
String numToName(int num) {
  String name = null;

  switch(num) {

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
}*/
