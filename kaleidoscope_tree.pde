int totalSlices = 8;
PImage img,img1,img2,img3, slice;
PGraphics selection_mask;
String img_varname;

int imgX, imgY;
float ratio_out, max_ratio_out, delta_ratio_out;
int delta = 1;
int XL, XR, YU, YD;
boolean spiral_out = true;
String spiral_leg = "TOP";

void setup() {
  //size(1500,1000);
  fullScreen(P2D, 0);
  print("total slices = ", totalSlices, "\n");
  draw_mask();
  slice = createImage(width/2, height/2, ARGB);

  img1 = loadImage("trees1.jpg");
  img2 = loadImage("trees2.jpg");
  img3 = loadImage("trees3.jpg");
  
  img = img1;
  img_varname = "img1";
  print("img = ", img_varname, "\n");
  update_loop_limits();
    
  imgX = img.width/2;
  imgY = img.height/2;
  ratio_out = 0.1;
  delta_ratio_out = 0.1;
}

void draw() { 
  background(0);
  //image(selection_mask,0,0);
  
  update_img_zone();
  //print("imgX = ", imgX, ", imgY = ", imgY, "\n");
  slice = img.get(imgX, imgY, width/2, height/2);
  slice.mask(selection_mask);
  
  translate(width/2, height/2);
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
      iterate_img();
      break;
    case ENTER:
      saveFrame("saved_images/kaleidoscope_tree####.jpg");
  }
  
}

void iterate_img() {
  switch (img_varname) {
    case "img1":
      img = img2;
      update_loop_limits();
      img_varname = "img2";
      print("img = ", img_varname, "\n");
      break;
    case "img2":
      img = img3;
      update_loop_limits();
      img_varname = "img3";
      print("img = ", img_varname, "\n");
      break;
    case "img3":
      img = img1;
      update_loop_limits();
      img_varname = "img1";
      print("img = ", img_varname, "\n");
      break;
  }
}

void update_loop_limits() {
  XL = max(floor(img.width/2 * (1 - ratio_out)), width/2);
  XR = min(floor(img.width/2 * (1 + ratio_out)), img.width-width/2);
  YU = max(floor(img.height/2 * (1 - ratio_out)),height/2);
  YD = min(floor(img.height/2 * (1 + ratio_out)),img.height-height/2);
  max_ratio_out = min(1.-float(width)/img.width, 1.-float(height)/img.height);
  print("spiral leg = ", spiral_leg, " ratio_out = ", ratio_out, "max_ratio_out = ", max_ratio_out, XL, XR, YU, YD, "\n");        
}

void update_img_zone() {
  switch (spiral_leg) {
    case "TOP":
      imgX = imgX + delta;
      if (imgX >= XR) {
        imgX = XR;
        spiral_leg = "RIGHT";
        print("spiral leg = ", spiral_leg, " ratio_out = ", ratio_out, "\n");        
      }
      break;
    case "RIGHT":
      imgY = imgY + delta;
      if (imgY >= YD) {
        imgY = YD;
        spiral_leg = "BOTTOM";
        print("spiral leg = ", spiral_leg, " ratio_out = ", ratio_out, "\n");
      }
      break;
    case "BOTTOM":
      imgX = imgX - delta;
      if (imgX <= XL) {
        imgX = XL;
        spiral_leg = "LEFT";
        print("spiral leg = ", spiral_leg, " ratio_out = ", ratio_out, "\n");
      }
      break;
    case "LEFT":
      imgY = imgY - delta;
      if (imgY <= YU) {
        imgY = YU;
        spiral_leg = "TOP";
        print("spiral leg = ", spiral_leg, " ratio_out = ", ratio_out, "\n");

      if (spiral_out) {
        ratio_out = ratio_out + delta_ratio_out;
        if (ratio_out >= max_ratio_out) {
          spiral_out = false;
          ratio_out = ratio_out - delta_ratio_out;
        }
        update_loop_limits();
      } else {
        ratio_out = ratio_out - delta_ratio_out;
        if (ratio_out <= 0) {
          iterate_img();
          spiral_out = true;
          ratio_out = ratio_out + delta_ratio_out;
        }
        update_loop_limits();
      }

    }
      break;
  }
  

    
  //imgX = floor((img.width-width)*float(mouseX)/width);
  //imgY = floor((img.height-height)*float(mouseY)/height);
}

void draw_mask() {
  selection_mask = createGraphics(width/2, height/2, P2D);
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
