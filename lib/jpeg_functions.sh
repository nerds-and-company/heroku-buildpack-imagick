function install_jpeg() {
  JPEG_CACHE_FILE="$CACHE_DIR/jpeg.tar.gz"
  JPEG_INSTALL_DIR="$VENDOR_DIR/jpeg"
  JPEG_PROFILE_PATH="$BUILD_DIR/.profile.d/jpeg.sh"
  JPEG_RUNTIME_INSTALL_PATH="$HOME/vendor/jpeg"

  mkdir -p $JPEG_INSTALL_DIR

  if [ ! -f $JPEG_CACHE_FILE ]; then
    echo "-----> Downloading jpeg version v8c"
    wget "http://www.ijg.org/files/jpegsrc.v8c.tar.gz"

    echo "-----> Extracting jpeg"
    tar xvzf "jpegsrc.v8c.tar.gz"

    echo "-----> Building jpeg"
    cd "jpeg-8c"
    ./configure --prefix=$JPEG_INSTALL_DIR
    make
    make install
    cd ..
    rm -rf "jpeg-8c"

    echo "-----> Caching jpeg"
    cd $VENDOR_DIR
    tar czf jpeg.tar.gz jpeg

    mv jpeg.tar.gz $JPEG_CACHE_FILE
  else
    echo "-----> Extracting jpeg from cache"
    tar xzf $JPEG_CACHE_FILE -C $VENDOR_DIR
  fi

  echo "-----> Building runtime environment"
  mkdir -p $(dirname $JPEG_PROFILE_PATH)
  echo "export PATH=$JPEG_RUNTIME_INSTALL_PATH/bin:\$PATH" >> $JPEG_PROFILE_PATH
  echo "export LD_LIBRARY_PATH=$JPEG_RUNTIME_INSTALL_PATH/lib:\$LD_LIBRARY_PATH" >> $JPEG_PROFILE_PATH

  echo "-----> Exporting runtime environment"
  export PATH=$JPEG_INSTALL_DIR/bin:$PATH
  export LD_LIBRARY_PATH=$JPEG_INSTALL_DIR/lib:$LD_LIBRARY_PATH
  export PKG_CONFIG_PATH=$JPEG_INSTALL_DIR/lib/pkgconfig:$PKG_CONFIG_PATH
  export CPPFLAGS="-I$JPEG_INSTALL_DIR/include $CPPFLAGS"
}
