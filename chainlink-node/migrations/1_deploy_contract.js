const WebScrapingData = artifacts.require("WebScrapingData");
const { LinkToken } = require("@chainlink/contracts/truffle/v0.5/LinkToken");
const { Oracle } = require("@chainlink/contracts/truffle/v0.5/Oracle");

module.exports = (deployer, network, [defaultAccount]) => {
  // if (network.startWith("ropsten")) {
    Oracle.setProvider(deployer.provider);
    deployer.deploy(WebScrapingData, '0x20fE562d797A42Dcb3399062AE9546cd06f63280')
    .then(async (instance) => {
      await instance.setUrl("http://abehiroshi.la.coocan.jp/movie/eiga.htm")
      Oracle.setProvider(deployer.provider)
      return deployer.deploy(WebScrapingData, '0x20fE562d797A42Dcb3399062AE9546cd06f63280', {from: defaultAccount})
    })
    .then(async (instance) => {
      await instance.setFullfillmentPermission("0xDC4D1E89A01557Fa6C81bfD2de56D73236708BA0", true, {defaultAccount})
    })
  // }
}