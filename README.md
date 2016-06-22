# lita-onewheel-beer-wework

[![Build Status](https://travis-ci.org/onewheelskyward/lita-onewheel-beer-wework.png?branch=master)](https://travis-ci.org/onewheelskyward/lita-onewheel-beer-wework)
[![Coverage Status](https://coveralls.io/repos/onewheelskyward/lita-onewheel-beer-wework/badge.png)](https://coveralls.io/r/onewheelskyward/lita-onewheel-beer-wework)

This plugin was designed to store WeWork's beer as sort of a shared beer locator for WeWork.

Thus, the plugin was born.  It'll store, quite literally, anything you like.

## Installation

Add lita-onewheel-beer-wework to your Lita instance's Gemfile:

``` ruby
gem 'lita-onewheel-beer-wework'
```

## Configuration

Just needs redis which you have because you're already running Lita.

## Usage
Command                   | Description
------------------------- | -------------
`!wework floor beer`  | Stores https://value under the key key.  Note, web links are not enforced.  You can store emoji if you like.
`!wework floor`       | Display beer from a given floor.
`!wework`             | list all beers.

