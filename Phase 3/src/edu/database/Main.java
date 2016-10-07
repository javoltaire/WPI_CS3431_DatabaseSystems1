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
            case 3: thirdOption(); break;
            case 4: fourthOption(); break;
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
        input.nextLine();
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
        input.nextLine();

        // Ask for the ending location
        System.out.println("Enter Ending Location: ");
        String endingLocattion = input.nextLine();

        System.out.println("Determining shortest path from " + startingLocation + " to " + endingLocattion);

        int shortestPath = getShortestPathID(startingLocation, endingLocattion);

        if(shortestPath == -1)
            return;

        // And finally, get each location, floor and PathOrder
        String query = "select Path.PathID, PathStart, PathEnd, PathContains.PathOrder, " +
                        "LocationName, FloorID " +
                        "from Path, Location, PathContains " +
                        "where Path.PathID = ? and " +
                        "Location.LocationID = PathContains.LocationID and" +
                        " Path.PathID = PathContains.PathID " +
                        "order by PathOrder";

        try{
            ps = connection.prepareStatement(query);
            ps.setInt(1, shortestPath);
            rs = ps.executeQuery();

            Path path = null;

            if(rs.next()){
                PathNode node = new PathNode(rs.getInt("PathOrder"), rs.getString("LocationName"),
                        rs.getString("FloorID"));
                path = new Path(rs.getInt("PathID"), startingLocation, endingLocattion, node);
            }

            while(rs.next()){
                PathNode node = new PathNode(rs.getInt("PathOrder"), rs.getString("LocationName"),
                        rs.getString("FloorID"));
                if(path != null)
                    path.addNode(node);
            }

            if(path != null){
                System.out.printf("Starting Location: %s\n", startingLocation);
                System.out.printf("End Location: %s\n", endingLocattion);
                System.out.printf("Path ID for shortest path: %d\n", path.pathID);

                for(PathNode node : path.pathNodes)
                    System.out.printf("\t%d\t%s\t%s\n", node.order, node.location, node.floorID);

            }

            rs.close();
            ps.close();
        }
        catch(SQLException ex){
            System.err.println(ex.getMessage());
            ex.printStackTrace();
        }
    }

    private int getShortestPathID(String start, String end){

        // This will figure out the number of paths for each of the ids that were return from the query above and group them by id
        String query = "select PathID, count(*) as PathContainsCount " +
                "from PathContains " +
                "where PathID IN " +
                "(select PathID " +
                "from Path " +
                "where PathStart = ? and PathEnd = ?) " +
                "group by PathID " +
                "order by PathContainsCount ";

        try{
            ps = connection.prepareStatement(query);
            ps.setString(1, start);
            ps.setString(2, end);

            rs = ps.executeQuery();
            if(rs.next())
                return rs.getInt("PathID");

        }catch(SQLException ex){
            System.err.println(ex.getMessage());
            ex.printStackTrace();
        }
        return -1;
    }

    private void fourthOption(){
        System.out.println("Enter Health Service Name: ");
        input.nextLine();
        String serviceName = input.nextLine();

        System.out.println("Enter the new LocationID: ");
        String locationID = input.nextLine();

        String query = "update ResidesIn " +
                "set LocationID = ? " +
                "where ServiceName = ?";
        try{
            ps = connection.prepareStatement(query);
            ps.setString(1, locationID);
            ps.setString(2, serviceName);

            int result = ps.executeUpdate();

            if(result == 1)
                System.out.printf("Update Successful!\n");

        }catch(SQLException ex){
            System.err.println(ex.getMessage());
            ex.printStackTrace();
        }

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

    class Path{
        int pathID;
        String start, end;
        List<PathNode> pathNodes;

        public Path(int pathID, String start, String end){
            this(pathID, start, end, new ArrayList<PathNode>());
        }

        public Path(int pathID, String start, String end, PathNode node){
            this(pathID, start, end);
            addNode(node);
        }

        public void addNode(PathNode node){
            if(pathNodes == null)
                pathNodes = new ArrayList<>();

            if(!pathNodes.contains(node))
                pathNodes.add(node);
        }

        public Path(int pathID, String start, String end, List<PathNode> pathNodes){
            this.pathID = pathID;
            this.start = start;
            this.end = end;
            this.pathNodes = pathNodes;
        }
    }

    class PathNode{
        int order;
        String location, floorID;

        public PathNode(int order, String location, String floorID){
            this.order = order;
            this.location = location;
            this.floorID = floorID;
        }
    }
}
