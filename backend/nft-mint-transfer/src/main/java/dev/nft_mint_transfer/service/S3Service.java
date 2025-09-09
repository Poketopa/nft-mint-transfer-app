package dev.nft_mint_transfer.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.IOException;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class S3Service {

    private final S3Client s3Client;

    @Value("${aws.s3.bucket}")
    private String bucketName;

    public String uploadImage(MultipartFile file, String folder) {
        try {
            // 파일명 생성 (UUID + 원본 파일명)
            String fileName = generateFileName(file.getOriginalFilename());
            String key = folder + "/" + fileName;

            // S3에 업로드
            PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .contentType(file.getContentType())
                    .build();

            s3Client.putObject(putObjectRequest, RequestBody.fromInputStream(
                    file.getInputStream(), file.getSize()));

            // 업로드된 파일의 URL 반환
            return String.format("https://%s.s3.amazonaws.com/%s", bucketName, key);

        } catch (IOException e) {
            log.error("파일 업로드 중 오류 발생: {}", e.getMessage());
            throw new RuntimeException("파일 업로드에 실패했습니다.", e);
        }
    }

    private String generateFileName(String originalFileName) {
        String extension = "";
        if (originalFileName != null && originalFileName.contains(".")) {
            extension = originalFileName.substring(originalFileName.lastIndexOf("."));
        }
        return UUID.randomUUID().toString() + extension;
    }
}
