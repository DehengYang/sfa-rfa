package fr.inria.lille.localization;

import fr.inria.lille.localization.metric.Metric;

/**
 * Created by bdanglot on 10/3/16.
 */
public abstract class AbstractStatement {

	private int ep;

	private int ef;

	private int np;

	private int nf;

	//added by dehengyang
	double suspiciousness;

	private Metric metric;

	public AbstractStatement(Metric metric) {
		this.metric = metric;
	}

	public int getEf() {
		return ef;
	}

	public int getEp() {
		return ep;
	}

	public int getNf() {
		return nf;
	}

	public int getNp() {
		return np;
	}

	public void setEf(int ef) {
		this.ef = ef;
	}

	public void setEp(int ep) {
		this.ep = ep;
	}

	public void setNf(int nf) {
		this.nf = nf;
	}

	public void setNp(int np) {
		this.np = np;
	}

	public double getSuspiciousness() {
		//System.out.println("==============ochiai is computed here=====================" + this.metric.value(this.ef, this.ep, this.nf, this.np)+ " " + ef +" " + ep+" " + nf+" " + np);
		return this.metric.value(this.ef, this.ep, this.nf, this.np);
		//return 1;
	}

	//added by dehengyang
	public void setSuspiciousness(double suspiciousness) {
		this.suspiciousness=suspiciousness;
	}
	public double getSuspiciousness2() {
		return this.suspiciousness;
	}

}
