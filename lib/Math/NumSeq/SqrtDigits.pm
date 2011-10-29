# Copyright 2010, 2011 Kevin Ryde

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

package Math::NumSeq::SqrtDigits;
use 5.004;
use strict;
use Carp;
use Math::NumSeq;

use vars '$VERSION','@ISA';
$VERSION = 14;

use Math::NumSeq::Base::Digits;
@ISA = ('Math::NumSeq::Base::Digits');

# uncomment this to run the ### lines
#use Devel::Comments;

# use constant name => Math::NumSeq::__('Square Root Digits');
use constant description => Math::NumSeq::__('The square root of a given number written out in decimal or a given radix.');
use constant i_start => 1;
use constant parameter_info_array =>
  [
   {
    name    => 'sqrt',
    display => Math::NumSeq::__('Sqrt'),
    type    => 'integer',
    default => 2,
    width   => 5,
    description => Math::NumSeq::__('The number to take the square root of.  If this is a perfect square then there\'s just a handful of digits, non squares go on infinitely.'),
   },
   Math::NumSeq::Base::Digits->parameter_info_list,
  ];

#------------------------------------------------------------------------------
# cf
#   A020807 - sqrt(1/50) decimal
#   A020811 - sqrt(1/54) decimal
#   A010503 - sqrt(1/2) decimal == sqrt(2)/2
#   A155781 - log15(22) decimal
#   A011368 - 16^(1/9) decimal
#   A010121 - continued fraction sqrt(7)
#   A010122 - continued fraction sqrt(13)
#   A010123 - continued fraction sqrt(14)
#   A010124 - continued fraction sqrt(19)
#   A010125 - continued fraction sqrt(21)
#
#   A092855 - the bit positions of sqrt(2)-1 in binary
#
my @oeis_anum;

# base 2 binary
$oeis_anum[2]->[2] = 'A004539';   # base 2, sqrt2
# OEIS-Catalogue: A004539 sqrt=2 radix=2

# base 3 ternary
$oeis_anum[3]->[2] = 'A004540';   # base 3, sqrt2
# OEIS-Catalogue: A004540 sqrt=2 radix=3

# base 4
$oeis_anum[4]->[2] = 'A004541';   # base 4, sqrt2
# OEIS-Catalogue: A004541 sqrt=2 radix=4

# base 5
$oeis_anum[5]->[2] = 'A004542';   # base 5, sqrt2
# OEIS-Catalogue: A004542 sqrt=2 radix=5

# base 10 decimal
$oeis_anum[10]
  = [ undef,       # 0
      undef,       # 1
      'A002193',   # sqrt2
      # OEIS-Catalogue: A002193 sqrt=2

      'A002194',   # sqrt3
      # OEIS-Catalogue: A002194 sqrt=3

      undef,       # 4

      'A002163',   # sqrt5
      # OEIS-Catalogue: A002163 sqrt=5
    ];
my %perfect_square = (16 => 1,
                      25 => 1,
                      36 => 1,
                      49 => 1,
                      64 => 1,
                      81 => 1);
sub oeis_anum {
  my ($self) = @_;
  ### oeis_anum() ...
  my $sqrt = $self->{'sqrt'};
  my $radix = $self->{'radix'};
  if ($radix == 10
      && $sqrt >= 10 && $sqrt <= 99
      && ! $perfect_square{$sqrt}) {
    ### calculated ...
    my $offset = 0;
    foreach my $i (11 .. $sqrt) {
      $offset += ! $perfect_square{$i};
    }
    return 'A0'.(10467+$offset);
  }
  return $oeis_anum[$radix]->[$sqrt];
}
# these in sequence, but skipping perfect squares 16,25,36,49,64,81
# OEIS-Catalogue: A010467 sqrt=10
# OEIS-Catalogue: A010468 sqrt=11
# OEIS-Catalogue: A010469 sqrt=12
# OEIS-Catalogue: A010470 sqrt=13
# OEIS-Catalogue: A010471 sqrt=14
# OEIS-Catalogue: A010472 sqrt=15
# not 16
# OEIS-Catalogue: A010473 sqrt=17
# OEIS-Catalogue: A010474 sqrt=18
# OEIS-Catalogue: A010475 sqrt=19
# OEIS-Catalogue: A010476 sqrt=20
# OEIS-Catalogue: A010477 sqrt=21
# OEIS-Catalogue: A010478 sqrt=22
# OEIS-Catalogue: A010479 sqrt=23
# OEIS-Catalogue: A010480 sqrt=24
# not 25
# OEIS-Catalogue: A010481 sqrt=26
# OEIS-Catalogue: A010482 sqrt=27
# OEIS-Catalogue: A010483 sqrt=28
# OEIS-Catalogue: A010484 sqrt=29
# OEIS-Catalogue: A010485 sqrt=30
# OEIS-Catalogue: A010486 sqrt=31
# OEIS-Catalogue: A010487 sqrt=32
# OEIS-Catalogue: A010488 sqrt=33
# OEIS-Catalogue: A010489 sqrt=34
# OEIS-Catalogue: A010490 sqrt=35
# not 36
# OEIS-Catalogue: A010491 sqrt=37
# OEIS-Catalogue: A010492 sqrt=38
# OEIS-Catalogue: A010493 sqrt=39
# OEIS-Catalogue: A010494 sqrt=40
# OEIS-Catalogue: A010495 sqrt=41
# OEIS-Catalogue: A010496 sqrt=42
# OEIS-Catalogue: A010497 sqrt=43
# OEIS-Catalogue: A010498 sqrt=44
# OEIS-Catalogue: A010499 sqrt=45
# OEIS-Catalogue: A010500 sqrt=46
# OEIS-Catalogue: A010501 sqrt=47
# OEIS-Catalogue: A010502 sqrt=48
# OEIS-Catalogue: A010503 sqrt=50
# OEIS-Catalogue: A010504 sqrt=51
# OEIS-Catalogue: A010505 sqrt=52
# OEIS-Catalogue: A010506 sqrt=53
# OEIS-Catalogue: A010507 sqrt=54
# OEIS-Catalogue: A010508 sqrt=55
# OEIS-Catalogue: A010509 sqrt=56
# OEIS-Catalogue: A010510 sqrt=57
# OEIS-Catalogue: A010511 sqrt=58
# OEIS-Catalogue: A010512 sqrt=59
# OEIS-Catalogue: A010513 sqrt=60
# OEIS-Catalogue: A010514 sqrt=61
# OEIS-Catalogue: A010515 sqrt=62
# OEIS-Catalogue: A010516 sqrt=63
# not 64
# OEIS-Catalogue: A010517 sqrt=65
# OEIS-Catalogue: A010518 sqrt=66
# OEIS-Catalogue: A010519 sqrt=67
# OEIS-Catalogue: A010520 sqrt=68
# OEIS-Catalogue: A010521 sqrt=69
# OEIS-Catalogue: A010522 sqrt=70
# OEIS-Catalogue: A010523 sqrt=71
# OEIS-Catalogue: A010524 sqrt=72
# OEIS-Catalogue: A010525 sqrt=73
# OEIS-Catalogue: A010526 sqrt=74
# OEIS-Catalogue: A010527 sqrt=75
# OEIS-Catalogue: A010528 sqrt=76
# OEIS-Catalogue: A010529 sqrt=77
# OEIS-Catalogue: A010530 sqrt=78
# OEIS-Catalogue: A010531 sqrt=79
# OEIS-Catalogue: A010532 sqrt=80
# not 81
# OEIS-Catalogue: A010533 sqrt=82
# OEIS-Catalogue: A010534 sqrt=83
# OEIS-Catalogue: A010535 sqrt=84
# OEIS-Catalogue: A010536 sqrt=85
# OEIS-Catalogue: A010537 sqrt=86
# OEIS-Catalogue: A010538 sqrt=87
# OEIS-Catalogue: A010539 sqrt=88
# OEIS-Catalogue: A010540 sqrt=89
# OEIS-Catalogue: A010541 sqrt=90
# OEIS-Catalogue: A010542 sqrt=91
# OEIS-Catalogue: A010543 sqrt=92
# OEIS-Catalogue: A010544 sqrt=93
# OEIS-Catalogue: A010545 sqrt=94
# OEIS-Catalogue: A010546 sqrt=95
# OEIS-Catalogue: A010547 sqrt=96
# OEIS-Catalogue: A010548 sqrt=97
# OEIS-Catalogue: A010549 sqrt=98
# OEIS-Catalogue: A010550 sqrt=99


#------------------------------------------------------------------------------

my %radix_to_stringize = (2  => 'as_bin',
                          8  => 'as_oct',
                          10 => 'bstr');

sub rewind {
  my ($self) = @_;
  $self->{'i_extended'} = $self->{'i'} = $self->i_start;
}

sub _extend {
  my ($self) = @_;

  my $sqrt = $self->{'sqrt'};
  if (defined $sqrt) {
    if ($sqrt =~ m{^\s*(\d+)\s*$}) {
      $sqrt = $1;
    } else {
      croak 'Unrecognised SqrtDigits parameter: ', $self->{'sqrt'};
    }
  } else {
    $sqrt = $self->parameter_default('sqrt');
  }

  unless (Math::BigInt->can('new')) {
    # pure-perl Calc.pm is very slow
    eval 'use Math::BigInt try => "GMP"; 1'
      || require Math::BigInt;
  }
  my $calcdigits = int(2*$self->{'i_extended'} + 32);

  my $radix = $self->{'radix'};
  my $power;
  my $root;
  my $halfdigits = int($calcdigits/2);
  if ($radix == 2) {
    $root = Math::BigInt->new(1);
    $root->blsft ($calcdigits);
  } else {
    $power = Math::BigInt->new($radix);
    $power->bpow ($halfdigits);
    $root = Math::BigInt->new($power);
    $root->bmul ($root);
  }
  $root->bmul ($sqrt);
  ### $radix
  ### $calcdigits
  ### root of: "$root"
  $root->bsqrt();
  ### root is: "$root"

  if (my $method = $radix_to_stringize{$radix}) {
    $self->{'string'} = $root->$method();
    ### string: $self->{'string'}

    # one leading zero for i=1 start
    if ($radix == 2) {
      substr($self->{'string'},0,2) = '0';  # replacing 0b from as_bin()
    } elsif ($radix != 8) {
      # already leading 0 from as_oct()
      substr($self->{'string'},0,0) = '0';
    }

  } else {
    $self->{'root'} = $root;

    if ($radix > 1) {
      while ($power <= $root) {
        $power->bmul($radix);
      }
    }
    if (my $i = $self->{'i'} - 1) {
      my $div = Math::BigInt->new($radix);
      $div->bpow ($i);
      $power->bdiv ($div);
      $root->bmod ($power);
    }
    $self->{'root'} = $root;
    $self->{'power'} = $power;
  }
}


sub next {
  my ($self) = @_;

  my $radix = $self->{'radix'};
  if ($radix < 2) {
    return;
  }

  if ($self->{'i'} >= $self->{'i_extended'}) {
    $self->{'i_extended'} = int(($self->{'i_extended'} + 100) * 1.5);
    _extend($self);
  }

  ### SqrtDigits next(): $self->{'i'}
  if (defined $self->{'string'}) {
    my $i = $self->{'i'}++;
    if ($i > length($self->{'string'})) {
      ### oops, past end of string ...
      return;
    }
    ### string char: "i=$i substr=".substr($self->{'string'},$i,1)
    return ($i, substr($self->{'string'},$i,1));

  } else {
    # digit by digit from the top like this is a bit slow, should chop into
    # repeated halves instead

    my $power = $self->{'power'};
    if ($power == 0) {
      return;
    }
    my $root  = $self->{'root'};
    ### root: "$root"
    ### power: "$power"

    $self->{'power'}->bdiv($self->{'radix'});
    (my $digit, $self->{'root'}) = $root->bdiv ($self->{'power'});
    ### digit: "$digit"
    return (++$self->{'i'}, $digit);
  }
}

# ENHANCE-ME: which digits can occur? all of them?
# sub pred {
#   my ($self, $n) = @_;
#   return ($n < $self->{'radix'});
# }

1;
__END__

=for stopwords Ryde Math-NumSeq radicand BigInt

=head1 NAME

Math::NumSeq::SqrtDigits -- the digits of a square root

=head1 SYNOPSIS

 use Math::NumSeq::SqrtDigits;
 my $seq = Math::NumSeq::SqrtDigits->new (sqrt => 7);
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The sequence of digits which are the square root of a given radicand.  For
example sqrt(2) in decimal 1, 4, 1, 4, 2, 1, etc, being 1.41421 etc.

The default is decimal, or a C<radix> can be given.  In the current code
C<Math::BigInt> is used.  (For radix 2, 8 and 10 the specific digit
conversion methods in BigInt are used, which might be faster than the
general case.)

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::SqrtDigits-E<gt>new (sqrt =E<gt> $s)>

=item C<$seq = Math::NumSeq::SqrtDigits-E<gt>new (sqrt =E<gt> $s, radix =E<gt> $r)>

Create and return a new sequence object giving the digits of C<sqrt($s)>.

=item C<$value = $seq-E<gt>ith($i)>

Return C<$i ** 2>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> might occurs as a digit in the square root.

Currently this presumes all digits occur, so simply C<$value E<gt>= 0> and
C<$value < $radix>.  For a perfect square this might be wrong, for a
non-square do all digits in fact occur?

=back

=head1 BUGS

The current code requires C<Math::BigInt> C<bsqrt()>, which may mean BigInt
1.60 (in Perl 5.8.0) or higher.

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::FractionDigits>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2010, 2011 Kevin Ryde

Math-NumSeq is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation; either version 3, or (at your option) any later
version.

Math-NumSeq is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
more details.

You should have received a copy of the GNU General Public License along with
Math-NumSeq.  If not, see <http://www.gnu.org/licenses/>.

=cut
