# Copyright 2011 Kevin Ryde

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

package Math::NumSeq::Base::IterateIth;
use 5.004;
use strict;

use vars '$VERSION';
$VERSION = 19;

sub rewind {
  my ($self) = @_;
  $self->{'i'} = $self->i_start;
}
sub next {
  my ($self) = @_;
  my $i = $self->{'i'}++;
  return ($i, $self->ith($i));
}

1;
__END__
