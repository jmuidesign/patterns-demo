import 'dotenv/config'
import { ethers } from 'ethers'

const fetchAndSubmitEthPriceToOracle = async () => {
  try {
    const ethPriceRequestUrl = `https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd&x_cg_demo_api_key=${process.env.COINGECKO_API_KEY}`
    const provider = new ethers.JsonRpcProvider(process.env.RPC_URL)
    const signer = new ethers.Wallet(
      process.env.PRIVATE_KEY as string,
      provider
    )

    const EthPriceOracle = [
      'function submitEthPrice(uint256 _ethPrice) external',
    ]

    const response = await fetch(ethPriceRequestUrl)
    const data = await response.json()

    const contract = new ethers.Contract(
      process.env.ORACLE_ADDRESS as string,
      EthPriceOracle,
      signer
    )

    // Multiply by 100 and round to respect 2 decimals in contract
    const tx = await contract.submitEthPrice(
      Math.round(data.ethereum.usd * 100)
    )
    const receipt = await tx.wait()

    console.log(receipt)
  } catch (error) {
    console.error(error)
  }
}

setInterval(fetchAndSubmitEthPriceToOracle, 1000 * 60 * 5)
