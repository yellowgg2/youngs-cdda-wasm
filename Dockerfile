# Emscripten SDK 기반 이미지 사용 (CDDA에서 사용하는 버전)
FROM emscripten/emsdk:3.1.51

# 작업 디렉토리 설정
WORKDIR /app

# 필요한 패키지 설치
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    gettext \
    ccache \
    astyle \
    libsdl2-dev \
    libsdl2-ttf-dev \
    libsdl2-image-dev \
    libsdl2-mixer-dev \
    && rm -rf /var/lib/apt/lists/*

# CDDA 저장소 클론 (0.H 안정 릴리스)
# 0.H-RELEASE는 WASM 빌드를 지원하는 안정 버전입니다
RUN git clone --depth=1 --branch 0.H-RELEASE https://github.com/CleverRaven/Cataclysm-DDA.git /app/cdda

# 작업 디렉토리를 클론된 저장소로 변경
WORKDIR /app/cdda

# Emscripten용 mmap 패치 적용
# WASM에서는 mmap이 제대로 동작하지 않으므로 fread로 대체
COPY patches/apply_mmap_patch.sh /tmp/
RUN chmod +x /tmp/apply_mmap_patch.sh && /tmp/apply_mmap_patch.sh

# 한글 언어팩을 포함한 모든 번역 파일 컴파일
# po 파일이 있으면 mo 파일로 컴파일
RUN if [ -f lang/compile_mo.sh ]; then \
        chmod +x lang/compile_mo.sh && \
        lang/compile_mo.sh; \
    fi

# WASM 빌드 실행
# TILES=1: 타일 그래픽 활성화
# RELEASE=1: 릴리스 빌드 (최적화)
# LOCALIZE=1: 다국어 지원 활성화
# LANGUAGES="all": 모든 언어 포함 (ko 포함)
RUN chmod +x build-scripts/build-emscripten.sh && \
    make -j$(nproc) NATIVE=emscripten BACKTRACE=0 TILES=1 TESTS=0 \
    RUNTESTS=0 RELEASE=1 CCACHE=0 LINTJSON=0 LOCALIZE=1 \
    LANGUAGES="ko en" cataclysm-tiles.js

# 웹 데이터 준비 (게임 리소스 번들링) + 언어 파일 포함
RUN chmod +x build-scripts/prepare-web.sh && \
    build-scripts/prepare-web.sh && \
    if [ -d lang/mo ]; then \
        echo "=== Adding Korean language file ===" && \
        mkdir -p web_bundle/lang/mo/ko/LC_MESSAGES && \
        cp lang/mo/ko/LC_MESSAGES/cataclysm-dda.mo web_bundle/lang/mo/ko/LC_MESSAGES/ && \
        echo "=== Regenerating data file ===" && \
        $EMSDK/upstream/emscripten/tools/file_packager cataclysm-tiles.data \
            --js-output=cataclysm-tiles.data.js \
            --no-node \
            --preload web_bundle@/ \
            --lz4 && \
        cp cataclysm-tiles.data cataclysm-tiles.data.js build/; \
    fi

# emrun 기본 포트 노출
EXPOSE 6931

# emrun으로 실행 (빌드 결과물이 있는 web 디렉토리에서)
CMD ["emrun", "--no_browser", "--hostname", "0.0.0.0", "--port", "6931", "/app/cdda/build/index.html"]
