package fr.inria.lille.localization;

import fil.iagl.opl.cocospoon.processors.WatcherProcessor;
import fr.inria.lille.commons.spoon.SpoonedProject;
import fr.inria.lille.localization.metric.Metric;
import fr.inria.lille.repair.common.config.NopolContext;
import fr.inria.lille.repair.nopol.SourceLocation;
import instrumenting._Instrumenting;
import xxl.java.junit.TestCasesListener;
import xxl.java.junit.TestSuiteExecution;

import java.util.*;

// added by dehengyang
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import fr.inria.lille.repair.nopol.NoPol;

/**
 * Created by bdanglot on 10/3/16.
 */
public class CocoSpoonBasedSpectrumBasedFaultLocalizer extends DumbFaultLocalizerImpl {

	private final Metric metric;
	private int nbSucceedTest;
	private int nbFailingTest;

	private List<StatementSourceLocation> statements;

	public CocoSpoonBasedSpectrumBasedFaultLocalizer(NopolContext nopolContext, Metric metric) {
		super(nopolContext);
		this.metric = metric;
		this.statements = new ArrayList<>();
	}

	@Override
	protected void runTests(String[] testClasses, NopolContext nopolContext, SpoonedProject spooner, WatcherProcessor processor) {
		ClassLoader cl = spooner.processedAndDumpedToClassLoader(processor);
		TestCasesListener listener = new TestCasesListener();
		Map<String, Boolean> resultsPerNameOfTest = new HashMap<>();
		Map<String, Map<SourceLocation, Boolean>> linesExecutedPerTestNames = new HashMap<>();
		nbFailingTest = 0;
		nbSucceedTest = 0;
		for (int i = 0; i < testClasses.length; i++) {
			try {
				for (String methodName : super.getTestMethods(cl.loadClass(testClasses[i]))) {
					String testMethod = testClasses[i] + "#" + methodName;
					TestSuiteExecution.runTest(testMethod, cl, listener, nopolContext);
					//Since we executed one test at the time, the listener contains one and only one TestCase
					boolean testSucceed = listener.numberOfFailedTests() == 0;
					resultsPerNameOfTest.put(testMethod, testSucceed);

//add by dehengyang
					try{
						FileWriter infoWriter = new FileWriter(NoPol.infoTXTPath,true);
						infoWriter.write(i + "th testMethod:\n" + testMethod+ "\n" );
						infoWriter.close(); 
					}catch (IOException e) {
					    e.printStackTrace();
					}					

					if (testSucceed) {
						nbSucceedTest++;
					} else {
						nbFailingTest++;
					}
					linesExecutedPerTestNames.put(testMethod, super.copyExecutedLinesAndReinit(_Instrumenting.lines));
				}
			} catch (ClassNotFoundException e) {
				throw new RuntimeException(e);
			}
		}

//add by dehengyang
		try{
			FileWriter infoWriter = new FileWriter(NoPol.infoTXTPath,true);
			infoWriter.write("\n nbFailingTest\n" + nbFailingTest + "\n nbSucceedTest\n" + nbSucceedTest );
			infoWriter.close(); 
		}catch (IOException e) {
	            e.printStackTrace();
	        }

		this.buildTestResultPerSourceLocation(resultsPerNameOfTest, linesExecutedPerTestNames);
	}

	@Override
	public Map<SourceLocation, List<TestResult>> getTestListPerStatement() {
		sortBySuspiciousness();
		return super.getTestListPerStatement();
	}

	private void sortBySuspiciousness() {
		for (SourceLocation sourceLocation : this.countPerSourceLocation.keySet()) {
			StatementSourceLocation current = new StatementSourceLocation(this.metric, sourceLocation);
			int ef = 0;
			int ep = 0;
			for (TestResult results : this.countPerSourceLocation.get(sourceLocation)) {
				if (results.isSuccessful())
					ep++;
				else
					ef++;
			}
			current.setNf(nbFailingTest - ef);
			current.setNp(nbSucceedTest - ep);
			current.setEp(ep);
			current.setEf(ef);

//add by dehengyang : to identify if the buggy program has randomness, which leads to different ep and ef for some statements.
			sourceLocation.setEp(ep);
			sourceLocation.setEf(ef);

			current.setSuspiciousness(current.getSuspiciousness());



			statements.add(current);
		}
		Collections.sort(statements, new Comparator<StatementSourceLocation>() {
			@Override
			public int compare(StatementSourceLocation o1, StatementSourceLocation o2) {
				return Double.compare(o2.getSuspiciousness(), o1.getSuspiciousness());
			}
		});

		LinkedHashMap<SourceLocation, List<TestResult>> map = new LinkedHashMap<>();
		for (StatementSourceLocation source : statements) {
			//杨德亨在此为可疑值语句 添加 可疑值。 就一行语句 dehengyang
			source.getLocation().setSuspiciousValue(source.getSuspiciousness2());
			map.put(source.getLocation(), this.countPerSourceLocation.get(source.getLocation()));
		}
		this.countPerSourceLocation = map;
	}

	@Override
	public List<AbstractStatement> getStatements() {
		List<AbstractStatement> abstractStatements = new ArrayList<>();
		for (StatementSourceLocation statement : this.statements) {
			abstractStatements.add(statement);
		}
		return abstractStatements;
	}
}
