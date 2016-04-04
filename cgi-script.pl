#!Strawberry\perl\bin\perl.exe
use CGI;
use DBI;
use strict;
use JSON;

# read the CGI params
my $cgi = CGI->new;
# search text value read through CGI param
my $searchText = $cgi->param("searchText") ? $cgi->param("searchText") : "";

my $row;
my @Appointments;

# connect to the database
# connect to the database, host, port, username and password are configured according to mysql setup in my local machine.
# needs to changed according to the actual DB server details.
my $dbh = DBI->connect("DBI:mysql:database=dbAppointments;host=127.0.0.1;port=3306",  
  "root", "lasya") 
  or die $DBI::errstr;
  
# frame mysql query according to search text value.
my $query = ($searchText) ? 
			qq{SELECT * FROM Appointments where description like ?} :
			qq{SELECT * FROM Appointments};
my $query_handle = $dbh->prepare($query)
  or die $dbh->errstr;

  # excute query according to the value of search text.
if($searchText eq "") {
	$query_handle-> execute()
	or die $query_handle->errstr;
}
else{
    $searchText = '%'.$searchText.'%';
	$query_handle-> execute($searchText)
	or die $query_handle->errstr;
}  
  
while($row = $query_handle->fetchrow_hashref) {
    push @Appointments, $row;
}  
# close and disconnect database
$query_handle-> finish();
$dbh->disconnect();

# return JSON string
print $cgi->header(-type => "application/json", -charset => "utf-8");
print to_json(\@Appointments);