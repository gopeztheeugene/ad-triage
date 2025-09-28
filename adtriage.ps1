$filepath = Join-Path -Path $env:SystemDrive -ChildPath "active_directory.txt"

#Forest and AD Triage
$separator = "================== Domain Information =================="
$separator | Out-File $filepath -Append
Get-ADDomain | Out-File $filepath -Append


$separator = "================== Forest Information =================="
$separator | Out-File $filepath -Append
$forestinfo = Get-ADForest
$forestinfo | Select-Object Name, RootDomain, SchemaMaster, ApplicationPartitions, CrossForestReferences, DomainNamingMaster, ForestMode, SPNSuffixes, UPNSuffixes | Out-File $filepath -Append
$separator = "`nSites:"
$separator | Out-File $filepath -Append
$forestinfo | Select-Object -ExpandProperty Sites | Out-File $filepath -Append

$separator = "`n`nDomains:"
$separator | Out-File $filepath -Append
$forestinfo | Select-Object -ExpandProperty Domains | Out-File $filepath -Append

$separator = "`n`nGlobal Catalogs:"
$separator | Out-File $filepath -Append
$forestinfo | Select-Object -ExpandProperty GlobalCatalogs | Out-File $filepath -Append

$separator = "`n================== Trusts =================="
$separator | Out-File $filepath -Append 
$trusts = Get-ADTrust -Filter *
$trusts | Out-File $filepath -Append

#Get the groups
$separator = "================== Universal Groups =================="
$separator | Out-File $filepath -Append
$unigroups = Get-ADGroup -filter * | Where-Object {$_.GroupScope -like "Universal*"}
$unigroups | Out-File $filepath -Append
foreach ($group in $unigroups) { 
$groupname = $group | Select-Object -Expandproperty Name;
$separator = "`n---$groupname Members:---"
$separator | Out-File $filepath -Append
Get-ADGroupMember -Identity $groupname | Out-File $filepath -Append
}


$separator = "================== Enterprise Admins =================="
$separator | Out-File $filepath -Append
$domain= Get-ADForest | Select-Object -ExpandProperty Name
$dcname = Get-ADDomainController -DomainName $domain -Discover
Get-ADGroupMember -Identity "Enterprise Admins" -Server $dcname | Out-File $filepath -Append


$separator = "================== Foreign Security Principals =================="
$separator | Out-File $filepath -Append
$list = @()
([adsisearcher]::new("(objectClass=foreignSecurityPrincipal)", @("objectSid"))).FindAll() |
    ForEach-Object {
        $Sid = [System.Security.Principal.SecurityIdentifier]::new($_.Properties["objectSid"][0], 0); $list += $Sid | Select-Object -Property Value, @{n="Name"; e= { $Sid.Translate([System.Security.Principal.NTAccount]) } } ;
 }
 $list | Out-File $filepath -Append


$separator = "================== Domain SIDs =================="
$separator | Out-File $filepath -Append
$domainlists = @()
foreach ($forest in $trusts) { 
$domain = $forest | Select-Object -ExpandProperty Target; 
$adinfo = Get-ADDomain -Identity $domain; 
$domainlists += $adinfo | Select-Object DNSRoot, Forest, InfrastructureMaster, DomainSID 
}
$domainlists | Out-File $filepath -Append

$separator = "================== DHCP Scopes and servers =================="
$separator | Out-File $filepath -Append

Get-ADReplicationSubnet -Filter * | Out-File $filepath -Append
get-dhcpserverv4scope | Out-File $filepath -Append
netsh dhcp show server | Out-File $filepath -Append