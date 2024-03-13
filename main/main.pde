// Zicheng, 12th March, 21:00: I modified the sample program on https://processing.org/examples/loadfile2.html to fit our dataset;
Datapoint[] datapoints;
String[] lines;
int datapointCount;
PFont body;
int displayNum = 10; // Display this many entries on each screen;
int startingEntry = 0; // Display from this entry number;

void setup(){
  size(600, 600);
  fill(255);
  noLoop();
  
  body = loadFont("myFont-12.vlw");
  textFont(body);
  textSize(20);
  
  lines = loadStrings("flights2k.csv"); // Loads in csv file (each line is an element in array)
  datapoints = new Datapoint[lines.length];
  println(lines.length);
  for(int i = 0; i < lines.length; i++){
    String[] pieces = split(lines[i], ',');
    // Got rid of integer and replaced it with constant variable
    
// Oliver, 13th March, 1:05: Commented out if statement to add more to dataponts array
//    if (pieces.length == DATAPOINTVARIABLECOUNT){ // checks if all the variables are there
      datapoints[datapointCount] = new Datapoint(pieces);
      datapointCount++;
//    }
  }
  // if there are spare elements in datapoints array, remove them.
  if (datapointCount != datapoints.length){
    datapoints = (Datapoint[]) subset(datapoints, 0, datapointCount);
  }
}

void draw(){
  background(0);
  for(int i = 0; i < displayNum; i++){
    int thisEntry = startingEntry + i;
    if (thisEntry < datapointCount){
      text(thisEntry + " > " + datapoints[thisEntry].carrierCode, 20, 20 + i*20);
    }
  }
}

void mousePressed(){
  startingEntry += displayNum;
  if (startingEntry > datapoints.length){
    startingEntry = 0; // go back to the begining;
  }
  redraw();
}