# My git template
Basic git template directory using [git hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) to facilitate updating ctags when a repository changes
- Adds post-checkout, post commit, post-merge, and post-rewrite hooks
- Also has a template for `info/exclude`, which contains only excludes for files created by this template

To make this the default templte for the current user: `git config init.templateDir /path/to/repository/git-template/`
- Then, upon initializing or cloning a repository, the contents of info and hooks directories should be replaced with the contents of the git-template/ in this repository
- [Documentation on git template directories](https://git-scm.com/docs/git-init#_template_directory)

These hooks were copied from an article titled [Getting started with Ctags with Vim and Git by Aaron Young](https://geekdude.github.io/tech/ctags/), but are likely to change as I improve my workflow.

