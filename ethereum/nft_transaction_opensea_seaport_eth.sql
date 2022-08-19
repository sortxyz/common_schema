select
	l.function_contract_name as "nft_name",
    l.function_address as "nft_contract_address",
    l.params [3].value as "token_id",
    l.timestamp as "timestamp",
    num_nfts.num as nfts_in_txn,
    l.transaction_value_eth as "amount_eth",
    'ETH' as "currency",
    l.transaction_value_eth * l.price_eth_usd as "amount_usd",
    'OpenSea' as exchange,
    '0x00000000006c3852cbef3e08e8df289169ede581' as exchange_address,
    l.transaction_hash as "transaction_hash",
    l.transaction_to as "to",
    l.transaction_from as "from"
from
    ethereum_latest.transaction_log l HINT(access_path=index_filter),
    (
        select
            l.transaction_hash as transaction_hash,
      		Count(*) as num,
        from
            ethereum_latest.transaction_log l HINT(access_path=index_filter)
        where
            l.function_address = '0x00000000006c3852cbef3e08e8df289169ede581'
      	group by l.transaction_hash
    ) as num_nfts
where
    l.transaction_to = '0x00000000006c3852cbef3e08e8df289169ede581'
    and num_nfts.transaction_hash = l.transaction_hash
    and l.name = 'Transfer'
    and l.transaction_value_eth > 0
    
