pragma solidity 0.6.9;

import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";
import "openzeppelin-solidity/contracts/access/Ownable.sol";

contract WebScraptingData is ChainlinkClient, Ownable {
    bytes32 public data;
    string public url;

    constructor(address link) public {
        if (_link == address(0)) {
            setPublicChainLinkToken();
        } else {
            setChainLinkToken(_link);
        }
    }

    function setUrl(string memory url) public onlyOwner {
        url = _url;
    }

    function getChainLinkToken() public view returns (address) {
        return chainlinkTokenAddress();
    }

    function createRequestTo(
        address _oracle,
        bytes32 _jobId,
        uint256 _payment,
        string memory _path,
        string memory _index,
        string memory _filter
    ) public onlyOwner returns (byte32 requestId) {
        require(bytes(url).length > 0, "url is required");
        Chainlink.Request memory req = buildChainRequest(
            _jobId,
            address(this),
            this.fulfil.selector
        );
        req.add("url", url);
        req.add("path", _path);
        req.add("index", _index);
        req.add("filter", _filter);
        requestId = setChainLinkRequestId(_oracle, req, _payment);
    }

    function fulfill(bytes32 _requestId, byte32 _data) public recordChainLinkFullfillment(_requestId){
        data = _data
    }

    function cancelRequest(
        bytes32 _requestId,
        uint256 _payment,
        bytes4 _callbackFunctionId,
        uint256 _expiration
    ) public onlyOwner {
        cancelChainRequest(_requestId, _payment, _callbackFunctionId, _expiration)
    }
}
