%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin

# A stores a number.
@storage_var
func number_in_A() -> (res : felt):
end

# Address of contract B so that A can call B.
@storage_var
func contract_B_address() -> (res : felt):
end

# This makes A (this contract) aware of B.
# Basically copy the functions needed and strip out
# implicit arguments (inside the curly braces).
@contract_interface
namespace contract_B:
    func increment(number : felt):
    end

    func read_number() -> (number : felt):
    end
end

# Function to get the stored number.
@view
func get_AB_system_status{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        system_sum : felt):
    # Sums A and B stored numbers.
    let (a_num) = number_in_A.read()
    # Fetch address of B from storage.
    let (b_addr) = contract_B_address.read()
    let (b_num) = contract_B.read_number(b_addr)
    let res = a_num + b_num
    return (res)
end

# Function to update the stored a number (field element).
@external
func update_AB_system{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        increment_for_A : felt, increment_for_B : felt):
    # Read A
    let (a_current) = number_in_A.read()
    # Add and save.
    number_in_A.write(a_current + increment_for_A)
    # Read B by calling it via the interface.
    let (b_addr) = contract_B_address.read()
    # This is the format for using interfaces.
    # contract_name.function(address, arg_1, arg_2, ...)
    contract_B.increment(b_addr, increment_for_B)
    return ()
end

# Save the address of contract B
@external
func set_B_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        address : felt):
    # Save to storage in A (this contract).
    # Now A knows where to find B.
    # It is already aware of the nature of B, thanks to the
    # interface function.
    contract_B_address.write(address)
    return ()
end
