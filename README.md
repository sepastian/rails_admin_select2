RailsAdmin-Select2
==================

Add support for [select2](http://ivaynberg.github.io/select2/) input fields to RailsAdmin.
Relations and tagging are supported.

This works only with mongoid for now.

This is a pre-release, it has note been tested toroughly, please let me know, if you find any errors.

Installation
------------

Add `rails_admin_select2` and `select2-rails` to your Gemfile

    gem 'select2-rails'
    gem 'rails_admin_select2'

Include select2 assets into your `application.css` and `application.js` (see https://github.com/argerim/select2-rails):

    # app/assets/stylesheets/application.css.scss
    @import "select2";

    # app/assets/javascripts/application.js
    //= require select2

Usage
-----

Render a relation:

    class Parent
      include Mongoid::Document
      has_many: children, inverse_of: parent
      rails_admin do
        edit do
          field :children, :select2
        end
      end
    end

Render a field for tagging:

    # To render a field for tagging, an Array holding predefined tags
    # must be passed to the :tags options. This array may be empty,
    # new tags can be created on-the-fly.
    class Parent
      include Mongoid::Document
      field :tags, :type => String  # tagging requires a String attribute
      rails_admin do
        edit do
          field :tags, :select2 do
            tags: [ 1, 2, 3] # can be empty (tags: [])
          end
        end
      end
    end
