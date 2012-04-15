use Test::More;
use strict; no warnings;
#use LWP::Debug qw(+);
use Data::Dumper;
use lib qw/lib t/;
use Fake;

our $responses;

BEGIN {
    my @skip_msg;

    eval {
        use eBay::API::Simple::Trading;
    };
    
    if ( $@ ) {
        push @skip_msg, 'missing module eBay::API::Simple::Trading, skipping test';
    }
    if ( scalar( @skip_msg ) ) {
        plan skip_all => join( ' ', @skip_msg );
    }
    else {
        plan qw(no_plan);
    }    
} 

@Fake::ISA = qw(eBay::API::Simple::Trading);
my $call = Fake->new( {
    # domain => 'internal-api.vip.ebay.com',
} );

#$call->api_init( { 
#    site_id => 0,
#    uri     => $arg_uri,
#    domain  => $arg_domain,
#    app_id  => $arg_appid,
#    version => $arg_version,
#} );

eval{
    $call->{response_content} = shift(@{$responses});
    $call->execute( 'GetCategories', 
                    { DetailLevel => 'ReturnAll',
                      LevelLimit => 2,
                      CategoryParent => 11116,
                  } 
                );
};

SKIP: {
    skip $@, 1 if $@;

    if ( $call->has_error() ) {
        fail( 'api call failed: ' . $call->errors_as_string() );
    }
    else {
        is( ref $call->response_dom(), 'XML::LibXML::Document', 'response dom' );
        is( ref $call->response_hash(), 'HASH', 'response hash' );

        like( $call->nodeContent('Timestamp'), 
            qr/^\d{4}-\d{2}-\d{2}/, 
            'response timestamp' 
        );

        ok( $call->nodeContent('ReduceReserveAllowed') =~ /(true|false)/, 
            'reduce reserve allowed node' );
    }
        
}


$call->{response_content} = shift(@{$responses});
$call->execute( 'BadCallSSS', { Query => 'shoe' } );

#is( $call->has_error(), 1, 'look for error flag' );
#ok( $call->errors_as_string() eq 'Call Failure-The API call "BadCallSSS" is invalid or not supported in this release.', 'check for error message' );
ok( $call->response_content() ne '', 'check for response content' );

$call->{response_content} = shift(@{$responses});
$call->execute( 'GetSearchResults', { Query => 'shoe', Pagination => { EntriesPerPage => 2, PageNumber => 1 }  } );

is( $call->has_error(), 0, 'error check' );
is( $call->errors_as_string(), '', 'error string check' );
ok( $call->nodeContent('TotalNumberOfEntries') > 10, 'response total items' );
#diag $call->request_object->as_string();

my @nodes = $call->response_dom->findnodes(
    '//Item'
);

foreach my $n ( @nodes ) {
    #diag( $n->findvalue('Title/text()') );
    ok( $n->findvalue('Title/text()') ne '', 'title check' );
}
 
#diag Dumper( $call->response_hash );

BEGIN {
    $responses = [
          '<?xml version="1.0" encoding="UTF-8"?>
<GetCategoriesResponse ><Timestamp>2011-06-10T22:06:56.297Z</Timestamp><Ack>Success</Ack><Version>725</Version><Build>E725_CORE_BUNDLED_13319544_R1</Build><CategoryArray><Category><BestOfferEnabled>true</BestOfferEnabled><AutoPayEnabled>true</AutoPayEnabled><CategoryID>11116</CategoryID><CategoryLevel>1</CategoryLevel><CategoryName>Coins &amp; Paper Money</CategoryName><CategoryParentID>11116</CategoryParentID><Expired>false</Expired><IntlAutosFixedCat>false</IntlAutosFixedCat><LeafCategory>false</LeafCategory><Virtual>false</Virtual><LSD>false</LSD></Category><Category><BestOfferEnabled>true</BestOfferEnabled><AutoPayEnabled>true</AutoPayEnabled><CategoryID>39482</CategoryID><CategoryLevel>2</CategoryLevel><CategoryName>Bullion</CategoryName><CategoryParentID>11116</CategoryParentID><Expired>false</Expired><IntlAutosFixedCat>false</IntlAutosFixedCat><LeafCategory>false</LeafCategory><Virtual>false</Virtual><LSD>false</LSD></Category><Category><BestOfferEnabled>true</BestOfferEnabled><AutoPayEnabled>true</AutoPayEnabled><CategoryID>253</CategoryID><CategoryLevel>2</CategoryLevel><CategoryName>Coins: US</CategoryName><CategoryParentID>11116</CategoryParentID><Expired>false</Expired><IntlAutosFixedCat>false</IntlAutosFixedCat><LeafCategory>false</LeafCategory><Virtual>false</Virtual><LSD>false</LSD></Category><Category><BestOfferEnabled>true</BestOfferEnabled><AutoPayEnabled>true</AutoPayEnabled><CategoryID>3377</CategoryID><CategoryLevel>2</CategoryLevel><CategoryName>Coins: Canada</CategoryName><CategoryParentID>11116</CategoryParentID><Expired>false</Expired><IntlAutosFixedCat>false</IntlAutosFixedCat><LeafCategory>false</LeafCategory><Virtual>false</Virtual><LSD>false</LSD></Category><Category><BestOfferEnabled>true</BestOfferEnabled><AutoPayEnabled>true</AutoPayEnabled><CategoryID>4733</CategoryID><CategoryLevel>2</CategoryLevel><CategoryName>Coins: Ancient</CategoryName><CategoryParentID>11116</CategoryParentID><Expired>false</Expired><IntlAutosFixedCat>false</IntlAutosFixedCat><LeafCategory>false</LeafCategory><Virtual>false</Virtual><LSD>false</LSD></Category><Category><BestOfferEnabled>true</BestOfferEnabled><AutoPayEnabled>true</AutoPayEnabled><CategoryID>256</CategoryID><CategoryLevel>2</CategoryLevel><CategoryName>Coins: World</CategoryName><CategoryParentID>11116</CategoryParentID><Expired>false</Expired><IntlAutosFixedCat>false</IntlAutosFixedCat><LeafCategory>false</LeafCategory><Virtual>false</Virtual><LSD>false</LSD></Category><Category><BestOfferEnabled>true</BestOfferEnabled><AutoPayEnabled>true</AutoPayEnabled><CategoryID>3452</CategoryID><CategoryLevel>2</CategoryLevel><CategoryName>Exonumia</CategoryName><CategoryParentID>11116</CategoryParentID><Expired>false</Expired><IntlAutosFixedCat>false</IntlAutosFixedCat><LeafCategory>false</LeafCategory><Virtual>false</Virtual><LSD>false</LSD></Category><Category><BestOfferEnabled>true</BestOfferEnabled><AutoPayEnabled>true</AutoPayEnabled><CategoryID>3412</CategoryID><CategoryLevel>2</CategoryLevel><CategoryName>Paper Money: US</CategoryName><CategoryParentID>11116</CategoryParentID><Expired>false</Expired><IntlAutosFixedCat>false</IntlAutosFixedCat><LeafCategory>false</LeafCategory><Virtual>false</Virtual><LSD>false</LSD></Category><Category><BestOfferEnabled>true</BestOfferEnabled><AutoPayEnabled>true</AutoPayEnabled><CategoryID>3411</CategoryID><CategoryLevel>2</CategoryLevel><CategoryName>Paper Money: World</CategoryName><CategoryParentID>11116</CategoryParentID><Expired>false</Expired><IntlAutosFixedCat>false</IntlAutosFixedCat><LeafCategory>false</LeafCategory><Virtual>false</Virtual><LSD>false</LSD></Category><Category><BestOfferEnabled>true</BestOfferEnabled><AutoPayEnabled>true</AutoPayEnabled><CategoryID>83274</CategoryID><CategoryLevel>2</CategoryLevel><CategoryName>Publications &amp; Supplies</CategoryName><CategoryParentID>11116</CategoryParentID><Expired>false</Expired><IntlAutosFixedCat>false</IntlAutosFixedCat><LeafCategory>false</LeafCategory><Virtual>false</Virtual><LSD>false</LSD></Category><Category><BestOfferEnabled>true</BestOfferEnabled><AutoPayEnabled>true</AutoPayEnabled><CategoryID>3444</CategoryID><CategoryLevel>2</CategoryLevel><CategoryName>Stocks &amp; Bonds, Scripophily</CategoryName><CategoryParentID>11116</CategoryParentID><Expired>false</Expired><IntlAutosFixedCat>false</IntlAutosFixedCat><LeafCategory>false</LeafCategory><Virtual>false</Virtual><LSD>false</LSD></Category><Category><BestOfferEnabled>true</BestOfferEnabled><AutoPayEnabled>true</AutoPayEnabled><CategoryID>169305</CategoryID><CategoryLevel>2</CategoryLevel><CategoryName>Other</CategoryName><CategoryParentID>11116</CategoryParentID><Expired>false</Expired><IntlAutosFixedCat>false</IntlAutosFixedCat><LeafCategory>true</LeafCategory><Virtual>false</Virtual><LSD>false</LSD></Category></CategoryArray><CategoryCount>12</CategoryCount><UpdateTime>2011-05-03T02:15:13.000Z</UpdateTime><CategoryVersion>98</CategoryVersion><ReservePriceAllowed>true</ReservePriceAllowed><MinimumReservePrice>0.0</MinimumReservePrice><ReduceReserveAllowed>false</ReduceReserveAllowed></GetCategoriesResponse>',
          '<?xml version="1.0" encoding="UTF-8" ?><BadCallSSSResponse ><Timestamp>2011-06-10 22:06:56</Timestamp><Ack>Failure</Ack><Errors><ShortMessage>Unsupported API call.</ShortMessage><LongMessage>The API call "BadCallSSS" is invalid or not supported in this release.</LongMessage><ErrorCode>2</ErrorCode><SeverityCode>Error</SeverityCode><ErrorClassification>RequestError</ErrorClassification></Errors><Version>543</Version><Build>13319544</Build></BadCallSSSResponse>',
          '<?xml version="1.0" encoding="UTF-8"?>
<GetSearchResultsResponse ><Timestamp>2011-06-10T22:06:59.727Z</Timestamp><Ack>Success</Ack><Version>725</Version><Build>E725_CORE_BUNDLED_13319544_R1</Build><SearchResultItemArray><SearchResultItem><Item><ItemID>250829415923</ItemID><ListingDetails><StartTime>2011-05-31T22:07:01.000Z</StartTime><EndTime>2011-06-10T22:07:01.000Z</EndTime><ViewItemURL>http://cgi.ebay.com/ws/eBayISAPI.dll?ViewItem&amp;item=250829415923&amp;ih=015&amp;category=95672&amp;ssPageName=WDVW&amp;rd=1</ViewItemURL><ViewItemURLForNaturalSearch>http://cgi.ebay.com/SKECHERS-SHAPE-UPS-WOMENS-OPTIMIZE-WOMENS-SZ-10-NIB-FS_W0QQitemZ250829415923QQcategoryZ95672QQcmdZViewItem</ViewItemURLForNaturalSearch></ListingDetails><SellingStatus><BidCount>0</BidCount><CurrentPrice currencyID="USD">50.15</CurrentPrice></SellingStatus><Site>US</Site><Title>SKECHERS SHAPE UPS WOMENS OPTIMIZE WOMENS SZ 10 NIB FS</Title><Currency>USD</Currency><ListingType>StoresFixedPrice</ListingType><GiftIcon>0</GiftIcon><SubTitle></SubTitle><PaymentMethods>PayPal</PaymentMethods><Country>US</Country><Storefront><StoreCategoryID>0</StoreCategoryID><StoreCategory2ID>0</StoreCategory2ID><StoreURL>http://stores.ebay.com/id=31784957</StoreURL><StoreName>Marketplace Liquidations</StoreName></Storefront><PostalCode>28715</PostalCode><ShippingDetails><ShippingType>Free</ShippingType><DefaultShippingCost currencyID="USD">0.0</DefaultShippingCost></ShippingDetails><PictureDetails><GalleryType>Gallery</GalleryType><GalleryURL>http://thumbs4.ebaystatic.com/pict/2508294159238080_1.jpg</GalleryURL></PictureDetails><ListingDuration>Days_10</ListingDuration></Item><ItemSpecific><NameValueList><Name>Condition</Name><Value>New with box</Value></NameValueList></ItemSpecific></SearchResultItem><SearchResultItem><Item><ItemID>290573053715</ItemID><ListingDetails><StartTime>2011-06-03T22:07:01.000Z</StartTime><EndTime>2011-06-10T22:07:01.000Z</EndTime><ViewItemURL>http://cgi.ebay.com/ws/eBayISAPI.dll?ViewItem&amp;item=290573053715&amp;ih=019&amp;category=62107&amp;ssPageName=WDVW&amp;rd=1</ViewItemURL><ViewItemURLForNaturalSearch>http://cgi.ebay.com/Shoe-white-birkoflor-Betula-Birkenstock-41-8-10-N-slide_W0QQitemZ290573053715QQcategoryZ62107QQcmdZViewItem</ViewItemURLForNaturalSearch></ListingDetails><SellingStatus><BidCount>1</BidCount><CurrentPrice currencyID="USD">24.99</CurrentPrice></SellingStatus><Site>US</Site><Title>Shoe white birkoflor Betula Birkenstock 41 8 10 N slide</Title><Currency>USD</Currency><ListingType>Chinese</ListingType><GiftIcon>0</GiftIcon><SubTitle></SubTitle><PaymentMethods>PayPal</PaymentMethods><Country>US</Country><Storefront><StoreCategoryID>0</StoreCategoryID><StoreCategory2ID>0</StoreCategory2ID><StoreURL>http://stores.ebay.com/id=4335778</StoreURL><StoreName>mrhaney4</StoreName></Storefront><PostalCode>80207</PostalCode><ShippingDetails><ShippingType>Flat</ShippingType><DefaultShippingCost currencyID="USD">9.5</DefaultShippingCost></ShippingDetails><SearchDetails><BuyItNowEnabled>false</BuyItNowEnabled></SearchDetails><PictureDetails><GalleryType>Gallery</GalleryType><GalleryURL>http://thumbs4.ebaystatic.com/pict/2905730537158080_1.jpg</GalleryURL></PictureDetails><ListingDuration>Days_7</ListingDuration></Item><ItemSpecific><NameValueList><Name>Condition</Name><Value>Pre-owned</Value></NameValueList></ItemSpecific></SearchResultItem></SearchResultItemArray><ItemsPerPage>2</ItemsPerPage><PageNumber>1</PageNumber><HasMoreItems>true</HasMoreItems><PaginationResult><TotalNumberOfPages>1622961</TotalNumberOfPages><TotalNumberOfEntries>3245922</TotalNumberOfEntries></PaginationResult><CategoryArray/><BuyingGuideDetails><BuyingGuide><Name>Jeans Style Guide</Name><URL>http://pages.ebay.com/buy/guides/jeans-denim-style-guide/</URL><CategoryID>11450</CategoryID></BuyingGuide><BuyingGuide><Name>How to Find Your Size</Name><URL>http://pages.ebay.com/buy/guides/sizing-size-apparel-shoes-guide/</URL><CategoryID>11450</CategoryID></BuyingGuide><BuyingGuide><Name>Sunglasses</Name><URL>http://pages.ebay.com/buy/guides/sunglasses-buying-guide/</URL><CategoryID>11450</CategoryID></BuyingGuide><BuyingGuide><Name>Clothing, ShoesÂ &amp; Accessories</Name><URL>http://pages.ebay.com/buy/guides/clothing-shoes-accessories-buying-guide/</URL><CategoryID>11450</CategoryID></BuyingGuide><BuyingGuide><Name>How to Get the Right Fit</Name><URL>http://pages.ebay.com/buy/guides/apparel-clothing-fit-guide/</URL><CategoryID>11450</CategoryID></BuyingGuide><BuyingGuide><Name>Shoes</Name><URL>http://pages.ebay.com/buy/guides/shoes-buying-guide/</URL><CategoryID>11450</CategoryID></BuyingGuide><BuyingGuideHub>http://search.reviews.ebay.com/_W0QQuqtZg</BuyingGuideHub></BuyingGuideDetails></GetSearchResultsResponse>'
        ];


}
