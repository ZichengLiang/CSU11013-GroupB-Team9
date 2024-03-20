import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

class Query {
  // TODO: flightsFrom and flightsTo are still interacting directly with datapoints[2000], upgrade them
  // TODO: write more query functions
  // TODO: consider more about the attributes inside this class
  // TODO: some queries can generate new information
  // TODO: 
  ArrayList<Datapoint> lastQueryList;

  Query() {
    List<Datapoint> tempList = Arrays.asList(datapoints); 
    this.lastQueryList = new ArrayList<Datapoint>(tempList);
  }
  
  Query(ArrayList<Datapoint> lastQueryList){
    this.lastQueryList = lastQueryList;
  }
  
  
  // methods:
  ArrayList<Datapoint> flightsFrom(int originWac){
    // a new way to get the sorted ArrayList:
    /* 
    ArrayList<Datapoint> newList = new ArrayList<Datapoint>(lastQueryList.stream()
    .filter(datapoint -> datapoint.conditionFunction())
    .collect(Collectors.toList()));
    */
    ArrayList<Datapoint> flightsFromList = new ArrayList<Datapoint>(lastQueryList.stream()
    .filter(datapoint -> datapoint.originWacIs(originWac))
    .collect(Collectors.toList()));
    
    // We use a StringBuilder to contain the report
    println(getReport(flightsFromList, FLIGHTS_FROM));
    return flightsFromList;
  }

  ArrayList<Datapoint> flightsFrom(String airportCode) {
    // queries function: print all the flights going to passed airport code
    ArrayList<Datapoint> flightsFromList = new ArrayList<Datapoint>(lastQueryList.stream()
    .filter(datapoint -> datapoint.originIs(airportCode))
    .collect(Collectors.toList()));
    
    println(getReport(flightsFromList, FLIGHTS_FROM));
  
    return flightsFromList;
  }

  ArrayList<Datapoint> flightsTo(String airportCode) {
    // queries function: print all the flights going to passed airport code
    ArrayList<Datapoint> flightsToList = new ArrayList<Datapoint>(lastQueryList.stream()
    .filter(datapoint -> datapoint.destIs(airportCode))
    .collect(Collectors.toList()));
    
    println(getReport(flightsToList, FLIGHTS_TO));
    return flightsToList;
  }
  
  // This is for displaying diverted flights
   ArrayList<Datapoint> divertedFlights() {
        ArrayList<Datapoint> divertedFlightsList = new ArrayList<Datapoint>();
        Datapoint[] lastQuery = lastQueryList.toArray(new Datapoint[0]);

        println("These flights are diverted:");
        for (int i = 0; i < lastQuery.length; i++) {
            if (lastQuery[i].isDiverted()) {
                divertedFlightsList.add(lastQuery[i]);
                println(divertedFlightsList.size() + "> " + lastQuery[i].flightCode + " on " + lastQuery[i].flightDate + " is diverted.");
            }
        }
        println("There are " + divertedFlightsList.size() + " diverted flights out of " + lastQuery.length + " flights.");
        return divertedFlightsList;
    }
    
    // This is for flights by particular carrier
    ArrayList<Datapoint> flightsByCarrier(String carrierCode) {
      ArrayList<Datapoint> flightsList = new ArrayList<Datapoint>();
    for (Datapoint datapoint : lastQueryList) {
        if (datapoint.carrierCodeIs(carrierCode)) {
            flightsList.add(datapoint);
        }
    }

    // Print flights from the specific carrier
    println("Flights operated by carrier " + carrierCode + ":");
    int count = 0;
    for (Datapoint flight : flightsList) {
        count++;
        println(count + "> " + flight.flightCode + " on " + flight.flightDate + " from " + flight.origin + " to " + flight.dest);
    }

    // Print summary
    println("Total number of flights operated by carrier " + carrierCode + ": " + flightsList.size());
    
    return flightsList;
}


  ArrayList<Datapoint> flightsOnDate(String date) {
    ArrayList<Datapoint> flightsList = new ArrayList<Datapoint>();
    for (Datapoint datapoint : lastQueryList) {
        if (datapoint.flightDate.trim().equals(date.trim())) {
            flightsList.add(datapoint);
        }
    }
    
    if (flightsList.isEmpty()) {
        println("No flights found on date: " + date);
    } else {
        println("Flights found on date: " + date + ", Total: " + flightsList.size());
        // Print additional details if needed
        for (Datapoint datapoint : flightsList) {
            println(datapoint.flightCode + " from " + datapoint.origin + " to " + datapoint.dest);
        }
    }
    
    return flightsList;
  }

 ArrayList<Datapoint> lateFlights() {
    // Zicheng: 18th March, 21:00
    // lateFlights query function: print all the late flights in the form:
    // note: it doesn't count a flight late if the late time is less than 10 minutes
    ArrayList<Datapoint> lateFlightsList = new ArrayList<Datapoint>(lastQueryList.stream()
    .filter(datapoint -> datapoint.isLate())
    .collect(Collectors.toList()));
    
    println(getReport(lateFlightsList, LATE_FLIGHTS));
    return lateFlightsList;
  }

// Zicheng: 20th March, 22:00, getReport function takes in a list and a type, returns a String of report
String getReport(ArrayList<Datapoint> inputList, int type){
  if(inputList.isEmpty()){
      return ("Sorry, there is no such flight!");
    }
    else{
      StringBuilder report = new StringBuilder();
      // the for loop generates each-line information, example:
      // 1> Flight Code: AA1, Date: 01/01/2022, Origin: JFK in New York, NY, Destination: LAX in Los Angeles, CA, the flight distance is 2475 miles.
      for(int i = 0; i < inputList.size(); i++){
        Datapoint flight = inputList.get(i);
        report.append(i+1)
        .append("> Flight Code: ").append(flight.flightCode)
        .append(", Date: ").append(flight.flightDate)
        .append(", Origin: ").append(flight.origin)
        .append(" in ").append(flight.combinedOriginCityName)
        .append(", Destination: ").append(flight.dest)
        .append(" in ").append(flight.combinedDestCityName)
        .append(", the flight distance is ").append(flight.distance).append(" miles")
        .append("\n");
      } // for loop ends
      
      switch(type){
        case FLIGHTS_FROM:
        report.insert(0, ":\n")
        .insert(0, inputList.get(0).originWac).insert(0, " where the WAC is ")
        .insert(0, inputList.get(0).origin).insert(0, "These flights fly from ");
        report.append(inputList.size())
        .append(" flights depart from ").append(inputList.get(0).origin);
        break;
        
        case FLIGHTS_TO:
        report.insert(0, ":\n")
        .insert(0, inputList.get(0).destWac).insert(0, " where the WAC is ")
        .insert(0, inputList.get(0).dest).insert(0, "These flights fly to ");
        report.append(inputList.size())
        .append(" flights arrive at").append(inputList.get(0).dest);
        break;
        
        case DIVERTED_FLIGHTS:
        report.insert(0,":\n").insert(0, "These flights are diverted");
        report.append(inputList.size()).append(" flights are diverted.");
        break;
        
        case FLIGHTS_BY_CARRIER:
        report.insert(0,":\n")
        .insert(0,inputList.get(0).carrierCode).insert(0, "These flights are by carrier");
        report.append(inputList.size())
        .append(" flights are carried by carrier ").append(inputList.get(0).carrierCode);
        break;
        
        case FLIGHTS_ON_DATE:
        report.insert(0,":\n").insert(0, "These flights are on date");
        report.append(inputList.size()).append(" flights are on date.");
        break;
        
        case LATE_FLIGHTS:
        report.insert(0,":\n").insert(0, "These flights are late (more than 10 minutes)");
        report.append(inputList.size()).append(" flights are late (more than 10 minutes).");
        break;
      }//switch ends
      
      return report.toString();
    }
    
  
}


}
