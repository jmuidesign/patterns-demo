import { ethers } from 'ethers'
import { setERC1155Balances } from './setERC1155Balances'
import type { FormattedTransferEvent } from '../types/formattedERC1155TransferEvent'

const watchERC1155Balances = ({
  contract,
  contractAddress,
}: {
  contract: ethers.Contract
  contractAddress: string
}) => {
  let prendingFormattedTransferEvents: FormattedTransferEvent[] = []

  contract.on('TransferSingle', (_, from, to, id, value) => {
    prendingFormattedTransferEvents.push({
      from,
      to,
      id: Number(id),
      value: BigInt(value),
    })
  })

  contract.on('TransferBatch', (_, from, to, ids, values) => {
    prendingFormattedTransferEvents.push({
      from,
      to,
      ids: ids.map((value: string) => Number(value)),
      values: values.map((value: string) => BigInt(value)),
    })
  })

  setInterval(() => {
    if (prendingFormattedTransferEvents.length > 0) {
      setERC1155Balances({
        contractAddress,
        formattedTransferEvents: prendingFormattedTransferEvents,
      })

      prendingFormattedTransferEvents = []
    }
  }, 5000)
}

export { watchERC1155Balances }
