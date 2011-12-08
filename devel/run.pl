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

use 5.010;
use strict;
use warnings;
use POSIX;

#use Smart::Comments;

use lib 'devel/lib';

use constant DBL_INT_MAX => (FLT_RADIX**DBL_MANT_DIG - 1);


$|=1;

{
  my $pred_upto = 0;

  my $values_class;
  # $values_class = $gen->values_class('Abundant');
  # $values_class = $gen->values_class('Obstinate');
  # $values_class = $gen->values_class('Emirps');
  # $values_class = $gen->values_class('Repdigits');
  # $values_class = $gen->values_class('UndulatingNumbers');
  # $values_class = $gen->values_class('TernaryWithout2');
  # $values_class = $gen->values_class('PrimeQuadraticEuler');
  # $values_class = $gen->values_class('Base4Without3');
  # $values_class = $gen->values_class('Tribonacci');
  # $values_class = $gen->values_class('Perrin');
  # $values_class = $gen->values_class('Expression');
  # $values_class = $gen->values_class('Pentagonal');
  # $values_class = $gen->values_class('TwinPrimes');
  # # $values_class = $gen->values_class('DigitsModulo');
  # $values_class = $gen->values_class('RadixWithoutDigit');
  # $values_class = $gen->values_class('Odd');
  # $values_class = $gen->values_class('Factorials');
  # $values_class = $gen->values_class('SumTwoSquares');
  # $values_class = $gen->values_class('Palindromes');
  # # $values_class = $gen->values_class('MathSequence');
  # $values_class = $gen->values_class('DigitLength');
  # $values_class = $gen->values_class('DigitLengthCumulative');
  # $values_class = $gen->values_class('HypotCount');
  # $values_class = $gen->values_class('PrimeIndexCount');
  # $values_class = $gen->values_class('Loeschian');
  # $values_class = $gen->values_class('SumXsq3Ysq');
  # $values_class = $gen->values_class('ProthNumbers');
  # $values_class = $gen->values_class('DigitSumModulo');
  # $values_class = $gen->values_class('PrimeFactorCount');
  # $values_class = $gen->values_class('ReverseAddSteps');
  # $values_class = $gen->values_class('Harshad');
  # $values_class = $gen->values_class('TotientPerfect');
  # $values_class = $gen->values_class('FractionDigits');
  require Math::NumSeq::DigitLength;
  $values_class = 'Math::NumSeq::OEIS';
  $values_class = 'Math::NumSeq::SqrtDigits';
  $values_class = 'Math::NumSeq::DigitLength';
  $values_class = 'Math::NumSeq::DigitProduct';
  $values_class = 'App::MathImage::NumSeq::UndulatingNumbers';
  $values_class = 'App::MathImage::NumSeq::MobiusFunction';
  $values_class = 'Math::NumSeq::TwinPrimes';
  $values_class = 'Math::NumSeq::NumAronson';
  $values_class = 'Math::NumSeq::ReverseAdd';
  $values_class = 'App::MathImage::NumSeq::Pell';
  $values_class = 'Math::NumSeq::Factorials';
  $values_class = 'App::MathImage::NumSeq::KlarnerRado';
  $values_class = 'App::MathImage::NumSeq::DigitCountLow';
  $values_class = 'App::MathImage::NumSeq::DivisorCount';
  $values_class = 'Math::NumSeq::AsciiSelf';
  $values_class = 'Math::NumSeq::LiouvilleFunction';
  $values_class = 'Math::NumSeq::DigitCount';
  $values_class = 'App::MathImage::NumSeq::JugglerSteps';
  $values_class = 'Math::NumSeq::Kolakoski';
  $values_class = 'App::MathImage::NumSeq::GolombSequence';
  $values_class = 'Math::NumSeq::Primorials';
  $values_class = 'Math::NumSeq::MephistoWaltz';
  $values_class = 'App::MathImage::NumSeq::UlamSequence';
  $values_class = 'Math::NumSeq::Fibonacci';
  $values_class = 'App::MathImage::NumSeq::ReplicateDigits';
  $values_class = 'App::MathImage::NumSeq::SumTwoSquares';
  $values_class = 'Math::NumSeq::Polygonal';
  $values_class = 'App::MathImage::NumSeq::CunninghamChain';
  $values_class = 'App::MathImage::NumSeq::CunninghamPrimes';
  $values_class = 'Math::NumSeq::RadixWithoutDigit';
  $values_class = 'Math::NumSeq::FibonacciWord';
  $values_class = 'App::MathImage::NumSeq::FibbinaryBitCount';
  $values_class = 'Math::NumSeq::Fibbinary';
  $values_class = 'App::MathImage::NumSeq::ReRound';
  $values_class = 'Math::NumSeq::AlmostPrimes';
  $values_class = 'App::MathImage::NumSeq::DigitMiddle';
  $values_class = 'Math::NumSeq::PrimeFactorCount';
  $values_class = 'Math::NumSeq::PlanePathCoord';
  $values_class = 'Math::NumSeq::SternDiatomic';
  $values_class = 'Math::NumSeq::SqrtEngel';
  $values_class = 'App::MathImage::NumSeq::HappySteps';
  $values_class = 'App::MathImage::NumSeq::RepdigitRadix';
  $values_class = 'App::MathImage::NumSeq::Runs';
  $values_class = 'App::MathImage::NumSeq::HofstadterDiff';
  $values_class = 'App::MathImage::NumSeq::AllDigits';
  $values_class = 'App::MathImage::NumSeq::ConcatNumbers';
  $values_class = 'Math::NumSeq::TotientStepsSum';
  $values_class = 'App::MathImage::NumSeq::KolakoskiMajority';
  $values_class = 'App::MathImage::NumSeq::PlanePathDelta';
  $values_class = 'App::MathImage::NumSeq::SqrtContfrac';
  $values_class = 'Math::NumSeq::LucasNumbers';
  $values_class = 'Math::NumSeq::StarNumbers';
  $values_class = 'Math::NumSeq::ReverseAddSteps';
  $values_class = 'Math::NumSeq::Expression';

  eval "require $values_class; 1" or die $@;
  print Math::NumSeq::DigitLength->VERSION,"\n";
  my $seq = $values_class->new (
                                sqrt => 46,
                                including_self => 0,

                                expression_evaluator => 'MS',
                                expression => '2*i+1',
                                # # expression => 'z=3; z*x^2 + 3*x + 2',
                                # # expression => 'x^2 + 3*x + 2',
                                # # expression => 'atan(x)',
                                # expression => '9*i*i',

                                runs_type => '1to2N',
                                # factor_count => 8,
                                # multiplicity => 'distinct',
                                #
                                # round => 'lower',
                                # radix => 10,
                                #
                                # length => 2,
                                # which => 'last',

                                # polygonal => 6,
                                # pairs => 'average',

                                # planepath => 'SquareSpiral',
                                # coordinate_type => 'AbsDiff',
                                #planepath => 'CoprimeColumns',
                                #coordinate_type => 'DiffXY',
                                i_start => 1,
                                endian => 'little',

                                #planepath => 'Diagonals',
                                # planepath => 'ZOrderCurve,radix=10',
                                # i_start => 1,
                                # planepath => 'PythagoreanTree,coordinates=BA',
                                # planepath=>'RationalsTree,tree_type=CW',
                                # planepath => 'DivisibleColumns,divisor_type=proper',
                                planepath => 'HilbertCurve',
                                delta_type=>'Dir4',

                                # including_zero => 1,
                                # # divisors_type => 'proper',
                                # # algorithm_type => '1/2-3/2',
                                # # algorithm_type => '1/3-3/2',
                                # start => 1,
                                # fraction => '1/975',
                                # lo => 0,
                                # hi => 10, # 200*$rep,
                                # digit => 1,
                                # where => 'low',
                                # oeis_anum  => 'A000396',
                               );
  my $hi = 278;
  
  my $i_start = $seq->i_start;
  print "i_start $i_start\n";
  print "anum ",($seq->oeis_anum//'[undef]'),"\n";
  print "values_min ",($seq->values_min//'[undef]'),"\n";
  print "values_max ",($seq->values_max//'[undef]'),"\n";
  print "characteristic(monotonic) ",($seq->characteristic('monotonic')//'[undef]'),"\n";
  print "parameters: ",join(', ',map{$_->{'name'}}$seq->parameter_info_list),"\n";
  print "\n";

  my $values_min = $seq->values_min;
  my $values_max = $seq->values_max;
  my $saw_value_min;

  foreach my $rep (1 .. 2) {
    ### $seq
    if (my $radix = $seq->characteristic('digits')) {
      print "  radix $radix\n";
    }
    print "by next(): ";
    my $show_i = 1;

    my $check_pred_upto = ! $seq->characteristic('digits')
      && ! $seq->characteristic('count');
    foreach my $want_i ($i_start .. $i_start + $hi) {
      my ($i,$value) = $seq->next;
      if (! defined $i) {
        print "undef\n";
        last;
      }
      if (! defined $i) {
        print "undef\n";
        last;
      }
      if ($show_i) {
        print "i=$i ";
        $show_i = 0;
      }
      print "$value,";
      if (defined $values_min && $value < $values_min) {
        print " oops, value < values_min=$values_min\n";
      }
      if (defined $values_max && $value > $values_max) {
        print " oops, value < values_max=$values_max\n";
      }
      if (! defined $saw_value_min || $value < $saw_value_min) {
        $saw_value_min = $value;
      }
      if ($i != $want_i) {
        print " oops, i=$i expected $want_i\n";
      }

      if ($value > DBL_INT_MAX) {
        last;
      }


      if ($seq->can('pred')) {
        if (! $seq->pred($value)) {
          print " oops, pred($value) false\n";
        }
        unless ($seq->characteristic('count')
                || $seq->characteristic('smaller')
                || $value - $pred_upto > 1000) {
          while ($pred_upto < $value) {
            if ($seq->pred($pred_upto)) {
              print " oops, pred($pred_upto) is true\n";
            }
            $pred_upto++;
          }
          $pred_upto = $value+1;
        }
      }
      if ($seq->can('ith')) {
        my $ith_value = $seq->ith($i);
        if ($ith_value != $value) {
          print " oops, ith($i)=$ith_value next=$value\n";
        }
      }
    }
    print "\n";
    if (defined $values_min && $saw_value_min != $values_min) {
      print "hmm, saw_value_min=$saw_value_min not seq->values_min=$values_min\n";
    }
    if ($rep < 2) {
      print "rewind\n";
      $seq->rewind;
    }
  }

  if ($seq->can('ith')) {
    print "by ith():  ";
    foreach my $i ($seq->i_start .. $seq->i_start + $hi - 1) {
      my $value = $seq->ith($i);
      if (! defined $value) {
        print "undef\n";
        if ($i > 3) {
          last;
        } else {
          next;
        }
      }
      if (defined $value) {
        print "$value,";
        #print "$i=$value,";
      } else {
        print "$i,";
        $value=$i;
      }
      if ($value > DBL_INT_MAX) {
        last;
      }

      if ($seq->can('pred') && ! $seq->pred($value)) {
        print " oops, pred($value) false\n";
      }
    }
    print "\n";
  }

  if ($seq->can('pred')
      && ! ($seq->characteristic('count'))) {
    print "by pred(): ";
    foreach my $value (0 .. $hi - 1) {
      if ($seq->pred($value)) {
        print "$value,";
        #print "$i=$value,";
      }
      if ($value > DBL_INT_MAX) {
        last;
      }
    }
    print "\n";
  }

  foreach my $method ('ith','pred') {
    if ($seq->can($method)) {
      require Data::Float;
      print "$method(pos_infinity): ";
      print $seq->$method(Data::Float::pos_infinity())//'undef',"\n";
      print "$method(neg_infinity): ";
      print $seq->$method(Data::Float::neg_infinity())//'undef',"\n";
      {
        print "$method(nan): ";
        my $pred = $seq->$method(Data::Float::nan());
        print $pred//'undef',"\n";
        if ($method eq 'pred' && $pred) {
          print "     **** oops\n";
        }
        # if ($method eq 'ith' && defined $pred) {
        #   print "     **** maybe oops\n";
        # }
      }

      # Note: not "require Math::BigFloat" since it does tie-ins to BigInt
      # in its import
      eval "use Math::BigFloat; 1" or die;
      print "$method(biginf): ";
      print $seq->$method(Math::BigFloat->binf())//'undef',"\n";
      print "$method(neg biginf): ";
      print $seq->$method(Math::BigFloat->binf('-'))//'undef',"\n";
      {
        print "$method(bignan): ";
        my $pred = $seq->$method(Math::BigFloat->bnan);
        print $pred//'undef',"\n";
        if ($method eq 'pred' && $pred) {
          print "     **** oops\n";
        }
        if ($method eq 'ith' && defined $pred) {
          print "     **** maybe oops\n";
        }
      }
    }
  }
  print "done\n";
  exit 0;
}

{
  require App::MathImage::NumSeq::Tribonacci;
  my $seq = App::MathImage::NumSeq::Tribonacci->new (hi => 13);
  my @next = ( $seq->next,
               $seq->next,
               $seq->next,
               $seq->next,
               $seq->next,
               $seq->next );
  ### @next
  print $seq->pred(12),"\n";
  ### $seq
  exit 0;
}


{
  my $i;
  sub del {
    my ($n) = @_;
    # return 2 + ($] >= 5.006 ? 3 : 999);
    return $n * (1/sqrt(2));
  }
  my %read_signal = ('has-screen' => 'screen-changed',
                     style        => 'style-set',
                     toplevel     => 'hierarchy-changed');
  sub read_signals {
    my ($self) = @_;
    my $pname = $self->{'pname'};
    return ($read_signal{$pname} || "$pname-changed");
  }

  require Math::PlanePath::MultipleRings;
  require App::MathImage::NumSeq::PrimeQuadraticHonaker;
  require B::Concise;
  # B::Concise::compile('-exec',\&App::MathImage::NumSeq::PrimeQuadraticHonaker::pred)->();
  B::Concise::compile('-exec',\&Math::PlanePath::MultipleRings::_xy_to_d)->();
  exit 0;
}


{
  require Math::BigInt;
  Math::BigInt->import (try => 'GMP');

  require Devel::TimeThis;
  my $t = Devel::TimeThis->new('x');

  my $k = 2;
  my $bits = 500000;
  my $num = Math::BigInt->new($k);
  $num->blsft ($bits);
  ### num: "$num"
  $num->blog();
  # $num->bsqrt();
  ### num: "$num"
  my $str = $num->as_bin;
  ### $str

  # $num = Math::BigInt->new(1);
  # $num->blsft (length($str)-1);
  # ### num: "$num"

  exit 0;
}





{
  my @catalan = (1);
  foreach my $i (1 .. 20) {
    my $c = 0;
    foreach my $j (0 .. $#catalan) {
      $c += $catalan[$j]*$catalan[-1-$j];
    }
    $catalan[$i] = $c;
    print "$c\n";
  }
  exit 0;
}




{
  # # use Memoize;
  # # memoize('bell_number');
  # my @bell;
  # sub bell_number {
  #   my $n = shift;
  #   if ($n < @bell) {
  #     return $bell[$n];
  #   }
  #   return undef if $n < 0;
  #   return 1     if $n == 0;
  #   my $bell = 0;
  #   for (0 .. $n - 1) {
  #     my $bin = Math::Symbolic::AuxFunctions::binomial_coeff( $n - 1, $_ );
  #     $bell += bell_number($_) * $bin;
  #     ### $bin
  #     ### $bell
  #   }
  #   ### return: $bell
  #   $bell[$n] = $bell;
  #   return $bell;
  # }

  require Math::Symbolic::AuxFunctions;
  foreach my $i (1 .. 50) {
    my $b = Math::Symbolic::AuxFunctions::bell_number($i);
    # my $b = bell_number($i);
    printf "%2d  %f\n", $i, $b;
  }
  exit 0;
}
{
  require Module::Util;
  my @modules = Module::Util::find_in_namespace
    ('App::MathImage::NumSeq');
  ### @modules
  exit 0;
}


{
  sub base3 {
    my ($n) = @_;
    my $str = '';
    while ($n) {
      $str = ($n % 3) . $str;
      $n = int($n/3);
    }
    return $str;
  }
  foreach my $n (1 .. 20) {
    printf "%2d %4s\n", $n, base3($n);
  }

  require App::MathImage::Generator;
  my $gen = App::MathImage::Generator->new (fraction => '5/29',
                                            polygonal => 3);
  my $iter = $gen->values_make_ternary_without_2;
  foreach my $i (1 .. 20) {
    my $count = 0;
    my $n = $iter->();
    printf "%2d %4s\n", $n, base3($n);
  }
  exit 0;
}

{
  require Math::Trig;
  my $x;
  foreach (my $i = 1; $i < 10000000; $i++) {
    my $multiple = $i * 7;
    my $r = 0.5/sin(Math::Trig::pi()/$multiple);
    $x //= $r-1;
    if ($r - $x < 1) {
      printf "%2d %3d %8.3f  %6.3f\n", $i, $multiple, $r, $i*$x;
      die $i;
    }
    $x = $r;
  }
  exit 0;
}

{
  require POSIX;
  require Math::Trig;
  my $r = 1;
  my $theta = 0;
  my $ang = 0;
  foreach my $n (1 .. 100) {
    printf "%2d  ang=%.3f  %.3f %.3f %.3f\n",
      $n, $ang, $r, $ang, POSIX::fmod($ang, 2*3.14159);
    $ang = Math::Trig::asin(1/$r) / (2*3.14159);
    $theta += $ang;
    $r += $ang;
  }
  exit 0;
}

{
  require String::Parity;
  require String::BitCount;
  my $i = 0xFFFF01;
  my $s = pack('N', $i);
  $s = "\x{7FF}";
  my $b = [unpack('%32b*', $s)];
  my $p = 0; #String::Parity::isOddParity($s);
  my $c = 0; # String::BitCount::BitCount($s);
  ### $i
  ### $s
  ### $b
  ### $p
  ### $c
  exit 0;
}

{
  require Path::Class;
  require Scalar::Util;
  my $dir = Path::Class::dir('/', 'tmp');
  ### $dir
  my $reftype = Scalar::Util::reftype($dir);
  ### $reftype
  exit 0;
}
{
  require Scalar::Util;
  @ARGV = ('--values=xyz');
  Getopt::Long::GetOptions
      ('values=s'  => sub {
         my ($name, $value) = @_;
         ### $name
         ### ref: ref($name)
         my $reftype = Scalar::Util::reftype($name);
         ### $reftype
         ### $value
         ### ref: ref($value)
       });
  exit 0;
}

{
  require Getopt::Long;
  require Scalar::Util;
  @ARGV = ('--values=xyz');
  Getopt::Long::GetOptions
      ('values=s'  => sub {
         my ($name, $value) = @_;
         ### $name
         ### ref: ref($name)
         my $reftype = Scalar::Util::reftype($name);
         ### $reftype
         ### $value
         ### ref: ref($value)
       });
  exit 0;
}

{
  my $subr = sub {
    my ($s) = @_;
    return $s*(16*$s - 56) + 50;
     return 3*$s*$s - 4*$s + 2;
    return 2*$s*$s - 2*$s + 2;
    return $s*$s + .5;
    return $s*$s - $s + 1;
    return $s*($s+1)*.5 + 0.5;
  };
  my $back = sub {
    my ($n) = @_;
    return (7 + sqrt($n - 1)) / 4;
    return (2 + sqrt(3*$n - 2)) / 3;
    return .5 + sqrt(.5*$n-.75);
    return sqrt ($n - .5);
    # return -.5 + sqrt(2*$n - .75);
    #    return int((sqrt(4*$n-1) - 1) / 2);
  };
  my $prev = 0;
  foreach (1..15) {
    my $this = $subr->($_);
    printf("%2d  %.2f  %.2f  %.2f\n", $_, $this, $this-$prev,$back->($this));
    $prev = $this;
  }
  for (my $n = 1; $n < 100; $n++) {
    printf "%.2f  %.2f\n", $n,$back->($n);
  }
  exit 0;
}



{
  require Math::Libm;
  my $pi = Math::Libm::M_PI();
  $pi *= 2**30;
  print $pi,"\n";
  printf ("%b", $pi);
  exit 0;
}


{
  require Math::PlanePath::SquareSpiral;
  require Math::PlanePath::Diagonals;
  my $path = Math::PlanePath::SquareSpiral->new;
  # my $path = Math::PlanePath::Diagonals->new;
  # print $path->rect_to_n_range (0,0, 5,0);
  foreach (1 .. 1_000_000) {
    $path->n_to_xy ($_);
  }
  exit 0;
}

{
  require Math::Fibonacci;
  require POSIX;
  my $phi = (1 + sqrt(5)) / 2;
  foreach my $i (1 .. 1000) {
    my $theta = $i / ($phi*$phi);
    my $frac = $theta - POSIX::floor($theta);
    if ($frac < 0.02 || $frac > 0.98) {
      printf("%2d  %1.3f  %5.3f\n",
             $i, $frac, $theta);
    }
  }
  exit 0;
}

{
  require Math::Fibonacci;
  require POSIX;
  my $phi = (1 + sqrt(5)) / 2;
  foreach my $i (1 .. 40) {
    my $f = Math::Fibonacci::term($i);
    my $theta = $f / ($phi*$phi);
    my $frac = $theta - POSIX::floor($theta);
    printf("%2d  %10.2f  %5.2f  %1.3f  %5.3f\n",
           $i, $f, sqrt($f), $frac, $theta);
  }
  exit 0;
}
{
  require Math::Fibonacci;
  my @f = Math::Fibonacci::series(90);
  local $, = ' ';
  print @f,"\n";

  foreach my $i (1 .. $#f) {
    if ($f[$i] > $f[$i]) {
      print "$i\n";
    }
  }
  my @add = (1, 1);
  for (;;) {
    my $n = $add[-1] + $add[-2];
    if ($n > 2**53) {
      last;
    }
    push @add, $n;
  }
  print "add count ",scalar(@add),"\n";
  foreach my $i (0 .. $#add) {
    if ($f[$i] != $add[$i]) {
      print "diff $i    $f[$i] != $add[$i]    log ",log($add[$i])/log(2),"\n";
    }
  }
  exit 0;
}

#     my $count = POSIX::ceil (log($n_pixels * sqrt(5)) / log(PHI));
#     @add = Math::Fibonacci::series ($count);
#     if ($option_verbose) {
#       print "fibonacci $count add to $add[-1]\n";
#     }

# miss 1928099
{
  require Math::Prime::XS;
  my @array = Math::Prime::XS::sieve_primes (1, 2000000);
  $,="\n";
#  print @array;
  exit 0;
}

