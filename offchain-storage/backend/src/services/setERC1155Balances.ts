import { readFileSync, writeFileSync } from 'fs'
import { ethers } from 'ethers'
import type { FormattedTransferEvent } from '../types/formattedERC1155TransferEvent'

const setERC1155Balances = ({
  contractAddress,
  formattedTransferEvents,
}: {
  contractAddress: string
  formattedTransferEvents: FormattedTransferEvent[]
}) => {
  let idToAccountToBalance: Record<number, Record<string, bigint>>

  try {
    idToAccountToBalance = JSON.parse(
      readFileSync(`data/${contractAddress}.json`, 'utf8'),
      (_, value) => {
        if (typeof value === 'string' && value.startsWith('bigint:')) {
          return BigInt(value.slice(7))
        }
        return value
      }
    )
  } catch {
    idToAccountToBalance = {}
  }

  for (const transferEvent of formattedTransferEvents) {
    const { ids, values } =
      'ids' in transferEvent
        ? { ids: transferEvent.ids, values: transferEvent.values }
        : { ids: [transferEvent.id], values: [transferEvent.value] }

    ids.forEach((id: number, i: number) => {
      idToAccountToBalance[id] ??= {}

      if (transferEvent.from !== ethers.ZeroAddress) {
        idToAccountToBalance[id][transferEvent.from] ??= 0n
        idToAccountToBalance[id][transferEvent.from] -= values[i]
      }

      if (transferEvent.to !== ethers.ZeroAddress) {
        idToAccountToBalance[id][transferEvent.to] ??= 0n
        idToAccountToBalance[id][transferEvent.to] += values[i]
      }
    })
  }

  writeFileSync(
    `data/${contractAddress}.json`,
    JSON.stringify(idToAccountToBalance, (_, value) =>
      typeof value === 'bigint' ? `bigint:${value.toString()}` : value
    )
  )
}

export { setERC1155Balances }
