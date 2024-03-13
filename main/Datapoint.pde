// Zicheng, 12th March, 18:00: created the Datapoint class;
class Datapoint{
  
  // Zicheng, 12th March, 18:00: fields added according to the .csv files;
  int  flightDate, flightNumber, originWac, destWac, distance;
  int  CRSDepTime, depTime, CRSArrTime, arrTime;
  String carrierCode, origin, originCityName, originState, dest, destCityName, destState;
  int cancelled, diverted;
  
  // Zicheng, 12th March, 21:00: a constructor with all parameters;
  public Datapoint(String[] pieces){
    flightDate = int (pieces[0]);
    carrierCode = pieces[1]; flightNumber = int (pieces[2]);
    origin = pieces[3]; originCityName = pieces[4]; originState = pieces[5]; originWac = int (pieces[6]);
    dest = pieces[7]; destCityName = pieces[8]; destState = pieces[9]; destWac = int (pieces[10]);
    CRSDepTime = int (pieces[11]); depTime = int (pieces[12]); CRSArrTime = int (pieces[13]); arrTime = int (pieces[14]); 
    cancelled = int (pieces[15]); diverted = int (pieces[16]); 
    distance = int (pieces[17]);
  }
}