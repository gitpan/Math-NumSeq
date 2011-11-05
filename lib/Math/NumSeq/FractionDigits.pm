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

package Math::NumSeq::FractionDigits;
use 5.004;
use strict;
use List::Util 'max';
use Math::NumSeq;

use vars '$VERSION', '@ISA';
$VERSION = 15;
use Math::NumSeq::Base::Digits;
@ISA = ('Math::NumSeq::Base::Digits');


# uncomment this to run the ### lines
#use Devel::Comments;

# use constant name => Math::NumSeq::__('Fraction Digits');
use constant description => Math::NumSeq::__('A given fraction number written out in binary.');
use constant parameter_info_array =>
  [ Math::NumSeq::Base::Digits->parameter_info_list,
    { name       => 'fraction',
      display    => Math::NumSeq::__('Fraction'),
      type       => 'string',
      type_hint  => 'fraction',
      width      => 10,
      default    => '5/29', # an arbitrary choice
      description => Math::NumSeq::__('The fraction to show, for example 5/29.  Press Return when ready to display the expression.'),
    },
  ];

my @oeis_anum;

$oeis_anum[10] =
  {
   # Any fixed-length repeating sequence is a fraction of some sort in
   # some radix.  There's many more not expressed here, and constant
   # digits sequences can be done by more than one fraction, etc.

   '1/7'   => 'A020806',   # 1/7 decimal
   # OEIS-Catalogue: A020806 fraction=1/7
   '22/7'  => 'A068028',   # 22/7 decimal
   # OEIS-Catalogue: A068028 fraction=22/7

   '1/9'   => 'A000012',   # 1/9 decimal, is just 1,1,1,1
   # pending something better for a constant sequence
   # OEIS-Catalogue: A000012 fraction=1/9

   '1/11'  => 'A010680',   # 1/11 decimal
   # OEIS-Catalogue: A010680 fraction=1/11

   # OEIS-Catalogue: A021015 fraction=1/11  # duplicate of A010680
   # OEIS-Catalogue: A021016 fraction=1/12
   # OEIS-Catalogue: A021017 fraction=1/13
   # OEIS-Catalogue: A021018 fraction=1/14
   # OEIS-Catalogue: A021019 fraction=1/15
   # OEIS-Catalogue: A021020 fraction=1/16

   '1/17'  => 'A007450',   # 1/17 decimal
   # OEIS-Catalogue: A007450 fraction=1/17

   # Math::NumSeq::OEIS::Catalogue::Plugin::FractionDigits has A021022
   # through A021999, being 1/18 to 1/995.  1/996 missing apparently.
   #
   # OEIS-Catalogue: A022001 fraction=1/997
   # OEIS-Catalogue: A022002 fraction=1/998
   # OEIS-Catalogue: A022003 fraction=1/999

   #---------------

   # extra 10 in the denominator to give the leading 0
   '13717421/1111111110' => 'A010888',  # .012345678912...
   # OEIS-Catalogue: A010888 fraction=13717421/1111111110

   #---------------

   # constant digits 3,3,3,...
   '10/3' => 'A010701',
   # ENHANCE-ME: of course could generate 3s more efficiently
   # just as a constant sequence, in which case would prefer that
   # over this for the catalogue.
   # OEIS-Catalogue: A010701 fraction=10/3
  };
sub oeis_anum {
  my ($self) = @_;
  ### oeis_anum() ...
  my $radix = $self->{'radix'};
  my $fraction = $self->{'fraction'};
  if (my $anum = $oeis_anum[$radix]->{$fraction}) {
    return $anum;
  }
  if ($radix == 10
      && $fraction =~ m{(\d+)/(\d+)}
      && $1 == 1
      && $2 >= 12 && $2 <= 999 && $2 != 996
      && ($2 % 10) != 0
      && $2 != 25) {
    return 'A0'.($2 + 21016-12);
  }
  ### $fraction
  return undef;
}

sub rewind {
  my ($self) = @_;

  my $radix = $self->{'radix'};
  my $fraction = $self->{'fraction'};

  my $num = 0;  # 0/0 if unrecognised
  my $den = 0;
  ($num, $den) = ($fraction =~ m{^\s*
                                 ([.[:digit:]]+)?
                                 \s*
                                 (?:/\s*
                                   ([.[:digit:]]+)?
                                 )?
                                 \s*$}x);
  if (! defined $num) { $num = 1; }
  if (! defined $den) { $den = 1; }
  ### $num
  ### $den
  $fraction = "$num/$den";

  my $num_decimals = 0;
  my $den_decimals = 0;
  if ($num =~ m{(\d*)\.(\d+)}) {
    $num = $1 . $2;
    $num_decimals = length($2);
  }
  if ($den =~ m{(\d*)\.(\d+)}) {
    $den = $1 . $2;
    $den_decimals = length($2);
  }
  $num .= '0' x max(0, $den_decimals - $num_decimals);
  $den .= '0' x max(0, $num_decimals - $den_decimals);

  while ($den != 0 && $num >= $den) {
    $den *= $radix;
  }
  # while ($num && $num < $den) {
  #   $num *= $radix;
  # }

  ### create
  ### $num
  ### $den
  $self->{'fraction'} = $fraction;
  $self->{'num'} = $num;
  $self->{'den'} = $den;
  $self->{'i'} = 0;
}

sub next {
  my ($self) = @_;

  my $num   = $self->{'num'} || return;  # num==0 exact radix frac
  my $den   = $self->{'den'} || return;  # den==0 invalid
  my $radix = $self->{'radix'};
  my $i = $self->{'i'};
  ### FractionDigits next(): "$i  $num/$den"

  ### frac: "$num / $den"
  $num *= $radix;
  my $quot = int ($num / $den);
  $self->{'num'} = $num - $quot * $den;
  ### $quot
  ### rem: $self->{'num'}
  return ($self->{'i'}++, $quot);
}

# FIXME: only some digits occur, being the mod den residue class containing num.
# sub pred {
#   my ($self, $value) = @_;
# }
#
# =item C<$bool = $seq-E<gt>pred($value)>
# 
# Return true if C<$value> occurs as a digit in the fraction.

1;
__END__

=for stopwords Ryde Math-NumSeq radix-1 ie xx.yy

=head1 NAME

Math::NumSeq::FractionDigits -- the digits of a fraction p/q

=head1 SYNOPSIS

 use Math::NumSeq::FractionDigits;
 my $seq = Math::NumSeq::FractionDigits->new (fraction => '2/11');
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The sequence of digits which are a given fraction.  For example 1/7 in
decimal 1,4,2,8,5,7,1,4, etc, being 0.14285714...

The digits are always a repeating sequence of length no more than den-1.  In
fact for a given repeating sequence a,b,c,a,b,c,etc the fraction is abc/999,
if you want to cook up a sequence like that.  In a base other than decimal
the "9" is radix-1, ie. the highest digit.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::FractionDigits-E<gt>new (fraction =E<gt> $f)>

=item C<$seq = Math::NumSeq::FractionDigits-E<gt>new (fraction =E<gt> $f, radix =E<gt> $r)>

Create and return a new sequence object giving the digits of C<$f>.  C<$f>
is a string "num/den", or a decimal "xx.yy",

    2/29
    1.5/3.25
    29.125

The default is digits in decimal, or with the C<radix> parameter in another
base.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::SqrtDigits>

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
