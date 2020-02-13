class CollageItem {
  
  PImage img;
  PVector pos;
  float scale;
  
  public CollageItem(PImage img, PVector pos) {
    this.img = img.copy();
    this.img.resize(0,100);
    this.pos = pos;
    scale = 1;
  }
  
  public CollageItem(PImage img) {
    this.img = img.copy();
    
    this.img.resize(0,floor(random(50, 200)) );
    float posX = random(this.img.width/2,negativeImage.width-this.img.width/2);
    float posY = random(this.img.height/2, negativeImage.height-this.img.height/2);
    pos = new PVector(posX, posY);
    scale = 1;
  }
  
  void show() {
    image(img, pos.x, pos.y);
  }
  
  boolean checkCollision(PImage other) {
    pushMatrix();
    translate(pos.x-img.width/2, pos.y-img.height/2);
    img.loadPixels();
    //other.loadPixels();
    for(int i = 0; i<img.pixels.length; i++) {
      color thisPixel = img.pixels[i];
      if(alpha(thisPixel) == 0)
        continue;
      PVector imageCoord = new PVector(i%img.width, i/img.width);
      PVector screenCoord = new PVector(screenX(imageCoord.x,imageCoord.y), screenY(imageCoord.x,imageCoord.y));
      if(screenCoord.x<0 || screenCoord.x>width || screenCoord.y<0 || screenCoord.y>height) {
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
