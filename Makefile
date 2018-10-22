SCRIPTS_TO_TEST := build/* clone/* crowdin/* dogbin/* dropbox/* gerrit/* github/* html/* misc/* personal-setup/* setup/*

test:
		@shellcheck ${SCRIPTS_TO_TEST}

installhook:
		@cp -v shellcheck-hook .git/hooks/pre-commit
		@chmod +x .git/hooks/pre-commit

.PHONY: test
