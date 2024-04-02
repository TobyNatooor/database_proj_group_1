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

            try {
                PhotosAndReportersLoader loader = new PhotosAndReportersLoader();
                List<PhotoAndReporter> photosAndReporters = loader.loadPhotosAndReporters(fileName);
                ManipulateDB manipulateDB = new ManipulateDB("localhost", "3306", "dkavisendb", "utf8");
                for (PhotoAndReporter photoAndReporter : photosAndReporters) {
                    manipulateDB.insertPhotoAndReporter(photoAndReporter);
                }
                manipulateDB.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
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
}