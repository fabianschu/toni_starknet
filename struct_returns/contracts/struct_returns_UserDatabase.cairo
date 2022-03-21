%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin

struct User:
    member upvotes : felt
    member downvotes : felt
    member rank : felt
end

@storage_var
func user_upvotes(user_id : felt) -> (count : felt):
end

@storage_var
func user_downvotes(user_id : felt) -> (count : felt):
end

@storage_var
func user_rank(user_id : felt) -> (count : felt):
end

@external
func query_user{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        user_id : felt
    ) -> (
        user_stats : User
    ):
    let (up) = user_upvotes.read(user_id)
    let (down) = user_downvotes.read(user_id)
    let (rank) = user_rank.read(user_id)
    let user_stats = User(
        upvotes=up,
        downvotes=down,
        rank=rank)
    return (user_stats)
end

@external
func register_user{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        user_id : felt,
        upvotes : felt,
        downvotes : felt,
        rank : felt
    ):
    user_upvotes.write(user_id, upvotes)
    user_downvotes.write(user_id, downvotes)
    user_rank.write(user_id, rank)
    return ()
end