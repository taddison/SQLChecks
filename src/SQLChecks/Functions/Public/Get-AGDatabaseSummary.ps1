Function Get-AGDatabaseSummary {
  [cmdletbinding()]
  Param(
    [Parameter(ParameterSetName="Config",ValueFromPipeline=$true,Position=0)]
    $Config

    ,[Parameter(ParameterSetName="Values")]
    $ServerInstance

    ,[parameter(ParameterSetName="Values")]
    [string]
    $AvailabilityGroup
  )

  if($PSCmdlet.ParameterSetName -eq "Config") {
    $ServerInstance = $Config.ServerInstance
    $AvailabilityGroup = $Config.AvailabilityGroup
  }

  $replicas = Get-AGDatabaseReplicaState -ServerInstance $ServerInstance -AvailabilityGroup $AvailabilityGroup

  $databases = $replicas | Where-Object { $_.IsPrimaryReplica -eq $true } | ForEach-Object {
    $db = $_.DatabaseName
    [PSCustomObject]@{
      AvailabilityGroup = $AvailabilityGroup
      DatabaseName = $db
      SynchronizedReplicas = @($replicas | Where-Object {
          $_.DatabaseName -eq $db -and $_.SynchronizationState -eq "SYNCHRONIZED" -and -not $_.IsPrimaryReplica
        }).Count
    }
  }

  $databases
}