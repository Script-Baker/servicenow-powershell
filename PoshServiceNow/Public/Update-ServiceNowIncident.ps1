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
        [hashtable]$Values,
        
        # Category
        [string]$Category,

        # ConfigurationItem
        [string]$ConfigurationItem,

        # AssignmentGroup
        [string]$AssignmentGroup,

        # AssignedTo
        [string]$AssignedTo,

        # WorkNotes
        [string]$WorkNotes,

        # Comments
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

    if ($Category)
    {
        if ($Values.ContainsKey('category'))
        {
            $Values['category'] = $Category
        }
        else
        {
            $Values.Add('category',$Category)
        }
    }
    if ($ConfigurationItem)
    {
        if ($Values.ContainsKey('cmdb_ci'))
        {
            $Values['cmdb_ci'] = $ConfigurationItem
        }
        else
        {
            $Values.Add('cmdb_ci',$ConfigurationItem)
        }
    }
    if ($AssignmentGroup)
    {
        if ($Values.ContainsKey('assignment_group'))
        {
            $Values['assignment_group'] = $AssignmentGroup
        }
        else
        {
            $Values.Add('assignment_group',$AssignmentGroup)
        }
    }
    if ($AssignedTo)
    {
        if ($Values.ContainsKey('assigned_to'))
        {
            $Values['assigned_to'] = $AssignedTo
        }
        else
        {
            $Values.Add('assigned_to',$AssignedTo)
        }
    }
    if ($WorkNotes)
    {
        if ($Values.ContainsKey('work_notes'))
        {
            $Values['work_notes'] = $WorkNotes
        }
        else
        {
            $Values.Add('work_notes',$WorkNotes)
        }
    }
    if ($Comments)
    {
        if ($Values.ContainsKey('comments'))
        {
            $Values['comments'] = $Comments
        }
        else
        {
            $Values.Add('comments',$Comments)
        }
    }

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