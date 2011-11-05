#!/usr/bin/perl -w

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

use 5.004;
use strict;
use HTML::Entities::Interpolate;
use URI::Escape;

# uncomment this to run the ### lines
#use Smart::Comments;

{
  open OUT, ">/tmp/find.html" or die;
  print OUT <<HERE or die;
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>start</title>
</head>
<body>
HERE

  my $count = 0;
  require App::MathImage::Generator;
  foreach my $module (App::MathImage::Generator->values_choices) {
    next if $module eq 'File';
    next if $module eq 'Expression';
    next if $module eq 'OEIS';
    next if $module eq 'CunninghamPrimes'; # broken
    next if $module eq 'PlanePathDelta'; # not yet
    next if $module eq 'PlanePathN'; # not yet
    next if $module eq 'PlanePathTurn'; # not yet
    my $class = App::MathImage::Generator->values_class($module);
    print "$class\n";

    print OUT <<HERE or die;
<p>
$class
HERE

    my @parameters = ([]);
    foreach my $info ($class->parameter_info_list) {
      if ($info->{'choices'}) {
        my @new_parameters;
        foreach my $p (@parameters) {
          foreach my $choice (@{$info->{'choices'}}) {
            push @new_parameters, [ @$p, $info->{'name'}, $choice ];
          }
        }
        @parameters = @new_parameters;
        next;
      }

      if ($info->{'type'} eq 'boolean') {
        my @new_parameters;
        foreach my $p (@parameters) {
          foreach my $choice (0, 1) {
            push @new_parameters, [ @$p, $info->{'name'}, $choice ];
          }
        }
        @parameters = @new_parameters;
        next;
      }

      if ($info->{'type'} eq 'integer'
          || $info->{'name'} eq 'multiples') {
        my $max = $info->{'minimum'}+10;
        if ($info->{'name'} eq 'radix') { $max = 17; }
        if ($info->{'name'} eq 'modulus') { $max = 32; }
        if ($info->{'name'} eq 'polygonal') { $max = 32; }
        if ($info->{'name'} eq 'factor_count') { $max = 12; }
        if (defined $info->{'maximum'} && $max > $info->{'maximum'}) {
          $max = $info->{'maximum'};
        }
        if ($info->{'name'} eq 'power' && $max > 6) { $max = 6; }
        my @new_parameters;
        foreach my $choice ($info->{'minimum'} .. $max) {
          foreach my $p (@parameters) {
            push @new_parameters, [ @$p, $info->{'name'}, $choice ];
          }
        }
        @parameters = @new_parameters;
        next;
      }
      print "  skip parameter $info->{'name'}\n";
    }

  PARAMETERS: foreach my $p (@parameters) {
      ### $p
      my $seq = $class->new (hi => 1000, @$p);
      next if $seq->oeis_anum;

      my $values = '';
      my (undef, $first_value) = $seq->next or next PARAMETERS;
      while (length($values) < 120) {
        my ($i, $value) = $seq->next
          or last;
        defined $value or next PARAMETERS;
        $value == int($value) or next PARAMETERS;
        if ($values ne '') {
          $values .= ', ';
        }
        $values .= $value;
      }

      my $values_escaped = URI::Escape::uri_escape($values);
      print OUT "<br>\n" or die;
      while (@$p) {
        print OUT shift @$p, "=", shift @$p;
        if (@$p) {
          print OUT ",  ";
        }
      }
      print OUT "\n" or die;
      print OUT <<HERE or die;
$first_value, <a href="http://oeis.org/search?q=$values_escaped&sort=&language=english&go=Search">$values</a>
HERE
      $count++;
    }
    print OUT "</p>\n" or die;
  }

  print OUT <<HERE or die;
</body>
</html>
HERE
  close OUT or die;

  print "total $count\n";
  exit 0;
}
