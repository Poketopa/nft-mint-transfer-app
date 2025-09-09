package dev.nft_mint_transfer.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Schema(description = "로그인 요청")
public class LoginRequest {

    @NotBlank(message = "이메일은 필수입니다.")
    @Email(message = "올바른 이메일 형식이 아닙니다.")
    @Schema(description = "사용자 이메일", example = "user@example.com", required = true)
    private String email;

    @NotBlank(message = "비밀번호는 필수입니다.")
    @Schema(description = "사용자 비밀번호", example = "password123", required = true)
    private String password;
}
