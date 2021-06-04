DIST_DIR ?= $(CURDIR)/dist
CHART_DIR ?= $(CURDIR)/hub
TMPDIR ?= /tmp
HELM_REPO ?= $(CURDIR)/repo
LINT_USE_DOCKER ?= true
LINT_CMD ?= ct lint --config=lint/ct.yaml
PROJECT ?= traefik/hub-helm-chart
VERSION ?= $(shell cat hub/Chart.yaml | grep 'version: ' | awk '{ print $$2 }')

################################## Functionnal targets

all: clean test build 

test: lint unit-test

# Execute Static Testing
lint: lint-requirements
	@echo "== Linting Chart..."
	@git remote add hub-agent https://github.com/traefik/hub-helm-chart >/dev/null 2>&1 || true
	@git fetch hub-agent master >/dev/null 2>&1 || true
ifeq ($(LINT_USE_DOCKER),true)
	    @docker run --rm -t -v $(CURDIR):/charts -w /charts quay.io/helmpack/chart-testing:v3.3.1 $(LINT_CMD)
else
	    cd $(CHART_DIR)/tests && $(LINT_CMD)
endif
	    @echo "== Linting Finished"

# Execute Units Tests
unit-test: helm-unittest
	@echo "== Unit Testing Chart..."
	@helm unittest --color --update-snapshot ./hub
	@echo "== Unit Tests Finished..."

build: global-requirements $(DIST_DIR)
	@echo "== Building Chart..."
	@helm package $(CHART_DIR) --destination=$(DIST_DIR)
	@echo "== Building Finished"

# Prepare the Helm repository with the latest packaged charts
package: global-requirements $(DIST_DIR) $(HELM_REPO) build full-yaml
	@echo "== Deploying Chart..."
	@rm -rf $(CURDIR)/gh-pages.zip
	@curl -sSL -o gh-pages.zip  -H "Authorization: Bearer $(GITHUB_TOKEN)" https://api.github.com/repos/$(PROJECT)/zipball/gh-pages
	@unzip -oj $(CURDIR)/gh-pages.zip -d $(HELM_REPO)/
	@cp $(DIST_DIR)/*tgz $(HELM_REPO)/
	@cp $(CURDIR)/README.md $(HELM_REPO)/index.md
	@cp -r $(DIST_DIR)/yaml $(HELM_REPO)/
	@helm repo index --merge $(HELM_REPO)/index.yaml --url https://helm.traefik.io/hub/ $(HELM_REPO)
	@echo "== Deploying Finished"

# Cleanup leftovers and distribution dir
clean:
	@echo "== Cleaning..."
	@rm -rf $(DIST_DIR)
	@rm -rf $(HELM_REPO)
	@echo "== Cleaning Finished"

# Generate full yaml
full-yaml:
	@echo "== Generating full yaml for $(VERSION)"
	@helm template hub hub > $(DIST_DIR)/yaml/$(VERSION).yaml

install: global-requirements $(DIST_DIR)
	@helm install hub $(CHART_DIR)

uninstall: global-requirements $(DIST_DIR)
	@helm uninstall hub $(CHART_DIR)
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
	@mkdir -p $(DIST_DIR)/yaml

$(HELM_REPO):
	@mkdir -p $(HELM_REPO)

helm-unittest: global-requirements
	@echo "== Checking that plugin helm-unittest is available..."
	@helm plugin list 2>/dev/null | grep unittest >/dev/null || helm plugin install https://github.com/rancher/helm-unittest --debug
	@echo "== plugin helm-unittest is ready"

.PHONY: all global-requirements lint-requirements helm-unittest lint build package clean full-yaml
