# submodule

Small gem to simplify building process of gems with git submodules. Tended to be used for ruby gems which wrap js libraries or another assets

## Usage

Install gem or add it to `Gemfile` then put in your `Rakefile`:

```ruby
require 'submodule'
class SomeSubmodule  < Submodule::Task
    def test
      # run tests of submodule
    end

    def after_pull
      # do something
    end
end
SomeSubmodule.new
```
