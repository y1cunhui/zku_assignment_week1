pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib-matrix/circuits/matMul.circom"; 
// hint: you can use more than one templates in circomlib-matrix to help you

template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    signal output out; // 1 for correct solution, 0 for incorrect solution

    // [bonus] insert your code here
    signal temp[n];
    signal temp2[n];
    component eqs[n+1];
    component mul = matMul(n,n,1);
    for (var i=0;i<n;i++) {
        for (var j=0;j<n;j++) {
            mul.a[i][j] <== A[i][j];
        } 
    }
    for (var i=0;i<n;i++) {
        mul.b[i][0] <== x[i];
    }

    for (var i=0;i<n;i++) {
        temp[i] <== mul.out[i][0];
    }
    

    eqs[0] = IsEqual();
    eqs[0].in[0] <== temp[0];
    eqs[0].in[1] <== b[0];
    temp2[0] <== eqs[0].out;

    for (var i = 1; i < n; i ++) {
        eqs[i] = IsEqual();
        eqs[i].in[0] <== temp[i];
        eqs[i].in[1] <== b[i];
        temp2[i] <== eqs[i].out + temp2[i-1];
    }

    eqs[n] = IsEqual();
    eqs[n].in[0] <== temp2[n-1];
    eqs[n].in[1] <== n;
    out <== eqs[0].out;
}

component main {public [A, b]} = SystemOfEquations(3);