select
    l.function_contract_name as "nft_name",
    l.function_address as "nft_contract_address",
    l.params [3].value as "token_id",
    l.timestamp as "timestamp",
    num_nfts.num as nfts_in_txn,
    s.amount_weth as "amount_eth",
    'WETH' as "currency",
    s.amount_weth * l.price_eth_usd as "amount_usd",
    'OpenSea' as exchange,
    '0x00000000006c3852cbef3e08e8df289169ede581' as exchange_address,
    l.transaction_hash as "transaction_hash"
from
    ethereum_latest.transaction_log l HINT(access_path=index_filter),
    (
        select
            l.transaction_hash,
      		LOWER(params[1].value) as funds_source,
            sum(CAST(params [3].value as float) / 1e18) as amount_weth
        from
            ethereum_latest.transaction_log l HINT(access_path=index_filter)
        where
            l.function_address = '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'
        group by
            l.transaction_hash,
      		params[1].value
    ) as s,
    (
        select
            l.transaction_hash as transaction_hash,
      		LOWER(params[2].value) as address
        from
            ethereum_latest.transaction_log l HINT(access_path=index_filter)
        where
            l.function_address = '0x00000000006c3852cbef3e08e8df289169ede581'
    ) as payer,
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
    l.transaction_hash = s.transaction_hash
    and num_nfts.transaction_hash = l.transaction_hash
    and payer.address = s.funds_source
    and payer.transaction_hash = l.transaction_hash
    and l.transaction_to = '0x00000000006c3852cbef3e08e8df289169ede581'
    and l.name = 'Transfer'
    and l.function_contract_name <> 'ETH'
