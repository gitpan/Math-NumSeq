# Copyright 2010, 2011, 2012 Kevin Ryde

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

package Math::NumSeq::Factorials;
use 5.004;
use strict;

use vars '$VERSION','@ISA';
$VERSION = 34;

use Math::NumSeq;
@ISA = ('Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

# use constant name => Math::NumSeq::__('Factorials');
use constant description => Math::NumSeq::__('The factorials 1, 2, 6, 24, 120, etc, 1*2*...*N.');
use constant values_min => 1;
use constant i_start => 0;
use constant characteristic_increasing => 1;
use constant characteristic_integer => 1;
use constant oeis_anum => 'A000142'; # factorials 1,1,2,6,24, including 0!==1

# uncomment this to run the ### lines
#use Devel::Comments;


use constant 1.02;  # for leading underscore
use constant _UV_LIMIT => do {
  my $u = ~0 >> 1;
  my $limit = 1;
  for (my $i = 2; $i++; ) {
    if ($u < $i) {
      ### _UV_LIMIT stop before: "i=$i"
      last;
    }
    $u -= ($u % $i);
    $u /= $i;
    $limit *= $i;
  }
  $limit
};
### _UV_LIMIT: _UV_LIMIT()


sub rewind {
  my ($self) = @_;
  ### Factorials rewind()
  $self->{'i'} = $self->i_start;
  $self->{'f'} = 1;
}
sub next {
  my ($self) = @_;
  ### Factorials next()
  my $i = $self->{'i'}++;
  my $f = $self->{'f'};
  if ($f >= _UV_LIMIT && ! ref $f) {
    $self->{'f'} = Math::NumSeq::_bigint()->new($f);
  }
  return ($i, $self->{'f'} *= ($i||1));
}

sub pred {
  my ($self, $value) = @_;
  ### Factorials pred(): $value
  my $i = 2;
  for (;; $i++) {
    if ($value <= 1) {
      return ($value == 1);
    }
    if (($value % $i) == 0) {  # inf or nan fails this
      $value /= $i;
    } else {
      return 0;
    }
  }
}

sub value_to_i_estimate {
  my ($self, $value) = @_;
  if (_is_infinite($value)) {
    return $value;
  }
  my $i = 2;
  for (;; $i++) {
    $value = int($value/$i);
    if ($value <= 1) {
      return $i;
    }
  }
}

1;
__END__

=for stopwords Ryde Math-NumSeq ie

=head1 NAME

Math::NumSeq::Factorials -- factorials 1*2*...*i

=head1 SYNOPSIS

 use Math::NumSeq::Factorials;
 my $seq = Math::NumSeq::Factorials->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The sequence of factorials, 1, 2, 6, 24, 120, etc, being the product
1*2*3*...*i.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::Factorials-E<gt>new (key=E<gt>value,...)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return C<1*2*...*$i>.  For C<$i==0> this is considered an empty product and
the return is 1.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a factorial, ie. equal to C<1*2*...*i> for
some i.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Primorials>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2010, 2011, 2012 Kevin Ryde

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
