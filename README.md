# CDDA WASM Docker

[한글](README.ko.md)

A Docker setup for running [Cataclysm: Dark Days Ahead](https://github.com/CleverRaven/Cataclysm-DDA) WebAssembly (WASM) version in your browser.

## About Cataclysm: Dark Days Ahead

Cataclysm: Dark Days Ahead is a turn-based survival game set in a post-apocalyptic world. Struggle to survive in a harsh, persistent, procedurally generated world. Scavenge the remnants of a dead civilization for food, equipment, or, if you are lucky, a vehicle with a full tank of gas to get you out of Dodge.

## Prerequisites

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/yellowgg2/youngs-cdda-wasm.git
   cd youngs-cdda-wasm
   ```

2. Build and run the container:
   ```bash
   docker compose up -d --build
   ```

3. Open your browser and navigate to:
   ```
   http://localhost:6931
   ```

4. Enjoy the game!

## Container Management

### Start the container
```bash
docker compose up -d
```

### Stop the container
```bash
docker compose down
```

### View logs
```bash
docker compose logs -f cdda-wasm
```

### Rebuild the container
```bash
docker compose up -d --build
```

## Technical Details

- **Base Image**: `emscripten/emsdk:3.1.51`
- **Port**: 6931
- **CDDA Version**: 0.H-RELEASE (Herbert) - stable release with WASM support
- **Build Type**: Release build with tiles and localization support
- **Languages**: Korean (한글) and English only
- **Server**: Emscripten's `emrun` development server

### Build Features

- Built directly from the latest [CDDA GitHub repository](https://github.com/CleverRaven/Cataclysm-DDA)
- Includes tile graphics for enhanced visual experience
- Korean (한글) and English language support
- Optimized release build for better performance
- Faster build time and smaller image size by including only essential languages

## Project Structure

```
.
├── Dockerfile          # Container build instructions
├── docker-compose.yml  # Docker Compose configuration
├── README.md           # This file (English)
└── README.ko.md        # Korean documentation
```

## License

This Docker setup is provided as-is. Cataclysm: Dark Days Ahead is licensed under [CC-BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/).

## Links

- [Cataclysm: DDA GitHub](https://github.com/CleverRaven/Cataclysm-DDA)
- [CDDA Official Website](https://cataclysmdda.org/)
- [CDDA Wiki](https://cddawiki.chezzo.com/cdda_wiki/index.php)
