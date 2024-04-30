int totalSlices = 8;
PImage img,img1,img2,img3, slice;
PGraphics selection_mask;
String img_varname;

void setup() {
  size(1000,1000);
  img1 = loadImage("trees1.jpg");
  img2 = loadImage("trees2.jpg");
  img3 = loadImage("trees3.jpg");
  img = img1;
  img_varname = "img1";
  print("img = ", img_varname, "\n");
  draw_mask();
  slice = createImage(width/2, height/2, ARGB);
  
  print("total slices = ", totalSlices, "\n");
}

void draw() { 
  background(0);
  //image(selection_mask,0,0);
  
  slice = img.get(
    floor((img.width-width)*float(mouseX)/width), 
    floor((img.height-height)*float(mouseY)/height), width/2, height/2);
  slice.mask(selection_mask);
  
  translate(width / 2, height / 2);
  //apply slice in a circle
  for (int k = 0; k <= totalSlices; k++) {
      rotate(2*k * radians(360 / totalSlices));
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
      draw_mask();
      print("total slices = ", totalSlices, "\n");
      break;
    case DOWN:
      totalSlices = max(4, totalSlices - 4);
      draw_mask();
      print("total slices = ", totalSlices, "\n");
      break;
    case TAB:
      switch (img_varname) {
        case "img1":
          img = img2;
          img_varname = "img2";
          print("img = ", img_varname, "\n");
          break;
        case "img2":
          img = img3;
          img_varname = "img3";
          print("img = ", img_varname, "\n");
          break;
        case "img3":
          img = img1;
          img_varname = "img1";
          print("img = ", img_varname, "\n");
          break;
      }
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
    //selection_mask.arc(0,0, width, height, 0, radians(360. / totalSlices));
  if (totalSlices == 4) {
    // whole rectangle
    selection_mask.vertex(0,0);
    selection_mask.vertex(width, 0);
    selection_mask.vertex(width, height);
    selection_mask.vertex(0, height);  
  } else {
    // triangle
    selection_mask.vertex(0,0);
    selection_mask.vertex(width, 0);
    selection_mask.vertex(width, ceil(float(width)*tan(TWO_PI/totalSlices)));
  }
  selection_mask.endShape(CLOSE);
  selection_mask.endDraw();
}
