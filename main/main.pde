// Zicheng, 12th March, 21:00: I modified the sample program on https://processing.org/examples/loadfile2.html to fit our dataset;
import java.util.*;

Datapoint[] datapoints;
String[] lines;

int datapointCount = 0;
PFont body;
int displayNum = 10; // Display this many entries on each screen;
int startingEntry = 0; // Display from this entry number;
int sideBarButtonsNum = 5;
int horizontalButtonsNum = 3;
boolean drawBarChart = false; // Used to check if bar chart is used
Query currentQuery;

// Oliver, 15th March: creation of widgets to switch between screens

Screen Screens;
Widget[] buttons;
Widget[] buttonsHorizontal;
Text showCase;

Map map;
//Muireann O'Neill 15/03/24 11:12 declaring Charts here;
PieChart thePieChart;
//Daniel 15/03/24 initialized BarCharts here
TheBarChart theBarChart;

void settings() {
  size(SCREENX, SCREENY);
}
void setup() {
  //Daniel 15/03/24 initialized BarCharts here
  BarChart barChart = new BarChart(this); // Create a new BarChart instance

  fill(BACKGROUND_COLOUR);
  noLoop();
  body = loadFont("myFont-12.vlw");
  textFont(body);
  textSize(12);
  rectMode(CENTER);

  datapoints = loadDatapoints("flights2k.csv");
  table = loadTable("flights2k.csv", "header");
  // Query functions test cases:
  Query fromWholeDataSet = new Query();
  currentQuery = fromWholeDataSet;
 //Muireann O'Neill 14/03/24 17:12 initializing Charts here;
  thePieChart = new PieChart();
  thePieChart.getAbnormalFlights(currentQuery);
  // Zicheng  20/03/24 Initialised flight distances to bar chart
  ArrayList<Datapoint> testFlights = currentQuery.flightsFrom("JFK");
  ArrayList<Datapoint> sortedFlights = sortByDistance(testFlights);

  Datapoint[] flights = sortedFlights.toArray(Datapoint[]::new);

  float[] flightDistance = new float[flights.length];
  for (int i = 0; i < flights.length; i++) {
    flightDistance[i] = flights[i].distance;
  }
  String[] flightDestination = new String[flights.length];
  for (int i = 0; i < flights.length; i++) {
    flightDestination[i] = flights[i].dest;
  }

  // BarChart (Checks flight distance)
  float[] topDistances = new float[datapoints.length];
  String[] topDestinations = new String[datapoints.length];
  int airportCounter = 0; //Counts airports passed through

  for (int i = 0; i < flightDistance.length && airportCounter < 5; i++) {
    if (! inTopDestinations(flightDestination[i], topDestinations)) {
      topDistances[airportCounter] = flightDistance[i];
      topDestinations[airportCounter] = flightDestination[i];
      airportCounter++;
    }
  }
  topDistances = Arrays.copyOf(topDistances, airportCounter);
  topDestinations = Arrays.copyOf(topDestinations, airportCounter);
  theBarChart = new TheBarChart(barChart, topDistances, topDestinations);



  // Buttons
  Screens = new Screen();
  //the side bar buttons here:
  initializeSidebarButtons();
  initializeHorizontalButtons();
  // Oliver, 22nd March: Working on horix=zontal buttons
     showCase = new Text(SCREENX-100, SCREENY-100, 200, 200,
  255, body);
   

   //Query for flights by a specific carrier (e.g., American Airlines with carrier code "AA")
    Query carrierQuery = new Query();
    ArrayList<Datapoint> bySpecificCarrier = carrierQuery.flightsByCarrier("AA");
  
   //Query for flights on a specific date
    Query onDate = new Query();
    ArrayList<Datapoint> onSpecificDate = onDate.flightsOnDate("20220101"); // Example: "20240101" for January 1, 2024

// Aryan, 27th March
    // Get the summary for a specific flight number (replace "XX" with the actual flight number)
    getFlightSummary("AA", 1); // First enter the airline code within quotes and then enter the flt num

  // Oliver 26th March: Map work
  map = new Map(SCREENX/5, SCREENY/3, 700, 450, datapoints);
  
  
  // Aryan, 4th April
  // for making the sliding bar
  
  //size(800, 600);
G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(true);
  int sliderWidth = 175; // Width of the slider
  int sliderHeight = 40; // Height of the slider
  int margin = 10; // Margin from the edges of the window

  // Initialize the tick labels with numbers from 0 to 23
  for (int i = 0; i < 24; i++) {
    tickLabels[i] = String.format("%02d:00", i); // Format each hour with leading zeros
  }

  // Position the slider at the top right, with a margin
  int sliderX = width - sliderWidth - margin; // X position
  //int sliderY = margin; // Y position, just a margin from the top
  int sliderY = 400;

  hourSlider = new GSlider(this, sliderX, sliderY, sliderWidth, sliderHeight, 10.0);
  hourSlider.setLimits(0, 0, 23); // Slider range from 0 to 23 hours
  hourSlider.setNumberFormat(G4P.INTEGER, 0);
  hourSlider.setShowValue(true); // Display value above cursor
  hourSlider.setOpaque(false);
  hourSlider.addEventHandler(this, "hourSliderChanged");

  
}


//displaynum = 10
void draw() {
  noStroke();
  background(BACKGROUND_COLOUR);

  textSize(12);
  Screens.draw();
  for (int i=0; i<buttons.length; i++)
  {
    buttons[i].draw();
  }
  for (int i=0; i<buttonsHorizontal.length; i++)
  {
    buttonsHorizontal[i].draw();
  }
  showCase.draw(currentQuery.filterQuery().toArray(Datapoint[]::new));
  drawTickLabels(10);
}

void mousePressed() {
  int event;
  scrollY -= 20;
  event = showCase.pressed(mouseX, mouseY);
  //scrollY -= 20;
  System.out.println(event);
  if (event>-1)
  {
    startingEntry += displayNum;
    if (startingEntry > datapoints.length) {
      startingEntry = 0; // go back to the beginning;
    }
  }
  
  for (int i =0; i<buttonsHorizontal.length; i++)
  {
    event=buttonsHorizontal[i].getEvent(mouseX, mouseY);
  }
  
  for (int i =0; i<buttons.length; i++)
  {
    event=buttons[i].getEvent(mouseX, mouseY);
    if (event>=0)
    {
      Screens.screenType=event;
    }
  }
  
  redraw();
}

Datapoint[] loadDatapoints(String fileName) {
  lines = loadStrings(fileName); // Loads in csv file in String array "lines" (each line is an element in array)
  datapoints = new Datapoint[lines.length - 1];  // Adjusted the size of datapoints array

  for (int i = 1; i < lines.length; i++) {  // Start reading from the second line
    String[] pieces = split(lines[i], ','); // Got rid of integer and replaced it with constant variable

    if (pieces.length == DATAPOINTVARIABLECOUNT) { // checks if all the variables are there, if so, load it
      datapoints[datapointCount] = new Datapoint(pieces);
      datapointCount++;
    } else {
      String[] adjustedPieces = new String[DATAPOINTVARIABLECOUNT];
      if (pieces.length == DATAPOINTVARIABLECOUNT - 1 ) { //in the given dataset, cancelled flights have no dep_time and arr_time
        arrayCopy(pieces, 0, adjustedPieces, 0, 16); //copy from first element to CRSArrTime
        adjustedPieces[16] = "9999"; // the actual arrive time is set to " ";
        arrayCopy(pieces, 16, adjustedPieces, 17, 3); //copy the last three elements
      } else if (pieces.length == DATAPOINTVARIABLECOUNT - 2 ) { //in the given dataset, cancelled flights have no dep_time and arr_time
        arrayCopy(pieces, 0, adjustedPieces, 0, 14); //copy from first element to CRSDeptTime
        adjustedPieces[14] = "9999"; // the actual dept time is set to " ";
        adjustedPieces[15] = pieces[14];
        adjustedPieces[16] = "9999"; // the actual arr time is set to " ";
        arrayCopy(pieces, 15, adjustedPieces, 17, 3); //copy the last three elements
      }
      datapoints[datapointCount] = new Datapoint(adjustedPieces);
      datapointCount++;
    }
  } // for loop ends here

  return datapoints; // this is an array of Datapoint elements
}

void initializeSidebarButtons() {
  buttons = new Widget[sideBarButtonsNum];
  for (int j = 0; j < buttons.length; j++) {
    if (j == 1) {
      buttons[j] = new Widget(60, (SCREENY / buttons.length) * j + 60, 100, 60, 20, "Pie Chart", 255, body, j);
    } 
    else if(j==2)
    {
      buttons[j] = new Widget(60, (SCREENY / buttons.length) * j + 60, 100, 60, 20, "Map", 255, body, j);
    }else if (j == 4) {
      buttons[j] = new Widget(60, (SCREENY / buttons.length) * j + 60, 100, 60, 20, "Bar Chart", 255, body, j);
    } else {
      buttons[j] = new Widget(60, (SCREENY / buttons.length) * j + 60, 100, 60, 20, "button " + j, 255, body, j);
    }
  }
}

void initializeHorizontalButtons() {
  buttonsHorizontal = new Widget[horizontalButtonsNum];
  for (int j = 0; j < buttonsHorizontal.length; j++) {
    if (j == 0) {
      buttonsHorizontal[j] = new Widget(((SCREENX - SCREENX / 1.99) / buttonsHorizontal.length) * j + SCREENX / 4, SCREENY - 65, 100, 60,20, "Toggle data", 255, body, j);
    } else {
      buttonsHorizontal[j] = new Widget(((SCREENX - SCREENX / 1.99) / buttonsHorizontal.length) * j + SCREENX / 4, SCREENY - 65, 100, 60,20, "button" + j, 255, body, j);
    }
  }
}

boolean inTopDestinations(String airport, String[] topDestinations) {
  for (String destination : topDestinations) {
    if (airport.equals(destination)) {
      return true;
    }
  }
  return false;
}

ArrayList<Datapoint> sortByDistance(ArrayList<Datapoint> input) {
    ArrayList<Datapoint> sortedList = new ArrayList<Datapoint>(input);
    Collections.sort(sortedList, (item2, item1) -> Integer.compare(item1.getDistance(), item2.getDistance()));
    return sortedList;
  }
