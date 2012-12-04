#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'CTT' ) || print "Bail out!\n";
}

diag( "Testing CTT $CTT::VERSION, Perl $], $^X" );
