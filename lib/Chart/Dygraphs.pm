package Chart::Dygraphs;

use strict;
use warnings;
use utf8;

use JSON;
use Params::Validate qw(:all);

our $VERSION = 0.001;

=encoding utf-8

=head1 NAME

Chart::Dygraphs - Generate html/javascript charts from perl data using javascript library Dygraphs

=cut

sub render_full_html {
    my %params = validate( @_,
                           {
                              data => { type    => SCALAR | ARRAYREF,
                                        default => [ [ '1', 100, 200 ], [ '2', 150, 220 ] ]
                              },
                              options => { type => HASHREF, default => {} }
                           }
    );

    my $template_first_part = <<'FIRST_PART_DYGRAPH';
<html>
<head>
<script src="https://cdnjs.cloudflare.com/ajax/libs/dygraph/1.1.1/dygraph-combined.js"></script>
</head>
<body>
<div id="graphdiv"></div>
<script type="text/javascript">
  g = new Dygraph(
    document.getElementById("graphdiv"),
    
FIRST_PART_DYGRAPH

    my $template_second_part = <<'SECOND_PART_DYGRAPH';
  );
</script>
</body>
</html>
SECOND_PART_DYGRAPH

    return
        $template_first_part
      . join( ',', map { to_json( $_, { allow_nonref => 1 } ) } @params{qw(data options)} )
      . $template_second_part;
}

1;
