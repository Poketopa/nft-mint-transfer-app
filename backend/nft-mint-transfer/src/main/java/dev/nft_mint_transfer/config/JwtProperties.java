package dev.nft_mint_transfer.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Getter;
import lombok.Setter;

@Component
@ConfigurationProperties(prefix = "jwt")
@Getter
@Setter
public class JwtProperties {

    private String secret = "mySecretKey12345678901234567890123456789012345678901234567890";
    private long accessTokenValidityInMs = 3600000; // 1 hour
}