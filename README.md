# lita-onewheel-beer-wework

[![Build Status](https://travis-ci.org/onewheelskyward/lita-onewheel-beer-wework.png?branch=master)](https://travis-ci.org/onewheelskyward/lita-onewheel-beer-wework)
[![Coverage Status](https://coveralls.io/repos/onewheelskyward/lita-onewheel-beer-wework/badge.png)](https://coveralls.io/r/onewheelskyward/lita-onewheel-beer-wework)

This plugin was designed to store WeWork's beer as sort of a shared bookmark store for work.  We use Confluence, which has a pretty
ridiculous URI structure, and I wanted to find a way to store the location of things like the deploy instructions,
how to nombom, and ways to make fun of my coworkers.

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
`!doc key https://value`  | Stores https://value under the key key.  Note, web links are not enforced.  You can store emoji if you like.
`!doc key`                | Find all documents starting with, or equal to key.
`!doc`                    | list all keys.
`!docdel key`             | Remove key from the store.

## To be implemented

Make !doc key substring search instead of starts-with.
