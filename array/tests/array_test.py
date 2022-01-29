import pytest
import asyncio
from starkware.starknet.testing.starknet import Starknet

@pytest.fixture(scope='module')
def event_loop():
    return asyncio.new_event_loop()

@pytest.fixture(scope='module')
async def contract_factory():
    starknet = await Starknet.empty()
    contract = await starknet.deploy("contracts/array.cairo")
    return starknet, contract

@pytest.mark.asyncio
async def test_contract(contract_factory):
    starknet, contract = contract_factory

    # Modify contract
    await contract.read_array(9).invoke()

    # Read from contract 
    response = await contract.read_array(4).call()
    assert response.result.value == 18
