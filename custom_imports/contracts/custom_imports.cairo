%lang starknet
%builtins range_check
# contracts/custom_imports.cairo

# Import from teh cairo-lang package
from starkware.cairo.common.cairo_builtins import HashBuiltin
# Import a function from a custom local file.
from contracts.utils.math import add_two, get_modulo

# This is the main contract file that will be deployed.
@view
func get_calculations{range_check_ptr}(first : felt, second : felt) -> (sum : felt, modulo : felt):
    # Two custom operations.
    let (sum) = add_two(first, second)
    let (modulo) = get_modulo(first, second)
    return (sum, modulo)
end
