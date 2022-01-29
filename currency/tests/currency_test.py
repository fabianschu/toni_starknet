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
    contract = await starknet.deploy("contracts/currency.cairo")
    return starknet, contract

@pytest.mark.asyncio
async def test_contract(contract_factory):
    starknet, contract = contract_factory

    # Register that user 7 owns 100 units currency,
    # which might represent mainnet ether (ETH).
    await contract.register_currency(7, 100).invoke()
    # Move 2 ether from user 7 to user 789.
    await contract.move_currency(7, 789, 2).invoke()

    # Check that the currency was received.
    response = await contract.check_wallet(789).call()
    assert response.result.balance == 2
