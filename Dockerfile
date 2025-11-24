# Emscripten SDK 기반 이미지 사용
FROM emscripten/emsdk:latest

# 작업 디렉토리 설정
WORKDIR /app

# 필요한 패키지 설치
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# CDDA WASM 파일 다운로드 및 압축 해제
RUN wget -O cdda-wasm.zip https://github.com/CleverRaven/Cataclysm-DDA/releases/download/0.H-RELEASE/cdda-wasm-2024-11-23-0334.zip \
    && unzip cdda-wasm.zip \
    && rm cdda-wasm.zip

# emrun 기본 포트 노출
EXPOSE 6931

# emrun으로 index.html 실행
CMD ["emrun", "--no_browser", "--hostname", "0.0.0.0", "index.html"]
