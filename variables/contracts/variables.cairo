%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin

# Constant variables defined here are available to all functions.
# E.g., const my_const_2 = 10

# All persistent state appears in @storage_var
@storage_var
func persistent_state() -> (res : felt):
end

@external
func use_variables{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals  # needed for "local" variables.

    # Transient, revocable felt (reference).
    let my_reference = 50
    # Redefine reference.
    let my_reference = 51

    # Transient, revocable expression (temporary variable).
    tempvar my_tempvar = 2 * my_reference
    # Redefine tempvar.
    tempvar my_tempvar = 3 * my_reference

    # Transient, non-revocable felt (constant).
    const my_const = 60
    # Cannot redefine const (const my_const = 61)

    # Transient, non-revoacable expression (local). Requires alloc_locals.
    local my_local = 70
    # Cannot redefine local (local my_local = 71).

    # Persistent (@storage_var) storage, without a variable.
    persistent_state.write(80)
    # Redefine state.
    persistent_state.write(81)

    # A variable can be assigned to a function output:
    # let (my_var) = func().
    let (my_reference_2) = persistent_state.read()
    let (local my_local_2) = persistent_state.read()

    assert my_local_2 = 81

    return ()
end

@view
func read_state{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        value : felt):
    let (state) = persistent_state.read()
    return (state)
end
