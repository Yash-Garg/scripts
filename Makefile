SCRIPTS_TO_TEST := build-rom/build-lineage.sh clone/clone.sh crowdin/crowdin-setup.sh dogbin/dogbin.sh gerrit/gerritcfg.sh \
                   html/generate-index.sh misc/*.sh personal-setup/*.sh setup/install_android_sdk.bash setup/setup-build-env.sh

test:
		@shellcheck ${SCRIPTS_TO_TEST}

installhook:
		@cp -v shellcheck-hook .git/hooks/pre-commit
		@chmod +x .git/hooks/pre-commit

.PHONY: test
