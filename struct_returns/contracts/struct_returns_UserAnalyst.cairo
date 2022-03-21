%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin

struct User:
    member upvotes : felt
    member downvotes : felt
    member rank : felt
end

@contract_interface
namespace struct_returns_UserDatabase:
    func query_user(number: felt) -> (user: User):
    end
end


@external
func score_user{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        database_address : felt,
        user_id: felt
    ) -> (
        user_score: felt
    ):
    let (user) = struct_returns_UserDatabase.query_user(database_address, user_id)
    return (user.upvotes - user.downvotes)
end