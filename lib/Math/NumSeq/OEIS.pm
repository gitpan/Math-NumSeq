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

package Math::NumSeq::OEIS;
use 5.004;
use strict;
use Carp;

use vars '$VERSION','@ISA';
$VERSION = 26;

use Math::NumSeq;
@ISA = ('Math::NumSeq');

# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('OEIS');
use constant description => Math::NumSeq::__('OEIS sequence, by its A-number.  There\'s code for some sequences, others look in ~/OEIS directory for downloaded files A123456.internal, A123456.html and/or b123456.txt.');
use constant characteristic_integer => 1;

# recalculated each time for updated file min/max
sub parameter_info_array {
  require Math::NumSeq::OEIS::Catalogue;
  return [
          { name      => 'anum',
            type      => 'string',
            display   => Math::NumSeq::__('OEIS A-number'),
            type_hint => 'oeis_anum',
            width     => 8,
            minimum   => Math::NumSeq::OEIS::Catalogue->anum_first,
            maximum   => Math::NumSeq::OEIS::Catalogue->anum_last,
            default   => 'A000290', # Squares, an arbitrary choice
          },
         ];
}
### parameter_info_array parameter_info_array()

sub oeis_anum {
  my ($self) = @_;
  return $self->{'oeis_anum'};
}

sub new {
  my ($class, %options) = @_;
  ### Values-OEIS: @_

  my $anum = $options{'anum'};
  if (! defined $anum) {
    $anum = parameter_info_array()->[0]->{'default'};
  }
  ### $anum

  require Math::NumSeq::OEIS::Catalogue;
  my $info = Math::NumSeq::OEIS::Catalogue->anum_to_info($anum)
    || croak 'Unknown OEIS sequence ',$anum;
  ### $info

  my $numseq_class = $info->{'class'};
  my $parameters = $info->{'parameters'};
  require Module::Load;
  Module::Load::load($numseq_class);
  return $numseq_class->new (%options, ($parameters ? @$parameters : ()));
}

1;
__END__

=for stopwords Ryde Math-NumSeq NumSeq ie OEIS Online

=head1 NAME

Math::NumSeq::OEIS -- number sequence by OEIS A-number

=head1 SYNOPSIS

 use Math::NumSeq::OEIS;
 my $seq = Math::NumSeq::OEIS->new (anum => 'A000032');
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

This module selects a NumSeq by its Online Encyclopedia of Integer Sequences
A-number.

If there's NumSeq code implementing the sequence then that's used, otherwise
files if available.  See L<Math::NumSeq::OEIS::Catalogue> for querying the
available A-numbers.

Files should be in an F<OEIS> directory in the user's home directory.  It
can be the HTML, "internal" format, B-file, or A-file.

    ~/OEIS/A000032.html
    ~/OEIS/A000032.internal
    ~/OEIS/b000032.txt
    ~/OEIS/a000032.txt

    downloaded from:
    http://oeis.org/A000032
    http://oeis.org/A000032/internal
    http://oeis.org/A000032/b000032.txt
    http://oeis.org/A000032/a000032.txt

The "internal" format is more reliable for parsing than the HTML.  The
B-file or A-file alone can be used, but in that case there's no
C<$seq-E<gt>description()> and only a few of the
C<$seq-E<gt>characteristic()> attributes.

The F<a000000.txt> or F<b000000.txt> files are generally a long list of
values (the F<a.txt> longer than the F<b.txt>, when available).  Some
sequences don't have them, only 30 or 40 sample values from HTML or internal
page.  Those few samples might be enough for fast growing sequences.

Sometimes more than one NumSeq module can generate a given OEIS sequence.
For example Squares and Polygonal k=4 are both A000290.
C<Math::NumSeq::OEIS> tries to give the better or faster one.

Sometimes the OEIS has duplicates, ie. two A-numbers which are the same
sequence.  The code modules are setup with both A-numbers, where known, but
the C<$seq-E<gt>oeis_anum()> method will generally read back as whichever is
the "primary" one.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::OEIS-E<gt>new (anum =E<gt> 'A000000')>

Create and return a new sequence object.

=back

=head1 BUGS

There's a hard-coded stop at file values bigger than an IV or an NV mantissa
(whichever is larger).  The idea is not to lose precision reading into a
float.  Perhaps reading into C<Math::BigInt> would be better, but perhaps
when reading progressively unlike the current code which slurps the file in
one go.

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::OEIS::Catalogue>

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
