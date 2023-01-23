# trigger a build pipeline in Azure DevOps
function triggerPipeline($PAT, $DevOpsOrg, $ProjectName, $BuildDefinitionId) {
    $api_ver = "7.0"
    $url = "https://dev.azure.com/$DevOpsOrg/$ProjectName/_apis/build/builds?api-version=$api_ver"
    $body = @{definition = @{id = $BuildDefinitionId}} | ConvertTo-Json
    # convert PAT to base64 and add to header
    $base64PAT = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($PAT)"))
    # create header
    $headers = @{Authorization = "Basic $base64PAT"}
    # trigger build with json body
    $response = Invoke-RestMethod -Uri $url -Method Post -Body $body -Headers $headers -ContentType "application/json"
    # return the response
    return $response
}
# gets a list of build definitions in a project
function getBuildDefinitionsIds($PAT, $DevOpsOrg, $ProjectName){
    $api_ver = "7.0"
    $url = "https://dev.azure.com/$DevOpsOrg/$ProjectName/_apis/build/definitions?api-version=$api_ver"
    # convert PAT to base64 and add to header
    $base64PAT = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($PAT)"))
    # create header
    $headers = @{Authorization = "Basic $base64PAT"}
    # trigger build with json body
    $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -ContentType "application/json"
    # return the response
    return $response
}
# list all build definitions
#$builds = getBuildDefinitionsIds -PAT $pat -DevOpsOrg $org -ProjectName $project
#$builds.value | select id, name
$pat = "PAT with build execute permissions"
$org = "ADO-ORG"
$project = "ADO-PROJECT"
$buildId = 1
$result = triggerPipeline -PAT $pat -DevOpsOrg $org -ProjectName $project -BuildDefinitionId $buildId
# write the response to the console
$result | ConvertTo-Json