package edu.database;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.sql.*;

public class Main {
    Scanner input;
    Connection connection;
    PreparedStatement ps;
    ResultSet rs;

    public static void main(String[] args) {
        new Main().runApp(args);
    }

    private void runApp(String[] args){
        try{
            if(args.length < 2)
                throw new Exception ("Invalid number of arguments");

            Class.forName("oracle.jdbc.driver.OracleDriver");
            connection = DriverManager.getConnection(
                    "jdbc:oracle:thin:@oracle.wpi.edu:1521:orcl", args[0], args[1]);
            input = new Scanner(System.in);

            if(args.length == 2)
                requestOption();
            else{
                int option = Integer.parseInt(args[2]);
                selectOption(option);
            }
        }catch (SQLException ex){
            System.err.println(ex.getMessage());
            ex.printStackTrace();
        }catch(Exception ex){
            System.err.println(ex.getMessage());
        }
    }

    private void requestOption(){
        String first = "1 - Report Health Provider Inforamtion";
        String second = "2 - Report Health Service Information";
        String third = "3 - Report Path Information";
        String fourth = "4 - Update Health Service Inforamtion";

        System.out.printf("%s\n%s\n%s\n%s\n\n", first, second, third, fourth);
        selectOption(input.nextInt());
    }

    private void selectOption(int option){
        switch(option){
            case 1:
                firstOption();
                break;
            case 2:
                secondOption();
                break;
            case 3: ; break;
            case 4: ; break;
        }
    }

    private void firstOption(){
        System.out.println("Enter Provider ID: ");
        int providerID = input.nextInt();

        String query = "Select FirstName, LastName, Acronym, LocationName " +
                "from Provider, ProviderTitle, Office, Location " +
                "where Provider.ProviderID = ? AND " +
                "Provider.ProviderID = ProviderTitle.ProviderID AND " +
                "(Provider.ProviderID = Office.ProviderID AND " +
                "Office.LocationID = Location.LocationID)";

        try{
            ps = connection.prepareStatement(query);
            ps.setInt(1, providerID);

            rs = ps.executeQuery();
            Provider provider = null;
            if(rs.next()){
                provider = new Provider(providerID, rs.getString("FirstName"),
                        rs.getString("LastName"), rs.getString("Acronym"), rs.getString("LocationName"));
            }

            while(rs.next()){
                if(provider != null){
                    if(rs.getString("Acronym") != null)
                        provider.addTitle(rs.getString("Acronym"));

                    if(rs.getString("LocationName") != null)
                        provider.addLocation(rs.getString("LocationName"));
                }
            }

            System.out.println("Health Provider Information");
            System.out.printf("Provider ID: %d\n", providerID);
            System.out.printf("First Name: %s\n", provider.firstName);
            System.out.printf("Last Name: %s\n", provider.lastName);
            System.out.print("Title: ");

            for(String title: provider.titles)
                System.out.printf("%s ", title);
            System.out.println();
            System.out.print("Office Location: ");

            for(String location : provider.locations)
                System.out.printf("%s ", location);
            System.out.println();


            rs.close();
            ps.close();
        }catch(SQLException ex){
            System.err.println(ex.getMessage());
            ex.printStackTrace();
        }
    }

    private void secondOption(){
        System.out.println("Enter Health Service Name: ");
        String serviceName = input.nextLine();

        String query = "select Services.ServiceName, HealthType, LocationName, FloorID " +
                "from  Services, ResidesIn, Location " +
                "where Services.ServiceName = ? and " +
                "(Services.ServiceName = ResidesIn.ServiceName and " +
                "ResidesIn.LocationID = Location.LocationID)";

        try{
            ps = connection.prepareStatement(query);
            ps.setString(1, serviceName);
            rs = ps.executeQuery();

            if(rs.next()){
                System.out.printf("Service Name: %s\n", rs.getString("ServiceName"));
                System.out.printf("Health Type: %s\n", rs.getString("HealthType"));
                System.out.printf("Location: %s\n", rs.getString("LocationName"));
                System.out.printf("Floor: %s\n", rs.getString("FloorID"));
            }

            rs.close();
            ps.close();
        }catch(SQLException ex){
            System.err.println(ex.getMessage());
            ex.printStackTrace();
        }
    }

    /**
     * This method should be executed when 3 is entered as an option. It requests a starting
     * and ending location and determines and displays the shortest path;
     *
     */
    private void thirdOption(){
        // Ask for the starting location
        System.out.println("Enter Starting Location: ");
        String startingLocation = input.nextLine();

        // Ask for the ending location
        System.out.println("Enter Ending Location: ");
        String endingLocattion = input.nextLine();

        System.out.println("Determining shortest path from " + startingLocation + "to " + endingLocattion);

        // Creating the sql query to get the requested data
        // this will return the id for paths with the same starting and ending locations
        String pathResultSubQuery = "select PathID" +
                                    "from Path" +
                                    "where PathStart = ? and PathEnd = ?";

        // This will figure out the number of paths for each of the ids that were return from the query above and group them by id
        String countPathsSubQuery = "select PathID, count(PathID) as PathContainsCount" +
                                    "from PathContains " +
                                    "where PathID = (" + pathResultSubQuery + ")" +
                                    "grouped by PathID";

        // This will return the id of the one with the lowest
        String minPathsSubQuery = "select PathID, min(PathContainsCount)" +
                                  "from(" + countPathsSubQuery + ")";

        // This will get the rows from path contains that mactches the id of the min returned from the above query
        String pathContainsResult = "select * from PathContains" +
                                    "where PathID = (" + minPathsSubQuery + ")";

        // And finally, get each location, floor and PathOrder
        String query = "select PathContains.PathOrder, Location.LocationName, Location.FloorID" +
                       "from Location, (" + pathContainsResult + ") Result" +
                       "Where Location.LocationID = Result.LocationID";

        try{
            ps = connection.prepareStatement(query);
            ps.setString(1, startingLocation);
            ps.setString(2, endingLocattion);
            rs = ps.executeQuery();

            if(rs.next()){
                // Todo: Just print the line
            }

            rs.close();
            ps.close();
        }
        catch(SQLException ex){
            System.err.println(ex.getMessage());
        }

    }

    private void fourthOption(){

    }

    class Provider{
        int id;
        String firstName, lastName;
        List<String> titles;
        List<String> locations;

        public Provider(int id, String firstName, String lastName){
            this.id = id;
            this.firstName = firstName;
            this.lastName = lastName;
            titles = new ArrayList<>();
            locations = new ArrayList<>();
        }

        public Provider(int id, String firstName, String lastName,
                        String title, String location){
            this.id = id;
            this.firstName = firstName;
            this.lastName = lastName;
            addTitle(title);
            addLocation(location);
        }

        public void setTitles(List<String> titles){
            this.titles =  titles;
        }

        public void addTitle(String title){
            if(titles == null)
                titles = new ArrayList<>();

            if(!titles.contains(title))
                titles.add(title);
        }

        public void setLocations(List<String> locations){
            this.locations = locations;
        }

        public void addLocation(String location){
            if(locations == null)
                locations = new ArrayList<>();

            if(!locations.contains(location))
                locations.add(location);
        }


    }

    class Service{
        String name, type, location, floor;

        public Service(String name, String type, String location, String floor){
            this.name = name;
            this.type = type;
            this.location = location;
            this.floor = floor;
        }
    }
}
