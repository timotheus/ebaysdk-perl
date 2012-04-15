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
        use eBay::API::Simple::Shopping;
    };
    
    if ( $@ ) {
        push @skip_msg, 'missing module eBay::API::Simple::Shopping, skipping test';
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
    @Fake::ISA = qw(eBay::API::Simple::Shopping);
    $call = Fake->new(
        { appid => undef } # <----- your appid here
    );
};
if ( $@ ) {
    push( @skip_msg, $@ );
}

#$call->api_init( { 
#    site_id => 0,
#    uri     => $arg_uri,
#    domain  => $arg_domain,
#    app_id  => $arg_appid,
#    version => $arg_version,
#} );

eval {
        
};

SKIP: {
    skip join( ' ', @skip_msg), 1 if scalar( @skip_msg );

    $call->{response_content} = shift(@{$responses});

    $call->execute( 'FindItemsAdvanced', { 
        QueryKeywords => 'black shoes', 
        MaxEntries => 5,
    } );

    #diag $call->request_content;
    #diag $call->response_content;

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
    
        ok( $call->nodeContent('TotalItems') > 10, 'response total items' );
        #diag( 'total items: ' . $call->nodeContent('TotalItems') );
        #diag( Dumper( $call->response_hash() ) );
    }

    $call->{response_content} = shift(@{$responses});

    $call->execute( 'BadCall', { QueryKeywords => 'shoe' } );

#    is( $call->has_error(), 1, 'look for error flag' );
#    ok( $call->errors_as_string() ne '', 'check for error message' );
    ok( $call->response_content() ne '', 'check for response content' );

    $call->{response_content} = shift(@{$responses});

    $call->execute( 'FindItemsAdvanced', { QueryKeywords => 'shoe' } );

    is( $call->has_error(), 0, 'error check' );
    is( $call->errors_as_string(), '', 'error string check' );
    ok( $call->nodeContent('TotalItems') > 10, 'response total items' );

    #diag( Dumper( $call->response_content() ) );

    my @nodes = $call->response_dom->findnodes(
        '/FindItemsAdvancedResponse/SearchResult/ItemArray/Item'
    );

    foreach my $n ( @nodes ) {
        # diag( $n->findvalue('Title/text()') );
        ok( $n->findvalue('Title/text()') ne '', 'title check' );
    }


    my $call2 = eBay::API::Simple::Shopping->new( { response_encoding => 'XML' } );
    $call->{response_content} = shift(@{$responses});

    $call2->execute( 'FindPopularSearches', { QueryKeywords => 'shoe' } );

    #diag( $call2->response_content() );
}

BEGIN {
$responses = [
          '<?xml version="1.0" encoding="UTF-8"?>

  <FindItemsAdvancedResponse >
   <Timestamp>2011-06-10T21:54:09.265Z</Timestamp>
   <Ack>Success</Ack>
   <Build>E725_CORE_BUNDLED_13319544_R1</Build>
   <Version>725</Version>
   <SearchResult>
    <ItemArray>
     <Item>
      <ItemID>220793930223</ItemID>
      <EndTime>2011-06-10T21:54:21.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Gently-Used-Black-Privo-Clarks-Size-6-5_W0QQitemZ220793930223QQcategoryZ45333QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs4.ebaystatic.com/pict/2207939302238080_1.jpg</GalleryURL>
      <PrimaryCategoryID>45333</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Flats &amp; Oxfords</PrimaryCategoryName>
      <BidCount>1</BidCount>
      <ConvertedCurrentPrice currencyID="USD">10.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT12S</TimeLeft>
      <Title>Gently Used Black Privo Clarks Size 6.5</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">10.0</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">10.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>230630303486</ItemID>
      <BuyItNowAvailable>true</BuyItNowAvailable>
      <ConvertedBuyItNowPrice currencyID="USD">50.0</ConvertedBuyItNowPrice>
      <EndTime>2011-06-10T21:54:27.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Franco-Sarto-Ensign-Black-Leather-Heel_W0QQitemZ230630303486QQcategoryZ55793QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs3.ebaystatic.com/pict/2306303034868080_1.jpg</GalleryURL>
      <PrimaryCategoryID>55793</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Heels</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">40.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT18S</TimeLeft>
      <Title>Franco Sarto &quot;Ensign&quot; Black Leather Heel</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">9.4</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">9.4</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>270761312141</ItemID>
      <EndTime>2011-06-10T21:54:30.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Korea-Bag-Cellphone-Key-High-heeled-Shoes-Pendant-Black_W0QQitemZ270761312141QQcategoryZ50649QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs2.ebaystatic.com/pict/2707613121418080_1.jpg</GalleryURL>
      <PrimaryCategoryID>50649</PrimaryCategoryID>
      <PrimaryCategoryName>Jewelry &amp; Watches:Fashion Jewelry:Necklaces &amp; Pendants:Other</PrimaryCategoryName>
      <BidCount>4</BidCount>
      <ConvertedCurrentPrice currencyID="USD">1.6</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT21S</TimeLeft>
      <Title>Korea Bag Cellphone Key High-heeled Shoes Pendant Black</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">0.0</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">0.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>120735177966</ItemID>
      <BuyItNowAvailable>true</BuyItNowAvailable>
      <ConvertedBuyItNowPrice currencyID="USD">499.99</ConvertedBuyItNowPrice>
      <EndTime>2011-06-10T21:54:38.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/GIUSEPPE-ZANOTTI-NAPPA-BLACK-LEATHER-PEEP-TOE-BOOT-39-9_W0QQitemZ120735177966QQcategoryZ55793QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs3.ebaystatic.com/pict/1207351779668080_1.jpg</GalleryURL>
      <PrimaryCategoryID>55793</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Heels</PrimaryCategoryName>
      <BidCount>17</BidCount>
      <ConvertedCurrentPrice currencyID="USD">136.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT29S</TimeLeft>
      <Title>GIUSEPPE ZANOTTI&quot;NAPPA&quot;BLACK LEATHER PEEP TOE BOOT 39/9</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">0.0</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">0.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>270762372668</ItemID>
      <EndTime>2011-06-10T21:54:53.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Womens-Talbots-Black-and-Brown-Tassle-Loafers-9M_W0QQitemZ270762372668QQcategoryZ45333QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs1.ebaystatic.com/pict/2707623726688080_1.jpg</GalleryURL>
      <PrimaryCategoryID>45333</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Flats &amp; Oxfords</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">10.99</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT44S</TimeLeft>
      <Title> Women&apos;s Talbots Black and Brown Tassle Loafers 9M</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">7.99</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">7.99</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
    </ItemArray>
   </SearchResult>
   <PageNumber>1</PageNumber>
   <TotalPages>156108</TotalPages>
   <TotalItems>780540</TotalItems>
   <ItemSearchURL>http://search.ebay.com/ws/search/SaleSearch?DemandData=1&amp;fsop=32&amp;satitle=black+shoes</ItemSearchURL>
  </FindItemsAdvancedResponse>
 ',
          '<html><body><b>Http/1.1 Service Unavailable</b></body> </html>',
          '<?xml version="1.0" encoding="UTF-8"?>

  <FindItemsAdvancedResponse >
   <Timestamp>2011-06-10T21:54:12.221Z</Timestamp>
   <Ack>Success</Ack>
   <Build>E725_CORE_BUNDLED_13319544_R1</Build>
   <Version>725</Version>
   <SearchResult>
    <ItemArray>
     <Item>
      <ItemID>140559806291</ItemID>
      <EndTime>2011-06-10T21:54:14.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/ANESTACIA-Size-7-5-WOMAN-LEATHER-BOOT_W0QQitemZ140559806291QQcategoryZ53557QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs4.ebaystatic.com/pict/1405598062918080_1.jpg</GalleryURL>
      <PrimaryCategoryID>53557</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Boots</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">19.99</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT2S</TimeLeft>
      <Title>ANESTACIA Size 7.5 WOMAN LEATHER BOOT</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">6.99</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">6.99</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>350255325151</ItemID>
      <EndTime>2011-06-13T08:15:52.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/ADIDAS-WOMENS-LADIES-SLVR-SANTA-ROSA-TRAINERS-SHOES-UK_W0QQitemZ350255325151QQcategoryZ95672QQvarZ620000303892QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>StoresFixedPrice</ListingType>
      <PrimaryCategoryID>95672</PrimaryCategoryID>
      <PrimaryCategoryName>Clothes, Shoes &amp; Accessories:Women&apos;s Shoes:Trainers</PrimaryCategoryName>
      <BidCount>61</BidCount>
      <ConvertedCurrentPrice currencyID="USD">32.72</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>P2DT10H21M40S</TimeLeft>
      <Title>ADIDAS WOMENS LADIES SLVR SANTA ROSA TRAINERS SHOES UK</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">13.1</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="GBP">8.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>200617546184</ItemID>
      <EndTime>2011-06-10T21:54:17.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/PRO-Metal-Shoe-Horn-7-5-Shoehorn-Spoon-Stainless-Steel_W0QQitemZ200617546184QQcategoryZ163627QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs1.ebaystatic.com/pict/2006175461848080_1.jpg</GalleryURL>
      <PrimaryCategoryID>163627</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Vintage:Vintage Accessories:Shoe Accessories</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">0.99</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT5S</TimeLeft>
      <Title>PRO Metal Shoe Horn 7.5&quot; Shoehorn Spoon Stainless Steel</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">3.99</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">3.99</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>220793930223</ItemID>
      <EndTime>2011-06-10T21:54:21.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Gently-Used-Black-Privo-Clarks-Size-6-5_W0QQitemZ220793930223QQcategoryZ45333QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs4.ebaystatic.com/pict/2207939302238080_1.jpg</GalleryURL>
      <PrimaryCategoryID>45333</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Flats &amp; Oxfords</PrimaryCategoryName>
      <BidCount>1</BidCount>
      <ConvertedCurrentPrice currencyID="USD">10.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT9S</TimeLeft>
      <Title>Gently Used Black Privo Clarks Size 6.5</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">10.0</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">10.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>120732985428</ItemID>
      <EndTime>2011-06-10T21:54:23.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Chanel-Gorgeous-Womens-Slip-On-Flats-Size-7-U-S_W0QQitemZ120732985428QQcategoryZ11632QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs1.ebaystatic.com/pict/1207329854288080_1.jpg</GalleryURL>
      <PrimaryCategoryID>11632</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Slippers</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">79.99</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT11S</TimeLeft>
      <Title>Chanel  Gorgeous Women&apos;s Slip On Flats Size 7 U.S.</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">11.94</ShippingServiceCost>
       <ShippingType>Calculated</ShippingType>
       <ListedShippingServiceCost currencyID="USD">11.94</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>370515984559</ItemID>
      <EndTime>2011-06-10T21:54:23.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Nike-Air-Max-95-Zen-Running-Shoes-Womens-US-7-5-EU-38-5_W0QQitemZ370515984559QQcategoryZ95672QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs4.ebaystatic.com/pict/3705159845598080_2.jpg</GalleryURL>
      <PrimaryCategoryID>95672</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Athletic</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">49.99</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT11S</TimeLeft>
      <Title>Nike Air Max 95 Zen Running Shoes Womens US 7.5 EU 38.5</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">16.0</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">16.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>230630303486</ItemID>
      <BuyItNowAvailable>true</BuyItNowAvailable>
      <ConvertedBuyItNowPrice currencyID="USD">50.0</ConvertedBuyItNowPrice>
      <EndTime>2011-06-10T21:54:27.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Franco-Sarto-Ensign-Black-Leather-Heel_W0QQitemZ230630303486QQcategoryZ55793QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs3.ebaystatic.com/pict/2306303034868080_1.jpg</GalleryURL>
      <PrimaryCategoryID>55793</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Heels</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">40.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT15S</TimeLeft>
      <Title>Franco Sarto &quot;Ensign&quot; Black Leather Heel</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">9.4</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">9.4</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>120735562320</ItemID>
      <EndTime>2011-06-15T20:02:40.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Swedish-Made-CAPE-CLOGS-by-Torpatoffeln-BRAND-NEW_W0QQitemZ120735562320QQcategoryZ45333QQvarZ420033823631QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>FixedPriceItem</ListingType>
      <PrimaryCategoryID>45333</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Flats &amp; Oxfords</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">29.99</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>P4DT22H8M28S</TimeLeft>
      <Title>Swedish Made CAPE CLOGS by Torpatoffeln   BRAND NEW!</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">0.0</ShippingServiceCost>
       <ShippingType>FlatDomesticCalculatedInternational</ShippingType>
       <ListedShippingServiceCost currencyID="USD">0.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>360371359933</ItemID>
      <EndTime>2011-06-10T21:54:29.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Birkenstock-Papillio-Gizeh-Thongs-39-Leopard-Print_W0QQitemZ360371359933QQcategoryZ62107QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs2.ebaystatic.com/pict/3603713599338080_1.jpg</GalleryURL>
      <PrimaryCategoryID>62107</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Sandals &amp; Flip Flops</PrimaryCategoryName>
      <BidCount>19</BidCount>
      <ConvertedCurrentPrice currencyID="USD">61.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT17S</TimeLeft>
      <Title>Birkenstock Papillio Gizeh Thongs 39 Leopard Print +</Title>
      <ShippingCostSummary>
       <ShippingType>Calculated</ShippingType>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>270761312141</ItemID>
      <EndTime>2011-06-10T21:54:30.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Korea-Bag-Cellphone-Key-High-heeled-Shoes-Pendant-Black_W0QQitemZ270761312141QQcategoryZ50649QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs2.ebaystatic.com/pict/2707613121418080_1.jpg</GalleryURL>
      <PrimaryCategoryID>50649</PrimaryCategoryID>
      <PrimaryCategoryName>Jewelry &amp; Watches:Fashion Jewelry:Necklaces &amp; Pendants:Other</PrimaryCategoryName>
      <BidCount>4</BidCount>
      <ConvertedCurrentPrice currencyID="USD">1.6</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT18S</TimeLeft>
      <Title>Korea Bag Cellphone Key High-heeled Shoes Pendant Black</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">0.0</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">0.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>110697691184</ItemID>
      <EndTime>2011-06-10T21:54:32.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Kate-Spade-Merrie-Sandal-Pink-Neon-Seahorse_W0QQitemZ110697691184QQcategoryZ62107QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs1.ebaystatic.com/pict/1106976911848080_1.jpg</GalleryURL>
      <PrimaryCategoryID>62107</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Sandals &amp; Flip Flops</PrimaryCategoryName>
      <BidCount>14</BidCount>
      <ConvertedCurrentPrice currencyID="USD">30.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT20S</TimeLeft>
      <Title>Kate Spade Merrie Sandal Pink Neon Seahorse</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">5.0</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">5.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>270762372588</ItemID>
      <BuyItNowAvailable>true</BuyItNowAvailable>
      <ConvertedBuyItNowPrice currencyID="USD">50.0</ConvertedBuyItNowPrice>
      <EndTime>2011-06-10T21:54:36.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Michael-Antonio-red-Lace-Bootie-Pumps_W0QQitemZ270762372588QQcategoryZ55793QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs1.ebaystatic.com/pict/2707623725888080_1.jpg</GalleryURL>
      <PrimaryCategoryID>55793</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Heels</PrimaryCategoryName>
      <BidCount>1</BidCount>
      <ConvertedCurrentPrice currencyID="USD">10.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT24S</TimeLeft>
      <Title>Michael Antonio red Lace Bootie Pumps </Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">10.0</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">10.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>120735177966</ItemID>
      <BuyItNowAvailable>true</BuyItNowAvailable>
      <ConvertedBuyItNowPrice currencyID="USD">499.99</ConvertedBuyItNowPrice>
      <EndTime>2011-06-10T21:54:38.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/GIUSEPPE-ZANOTTI-NAPPA-BLACK-LEATHER-PEEP-TOE-BOOT-39-9_W0QQitemZ120735177966QQcategoryZ55793QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs3.ebaystatic.com/pict/1207351779668080_1.jpg</GalleryURL>
      <PrimaryCategoryID>55793</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Heels</PrimaryCategoryName>
      <BidCount>17</BidCount>
      <ConvertedCurrentPrice currencyID="USD">136.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT26S</TimeLeft>
      <Title>GIUSEPPE ZANOTTI&quot;NAPPA&quot;BLACK LEATHER PEEP TOE BOOT 39/9</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">0.0</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">0.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>380345264599</ItemID>
      <BuyItNowAvailable>true</BuyItNowAvailable>
      <ConvertedBuyItNowPrice currencyID="USD">15.0</ConvertedBuyItNowPrice>
      <EndTime>2011-06-10T21:54:40.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/RAMPAGE-TRAFFIC-YELLOW-WEDGES-SIZE-9-5_W0QQitemZ380345264599QQcategoryZ55793QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs4.ebaystatic.com/pict/3803452645998080_1.jpg</GalleryURL>
      <PrimaryCategoryID>55793</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Heels</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">10.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT28S</TimeLeft>
      <Title>RAMPAGE TRAFFIC YELLOW WEDGES SIZE 9.5</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">10.52</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">10.52</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>120735562320</ItemID>
      <EndTime>2011-06-15T20:02:40.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Swedish-Made-CAPE-CLOGS-by-Torpatoffeln-BRAND-NEW_W0QQitemZ120735562320QQcategoryZ45333QQvarZ420033823632QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>FixedPriceItem</ListingType>
      <PrimaryCategoryID>45333</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Flats &amp; Oxfords</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">34.99</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>P4DT22H8M28S</TimeLeft>
      <Title>Swedish Made CAPE CLOGS by Torpatoffeln   BRAND NEW!</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">0.0</ShippingServiceCost>
       <ShippingType>FlatDomesticCalculatedInternational</ShippingType>
       <ListedShippingServiceCost currencyID="USD">0.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>200615775172</ItemID>
      <EndTime>2011-06-10T21:54:41.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/New-women-peep-toe-wedge-heels-buckle-shoes-AU-Sz-7-38_W0QQitemZ200615775172QQcategoryZ62107QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs1.ebaystatic.com/pict/2006157751728080_1.jpg</GalleryURL>
      <PrimaryCategoryID>62107</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes, Accessories:Women&apos;s Shoes:Sandals, Flip-Flops</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">21.22</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT29S</TimeLeft>
      <Title>New women peep toe wedge heels buckle shoes AU Sz 7/38</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">13.79</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="AUD">12.99</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>110696496124</ItemID>
      <EndTime>2011-06-10T21:54:42.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/pair-of-boots-shoes-kids-L-L-Bean-sz-12_W0QQitemZ110696496124QQcategoryZ147285QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs1.ebaystatic.com/pict/1106964961248080_1.jpg</GalleryURL>
      <PrimaryCategoryID>147285</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Baby &amp; Toddler Clothing:Girls-Shoes</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">2.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT30S</TimeLeft>
      <Title>pair of boots shoes kids L.L. Bean sz 12</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">6.0</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">6.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>230632082603</ItemID>
      <BuyItNowAvailable>true</BuyItNowAvailable>
      <ConvertedBuyItNowPrice currencyID="USD">16.99</ConvertedBuyItNowPrice>
      <EndTime>2011-06-10T21:54:43.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Sweater-Knit-Crochet-Knitted-Winter-Womens-Boots-Sz-8_W0QQitemZ230632082603QQcategoryZ53557QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs4.ebaystatic.com/pict/2306320826038080_1.jpg</GalleryURL>
      <PrimaryCategoryID>53557</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Boots</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">14.99</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT31S</TimeLeft>
      <Title>Sweater Knit Crochet Knitted Winter Womens Boots Sz 8</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">11.99</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">11.99</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>200616732150</ItemID>
      <EndTime>2011-06-10T21:54:51.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Boys-Birkenstock-Birkis-EU-25-US-8-8-5_W0QQitemZ200616732150QQcategoryZ57929QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs3.ebaystatic.com/pict/2006167321508080_1.jpg</GalleryURL>
      <PrimaryCategoryID>57929</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Children&apos;s Clothing &amp; Shoes:Boys-Shoes</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">5.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT39S</TimeLeft>
      <Title>Boy&apos;s Birkenstock Birki&apos;s EU 25/ US 8-8.5</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">8.0</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">8.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>260797639763</ItemID>
      <BuyItNowAvailable>true</BuyItNowAvailable>
      <ConvertedBuyItNowPrice currencyID="USD">125.0</ConvertedBuyItNowPrice>
      <EndTime>2011-06-10T21:54:53.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Jordan-package-18-5_W0QQitemZ260797639763QQcategoryZ57929QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs4.ebaystatic.com/pict/2607976397638080_1.jpg</GalleryURL>
      <PrimaryCategoryID>57929</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Children&apos;s Clothing &amp; Shoes:Boys-Shoes</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">100.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT41S</TimeLeft>
      <Title>Jordan package 18/5 </Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">5.0</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">5.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
    </ItemArray>
   </SearchResult>
   <PageNumber>1</PageNumber>
   <TotalPages>162289</TotalPages>
   <TotalItems>3245772</TotalItems>
   <ItemSearchURL>http://search.ebay.com/ws/search/SaleSearch?DemandData=1&amp;fsop=32&amp;satitle=shoe</ItemSearchURL>
  </FindItemsAdvancedResponse>
 ',
          '<?xml version="1.0" encoding="UTF-8"?>

  <FindItemsAdvancedResponse >
   <Timestamp>2011-06-10T21:54:12.221Z</Timestamp>
   <Ack>Success</Ack>
   <Build>E725_CORE_BUNDLED_13319544_R1</Build>
   <Version>725</Version>
   <SearchResult>
    <ItemArray>
     <Item>
      <ItemID>140559806291</ItemID>
      <EndTime>2011-06-10T21:54:14.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/ANESTACIA-Size-7-5-WOMAN-LEATHER-BOOT_W0QQitemZ140559806291QQcategoryZ53557QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs4.ebaystatic.com/pict/1405598062918080_1.jpg</GalleryURL>
      <PrimaryCategoryID>53557</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Boots</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">19.99</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT2S</TimeLeft>
      <Title>ANESTACIA Size 7.5 WOMAN LEATHER BOOT</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">6.99</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">6.99</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>350255325151</ItemID>
      <EndTime>2011-06-13T08:15:52.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/ADIDAS-WOMENS-LADIES-SLVR-SANTA-ROSA-TRAINERS-SHOES-UK_W0QQitemZ350255325151QQcategoryZ95672QQvarZ620000303892QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>StoresFixedPrice</ListingType>
      <PrimaryCategoryID>95672</PrimaryCategoryID>
      <PrimaryCategoryName>Clothes, Shoes &amp; Accessories:Women&apos;s Shoes:Trainers</PrimaryCategoryName>
      <BidCount>61</BidCount>
      <ConvertedCurrentPrice currencyID="USD">32.72</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>P2DT10H21M40S</TimeLeft>
      <Title>ADIDAS WOMENS LADIES SLVR SANTA ROSA TRAINERS SHOES UK</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">13.1</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="GBP">8.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>200617546184</ItemID>
      <EndTime>2011-06-10T21:54:17.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/PRO-Metal-Shoe-Horn-7-5-Shoehorn-Spoon-Stainless-Steel_W0QQitemZ200617546184QQcategoryZ163627QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs1.ebaystatic.com/pict/2006175461848080_1.jpg</GalleryURL>
      <PrimaryCategoryID>163627</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Vintage:Vintage Accessories:Shoe Accessories</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">0.99</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT5S</TimeLeft>
      <Title>PRO Metal Shoe Horn 7.5&quot; Shoehorn Spoon Stainless Steel</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">3.99</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">3.99</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>220793930223</ItemID>
      <EndTime>2011-06-10T21:54:21.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Gently-Used-Black-Privo-Clarks-Size-6-5_W0QQitemZ220793930223QQcategoryZ45333QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs4.ebaystatic.com/pict/2207939302238080_1.jpg</GalleryURL>
      <PrimaryCategoryID>45333</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Flats &amp; Oxfords</PrimaryCategoryName>
      <BidCount>1</BidCount>
      <ConvertedCurrentPrice currencyID="USD">10.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT9S</TimeLeft>
      <Title>Gently Used Black Privo Clarks Size 6.5</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">10.0</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">10.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>120732985428</ItemID>
      <EndTime>2011-06-10T21:54:23.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Chanel-Gorgeous-Womens-Slip-On-Flats-Size-7-U-S_W0QQitemZ120732985428QQcategoryZ11632QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs1.ebaystatic.com/pict/1207329854288080_1.jpg</GalleryURL>
      <PrimaryCategoryID>11632</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Slippers</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">79.99</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT11S</TimeLeft>
      <Title>Chanel  Gorgeous Women&apos;s Slip On Flats Size 7 U.S.</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">11.94</ShippingServiceCost>
       <ShippingType>Calculated</ShippingType>
       <ListedShippingServiceCost currencyID="USD">11.94</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>370515984559</ItemID>
      <EndTime>2011-06-10T21:54:23.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Nike-Air-Max-95-Zen-Running-Shoes-Womens-US-7-5-EU-38-5_W0QQitemZ370515984559QQcategoryZ95672QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs4.ebaystatic.com/pict/3705159845598080_2.jpg</GalleryURL>
      <PrimaryCategoryID>95672</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Athletic</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">49.99</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT11S</TimeLeft>
      <Title>Nike Air Max 95 Zen Running Shoes Womens US 7.5 EU 38.5</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">16.0</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">16.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>230630303486</ItemID>
      <BuyItNowAvailable>true</BuyItNowAvailable>
      <ConvertedBuyItNowPrice currencyID="USD">50.0</ConvertedBuyItNowPrice>
      <EndTime>2011-06-10T21:54:27.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Franco-Sarto-Ensign-Black-Leather-Heel_W0QQitemZ230630303486QQcategoryZ55793QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs3.ebaystatic.com/pict/2306303034868080_1.jpg</GalleryURL>
      <PrimaryCategoryID>55793</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Heels</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">40.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT15S</TimeLeft>
      <Title>Franco Sarto &quot;Ensign&quot; Black Leather Heel</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">9.4</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">9.4</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>120735562320</ItemID>
      <EndTime>2011-06-15T20:02:40.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Swedish-Made-CAPE-CLOGS-by-Torpatoffeln-BRAND-NEW_W0QQitemZ120735562320QQcategoryZ45333QQvarZ420033823631QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>FixedPriceItem</ListingType>
      <PrimaryCategoryID>45333</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Flats &amp; Oxfords</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">29.99</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>P4DT22H8M28S</TimeLeft>
      <Title>Swedish Made CAPE CLOGS by Torpatoffeln   BRAND NEW!</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">0.0</ShippingServiceCost>
       <ShippingType>FlatDomesticCalculatedInternational</ShippingType>
       <ListedShippingServiceCost currencyID="USD">0.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>360371359933</ItemID>
      <EndTime>2011-06-10T21:54:29.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Birkenstock-Papillio-Gizeh-Thongs-39-Leopard-Print_W0QQitemZ360371359933QQcategoryZ62107QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs2.ebaystatic.com/pict/3603713599338080_1.jpg</GalleryURL>
      <PrimaryCategoryID>62107</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Sandals &amp; Flip Flops</PrimaryCategoryName>
      <BidCount>19</BidCount>
      <ConvertedCurrentPrice currencyID="USD">61.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT17S</TimeLeft>
      <Title>Birkenstock Papillio Gizeh Thongs 39 Leopard Print +</Title>
      <ShippingCostSummary>
       <ShippingType>Calculated</ShippingType>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>270761312141</ItemID>
      <EndTime>2011-06-10T21:54:30.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Korea-Bag-Cellphone-Key-High-heeled-Shoes-Pendant-Black_W0QQitemZ270761312141QQcategoryZ50649QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs2.ebaystatic.com/pict/2707613121418080_1.jpg</GalleryURL>
      <PrimaryCategoryID>50649</PrimaryCategoryID>
      <PrimaryCategoryName>Jewelry &amp; Watches:Fashion Jewelry:Necklaces &amp; Pendants:Other</PrimaryCategoryName>
      <BidCount>4</BidCount>
      <ConvertedCurrentPrice currencyID="USD">1.6</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT18S</TimeLeft>
      <Title>Korea Bag Cellphone Key High-heeled Shoes Pendant Black</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">0.0</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">0.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>110697691184</ItemID>
      <EndTime>2011-06-10T21:54:32.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Kate-Spade-Merrie-Sandal-Pink-Neon-Seahorse_W0QQitemZ110697691184QQcategoryZ62107QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs1.ebaystatic.com/pict/1106976911848080_1.jpg</GalleryURL>
      <PrimaryCategoryID>62107</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Sandals &amp; Flip Flops</PrimaryCategoryName>
      <BidCount>14</BidCount>
      <ConvertedCurrentPrice currencyID="USD">30.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT20S</TimeLeft>
      <Title>Kate Spade Merrie Sandal Pink Neon Seahorse</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">5.0</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">5.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>270762372588</ItemID>
      <BuyItNowAvailable>true</BuyItNowAvailable>
      <ConvertedBuyItNowPrice currencyID="USD">50.0</ConvertedBuyItNowPrice>
      <EndTime>2011-06-10T21:54:36.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Michael-Antonio-red-Lace-Bootie-Pumps_W0QQitemZ270762372588QQcategoryZ55793QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs1.ebaystatic.com/pict/2707623725888080_1.jpg</GalleryURL>
      <PrimaryCategoryID>55793</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Heels</PrimaryCategoryName>
      <BidCount>1</BidCount>
      <ConvertedCurrentPrice currencyID="USD">10.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT24S</TimeLeft>
      <Title>Michael Antonio red Lace Bootie Pumps </Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">10.0</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">10.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>120735177966</ItemID>
      <BuyItNowAvailable>true</BuyItNowAvailable>
      <ConvertedBuyItNowPrice currencyID="USD">499.99</ConvertedBuyItNowPrice>
      <EndTime>2011-06-10T21:54:38.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/GIUSEPPE-ZANOTTI-NAPPA-BLACK-LEATHER-PEEP-TOE-BOOT-39-9_W0QQitemZ120735177966QQcategoryZ55793QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs3.ebaystatic.com/pict/1207351779668080_1.jpg</GalleryURL>
      <PrimaryCategoryID>55793</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Heels</PrimaryCategoryName>
      <BidCount>17</BidCount>
      <ConvertedCurrentPrice currencyID="USD">136.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT26S</TimeLeft>
      <Title>GIUSEPPE ZANOTTI&quot;NAPPA&quot;BLACK LEATHER PEEP TOE BOOT 39/9</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">0.0</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">0.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>380345264599</ItemID>
      <BuyItNowAvailable>true</BuyItNowAvailable>
      <ConvertedBuyItNowPrice currencyID="USD">15.0</ConvertedBuyItNowPrice>
      <EndTime>2011-06-10T21:54:40.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/RAMPAGE-TRAFFIC-YELLOW-WEDGES-SIZE-9-5_W0QQitemZ380345264599QQcategoryZ55793QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs4.ebaystatic.com/pict/3803452645998080_1.jpg</GalleryURL>
      <PrimaryCategoryID>55793</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Heels</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">10.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT28S</TimeLeft>
      <Title>RAMPAGE TRAFFIC YELLOW WEDGES SIZE 9.5</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">10.52</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">10.52</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>120735562320</ItemID>
      <EndTime>2011-06-15T20:02:40.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Swedish-Made-CAPE-CLOGS-by-Torpatoffeln-BRAND-NEW_W0QQitemZ120735562320QQcategoryZ45333QQvarZ420033823632QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>FixedPriceItem</ListingType>
      <PrimaryCategoryID>45333</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Flats &amp; Oxfords</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">34.99</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>P4DT22H8M28S</TimeLeft>
      <Title>Swedish Made CAPE CLOGS by Torpatoffeln   BRAND NEW!</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">0.0</ShippingServiceCost>
       <ShippingType>FlatDomesticCalculatedInternational</ShippingType>
       <ListedShippingServiceCost currencyID="USD">0.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>200615775172</ItemID>
      <EndTime>2011-06-10T21:54:41.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/New-women-peep-toe-wedge-heels-buckle-shoes-AU-Sz-7-38_W0QQitemZ200615775172QQcategoryZ62107QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs1.ebaystatic.com/pict/2006157751728080_1.jpg</GalleryURL>
      <PrimaryCategoryID>62107</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes, Accessories:Women&apos;s Shoes:Sandals, Flip-Flops</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">21.22</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT29S</TimeLeft>
      <Title>New women peep toe wedge heels buckle shoes AU Sz 7/38</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">13.79</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="AUD">12.99</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>110696496124</ItemID>
      <EndTime>2011-06-10T21:54:42.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/pair-of-boots-shoes-kids-L-L-Bean-sz-12_W0QQitemZ110696496124QQcategoryZ147285QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs1.ebaystatic.com/pict/1106964961248080_1.jpg</GalleryURL>
      <PrimaryCategoryID>147285</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Baby &amp; Toddler Clothing:Girls-Shoes</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">2.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT30S</TimeLeft>
      <Title>pair of boots shoes kids L.L. Bean sz 12</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">6.0</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">6.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>230632082603</ItemID>
      <BuyItNowAvailable>true</BuyItNowAvailable>
      <ConvertedBuyItNowPrice currencyID="USD">16.99</ConvertedBuyItNowPrice>
      <EndTime>2011-06-10T21:54:43.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Sweater-Knit-Crochet-Knitted-Winter-Womens-Boots-Sz-8_W0QQitemZ230632082603QQcategoryZ53557QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs4.ebaystatic.com/pict/2306320826038080_1.jpg</GalleryURL>
      <PrimaryCategoryID>53557</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Women&apos;s Shoes:Boots</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">14.99</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT31S</TimeLeft>
      <Title>Sweater Knit Crochet Knitted Winter Womens Boots Sz 8</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">11.99</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">11.99</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>200616732150</ItemID>
      <EndTime>2011-06-10T21:54:51.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Boys-Birkenstock-Birkis-EU-25-US-8-8-5_W0QQitemZ200616732150QQcategoryZ57929QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs3.ebaystatic.com/pict/2006167321508080_1.jpg</GalleryURL>
      <PrimaryCategoryID>57929</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Children&apos;s Clothing &amp; Shoes:Boys-Shoes</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">5.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT39S</TimeLeft>
      <Title>Boy&apos;s Birkenstock Birki&apos;s EU 25/ US 8-8.5</Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">8.0</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">8.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
     <Item>
      <ItemID>260797639763</ItemID>
      <BuyItNowAvailable>true</BuyItNowAvailable>
      <ConvertedBuyItNowPrice currencyID="USD">125.0</ConvertedBuyItNowPrice>
      <EndTime>2011-06-10T21:54:53.000Z</EndTime>
      <ViewItemURLForNaturalSearch>http://cgi.ebay.com/Jordan-package-18-5_W0QQitemZ260797639763QQcategoryZ57929QQcmdZViewItem</ViewItemURLForNaturalSearch>
      <ListingType>Chinese</ListingType>
      <GalleryURL>http://thumbs4.ebaystatic.com/pict/2607976397638080_1.jpg</GalleryURL>
      <PrimaryCategoryID>57929</PrimaryCategoryID>
      <PrimaryCategoryName>Clothing, Shoes &amp; Accessories:Children&apos;s Clothing &amp; Shoes:Boys-Shoes</PrimaryCategoryName>
      <BidCount>0</BidCount>
      <ConvertedCurrentPrice currencyID="USD">100.0</ConvertedCurrentPrice>
      <ListingStatus>Active</ListingStatus>
      <TimeLeft>PT41S</TimeLeft>
      <Title>Jordan package 18/5 </Title>
      <ShippingCostSummary>
       <ShippingServiceCost currencyID="USD">5.0</ShippingServiceCost>
       <ShippingType>Flat</ShippingType>
       <ListedShippingServiceCost currencyID="USD">5.0</ListedShippingServiceCost>
      </ShippingCostSummary>
     </Item>
    </ItemArray>
   </SearchResult>
   <PageNumber>1</PageNumber>
   <TotalPages>162289</TotalPages>
   <TotalItems>3245772</TotalItems>
   <ItemSearchURL>http://search.ebay.com/ws/search/SaleSearch?DemandData=1&amp;fsop=32&amp;satitle=shoe</ItemSearchURL>
  </FindItemsAdvancedResponse>
 '
        ];


}
