%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin

@storage_var
func stored_parameter() -> (res : felt):
end

@storage_var
func important_contract_address() -> (res : felt):
end

# Run on deployment only. Must have constructor in name and decorator.
@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        special_number : felt, important_address : felt):
    stored_parameter.write(special_number)
    important_contract_address.write(important_address)
    return ()
end

# Function to get the numbers stored at deployment.
@view
func read_special_values{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        number : felt, address : felt):
    let (number) = stored_parameter.read()
    let (address) = important_contract_address.read()
    return (number, address)
end
