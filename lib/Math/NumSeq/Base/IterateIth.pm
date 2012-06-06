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

package Math::NumSeq::Base::IterateIth;
use 5.004;
use strict;

use vars '$VERSION';
$VERSION = 42;

sub rewind {
  my ($self) = @_;
  $self->seek_to_i($self->i_start);
}
sub seek_to_i {
  my ($self, $i) = @_;
  $self->{'i'} = $i;
}
sub next {
  my ($self) = @_;
  my $i = $self->{'i'}++;
  if (defined (my $value = $self->ith($i))) {
    return ($i, $value);
  } else {
    return;
  }
}

1;
__END__
