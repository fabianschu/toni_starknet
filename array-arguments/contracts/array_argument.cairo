%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin

@storage_var
func stored_number() -> (res : felt):
end

# Function to get the stored value.
@view
func get{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (
        stored : felt
    ):
    let (stored) = stored_number.read()
    return (stored)
end

# Function to accept an array.
@external
func save{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        input_array_len : felt,
        input_array : felt*
    ):
    let first = input_array[0]
    let last = input_array[input_array_len - 1]
    let solution = first * 2 + last * 3
    stored_number.write(solution)
    return ()
end