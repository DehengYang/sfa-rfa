# The Repair Tools
## For SFA-based and RFA-based Nopol
### Introduction
The Nopol is originally a RFA-based repair tool that repairs statements starting from the most suspicious statement to the least suspicious statement in the rank list.

### Modification details
To compare SFA against RFA, we need to obtain SFA-based Nopol from the current RFA-based Nopol.

To get SFA-based Nopol, we made modifications on the java files as follows:
1) NoPol.java
* This file is to instruct Nopol to repair the statement with RFA. We added a function "private SourceLocation randomChosen(List<SourceLocation> listSourceLocation)" into this file, and make corresponding modifications to make sure the availability of SFA.

2) Ochiai.java
* This file aims to calculate suspiciousness values for all suspicious statements and produce a rank list.

* To implement 6 experimental SFL techniques into jKali and jMutRepair, we modified this file by replacing the default Ochiai formula with the risk formulas for 6 SFL techniques.

3) Besides, we modified some other files to output the results of NCP and patch information.

### Introduction of ```SFANopol-with-NewOch```
In Section 4.4 of our paper, we propose a new strategy to improve the suspiciousness accuracy of Ochiai technique. Therefore, we modify the ```SFA-based Nopol``` into  ```SFANopol-with-NewOch```. The java file modified by us is ```NoPol.java```.

### Configuration
The configuration of Nopol can be found in the GitHub website of Nopol(https://github.com/SpoonLabs/nopol).

### Instructions of running the tools
When you want to run SFA-based Nopol, open the folder ```SFANopol```, and run ```runNopol.sh```. Similarly, if you want to run RFA-based Nopol, open the folder ```RFANopol```, and run ```runNopol.sh```.

Also, open the folder ```SFANopol-with-NewOch```, and run ```runNopol.sh```.

## For SFA-based and RFA-based jkali and jMutRepair
### Introduction
The jKali and jMutRepair are initially RFA-based repair tools that repair statements starting from the most suspicious statement to the least suspicious statement in the rank list.

### Modification details
To compare SFA against RFA, we need to obtain SFA-based versions from the current RFA-based jKali and jMutRepair.

To get SFA-based versions, we made modifications on the java files as follows:
1) ExhaustiveSearchEngine.java
* This file is to instruct jKali and jMutRepair to repair the statement with RFA. We added a function "private ModificationPoint randomChosen(List<ModificationPoint> modifPoints)" into this file, and make corresponding modifications to make sure the availability of SFA.

2) GZoltarFaultLocalization.java
* This file aims to calculate suspiciousness values for all suspicious statements and produce a rank list.

* To implement 6 experimental SFL techniques into jKali and jMutRepair, we modified this file by adding the risk formulas for 6 SFL techniques.

3) Besides, we modified some other files to output the results of NCP and patch information.

### Configuration
The configuration of jKali and jMutRepair can be found in the GitHub website of Astor(https://github.com/SpoonLabs/astor).

### Instructions of running the tools
We implement SFA-based jKali and jMutRepair based on the source code of RFA-based jKali and jMutRepair.

When you want to run SFA-based jKali, you can run ```kaliRun``` shell script in the terminal. Similarly, when you want to run SFA-based jMutRepair, you can run ```mutRepairRun``` shell script in the terminal.

If you want to run RFA-based jKali or jMutRepair, you should do following steps:
1) Modify ```ExhaustiveSearchEngine.java```: comment the line ```ModificationPoint modifPoint=randomChosen(modifPoints1); //SFA``` and umcomment the line ```ModificationPoint modifPoint=modifPoint0; //RFA```;
2) Run ```kaliRun``` or ```mutRepairRun```.

## The Result Data of NCP and Patch Diversity
### Introduction
In our experiment, we obtained 36 versions of repair tools (6 SFl * 2 statement selecting strategies * 3 repair tools = 36 versions of repair tools). And then run 100 independent repeated repair trials on each benchmark program. The total time cost is up to one and a half month.

The result data of NCP and patch diversity can be found in this folder.

### Instructions of Plotting Figures
To get the figures and results of statistcal tests presented in our paper:
1) Open the folder "Nopol", and run ```runAll.m``` and ```strategy2RunCompare.m``` respectively;
2) Open the folder "Astor/jKali", and run ```runAll.m```;
2) Open the folder "Astor/jMutRepair", and run ```runAll.m```;
