EthSamba 2024 - Zero Knowledge na prática - Blind Auction

## Main Links
- Slides presentation: https://docs.google.com/presentation/d/1T8mZCjvQsK28-rOj-3Em7v5hFwivJK268ECkOFOnbbA/edit?usp=sharing
- Repo Github: https://github.com/Robsonsjre/circom-snark-template
- Oficial Docs: https://docs.circom.io/getting-started/

## Secondary Links
- Circuits library: https://github.com/iden3/circomlib
- Blind auction MIT Paper: https://courses.csail.mit.edu/6.857/2019/project/18-doNascimento-Kumari-Ganesan.pdf
- Example Repo combining with frontend: https://github.com/heivenn/zk-blind-auction

# 1) Initial Setup

## 1.1) Rust Install
`
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
`

Obs: Sometimes in Codespaces, Rust default installation will have an error. If it is your case, 
you select the option 2 (Customization) and select "N" when it asks about the PATH.

Obs2: Sometimes the alias 'cargo' doesnt work directly in Codespaces. You could try '/home/codespace/.cargo/bin/cargo' and create an alias for it with:
> alias cargo='/home/codespace/.cargo/bin/cargo'

## 1.2) Circom Install

a) `git clone https://github.com/iden3/circom.git`

b) `cargo build --release`

c) `cargo install --path circom`

You can try if it went well with: circom --help or /home/codespace/.cargo/bin/circom --help

Obs: Again, you can create an alias using: 
> alias circom='/home/codespace/.cargo/bin/circom'

Obs: Does not foget quotes in the end of the Alias path

## 1.3) Install snarkjs

> npm install -g snarkjs


# 2) Our first Circuit

- 2.1) Create a folder called 'circuits' and a file inside there called 'myfirstcircuit.circom'

````
pragma circom 2.0.0;

/*This circuit template checks that 16 is the multiplication of a and b.*/  

template MultiplierEqualTo16 () {  

   // Declaration of signals.  
   signal input a;  
   signal input b; 
   signal output c <-- 16; 

   // Constraints.  
   c === a * b;  
}

 component main = MultiplierEqualTo16 ();
````

### 2.2) Compile the circuit

The command to run the circuit is: 
`circom ./circuits/myfirstcircuit.circom  --r1cs --wasm --sym --c`

where: 
- --r1cs: it generates the file multiplier2.r1cs that contains the R1CS constraint system of the circuit in binary format.
- --wasm: it generates the directory multiplier2_js that contains the Wasm code (multiplier2.wasm) and other files needed to generate the witness.
- --sym : it generates the file multiplier2.sym , a symbols file required for debugging or for printing the constraint system in an annotated mode.
- --c : it generates the directory multiplier2_cpp that contains several files (multiplier2.cpp, multiplier2.dat, and other common files for every compiled program like main.cpp, MakeFile, etc) needed to compile the C code to generate the witness

### 2.3) Trusted Setup

We are going to use the Groth16 zk-SNARK protocol. To use this protocol, you will need to generate a trusted setup. Groth16 requires a per circuit trusted setup. In more detail, the trusted setup consists of 2 parts:

- The powers of tau, which is independent of the circuit.
- The phase 2, which depends on the circuit.
  
#### 2.3.1) First Phase: we start a new "powers of tau" ceremony:

- snarkjs powersoftau new bn128 12 pot12_0000.ptau -v

Then, we contribute to the ceremony:

- snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v

#### 2.3.2) Second Phase

The phase 2 is circuit-specific. Execute the following command to start the generation of this phase:

- snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
- snarkjs groth16 setup myfirstcircuit.r1cs pot12_final.ptau myfirstcircuit_0000.zkey

Contribute to the phase 2 of the ceremony:

- snarkjs zkey contribute myfirstcircuit_0000.zkey myfirstcircuit_0001.zkey --name="1st Contributor Name" -v

Export the verification key:

- snarkjs zkey export verificationkey myfirstcircuit_0001.zkey verification_key.json


### 2.4) Generate Witness (Preparation) Create the input.json file with a testing scenario for the inputs 

Example for this one: `{"a": "1", "b": "16"}`

### 2.5) Generate witness

--> It will use the .wasm from the step 2.1) and the the JSON file from the step 2.4)

- node ./myfirstcircuit_js/generate_witness.js ./myfirstcircuit_js/myfirstcircuit.wasm ./input.json witness.wtns

### 2.6) Generating a proof

It requires the Verification Key (last output from 2.3.2) and the witness file.

- snarkjs groth16 prove ./myfirstcircuit_0001.zkey witness.wtns proof.json public.json
