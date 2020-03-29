# Hybrid Runbook Worker (HRW) Deployment Walkthrough

## Overview

Getting your first Hybrid Runbook Worker (HRW) running can be an experience.  I've tried to boil down some the key steps to make things a little easier.  This effort is targeted at building a HRW to run AzInfo.

### Known Challenges

  - Onboarding script on Microsoft Docs is written for AzureRM commands and makes some bad assumptions about Auth.  There is an updated copy in this Repo. ```New-OnPremiseHybridWorker.ps1```
  - Auth can always be challenge, particularly if you are working in the Gov't Clouds or bouncing between clouds.  ```Test-Auth.ps1``` runbook is included to help here.
  - Be sure to read the tips and tricks section at the end **FIRST**.  For example, there are known issues with AZ storage account commands, you will most likely need the provided obscure workaround.


## Steps 

1. Build RG, VNet, VM.  
   **NOTE:** *Terraform is included for a quick setup of this config in the lab (Steps 1-3), you will most likely have a good bit of this in place.*

1. Create AutoAccount

1. Create LogA and LogA Link to AutoAccount

1.  If HRW VM is Windows Server R2, install .Net 4.8, and WMF 5.1, and AZ Cmdlets

1.  Create AutoAccount RunAs Account.  Using the GUI is OK for this task.  It can be scripted too.   
  https://docs.microsoft.com/en-us/azure/automation/manage-runas-account

1. Validate RunAs Account has Subscription contributor role

1. Load required modules such at AzInfo and AZ CmdLets into Automation Account (For Azure Worker Testing Only i.e. optional)

1. Try LogA Gui for joining VM to LogA.  Script can do this too, but it's easier to troubleshoot if it's done from the LogA Gui. Also, I'm not 100% sure the script below pulls down the latest version the Microsoft Monitoring Agent (MMA).

1. Fix up initialization sections of scripts in first runbooks, remove gov reference in add-account for example.

1. As Admin, load required modules such as AzInfo and AZ CmdLets into ```C:\Program Files\WindowsPowerShell\Modules``` on the HRW.  
   **TIP:** *Download AzInfo module to HRW, unblock files!!!*

1. Run ```New-OnPremiseHybridWorker.ps1```.  Sample parameter are shown in ```Create-OnPremiseHybridWorker.ps1.sample```

1. Import Automation Account Cert into HRW ```Export-RunAsCertificateToHybridWorker.ps1``` - via runbook.  
   https://docs.microsoft.com/en-us/azure/automation/automation-hrw-run-runbooks 

1. Apply HRW workaround for AZ storage account CmdLet errors,  See **Tips** below.

1. If you are working towards running AzIno, you will also need to setup a storage account.  See AzInfo readme for details.  There's also a good bit of environmental info needed for updates to ```New-AzInfo.ps1```. See sample in ```Sample_Scripts```.

## Tips and Tricks

- I had to use this article to clean up OMS workspaces and remove a bad HRW Regkey  
https://bwit.blog/add-hybridrunbookworker-machine-already-registered-different-account/

- Apply this workaround for the below error when running jobs on HRW 
https://github.com/Azure/azure-powershell/issues/8531  

  ```PowerShell
  # AZ Storage Account Errors on HRW...

  2020-03-26T13.52.389 Running Export-AzInfoToBlobStorage...
  Set-AzStorageBlobContent : Failed to open file 
  C:\windows\TEMP\HRW\2020-03\2020-03-26T13.52_AzInfo\2020-03-26T13.52_AzInfo_HRW.zip: Illegal characters in path..
  At C:\Program Files\WindowsPowerShell\Modules\AzInfo\AzInfo.psm1:892 char:17
  + ...             Set-AzStorageBlobContent @BlobParams -Force -Verbose:$fal ...
  +                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      + CategoryInfo          : CloseError: (:) [Set-AzStorageBlobContent], TransferException
      + FullyQualifiedErrorId : TransferException,Microsoft.WindowsAzure.Commands.Storage.Blob.SetAzureBlobContentCommand
  ```
- Helpful Az Cli commands for Terraform 
  ```
  az cloud set --name AzureUSGovernment
  az account set -s ed347077-d367-4401-af11-XXXXXX
  az account list-locations -o table
  ```








