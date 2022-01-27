import pytest
import asyncio
from starkware.starknet.testing.starknet import Starknet
from starkware.starknet.testing.contract import StarknetContract

# Enables modules.
@pytest.fixture(scope='module')
def event_loop():
    return asyncio.new_event_loop()

# Reusable to save testing time.
@pytest.fixture(scope='module')
async def contract_factory():
    starknet = await Starknet.empty()
    contract = await starknet.deploy("contracts/TEMPLATE.cairo")
    return starknet, contract

@pytest.mark.asyncio
async def test_main_logic(contract_factory):
    starknet, contract = contract_factory

    # Modify a contract.
    await contract.EXTERNAL_FUNCTION_NAME(INPUT_1, INPUT2).invoke()

    # Read from a contract
    VAL = await contract.VIEW_FUNCTION_NAME().call()
    assert VAL == EXPECTED_RESULT
    print('Value is as expected')

# A second test function that uses the same deployments.
@pytest.mark.asyncio
async def test_two(contract_factory):
    starknet, contract = contract_factory

    VAL = await contract.VIEW_FUNCTION_NAME().call()
    assert VAL == EXPECTED_RESULT
