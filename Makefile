DIST_DIR ?= $(CURDIR)/dist
CHART_DIR ?= $(CURDIR)/neo
TMPDIR ?= /tmp
PROJECT ?= github.com/traefik/neo-helm-chart
LINT_USE_DOCKER ?= true
LINT_CMD ?= ct lint --config=lint/ct.yaml
################################## Functionnal targets

all: clean test build 

test: lint unit-test

# Execute Static Testing
lint: lint-requirements
	@echo "== Linting Chart..."
	@git remote add neo-agent https://github.com/traefik/neo-helm-chart >/dev/null 2>&1 || true
	@git fetch neo-agent master >/dev/null 2>&1 || true
ifeq ($(LINT_USE_DOCKER),true)
	@docker run --rm -t -v $(CURDIR):/charts -w /charts quay.io/helmpack/chart-testing:v3.3.1 $(LINT_CMD)
else
	cd $(CHART_DIR)/tests && $(LINT_CMD)
endif
	@echo "== Linting Finished"

# Execute Units Tests
unit-test: helm-unittest
	@echo "== Unit Testing Chart..."
	@helm unittest --color --update-snapshot ./neo
	@echo "== Unit Tests Finished..."

build: global-requirements $(DIST_DIR)
	@echo "== Building Chart..."
	@helm package $(CHART_DIR) --destination=$(DIST_DIR)
	@echo "== Building Finished"

# Cleanup leftovers and distribution dir
clean:
	@echo "== Cleaning..."
	@rm -rf $(DIST_DIR)
	@rm -rf $(HELM_REPO)
	@echo "== Cleaning Finished"

install: global-requirements $(DIST_DIR)
	@helm install neo $(CHART_DIR)

uninstall: global-requirements $(DIST_DIR)
	@helm uninstall neo $(CHART_DIR)
	clean

global-requirements:
	@echo "== Checking global requirements..."
ifeq ($(LINT_USE_DOCKER),true)
	@command -v docker >/dev/null || ( echo "ERROR: Docker binary not found. Exiting." && exit 1)
	@docker info >/dev/null || ( echo "ERROR: command "docker info" is in error. Exiting." && exit 1)
else
	@command -v helm >/dev/null || ( echo "ERROR: Helm binary not found. Exiting." && exit 1)
	@command -v git >/dev/null || ( echo "ERROR: git binary not found. Exiting." && exit 1)
	@echo "== Global requirements are met."
endif

lint-requirements: global-requirements
	@echo "== Checking requirements for linting..."
ifeq ($(LINT_USE_DOCKER),true)
	@command -v docker >/dev/null || ( echo "ERROR: Docker binary not found. Exiting." && exit 1)
	@docker info >/dev/null || ( echo "ERROR: command "docker info" is in error. Exiting." && exit 1)
else
	@command -v ct >/dev/null || ( echo "ERROR: ct binary not found. Exiting." && exit 1)
	@command -v yamale >/dev/null || ( echo "ERROR: yamale binary not found. Exiting." && exit 1)
	@command -v yamllint >/dev/null || ( echo "ERROR: yamllint binary not found. Exiting." && exit 1)
	@command -v kubectl >/dev/null || ( echo "ERROR: kubectl binary not found. Exiting." && exit 1)
endif
	@echo "== Requirements for linting are met."

################################## Technical targets
$(DIST_DIR):
	@mkdir -p $(DIST_DIR)

$(HELM_REPO):
	@mkdir -p $(HELM_REPO)

helm-unittest: global-requirements
	@echo "== Checking that plugin helm-unittest is available..."
	@helm plugin list 2>/dev/null | grep unittest >/dev/null || helm plugin install https://github.com/rancher/helm-unittest --debug
	@echo "== plugin helm-unittest is ready"

.PHONY: all global-requirements lint-requirements helm-unittest lint build deploy clean
