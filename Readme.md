# Extract-VMWare-VM-Gen-Encryption-Win

**Extract-VMWare-VM-Gen-Encryption-Win** is a PowerShell script designed to **retrieve the VM encryption secret** (such as the encryption GUID or key) from the **Windows Credential Store**. This is particularly useful for administrators or automation workflows that need to backup, migrate, or audit encrypted VMware virtual machines on Windows systems.

## What does it do?

- **Automates extraction** of VM encryption secrets stored in the Windows Credential Manager.
- **Reads and parses credentials** related to VMware VM encryption, allowing you to securely access or export these secrets for backup or migration purposes.


## Typical Use Case

1. **Backup or Migration**: When migrating or backing up encrypted VMware VMs, you may need to retrieve the encryption secret stored in the Windows Credential Store.
2. **Auditing**: For compliance or security audits, you may need to verify or export the encryption GUIDs or keys associated with your VMs.

## How it works

- The script queries the Windows Credential Store for entries related to VMware VM encryption.
- It extracts the relevant secret (e.g., `encryptedVM.guid`) and outputs it securely for use in your workflow.

## Usage
0. (clone the repo)
1. run in powershell``./extract_vmware_generic_secret.ps1``
2. enter the path to your vmx, like ``D:\My VMs\VM1\encryptedvm.vmx``
3. copy secret from notepad with :keyboard: `Ctrl+A` and :keyboard: `Ctrl+C`
4. on the other machine, open windows credential manager, in windows credentials, scroll down and add a new generic credential with the uuid outputted into the console as name and username, and as password just :keyboard: `Ctrl+V` the secret copied from notepad.
5. enjoy :-)


---

