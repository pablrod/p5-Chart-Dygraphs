package Chart::Dygraphs;

use strict;
use warnings;
use utf8;

use JSON;
use Params::Validate qw(:all);
use Text::Template;

=encoding utf-8

=head1 NAME

Chart::Dygraphs - Generate html/javascript charts from perl data using javascript library Dygraphs

=head1 SYNOPSYS

    use Chart::Dygraphs;
    use Browser::Open qw( open_browser );
    use Path::Tiny;
    use DateTime;
    
    my $data = [map {[$_, rand($_)]} 1..10 ];
    my $html_file = Path::Tiny::tempfile(UNLINK => 0);
    
    $html_file->spew_utf8(Chart::Dygraphs::render_full_html(data => $data));
   
    open_browser($html_file->canonpath()); 

    my $start_date = DateTime->now(time_zone => 'UTC')->truncate(to => 'hour');
    my $time_series_data = [map {[$start_date->add(hours => 1)->clone(), rand($_)]} 1..1000];
    
    my $time_series_html_file = Path::Tiny::tempfile(UNLINK => 0);
    $time_series_html_file->spew_utf8(Chart::Dygraphs::render_full_html(data => $time_series_data));

    open_browser($time_series_html_file->canonpath());
     
=head1 DESCRIPTION

Generate html/javascript charts from perl data using javascript library Dygraphs. The result
is a file that you could see in your favourite browser.

This module does not export anything and the interface is "sub" oriented, but the API is subject to changes.

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
                           {  data    => { type => SCALAR | ARRAYREF },
                              options => { type => HASHREF, default => { showRangeSelector => 1 } },
                              render_html_options => {
                                    type     => HASHREF,
                                    optional => 1,
                                    default => { dygraphs_div_id => 'graphdiv', dygraphs_javascript_object_name => 'g' }
                              }
                           }
    );

    my $template = <<'DYGRAPH_TEMPLATE';
<html>
<head>
<script src="https://cdnjs.cloudflare.com/ajax/libs/dygraph/1.1.1/dygraph-combined.js"></script>
<style>
#{$dygraphs_div_id} \{ position: absolute; left: 20px; right: 20px; top: 20px; bottom: 20px; \}
</style>
</head>
<body>
{$pre_graph_html}
<div id="{$dygraphs_div_id}" style="{$dygraphs_div_inline_style}"></div>
<script type="text/javascript">
  {$dygraphs_javascript_object_name} = new Dygraph(
    document.getElementById("{$dygraphs_div_id}"),
    {$data_and_options}
  );

  var range = {$dygraphs_javascript_object_name}.yAxisRange(0);
  {$dygraphs_javascript_object_name}.updateOptions({valueRange: range});
</script>
{$post_graph_html}
</body>
</html>
DYGRAPH_TEMPLATE

    my $transform_data;
    $transform_data = sub {
        my $data        = shift;
        my $string_data = "";
        if ( ref $data eq 'ARRAY' ) {
            $string_data .= "[" . ( join( ',', map { $transform_data->($_) } @$data ) ) . "]";
        } elsif ( ref $data eq 'HASH' ) {
            return "not supported";
        } elsif ( ref $data eq 'DateTime' ) {
            return 'new Date("' . $data . '")';
        } else {
            return $data;
        }
        return $string_data;
    };
    my $data_string = $transform_data->( $params{'data'} );

    my $json_formatter = JSON->new->utf8;
    my $template_variables = {
                           %{ $params{'render_html_options'} },
                           data_and_options => join( ',', $data_string, $json_formatter->encode( $params{'options'} ) ),
    };

    if ( ! defined $template_variables->{'dygraphs_div_id'} ) {
        $template_variables->{'dygraphs_div_id'} = 'graphdiv';
    }
    if ( ! defined $template_variables->{'dygraphs_javascript_object_name'} ) {
        $template_variables->{'dygraphs_javascript_object_name'} = 'g';
    }

    return Text::Template::fill_in_string( $template, HASH => $template_variables );
}

1;

__END__

=head1 AUTHOR

Pablo Rodríguez González

=head1 BUGS

Please report any bugs or feature requests via github: L<https://github.com/pablrod/p5-Chart-Dygraphs/issues>

=head1 LICENSE AND COPYRIGHT

Copyright 2016 Pablo Rodríguez González.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES . THE IMPLIED WARRANTIES OF MERCHANTABILITY,
            FITNESS FOR A PARTICULAR
              PURPOSE,                                 OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
              YOUR LOCAL LAW . UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
              CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
              CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
            EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE
              .

=cut

