/*
 * Copyright (C) 2013 INRIA
 *
 * This software is governed by the CeCILL-C License under French law and
 * abiding by the rules of distribution of free software. You can use, modify
 * and/or redistribute the software under the terms of the CeCILL-C license as
 * circulated by CEA, CNRS and INRIA at http://www.cecill.info.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the CeCILL-C License for more details.
 *
 * The fact that you are presently reading this means that you have had
 * knowledge of the CeCILL-C license and that you accept its terms.
 */
package fr.inria.lille.localization;

import com.gzoltar.core.GZoltar;
import com.gzoltar.core.components.Statement;
import com.gzoltar.core.components.count.ComponentCount;
import com.gzoltar.core.instr.testing.TestResult;
import fr.inria.lille.localization.metric.Metric;
import fr.inria.lille.localization.metric.Ochiai;
import fr.inria.lille.repair.common.config.NopolContext;
import fr.inria.lille.repair.nopol.SourceLocation;
import xxl.java.junit.TestCase;

import java.io.IOException;
import java.net.URL;
import java.util.*;

import static com.google.common.base.Preconditions.checkNotNull;

// added by dehengyang
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import fr.inria.lille.repair.nopol.NoPol;

/**
 * A list of potential bug root-cause.
 *
 * @author Favio D. DeMarco
 */
public final class GZoltarFaultLocalizer extends GZoltar implements FaultLocalizer {

	private Metric metric;

	private List<StatementExt> statements;

	public GZoltarFaultLocalizer(NopolContext nopolContext) throws IOException {
		this(nopolContext.getProjectClasspath(), checkNotNull(Arrays.asList("")), nopolContext.getProjectTests(), new Ochiai());
	}

	public GZoltarFaultLocalizer(final URL[] classpath, Collection<String> packageNames, String[] test, Metric metric) throws IOException {
		super(System.getProperty("user.dir"));
		this.metric = metric;
		ArrayList<String> classpaths = new ArrayList<>();
		for (URL url : classpath) {
			if ("file".equals(url.getProtocol())) {
				classpaths.add(url.getPath());
			} else {
				classpaths.add(url.toExternalForm());
			}
		}

		this.setClassPaths(classpaths);
		/*dehengyang test here	*/	
		this.addPackageNotToInstrument("org.junit");
		this.addPackageNotToInstrument("junit.framework");
		this.addTestPackageNotToExecute("junit.framework");
		this.addTestPackageNotToExecute("org.junit");
		
		for (String packageName : packageNames) {
			this.addPackageToInstrument(packageName);
		}

		this.statements = run(test);
	}

	public List<AbstractStatement> getStatements() {
		List<AbstractStatement> abstractStatements = new ArrayList<>();
		for (StatementExt statement : this.statements) {
			abstractStatements.add(statement);
		}
		return abstractStatements;
	}

	public List<com.gzoltar.core.instr.testing.TestResult> getTestResults() {
		return super.getTestResults();
	}

	@Override
	public Map<SourceLocation, List<fr.inria.lille.localization.TestResult>> getTestListPerStatement() {
		Map<SourceLocation, List<fr.inria.lille.localization.TestResult>> results = new HashMap<>();
		List<TestResult> testResults = this.getTestResults();
		long startT = System.currentTimeMillis();//dehengyang	
		long endT;
		

		for (int j = 0; j < testResults.size(); j++) {
			TestResult testResult = testResults.get(j);
			TestResultImpl test = new TestResultImpl(TestCase.from(testResult.getName()), testResult.wasSuccessful());
			try{
				FileWriter infoWriter = new FileWriter(NoPol.infoTXTPath,true);
				infoWriter.write(j + "th testCase:\n" + testResult.getName() + "  "+ testResult.wasSuccessful() + "\n" );
				infoWriter.close(); 
			}catch (IOException e) {
			    e.printStackTrace();
			}
			List<ComponentCount> components = testResult.getCoveredComponents();
			for (int i = 0; i < components.size(); i++) {
				ComponentCount component1 = components.get(i);
				Statement component = (Statement) component1.getComponent();
				String containingClass = component.getMethod().getParent().getLabel();

				SourceLocation sourceLocation = new SourceLocation(containingClass, component.getLineNumber());
				if (!results.containsKey(sourceLocation)) {
					results.put(sourceLocation, new ArrayList<fr.inria.lille.localization.TestResult>());
				}
				results.get(sourceLocation).add(test);
			}
		}
		
		endT = System.currentTimeMillis();
		try{
			FileWriter infoWriter1 = new FileWriter(NoPol.infoTXTPath,true);
			infoWriter1.write("\n\n\n\n\nThe time of saving all test cases is: "+ (endT-startT) + "\n\n\n\n\n" );
			infoWriter1.close(); 
		}catch (IOException e) {
		    e.printStackTrace();
		}

		LinkedHashMap<SourceLocation, List<fr.inria.lille.localization.TestResult>> map = new LinkedHashMap<>();
		for (StatementSourceLocation source : this.statements) {
			//杨德亨在此添加可疑值。
			source.getLocation().setSuspiciousValue(source.getSuspiciousness());
			map.put(source.getLocation(), results.get(source.getLocation()));
		}

		results = map;
		return results;
	}

	/**
	 * @param testClasses
	 * @return a ranked list of potential bug root-cause.
	 */
	private List<StatementExt> run(final String... testClasses) {
		for (String className : checkNotNull(testClasses)) {
			this.addTestToExecute(className); // we want to execute the test
			this.addClassNotToInstrument(className); // we don't want to include the test as root-cause
			// candidate
		}
		this.run();
		return this.getSuspiciousStatements(this.metric);
	}

	private List<StatementExt> getSuspiciousStatements(final Metric metric) {
		List<Statement> suspiciousStatements = super.getSuspiciousStatements();

		List<StatementExt> result = new ArrayList<>(suspiciousStatements.size());
		int successfulTests;
		int nbFailingTest = 0;
		List<TestResult> testResults = super.getTestResults();
		for (int i = testResults.size() - 1; i >= 0; i--) {
			TestResult testResult = testResults.get(i);
			if (!testResult.wasSuccessful()) {
				nbFailingTest++;
			}
		}
		successfulTests = testResults.size() - nbFailingTest;

		try{
			File fileDir = new File("./testResults");
			if(!fileDir.exists()){
				fileDir.mkdir();
			}
			FileWriter infoWriter = new FileWriter(NoPol.infoTXTPath,true);
			infoWriter.write("\n nbFailingTest\n" + nbFailingTest + "\n nbSucceedTest\n" + successfulTests + "\n");
			infoWriter.close(); 
		}catch (IOException e) {
	            e.printStackTrace();
	        }

		for (int i = suspiciousStatements.size() - 1; i >= 0; i--) {
			Statement statement = suspiciousStatements.get(i);
			BitSet coverage = statement.getCoverage();
			int executedAndPassedCount = 0;
			int executedAndFailedCount = 0;
			int nextTest = coverage.nextSetBit(0);
			while (nextTest != -1) {
				TestResult testResult = testResults.get(nextTest);
				if (testResult.wasSuccessful()) {
					executedAndPassedCount++;
				} else {
					executedAndFailedCount++;
				}
				nextTest = coverage.nextSetBit(nextTest + 1);
			}
			StatementExt s = new StatementExt(metric, statement);
			s.setEf(executedAndFailedCount);
			s.setEp(executedAndPassedCount);
			s.setNp(successfulTests - executedAndPassedCount);
			s.setNf(nbFailingTest - executedAndFailedCount);

			//add sourcelocation info about ep and ef
			s.getLocation().setEp(executedAndPassedCount);
			s.getLocation().setEf(executedAndFailedCount);
			s.getLocation().setNp(successfulTests - executedAndPassedCount);
			s.getLocation().setNf(nbFailingTest - executedAndFailedCount);
			//System.out.println("statementGzoltar suspicious:" + s.getSuspiciousness());
			//s.getLocation().setSuspiciousValue(s.getSuspiciousness());

			result.add(s);
		}
		Collections.sort(result, new Comparator<StatementExt>() {
			@Override
			public int compare(final StatementExt o1, final StatementExt o2) {
				// reversed parameters because we want a descending order list
				return Double.compare(o2.getSuspiciousness(), o1.getSuspiciousness());
			}
		});
		return result;
	}

	@Deprecated
	private List<SuspiciousStatement> sortByDescendingOrder(List<SuspiciousStatement> statements) {
		List<SuspiciousStatement> tmp = new ArrayList<>(statements);
		Collections.sort(tmp, new Comparator<SuspiciousStatement>() {
			@Override
			public int compare(final SuspiciousStatement o1, final SuspiciousStatement o2) {
				// reversed parameters because we want a descending order list
				return Double.compare(o2.getSuspiciousness(), o1.getSuspiciousness());
			}
		});
		return tmp;
	}
}
