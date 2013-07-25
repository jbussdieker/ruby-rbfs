# Rbfs

[![Build Status](https://travis-ci.org/jbussdieker/ruby-rbfs.png?branch=master)](https://travis-ci.org/jbussdieker/ruby-rbfs)
[![Code Climate](https://codeclimate.com/github/jbussdieker/ruby-rbfs.png)](https://codeclimate.com/github/jbussdieker/ruby-rbfs)
[![Gem Version](https://badge.fury.io/rb/rbfs.png)](http://badge.fury.io/rb/rbfs)

Rbfs combines hosts files with rsync to simplify keeping a consistent set of files on multiple servers.

## Features

 * Multithreaded sync
 * Partial sync using a subpath
 * Summary exit code indicating success of all nodes.
 * Configurable timeout to avoid long delays on inaccessible nodes.

## Options

Most options can be specified via command-line arguments or in the config file. Arguments specified on the command line supersede those specified in the config file.

### Command line arguments

    Usage: rbfs [options]
        -c, --config FILE                Configuration file
        -h, --hosts FILE                 Hosts file
        -r, --root ROOT                  Root path to sync
        -e, --remote-root ROOT           Remote root path to sync
        -s, --subpath PATH               Subpath of root to sync
        -v, --[no-]verbose               Print extra debugging info
        -d, --dry                        Test config settings
        -t, --[no-]threaded              Run all hosts concurrently
            --timeout TIMEOUT            Set I/O timeout

### Config file settings

 - hosts: Hosts file
 - root: Root path to sync from
 - remote_path: Remote root path to sync to (default: the value of root)
 - subpath: Subpath of root to sync (default: /)
 - verbose: Print extra debugging info (default: false)
 - dry: Test config settings (default: false)
 - threaded: Run all hosts concurrently (default: false)
 - timeout: Set I/O timeout in seconds (default: 60)

## Usage

### Basic Sample

Given a sample hosts file (/etc/sync.hostlist):

    1.1.1.1 server-a
    2.2.2.2 server-b

It is possible to ensure that both server-a and server-b have an identical directory (/path/to/filestore) using rbfs:

    rbfs --hosts /etc/sync.hostlist --root /path/to/filestore

The output of the command would be as follows:

    Syncing /path/to/filestore...
    server-a: Success
    server-b: Success

### Config File

It is also possible to create syncing profiles using Rbfs' config file format.

Creating a profile (/etc/rbfs/filestore.yml) for the Basic Sample would look this:

    ---
      hosts: /etc/sync.hostlist
      root: /path/to/filestore

To use this profile you would run Rbfs with the --config option:

    rbfs --config /etc/rbfs/filestore.yml
