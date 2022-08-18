select
    l.function_contract_name as "nft_name",
    l.function_address as "nft_contract_address",
    transfer_single.token_id as "token_id",
    l.timestamp as "timestamp",
    transfer_single.quantity as nfts_in_txn,
    l.transaction_value_eth as "amount_eth",
    'ETH' as "currency",
    l.transaction_value_eth * l.price_eth_usd as "amount_usd",
    'OpenSea' as exchange,
    '0x00000000006c3852cbef3e08e8df289169ede581' as exchange_address,
    l.transaction_hash as "transaction_hash"
from
    ethereum_latest.transaction_log l HINT(access_path=index_filter),
    (
        select
            l.transaction_hash,
      		l.function_address,
      		params[4].value as token_id,
            params[5].value as quantity
        from
            ethereum_latest.transaction_log l HINT(access_path=index_filter)
        where
            l.name = 'TransferSingle'
    ) as transfer_single
where
    l.transaction_hash = transfer_single.transaction_hash
    and l.transaction_to = '0x00000000006c3852cbef3e08e8df289169ede581'
    and l.name = 'TransferSingle'
    and l.function_contract_name <> 'ETH'
    and l.function_address = '0x76be3b62873462d2142405439777e971754e8e77'
order by timestamp desc
    
