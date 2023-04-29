package Polinom;

public class Polinom {

    public Integer exponent;
    public float coeficient;

    public Polinom(Integer exponent, float coeficient){
        this.exponent = exponent;
        this.coeficient = coeficient;
    }

    public void setExponent(Integer exponent) {
        this.exponent = exponent;
    }

    public void setCoeficient(float coeficient){
        this.coeficient = coeficient;
    }

    public Integer getExponent(){
        return this.exponent;
    }

    public double getCoeficient(){
        return this.coeficient;
    }

    public String toString(){
        String x ="";
        if(exponent == 0) {
            if(coeficient < 0)
                x = String.valueOf(coeficient * (-1));
            else
                x = String.valueOf(coeficient);
            return x;
        }
        else if(exponent == 1) {
            if(coeficient == 1.0 || coeficient == -1.0) {
                x = "x";
                return x;
            } else {
                if(coeficient < 0)
                    x = String.valueOf(coeficient * (-1)) +"x";
                else
                    x = String.valueOf(coeficient) + "x";
                return x;
            }
        } else {
            if(coeficient == 1.00 || coeficient == -1.00) {
                x = "x^" + String.valueOf(exponent);
                return x;
            } else {
                if(coeficient < 0)
                    x = String.valueOf(coeficient * (-1)) + "x^" + String.valueOf(exponent);
                else
                    x = String.valueOf(coeficient) + "x^" + String.valueOf(exponent);
                return x;
            }
        }
    }
}
