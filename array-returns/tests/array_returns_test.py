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
    contract = await starknet.deploy("contracts/array_returns.cairo")
    return starknet, contract

@pytest.mark.asyncio
async def test_contract(contract_factory):
    starknet, contract = contract_factory
    input_array = [2, 5, 7, 9, 3, 5, 6]
    # Read from contract
    response = await contract.duplicate_array(input_array).call()
    # Check the two arrays received are correct
    arr_1 = response.result.out_arr_1
    arr_2 = response.result.out_arr_2
    assert len(arr_1) == len(input_array)
    assert arr_1 == arr_2 == input_array
    # Check the values of the struct.
    calcs = response.result.array_calculation
    assert calcs.a == input_array[0] + input_array[1]
    assert calcs.b == calcs.a + input_array[2]
    assert calcs.c == calcs.b + input_array[3]
    assert calcs.d == calcs.c + input_array[4]

