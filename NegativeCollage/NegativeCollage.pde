final String negativeSpaceFile = "../assets/award.png";
final String collageFileBase = "../assets/icons/avenger";
final String collageFileSuffix = ".png";

final float maxScale = 1.6;
final float minScale = 0.8;

PImage negativeImage;
ArrayList<PImage> collagePics;
ArrayList<CollageItem> collageItems;

PGraphics collage;

CollageItem testItem;

float upShift;

void setup() {
  size(1080,1920);
  //noLoop();
  
  upShift = -height/3;
  
  collage = createGraphics(1080,1920);
  
  negativeImage = loadImage(negativeSpaceFile);
  negativeImage.loadPixels();
  collagePics = loadImages();
  collageItems = new ArrayList<CollageItem>();
  
  generateCollage(2500);
  
  collage.beginDraw();
  collage.imageMode(CENTER);
  for(CollageItem c : collageItems)
    collage.image(c.img, c.pos.x, c.pos.y);
  collage.endDraw();
  
  //testItem = new CollageItem(collagePics.get(2), new PVector(width/2, height*2/3));
  println(negativeImage.pixels.length);
 
}

void draw() {
  background(218, 165, 32);
  //drawMask(negativeImage);
  image(collage, 0, upShift);
  //testItem.show();
  if(keyPressed) {
    if(key == CODED) {
      switch(keyCode) {
        case UP:
          upShift-=3;
          break;
        case DOWN:
          upShift+=3;
          break;
      }
    } else {
      image(negativeImage, 0, upShift);
    }
  }
  //saveFrame(getDateTime() + ".png");
}

String getDateTime() {
  return month()+"-"+day()+"-"+year()+"-"+hour()+";"+minute()+";"+second();
}

void generateCollage(int count) {
  int i = 0;
  int failCount = 0;
  while(i < count) {
    println("Starting item "+i+".");
    CollageItem newItem = new CollageItem(collagePics.get(floor(random(collagePics.size()))));
    if(newItem.checkCollision(negativeImage)) {
      if(newItem.scaleDown()) {
        collageItems.add(newItem);
      }
      failCount++;
      continue;
    } else {
      newItem.scaleMax();
      collageItems.add(newItem);
      i++;
    }
    //println("Finished item "+i+".");
  }
  println("Final fail count: " + failCount);
}

void drawMask(PImage img) {
  loadPixels();
  img.loadPixels();
  for(int i = 0; i < img.pixels.length; i++) {
    if(alpha(img.pixels[i]) != 0) {
      int bkgPixel = i + floor(upShift*width);
      if(bkgPixel < 0) {
        continue;
      }
      pixels[bkgPixel] = color(255,0,0);
    }
  }
  updatePixels();
}

ArrayList<PImage> loadImages() {
  ArrayList<PImage> arr = new ArrayList<PImage>();
  int i = 0;
  while(true) {
    PImage tempImg = loadImage(collageFileBase + leadZeroes(++i, 2) + collageFileSuffix);
    if(tempImg != null) {
      arr.add(tempImg);
      continue;
    } else {
      return arr;
    }
  }
}

String leadZeroes(int x, int chars) {
  String s = ""+x;
  while(s.length() < chars)
    s = '0'+s;
  return s;
}
