###############################################################################
# ENVIRONMENT CONFIGURATION
###############################################################################
MAKEFLAGS += --no-print-directory
SHELL=/bin/bash

###############################################################################
# INTERNAL GOALS
###############################################################################

.preflight_check:
	@find ./ -name "*.sh" -exec chmod +x {} +;
	@.ops/utils/preflight.sh

###############################################################################
# GLOBAL GOALS
###############################################################################

default:
	@echo "See README.md on how to use this Makefile"

###############################################################################
# SAFE DEFAULTS
###############################################################################

clean:
	@make clean_local

start:
	@make start_local

stop:
	@make stop_local

restart:
	@make restart_local

inspect:
	@make inspect_local

test:
	@make test_local

deploy:
	@make deploy_local

redeploy:
	@make redeploy_local

###############################################################################
# GOALS
###############################################################################

ENV=$(word 2,$(subst _, ,$(MAKECMDGOALS)))

clean_%: .preflight_check
	@.ops/deploy/$(ENV).sh clean

start_%: .preflight_check
	@.ops/deploy/$(ENV).sh start

stop_%: .preflight_check
	@.ops/deploy/$(ENV).sh stop

restart_%: .preflight_check
	@.ops/deploy/$(ENV).sh restart

inspect_%: .preflight_check
	@.ops/deploy/$(ENV).sh inspect

test_%: .preflight_check
	@.ops/deploy/$(ENV).sh test

redeploy_%: .preflight_check
	@.ops/deploy/$(ENV).sh rebuild

deploy_%: .preflight_check
	@make start_$(ENV)
	@make test_$(ENV)
