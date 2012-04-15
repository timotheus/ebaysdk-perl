use Test::More;
use strict; no warnings;
#use LWP::Debug qw(+);
use Data::Dumper;
use lib qw/lib t/;
use Fake;


BEGIN {
    my @skip_msg;

    eval {
        use eBay::API::SimpleBase;
        use eBay::API::Simple::RSS;
    };
    
    if ( $@ ) {
        push @skip_msg, 'missing module eBay::API::SimpleBase, skipping test';
    }
    if ( scalar( @skip_msg ) ) {
        plan skip_all => join( ' ', @skip_msg );
    }
    else {
        plan qw(no_plan);
    }

}

my $simple = eBay::API::SimpleBase->new();
my $rss = eBay::API::Simple::RSS->new();

my $url = 'http://worldofgood.ebay.com/Eco-Organic-Clothes-Shoes-Men-Women-Children/43/list'; 

#$rss->add_call( );
#$rss->add_call( );

#for my $ct ( 1 .. 60 ) {
#    $rss->execute( $url, { page => 1, format => 'rss' } );
#    print length( $rss->response_hash() );
#}

#exit;

for my $ct ( 1 .. 5 ) {
    $rss->execute2( [ 
        [ $url, { page => 1, format => 'rss' } ], 
        [ $url, { page => 2, format => 'rss' } ], 
        [ $url, { page => 3, format => 'rss' } ], 
        [ $url, { page => 4, format => 'rss' } ], 
        [ $url, { page => 5, format => 'rss' } ], 
        [ $url, { page => 6, format => 'rss' } ], 
        [ $url, { page => 7, format => 'rss' } ], 
        [ $url, { page => 8, format => 'rss' } ], 
    ] );

    for my $call ( @{ $rss->{calls} } ) {
        print "has error:\n" . $call->{error} . "\n";
        print "request:\n" . length( $call->{request_content} ) . "\n";
        print "response:\n" . length( $call->{response_content} ) . "\n";
        #print length( $call->{hash} ) . "\n\n";
    }

}

exit;

=head1

for my $ct ( 1 .. 5 ) {
    my @calls = $rss->execute_batch( [ 
        { 
            args => [ $url, { page => 1, format => 'rss' } ] 
        },
        { 
            args => [ $url, { page => 2, format => 'rss' } ] 
        },
        { 
            args => [ $url, { page => 3, format => 'rss' } ] 
        },
    ] );

    for my $call ( @calls ) {
        print "has error: " . $call->{has_error} . "\n";
        print "request : " . $call->{has_error} . "\n";
        print length( $call->{hash} ) . "\n";
    }
    
}

exit;

for my $call ( @calls ) {
    print length( $call );
    next;
    
    if ( $call->has_error() ) {
        fail( 'api call failed: ' . $call->errors_as_string() );
    }
    else {
        is( ref $call->response_dom(), 'XML::LibXML::Document', 'response dom' );
        is( ref $call->response_hash(), 'HASH', 'response hash' );

        ok( $call->nodeContent('title') eq 'RSS Title', 'nodeContent test' );
        #diag Dumper( $call->response_hash );
    }
}
#$call->execute(
#    #'http://worldofgood.ebay.com/Eco-Organic-Clothes-Shoes-Men-Women-Children/43/list',
#    { format => 'rss' },
#);

#diag($call->request_content);
#diag($call->response_content);


#is( $call->has_error(), 1, 'look for error flag' );
#ok( $call->errors_as_string() ne '', 'check for error message' );
#ok( $call->response_content() ne '', 'check for response content' );

exit;

my $call2 = eBay::API::Simple::RSS->new(
    { request_method => 'POST' }
);

$call2->execute(
    'http://en.wikipedia.org/w/index.php?title=Special:RecentChanges&feed=rss',
    { page => 1 },
);

is( ref $call2->response_dom(), 'XML::LibXML::Document', 'post response dom' );
is( ref $call2->response_hash(), 'HASH', 'post response hash' );
ok( $call2->nodeContent('title') ne '', 'post nodeContent test' );

=cut