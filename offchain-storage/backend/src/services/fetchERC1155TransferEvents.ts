import { ethers } from 'ethers'

const providerRateLimit = Number(process.env.RPC_RATE_LIMIT) || 0

const fetchERC1155TransferEvents = async ({
  provider,
  contract,
}: {
  provider: ethers.JsonRpcProvider
  contract: ethers.Contract
}) => {
  const lastBlock = await provider.getBlockNumber()
  const batchNumber = Math.ceil(lastBlock / providerRateLimit)

  const transferEvents = []

  for (let i = 0; i < batchNumber; i++) {
    const fromBlock = i * providerRateLimit
    const toBlock = Math.min(fromBlock + providerRateLimit - 1, lastBlock)

    const queryFilterPromises = Promise.all([
      contract.queryFilter('TransferSingle', fromBlock, toBlock),
      contract.queryFilter('TransferBatch', fromBlock, toBlock),
    ])
    const allTransferEvents = await queryFilterPromises

    transferEvents.push(...allTransferEvents[0], ...allTransferEvents[1])
  }

  return transferEvents as ethers.EventLog[]
}

export { fetchERC1155TransferEvents }
