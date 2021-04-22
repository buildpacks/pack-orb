
.PHONY: validate
lint:
	circleci orb pack src/ | circleci orb validate -
	circleci config validate .circleci/config.yml
