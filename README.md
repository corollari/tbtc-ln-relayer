# tbtc-ln-relayer
> Mint tBTC without ever having to own ETH!

**This is EXTREMELY alpha stage and only meant as a prototype, please don't use in production**

## What problem does this solve?
If you are a bitcoiner that wants to move some of your holdings to tBTC you'll need some ETH in order to pay for the gas fees associated with the minting process. This is annoying as it either requires going through a centralized exchange or trying to use one of the currently-underdeveloped atomic swaps market. What's more, some users might prefer to not have to own any ETH.

This project scratches that itch by allowing these users to pay for the gas fees through a lightning payment.

## How it works
Initially the relayer calculates the price in ether of the whole process and creates a lightning invoice for that amount.
After the user pays that, a new GSN-enabled contract is deployed that acts as a proxy for the user and accepts GSN meta-transactions, and this contract is loaded with enough ETH to pay for all the fees involved in the process. Afterward the user just relays their transactions through the GSN into that contract, which then calls the tBTC contracts acting as a proxy for the user.

As you can see, currently this project requires trust on the relayer, as it could just run away with the sats without paying for the promised gas. It would also be possible to make this fully trustless but given that the amounts at stake are relaively low and adding complexity would heavily increase the cost of using the relayer (more transactions would need to be sent) I've decided not to go that route.