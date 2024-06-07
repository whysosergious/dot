# Testdrive and Random Scenarios Related to Scripting, Shell Servers, and Template Compiler Generators

## Overview

-   **Filename**: `testdrive_n_rnd.np`
-   **Scope**: Scripting, shell servers, and template compiler generators.

### Namespace Conventions

-   **`$nu`**

    -   Refers to Nushell's functions and structures.
    -   If similar logic exists in our context, adopt it to match Nushell's behavior as closely as possible.

-   **`$c`**
    -   Holds underlying/invisible special variables like `$in`, `$it`, or any context data.
    -   The "c" stands for context or caret, as it will manage both our data and control the process's position and direction.

```
there are also the the 'wondering' $in/$it . they reflect the values if their counterparts in the caret, but are the ones most often usen/seen in the ui as the caret is most of the time hidden by comment markup strings:

we'll define the <h></h> comment string element as 'hiddem'
/
/*<h>*/i will not render/*</h>*/
so we can do stuff like this:
*<h>*/let $in,$it/*</h>*/
/*<h>*/$c.in = $in =/*</h>*/"lets go!!" | print

```

## Objectives

1. **Data Flow Direction**
    - Instead of the traditional left `->` right piping direction, we'll use a `top ↓ down` approach. though the most important rule must be what makes most sense.
2. **Transpilation**
    - Experiment with transpiling `ts_script` to `nuscript`.
3. **Experimentation**
    - Try various methods and focus on transpiling TypeScript (`ts_script`) to Nushell script (`nuscript`).

## Example Workflow

### Fetch README from GitHub

**JavaScript Example:**

```javascript
const get_readme = (repo) => `https://raw.githubusercontent.com/${repo}/main/README.md`

get_readme('akinsho/toggleterm.nvim')

$nu.lines

$nu.each((ln) => {
	// Process each line
})
```

**Nushell Script:**

```sh
'akinsho/toggleterm.nvim'
$"http://akinsho/toggleterm.nvim/${$in}.md/main/readme.md" | http get
$in | lines | each { |ln| "--##($ln)" } | ast-grep --##$$$--## | each { |m| str replace "--##" " " | }
```

**Explanation:**

-   The above pipeline fetches the README file from a GitHub repository.
-   Each line that is not part of a code snippet is prepended with `--##` (a Lua comment marker).
-   Extra indentation is used for code snippets, making it easier to mark folds with tree-sitter.

### TypeScript Equivalent

**TypeScript Example:**

```typescript
'akinsho/toggleterm.nvim'

const url = `http://akinsho/toggleterm.nvim/${$in}.md/main/readme.md`

await fetch(url)

$nu.lines // Lines in TS would simply be str.split('\n'), but we can run in Nu too.

$nu.each(($ln) => `--##${$ln}\n`)

/* 
 - ast-grep in TS? Yes, we can always fallback to RegExp:
   new AstGrep('ast-grep --##$$$--##') 
*/

$nu.each(($m) => JSON.stringify($m).replace('--#', ' ').split('\n'))
```

**Discussion:**

-   **Transpilation Validity**: The script doesn't seem to be valid JS from start to finish. Are we meant to JIT each pipe step into `nuon` and back?
-   **Offside Buffer**: The invisible `$c` follows us around, which is why context/caret are both suitable names.

## Concept of `$c` Object

-   **Purpose**: $c runs each line as a function and stores the result in its `in` property.
-   **Benefits**:
    -   Able to store as much data as possible.
    -   Enables time travel and branching out indefinitely.

### Example

```javascript
$c.pipe(($in) => {
  // Nested pipe
  $c.in = $in;
});

$c /-/ ($in) => {
  'akinsho/toggleterm.nvim';
  $c.in = `${$in}`;
}

$c.ag_pttrn0 = new AstGrep('--##$$$--##');
$c.tmp0 = $c.ag_pttrn0.match($c.in);
$c.in = $c.tmp0;
$c.tmp0 = $c.in.join('\n');

// Proceed with processing matches
$c /-/ ($in) => {
  const match in $m /$matches/;

  // Continue further processing...
};
```

### Final Notes

-   **Structured Data**: By structuring data through ast-grep, we ensure all data types remain consistent.
-   **Processing**: Use of matches and data transformation through a series of steps ensures robust data handling and manipulation.
-   **Transpilation Challenges**: If full JS compatibility isn't possible, consider Just-In-Time (JIT) compilation for each pipeline step.
