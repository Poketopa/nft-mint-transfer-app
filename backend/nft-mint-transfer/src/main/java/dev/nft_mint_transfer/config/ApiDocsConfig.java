package dev.nft_mint_transfer.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;

@Configuration
public class ApiDocsConfig {
	@Bean
	OpenAPI openAPI() {
		return new OpenAPI()
			.info(createApiInfo())
			.addSecurityItem(new SecurityRequirement().addList("bearerAuth"))
			.components(new Components().addSecuritySchemes("bearerAuth",
				new SecurityScheme()
					.name("Authorization")
					.type(SecurityScheme.Type.HTTP)
					.scheme("bearer")
					.bearerFormat("JWT")));
	}

	private Info createApiInfo() {
		return new Info()
			.title("GreenMate API")
			.description("GreenMate API 문서입니다.")
			.version("1.0.0");
	}
}
