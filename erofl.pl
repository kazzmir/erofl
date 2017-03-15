#!/usr/bin/env perl

use strict;

## Version1:
## Lost due to negligence

## Version2:
## The parser is called on a string with tokens. Each token returns its normalized form by calling
## the parser on some string or returning a terminal

## Version3:
## The parser is called on a start symbol. Each token returns a new string consisting of more tokens
## or terminals which the parser will call itself on, thus modularizing tokens from the parser
## Also tokens are split into an array with the split() function

## Version4:
## <token>? is shorthand for &oneOf( [ "<token>", "" ] ). The number of ? gives the number of empty strings
## in the anonymous array

## Version5:
## No longer need action routines for tokens. All thats left is the CFG and the parser.

my %funcs2 = (
  "<adjective>"      => [ "<e-3> <real_adjective>" ],
  "<adjective-rest>" => [ "<space> <adjective> <adjective-rest>", "<epsilon>" ],
  "<adjective-many>" => [ "<adjective> <adjective-rest>" ],
  "<article>"        => [ "The", "A" ],
  "<describe>"       => [ "that", "which" ],
  "<e-3>"            => [ "<e>", "<epsilon>", "<epsilon>", "<epsilon>" ],
  "<e>"              => [ "e-" ],
  "<epsilon>"        => [ "" ],
  "<noun>"           => [ "infrastructure", "architecture", "initiative", "Mommy", "DOG", "server", "application", "framework", "platform", "attestation", "workflow", "flow", "transaction", "agency", "paradigm" ],
  "<need>"           => [ "needs", "wants", "deserves" ],
  "<business>"       => [ "Your <space> business <space> <need> <space> a", "We <space> <provide> <space> you <space> a" ],
  "<object>"         => [ "<adjective-many> <space> <e-3> <noun>" ],
  "<real_adjective>" => [ "business", "functional", "perspective", "Global", "corporate", "ROFL", "info shared", "synergistic", "B2B", "business-enabled", "web-enabled", "websphere-enabled", "J2EE", "modular", "contactable", "LOL", "re-architecture", "deliverable", "flexible", "dynamic", "end <space> to <space> end" ],
  "<space>"          => [ "" ],
  "<provide>"        => [ "offer", "provide", "give" ],
  "<sentence-1>"     => [ "<business> <space> <subject> <space> <describe> <space> <verb> <space> <object> s ." ],
  "<product>"        => [ "product", "asset" ],
  "<sentence-2>"     => [ "Our <space> <product> <space> <verb> <space> you <space> to <space> <past-verb> <space> your <space> <object> ." ],
  "<join-us>"        => [ "Join <space> us", "Contact <space> us" ],
  "<sentence-3>"     => [ "<join-us> <space> in <space> the <space> 21st <space> century <space> where <space> <adjective> <space> <object> s <space> are <space> <verbing> ." ],
  "<start>"          => [ "<sentence-1> <space> <sentence-2> <space> <sentence-3>" ],
  "<subject>"        => [ "<object>" ],
  "<verb>"           => [ "adds <space> value <space> to", "synergizes", "complies <space> with", "performs <space> vital <space> functions <space> on", "allows <space> for", "integrates <space> with", "provides" ],
  "<past-verb>"      => [ "add <space> value <space> to", "synergize", "comply <space> with", "perform <space> vital <space> functions <space> on", "allow <space> for", "integrate <space> with", "provide" ],
  "<exciting>"       => [ "<wow> <space> <real_adjective> <space> <heights>" ],
  "<wow>"            => [ "new", "amazing", "bleeding-edge", "awesome", "super" ],
  "<heights>"        => [ "heights", "places" ],
  "<verbing>"        => [ "taking <space> <object> s <space> to <space> <exciting>" ],
  "<dream>"          => [ "Our <space> dream <space> is", "We <space> hope" ],
  "<vision>"         => [ "<vision-1> <space> <vision-2>" ],
  "<vision-1>"       => [ "<dream> <space> to <space> provide <space> <adjective> <space> <object> s <space> to <space> our <space> customers ." ],
  "<vision-2>"       => [ "Every <space> <object> <space> we <space> provide <space> gives <space> us <space> a <space> <better-understanding> <space> of <space> <object> s ." ],
  "<better-understanding>" => [ "<more> <space> understanding" ],
  "<more>"           => [ "more <space> robust", "better" ],

);

my $start_symbol = "<start>";
if ( $#ARGV != -1 ){
	$start_symbol = $ARGV[ 0 ];
}
## Parse the start token
my $result = &parse3( $start_symbol );
$result =~ s// /g;
print "$result\n";

sub parse3( $ ){
        my $string = shift;

        ## Either a non-terminal or its not!
        if ( defined( $funcs2{ $string } ) ){
                my $strs = $funcs2{ $string };
                my $pick = int( rand( $#$strs + 1 ) );
                my $str = $strs->[ $pick ];

                my @things = split( ' ', $str );
                my $whole = "";
                foreach ( @things ){
                        $whole = $whole . &parse3( $_ );
                }
                return $whole;
        }
        return $string;

}
