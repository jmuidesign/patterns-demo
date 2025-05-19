import { ethers } from 'ethers'
import { fetchERC1155TransferEvents } from './fetchERC1155TransferEvents'
import { formatERC1155TransferEvents } from '../utils/formatERC1155TransferEvents'
import { setERC1155Balances } from './setERC1155Balances'

const initERC1155Balances = async ({
  provider,
  contract,
  contractAddress,
}: {
  provider: ethers.JsonRpcProvider
  contract: ethers.Contract
  contractAddress: string
}) => {
  const transferEvents = await fetchERC1155TransferEvents({
    provider,
    contract,
  })
  const formattedTransferEvents = formatERC1155TransferEvents(transferEvents)

  setERC1155Balances({
    contractAddress,
    formattedTransferEvents,
  })
}

export { initERC1155Balances }
