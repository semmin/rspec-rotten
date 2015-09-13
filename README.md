# Rspec::Rotten

According to [pronounced James O Coplien essay](http://www.rbcs-us.com/documents/Why-Most-Unit-Testing-is-Waste.pdf),
most unit tests are waste. Particulary, James says:

>If you want to reduce your test mass, the number one
>thing you should do is look at the tests that have never
>failed in a year and consider throwing them away. They are
>producing no information for you — or at least very little
>information. The value of the information they produce may
>not be worth the expense of maintaining and running the
>tests. This is the first set of tests to throw away — whether
>they are unit tests, integration tests, or system tests.

This gem lets you track tests that haven't failed for given period of time,
and prompts you to "reduce test mass" by removing them.

## Installation

### Step 1

Add this line to your application's Gemfile:

```ruby
gem 'rspec-rotten'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-rotten

### Step 2

Create initializer and specify path to a file that will be storing stats of your
test runs, and, most importantly, _time period after which specs will be considered
"rotten"_, given they didn't change status(failed/passed/became pending):

```ruby
# config/initializers/rspec-rotten.rb
Rspec::Rotten::Configuration.configure do |config|
  config.results_file = Rails.root.join('output.json')
  config.time_to_rotten = 1.year
end
```

Also add this line to RSpec config in spec_helper/rails_helper:

```ruby
# spec/rails_helper.rb
RSpec.configure do |config|
  ...
  config.add_formatter(Rspec::Rotten::Formatters::RottenReportFormatter)
  ...
end
```

### Step 3

Run **the entire suite** to genreate initial spec report:

```
rake spec
```
_**NOTE:**_ This will create the report that will reflect the status of your specs,
and will be updated every time you run specs. It's recommended to check this file
under source control, to share this data with your co-workers.

## VIOLA!

Now, every time you run specs, you will get an annoying message _if you have
"rotten" specs_ (it's easy to turn OFF by commenting out Formatter in step 2).

## TODO

* create rake task / installer to generate initial report
* notify only about the examples currently executed (not the whole suite)
* allow user to use Formatter from CLI like `rspec --format RottenFormatter spec/`
* give user a chance to only track unit/integration/acceptance specs

## Contributions welcomed

1. Fork it ( https://github.com/[my-github-username]/rspec-rotten/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
