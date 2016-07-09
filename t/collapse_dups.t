#!/bin/env perl6

use Test;

use File::Temp;

my $in-filename  = filename-for( input );
my $out-filename = temp-filename;

shell("./collapse_dups $in-filename > $out-filename");

my $result = slurp $out-filename;

is $result, expected, 'duplicates correctly combined'; 

sub input
{
    return q:to/END/;
        60    AAA
         40                                         AAA
        20    GGG
        15    CCC
         10 GGG
        END
}

sub expected
{
    return q:to/END/;
        100	AAA
        30	GGG
        15	CCC
        END
}

sub temp-filename
{
    my ($file-name, $fh) = tempfile;
    $fh.close;

    return $file-name;
}

sub filename-for ($content)
{
    my $temp-filename = temp-filename;    
    spurt($temp-filename, $content);
    return $temp-filename;
}

