import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

OpenCV opencv;
Capture cam;
Rectangle[] faces;
Rectangle[] noses;

void setup() 
{
  size(10, 10);
  
  initCamera();
  opencv = new OpenCV(this, cam.width, cam.height);
  
  surface.setResizable(true);
  surface.setSize(opencv.width, opencv.height);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  
}

void draw() 
{
  if(cam.available())
  {    
    cam.read();
    cam.loadPixels();
    opencv.loadImage((PImage)cam);
    image(opencv.getInput(), 0, 0);
    faces = opencv.detect();
    for (int i = 0; i < faces.length; i++) {
      stroke(255, 0, 0);
      fill(255,0,0,100);
      strokeWeight(3);
      rect(faces[i].x,faces[i].y,faces[i].width,faces[i].height);
      opencv.setROI(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
      
      opencv.loadCascade(OpenCV.CASCADE_NOSE);  
      noses = opencv.detect();

      stroke(255, 0, 0);
      fill(255,0,0);
      strokeWeight(3);
      for (int j = 0; j < noses.length; j++) {
        float noseCentreX = faces[i].x + noses[j].x + noses[j].width/2.0;
                float noseCentreY = faces[i].y + noses[j].y + noses[j].height/2.0;
        
        circle(noseCentreX, noseCentreY, noses[j].height);
      }
      opencv.releaseROI();
      opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
    }
    

  }
}


void initCamera()
{
  String[] cameras = Capture.list();
  if (cameras.length != 0) 
  {
    println("Using camera: " + cameras[0]); 
    
    // If you receive the error "BaseSrc: [avfvideosrc0] : Internal data stream error"
    // then comment out the line below and uncomment the one below that.
    //cam = new Capture(this, cameras[0]);
    cam = new Capture(this, 640, 480, "pipeline:avfvideosrc device-index=0", 30);  
    
    cam.start();    
    
    while(!cam.available()) print();
    
    cam.read();
    cam.loadPixels();
  }
  else
  {
    println("There are no cameras available for capture.");
    exit();
  }
}
