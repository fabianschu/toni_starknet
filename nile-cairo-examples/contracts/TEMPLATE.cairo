# Declare this file as a StarkNet contract and set the required
# builtins.
%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin

# Define a storage variable.
@storage_var
func balance() -> (res : felt):
end

# Increases the balance by the given amount.
@external
func EXTERNAL_FUNCTION_NAME{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        a : felt, b : felt):
    balance.write(a + b)
    return ()
end

# Returns the current balance.
@view
func VIEW_FUNCTION_NAME{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        res : felt):
    let (res) = balance.read()
    return (res)
end
