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

package Math::NumSeq::Expression;
use 5.004;
use strict;
use Carp;
use List::Util;
use Math::Libm;
use Module::Util;

use Math::NumSeq;
use base 'Math::NumSeq';

use vars '$VERSION';
$VERSION = 6;

# uncomment this to run the ### lines
#use Devel::Comments;

my ($have_MS, $have_MEE, $have_LE, @evaluators);
BEGIN {
  my $have_MS
    = defined(Module::Util::find_installed('Math::Symbolic'));
  my $have_MEE
    = defined(Module::Util::find_installed('Math::Expression::Evaluator'));
  my $have_LE
    = defined(Module::Util::find_installed('Language::Expr'));
  ### $have_MS
  ### $have_MEE
  ### $have_LE

  @evaluators = ('Perl',
                 ($have_MS  ? 'MS'  : ()),
                 ($have_MEE ? 'MEE' : ()),
                 ($have_LE  ? 'LE'  : ()));
  ### @evaluators
}

use constant name => Math::NumSeq::__('Arbitrary Expression');
use constant description =>
  join ("\n",
        Math::NumSeq::__('An arbitrary expression.  It should be a function of \"i\" at 0,1,2, etc.  For example (2*i)^2 would give the even perfect squares.

Syntax is per the chosen evaluator, an invalid expression displays an error message.
Perl (the default) is either 2*i+1 or 2*$i+1.'),

        ($have_MS ?
         Math::NumSeq::__('Math::Symbolic is like 2*i^2.')
         : ()),

        ($have_MEE ?
         Math::NumSeq::__('Math::Expression::Evaluator is like t=2*i;t^2')
         : ()),

        ($have_LE ?
         Math::NumSeq::__('Language::Expr is like $k**2 + $k - 1.')
         : ()));

use constant parameter_info_array =>
  [
   { name    => 'expression',
     display => Math::NumSeq::__('Expression'),
     type    => 'string',
     default => '3*i*i + i + 2',
     width   => 30,
     description => Math::NumSeq::__('A mathematical expression giving values to display, for example x^2+x+41.  Only one variable is allowed, see the chosen evaluator Math::Symbolic or Math::Expression::Evaluator for possible operators and function.'),
   },
   { name    => 'expression_evaluator',
     display => Math::NumSeq::__('Evaluator'),
     type    => 'enum',
     default => $evaluators[0],
     choices => \@evaluators,
     description => Math::NumSeq::__('The expression evaluator module, Perl for Perl itself, MS for Math::Symbolic, MEE for Math::Expression::Evaluator, LE for Language::Expr.'),
   },
                                     ];

# ### parameter_info_array: parameter_info_array()
# ### parameter_info_hash: __PACKAGE__->parameter_info_hash
# ### evaluator default: __PACKAGE__->parameter_default('expression_evaluator')

{
  package Math::NumSeq::Expression::LanguageExpr;
  use List::Util 'min', 'max';
  our $pi = Math::Libm::M_PI();
  our $e = Math::Libm::M_E();
  our $phi = (1+sqrt(5))/2;
  our $gam = 0.5772156649015328606065120;
}

sub new {
  my ($class, %options) = @_;
  my $lo = $options{'lo'} || 0;
  my $expression = $options{'expression'};
  if (! defined $expression) {
    $expression = $class->parameter_default('expression');
  }

  my $evaluator = $options{'expression_evaluator'}
    || $class->parameter_default('expression_evaluator')
      || croak "No expression evaluator modules available";
  ### $evaluator

  my $subr;
  if ($evaluator eq 'Perl') {
    require Safe;
    my $safe = Safe->new;
    $safe->permit('print',
                  ':base_math',  # sqrt(), rand(), etc
                 );
    if (eval { require List::Util; 1 }) {
      $safe->share_from('List::Util', [ 'min','max' ]);
    }
    require POSIX;
    $safe->share_from('POSIX', [ 'floor','ceil' ]);
    require Math::Trig;
    $safe->share_from('Math::Trig', [qw(tan
                                        asin acos atan
                                        csc cosec sec cot cotan
                                        acsc acosec asec acot acotan
                                        sinh cosh tanh
                                        csch cosech sech coth cotanh
                                        asinh acosh atanh
                                        acsch acosech asech acoth acotanh
                                      )]);
    require Math::Libm;
    $safe->share_from('Math::Libm', [qw(cbrt
                                        erf
                                        erfc
                                        expm1
                                        hypot
                                        j0
                                        j1
                                        jn
                                        lgamma_r
                                        log10
                                        log1p
                                        pow
                                        rint
                                        y0
                                        y1
                                        yn)]);

    my $pi = Math::Libm::M_PI();
    my $e  = Math::Libm::M_E();
    $subr = $safe->reval("#line ".(__LINE__+2)." \"".__FILE__."\"\n"
                         . <<"HERE");
my \$pi = $pi;
my \$e = $e;
my \$phi = (1+sqrt(5))/2;
my \$gam = 0.5772156649015328606065120;
my \$i;
sub i () { return \$i }
sub {
  \$i = \$_[0];
  return do { $expression }
}
HERE
    ### $subr
    if (! $subr) {
      croak "Invalid or unsafe expression: $@\n";
    }

  } elsif ($evaluator eq 'MS') {
    require Math::Symbolic;
    my $tree = Math::Symbolic->parse_from_string($expression);
    if (! defined $tree) {
      croak "Cannot parse MS expression: $expression";
    }

    # simplify wrong result on x+(-5)*y before 0.605 ...
    if (eval { $tree->VERSION(0.605); 1 }) {
      $tree = $tree->simplify;
    }

    my @vars = $tree->signature;
    if (@vars > 1) {
      croak "More than one variable in MS expression: $expression\n(simplified to $tree)";
    }
    ### code: $tree->to_code
    ($subr) = $tree->to_sub(\@vars);
    ### $subr

  } elsif ($evaluator eq 'MEE') {
    require Math::Expression::Evaluator;
    my $me = Math::Expression::Evaluator->new;
    $me->set_function('min', \&List::Util::min);
    $me->set_function('max', \&List::Util::max);
    $me->parse('pi='.Math::Libm::M_PI()
               .'; e='.Math::Libm::M_E()
               .'; phi=(1+sqrt(5))/2'
               .'; gam=0.5772156649015328606065120');
    $me->val;

    eval { $me->parse ($expression); 1 }
      or croak "Cannot parse MEE expression: $expression\n$@";

    # my @vars = $me->variables;
    my @vars = _me_free_variables($me);
    if (@vars > 1) {
      croak "More than one variable in MEE expression: $expression";
    }

    my $hashsub = $me->compiled;
    ### $hashsub
    ### _ast_to_perl: $me->_ast_to_perl($me->{ast})

    my $v = $vars[0];
    my %vars;
    $subr = sub {
      $vars{$v} = $_[0];
      return &$hashsub(\%vars);
    };

  } elsif ($evaluator eq 'LE') {
    require Language::Expr;
    my $le = Language::Expr->new;
    my $varef;
    eval { $varef = $le->enum_vars ($expression); 1 }
      or croak "Cannot parse LE expression: $expression\n$@";
    ### $varef
    my @vars = grep {   # only vars, not functions as such
      do {
        no strict;
        ! defined ${"Math::NumSeq::Expression::LanguageExpr::$_"}
      }
    } @$varef;
    if (@vars > 1) {
      croak "More than one variable in LE expression: $expression";
    }

    require Language::Expr::Compiler::Perl;
    my $pe = Language::Expr::Compiler::Perl->new;
    my $perlstr;
    eval { $perlstr = $pe->perl ($expression); 1 }
      or croak "Cannot parse LE expression: $expression\n$@";

    my $v = $vars[0] || 'k';
    ### $v
    ### eval: "sub { my \$$v = \$_[0]; $perlstr }"
    $subr = eval "package Math::NumSeq::Expression::LanguageExpr;
                  use strict;
                  sub { my \$$v = \$_[0]; $perlstr }"
      or croak "Cannot compile $expression\n$perlstr\n$@";
    ### $subr
    ### at zero: $subr->(0)

  } else {
    croak "Unknown evaluator: $evaluator";
  }

  my $self = bless { 
                     # hi    => $options{'hi'},
                     subr  => $subr,
                   }, $class;
  $self->rewind;
  return $self;
}

sub rewind {
  my ($self) = @_;
  $self->{'i'} = 0;
  $self->{'above'} = 0;
}

# $me is a Math::Expression::Evaluator
# return a list of the free variables in it
sub _me_free_variables {
  my ($me) = @_;
  my %assigned = %{$me->{'variables'}};
  my %free;
  my @pending = ($me->{'ast'});
  while (@pending) {
    my $node = shift @pending;
    ref $node or next;
    # ### $node
    push @pending, @$node[1..$#$node];

    if ($node->[0] eq '$') {
      my $varname = $node->[1];
      if (! $assigned{$varname}) {
        ### free: $varname
        $free{$varname} = 1;
      }
    } elsif ($node->[0] eq '=') {
      my $vnode = $node->[1];
      if ($vnode->[0] eq '$') {
        ### assigned: $vnode->[1]
        $assigned{$vnode->[1]} = 1;
      }
    }
  }
  return keys %free;
}

sub next {
  my ($self) = @_;
  my $i = $self->{'i'}++;

  for (;;) {
    if ($self->{'above'} >= 10) {  #  || $i > $self->{'hi'}
      return;
    }
    my $n = eval { $self->{'subr'}->($i) };
    if (! defined $n) {
      # eg. division by zero
      ### expression undef: $@
      $self->{'above'}++;
      next;
    }
    ### expression result: $n
    # if ($n > $self->{'hi'}) {
    #   $self->{'above'}++;
    # }
    return ($i, $n);
  }
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::Expression -- mathematical expression values

=head1 SYNOPSIS

 use Math::NumSeq::Expression;
 my $seq = Math::NumSeq::Expression->new (expression => '2*i+1');
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

A string expression evaluated at i=0, 1, 2, etc, by a choice of evaluator
modules.

This is designed to take expression strings from user input, though could be
used for something quick from program code too.

=head2 Perl

The default C<expression_evaluator =E<gt> 'Perl'> evaluates with Perl
itself.  This is always available.  Expressions are with the C<Safe> module
to restrict to arithmetic.

The i value is in a C<$i> variable and an C<i> function.  The C<i> function
is prototyped like a constant.

    i+1
    2*$i - 2

The functions made available include

    atan2 sin cos exp log                 \    Perl builtins
      sqrt rand                           /
    min max                               List::Util
    floor ceil                            POSIX module
    cbrt hypot erf erfc expm1             \
      j0 j1 jn lgamma_r log10              |  Math::Libm
      log1p pow rint y0 y1 yn             /
    tan asin acos atan                    \
      csc cosec sec cot cotan              |  Math::Trig
      acsc acosec asec acot acotan         |
      sinh cosh tanh                       |
      csch cosech sech coth cotanh         |
      asinh acosh atanh                    |
      acsch acosech asech acoth acotanh   /

=head2 Math-Symbolic

C<expression_evaluator =E<gt> 'MS'> selects the C<Math::Symbolic> module, if
available.

The expression should use a single variable, which can be any name, and
takes the C<$i> index in the sequence.

The usual C<Math::Symbolic> C<simplify()> is applied to perhaps reduce the
expression a bit, then its C<to_sub()> for actual evaluation.

=head2 Math-Expression-Evaluator

C<expression_evaluator =E<gt> 'MEE'> selects the
C<Math::Expression::Evaluator> module, if
available.

The expression should use a single input variable, which can be any name,
and takes the C<$i> index in the sequence.  Temporary variables can be
assigned to, as for instance

    t=2*i; t^2

The expression is compiled with the C<Math::Expression::Evaluator>
C<compiled()> method for actual evaluation.

=head2 Language-Expr

C<expression_evaluator =E<gt> 'LE'> selects the C<Language::Expr> module, if
available.  See L<Language::Expr::Manual::Syntax> for its expression syntax.

The expression should use a single variable, of any name, which will be the
C<$i> index in the sequence.

The expression is compiled with L<Language::Expr::Compiler::Perl> for
evaluation.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::Expression-E<gt>new (radix =E<gt> $r, modulus =E<gt> $d)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the C<expression> evaluated at C<$i>.

=back

=head1 BUGS

C<Safe.pm> seems a bit of a slowdown.  Is that right or is it supposed to
validate ops during the eval which compiles a subr?

=head1 SEE ALSO

L<Math::NumSeq>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2010, 2011 Kevin Ryde

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
