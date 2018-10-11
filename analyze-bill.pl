#!/usr/bin/perl
use warnings;
use strict;

my $csv_file_name = shift;
my $grep_phone    = shift;

die "CSV not found" unless -r $csv_file_name;

open (my $csv, '<', $csv_file_name) or die;

my $header = <$csv>;

my %service_sums;

while (my $line = <$csv>) {
  chomp $line;

  my ($date, $time, $phone, $to, $service, $duration_quantity_kb, $amount) = split ';', $line;

   $phone =~ s/\D//g;
   $to    =~ s/\D//g;

   #  print "$phone\n";

  if ($phone == $grep_phone) {
     my ($hh, $mm, $ss) = $duration_quantity_kb =~ /(\d\d):(\d\d):(\d\d)/;
     my $secs = 60 * 60 * $hh + 60 * $mm + $ss;
#    print "to = $to | $duration_quantity_kb | $hh - $mm - $ss ($secs) | $service\n";
     $service_sums{$service}{secs} += $secs;
  }

}
for my $service (keys %service_sums) {
  printf "%-50s: %4d\n", $service, $service_sums{$service}{secs} / 60;
}
