package dtu.compute.dkavisen;

import java.sql.*;
import io.github.cdimascio.dotenv.Dotenv;
import java.text.SimpleDateFormat;

public class ManipulateDB {
    private Statement statement;
    private SimpleDateFormat dateFormatter;

    ManipulateDB(String host, String port, String database, String cp) throws SQLException {
        Dotenv dotenv = Dotenv.load();
        String username = dotenv.get("DB_USERNAME");
        String password = dotenv.get("DB_PASSWORD");
        String url = "jdbc:mysql://" + host + ":" + port + "/" + database + "?characterEncoding=" + cp;

        Connection connection = DriverManager.getConnection(url, username, password);
        statement = connection.createStatement();

        dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
    }

    public void insertPhotoAndReporter(PhotoAndReporter photoAndReporter) {
        try {

            Reporter rep = photoAndReporter.getReporter();
            Photo photo = photoAndReporter.getPhoto();

            if (reporterExists(rep.getCPR())) {
                System.out.println("The reporter: '" + rep.getFirstName() + " " + rep.getLastName()
                        + "' already exists in the database");
            } else {
                statement.executeUpdate(
                        "INSERT INTO Journalist (CPR, FirstName, LastName, StreetName, StreetNumber, ZipCode, Country) VALUES ("
                                + String.format("'%s', '%s', '%s', '%s', %d, %d, '%s')", rep.getCPR(),
                                        rep.getFirstName(),
                                        rep.getLastName(), rep.getStreetName(), rep.getCivicNumber(), rep.getZIPCode(),
                                        rep.getCountry()));
            }

            if (photoExists(photo.getTitle())) {
                System.out.println("A photo with the title: '" + photo.getTitle() + "' already exists in the database");
            } else {
                statement.executeUpdate(
                        String.format("INSERT INTO Photo (PhotoTitle, PhotoDate, Reporter) VALUES ('%s', '%s', '%s')",
                                photo.getTitle(), dateFormatter.format(photo.getDate()), rep.getCPR()));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private boolean reporterExists(String cpr) throws SQLException {
        ResultSet resultSet = statement.executeQuery("SELECT * FROM Journalist WHERE CPR = '" + cpr + "'");
        while (resultSet.next()) {
            String rowValue = resultSet.getString(1);
            if (rowValue.equals(cpr)) {
                return true;
            }
        }
        return false;
    }

    private boolean photoExists(String photoTitle) throws SQLException {
        ResultSet resultSet = statement.executeQuery("SELECT * FROM Photo WHERE PhotoTitle = '" + photoTitle + "'");
        while (resultSet.next()) {
            String rowValue = resultSet.getString(1);
            if (rowValue.equals(photoTitle)) {
                return true;
            }
        }
        return false;
    }

    public void close() throws SQLException {
        statement.close();
    }
}
