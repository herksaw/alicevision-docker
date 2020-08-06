ARG CUDA_TAG=10.2
ARG OS_TAG=20.04
ARG NPROC=1
FROM alicevision/alicevision-deps:cuda${CUDA_TAG}-ubuntu${OS_TAG}
LABEL maintainer="herksaw@gmail.com"

ENV AV_DEV=/opt/AliceVision_git \
    AV_BUILD=/tmp/AliceVision_build \
    AV_INSTALL=/opt/AliceVision_install \
    AV_BUNDLE=/opt/AliceVision_bundle \
    PATH="${PATH}:${AV_BUNDLE}" \
    VERBOSE=1

COPY . "${AV_DEV}"

WORKDIR "${AV_BUILD}"

RUN cmake -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS:BOOL=ON \
        -DTARGET_ARCHITECTURE=core \
        -DALICEVISION_BUILD_DEPENDENCIES:BOOL=OFF \
        -DCMAKE_PREFIX_PATH:PATH="${AV_INSTALL}" \
        -DCMAKE_INSTALL_PREFIX:PATH="${AV_INSTALL}" \
        -DALICEVISION_BUNDLE_PREFIX="${AV_BUNDLE}" \
        -DALICEVISION_USE_ALEMBIC:BOOL=ON \
        -DMINIGLOG:BOOL=ON \
        -DALICEVISION_USE_CCTAG:BOOL=ON \
        -DALICEVISION_USE_OPENCV:BOOL=ON \
        -DALICEVISION_USE_OPENGV:BOOL=ON \
        -DALICEVISION_USE_POPSIFT:BOOL=ON \
        -DALICEVISION_USE_CUDA:BOOL=ON \
        -DALICEVISION_BUILD_DOC:BOOL=OFF \
        -DALICEVISION_BUILD_EXAMPLES:BOOL=OFF \
        "${AV_DEV}" && \
\
   make install -j$(nproc) && \
   make bundle && \
   cd /opt && \
   rm -rf "${AV_BUILD}"
