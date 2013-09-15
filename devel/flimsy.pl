#!/usr/bin/perl -w

# Copyright 2013 Kevin Ryde

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

# A005360 flimsy numbers, n*k has fewer 1-bits than n for some k
# A125121 sturdy, not flimsy
# A143069 the smallest k giving the fewest 1-bits in n*k
# A143073 the smallest k giving fewer 1-bits
# A086342 smallest 1s-count in any n*k
# 
# A003147 primes fib prim root
# A095810 2^k mod 10^j
# A100661 count how many 2^k-1 terms add up to n cf A080468 A080578


# n=37    100101
# k=7085  1101110101101
# n*k     1000000000000000001

use 5.010;
use strict;
use List::Util 'min','max';
use Math::BigInt try => 'GMP';

use Math::NumSeq;
*_is_infinite = \&Math::NumSeq::_is_infinite;

use Math::NumSeq::NumAronson;
*_round_down_pow = \&Math::NumSeq::NumAronson::_round_down_pow;

# uncomment this to run the ### lines
use Smart::Comments;




sub bit_length {
  my ($n) = @_;
  my ($pow,$exp) = _round_down_pow($n, 2);
  return $exp+1;
}
bit_length(3) == 2 or die;
bit_length(4) == 3 or die;
bit_length(7) == 3 or die;
bit_length(8) == 4 or die;

sub bigint_count_1bits {
  my ($n) = @_;
  return scalar($n->as_bin() =~ tr/1/1/);
}
bigint_count_1bits(Math::BigInt->new(0b1011)) == 3 or die;
my @mask;
my @newbit;
my $peak_pos = 0;

sub is_flimsy {
  my ($n) = @_;
  $peak_pos = 0;
  
  if ($n <= 3) {
    return 0;
  }
  while ($n % 2 == 0) {
    $n /= 2;
  }
  if ($n <= 3) {
    return 0;
  }

  $n = Math::BigInt->new($n);
  my $n_count = bigint_count_1bits($n);
  if ($n_count <= 1) {
    ### no, single 1 bit ...
    return 0;
  }
  ### n binary: $n->as_bin." n_count=$n_count"

  my $pos = 0;
  my $prod = $n;  # k=1 so prod=1*n
  my $limit = bit_length($prod) + 2;

  my @pos;
  my @prod;
  my @limit;

  for (;;) {
    $pos++;
    ### at: "prod=".$prod->as_bin." k=".($prod/$n)->as_bin." pos=$pos limit=$limit   pending=".scalar(@pos)
    if ($pos > $limit) {
      $peak_pos = max($peak_pos,$pos);
      if (@pos) {
        ### backtrack ...
        $pos = pop @pos;
        $prod = pop @prod;
        $limit = pop @limit;
        next;
      } else {
        ### no more backtracking ...
        return 0;
      }
    }

    # n*(k+2^pos) = n*k + n*2^pos
    my $new_prod = $prod + ($n << $pos);

    if (bigint_count_1bits($new_prod) < $n_count) {
      ### yes ...
      return 1;
    }

    my $mask = ($mask[$pos] ||= (Math::BigInt->new(1) << ($pos+1)) - 1);
    my $plow = $new_prod & $mask;

    ### prod: $new_prod->as_bin
    ### mask: $mask[$pos]->as_bin
    ### prod low: $plow->as_bin

    if (bigint_count_1bits($plow) < $n_count) {
      ### low bits good, push ...
      push @prod, $new_prod;
      push @pos, $pos;
      push @limit, bit_length($new_prod) + 3;
    }
  }
}

BEGIN {
  my @want;
  require Math::NumSeq::OEIS;
  my $seq = Math::NumSeq::OEIS->new(anum=>'A005360');
  while (my ($i,$value) = $seq->next) {
    $want[$value] = 1;
  }
  sub want_is_flimsy {
    my ($n) = @_;
    return ($n >= 0 && $want[$n] ? 1 : 0);
  }
}

{
  foreach my $n (3 .. 121) {
    my $got = is_flimsy($n);
    my $want = want_is_flimsy($n);
    my $diff = ($got == $want ? '' : ' ********');
    print "$n got=$got want=$want$diff   peakpos=$peak_pos\n";
  }
  exit 0;
}
