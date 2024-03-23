// SPDX-License-Identifier: MIT

//     ___
//      __|___|__
//       ('o_o')
//       _\~-~/_    ______.
//      //\__/\ \ ~(_]---'
//     / )O  O( .\/_)
//     \ \    / \_/
//     )/_|  |_\
//    // /(\/)\ \
//    /_/      \_\
//   (_||      ||_)
//     \| |__| |/
//      | |  | |
//      | |  | |
//      |_|  |_|
//      /_\  /_\

// .________         ___ .______  ._____.___ ._______      ._______ ._______           ___ ._______ ._______   ____   ____
// |    ___/.___    |   |:      \ :         |: ____  |     :_.  ___\: .___  \ .___    |   |: __   / : .___  \  \   \_/   /
// |___    \:   | /\|   ||   .   ||   \  /  ||    :  |     |  : |/\ | :   |  |:   | /\|   ||  |>  \ | :   |  |  \___ ___/
// |       /|   |/  :   ||   :   ||   |\/   ||   |___|     |    /  \|     :  ||   |/  :   ||  |>   \|     :  |    |   |
// |__:___/ |   /       ||___|   ||___| |   ||___|         |. _____/ \_. ___/ |   /       ||_______/ \_. ___/     |___|
//    :     |______/|___|    |___|      |___|               :/         :/     |______/|___|            :/
//                  :                                       :          :              :                :
//                  :                                                                 :

pragma solidity ^0.8.0;

interface IUniswapRouter {
    function WETH() external pure returns (address);
    function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);
}

contract SwampCowboy {
    address private owner;
    address private uniswapRouter;

    constructor(address _uniswapRouter) {
        owner = msg.sender;
        uniswapRouter = _uniswapRouter;
    }

    receive() external payable {}

    function buyToken(address _token, uint256 _amountOutMin) external payable {
        require(msg.sender == owner, "Only owner can call this function");
        require(msg.value > 0, "No ETH sent with the transaction");

        address[] memory path = new address[](2);
        path[0] = IUniswapRouter(uniswapRouter).WETH();
        path[1] = _token;

        uint deadline = block.timestamp + 300; // 5 minute deadline

        IUniswapRouter(uniswapRouter).swapExactETHForTokens{value: msg.value}(
            _amountOutMin,
            path,
            address(this),
            deadline
        );
    }

    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(owner).transfer(address(this).balance);
    }
}
