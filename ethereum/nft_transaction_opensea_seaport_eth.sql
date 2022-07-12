select
	l.function_contract_name as "nft_name",
    l.function_address as "nft_contract_address",
    l.params [3].value as "token_id",
    l.timestamp as "timestamp",
    l.transaction_value_eth as "amount_eth",
    'ETH' as "currency",
    'OpenSea' as exchange,
    '0x00000000006c3852cbef3e08e8df289169ede581' as exchange_address,
    l.transaction_hash as "transaction_hash"
from
    ethereum.transaction_log l
where
    l.transaction_to = '0x00000000006c3852cbef3e08e8df289169ede581'
    and l.name = 'Approval'
