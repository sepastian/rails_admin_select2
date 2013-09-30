RailsAdmin-Select2
==================

Add support for select2 input fields to RailsAdmin.

This is a pre-release, it has been tested with mongoid only, it has not been tested with ActiveRecord.


Usage
-----

Add `select2-rails` to your Gemfile

    gem 'select2-rails'

and include select2 assets into your `application.css` and `application.js` (see https://github.com/argerim/select2-rails):

    # app/assets/stylesheets/application.css.scss
    @import "select2";

    # app/assets/javascripts/application.js
    //= require select2

Then, render any association field using select2 like so:

    rails_admin do
      edit do
        field :children, :select2
      end
    end
