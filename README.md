# rocks

![CI](https://github.com/BjornLuG/rocks/workflows/CI/badge.svg)

Uni programming project. A classic space shooter.

## Install

This game is only tested with Ruby 2.6.5. Higher versions should work. Any version lower may break the game.

Make sure [Bundler](https://bundler.io/) is installed.

Depending on your OS, [Gosu](https://github.com/gosu/gosu) might need external dependencies for it to work. Follow its [installation guide](https://github.com/gosu/gosu/wiki#installation) to get started.

Then, install the dependencies with Bundler:

```bash
# Install all dependencies
$ bundle install
```

> If Bundler fails with `Can't find gem bundler (>= 0.a) with executable bundle (Gem::GemNotFoundException)`, try updating bundler with `gem install bundler`. [More info](https://bundler.io/blog/2019/01/04/an-update-on-the-bundler-2-release.html).

## Play

```bash
# Execute ruby with bundler
$ bundle exec ruby rocks.rb

# or use Rake
$ bundle exec rake start
```

## Development

Besides the commands above for play-testing, there are other rake commands for linting:

```bash
# Run Rubocop lint
$ bundle exec rake rubocop

# Autocorrect Rubocop fixable errors
$ bundle exec rake rubocop:auto_correct
```

## Attributions

- Game images: https://kenney.nl/assets/space-shooter-redux
- Menu music: https://www.dl-sounds.com/royalty-free/sci-fi-pulse-loop/
- Game music: https://www.dl-sounds.com/royalty-free/space-trip/

## License

MIT
