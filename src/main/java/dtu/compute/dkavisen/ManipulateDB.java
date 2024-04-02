package dtu.compute.dkavisen;

import java.sql.*;

public class ManipulateDB {
    private String dbName;

    ManipulateDB(String dbName) {
        this.dbName = dbName;
    }

    public void insertPhotoAndReporter(PhotoAndReporter photoAndReporter) {
        String host = "localhost"; // host is "localhost" or "127.0.0.1"
        String port = "3306"; // port is where to communicate with the RDBMS
        String database = "dkavisendb"; // database containing tables to be queried
        String cp = "utf8"; // Database codepage supporting Danish (i.e. æøåÆØÅ)
        // Set username and password.
        String username = "root"; // Username for connection
        String password = "YES"; // Password for username

        String url = "jdbc:mysql://" + host + ":" + port + "/" + database + "?characterEncoding=" + cp;
        try {
            Connection connection = DriverManager.getConnection(url, username, password);
            Statement statement = connection.createStatement();

            Reporter rep = photoAndReporter.getReporter();
            Photo photo = photoAndReporter.getPhoto();
            statement.executeUpdate(
            // System.out.println(
                    "INSERT INTO Journalist (CPR, FirstName, LastName, StreetName, StreetNumber, ZipCode, Country) VALUES ("
                            + String.format("%d, '%s', '%s', '%s', %d, %d, '%s')", rep.getCPR(), rep.getFirstName(),
                                    rep.getLastName(), rep.getStreetName(), rep.getCivicNumber(), rep.getZIPCode(),
                                    rep.getCountry()));
            statement.executeUpdate(
            // System.out.println(
                    String.format("INSERT INTO Photo (PhotoTitle, PhotoDate, Reporter) VALUES ('%s', '%s', %d)",
                            photo.getTitle(), photo.getDate(), rep.getCPR()));

            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}
