[Cmdletbinding()]
PARAM (
  [Parameter(Mandatory=$True,Position=0,ParameterSetName='EnterResturant')]
  [String]$Resturant,

  [Parameter(Mandatory=$False,Position=0,ParameterSetName='FindResturant')]
  [Switch]$FindResturant
)

If ($FindResturant) {
  Start-Process "http://www.culvers.com/locator/view-all-locations"
  Exit
}


#Runs the Invoke-WebRequest on the requested resturant
$WebRequest = Invoke-WebRequest -Uri "http://www.culvers.com/restaurants/$Resturant"
  
#Checks to see if the page is a 404
If ($WebRequest.ParsedHTML.Title -eq "Flavor of the Day | Culver's") {
  Throw "Resturant `"$Resturant`" not found!"
}

#Outputs the Flavor of the day parsed from the web request
(($WebRequest.ParsedHtml.getElementsByTagName("DIV") | Where-Object {$_.className -eq 'ModuleRestaurantDetail-fotd'}).InnerText).SubString(30)