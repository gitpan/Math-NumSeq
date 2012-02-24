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


# characteristic('increasing')
# characteristic('integer')
#    only by reading the whole file
#    assume seekable



package Math::NumSeq::File;
use 5.004;
use strict;
use Carp;
use Fcntl;

use vars '$VERSION', '@ISA';
$VERSION = 35;
use Math::NumSeq;
@ISA = ('Math::NumSeq');


# uncomment this to run the ### lines
#use Smart::Comments;

# use constant name => Math::NumSeq::__('File');
use constant description => Math::NumSeq::__('Numbers from a file');
use constant parameter_info_array =>
  [ { name    => 'filename',
      type    => 'filename',
      display => Math::NumSeq::__('Filename'),
      width   => 40,
      default => '',
    } ];

sub rewind {
  my ($self) = @_;
  ### Values-File rewind()

  if ($self->{'fh'}) {
    seek $self->{'fh'}, 0, Fcntl::SEEK_SET() # parens because autoloaded ...
      or croak "Cannot rewind ",$self->{'filename'},": ",$!;
  } else {
    my $filename = $self->{'filename'};
    if (defined $filename && $filename !~ /^\s*$/) {
      my $fh;
      ($] >= 5.006
       ? open $fh, '<', $filename
       : open $fh, "< $filename")
        or croak "Cannot open ",$filename,": ",$!;
      $self->{'fh'} = $fh;
    }
  }
  $self->{'i'} = -1;
}

sub next {
  my ($self) = @_;
  my $fh = $self->{'fh'} || return;
  for (;;) {
    my $line = readline $fh;
    if (! defined $line) {
      return;
    }
    if ($line =~ /^\s*(-?\d+)(\s+(-?(\d+(\.\d*)?|\.\d+)))?/) {
      if (defined $3) {
        return ($self->{'i'} = $1, $3);
      } else {
        return (++$self->{'i'}, $1);
      }
    }
  }
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::File -- sequence read from a file

=head1 SYNOPSIS

 use Math::NumSeq::File;
 my $seq = Math::NumSeq::File->new (filename => 'foo.txt');
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

A sequence of values read from a file.  This is designed to read a file of
numbers in NumSeq style.

The intention is to be flexible about the file format and to auto-detect as
far as possible.  Currently the only format is plain text, either a single
value per line, or a pair i index and value.

    123                   # one value per line
    456

    1  123                # i and value per line
    2  456

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::File-E<gt>new (filename =E<gt> $filename)>

Create and return a new sequence object to read C<$filename>.

=back

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
