library;

mod simplevrf;

use simplevrf::{SimpleVrf, SIMPLEVRF_TESTNET, SIMPLEVRF_MAINNET};

pub enum VrfResult {
    Success: u64,
    Failure: (),
    Pending: (),
}

pub struct Vrf {
    contract_id: b256,
}

impl Vrf {
    pub fn testnet() -> Self {
        Self { contract_id: SIMPLEVRF_TESTNET }
    }
    pub fn mainnet() -> Self {
        Self { contract_id: SIMPLEVRF_MAINNET }
    }
    pub fn simplevrf(contract_id: b256) -> Self {
        Self { contract_id }
    }
    
    pub fn request_random(self, seed: b256) -> u64 {
        let simple_vrf = abi(SimpleVrf, self.contract_id);
        let fee = simple_vrf.get_fee(AssetId::base());
        let request_id = simple_vrf.request{
            asset_id: AssetId::base().bits(),
            coins: fee,
        }(seed);
        request_id
    }

    pub fn get_random(self, seed: b256) -> VrfResult {
        let simple_vrf = abi(SimpleVrf, self.contract_id);
        let request = simple_vrf.get_request(seed);
        if request.status == 0 {
            VrfResult::Pending
        } else if request.status == 1 {
            VrfResult::Success(request.num)
        } else {
            VrfResult::Failure
        }
    }
}
 
