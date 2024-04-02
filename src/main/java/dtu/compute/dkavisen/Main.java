package main.java.dtu.compute.dkavisen;

import java.io.File;
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

            String fileName = dataFiles[fileIndex].getAbsolutePath();
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