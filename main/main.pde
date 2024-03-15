// Zicheng, 12th March, 21:00: I modified the sample program on https://processing.org/examples/loadfile2.html to fit our dataset;
Datapoint[] datapoints;
String[] lines;
int datapointCount;
PFont body;
int displayNum = 10; // Display this many entries on each screen;
int startingEntry = 0; // Display from this entry number;

//M: As far as I understand it, draw function won't work properly if size is in setup.
void settings(){
  size(600, 600);
}
void setup(){
  fill(255);
  noLoop();
  body = loadFont("myFont-12.vlw"); 
  textFont(body);
  textSize(12);
  
  lines = loadStrings("flights2k.csv"); // Loads in csv file (each line is an element in array)
  datapoints = new Datapoint[lines.length];
  println(lines.length);
  for(int i2 = 0; i2 < lines.length; i2++){
    String[] pieces = split(lines[i2], ','); // Got rid of integer and replaced it with constant variable
    
// Oliver, 13th March, 1:05: Commented out if statement to add more to dataponts array
//    if (pieces.length == DATAPOINTVARIABLECOUNT){ // checks if all the variables are there
      datapoints[datapointCount] = new Datapoint(pieces);
      datapointCount++;
   }
  
  // if there are spare elements in datapoints array, remove them.
  if (datapointCount != datapoints.length){
    datapoints = (Datapoint[]) subset(datapoints, 0, datapointCount);
  }
 }

//displaynum = 10
  void draw(){
  background(0);
  for(int i3 = 0; i3 < displayNum; i3++){
    int thisEntry = 0;
    thisEntry = startingEntry + i3;
    //~M: seems to be confusing the system, prints 10 times once replaced
    if (thisEntry < datapointCount){
      //M: there seems to be somthing going wrong with calling on data here, i need more info on exactly how data is being called before i can fix this
      text(thisEntry + " > " + datapoints[thisEntry].carrierCode + datapoints[thisEntry].flightNumber + "----" 
                     + datapoints[thisEntry].origin + " -> " + datapoints[thisEntry].originState
                     , 20, 20 + i3*20);
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
