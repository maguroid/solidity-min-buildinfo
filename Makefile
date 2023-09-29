# TARGET := $(basename $(notdir $(wildcard vendor/*.sol)))
SRC := $(wildcard vendor/*.sol)
TARGET_JSON := $(patsubst %.sol, %.json, $(notdir $(SRC)))
TARGET_MIN_JSON := $(patsubst %.sol, %.min.json, $(notdir $(SRC)))
OUT_DIR_ROOT := build_info

all: $(TARGET_MIN_JSON)

$(TARGET_JSON):
	@echo "Compiling $@"

	$(eval sol := $(patsubst %.json,%.sol,$@))
	$(eval outdir := build_info/$(sol))
	mkdir -p $(outdir)

	forge build --force -C vendor/$(sol) --build-info --build-info-path $(outdir)

$(TARGET_MIN_JSON):
	@echo "Minifying json to $@"
	$(eval jsonfile := $(shell ls $(outdir)))
	@echo jsonfile: $(jsonfile)
	jq -c . $(outdir)/$(jsonfile) > $(OUT_DIR_ROOT)/$@
	rm -rf $(outdir)

ProxyAdmin.json: $@
ProxyAdmin.min.json: ProxyAdmin.json

TransparentUpgradeableProxy.json: $@
TransparentUpgradeableProxy.min.json: TransparentUpgradeableProxy.json

flatten:
define usage
	@echo "Description: Flatten solidity contracts to a single file"
	@echo "Usage: make flatten in=<input contract path> out=[output_dir(default: vendor)]"
	@echo "Example: make flatten in=lib/openzeppelin-contracts/contracts/access/AccessControl.sol out=vendor"
endef

ifndef in
	@echo error: input contract is undefined
	$(usage)
	@exit 1
endif
	$(eval out := vendor)
	@echo "Flattening $(in) to $(out)"
	mkdir -p $(out)
	forge flatten $(in) > $(out)/$(notdir $(in))
