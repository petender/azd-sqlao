[comment]: <> (please keep all comment items at the top of the markdown file)
[comment]: <> (please do not change the ***, as well as <div> placeholders for Note and Tip layout)
[comment]: <> (please keep the ### 1. and 2. titles as is for consistency across all demoguides)
[comment]: <> (section 1 provides a bullet list of resources + clarifying screenshots of the key resources details)
[comment]: <> (section 2 provides summarized step-by-step instructions on what to demo)


[comment]: <> (this is the section for the Note: item; please do not make any changes here)
***
## SQL Server 2019 AlwaysOn Availability Group - demo scenario

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
## 1. What Resources are getting deployed
This scenario deploys a SQL 2019 AlwaysOn Availability Group with 2 VM-Nodes, together with a Windows Server 2019 as Active Directory Domain Controller and DNS Server. To highlight the importance of protecting remote management activities of these servers, the scenario comes with Azure Bastion, allowing connectivity to a Tools-VM, which acts as a Privileged Access Workstation. 

* MTTDemoDeployRGc%youralias%ADDS - Azure Resource Group.
* mtt-dc-01 - Windows Server 2019 running Active Directory Domain Services
* mtt-sql-01 and 02 - Windows Server 2019 with SQL Server 2019
* mtt-sql-avs - Availability Set in Azure for the 2 SQL VM Nodes
* mtt-sql-lb - Internal Azure Load Balancer for the SQL Cluster
* toolVM-01 - Privileged Access Workstation allowing Remote Management of ADDS, SQL Mgmt Studio and Failover Cluster

(Note: Other resources such as disks, Virtual Network etc... have been excluded from this list, but they are part of the deployment)

<img src="https://raw.githubusercontent.com/petender/azd-sqlao/main/demoguide/SQLAO_ResourceGroup_Overview.png" alt="SQLAO Resource Group" style="width:70%;">
<br></br>

## 2. What can I demo from this scenario after deployment

### Bastion
1. After authenticating to the Azure Portal, navigate to the **mtt-dc-01** Virtual Machine.
1. From the **Overview** blade,  highlight there is **No Public IP address** resource allocated. This means the VM is only reachable from an "internal" source.
1. Select **Networking/Networking Settings**, and select the **Virtual Network** the VM is using.
1. From the **Virtual Network** settings, open **Subnets**. Highlight the 2 different **Subnets** used by the Virtual Machine, as well as the **AzureBastionSubnet**, used for the Azure Bastion service. 

<img src="https://raw.githubusercontent.com/petender/azd-sqlao/main/demoguide/AzureBastionSubnet.png" alt="ADDS Subnets" style="width:70%;">
<br></br>

1. From the **Virtual Network** resource / Settings / navigate to **Bastion**
1. **Specify the ADDS-VM** as VM to Connect to. Provide the necessary **local admin credentials** you specified during the AZD deployment.

<img src="https://raw.githubusercontent.com/petender/azd-sqlao/main/demoguide/ADDS_Bastion.png" alt="ADDS Bastion" style="width:70%;">
<br></br>

1. This opens a new browser tab, with an **RDP-session** to the ADDS VM.
1. Click **Allow** in the popup message regarding the text and images copied to the clipboard.

### Active Directory Domain Services (ADDS)
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

### Validate High Availability in SQL Server 2019 Using SQL Always On

SQL Always On is a feature that ensures high availability and disaster recovery for critical databases. This guide focuses on the validation steps for an existing Availability Group to verify its high availability functionality.

Failover Clustering is a crucial feature in Windows Server 2019 that ensures high availability for critical applications like SQL Server. The following detailed steps outline the validation process for a 2-node SQL Cluster within an availability group:

#### Step 1: Verify Cluster Configuration**
1. Open **Failover Cluster Manager** by searching for it in the Start Menu on either of the cluster nodes.
2. Connect to your cluster by entering its name.
3. Navigate to the **Nodes** section and ensure that both nodes are listed as "Up" and "Running."
4. Check the **Cluster Core Resources** tab to confirm that the cluster name and IP address are online.

#### Step 2: Validate Cluster Health
1. In the **Actions** pane of the Failover Cluster Manager, click on **Validate Cluster**.
2. Follow the wizard prompts and select all validation tests for a comprehensive check. This includes:
- Network Configuration
- Storage Configuration
- System Configuration
- Inventory
- Validation of SQL Services
3. Review the validation report generated at the end. Ensure there are no critical errors, as these may impact failover functionality.

#### Step 3: Test Failover of Cluster Resources
1. In Failover Cluster Manager, navigate to **Roles**.
2. Right-click on the SQL Server role and choose **Move** ➔ **Select Node**.
3. Choose the secondary node and observe the failover process:
- Ensure the role transitions successfully to the secondary node.
- Verify that all associated resources, such as the SQL Server service and disk drives, also come online on the new node.

#### Step 4: Validate Connectivity Post-Failover
1. Use SQL Server Management Studio (SSMS) to connect to the SQL Server instance using the cluster's virtual network name or IP address.
2. Run queries against the database in the availability group to confirm uninterrupted access and functionality.
3. Test application connections to ensure seamless failover transparency.

#### Step 5: Monitor Cluster Events
1. Open Event Viewer on either node, and navigate to **Applications and Services Logs** ➔ **Microsoft** ➔ **Windows** ➔ **FailoverClustering** ➔ **Operational**.
2. Look for any warning or error events related to cluster functionality.
3. Address any indicated issues to ensure continued cluster health.

#### Step 6: Validate Quorum Configuration
1. In Failover Cluster Manager, go to **Quorum Settings**.
2. Verify that the quorum configuration is suitable for your environment:
- For two nodes, ensure a **File Share Witness** or **Cloud Witness** has been configured to avoid split-brain scenarios.
3. Test the quorum by temporarily stopping the cluster service on one node and ensuring the cluster remains operational.

#### Step 7: Perform a Simulated Node Failure
1. On one of the nodes, disable the cluster service to simulate failure:
- Open an elevated PowerShell window and run `Stop-Service -Name ClusSvc`.
2. Monitor Failover Cluster Manager to ensure that the remaining node takes ownership of all cluster resources.
3. Re-enable the cluster service on the disabled node using `Start-Service -Name ClusSvc`.

#### Step 8: Review Cluster Shared Volumes (if applicable)
1. If your SQL Cluster utilizes Cluster Shared Volumes (CSV), ensure they are accessible and online after failover.
2. Navigate to the **Storage** section in Failover Cluster Manager and verify the status of all storage resources.
---
### Steps to Validate SQL Always On - Availability Group

#### Step 1: Verify Replica Status
1. Open SQL Server Management Studio (SSMS) and connect to the primary replica.
2. Navigate to **Always On High Availability** and expand **Availability Groups**.
3. Ensure all replicas are listed and their statuses are either “Synchronized” or “Synchronizing.”
4. Open the **Dashboard for Availability Groups** to monitor real-time synchronization health and check for any warnings or errors.

#### Step 2: Test Read-Only Routing (if configured)
1. Connect to a secondary replica using a read-only connection string.
2. Run queries to validate that the secondary replica is serving read-only workloads without errors.
3. Check the SQL Server Error Log for routing-related messages to confirm proper configuration and operation.

#### Step 3: Perform a Manual Failover
1. In SSMS, right-click the Availability Group and select **Failover**.
2. Follow the Failover Wizard to transfer the primary role to a designated secondary replica.
3. Verify the failover by:
- Checking the database status on the new primary replica to confirm it is now the primary.
- Ensuring applications can connect and operate seamlessly on the new primary node.
4. Revert the setup by failing over back to the original primary replica, if necessary.

#### Step 4: Simulate a Failure
1. Disconnect or shut down the current primary replica to simulate a node failure.
2. Observe the behavior of the Availability Group:
- If automatic failover is configured, ensure the secondary replica becomes primary without manual intervention.
- If manual failover is required, perform the failover using SSMS.
3. Validate that the databases remain accessible and functional after the failover event.

#### Step 5: Monitor Synchronization Health
1. Use the **Dashboard for Availability Groups** to check for synchronization delays or issues.
2. Review the synchronization states of all replicas and verify no data loss has occurred during failover or failure simulation tests.

#### Step 6: Review Logs
1. Open the SQL Server Error Log on all replicas to review any warnings or errors logged during validation tests.
2. Check the Windows Event Viewer and Cluster Logs to identify any failover-related events or issues.

#### Step 7: Document Findings
1. Record the results of all validation tests, including any anomalies or errors encountered.
2. Provide recommendations for adjustments or improvements based on the findings.
---

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




