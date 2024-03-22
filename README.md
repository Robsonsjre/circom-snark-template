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
