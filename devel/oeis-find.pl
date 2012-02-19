#!/usr/bin/perl -w

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

use 5.004;
use strict;
use HTML::Entities::Interpolate;
use List::Util;
use URI::Escape;
use Module::Load;

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
    next if $module =~ 'CunninghamPrimes'; # broken
    next if $module =~ 'PlanePathTurn'; # not yet

    # restricted to ...
    # next unless $module =~ 'BinaryUnd';

    my $class = App::MathImage::Generator->values_class($module);
    print "$class\n";

    print OUT <<HERE or die;
<p>
$class
HERE

    my $parameters = parameter_info_list_to_parameters($class->parameter_info_list);

  PARAMETERS: foreach my $p (@$parameters) {
      ### $p
      my $seq = $class->new (hi => 1000, @$p);
      next if $seq->oeis_anum;

      my $values = '';
      my @values;
      my (undef, $first_value) = $seq->next or next PARAMETERS;
      my $target_values_length = 120;
      if ($class =~ /BinaryUnd/) { $target_values_length = 20; }
      while (length($values) < 120) {
        my ($i, $value) = $seq->next
          or last;
        defined $value or next PARAMETERS;
        $value == int($value) or next PARAMETERS;
        if ($values ne '') {
          $values .= ', ';
        }
        $values .= $value;
        push @values, $value;
      }
      next if (@values < 5);

      my $p_string = '';
      while (@$p) {
        $p_string .= shift(@$p) . "=" . shift(@$p);
        if (@$p) {
          $p_string .= ",  ";
        }
      }

      my $signed='';
      if (defined (List::Util::first {$_<0} @values)) {
        $signed = 'signed:';
      }

      special_values($module, $p_string, \@values);

      my $values_escaped = URI::Escape::uri_escape($values);
      print OUT "<br>\n$p_string\n" or die;

      print OUT <<HERE or die;
$first_value, <a href="http://oeis.org/search?q=$signed$values_escaped&sort=&language=english&go=Search">$values</a>
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


sub special_values {
  my ($module, $params, $values_aref) = @_;
  return unless @$values_aref;
  return if $module eq 'SqrtDigits';

  if (all_same(@$values_aref)) {
    print "$module $params:\n  all same $values_aref->[0]   length $#$values_aref\n";

  } elsif (defined (my $diff = constant_diff(@$values_aref))) {
    print "$module $params:\n  constant increment $diff\n";
    print "  ",join(',',@$values_aref),"\n";

  } elsif (is_squares(@$values_aref)) {
    print "$module $params: squares\n";
  }
}
sub is_squares {
  my $value = shift;
  return 0 unless $value >= 0;
  my $root = sqrt($value);
  return 0 unless $root==int($root);
  while (@_) {
    $value = shift;
    unless ($value >= 0 && sqrt($value) == ++$root) {
      return 0;
    }
  }
  return 1;
}
sub constant_diff {
  my $diff = shift;
  my $value = shift;
  $diff = $value - $diff;
  while (@_) {
    my $next_value = shift;
    if ($next_value - $value != $diff) {
      return undef;
    }
    $value = $next_value;
  }
  return $diff;
}
sub all_same {
  my $value = shift;
  while (@_) {
    if ($value != shift) {
      return 0;
    }
  }
  return 1;
}

sub parameter_info_list_to_parameters {
  my @parameters = ([]);
  foreach my $info (@_) {
    info_extend_parameters($info,\@parameters);
  }
  return \@parameters;
}

sub info_extend_parameters {
  my ($info, $parameters) = @_;
  my @new_parameters;

  if ($info->{'name'} eq 'planepath') {
    my @strings;
    foreach my $choice (@{$info->{'choices'}}) {
      my $path_class = "Math::PlanePath::$choice";
      Module::Load::load($path_class);

      my @parameter_info_list = $path_class->parameter_info_list;

      if ($path_class->isa('Math::PlanePath::Rows')) {
        push @parameter_info_list,{ name       => 'width',
                                    type       => 'integer',
                                    width      => 3,
                                    default    => '1',
                                    minimum    => 1,
                                  };
      }
      if ($path_class->isa('Math::PlanePath::Columns')) {
        push @parameter_info_list, { name       => 'height',
                                     type       => 'integer',
                                     width      => 3,
                                     default    => '1',
                                     minimum    => 1,
                                   };
      }

      my $path_parameters
        = parameter_info_list_to_parameters(@parameter_info_list);
      ### $path_parameters

      foreach my $aref (@$path_parameters) {
        my $str = $choice;
        while (@$aref) {
          $str .= "," . shift(@$aref) . '=' . shift(@$aref);
        }
        push @strings, $str;
      }
    }
    ### @strings
    foreach my $p (@$parameters) {
      foreach my $choice (@strings) {
        push @new_parameters, [ @$p, $info->{'name'}, $choice ];
      }
    }
    @$parameters = @new_parameters;
    return;
  }

  if ($info->{'name'} eq 'arms') {
    print "  skip parameter $info->{'name'}\n";
    return;
  }

  if ($info->{'choices'}) {
    my @new_parameters;
    foreach my $p (@$parameters) {
      foreach my $choice (@{$info->{'choices'}}) {
        next if ($info->{'name'} eq 'rotation_type' && $choice eq 'custom');
        push @new_parameters, [ @$p, $info->{'name'}, $choice ];
      }
    }
    @$parameters = @new_parameters;
    return;
  }

  if ($info->{'type'} eq 'boolean') {
    my @new_parameters;
    foreach my $p (@$parameters) {
      foreach my $choice (0, 1) {
        push @new_parameters, [ @$p, $info->{'name'}, $choice ];
      }
    }
    @$parameters = @new_parameters;
    return;
  }

  if ($info->{'type'} eq 'integer'
      || $info->{'name'} eq 'multiples') {
    my $max = $info->{'minimum'}+10;
    if ($info->{'name'} eq 'rule') { $max = 255; }
    if ($info->{'name'} eq 'round_count') { $max = 20; }
    if ($info->{'name'} eq 'straight_spacing') { $max = 2; }
    if ($info->{'name'} eq 'diagonal_spacing') { $max = 2; }
    if ($info->{'name'} eq 'radix') { $max = 17; }
    if ($info->{'name'} eq 'realpart') { $max = 3; }
    if ($info->{'name'} eq 'wider') { $max = 3; }
    if ($info->{'name'} eq 'modulus') { $max = 32; }
    if ($info->{'name'} eq 'polygonal') { $max = 32; }
    if ($info->{'name'} eq 'factor_count') { $max = 12; }
    if (defined $info->{'maximum'} && $max > $info->{'maximum'}) {
      $max = $info->{'maximum'};
    }
    if ($info->{'name'} eq 'power' && $max > 6) { $max = 6; }
    my @new_parameters;
    foreach my $choice ($info->{'minimum'} .. $max) {
      foreach my $p (@$parameters) {
        push @new_parameters, [ @$p, $info->{'name'}, $choice ];
      }
    }
    @$parameters = @new_parameters;
    return;
  }

  if ($info->{'name'} eq 'fraction') {
    ### fraction ...
    my @new_parameters;
    foreach my $p (@$parameters) {
      my $radix = p_radix($p) || die;
      foreach my $den (995 .. 1021) {
        next if $den % $radix == 0;
        my $choice = "1/$den";
        push @new_parameters, [ @$p, $info->{'name'}, $choice ];
      }
      foreach my $num (2 .. 10) {
        foreach my $den ($num+1 .. 15) {
          next if $den % $radix == 0;
          next unless _coprime($num,$den);
          my $choice = "$num/$den";
          push @new_parameters, [ @$p, $info->{'name'}, $choice ];
        }
      }
    }
    @$parameters = @new_parameters;
    return;
  }

  print "  skip parameter $info->{'name'}\n";
}

# return true if coprime
sub _coprime {
  my ($x, $y) = @_;
  ### _coprime(): "$x,$y"
  if ($y > $x) {
    ($x,$y) = ($y,$x);
  }
  for (;;) {
    if ($y <= 1) {
      ### result: ($y == 1)
      return ($y == 1);
    }
    ($x,$y) = ($y, $x % $y);
  }
}

sub p_radix {
  my ($p) = @_;
  for (my $i = 0; $i < @$p; $i += 2) {
    if ($p->[$i] eq 'radix') {
      return $p->[$i+1];
    }
  }
  return undef;
}
