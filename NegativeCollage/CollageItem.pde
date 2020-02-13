class CollageItem {
  
  PImage img;
  PVector pos;
  float scale;
  float rot;
  
  public CollageItem(PImage img, PVector pos) {
    this.img = img.copy();
    this.img.resize(0,100);
    this.pos = pos;
    rot = random(0, TWO_PI);
  }
  
  public CollageItem(PImage img) {
    this.img = img.copy();
    
    this.img.resize(0,floor(random(50, 200)) );
    float posX = random(this.img.width/2,negativeImage.width-this.img.width/2);
    float posY = random(this.img.height/2, negativeImage.height-this.img.height/2);
    pos = new PVector(posX, posY);
    rot = random(0, TWO_PI);
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
    float scaleUpVal = 1.2;
    float scaleMem = 1;
    while(!checkCollision(negativeImage) && scaleMem < maxScale) {
      img.resize(floor(img.width*scaleUpVal), 0);
      scaleMem *= scaleUpVal;
    }
    scaleDown();
  }
  
  boolean scaleDown() {
    float scaleDownVal = 0.9;
    float scaleMem = 1;
    while(checkCollision(negativeImage) && scaleMem > minScale) {
      img.resize((int)(img.width*scaleDownVal),0);
      scaleMem *= scaleDownVal;
    }
    return !checkCollision(negativeImage);
  }
}
