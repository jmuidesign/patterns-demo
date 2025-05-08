import 'dotenv/config'
import { serve } from '@hono/node-server'
import { Hono } from 'hono'
import { ethers } from 'ethers'

const app = new Hono()

const provider = new ethers.JsonRpcProvider(process.env.RPC_URL)

const ERC20 = [
  'event Transfer(address indexed from, address indexed to, uint256 value)',
  'event Approval(address indexed owner, address indexed spender, uint256 value)',
]

app.get('/api/transfers/:token', async (c) => {
  const token = c.req.param('token')
  const lastBlock = await provider.getBlockNumber()
  const {
    from = null,
    to = null,
    fromBlock = lastBlock - 100,
    toBlock = lastBlock,
  } = c.req.query()

  const contract = new ethers.Contract(token, ERC20, provider)

  try {
    const filter = contract.filters.Transfer(from, to)
    const events = await contract.queryFilter(filter, fromBlock, toBlock)

    return c.json(events)
  } catch (error) {
    return c.json({ error: error }, 500)
  }
})

app.get('/api/approvals/:token', async (c) => {
  const token = c.req.param('token')
  const lastBlock = await provider.getBlockNumber()
  const {
    owner = null,
    spender = null,
    fromBlock = lastBlock - 100,
    toBlock = lastBlock,
  } = c.req.query()

  const contract = new ethers.Contract(token, ERC20, provider)

  try {
    const filter = contract.filters.Approval(owner, spender)
    const events = await contract.queryFilter(filter, fromBlock, toBlock)

    return c.json(events)
  } catch (error) {
    return c.json({ error: error }, 500)
  }
})

serve(
  {
    fetch: app.fetch,
    port: 3000,
  },
  (info) => {
    console.log(`Server is running on http://localhost:${info.port}`)
  }
)
