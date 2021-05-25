function install_webp() {
  LIBWEBP_CACHE_FILE="$CACHE_DIR/libwebp.tar.gz"
  LIBWEBP_INSTALL_DIR="$VENDOR_DIR/libwebp"
  LIBWEBP_PROFILE_PATH="$BUILD_DIR/.profile.d/libwebp.sh"
  LIBWEBP_RUNTIME_INSTALL_PATH="$HOME/vendor/libwebp"
  LIBWEBP_VERSION=`wget -q -O - https://storage.googleapis.com/downloads.webmproject.org/releases/webp/index.html | sed 's/^.*href="\/\/storage\.googleapis\.com\/downloads\.webmproject\.org\/releases\/webp\/libwebp-\([^"]\+\)\.tar\.gz".*/\1/p;d' | tail -n "${1:-1}" | head -n 1`

  mkdir -p $LIBWEBP_INSTALL_DIR

  if [ ! -f $LIBWEBP_CACHE_FILE ]; then
    echo "-----> Downloading libwebp version $LIBWEBP_VERSION"
    wget "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-$LIBWEBP_VERSION.tar.gz"

    echo "-----> Extracting libwebp"
    tar xvzf "libwebp-$LIBWEBP_VERSION.tar.gz"

    echo "-----> Building libwebp"
    cd "libwebp-$LIBWEBP_VERSION"
    ./configure --prefix=$LIBWEBP_INSTALL_DIR
    make
    make install
    cd ..
    rm -rf "libwebp-$LIBWEBP_VERSION"

    echo "-----> Caching libwebp"
    cd $VENDOR_DIR
    tar czf libwebp.tar.gz libwebp

    mv libwebp.tar.gz $LIBWEBP_CACHE_FILE
  else
    echo "-----> Extracting libwebp from cache"
    tar xzf $LIBWEBP_CACHE_FILE -C $VENDOR_DIR
  fi

  echo "-----> Building runtime environment"
  mkdir -p $(dirname $LIBWEBP_PROFILE_PATH)
  echo "export PATH=$LIBWEBP_RUNTIME_INSTALL_PATH/bin:\$PATH" >> $LIBWEBP_PROFILE_PATH
  echo "export LD_LIBRARY_PATH=$LIBWEBP_RUNTIME_INSTALL_PATH/lib:\$LD_LIBRARY_PATH" >> $LIBWEBP_PROFILE_PATH
}
