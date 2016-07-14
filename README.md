# salted_rails_server

A ruby on rails generator used to provision a new server (using salt-ssh) with the following:

* RAILS_ENV set to development
* User for running rails - default: deploy
* RVM - latest stable version
* NGINX - latest OS repo version
* Rails - latest stable version
* Elasticsearch - default: 2.3.4
* NodeJS - latest OS repo version
* MySQL - latest OS repo version

## Tested on
* saltstack 2016.3.1
* Ubuntu 14.04 (trusty)
* Ubuntu 15.10 (wily)--
* ubuntu 16.04 (xenial)

No reason this should not work on any other saltstack supported OS. If you have tried this on any other OS and it did not work, let me know.

## salt-ssh installation

This code requires that you have Saltstack's salt-ssh already installed the system you are deploying from and a compatible version of python on the system you are deploying to.

Consult the following documentation for your OS:
https://docs.saltstack.com/en/latest/topics/installation/index.html

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'salted_rails_server'
```

And then execute:

    $ bundle

And then generate code:

```ruby
rails g salted_rails_server
```

The following files will be generated:

* master
* roster
* Saltfile
* salted_rails_server/pillars/*
* salted_rails_server/states/*

## Configuration

Add your custom options to the following files:

* roster - remote host(s) information
* pillars/default/init.sls - rails environment, username, ssh-key, mysql root and rails_user password and version of ruby and elasticsearch to be installed.


## Testing salt-ssh connection

```
sudo salt-ssh -i '*' test.ping
```

The following should be returned:
```
managed:
    True
```

## Running the code

### Installing all states:

```
sudo salt-ssh -i '*' state.apply setup
```

This takes a while and there aren't any status updates as things
progress. Be patient!

### Installing an individual state:

```
sudo salt-ssh -i '*' state.apply state_file
```

#### States to chose from

* elasticsearch
* mysql
* nginx
* node
* rails
* rvm
* user

## Code Details

### User state

Creates a user that is defined in pillars/default/init.sls. If a user is not found it will default to user named deploy. This state also addes the user to /etc/sudoers for executing code without the need for a password.

#### RSA key

Update pillars/default/init.sls to add your ssh key to log in as the user created in the user state. This is required since the user created does not have a default password assigned. This is done for strong security!

### RVM state

Installed under the user that is created from the user state
Sets the default to the specified version in pillars/default/init.sls

### Rails state

Installs the following gems under RVM

* Bundler
* Rails
* Unicorn

Finds or creates /var/www and sets the owner of that directory to the specified user in the user state

### MySQL state

Creates a rails_user account with the appropriate permissions to run rails nothing more. Sets its password to what is specified in pillar/default/init.sls
Sets the root password to what is specified in pillar/default/init.sls


## Caution

Take a look at the code before you use it to make sure that it works the way you expect or want. After the code is generated you can modify it to fit your needs before executing.

# Contributing

I am looking for constructive criticisim on making this better and easier for everyone who could use it.

1. Fork it ( https://github.com/vmcilwain/salted_rails_server/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
