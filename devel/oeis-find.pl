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
<title>oeis-find</title>
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
    next if $module =~ /KaprekarNumbers/; # bit slow yet
    
    # restricted to ...
    # next unless $module =~ /Aron/;
    next unless $module =~ /PlanePathN/;
    # next unless $module =~ /AllPr/;
    
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
      my (undef, $first_value) = $seq->next
        or next PARAMETERS;
      my $target_values_length = 120;
      if ($class =~ /BinaryUnd/) { $target_values_length = 20; }
      while (length($values) < 120) {
        my ($i, $value) = $seq->next
          or last;
        if ($module =~ /KaprekarNumbers/ && length($value) > 4) {
          last;
        }
        if (! defined $value) {
          die "Oops $module @$p returned value undef";
        }
        $value == int($value) or next PARAMETERS; # not an integer seq
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
      
      special_values($module, $p_string, $seq, \@values);
      
      my $values_escaped = URI::Escape::uri_escape($values);
      print OUT "<br>\n$p_string\n" or die;
      
      print OUT <<HERE or die;
$first_value, <a href="http://oeis.org/search?q=$signed$values_escaped&sort=&language=english&go=Search">$values</a>
HERE
      
      if (my @unzeros = unzeros(@values)) {
        $first_value = shift @unzeros;
        $values = join(',',@unzeros);
        $values_escaped = URI::Escape::uri_escape($values);
        print OUT <<HERE or die;
<br> &nbsp; unzeros: $first_value, <a href="http://oeis.org/search?q=$signed$values_escaped&sort=&language=english&go=Search">$values</a>
HERE
      }
      
      unless ($module =~ /FractionDigits|DigitLength/) {
        my $base_len = scalar(@values);
        
        foreach (1 .. $base_len) {
          my ($i, $value) = $seq->next or last;
          push @values, $value;
        }
        if (my @undouble = undouble(@values)) {
          unless (all_same(@undouble) || constant_diff(@undouble)) {
            $first_value = shift @undouble;
            $values = join(',',@undouble);
            $values_escaped = URI::Escape::uri_escape($values);
            print OUT <<HERE or die;
<br> &nbsp; undouble: $first_value, <a href="http://oeis.org/search?q=$signed$values_escaped&sort=&language=english&go=Search">$values</a>
HERE
          }
        }
        
        foreach (1 .. $base_len) {
          my ($i, $value) = $seq->next or last;
          push @values, $value;
        }
        if (my @untriple = untriple(@values)) {
          unless (all_same(@untriple) || constant_diff(@untriple)) {
            $first_value = shift @untriple;
            $values = join(',',@untriple);
            $values_escaped = URI::Escape::uri_escape($values);
            print OUT <<HERE or die;
<br> &nbsp; untriple: $first_value, <a href="http://oeis.org/search?q=$signed$values_escaped&sort=&language=english&go=Search">$values</a>
HERE
          }
        }
        
        foreach (1 .. $base_len) {
          my ($i, $value) = $seq->next or last;
          push @values, $value;
        }
        if (my @unquad = unquad(@values)) {
          unless (all_same(@unquad) || constant_diff(@unquad)) {
            $first_value = shift @unquad;
            $values = join(',',@unquad);
            $values_escaped = URI::Escape::uri_escape($values);
            print OUT <<HERE or die;
<br> &nbsp; unquad: $first_value, <a href="http://oeis.org/search?q=$signed$values_escaped&sort=&language=english&go=Search">$values</a>
HERE
          }
        }
      }
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
  my ($module, $params, $seq, $values_aref) = @_;
  return unless @$values_aref;
  return if $module eq 'SqrtDigits';

  $seq->rewind;
  my ($i_start, $value_start) = $seq->next;

  if (all_same(@$values_aref)) {
    if ($values_aref->[0] == 0 && $i_start != 0) {
      # A000004 all zeros starts i=0, ignore other starts

    } elsif ($values_aref->[0] == 1 && $i_start != 0) {
      # A000012 all ones starts i=0, ignore other starts

    } else {
      print "$module $params:\n";
      print "  all same $values_aref->[0]   length $#$values_aref\n";
    }

  } elsif (defined (my $diff = constant_diff(@$values_aref))) {
    if ($diff == -1 && $i_start != 0) {
      # A001489 negatives starts i=0, ignore others

    } elsif ($diff == 1 && $i_start != $value_start) {
      # A001477 all integers starts i=0
      # A000027 naturals starts i=1

    } elsif ($diff == 2 && $i_start != 0) {
      # A005843 even numbers starts i=0

    } else {
      print "$module $params:\n";
      print "  constant increment $diff (i_start=$i_start value=$value_start)\n";
      print "  ",join(',',@$values_aref),"\n";
    }

  } elsif (is_squares(@$values_aref)) {
    if ($values_aref->[0] == 0) {
      # A000290 starts i=0
      print "$module $params: squares\n";
    }
  } else {
    grep_for_values("$module $params", join(',',@$values_aref));
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

# constant_diff($a,$b,$c,...)
# If all the given values have a constant difference then return that amount.
# Otherwise return undef.
#
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

# all_same($a,$b,$c,...)
# Return true if all the given numbers are the same value.
#
sub all_same {
  my $value = shift;
  while (@_) {
    if ($value != shift) {
      return 0;
    }
  }
  return 1;
}

# @list = unzeros(@list)
# if every second given arg is 0 then return the values without those zeros,
# otherwise return an empty list
# If the args are all 0 then return an empty list too.
sub unzeros {
  @_ or return;

  if (! $_[0]) {
    shift; # skip zero
  }

  my @ret;
  my $seen_nonzero;
  while (@_) {
    $seen_nonzero ||= $_[0];
    push @ret, shift;
    if ($_[0]) {
      return; # not alternate zeros
    } else {
      shift; # skip zero
    }
  }
  if (! $seen_nonzero) {
    return;
  }
  return @ret;
}

# @list = undouble(@list)
# If pairs of two consecutive values are equal then return the undoubled
# values, otherwise return an empty list.
# If the args are all identical then return an empty list too.
# An initial $_[0] can be a solitary value and is dropped if necessary.
# The final $_[-1] can be a solitary value but is retained.
#
sub undouble {
  @_ >= 2 or return;

  if (first_diff_pos(@_) & 1) {
    shift; # skip unmatched initial
  }

  my @ret;
  my $seen_different = 0;
  while (@_ >= 2) {
    my $v1 = shift;
    my $v2 = shift;
    if ($v1 != $v2) {
      return; # not doubled pairs
    }
    push @ret, $v1;
    $seen_different ||= ($v1 != $ret[0])
  }
  if (! $seen_different) {
    return;
  }
  return (@ret, @_);
}

# @list = untriple(@list)
# If triples of four consecutive values are equal then return the untripled
# values, otherwise return an empty list.
# If the args are all identical then return an empty list too.
# An initial 1 or 2 values can be skipped to get to a four-equal boundary.
# Final 1 or 2 values don't have to be a triple but do have to be equal and
# are included in the return.
#
sub untriple {
  @_ >= 4 or return;

  foreach (1 .. (first_diff_pos(@_) % 3)) {
    shift; # skip unmatched initial 1 or 2
  }

  my @ret;
  my $seen_different = 0;
  while (@_ >= 4) {
    my $v1 = shift;
    my $v2 = shift;
    my $v3 = shift;
    if ($v1 != $v2 || $v1 != $v3) {
      return; # not triples
    }
    push @ret, $v1;
    $seen_different ||= ($v1 != $ret[0]);
  }

  if (@_) {
    my $v1 = shift;
    if (@_) {
      my $v2 = shift;
      if ($v1 != $v2) { return; }
    }
    push @ret, $v1;
    $seen_different ||= ($v1 != $ret[0]);
  }

  if (! $seen_different) {
    return;
  }
  return (@ret, @_);
}

# @list = unquad(@list)
# If quads of four consecutive values are equal then return the unquadded
# values, otherwise return an empty list.
# If the args are all identical then return an empty list too.
# An initial 1, 2 or 3 values can be skipped to get to a four-equal boundary.
# Final 1, 2 or 3 values don't have to be a quad but do have to be equal and
# are included in the return.
#
sub unquad {
  @_ >= 4 or return;

  foreach (1 .. (first_diff_pos(@_) & 3)) {
    shift; # skip unmatched initial 1, 2 or 3
  }

  my @ret;
  my $seen_different = 0;
  while (@_ >= 4) {
    my $v1 = shift;
    my $v2 = shift;
    my $v3 = shift;
    my $v4 = shift;
    if ($v1 != $v2 || $v1 != $v3 || $v1 != $v4) {
      return; # not quads
    }
    push @ret, $v1;
    $seen_different ||= ($v1 != $ret[0]);
  }

  if (@_) {
    my $v1 = shift;
    if (@_) {
      my $v2 = shift;
      if ($v1 != $v2) { return; }
    }
    if (@_) {
      my $v3 = shift;
      if ($v1 != $v3) { return; }
    }
    push @ret, $v1;
    $seen_different ||= ($v1 != $ret[0]);
  }

  if (! $seen_different) {
    return;
  }
  return (@ret, @_);
}

sub first_diff_pos {
  my $pos = 0;
  while (@_ >= 2) {
    $pos++;
    if ($_[0] != $_[1]) {
      return $pos;
    }
    shift;
  }
  return 0;
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
        next if ($info->{'name'} eq 'serpentine_type' && $choice eq 'Peano');
        next if ($info->{'name'} eq 'rotation_type' && $choice eq 'custom');
        push @new_parameters, [ @$p, $info->{'name'}, $choice ];
      }
      if ($info->{'name'} eq 'serpentine_type') {
        push @new_parameters, [ @$p, $info->{'name'}, '100_000_000' ];
        push @new_parameters, [ @$p, $info->{'name'}, '101_010_101' ];
        push @new_parameters, [ @$p, $info->{'name'}, '000_111_000' ];
        push @new_parameters, [ @$p, $info->{'name'}, '111_000_111' ];
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
    my $min = $info->{'minimum'} // -5;
    my $max = $min + 10;
    if (# $module =~ 'PrimeIndexPrimes' &&
        $info->{'name'} eq 'level') { $max = 5; }
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
    if ($info->{'name'} eq 'diagonal_length') { $max = 5; }
    if (defined $info->{'maximum'} && $max > $info->{'maximum'}) {
      $max = $info->{'maximum'};
    }
    if ($info->{'name'} eq 'power' && $max > 6) { $max = 6; }
    my @new_parameters;
    foreach my $choice ($min .. $max) {
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

sub grep_for_values {
  my ($name, $values) = @_;
  unless (system 'fgrep', '-e', $values, "$ENV{HOME}/OEIS/oeis-grep.txt") {
    print "  match $values\n";
    print "  $name\n";
    print "\n"
  }
}
