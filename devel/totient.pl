#!/usr/bin/perl -w

# Copyright 2011, 2012 Kevin Ryde

# This file is part of Math-NumSeq.
#
# Math-NumSeq is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 3, or (at your option) any later
# version.
#
# Math-NumSeq is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with Math-NumSeq.  If not, see <http://www.gnu.org/licenses/>.

require 5;
use strict;
use Math::Prime::XS 0.23 'is_prime'; # version 0.23 fix for 1928099
use Math::Factor::XS 0.39 'prime_factors'; # version 0.39 for prime_factors()

# uncomment this to run the ### lines
#use Smart::Comments;

{
  # non-totients

  require Math::NumSeq::Totient;
  my @is_totient;
  my @totient_from;
  my $seq = Math::NumSeq::Totient->new;
  my $hi = 5000;
  for (1 .. 3*$hi) {
    my ($i,$value) = $seq->next;
    $totient_from[$value] .= ",$i";
    $is_totient[$value]++;
  }

  foreach my $i (0 .. 100) {
    if ($is_totient[$i]) {
      print "$i,";
    }
  }
  print "\n";

  foreach my $i (0 .. $hi) {
    #foreach my $i (54 .. 54) {
    my $got = is_totient($i);
    my $want = $is_totient[$i] || 0;
    if ((!!$got) != (!!$want)) {
      # if ($got != $want) {
      print "$i got=$got want=$want from=$totient_from[$i]\n";
    }
  }

  sub is_totient {
    my ($n) = @_;
    ### is_totient: $n

    if ($n <= 1) {
      return ($n == 1); # $n==0 no, $n==1 yes
    }
    if ($n & 1) {
      return 0;
    }

    return _is_totient_from_array ([prime_factors($n)], $n+1);
  }

  sub _is_totient_from_array {
    my ($primes, $prev_product) = @_;
    ### try ...
    ### assert: @$primes > 0
    ### assert: $primes->[0] == 2

    my $bits_max = 1 << scalar(@$primes);
  BITS: for (my $bits = 1 << $#$primes;  # always the 2 in $primes->[0]
             $bits < $bits_max;
             $bits += 1) {
      ### $bits
      ### $primes
      ### $prev_product

      my @other;
      my $product = 1;
      for (my $i = 0, my $mask = 1 << $#$primes;
           $mask;
           $mask >>= 1, $i++) {
        if ($bits & $mask) {
          $product *= $primes->[$i];

          if ($product >= $prev_product) {
            ### at or past prev_product, skip ahead ...
            $bits |= $mask-1;
            next BITS;
          }

        } else {
          push @other, $primes->[$i];
        }
      }
      ### $product
      ### @other

      my $p = $product+1;
      ### $p

      my $pcount = 0;
      my $ppos = 0;
      for (my $i = 0; $i < @other; $i++) {
        if ($other[$i] == $p) {
          $ppos = $i;
          do {
            $pcount++;
          } while (++$i < @other && $other[$i] == $p);
          splice @other, $ppos, $pcount;  # delete
          last;
        }
      }
      ### $pcount

      if (scalar(@other) && $other[0] != 2) {
        ### no twos left in other ...
        next;
      }

      unless (is_prime($p)) {
        ### p not prime, next twos ...
        next;
      }

      if (! @other) {
        ### no other primes, so yes ...
        return 1;
      }

      foreach (0 .. $pcount) {
        ### recurse ...
        if (_is_totient_from_array (\@other, $product)) {
          return 1;
        }
        splice @other, $ppos, 0, $p; # insert
      }
    }
    return 0;
  }


  # sub is_totient {
  #   my ($n) = @_;
  #   ### is_totient: $n
  #
  #   if ($n <= 1) {
  #     return ($n == 1); # $n==0 no, $n==1 yes
  #   }
  #   if ($n & 1) {
  #     return 0;
  #   }
  #
  #   my $prev_product = $n + 1;
  #   my $twos = 0;
  #   do {
  #     $twos++;
  #   } until (($n >>= 1) & 1);
  #   ### $twos
  #
  #   my @primes = prime_factors($n);
  #   if (@primes) {
  #     return _is_totient_from_array ($twos, \@primes, $prev_product);
  #   } else {
  #     # n=2**k is totient(2**(k+1))
  #     return 1;
  #   }
  # }
  #
  # sub _is_totient_from_array {
  #   my ($twos, $primes, $prev_product) = @_;
  #   ### try ...
  #
  #   my $bits_max = 1 << scalar(@$primes);
  #   $twos--;
  # BITS: for (my $bits = 0; #  : $bits_max-1);
  #            $bits < $bits_max;
  #            $bits++) {
  #     ### $bits
  #     ### $primes
  #     ### remaining twos: $twos
  #     ### $prev_product
  #
  #     my @other;
  #     my $product = 1;
  #     foreach my $i (0 .. $#$primes) {
  #       if ($bits & (1 << $i)) {
  #         $product *= $primes->[$i];
  #       } else {
  #         push @other, $primes->[$i];
  #       }
  #     }
  #     ### base primes product: $product
  #     ### @other
  #
  #     for (my $remaining_twos = $twos;
  #          $remaining_twos >= 0;
  #          $remaining_twos--) {
  #       $product *= 2;
  #
  #       ### $product
  #       ### $remaining_twos
  #
  #       if ($product > $prev_product) {
  #         ### past prev_product ...
  #         next BITS;
  #       }
  #
  #       my $p = $product+1;
  #       ### $p
  #       unless (is_prime($p)) {
  #         ### p not prime, next twos ...
  #         next;
  #       }
  #
  #       my $pcount = 0;
  #       @other = grep {$_ == $p ? ($pcount++, 0) : 1} @other;
  #       ### $pcount
  #
  #       if (! @other) {
  #         ### no other primes, so yes ...
  #         return 1;
  #       }
  #
  #       if ($remaining_twos) {
  #         foreach my $i (0 .. $pcount) {
  #           ### recurse ...
  #           if (_is_totient_from_array ($remaining_twos, \@other, $product)) {
  #             return 1;
  #           }
  #           push @other, $p;
  #         }
  #       } else {
  #         ### no remaining twos to recurse
  #       }
  #     }
  #   }
  #   return 0;
  # }

  exit 0;
}


{
  require Math::NumSeq::TotientStepsSum;
  my $seq = Math::NumSeq::TotientStepsSum->new;
  my $value_prev = 0;
  my $decr = 0;
  for (1 .. 500) {
    my ($i,$value) = $seq->next;
    if ($value < $value_prev) {
      $decr++;
    } else {
      if ($decr) {
        print "$i decr $decr\n";
      }
      $decr = 0;
    }
    $value_prev = $value;
  }
  exit 0;
}
