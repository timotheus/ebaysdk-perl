use Test::More;
use strict; no warnings;
#use LWP::Debug qw(+);
use Data::Dumper;
use lib qw/lib t/;
use Fake;

my @skip_msg;
our $responses;

BEGIN {

    eval {
        use eBay::API::Simple::Merchandising;
    };
    
    if ( $@ ) {
        push @skip_msg, 'missing module eBay::API::Simple::Merchandising, skipping test';
    }
    
       
    if ( scalar( @skip_msg ) ) {
        plan skip_all => join( ' ', @skip_msg );
    }
    else {
        plan qw(no_plan);
    }    

}

my $call;

eval {
    @Fake::ISA = qw(eBay::API::Simple::Merchandising);
    $call = Fake->new(
        { appid => undef, } # <----- your appid here
    );

};

if ( $@ ) {
    push( @skip_msg, $@ );
}

SKIP: {
    skip join("\n", @skip_msg), 1 if scalar(@skip_msg);
   
    $call->{response_content} = shift(@{$responses});
    $call->execute(
        'getMostWatchedItems', { maxResults => 1, categoryId => 267 } 
    );

    #diag $call->request_content;
    #diag $call->response_content;
    
    if ( $call->has_error() ) {
        fail( 'api call failed: ' . $call->errors_as_string() );
    }
    else {
        is( ref $call->response_dom(), 'XML::LibXML::Document', 'response dom' );
        is( ref $call->response_hash(), 'HASH', 'response hash' );

        like( $call->nodeContent('timestamp'), 
            qr/^\d{4}-\d{2}-\d{2}/, 
            'response timestamp' 
        );
    
        #diag( Dumper( $call->response_hash() ) );
    }

    $call->{response_content} = shift(@{$responses});
    $call->execute( 'BadCall', { keywords => 'shoe' } );

#    is( $call->has_error(), 1, 'look for error flag' );
#    ok( $call->errors_as_string() ne '', 'check for error message' );
    ok( $call->response_content() ne '', 'check for response content' );

    $call->{response_content} = shift(@{$responses});
    $call->execute( 'getSimilarItems', { itemId => 270358046257 } );

    #diag $call->request_content;
    #diag $call->response_content;

    is( $call->has_error(), 0, 'error check' );
    is( $call->errors_as_string(), '', 'error string check' );
    
    #diag( Dumper( $call->response_hash() ) );

    my @nodes = $call->response_dom->findnodes(
        '//item'
    );

    my $count = 0;
    foreach my $n ( @nodes ) {
        ++$count;
        #diag( $n->findvalue('title/text()') );
        ok( $n->findvalue('title/text()') ne '', "title check $count" );
    }

}

BEGIN {
$responses = [
          '<?xml version=\'1.0\' encoding=\'UTF-8\'?><getMostWatchedItemsResponse ><ack>Success</ack><version>1.4.0</version><timestamp>2011-06-10T21:37:38.170Z</timestamp><itemRecommendations><item><itemId>260425997760</itemId><title>BOOKS FOR KINDLE - COLLECTION OF 125 MOST FAMOUS EBOOKS</title><viewItemURL>http://cgi.ebay.com/BOOKS-KINDLE-COLLECTION-125-MOST-FAMOUS-EBOOKS-/260425997760?_trksid=m8&amp;_trkparms=algo%3DMW%26its%3DC%26itu%3DUCC%26otn%3D1%26ps%3D50</viewItemURL><globalId>EBAY-US</globalId><timeLeft>P18DT21H38M53S</timeLeft><primaryCategoryId>267</primaryCategoryId><primaryCategoryName>Books</primaryCategoryName><subtitle>HUGE LIBRARY COMPATIBLE WITH KINDLE 1, 2 &amp; 3</subtitle><buyItNowPrice currencyId="USD">4.99</buyItNowPrice><country>US</country><imageURL>http://thumbs1.ebaystatic.com/m/mbbq9Syv3wdQRu0AnRgtdtw/80.jpg</imageURL><shippingCost currencyId="USD">1.98</shippingCost><shippingType>NotSpecified</shippingType><watchCount>252</watchCount></item></itemRecommendations></getMostWatchedItemsResponse>',
          '<?xml version=\'1.0\' encoding=\'UTF-8\'?><errorMessage xmlns="http://www.ebay.com/marketplace/services"><error><errorId>2000</errorId><domain>CoreRuntime</domain><severity>Error</severity><category>Request</category><message>Service operation BadCall is unknown</message><subdomain>Inbound_Meta_Data</subdomain><parameter name="Param1">BadCall</parameter></error></errorMessage>',
          '<?xml version=\'1.0\' encoding=\'UTF-8\'?><getSimilarItemsResponse ><ack>Success</ack><version>1.4.0</version><timestamp>2011-06-10T21:37:38.684Z</timestamp><itemRecommendations><item><itemId>280437477957</itemId><title>Solar Hybrid Flashlight: Colors: Green</title><viewItemURL>http://cgi.ebay.com/Solar-Hybrid-Flashlight-Colors-Green-/280437477957?_trksid=m263&amp;_trkparms=algo%3DSIC%26its%3DI%26itu%3DUCI%252BIA%252BUA%252BFICS%252BUFI%26otn%3D20%26pmod%3D270358046257%26ps%3D50</viewItemURL><globalId>EBAY-US</globalId><timeLeft>P24DT0H32M20S</timeLeft><primaryCategoryId>11700</primaryCategoryId><primaryCategoryName>Home &amp; Garden</primaryCategoryName><buyItNowPrice currencyId="USD">19.95</buyItNowPrice><country>US</country><imageURL>http://thumbs2.ebaystatic.com/m/m4E05_zSYf49FhF9CbSlDsg/80.jpg</imageURL><shippingType>Freight</shippingType></item><item><itemId>270500086631</itemId><title>Solar Hybrid Flashlight: Colors: Black</title><viewItemURL>http://cgi.ebay.com/Solar-Hybrid-Flashlight-Colors-Black-/270500086631?_trksid=m263&amp;_trkparms=algo%3DSIC%26its%3DI%26itu%3DUCI%252BIA%252BUA%252BFICS%252BUFI%26otn%3D20%26pmod%3D270358046257%26ps%3D50</viewItemURL><globalId>EBAY-US</globalId><timeLeft>P24DT0H35M6S</timeLeft><primaryCategoryId>11700</primaryCategoryId><primaryCategoryName>Home &amp; Garden</primaryCategoryName><buyItNowPrice currencyId="USD">19.95</buyItNowPrice><country>US</country><imageURL>http://thumbs4.ebaystatic.com/m/m_mOnguYieCVZS_4-W5P2SQ/80.jpg</imageURL><shippingType>Freight</shippingType></item><item><itemId>280676344897</itemId><title>Solar Powered LED Hybrid Light Flashlight</title><viewItemURL>http://cgi.ebay.com/Solar-Powered-LED-Hybrid-Light-Flashlight-/280676344897?_trksid=m263&amp;_trkparms=algo%3DSIC%26its%3DI%26itu%3DUCI%252BIA%252BUA%252BFICS%252BUFI%26otn%3D20%26pmod%3D270358046257%26ps%3D50</viewItemURL><globalId>EBAY-US</globalId><timeLeft>P0DT23H47M9S</timeLeft><primaryCategoryId>382</primaryCategoryId><primaryCategoryName>Sporting Goods</primaryCategoryName><buyItNowPrice currencyId="USD">18.5</buyItNowPrice><country>US</country><imageURL>http://thumbs2.ebaystatic.com/m/mCkn3aKk8LLWvUl_IG-rVaA/80.jpg</imageURL><shippingType>Freight</shippingType></item><item><itemId>160590728599</itemId><title>HYBRID Camping Hiking Solar Flashlight LED Lantern NEW</title><viewItemURL>http://cgi.ebay.com/HYBRID-Camping-Hiking-Solar-Flashlight-LED-Lantern-NEW-/160590728599?_trksid=m263&amp;_trkparms=algo%3DSIC%26its%3DI%26itu%3DUCI%252BIA%252BUA%252BFICS%252BUFI%26otn%3D20%26pmod%3D270358046257%26ps%3D50</viewItemURL><globalId>EBAY-US</globalId><timeLeft>P8DT13H31M1S</timeLeft><primaryCategoryId>382</primaryCategoryId><primaryCategoryName>Sporting Goods</primaryCategoryName><buyItNowPrice currencyId="USD">29.01</buyItNowPrice><country>US</country><imageURL>http://thumbs4.ebaystatic.com/m/m-0YWWMJA3IB4Yl1klSEsnA/80.jpg</imageURL><shippingCost currencyId="USD">8.98</shippingCost><shippingType>NotSpecified</shippingType></item><item><itemId>280647899527</itemId><title>SOLAR LITE HYBRID LED FLASHLIGHT WATERPROOF Flash Light</title><viewItemURL>http://cgi.ebay.com/SOLAR-LITE-HYBRID-LED-FLASHLIGHT-WATERPROOF-Flash-Light-/280647899527?_trksid=m263&amp;_trkparms=algo%3DSIC%26its%3DI%26itu%3DUCI%252BIA%252BUA%252BFICS%252BUFI%26otn%3D20%26pmod%3D270358046257%26ps%3D50</viewItemURL><globalId>EBAY-US</globalId><timeLeft>P9DT5H12M27S</timeLeft><primaryCategoryId>382</primaryCategoryId><primaryCategoryName>Sporting Goods</primaryCategoryName><buyItNowPrice currencyId="USD">24.75</buyItNowPrice><country>US</country><imageURL>http://thumbs4.ebaystatic.com/m/mkfP4uANcBN3e71VMQo4sbw/80.jpg</imageURL><shippingCost currencyId="USD">0.0</shippingCost><shippingType>Flat</shippingType></item><item><itemId>250832998322</itemId><title>Yellow 3 Mode Colors Flash Wht SMD LED Light Flashlight</title><viewItemURL>http://cgi.ebay.com/Yellow-3-Mode-Colors-Flash-Wht-SMD-LED-Light-Flashlight-/250832998322?_trksid=m263&amp;_trkparms=algo%3DSIC%26its%3DI%26itu%3DUCI%252BIA%252BUA%252BFICS%252BUFI%26otn%3D20%26pmod%3D270358046257%26ps%3D50</viewItemURL><globalId>EBAY-US</globalId><timeLeft>P26DT4H47M5S</timeLeft><primaryCategoryId>11700</primaryCategoryId><primaryCategoryName>Home &amp; Garden</primaryCategoryName><buyItNowPrice currencyId="USD">6.79</buyItNowPrice><country>HK</country><imageURL>http://thumbs3.ebaystatic.com/m/mz4Ig152AmpRX3Jy84X6veA/80.jpg</imageURL><shippingCost currencyId="USD">0.0</shippingCost><shippingType>Flat</shippingType></item><item><itemId>280692101814</itemId><title>Yellow 3 Mode Colors Flash Wht SMD LED Light Flashlight</title><viewItemURL>http://cgi.ebay.com/Yellow-3-Mode-Colors-Flash-Wht-SMD-LED-Light-Flashlight-/280692101814?_trksid=m263&amp;_trkparms=algo%3DSIC%26its%3DI%26itu%3DUCI%252BIA%252BUA%252BFICS%252BUFI%26otn%3D20%26pmod%3D270358046257%26ps%3D50</viewItemURL><globalId>EBAY-US</globalId><timeLeft>P26DT17H8M25S</timeLeft><primaryCategoryId>11700</primaryCategoryId><primaryCategoryName>Home &amp; Garden</primaryCategoryName><buyItNowPrice currencyId="USD">6.74</buyItNowPrice><country>HK</country><imageURL>http://thumbs3.ebaystatic.com/m/m8Nx_BP9nJVuTCgNEfkDxiQ/80.jpg</imageURL><shippingCost currencyId="USD">0.0</shippingCost><shippingType>Flat</shippingType></item><item><itemId>230632147942</itemId><title>Yellow 3 Mode Colors Flash Wht SMD LED Light Flashlight</title><viewItemURL>http://cgi.ebay.com/Yellow-3-Mode-Colors-Flash-Wht-SMD-LED-Light-Flashlight-/230632147942?_trksid=m263&amp;_trkparms=algo%3DSIC%26its%3DI%26itu%3DUCI%252BIA%252BUA%252BFICS%252BUFI%26otn%3D20%26pmod%3D270358046257%26ps%3D50</viewItemURL><globalId>EBAY-US</globalId><timeLeft>P27DT4H15M54S</timeLeft><primaryCategoryId>11700</primaryCategoryId><primaryCategoryName>Home &amp; Garden</primaryCategoryName><buyItNowPrice currencyId="USD">6.8</buyItNowPrice><country>HK</country><imageURL>http://thumbs3.ebaystatic.com/m/mz4Ig152AmpRX3Jy84X6veA/80.jpg</imageURL><shippingCost currencyId="USD">0.0</shippingCost><shippingType>Flat</shippingType></item><item><itemId>390321384991</itemId><title>Yellow 3 Mode Colors Flash Wht SMD LED Light Flashlight</title><viewItemURL>http://cgi.ebay.com/Yellow-3-Mode-Colors-Flash-Wht-SMD-LED-Light-Flashlight-/390321384991?_trksid=m263&amp;_trkparms=algo%3DSIC%26its%3DI%26itu%3DUCI%252BIA%252BUA%252BFICS%252BUFI%26otn%3D20%26pmod%3D270358046257%26ps%3D50</viewItemURL><globalId>EBAY-US</globalId><timeLeft>P28DT8H44M56S</timeLeft><primaryCategoryId>11700</primaryCategoryId><primaryCategoryName>Home &amp; Garden</primaryCategoryName><buyItNowPrice currencyId="USD">6.76</buyItNowPrice><country>HK</country><imageURL>http://thumbs4.ebaystatic.com/m/msDorK8GdiCddNARhuSwg1w/80.jpg</imageURL><shippingCost currencyId="USD">0.0</shippingCost><shippingType>Flat</shippingType></item><item><itemId>180679101537</itemId><title>LED Solar Powered Flashlight Torch Key Chain Yellow</title><viewItemURL>http://cgi.ebay.com/LED-Solar-Powered-Flashlight-Torch-Key-Chain-Yellow-/180679101537?_trksid=m263&amp;_trkparms=algo%3DSIC%26its%3DI%26itu%3DUCI%252BIA%252BUA%252BFICS%252BUFI%26otn%3D20%26pmod%3D270358046257%26ps%3D50</viewItemURL><currentPrice currencyId="USD">0.55</currentPrice><globalId>EBAY-US</globalId><timeLeft>P1DT5H4M55S</timeLeft><primaryCategoryId>293</primaryCategoryId><primaryCategoryName>Consumer Electronics</primaryCategoryName><bidCount>2</bidCount><country>HK</country><imageURL>http://thumbs2.ebaystatic.com/m/mRY61z63OICn_q9MDbPEXhQ/80.jpg</imageURL><shippingCost currencyId="USD">0.0</shippingCost><shippingType>Flat</shippingType></item><item><itemId>250835206437</itemId><title>Yellow 3 LED Mini Solar Flashlight Power keychain torch</title><viewItemURL>http://cgi.ebay.com/Yellow-3-LED-Mini-Solar-Flashlight-Power-keychain-torch-/250835206437?_trksid=m263&amp;_trkparms=algo%3DSIC%26its%3DI%26itu%3DUCI%252BIA%252BUA%252BFICS%252BUFI%26otn%3D20%26pmod%3D270358046257%26ps%3D50</viewItemURL><globalId>EBAY-US</globalId><timeLeft>P1DT13H48M21S</timeLeft><primaryCategoryId>382</primaryCategoryId><primaryCategoryName>Sporting Goods</primaryCategoryName><buyItNowPrice currencyId="USD">1.49</buyItNowPrice><country>HK</country><imageURL>http://thumbs2.ebaystatic.com/m/mvfMd-OOe17Wsb5oq7VDB9g/80.jpg</imageURL><shippingCost currencyId="USD">0.0</shippingCost><shippingType>Flat</shippingType></item><item><itemId>280677810822</itemId><title>Solar Hybrid LED Flashlight (RECHARGE) Waterproof,Green</title><viewItemURL>http://cgi.ebay.com/Solar-Hybrid-LED-Flashlight-RECHARGE-Waterproof-Green-/280677810822?_trksid=m263&amp;_trkparms=algo%3DSIC%26its%3DI%26itu%3DUCI%252BIA%252BUA%252BFICS%252BUFI%26otn%3D20%26pmod%3D270358046257%26ps%3D50</viewItemURL><globalId>EBAY-US</globalId><timeLeft>P3DT14H20M27S</timeLeft><primaryCategoryId>382</primaryCategoryId><primaryCategoryName>Sporting Goods</primaryCategoryName><buyItNowPrice currencyId="USD">24.99</buyItNowPrice><country>US</country><imageURL>http://thumbs3.ebaystatic.com/m/mLQyXql77VBCreUQjO_E8kg/80.jpg</imageURL><shippingCost currencyId="USD">0.0</shippingCost><shippingType>Flat</shippingType></item><item><itemId>160590873695</itemId><title>Yellow Solar Recharge 3-LED mini flashlight keychain</title><viewItemURL>http://cgi.ebay.com/Yellow-Solar-Recharge-3-LED-mini-flashlight-keychain-/160590873695?_trksid=m263&amp;_trkparms=algo%3DSIC%26its%3DI%26itu%3DUCI%252BIA%252BUA%252BFICS%252BUFI%26otn%3D20%26pmod%3D270358046257%26ps%3D50</viewItemURL><globalId>EBAY-US</globalId><timeLeft>P8DT20H36M13S</timeLeft><primaryCategoryId>382</primaryCategoryId><primaryCategoryName>Sporting Goods</primaryCategoryName><buyItNowPrice currencyId="USD">1.09</buyItNowPrice><country>HK</country><imageURL>http://thumbs4.ebaystatic.com/m/mFPKmKmHUy2h1y_ytLZg8dA/80.jpg</imageURL><shippingCost currencyId="USD">1.45</shippingCost><shippingType>NotSpecified</shippingType></item><item><itemId>220707735481</itemId><title>10* 3 LED Solar energy no si-type  flashlight Yellow</title><viewItemURL>http://cgi.ebay.com/10-3-LED-Solar-energy-no-si-type-flashlight-Yellow-/220707735481?_trksid=m263&amp;_trkparms=algo%3DSIC%26its%3DI%26itu%3DUCI%252BIA%252BUA%252BFICS%252BUFI%26otn%3D20%26pmod%3D270358046257%26ps%3D50</viewItemURL><globalId>EBAY-US</globalId><timeLeft>P24DT8H30M47S</timeLeft><primaryCategoryId>382</primaryCategoryId><primaryCategoryName>Sporting Goods</primaryCategoryName><buyItNowPrice currencyId="USD">0.99</buyItNowPrice><country>HK</country><imageURL>http://thumbs2.ebaystatic.com/m/msUO_N2bHs_TKIG7DAU_r-Q/80.jpg</imageURL><shippingCost currencyId="USD">11.0</shippingCost><shippingType>NotSpecified</shippingType></item><item><itemId>170576865131</itemId><title>3 LED MINI  Solar energy no si-type  flashlight Yellow</title><viewItemURL>http://cgi.ebay.com/3-LED-MINI-Solar-energy-no-si-type-flashlight-Yellow-/170576865131?_trksid=m263&amp;_trkparms=algo%3DSIC%26its%3DI%26itu%3DUCI%252BIA%252BUA%252BFICS%252BUFI%26otn%3D20%26pmod%3D270358046257%26ps%3D50</viewItemURL><globalId>EBAY-US</globalId><timeLeft>P25DT7H49M32S</timeLeft><primaryCategoryId>382</primaryCategoryId><primaryCategoryName>Sporting Goods</primaryCategoryName><buyItNowPrice currencyId="USD">0.99</buyItNowPrice><country>HK</country><imageURL>http://thumbs4.ebaystatic.com/m/mTJKBdFBg_gvful_9XW-G_w/80.jpg</imageURL><shippingCost currencyId="USD">0.89</shippingCost><shippingType>NotSpecified</shippingType></item><item><itemId>190477659627</itemId><title>10*3 LED MINI Solar energy no si-type flashlight Yellow</title><viewItemURL>http://cgi.ebay.com/10-3-LED-MINI-Solar-energy-no-si-type-flashlight-Yellow-/190477659627?_trksid=m263&amp;_trkparms=algo%3DSIC%26its%3DI%26itu%3DUCI%252BIA%252BUA%252BFICS%252BUFI%26otn%3D20%26pmod%3D270358046257%26ps%3D50</viewItemURL><globalId>EBAY-US</globalId><timeLeft>P25DT7H55M45S</timeLeft><primaryCategoryId>382</primaryCategoryId><primaryCategoryName>Sporting Goods</primaryCategoryName><buyItNowPrice currencyId="USD">0.99</buyItNowPrice><country>HK</country><imageURL>http://thumbs4.ebaystatic.com/m/mzb9x8BS1XVJdrkwd4MAj5Q/80.jpg</imageURL><shippingCost currencyId="USD">11.0</shippingCost><shippingType>NotSpecified</shippingType></item><item><itemId>230560962785</itemId><title> 3 LED Solar energy no si-type  flashlight Yellow</title><viewItemURL>http://cgi.ebay.com/3-LED-Solar-energy-no-si-type-flashlight-Yellow-/230560962785?_trksid=m263&amp;_trkparms=algo%3DSIC%26its%3DI%26itu%3DUCI%252BIA%252BUA%252BFICS%252BUFI%26otn%3D20%26pmod%3D270358046257%26ps%3D50</viewItemURL><globalId>EBAY-US</globalId><timeLeft>P25DT8H52M20S</timeLeft><primaryCategoryId>382</primaryCategoryId><primaryCategoryName>Sporting Goods</primaryCategoryName><buyItNowPrice currencyId="USD">0.99</buyItNowPrice><country>HK</country><imageURL>http://thumbs2.ebaystatic.com/m/midMfic-bVjzzTZw4wr27GA/80.jpg</imageURL><shippingCost currencyId="USD">1.0</shippingCost><shippingType>NotSpecified</shippingType></item><item><itemId>290574883393</itemId><title>Energizer Small Solar/Crank Hybrid LED Flashlight</title><viewItemURL>http://cgi.ebay.com/Energizer-Small-Solar-Crank-Hybrid-LED-Flashlight-/290574883393?_trksid=m263&amp;_trkparms=algo%3DSIC%26its%3DI%26itu%3DUCI%252BIA%252BUA%252BFICS%252BUFI%26otn%3D20%26pmod%3D270358046257%26ps%3D50</viewItemURL><globalId>EBAY-US</globalId><timeLeft>P27DT15H30M53S</timeLeft><primaryCategoryId>382</primaryCategoryId><primaryCategoryName>Sporting Goods</primaryCategoryName><buyItNowPrice currencyId="USD">19.99</buyItNowPrice><country>US</country><imageURL>http://thumbs2.ebaystatic.com/m/mZLwxpknP1EH3Gz97O8-f8Q/80.jpg</imageURL><shippingCost currencyId="USD">5.0</shippingCost><shippingType>NotSpecified</shippingType></item><item><itemId>370516522695</itemId><title>Hybrid Solar Powered Flashlight-Black (2 pk) BRAND NEW!</title><viewItemURL>http://cgi.ebay.com/Hybrid-Solar-Powered-Flashlight-Black-2-pk-BRAND-NEW-/370516522695?_trksid=m263&amp;_trkparms=algo%3DSIC%26its%3DI%26itu%3DUCI%252BIA%252BUA%252BFICS%252BUFI%26otn%3D20%26pmod%3D270358046257%26ps%3D50</viewItemURL><globalId>EBAY-US</globalId><timeLeft>P24DT20H43M30S</timeLeft><primaryCategoryId>293</primaryCategoryId><primaryCategoryName>Consumer Electronics</primaryCategoryName><buyItNowPrice currencyId="USD">22.98</buyItNowPrice><country>US</country><imageURL>http://thumbs4.ebaystatic.com/m/m-XRPQo5hL7opRTxprdELwg/80.jpg</imageURL><shippingType>FlatDomesticCalculatedInternational</shippingType></item><item><itemId>230609310879</itemId><title>HYBRID SOLAR LITE FLASHLIGHT - 36 AT WHOLESALE PRICE!</title><viewItemURL>http://cgi.ebay.com/HYBRID-SOLAR-LITE-FLASHLIGHT-36-WHOLESALE-PRICE-/230609310879?_trksid=m263&amp;_trkparms=algo%3DSIC%26its%3DI%26itu%3DUCI%252BIA%252BUA%252BFICS%252BUFI%26otn%3D20%26pmod%3D270358046257%26ps%3D50</viewItemURL><globalId>EBAY-US</globalId><timeLeft>P2DT7H18M37S</timeLeft><primaryCategoryId>382</primaryCategoryId><primaryCategoryName>Sporting Goods</primaryCategoryName><subtitle>FREE USA SHIPPING! SURVIVAL EMERGENCY HYBRIDLITE</subtitle><buyItNowPrice currencyId="USD">405.0</buyItNowPrice><country>US</country><imageURL>http://thumbs4.ebaystatic.com/m/mB0tZq_BCJLVTHDEIowSqYQ/80.jpg</imageURL><shippingCost currencyId="USD">0.0</shippingCost><shippingType>Flat</shippingType></item></itemRecommendations></getSimilarItemsResponse>'
        ];
}
