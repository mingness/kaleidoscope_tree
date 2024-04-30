int totalSlices = 8;
PImage img, slice;
PGraphics selection_mask;

void setup() {
  size(1000,1000);
  img = loadImage("trees1.jpg");
  background(0);
  selection_mask = createGraphics(width, height);
  slice = createImage(width, height, ARGB);
}

void draw() {
  //create a mask of a slice of the original image.
  selection_mask.beginDraw();
  selection_mask.noStroke();
  selection_mask.beginShape();
  //selection_mask.vertex(0,0);
  //selection_mask.vertex(selection_mask.width, 0);
  //selection_mask.vertex(width/2, ceil(float(width)/2*sin(TWO_PI/totalSlices)));
  selection_mask.arc(0,0, width, height, 0, radians(360. / totalSlices));
  selection_mask.endShape(CLOSE);
  selection_mask.endDraw();
  print(float(width)/2, " ",float(width)/2*sin(TWO_PI/totalSlices), "\n");
  
  slice = img.get(
    floor((img.width-width)*float(mouseX)/width), 
    floor((img.height-height)*float(mouseY)/height), width, height);
  slice.mask(selection_mask);
  
  //image(slice,0,0);
  
  translate(width / 2, height / 2);
  //apply slice in a circle
  for (int k = 0; k <= totalSlices; k++) {
      rotate(k * radians(360 / (totalSlices / 2)));
      image(slice, 0, 0);
      scale(-1.0, 1.0);
      image(slice, 0, 0);
  }
  resetMatrix();
}

void keyPressed() {
  switch(keyCode) {
    case UP:
      totalSlices = totalSlices+1;
      break;
    case DOWN:
      totalSlices = max(4,totalSlices-1);
      break;
    case ENTER:
      saveFrame("kaleidoscope_tree####.jpg");
  }
  
}
