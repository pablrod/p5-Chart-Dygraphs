package Chart::Dygraphs;

use strict;
use warnings;
use utf8;

use Exporter 'import';
our @EXPORT_OK = qw(show_plot);

use JSON;
use Params::Validate qw(:all);
use Text::Template;
use HTML::Show;
use Ref::Util;

# VERSION

# ABSTRACT: Generate html/javascript charts from perl data using javascript library Dygraphs

=encoding utf-8

=head1 SYNOPSIS

# EXAMPLE: examples/basic.pl

# EXAMPLE: examples/time_series.pl

=head1 DESCRIPTION

Generate html/javascript charts from perl data using javascript library Dygraphs. The result
is html that you could see in your favourite browser.

Example screenshot of plot generated with examples/time_series.pl:

=begin HTML

<p>
<img src="https://raw.githubusercontent.com/pablrod/p5-Chart-Dygraphs/master/examples/time_series.png" alt="Random time series plotted with Dygraphs">
</p>

=end HTML

=begin markdown

![Random time series plotted with Dygraphs](https://raw.githubusercontent.com/pablrod/p5-Chart-Dygraphs/master/examples/time_series.png)

=end markdown

The API is subject to changes.

=cut

=head1 FUNCTIONS

=cut

=head2 render_full_html

=head3 Parameters

=over

=item * data:

Data to be represented. The format is the perl version of the data expected by Dygraphs: L<http://dygraphs.com/data.html>

=item * options:

Hashref with options for graph. The format is the perl version of the options expected by Dygraphs: L<http://dygraphs.com/options.html>
Optional

=item * render_html_options

Hashref with options controlling html output. With this you can inject html, javascript or styles.

Supported options:

=over

=item * pre_graph_html

=item * post_graph_html

=item * dygraphs_div_id

=item * dygraphs_javascript_object_name

=item * dygraphs_div_inline_style

=back

=back

=cut

sub render_full_html {
    my %params = validate( @_,
                           {  data    => { type => SCALAR | ARRAYREF | OBJECT},
                              options => { type => HASHREF, default => { showRangeSelector => 1 } },
                              render_html_options => { type     => HASHREF,
                                                       optional => 1,
                                                       default  => {}
                              }
                           }
    );
    return _render_html_wrap(
           _render_cell( _process_data_and_options( @params{qw(data options)} ), $params{'render_html_options'}, '' ) );
}

sub _transform_data {
    my $data        = shift;
    my $string_data = "";
    if ( Ref::Util::is_plain_arrayref($data) ) {
        $string_data .= "[" . ( join( ',', map { _transform_data($_) } @$data ) ) . "]";
    } elsif ( Ref::Util::is_plain_hashref($data) ) {
        return "not supported";
    } elsif ( Ref::Util::is_blessed_ref($data) && $data->isa('DateTime') ) {
        return 'new Date("' . $data . '")';
    } else {
        return $data;
    }
    return $string_data;
}

sub _process_data_and_options {
    my $data           = shift();
    my $options        = shift();
    my $json_formatter = JSON->new->utf8;
    local *PDL::TO_JSON = sub { $_[0]->unpdl };
    if ( Ref::Util::is_blessed_ref($data) ) {
        my $adapter_name = 'Chart::Dygraphs::Adapter::' . ref $data;
        eval {
            load $adapter_name;
            my $adapter = $adapter_name->new( data => $data );
            $data = $adapter->series();
        };
        if ($@) {
            warn 'Cannot load adapter: ' . $adapter_name . '. ' . $@;
        }
    }
    return join( ',', _transform_data($data), $json_formatter->encode($options) );
}

sub _render_cell {

    my $data         = shift();
    my $html_options = shift();
    my $id           = shift();
    my $template     = <<'TEMPLATE';
{$pre_graph_html}
<div id="{$dygraphs_div_id}" style="{$dygraphs_div_inline_style}"></div>
<script type="text/javascript">
  {$dygraphs_javascript_object_name} = new Dygraph(
    document.getElementById("{$dygraphs_div_id}"),
    {$data_and_options}
  );

  var range = {$dygraphs_javascript_object_name}.yAxisRange(0);
  {$dygraphs_javascript_object_name}.updateOptions(\{valueRange: range\});
</script>
{$post_graph_html}
TEMPLATE
    my $template_variables = { %{$html_options}, data_and_options => $data, };

    if ( !defined $template_variables->{'dygraphs_div_id'} ) {
        $template_variables->{'dygraphs_div_id'} = 'graphdiv' . $id;
    }
    if ( !defined $template_variables->{'dygraphs_javascript_object_name'} ) {
        $template_variables->{'dygraphs_javascript_object_name'} = 'g' . $id;
    }
    if ( !defined $template_variables->{'dygraphs_div_inline_style'} ) {
        $template_variables->{'dygraphs_div_inline_style'} = 'width: 100%';
    }
    my $renderer = Text::Template->new( TYPE => 'STRING', SOURCE => $template );
    return $renderer->fill_in( HASH => $template_variables );
}

sub _render_html_wrap {
    my $body = shift();

    my $html_begin = <<'BEGIN_HTML';
<html>
<head>
<script src="https://cdnjs.cloudflare.com/ajax/libs/dygraph/1.1.1/dygraph-combined.js"></script>
</head>
<body>
BEGIN_HTML

    my $html_end = <<'END_HTML';
</body>
</html>
END_HTML

    return $html_begin . $body . $html_end;

}

=head2 show_plot

Opens the plot in a browser locally

=head3 Parameters

Data to be represented. The format is the same as the parameter data in render_full_html

=cut

sub show_plot {
    my @data_to_plot = @_;

    my $rendered_cells = "";
    my $numeric_id     = 0;
    for my $data (@data_to_plot) {
        if ( ref $data eq 'Chart::Dygraphs::Plot' ) {
            $rendered_cells .= _render_cell( _process_data_and_options( $data->data, $data->options ),
                                             {  dygraphs_div_id                 => 'graphdiv' . $numeric_id,
                                                dygraphs_javascript_object_name => 'g' . $numeric_id
                                             },
                                             'chart_' . $numeric_id++
            );

        } else {
            $rendered_cells .= _render_cell( _process_data_and_options( $data, { showRangeSelector => 1 } ),
                                             {  dygraphs_div_id                 => 'graphdiv' . $numeric_id,
                                                dygraphs_javascript_object_name => 'g' . $numeric_id
                                             },
                                             'chart_' . $numeric_id++
            );
        }
    }
    my $plots = _render_html_wrap($rendered_cells);
    HTML::Show::show($plots);
}

1;

__END__

=head1 BUGS

Please report any bugs or feature requests via github: L<https://github.com/pablrod/p5-Chart-Dygraphs/issues>

=cut 


