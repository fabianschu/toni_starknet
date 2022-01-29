%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin

# Define a storage variable.
@storage_var
func stored_felt() -> (res : felt):
end

# Returns the current balance.
@view
func get{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (res : felt):
    let (res) = stored_felt.read()
    return (res)
end

# Increases the balance by the given amount.
@external
func set{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(input : felt):
    stored_felt.write(input)
    return ()
end
