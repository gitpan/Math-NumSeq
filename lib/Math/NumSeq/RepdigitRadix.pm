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

package Math::NumSeq::RepdigitRadix;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 19;
use Math::NumSeq;
@ISA = ('Math::NumSeq');

# uncomment this to run the ### lines
#use Smart::Comments;


use constant description => Math::NumSeq::__('First base in which i is a repdigit (at most base=i-1 since "11" gives i).');
use constant characteristic_smaller => 1;
use constant characteristic_monotonic => 0;
sub values_min {
  my ($self) = @_;
  return ($self->i_start >= 3 ? 2 : 0);
}
sub i_start {
  my ($self) = @_;
  return $self->{'i_start'} || 0;
}

# smallest base in which n is a repdigit, starting n=3
sub oeis_anum { 'A059711' }
# OEIS-Catalogue: A059711 i_start=3


# d * (b^3 + b^2 + b + 1) = i
# b^3 + b^2 + b + 1 = i/d
# (b+1)^3 = b^3 + 3b^2 + 3b + 1
#
# (b-1) * (b^3 + b^2 + b + 1) = b^4 - 1
#
# 8888 base 9 = 6560
# 1111 base 10

# b^2 + b + 1 = k
# (b+0.5)^2 + .75 = k
# (b+0.5)^2 = (k-0.75)
# b = sqrt(k-0.75)-0.5;

sub rewind {
  my ($self) = @_;
  $self->{'i'} = $self->i_start;
  $self->{'ones'}   = [ undef, undef, 7 ];
  $self->{'digits'} = [ undef, undef, 1 ];
  ### rewind to: $self
}

# (r+1)^2 + (r+1) + 1
#   = r^2 + 2r + 1 + r +1 + 1
#   = r^2 + 3r + 3
#   = (r + 3)*r + 3

#            0  1  2
my @small = (2, 0, 0);

sub next {
  my ($self) = @_;
  ### RepdigitRadix next(): $self->{'i'}

  my $i = $self->{'i'}++;
  my $ones = $self->{'ones'};
  my $digits = $self->{'digits'};

  if ($i < 3) {
    return ($i, $small[$i]);
  }

  for (my $radix = 2; ; $radix++) {
    ### $radix
    ### ones: $ones->[$radix]
    ### digit: $digits->[$radix]

    my $one;
    if ($radix > $#$ones) {
      ### maybe extend array: $radix
      $one = $radix + 1;  # or three digits ... ($radix + 1) * 
      unless ($one <= $i) {
        ### not repdigit of 3 digits in any radix, take as 2 digits ...
        return ($i, $i-1);
      }
      $ones->[$radix] = $one;
      $digits->[$radix] = 1;

    } else {
      $one = $ones->[$radix];
    }

    my $repdigit = $one * $digits->[$radix];
    while ($repdigit < $i) {
      my $digit = ++$digits->[$radix];
      if ($digit >= $radix) {
        $digit = $digits->[$radix] = 1;
        $one = $ones->[$radix] = ($one * $radix + 1);
      }
      $repdigit = $one * $digit;
    }
    ### consider repdigit: $repdigit
    if ($repdigit == $i) {
      ### found radix: $radix
      return ($i, $radix);
    }
  }
}

sub ith {
  my ($self, $i) = @_;
  ### RepdigitRadix ith(): $i

  if ($i < 3) {
    return $small[$i];
  }

  for (my $radix = 2; ; $radix++) {
    ### $radix

    my $one = $radix + 1;  # ... or 3 digits 111 ($radix + 1) *
    unless ($one <= $i) {
      ### stop at ones too big not a 3-digit repdigit: $one
      return $i-1;
    }
    ### $one

    do {
      if ($one == $i) {
        return $radix;
      }
      foreach my $digit (2 .. $radix-1) {
        ### $digit
        if ((my $repdigit = $digit * $one) <= $i) {
          if ($repdigit == $i) {
            return $radix;
          }
        }
      }
    } while (($one = $one * $radix + 1) <= $i);
  }
}

# R^2+R+1
# R=65 "111"=4291
#
# Does every radix occur?  Is it certain that at least one repdigit in base
# R is not a repdigit in anything smaller?
#
# sub pred {
#   my ($self, $value) = @_;
#   return ($value == int($value)
#           && ($value == 0 || $value >= 2));
# }

1;
__END__

=for stopwords Ryde 

=head1 NAME

Math::NumSeq::RepdigitRadix -- radix in which i is a repdigit

=head1 SYNOPSIS

 use Math::NumSeq::RepdigitRadix;
 my $seq = Math::NumSeq::RepdigitRadix->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The radix in which i is a repdigit,

    starting i=0
    2, 0, 0, 2, 3, 4, 5, 2, 3, 8, 4, 10, etc

i=0 is taken to be a repdigit 00 in base 2, but i=1 and i=2 are not
repdigits in any radix, then i=3 is repdigit 11 in base 2.  Any iE<gt>=3 is
a repdigit "11" in base i-1, but it may be a repdigit in a smaller base.
For example i=8 is "22" in base 3.

Is this behaviour for i=0,1,2 any good?  Perhaps it will change.

=head1 FUNCTIONS

=over 4

=item C<$seq = Math::NumSeq::RepdigitRadix-E<gt>new (key=E<gt>value,...)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the radix in which C<$i> is a repdigit.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::RepdigitAny>

=cut

# Local variables:
# compile-command: "math-image --values=RepdigitRadix"
# End:
