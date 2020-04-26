# rocks

Uni programming project

## Install

Make sure you have [Bundler](https://bundler.io/) to install the project's
dependencies.

After that, we need to install some dependencies for [Gosu](https://github.com/gosu/gosu).
Follow the [installation guide](https://github.com/gosu/gosu/wiki#installation)
to get started. You can skip this if you're using Windows.

Then, we install the dependencies with Bundler:

```bash
# Install all dependencies
$ bundle install

# Or install for production only
$ bundle install --without dev
```

## Play

```bash
# Execute ruby with bundler
$ bundle exec ruby rocks.rb

# or use Rake
$ bundle exec rake start
```

## License

MIT
