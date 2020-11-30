<#
first we setup a file list
echo "" > c:\bin\movies.txt

#>

#load the movies into a variabl
$movies = Get-Content C:\bin\movies.txt

#now we loop through each movie and output the results
#the right way to do this would be pass the entire variable as an array to the bestmovie.ps1 script
#but this is just as easy

foreach ($movie in $movies) {.\bestmovie.ps1 $movie}