use strict;
use warnings;
use Test::More tests => 6;

BEGIN { use_ok('Search::QueryParser') };

my $qp = new Search::QueryParser;
isa_ok($qp, 'Search::QueryParser');

my $s = '+mandatoryWord -excludedWord +field:word "exact phrase"';

my $q = $qp->parse($s);
isa_ok($q, 'HASH');

is($qp->unparse($q), 
   '+:"mandatoryWord" +field:"word" :"exact phrase" -:"excludedWord"');

# query with comparison operators and implicit plus (second arg is true)
$q = $qp->parse("txt~'^foo.*' date>='01.01.2001' date<='02.02.2002'", 1);
is($qp->unparse($q), 
   '+txt~"^foo.*" +date>="01.01.2001" +date<="02.02.2002"');

# boolean operators (example below is equivalent to "+a +(b c) -d")
$q = $qp->parse("a AND (b OR c) AND NOT d");
is($qp->unparse($q), 
   '+:"a" +(:"b" :"c") -:"d"');

