import pytest
import asyncio
from starkware.starknet.testing.starknet import Starknet

@pytest.fixture(scope='module')
def event_loop():
    return asyncio.new_event_loop()

@pytest.fixture(scope='module')
async def contract_factory():
    starknet = await Starknet.empty()
    # Note how the contracts/utils/math.cairo file is not needed here.
    contract = await starknet.deploy("contracts/array_argument.cairo")
    return starknet, contract

@pytest.mark.asyncio
async def test_contract(contract_factory):
    starknet, contract = contract_factory

    array = [10, 20, 30, 40]

    # write to contract
    await contract.save(array).invoke()
   
    expected_result = 2 * array[0] + 3 * array[-1]
    actual_result = await contract.get().call() 
    
    assert actual_result.result.stored == expected_result
