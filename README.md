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

Plays a video:

    flv-dl -p totem "URL"

List available formats / URLs:

    flv-dl -U "URL"

Dumps the collected `flashvars`:

    flv-dl -D "URL"

## Requirements

* [nokogiri](https://github.com/tenderlove/nokogiri) ~> 1.4

## Install

    $ gem install flv-dl

## Copyright

Copyright (c) 2012 Postmodern

See {file:LICENSE.txt} for details.
