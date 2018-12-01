Function Get-ValueFromCache {
  [cmdletbinding()]
  Param(
    [Parameter(Mandatory = $true)]
    $Key

    , [Parameter(Mandatory = $true)]
    [ScriptBlock]
    $Value
  )

  $CACHE_VARIABLE_NAME = "SQLChecks_Cache"

  if (-not (Get-Variable -Name $CACHE_VARIABLE_NAME -Scope Global -ErrorAction SilentlyContinue)) {
    Write-Verbose "Did not find CachedData in the script scope"
    Set-Variable -Name $CACHE_VARIABLE_NAME -Scope Global -Value @{}
  }

  $cache = Get-Variable -Name $CACHE_VARIABLE_NAME -Scope Global
  if (-not $cache.Value.ContainsKey($Key)) {
    Write-Verbose "Did not find $Key in the cache, populating"
    $cachedValue = &$Value
    $cache.Value[$Key] = $cachedValue
  }
  else {
    Write-Verbose "Found $Key in the cache"
    $cachedValue = $cache.Value[$Key]
  }
  
  $cachedValue
}