package dev.nft_mint_transfer.repository;

import dev.nft_mint_transfer.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    /**
     * 이메일로 사용자 조회
     * @param email 사용자 이메일
     * @return 사용자 정보 (Optional)
     */
    Optional<User> findByEmail(String email);

    /**
     * 닉네임으로 사용자 조회
     * @param nickname 사용자 닉네임
     * @return 사용자 정보 (Optional)
     */
    Optional<User> findByNickname(String nickname);

    /**
     * 이메일 존재 여부 확인
     * @param email 사용자 이메일
     * @return 이메일 존재 여부
     */
    boolean existsByEmail(String email);

    /**
     * 닉네임 존재 여부 확인
     * @param nickname 사용자 닉네임
     * @return 닉네임 존재 여부
     */
    boolean existsByNickname(String nickname);
}

