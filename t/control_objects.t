use strict;
use warnings FATAL => 'all';
use Test::More qw(no_plan);

use Scalar::Util qw(blessed);

use IO::Pipeline;

# Regression test: make sure control objects don't interfere
my $source = q{
abc
xyz
123
def
456
};

sub input_fh {
  my ($string_ref) = @_;
  open my $in, '<', $string_ref;
  return $in;
}

my $out;
my $pipe = input_fh(\$source)
  | pmap  { blessed($_) and die( "Found control object\n" ); $_ }
  | pgrep { blessed($_) and die( "Found control object\n" ); 1 }
  | psink { blessed($_) and die( "Found control object\n" ); $out .= $_ };

is($out, $source, 'No control objects in the output');


# ppool




# psort


