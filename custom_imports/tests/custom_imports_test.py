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
    contract = await starknet.deploy("contracts/custom_imports.cairo")
    return starknet, contract

@pytest.mark.asyncio
async def test_contract(contract_factory):
    starknet, contract = contract_factory

    num_1 = 10
    num_2 = 3
    # Read from contract
    response = await contract.get_calculations(10, 3).call()
    # Check the results, addressing each returned value
    # by its name defined in the contract return statement.
    assert response.result.sum == num_1 + num_2
    assert response.result.modulo == num_1 % num_2

