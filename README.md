# `vrf` a Sway Library for verifiable random number generation

`vrf` is a simple library to access VRF implementations on Fuel, currently supporting:

- [SimpleVRF](https://github.com/darthbenro008/simplevrf)


To get started simply add it to your contract:

```
forc add vrf@0.1.1
```

and call it like so:

```sway
use vrf::{Vrf, VrfResult};

// ...

let seed = 0xd167b328cc944e4ff79f18e8f0431165; // this is a random seed you should generate yourself (most likely off chain)
let vrf = Vrf::testnet(); // or Vrf::mainnet() if you want to run on mainnet
vrf.request_random(seed);

// ... wait a while and store the seed somewhere ...

match vrf.get_random(seed) {
  VrfResult::Pending => {} // we are still waiting for the number to be generated
  VrfResult::Failure => {} // something went wrong
  VrfResult::Success(num) => log(num), // we did generate a random number, and it is num
}

```
