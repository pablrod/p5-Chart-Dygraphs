# NAME

Chart::Dygraphs - Generate html/javascript charts from perl data using javascript library Dygraphs

# VERSION

version 0.007

# SYNOPSIS

```perl
use Chart::Dygraphs qw(show_plot);

my $data = [map {[$_, rand($_)]} 1..10 ];
show_plot($data);

use Chart::Dygraphs qw(show_plot);
use DateTime;

my $start_date = DateTime->now(time_zone => 'UTC')->truncate(to => 'hour');
my $time_series_data = [map {[$start_date->add(hours => 1)->clone(), rand($_)]} 1..1000];

show_plot($time_series_data);
```

# DESCRIPTION

Generate html/javascript charts from perl data using javascript library Dygraphs. The result
is html that you could see in your favourite browser.

Example screenshot of plot generated with examples/time\_series.pl:

![Random time series plotted with Dygraphs](https://raw.githubusercontent.com/pablrod/p5-Chart-Dygraphs/master/examples/time_series.png)

The API is subject to changes.

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

# BUGS

Please report any bugs or feature requests via github: [https://github.com/pablrod/p5-Chart-Dygraphs/issues](https://github.com/pablrod/p5-Chart-Dygraphs/issues)

# AUTHOR

Pablo Rodríguez González <pablo.rodriguez.gonzalez@gmail.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Pablo Rodríguez González.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
