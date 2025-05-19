type FormattedTransferEventSingle = {
  from: string
  to: string
  id: number
  value: bigint
}

type FormattedTransferEventBatch = {
  from: string
  to: string
  ids: number[]
  values: bigint[]
}

type FormattedTransferEvent =
  | FormattedTransferEventSingle
  | FormattedTransferEventBatch

export {
  FormattedTransferEventSingle,
  FormattedTransferEventBatch,
  FormattedTransferEvent,
}
