#!/usr/bin/perl -w
use strict;
use File::Copy;
use DBI;

# Edit these variables to set up your TNS info, schema, password, etc

my $instance = '';
my $schema = '';
my $pwd = '';


# Connect to Oracle
# Set AutoCommit to 0 to enable transactions. In this case, queries will be rolled back in case something fails.

my $dbh = DBI->connect($instance, $schema, $pwd, {RaiseError => 1, AutoCommit => 0})
or die "could not connect to database: ".DBI->errstr;

########################################################
# Subroutines for querying and exporting Oracle tables #
########################################################


# Exports table and appends headers
# Usage: export_with_headers("tablename", "path/to/file.txt")
# @param $table string $file string
sub export_with_headers {
		#my $table = shift;
		#my $file = shift;
	my ($table, $file) = @_;
	# exit out if user doesn't supply both params
	if (!defined($table) or !defined($file)){
		print "Error:\n";
		print "Export routine requires 2 arguments: table name to export, and filepath to export to.\n";
		exit;
	}
	my $sql = "SELECT * FROM $table";
	my $sth = $dbh->prepare($sql);
	$sth->execute() or die "Can't run SQL statement\n$DBI::errstr\n";

	open(FH, ">>$file") or die $!;
	my $header = join("\t", @{$sth->{NAME}});
	print FH "$header\n";
	print "Exporting...\n";
	while(my $ref = $sth->fetchrow_arrayref()){
		 foreach(@$ref){
			$_ = '' if !defined($_);
		 }
		 my $str=join("\t",@$ref);
		 print FH "$str\n";
	}
	close FH;
	print "Table exported to $file \n";
}

# Executes a string of sql.
# usage: run_query("INSERT into foo, ('bar')")
# @param $sql string
sub run_query{
	my $sql = $_[0];
	my $sth = $dbh->prepare($sql);
	$sth->execute() or die "Can't run SQL statement\n$DBI::errstr\n";
}

#####################################
##### Misc. Utility Functions #######
#####################################


# Checks to see if table exists in Oracle by querying user_tables listing
# return true if table exists
# return false(undef) if does not exist
sub table_exists{
	my $table = $_[0];
	my $th = $dbh->prepare("select table_name from user_tables where table_name = '".$table."'");
	$th->execute() or die "Can't run SQL statement\n$DBI::errstr\n";
	my $found = $th->fetch();
	unless($found){
		return undef;
	}
}


