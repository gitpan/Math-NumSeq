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


# http://oeis.org/wiki/Clear-cut_examples_of_keywords
#
# ENHANCE-ME: share most of the a-file/b-file reading with Math::NumSeq::File

package Math::NumSeq::OEIS::File;
use 5.004;
use strict;
use Carp;
use POSIX ();
use File::Spec;
use Symbol 'gensym';
use Math::NumSeq;

use vars '$VERSION','@ISA';
$VERSION = 48;

use Math::NumSeq;
@ISA = ('Math::NumSeq');
*_to_bigint = \&Math::NumSeq::_to_bigint;

use vars '$VERSION';
$VERSION = 48;

eval q{use Scalar::Util 'weaken'; 1}
  || eval q{sub weaken { $_[0] = undef }; 1 }
  || die "Oops, error making a weaken() fallback: $@";

# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('OEIS File');
use Math::NumSeq::OEIS;
*parameter_info_array = \&Math::NumSeq::OEIS::parameter_info_array;

sub description {
  my ($class_or_self) = @_;
  if (ref $class_or_self && defined $class_or_self->{'description'}) {
    # instance
    return $class_or_self->{'description'};
  } else {
    # class
    return Math::NumSeq::__('OEIS sequence from file.');
  }
}

sub values_min {
  my ($self) = @_;
  ### OEIS-File values_min() ...
  return _analyze($self)->{'values_min'};
}
sub values_max {
  my ($self) = @_;
  ### OEIS-File values_max() ...
  return _analyze($self)->{'values_max'};
}

my %analyze_characteristics = (increasing            => 1,
                               increasing_from_i     => 1,
                               non_decreasing        => 1,
                               non_decreasing_from_i => 1,
                               smaller               => 1,
                              );
sub characteristic {
  my ($self, $key) = @_;
  if ($analyze_characteristics{$key}) {
    _analyze($self);
  }
  return shift->SUPER::characteristic(@_);
}

my $max_value = POSIX::FLT_RADIX() ** (POSIX::DBL_MANT_DIG()-5);
if ((~0 >> 1) > $max_value) {
  $max_value = (~0 >> 1);
}
my $min_value = -$max_value;

sub oeis_dir {
  require File::HomeDir;
  return File::Spec->catfile (File::HomeDir->my_home, 'OEIS');
}
sub anum_to_bfile {
  my ($anum, $prefix) = @_;
  $prefix ||= 'b';
  $anum =~ s/^A/$prefix/;
  return "$anum.txt";
}

my %instances;
sub DESTROY {
  my ($self) = @_;
  delete $instances{$self+0};
}
sub CLONE {
  my ($class) = @_;
  foreach my $self (values %instances) {
    next unless $self;
    next unless $self->{'fh'};
    my $pos = _tell($self);
    my $fh = gensym;
    if (open $fh, "< $self->{'filename'}") {
      $self->{'fh'} = $fh;
      _seek ($self, $pos);
    } else {
      delete $self->{'fh'};
      delete $self->{'filename'};
    }
  }
}


# special case a000000.txt files to exclude
#
my %afile_exclude
  = (
     # a003849.txt has replication level words rather than the individual
     # sequence values.
     'a003849.txt' => 1,

     # a027750.txt is unflattened divisors as lists.
     # Its first line is a correct looking "1 1" so _afile_is_good() doesn't
     # notice.
     'a027750.txt' => 1,
    );

sub new {
  ### OEIS-File new() ...
  my $self = shift->SUPER::new(@_);

  my $anum = $self->{'anum'};
  my $oeis_dir = oeis_dir();
  (my $num = $anum) =~ s/^A//;
  foreach my $basefile ("a$num.txt",
                        "b$num.txt") {
    next if $afile_exclude{$basefile};

    next if $basefile =~ /^a/ && $self->{'_dont_use_afile'};
    next if $basefile =~ /^b/ && $self->{'_dont_use_bfile'};

    my $filename = File::Spec->catfile ($oeis_dir, $basefile);
    ### $filename

    my $fh = gensym;
    if (! open $fh, "< $filename") {
      ### cannot open: $!
      next;
    }

    $self->{'filename'} = $filename;
    $self->{'fh'} = $fh;
    if (! _afile_is_good($self)) {
      ### this afile not good ...
      close delete $self->{'fh'};
      delete $self->{'filename'};
      next;
    }

    ### opened: $fh
    last;
  }

  my $have_info = (_read_internal($self, $anum)
                   || _read_html($self, $anum));

  if (! $have_info && ! $self->{'fh'}) {
    croak 'OEIS file(s) not found for A-number "',$anum,'"';
  }

  weaken($instances{$self+0} = $self);
  return $self;
}

sub _analyze {
  my ($self) = @_;

  if ($self->{'analyze_done'}) {
    return $self;
  }
  $self->{'analyze_done'} = 1;

  ### _analyze() ...

  my $i_start = $self->i_start;
  my ($i, $value);
  my ($prev_i, $prev_value);

  my $values_min;
  my $values_max;
  my $increasing_from_i = $i_start;
  my $non_decreasing_from_i = $i_start;
  my $strictly_smaller_count = 0;
  my $smaller_count = 0;
  my $total_count = 0;

  my $analyze = sub {
    ### $prev_value
    ### $value
    if (! defined $values_min || $value < $values_min) {
      $values_min = $value;
    }
    if (! defined $values_max || $value > $values_max) {
      $values_max = $value;
    }

    if (defined $prev_value) {
      my $cmp = ($value <=> $prev_value);
      if ($cmp < 0) {
        # value < $prev_value
        $increasing_from_i = $i;
        $non_decreasing_from_i = $i;
      }
      if ($cmp <= 0) {
        # value <= $prev_value
        $increasing_from_i = $i;
      }
    }

    $total_count++;
    $smaller_count += (abs($value) <= $i);
    $strictly_smaller_count += ($value < $i);

    $prev_i = $value;
    $prev_value = $value;
  };

  if (my $fh = $self->{'fh'}) {
    my $oldpos = _tell($self);
    while (($i, $value) = _readline($self)) {
      $analyze->($value);
      last if $total_count > 200;
    }
    _seek ($self, $oldpos);
  } else {
    $i = $i_start;
    foreach (@{$self->{'array'}}) {
      $i++;
      $value = $_;
      $analyze->();
    }
  }

  my $range_is_small = (defined $values_max
                        && $values_max - $values_min <= 16);
  ### $range_is_small

  # "full" means whole sequence in sample values
  # "sign" means negatives in sequence
  if (! defined $self->{'values_min'}
      && ($range_is_small
          || $self->{'characteristic'}->{'OEIS_full'}
          || ! $self->{'characteristic'}->{'OEIS_sign'})) {
    ### set values_min: $values_min
    $self->{'values_min'} = $values_min;
  }
  if (! defined $self->{'values_max'}
      && ($range_is_small
          || $self->{'characteristic'}->{'OEIS_full'})) {
    ### set values_max: $values_max
    $self->{'values_max'} = $values_max;
  }

  $self->{'characteristic'}->{'smaller'}
    = ($total_count == 0
       || ($smaller_count / $total_count >= .9
           && $strictly_smaller_count > 0));
  ### decide smaller: $self->{'characteristic'}->{'smaller'}

  ### $increasing_from_i
  if (defined $prev_i && $increasing_from_i < $prev_i) {
    if ($increasing_from_i - $i_start < 20) {
      $self->{'characteristic'}->{'increasing_from_i'} = $increasing_from_i;
    }
    if ($increasing_from_i == $i_start) {
      $self->{'characteristic'}->{'increasing'} = 1;
    }
  }

  ### $non_decreasing_from_i
  if (defined $prev_i && $non_decreasing_from_i < $prev_i) {
    if ($non_decreasing_from_i - $i_start < 20) {
      $self->{'characteristic'}->{'non_decreasing_from_i'} = $non_decreasing_from_i;
    }
    if ($non_decreasing_from_i == $i_start) {
      $self->{'characteristic'}->{'non_decreasing'} = 1;
    }
  }

  return $self;
}

# # compare $x <=> $y but in strings in case they're bigger than IV or NV
# # my $cmp = _value_cmp ($value, $prev_value);
# sub _value_cmp {
#   my ($x, $y) = @_;
#   ### _value_cmp(): "$x  $y"
#   ### cmp: $x cmp $y
# 
#   my $x_neg = substr($x,0,1) eq '-';
#   my $y_neg = substr($y,0,1) eq '-';
#   ### $x_neg
#   ### $y_neg
# 
#   return ($y_neg <=> $x_neg
#           || ($x_neg ? -1 : 1) * (length($x) <=> length($y)
#                                   || $x cmp $y));
# }

sub _seek {
  my ($self, $pos) = @_;
  seek ($self->{'fh'}, $pos, 0)
    or croak "Cannot seek $self->{'filename'}: $!";
}
sub _tell {
  my ($self) = @_;
  my $pos = tell $self->{'fh'};
  if ($pos < 0) {
    croak "Cannot tell file position $self->{'filename'}: $!";
  }
  return $pos;
}

sub rewind {
  my ($self, $pos) = @_;
  ### OEIS-File rewind() ...

  $self->{'i'} = $self->i_start;
  $self->{'array_pos'} = 0;
  if ($self->{'fh'}) {
    seek ($self->{'fh'}, 0, 0)
      or croak "Cannot seek $self->{'filename'}: $!";
  }
}

sub next {
  my ($self) = @_;
  ### OEIS-File next(): "i=$self->{'i'}"

  my $value;
  if (my $fh = $self->{'fh'}) {
    ### from readline ...
    ($self->{'i'}, $value) = _readline($self)
      or return;
  } else {
    ### from array ...
    my $array = $self->{'array'};
    my $pos = $self->{'array_pos'}++;
    if ($pos > $#$array) {
      return;
    }
    $value = $array->[$pos];

    # large values as Math::BigInt
    # initially $array has strings, make bigint objects when required
    if (! ref $value
        && ($value > $max_value || $value < $min_value)) {
      $value = $array->[$pos] = _to_bigint($value);
    }
  }
  return ($self->{'i'}++, $value);
}

sub _readline {
  my ($self) = @_;
  my $fh = $self->{'fh'};
  while (defined (my $line = <$fh>)) {
    chomp $line;
    $line =~ tr/\r//d;    # delete CR if CRLF line endings, eg. b009000.txt
    ### $line

    if ($line =~ /^\s*(#|$)/) {
      ### ignore blank or comment ...
      # comment lines with "#" eg. b002182.txt
      next;
    }

    # leading whitespace allowed as per b195467.txt
    if (my ($i, $value) = ($line =~ /^\s*
                                     ([0-9]+)      # i
                                     [ \t]+
                                     (-?[0-9]+)    # value
                                     [ \t]*
                                     $/x)) {
      ### _readline: "$i  $value"
      if ($value > $max_value || $value < $min_value) {
        $value = _to_bigint($value);
      }
      return ($i, $value);
    }
  }
  return;
}

# Return true if the a000000.txt file in $self->{'fh'} looks good.
# Various a-files are source code or tables rather than sequence values.
#
sub _afile_is_good {
  my ($self) = @_;
  my $fh = $self->{'fh'};
  while (defined (my $line = <$fh>)) {
    chomp $line;
    $line =~ tr/\r//d;    # delete CR if CRLF line endings, eg. b009000.txt
    ### $line

    if ($line =~ /^\s*(#|$)/) {
      ### ignore blank or comment ...
      next;
    }

    # a line "0 123" means good
    if ($line =~ /^([0-9]+)     # i
                  [ \t]+
                  (-?[0-9]+)    # value
                  [ \t]*
                  $/x) {
      _seek ($self, 0);
      return 1;
    } else {
      last;
    }
  }
  return 0;
}

sub _read_internal {
  my ($self, $anum) = @_;
  ### _read_internal(): $anum

  return 0 if $self->{'_dont_use_internal'};

  foreach my $basefile ("$anum.internal", "$anum.internal.html") {
    my $filename = File::Spec->catfile (oeis_dir(), $basefile);
    ### $basefile
    ### $filename

    if (! open FH, "<$filename") {
      ### cannot open .internal file: $!
      next;
    }
    my $contents = do { local $/; <FH> }; # slurp
    close FH or die "Error reading $filename: ",$!;

    # "Internal" files are served as html with a <meta> charset indicator
    $contents = _decode_html_charset($contents);
    ### $contents

    my %characteristic = (integer => 1);
    $self->{'characteristic'} = \%characteristic;

    my $offset;
    if ($contents =~ /(^|<tt>)%O\s+(\d+)/im) {
      $offset = $2;
      ### %O line: $offset
    } else {
      $offset = 0;
    }

    if ($contents =~ m{(^|<tt>)%N (.*?)(<tt>|$)}im) {
      _set_description ($self, $2, $filename);
    } else {
      ### description not matched ...
    }

    _set_characteristics ($self,
                          $contents =~ /(^|<tt>)%K (.*?)(<tt>|$)/im
                          && $2);

    # the eishelp1.html says
    # %V,%W,%X lines for signed sequences
    # %S,%T,%U lines for non-negative sequences
    # though now %S is signed and unsigned both is it?
    #
    if (! $self->{'array'}) {
      my @samples;
      # capital %STU etc, but any case <tt>
      while ($contents =~ m{(^|<[tT][tT]>)%[VWX] (.*?)(</[tT][tT]>|$)}mg) {
        push @samples, $2;
      }
      unless (@samples) {
        while ($contents =~ m{(^|<[tT][tT]>)%[STU] (.*?)(</[tT][tT]>|$)}mg) {
          push @samples, $2;
        }
        unless (@samples) {
          croak "Oops list of values not found in ",$filename;
        }
      }
      _split_sample_values ($self, $filename,
                            join (', ', @samples),
                            $offset);
    }

    # %O "OFFSET" is subscript of first number.
    # Or for digit expansions it's the number of terms before the decimal
    # point, per http://oeis.org/eishelp2.html#RO
    #
    unless ($self->{'characteristic'}->{'digits'}) {
      $self->{'i'} = $self->{'i_start'} = $offset;
    }
    ### i: $self->{'i'}
    ### i_start: $self->{'i_start'}

    return 1; # success
  }

  return 0; # file not found
}

# various fragile greps of the html ...
# return 1 if .html or .htm file exists, 0 if not
#
sub _read_html {
  my ($self, $anum) = @_;
  ### _read_html(): $anum

  return 0 if $self->{'_dont_use_html'};

  foreach my $basefile ("$anum.html", "$anum.htm") {
    my $filename = File::Spec->catfile (oeis_dir(), $basefile);
    ### $basefile
    ### $filename

    if (! open FH, "< $filename") {
      ### cannot open: $!
      next;
    }
    my $contents = do { local $/; <FH> }; # slurp
    close FH or die;

    $contents = _decode_html_charset($contents);

    if ($contents =~
        m{$anum[ \t]*\n.*?       # target anum
          <td[^>]*>\s*(?:</td>)? # <td ...></td> empty
          <td[^>]*>              # <td ...>
          \s*
          (.*?)                  # text through to ...
          (<br>|</?td)           # <br> or </td> or <td>
       }isx) {
      _set_description ($self, $1, $filename);
    } else {
      ### description not matched ...
    }

    my $offset = ($contents =~ /OFFSET.*?<[tT][tT]>(\d+)/s
                  && $1);
    ### $offset

    # fragile grep out of the html ...
    my $keywords;
    if ($contents =~ m{KEYWORD.*?<[tT][tT][^>]*>(.*?)</[tT][tT]>}s) {
      ### html keywords match: $1
      $keywords = $1;
    } else {
      # die "Oops, KEYWORD not matched: $anum";
    }
    _set_characteristics ($self, $keywords);

    if (! $self->{'array'}) {
      # fragile grep out of the html ...
      $contents =~ s{>graph</a>.*}{};
      $contents =~ m{.*<tt>([^<]+)</tt>}i;
      my $list = $1;
      _split_sample_values ($self, $filename, $list, $offset);
    }

    # %O "OFFSET" is subscript of first number, but for digit expansions
    # it's the position of the decimal point
    # http://oeis.org/eishelp2.html#RO
    if (! $self->{'characteristic'}->{'digits'}) {
      $self->{'i'} = $self->{'i_start'} = $offset;
    }
    ### i: $self->{'i'}
    ### i_start: $self->{'i_start'}

    return 1;
  }
  return 0;
}

sub _set_description {
  my ($self, $description, $few_filename) = @_;
  ### _set_description(): $description

  $description =~ s/\s+$//;       # trailing whitespace
  $description =~ s/\s+/ /g;      # collapse whitespace
  $description =~ s/<[^>]*?>//sg; # tags <foo ...>
  $description =~ s/&lt;/</ig;    # unentitize <
  $description =~ s/&gt;/>/ig;    # unentitize >
  $description =~ s/&amp;/&/ig;   # unentitize &
  $description =~ s/&#(\d+);/chr($1)/ge; # unentitize numeric ' and "

  # ENHANCE-ME: maybe __x() if made available, or an sprintf "... %s" would
  # be enough ...
  $description .= "\n";
  if (defined $self->{'filename'}) {
    $description .= Math::NumSeq::__('Values from B-file ')
      . $self->{'filename'};
  } else {
    $description .= Math::NumSeq::__('Values from ')
      . $few_filename;
  }
  $self->{'description'} = $description;
}

sub _set_characteristics {
  my ($self, $keywords) = @_;
  ### _set_characteristics()
  ### $keywords

  if (! defined $keywords) {
    return; # if perhaps match of .html failed
  }

  $keywords =~ s{<[^>]*>}{}g;  # <foo ...> tags
  ### $keywords

  foreach my $key (split /[, \t]+/, ($keywords||'')) {
    ### $key
    $self->{'characteristic'}->{"OEIS_$key"} = 1;
  }

  # if ($self->{'characteristic'}->{'OEIS_cofr'}) {
  #   $self->{'characteristic'}->{'continued_fraction'} = 1;
  # }

  # "cons" means decimal digits of a constant
  # but don't reckon A000012 all-ones that way
  # "base" means non-decimal, it seems, maybe
  if ($self->{'characteristic'}->{'OEIS_cons'}
      && ! $self->{'characteristic'}->{'OEIS_base'}
      && $self->{'anum'} ne 'A000012') {
    $self->{'values_min'} = 0;
    $self->{'values_max'} = 9;
    $self->{'characteristic'}->{'digits'} = 10;
  }

  if (defined (my $description = $self->{'description'})) {
    if ($description =~ /expansion of .* in base (\d+)/i) {
      $self->{'values_min'} = 0;
      $self->{'values_max'} = $1 - 1;
      $self->{'characteristic'}->{'digits'} = $1;
    }
    if ($description =~ /^number of /i) {
      $self->{'characteristic'}->{'count'} = 1;
    }
  }
}

sub _split_sample_values {
  my ($self, $filename, $str, $offset) = @_;
  ### _split_sample_values(): $str
  unless (defined $str && $str =~ m{^([0-9,-]|\s)+$}) {
    croak "Oops list of sample values not recognised in ",$filename,"\n",
      (defined $str ? $str : ());
  }
  $self->{'array'} = [ split /[, \t\r\n]+/, $str ];
}

use constant::defer _HAVE_ENCODE => sub {
  eval { require Encode; 1 } || 0;
};
sub _decode_html_charset {
  my ($contents) = @_;

  # eg. <META http-equiv="content-type" content="text/html; charset=utf-8">
  # HTTP::Message has a blob of code for this, using the full HTTP::Parser,
  # but a slack regexp should be enough for OEIS pages.
  #
  if (_HAVE_ENCODE
      && $contents =~ m{<META[^>]+
                        http-equiv=[^>]+
                        content-type[^>]+
                        charset=([a-z0-9-_]+)}isx) {
    return Encode::decode($1, $contents, Encode::FB_PERLQQ());
  } else {
    return $contents;
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
