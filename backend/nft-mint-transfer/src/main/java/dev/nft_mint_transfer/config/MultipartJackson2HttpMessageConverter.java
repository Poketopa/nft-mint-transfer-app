package dev.nft_mint_transfer.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.http.MediaType;
import org.springframework.http.converter.json.AbstractJackson2HttpMessageConverter;
import org.springframework.stereotype.Component;

@Component
public class MultipartJackson2HttpMessageConverter extends AbstractJackson2HttpMessageConverter {

    public MultipartJackson2HttpMessageConverter(ObjectMapper objectMapper) {
        super(objectMapper, MediaType.APPLICATION_OCTET_STREAM);
    }

    @Override
    public boolean canRead(Class<?> clazz, MediaType mediaType) {
        return mediaType != null && (
                MediaType.APPLICATION_OCTET_STREAM.equals(mediaType) ||
                MediaType.APPLICATION_JSON.equals(mediaType) ||
                MediaType.TEXT_PLAIN.equals(mediaType)
        );
    }
}
