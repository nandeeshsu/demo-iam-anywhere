package com.example.demo.iam.anywhere;

import org.springframework.boot.SpringApplication;

public class TestDemoIamAnywhereApplication {

	public static void main(String[] args) {
		SpringApplication.from(DemoIamAnywhereApplication::main).with(TestcontainersConfiguration.class).run(args);
	}

}
