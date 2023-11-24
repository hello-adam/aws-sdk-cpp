#!/bin/sh

INSTALL_DIR="$(pwd)/dist"

cmake -G Ninja -B builddeps -S thirdparty -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" -DCMAKE_BUILD_TYPE=Release \
&& cmake --build builddeps \
&& cmake --install builddeps \
&& cmake -G Ninja -B build \
-DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
-DCMAKE_BUILD_TYPE=Release \
-DUSE_OPENSSL=ON \
-DENABLE_TESTING=OFF \
-DUSE_CRT_HTTP_CLIENT=ON \
-DMINIMIZE_SIZE=ON \
-DBUILD_ONLY="cognito-idp;cognito-identity;dynamodb" \
-DBUILD_SHARED_LIBS=OFF \
-DCMAKE_POSITION_INDEPENDENT_CODE=ON \
-DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" \
-DAWS_SDK_WARNINGS_ARE_ERRORS=OFF \
-DOPENSSL_ROOT_DIR="${INSTALL_DIR}" \
-DOPENSSL_USE_STATIC_LIBS=ON \
-DZLIB_ROOT="${INSTALL_DIR}" \
-DZLIB_USE_STATIC_LIBS=ON \
&& cmake --build build \
&& cmake --install build \
&& rm -rf dist/share dist/ssl