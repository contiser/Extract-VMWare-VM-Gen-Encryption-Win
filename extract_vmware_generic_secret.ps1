Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class CredMan
{
    [DllImport("Advapi32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
    public static extern bool CredRead(string target, int type, int reservedFlag, out IntPtr CredentialPtr);

    [DllImport("Advapi32.dll", SetLastError = true)]
    public static extern void CredFree([In] IntPtr cred);

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct CREDENTIAL
    {
        public int Flags;
        public int Type;
        public IntPtr TargetName;
        public IntPtr Comment;
        public System.Runtime.InteropServices.ComTypes.FILETIME LastWritten;
        public int CredentialBlobSize;
        public IntPtr CredentialBlob;
        public int Persist;
        public int AttributeCount;
        public IntPtr Attributes;
        public IntPtr TargetAlias;
        public IntPtr UserName;
    }

    public static string ReadCredential(string target)
    {
        IntPtr credPtr;
        if (CredRead(target, 1, 0, out credPtr))
        {
            CREDENTIAL cred = (CREDENTIAL)Marshal.PtrToStructure(credPtr, typeof(CREDENTIAL));
            string secret = Marshal.PtrToStringUni(cred.CredentialBlob, cred.CredentialBlobSize / 2);
            CredFree(credPtr);
            return secret;
        }
        else
        {
            throw new Exception("CredRead failed with error code: " + Marshal.GetLastWin32Error());
        }
    }
}
"@

# Ask the user to input the path to the .vmx file
$vmxPath = Read-Host "Enter the path to the .vmx file"

# Read the .vmx file line by line
$lines = Get-Content $vmxPath

# Search for the line containing 'encryptedVM.guid'
$encryptedGuidLine = $lines | Where-Object { $_ -match '^encryptedVM\.guid\s*=' }

if ($encryptedGuidLine) {
    # Extract the value inside the quotes
    if ($encryptedGuidLine -match 'encryptedVM\.guid\s*=\s*"(.*)"') {
        $encryptedGuid = $matches[1]
    } else {
        Write-Error "Field encryptedVM.guid is present, but value not found."
        exit 1
    }
} else {
    Write-Error "Field encryptedVM.guid is not present in the file."
    exit 1
}

# Replace the GUID with the One you read by opening your vmx in a text editor in field encryptedVM.guid
$guid = $encryptedGuid
[CredMan]::ReadCredential($guid) > cred.txt
notepad cred.txt
Write-Host "`n Credential saved in kind of plaintext at $(Get-Location)\cred.txt `n`n"
Write-Host "NOW MANUALLY CREATE IN WIN CREDENTIAL STORE A GENERIC CREDENTIAL WITH ITEM NAME $guid, USERNAME $guid , and as password what's shown in notepad. then open .vmx again" -ForegroundColor Green