select
    *
from
    ethereum_latest.nft_transaction_opensea_seaport_weth
UNION
select
    *
from
    ethereum_latest."nft_transaction_opensea-1155_transfersingle"
UNION
select
    *
from
    ethereum_latest.nft_transaction_opensea_seaport_eth
where nft_name <> 'ETH'
