
import java.awt.Color;

import org.sunflow.SunflowAPI;
import org.sunflow.core.Display;
import org.sunflow.core.ParameterList.FloatParameter;
import org.sunflow.core.display.FileDisplay;
import org.sunflow.math.Matrix4;
import org.sunflow.math.Point3;
import org.sunflow.math.Vector3;

public class SunflowAPIAPI {
        private String currShader;
        private String currModifier;
        private String currCamera;
        private String currBucketOrder;
        private String currFilter;
        private String cameraType;
        private String modifierType;

        private SunflowAPI sunflow;

        private Display windowDisplay;
        private FileDisplay fileDisplay;

        public final String SHADER_AMBIENT_OCCLUSION = "ambient_occlusion";
        public final String SHADER_TEXTURED_AMBIENT_OCCLUSION = "textured_ambient_occlusion";
        public final String SHADER_CONSTANT = "constant";
        public final String SHADER_DIFFUSE = "diffuse";
        public final String SHADER_TEXTURED_DIFFUSE = "textured_diffuse";
        public final String SHADER_GLASS = "glass";
        public final String SHADER_MIRROR = "mirror";
        public final String SHADER_PHONG = "phong";
        public final String SHADER_TEXTURED_PHONG = "textured_phong";
        public final String SHADER_SHINY_DIFFUSE = "shiny_diffuse";
        public final String SHADER_TEXTURED_SHINY_DIFFUSE = "textured_shiny_diffuse";
        public final String SHADER_UBER = "uber";
        public final String SHADER_WARD = "ward";
        public final String SHADER_TEXTURED_WARD = "textured_ward";
        public final String SHADER_WIREFRAME = "wireframe";

        public final String COLORSPACE_SRGB_NONLINEAR = "sRGB nonlinear";
        public final String COLORSPACE_SRGB_LINEAR = "sRGB linear";
        public final String COLORSPACE_XYZ = "XYZ";
        private String colorSpace = COLORSPACE_SRGB_NONLINEAR;

        public final String CAMERA_PINHOLE = "pinhole";
        public final String CAMERA_THINLENS = "thinlens";
        public final String CAMERA_FISHEYE = "fisheye";
        public final String CAMERA_SPHERICAL = "spherical";

        public final String GI_AMBIENT_OCCLUSION = "ambocc";
        public final String GI_FAKE = "fake";
        public final String GI_INSTANT_GI = "igi";
        public final String GI_IRRADIANCE_CACHE = "irr-cache";
        public final String GI_PATH = "path";

        public final String LIGHT_DIRECTIONAL = "directional";
        public final String LIGHT_IMAGEBASED = "ibl";
        public final String LIGHT_POINT = "point";
        public final String LIGHT_SPHERE = "sphere";
        public final String LIGHT_SUNSKY = "sunsky";
        public final String LIGHT_MESH = "triangle_mesh";

        public final String BUCKET_ORDER_COLUMN = "column";
        public final String BUCKET_ORDER_DIAGONAL = "diagonal";
        public final String BUCKET_ORDER_HILBERT = "hilbert";
        public final String BUCKET_ORDER_RANDOM = "random";
        public final String BUCKET_ORDER_ROW = "row";
        public final String BUCKET_ORDER_SPIRAL = "spiral";

        public final String FILTER_BLACKMAN_HARRIS = "blackman-harris";
        public final String FILTER_BOX = "box";
        public final String FILTER_CATMULL_ROM = "catmull-rom";
        public final String FILTER_GAUSSIAN = "gaussian";
        public final String FILTER_LANCZOS = "lanczos";
        public final String FILTER_MITCHELL = "mitchell";
        public final String FILTER_SINC = "sinc";
        public final String FILTER_TRIANGLE = "triangle";
        public final String FILTER_BSPLINE = "bspline";

        public final String MODIFIER_BUMP_MAP = "bump_map";
        public final String MODIFIER_NORMAL_MAP = "normal_map";
        public final String MODIFIER_PERLIN_MAP = "perlin";

        private Point3 eye;
        private Point3 target;
        private Vector3 up;
        private int sides;
        private float fov;
        private float aspect;
        private float shiftX;
        private float shiftY;
        private float focusDistance;
        private float lensRadius;
        private float lensRotation;
        private int tileX;
        private int tileY;

        // modifier parameters
        private int modifiercount = 0;

        private boolean isModifiers = false;
        private int aaMin = 1;
        private int aaMax = 2;
        private int previewAaMin = 0;
        private int previewAaMax = 1;

        private int width = 640;
        private int height = 480;
        public SunflowAPIAPI() {
          sunflow = new SunflowAPI();

          // set default values

          // camera position
          eye = new Point3(0, 10, 15);
          target = new Point3(0, 0, 0);
          up = new Vector3(0, 1, 0);
          // camera default values
          fov = 50;
          aspect = width/height;
          currCamera = "internal_defaultcamera";
          focusDistance = 1;
          lensRadius = 0;
          fov = 90;
          aspect = 1;
          sides = 0;
          lensRotation = 0;

          // set camera
          this.setThinlensCamera("internal_defaultcamera", fov, aspect);
          // shader
          this.setAmbientOcclusionShader("internal_defaultshader", new Color(1f,1f,1f), new Color(0f,0f,0f), 16, 5);
          // bucket order
          currBucketOrder = BUCKET_ORDER_SPIRAL;
          // filter
          currFilter = FILTER_MITCHELL;
        }

        /*
         * --------------------------------------------------------------------------------------
         * LIGHTS
         */

        /**
         * sets directional light
         * @param name Individual name
         * @param source light position
         * @param direction light direction
         * @param radius light radius
         * @param color light color
         */
        public void setDirectionalLight(String name, Point3 source, Vector3 direction, float radius, Color color) {
                sunflow.parameter("source", source);
                sunflow.parameter("dir", direction);
                sunflow.parameter("radius", radius);
                sunflow.parameter("radiance", colorSpace, color.getRed()/(float)255, color.getGreen()/(float)255, color.getBlue()/(float)255);
                sunflow.light( name, LIGHT_DIRECTIONAL );
        }
        /**
         * Sets Image based light
         * @param name Individual name
         * @param center Light position
         * @param up ?
         * @param samples Detail, the higher the slower and smoother
         * @param lowSamples ?
         * @param texture Path to texture file
         */
        public void setImageBasedLight(String name, Vector3 center, Vector3 up, int samples, int lowSamples, String texture) {
                sunflow.parameter("center", center);
                sunflow.parameter("up", up);
                sunflow.parameter("samples", samples);
                sunflow.parameter("lowsamples",lowSamples);
                sunflow.parameter("texture", texture);
                sunflow.light( name, this.LIGHT_IMAGEBASED );
        }
        /**
         * Sets point light
         * @param name Individual name
         * @param center Light position
         * @param color light color
         */
        public void setPointLight(String name, Point3 center, Color color) {
                sunflow.parameter("center", center);
                sunflow.parameter("power", colorSpace, color.getRed()/(float)255, color.getGreen()/(float)255, color.getBlue()/(float)255);
                sunflow.light( name, this.LIGHT_POINT );
        }
        /**
         * Sets sphere light
         * @param name individual name
         * @param center light position
         * @param color light color
         * @param samples Detail, the highe the smoother and slower
         * @param radius light size
         */
        public void setSphereLight(String name, Point3 center, Color color, int samples, float radius) {
                sunflow.parameter("center", center);
                sunflow.parameter("radiance", colorSpace, color.getRed()/(float)255, color.getGreen()/(float)255, color.getBlue()/(float)255);
                sunflow.parameter("samples", samples);
                sunflow.parameter("radius", radius);
        sunflow.light( name, LIGHT_SPHERE );
        }
        /**
         * sets sunsky light
         * @param name Individual name
         */
        public void setSunSkyLight(String name) {
                sunflow.parameter( "up", new Vector3( 0, 0, 1 ) );
                sunflow.parameter( "east", new Vector3( 0, 1, 0 ) );
                sunflow.parameter( "sundir", new Vector3( 1, -1, 0.31f ) );
                sunflow.parameter( "turbidity", 2f );
                sunflow.parameter( "samples", 16 );
        sunflow.light( name, this.LIGHT_SUNSKY );
        }
        /**
         * sets sunsky light
         * @param name Individual name
         * @param up ? direction
         * @param east ? direction
         * @param direction light direction
         * @param color light color
         * @param samples Detail
         * @param turbidity ?
         * @param groundExtendSky ?
         */
        public void setSunSkyLight(String name, Vector3 up, Vector3 east, Vector3 direction, Color color, int samples, float turbidity, boolean groundExtendSky) {
                sunflow.parameter("up", up);
                sunflow.parameter("east", east);
                sunflow.parameter("sundir", direction);
                sunflow.parameter("ground.color", colorSpace, color.getRed()/(float)255, color.getGreen()/(float)255, color.getBlue()/(float)255);
                sunflow.parameter("samples", samples);
                sunflow.parameter("turbidity", turbidity);
                sunflow.parameter("ground.extendsky", groundExtendSky);
        sunflow.light( name, this.LIGHT_SUNSKY );
        }

        /**
         * sets mesh light
         * @param name Individual name
         * @param color light color
         * @param samples Detail
         * @param vertices Float array with coordinates (like [x0,y0,z0,x1,y1,z1,x2,y2,z2])
         * @param triangles int array connecting the vertices (like [0,1,2])
         */
        public void drawMeshLight(String name, Color color, int samples, float[] vertices, int[] triangles) {
                sunflow.parameter("points", "point", "vertex", vertices);
                sunflow.parameter("triangles", triangles);

                sunflow.parameter("radiance", colorSpace, color.getRed()/(float)255, color.getGreen()/(float)255, color.getBlue()/(float)255);
                sunflow.parameter("samples", samples);

                sunflow.light( name, this.LIGHT_MESH);
        }

        /*
         * END OF LIGHTS
         * --------------------------------------------------------------------------------------
         */

        /*
         * --------------------------------------------------------------------------------------
         * SHADER
         */

        /**
         * Sets Ambient Occlusion Shader
         * @param name Individual Name
         * @param bright Highlight Color
         * @param dark Dark Color
         * @param samples Detail, the higher the slower and smoother
         * @param maxDist ?
         */
        public void setAmbientOcclusionShader(String name, Color bright, Color dark, int samples, float maxDist) {
//              save name for use with primitives
                currShader = name;

//              set parameter
                sunflow.parameter("bright", colorSpace, bright.getRed()/(float)255, bright.getGreen()/(float)255, bright.getBlue()/(float)255);
                sunflow.parameter("dark", colorSpace, dark.getRed()/(float)255, dark.getGreen()/(float)255, dark.getBlue()/(float)255);
                sunflow.parameter("samples", samples);
                sunflow.parameter("maxdist", maxDist);

//              set shader
                sunflow.shader(currShader, SHADER_AMBIENT_OCCLUSION);
        }

        /**
         * Sets Ambient Occlusion Shader
         * @param name Individual Name
         * @param bright Highlight Color
         * @param dark Dark Color
         * @param samples Detail, the higher the slower and smoother
         * @param maxDist ?
         * @param texture Path to texture file
         */
        public void setAmbientOcclusionShader(String name, Color bright, Color dark, int samples, float maxDist, String texture) {
//              save name for use with primitives
                currShader = name;

//              set parameter
                sunflow.parameter("bright", colorSpace, bright.getRed()/(float)255, bright.getGreen()/(float)255, bright.getBlue()/(float)255);
                sunflow.parameter("dark", colorSpace, dark.getRed()/(float)255, dark.getGreen()/(float)255, dark.getBlue()/(float)255);
                sunflow.parameter("samples", samples);
                sunflow.parameter("maxdist", maxDist);
                sunflow.parameter("texture", texture);

//              set shader
                sunflow.shader(currShader, SHADER_TEXTURED_AMBIENT_OCCLUSION);
        }

        /**
         * Sets constant shader
         * @param name Individual Name
         * @param color Color
         */
        public void setConstantShader(String name, Color color) {
//              save name for use with primitives
                currShader = name;

//              set parameter
                sunflow.parameter("color", colorSpace, color.getRed()/(float)255, color.getGreen()/(float)255, color.getBlue()/(float)255);

//              set shader
                sunflow.shader(currShader, SHADER_CONSTANT);
        }

        /**
         * Sets Diffuse Shader
         * @param name Individial Name
         * @param color Color
         */
        public void setDiffuseShader(String name, Color color) {
//              save name for use with primitives
                currShader = name;

//              set parameter
                sunflow.parameter("diffuse", colorSpace, color.getRed()/(float)255, color.getGreen()/(float)255, color.getBlue()/(float)255);

//              set shader
                sunflow.shader(currShader, SHADER_DIFFUSE);
        }

        /**
         * Sets Diffuse Shader
         * @param name Individial Name
         * @param color Color
         * @param texture Path to texture file
         */
        public void setDiffuseShader(String name, Color color, String texture) {
//              save name for use with primitives
                currShader = name;

//              set parameter
                sunflow.parameter("diffuse", colorSpace, color.getRed()/(float)255, color.getGreen()/(float)255, color.getBlue()/(float)255);
                sunflow.parameter("texture", texture);

//              set shader
                sunflow.shader(currShader, SHADER_TEXTURED_DIFFUSE);
        }

        /**
         * Sets Glass Shader
         * @param name Individual Name
         * @param color Color
         * @param eta ?
         * @param absorptionDistance ?
         * @param absorptionColor Color
         */
        public void setGlassShader(String name, Color color, float eta, float absorptionDistance, Color absorptionColor) {
//              save name for use with primitives
                currShader = name;

//              set parameter
                sunflow.parameter("color", colorSpace, color.getRed()/(float)255, color.getGreen()/(float)255, color.getBlue()/(float)255);
                sunflow.parameter("eta", eta);
                sunflow.parameter("absorption.distance", absorptionDistance);
                sunflow.parameter("absorption.color", colorSpace, absorptionColor.getRed()/(float)255, absorptionColor.getGreen()/(float)255, absorptionColor.getBlue()/(float)255);

//              set shader
                sunflow.shader(currShader, SHADER_GLASS);
        }

        /**
         * Sets Mirror Shader
         * @param name Individial Name
         * @param color Color
         */
        public void setMirrorShader(String name, Color color) {
//              save name for use with primitives
                currShader = name;

//              set parameter
                sunflow.parameter("color", colorSpace, color.getRed()/(float)255, color.getGreen()/(float)255, color.getBlue()/(float)255);

//              set shader
                sunflow.shader(currShader, SHADER_MIRROR);
        }

        /**
         * Sets Phong Shader
         * @param name Individual Name
         * @param diffuse Diffuse Color
         * @param specular Specular Color
         * @param power ?
         * @param samples Detail, the higher the slower and smoother
         */
        public void setPhongShader(String name, Color diffuse, Color specular, float power, int samples) {
//              save name for use with primitives
                currShader = name;

//              set parameter
                sunflow.parameter("diffuse", colorSpace, diffuse.getRed()/(float)255, diffuse.getGreen()/(float)255, diffuse.getBlue()/(float)255);
                sunflow.parameter("specular", colorSpace, specular.getRed()/(float)255, specular.getGreen()/(float)255, specular.getBlue()/(float)255);
                sunflow.parameter("power", power);
                sunflow.parameter("samples", samples);

//              set shader
                sunflow.shader(currShader, SHADER_PHONG);
        }

        /**
         * Sets Phong Shader
         * @param name Individual Name
         * @param diffuse Diffuse Color
         * @param specular Specular Color
         * @param power ?
         * @param samples Detail, the higher the slower and smoother
         * @param texture Path to texture file
         */
        public void setPhongShader(String name, Color diffuse, Color specular, float power, int samples, String texture) {
//              save name for use with primitives
                currShader = name;

//              set parameter
                sunflow.parameter("diffuse", colorSpace, diffuse.getRed()/(float)255, diffuse.getGreen()/(float)255, diffuse.getBlue()/(float)255);
                sunflow.parameter("specular", colorSpace, specular.getRed()/(float)255, specular.getGreen()/(float)255, specular.getBlue()/(float)255);
                sunflow.parameter("power", power);
                sunflow.parameter("samples", samples);
                sunflow.parameter("texture", texture);

//              set shader
                sunflow.shader(currShader, SHADER_TEXTURED_PHONG);
        }
        /**
         * Sets Shiny Diffuse Shader
         * @param name Individual Name
         * @param color Color
         * @param shiny shinyness, the bigger the more
         */
        public void setShinyDiffuseShader(String name, Color color, float shiny) {
//              save name for use with primitives
                currShader = name;

//              set parameter
                sunflow.parameter("diffuse", colorSpace, color.getRed()/(float)255, color.getGreen()/(float)255, color.getBlue()/(float)255);
                sunflow.parameter("shiny", shiny);

//              set shader
                sunflow.shader(currShader, SHADER_SHINY_DIFFUSE);
        }
        /**
         * Sets Shiny Diffuse Shader
         * @param name Individual Name
         * @param color Color
         * @param shiny shinyness, the bigger the more
         * @param texture Path to texture file
         */
        public void setShinyDiffuseShader(String name, Color color, float shiny, String texture) {
//              save name for use with primitives
                currShader = name;

//              set parameter
                sunflow.parameter("diffuse", colorSpace, color.getRed()/(float)255, color.getGreen()/(float)255, color.getBlue()/(float)255);
                sunflow.parameter("shiny", shiny);
                sunflow.parameter("texture", texture);

//              set shader
                sunflow.shader(currShader, SHADER_TEXTURED_SHINY_DIFFUSE);
        }

        /**
         * Sets Uber Shader
         * @param name Individual Name
         * @param diffuse Diffuse Color
         * @param specular Specular Color
         * @param diffuseTexture Diffuse Texture
         * @param specularTexture Specular Texture
         * @param diffuseBlend Diffuse Blendamount
         * @param specularBlend Specular Blendamount
         * @param glossyness glossyness
         * @param samples samples
         */
        public void setUberShader(String name, Color diffuse, Color specular, String diffuseTexture, String specularTexture, float diffuseBlend, float specularBlend, float glossyness, int samples) {
//              save name for use with primitives
                currShader = name;

//              set parameter
                sunflow.parameter("diffuse", colorSpace, diffuse.getRed()/(float)255, diffuse.getGreen()/(float)255, diffuse.getBlue()/(float)255);
                sunflow.parameter("specular", colorSpace, specular.getRed()/(float)255, specular.getGreen()/(float)255, specular.getBlue()/(float)255);
                sunflow.parameter("diffuse.texture", diffuseTexture);
                sunflow.parameter("specular.texture", specularTexture);
                sunflow.parameter("diffuse.blend", diffuseBlend);
                sunflow.parameter("specular.blend", specularBlend);
                sunflow.parameter("glossyness", glossyness);
                sunflow.parameter("samples", samples);

//              set shader
                sunflow.shader(currShader, SHADER_UBER);
        }

        /**
         * Sets Anisotropic Ward Shader
         * @param name Individual Name
         * @param diffuse Diffuse Color
         * @param specular Specular Color
         * @param roughnessX Roughness in x axis
         * @param roughnessY Roughness in y axis
         * @param samples Detail, the more the slower and smoother
         */
        public void setWardShader(String name, Color diffuse, Color specular, float roughnessX, float roughnessY, int samples) {
//              save name for use with primitives
                currShader = name;

//              set parameter
                sunflow.parameter("diffuse", colorSpace, diffuse.getRed()/(float)255, diffuse.getGreen()/(float)255, diffuse.getBlue()/(float)255);
                sunflow.parameter("specular", colorSpace, specular.getRed()/(float)255, specular.getGreen()/(float)255, specular.getBlue()/(float)255);
                sunflow.parameter("roughnessX", roughnessX);
                sunflow.parameter("roughnessY", roughnessY);
                sunflow.parameter("samples", samples);

//              set shader
                sunflow.shader(currShader, SHADER_WARD);
        }

        /**
         * Sets Anisotropic Ward Shader
         * @param name Individual Name
         * @param diffuse Diffuse Color
         * @param specular Specular Color
         * @param roughnessX Roughness in x axis
         * @param roughnessY Roughness in y axis
         * @param samples Detail, the more the slower and smoother
         * @param texture Path to texture file
         */
        public void setWardShader(String name, Color diffuse, Color specular, float roughnessX, float roughnessY, int samples, String texture) {
//              save name for use with primitives
                currShader = name;

//              set parameter
                sunflow.parameter("diffuse", colorSpace, diffuse.getRed()/(float)255, diffuse.getGreen()/(float)255, diffuse.getBlue()/(float)255);
                sunflow.parameter("specular", colorSpace, specular.getRed()/(float)255, specular.getGreen()/(float)255, specular.getBlue()/(float)255);
                sunflow.parameter("roughnessX", roughnessX);
                sunflow.parameter("roughnessY", roughnessY);
                sunflow.parameter("samples", samples);
                sunflow.parameter("texture", texture);

//              set shader
                sunflow.shader(currShader, SHADER_TEXTURED_WARD);
        }

        /**
         * Sets Wireframe Shader
         * @param name Individual Name
         * @param lineColor line color
         * @param fillColor fill color
         * @param width stroke width ?
         */
        public void setWireframeShader(String name, Color lineColor, Color fillColor, float width) {
//              save name for use with primitives
                currShader = name;

//              set parameter
                sunflow.parameter("line", colorSpace, lineColor.getRed()/(float)255, lineColor.getGreen()/(float)255, lineColor.getBlue()/(float)255);
                sunflow.parameter("fill", colorSpace, fillColor.getRed()/(float)255, fillColor.getGreen()/(float)255, fillColor.getBlue()/(float)255);
                sunflow.parameter("width", width);

//              set shader
                sunflow.shader(currShader, SHADER_WIREFRAME);
        }

        /*
         * END OF SHADER
         * --------------------------------------------------------------------------------------
         */

        /*
         * --------------------------------------------------------------------------------------
         * MODIFIERS
         */

        public void setPerlinModifier(String name, int function, float size, float scale) {
                currModifier = name + modifiercount;
                modifierType = MODIFIER_PERLIN_MAP;

                sunflow.parameter("function", function);
                sunflow.parameter("size", size);
                sunflow.parameter("scale", scale);
                sunflow.modifier(currModifier, modifierType);

                modifiercount++;
                isModifiers = true;
        }

        /*
         * END OF MODIFIERS
         * --------------------------------------------------------------------------------------
         */

        /*
         * --------------------------------------------------------------------------------------
         * PRIMITIVES
         */

        /**
         * draws a mesh primitive
         * @param name individual name of primitive
         * @param vertices Float array with coordinates (like [x0,y0,z0,x1,y1,z1,x2,y2,z2])
         * @param triangles int array connecting the vertices (like [0,1,2])
         */
        public void drawMesh(String name, float[] vertices, int[] triangles) {
                sunflow.parameter("points", "point", "vertex", vertices);
                sunflow.parameter("triangles", triangles);

                sunflow.geometry( name, "triangle_mesh" );
                sunflow.parameter( "shaders", currShader);
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.instance( name + ".instance", name );
        }

        /**
         * draws a mesh primitive which can be rotated and scaled
         * @param name individual name of primitive
         * @param vertices Float array with coordinates (like [x0,y0,z0,x1,y1,z1,x2,y2,z2])
         * @param triangles int array connecting the vertices (like [0,1,2])
         * @param size size
         * @param xRotation x rotation
         * @param yRotation y rotation
         * @param zRotation z rotation
         */
        public void drawMesh(String name, float[] vertices, int[] triangles, float size, float xRotation, float yRotation, float zRotation) {
                Matrix4 scale = Matrix4.IDENTITY.multiply( Matrix4.scale(size, size, size) );
                Matrix4 rotate = Matrix4.IDENTITY
                .multiply( Matrix4.rotateZ(zRotation) )
                .multiply( Matrix4.rotateX(xRotation) )
                .multiply( Matrix4.rotateY(yRotation) );

                Matrix4 m = Matrix4.IDENTITY;
                m = scale.multiply(m);
                m = rotate.multiply(m);

                sunflow.parameter("points", "point", "vertex", vertices);
                sunflow.parameter("triangles", triangles);

                sunflow.geometry( name, "triangle_mesh" );
                sunflow.parameter( "shaders", currShader);
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.parameter( "transform", m );
                sunflow.instance( name + ".instance", name );
        }

        /**
         * draws a bezier patch
         * @param name individual name of primitive
         * @param subdivs int value of how much subdivisions
         * @param smooth boolean is bezier patch set to smooth
         * @param quads boolean if patch uses quads
         * @param nu number of points in vertical direction
         * @param nv number of points in horizontal direction
         * @param uwrap boolean ? best is to use false
         * @param vwrap boolean ? best is to use false
         * @param points Float array with coordinates (like [x0,y0,z0,x1,y1,z1,x2,y2,z2])
         */
        public void drawBezierMesh(String name, int subdivs, boolean smooth, boolean quads, int nu, int nv, boolean uwrap, boolean vwrap, float[] points) {
                sunflow.parameter("subdivs", subdivs);
                sunflow.parameter("smooth", smooth);
                sunflow.parameter("quads", quads);
                sunflow.parameter("nu", nu);
                sunflow.parameter("nv", nv);
                sunflow.parameter("uwrap", uwrap);
                sunflow.parameter("vwrap", vwrap);
                sunflow.parameter("points", "point", "vertex", points);

                sunflow.geometry( name, "bezier_mesh" );
                sunflow.parameter( "shaders", currShader);
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.instance( name + ".instance", name );
        }

        /**
         * draws a sphere
         * @param name Individual name
         */
        public void drawSphere(String name) {
                sunflow.geometry( name, "sphere" );
                sunflow.parameter( "shaders", currShader);
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.instance( name + ".instance", name );
        }
        /**
         * draws a sphere
         * @param name Individual name
         * @param x x position
         * @param y y position
         * @param z z position
         * @param size size
         */
        public void drawSphere(String name, float x, float y, float z, float size) {
                Matrix4 translate = Matrix4.IDENTITY.multiply( Matrix4.translation(x, y, z ));
                Matrix4 scale = Matrix4.IDENTITY.multiply( Matrix4.scale(size, size, size) );

                Matrix4 m = Matrix4.IDENTITY;
                m = scale.multiply(m);
                m = translate.multiply(m);

                sunflow.geometry( name, "sphere" );
                sunflow.parameter( "shaders", currShader);
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.parameter( "transform", m );
                sunflow.instance( name + ".instance", name );
        }
        /**
         * Draws a box
         * @param name Individual name
         */
        public void drawBox(String name) {
                sunflow.geometry( name, "box" );
                sunflow.parameter( "shaders", currShader);
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.instance( name + ".instance", name );
        }
        /**
         * Draws a box
         * @param name
         * @param name Individual name
         * @param x x position
         * @param y y position
         * @param z z position
         * @param size size
         */
        public void drawBox(String name, float x, float y, float z, float size) {
                Matrix4 translate = Matrix4.IDENTITY.multiply( Matrix4.translation(x, y, z ));
                Matrix4 scale = Matrix4.IDENTITY.multiply( Matrix4.scale(size, size, size) );

                Matrix4 m = Matrix4.IDENTITY;
                m = scale.multiply(m);
                m = translate.multiply(m);

                sunflow.geometry( name, "box" );
                sunflow.parameter( "shaders", currShader);
                sunflow.parameter( "transform", m );
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.instance( name + ".instance", name );
        }

        /**
         * Draws a box
         * @param name
         * @param name Individual name
         * @param x x position
         * @param y y position
         * @param z z position
         * @param size size
         * @param xRotation x rotation
         * @param yRotation y rotation
         * @param zRotation z rotation
         */
        public void drawBox(String name, float size, float x, float y, float z, float xRotation, float yRotation, float zRotation) {
                Matrix4 translate = Matrix4.IDENTITY.multiply( Matrix4.translation(x, y, z ));
                Matrix4 scale = Matrix4.IDENTITY.multiply( Matrix4.scale(size, size, size) );
                Matrix4 rotate = Matrix4.IDENTITY
                .multiply( Matrix4.rotateZ(zRotation) )
                .multiply( Matrix4.rotateX(xRotation) )
                .multiply( Matrix4.rotateY(yRotation) );

                Matrix4 m = Matrix4.IDENTITY;
                m = scale.multiply(m);
                m = rotate.multiply(m);
                m = translate.multiply(m);

                sunflow.geometry( name, "box" );
                sunflow.parameter( "shaders", currShader);
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.parameter( "transform", m );
                sunflow.instance( name + ".instance", name );
        }

        /**
         * Draws a box
         * @param name
         * @param name Individual name
         * @param xSize size on x axis
         * @param ySize size on y axis
         * @param zSize size on z axis
         * @param x x position
         * @param y y position
         * @param z z position
         * @param xRotation x rotation
         * @param yRotation y rotation
         * @param zRotation z rotation
         */
        public void drawBox(String name, float xSize, float ySize, float zSize, float x, float y, float z, float xRotation, float yRotation, float zRotation) {
                Matrix4 translate = Matrix4.IDENTITY.multiply( Matrix4.translation(x, y, z ));
                Matrix4 scale = Matrix4.IDENTITY.multiply( Matrix4.scale(xSize, ySize, zSize) );
                Matrix4 rotate = Matrix4.IDENTITY
                .multiply( Matrix4.rotateZ(zRotation) )
                .multiply( Matrix4.rotateX(xRotation) )
                .multiply( Matrix4.rotateY(yRotation) );

                Matrix4 m = Matrix4.IDENTITY;
                m = scale.multiply(m);
                m = rotate.multiply(m);
                m = translate.multiply(m);

                sunflow.geometry( name, "box" );
                sunflow.parameter( "shaders", currShader);
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.parameter( "transform", m );
                sunflow.instance( name + ".instance", name );
        }

        /**
         * Draws a cylinder
         * @param name Individual name
         */
        public void drawCylinder(String name) {
                sunflow.geometry( name, "cylinder" );
                sunflow.parameter( "shaders", currShader);
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.instance( name + ".instance", name );
        }
        /**
         * Draws a cylinder
         * @param name Individual name
         * @param x x position
         * @param y y position
         * @param z z position
         * @param size size
         */
        public void drawCylinder(String name, float x, float y, float z, float size) {
                Matrix4 translate = Matrix4.IDENTITY.multiply( Matrix4.translation(x, y, z ));
                Matrix4 scale = Matrix4.IDENTITY.multiply( Matrix4.scale(size, size, size) );

                Matrix4 m = Matrix4.IDENTITY;
                m = scale.multiply(m);
                m = translate.multiply(m);

                sunflow.geometry( name, "cylinder" );
                sunflow.parameter( "shaders", currShader);
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.parameter( "transform", m );
                sunflow.instance( name + ".instance", name );
        }

        /**
         * Draws a cylinder
         * @param name Individual name
         * @param x x position
         * @param y y position
         * @param z z position
         * @param size size
         * @param xRotation x rotation
         * @param yRotation y rotation
         * @param zRotation z rotation
         */
        public void drawCylinder(String name, float x, float y, float z, float size, float xRotation, float yRotation, float zRotation) {
                Matrix4 translate = Matrix4.IDENTITY.multiply( Matrix4.translation(x, y, z ));
                Matrix4 scale = Matrix4.IDENTITY.multiply( Matrix4.scale(size, size, size) );
                Matrix4 rotate = Matrix4.IDENTITY
                .multiply( Matrix4.rotateZ(zRotation) )
                .multiply( Matrix4.rotateX(xRotation) )
                .multiply( Matrix4.rotateY(yRotation) );

                Matrix4 m = Matrix4.IDENTITY;
                m = scale.multiply(m);
                m = rotate.multiply(m);
                m = translate.multiply(m);

                sunflow.geometry( name, "cylinder" );
                sunflow.parameter( "shaders", currShader);
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.parameter( "transform", m );
                sunflow.instance( name + ".instance", name );
        }

        /**
         * Draws a Cylinder
         * @param name
         * @param name Individual name
         * @param xSize size on x axis
         * @param ySize size on y axis
         * @param zSize size on z axis
         * @param x x position
         * @param y y position
         * @param z z position
         * @param xRotation x rotation
         * @param yRotation y rotation
         * @param zRotation z rotation
         */
        public void drawCylinder(String name, float xSize, float ySize, float zSize, float x, float y, float z, float xRotation, float yRotation, float zRotation) {
                Matrix4 translate = Matrix4.IDENTITY.multiply( Matrix4.translation(x, y, z ));
                Matrix4 scale = Matrix4.IDENTITY.multiply( Matrix4.scale(xSize, ySize, zSize) );
                Matrix4 rotate = Matrix4.IDENTITY
                .multiply( Matrix4.rotateZ(zRotation) )
                .multiply( Matrix4.rotateX(xRotation) )
                .multiply( Matrix4.rotateY(yRotation) );

                Matrix4 m = Matrix4.IDENTITY;
                m = scale.multiply(m);
                m = rotate.multiply(m);
                m = translate.multiply(m);

                sunflow.geometry( name, "cylinder" );
                sunflow.parameter( "shaders", currShader);
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.parameter( "transform", m );
                sunflow.instance( name + ".instance", name );
        }

        /**
         * Draws a Banchoff Surface
         * @param name Individual name
         */
        public void drawBanchoffSurface(String name) {
                sunflow.geometry( name, "banchoff" );
                sunflow.parameter( "shaders", currShader);
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.instance( name + ".instance", name );
        }
        /**
         * Draws a Banchoff Surface
         * @param name Individual name
         * @param x x position
         * @param y y position
         * @param z z position
         * @param size size
         */
        public void drawBanchoffSurface(String name, float x, float y, float z, float size) {
                Matrix4 translate = Matrix4.IDENTITY.multiply( Matrix4.translation(x, y, z ));
                Matrix4 scale = Matrix4.IDENTITY.multiply( Matrix4.scale(size, size, size) );

                Matrix4 m = Matrix4.IDENTITY;
                m = scale.multiply(m);
                m = translate.multiply(m);

                sunflow.geometry( name, "banchoff" );
                sunflow.parameter( "shaders", currShader);
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.parameter( "transform", m );
                sunflow.instance( name + ".instance", name );
        }

        /**
         * Draws a Banchoff Surface
         * @param name Individual name
         * @param x x position
         * @param y y position
         * @param z z position
         * @param size size
         * @param xRotation x rotation
         * @param yRotation y rotation
         * @param zRotation z rotation
         */
        public void drawBanchoffSurface(String name, float x, float y, float z, float size, float xRotation, float yRotation, float zRotation) {
                Matrix4 translate = Matrix4.IDENTITY.multiply( Matrix4.translation(x, y, z ));
                Matrix4 scale = Matrix4.IDENTITY.multiply( Matrix4.scale(size, size, size) );
                Matrix4 rotate = Matrix4.IDENTITY
                .multiply( Matrix4.rotateZ(zRotation) )
                .multiply( Matrix4.rotateX(xRotation) )
                .multiply( Matrix4.rotateY(yRotation) );

                Matrix4 m = Matrix4.IDENTITY;
                m = scale.multiply(m);
                m = rotate.multiply(m);
                m = translate.multiply(m);

                sunflow.geometry( name, "banchoff" );
                sunflow.parameter( "shaders", currShader);
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.parameter( "transform", m );
                sunflow.instance( name + ".instance", name );
        }



        /**

         * Draws a Julia

         * @param name Individual name

         * @param x x position

         * @param y y position

         * @param z z position

         * @param size size

         * @param xRotation x rotation

         * @param yRotation y rotation

         * @param zRotation z rotation



         * @param float[] q = four quaternization variables

         * @param int iterations = level of detail

         * @param float epsilon = level of accuracy

         */



        public void drawJulia(String name, float x, float y, float z, float size, float xRotation, float yRotation, float zRotation, float[] q, int iterations, float epsilon) {

                Matrix4 translate = Matrix4.IDENTITY.multiply( Matrix4.translation(x, y, z ));
                Matrix4 scale = Matrix4.IDENTITY.multiply( Matrix4.scale(size, size, size) );
                Matrix4 rotate = Matrix4.IDENTITY
                .multiply( Matrix4.rotateZ(zRotation) )
                .multiply( Matrix4.rotateX(xRotation) )
                .multiply( Matrix4.rotateY(yRotation) );

                Matrix4 m = Matrix4.IDENTITY;
                m = scale.multiply(m);
                m = rotate.multiply(m);
                m = translate.multiply(m);

                sunflow.parameter("iterations", iterations);
                sunflow.parameter("epsilon", epsilon);

        sunflow.parameter("cw", q[0]);
        sunflow.parameter("cx", q[1]);
        sunflow.parameter("cy", q[2]);
        sunflow.parameter("cz", q[3]);

                sunflow.geometry( name, "julia" );
                sunflow.parameter( "shaders", currShader);

                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.parameter( "transform", m );
                sunflow.instance( name + ".instance", name );

        }


        /**
         * Draws a SphereFlake (note: requires Sunflow version 0.07.3)

         * @param level = numbers of iterative levels ranging from 0 to 20
         * @param axis = axis orientation
         * @param radius = radius for the inititial sphere
         */

        public void drawSphereFlake(String name, int level, Vector3 axis, float radius) {
                sunflow.parameter("level", level);
                sunflow.parameter("axis", axis);
                sunflow.parameter("radius", radius);

                sunflow.geometry( name, "sphereflake" );
                sunflow.parameter( "shaders", currShader);
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.instance( name + ".instance", name );
        }

        /**
         * Draws a SphereFlake (note: requires Sunflow version 0.07.3)
         * @param name Individual name
         * @param x x position
         * @param y y position
         * @param z z position
         * @param size size
         * @param xRotation x rotation
         * @param yRotation y rotation
         * @param zRotation z rotation

         * @param level = numbers of iterative levels ranging from 0 to 20
         * @param axis = axis orientation
         * @param radius = radius for the inititial sphere
         */

        public void drawSphereFlake(String name, float x, float y, float z, float size, float xRotation, float yRotation, float zRotation,
        int level, Vector3 axis, float radius) {
                Matrix4 translate = Matrix4.IDENTITY.multiply( Matrix4.translation(x, y, z ));
                Matrix4 scale = Matrix4.IDENTITY.multiply( Matrix4.scale(size, size, size) );
                Matrix4 rotate = Matrix4.IDENTITY
                .multiply( Matrix4.rotateZ(zRotation) )
                .multiply( Matrix4.rotateX(xRotation) )
                .multiply( Matrix4.rotateY(yRotation) );

                Matrix4 m = Matrix4.IDENTITY;
                m = scale.multiply(m);
                m = rotate.multiply(m);
                m = translate.multiply(m);

                sunflow.parameter("level", level);
                sunflow.parameter("axis", axis);
                sunflow.parameter("radius", radius);

                sunflow.geometry( name, "sphereflake" );
                sunflow.parameter( "shaders", currShader);
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.parameter( "transform", m );
                sunflow.instance( name + ".instance", name );
        }

        /**
         * set background
         * @param name Individual name
         */
        public void setBackground(String name) {
                sunflow.geometry( name, "background" );
                sunflow.parameter( "shaders", currShader);
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.instance( name + ".instance", name );
        }

        /**
         * draw hair object
         * @param name Individual Name
         * @param segments ?
         * @param points start of hair ?
         * @param widths hairwidth ?
         */
        public void drawHair(String name, int segments, float[] points, float[] widths) {
                sunflow.parameter("segments", segments);
                sunflow.parameter("widths", "float", "none", widths);
                sunflow.parameter("points", "point", "vertex", points);

                sunflow.geometry( name, "hair" );
                sunflow.parameter( "shaders", currShader);
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.instance( name + ".instance", name );

        }

        /**
         * draw a particle surface object
         * @param name Individual name
         * @param particles float array with particle positions
         * @param radius object radius ?
         * @param num Number of Particles
         */
        public void drawParticleSurface(String name, float[] particles, float radius, int num) {
                sunflow.parameter("particles", "point", "vertex", particles);
                sunflow.parameter("num", num);
                sunflow.parameter("radius", radius);

                sunflow.geometry( name, "particles" );
                sunflow.parameter( "shaders", currShader);
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.instance( name + ".instance", name );
        }
        /**
         * Draw a plane
         * @param name Individual name
         * @param center center of plane
         * @param normal normal of plane
         */
        public void drawPlane(String name, Point3 center, Vector3 normal) {
                sunflow.parameter("center", center);
                sunflow.parameter("normal", normal);

                sunflow.geometry( name, "plane" );
                sunflow.parameter( "shaders", currShader);
                if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.instance( name + ".instance", name );
        }

        /*
         * END OF PRIMITIVES
         * --------------------------------------------------------------------------------------
         */

        /*
     * --------------------------------------------------------------------------------------
     * MY OWN SHAPES
     */

    /**
     * takes points, uses first point as center and connects the rest to it using triangles
     * one can draw circles or weird other types of shapes
     *
     * @param name Individual name
     * @param points a float array of Point3s.
     */
    public void drawCircularShape(String name, Point3[] points) {
//       vertex amount
        int verticesLength = points.length*3;
        int trianglesLength = points.length-1;
        float[] vertices = new float[verticesLength];
        int[] triangles = new int[trianglesLength];

        // create vertices array
        int verticesIndex = 0;
        for(int i=0;i<points.length;i++) {
            vertices[verticesIndex++] = points[i].x; // x value
            vertices[verticesIndex++] = points[i].y; // y value
            vertices[verticesIndex++] = points[i].z; // z value
        }
        // create triangles array
        int trianglesIndex = 0;
        int runx = 0;
        for(int i=0;i<trianglesLength;i++) {
            if(runx == 0) triangles[i] = 0; // center point is always first in vertices array
            if(runx == 1) triangles[i] = i-2;//i; // point 2
            if(runx == 2) triangles[i] = i;// i+1; // point 3

            if(runx == 2) runx = 0;
            else runx++;
        }
        triangles[trianglesIndex++] = 0; // center point is always first in vertices array
        triangles[trianglesIndex++] = points.length-1; // point 2
        triangles[trianglesIndex++] = 1; // point 3

        sunflow.parameter("points", "point", "vertex", vertices);
        sunflow.parameter("triangles", triangles);

        sunflow.geometry( name, "triangle_mesh" );
        sunflow.parameter( "shaders", currShader);
        if(isModifiers) sunflow.parameter("modifiers", currModifier);
                sunflow.instance( name + ".instance", name );
    }


    /**
     * draws a rectangle
     * @name individual name
     * @param first corner
     * @param second corner
     * @param third corner
     * @param fourth corner
     */
    public void rect(String name, Point3 corner0, Point3 corner1, Point3 corner2, Point3 corner3) {
        // define vertices
        float[] vertices = {corner0.x, corner0.y, corner0.z,
                        corner1.x, corner1.y, corner1.z,
                        corner2.x, corner2.y, corner2.z,
                        corner3.x, corner3.y, corner3.z};
        // define triangles
        int[] triangles = {0,1,2,0,2,3};
        // draw mesh
        this.drawMesh(name, vertices, triangles);
    }

    /*
     * MY OWN SHAPES
     * --------------------------------------------------------------------------------------
     */

        /*
         * --------------------------------------------------------------------------------------
         * CAMERAS
         */

        /**
         * sets Camera Position
         * @param x x value
         * @param y y value
         * @param z z value
         */
        public void setCameraPosition(float x, float y, float z) {
                eye = new Point3(x, y, z);
                // update current camera
                resetCamera();
        }
        /**
         * sets camera target (look at)
         * @param x x value
         * @param y y value
         * @param z z value
         */
        public void setCameraTarget(float x, float y, float z) {
                target = new Point3(x, y, z);
                // update current camera
                resetCamera();
        }
        /**
         * ? camera direction/rotation?
         * @param value0
         * @param value1
         * @param value2
         */
        public void setCameraUp(float value0, float value1, float value2) {
                up = new Vector3(value0, value1, value2);
                // update current camera
                resetCamera();
        }
        /**
         * set a pinhole camera
         * @param name Individual Name
         * @param fov Field of View
         * @param aspect Aspect Ratio
         */
        public void setPinholeCamera(String name, float fov, float aspect) {
                // save parameters
                this.currCamera = name;
                this.fov = fov;
                this.aspect = aspect;
                this.cameraType = this.CAMERA_PINHOLE;

                // set currCamera for rendering
                currCamera = name;

                sunflow.parameter("transform", Matrix4.lookAt(eye, target, up));
                sunflow.parameter("fov", fov);
                sunflow.parameter("aspect", aspect);
                sunflow.parameter("shift.x", shiftX);
                sunflow.parameter("shift.y", shiftY);

                sunflow.camera(name, CAMERA_PINHOLE);
        }
        /**
         * set a pinhole camera
         * @param name Individual Name
         * @param fov Field of View
         * @param aspect Aspect Ratio
         * @param shiftX ?
         * @param shiftY ?
         */
        public void setPinholeCamera(String name, float fov, float aspect, float shiftX, float shiftY) {
                // save parameters
                this.currCamera = name;
                this.fov = fov;
                this.aspect = aspect;
                this.shiftX = shiftX;
                this.shiftY = shiftY;
                this.cameraType = this.CAMERA_PINHOLE;

                // set currCamera for rendering
                currCamera = name;

                sunflow.parameter("transform", Matrix4.lookAt(eye, target, up));
                sunflow.parameter("fov", fov);
                sunflow.parameter("aspect", aspect);
                sunflow.parameter("shift.x", shiftX);
                sunflow.parameter("shift.y", shiftY);

                sunflow.camera(name, CAMERA_PINHOLE);
        }

        /**
         * Set thinlens camera
         * @param name Individual name
         * @param fov Field of View
         * @param aspect Aspect ratio
         */
        public void setThinlensCamera(String name, float fov, float aspect) {
                // save parameters
                this.currCamera = name;
                this.fov = fov;
                this.aspect = aspect;
                this.cameraType = this.CAMERA_THINLENS;

                // save parameters
                this.fov = fov;
                this.aspect = aspect;
//              set currCamera for rendering
                currCamera = name;

                sunflow.parameter("transform", Matrix4.lookAt(eye, target, up));
                sunflow.parameter("fov", fov);
                sunflow.parameter("aspect", aspect);

                sunflow.camera(name, CAMERA_THINLENS);
        }

        /**
         * Set thinlens camera
         * @param name Individual name
         * @param fov Field of View
         * @param aspect Aspect ratio
         * @param shiftX ?
         * @param shiftY ?
         * @param focusDistance focal blur setting
         * @param lensRadius Lens radius
         * @param sides < 3 means use circular lens
         * @param lensRotation this rotates polygonal lenses
         */
        public void setThinlensCamera(String name, float fov, float aspect, float shiftX, float shiftY, float focusDistance, float lensRadius, int sides, float lensRotation) {
                // save parameters
                this.currCamera = name;
                this.fov = fov;
                this.aspect = aspect;
                this.shiftX = shiftX;
                this.shiftY = shiftY;
                this.focusDistance = focusDistance;
                this.lensRadius = lensRadius;
                this.sides = sides;
                this.lensRotation = lensRotation;
                this.cameraType = this.CAMERA_THINLENS;

                // set currCamera for rendering
                currCamera = name;

                sunflow.parameter("transform", Matrix4.lookAt(eye, target, up));
                sunflow.parameter("fov", fov);
                sunflow.parameter("aspect", aspect);
                sunflow.parameter("shift.x", shiftX);
                sunflow.parameter("shift.y", shiftY);
                sunflow.parameter("focus.distance", focusDistance);
                sunflow.parameter("lens.radius", lensRadius);
                sunflow.parameter("lens.sides", sides);
                sunflow.parameter("lens.rotation", lensRotation);

                sunflow.camera(name, CAMERA_THINLENS);
        }

        /**
         * set fisheye camera
         * @param name Individual name
         */
        public void setFisheyeCamera(String name) {
//              set currCamera for rendering
                this.currCamera = name;

                sunflow.parameter("transform", Matrix4.lookAt(eye, target, up));

                sunflow.camera(name, CAMERA_FISHEYE);
        }

        /**
         * set spherical camera
         * @param name Individual name
         */
        public void setSphericalCamera(String name) {
//              set currCamera for rendering
                this.currCamera = name;

                sunflow.parameter("transform", Matrix4.lookAt(eye, target, up));

                sunflow.camera(name, CAMERA_SPHERICAL);
        }
        /**
         * resends current camera parameters to sunflow
         * one has to do that after having updated the position for example
         */
        private void resetCamera() {
                sunflow.remove(currCamera);
                if(cameraType == this.CAMERA_FISHEYE) {
                        this.setFisheyeCamera(currCamera);
                } else if(cameraType == this.CAMERA_PINHOLE) {
                        this.setPinholeCamera(currCamera, fov, aspect, shiftX, shiftY);
                } else if(cameraType == this.CAMERA_SPHERICAL) {
                        this.setSphericalCamera(currCamera);
                } else if(cameraType == this.CAMERA_THINLENS) {
                        this.setThinlensCamera(currCamera, fov, aspect, shiftX, shiftY, focusDistance, lensRadius, sides, lensRotation);
                }
        }

        /*
         * END OF CAMERAS
         * --------------------------------------------------------------------------------------
         */

        /*
         * --------------------------------------------------------------------------------------
         * GLOBAL ILLUMINATION ENGINE
         */

        /**
         * sets ambient occlusion gi engine
         * @param bright
         * @param dark
         * @param samples
         * @param maxDist
         */
        public void setAmbientOcclusionEngine(Color bright, Color dark, int samples, float maxDist) {
                sunflow.parameter("gi.engine", GI_AMBIENT_OCCLUSION);
                sunflow.parameter("gi.ambocc.bright", colorSpace, bright.getRed()/(float)255, bright.getGreen(), bright.getBlue());
                sunflow.parameter("gi.ambocc.dark", colorSpace, dark.getRed()/(float)255, dark.getGreen(), dark.getBlue());
                sunflow.parameter("gi.ambocc.samples", samples);
                sunflow.parameter("gi.ambocc.maxdist", maxDist);
        }

        /**
         * sets fake gi engine
         * @param up ?
         * @param sky Sky Color
         * @param ground Ground Color
         */
        public void setFakeGIEngine(Vector3 up, Color sky, Color ground) {
                sunflow.parameter("gi.engine", GI_FAKE);
                sunflow.parameter("gi.fake.up", up);
                sunflow.parameter("gi.fake.sky", colorSpace, sky.getRed()/(float)255, sky.getGreen(), sky.getBlue());
                sunflow.parameter("gi.fake.ground", colorSpace, ground.getRed()/(float)255, ground.getGreen()/(float)255, ground.getBlue()/(float)255);
        }
        /**
         * sets Instant Gi Engine
         * @param samples Detail, the higher the slower and smoother
         * @param sets ?
         * @param c ?
         * @param bias_samples ?
         */
        public void setInstantGIEngine(int samples, int sets, float c, int bias_samples) {
                sunflow.parameter("gi.engine", GI_INSTANT_GI);
                sunflow.parameter("gi.igi.samples", samples);
                sunflow.parameter("gi.igi.sets", sets);
                sunflow.parameter("gi.igi.c", c);
                sunflow.parameter("gi.igi.bias_samples", bias_samples);
        }
        /**
         * sets Irradiance Cache GI Engine
         * @param samples Detail, the higher the slower and smoother
         * @param tolerance ?
         * @param minSpacing ?
         * @param maxSpacing ?
         * @param globalphotonmap ?
         */
        public void setIrradianceCacheGIEngine(int samples, float tolerance, float minSpacing, float maxSpacing, String globalphotonmap){
                sunflow.parameter("gi.engine", GI_IRRADIANCE_CACHE);
                sunflow.parameter("gi.irr-cache.samples", samples);
                sunflow.parameter("gi.irr-cache.tolerance", tolerance);
                sunflow.parameter("gi.irr-cache.min_spacing", minSpacing);
                sunflow.parameter("gi.irr-cache.max_spacing", maxSpacing);
                sunflow.parameter("gi.irr-cache.gmap", globalphotonmap);
        }
        /**
         * sets path tracing gi engine
         * @param samples Detail, the higher the slower and smoother
         */
        public void setPathTracingGIEngine(int samples) {
                sunflow.parameter("gi.engine", GI_PATH);
                sunflow.parameter("gi.path.samples", samples);
        }

        /*
         * END OF GLOBAL ILLUMINATION ENGINE
         * --------------------------------------------------------------------------------------
         */

        /**
         * Sets color Space, default is COLORSPACE_SRGB_NONLINEAR
         * @param theColorSpace either COLORSPACE_SRGB_NONLINEAR, COLORSPACE_SRGB_LINEAR, or COLORSPACE_XYZ
         */
        public void setColorSpace(String theColorSpace) {
                if(theColorSpace == COLORSPACE_SRGB_NONLINEAR) colorSpace = theColorSpace;
                else if(theColorSpace == COLORSPACE_SRGB_LINEAR) colorSpace = theColorSpace;
                else if(theColorSpace == COLORSPACE_XYZ) colorSpace = theColorSpace;
                else System.out.println("Colorspace not found, keeping current one");
        }
        /**
         * sets bucket order
         * @param newBucketOrder bucket order type
         */
        public void setBucketOrder(String newBucketOrder) {
                if(newBucketOrder == this.BUCKET_ORDER_COLUMN) this.currBucketOrder = this.BUCKET_ORDER_COLUMN;
                if(newBucketOrder == this.BUCKET_ORDER_DIAGONAL) this.currBucketOrder = this.BUCKET_ORDER_DIAGONAL;
                if(newBucketOrder == this.BUCKET_ORDER_HILBERT) this.currBucketOrder = this.BUCKET_ORDER_HILBERT;
                if(newBucketOrder == this.BUCKET_ORDER_RANDOM) this.currBucketOrder = this.BUCKET_ORDER_RANDOM;
                if(newBucketOrder == this.BUCKET_ORDER_SPIRAL) this.currBucketOrder = this.BUCKET_ORDER_SPIRAL;
                if(newBucketOrder == this.BUCKET_ORDER_ROW) this.currBucketOrder = this.BUCKET_ORDER_ROW;
        }
        /**
         * returns bucket order type
         * @return String
         */
        public String getBucketOrder() {
                return currBucketOrder;
        }
        /**
         * creates background
         * @param red
         * @param green
         * @param blue
         */
        public void setBackground(float red, float green, float blue){
                sunflow.parameter("color", null, red, green, blue);
                removeBackground();
                sunflow.shader("background.shader", "constant");
                sunflow.geometry("internal_background", "background");
                sunflow.parameter("shaders", "background.shader");
                sunflow.instance("internal_background.instance", "internal_background");
        }
        public void removeBackground() {
                if(sunflow.lookupGeometry("internal_background") != null) sunflow.remove("internal_background");
        }
        public void render(){
//              rendering options
                sunflow.parameter("camera", currCamera);
                sunflow.parameter("resolutionX", width);
                sunflow.parameter("resolutionY", height);
                sunflow.parameter("aa.min", aaMin);
                sunflow.parameter("aa.max", aaMax);
                sunflow.parameter("bucket.order", currBucketOrder);
                sunflow.parameter("filter", currFilter);
                sunflow.options(SunflowAPI.DEFAULT_OPTIONS);
                sunflow.render(SunflowAPI.DEFAULT_OPTIONS, windowDisplay);
        }
        public void render(boolean isPreview) {
                if (isPreview) {
                        sunflow.parameter("camera", currCamera);
                        sunflow.parameter("resolutionX", width);
                        sunflow.parameter("resolutionY", height);
                        sunflow.parameter("aa.min", previewAaMin);
                        sunflow.parameter("aa.max", previewAaMax);
                        sunflow.parameter("bucket.order", this.BUCKET_ORDER_SPIRAL);
                        sunflow.options(SunflowAPI.DEFAULT_OPTIONS);
                        sunflow.render(SunflowAPI.DEFAULT_OPTIONS, windowDisplay);
                } else {
                        render();
                }
        }
        public void render(String fileName) {
//              rendering options
                sunflow.parameter("camera", currCamera);
                sunflow.parameter("resolutionX", width);
                sunflow.parameter("resolutionY", height);
                sunflow.parameter("aa.min", aaMin);
                sunflow.parameter("aa.max", aaMax);
                sunflow.parameter("bucket.order", currBucketOrder);
                sunflow.parameter("filter", currFilter);
                sunflow.options(SunflowAPI.DEFAULT_OPTIONS);
                fileDisplay = new FileDisplay(fileName);
                sunflow.render(SunflowAPI.DEFAULT_OPTIONS, fileDisplay);
        }
        public void render(boolean isPreview, String fileName) {
                if (isPreview) {
                        sunflow.parameter("camera", currCamera);
                        sunflow.parameter("resolutionX", width);
                        sunflow.parameter("resolutionY", height);
                        sunflow.parameter("aa.min", previewAaMin);
                        sunflow.parameter("aa.max", previewAaMax);
                        sunflow.parameter("bucket.order", this.BUCKET_ORDER_SPIRAL);
                        sunflow.options(SunflowAPI.DEFAULT_OPTIONS);
                        fileDisplay = new FileDisplay(fileName);
                        sunflow.render(SunflowAPI.DEFAULT_OPTIONS, fileDisplay);
                } else {
                        render(fileName);
                }
        }
        /**
         * remove sunflow object. function checks if object is existing first
         * @param name
         */
        public void removeObject(String name) {
                if(sunflow.lookupGeometry(name) != null) sunflow.remove(name);
        }
        /*
         * remove sunflow shader. function checks if object ist existing first
         * @param name
         */
        public void removeShader(String name) {
                if(sunflow.lookupShader(name) != null) sunflow.remove(name);
        }
        /*
         * remove sunflow modifier. function checks if object ist existing first
         * @param name
         */
        public void removeModifier(String name) {
                if(sunflow.lookupModifier(name) != null) sunflow.remove(name);
        }

        public SunflowAPI sunflowObject() {
                return sunflow;
        }

        public int getWidth() {
                return width;
        }

        public void setWidth(int width) {
                this.width = width;
        }

        public int getHeight() {
                return height;
        }

        public void setHeight(int height) {
                this.height = height;
        }

        public int getAaMin() {
                return aaMin;
        }

        public void setAaMin(int aaMin) {
                this.aaMin = aaMin;
        }

        public int getAaMax() {
                return aaMax;
        }

        public void setAaMax(int aaMax) {
                this.aaMax = aaMax;
        }

        /*
         * --------------------------------------------------------------------------------------
         * UTILITIES
         */

        /**
         * writes basic settings (camera, light, shader)
         * note: one still has to set the ambient occlusion shader
         * @param sceneWidth width of rendering
         * @param sceneHeight height of rendering
         */
        public void setBasicScene(int sceneWidth, int sceneHeight) {
                // set width and height
                this.setWidth(sceneWidth);
                this.setHeight(sceneHeight);
                // set camera
                this.setCameraPosition(0, 2, 15);
                this.setThinlensCamera("thinLensCamera", 50f, (float)sceneWidth/sceneHeight);
                // set basic light
                this.setSunSkyLight("mySunskyLight");
                this.setPointLight("myPointLight", new Point3(0,5,5), new Color(255,255,255));
                this.setDirectionalLight("myDirectionalLight", new Point3(-2,3,0), new Vector3(0,0,0), 3, new Color(1f,0f,0f));
                // set shader
                this.setAmbientOcclusionShader("myAmbientOcclusionShader", new Color(255,255,255), new Color(0,0,0), 16, 1);
                // draw a ground plane
                this.drawPlane("internal_basic_ground", new Point3(0,0,0), new Vector3(0,1,0));
        }

        /*
         * END OF UTILITIES
         * --------------------------------------------------------------------------------------
         */
}
