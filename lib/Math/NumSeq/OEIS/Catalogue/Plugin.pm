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

package Math::NumSeq::OEIS::Catalogue::Plugin;
use 5.004;
use strict;

use vars '$VERSION';
$VERSION = 25;

# uncomment this to run the ### lines
#use Smart::Comments;

my %anum_to_info_hashref;
sub anum_to_info_hashref {
  my ($class) = @_;
  ### anum_to_info_hashref(): $class
  return ($anum_to_info_hashref{$class} ||=
          { map { $_->{'anum'} => $_ } @{$class->info_arrayref} });
}

sub anum_to_info {
  my ($class, $anum) = @_;
  return $class->anum_to_info_hashref->{$anum};
}

sub anum_after {
  my ($class, $after_anum) = @_;
  ### $after_anum
  my $ret;
  foreach my $info (@{$class->info_arrayref}) {
    ### after info: $info
    if ($info->{'anum'} gt $after_anum
        && (! defined $ret || $ret gt $info->{'anum'})) {
      $ret = $info->{'anum'};
    }
  }
  return $ret;
}
sub anum_before {
  my ($class, $before_anum) = @_;
  ### $before_anum
  my $ret;
  foreach my $info (@{$class->info_arrayref}) {
    if ($info->{'anum'} lt $before_anum
        && (! defined $ret || $ret lt $info->{'anum'})) {
      $ret = $info->{'anum'};
    }
  }
  return $ret;
}

sub anum_first {
  my ($class, $after_num) = @_;
  return $class->anum_after('A000000');
}
sub anum_last {
  my ($class, $before_num) = @_;
  return $class->anum_before('A1000000');
}

1;
__END__

=for stopwords Ryde Math-NumSeq pluggable

=head1 NAME

Math::NumSeq::OEIS::Catalogue::Plugin -- pluggable catalogue extensions

=for test_synopsis my @ISA

=head1 SYNOPSIS

 package Math::NumSeq::OEIS::Catalogue::Plugin::MySeqs;
 use Math::NumSeq::OEIS::Catalogue::Plugin;
 @ISA = 'Math::NumSeq::OEIS::Catalogue::Plugin';
 # ...

=head1 DESCRIPTION

This is an internal part of C<Math::NumSeq::OEIS::Catalogue> not yet meant
for general use yet, but the intention is for add-on sequences to declare
themselves in the A-number catalogue.

=head1 SEE ALSO

L<Math::NumSeq::OEIS::Catalogue>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2011 Kevin Ryde

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

