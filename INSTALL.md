# Installation

This document outlines the required versions of tools and software used in the project.

## Requirements

### rbenv

To manage Ruby versions, you should have `rbenv` installed. The Ruby Environment version being used is:

Check the version: `rbenv --version`, Output: `rbenv 1.3.2`

Set the local Ruby version: `rbenv local 3.2.0`

Check if it is set: `rbenv local`, Output: `3.2.0`

### Ruby

The Ruby version used in the project is:

Check version: `ruby --version`, Output: `ruby 3.2.0 (2022-12-25 revision a528908271) [arm64-darwin24]`

### Bundler

Bundler is used to manage the dependencies for the project. The version being used is:

Check version: `bundle --version`, Output: `Bundler version 2.4.1`

### Gem

RubyGems version for managing gems:

Check version: `gem --version`, Output: `3.4.1`

### Fastlane

Fastlane will be used for iOS deployment automation. The version in use is:

Check version: `bundle exec fastlane --version`

Output: 

```
fastlane installation at path:
$HOME/.rbenv/versions/3.2.0/lib/ruby/gems/3.2.0/gems/fastlane-2.227.1/bin/fastlane
-----------------------------
[✔] 🚀 
fastlane 2.227.1
```

## Installation Steps

1. Install `rbenv` using Homebrew: `brew install rbenv`

Add the following to your shell configuration file (e.g., .zshrc, .bash_profile, or .bashrc):

```
# Path to rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then
  eval "$(rbenv init -)"
fi
```

After editing the file, reload your shell: `source ~/.zshrc` (or the appropriate file)

2. Install Ruby 3.2.0:

```
rbenv install 3.2.0
rbenv local 3.2.0
```

3. Install project dependencies: `bundle install`

## Notes

Always run Fastlane through `bundle exec fastlane <command>` to ensure you're using the locked version in your project.