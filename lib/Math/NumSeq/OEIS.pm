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

package Math::NumSeq::OEIS;
use 5.004;
use strict;
use Carp;

use vars '$VERSION','@ISA';
$VERSION = 43;

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

=for stopwords Ryde Math-NumSeq NumSeq ie OEIS Online ithreads ascii utf eg cofr recognised booleans

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
local files if available.  See L<Math::NumSeq::OEIS::Catalogue> for querying
available A-numbers.

=head2 Files

Files should be in an F<OEIS> directory in the user's home directory (see
L<File::HomeDir>).  Files can be HTML, OEIS internal, B-file, and/or A-file.

    ~/OEIS/A000032.html
    ~/OEIS/A000032.internal
    ~/OEIS/b000032.txt
    ~/OEIS/a000032.txt

    downloaded from:
    http://oeis.org/A000032
    http://oeis.org/A000032/internal
    http://oeis.org/A000032/b000032.txt
    http://oeis.org/A000032/a000032.txt

The "internal" format is more reliable than the HTML for parsing.  The
B-file or A-file can be used alone, but in that case there's no
C<$seq-E<gt>description()> and it may limit the
C<$seq-E<gt>characteristic()> attributes.

The F<b000000.txt> file is a long list of values.  The F<a000000.txt> too
and longer, but sometimes an auxiliary info.  Some sequences don't have
these, only 30 or 40 sample values from the HTML or internal page.  Those
few samples might be enough for fast growing sequences.

=head2 Other Notes

Sometimes more than one NumSeq module generates an OEIS sequence.  For
example A000290 both from Squares and from Polygonal k=4.
C<Math::NumSeq::OEIS> tries to give the better or faster one.

Sometimes the OEIS has duplicates, ie. two A-numbers which are the same
sequence.  Both are catalogued so they both give NumSeq module code, but the
C<$seq-E<gt>oeis_anum()> method will read back as whichever is the "primary"
one.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::OEIS-E<gt>new (anum =E<gt> 'A000000')>

Create and return a new sequence object.

=item C<($i, $value) = $seq-E<gt>next()>

Return the next index and value in the sequence.

In the current code when reading from a file any values bigger than a usual
Perl IV or NV are returned as C<Math::BigInt> objects.  Is that a good idea?
It preserves precision.

An F<a000000.txt> or F<b000000.txt> is read progressively.  There's a Perl
5.8 ithreads C<CLONE> which re-opens in a new thread so the C<$seq> in each
thread has its own position.  But that doesn't help a C<fork()> so care
should be taken that only one of the parent or child use the C<$seq> in that
case, the same as for most open files when forking.  Is this a good idea?

=item C<$str = $seq-E<gt>description()>

Return a human-readable description of the sequence.  For the downloaded
files this is the "name" part, a short description of the sequence.

A few sequences may have non-ascii characters in the description.  For Perl
5.8 and up they're decoded to wide-chars.  Not sure what to do for earlier
Perl, currently they're left as whatever bytes the download gave, probably
utf-8.

=item C<$value = $seq-E<gt>values_min()>

=item C<$value = $seq-E<gt>values_max()>

Return the minimum or maximum value taken by values in the sequence, or
C<undef> if unknown or infinity.

For files C<values_min()> is guessed from the first few values if
non-negative, but C<values_max()> considered to be infinite.  If the range
seems to be limited (eg. sequences of -1,0,1) then min and max are obtained,
and also for "full" sequences where the samples are all the values.

=item C<$ret = $seq-E<gt>characteristic($key)>

For a file the various standard characteristics are obtained as follows

=over

=item *

"increasing", "non_decreasing" and "smaller" are determined from
the sample values or the first few values from a a-file or b-file.  Looking
at only the few values ensures a big file isn't read in its entirety and is
normally enough.  The intention would be to try to look at enough values not
to be tricked by decreasing values after the first few, etc.

=item * 

"digits" is from KEYWORDS "cons" for decimal constants.  Some other digit
sequences are recognised by their DESCRIPTION part though this may be
unreliable.

=item * 

"count" is obtained from a DESCRIPTION with "number of".  This is probably
unreliable.

=item *

All the "KEYWORDS" from the OEIS are provided as booleans under
names "OEIS_easy" etc.  So for example

    if ($seq->characteristic("OEIS_nice")) {
      print "nooiice ...\n";
    }

=back

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::OEIS::Catalogue>

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
