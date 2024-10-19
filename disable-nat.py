#!/usr/bin/env python3

import subprocess
import platform

vms = [
    "companyrouter",
    "dns",
    "web",
    "database",
    "employee",
    "homerouter",
    "remote-employee",
]

if platform.system() == "Windows":
    vboxmanage_cmd = r"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
else:
    vboxmanage_cmd = (
        "VBoxManage"  # On Linux/Mac, VBoxManage is typically in the system PATH
    )

for vm in vms:
    print(f"Disabling NAT for {vm}")
    try:
        subprocess.run(
            [vboxmanage_cmd, "controlvm", vm, "setlinkstate1", "off"], check=True
        )
    except subprocess.CalledProcessError as e:
        print(f"Error disabling NAT for {vm}: {e}")
