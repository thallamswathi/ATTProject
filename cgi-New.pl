#!Strawberry\perl\bin\perl.exe
use CGI qw(:standard);
use DBI;
use strict;

my $c = CGI->new;
#assign HTML form values to variables.
my ($Date,$Time,$Description);
	
#get referer url 
my $url = $c->referer;
#handle only POST request.
if ('POST' eq $c->request_method){
  $Date = param('Date');
  $Time = param('Time');
  $Description = param('Description');
# connect to the database, host, port, username and password are configured according to mysql setup in my local machine.
# needs to changed according to the actual DB server details.
my $dbh = DBI->connect("DBI:mysql:database=dbAppointments;host=127.0.0.1;port=3306",  
  "root", "lasya") 
  or die $DBI::errstr;

# Insert new appointments
my $query =  "INSERT INTO Appointments(appointment_date,appointment_time,description) VALUES(\'".$Date."\',\'".$Time."\',\'".$Description."\')";
my $query_handle = $dbh->prepare($query)
  or die $dbh->errstr;
#execute query
$query_handle-> execute
	or die $query_handle->errstr;	

$query_handle-> finish();
$dbh->disconnect();

# redirect to referer url to load html.
# Used CGI referer for current project only. referer cannot be understood by all browsers. 
# possible to assign desired URL to $url variable and redirect.
# Suggested way: Assign url for project i.e, $url = "http://www.att.com/Main.html"
}

print $c->redirect($url);
print $c->header('text/html');