package com.aipm.ai_project_management;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@EnableJpaRepositories(basePackages = {
	    "com.aipm.ai_project_management.modules.auth.repository",
	    "com.aipm.ai_project_management.modules.users.repository",
	    "com.aipm.ai_project_management.modules.clients.repository"
	})
@EntityScan(basePackages = {
	    "com.aipm.ai_project_management.modules.auth.entity",
	    "com.aipm.ai_project_management.modules.users.entity",
	    "com.aipm.ai_project_management.modules.clients.entity"
	})
public class AiProjectManagementSoftwareApplication {

	public static void main(String[] args) {
		SpringApplication.run(AiProjectManagementSoftwareApplication.class, args);
	}

}
