# Heroku buildpack for Imagick

This is a Heroku buildpack for adding Imagick with support for:
- jng
- jpeg
- png
- webp
- zlib

Please submit a PR or an issue for more support.

We're currently using it for our [craftcms](https://craftcms.com/) websites. This buildpack is the last buildpack in the buildpack list at our projects.

## Using this buildpack in Heroku

1. Add the buildpack to your app:
  ```bash
  heroku buildpacks:set https://github.com/nerds-and-company/heroku-buildpack-imagick -a my-app
  ```

2. Add `"ext-redis": "*",` to your `composer.json`

Note: First time build will take 7-10 minutes. Second build will use the cache. Updating a version is currently not possible (see [TODO](#TODO))

## Features
- Always using the latest version of libwebp
- Always using version v8c of jpegsrc
- Always using version 1.2.11 of zlib (dependency of libpng)
- Always using version 1.6.37 of libpng
- Always using the latest version of image magick
- Always using version 3.4.4 of Imagick
- It will add `extension=imagick.so`

## TODO
- Make versioning dynamically by using an environment variable, otherwise use latest version (how it currently works)
- Clear the cache to update a version
- Try to not make use of `"ext-redis": "*",` in the `composer.json`
