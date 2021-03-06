[Cmdletbinding()]
PARAM (
  [Parameter(Mandatory=$True,Position=0,ParameterSetName='EnterResturant',ValueFromPipeline=$true)]
  [String[]]$Resturant,

  [Parameter(Mandatory=$False,Position=0,ParameterSetName='FindResturant')]
  [Switch]$FindResturant
)

Begin {

  #Find resturant mode pulls up their resturant finder in a browser
  If ($FindResturant) {
    Start-Process "http://www.culvers.com/locator/view-all-locations"
    Exit
  }  
  
  #Create an Empty Array
  $Output = @()

}

Process {
  
  #Loop through each inputed resturant in the Resturant array input parameter
  ForEach ($Resturant_Current in $Resturant) {

    #Runs the Invoke-WebRequest on the requested resturant
    $WebRequest = Invoke-WebRequest -Uri "http://www.culvers.com/restaurants/$Resturant_Current"
      
    #Checks to see if the page is a 404
    If ($WebRequest.ParsedHTML.Title -eq "Flavor of the Day | Culver's") {
      Break "Resturant `"$Resturant`" not found!"
    }

    #Outputs the Flavor of the day parsed from the web request
    $FlavorOTD = (($WebRequest.ParsedHtml.getElementsByTagName("DIV") | Where-Object {$_.className -eq 'ModuleRestaurantDetail-fotd'}).InnerText).SubString(30)

    #Create a custom object with two properties
    $FlavorOTD_Object = [pscustomobject] @{

      "Resturant" = $Resturant_Current
      "Flavor" = $FlavorOTD

    }

    #Add the custom object to the array created earlier
    $Output += $FlavorOTD_Object

  }

}

End {

  #Output the array  
  Write-Output $Output  

}