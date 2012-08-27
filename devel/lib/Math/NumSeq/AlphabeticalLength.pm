# Copyright 2012 Kevin Ryde

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

package Math::NumSeq::AlphabeticalLength;
use 5.004;
use strict;
use List::Util 'min';

use vars '$VERSION', '@ISA';
$VERSION = 50;
use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('...');
use constant description => Math::NumSeq::__('Length of i written out in words.');
use constant default_i_start => 1;
use constant characteristic_count => 1;
use constant characteristic_smaller => 1;
use constant characteristic_integer => 1;

use constant _HAVE_LINGUA_ANY_NUMBERS =>
  eval { require Lingua::Any::Numbers; 1 };

use constant::defer parameter_info_array => sub {
  require Lingua::Any::Numbers;
  my @choices;
  if (_HAVE_LINGUA_ANY_NUMBERS) {
    @choices = Lingua::Any::Numbers::available();
  }
  @choices = sort @choices;
  my $en;
  @choices = map { $_ eq 'EN' ? do { $en=1; () } : $_ } @choices;
  if ($en) {
    unshift @choices, 'EN';
  }
  return [
          {
           name        => 'language',
           type        => 'string',
           default     => 'EN',
           choices     => \@choices,
           width       => 8,
           # description => Math::NumSeq::__('...'),
          },
          {
           name            => 'number_type',
           type            => 'enum',
           default         => 'cardinal',
           choices         => ['cardinal','ordinal'],
           choices_display => [Math::NumSeq::__('Cardinal'),
                               Math::NumSeq::__('Ordinal')],
           # description => Math::NumSeq::__('...'),
          },
          # Not through Lingua::Any::Numbers interface
          # {
          #  name        => 'gender',
          #  type        => 'enum',
          #  default     => 'M',
          #  choices     => ['M','F','N'],
          #  # description => Math::NumSeq::__('...'),
          # },
          # {
          #  name        => 'declension',
          #  type        => 'enum',
          #  default     => 'nominative',
          #  choices     => ['nominative','genitive','dative','accusative','ablative'],
          #  # description => Math::NumSeq::__('...'),
          # },
         ];
};

sub values_min {
  my ($self) = @_;
  ### values_min(): $self
  my $i_start = $self->i_start;
  return ($self->{'values_min'}
          = min (map {$self->ith($_)||0}
                 $i_start .. $i_start + 20));
}

#------------------------------------------------------------------------------
# cf A052360 en cardinal including spaces and hyphens
#    A052363 new longest alpha
#    A134629 first requiring n letters
#
# A003078 (Danish) DK
# A001050 (Finnish) FI
# A001368 (Irish Gaelic) GA
# A006968 or A092196 (Roman numerals)
# A051785 (Catalan) CA
# A056597 (Serbian or Croatian) SR
# A132984 (Latin) LA
# A140395 (Hindi) HI
# A053306 (Galego)
# A140396 (Welsh) CY
# A140438 (Tamil) TA
# A014656 (Bokmal) NB, was NO   Lingua::NO::Num2Word
# A028292 (Nynorsk) NN

# catalogued in Alpha.pm
my %oeis_anum
  = ('en,cardinal,0' => 'A005589',
     'en,ordinal,1'  => 'A006944',

     # Lingua::CS::Num2Word doubtful ...
     'cs,cardinal,1' => 'A010038', # Czech, Lingua::CS::Num2Word

     # Lingua::DE::Num2Word doubtful ...
     # 'de,cardinal,1' => 'A007208', # German, Lingua::DE::Num2Word

     'eo,cardinal,0' => 'A057853', # Esperanto, Lingua::EO::Numbers

     'es,cardinal,0' => 'A011762', # Spanish, Lingua::ES::Numeros

     'fr,ordinal,1' => 'A006969', # French, Lingua::FR::Numbers
     'fr,cardinal,0,incspaces' => 'A007005',

     'hu,cardinal,1' => 'A007292', # Hungarian, Lingua::HU::Numbers

     # Not quite, centottanta in A026858 vs centoottanta in Lingua
     # 'it,cardinal,0' => 'A026858', # Italian, Lingua::IT::Numbers

     'ja,cardinal,0' => 'A030166', # Japanese Kanji, Lingua::JA::Numbers

     'nl,cardinal,1' => 'A090589', # Dutch, Lingua::NL::Numbers
     # cf A007485 ij as one letter

     # Not sure about 11=ellve cf A014656(11)=6
     # # Bokmal NO, lately code change to NB
     # 'no,cardinal,1' => 'A014656', # Lingua::NO::Num2Word
     #
     # cf A028292 Nynorsk A028292(1)=3
     # 'nn,cardinal,1' => 'A028292',

     'pl,cardinal,0' => 'A008962', # Polish, Lingua::PL::Numbers

     # No, Brazilian Portuguese "catorze" cf "quatorze"
     # 'pt,cardinal,1' => 'A057696',  # Lingua::PT::Nums2Words

     # No, Lingua::RU::Number 0.05 is money amounts only.
     # 'ru,cardinal,1' => 'A006994', # Russian, Lingua::RU::Number

     'sv,cardinal,0' => 'A059124', # Swedish, Lingua::SV::Numbers

     'tr,cardinal,1' => 'A057435', # Turkish, Lingua::TR::Numbers
    );
sub oeis_anum {
  my ($self) = @_;
  ### oeis_anum: $self
  ### key: "\L$self->{language}\E,$self->{number_type},".$self->i_start

  return $oeis_anum
    {"\L$self->{language}\E,$self->{number_type},".$self->i_start};
}

#------------------------------------------------------------------------------

sub new {
  my $self = shift->SUPER::new(@_);

  if ($self->{'language'} eq 'sv') {
    my $str = Lingua::Any::Numbers::to_string (2, 'sv');
    ### $str
    if (length($str) == 4) {
      # Lingua::SV::Numbers gives utf-8 bytes, mangle it down to chars
      ### decode_chars mangle out utf8 ...
      $self->{'decode_chars'} = sub {
        $_[0] =~ s/\303./X/g;
      };
    }
  }
  return $self;
}

sub ith {
  my ($self, $i) = @_;
  ### AlphabeticalLength ith(): "$i"
  _HAVE_LINGUA_ANY_NUMBERS or return undef;

  if (_is_infinite($i)) {
    return undef;
  }

  my $str;
  if ($self->{'number_type'} eq 'ordinal') {
    $str = Lingua::Any::Numbers::to_ordinal ($i, $self->{'language'});
    if ($str eq $i) {
      # some modules without ordinal support return $i as numerals unchanged
      return undef;
    }

  } else {
    if ($self->{'language'} eq 'eo' && $i == 1) {
      # HACK: avoid warn() from num2eo(1) in Lingua::EO::Numbers 0.03
      $str = 'unu';
    } else {
      $str = Lingua::Any::Numbers::to_string ($i, $self->{'language'});
    }
  }
  if (my $decode_chars = $self->{'decode_chars'}) {
    $decode_chars->($str);
  }
  ### language: $self->{'language'}
  ### $str

  my $count = 0;
  while ($str =~ /(\w|[^[:ascii:]])/g) {
    $count += length($1);
  }
  ### $count
  return $count;

  # ### letters only: $str
  # counting whitespace ...
  # $str =~ s/[^[:word:][:space:]]//g;
  # return length($str);
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::AlphabeticalLength -- length of numbers written in words

=head1 SYNOPSIS

 use Math::NumSeq::AlphabeticalLength;
 my $seq = Math::NumSeq::AlphabeticalLength->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

I<In progress ...>

This is how many letters in each i written out in words.  For example i=12
is value 6 because "twelve" has 6 letters.

    starting i=1
    3, 3, 5, 4, 4, 3, 5, 5, 4, 3, 6, 6, 8, 8, 7, 7, 9, 8, 8, ...

Only letters are counted.  Any spaces, hyphenation or accenting is ignored.

=head2 Language

The default is English, or the C<language> option can select anything known
to C<Lingua::Any::Numbers>.  For example in French i=2 has value 4 for 4
letters in "deux".

    language => 'fr'
    2, 4, 5, 6, 4, 3, 4, 4, 4, 3, 4, 5, 6, 8, ...

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::AlphabeticalLength-E<gt>new ()>

=item C<$seq = Math::NumSeq::AlphabeticalLength-E<gt>new (language =E<gt> $str)>

Create and return a new sequence object.

=back

=head2 Random Access

=over

=item C<$value = $seq-E<gt>ith($i)>

Return the number of letters in C<$i> written out in the selected language.

=cut

# =item C<$i = $seq-E<gt>i_start ()>
# 
# Return 1, the first term in the sequence being at i=1.

=back

=head1 BUGS

Some of the modules C<Lingua::Any::Numbers> uses return utf-8 bytes.  When
this happens C<length()> of "\w" word chars is not the length in letters.
The current code notices and decodes "Lingua::SV::Numbers" utf-8, but other
modules might give incorrect lengths.

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::DigitLength>

L<Lingua::Any::Numbers>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2012 Kevin Ryde

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
