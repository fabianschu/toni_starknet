import pytest
import asyncio
from starkware.starknet.testing.starknet import Starknet

# Enables modules.
@pytest.fixture(scope='module')
def event_loop():
    return asyncio.new_event_loop()

# Reusable to save testing time.
@pytest.fixture(scope='module')
async def contract_factory():
    starknet = await Starknet.empty()
    contract = await starknet.deploy("contracts/read_write_1.cairo")
    return starknet, contract

@pytest.mark.asyncio
async def test_contract(contract_factory):
    starknet, contract = contract_factory

    # Modify contract.
    await contract.set(10009).invoke()

    # Read from contract
    response = await contract.get().call()
    assert response.result.res == 10009
