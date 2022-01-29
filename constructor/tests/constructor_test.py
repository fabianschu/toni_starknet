import pytest
import asyncio
from starkware.starknet.testing.starknet import Starknet

PARAMETER = 23456
IMPORTANT_ADDRESS = 987623451345

# Enables modules.
@pytest.fixture(scope='module')
def event_loop():
    return asyncio.new_event_loop()

# Reusable to save testing time.
@pytest.fixture(scope='module')
async def contract_factory():
    starknet = await Starknet.empty()
    contract = await starknet.deploy("contracts/constructor.cairo",
        constructor_calldata=[PARAMETER, IMPORTANT_ADDRESS])
    return starknet, contract

@pytest.mark.asyncio
async def test_contract(contract_factory):
    starknet, contract = contract_factory

    # Read from contract
    response = await contract.read_special_values().call()
    assert response.result == (PARAMETER, IMPORTANT_ADDRESS)
