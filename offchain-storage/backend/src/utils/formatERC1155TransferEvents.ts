import { ethers } from 'ethers'
import { FormattedTransferEvent } from '../types/formattedERC1155TransferEvent'

const formatERC1155TransferEvents = (events: ethers.EventLog[]) => {
  const formattedTransferEvents: FormattedTransferEvent[] = []

  for (const event of events) {
    if (event.fragment.name === 'TransferSingle') {
      formattedTransferEvents.push({
        from: event.args[1],
        to: event.args[2],
        id: Number(event.args[3]),
        value: ethers.toBigInt(event.args[4]),
      })
    } else if (event.fragment.name === 'TransferBatch') {
      formattedTransferEvents.push({
        from: event.args[1],
        to: event.args[2],
        ids: event.args[3].map((value: string) => Number(value)),
        values: event.args[4].map((value: string) => ethers.toBigInt(value)),
      })
    }
  }

  return formattedTransferEvents
}

export { formatERC1155TransferEvents }
