BRANCH?=$(shell git branch --show-current)
VERSION?=$(shell echo $(BRANCH) | grep "^release" | sed 's;release\/\(.*\);\1;')

.PHONY: publish-dev
publish-dev:
	@echo "> Publishing new dev:alpha version..."
	circleci orb pack src/ | circleci orb publish - buildpacks/pack@dev:alpha

.PHONY: lint
lint:
	@echo "NOTE: If changes have been make to .circleci/config.yml "\
	"that depend on changes to the orb. It may require for the 'dev:alpha' "\
	"version to be updated.\n\nYou may run 'publish-dev' to do so (if permissions allow).\n"

	@echo "> Validating orb..."
	circleci orb pack src/ | circleci orb validate -

	@echo "> Validating CI config..."
	circleci config validate .circleci/config.yml

.PHONE: test
test:
	@echo "> Running tests..."
	cd ./src/tests/; find . -type f -name "*_test.sh" -exec {} \;

.PHONY: future-version
future-version:
	@echo "> Determining future version..."
	@$(if $(strip $(VERSION)),echo $(VERSION), echo "Failed to determine future version. May need to provide VERSION env var."; exit 1)

.PHONY: generate-changelog
generate-changelog: export TMP_DIR:=$(shell mktemp -d "/tmp/changelog.XXXXXXXXX")
generate-changelog: future-version
generate-changelog:
	@echo "> Configuring changelog generator..."
	@cp .github_changelog_generator $(TMP_DIR)

	@echo "> Generating changelog..."
	@docker run -it --rm -v "$(TMP_DIR)":/usr/local/src/your-app githubchangeloggenerator/github-changelog-generator --user buildpacks --project pack-orb --token $(GITHUB_TOKEN) --future-release $(VERSION) -o CHANGELOG.md
	
	@echo "> Cleaning it up..."
	@# removes footer
	@awk 'n>=3 { print a[n%3] } { a[n++%3]=$$0 }' "$(TMP_DIR)/CHANGELOG.md" > CHANGELOG.md
	
	@echo "> CHANGELOG:"
	@cat CHANGELOG.md
