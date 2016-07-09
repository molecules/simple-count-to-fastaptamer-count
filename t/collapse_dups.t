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
        70    GGG
        20    CCC
         10 GGG
        END
}

sub expected
{
    return q:to/END/;
        >1(1)-100-500000
        AAA
        >2(1)-80-400000
        GGG
        >3(1)-20-100000
        CCC
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
