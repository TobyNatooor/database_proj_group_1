package dtu.compute.dkavisen;

import java.io.File;
import java.util.List;
import java.util.Scanner;

class Main {
    public static void main(String[] args) {
        if (args.length == 0) {
            // print out the data files in the data folder
            File dataFolder = new File("data");
            File[] dataFiles = dataFolder.listFiles();
            if (dataFiles == null || dataFiles.length == 0) {
                System.out.println("No data files found in the data folder.");
                return;
            }
            printDataFileOptions(dataFiles);

            // read the file index from the user
            Scanner scanner = new Scanner(System.in);
            System.out.print("Choose the file index: ");
            int fileIndex;
            while (true) {
                fileIndex = scanner.nextInt();
                if (fileIndex >= 1 && fileIndex <= dataFiles.length) {
                    break;
                }
                printDataFileOptions(dataFiles);
                System.out.print("Please enter a valid index: ");
            }
            scanner.close();

            String fileName = dataFiles[fileIndex - 1].getAbsolutePath();

            insertIntoDB(fileName);
        } else if (args.length == 1) {
            insertIntoDB(args[0]);
        } else {
            System.out.println("Invalid number of arguments.");
        }
    }

    private static void printDataFileOptions(File[] dataFiles) {
        for (int i = 0; i < dataFiles.length; i++) {
            System.out.print(dataFiles[i].getName() + " (" + (i + 1) + ")");
            if (i != dataFiles.length - 1) {
                System.out.print(", ");
            }
        }
        System.out.println();
    }

    private static void insertIntoDB(String fileName) {
        PhotosAndReportersLoader loader = new PhotosAndReportersLoader();
        try {
            List<PhotoAndReporter> photosAndReporters = loader.loadPhotosAndReporters(fileName);
            try {
                ManipulateDB manipulateDB = new ManipulateDB("localhost", "3306", "dkavisendb", "utf8");
                for (PhotoAndReporter photoAndReporter : photosAndReporters) {
                    manipulateDB.insertPhotoAndReporter(photoAndReporter);
                }
                manipulateDB.close();

            } catch (Exception e) {
                System.out.println("failed to establish a connection to the database");
            }

        } catch (Exception e) {
            System.out.println("failed to load data from the file.");
        }
    }
}