// sets the translation in the X axis
int xOrigin;

// true is the solid of revolution should be rendered
boolean renderSolid;

PShape solid;

//sideedge points
ArrayList<Point> selectedPoints; 

class Point {
  float x;
  float y;
  float z;
  
  Point(float x, float y){
    this.x = x;
    this.y = y;
    this.z = 0;
  }
  
  Point(float x, float y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

void setup(){
  size(600, 800, P3D);
  xOrigin = width/2;
  translate(xOrigin, 0);
  
  reset();
}

void reset(){
  background(0);
  stroke(color(255));
  line(0, 0, 0, height);
  text("Haz click con el ratón para dibujar el perfil.", 5 - xOrigin, 20);
  text("Después pulsa ENTER para generar la figura.", 15, 20);
  
  selectedPoints = new ArrayList<Point>();
  renderSolid = false;
}

void draw(){
  translate(xOrigin, 0);
  if(renderSolid){
    background(0);
    text("Pulsa R para volver a dibujar.", 5 - xOrigin, 20);
    shape(solid);
  }
}

void mouseClicked() {
  Point newPoint = new Point(mouseX - xOrigin, mouseY);
  selectedPoints.add(newPoint);
  // if there is already at least a point
  if( selectedPoints.size() > 1 ){
    Point prevPoint = selectedPoints.get(selectedPoints.size() - 2);
    stroke(color(255));
    // a line between last point and new point is drawn
    line(prevPoint.x, prevPoint.y, newPoint.x, newPoint.y);
  }
}

void keyPressed(){
  if( key == 'R' || key == 'r' ){
    reset();
  }
  
  if( key == ENTER ){
    revSolid();
  }
}

void revSolid(){
  
  int sideFacePoints = selectedPoints.size();
  // Points mesh
  Point[][] points = new Point[sideFacePoints][24];
  
  for(int i = 0; i < sideFacePoints; i++){
    points[i][0] = selectedPoints.get(i);
  }
  
  float angle = PI / 12; // 15º
  
  // rotates the points around Y axis
  float x1, y1, z1;
  float x2, y2, z2;
  Point p;
  for(int i = 0; i < sideFacePoints; i++){
    p = points[i][0];
    x1 = p.x;
    y1 = p.y;
    z1 = p.z;
    for(int t = 1; t < 24; t++){
      x2 = x1 * cos(angle) - z1 * sin(angle);
      y2 = y1;
      z2 = x1 * sin(angle) + z1 * cos(angle);
      points[i][t] = new Point(x2, y2, z2);
      x1 = x2;
      y1 = y2;
      z1 = z2;
    }
  }
  
  solid = createShape();
  
  solid.beginShape(TRIANGLE_STRIP);
  solid.fill(255);
  solid.stroke(color(93, 193, 185));
  solid.strokeWeight(2);
  solid.endShape();
  
  // defines the shape in horizontal strips
  for(int i = 0; i < sideFacePoints - 1; i++){
    solid.beginShape(TRIANGLE_STRIP);
    for(int j = 0; j < 24; j++){
      p = points[i][j];
      solid.vertex(p.x, p.y, p.z);
      
      p = points[i+1][j];
      solid.vertex(p.x, p.y, p.z);
    }
    p = points[i][0];
    solid.vertex(p.x, p.y, p.z);
    
    p = points[i+1][0];
    solid.vertex(p.x, p.y, p.z);
    
    solid.endShape();
  }
  
  renderSolid = true;
  return;
}
