Welcome to the perl ebaysdk
=============================

This SDK is a dead-simple, programatic inteface into the eBay APIs. It simplifies development and cuts development time by standerizing calls, response processing, error handling, debugging across the Finding, Shopping, Merchandising, & Trading APIs. 

Quick Example::

    use eBay::API::Simple::Finding;

    my $api = eBay::API::Simple::Finding->new( {
       appid   => 'YOUR_APP_ID',
    } );

    $api->execute( 'findItemsByKeywords', { keywords => 'shoe' } );

    my $hash = $api->response_hash();

Getting Started
---------------

SDK Classes

* `Trading API Class`_ - secure, authenticated access to private eBay data.
* `Finding API Class`_ - access eBay's next generation search capabilities.
* `Shopping API Class`_ - performance-optimized, lightweight APIs for accessing public eBay data.
* `Merchandising API Class`_ - easy way to surface available items and products on eBay that provide good value or are otherwise popular with eBay buyers.
* `HTML Class`_ - generic back-end class the enbles and standardized way to make API calls.
* `JSON Class`_ - generic back-end class the enbles and standardized way to make JSON API calls.
* `Parallel Class`_ - SDK support for concurrent API calls.

SDK Configuration

* `YAML Configuration`_ 
* `Understanding eBay Credentials`_


Support
-------

For developer support regarding the SDK code base please use this project's `Github issue tracking`_.

For developer support regarding the eBay APIs please use the `eBay Developer Forums`_.

License
-------

`COMMON DEVELOPMENT AND DISTRIBUTION LICENSE`_ Version 1.0 (CDDL-1.0)


.. _COMMON DEVELOPMENT AND DISTRIBUTION LICENSE: http://opensource.org/licenses/CDDL-1.0
.. _Understanding eBay Credentials: https://github.com/timotheus/ebaysdk-perl/wiki/eBay-Credentials
.. _eBay Developer Site: http://developer.ebay.com/
.. _YAML Configuration: https://github.com/timotheus/ebaysdk-perl/wiki/YAML-Configuration
.. _Merchandising API Class: https://github.com/timotheus/ebaysdk-perl/wiki/Merchandising-API-Class
.. _Trading API Class: https://github.com/timotheus/ebaysdk-perl/wiki/Trading-API-Class
.. _Finding API Class: https://github.com/timotheus/ebaysdk-perl/wiki/Finding-API-Class
.. _Shopping API Class: https://github.com/timotheus/ebaysdk-perl/wiki/Shopping-API-Class
.. _HTML Class: https://github.com/timotheus/ebaysdk-perl/wiki/HTML-Class
.. _Parallel Class: https://github.com/timotheus/ebaysdk-perl/wiki/Parallel-Class
.. _eBay Developer Forums: https://www.x.com/developers/ebay/forums
.. _Github issue tracking: https://github.com/timotheus/ebaysdk-perl/issues
