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

package Math::NumSeq::Polygonal;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 3;

use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');

# uncomment this to run the ### lines
#use Smart::Comments;

# use constant name => Math::NumSeq::__('Polygonal Numbers');
use constant description => Math::NumSeq::__('Polygonal numbers');
use constant values_min => 1;
use constant characteristic_monotonic => 2;
use constant parameter_info_array =>
  [
   { name    => 'polygonal',
     display => Math::NumSeq::__('Polygonal'),
     type    => 'integer',
     default => 6,
     minimum => 3,
     description => Math::NumSeq::__('Which polygonal numbers to show.  3 is the triangular numbers, 4 the perfect squares, 5 the pentagonal numbers, etc.'),
   },
   { name    => 'pairs',
     display => Math::NumSeq::__('Pairs'),
     type    => 'enum',
     default => 'first',
     choices => ['first','second','both'],  # ,'average'
     choices_display => [Math::NumSeq::__('First'),
                         Math::NumSeq::__('Second'),
                         Math::NumSeq::__('Both'),
                         # Math::NumSeq::__('Average'),
                        ],
     description => Math::NumSeq::__('Which of the pair of values to show.'),
   },
  ];

my @oeis
  = (undef, # 0
     undef, # 1
     undef, # 2

     # in Triangular.pm ... A000217 polygonal=3  pairs=first
     { first  =>  'A000217' }, # 3 triangular

     # in Squares.pm    ... A000290 polygonal=4  pairs=first
     { first  =>  'A000290' }, # 4 squares

     {
      # OEIS-Catalogue: A000326 polygonal=5  pairs=first
      first  => 'A000326',   # 5 pentagonal
      # OEIS-Catalogue: A005449 polygonal=5  pairs=second
      second => 'A005449',
      # OEIS-Catalogue: A001318 polygonal=5  pairs=both
      both   => 'A001318',
     },

     {
      # OEIS-Catalogue: A000384 polygonal=6  pairs=first  # 6 hexagonal
      first  => 'A000384',   # 6 hexagonal
      # OEIS-Catalogue: A014105 polygonal=6  pairs=second
      second => 'A014105',
     },

     # OEIS-Catalogue: A000566 polygonal=7  pairs=first  # 7 heptagonal
     { first  => 'A000566' }, # 7 heptagonal

     # OEIS-Catalogue: A000567 polygonal=8  pairs=first  # 8 octagonal
     { first  =>  'A000567' }, # 8 octagonal

     # OEIS-Catalogue: A001106 polygonal=9  pairs=first  # 9 nonagonal
     { first  =>  'A001106' }, # 9 nonagonal

     # OEIS-Catalogue: A001107 polygonal=10 pairs=first  # 10 decogaonal
     { first  =>  'A001107' }, # 10 decogaonal

     # OEIS-Catalogue: A051682 polygonal=11 pairs=first  # 11 hendecagonal
     { first  =>  'A051682' }, # 11 hendecagonal

     # OEIS-Catalogue: A051624 polygonal=12 pairs=first  # 12-gonal
     { first  =>  'A051624' }, # 12-gonal

     # these in sequence ...
     { first  =>  'A051865' }, # 13 tridecagonal
     { first  =>  'A051866' }, # 14-gonal
     { first  =>  'A051867' }, # 15
     { first  =>  'A051868' }, # 16
     { first  =>  'A051869' }, # 17
     { first  =>  'A051870' }, # 18
     { first  =>  'A051871' }, # 19
     { first  =>  'A051872' }, # 20
     { first  =>  'A051873' }, # 21
     { first  =>  'A051874' }, # 22
     { first  =>  'A051875' }, # 23
     { first  =>  'A051876' }, # 24
     # OEIS-Catalogue: A051865 polygonal=13 pairs=first  # 13 tridecagonal
     # OEIS-Catalogue: A051866 polygonal=14 pairs=first  # 14-gonal
     # OEIS-Catalogue: A051867 polygonal=15 pairs=first  # 15
     # OEIS-Catalogue: A051868 polygonal=16 pairs=first  # 16
     # OEIS-Catalogue: A051869 polygonal=17 pairs=first  # 17
     # OEIS-Catalogue: A051870 polygonal=18 pairs=first  # 18
     # OEIS-Catalogue: A051871 polygonal=19 pairs=first  # 19
     # OEIS-Catalogue: A051872 polygonal=20 pairs=first  # 20
     # OEIS-Catalogue: A051873 polygonal=21 pairs=first  # 21
     # OEIS-Catalogue: A051874 polygonal=22 pairs=first  # 22
     # OEIS-Catalogue: A051875 polygonal=23 pairs=first  # 23
     # OEIS-Catalogue: A051876 polygonal=24 pairs=first  # 24
    );
sub oeis_anum {
  my ($class_or_self) = @_;
  my $k = (ref $class_or_self
           ? $class_or_self->{'k'}
           : $class_or_self->parameter_default('polygonal'));
  my $pairs = (ref $class_or_self
               ? $class_or_self->{'pairs'}
               : $class_or_self->parameter_default('pairs'));
  return $oeis[$k]->{$pairs};
}


# ($k-2)*$i*($i+1)/2 - ($k-3)*$i
# = ($k-2)/2*$i*i + ($k-2)/2*$i - ($k-3)*$i
# = ($k-2)/2*$i*i + ($k - 2 - 2*$k + 6)/2*$i
# = ($k-2)/2*$i*i + (-$k + 4)/2*$i
# = 0.5 * (($k-2)*$i*i + (-$k +4)*$i)
# = 0.5 * $i * (($k-2)*$i - $k + 4)

# 25*i*(i+1)/2 - 24i
# 25*i*(i+1)/2 - 48i/2
# i/2*(25*(i+1) - 48)
# i/2*(25*i + 25 - 48)
# i/2*(25*i - 23)
# 

sub rewind {
  my ($self) = @_;
  my $lo = $self->{'lo'} || 0;

  my $k = $self->{'polygonal'} || 2;
  my $add = - $k + 4;
  my $pairs = $self->{'pairs'} || ($self->{'pairs'} = 'first');
  if ($k >= 5) {
    if ($pairs eq 'second') {
      $add = - $add;
    } elsif ($pairs eq 'both') {
      $add = - abs($add);
    }
  }
  $self->{'k'} = $k;
  $self->{'add'} = $add;
}

sub ith {
  my ($self, $i) = @_;
  my $k = $self->{'k'};
  if ($k < 3) {
    if ($i == 0) {
      return 1;
    } else {
      return;
    }
  }
  my $pairs = $self->{'pairs'};
  if ($pairs eq 'both') {
    if ($i & 1) {
      $i = ($i+1)/2;
    } else {
      $i = -$i/2;
    }
  }
  ### $i
  return $i * (($k-2)*$i + $self->{'add'}) / 2;
}

# k=3  -1/2 + sqrt(2/1 * $n + 1/4)
# k=4         sqrt(2/2 * $n      )
# k=5   1/6 + sqrt(2/3 * $n + 1/36)
# k=6   2/8 + sqrt(2/4 * $n + 4/64)
# k=7  3/10 + sqrt(2/5 * $n + 9/100)
# k=8  4/12 + sqrt(2/6 * $n + 1/9)
#
# i = 1/(2*(k-2)) * [k-4 + sqrt( 8*(k-2)*n + (4-k)^2 ) ]
sub pred {
  my ($self, $value) = @_;
  if ($value <= 0) {
    return ($value == 0);
  }
  my $k = $self->{'k'};
  my $sqrt = sqrt(8*($k-2) * $value + (4-$k)**2);
  if ($self->{'pairs'} eq 'both') {
    my $other = ($sqrt + $self->{'add'}) / (2*($k-2));
    if (int($other) == $other) {
      return 1;
    }
  }
  $sqrt = ($sqrt - $self->{'add'}) / (2*($k-2));
  return (int($sqrt) == $sqrt);

}

1;
__END__
