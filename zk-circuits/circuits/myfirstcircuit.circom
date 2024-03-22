pragma circom 2.0.0;

/*This circuit template checks that 16 is the multiplication of a and b.*/  

template MultiplierEqualTo16 () {  

   // Declaration of signals.  
   signal input a;  
   signal input b; 
   signal output c <-- 16; 
   signal output d;
//    signal output c;  

   // Constraints.  
   c === a * b;
   d <-- b;
}

 component main {public [a]} = MultiplierEqualTo16 ();
