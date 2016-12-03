# NAME

Chart::Dygraphs - Generate html/javascript charts from perl data using javascript library Dygraphs

# SYNOPSYS

    use Chart::Dygraphs qw(show_plot);
    
    my $data = [map {[$_, rand($_)]} 1..10 ];
    show_plot($data);

    use Chart::Dygraphs qw(show_plot);
    use DateTime;
    
    my $start_date = DateTime->now(time_zone => 'UTC')->truncate(to => 'hour');
    my $time_series_data = [map {[$start_date->add(hours => 1)->clone(), rand($_)]} 1..1000];
    
    show_plot($time_series_data);

# DESCRIPTION

Generate html/javascript charts from perl data using javascript library Dygraphs. The result
is html that you could see in your favourite browser.

The interface is "sub" oriented, but the API is subject to changes.

# FUNCTIONS

## render\_full\_html

### Parameters

- data:

    Data to be represented. The format is the perl version of the data expected by Dygraphs: [http://dygraphs.com/data.html](http://dygraphs.com/data.html)

- options:

    Hashref with options for graph. The format is the perl version of the options expected by Dygraphs: [http://dygraphs.com/options.html](http://dygraphs.com/options.html)
    Optional

- render\_html\_options

    Hashref with options controlling html output. With this you can inject html, javascript or styles.

    Supported options:

    - pre\_graph\_html
    - post\_graph\_html
    - dygraphs\_div\_id
    - dygraphs\_javascript\_object\_name
    - dygraphs\_div\_inline\_style

## show\_plot

Opens the plot in a browser locally

### Parameters

Data to be represented. The format is the same as the parameter data in render\_full\_html

# AUTHOR

Pablo Rodr�guez Gonz�lez

# BUGS

Please report any bugs or feature requests via github: [https://github.com/pablrod/p5-Chart-Dygraphs/issues](https://github.com/pablrod/p5-Chart-Dygraphs/issues)

# LICENSE AND COPYRIGHT

Copyright 2016 Pablo Rodr�guez Gonz�lez.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

[http://www.perlfoundation.org/artistic\_license\_2\_0](http://www.perlfoundation.org/artistic_license_2_0)

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
