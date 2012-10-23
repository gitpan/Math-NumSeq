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

package Math::NumSeq::Base::IteratePred;
use 5.004;
use strict;
use List::Util 'max';

use vars '$VERSION';
$VERSION = 55;

sub rewind {
  my ($self) = @_;
  $self->{'i'} = $self->i_start;
  $self->{'value'} = $self->values_min;
}
sub next {
  my ($self) = @_;
  for (my $value = $self->{'value'}; ; $value++) {
    if ($self->pred($value)) {
      $self->{'value'} = $value+1;
      return ($self->{'i'}++, $value);
    }
  }
}

# Would have to scan all values to find correct i.
# sub seek_to_value {
#   my ($self, $value) = @_;
#   $value = int($value);
#   $self->{'value'} = max ($value, $self->values_min);
#   $self->{'i'} = ...
# }

# Slow to scan through all values.
# sub ith {
#   my ($self, $i) = @_;
#   $i -= $self->i_start;
#   my $value = $self->value_min - 1;
#   while ($i >= 0) {
#     $value++;
#     if ($self->pred($value)) {
#       $i--;
#     }
#   }
#   return $value;    
# }


1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::Base::IteratePred -- iterate by searching with pred()

=for test_synopsis my @ISA

=head1 SYNOPSIS

 package MyNumSeqSubclass;
 use Math::NumSeq;
 use Math::NumSeq::Base::IteratePred;
 @ISA = ('Math::NumSeq::Base::IteratePred',
         'Math::NumSeq');
 sub ith {
   my ($self, $i) = @_;
   return something($i);
 }

=head1 DESCRIPTION

This is a multi-inheritance mix-in providing the following methods

    rewind()
    next()

They iterate by calling C<pred()> to search for values in the sequence,
starting at C<values_min()> and stepping by 1 each time.

This is a handy way to implement the iterating methods for a NumSeq if
there's no easy way to step or random access for values, only test a
condition.

The current implementation is designed for infinite sequences, it doesn't
check for a C<values_max()> limit.

=head1 SEE ALSO

L<Math::NumSeq>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2011, 2012 Kevin Ryde

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
