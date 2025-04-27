[comment]: <> (please keep all comment items at the top of the markdown file)
[comment]: <> (please do not change the ***, as well as <div> placeholders for Note and Tip layout)
[comment]: <> (please keep the ### 1. and 2. titles as is for consistency across all demoguides)
[comment]: <> (section 1 provides a bullet list of resources + clarifying screenshots of the key resources details)
[comment]: <> (section 2 provides summarized step-by-step instructions on what to demo)


[comment]: <> (this is the section for the Note: item; please do not make any changes here)
***
### Active Directory Domain Controller with Bastion - demo scenario

<div style="background: lightgreen; 
            font-size: 14px; 
            color: black;
            padding: 5px; 
            border: 1px solid lightgray; 
            margin: 5px;">

**Note:** Below demo steps should be used **as a guideline** for doing your own demos. Please consider contributing to add additional demo steps.
</div>

[comment]: <> (this is the section for the Tip: item; consider adding a Tip, or remove the section between <div> and </div> if there is no tip)

***
### 1. What Resources are getting deployed
This scenario deploys a Windows Server 2022 as Active Directory Domain Controller and DNS Server. To highlight the importance of protecting remote management activities of this Server, the scenario comes with Azure Bastion. 

* MTTDemoDeployRGc%youralias%ADDS - Azure Resource Group.
* %youralias%-dc-01 - Windows Server 2022 running Active Directory Domain Services
* %youralias%-VNET1 - Azure Virtual Network 
* %youralias%-VNET1 - Azure Bastion
* %youralias%-OSDisk - The Operating System of the ADDS VM
* %youralias%-NTDS - The additional disk for storing the ADDS NTDS Directory database


<img src="https://raw.githubusercontent.com/petender/azd-sqlao/main/demoguide/ResourceGroup_Overview.png" alt="ADDS Resource Group" style="width:70%;">
<br></br>

### 2. What can I demo from this scenario after deployment

#### Bastion
1. After authenticating to the Azure Portal, navigate to the **%alias%-dc-01** Virtual Machine.
1. From the **Overview** blade,  highlight there is **No Public IP address** resource allocated. This means the VM is only reachable from an "internal" source.
1. Select **Settings/Networking**, and select the **Virtual Network** the VM is using.
1. From the **Virtual Network** settings, open **Subnets**. Highlight the 2 different **Subnets** used by the Virtual Machine, as well as the **AzureBastionSubnet**, used for the Azure Bastion service. 

<img src="https://raw.githubusercontent.com/petender/azd-sqlao/main/demoguide/ADDS_Subnets.png" alt="ADDS Subnets" style="width:70%;">
<br></br>

1. From the **Virtual Network** resource / Settings / navigate to **Bastion**
1. **Specify the ADDS-VM** as VM to Connect to. Provide the necessary **local admin credentials** (see deployment status email for credentials)

<img src="https://raw.githubusercontent.com/petender/azd-sqlao/main/demoguide/ADDS_Bastion.png" alt="ADDS Bastion" style="width:70%;">
<br></br>

1. This opens a new browser tab, with an **RDP-session** to the ADDS VM.
1. Click **Allow** in the popup message regarding the text and images copied to the clipboard.

#### Active Directory Domain Services
 Here are some step-by-step ideas that you could demo to a technical audience to give them an understanding of what Active Directory is used for:

1. Introduce the concept of a **Windows Forest and Domain** and explain why it is useful for managing a large number of computers and users. Open the **Active Directory Users and Computers** from the Start Menu, and walk through the high-level layout of Domain (%alias.mttdemodomain.com), the **Organizational Units** and **Containers**.

<img src="https://raw.githubusercontent.com/petender/azd-sqlao/main/demoguide/ADDS_ADUC.png" alt="ADDS Users and Computers" style="width:70%;">
<br></br>

1. Open **Active Directory Administrative Center** and highlight some of its core features, compared to the MMC-based ADUC.

<img src="https://raw.githubusercontent.com/petender/azd-sqlao/main/demoguide/ADDS_AdminCenter.png" alt="ADDS Users and Computers" style="width:70%;">
<br></br>

1. Show how **Active Directory Domain Services** is a **role** on the Windows Server, together with the DNS role.

<img src="https://raw.githubusercontent.com/petender/azd-sqlao/main/demoguide/ADDS_DNS.png" alt="ADDS DNS Zone" style="width:70%;">
<br></br>

1. **Create a new user account** in Active Directory, and explain how this user account can be used to log in to any computer in the domain.

<img src="https://raw.githubusercontent.com/petender/azd-sqlao/main/demoguide/ADDS_CreateUser.png" alt="ADDS Create user" style="width:70%;">
<br></br>

1. Explain the concept of **Group Policy Objects (GPOs)** and show how to create and apply a GPO to a specific group of users or computers.

<img src="https://raw.githubusercontent.com/petender/azd-sqlao/main/demoguide/ADDS_GPO.png" alt="ADDS Group Policy Mgmt" style="width:70%;">
<br></br>

1. Demonstrate how to **create a security group** in Active Directory, and explain how this group can be used to control access to resources such as files and folders.
1. Show how to delegate administrative tasks to specific users or groups, including creating a custom **Administrative Template** and using Role-Based Access Control (RBAC) to grant permissions.

By following these steps, you should be able to give your technical audience a good understanding of what Active Directory is used for and how it can be used to manage a Windows domain.

[comment]: <> (this is the closing section of the demo steps. Please do not change anything here to keep the layout consistant with the other demoguides.)
<br></br>
***
<div style="background: lightgray; 
            font-size: 14px; 
            color: black;
            padding: 5px; 
            border: 1px solid lightgray; 
            margin: 5px;">

**Note:** This is the end of the current demo guide instructions.
</div>




