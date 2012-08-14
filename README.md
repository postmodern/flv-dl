# flv-dl

* [Homepage](https://github.com/sophsec/flv-dl#readme)
* [Issues](https://github.com/sophsec/flv-dl/issues)
* [Documentation](http://rubydoc.info/gems/flv-dl/frames)
* [Email](mailto:postmodern.mod3 at gmail.com)

## Description

Downloads or plays Flash Video (`.flv`) file directly from their web-page.

## Why?

Because **fuck flash**, that's why.

## Features

* Extracts `flashvars` from:
  * `param` tags.
  * `embed` / `object` tags.
  * JavaScript

## TODO

* Support extracting Video URLs from XML/JSON config files.
* Add specs for {FLV::Video} against major Flash Video websites
  (yes, even the sketchy porn sites.)

## Synopsis

Downloads a video:

    flv-dl "URL"
    flv-dl -o video.flv "URL"

Plays a video:

    export VIDEO_PLAYER=mplayer
    flv-dl -p "URL"

List available formats / URLs:

    flv-dl -U "URL"

Dumps the collected `flashvars`:

    flv-dl -D "URL"

## Requirements

* [uri-query_params](https://github.com/postmodern/uri-query_params) ~> 0.6
* [nokogiri](https://github.com/tenderlove/nokogiri) ~> 1.4

## Install

    $ gem install flv-dl

## Copyright

Copyright (c) 2012 Postmodern

See {file:LICENSE.txt} for details.
