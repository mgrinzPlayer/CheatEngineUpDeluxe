# CheatEngineUpDeluxe

## Description
It will help to set up FreePascal/Lazarus environment needed for building [Cheat Engine 7.0](https://github.com/cheat-engine/cheat-engine)


## Instructions
Download [prepareLazarusEnvAndCE.zip](https://github.com/mgrinzPlayer/CheatEngineUpDeluxe/releases/latest)

Extract it to folder where you have write permission. Make sure there are no spaces or non-English characters in the path. You will need at least 2.5GB free space. Installed SVN client is required, be it TortoiseSVN with command line client tools or SlikSVN.

Launch "prepare Lazarus Env.cmd"

You have several options to choose from. You can download files from original source or you can download heavily compressed (7zip) files from this repository.

There is also compiled FreePascal package: FPC 3.2.0, branch: fixes_3_2, revision 42444.


<p align="center">
<img src="https://github.com/mgrinzPlayer/CheatEngineUpDeluxe/raw/master/screenshot.png" />
</p>

Launch Lazarus at least once then launch "prepare CE.cmd"

You can edit some variables like buildmode (release or debug) or cpumode (i386 or x86_64).

By default it will compile 32 and 64bit CE. You can find executables inside CheatEngine\bin folder.

To compile other CE componens, launch Lazarus, open lpi file (e.g. vehdebug.lpi) and choose "compile many modes".
