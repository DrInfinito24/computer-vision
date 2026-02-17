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
   
    
   
  opencv.calculateOpticalFlow();

   image(opencv.getInput(), 0, 0);
  stroke(255,0,0);
  opencv.drawOpticalFlow();
  
  PVector aveFlow = opencv.getAverageFlow();
  int flowScale = 50;
  stroke(255);
  strokeWeight(2);
  line(cam.width/2, cam.height/2, cam.width/2 + aveFlow.x*flowScale, cam.height/2 + aveFlow.y*flowScale);
   println(aveFlow);

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
