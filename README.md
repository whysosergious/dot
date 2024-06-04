# dot

dot>to>not + not>to>dot scripts

### prerequisites

- git
- github cli (4auth)
- rustup [https://www.rust-lang.org/tools/install]
- terminal
  ## incl cfg (the more the better)
  - wezterm

---

# TODO's

#### yawn

- [ ] proper wezterm cfg
- [ ] backup script
- [ ] cleanup script
- [ ] uninstall script (incl cleanup pre-install) - .local, .cache, nvim-data, .cargo (anythiing with TMP), shared
- [ ] lockfile

#### last thing to structure

- [ ] separate cfgs to their own repos (term, shell, nvim ..) & git clone instead of cp

### nvim

- [ ] migrate from lazy -> pckr

- #### make scripts for separating nvim repo(s) into parts of

- [ ] lsp (lsp plugins, keymaps, options, cmd, autocmd ..) - least structured/most varying so...
- [ ] plugins (incl plugim keymaps, though preferably keep all plugin-mappings in one place and not scattered with each plugin)
  - ##### loose plugin grouping structure
  - [ ] repo name, deps, opts, build cmd
  - [ ] cmds (cmd, autocmd, augroup)
  - [ ] keymaps following which-key groups & syntax e.g
    ###### prefer mapping cmd: `vim.keymaps.set(map)`,
    <pre><code>
      struct = {
          map = {
          modes: {'n', 'v', 'x'},
          keys/motion: {'<leader>g'},
          action/func/cmd: function() ffs() end | '<cmd>echo "ffs"<CR>', << common exmpls
          opts: { noremap = true, desc = '!!!' }
          },
          condition = expr,
          tags = {},
      }
    </code></pre>
- [ ] core (keymaps, options, cmd, autocmd) - main usr customs should be as portable as possible (even autocmd/cmd would be nice if defined in ts with utility types (rpc), point below)

- #### super duper thing !!!

- [ ] transpile ts + own util types (e.g SH_ENV -> --env, SH_WRAPPED -> --wrapped, SH_FLAGS<Union> -> --flags) into nu-script custom commands and data-structs, as it is interpreted by rust (so ++ for safety & cross-device). see what bun does, if they interpret in zig and how. -- keep in mind bash.
