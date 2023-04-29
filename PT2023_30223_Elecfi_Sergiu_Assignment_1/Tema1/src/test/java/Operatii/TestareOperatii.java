package Operatii;

import org.junit.Assert;
import org.junit.Test;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

public class TestareOperatii {
    Operatii op = new Operatii();
    @Test
    public void TestareAdunare(){
        Map<Integer, Float> poli1 = new HashMap<>();
        Map<Integer, Float> poli2 = new HashMap<>();
        poli1.put(3,(float)1.0);
        poli1.put(2,(float)-2);
        poli1.put(1,(float)-6);
        poli1.put(0,(float)-5);

        poli2.put(2,(float)1);
        poli2.put(0,(float)-1);

        Map<Integer, Float> poli3 = new HashMap<>();
        poli3 = op.adunare(poli1,poli2);
        SortedMap<Integer, Float> reversedMap = new TreeMap<>(Collections.reverseOrder());
        reversedMap.putAll(poli3);
        String af = op.afisarePolinom(reversedMap);
        Assert.assertEquals("x^3-x^2-6.0x-6.0",af);

        Map<Integer, Float> poli4 = new HashMap<>();
        Map<Integer, Float> poli5 = new HashMap<>();

        poli4.put(2,(float)-2);
        poli4.put(1,(float)3);
        poli4.put(0,(float)-6);

        poli5.put(2,(float)2);
        poli5.put(1,(float)-3);
        poli5.put(0,(float)6);

        poli3 = op.adunare(poli4,poli5);
        SortedMap<Integer, Float> reversedMap1 = new TreeMap<>(Collections.reverseOrder());
        reversedMap.putAll(poli3);
        String af1 = op.afisarePolinom(reversedMap1);
        Assert.assertEquals("",af1);
    }

    @Test
    public void testareImpartire(){
        Map<Integer, Float> poli1 = new HashMap<>();
        Map<Integer, Float> poli2 = new HashMap<>();
        poli1.put(3,(float)1.0);
        poli1.put(2,(float)-2);
        poli1.put(1,(float)-6);
        poli1.put(0,(float)-5);

        poli2.put(2,(float)1);
        poli2.put(0,(float)-1);

        Map<Integer, Float> poli3 = new HashMap<>();
        poli3 = op.impartire(poli1,poli2);
        SortedMap<Integer, Float> reversedMap = new TreeMap<>(Collections.reverseOrder());
        reversedMap.putAll(poli3);
        String af = op.afisarePolinom(reversedMap);
        Assert.assertEquals("x-2.0",af);
    }

    @Test
    public void testareScadere(){
        Map<Integer, Float> poli1 = new HashMap<>();
        Map<Integer, Float> poli2 = new HashMap<>();

        poli1.put(3,(float)1.0);
        poli1.put(2,(float)-2);
        poli1.put(1,(float)-6);
        poli1.put(0,(float)-5);

        poli2.put(2,(float)1);
        poli2.put(0,(float)-1);

        Map<Integer, Float> poli3 = new HashMap<>();
        poli3 = op.scadere(poli1,poli2);
        SortedMap<Integer, Float> reversedMap = new TreeMap<>(Collections.reverseOrder());
        reversedMap.putAll(poli3);
        String af = op.afisarePolinom(reversedMap);
        Assert.assertEquals("x^3-3.0x^2-6.0x-4.0",af);

        Map<Integer, Float> poli4 = new HashMap<>();
        Map<Integer, Float> poli5 = new HashMap<>();
        poli4.put(4,(float)3);
        poli4.put(2,(float)5);
        poli4.put(1,(float)-2);
        poli4.put(0,(float)-5);

        poli5.put(4,(float)3);
        poli5.put(2,(float)5);
        poli5.put(1,(float)-2);
        poli5.put(0,(float)-5);
        poli3 = op.scadere(poli4,poli5);
        SortedMap<Integer, Float> reversedMap1 = new TreeMap<>(Collections.reverseOrder());
        reversedMap1.putAll(poli3);
        String af1 = op.afisarePolinom(reversedMap1);
        Assert.assertEquals("",af1);
    }

    @Test
    public void testareInmultire(){
        Map<Integer, Float> poli1 = new HashMap<>();
        Map<Integer, Float> poli2 = new HashMap<>();
        poli1.put(4,(float)-2);
        poli1.put(2,(float)1);
        poli1.put(1,(float)-2);
        poli1.put(0,(float)2);

        poli2.put(3,(float)2);
        poli2.put(2,(float)3);
        poli2.put(1,(float)-2);

        Map<Integer, Float> poli3 = new HashMap<>();
        poli3 = op.inmultire(poli1,poli2);
        SortedMap<Integer, Float> reversedMap = new TreeMap<>(Collections.reverseOrder());
        reversedMap.putAll(poli3);
        String af = op.afisarePolinom(reversedMap);
        Assert.assertEquals("-4.0x^7-6.0x^6+6.0x^5-x^4-4.0x^3+10.0x^2-4.0x",af);

        Map<Integer, Float> poli4 = new HashMap<>();
        Map<Integer, Float> poli5 = new HashMap<>();

        poli4.put(4,(float)2);
        poli4.put(2,(float)3);
        poli4.put(1,(float)-2);
        poli4.put(0,(float)-3);

        poli5.put(0,(float)0);
        poli3 = op.inmultire(poli4,poli5);
        SortedMap<Integer, Float> reversedMap1 = new TreeMap<>(Collections.reverseOrder());
        reversedMap1.putAll(poli3);
        af = op.afisarePolinom(reversedMap1);
        Assert.assertEquals("",af);
    }

    @Test
    public void testareDerivare(){
        Map<Integer, Float> poli1 = new HashMap<>();
        poli1.put(5,(float)-1);
        poli1.put(3,(float)4);
        poli1.put(1,(float)-2);
        poli1.put(0,18.5f);

        Map<Integer, Float> poli3 = new HashMap<>();
        poli3 = op.derivare(poli1);
        SortedMap<Integer, Float> reversedMap = new TreeMap<>(Collections.reverseOrder());
        reversedMap.putAll(poli3);
        String af = op.afisarePolinom(reversedMap);
        Assert.assertEquals("-5.0x^4+12.0x^2-2.0",af);

        Map<Integer, Float> poli2 = new HashMap<>();
        poli2.put(0,(float)-2);
        poli3 = op.derivare(poli2);
        SortedMap<Integer, Float> reversedMap1 = new TreeMap<>(Collections.reverseOrder());
        reversedMap1.putAll(poli3);
        String af1 = op.afisarePolinom(reversedMap1);
        Assert.assertEquals("",af1);
    }

    public void testareIntegrare(){
        Map<Integer, Float> poli1 = new HashMap<>();
        poli1.put(5,(float)-1);
        poli1.put(3,(float)4);
        poli1.put(1,(float)-2);
        poli1.put(0,18.5f);

        Map<Integer, Float> poli3 = new HashMap<>();
        poli3 = op.derivare(poli1);
        SortedMap<Integer, Float> reversedMap = new TreeMap<>(Collections.reverseOrder());
        reversedMap.putAll(poli3);
        String af = op.afisarePolinom(reversedMap);
        Assert.assertEquals("-0.16x^6+x^4-x^2+18.5x",af);

        Map<Integer, Float> poli2 = new HashMap<>();
        poli2.put(0,(float)-2);
        poli3 = op.derivare(poli2);
        SortedMap<Integer, Float> reversedMap1 = new TreeMap<>(Collections.reverseOrder());
        reversedMap1.putAll(poli3);
        String af1 = op.afisarePolinom(reversedMap1);
        Assert.assertEquals("-2.0x",af1);
    }
}