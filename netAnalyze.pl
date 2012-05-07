#!/usr/bin/perl
#future konsep via web
#dev 
#	- populate [ by scan, by packet ]
#			- target pick ( IP/mac ) [ to scan services { listening port }, to be sniffed { established connection / packet analyze }]	

#network tools

use Data::Dumper; 

my %populate;
my @thread;
my $thread_i = 0;
my @struk =
(
	net =>
		tool => 
			  [ 
				{ 
					  name => "ngrep",
					  binary => "ngrep",
					  parameter => " -d wlan0"
				},
				{
					  name => "nmap",
					  binary => "nmap"
				},
				{
					  name => "tcpdump",
					  binary => "tcpdump"
				}
			  ]
);

sub fill_populate
{
	if(!$populate{$2})
	{
		$populate{$2} = 
				{
				 $1 => 
					{ 						
					$3 => 
						{ 
							$4 => $5 
						} 							
					}
				};
	}
	elsif($populate{$2}{$1})
	{
		foreach(@{$populate[$2][$1]})
		{
			if(!$_->{$3})
			{
				
			}
		}
		my @tmp = ( [$3 => { $4 => $5 } ]);

		push ( @{$populate{$2}{$1}}, @tmp);
	}
	else
	{
		
	}
	
}

sub populate_sniff
{
	print "starting..\n";
	open FH,"ngrep -lqi -d wlan0 -W none |" or die "$!";
	while(<FH>)
	{
		chomp;
		#print $_."\n";
		if($_ =~ /([A-Z])\s?(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}):(\d{1,5}) -> (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}):(\d{1,5})/)
		{
			print $1.'--'.$2.'--'.$3.'--'.$4.'--'.$5."\n";

		}
	}
}

sub console
{
	my %cmd = 
	(
		   "populate" =>  {
					"sniff" => \&populate_sniff
				  }
	
	);
	
	while(<STDIN>)
	{
		
		if($_)
		{
			if($_ =~ /^(.\w+)(.\s*)(.\w+)\n/)
			{
				print "workin..\n";
				$cmd{$1}{$3}();
			}			
		}
	}
}

sub main
{
	console();
}

main();
