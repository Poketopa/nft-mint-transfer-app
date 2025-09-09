package dev.nft_mint_transfer.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "회원가입 응답")
public class SignUpResponse {

	@Schema(description = "사용자 ID", example = "1")
	private Long userId;
}
