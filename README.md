# 1.The Repair Tools
## 1.1 For SFA-based and RFA-based Nopol
#### 1.1.1 Introduction
The Nopol is originally a RFA-based repair tool that repairs statements starting from the most suspicious statement to the least suspicious statement in the rank list.

#### 1.1.2 Modification details
To compare SFA against RFA, we need to obtain SFA-based Nopol from the current RFA-based Nopol.

To get SFA-based Nopol, we made modifications on the java files as follows:
1) NoPol.java
* This file is to instruct Nopol to repair the statement with RFA. We added a function "private SourceLocation randomChosen(List<SourceLocation> listSourceLocation)" into this file, and make corresponding modifications to make sure the availability of SFA.

2) Ochiai.java
* This file aims to calculate suspiciousness values for all suspicious statements and produce a rank list.

* To implement 6 experimental SFL techniques into jKali and jMutRepair, we modified this file by replacing the default Ochiai formula with the risk formulas for 6 SFL techniques.

3) Besides, we modified some other files to output the results of NCP and patch information.

#### 1.1.3 Introduction of ```SFANopol-with-NewOch```
In Section 4.4 of our paper, we propose a new strategy to improve the suspiciousness accuracy of Ochiai technique. Therefore, we modify the ```SFA-based Nopol``` into  ```SFANopol-with-NewOch```. The java file modified by us is ```NoPol.java```.

#### 1.1.4 Configuration
The configuration of Nopol can be found in the GitHub website of Nopol(https://github.com/SpoonLabs/nopol).

#### 1.1.5 Instructions of running the tools
When you want to run SFA-based Nopol, open the folder ```SFANopol```, and run ```runNopol.sh```. Similarly, if you want to run RFA-based Nopol, open the folder ```RFANopol```, and run ```runNopol.sh```.

Also, open the folder ```SFANopol-with-NewOch```, and run ```runNopol.sh```.

## 1.2 For SFA-based and RFA-based jkali and jMutRepair
#### 1.2.1 Introduction
The jKali and jMutRepair are initially RFA-based repair tools that repair statements starting from the most suspicious statement to the least suspicious statement in the rank list.

#### 1.2.2 Modification details
To compare SFA against RFA, we need to obtain SFA-based versions from the current RFA-based jKali and jMutRepair.

To get SFA-based versions, we made modifications on the java files as follows:
1) ExhaustiveSearchEngine.java
* This file is to instruct jKali and jMutRepair to repair the statement with RFA. We added a function "private ModificationPoint randomChosen(List<ModificationPoint> modifPoints)" into this file, and make corresponding modifications to make sure the availability of SFA.

2) GZoltarFaultLocalization.java
* This file aims to calculate suspiciousness values for all suspicious statements and produce a rank list.

* To implement 6 experimental SFL techniques into jKali and jMutRepair, we modified this file by adding the risk formulas for 6 SFL techniques.

3) Besides, we modified some other files to output the results of NCP and patch information.

#### 1.2.3 Configuration
The configuration of jKali and jMutRepair can be found in the GitHub website of Astor(https://github.com/SpoonLabs/astor).

#### 1.2.4 Instructions of running the tools
We implement SFA-based jKali and jMutRepair based on the source code of RFA-based jKali and jMutRepair.

When you want to run SFA-based jKali, you can run ```kaliRun``` shell script in the terminal. Similarly, when you want to run SFA-based jMutRepair, you can run ```mutRepairRun``` shell script in the terminal.

If you want to run RFA-based jKali or jMutRepair, you should do following steps:
1) Modify ```ExhaustiveSearchEngine.java```: comment the line ```ModificationPoint modifPoint=randomChosen(modifPoints1); //SFA``` and uncomment the line ```ModificationPoint modifPoint=modifPoint0; //RFA```;
2) Run ```kaliRun``` or ```mutRepairRun```.


## 1.3 For SFA-based and RFA-based SimFix
For SimFix, the RFA-simfix.jar and SFA-simfix.jar are available. Therefore you can run `RFA-run.sh` and `SFA-run.sh` to replicate the experiments of RFA-based and SFA-based SimFix, respectively.

# 2.The Result Data of NCP and Patch Diversity
#### 2.1 Introduction
In our experiment, we obtained 36 versions of repair tools (6 SFl * 2 statement selecting strategies * 3 repair tools = 36 versions of repair tools). And then run 100 independent repeated repair trials on each benchmark program. The total time cost is up to one and a half month.

The result data of NCP and patch diversity can be found in this folder.

#### 2.2 Instructions of Plotting Figures
To get the figures and results of statistcal tests presented in our paper:
1) Open the folder "Nopol", and run ```runAll.m``` and ```strategy2RunCompare.m``` respectively;
2) Open the folder "Astor/jKali", and run ```runAll.m```;
2) Open the folder "Astor/jMutRepair", and run ```runAll.m```;

#### 2.3 The Figures of our experiments
**The NCP distributions of SFA-based and RFA-based jKali**
![The NCP distributions of SFA-based jKali and RFA-based jKali](https://github.com/DehengYang/sfa-rfa/blob/master/doc/jKali.png)

**The NCP distributions of SFA-based and RFA-based jMutRepair**
![The NCP distributions of SFA-based jMutRepair and RFA-based jMutRepair](https://github.com/DehengYang/sfa-rfa/blob/master/doc/jMutRepair.png)

**The NCP distributions of SFA-based Nopol and RFA-based Nopol -- part 1:**
![The NCP distributions of SFA-based Nopol and RFA-based Nopol -- part 1](https://github.com/DehengYang/sfa-rfa/blob/master/doc/Nopol-1.png)

**The NCP distributions of SFA-based Nopol and RFA-based Nopol -- part 2:**
![The NCP distributions of SFA-based Nopol and RFA-based Nopol -- part 2](https://github.com/DehengYang/sfa-rfa/blob/master/doc/Nopol-2.png)

**The NCP distributions of SFA-based Nopol and RFA-based Nopol -- part 3 -- extended:**
![The NCP distributions of SFA-based Nopol and RFA-based Nopol -- part 3 -- extended](https://github.com/DehengYang/sfa-rfa/blob/master/doc/Nopol-3-extended.png)


**The NCP distributions of SFA-based Nopol and RFA-based Nopol -- part 3 -- extended:**
![The NCP distributions of SFA-based Nopol and RFA-based Nopol -- part 4 -- for 16 buggy programs](https://github.com/DehengYang/sfa-rfa/blob/master/doc/NCP%distributions%for%16%bugs.png)

**Statistical analysis of RQ 2:**
![Statistical analysis of RQ 2](https://github.com/DehengYang/sfa-rfa/blob/master/doc/Statistical%20analysis%20of%20RQ%202.png)
 
**Any advice is welcomed.**
