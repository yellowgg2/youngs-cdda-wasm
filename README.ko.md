# CDDA WASM Docker

[English](README.md)

[Cataclysm: Dark Days Ahead](https://github.com/CleverRaven/Cataclysm-DDA) WebAssembly(WASM) 버전을 브라우저에서 실행하기 위한 Docker 설정입니다.

## Cataclysm: Dark Days Ahead 소개

Cataclysm: Dark Days Ahead는 포스트 아포칼립스 세계를 배경으로 한 턴제 생존 게임입니다. 절차적으로 생성된 혹독한 세계에서 살아남기 위해 고군분투하세요. 멸망한 문명의 잔해에서 음식, 장비, 또는 운이 좋다면 연료가 가득 찬 차량을 찾아 탈출하세요.

## 사전 요구사항

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

## 빠른 시작

1. 저장소 클론:
   ```bash
   git clone https://github.com/yellowgg2/youngs-cdda-wasm.git
   cd youngs-cdda-wasm
   ```

2. 컨테이너 빌드 및 실행:
   ```bash
   docker compose up -d --build
   ```

3. 브라우저에서 접속:
   ```
   http://localhost:6931
   ```

4. 게임을 즐기세요!

## 컨테이너 관리

### 컨테이너 시작
```bash
docker compose up -d
```

### 컨테이너 중지
```bash
docker compose down
```

### 로그 확인
```bash
docker compose logs -f cdda-wasm
```

### 컨테이너 재빌드
```bash
docker compose up -d --build
```

## 기술 세부사항

- **베이스 이미지**: `emscripten/emsdk:3.1.51`
- **포트**: 6931
- **CDDA 버전**: 0.H-RELEASE (Herbert) - WASM을 지원하는 안정 릴리스
- **빌드 타입**: 타일 및 다국어 지원 릴리스 빌드
- **언어**: 한글과 영어만 포함
- **서버**: Emscripten의 `emrun` 개발 서버

### 빌드 기능

- 최신 [CDDA GitHub 저장소](https://github.com/CleverRaven/Cataclysm-DDA)에서 직접 빌드
- 향상된 시각적 경험을 위한 타일 그래픽 포함
- 한글과 영어 언어 지원
- 더 나은 성능을 위한 최적화된 릴리스 빌드
- 필수 언어만 포함하여 빠른 빌드 시간과 작은 이미지 크기

## 프로젝트 구조

```
.
├── Dockerfile          # 컨테이너 빌드 설정
├── docker-compose.yml  # Docker Compose 설정
├── README.md           # 영문 문서
└── README.ko.md        # 한글 문서 (현재 파일)
```

## 라이선스

이 Docker 설정은 있는 그대로 제공됩니다. Cataclysm: Dark Days Ahead는 [CC-BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/) 라이선스를 따릅니다.

## 링크

- [Cataclysm: DDA GitHub](https://github.com/CleverRaven/Cataclysm-DDA)
- [CDDA 공식 웹사이트](https://cataclysmdda.org/)
- [CDDA 위키](https://cataclysmdda.miraheze.org/wiki/Main_Page)
