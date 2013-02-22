#!/usr/bin/perl -w

# Copyright 2013 Kevin Ryde

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

use 5.006;
use strict;
use warnings;

#use Smart::Comments;


{
  unlink '/tmp/tie-file.txt';
  system 'echo one >/tmp/tie-file.txt';
  system 'echo two >>/tmp/tie-file.txt';
  system 'echo three >>/tmp/tie-file.txt';
  system 'cat /tmp/tie-file.txt';
  my @array; # = (1,2,3);
  require Tie::File;
  tie @array, 'Tie::File', '/tmp/tie-file.txt' or die;
  foreach my $i (-7 .. 5) {
    my $e = (exists $array[$i] ? "E" : "n");
    print "$i $e\n";
  }
  exit 0;
}
