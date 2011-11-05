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


package Math::NumSeq::OEIS::File;
use 5.004;
use strict;
use Carp;
use POSIX ();
use Math::NumSeq;

use vars '$VERSION','@ISA';
$VERSION = 15;

use Math::NumSeq::Base::Array;
@ISA = ('Math::NumSeq::Base::Array');

use vars '$VERSION';
$VERSION = 15;

# uncomment this to run the ### lines
#use Devel::Comments;


# use constant name => Math::NumSeq::__('OEIS File');
sub description {
  my ($class_or_self) = @_;
  if (ref $class_or_self && defined $class_or_self->{'description'}) {
    return $class_or_self->{'description'};
  }
  return Math::NumSeq::__('OEIS sequence from file.');
}
use Math::NumSeq::OEIS;
*parameter_info_array = \&Math::NumSeq::OEIS::parameter_info_array;

sub new {
  my ($class, %options) = @_;
  ### OEIS-File: %options

  my %self;
  if (my $anum = $options{'anum'}) {
    my $self = {};
    ### $anum
    _read_values (\%self, $anum);
    if (! _read_internal(\%self, $anum)) {
      _read_html(\%self, $anum);
    }
    if (! $self{'array'}) {
      croak 'B-file, Internal or HTML not found for A-number "',$anum,'"';
    }

    if ($self{'characteristic'}->{'radix'}) {
      ### radix ...
      my $aref = $self{'array'};
      my $max = 0;
      foreach my $i (1 .. $#$aref) {
        if ($aref->[$i] > 50) {
          last;
        }
        if ($aref->[$i] > $max) {
          $max = $aref->[$i];
        }
      }
      ### guess max from data: $max
      $self{'values_max'} = $max;
      $self{'radix'} = $max+1;
    }
  }

  return $class->SUPER::new (%self,
                             %options);
}

sub oeis_dir {
  require File::Spec;
  require File::HomeDir;
  return File::Spec->catfile (File::HomeDir->my_home, 'OEIS');
}

my $max_value = POSIX::FLT_RADIX() ** (POSIX::DBL_MANT_DIG()-5);
if ((~0 >> 1) > $max_value) {
  $max_value = (~0 >> 1);
}

sub anum_to_bfile {
  my ($anum, $prefix) = @_;
  $prefix ||= 'b';
  $anum =~ s/^A/$prefix/;
  return "$anum.txt";
}

sub _read_values {
  my ($self, $anum) = @_;
  ### Values-OEIS-File _read_values(): @_

  require File::Spec;
 PREFIX: foreach my $prefix ('a', 'b') {
    my $basefile = anum_to_bfile($anum,$prefix);
    my $filename = File::Spec->catfile (oeis_dir(), $basefile);
    ### $basefile
    ### $filename
    if (! open FH, "< $filename") {
      ### no bfile: $!
      next;
    }
    my @array;
    my $seen_good = 0;
    while (defined (my $line = <FH>)) {
      chomp $line;
      $line =~ tr/\r//d;    # delete CR if CRLF line endings, eg. b009000.txt
      ### $line

      if ($line =~ /^\s*(#|$)/) {
        ### ignore blank or comment ...
        # comment lines with # eg. b002182.txt
        next;
      }

      if (my ($i, $value) = ($line =~ /^([0-9]+)     # i
                                       [ \t]+
                                       (-?[0-9]+)    # value
                                       [ \t]*
                                       $/x)) {
        if ($value > $max_value) {
          ### stop at bignum value ...
          last;
        }
        $seen_good = 1;
        $array[$i] = $value;
        next;
      }

      # forgive random non-number stuff in a000000.txt files, eg. a084888.txt
      if (! $seen_good && $prefix eq 'a') {
        ### non-number in a-file, skip ...
        close FH or die "Error reading $filename: $!";
        next PREFIX;
      }
      # bad line in b000000.txt file, or in an a000000.txt which had
      # looked good until this point
      ### linenum: $.
      $line =~ s{([^\020-\176])}{sprintf '\\x{%04x}', ord($1)}eg;
      die "oops, bad line $. in $filename: \"$line\"";
    }
    close FH or die "Error reading $filename: $!";
    $self->{'filename'} = $filename;
    $self->{'array'} = \@array;
    ### array size: scalar(@{$self->{'array'}})
  }
  return;
}

sub characteristic_monotonic {
  my ($self) = @_;
  ### OEIS-File characteristic_monotonic() ...

  if (! defined $self->{'characteristic'}->{'monotonic'}) {
    my $monotonic = 2;
    my $aref = $self->{'array'};
    my $prev;
    foreach my $i (0 .. $#$aref) {
      next unless defined (my $value = $aref->[$i]);
      if (defined $prev) {
        if ($value < $prev) {
          $monotonic = 0;
          last;
        }
        if ($value eq $prev) {
          $monotonic = 1;
        }
      }
      $prev = $value;
    }
    ### $monotonic
    $self->{'characteristic'}->{'monotonic'} = $monotonic;
  }
  return $self->{'characteristic'}->{'monotonic'};
}

sub characteristic_smaller {
  my ($self) = @_;
  ### OEIS-File characteristic_smaller() ...

  if (! defined $self->{'characteristic'}->{'smaller'}) {
    my $aref = $self->{'array'};
    my $smaller = 0;
    my $total = 0;
    foreach my $i (0 .. $#$aref) {
      next unless defined (my $value = $aref->[$i]);
      $total++;
      $smaller += ($value < $i);
    }
    ### $smaller
    ### $total
    $self->{'characteristic'}->{'smaller'}
      = ($total == 0 || $smaller / $total >= .9);
    ### decide: $self->{'characteristic'}->{'smaller'}
  }
  return $self->{'characteristic'}->{'smaller'};
}

sub values_min {
  my ($self) = @_;
  ### OEIS-File values_min() ...
  if (! exists $self->{'values_min'}) {
    my $aref = $self->{'array'};
    my $min;
    foreach my $i (0 .. $#$aref) {
      next unless defined (my $value = $aref->[$i]);
      if (! defined $min || $value < $min) {
        $min = $value;
      }
    }
    if (! defined $min && $self->{'characteristic'}->{'oeis_nonn'}) {
      $min = 0;
    }
    ### $min
    $self->{'values_min'} = $min;
  }
  return $self->{'values_min'};
}
sub values_max {
  my ($self) = @_;
  ### OEIS-File values_max() ...
  return undef;

  # if (! exists $self->{'values_max'}) {
  #   my $aref = $self->{'array'};
  #   my $max;
  #   foreach my $i (0 .. $#$aref) {
  #     next unless defined (my $value = $aref->[$i]);
  #     if (! defined $max || $value > $max) {
  #       $max = $value;
  #     }
  #   }
  #   ### $max
  #   $self->{'values_max'} = $max;
  # }
  # return $self->{'values_max'};
}

sub _read_internal {
  my ($self, $anum, $aref) = @_;

  my $basefile = "$anum.internal";
  my $filename = File::Spec->catfile (oeis_dir(), $basefile);
  ### $basefile
  ### $filename
  if (! open FH, "<$filename") {
    ### no .internal file: $!
    return;
  }
  my $contents = do { local $/; <FH> }; # slurp
  close FH or die "Error reading $filename: ",$!;

  my %characteristic = (integer => 1);
  $self->{'characteristic'} = \%characteristic;

  my $offset;
  if ($contents =~ /^%O\s+(\d+)/m) {
    $offset = $1;
  } else {
    $offset = 0;
  }

  my $description;
  if ($contents =~ m{^%N (.*?)(<tt>|$)}m) {
    $description = $1;
    $description =~ s/\s+/ /g;
    $description =~ s/<[^>]*?>//sg;  # <foo ...> tags
    $description =~ s/&lt;/</sg;     # unentitize <
    $description =~ s/&gt;/>/sg;     # unentitize >
    $description =~ s/&amp;/&/sg;    # unentitize &
    $description =~ s/&#39;/'/sg;    # unentitize '
    ### $description

    if ($description =~ /^number of /i) {
      $characteristic{'count'} = 1;
    }
    # ENHANCE-ME: use __x() when available, or an sprintf "... %s" would be enough ...
    $description .= "\n" . (defined $self->{'filename'}
                            ? Math::NumSeq::__('Values from B-file ') . $self->{'filename'}
                            : Math::NumSeq::__('First few values from ') . "$anum.internal");
    $self->{'description'} = $description;
  }

  _set_characteristics ($self, $description,
                        $contents =~ /^%K (.*?)(<tt>|$)/m && $1);

  if (! $self->{'array'}) {
    $contents =~ m{^%S (.*?)(</tt>|$)}m
      or croak "Oops list of values not found in ",$filename;
    _split_sample_values ($self, $filename, $1, $offset);
  }
}

sub _read_html {
  my ($self, $anum) = @_;
  foreach my $basefile ("$anum.html", "$anum.htm") {
    my $filename = File::Spec->catfile (oeis_dir(), $basefile);
    ### $basefile
    ### $filename
    if (open FH, "< $filename") {
      my $contents = do { local $/; <FH> }; # slurp
      close FH or die;

      my $description;
      if ($contents =~
          m{$anum\n.*?
            <td[^>]*>\s*</td>   # blank <td ...></td>
            <td[^>]*>           # <td ...>
            \s*
            (.*?)               # text
            <(br|/td)>          # to <br> or </td>
         }sx) {
        $description = $1;
        $description =~ s/\s+$//;       # trailing whitespace
        $description =~ s/\s+/ /g;      # collapse whitespace
        $description =~ s/<[^>]*?>//sg; # tags <foo ...>
        $description =~ s/&lt;/</sg;    # unentitize <
        $description =~ s/&gt;/>/sg;    # unentitize >
        $description =~ s/&amp;/&/sg;   # unentitize &
        $description =~ s/&#39;/'/sg;   # unentitize '
        ### $description

        # __x('Values from B-file {filename}',
        #     filename => $self->{'filename'})

        $description .= "\n" . (defined $self->{'filename'}
                                ? Math::NumSeq::__('Values from B-file ').$self->{'filename'}
                                : Math::NumSeq::__('First few values from HTML'));
        $self->{'description'} = $description;
      }

      # fragile grep out of the html ...
      my $offset = ($contents =~ /OFFSET.*?<tt>(\d+)/s
                    && $1);
      ### $offset

      # fragile grep out of the html ...
      my $keywords;
      if ($contents =~ m{KEYWORD.*?<tt[^>]*>(.*?)</tt>}s) {
        ### html keywords match: $1
        $keywords = $1;
      }
      _set_characteristics ($self, $description, $keywords);

      if (! $self->{'array'}) {
        # fragile grep out of the html ...
        $contents =~ s{>graph</a>.*}{};
        $contents =~ m{.*<tt>([^<]+)</tt>};
        my $list = $1;
        _split_sample_values ($self, $filename, $list, $offset);
      }
      return 1;
    }
    ### no html: $!
  }
  return 0;
}

sub _set_characteristics {
  my ($self, $description, $keywords) = @_;
  ### _set_characteristics()
  ### $description
  ### $keywords

  $keywords =~ s{<[^>]*>}{}g;  # <foo ...> tags
  ### $keywords

  foreach my $key (split /[, \t]+/, ($keywords||'')) {
    ### $key
    if ($key eq 'nonn') {   # non-negative
      $self->{'values_min'} = 0;
    }
    # "base" means values are dependent on some number base, but doesn't
    # mean they're digits or small etc
    # "cons" means decimal expansion of a number
    if ($key eq 'cons') {
      $self->{'characteristic'}->{'radix'} = 1;
    }
    if ($key eq 'cofr') {
      $self->{'characteristic'}->{'continued_fraction'} = 1;
    }
    $self->{'characteristic'}->{"OEIS_$key"} = 1;
  }
}

sub _split_sample_values {
  my ($self, $filename, $str, $offset) = @_;
  unless ($str =~ m{^([0-9,-]|\s)+$}) {
    croak "Oops unrecognised list of values not found in ",$filename,"\n",$str;
  }
  $self->{'array'} = [ split /[, \t\r\n]+/, $str ];

  # %O "OFFSET" is subscript of first number, or for digit expansions it's
  # the position of the decimal point
  # http://oeis.org/eishelp2.html#RO
  if ($offset && ! $self->{'characteristic'}->{'radix'}) {
    unshift @{$self->{'array'}}, (undef) x $offset;
  }
}

1;
__END__







  # foreach my $basefile (anum_to_html($anum), anum_to_html($anum,'.htm')) {
  #   my $filename = File::Spec->catfile (oeis_dir(), $basefile);
  #   ### $basefile
  #   ### $filename
  #   if (open FH, "<$filename") {
  #     my $contents = do { local $/; <FH> }; # slurp
  #     close FH or die;
  # 
  #     # fragile grep out of the html ...
  #     $contents =~ s{>graph</a>.*}{};
  #     $contents =~ m{.*<tt>([^<]+)</tt>};
  #     my $list = $1;
  #     unless ($list =~ m{^([0-9,-]|\s)+$}) {
  #       croak "Oops list of values not found in ",$filename;
  #     }
  #     my @array = split /[, \t\r\n]+/, $list;
  #     ### $list
  #     ### @array
  #     return \@array;
  #   }
  #   ### no html: $!
  # }
