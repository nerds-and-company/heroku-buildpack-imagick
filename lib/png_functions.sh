function install_png() {
  PNG_CACHE_FILE="$CACHE_DIR/png.tar.gz"
  PNG_INSTALL_DIR="$VENDOR_DIR/png"
  PNG_PROFILE_PATH="$BUILD_DIR/.profile.d/png.sh"
  PNG_RUNTIME_INSTALL_PATH="$HOME/vendor/png"

  mkdir -p $PNG_INSTALL_DIR

  if [ ! -f $PNG_CACHE_FILE ]; then
    echo "-----> Downloading zlib version 1.2.11"
    wget "http://www.zlib.net/zlib-1.2.11.tar.gz"

    echo "-----> Extracting zlib"
    tar xvzf "zlib-1.2.11.tar.gz"

    echo "-----> Building zlib"
    cd "zlib-1.2.11"
    ./configure --prefix=$PNG_INSTALL_DIR
    make
    make install
    cd ..
    rm -rf "zlib-1.2.11"

    echo "-----> Downloading png version 1.6.37"
    wget "https://download.sourceforge.net/libpng/libpng-1.6.37.tar.gz"

    echo "-----> Extracting png"
    tar xvzf "libpng-1.6.37.tar.gz"

    echo "-----> Building png"
    cd "libpng-1.6.37"
    ./configure --prefix=$PNG_INSTALL_DIR
    make
    make install
    cd ..
    rm -rf "libpng-1.6.37"

    echo "-----> Caching png"
    cd $VENDOR_DIR
    tar czf png.tar.gz png

    mv png.tar.gz $PNG_CACHE_FILE
  else
    echo "-----> Extracting png from cache"
    tar xzf $PNG_CACHE_FILE -C $PNG_INSTALL_DIR
  fi

  echo "-----> Building runtime environment"
  mkdir -p $(dirname $PNG_PROFILE_PATH)
  echo "export PATH=$PNG_RUNTIME_INSTALL_PATH/bin:\$PATH" >> $PNG_PROFILE_PATH
  echo "export LD_LIBRARY_PATH=$PNG_RUNTIME_INSTALL_PATH/lib:\$LD_LIBRARY_PATH" >> $PNG_PROFILE_PATH

  echo "-----> Exporting runtime environment"
  export PATH=$PNG_INSTALL_DIR/bin:$PATH
  export LD_LIBRARY_PATH=$PNG_INSTALL_DIR/lib:$LD_LIBRARY_PATH
  export PKG_CONFIG_PATH=$PNG_INSTALL_DIR/lib/pkgconfig:$PKG_CONFIG_PATH
  export CPPFLAGS="-I$PNG_INSTALL_DIR/include $CPPFLAGS"
}
