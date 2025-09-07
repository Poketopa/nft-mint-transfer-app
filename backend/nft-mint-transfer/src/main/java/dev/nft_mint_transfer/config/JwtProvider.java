package dev.nft_mint_transfer.config;

import java.security.Key;
import java.util.Date;

import javax.crypto.SecretKey;

import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.UnsupportedJwtException;
import io.jsonwebtoken.security.Keys;

@Component
public class JwtProvider {

	private final JwtProperties jwtProperties;
	private final Key key;

	public JwtProvider(JwtProperties jwtProperties) {
		this.jwtProperties = jwtProperties;
		this.key = Keys.hmacShaKeyFor(jwtProperties.getSecret().getBytes());
	}

	public String createToken(Long userId, String email, String nickname) {
		Date now = new Date();
		Date expiry = new Date(now.getTime() + jwtProperties.getAccessTokenValidityInMs());

		return Jwts.builder()
			.setSubject(String.valueOf(userId))
			.claim("email", email)
			.claim("nickname", nickname)
			.setIssuedAt(now)
			.setExpiration(expiry)
			.signWith(key)
			.compact();
	}

	public Long getUserId(String token) {
		Claims claims = parseClaims(token);
		return Long.valueOf(claims.getSubject());
	}

	public String getEmail(String token) {
		Claims claims = parseClaims(token);
		return claims.get("email", String.class);
	}

	public boolean validateToken(String token) {
		try {
			JwtParser parser = Jwts.parser()
				.verifyWith((SecretKey)key)
				.build();

			parser.parseSignedClaims(token);
			return true;
		} catch (MalformedJwtException | UnsupportedJwtException | IllegalArgumentException e) {
			return false;
		} catch (ExpiredJwtException e) {
			return false;
		} catch (JwtException e) {
			return false;
		}
	}

	private Claims parseClaims(String token) {
		try {
			JwtParser parser = Jwts.parser()
				.verifyWith((SecretKey)key)
				.build();

			return parser.parseSignedClaims(token).getPayload();
		} catch (ExpiredJwtException e) {
			return e.getClaims();
		}
	}
}
