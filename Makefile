.PHONY: lint test

test:
	@mkdir -p hub-agent/tests/__snapshot__
	docker run ${DOCKER_ARGS} --entrypoint /bin/sh --rm -v $(CURDIR):/charts -w /charts helmunittest/helm-unittest:3.11.1-0.3.0 /charts/hack/test.sh

lint:
	docker run ${DOCKER_ARGS} --env GIT_SAFE_DIR="true" --entrypoint /bin/sh --rm -v $(CURDIR):/charts -w /charts quay.io/helmpack/chart-testing:v3.7.1 /charts/hack/lint.sh
