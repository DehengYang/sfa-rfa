/**
 * Copyright (C) SEI, PKU, PRC. - All Rights Reserved.
 * Unauthorized copying of this file via any medium is
 * strictly prohibited Proprietary and Confidential.
 * Written by Jiajun Jiang<jiajun.jiang@pku.edu.cn>.
 */
package cofix.main;

//revised by dale
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.util.Random;


import java.io.File;
import java.io.IOException;
import java.io.PrintStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

import org.apache.commons.io.FileUtils;
import org.eclipse.jdt.core.dom.ASTNode;
import org.eclipse.jdt.core.dom.ASTParser;
import org.eclipse.jdt.core.dom.FieldAccess;
import org.eclipse.jdt.core.dom.Name;
import org.eclipse.jdt.core.dom.Type;
import org.junit.runner.Result;

import cofix.common.config.Constant;
import cofix.common.inst.Instrument;
import cofix.common.inst.MethodInstrumentVisitor;
import cofix.common.junit.runner.JUnitEngine;
import cofix.common.junit.runner.JUnitRuntime;
import cofix.common.junit.runner.OutStream;
import cofix.common.localization.AbstractFaultlocalization;
import cofix.common.run.Runner;
import cofix.common.util.JavaFile;
import cofix.common.util.Pair;
import cofix.common.util.Status;
import cofix.common.util.Subject;
import cofix.core.match.CodeBlockMatcher;
import cofix.core.modify.Modification;
import cofix.core.modify.Revision;
import cofix.core.parser.NodeUtils;
import cofix.core.parser.node.CodeBlock;
import cofix.core.parser.node.Node;
import cofix.core.parser.search.BuggyCode;
import cofix.core.parser.search.SimpleFilter;

/**
 * @author Jiajun
 * @date Jun 20, 2017
 */
public class Repair {

	//revised by dale
	private final String _locRsltPath = Constant.HOME + "/d4j-info/location/ochiai";
	private List<Double> suspicions = new ArrayList<>();
	private static int selected = -1;  // added by dehengyang testResults/
	private int NCP = 0;
	private long startTime = 0;
	private long endTime = 0;

	private AbstractFaultlocalization _localization = null;
	private Subject _subject = null;
	private List<String> _failedTestCases = null;
	private Map<Integer, Set<Pair<String, String>>> _passedTestCasesMap = null;
	public Repair(Subject subject, AbstractFaultlocalization fLocalization) {
		_localization = fLocalization;
		_subject = subject;
		_failedTestCases = fLocalization.getFailedTestCases();
		_passedTestCasesMap = new HashMap<>();
//		try {
//			computeMethodCoverage();
//		} catch (IOException e) {
//			e.printStackTrace();
//		}
	}
	
	private void computeMethodCoverage() throws IOException{
		JUnitRuntime runtime = new JUnitRuntime(_subject);
		String src = _subject.getHome() + _subject.getSsrc();
		MethodInstrumentVisitor methodInstrumentVisitor = new MethodInstrumentVisitor();
		Instrument.execute(src, methodInstrumentVisitor);
		
		if(!Runner.compileSubject(_subject)){
			System.err.println("Build project failed!");
			System.exit(0);
		}
		
		System.out.println("Passed test classes : " + _localization.getPassedTestCases().size());
		for(String test : _localization.getPassedTestCases()){
			String[] testStr = test.split("#");
			String clazz = testStr[0];
			String methodName = testStr[1];
			OutStream outStream = new OutStream();
			Result result = JUnitEngine.getInstance(runtime).test(clazz, methodName, new PrintStream(outStream));
			if(result.getFailureCount() > 0){
				System.out.println("Error : Passed test cases running failed ! => " + clazz);
				System.exit(0);
			}
			for(Integer method : outStream.getOut()){
				Set<Pair<String, String>> tcases = _passedTestCasesMap.get(method);
				if(tcases == null){
					tcases = new HashSet<>();
				}
				tcases.add(new Pair<String, String>(clazz, methodName));
				_passedTestCasesMap.put(method, tcases);
			}
		}
		// restore source file
		_subject.restore();
	}
	
	//revised by dale
	private void transform(String fileName) throws NumberFormatException, IOException{
		List<Pair<String, Double>> suspStmt = new ArrayList<>();
		File file = new File(fileName);
		String line = null;
		BufferedReader bReader = null;
		bReader = new BufferedReader(new InputStreamReader(new FileInputStream(file), "UTF-8"));
		line = bReader.readLine();
		while((line = bReader.readLine()) != null){
			String[] lineAndSusp = line.split(",");
			if(lineAndSusp.length != 2){
				System.err.println("Suspicious line format error : " + line);
				continue;
			}
			String stmt = lineAndSusp[0];
			double susp = Double.parseDouble(lineAndSusp[1]);
			suspStmt.add(new Pair<String, Double>(stmt, susp));
		}
		bReader.close();
		
		Collections.sort(suspStmt, new Comparator<Pair<String, Double>>() {

			@Override
			public int compare(Pair<String, Double> o1, Pair<String, Double> o2) {
				if(o1.getSecond() > o2.getSecond()){
					return -1;
				} else if(o1.getSecond() < o2.getSecond()){
					return 1;
				} else {
					return 0;
				}
			}
		});
		
		File realtimeLocFile = new File(_locRsltPath + "/" + _subject.getName() + "/" + _subject.getId() + ".txt");
		if(!realtimeLocFile.exists()){
			realtimeLocFile.getParentFile().mkdirs();
			realtimeLocFile.createNewFile();
		}
		BufferedWriter bWriter = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(realtimeLocFile, false), "UTF-8"));
		
		List<Pair<String, Integer>> buggyLines = new LinkedList<>();
		for(Pair<String, Double> pair : suspStmt){
			bWriter.write(pair.getFirst() + "," + pair.getSecond() + ",1\n");
			String[] clazzAndLine = pair.getFirst().split("#");
			if(clazzAndLine.length != 2){
				System.err.println("Suspicous statement format error : " + pair.getFirst());
				continue;
			}
			
			String clazz = clazzAndLine[0];
			int index = clazz.indexOf("$");
			if(index > 0){
				clazz = clazz.substring(0, index);
			}
			int lineNum = Integer.parseInt(clazzAndLine[1]);
			buggyLines.add(new Pair<String, Integer>(clazz, lineNum));
		}
		bWriter.close();
	}
	
	
	//revised by dale
	private List<Pair<String, Integer>> getLocations() throws NumberFormatException, IOException {
		String path = _locRsltPath + "/" + _subject.getName() + "/" + _subject.getId() + ".txt";
		File file = new File(path);
		if(!file.exists()){
			System.out.println("(By dale) The SFL location result file does not exist : " + path);
			transform(_subject.getBuggyLineSuspFile());		
			//System.exit(0);
		}
		File file1 = new File(path);
		BufferedReader bufferedReader = null;
		try {
			bufferedReader = new BufferedReader(new InputStreamReader(new FileInputStream(file1), "UTF-8"));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		
		List<Pair<String, Integer>> locations = new ArrayList<>();
		String line = null;
		try {
			int count = 0;
			while((line = bufferedReader.readLine()) != null){
				if(line.length() > 0){
					String[] info = line.split("#");
					if(info.length < 2){
						System.err.println("Location format error : " + line);
						System.exit(0);
					}
					String[] linesInfo = info[1].split(",");
					Integer lineNumber = Integer.parseInt(linesInfo[0]);
					String stmt = info[0];
					int index = stmt.indexOf("$");

					//revised by dale
					String[] supicionInfo = linesInfo[1].split(",");
					suspicions.add(Double.parseDouble(supicionInfo[0]));

					if(index > 0){
						stmt = stmt.substring(0, index);
					}
					locations.add(new Pair<String, Integer>(stmt, lineNumber));
					count ++;
					if(count == 200){
						break;
					}
				}
			}
			bufferedReader.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return locations;
	}

	//revised by dale 2018-9-12
	private Pair<String, Integer> randomChosen(List<Pair<String, Integer>> locations, List<Double> suspicions){
		double sum = 0;
		int i;
		int size = locations.size();
		double[] suspicious = new double[size];
		
		for( i=0;i<size;i++){
			sum += suspicions.get(i);
			suspicious[i]=suspicions.get(i);
		}
		
		Random random = new Random(); 
		double selection = random.nextDouble();
		double tmpSum=0;	
		for(i=0;i<size;i++){
			tmpSum += (suspicious[i]/sum);
			if(selection < tmpSum){  
				Pair<String, Integer> loc = locations.get(i);
				selected=i;
				locations.remove(i);
				suspicions.remove(i);
				return loc;
			}
		}
		System.out.println(" Error occured in SFA Selection. (logged by dehengyang) ");
		return null;
	}


	public Status fix(Timer timer, String logFile, int currentTry) throws IOException{
		String src = _subject.getHome() + _subject.getSsrc();
//		List<Pair<String, Integer>> locations = _localization.getLocations(200);
		
		List<Pair<String, Integer>> locations = getLocations();

		int correct = 0;
		Set<String> haveTryBuggySourceCode = new HashSet<>();
		Status status = Status.FAILED;
		Set<String> patches = new HashSet<>();
//		for(Pair<String, Integer> loc_tmp : locations){
		
		
		int locations_size = locations.size();  
//		for(int tmp=0;tmp<locations_size;tmp++){    //SFA
		for(Pair<String, Integer> loc : locations){ //RFA
			
			//revised by dale
//			Pair<String, Integer> loc = randomChosen(locations, suspicions);    //SFA
	
			
			System.out.println(" We select: " + loc.getFirst() + "," + loc.getSecond() + " locations size: " +locations.size() 
				+ " suspicions size: " + suspicions.size() + "\n");

			if(timer.timeout()){
				return Status.TIMEOUT;
			}
			_subject.restore();
			FileUtils.deleteDirectory(new File(_subject.getHome() + _subject.getSbin()));
			FileUtils.deleteDirectory(new File(_subject.getHome() + _subject.getTbin()));
			System.out.println(loc.getFirst() + "," + loc.getSecond());
			
			String file = _subject.getHome() + _subject.getSsrc() + "/" + loc.getFirst().replace(".", "/") + ".java";
			String binFile = _subject.getHome() + _subject.getSbin() + "/" + loc.getFirst().replace(".", "/") + ".class";
			// get buggy code block
			
			//revised by dale
			endTime = System.currentTimeMillis();    
			JavaFile.writeStringToFile(logFile, ((endTime - startTime)/1000) + " s for the statement." + "\n", true);
			startTime = System.currentTimeMillis();    
			
			CodeBlock buggyblock = BuggyCode.getBuggyCodeBlock(file, loc.getSecond());
			Integer methodID = buggyblock.getWrapMethodID(); 
			if(methodID == null){
				logMessage(logFile, new Date(System.currentTimeMillis()).toString() + " : " + loc.getFirst() + "," + loc.getSecond() + "=>Find no block");
				System.out.println("Find no block!");
				continue;
			}
			logMessage(logFile, loc.getFirst() + "," + loc.getSecond());
			List<CodeBlock> buggyBlockList = new LinkedList<>();
			buggyBlockList.addAll(buggyblock.reduce());
			buggyBlockList.add(buggyblock);
			
			for(CodeBlock oneBuggyBlock : buggyBlockList){
				String currentBlockString = oneBuggyBlock.toSrcString().toString();
				if(currentBlockString == null || currentBlockString.length() <= 0){
					continue;
				}
				if(haveTryBuggySourceCode.contains(currentBlockString)){
					continue;
				}
				haveTryBuggySourceCode.add(currentBlockString);
				_subject.restore();
				Pair<Integer, Integer> range = oneBuggyBlock.getLineRangeInSource();
				Set<String> haveTryPatches = new HashSet<>();
				// get all variables can be used at buggy line
				Map<String, Type> usableVars = NodeUtils.getUsableVarTypes(file, loc.getSecond());
				// search candidate similar code block
				SimpleFilter simpleFilter = new SimpleFilter(oneBuggyBlock);
				
				List<Pair<CodeBlock, Double>> candidates = simpleFilter.filter(src, 0.3);
				List<String> source = null;
				try {
					source = JavaFile.readFileToList(file);
				} catch (IOException e1) {
					System.err.println("Failed to read file to list : " + file);
					continue;
				}
				int i = 1;
	//			Set<String> already = new HashSet<>();
				for(Pair<CodeBlock, Double> similar : candidates){
					// try top 100 candidates
					if(i > 100 || timer.timeout()){
						break;
					}
					
//					System.out.println("=====================" + (i++) +"==============================");
//					System.out.println(similar.getFirst().toSrcString().toString());
					// compute transformation
					List<Modification> modifications = CodeBlockMatcher.match(oneBuggyBlock, similar.getFirst(), usableVars);
					Map<String, Set<Node>> already = new HashMap<>();
					// try each transformation first
					List<Set<Integer>> list = new ArrayList<>();
					list.addAll(consistentModification(modifications));
					modifications = removeDuplicateModifications(modifications);
					for(int index = 0; index < modifications.size(); index++){
						Modification modification = modifications.get(index);
						String modify = modification.toString();
						Set<Node> tested = already.get(modify);
						if(tested != null){
							if(tested.contains(modification.getSrcNode())){
								continue;
							} else {
								tested.add(modification.getSrcNode());
							}
						} else {
							tested = new HashSet<>();
							tested.add(modification.getSrcNode());
							already.put(modify, tested);
						}
						Set<Integer> set = new HashSet<>();
						set.add(index);
						list.add(set);
					}
					
					List<Modification> legalModifications = new ArrayList<>();
					while(true){
						for(Set<Integer> modifySet : list){
							if(timer.timeout()){
								return Status.TIMEOUT;
							}
							
							for(Integer index : modifySet){
								modifications.get(index).apply(usableVars);
							}
							
							String replace = oneBuggyBlock.toSrcString().toString();
							if(replace.equals(currentBlockString)) {
								for(Integer index : modifySet){
									modifications.get(index).restore();
								}
								continue;
							}
							if(haveTryPatches.contains(replace)){
//								System.out.println("already try ...");
								for(Integer index : modifySet){
									modifications.get(index).restore();
								}
								if(legalModifications != null){
									for(Integer index : modifySet){
										legalModifications.add(modifications.get(index));
									}
								}
								continue;
							}
							
							System.out.println("========");
							System.out.println(replace);
							System.out.println("========");
							
							haveTryPatches.add(replace);
							try {
								JavaFile.sourceReplace(file, source, range.getFirst(), range.getSecond(), replace);
							} catch (IOException e) {
								System.err.println("Failed to replace source code.");
								continue;
							}
							try {
								FileUtils.forceDelete(new File(binFile));
							} catch (IOException e) {
							}
							
							// validate correctness of patch
							NCP ++;
							switch (validate(logFile, oneBuggyBlock)) {
							case COMPILE_FAILED:
//								haveTryPatches.remove(replace);
								break;
							case SUCCESS:
								String correctPatch = oneBuggyBlock.toSrcString().toString().replace("\\s*|\t|\r|\n", "");
								if(patches.contains(correctPatch)){
									continue;
								}
								patches.add(correctPatch);
								correct ++;
								// for debug
								dumpPatch(logFile, "Similar code block : " + similar.getSecond(), file, new Pair<Integer, Integer>(0, 0), similar.getFirst().toSrcString().toString());
								dumpPatch(logFile, "Original source code", file, range, currentBlockString); 
								dumpPatch(logFile, "Find a patch", file, range, oneBuggyBlock.toSrcString().toString());
								
								//revised by dale
								JavaFile.writeStringToFile(logFile, "NCP is: " + NCP + "\n", true);
								
								
								String target = Constant.HOME + "/patch/" + _subject.getName() + "/" + _subject.getId() + "/" + currentTry;
								File tarFile = new File(target);
								if(!tarFile.exists()){
									tarFile.mkdirs();
								}
								File sourceFile = new File(file);
								FileUtils.copyFile(sourceFile, new File(target + "/" + correct + "_" + sourceFile.getName()));
								status = Status.SUCCESS;
								if(correct == Constant.PATCH_NUM){
									//revised by dale
									JavaFile.writeStringToFile(logFile, ((System.currentTimeMillis() - startTime)/1000) + " s for the statement." + "\n", true);
									
									
									return Status.SUCCESS;
								}
								break; //remove passed revision
							case TEST_FAILED:
								if(legalModifications != null){
									for(Integer index : modifySet){
										legalModifications.add(modifications.get(index));
									}
								}
							}
							for(Integer index : modifySet){
								modifications.get(index).restore();
							}
						}
						if(legalModifications == null){
							break;
						}
						list = combineModification(legalModifications);
						modifications = legalModifications;
						legalModifications = null;
					}
				}
			}
		}
		System.out.println("here the repair fails. -dale. \n And the rest locations are : \n");
		for(int tmp=0;tmp<locations.size();tmp++){
			System.out.println(locations.get(tmp).getFirst()  + "  " + locations.get(tmp).getSecond());
		}
		return status;
	}
	
	private void logMessage(String logFile, String message){
		JavaFile.writeStringToFile(logFile, new Date(System.currentTimeMillis()).toString() + " " + message + "\n", true);
	}
	
	private void dumpPatch(String logFile, String message, String buggyFile, Pair<Integer, Integer> codeRange, String text){
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("\n----------------------------------------\n----------------------------------------\n");
		stringBuffer.append(message + " : [" + buggyFile + "=>" + codeRange.getFirst() + "," + codeRange.getSecond() + "]\n");
		stringBuffer.append(text);
		SimpleDateFormat simpleFormat=new SimpleDateFormat("yy/MM/dd HH:mm"); 
		stringBuffer.append("\nTime : " + simpleFormat.format(new Date()) + "\n");
		stringBuffer.append("----------------------------------------\n");
//		System.out.println(stringBuffer.toString());
		JavaFile.writeStringToFile(logFile, stringBuffer.toString(), true);
	}
	
	private List<Modification> removeDuplicateModifications(List<Modification> modifications){
		//remove duplicate modifications
		List<Modification> unique = new LinkedList<>();
		for (Modification modification : modifications) {
			boolean exist = false;
			for (Modification u : unique) {
				if (u.getRevisionTypeID() == modification.getRevisionTypeID()
						&& u.getSourceID() == modification.getSourceID()
						&& u.getTargetString().equals(modification.getTargetString())
						&& u.getSrcNode().toSrcString().toString().equals(modification.getSrcNode())) {
					exist = true;
					break;
				}
			}
			if(!exist){
				unique.add(modification);
			}
		}
		return unique;
	}
	
	
	private List<Set<Integer>> consistentModification(List<Modification> modifications){
		List<Set<Integer>> result = new LinkedList<>();
		String regex = "[A-Za-z_][0-9A-Za-z_.]*";
		Pattern pattern = Pattern.compile(regex);
		for(int i = 0; i < modifications.size(); i++){
			Modification modification = modifications.get(i);
			if(modification instanceof Revision){
				Set<Integer> consistant = new HashSet<>();
				consistant.add(i);
				for(int j = i + 1; j < modifications.size(); j++){
					Modification other = modifications.get(j);
					if(other instanceof Revision){
						if(modification.compatible(other) && modification.getTargetString().equals(other.getTargetString())){
							ASTNode node = JavaFile.genASTFromSource(modification.getTargetString(), ASTParser.K_EXPRESSION);
							if(node instanceof Name || node instanceof FieldAccess || pattern.matcher(modification.getTargetString()).matches()){
								consistant.add(j);
							}
						}
					}
				}
				if(consistant.size() > 1){
					result.add(consistant);
				}
			}
		}
		
		return result;
	}
	private List<Set<Integer>> combineModification(List<Modification> modifications){
		List<Set<Integer>> list = new ArrayList<>();
		int length = modifications.size();
		if(length == 0){
			return list;
		}
		int[][] incompatibleMap = new int[length][length];
		for(int i = 0; i < length; i++){
			for(int j = i; j < length; j++){
				if(i == j){
					incompatibleMap[i][j] = 1;
				} else if(modifications.get(i).compatible(modifications.get(j))){
					incompatibleMap[i][j] = 0;
					incompatibleMap[j][i] = 0;
				} else {
					incompatibleMap[i][j] = 1;
					incompatibleMap[i][j] = 1;
				}
			}
		}
		List<Set<Integer>> baseSet = new ArrayList<>();
		for(int i = 0; i < modifications.size(); i++){
			Set<Integer> set = new HashSet<>();
			set.add(i);
			baseSet.add(set);
		}
		
//		List<Set<Integer>> expanded = expand(incompatibleMap, baseSet, 2, 3);
//		for(Set<Integer> set : expanded){
//			Set<Modification> combinedModification = new HashSet<>();
//			for(Integer integer : set){
//				combinedModification.add(modifications.get(integer));
//			}
//			list.add(combinedModification);
//		}
		list.addAll(expand(incompatibleMap, baseSet, 2, 4));
		
		return list;
	}
	
	private List<Set<Integer>> expand(int[][] incompatibleTabe, List<Set<Integer>> baseSet, int currentSize, int upperbound){
		List<Set<Integer>> rslt = new LinkedList<>();
		if(currentSize > upperbound){
			return rslt;
		}
		while(baseSet.size() > 1000){
			baseSet.remove(baseSet.size() - 1);
		}
		int length = incompatibleTabe.length;
		for(Set<Integer> base : baseSet){
			int minIndex = 0;
			for(Integer integer : base){
				if(integer > minIndex){
					minIndex = integer;
				}
			}
			
			for(minIndex ++; minIndex < length; minIndex ++){
				boolean canExd = true;
				for(Integer integer : base){
					if(incompatibleTabe[minIndex][integer] == 1){
						canExd = false;
						break;
					}
				}
				if(canExd){
					Set<Integer> expanded = new HashSet<>(base);
					expanded.add(minIndex);
					rslt.add(expanded);
				}
			}
		}
		
		if(rslt.size() > 0){
			rslt.addAll(expand(incompatibleTabe, rslt, currentSize + 1, upperbound));
		}
		
		return rslt;
	}
	
	private ValidateStatus validate(String logFile, CodeBlock buggyBlock){
		if(!Runner.compileSubject(_subject)){
			System.out.println("Build failed !");
			return ValidateStatus.COMPILE_FAILED;
		}
		
		// validate patch using failed test cases
		for(String testcase : _failedTestCases){
			String[] testinfo = testcase.split("::");
			if(!Runner.testSingleTest(_subject, testinfo[0], testinfo[1])){
				System.out.println("Test failed !"+_subject+  " " + testinfo[0]+ " " + testinfo[1]);
				return ValidateStatus.TEST_FAILED;
			}
		}
		
		dumpPatch(logFile, "Pass Single Test", "", new Pair<Integer, Integer>(0, 0), buggyBlock.toSrcString().toString());
		
		if(!Runner.runTestSuite(_subject)){
			System.out.println("Positive Tests failed !");
			return ValidateStatus.TEST_FAILED;
		}
		
		System.out.println("Test succeed!");
		return ValidateStatus.SUCCESS;
	}
	
	private enum ValidateStatus{
		COMPILE_FAILED,
		TEST_FAILED,
		SUCCESS
	}

}
