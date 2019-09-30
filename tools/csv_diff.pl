#!/usr/bin/env perl
use strict;
use warnings;

use Getopt::Long;
use List::Util qw(max);
use Data::Dumper;

my $opt_delimiter = ',';
my $is_ignore_white_space;
my $is_cell_diff;
my %opt;
GetOptions(
    \%opt,
    'help|h|?',
    'delimiter|d=s'        => \$opt_delimiter,
    'ignore_white_space|w' => \$is_ignore_white_space,
    'cell|c'               => \$is_cell_diff,
);
my $FILE_NAME_1 = $ARGV[0];
my $FILE_NAME_2 = $ARGV[1];

if (!$FILE_NAME_1 || !$FILE_NAME_2) {
    print "[error]input_filename1 and input_filename2 require\n";
    usage();
    exit 0;
}
unless (-f $FILE_NAME_1) {
    print "[error]file not found:$FILE_NAME_1 \n";
    exit 0;
}
unless (-f $FILE_NAME_2) {
    print "[error]file not found:$FILE_NAME_2 \n";
    exit 0;
}

compareFile();

sub compareFile {
    my @file1_data = ();
    open(FH1, $FILE_NAME_1);
    while(<FH1>) {
        chomp($_);
        push @file1_data, $_;
    }

    my @file2_data = ();
    open(FH2, $FILE_NAME_2);
    while(<FH2>) {
        chomp($_);
        push @file2_data, $_;
    }
    
    checkDiff(\@file1_data, \@file2_data);
}

sub checkDiff {
    my ($data1, $data2) = @_;
    # レコード数が多い方を基準にループ
    my $max_line_count = max(scalar @$data1, scalar @$data2);
    for (0..($max_line_count-1)) {
        my $line = $_+1;
        my $data1_line = $data1->[$_] || '';
        my $data2_line = $data2->[$_] || '';
        if (!$data1_line && !$data2_line) {
            next;
        }
        elsif (!$data1_line || !$data2_line) {
            $data1_line = "[ NO DATA ]" unless $data1_line;
            $data2_line = "[ NO DATA ]" unless $data2_line;
            print "LINE:$line | $data1_line | $data2_line |\n";
            next;
        }
        my @data1_cells = split(/$opt_delimiter/, $data1_line, -1);
        my @data2_cells = split(/$opt_delimiter/, $data2_line, -1);
        my $max_cell_count = max(scalar @data1_cells, scalar @data2_cells);
        for (0..($max_cell_count-1)) {
            my $cell1 = $data1_cells[$_];
            my $cell2 = $data2_cells[$_];
            if ($is_ignore_white_space) {
                $cell1 = trim($cell1);
                $cell2 = trim($cell2);
            }
            unless ($cell1 eq $cell2) {
                if ($is_cell_diff) {
                    $cell1 = $data1_cells[$_];
                    $cell2 = $data2_cells[$_];
                    print "LINE:$line\t$cell1\t$cell2\n";
                }
                else {
                    print "LINE:$line\t$data1_line\t$data2_line\n";
                    last;
                }
            }
        }
    }
}

sub trim {
    my $val = shift;
    # $val =~ s/^ *(.*?) *$/$1/;
    $val =~ s/\A\s*(.*?)\s*\z/$1/;
    return $val;
}

sub usage {
    print "usage: tools/csv_diff.pl <input_filename1> <input_filename2> [-w]\n";
    return;
}
