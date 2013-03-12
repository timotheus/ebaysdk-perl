Welcome to the perl ebaysdk
=============================

This SDK is a dead-simple, programatic inteface into the eBay APIs. It simplifies development and cuts development time by standerizing calls, response processing, error handling, debugging across the Finding, Shopping, Merchandising, & Trading APIs. 

Quick Example::

    use eBay::API::Simple::Finding;

    my $api = eBay::API::Simple::Finding->new( {
       appid   => 'myappid',
    } );

    $api->execute( 'findItemsByKeywords', { keywords => 'shoe' } );

    my $hash = $api->response_hash();

Getting Started
---------------

SDK Classes

* `Trading API Class`_ - secure, authenticated access to private eBay data.
* `Finding API Class`_ - access eBay's next generation search capabilities.
* `Shopping API Class`_ - performance-optimized, lightweight APIs for accessing public eBay data.
* `HTML Class`_ - generic back-end class the enbles and standardized way to make API calls.
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
.. _Trading API Class: https://github.com/timotheus/ebaysdk-perl/wiki/Trading-API-Class
.. _Finding API Class: https://github.com/timotheus/ebaysdk-perl/wiki/Finding-API-Class
.. _Shopping API Class: https://github.com/timotheus/ebaysdk-perl/wiki/Shopping-API-Class
.. _HTML Class: https://github.com/timotheus/ebaysdk-perl/wiki/HTML-Class
.. _Parallel Class: https://github.com/timotheus/ebaysdk-perl/wiki/Parallel-Class
.. _eBay Developer Forums: https://www.x.com/developers/ebay/forums
.. _Github issue tracking: https://github.com/timotheus/ebaysdk-perl/issues













eBay::API::Simple
===========================

This module supports eBay's Shopping and Trading API services. In addition, eBay::API::Simple comes with a standard RSS and HTML back-end.

In order to use eBay aspects of this utility you must first register with eBay to get your `eBay Develoepr Site`_ API developer credentials] (see the ebay.yaml option for a way to tie these credentials into the Shopping and Trading back-ends)

Parallel Requests::

    my $pua = eBay::API::Simple::Parallel->new();

    my $call1 = eBay::API::Simple::RSS->new( {
        parallel => $pua,
    } );

    $call1->execute(
        ’http://worldofgood.ebay.com/Clothes-Shoes-Men/43/list?format=rss’,
    );

    my $call2 = eBay::API::Simple::RSS->new( {
        parallel => $pua,
    } );

    $call2->execute(
        ’http://worldofgood.ebay.com/Home-Garden/46/list?format=rss’
    );

    $pua->wait();

    if ( $pua->has_error() ) {
        print "ONE OR MORE FAILURES!\n";
    }

    print $call1->response_content() . "\n";
    print $call2->response_content() "\n";


Merchandising Services::

    use eBay::API::Simple::Merchandising;

    my $api = eBay::API::Simple::Merchandising->new( {
       appid   => '<your app id here>',
    } );

    $api->execute( 'getMostWatchedItems', { 
       maxResults => 3, categoryId => 267 
    });

    if ( $api->has_error() ) {
       die "Call Failed:" . $api->errors_as_string();
    }

    # getters for the response DOM or Hash
    my $dom  = $api->response_dom();
    my $hash = $api->response_hash();

  	 
[eBayAPISimpleMerchandising#Sandbox_Usage Sandbox Usage] |
[eBayAPISimpleMerchandising#Module_Documentation Module Documentation] 

Finding Services::

    use eBay::API::Simple::Finding;

    my $api = eBay::API::Simple::Finding->new( {
       appid   => 'myappid',
    } );

    $api->execute( 'findItemsByKeywords', { keywords => 'shoe' } );

    if ( $api->has_error() ) {
       die "Call Failed:" . $api->errors_as_string();
    }

    # getters for the response DOM or Hash
    my $dom  = $api->response_dom();
    my $hash = $api->response_hash();

[eBayAPISimpleFinding#Sandbox_Usage Sandbox Usage] |
[eBayAPISimpleFinding#Module_Documentation Module Documentation] 


Shopping Services::

    use eBay::API::Simple::Shopping;

    my $api = eBay::API::Simple::Shopping->new( {
       appid   => 'myappid',
    } );

    $api->execute( 'FindItemsAdvanced', { QueryKeywords => 'shoe' } );

    if ( $api->has_error() ) {
       die "Call Failed:" . $api->errors_as_string();
    }

    # getters for the response DOM or Hash
    my $dom  = $api->response_dom();
    my $hash = $api->response_hash();

[eBayAPISimpleShopping#Sandbox_Usage Sandbox Usage] |
[eBayAPISimpleShopping#Module_Documentation Module Documentation] 

Trading Services::

    use eBay::API::Simple::Trading;
  
    my $api = eBay::API::Simple::Trading->new( {
        appid   => 'myappid',
        devid   => 'mydevid',
        certid  => 'mycertid',
        token   => $mytoken,
    } );

    $api->execute( 'GetSearchResults', { Query => 'shoe' } );

    if ( $api->has_error() ) {
       die "Call Failed:" . $api->errors_as_string();
    }

    # getters for the response DOM or Hash
    my $dom  = $api->response_dom();
    my $hash = $api->response_hash();

[eBayAPISimpleTrading#Sandbox_Usage Sandbox Usage] |
[eBayAPISimpleTrading#Module_Documentation Module Documentation]

Generic JSON Backend::

    use eBay::API::Simple::JSON;

    my $api = eBay::API::Simple::JSON->new();

    # 'GET' call
    $api->get( 
       'http://localhost-django-vm.ebay.com/green/api/v1/greenerAlternative/32/'
    );

    if ( $api->has_error() ) {
        die "Call Failed:" . $api->errors_as_string();
    }

    # convenience methods
    my $hash = $api->response_hash();
    my $response_content = $api->response_content();
    my $request_content = $api->request_content();

    # HTTP::Request
    print $api->request->as_string();

    # HTTP::Response
    print $api->response->as_string();
    print $api->response->content();
    print $api->response->is_error();

    # HTTP::Headers
    print $api->response->headers->as_string();
    print $api->response->headers->content_type();

    # 'POST', 'PUT', 'DELETE' calls

    my $data = {     
        "user_eais_token" => "tim", 
        "body_text" => "mytext"
    };

    $api->post( 'http://myendpoint', $data );
    $api->put( 'http://myendpoint', $data );
    $api->delete( 'http://myendpoint' );

Generic HTML Backend::

    use eBay::API::Simple::HTML;

    my $api = eBay::API::Simple::HTML->new();

    $api->execute( 'http://www.example.com' );

    if ( $api->has_error() ) {
        die "Call Failed:" . $api->errors_as_string();
    }

    # getters for the response DOM or Hash
    my $dom  = $api->response_dom();
    my $hash = $api->response_hash();

Generic RSS Backend::

    use eBay::API::Simple::RSS;

    my $api = eBay::API::Simple::RSS->new();

    $api->execute( 
       'http://sfbay.craigslist.org/search/sss?query=shirt&format=rss'
    );

    if ( $api->has_error() ) {
        die "Call Failed:" . $api->errors_as_string();
    }

    # getters for the response DOM or Hash
    my $dom  = $api->response_dom();
    my $hash = $api->response_hash();

More Docs::

Visit CPAN to view the full documentation for [http://search.cpan.org/search?query=eBay%3A%3AAPI%3A%3ASimple eBay::API::Simple].


.. _eBay Developer Site: http://developer.ebay.com/
