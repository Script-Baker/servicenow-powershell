function Update-ServiceNowIncident
{
    Param(  
        # sys_id of the incident (user Get-ServiceNowUser to retrieve this)
        [parameter(mandatory=$true)]        
        [parameter(ParameterSetName='SpecifyConnectionFields', mandatory=$true)]
        [parameter(ParameterSetName='UseConnectionObject', mandatory=$true)]
        [parameter(ParameterSetName='SetGlobalAuth', mandatory=$true)]       
        [string]$SysId,

        # Hashtable of values to use as the record's properties
        [Parameter(ParameterSetName="HashValues", Mandatory=$true)]
        [hashtable]$Values,
        
        # Category
        [Parameter(ParameterSetName="NamedValues")]
        [string]$Category,

        # ConfigurationItem
        [Parameter(ParameterSetName="NamedValues")]
        [string]$ConfigurationItem,

        # AssignmentGroup
        [Parameter(ParameterSetName="NamedValues")]
        [string]$AssignmentGroup,

        # AssignedTo
        [Parameter(ParameterSetName="NamedValues")]
        [string]$AssignedTo,

        # WorkNotes
        [Parameter(ParameterSetName="NamedValues")]
        [string]$WorkNotes,

        # Comments
        [Parameter(ParameterSetName="NamedValues")]
        [string]$Comments,

        # Credential used to authenticate to ServiceNow  
        [Parameter(ParameterSetName='SpecifyConnectionFields', Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [PSCredential]
        $ServiceNowCredential,

        # The URL for the ServiceNow instance being used (eg: instancename.service-now.com)
        [Parameter(ParameterSetName='SpecifyConnectionFields', Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ServiceNowURL, 

        #Azure Automation Connection object containing username, password, and URL for the ServiceNow instance
        [Parameter(ParameterSetName='UseConnectionObject', Mandatory=$True)] 
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $Connection
    )
    
    if (-not($Values))
    {
        $Values = @{}        
    }

    if ($Category) { $Values.Add('category',$Category) }
    if ($ConfigurationItem) { $Values.Add('cmdb_ci',$ConfigurationItem) }
    if ($AssignmentGroup) { $Values.Add('assignment_group',$AssignmentGroup) }
    if ($AssignedTo) { $Values.Add('assigned_to',$AssignedTo) }
    if ($WorkNotes) { $Values.Add('work_notes',$WorkNotes) }
    if ($Comments) { $Values.Add('comments',$Comments) }

    if ($Connection -ne $null)
    {
       Update-ServiceNowTableEntry -Table 'incident' -Values $Values -Connection $Connection -SysId $SysId 
    }
    elseif ($ServiceNowCredential -ne $null -and $ServiceNowURL -ne $null) 
    {
       Update-ServiceNowTableEntry -Table 'incident' -Values $Values -ServiceNowCredential $ServiceNowCredential -ServiceNowURL $ServiceNowURL -SysId $SysId 
    }
    else 
    {
       Update-ServiceNowTableEntry -Table 'incident' -Values $Values -SysId $SysId   
    }     
}