# Rails Template

This Rails 3 template was written to make the process of starting a very basic Rails app easier, and make my personal Rails app bootstrap instruction guide obsolete.  I disliked having to spend the time to repeat the same old steps manually every time I began a new application, so this is my attempt at automating that process.  

It's influenced heavily by, and owes a debt of gratitude to: 
- [Rails Apps Composer](https://github.com/RailsApps/rails_apps_composer)
- [Sample App](https://github.com/railstutorial/sample_app) of the [Rails Tutorial](http://ruby.railstutorial.org/)
- [Railscasts](http://railscasts.com/), in particular episodes [#250](http://railscasts.com/episodes/250-authentication-from-scratch-revised) and [#274](http://railscasts.com/episodes/274-remember-me-reset-password)

The template reflects my Rails preferences in the following ways:

- Always internationalize
- Postgresql for database
- Hide away all secret data in [Figaro](https://github.com/laserlemon/figaro) configuration
- [Bootstrap](https://github.com/thomas-mcdonald/bootstrap-sass) and [Haml](https://github.com/haml/haml)-ize views
- Test with [RSpec](https://github.com/rspec/rspec-rails)
- Use as many relevant code quality tools as possible during development

## Dependencies

This template was created to run using [RVM](https://rvm.io/) with:

- Ruby 2.0.0
- Rails 3.2.13

## Usage

    $ rails new my_app -m https://raw.github.com/paulfioravanti/rails_template/master/template.rb

I originally had issues with OpenSSL when attempting to reference the template, but [this guide](http://railsapps.github.com/openssl-certificate-verify-failed.html) on The RailsApps Project fixed it. 

## Social

<a href="http://stackoverflow.com/users/567863/paul-fioravanti">
  <img src="http://stackoverflow.com/users/flair/567863.png" width="208" height="58" alt="profile for Paul Fioravanti at Stack Overflow, Q&amp;A for professional and enthusiast programmers" title="profile for Paul Fioravanti at Stack Overflow, Q&amp;A for professional and enthusiast programmers">
</a>

[![endorse](http://api.coderwall.com/pfioravanti/endorsecount.png)](http://coderwall.com/pfioravanti)