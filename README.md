# downgrade-ud <br>

![Screenshot-Downgrade-ud](https://user-images.githubusercontent.com/36802396/107845071-ba661280-6d8d-11eb-95e8-39053997df85.png)
<br>
A simple bash script to undo the last pacman system update.						<br>
Effort was focused on performing a system downgrade to Arch wiki described standards.			<br>
See: https://wiki.archlinux.org/index.php/downgrading_packages.						<br>
<br>
Warning: Running an Arch linux system holding packages back from update is not recommended.		<br>
See: https://wiki.archlinux.org/index.php/System_maintenance#Upgrading_the_system			<br>
And: https://wiki.archlinux.org/index.php/System_maintenance#Partial_upgrades_are_unsupported		<br>
<br>
Downgrade-ud reinstalls packages available in the pacman package cache only. Does not use ALA.		<br>
Primairly intended for use within a short time after an update leaves the system in a bootable,		<br>
but otherwise undesireable state, and is presumed correctable by reversing the update.			<br>
<br>
Dependencies: sudo pacutils										<br>

```
USAGE: downgrade-ud [operation]

operations:	-rl  --readable_list    print detailed downgrade list (packages-new-old-versions)
		-dl  --downgrade_list   print downgrade list in pacman useable format
		-dt  --downgrade_test   pacman simulated downgrade (prints only)
		-dg  --downgrade        pacman downgrades packages-versions from list
		-h   --help             print this help info
```

Downgrade-ud gets the last update package list with versions from /var/log/pacman.log.			<br>
The script verifies the packages prior to the last update are present in /var/cache/pacman/pkg/,	<br>
and will skip any packages not available.								<br>
The downgrade operation uses command `sudo pacman -U "${DowngradeList[@]}"`.				<br>
<br>
Downgrade-ud provides various levels of information gathering operations before downgrading.		<br>
The first two operations, '-rl, -dl' are provided for easy evaluation of what the downgrade entails.	<br>
The '-dt --downgrade_test' runs `sudo pacman -Up "${DowngradeList[@]}"`, on the downgrade package list, <br>
which is essentially a non transactional "dry run" with pacman providing output.			<br>
<br>
<br>
NEWS/UPDATE INFO:<br>
<br>
UPDATE: Mar 23, 2021:<br>
Added check function to exit if no updates were made today.						<br>
Reworded help info for clarity.										<br>
Changed "parse for no options" from calling the help function, to print a message.			<br>
Implemented shellcheck.											<br>
<br>
<br>
REPORT: initial release, Feb 12, 2021:<br>
I've used and tested downgrade-ud on my system, including downgrading the kernel and nvidia packages.	<br>
Have not encountered issues, but be aware this has minimal usage and testing on one system only.	<br>
Use at your own risk and before considering using it, please be advised to:				<br>
1) Know enough shell scripting to be able to read and understand what the script is doing.		<br>
2) Are able to handle a system downgrade manually, possibly using the script more for convenience.	<br>
3) Are capable of troubleshooting and fixing a borked system from an update/downgrade issue.		<br>

