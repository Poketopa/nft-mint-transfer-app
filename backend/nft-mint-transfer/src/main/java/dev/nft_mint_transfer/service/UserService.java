package dev.nft_mint_transfer.service;

import dev.nft_mint_transfer.config.JwtProvider;
import dev.nft_mint_transfer.dto.request.LoginRequest;
import dev.nft_mint_transfer.dto.request.SignUpRequest;
import dev.nft_mint_transfer.dto.response.AuthResponse;
import dev.nft_mint_transfer.dto.response.SignUpResponse;
import dev.nft_mint_transfer.entity.User;
import dev.nft_mint_transfer.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtProvider jwtProvider;
    private final S3Service s3Service;

    @Transactional
    public SignUpResponse signUp(SignUpRequest request, MultipartFile profileImage) {
        // 이메일 중복 확인
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("이미 존재하는 이메일입니다.");
        }

        // 닉네임 중복 확인
        if (userRepository.existsByNickname(request.getNickname())) {
            throw new IllegalArgumentException("이미 존재하는 닉네임입니다.");
        }

        // 프로필 이미지 업로드 (선택사항)
        String profileImageUrl = null;
        if (profileImage != null && !profileImage.isEmpty()) {
            profileImageUrl = s3Service.uploadImage(profileImage, "profile-images");
        }

        // 사용자 생성
        User user = User.builder()
                .email(request.getEmail())
                .nickname(request.getNickname())
                .password(passwordEncoder.encode(request.getPassword()))
                .profileImageUrl(profileImageUrl)
                .build();

        User savedUser = userRepository.save(user);

        return new SignUpResponse(savedUser.getId());
    }

    public AuthResponse login(LoginRequest request) {
        // 사용자 조회
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 이메일입니다."));

        // 비밀번호 확인
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
        }

        // JWT 토큰 생성
        String accessToken = jwtProvider.createToken(
                user.getId(),
                user.getEmail(),
                user.getNickname()
        );

        return new AuthResponse(accessToken);
    }
}
