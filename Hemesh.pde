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
          public synchronized void create(float[] values, File file) {}
          public synchronized void create(float[] values) {
               meshBuffer = new HE_Mesh(
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
           public synchronized void create(float[] values, File file) {}
           public synchronized void create(float[] values) {
               meshBuffer = new HE_Mesh(
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
            public synchronized void create(float[] values, File file) {}
            public synchronized void create(float[] values) {
               meshBuffer = new HE_Mesh(
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
           public synchronized void create(float[] values, File file) {}
           public synchronized void create(float[] values) {
              meshBuffer = new HE_Mesh(
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
           public synchronized void create(float[] values, File file) {}
           public synchronized void create(float[] values) {
              meshBuffer = new HE_Mesh(
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
            public synchronized void create(float[] values, File file) {}
            public synchronized void create(float[] values) {
               meshBuffer = new HE_Mesh(
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
            public synchronized void create(float[] values, File file) {}
            public synchronized void create(float[] values) {
               meshBuffer = new HE_Mesh(
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
            public synchronized void create(float[] values, File file) {}
            public synchronized void create(float[] values) {
               meshBuffer = new HE_Mesh(
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
            public synchronized void create(float[] values, File file) {}
            public synchronized void create(float[] values) {
               meshBuffer = new HE_Mesh(
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
            public synchronized void create(float[] values, File file) {}
            public synchronized void create(float[] values) {
               meshBuffer = new HE_Mesh(
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
            public synchronized void create(float[] values, File file) {}
            public synchronized void create(float[] values) {
                float[][] wvalues = new float[int(values[3])][int(values[3])];
                for (int j = 0; j < int(values[3]); j++) {
                   for (int i = 0; i < int(values[3]); i++) {
                     wvalues[i][j] = values[2] * noise(0.35*i, 0.35*j);
                   }
                }

                meshBuffer = new HE_Mesh(
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
            public synchronized void create(float[] values, File file) {}
            public synchronized void create(float[] values) {
                float[][] randomPoints = new float[int(values[0])*1000][3];
                for (int i = 0; i < int(values[0])*1000; i++) {
                  randomPoints[i][0] = random(-values[1]/2, values[1]/2);
                  randomPoints[i][1] = random(-values[2]/2, values[2]/2);
                  randomPoints[i][2] = random(-values[3]/2, values[3]/2);
                }

                meshBuffer = new HE_Mesh(
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
            public synchronized void create(float[] values, File file) {}
            public synchronized void create(float[] values) {
                meshBuffer = new HE_Mesh(
                    new HEC_Beethoven()
                        .setScale(int(values[0]))
                        .setZAxis(0, -90, 0)
                );
            }
        })
   );

   shapes.add(
      new Shape("Super Duper", 4)
        .setLabels(new String[] { "Radius", "UFacets", "VFacets" })
        .setMinValues(new float[] { 1, 1, 1 })
        .setMaxValues(new float[] { 200, 500, 100 })
        .setDefaultValues(new float[] { 30, 35, 400, 20 })
        .setCreator(new ShapeCreator() {
            public synchronized void create(float[] values, File file) {}
            public synchronized void create(float[] values) {
                meshBuffer = new HE_Mesh(
                    new HEC_SuperDuper()
                        .setGeneralParameters(0, 11, 0, 0,13, 10, 15, 10, 4, 0, 0, 0, 5, 0.3, 2.2)
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
            public synchronized void create(float[] values, File file) {}
            public synchronized void create(float[] values) {
                WB_RandomOnSphere source = new WB_RandomOnSphere();
                int numPoints = int(values[1]);
                points = new WB_Point[numPoints];

                for (int i=0; i < numPoints; i++) {
                  points[i] = source.nextPoint().mulSelf(values[0]);
                }

                WB_AlphaTriangulation3D triangulation = WB_Triangulate.alphaTriangulate3D(points);
                int[] tetrahedra = triangulation.getAlphaTetrahedra(values[2]);// 1D array of indices of tetrahedra, 4 indices per tetrahedron

                triangles = triangulation.getAlphaTriangles(values[2]);

                meshBuffer = new HE_Mesh(
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
            public synchronized void create(float[] values, File file) {}
            public synchronized void create(float[] values) {
                meshBuffer = new HE_Mesh(
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
            public synchronized void create(float[] values, File file) {}
            public synchronized void create(float[] values) {
                meshBuffer = new HE_Mesh(
                    new HEC_Geodesic()
                        .setRadius(values[0])
                );

                float[][] points = new float[int(values[1])][3];
                for (int i = 0; i < int(values[1]); i++) {
                    points[i][0] = random(-int(values[0]), int(values[0]));
                    points[i][1] = random(-int(values[0]), int(values[0]));
                    points[i][2] = random(-int(values[0]), int(values[0]));
                }

                for (int i = 0; i < selectedModifiers.size(); i++) {
                    Modifier m = selectedModifiers.get(i);
                    m.index = i;
                    m.create();
                    m.update();
                }

                HEMC_VoronoiCells multiCreator = new HEMC_VoronoiCells();
                multiCreator.setPoints(points);
                multiCreator.setContainer(meshBuffer);
                multiCreator.setOffset(int(values[2]));
                multiCreator.setSurface(false);
                meshesBuffer = multiCreator.create();
            }
        })
   );

   shapes.add(
      new Shape("UV Parametric", 4)
        .setMinValues(new float[] { 10, 4, 0.5, 2 })
        .setMaxValues(new float[] { 500, 200, 10, 30 })
        .setDefaultValues(new float[] { 100, 50, 2, 3 })
        .setLabels(new String[] { "Scale", "Steps", "Sq. Factor", "Divider" })
        .setCreator(new ShapeCreator() {
            public synchronized void create(float[] values, File file) {}
            public synchronized void create(float[] values) {
                meshBuffer = new HE_Mesh(
                    new HEC_UVParametric()
                        .setUVSteps(int(values[1]), int(values[1]))
                        .setScale(values[0])
                        .setEvaluator(new UVFunction(values[2], values[3]))
                );
            }
        })
   );

   shapes.add(
     new Shape("Sea Shell", 4)
      .setMinValues(new float[] { 0, 0, 0, 1 })
      .setMaxValues(new float[] { 10, 10, 100, 20 })
      .setDefaultValues(new float[] { 5, 2, 15, 10 })
      .setLabels(new String[] { "Scale", "Spiral Size", "Angle", "Divisions" })
      .setCreator(new ShapeCreator() {
          public synchronized void create(float[] values, File file) {}
          public synchronized void create(float[] values) {
              meshBuffer = new HE_Mesh(
                  new HEC_SeaShell()
                      .setScale(values[0])
                      .setA(values[1])
                      .setBeta(values[2])
                      .setDivisions(values[3], values[3])
              );
          }
      })
   );

   shapes.add(
     new Shape("Sweep Tube", 5)
      .setMinValues(new float[] { 0, 0, 0, 1, 10 })
      .setMaxValues(new float[] { 100, 2000, 100, 10, 100 })
      .setDefaultValues(new float[] { 40, 200, 80, 3, 20 })
      .setLabels(new String[] { "Thickness", "Length", "Radius", "Pitch", "Facets" })
      .setCreator(new ShapeCreator() {
          public synchronized void create(float[] values, File file) {}
          public synchronized void create(float[] values) {
              WB_Point[] splinePoints = new WB_Point[int(values[1]) * 2];
              for (int i = -int(values[1]); i < int(values[1]); i++) {
                splinePoints[i + int(values[1])] = new WB_Point(
                  cos(radians(i)) * values[2],
                  sin(radians(i)) * values[2],
                  i / values[3]
                );
              }

              WB_BSpline spline = new WB_BSpline(splinePoints, 6);

              meshBuffer = new HE_Mesh(
                  new HEC_SweepTube()
                      .setCurve(spline)
                      .setRadius(values[0])
                      .setSteps(int(values[4]) * 8)
                      .setFacets(int(values[4]))
                      .setCap(true, true)
                  );
          }
      })
   );

   shapes.add(
     new Shape("From file...", 1)
        .setLabels(new String[] { "Scale" })
        .setMinValues(new float[] { 0.1 })
        .setMaxValues(new float[] { 100.0 })
        .setDefaultValues(new float[] { 1.0 })
        .setCustom(true)
        .setCreator(new ShapeCreator() {
          public synchronized void create(float[] values) {}
          public synchronized void create(float[] values, File file) {
            String extension = FileExtensions.getExtensionLowerCase(file);
            String fullPath = file.getAbsolutePath();

            // moveToSelf() needs to be called on all of these imports
            // to center the object correctly
            switch(extension) {
              case "3ds":
                meshBuffer = new HE_Mesh(
                  new HEC_From3dsFile(fullPath)
                    .setScale(values[0])
                ).moveToSelf(0, 0, 0);
                break;
              case "stl":
                meshBuffer = new HE_Mesh(
                  new HEC_FromBinarySTLFile(fullPath)
                    .setScale(values[0])
                ).moveToSelf(0, 0, 0);
                break;
              case "obj":
                meshBuffer = new HE_Mesh(
                  new HEC_FromOBJFile(fullPath)
                    .setScale(values[0])
                ).moveToSelf(0, 0, 0);
                break;
              default:
                println("Invalid file format");
                break;
            }
          }
        })
   );

   // Set the maximum number of parameters to display
   for ( Shape shape : shapes ) {
     maxShapeParameters = shape.parameters > maxShapeParameters ? shape.parameters : maxShapeParameters;
   }
}

void createModifiers() {
    modifiers.add(
      new Modifier("Chamfer Corners", 1)
          .setDefaultValues(new float[] { 10 })
          .setMaxValues(new float[] { 100 })
          .setLabels(new String[] { "Distance" })
          .setCreator(new ModifierCreator() {
            public synchronized void create(float[] values) {
                meshBuffer.modify(
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
           public synchronized void create(float[] values) {
               extrude1.setDistance(values[0]);
               meshBuffer.modify(extrude1);
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
              public synchronized void create(float[] values) {
                  extrude1
                     .setDistance(values[0])
                     .setChamfer(values[1])
                     .setHardEdgeChamfer(values[2]);
                  meshBuffer.modify(extrude1);
              }
          })
    );

    modifiers.add(
       new Modifier("Lattice", 3)
           .setDefaultValues(new float[] { 15, 15, 1 })
           .setMaxValues(new float[] { 100, 100, 360 })
           .setLabels(new String[] { "Depth", "Width", "Threshold Angle" })
           .setCreator(new ModifierCreator() {
             public synchronized void create(float[] values) {
                 meshBuffer.modify(
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
             public synchronized void create(float[] values) {
                 meshBuffer.modify(
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
           .setDefaultValues(new float[] { 1.0, 1.0 })
           .setMinValues(new float[] { 0.1, 0.1 })
           .setMaxValues(new float[] { 2.0, 2.0 })
           .setLabels(new String[] { "Factor", "Compression" })
           .setCreator(new ModifierCreator() {
             public synchronized void create(float[] values) {
                 meshBuffer.modify(
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
           .setDefaultValues(new float[] { 0.1 })
           .setMinValues(new float[] { 0 })
           .setMaxValues(new float[] { 1 })
           .setLabels(new String[] { "Angle" })
           .setCreator(new ModifierCreator() {
             public synchronized void create(float[] values) {
                 meshBuffer.modify(
                     new HEM_Twist()
                        .setAngleFactor(values[0])
                        .setTwistAxis(new WB_Line(new WB_Point(0,0,0), new WB_Vector(1,0,0)))
                 );
             }
         })
    );

    modifiers.add(
       new Modifier("Twist (Y)", 1)
           .setDefaultValues(new float[] { 0.1 })
           .setMinValues(new float[] { 0 })
           .setMaxValues(new float[] { 1 })
           .setLabels(new String[] { "Angle" })
           .setCreator(new ModifierCreator() {
             public synchronized void create(float[] values) {
                 meshBuffer.modify(
                     new HEM_Twist()
                        .setAngleFactor(values[0])
                        .setTwistAxis(new WB_Line(new WB_Point(0,0,0), new WB_Vector(0,1,0)))
                 );
             }
         })
    );

    modifiers.add(
       new Modifier("Twist (Z)", 1)
           .setDefaultValues(new float[] { 0.1 })
           .setMinValues(new float[] { 0 })
           .setMaxValues(new float[] { 1 })
           .setLabels(new String[] { "Angle" })
           .setCreator(new ModifierCreator() {
             public synchronized void create(float[] values) {
                 meshBuffer.modify(
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
             public synchronized void create(float[] values) {
                 meshBuffer.modify(
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
             public synchronized void create(float[] values) {
                 meshBuffer.modify(
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
              public synchronized void create(float[] values) {
                  meshBuffer.modify(
                      new HEM_Slice()
                          .setCap(true)
                          .setPlane(
                              new WB_Plane(
                                  new WB_Point(0, 0, -values[0]),
                                  new WB_Vector(values[2], 0, 1)
                              )
                          )
                  );

                  meshBuffer.modify(
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
              public synchronized void create(float[] values) {
                  meshBuffer.modify(
                      new HEM_Slice()
                          .setCap(false)
                          .setPlane(
                              new WB_Plane(
                                  new WB_Point(0, 0, -values[0]),
                                  new WB_Vector(values[2], 0, 1)
                              )
                          )
                  );

                  meshBuffer.modify(
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
              public synchronized void create(float[] values) {
                  meshBuffer.modify(
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
              public synchronized void create(float[] values) {
                  meshBuffer.modify(
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
             public synchronized void create(float[] values) {
                 meshBuffer.modify(
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
             public synchronized void create(float[] values) {
                 meshBuffer.modify(
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
       new Modifier("Spherify", 1)
           .setDefaultValues(new float[] { 1 })
           .setLabels(new String[] { "Radius" })
           .setCreator(new ModifierCreator() {
             public synchronized void create(float[] values) {
                 meshBuffer.modify(
                     new HEM_Spherify()
                        .setRadius(values[0])
                        .setCenter(0, 0, 0)
                 );
             }
         })
    );

    // NOTE: This feature is unstable
    modifiers.add(
       new Modifier("Shrink Wrap", 1)
           .setMinValues(new float[] { 0 })
           .setDefaultValues(new float[] { 2 })
           .setMaxValues(new float[] { 20 })
           .setLabels(new String[] { "Level" })
           .setCreator(new ModifierCreator() {
             public synchronized void create(float[] values) {
                meshBuffer = new HEC_ShrinkWrap()
                  .setSource(meshBuffer)
                  .setLevel(int(values[0]))
                  .createBase();
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
              public synchronized void create(float[] values) {
                  meshBuffer.subdivide(
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
              public synchronized void create(float[] values) {
                  meshBuffer.subdivide(
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
              public synchronized void create(float[] values) {
                  meshBuffer.subdivide(
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
              public synchronized void create(float[] values) {
                  meshBuffer.subdivide(
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
              public synchronized void create(float[] values) {
                  meshBuffer.subdivide(
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
              public synchronized void create(float[] values) {
                  meshBuffer.subdivide(
                      new HES_DooSabin()
                          .setFactors(2, 2)
                          .setAbsolute(false)
                          .setDistance(int(values[1])),
                      int(values[0])
                  );
              }
        })
    );

    modifiers.add(
        new Modifier("============", 0)
    );

    modifiers.add(
        new Modifier("TriDec", 1)
            .setDefaultValues(new float[] { 0.9 })
            .setMaxValues(new float[] { 1.0 })
            .setMinValues(new float[] { 0.01 })
            .setLabels(new String[] { "Iterations", "Distance" })
            .setCreator(new ModifierCreator() {
              public synchronized void create(float[] values) {
                  meshBuffer.simplify(
                      new HES_TriDec()
                          .setGoal(values[0])
                  );
              }
        })
    );
}

// create shape and run modifiers
void createHemesh() {
  // Certain meshes and modifiers can make the UI become unresponsive, so we delegate this work to a thread

  if (!isUpdatingMesh) {
    new Thread()
    {
      public void run() {
        try {
          synchronized(this) {
            isUpdatingMesh = true;
            renderingTime = millis();
            selectedShape.create();

            if (validateMesh) {
              selectedShape.validate(meshBuffer);
            }

            for (int i = 0; i < selectedModifiers.size(); i++) {
                Modifier m = selectedModifiers.get(i);
                m.index = i;
                m.create();
                m.update();
            }

            mesh = meshBuffer;
            meshes = meshesBuffer;
          }
        } catch(Exception ex) {
          println("Exception: " + ex);
        } finally {
          renderingTime = millis();
          isUpdatingMesh = false;
        }
      }
    }.start();
  }
}

void drawWaitState() {
  if (isUpdatingMesh && millis() - renderingTime > waitTime) {
    hint(DISABLE_DEPTH_TEST);
    translate(0, 0);
    fill(currentTheme.Background, 100);
    rect(0, 0, width, height);
    translate(width/2, height/2);
    rotate(rotationX / 10);
    noFill();
    strokeWeight(8);
    stroke(currentTheme.Spinner);
    ellipseMode(CENTER);
    arc(0, 0, 32, 32, radians(0), radians(215));
    stroke(currentTheme.Spinner, 100);
    arc(0, 0, 32, 32, radians(0), radians(360));
    hint(ENABLE_DEPTH_TEST);
  }
}

// display shape
void drawHemesh() {
  colorMode(HSB, 360, 100, 100, 100);
  shapeColor = color(shapeHue, shapeSaturation, shapeBrightness, shapeTransparency);
  colorMode(RGB, 255, 255, 255, 255);


  if (facesOn) {
    noStroke();
    fill(shapeColor);

    if (selectedShape.getMeshCollection() && meshes != null) {
      render.drawFaces(meshes);
    } else if (mesh != null) {
      render.drawFaces(mesh);
      noFill();
      /* Draw bounding box
      stroke(255, 0, 0);
      render.drawAABB(mesh.getAABB());*/
    }
  }

  if (edgesOn) {
    strokeWeight(1);
    stroke(currentTheme.Edges);

    if (selectedShape.getMeshCollection() && meshes != null) {
      render.drawEdges(meshes);
    } else if (mesh != null) {
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
