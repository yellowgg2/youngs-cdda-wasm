#!/bin/bash
# Emscripten용 mmap 패치 적용 스크립트
# WASM에서는 mmap이 제대로 동작하지 않으므로 fread로 대체

set -e

MMAP_FILE="src/mmap_file.cpp"

# 백업 생성
cp "$MMAP_FILE" "${MMAP_FILE}.bak"

# Python으로 패치 적용 (sed보다 안정적)
python3 << 'PYTHON_SCRIPT'
import re

with open("src/mmap_file.cpp", "r") as f:
    content = f.read()

# 1. 파일 상단에 Emscripten include 추가 (이미 없는 경우만)
if "#ifdef __EMSCRIPTEN__" not in content:
    emscripten_include = """#ifdef __EMSCRIPTEN__
#include <cstdio>
#include <cstdlib>
#endif

"""
    content = emscripten_include + content

# 2. map_file 함수의 #else 이전에 Emscripten 구현 추가
# "#else" 다음에 Unix mmap 코드가 시작되는 부분 찾기
# 패턴: #ifdef _WIN32 ... 긴 Windows 코드 ... #else

emscripten_impl = """#elif defined(__EMSCRIPTEN__)
    // Emscripten: use fread instead of mmap (mmap doesn't work properly in WASM)
    FILE *f = fopen( file_path.native().c_str(), "rb" );
    if( !f ) {
        return mapped_file;
    }
    fseek( f, 0, SEEK_END );
    long file_size = ftell( f );
    fseek( f, 0, SEEK_SET );
    if( file_size <= 0 ) {
        fclose( f );
        return mapped_file;
    }
    uint8_t *data = static_cast<uint8_t *>( malloc( file_size ) );
    if( !data ) {
        fclose( f );
        return mapped_file;
    }
    size_t bytes_read = fread( data, 1, file_size, f );
    fclose( f );
    if( bytes_read != static_cast<size_t>( file_size ) ) {
        free( data );
        return mapped_file;
    }
    mapped_file = std::shared_ptr<mmap_file>{ new mmap_file() };
    mapped_file->base = data;
    mapped_file->len = file_size;
#else"""

# map_file 함수 내의 #else 찾기 (mapped_file->len = file_size.QuadPart; 이후의 #else)
# 정규식으로 Windows 구현 끝 부분 이후의 #else 찾기
pattern = r'(mapped_file->len = file_size\.QuadPart;\s*\n)(#else)'
replacement = r'\1' + emscripten_impl
content = re.sub(pattern, replacement, content)

with open("src/mmap_file.cpp", "w") as f:
    f.write(content)

print("Patch applied successfully!")
PYTHON_SCRIPT

# 결과 확인
if grep -q "EMSCRIPTEN" "$MMAP_FILE" && grep -q "fread" "$MMAP_FILE"; then
    echo "mmap patch applied successfully"
    grep -n "EMSCRIPTEN\|fread" "$MMAP_FILE"
else
    echo "Patch application failed!"
    exit 1
fi
