## Introduction
The jKali and jMutRepair are initially RFA-based repair tools that repair statements starting from the most suspicious statement to the least suspicious statement in the rank list.

## Modification details
To compare SFA against RFA, we need to obtain SFA-based versions from the current RFA-based jKali and jMutRepair.

To get SFA-based versions, we made modifications on the java files as follows:
1) ExhaustiveSearchEngine.java
* This file is to instruct jKali and jMutRepair to repair the statement with RFA. We added a function "private ModificationPoint randomChosen(List<ModificationPoint> modifPoints)" into this file, and make corresponding modifications to make sure the availability of SFA.

2) GZoltarFaultLocalization.java
* This file aims to calculate suspiciousness values for all suspicious statements and produce a rank list.

* To implement 6 experimental SFL techniques into jKali and jMutRepair, we modified this file by adding the risk formulas for 6 SFL techniques.

3) Besides, we modified some other files to output the results of NCP and patch information.

## Configuration
The configuration of jKali and jMutRepair can be found in the GitHub website of Astor(https://github.com/SpoonLabs/astor).

## Instructions of running the tools
We implement SFA-based jKali and jMutRepair based on the source code of RFA-based jKali and jMutRepair.

When you want to run SFA-based jKali, you can run ```kaliRun``` shell script in the terminal. Similarly, when you want to run SFA-based jMutRepair, you can run ```mutRepairRun``` shell script in the terminal.

If you want to run RFA-based jKali or jMutRepair, you should do following steps:
1) Modify ```ExhaustiveSearchEngine.java```: comment the line ```ModificationPoint modifPoint=randomChosen(modifPoints1); //SFA```` and umcomment the line ```ModificationPoint modifPoint=modifPoint0; //RFA```;
2) Run ```kaliRun``` or ```mutRepairRun```.