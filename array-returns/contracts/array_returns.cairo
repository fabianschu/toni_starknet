%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.math import assert_in_range

struct ArrayCalculation:
    member a : felt
    member b : felt
    member c : felt
    member d : felt
end

# Function to accept an array.
@view
func duplicate_array{
        range_check_ptr
    }(
        input_array_len : felt,
        input_array : felt*
    ) -> (
        out_arr_1_len : felt,
        out_arr_1 : felt*,
        array_calculation : ArrayCalculation,
        out_arr_2_len : felt,
        out_arr_2 : felt*
    ):
    assert_in_range(input_array_len, 5, 11)

    let one = input_array[0] + input_array[1]
    let two = one + input_array[2]
    let three = two + input_array[3]
    let four = three + input_array[4]

    # define sstruct
    let array_calculation = ArrayCalculation(
        a=one, b=two, c=three, d=four)

    return (
        input_array_len,
        input_array,
        array_calculation,
        input_array_len,
        input_array)
end