
SET /A INSTALL_DIR=%~dp0\dist
echo Base Dir: %~dp0
echo Install Dir: %INSTALL_DIR%

cmake -B builddeps -S thirdparty -G "Visual Studio 17 2022" -DCMAKE_BUILD_TYPE=MinSizeRel -A x64 -T v141 || goto :error
cmake --build builddeps || goto :error
cmake --install builddeps || goto :error
cmake -G Ninja -B build ^
 -DCMAKE_BUILD_TYPE=MinSizeRel^
 -DUSE_OPENSSL=ON ^
 -DENABLE_TESTING=OFF ^
 -DUSE_CRT_HTTP_CLIENT=ON ^
 -DMINIMIZE_SIZE=ON ^
 -DBUILD_ONLY="cognito-idp;cognito-identity;dynamodb" ^
 -DBUILD_SHARED_LIBS=OFF ^
 -DCMAKE_POSITION_INDEPENDENT_CODE=ON ^
 -DCMAKE_INSTALL_PREFIX=%INSTALL_DIR% ^
 -DAWS_SDK_WARNINGS_ARE_ERRORS=OFF ^
 -DOPENSSL_ROOT_DIR=%INSTALL_DIR% ^
 -DOPENSSL_USE_STATIC_LIBS=ON ^
 -DZLIB_ROOT=%INSTALL_DIR% ^
 -DZLIB_USE_STATIC_LIBS=ON || goto :error
 
cmake --build build || goto :error
cmake --install build || goto :error

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%