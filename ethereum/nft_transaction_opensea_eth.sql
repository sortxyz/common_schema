select
    l.function_contract_name as "nft_name",
    l.function_address as "nft_contract_address",
    l.params [3].value as "token_id",
    l.timestamp as "timestamp",
    l.transaction_value_eth as "amount_eth",
    'ETH' as "currency",
    'OpenSea' as exchange,
    '0x7f268357a8c2552623316e2562d90e642bb538e5' as exchange_address,
    l.transaction_hash as "transaction_hash"
from
    ethereum.transaction_log l
where
    l.transaction_to = '0x7f268357a8c2552623316e2562d90e642bb538e5'
    and l.name = 'Approval'
