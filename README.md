# Salted _ Rails _ Server

## Description

A ruby on rails generator for provisioning a new server using salt-ssh

Supports the following:

* [Backup] (https://github.com/backup/backup)
* [ElasticSearch] (https://info.elastic.co/branded-ggl-elastic-exact-v3.html?camp=Branded-GGL-Exact&src=adwords&mdm=cpc&trm=elasticsearch&gclid=EAIaIQobChMIhuuXsc6E2AIVEoGzCh1JFgyzEAAYAiAAEgKRZ_D_BwE)
* [ImageMagick] (https://www.imagemagick.org/script/index.php)
* [LogRotate] (http://www.thegeekstuff.com/2010/07/logrotate-examples/)
* [Monit] (https://mmonit.com/monit)
* [MySQL] (https://www.mysql.com/)
* [NGINX] (https://www.nginx.com/)
* [Node] (https://nodejs.org/)
* [RubyOnRails] (http://rubyonrails.org/)
* [RVM] (https://rvm.io/)
* User - User setup

All installations are the latest packages for the managed system unless there is a version section in the pillars/default.sls.

## Tested on

* Ubuntu Trust
* Ubuntu Xenial

No reason this should not work on any other salt stack supported OS. If you have tried this on any other OS and it did not work, please let me know.

## salt-ssh installation

This code requires that you have Saltstack's salt-ssh already installed on the system you are deploying from and a compatible version of python on the system you are deploying to. If you are a mac user attempting to use this and you have issues, try using [salt-ssh-vm] ()

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

The following files will be generated in the root directory:

```
./master
./roster # DO NOT CHECK IN THIS FILE!!!
./Saltfile
./salt_ssh
├── pillars
│   ├── default.sls
│   └── top.sls
└── states
    ├── backup
    │   └── files
    │       └── home
    │           └── deploy
    │               ├── bin
    │               │   └── backup.rb
    │               └── config
    │                   └── schedule.rb
    ├── backup.sls
    ├── elasticsearch.sls
    ├── imagemagick.sls
    ├── logrotate
    │   └── files
    │       └── etc
    │           └── logrotate.d
    │               └── rails
    ├── logrotate.sls
    ├── monit
    │   ├── etc
    │   │   └── monit
    │   │       └── monitrc
    │   └── redis.sls
    ├── monit.sls
    ├── mysql.sls
    ├── nginx.sls
    ├── node.sls
    ├── rails.sls
    ├── rvm.sls
    ├── setup.sls
    └── user.sls
```

## Configuration

Add custom options to the following files:

* roster - remote host(s) information
* pillars/default.sls - RAILS_ENV, Remote Username with ssh-key, MYSQL root and rails user user password and versions of ruby and elasticsearch to be installed.

## Setting up Remote system

Add your public ssh key to the authorized_keys on remote server that you plan to manage. I normally add this to root but it needs to be added to a user with sudo privileges.

## Testing salt-ssh connection

From within the appliation root directory type:

```
sudo salt-ssh -i '*' test.ping
```

The following should be returned:
```
managed:
    True
```

If that is not returned, salt-ssh should give you an accurate reason to why it was not able to connect. Another tool to use is the verbose option on the ssh command.

```
ssh -vv user@remote-host
```

## The States (Remote Management)

### Available States

* backup
* elasticsearch
* imagemagick
* logrotate
* monit
* mysql
* nginx
* node
* rails
* rvm
* setup
* user - User setup

### The Setup State

```
sudo salt-ssh -i '*' state.apply setup
```

This runs the minimum set of states in a specific order. Be sure to look at salt_ssh/states/setup.sls to comment or uncomment any additional items you do or don't want installed during the setup process.

This takes a while and there aren't any status updates as things
progress. Be patient!

### Individual States

```
sudo salt-ssh -i '*' state.apply state_file
```

## State Details

### Backup State

Installs the [backup] (https://github.com/backup/backup) and [whenever](https://github.com/javan/whenever) gems for backing up your rails application

The backup configuration is stored in `/home/username/bin`

Whenever configuration is stored in `/home/username/config`

Backups are stored in `/var/backups/rails`

It has configurations for using AWS S3 and SES. Those configurations can be added to the roster file. You can see an example of this in the roster file.

### ElasticSearch State (Debian/Ubuntu Only)

Installs the specified version of elasticsearch found in salt_ssh/pillars/default.sls. The fallback is version 2.3.4. This also installs the openjdk_7_jre dependency.

### ImageMagick State

Installs the lates version of ImageMagick via the package manager for the OS

### LogRotate State

Ensures logrotate is installed on the remote system (it most likely is) via the package manager for the OS. Adds a rails config in /etc/logrotate.d

### Monit State

Ensures monit is installed via the package manager for the OS
and running. Makes a backup of the original /etc/monit/monitrc then replaces it with config that monitors any monit configs stored within the rails application.

The monit config file is setup to use AWS SES which you can add the credentials to the roster file.

### MySQL state

Ensures MySQL is installed via the package manager for the OS and running. Currently, you will need to create the user account due to the following open issues:

[29265](https://github.com/saltstack/salt/issues/29265)

[44200](https://github.com/saltstack/salt/issues/44200)

Once resolved, the option to create MySQL users will be re-enabled.

The code is commented out in salt_ssh/states/user.sls if you decide you want to try and use it before the issues are resolved.

### NGINX State

Installs NGINX via the package manager for the OS and ensures it is running.

### Node State

Ensures nodejs is installed via the package manager for the OS and creates a node symlink if it doesn't exist

### Rails state

Installs the following gems under RVM

* Bundler
* Rails
* Unicorn

creates /var/www if it doesn't exist and sets the owner of that directory to the specified user in the user state

### RVM state

Installs RVM under the specified user in the user state. Sets the default to the specified version in salt_ssh/pillars/default.sls

### User state

Creates a user that is defined in salt_ssh/pillars/default.sls. If a user is not found it will default to user named deploy. This state also adds the user to /etc/sudoers for executing code without the need for a password.

#### RSA key

Update salt_ssh/pillars/default/init.sls to add your ssh key to log in as the user created in the user state. This is required since the user created does not have a default password assigned. This is done for strong security!

## Caution

Take a look at the code before you use it to make sure that it works the way you expect or want. After the code is generated you can modify it to fit your needs before executing.


## Uninstalling

To uninstall salted_rails_server simply delete the following files:

* /master
* /roster
* /Saltfile
* /salt.log
* /salt_ssh #directory

## Contributing

I am looking for constructive criticisim on making this better and easier for everyone who could use it.

1. Fork it ( https://github.com/vmcilwain/salted_rails_server/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
