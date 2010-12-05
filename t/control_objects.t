use strict;
use warnings FATAL => 'all';
use Test::More qw(no_plan);

use Scalar::Util qw(blessed);

use IO::Pipeline;

sub input_fh {
  my ($string_ref) = @_;
  open my $in, '<', $string_ref;
  return $in;
}

# Regression test: make sure control objects don't interfere
my $source = q{abc
xyz
123
def
456
};

{
  my $out;
  my $pipe = input_fh(\$source)
    | pmap  { blessed($_) and die( "Found control object\n" ); $_ }
    | pgrep { blessed($_) and die( "Found control object\n" ); 1 }
    | psink { blessed($_) and die( "Found control object\n" ); $out .= $_ };

  is($out, $source, 'No control objects in the output');
}

# ppool
{
  my @pool;
  my $out;
  my $pipe = input_fh(\$source)
    | pmap  { $_ }
    | ppool(
        sub { },
        sub { push(@pool,$_);     return ();    },
        sub { @pool = sort @pool; return @pool; }
      )
    | psink { $out .= $_ };

  my $sorted_source = join("\n", sort split(/\n/, $source)) . "\n";
  is($out, $sorted_source, 'Output is sorted in the pool');
}



