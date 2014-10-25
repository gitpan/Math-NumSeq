#!/usr/bin/perl -w

# Copyright 2012, 2013 Kevin Ryde

# This file is part of Math-NumSeq.
#
# Math-NumSeq is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 3, or (at your option) any later
# version.
#
# Math-NumSeq is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with Math-NumSeq.  If not, see <http://www.gnu.org/licenses/>.


# cf A057163 tree reflection
#    A075166 A106456 tree by prime powers
# A070041  df->bf
# A079214 catalan digit changes




use 5.004;
use strict;

use Test;
plan tests => 15;

use lib 't','xt';
use MyTestHelpers;
MyTestHelpers::nowarnings();
use MyOEIS;

use Math::NumSeq::BalancedBinary;

use Math::NumSeq::Repdigits;
*_digit_split_lowtohigh = \&Math::NumSeq::Repdigits::_digit_split_lowtohigh;

use Math::NumSeq::RadixConversion;
*_digit_join_lowtohigh = \&Math::NumSeq::RadixConversion::_digit_join_lowtohigh;

# uncomment this to run the ### lines
#use Smart::Comments '###';


sub diff_nums {
  my ($gotaref, $wantaref) = @_;
  for (my $i = 0; $i < @$gotaref; $i++) {
    if ($i > @$wantaref) {
      return "want ends prematurely pos=$i";
    }
    my $got = $gotaref->[$i];
    my $want = $wantaref->[$i];
    if (! defined $got && ! defined $want) {
      next;
    }
    if (! defined $got || ! defined $want) {
      return "different pos=$i got=".(defined $got ? $got : '[undef]')
        ." want=".(defined $want ? $want : '[undef]');
    }
    $got =~ /^[0-9.-]+$/
      or return "not a number pos=$i got='$got'";
    $want =~ /^[0-9.-]+$/
      or return "not a number pos=$i want='$want'";
    if ($got != $want) {
      return "different pos=$i numbers got=$got want=$want";
    }
  }
  return undef;
}


#------------------------------------------------------------------------------
# A080300 - ranking, value -> i or if no such then 0

MyOEIS::compare_values
  (anum => 'A080300',
   func => sub {
     my ($count) = @_;
    my $seq = Math::NumSeq::BalancedBinary->new;
    my @got;

    for (my $value = 0; @got < $count; $value++) {
      my $i = $seq->value_to_i($value);
      push @got, $i || 0;
    }
     return \@got;
   });

#------------------------------------------------------------------------------
# A057520 - without low 0-bit, including 0

MyOEIS::compare_values
  (anum => 'A057520',
   func => sub {
     my ($count) = @_;
     require Math::BigInt;
     require Math::NumSeq::DigitLength;
     my $dlen = Math::NumSeq::DigitLength->new (radix => 2);
     my $seq = Math::NumSeq::BalancedBinary->new;
     my @got = (0);
     while (@got < $count) {
       my ($i, $value) = $seq->next;
       $value /= 2;                                 # strip low 0-bit
       push @got, $value;
     }
     return \@got;
   });


#------------------------------------------------------------------------------
# A085183,A085184 - without high,low 1,0 bits

MyOEIS::compare_values
  (anum => 'A085183',
   func => sub {
     my ($count) = @_;
     require Math::BigInt;
     require Math::NumSeq::DigitLength;
     my $dlen = Math::NumSeq::DigitLength->new (radix => 2);
     my $seq = Math::NumSeq::BalancedBinary->new;
     my @got;
     while (@got < $count) {
       my ($i, $value) = $seq->next;
       $value /= 2;                                 # strip low 0-bit
       my $pos = $dlen->ith($value);
       $value -= Math::BigInt->new(1) << ($pos-1);  # strip high 1-bit
       push @got, $value;
     }
     return \@got;
   });

# same in base4
MyOEIS::compare_values
  (anum => 'A085184',
   func => sub {
     my ($count) = @_;
     require Math::BigInt;
     require Math::NumSeq::DigitLength;
     my $dlen = Math::NumSeq::DigitLength->new (radix => 2);
     my $seq = Math::NumSeq::BalancedBinary->new;
     my @got;
     while (@got < $count) {
       my ($i, $value) = $seq->next;
       $value /= 2;                                 # strip low 0-bit
       my $pos = $dlen->ith($value);
       $value -= Math::BigInt->new(1) << ($pos-1);  # strip high 1-bit
       push @got, to_base4_str($value);
     }
     return \@got;
   });

#------------------------------------------------------------------------------
# A085185 - in base4, including 0

MyOEIS::compare_values
  (anum => 'A085185',
   func => sub {
     my ($count) = @_;
     my $seq = Math::NumSeq::BalancedBinary->new;
     my @got = (0);
     while (@got < $count) {
       my ($i, $value) = $seq->next;
       push @got, to_base4_str($value);
     }
     return \@got;
   });

sub to_base4_str {
  my ($n) = @_;
  if ($n == 0) { return '0'; }
  my @digits;
  while ($n) {
    push @digits, ($n&3);
    $n >>= 2;
  }
  return join('',reverse @digits);
}



#------------------------------------------------------------------------------
# A057118 - depth-first -> breadth-first index map
#
# cf A038776 -
#    A070041  # df->bf 1-based

MyOEIS::compare_values
  (anum => 'A057117',
   func => sub {
     my ($count) = @_;
     my $seq = Math::NumSeq::BalancedBinary->new;
     my @got = (0);
     while (@got < $count) {
       my ($i, $value) = $seq->next;
       my @bits = bit_split_hightolow($value);
       @bits = bits_breadth_to_depth(@bits);
       my $pvalue = bit_join_hightolow(\@bits);
       ### dtob: @bits
       ### $pvalue
       my $pi = $seq->value_to_i($pvalue);
       if (! defined $pi) {
         ### @bits
         die "Oops, bad pvalue $pvalue: ",join('',@bits);
       }
       push @got, $pi;
     }
     return \@got;
   });

MyOEIS::compare_values
  (anum => 'A057118',
   func => sub {
     my ($count) = @_;
     my $seq = Math::NumSeq::BalancedBinary->new;
     my @got = (0);
     while (@got < $count) {
       my ($i, $value) = $seq->next;
       my @bits = bit_split_hightolow($value);
       @bits = bits_depth_to_breadth(@bits);
       my $pvalue = bit_join_hightolow(\@bits);
       ### dtob: @bits
       ### $pvalue
       my $pi = $seq->value_to_i($pvalue);
       if (! defined $pi) {
         ### @bits
         die "Oops, bad pvalue $pvalue: ",join('',@bits);
       }
       push @got, $pi;
     }
     return \@got;
   });

sub bit_split_hightolow {
  my ($n) = @_;
  return reverse _digit_split_lowtohigh($n,2);
}
sub bit_join_hightolow {
  my ($aref) = @_;
  return _digit_join_lowtohigh([reverse @$aref],2);
}

sub depthfirst_bits_to_tree {
  my @bits = @_;
  ### depthfirst_bits_to_tree(): join('',@bits)
  push @bits, 0;
  my $take;
  $take = sub {
    my $bit = shift @bits;
    if ($bit) {
      my $left = &$take();
      my $right = &$take();
      return [$left,$right];
    } else {
      return 0;
    }
  };
  my $tree = &$take();
  if (@bits) {
    die "Oops, bits left over: ",@bits;
  }
  return $tree;
}
sub depthfirst_tree_to_bits {
  my ($tree) = @_;
  ### depthfirst_bits_to_tree(): $tree
  my $emit;
  $emit = sub {
    my ($part) = @_;
    ### $part
    if ($part) {
      return 1,$emit->($part->[0]),$emit->($part->[1]);
    } else {
      return 0;
    }
  };
  my @ret = $emit->($tree);
  ### @ret;
  pop @ret;
  return @ret;
}
{
  my $seq = Math::NumSeq::BalancedBinary->new;
  foreach (1 .. 100) {
    my ($i, $value) = $seq->next;
    my @bits = bit_split_hightolow($value);
    my $tree = depthfirst_bits_to_tree(@bits);
    ### $tree
    my @rev = depthfirst_tree_to_bits($tree);
    my $bits = join('',@bits);
    my $rev = join('',@rev);
    $bits eq $rev or die "oops $bits\nrev $rev";
  }
}

sub breadthfirst_bits_to_tree {
  my @bits = @_;
  ### breadthfirst_bits_to_tree(): join('',@bits)
  my $tree = 0;
  my @pending = (\$tree);
  while (@pending) {
    my $ref = shift @pending;
    if (shift @bits) {
      my @part = (0,0);
      $$ref = \@part;
      push @pending, \$part[0], \$part[1];
    } else {
      $$ref = 0;
    }
  }
  if (@pending) {
    die "Oops, more pending";
  }
  return $tree;
}
sub breadthfirst_tree_to_bits {
  my ($tree) = @_;
  ### breadthfirst_tree_to_bits(): $tree
  my @pending = ($tree);
  my @ret;
  while (@pending) {
    my $part = shift @pending;
    if ($part) {
      push @ret, 1;
      push @pending, $part->[0], $part->[1];
    } else {
      push @ret, 0;
    }
  };
  if (@pending) {
    die "Oops, more pending";
  }
  pop @ret;
  ### @ret
  return @ret;
}
{
  my $seq = Math::NumSeq::BalancedBinary->new;
  foreach (1 .. 100) {
    my ($i, $value) = $seq->next;
    my @bits = bit_split_hightolow($value);
    my $tree = breadthfirst_bits_to_tree(@bits);
    my @rev = breadthfirst_tree_to_bits($tree);
    my $bits = join('',@bits);
    my $rev = join('',@rev);
    $bits eq $rev or die "$bits\n$rev";
  }
}

sub bits_depth_to_breadth {
  my @bits = @_;
  return breadthfirst_tree_to_bits(depthfirst_bits_to_tree(@bits));
}
sub bits_breadth_to_depth {
  my @bits = @_;
  return depthfirst_tree_to_bits(breadthfirst_bits_to_tree(@bits));
}

#------------------------------------------------------------------------------
# A071162 - decimal of trees with at most one child per node,
#           so path left or right but not branching

# cf A209642 left-only trees, not in ascending order

{
  my $anum = 'A071162';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum,
                                                      max_count => 1024);
  my $diff;
  if ($bvalues) {
    my $seq = Math::NumSeq::BalancedBinary->new;
    my @got = (0);
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      my @bits = bit_split_hightolow($value);
      my $tree = depthfirst_bits_to_tree(@bits);
      ### $value
      ### $tree
      if (bits_is_oneonly(@bits)) {
        push @got, $value;
      }
    }
    $diff = diff_nums(\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..10]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..10]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum");
}

sub bits_is_oneonly {
  my @bits = @_;
  ### bits_is_oneonly(): join('',@bits)
  push @bits, 0;
  my $good = 1;
  my $take;
  $take = sub {
    if (! @bits) {
      die "Oops, end of bits";
    }
    my $bit = shift @bits;
    ### $bit
    if ($bit) {
      my $left = &$take();
      my $right = &$take();
      ### $left
      ### $right
      if ($left == 1 && $right == 1) {
        $good = 0;
      }
      return 1;
    } else {
      return 0;
    }
  };
  &$take();
  if (@bits) {
    die "Oops, too many bits";
  }
  ### $good
  return $good;
}

#------------------------------------------------------------------------------
# A071152 - Lukasiewicz, binary with 0,2, including value=0

{
  my $anum = 'A071152';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if ($bvalues) {
    my $seq = Math::NumSeq::BalancedBinary->new;
    my @got = ('0');
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      my $str = to_binary_str($value);
      $str =~ tr/1/2/;
      push @got, $str;
    }
    $diff = diff_nums(\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum");
}

#------------------------------------------------------------------------------
# A072643 balanced binary width, including value=0

{
  my $anum = 'A072643';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if ($bvalues) {
    require Math::NumSeq::DigitLength;
    my $dlen = Math::NumSeq::DigitLength->new (radix => 2);
    my $seq = Math::NumSeq::BalancedBinary->new;
    my @got = (0);
    for (my $value = 0; @got < @$bvalues; $value++) {
      my ($i,$value) = $seq->next;
      push @got, $dlen->ith($value)/2;
    }
    $diff = diff_nums(\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum");
}


#------------------------------------------------------------------------------
# A071671 - permuted by A071651/A071652
#
# {
#   my $anum = 'A071671';
#   my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
#   my $diff;
#   if ($bvalues) {
#     my $seq = Math::NumSeq::BalancedBinary->new;
#     my @got;
#     for (my $value = 0; @got < @$bvalues; $value++) {
#       my $i = $seq->value_to_i($value);
#       push @got, $i || 0;
#     }
#     $diff = diff_nums(\@got, $bvalues);
#     if ($diff) {
#       MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
#       MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
#     }
#   }
#   skip (! $bvalues,
#         $diff, undef,
#         "$anum");
# }

#------------------------------------------------------------------------------
# A085192 first diffs

{
  my $anum = 'A085192';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if ($bvalues) {
    my $seq = Math::NumSeq::BalancedBinary->new;
    my $prev = 0;
    my @got;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      push @got, $value - $prev;
      $prev = $value;
    }
    $diff = diff_nums(\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum");
}

#------------------------------------------------------------------------------
# A085223 - positions of single trailing zero

{
  my $anum = 'A085223';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if ($bvalues) {
    my $seq = Math::NumSeq::BalancedBinary->new;
    my @got;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      if (($value % 4) == 2) {
        push @got, $i;
      }
    }
    $diff = diff_nums(\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum");
}

#------------------------------------------------------------------------------
# A080237 - num trailing zeros

{
  my $anum = 'A080237';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if ($bvalues) {
    require Math::NumSeq::DigitCountLow;
    my $seq = Math::NumSeq::BalancedBinary->new;
    my $low = Math::NumSeq::DigitCountLow->new (radix => 2, digit => 0);
    my @got;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      push @got, $low->ith($value);
    }
    $diff = diff_nums(\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum");
}

#------------------------------------------------------------------------------
# A080116 predicate 0,1

{
  my $anum = 'A080116';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if ($bvalues) {
    my $seq = Math::NumSeq::BalancedBinary->new;
    my @got = (1);
    for (my $value = 1; @got < @$bvalues; $value++) {
      push @got, ($seq->pred($value) ? 1 : 0);
    }
    $diff = diff_nums(\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum");
}


#------------------------------------------------------------------------------
# A063171 - in binary

{
  my $anum = 'A063171';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if ($bvalues) {
    my $seq = Math::NumSeq::BalancedBinary->new;
    my @got;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      push @got, to_binary_str($value);
    }
    $diff = diff_nums(\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum");
}

sub to_binary_str {
  my ($n) = @_;
  if (ref $n) {
    my $str = $n->as_bin;
    $str =~ s/^0b//;
    return $str;
  }
  if ($n == 0) { return '0'; }
  my @bits;
  while ($n) {
    push @bits, $n%2;
    $n = int($n/2);
  }
  return join('',reverse @bits);
}


#------------------------------------------------------------------------------
exit 0;
