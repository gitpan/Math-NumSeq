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


# characteristic('monotonic')      strictly non-decreasing
# characteristic('monotonic_from_i')   beyond a given value or i


# ->add ->sub   of sequence or constant
# ->mul
# ->mod($k)    of constant
# overloads
# ->shift
# ->inverse  some with known ways to calculate
# ->is_subset_of
#
# ->value_to_i_floor
# ->pred undef if unknown ?


# lo,hi   i or value
# lo_value,hi_value

# Sequence::Array from arrayref
# Derived::Interleave




package Math::NumSeq;
use 5.004;
use strict;

use vars '$VERSION', '@ISA', '@EXPORT_OK';
$VERSION = 1;

# uncomment this to run the ### lines
#use Smart::Comments;

BEGIN {
  eval "#line ".(__LINE__+1)." \"".__FILE__."\"\n" . <<'HERE'
# print "attempt Locale::Messages for __\n";
use Locale::Messages ();
sub __ { Locale::Messages::dgettext('Math-NumSeq',$_[0]) }
1;
HERE
    || eval "#line ".(__LINE__+1)." \"".__FILE__."\"\n" . <<'HERE'
# print "fallback definition of __\n";
sub __ { $_[0] };
1;
HERE
  || die $@;
}

# sub name {
#   my ($class_or_self) = @_;
#   my $name = ref($class_or_self) || $class_or_self;
#   $name =~ s/^Math::NumSeq:://;
#   return $name;
# }

use constant description => undef;
use constant i_start => 0;
use constant oeis_anum => undef;

sub values_min {
  my ($self) = @_;
  return $self->{'values_min'};
}
sub values_max {
  my ($self) = @_;
  return $self->{'values_max'};
}

use constant parameter_info_array => [];
sub parameter_info_list {
  return @{$_[0]->parameter_info_array};
}

# not documented yet
my %parameter_info_hash;
sub parameter_info_hash {
  my ($class_or_self) = @_;
  my $class = (ref $class_or_self || $class_or_self);
  return ($parameter_info_hash{$class}
          ||= { map { $_->{'name'} => $_ }
                $class_or_self->parameter_info_list });
}

# not documented yet
sub parameter_default {
  my ($class_or_self, $name) = @_;
  ### Values parameter_default: @_
  ### info: $class_or_self->parameter_info_hash->{$name}
  my $info;
  return (($info = $class_or_self->parameter_info_hash->{$name})
          && $info->{'default'});
}


#    pn1         values +1, -1, 0
#    permutation
#    delta
#    boolean ?
sub characteristic {
  my $self = shift;
  my $type = shift;
  if (ref $self
      && (my $href = $self->{'characteristic'})) {
    if (exists $href->{$type}) {
      return $href->{$type};
    }
  }
  if (my $subr = $self->can("characteristic_${type}")) {
    return $self->$subr (@_);
  }
  return undef;
}
# use constant finish => undef;

sub new {
  my ($class, %self) = @_;
  ### Sequence new(): $class
  $self{'lo'} ||= 0;
  my $self = bless \%self, $class;

  foreach my $pinfo ($self->parameter_info_list) {
    my $pname = $pinfo->{'name'};
    if (! defined $self->{$pname}) {
      ### default: $pname
      $self->{$pname} = $pinfo->{'default'};
    }
  }
  $self->rewind;
  return $self;
}

1;
__END__

=for stopwords Ryde Math-NumSeq oopery genericness Online OEIS ie

=head1 NAME

Math::NumSeq -- number sequences

=head1 SYNOPSIS

 # only a base class, use one of the actual classes such as
 use Math::NumSeq::Squares;
 my $seq = Math::NumSeq::Squares->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

This is a base class for number sequences.  Sequence objects can iterate
through the values, and some sequences have random access and predicate.
It's a touch rough yet.

The idea is to generate things like squares or primes in a generic way.
Some sequences, like squares, are so easy there's no need for this except
for the genericness.  Other sequences are trickier and an iterator is a good
way to go through the values.

=head1 FUNCTIONS

In the following "Foo" is one of the actual subclass names.

=over 4

=item C<$seq = Math::NumSeq::Foo-E<gt>new (key=E<gt>value,...)>

Create and return a new sequence object.

=item C<($i, $value) = $seq-E<gt>next()>

Return the next index and value in the sequence.

=item C<$seq-E<gt>rewind()>

Rewind the sequence to its starting point.

=item C<$str = $seq-E<gt>description()>

A human-readable description of the sequence.

=item C<$value = $seq-E<gt>values_min()>

=item C<$value = $seq-E<gt>values_max()>

Return the minimum or maximum value taken by values in the sequence, or
C<undef> if unknown or infinity.

=item C<$ret = $seq-E<gt>characteristic($key)>

Return something if the sequence has a C<$key> (a string) characteristic, or
C<undef> if not.  This is intended as a loose set of expressing features or
properties a sequence might have.

    digits      the radix (an integer), if sequence is digits

=item C<$str = $seq-E<gt>oeis_anum()>

Return the Online Encyclopedia of Integer Sequences A-number (a string) of
C<$seq>, or C<undef> if not in the OEIS or not known.  For example

    my $seq = Math::NumSeq::Squares->new;
    my $anum = $seq->oeis_anum;
    # gives $anum eq "A000290"

The web page for that is then

    http://oeis.org/A000290

Sometimes the OEIS has duplicates, ie. two A-numbers which are the same
sequence.  C<$seq-E<gt>oeis_anum()> generally returns whichever is the
primary one, at least for accidental duplication.

=back

=head2 Optional Methods

The following methods are only implemented for some sequences, since it's
sometimes difficult to generate an arbitrary numbered element etc.  Check
with C<$seq-E<gt>can('ith')> etc before using.

=over

=item C<$value = $seq-E<gt>ith($i)>

Return the C<$i>'th value in the sequence.  Only some sequence classes
implement this method.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs in the sequence.  For example for the
squares this would return true if C<$value> is a perfect square or false if
not.

=back

=head1 SEE ALSO

L<Math::NumSeq::Squares>,
L<Math::NumSeq::Cubes>,
L<Math::NumSeq::Pronic>,
L<Math::NumSeq::Triangular>,
L<Math::NumSeq::Polygonal>,
L<Math::NumSeq::Tetrahedral>,
L<Math::NumSeq::StarNumbers>,
L<Math::NumSeq::Even>,
L<Math::NumSeq::Odd>

L<Math::NumSeq::Factorials>,
L<Math::NumSeq::Primorials>,
L<Math::NumSeq::Fibonacci>,
L<Math::NumSeq::LucasNumbers>

L<Math::NumSeq::FractionDigits>,
L<Math::NumSeq::SqrtDigits>

L<Math::NumSeq::DigitLength>,
L<Math::NumSeq::DigitLengthCumulative>,
L<Math::NumSeq::RadixWithoutDigit>,
L<Math::NumSeq::HarshadNumbers>

L<Math::NumSeq::Beastly>,
L<Math::NumSeq::Repdigits>,
L<Math::NumSeq::Palindromes>

L<Math::NumSeq::CullenNumbers>,
L<Math::NumSeq::ProthNumbers>,
L<Math::NumSeq::WoodallNumbers>

L<Math::NumSeq::CollatzSteps>

L<Math::Sequence> and L<Math::Series>, for symbolic recursive sequence
definitions

L<math-image>

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




# =item C<$i = $seq-E<gt>i_start()>
# 
# Return the first index C<$i> in the sequence.  This is the position
# C<rewind> returns to.

