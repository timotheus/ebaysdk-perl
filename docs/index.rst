Welcome to eBay API Simple!
====================

eBay API Simple is a super simple, easy to use, toolkit that interfaces with eBay API's and other standard web services.

.. toctree::
   :maxdepth: 2

   tutorial
   interacting
   settings

   cookbook
   debugging
   who_uses
   contributing


Getting Help
============

Post issues on Github

Quick Start
===========

1. sudo cpanm eBay::API::Simple 
2. create a test.pl script

    use strict;
    use eBay::API::Simple::Finding;

    my $api = eBay::API::Simple::Finding->new( {
       appid => 'myappid',
    } );

    $api->execute( 'findItemsByKeywords', { keywords => 'perl books' } );

    if ( $api->has_error() ) {
       die "Call Failed:" . $api->errors_as_string();
    }

    # getters for the response DOM or Hash
    my $dom  = $api->response_dom();
    my $hash = $api->response_hash();


Requirements
============

Required
--------

* Perl 5.8+


