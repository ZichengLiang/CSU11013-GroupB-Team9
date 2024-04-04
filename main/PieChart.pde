import org.gicentre.utils.stat.*;
Widget[] DataToggle;
class PieChart {

  int[] data;
  int[] originalData;
  int Conversion; //determaines what kind of conversion is done in piConverter - radians or percentage
  Query fromWholeDataSet = new Query();
  int totalFlights = fromWholeDataSet.lastQueryList.size();
  int[] angles = {90, 90, 90, 90}; //represents degrees
  String[] dataLables ={"Diverted", "cancelled", "Unchanged"};

  PieChart(int[] data) {
    originalData = data;
    Conversion = 360;
    this.data = piConverter(data);
  }

  void  draw() {
    fill(255);
    rect(650, 40, 160, 60*data.length, 20);
    pieChart(300);
    //   for (int j = 0; j < DataToggle.length; j++) {
    //  if (j == 1) {
    //    DataToggle[j] = new Widget( (SCREENX / buttons.length) * j + 60,60, 100, 60, 20, "Pie Chart", 255, body, j);
    //  } else if (j == 4) {
    //    DataToggle[j] = new Widget( (SCREENX / buttons.length) * j + 60,60, 100, 60, 20, "Bar Chart", 255, body, j);
    //  }
    //}
  }

  void pieChart(float diameter) {
    float lastAngle = 0;
    for (int i = 0; i < data.length; i++) {
      float blue = map(i, 0, data.length, 0, 255);
      float c = map(i, 0, data.length, 8, 200);  // Muireann O'Neill 23/3/24 11:48
      float e = map(i, 0, data.length, 50, 400); //to change pi Chart color
      fill(blue, c, e);
      arc(width/2, height/2, diameter, diameter, lastAngle, lastAngle+radians(data[i]));//creates an arc in the piechart using data
      if (i < dataLables.length) {
        textSize(15);
        text( dataLables[i] +" = "+ originalData[i], 700, 40+30*i);
      }
      lastAngle += radians(data[i]);
    }
  }



  int[] piConverter(int[] data) {
    int[]convertedData = new int[data.length];
    float dataPointDecValue;
    for (int i = 0; i < data.length; i++) {           // 22/03/2024 11:32
      dataPointDecValue = data[i]*Conversion;      //  data is multiplied by 360 to convert it to a fraction of PI
      println(dataPointDecValue);
      dataPointDecValue = dataPointDecValue/totalFlights;       // the data fraction eg 218*360 cancelled flights out of 2000 218*360/2000 is converted to decimal form
      println(dataPointDecValue);
      int dataPointDecFin = (int)dataPointDecValue;   // converts the float into an int
      convertedData[i] = dataPointDecFin;
      println(convertedData[i]);
    }
    Conversion = 0;
    return(convertedData);
  }
}
