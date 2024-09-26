-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil 

PRIVATE_KEY_ANVIL_0 := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--sepolia\""
	@echo ""
	@echo "  make fund [ARGS=...]\n    example: make deploy ARGS=\"--sepolia\""

all: clean remove install update build

clean  :; forge clean

remove :; rm -rf dependencies/ && rm soldeer.lock

install :; forge soldeer install

update:; forge soldeer update

build:; forge build

test :; forge test -vvv

testForkSepolia :; @forge test --fork-url $(RPC_URL_SEPOLIA) -vvv

coverage :; forge coverage -vvv

coverageLcov :; forge coverage --report lcov

coverageTxt :; forge coverage --report debug > coverage.txt

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS_ANVIL := --rpc-url http://localhost:8545 --private-key $(PRIVATE_KEY_ANVIL_0) --broadcast

NETWORK_ARGS_SEPOLIA := --rpc-url $(RPC_URL_SEPOLIA) --account $(ACCOUNT_DEV) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

ifeq ($(findstring --sepolia,$(ARGS)),--sepolia)
	NETWORK_ARGS := $(NETWORK_ARGS_SEPOLIA)
else
	NETWORK_ARGS := $(NETWORK_ARGS_ANVIL)
endif

checkEtherscanApi:
	@response_mainnet=$$(curl -s "https://api.etherscan.io/api?module=account&action=balance&address=$(PUBLIC_KEY_DEV)&tag=latest&apikey=$(ETHERSCAN_API_KEY)"); \
	echo "Mainnet:" $$response_mainnet; \
	response_sepolia=$$(curl -s "https://api-sepolia.etherscan.io/api?module=account&action=balance&address=$(PUBLIC_KEY_DEV)&tag=latest&apikey=$(ETHERSCAN_API_KEY)"); \
	echo "Sepolia:" $$response_sepolia;
