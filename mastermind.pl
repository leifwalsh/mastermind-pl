#!/usr/bin/perl -w

use strict;

use Quantum::Superpositions;
use Term::ANSIColor;

my( %pegcolors, $npegcolors, %keycolors, %out );

%pegcolors = ( "r" => 1,
               "c" => 1,
               "y" => 1,
               "p" => 1,
               "g" => 1,
               "b" => 1 );

$npegcolors = (keys %pegcolors) + 1;

%keycolors = ( nil => "kz",
               white => "kw",
               red => "kr" );

%out = ( "r" => colored("o", 'red bold'),
         "c" => colored("o", 'cyan bold'),
         "y" => colored("o", 'yellow bold'),
         "p" => colored("o", 'magenta bold'),
         "g" => colored("o", 'green bold'),
         "b" => colored("o", 'dark blue bold'),
         "kz" => colored(".", 'black'),
         "kw" => colored("o", 'white'),
         "kr" => colored("o", 'red') );

sub calculate_key {
    my( $guess, $target, $key, $used );

    ( $guess, $target ) = @_;

    $key = [ $keycolors{nil},
             $keycolors{nil},
             $keycolors{nil},
             $keycolors{nil} ];
    $used = [ 0, 0, 0, 0 ];

    FIND_RED: foreach my $i (0 .. $#$guess) {
        my $guess_peg = $guess->[$i];

        if ($guess_peg eq $target->[$i]) {
            $key->[$i] = $keycolors{red};
            $used->[$i] = 1;
        }
    }

    FIND_WHITE: foreach my $i (0 .. $#$guess) {
        my $guess_peg = $guess->[$i];

        next FIND_WHITE if ($key->[$i] ne $keycolors{nil});

        SEARCH: foreach my $j (0 .. $#$target) {
            my $target_peg = $target->[$j];

            if (!$used->[$j] and ($guess_peg eq $target_peg)) {
                $key->[$i] = $keycolors{white};
                $used->[$j] = 1;
                last SEARCH;
            }
        }
    }

    return $key;
}

sub get_input {
    my( $line, $guess, $errchar, $err );

    print "Enter your guess [", join(" ", sort(keys %pegcolors)), "]: ";

    INPUT: while (<>) {
        chomp;
        $guess = [ split /\ / ];

        $err = "";
        if ($#$guess != 3) {
            $err = " (must input exactly 4 pegs)";
            next INPUT;
        }

        VERIFY_PEGS: foreach my $p (@$guess) {
            if (!$pegcolors{$p}) {
                $err = " (invalid char '$p')";
                next INPUT;
            }
        }

        last INPUT;
    } continue {
        print "Try again$err: ";
    }

    return $guess;
}

sub randompeg {
    return (sort keys %pegcolors)[int rand ($npegcolors)];
}

# main:
my( $round, $guess, $target, $key );

$target = [ randompeg(), randompeg(), randompeg(), randompeg() ];

PLAY_ROUND: for ($round = 1; $round <= 6; ++$round) {
    $guess = get_input;
    print "[", join(" ", map { $out{$_} } @$guess ), "]";

    $key = calculate_key($guess, $target);
    if ($keycolors{red} eq all(@$key)) {
        print "\nYou win!\n";
        last PLAY_ROUND;
    }
    print " [", join(" ", map { $out{$_} } sort(@$key) ), "]\n";
}
if ($round > 6) {
    print "You lose!\n";
    print "Target: [", join(" ", map { $out{$_} } @$target ), "]\n";
}

exit 0;
