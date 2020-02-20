class CollageItem {
  
  int index;
  PImage img;
  PVector pos;
  float scale;
  float rot;
  
  public CollageItem(int index, PVector pos, float scale, float rot) {
    this.index = index;
    img = collagePics.get(index).copy();
    this.pos = pos;
    this.scale = scale;
    img.resize(0,floor(100*scale));
    this.rot = rot;
  }
  
  public CollageItem(int index) {
    this.index = index;
    img = collagePics.get(index).copy();
    scale = random(0.5,2);
    img.resize(0,floor(100*scale));
    float posX = random(this.img.width/2,negativeImage.width-this.img.width/2);
    float posY = random(this.img.height/2, negativeImage.height-this.img.height/2);
    pos = new PVector(posX, posY);
    rot = random(-PI/4, PI/4);
  }
  
  void show(PGraphics pg) {
    pg.pushMatrix();
    pg.translate(pos.x, pos.y);
    pg.rotate(rot);
    pg.image(img, 0, 0);
    pg.popMatrix();
  }
  
  boolean checkCollision(PImage other) {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(rot);
    translate(-img.width/2, -img.height/2);
    img.loadPixels();
    //other.loadPixels();
    for(int i = 0; i<img.pixels.length; i++) {
      color thisPixel = img.pixels[i];
      if(alpha(thisPixel) == 0)
        continue;
      PVector imageCoord = new PVector(i%img.width, i/img.width);
      PVector screenCoord = new PVector(screenX(imageCoord.x,imageCoord.y), screenY(imageCoord.x,imageCoord.y));
      if(screenCoord.x<0 || screenCoord.x>=width || screenCoord.y<0 || screenCoord.y>=height) {
        continue;
      }
      color otherPixel = other.pixels[floor(screenCoord.y)*other.width + floor(screenCoord.x)];
      if(alpha(otherPixel) != 0) {
        popMatrix();
        return true;
      }
    }
    popMatrix();        
    return false;
  }
  
  void scaleMax() {
    float maxScale = globalMaxScale - random(0.4);
    float scaleUpVal = 1.2;
    while(!checkCollision(negativeImage) && scale < maxScale) {
      img.resize(floor(img.width*scaleUpVal), 0);
      scale *= scaleUpVal;
    }
    scaleDown();
  }
  
  boolean scaleDown() {
    float minScale = globalMinScale + random(0.2);
    float scaleDownVal = 0.9;
    while(checkCollision(negativeImage) && scale > minScale) {
      img.resize((int)(img.width*scaleDownVal),0);
      scale *= scaleDownVal;
    }
    return !checkCollision(negativeImage);
  }
  
  void blur(float rad) {
    img.filter(BLUR, rad);
  }
  
  String toString() {
    return index + " " + floor(pos.x) + " " + floor(pos.y) + " " + scale + " " + rot;
  }
}
