param([Parameter(Mandatory=$true)]$MovieName, $WhatIf=$false)

$title = $MovieName

if ($WhatIf -eq $true){
    Write-Output '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
    write-output 'the movie name is'    
    write-output $MovieName
    Write-Output '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
}

write-output "       "
write-output "###################################################################################################################################################"
write-output "########################################################## $title #################################################################################"
write-output "###################################################################################################################################################"


$tempfile = "C:\Windows\Temp\bing.txt"

### The number.com site needs to have the movie title formatted in a special way
### but that impacts the bing results
### we had split them into separate variable to make it cleaner

$bingtitle = $title
$numbertitle = $title
$funkotitle = $title



write-output "       "
write-output "#################################################"
write-output "######### Begin Revenue Results #################"
write-output "#################################################"



if ($numbertitle.Substring(0,1) -like 'a' -and $numbertitle.Substring(1,1) -like ' ')
{
    $numbertitle = $numbertitle.Substring(2)+"-a"
}


if ($numbertitle.Substring(0,3) -eq "the")
{
     $numbertitle = $numbertitle.Substring(4)+" the"
}

$numbertitle = $numbertitle.Replace(" ","-")
$numbertitle = $numbertitle.Replace("'","")
$numbertitle = $numbertitle.Replace(".","")
$numbertitle = $numbertitle.Replace("!","")
$numbertitle = $numbertitle.Replace("&","")


$url = "https://the-numbers.com/movie/$numbertitle#tab=summary"

if ($WhatIf -eq $true){
    Write-Output '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
    write-output 'the movie url is ' $url    
    Write-Output '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
}

##write-output $url
$b = invoke-webrequest -uri $url
##$b.ParsedHtml.body.outerText

$results = $b.ParsedHtml.body.outerText


if ($WhatIf -eq $true){
    Write-Output '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
    write-output $results.Length
    Write-Output '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
}

write-output $results  |Out-File $tempfile ##Gross revenue

##get gross revenue
Get-Content $tempfile | Where-Object {$_ -like '*Worldwide Box Office*'} | where-object {$_ -notlike "*All Time*"} | where-object {$_ -notlike "*Budget*"}| where-object {$_ -notlike "*Top*"}

##opening weekend
Get-Content $tempfile | Where-Object {$_ -like '*Opening Weekend*'} | where-object {$_ -notlike "*Territories*"} | where-object {$_ -notlike "*Budget*"}


##get rating. The line itself is long, so we need to filter out just the rating
##$rating = Get-Content $tempfile | Where-Object {$_ -like '*MPAA Rating*'}
##$rating.Substring($rating.IndexOf("MPAA Rating"),15)

#simple get rating
Get-Content $tempfile | Where-Object {$_ -like '*MPAA Rating*'}



write-output "       "
write-output "#################################################"
write-output "############## Begin Bing Count Results ###############"
write-output "#################################################"

$search = "$bingtitle"

$bingURL = "https://www.bing.com/search?q=$search&first=2"


if ($WhatIf -eq $true){
    Write-Output '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
    write-output 'the Bing search url is ' $bingURL
    Write-Output '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
}



$b = invoke-webrequest -uri $bingURL
##$b.ParsedHtml.body.outerText

$results = $b.ParsedHtml.body.outerText

write-output $results  |Out-File $tempfile ##Gross revenue

##get gross revenue
$results = Get-Content $tempfile | Where-Object {$_ -like '*Results*'} | Where-Object {$_ -notlike "*See*"} | Where-Object {$_ -notlike "*Some*"}

#Write-Output $results

$results = $results.Substring(0,$results.IndexOf("results"))
$results = $results.Substring($results.IndexOf(" of "))

Write-Output $results



write-output "       "
write-output "#################################################"
write-output "######### Begin Bing metascore Results ##########"
write-output "#################################################"

$search = "$bingtitle"

$bingURL = "https://www.bing.com/search?q=$search+metascore"


if ($WhatIf -eq $true){
    Write-Output '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
    write-output 'the Bing metascore search url is ' $bingURL
    Write-Output '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
}



$b = invoke-webrequest -uri $bingURL
##$b.ParsedHtml.body.outerText

$results = $b.ParsedHtml.body.outerText

if ($WhatIf -eq $true){
    Write-Output '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
    write-output 'Raw results pre-filtering' $results
    Write-Output '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
}

write-output $results  |Out-File $tempfile ##Gross revenue

##get gross revenue
$results = Get-Content $tempfile | Where-Object {$_ -like '*%(*'} | Where-Object {$_ -notlike "*details*"} | Where-Object {$_ -notlike "*imdb*"} | Where-Object {$_ -notlike "*game*"}


if ($WhatIf -eq $true){
    Write-Output '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
    write-output 'Raw results post-filtering' $results
    Write-Output '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
}

$results = $results.Substring(0,$results.IndexOf("%("))
#$results = $results.Substring($results.IndexOf(" of "))

Write-Output $results




write-output "       "
write-output "#################################################"
write-output "########## Begin FunkoPop Results #########"
write-output "#################################################"



$funkotitle = $funkotitle.Replace(" ","+")
$funkotitle = $funkotitle.Replace("'","")

$search = $funkotitle


$FunkoDBURL = "https://www.funkodb.com/?search=$search"
$b = invoke-webrequest -uri $FunkoDBURL
##$b.ParsedHtml.body.outerText

$results = $b.ParsedHtml.body.outerText

write-output $results  |Out-File $tempfile ##Gross revenue

##get gross revenue
$results = Get-Content $tempfile | Where-Object {$_ -like '*Show*'} ##| Where-Object {$_ -notlike "*See*"} | Where-Object {$_ -notlike "*Some*"}

Write-Output $results

#$results = $results.Substring(0,$results.IndexOf("results"))
#$results = $results.Substring($results.IndexOf(" of "))

#Write-Output $results