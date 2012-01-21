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
$VERSION = 30;

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
#   my ($self) = @_;
#   my $name = ref($self) || $self;
#   $name =~ s/^Math::NumSeq:://;
#   return $name;
# }

use constant description => undef;
sub oeis_anum {
  my ($self) = @_;
  return $self->{'oeis_anum'} || undef;
}

use constant default_i_start => 1;
sub i_start {
  my ($self) = @_;
  return (defined $self->{'i_start'}
          ? $self->{'i_start'}
          : $self->default_i_start);
}
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

# default i_start if "increasing"
sub characteristic_increasing_from_i {
  my ($self) = @_;
  return ($self->characteristic('increasing')
          ? $self->i_start
          : undef);
}

# default from the stronger condition "increasing"
sub characteristic_non_decreasing {
  my ($self) = @_;
  return $self->characteristic('increasing');
}
sub characteristic_non_decreasing_from_i {
  my ($self) = @_;
  return ($self->characteristic('non_decreasing')
          ? $self->i_start
          : undef);
}

# default "count" is integer
sub characteristic_integer {
  my ($self) = @_;
  return $self->characteristic_count;
}
use constant characteristic_count => undef; # don't know


#------------------------------------------------------------------------------

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

#------------------------------------------------------------------------------
# shared internals

# cf Data::Float, but it might not handle BigFloat
sub _is_infinite {
  my ($x) = @_;
  return ($x != $x    # nan
          || ($x != 0 && $x == 2*$x));  # inf
}

# or maybe check for new enough for uv->mpz fix
use constant::defer _bigint => sub {
  # Crib note: don't change the back-end if already loaded
  unless (Math::BigInt->can('new')) {
    require Math::BigInt;
    eval { Math::BigInt->import (try => 'GMP') };
  }
  return 'Math::BigInt';
};

1;
__END__

=for stopwords Ryde Math-NumSeq Math-Aronson Math-PlanePath oopery genericness Online OEIS ie arrayref hashref filename enum Aronson

=head1 NAME

Math::NumSeq -- number sequences

=head1 SYNOPSIS

 # only a base class, use one of the actual classes such as
 use Math::NumSeq::Squares;
 my $seq = Math::NumSeq::Squares->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

This is a base class for number sequences.  Sequence objects can iterate
through values, and some sequences have random access and predicate.

The idea is to generate things like squares or primes in a generic way.
Some sequences, like squares, are so easy there's no need for this except
for the genericness.  Other sequences are trickier and an iterator is a good
way to go through the values.

The intention is that all modules C<Math::NumSeq::Foo> are sequence classes,
and that supporting things are deeper, such as under
C<Math::NumSeq::Something::Helper> or C<Math::NumSeq::Base::SharedStuff>.

=head1 FUNCTIONS

In the following "Foo" is one of the subclass names.

=over 4

=item C<$seq = Math::NumSeq::Foo-E<gt>new (key=E<gt>value,...)>

Create and return a new sequence object.

=item C<($i, $value) = $seq-E<gt>next()>

Return the next index and value in the sequence.

=item C<$seq-E<gt>rewind()>

Rewind the sequence to its starting point.

=item C<$i = $seq-E<gt>i_start()>

Return the first index C<$i> in the sequence.  This is the position
C<rewind()> returns to.

=item C<$str = $seq-E<gt>description()>

A human-readable description of the sequence.

=item C<$value = $seq-E<gt>values_min()>

=item C<$value = $seq-E<gt>values_max()>

Return the minimum or maximum value taken by values in the sequence, or
C<undef> if unknown or infinity.

=item C<$ret = $seq-E<gt>characteristic($key)>

Return something if the sequence has a C<$key> (a string) characteristic, or
C<undef> if not.  This is intended as a loose set of features or properties
a sequence might have.

    digits            integer or undef, the radix if seq is digits
    count             boolean, true if values are counts of something
    smaller           boolean, true if v[i] < i, in general
    integer           boolean, true if all values are integers

    increasing        boolean, true if v[i+1] > v[i] always
    non_decreasing    boolean, true if v[i+1] >= v[i] always
    increasing_from_i     integer, i for which v[i+1] > v[i]
    non_decreasing_from_i integer, i for which v[i+1] >= v[i]

=item C<$str = $seq-E<gt>oeis_anum()>

Return the A-number (a string) for Sloane's Online Encyclopedia of Integer
Sequences of C<$seq>, or return C<undef> if not in the OEIS or not known.
For example

    my $seq = Math::NumSeq::Squares->new;
    my $anum = $seq->oeis_anum;
    # gives $anum eq "A000290"

The web page for that is then

    http://oeis.org/A000290

Sometimes the OEIS has duplicates, ie. two A-numbers which are the same
sequence.  C<$seq-E<gt>oeis_anum()> is generally the primary one in cases
where the duplication is accidental or historical.

=item C<$aref = Math::NumSeq::Foo-E<gt>parameter_info_array()>

=item C<@list = Math::NumSeq::Foo-E<gt>parameter_info_list()>

Return an arrayref of list describing the parameters taken by a given class.
This meant to help making widgets etc for user interaction in a GUI.  Each
element is a hashref

    {
      name        =>    parameter key arg for new()
      share_key   =>    string, or undef
      description =>    human readable string
      type        =>    string "integer","boolean","enum" etc
      default     =>    value
      minimum     =>    number, or undef
      maximum     =>    number, or undef
      width       =>    integer, suggested display size
      choices     =>    for enum, an arrayref     
    }

C<type> is a string, one of

    "integer"
    "enum"
    "boolean"
    "string"
    "filename"

"filename" is separate from "string" since it might require subtly different
handling to ensure it reaches Perl as a byte string, whereas a "string" type
might in principle take Perl wide chars.

For "enum" the C<choices> field is the possible values, such as

    { name => "flavour",
      type => "enum",
      choices => ["strawberry","chocolate"],
    }

C<minimum> and C<maximum> are omitted (or C<undef>) if there's no hard limit
on the parameter.

C<share_key> is designed to indicate when parameters from different NumSeq
classes can be a single control widget in a GUI etc.  Normally the C<name>
is enough, but when the same name has slightly different meanings in
different classes a C<share_key> allows the same meanings to be matched up.

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
squares this would return true if C<$value> is a square or false if not.

=item C<$i = $seq-E<gt>value_to_i_floor($value)>

Return the index i of C<$value>, or if C<$value> doesn't occur in the
sequence then the i of the next lower value which does.  This method only
exists for non-decreasing sequences.

=item C<$i = $seq-E<gt>value_to_i_estimate($value)>

Return an estimate of the i value corresponding to C<$value>.  This method
only exists for non-decreasing sequences, and the accuracy of the estimate
is unspecified, but when available it can at least hint at the growth rate.

=back

=head1 SEE ALSO

=for my_pod see_also begin

L<Math::NumSeq::Squares>,
L<Math::NumSeq::Cubes>,
L<Math::NumSeq::Pronic>,
L<Math::NumSeq::Triangular>,
L<Math::NumSeq::Polygonal>,
L<Math::NumSeq::Tetrahedral>,
L<Math::NumSeq::StarNumbers>,
L<Math::NumSeq::Powerful>
L<Math::NumSeq::PowerPart>

L<Math::NumSeq::Even>,
L<Math::NumSeq::Odd>,
L<Math::NumSeq::All>,
L<Math::NumSeq::AllDigits>

L<Math::NumSeq::Primes>,
L<Math::NumSeq::TwinPrimes>,
L<Math::NumSeq::SophieGermainPrimes>,
L<Math::NumSeq::AlmostPrimes>,
L<Math::NumSeq::Emirps>,
L<Math::NumSeq::MobiusFunction>,
L<Math::NumSeq::LiouvilleFunction>,
L<Math::NumSeq::PrimeFactorCount>,
L<Math::NumSeq::DivisorCount>,
L<Math::NumSeq::PythagoreanHypots>

L<Math::NumSeq::Totient>,
L<Math::NumSeq::TotientCumulative>,
L<Math::NumSeq::TotientSteps>,
L<Math::NumSeq::TotientStepsSum>,
L<Math::NumSeq::TotientPerfect>,
L<Math::NumSeq::Abundant>,
L<Math::NumSeq::PolignacObstinate>

L<Math::NumSeq::Factorials>,
L<Math::NumSeq::Primorials>,
L<Math::NumSeq::Fibonacci>,
L<Math::NumSeq::FibonacciWord>,
L<Math::NumSeq::LucasNumbers>,
L<Math::NumSeq::Fibbinary>,
L<Math::NumSeq::FibbinaryBitCount>,
L<Math::NumSeq::Pell>,
L<Math::NumSeq::Tribonacci>,
L<Math::NumSeq::Perrin>

L<Math::NumSeq::FractionDigits>,
L<Math::NumSeq::SqrtDigits>,
L<Math::NumSeq::SqrtEngel>,
L<Math::NumSeq::SqrtContinued>,
L<Math::NumSeq::SqrtContinuedPeriod>

L<Math::NumSeq::DigitCount>,
L<Math::NumSeq::DigitCountLow>,
L<Math::NumSeq::DigitCountHigh>

L<Math::NumSeq::DigitLength>,
L<Math::NumSeq::DigitLengthCumulative>,
L<Math::NumSeq::DigitProduct>,
L<Math::NumSeq::DigitSum>,
L<Math::NumSeq::DigitSumModulo>,
L<Math::NumSeq::RadixWithoutDigit>

L<Math::NumSeq::Palindromes>,
L<Math::NumSeq::Beastly>,
L<Math::NumSeq::Repdigits>,
L<Math::NumSeq::RepdigitAny>,
L<Math::NumSeq::RepdigitRadix>,
L<Math::NumSeq::HarshadNumbers>,
L<Math::NumSeq::HappyNumbers>,
L<Math::NumSeq::HappySteps>

L<Math::NumSeq::CullenNumbers>,
L<Math::NumSeq::ProthNumbers>,
L<Math::NumSeq::WoodallNumbers>,
L<Math::NumSeq::BaumSweet>,
L<Math::NumSeq::KlarnerRado>,
L<Math::NumSeq::UlamSequence>,
L<Math::NumSeq::ReRound>,
L<Math::NumSeq::MephistoWaltz>

L<Math::NumSeq::CollatzSteps>,
L<Math::NumSeq::ReverseAdd>,
L<Math::NumSeq::ReverseAddSteps>,
L<Math::NumSeq::JugglerSteps>,
L<Math::NumSeq::SternDiatomic>,
L<Math::NumSeq::NumAronson>

L<Math::NumSeq::Kolakoski>,
L<Math::NumSeq::GolombSequence>,
L<Math::NumSeq::AsciiSelf>,
L<Math::NumSeq::Multiples>,
L<Math::NumSeq::Modulo>

L<Math::NumSeq::Expression>,
L<Math::NumSeq::File>,
L<Math::NumSeq::OEIS>

=for my_pod see_also end

L<Math::NumSeq::Aronson> (in the Math-Aronson dist)

L<Math::NumSeq::PlanePathCoord>, L<Math::NumSeq::PlanePathDelta>,
L<Math::NumSeq::PlanePathTurn> (in the Math-PlanePath dist)

=head2 Other Modules Etc

L<Math::Sequence> and L<Math::Series>, for symbolic recursive sequence
definitions

L<math-image>

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
