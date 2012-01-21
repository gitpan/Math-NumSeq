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
$VERSION = 30;
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
