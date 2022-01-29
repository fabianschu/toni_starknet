%lang starknet

# This function is from the common library.
# It can live here, reducing the clutter of an application.
from starkware.cairo.common.math import unsigned_div_rem

# This function is imported by 'custom_import.cairo'
# Equivalent to placing this function in that file.
func add_two(a : felt, b : felt) -> (sum : felt):
    let sum = a + b
    return (sum)
end

# This function performs the modulo operation.
func get_modulo{range_check_ptr}(a : felt, b : felt) -> (result : felt):
    let (dividend, remainder) = unsigned_div_rem(a, b)
    # The dividend is not used, and the following is equivalent:
    # let (_, remainder) = unsigned_div_rem(a, b)
    return (remainder)
end
