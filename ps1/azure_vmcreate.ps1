#Create Storage in random region
$storagelocations = AzureResourceManager\Get-AzureLocation | select name, locations | where {$_.Name -eq "Microsoft.Storage/storageAccounts"}
$region = (Get-Random -input $storagelocations.Locations)

$region = "West US"

$rgname = "VMinCode"
$storagename = "blstvmdiskstore"
New-AzureResourceGroup -Name $rgname -location $region
AzureResourceManager\New-AzureStorageAccount –StorageAccountName $storagename –Location $region -ResourceGroupName $rgname -Type Standard_LRS 

#Create Virtual Network Card, Public IP and Network Card
$vmDNSname = "blst-vmincode"
$subnetName = "Subnet-1"
$subnet = New-AzureVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix "10.0.64.0/24"
$vnet = New-AzureVirtualNetwork -Name "VNET" -ResourceGroupName $rgname -Location $region -AddressPrefix "10.0.0.0/16" -Subnet $subnet
$subnet = Get-AzureVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet
$pip = New-AzurePublicIpAddress -ResourceGroupName $rgname -Name "vip1" -Location $region -AllocationMethod Dynamic -DomainNameLabel $vmDNSname
$nic = New-AzureNetworkInterface -ResourceGroupName $rgname -Name "nic1" -Subnet $subnet -Location $region -PublicIpAddress $pip -PrivateIpAddress "10.0.64.4" 

#Create Virtual Machine
$publisher = "MicrosoftWindowsServer"
$offer = "WindowsServer"
$sku = "2012-R2-Datacenter"
$version = "latest"
$cred = Get-Credential

$vmConfig = AzureResourceManager\New-AzureVMConfig -VMName $vmDNSname -VMSize "Standard_A1"
AzureResourceManager\Set-AzureVMOperatingSystem -VM $vmconfig -Windows -ComputerName "contoso-w1" -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
$vmConfig | AzureResourceManager\Set-AzureVMSourceImage -PublisherName $publisher -Offer $offer -Skus $sku -Version $version
$vmConfig | AzureResourceManager\Set-AzureVMOSDisk -Name "$vmDNSname-w1" -VhdUri "https://$storagename.blob.core.windows.net/vhds/$vmDNSname-w1-os.vhd" -Caching ReadWrite -CreateOption fromImage
$vmConfig | AzureResourceManager\Add-AzureVMNetworkInterface -Id $nic.Id 
AzureResourceManager\New-AzureVM -ResourceGroupName $rgname -Location $region -VM $vmConfig 
