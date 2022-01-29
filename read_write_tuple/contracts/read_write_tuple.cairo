%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin

@storage_var
func stored_felt() -> (res : (felt, felt, felt)):
end

@view
func get{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        res_1 : felt, res_2 : felt, res_3 : felt):
    let (stored_tuple) = stored_felt.read()
    let res_1 = stored_tuple[0]
    let res_2 = stored_tuple[1]
    let res_3 = stored_tuple[2]
    return (res_1=res_1, res_2=res_2, res_3=res_3)
end

# Function to update the stored tuple of field elements.
@external
func save{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        input_1 : felt, input_2 : felt, input_3 : felt):
    # The tuple is declared with round brackets.
    stored_felt.write((input_1, input_2, input_3))
    return ()
end
