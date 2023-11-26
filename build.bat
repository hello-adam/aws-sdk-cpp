

cmake -B builddeps -S thirdparty -G "Visual Studio 17 2022" -DCMAKE_BUILD_TYPE=MinSizeRel -A x64 -T v141 || goto :error
cmake --build builddeps || goto :error
cmake --install builddeps || goto :error
cmake -B build -G "Visual Studio 17 2022" -DCMAKE_BUILD_TYPE=MinSizeRel -A x64 -T v141 ^
 -DUSE_OPENSSL=ON ^
 -DENABLE_TESTING=OFF ^
 -DUSE_CRT_HTTP_CLIENT=ON ^
 -DMINIMIZE_SIZE=ON ^
 -DBUILD_ONLY="cognito-idp;cognito-identity;dynamodb" ^
 -DBUILD_SHARED_LIBS=OFF ^
 -DCMAKE_POSITION_INDEPENDENT_CODE=ON ^
 -DCMAKE_INSTALL_PREFIX=%~dp0%dist ^
 -DAWS_SDK_WARNINGS_ARE_ERRORS=OFF ^
 -DOPENSSL_ROOT_DIR=%~dp0%dist ^
 -DOPENSSL_USE_STATIC_LIBS=ON ^
 -DZLIB_ROOT=%~dp0%dist ^
 -DZLIB_USE_STATIC_LIBS=ON || goto :error
 
cmake --build build || goto :error
cmake --install build || goto :error

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%