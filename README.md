# Atlanta PJ Seminar Contest

[![Build Status](https://travis-ci.org/photojournalism/contest.svg?branch=master)](https://travis-ci.org/photojournalism/contest)  [![Coverage Status](https://img.shields.io/coveralls/photojournalism/contest.svg)](https://coveralls.io/r/photojournalism/contest?branch=master) [![Code Climate](https://codeclimate.com/github/photojournalism/contest/badges/gpa.svg)](https://codeclimate.com/github/photojournalism/contest) 

This repository contains the Rails application used to register and enter the Atlanta Photojournalism Seminar's yearly international photo contest. It is currently a work in progress.

## System Dependencies

* Ruby >= 2.0

## Running the Application Locally

```bash
git clone git@github.com:photojournalism/contest.git
cd contest

# Install Dependencies
bundle install

# Migrate and Seed the Database
rake db:migrate
rake db:seed

# Run the server
rails s
```

Navigate to [localhost:3000](http://localhost:3000) in your browser to view the application.

## Running the Test Suite

The test suite is built using [RSpec](https://github.com/rspec/rspec). It can be run by issuing the following commands:

```bash
# Migrate the Test Database
rake db:migrate RAILS_ENV=test

# Run the tests
rspec spec/
```

## Configuration

For email to be sent from the application, the `email.yml` configuration file must be created and configured.

```bash
# Move sample file
mv config/email.example.yml config/email.yml
```

Then open the file, and update the corresponding configuration values. For more information, see [Action Mailer Basics](http://guides.rubyonrails.org/action_mailer_basics.html).