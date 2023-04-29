package Operatii;
import Polinom.Polinom;

import java.text.DecimalFormat;
import java.util.*;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Operatii {

    public Map<Integer, Float> conversion(String x) {
        Map<Integer, Float> aux = new HashMap<>();
        Pattern pattern = Pattern.compile("([+-]?\\d*)[xX](\\^(\\d+))?|([+-]?\\d+)"); //regex pentru transf din string in termeni
        Matcher matcher = pattern.matcher(x);
        while(matcher.find()) { //cat timp se gasesc termeni
            if(matcher.group(4) != null) { //in cazul in care x este la puterea 0
                float coef = Float.parseFloat(matcher.group(4));
                aux.put(0,coef);
            }
            else {
                if(matcher.group(1).equals("") || matcher.group(1).equals("-")) { //daca coeficientul este negativ
                    if(matcher.group(1).equals("-")) {
                        if(matcher.group(2) == null) { //-x^1
                            aux.put(1, (float) -1);
                        } else { //-x^n
                            int exp = Integer.parseInt(matcher.group(3));
                            aux.put(exp, (float) -1);
                        }
                    } else {
                        if(matcher.group(2) == null) { //x^1
                            aux.put(1, (float) 1);
                        } else { //x^n
                            int exp = Integer.parseInt(matcher.group(3));
                            aux.put(exp, (float) 1);
                        }
                    }
                } else try {
                    if(matcher.group(2) == null) { //m*x
                        float coef = Float.parseFloat(matcher.group(1));
                        aux.put(1, coef);
                    }
                    else { //m*x^n
                        int exp = Integer.parseInt(matcher.group(3));
                        float coef = Float.parseFloat(matcher.group(1));
                        aux.put(exp, coef);
                    }
                }catch (NumberFormatException e1) { //cand nu se poate face convertirea de la string la float la coeficient
                    int exp = Integer.parseInt(matcher.group(3));
                    aux.put(exp, (float) 1);
                }
            }
        }
        return aux;
    }

    public Map<Integer, Float> adunare(Map<Integer, Float> aux1, Map<Integer, Float> aux2){
        Map<Integer, Float> suma = new HashMap<>(aux1);

        for (Map.Entry<Integer, Float> a : aux2.entrySet()) {
            int expo = a.getKey();
            float coef = a.getValue();
            if (suma.containsKey(expo)) {
                suma.put(expo, suma.get(expo) + coef);
            } else {
                suma.put(expo, coef);
            }
        }
        return suma;
    }

    public Map<Integer, Float> scadere(Map<Integer, Float> aux1, Map<Integer, Float> aux2){
        Map<Integer, Float> diferenta = new HashMap<>(aux1);

        for (Map.Entry<Integer, Float> a : aux2.entrySet()) {
            int expo = a.getKey();
            float coef = a.getValue();
            if (diferenta.containsKey(expo)) {
                diferenta.put(expo, diferenta.get(expo) - coef);
            } else {
                diferenta.put(expo, -coef);
            }
        }

        return diferenta;
    }

    public Map<Integer, Float> inmultire(Map<Integer, Float> aux1, Map<Integer, Float> aux2){
        Map<Integer, Float> produs = new HashMap<>();
        for (Map.Entry<Integer, Float> a : aux1.entrySet()) {
            int exp1 = a.getKey();
            float coef1 = a.getValue();

            for (Map.Entry<Integer, Float> b : aux2.entrySet()) {
                int exp2 = b.getKey();
                float coef2 = b.getValue();

                int expf = exp1 + exp2;
                float coeff = coef1 * coef2;

                if (produs.containsKey(expf)) {
                    produs.put(expf, produs.get(expf) + coeff);
                } else {
                    produs.put(expf, coeff);
                }
            }
        }
        return produs;
    }

    public Map<Integer, Float> derivare(Map<Integer, Float> aux){
        Map<Integer, Float> derivata = new HashMap<>();
        for(Entry<Integer, Float> a: aux.entrySet()) {
            if(a.getKey() != 0)
            {
                int exp = a.getKey();
                float coef = a.getValue() * exp;
                derivata.put(exp - 1, coef);
            }
        }
        return derivata;
    }

    public Map<Integer, Float> integrare (Map<Integer, Float> aux){
        Map<Integer, Float> integrata = new HashMap<>();
        DecimalFormat df = new DecimalFormat("#.##");
        for(Entry<Integer, Float> a : aux.entrySet()) {
            int exp = a.getKey() + 1;
            double coef = a.getValue() / exp;
            String formatare = df.format(coef);
            coef = Float.parseFloat(formatare);
            integrata.put(exp,  (float)coef);
        }
        return integrata;
    }

    public Map<Integer, Float> impartire (Map<Integer, Float> aux1, Map<Integer, Float> aux2)
    {
        Map<Integer, Float> cat = new HashMap<>();
        int grad1 = Collections.max(aux1.keySet()); //gradul maxim din polinomul 1
        int grad2 = Collections.max(aux2.keySet()); //gradul maxim din polinomul 2
        if(grad1 == 0 || grad2 ==0)
        {
            cat.put(0,(float) 0);
            return cat;
        }
        if(grad1 < grad2) //in caz ca al doilea are grad mai mare nu se poate face impartirea
            return null;
        while (grad1 >= grad2 && !aux1.isEmpty()){ //impartim termen cu termen polinoamele
            float coef = aux1.get(grad1) / aux2.get(grad2); //coeficientul catului
            int grad = grad1 - grad2; //gradul rezultat in cat
            cat.put(grad,coef); //punem in cat rezultatul intreg

            for(int i = grad2; i >= 0; i--){ //actualizam coeficientii pentru a putea calcula urm. termen al impartirii
                float coef1 = aux1.containsKey(i + grad) ? aux1.get(i + grad) : 0;
                float coef2 = aux2.containsKey(i) ? aux2.get(i) : 0;
                float coef3 = coef1 - coef2 * coef;
                if(coef3 == 0){ //se elimina termenii cu coeficientii = 0
                    aux1.remove(i + grad);
                } else {
                    aux1.put(i + grad, coef3);
                }
            }
            grad1 = Collections.max(aux1.keySet());
        }
        return cat;
    }

    public String afisarePolinom(SortedMap<Integer, Float> aux) {
        String x = "";
        for(Entry<Integer, Float> a : aux.entrySet()) {
            int exp = a.getKey();
            float coef = a.getValue();
            Polinom p = new Polinom(exp,coef);
            if(coef != 0) {
                if(coef  < 0 ) {
                    x = x + "-";
                }
                else if(x != "") {
                    x = x + "+";
                }
                x = x + p.toString();
            }
        }
        return x;
    }
}