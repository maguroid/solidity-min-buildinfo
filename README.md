# solidity-min-buildinfo
Flatten contract, generating minimum build info json.

# Usage
## flatten contract
```bash
# usage: make flatten in=<input contract path> out=[output_dir(default: vendor)]"
make flatten in=lib/openzeppelin-contracts/contracts/access/AccessControl.sol out=vendor"
```
## generate build info json
before generate build info json, you need to flatten contract. and then, add out file names to the Makefile
```Makefile
ProxyAdmin.json: $@
ProxyAdmin.min.json: ProxyAdmin.json
```

then run make command
```bash
make ProxyAdmin.min.json
```
