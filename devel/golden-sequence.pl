#!/usr/bin/perl -w

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

require 5;
use strict;

# uncomment this to run the ### lines
#use Smart::Comments;

{
  my @values = (0);
  print join('',@values),"\n";
  foreach (1 .. 8) {
    my $oldlen = scalar(@values);
    @values = map { $_ ? (0) : (0, 1) } @values;
    my $newlen = scalar(@values);

    my $old = join('', @values[0 .. $newlen-$oldlen-1]);
    my $new = join('', @values[$oldlen .. $newlen-1]);
    my $eq = ($old eq $new ? "eq" : "ne");

    my $str = join('',@values);
    substr($str,$oldlen,0) = '-';
    print "len $newlen   $eq   $str\n";
  }

  # print "ith()         ";
  # foreach my $i (0 .. $#values) {
  #   print ith($i);
  # }
  # print "\n";
      
  # require Math::NumSeq::Fibbinary;
  # my $seq = Math::NumSeq::Fibbinary->new;
  # print "             ";
  # foreach my $i (0 .. $#values) {
  #   print $seq->pred($i) ? '0' : '1';
  # }
  # print "\n";

  exit 0;
}

