function install_imagick() {
  IMAGICK_CACHE_FILE="$CACHE_DIR/imagick.tar.gz"
  IMAGICK_INSTALL_DIR="$VENDOR_DIR/imagick"
  IMAGICK_PROFILE_PATH="$BUILD_DIR/.profile.d/imagick.sh"
  IMAGICK_RUNTIME_INSTALL_PATH="$HOME/vendor/imagick"
  PHP_EXT_DIR=$(php-config --extension-dir)
  IMAGICK_INSTALL_FILE="$PHP_EXT_DIR/imagick.so"

  mkdir -p $IMAGICK_INSTALL_DIR

  if [ ! -f $IMAGICK_CACHE_FILE ]; then
    echo "-----> Downloading imagick version https://github.com/Imagick/imagick"
    git clone https://github.com/Imagick/imagick

    echo "-----> Building imagick"
    cd "imagick"
    phpize
    ./configure --prefix=$IMAGICK_INSTALL_DIR --with-imagick=$VENDOR_DIR/image_magick
    make
    mv modules/imagick.so $IMAGICK_INSTALL_FILE
    cd ..
    rm -rf "imagick"

    echo "-----> Caching imagick"
    cp $IMAGICK_INSTALL_FILE $IMAGICK_CACHE_FILE
  else
    echo "-----> Extracting imagick from cache"
    cp $IMAGICK_CACHE_FILE $IMAGICK_INSTALL_FILE
  fi

  echo "-----> Building runtime environment"
  mkdir -p $(dirname $IMAGICK_PROFILE_PATH)
  echo "export PATH=$IMAGICK_RUNTIME_INSTALL_PATH/bin:\$PATH" >> $IMAGICK_PROFILE_PATH
  echo "export LD_LIBRARY_PATH=$IMAGICK_RUNTIME_INSTALL_PATH/lib:\$LD_LIBRARY_PATH" >> $IMAGICK_PROFILE_PATH
}
