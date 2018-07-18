## Introduction
The Nopol is originally a RFA-based repair tool that repairs statements starting from the most suspicious statement to the least suspicious statement in the rank list.

## Modification details
To compare SFA against RFA, we need to obtain SFA-based Nopol from the current RFA-based Nopol.

To get SFA-based Nopol, we made modifications on the java files as follows:
1) NoPol.java
* This file is to instruct Nopol to repair the statement with RFA. We added a function "private SourceLocation randomChosen(List<SourceLocation> listSourceLocation)" into this file, and make corresponding modifications to make sure the availability of SFA.

2) Ochiai.java
* This file aims to calculate suspiciousness values for all suspicious statements and produce a rank list.

* To implement 6 experimental SFL techniques into jKali and jMutRepair, we modified this file by replacing the default Ochiai formula with the risk formulas for 6 SFL techniques.

3) Besides, we modified some other files to output the results of NCP and patch information.

## Introduction of ```SFANopol-with-NewOch```
In Section 4.4 of our paper, we propose a new strategy to improve the suspiciousness accuracy of Ochiai technique. Therefore, we modify the ```SFA-based Nopol``` into  ```SFANopol-with-NewOch```. The java file modified by us is ```NoPol.java```.

## Configuration
The configuration of Nopol can be found in the GitHub website of Nopol(https://github.com/SpoonLabs/nopol).

## Instructions of running the tools
When you want to run SFA-based Nopol, open the folder ```SFANopol```, and run ```runNopol.sh```. Similarly, if you want to run RFA-based Nopol, open the folder ```RFANopol```, and run ```runNopol.sh```.

Also, open the folder ```SFANopol-with-NewOch```, and run ```runNopol.sh```.