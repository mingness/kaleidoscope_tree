int totalSlices = 28;  
PImage img,img1,img2,img3, img_chunk;
PGraphics mask_shape, slice;
String img_varname;
int slice_width, slice_height, chunk_width;  // pixel lengths of slice, and chunk objects
int maskCenterX, maskCenterY;  // where image center of rotation should be
int imgX, imgY;  // center of image chunk, relative to image

float ratio_out, max_ratio_out, delta_ratio_out;
int delta = 1;
int XL, XR, YU, YD;
boolean spiral_out = true;
String spiral_leg = "TOP";
float img_rotation, delta_img_rotation = 0.005;

void settings() {
  size(1000,1000,P2D);
  //fullScreen(P2D, 0);
}

void setup() {
  img1 = loadImage("trees1.jpg");
  img2 = loadImage("trees2.jpg");
  img3 = loadImage("trees3.jpg");
  img = img1;
  img_varname = "img1";
  print("img = ", img_varname, "\n");
  imgX = img.width/2;
  imgY = img.height/2;
  
  print("total slices = ", totalSlices, "\n");
  //slice_width = width/2;
  slice_width = ceil(0.5*sqrt(float(width)*float(width) + float(height)*float(height)));  // length of half diagonal
  //slice_height = height/2;
  slice_height = slice_width;  // for now, slice is square
  chunk_width = ceil(slice_width*sqrt(2));  // wide enough to cover slice in diamond orientation

  // DEBUG
  print("slice_width = ", slice_width, "\n");
  print("chunk_width = ", chunk_width, "\n");

  
  img_chunk = createImage(chunk_width, chunk_width, ARGB); // grabs chunk of image to rotate
  slice = createGraphics(slice_width, slice_height, P2D); // image rotated. mask will be applied

  draw_mask();

// looping continuous motion
  ratio_out = 0.1;
  delta_ratio_out = 0.1;
  update_loop_limits();    
}

void draw() { 
  background(0);  
  
  update_img_zone();
  img_chunk = img.get(imgX-chunk_width/2, imgY-chunk_width/2, chunk_width, chunk_width);

  //// DEBUG
  //image(img_chunk,0,0);  

  slice.beginDraw();
  slice.translate(maskCenterX, maskCenterY);
  slice.rotate(img_rotation);
  slice.image(img_chunk,-chunk_width/2, -chunk_width/2);
  //// DEBUG
  //slice.image(img_chunk,0,0);  
  slice.endDraw();

  //// DEBUG
  //image(slice,0,0);
  
  slice.mask(mask_shape);
  
  //// DEBUG
  //image(slice,slice_width,0);
  
  translate(width/2, height/2);
  //apply slice in a circle
  for (int k = 0; k <= totalSlices; k++) {
      rotate(2*k * radians(360. / totalSlices));
      image(slice, 0, 0);
      scale(-1.0, 1.0);
      image(slice, 0, 0);
  }

  img_rotation = img_rotation+delta_img_rotation;
}


void draw_mask() {
  mask_shape = createGraphics(slice_width, slice_height, P2D);
  float angle = TWO_PI/totalSlices;
  maskCenterX = floor(float(width/4)*cos(angle/2));
  maskCenterY = floor(float(width/4)*sin(angle/2));

  mask_shape.beginDraw();
  mask_shape.noStroke();
  mask_shape.beginShape();
  mask_shape.arc(0,0, 2*slice_width, 2*slice_width, 0, angle);
  //if (totalSlices == 4) {
  //  // whole rectangle
  //  mask_shape.vertex(0,0);
  //  mask_shape.vertex(width, 0);
  //  mask_shape.vertex(width, height);
  //  mask_shape.vertex(0, height);  
  //} else {
  //  // arc works if circle
  //  mask_shape.arc(0,0, slice_width, slice_width, 0, angle);
  //}
  mask_shape.endShape(CLOSE);
  mask_shape.endDraw();
  resetMatrix();
}

void update_loop_limits() {
  XL = max(floor(img.width/2 * (1 - ratio_out)), chunk_width);
  XR = min(floor(img.width/2 * (1 + ratio_out)), img.width-chunk_width);
  YU = max(floor(img.height/2 * (1 - ratio_out)),chunk_width);
  YD = min(floor(img.height/2 * (1 + ratio_out)),img.height-chunk_width);
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
  

  //// mouse position affects center
  //imgX = floor((img.width-width)*float(mouseX)/width);
  //imgY = floor((img.height-height)*float(mouseY)/height);
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
