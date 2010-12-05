use strict;
use warnings FATAL => 'all';
use Test::More qw(no_plan);

use Scalar::Util qw(blessed);

use IO::Pipeline;

my $source = <<'END';
abc
def
123
456
END

sub input_fh {
  open my $in, '<', \$source;
  return $in;
}

my $out;
my $pipe = input_fh
  | pmap  { blessed($_) and die( "Found control object\n" ); $_ }
  | pgrep { blessed($_) and die( "Found control object\n" ); 1 }
  | psink { blessed($_) and die( "Found control object\n" ); $out .= $_ };

is($out, $source, 'No control objects in the output');


# ppool { }


