package fr.inria.lille.localization.metric;

/**
 * Created by spirals on 24/07/15.
 */
public class Ochiai implements Metric {
    @Override
    public double value(int ef, int ep, int nf, int np) {
        //return ef/Math.sqrt((ef+ep)*(ef+nf));
	return ef / ((double) (ef + ep + nf));  // Now jaccard added by dehengyang
	
	//if(ef+nf == 0) {
        //    return 0;
        //}
        //return (ef / ((double) (ef + nf))) / ((ef / ((double)(ef + nf))) + (ep/ ((double) ep + np))) ;// Now Tarantula added by dehengyang  2017-11-27
	

	//return ef-ep/(double)(ep+np+1);//op2 2017 12-4 09:08 china time

	//return 1-ep/((double)(ep+ef));//barinel 2017 12-6 09:25 china time
	
	//return ef*ef/(double)(ep+nf);  //DStar 2017 12-11 18:24 china time 
    }
}
