-- Global Variables
local globalTest = 41

-- Functions
function main()
    local gondorium = 5
    local saladium = 10
    local msg = "b"

    -- add a bunch a's to the end of b
    while saladium >= gondorium do 
        msg = msg .. "a"
        gondorium = gondorium + 1;
    end

    msg = DestroyMsg(msg) -- function test

    print(msg)

    -- Print out the even elements of this list, or "table"
    local msg2 = "Even Elements: "
    local letters = {"poop", "fart", "gondorium", "hedium", "pooporium"}

    for idx = 1, 5, 1 do
        if idx % 2 ~= 0 then -- WHY IS != REPLACED WITH ~= ??????????????
            msg2 = msg2 .. "\n---" .. tostring(letters[idx])
        end
    end

    print(msg2 .. "\n" .. tostring(globalTest))
end

function DestroyMsg(inputMsg)
    inputMsg = inputMsg .. " ...grrrr"
    return inputMsg
end

-- Body

main()