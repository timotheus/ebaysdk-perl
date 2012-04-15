
use strict; 
no warnings;

use Test::More;
use Data::Dumper;
use lib qw/lib/;
#use LWP::Debug qw(+);

BEGIN {
    my @skip_msg;

    eval {
        use eBay::API::Simple::RSS;
        use eBay::API::Simple::Parallel;
    };
    
    if ( $@ ) {
        push @skip_msg, 'missing module eBay::API::Simple::Parallel, skipping test';
    }
    if ( scalar( @skip_msg ) ) {
        plan skip_all => join( ' ', @skip_msg );
    }
    else {
        plan qw(no_plan);
    }    
}

my $pua = eBay::API::Simple::Parallel->new();
my @calls;

for ( my $i=0; $i < 20; ++$i ) {
    my $call = eBay::API::Simple::RSS->new( {
        parallel => $pua,
    } );


    $call->execute(
        'http://worldofgood.ebay.com/Clothes-Shoes-Men/43/list?format=rss',
    );

    push( @calls, $call );
}

$pua->wait();

ok( ! $pua->has_error(), 'error free' );

for ( my $i=0; $i < 20; ++$i ) {
    ok( length( $calls[$i]->request_content() ) > 30, 'request length' );
    #diag( $calls[$i]->request_content() );
    ok( length( $calls[$i]->response_content() ) > 200, 'response length' );
}

