# custom ERC-20 for test net use
This ERC-20 has additional interfaces to enable user to send tokens to many addresses at once or claim the tokens.
Please note that the decimals is set as 6 since the decimals of USDC is 6, usually the decimals is 18, feel free to modify the deimals by consturctor.

## Custom functions
### SendToMultiUsers
this function allow the token owner to send the given amount to multiple addresses at once.
```solidity
function sendToMutiUsers(address[] memory input, uint256 amount) external {
    if (_balances[msg.sender] < input.length * amount) {
        revert InsufficientBalance(_balances[msg.sender], input.length * amount);
    }
    
    for (uint256 i = 0; i < input.length; i++) {
        _transfer(msg.sender, input[i], amount);
    }
}
```
### Claim
If QA or internal member needs to use test ERC-20 to test Defi on test net, they are able to call this function to get the test tokens.
```solidity
function claim() external {
    _transfer(address(this), msg.sender, 500_000 * 1e6);
}
```
## Unit Test
1. Clone the repo and navigate to the project folder
```sh
$ git clone git@github.com:chentihe/erc20-example.git
$ cd erc20-example
```
2. Install the libs
```sh
$ forge install
```
3. Run unit tests
```sh
$ forge test -v
```
You will see the output like below
```sh
Running 7 tests for test/ERC20.t.sol:ERC20Test
[PASS] testApprove() (gas: 37713)
[PASS] testBalanceOf() (gas: 9952)
[PASS] testClaim() (gas: 22217)
[PASS] testSendToMultiUser() (gas: 66307)
[PASS] testTransfer() (gas: 45428)
[PASS] testTransferFrom() (gas: 74454)
[PASS] testWithdraw() (gas: 24623)
Test result: ok. 7 passed; 0 failed; finished in 2.23ms
```