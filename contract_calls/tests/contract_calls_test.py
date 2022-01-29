import pytest
import asyncio
from starkware.starknet.testing.starknet import Starknet

@pytest.fixture(scope='module')
def event_loop():
    return asyncio.new_event_loop()

@pytest.fixture(scope='module')
async def contract_factory():
    starknet = await Starknet.empty()
    # Each contract is deployed.
    contract_A = await starknet.deploy(
        "contracts/contract_calls_A.cairo")
    # The address of A will be passed to B during deployment of B.
    addr_a = contract_A.contract_address
    # Pass the address so that B can assert that only A
    # has write-access to B's storage.
    contract_B = await starknet.deploy(
        "contracts/contract_calls_B.cairo",
        constructor_calldata=[addr_a])

    # Contract A needs to know where B is deployed so it can call B.
    await contract_A.set_B_address(contract_B.contract_address).invoke()
    # Now the main permissions are set, pass
    return starknet, contract_A, contract_B

@pytest.mark.asyncio
async def test_contract(contract_factory):
    starknet, contract_A, contract_B = contract_factory

    inc_A = 10
    inc_B = 99

    # Call contract A. It will update both A and B.
    await contract_A.update_AB_system(
            inc_A,
            inc_B).invoke()

    # Read from contract A. It will read from both A and B.
    response = await contract_A.get_AB_system_status().call()
    assert response.result.system_sum == inc_A + inc_B
