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

package Math::NumSeq::Repdigits;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 21;
use Math::NumSeq;
@ISA = ('Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;


# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('Repdigits');
use constant description => Math::NumSeq::__('Numbers which are a "repdigit", meaning 0, 1 ... 9, 11, 22, 33, ... 99, 111, 222, 333, ..., 999, etc.  The default is decimal, or select a radix.');
use constant characteristic_monotonic => 1;
use constant values_min => 0;

use Math::NumSeq::Base::Digits;
*parameter_info_array = \&Math::NumSeq::Base::Digits::parameter_info_array;

my @oeis_anum = (undef, # 0
                 undef, # 1
                 undef, # 2
                 'A048328', # 3
                 'A048329', # 4
                 'A048330', # 5
                 'A048331', # 6
                 'A048332', # 7
                 'A048333', # 8
                 'A048334', # 9 
                 'A010785', # 10, starting from i=0
                 'A048335', # 11
                 'A048336', # 12
                 'A048337', # 13
                 'A048338', # 14
                 'A048339', # 15
                 'A048340', # 16
                );
sub oeis_anum {
  my ($self) = @_;
  return $oeis_anum[$self->{'radix'}];
}
# OEIS-Catalogue: A010785 radix=10

sub rewind {
  my ($self) = @_;
  my $radix = $self->{'radix'};
  if ($radix < 2) { $radix = $self->{'radix'} = 10; }

  if ($radix == 2) {
    $self->{'i'} = 0;
  } else {
    $self->{'n'} = -1;
    $self->{'inc'} = 1;
    $self->{'digit'} = -1;
  }
}
sub next {
  my ($self) = @_;

  my $i = $self->{'i'}++;
  my $radix = $self->{'radix'};
  if ($radix == 2) {
    return (1 << $i) - 1;

  } else {
    my $n = ($self->{'n'} += $self->{'inc'});
    if (++$self->{'digit'} >= $radix) {
      $self->{'inc'} = $self->{'inc'} * $radix + 1;
      $self->{'digit'} = 1;
      $self->{'n'} = ($n += 1); # not ++$n as that gives warnings on overflow
      ### digit: $self->{'digit'}
      ### inc: $self->{'inc'}
      ### $n
    }
    return ($i, $n);
  }
}

sub ith {
  my ($self, $i) = @_;
  my $radix = $self->{'radix'};

  if (_is_infinite ($i)) {
    return $i;
  }

  if ($radix == 2) {
    return (1 << $i) - 1;
  }

  if (($i-=1) < 0) {
    return 0;
  }
  my $digit = ($i % ($radix-1)) + 1;
  $i = int($i/($radix-1)) + 1;
  return ($radix ** $i - 1) / ($radix - 1) * $digit;
}

sub pred {
  my ($self, $value) = @_;

  {
    my $int = int($value);
    if ($value != $int) {
      return 0;
    }
    $value = $int;  # prefer BigInt if input BigFloat
  }

  my $radix = $self->{'radix'};
  if ($radix == 2) {
    return ! (($value+1) & $value);

  }
  if ($radix == 10) {
    my $digit = substr($value,0,1);
    return ($value !~ /[^$digit]/);
  }

  my $digit = $value % $radix;
  while ($value = int($value/$radix)) {
    unless (($value % $radix) == $digit) { # false for inf or nan
      return 0;
    }
  }
  return 1;
}

1;
__END__

=for stopwords Ryde Math-NumSeq repdigit repdigits

=head1 NAME

Math::NumSeq::Repdigits -- repdigits 11, 22, 33, etc

=head1 SYNOPSIS

 use Math::NumSeq::Repdigits;
 my $seq = Math::NumSeq::Repdigits->new (radix => 10);
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The sequence of repdigit numbers, 1 ... 9, 11, 22, 33, ... 99, 111, 222,
333, ..., 999, etc, comprising repetitions of a single digit.  The default
is decimal or a C<radix> parameter can be given.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::Repdigits-E<gt>new ()>

=item C<$seq = Math::NumSeq::Repdigits-E<gt>new (radix =E<gt> $r)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the C<$i>'th repdigit.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a repdigit in the given C<radix>.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::RepdigitAny>,
L<Math::NumSeq::Beastly>

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
