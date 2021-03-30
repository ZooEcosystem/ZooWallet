// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract ZooWalletTokenProviderV0 is Ownable{
    
    mapping(address => uint256) indexcontainer;
    address[] listedTokens;
    mapping(address => Token) listedTokens1;
    
    struct Token {
        address _address;
        bool supported;
    }
    
    event tokenAdded(address token);
    event tokenRemoved(address token);
    
    function addSupportedTokenOnWallet(address _token1) public onlyOwner {
        for(uint256 i = 0; i< listedTokens.length;i++){
            if(listedTokens[i] == _token1){
                revert("Already listed");
            }
        }
        indexcontainer[_token1] = listedTokens.length;
        listedTokens1[_token1] = Token(_token1, true);
        listedTokens.push(_token1);
        emit tokenAdded(_token1);
    }
    
    function isSupportedOnWallet(address _token1) public view returns(bool){
        return listedTokens1[_token1].supported;
    } 
    
    function getAllListedTokens() public view returns(address[] memory){
        return listedTokens;
    }
    
    function removeTokenFromWallet(address _token1) public onlyOwner {
        require(listedTokens1[_token1].supported,"Already removed");
        delete listedTokens[indexcontainer[_token1]];
        listedTokens1[_token1].supported = false;
        emit tokenRemoved(_token1);
    }
    
}