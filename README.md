# Lightweight DI Container for Crystal
[![Build Status](https://travis-ci.org/funk-yourself/crystal-di.svg?branch=master)](https://travis-ci.org/funk-yourself/crystal-di)

![alt text](http://imgur.com/GQ3lD0m.png "Crystal-DI")

Crystal-DI is a flexible DI-container with simple DSL, auto-injection, memoization, lazy evaluation and contextual bindings.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  di:
    github: funk-yourself/crystal-di
    version: ~> 0.2.0
```

## Usage

It's as simple as:
```crystal
require "di"

module Container # may be a class as well
  include DI::ContainerMixin

  register Foo, Foo.new
end

Container.resolve(Foo)
```

You can also use blocks:

```Crystal
register Bar, Bar.new

register Foo do
  logger = Logger.new(STDOUT)
  logger.level = Logger::WARN
  Foo.new(resolve(Bar), logger)
end
```

## Auto-injection

```crystal
module Container
  include DI::ContainerMixin

  register AppService, AppService.new
end

class AppService
end

class Controller
  include DI::AutoInject(Container)

  def initialize(@app_service : AppService)
    p @app_service
  end
end

Controller.new
```

## Memoization
Sometimes you need to be sure that there's only one instance of some service. You can achieve that with *memoize* option:

```Crystal
# Will be evaluated only one time
register AppService, AppService.new, memoize: true
```

## Contextual bindings
You can bind container items to any class with *context* option:

```Crystal
register AppService, AppService.new, context: Controller
```

It means that you can resolve this item by calling

```Crystal
Container.resolve(AppService, context: Controller)
```

But the main purpose is ability to auto-inject different implementations of abstract class/interface into different classes:

```Crystal
require "di"

module Container
  include DI::ContainerMixin
  register Storage, RedisStorage.new, context: UsersController
  register Storage, MemcachedStorage.new, context: PostsController
end

abstract class Storage
end

class RedisStorage < Storage
end

class MemcachedStorage < Storage
end

class UsersController
  include DI::AutoInject(Container)

  def initialize(@storage : Storage)
    p @storage
  end
end

class PostsController
  include DI::AutoInject(Container)

  def initialize(@storage : Storage)
    p @storage
  end
end

UsersController.new # will print RedisStorage
PostsController.new # will print MemcachedStorage
```


## Development

Run tests:
```
crystal spec
```

## Contributing

1. Fork it ( https://github.com/funk-yourself/crystal-di/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [funk-yourself](https://github.com/funkthis) (Vladislav Yashin)  - creator, maintainer
