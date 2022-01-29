%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address

# B stores a number.
@storage_var
func number_in_B() -> (res : felt):
end

@storage_var
func contract_A_address() -> (res : felt):
end

# Run on deployment only. Must have constructor in name and decorator.
@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        address_of_contract_A : felt):
    # When this contract is deployed, passing it the known
    # address of A allows B to restrict write access.
    contract_A_address.write(address_of_contract_A)
    # There is no way to modify this value after deployment.
    return ()
end

# Function to get the stored number.
@view
func read_number{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        res : felt):
    # Anyone can call this read-only function.
    let (res) = number_in_B.read()
    return (res)
end

# Function to update the stored number. Only A is allowed.
@external
func increment{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(input : felt):
    # If using a local, 'alloc_locals' must go here.
    alloc_locals
    # See who is trying to modify B (this contract).
    let (local address) = get_caller_address()
    # Lookup the address of A saved during deployment.
    let (known_address) = contract_A_address.read()
    # Make sure it is A who is calling.
    assert address = known_address
    # Get the current stored number.
    let (current) = number_in_B.read()
    # Add and save.
    number_in_B.write(current + input)
    return ()
end
