package dtu.compute.dkavisen;

import java.util.Date;

public class PhotoAndReporter {
	private final Reporter reporter;
	private final Photo photo;

	public PhotoAndReporter(String title, Date date, String cpr, String firstName, String lastName, String streetName,
			Integer civicNumber, Integer zipCode, String country) {
		reporter = new Reporter(cpr, firstName, lastName, streetName, civicNumber, zipCode, country);
		photo = new Photo(title, date);
	}

	public Reporter getReporter() {
		return reporter;
	}

	public Photo getPhoto() {
		return photo;
	}
}
