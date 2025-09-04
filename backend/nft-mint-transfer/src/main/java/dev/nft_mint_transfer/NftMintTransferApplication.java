package dev.nft_mint_transfer;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
@EnableJpaAuditing
public class NftMintTransferApplication {

	public static void main(String[] args) {
		SpringApplication.run(NftMintTransferApplication.class, args);
	}

}
