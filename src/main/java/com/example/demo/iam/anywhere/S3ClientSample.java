package com.example.demo.iam.anywhere;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import io.awspring.cloud.s3.S3Resource;
import io.awspring.cloud.s3.S3Template;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;

@Component
class S3ClientSample implements CommandLineRunner {

    @Autowired
    private S3Template s3Template;

    void readFile() throws IOException {
        List<S3Resource> objects = s3Template.listObjects("jbs-webpage", "");
        System.out.println("s3 listObjects::" + objects.size());
        // Iterate over the list and print object details
        for (S3Resource object : objects) {
            System.out.println("Object Key: " + object.getLocation().getObject());
            // Optionally, you can print more details or content of the object if needed
        }
    }

    public void uploadFile() throws IOException {
        String bucketName = "jbs-webpage";
        String key = "uploads/myfile.txt";
        // Path to the local file to upload
        String filePath = "/Users/mitanandeesh/Downloads/custord.2024090115511587.txt";

        try (InputStream fileInputStream = new FileInputStream(filePath)) {

            // Upload the file to S3
            s3Template.upload(bucketName, key, fileInputStream);
            System.out.println("File uploaded successfully: " + key);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void run(String... args) throws Exception {
        readFile();
        uploadFile();
    }
}


