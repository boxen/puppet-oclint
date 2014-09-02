# OCLint Puppet Module for Boxen

***

***note: now managed on [boxen fork](https://github.com/boxen/puppet-oclint)***

***

Install OSX package for [OCLint](http://oclint.org/)

[![Build Status](https://travis-ci.org/tommeier/puppet-oclint.svg?branch=master)](https://travis-ci.org/tommeier/puppet-oclint)

## Usage

```puppet
include oclint
include oclint::dev
```

## Required Puppet Modules

* `boxen`

## Development

Set `GITHUB_API_TOKEN` in your shell with a [Github oAuth Token](https://help.github.com/articles/creating-an-oauth-token-for-command-line-use) to raise your API rate limit. You can get some work done without it, but you're less likely to encounter errors like `Unable to find module 'boxen/puppet-boxen' on https://github.com`.

Then write some code. Run `script/cibuild` to test it. Check the `script`
directory for other useful tools.
