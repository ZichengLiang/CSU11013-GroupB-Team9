// Oliver 21st March: Creation of Map class
class Map
{
  PImage map;
  float x, y;//, xSize, ySize;
  
  Map(float x, float y, float xSize, float ySize)
  {
    this.x = x; this.y = y;
    int sizeX = int(xSize); int sizeY = int(ySize);
    

    map = loadImage("America.jpg");
    map.resize(sizeX,sizeY);
  }
  
  void draw()
  {
    image(map, x, y);
  }
}
