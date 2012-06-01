# submodule

Small gem to simplify building process of gems with git submodules. Tended to be used for ruby gems which wrap js libraries or another assets

## Usage

Install gem or add it to `Gemfile` then put in your `Rakefile`:

```ruby
require 'submodule'
Submodule::Task.new do |t|
    t.test do
      # run tests of submodule
    end

    t.after_pull do
      # do something
    end
end
```

## Alternatives

### [vendorer](https://github.com/grosser/vendorer)
Submodule support only git. Submodule use `.gitmodules` as config, but vendorer use `Vendorfile`

## TODO

 - Implement: upgrade submodule to the latest version with passing tests