import pytest
import asyncio
from starkware.starknet.testing.starknet import Starknet

@pytest.fixture(scope='module')
def event_loop():
    return asyncio.new_event_loop()

@pytest.fixture(scope='module')
async def contract_factory():
    starknet = await Starknet.empty()
    analyst = await starknet.deploy(
        "contracts/struct_returns_UserAnalyst.cairo")
    database = await starknet.deploy(
        "contracts/struct_returns_UserDatabase.cairo")
    return starknet, analyst, database

@pytest.mark.asyncio
async def test_contract(contract_factory):
    starknet, analyst, database = contract_factory

    USER_ID = 43
    UP = 200
    DOWN = 32
    RANK = 17
    # Call a function.
    await database.register_user(
        user_id=USER_ID,
        upvotes=UP,
        downvotes=DOWN,
        rank=RANK).invoke()

    # Ask the analyst contract to fetch-and-score the user.
    # It will receive a struct containing user data.
    response = await analyst.score_user(
        database.contract_address, USER_ID).call()
    print(response.result)
    assert response.result.user_score == UP - DOWN

    response = await database.query_user(user_id=USER_ID).invoke()
    # First capture the result of the call. In the contract the
    # name of the returned value is 'user_stats'.
    user = response.result.user_stats
    # The type of 'user_stats' is a a struct defined in the contract.
    # The struct member values can be accessed by name as follows.
    assert user.upvotes == UP
    assert user.downvotes == DOWN
    assert user.rank == RANK
