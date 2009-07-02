#!/usr/bin/perl -w

use strict;

use Quantum::Superpositions;
use Term::ANSIColor;

my @pegcolors = ( "r", "c", "y", "p", "g", "b" );

my %keycolors = ( nil => "ko",
                  white => "kw",
                  red => "kr" );

my %out = ( "r" => colored("o", 'red bold'),
            "c" => colored("o", 'blue bold'),
            "y" => colored("o", 'yellow bold'),
            "p" => colored("o", 'magenta bold'),
            "g" => colored("o", 'green bold'),
            "b" => colored("o", 'dark blue bold'),
            "ko" => colored(".", 'black'),
            "kw" => colored("o", 'white'),
            "kr" => colored("o", 'red') );

sub shuffle {
  my $a = shift;
  my $i = @$a;
  while (--$i) {
    my $j = int rand ($i + 1);
    @$a[$i, $j] = @$a[$j, $i];
  }
}

sub enumerate {
  my $a = shift;
  foreach my $i (0 .. $#$a) {
    $a->[$i] = [ $i, $a->[$i] ];
  }
}

sub calculate_matches {
  my ( $guess, $target ) = @_;

  my $key = [];
  my $guesscopy = [ @$guess ];

  enumerate $guesscopy;
  for my $p (@$guesscopy) {
    my ($idx, $guess_peg) = @$p;

    if ($guess_peg eq $target->[$idx]) {
      push @$key, $keycolors{red};
    } elsif ($guess_peg eq any(@$target)) {
      push @$key, $keycolors{white};
    } else {
      push @$key, $keycolors{nil};
    }
  }

  shuffle $key;

  return $key;
}

# TEST:
my $guess = [ qw(r c c y) ];
my $target = [ qw(b y c p) ];
my $matches = calculate_matches $guess, $target;

print "Guess:  [ ";
foreach my $p (@$guess) {
  print $out{$p}, " ";
}
print "]\nTarget: [ ";
foreach my $p (@$target) {
  print $out{$p}, " ";
}
print "]\nKey:    [ ";
foreach my $p (@$matches) {
  print $out{$p}, " ";
}
print "]\n";

exit 0;
