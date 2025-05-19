import 'dotenv/config'
import { readFileSync, existsSync } from 'fs'

import { serve } from '@hono/node-server'
import { Hono } from 'hono'
import { ethers } from 'ethers'

import ERC1155_ABI from './abis/ERC1155'
import { initERC1155Balances } from './services/initERC1155Balances'
import { watchERC1155Balances } from './services/watchERC1155Balances'

const app = new Hono()
const provider = new ethers.JsonRpcProvider(process.env.RPC_URL)

const erc1155AddressesToIndex = ['0x5FbDB2315678afecb367f032d93F642f64180aa3']

const initERC1155Indexing = async (contractAddress: string) => {
  const contract = new ethers.Contract(contractAddress, ERC1155_ABI, provider)

  if (!existsSync(`data/${contractAddress}.json`))
    initERC1155Balances({ provider, contract, contractAddress })

  watchERC1155Balances({ contract, contractAddress })
}

erc1155AddressesToIndex.forEach((contractAddress) => {
  initERC1155Indexing(contractAddress)
})

app.get(
  'api/erc1155-balances/:contractAddress/:tokenId/:accountAddress',
  async (c) => {
    const { contractAddress, tokenId, accountAddress } = c.req.param()

    try {
      const idToAccountToBalance = JSON.parse(
        readFileSync(`data/${contractAddress}.json`, 'utf8')
      )

      const balance = idToAccountToBalance[tokenId][accountAddress]

      if (balance === undefined)
        return c.json({ error: 'Balance not found' }, 404)

      return c.json(balance)
    } catch {
      return c.json({ error: 'Token not indexed' }, 404)
    }
  }
)

serve(
  {
    fetch: app.fetch,
    port: 3000,
  },
  (info) => {
    console.log(`Server is running on http://localhost:${info.port}`)
  }
)
