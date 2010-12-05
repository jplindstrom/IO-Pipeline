use strict;
use warnings FATAL => 'all';
use IO::Pipeline;
use Test::More qw(no_plan);

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
  | pmap { $_ }
  | psink { $out .= $_ };

is($out, $source, 'No control objects in the output');


# ppool
