pragma solidity ^0.5.0;

import "@chainlink/contracts/src/v0.5/ChainlinkClient.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract WebScraptingData is ChainlinkClient, Ownable {
    bytes32 public data;
    string public url;

    constructor(address _link) public {
        if (_link == address(0)) {
            setPublicChainlinkToken();
        } else {
            setChainlinkToken(_link);
        }
    }

    function setUrl(string memory _url) public onlyOwner {
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
    ) public onlyOwner returns (bytes32 requestId) {
        require(bytes(url).length > 0, "url is required");
        Chainlink.Request memory request = buildChainlinkRequest(
            _jobId,
            address(this),
            this.fulfill.selector
        );
        request.add("url", url);
        request.add("path", _path);
        request.add("index", _index);
        request.add("filter", _filter);
        requestId = sendChainlinkRequestTo(_oracle, request, _payment);
    }

    function fulfill(bytes32 _requestId, bytes32 _data)
        public
        recordChainlinkFulfillment(_requestId)
    {
        data = _data;
    }

    function cancelRequest(
        bytes32 _requestId,
        uint256 _payment,
        bytes4 _callbackFunctionId,
        uint256 _expiration
    ) public onlyOwner {
        cancelChainlinkRequest(
            _requestId,
            _payment,
            _callbackFunctionId,
            _expiration
        );
    }
}
