final String negativeSpaceFile = "../assets/award.png";
final String collageFileBase = "../assets/icons/avengerc";
final String collageFileSuffix = ".png";

final float globalMaxScale = 2.0;
final float globalMinScale = 0.5;

float opacityValue = 1;

PImage negativeImage;
ArrayList<PImage> collagePics;
ArrayList<CollageItem> collageItems;

PGraphics collage;

CollageItem testItem;

float upShift;

boolean saved=true;

void setup() {
  size(1080, 1920);
  //noLoop();

  upShift = 0;

  collage = createGraphics(1080, 1920);
  collagePics = loadImages();

  collageItems = loadCollage("savedata.txt");
  
  negativeImage = loadImage(negativeSpaceFile);
  negativeImage.loadPixels();
  
  if(collageItems == null) {
    collageItems = new ArrayList<CollageItem>();
    generateCollage(4000);
    saved=false;
  }

  //blurImages();

  collage.beginDraw();
  collage.imageMode(CENTER);
  collage.tint(255, opacityValue*255);
  for (CollageItem c : collageItems)
    c.show(collage);
  collage.endDraw();

  //testItem = new CollageItem(collagePics.get(2), new PVector(width/2, height*2/3));
  //println(negativeImage.pixels.length);
}

void draw() {
  background(255, 217, 0);
  //drawMask(negativeImage);
  image(collage, 0, upShift);
  //testItem.show();
  if (keyPressed) {
    if (key == CODED) {
      switch(keyCode) {
      case UP:
        upShift = max(upShift-3, -height);
        break;
      case DOWN:
        upShift = min(upShift+3, 0);
        break;
      }
    } else {
      if(key == ' ' && !saved) {
        saveCollage("savedata.txt");
      } else {
        
      }image(negativeImage, 0, upShift);
    }
  }
}

void mouseClicked() {
  saveFrame(getDateTime() + ".png");
}

void saveCollage(String s) {
  PrintWriter output = createWriter(s);
  for (CollageItem c : collageItems) {
    output.println(c);
  }
  output.flush();
  output.close();
}

ArrayList<CollageItem> loadCollage(String s) {
  BufferedReader input = createReader(s);
  if(input == null) {
    return null;
  }
  ArrayList<CollageItem> collage = new ArrayList<CollageItem>();
  String line = null;
  int count = 0;
  try {
    while ((line = input.readLine()) != null) {
      println("Loading line " + (count++) + ".");
      collage.add(fromString(line));
    }
    input.close();
  } catch (IOException e) {
    println("Uh oh spaghetti-o.");
    return null;
  }
  return collage;
}

String getDateTime() {
  return month()+"-"+day()+"-"+year()+"-"+hour()+";"+minute()+";"+second();
}

void generateCollage(int count) {
  int i = 0;
  int failCount = 0;
  while (i < count) {
    println("Starting item "+i+".");
    int index = floor(random(collagePics.size()));
    CollageItem newItem = new CollageItem(index);
    if (newItem.checkCollision(negativeImage)) {
      if (newItem.scaleDown()) {
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
  for (int i = 0; i < img.pixels.length; i++) {
    if (alpha(img.pixels[i]) != 0) {
      int bkgPixel = i + floor(upShift*width);
      if (bkgPixel < 0) {
        continue;
      }
      pixels[bkgPixel] = color(255, 0, 0);
    }
  }
  updatePixels();
}

void blurImages() {
  int size = collageItems.size();
  for(int i = 0; i < size; i++) {
    collageItems.get(i).blur(map(i, 0, size, 4, 0));
  }
}

ArrayList<PImage> loadImages() {
  ArrayList<PImage> arr = new ArrayList<PImage>();
  int i = 0;
  while (true) {
    PImage tempImg = loadImage(collageFileBase + leadZeroes(++i, 2) + collageFileSuffix);
    if (tempImg != null) {
      arr.add(tempImg);
      continue;
    } else {
      return arr;
    }
  }
}

CollageItem fromString(String s) {
  String[] params = s.split(" ");
  int index = Integer.parseInt(params[0]);
  PVector pos = new PVector(Float.parseFloat(params[1]), Float.parseFloat(params[2]));
  float scale = Float.parseFloat(params[3]);
  float rot = Float.parseFloat(params[4]);
  //println("Making CollageItem with index "+index+", pos ("+pos.x+","+pos.y+"), scale "+scale+" and angle "+rot+".");
  return new CollageItem(index, pos, scale, rot);
}

String leadZeroes(int x, int chars) {
  String s = ""+x;
  while (s.length() < chars)
    s = '0'+s;
  return s;
}
