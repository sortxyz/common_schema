select
    l.function_contract_name as "nft_name",
    l.function_address as "nft_contract_address",
    l.params [3].value as "token_id",
    l.timestamp as "timestamp",
    s.amount_weth as "amount_eth",
    'WETH' as "currency",
    'OpenSea' as exchange,
    '0x7f268357a8c2552623316e2562d90e642bb538e5' as exchange_address,
    l.transaction_hash as "transaction_hash"
from
    ethereum.transaction_log l,
    (
        select
            l.transaction_hash,
            sum(CAST(params [3].value as float) / 1e18) as amount_weth
        from
            ethereum.transaction_log l
        where
            l.function_address = '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'
        group by
            l.transaction_hash
    ) as s
where
    l.transaction_hash = s.transaction_hash
    and l.transaction_to = '0x7f268357a8c2552623316e2562d90e642bb538e5'
    and l.name = 'Approval'
