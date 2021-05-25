function install_image_magick() {
  IMAGE_MAGICK_CACHE_FILE="$CACHE_DIR/image_magick.tar.gz"
  IMAGE_MAGICK_INSTALL_DIR="$VENDOR_DIR/image_magick"
  IMAGE_MAGICK_PROFILE_PATH="$BUILD_DIR/.profile.d/image_magick.sh"
  IMAGE_MAGICK_RUNTIME_INSTALL_PATH="$HOME/vendor/image_magick"
  IMAGE_MAGICK_VERSION=`wget -q -O - https://www.imagemagick.org/download/releases/ | sed 's/^.*href="ImageMagick-\([^"]\+\)\.tar\.gz".*/\1/p;d' | tail -n "${1:-1}" | head -n 1`

  mkdir -p $IMAGE_MAGICK_INSTALL_DIR

  if [ ! -f $IMAGE_MAGICK_CACHE_FILE ]; then
    echo "-----> Downloading Image Magick version $IMAGE_MAGICK_VERSION"
    wget "https://www.imagemagick.org/download/releases/ImageMagick-$IMAGE_MAGICK_VERSION.tar.xz"

    echo "-----> Extracting Image Magick"
    tar xvf "ImageMagick-$IMAGE_MAGICK_VERSION.tar.xz"

    echo "-----> Building Image Magick"
    cd "ImageMagick-$IMAGE_MAGICK_VERSION"
    ./configure --with-webp=yes --with-jpg=yes --with-png=yes --prefix=$IMAGE_MAGICK_INSTALL_DIR
    make
    make install
    cd ..
    rm -rf "ImageMagick-$IMAGE_MAGICK_VERSION"

    echo "-----> Caching Image Magick"
    cd $VENDOR_DIR
    tar czf image_magick.tar.gz image_magick

    mv image_magick.tar.gz $IMAGE_MAGICK_CACHE_FILE
  else
    echo "-----> Extracting Image Magick from cache"
    tar xzf $IMAGE_MAGICK_CACHE_FILE -C $VENDOR_DIR
  fi

  echo "-----> Building runtime environment"
  mkdir -p $(dirname $IMAGE_MAGICK_PROFILE_PATH)
  echo "export PATH=$IMAGE_MAGICK_RUNTIME_INSTALL_PATH/bin:\$PATH" >> $IMAGE_MAGICK_PROFILE_PATH
  echo "export LD_LIBRARY_PATH=$IMAGE_MAGICK_RUNTIME_INSTALL_PATH/lib:\$LD_LIBRARY_PATH" >> $IMAGE_MAGICK_PROFILE_PATH
}
