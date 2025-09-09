package dev.nft_mint_transfer.controller;

import dev.nft_mint_transfer.dto.request.LoginRequest;
import dev.nft_mint_transfer.dto.request.SignUpRequest;
import dev.nft_mint_transfer.dto.response.AuthResponse;
import dev.nft_mint_transfer.dto.response.SignUpResponse;
import dev.nft_mint_transfer.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Tag(name = "인증", description = "회원가입, 로그인 API")
public class AuthController {

    private final UserService userService;

    @PostMapping(value = "/signup", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(
        summary = "회원가입",
        description = "새로운 사용자를 등록합니다. 프로필 이미지는 선택사항입니다."
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "회원가입 성공",
            content = @Content(mediaType = "application/json",
                schema = @Schema(implementation = SignUpResponse.class),
                examples = @ExampleObject(
                    name = "성공 예시",
                    value = """
                        {
                          "userId": 1
                        }
                        """
                )
            )
        ),
        @ApiResponse(responseCode = "400", description = "잘못된 요청 (중복 이메일/닉네임, 유효성 검증 실패)"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<SignUpResponse> signUp(
        @RequestPart("request") @Valid SignUpRequest request,
        @Parameter(description = "프로필 이미지 파일 (선택사항)", 
                   example = "profile.jpg",
                   schema = @Schema(type = "string", format = "binary"))
        @RequestPart(value = "profileImage", required = false) MultipartFile profileImage
    ) {
        log.info("회원가입 요청: {}", request.getEmail());
        
        SignUpResponse response = userService.signUp(request, profileImage);
        
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PostMapping("/login")
    @Operation(
        summary = "로그인", 
        description = "이메일과 비밀번호로 로그인합니다."
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "로그인 성공",
            content = @Content(mediaType = "application/json",
                schema = @Schema(implementation = AuthResponse.class),
                examples = @ExampleObject(
                    name = "성공 예시",
                    value = """
                        {
                          "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
                        }
                        """
                )
            )
        ),
        @ApiResponse(responseCode = "400", description = "잘못된 요청 (존재하지 않는 이메일, 비밀번호 불일치)"),
        @ApiResponse(responseCode = "500", description = "서버 오류")
    })
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        
        log.info("로그인 요청: {}", request.getEmail());
        
        AuthResponse response = userService.login(request);
        
        return ResponseEntity.ok(response);
    }
}
