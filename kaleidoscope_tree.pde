int totalSlices = 8;
PImage img, slice;
PGraphics selection_mask;

void setup() {
  size(1000,1000);
  img = loadImage("trees1.jpg");
  background(0);
  draw_mask();
  slice = createImage(width/2, height/2, ARGB);
  
  print("total slices = ", totalSlices, "\n");
}

void draw() {  
  slice = img.get(
    floor((img.width-width)*float(mouseX)/width), 
    floor((img.height-height)*float(mouseY)/height), width/2, height/2);
  slice.mask(selection_mask);
  
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
      totalSlices = totalSlices + 4;
      print("total slices = ", totalSlices, "\n");
      draw_mask();
      break;
    case DOWN:
      totalSlices = max(4, totalSlices - 4);
      print("total slices = ", totalSlices, "\n");
      draw_mask();
      break;
    case ENTER:
      saveFrame("saved_images/kaleidoscope_tree####.jpg");
  }
  
}

void draw_mask() {
  selection_mask = createGraphics(width/2, height/2);
  selection_mask.beginDraw();
  selection_mask.noStroke();
  selection_mask.beginShape();
  //selection_mask.vertex(0,0);
  //selection_mask.vertex(selection_mask.width, 0);
  //selection_mask.vertex(width/2, ceil(float(width)/2*sin(TWO_PI/totalSlices)));
  selection_mask.arc(0,0, width, height, 0, radians(360. / totalSlices));
  selection_mask.endShape(CLOSE);
  selection_mask.endDraw();
}
