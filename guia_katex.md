# Getting Started with KaTeX

1. **Including KaTeX in Your Web Page:**
   To use KaTeX, you need to include its CSS and JavaScript files in your HTML document. You can link to these files directly from a CDN (Content Delivery Network) like this:

   ```html
   <!-- KaTeX CSS -->
   <link
     rel="stylesheet"
     href="https://cdn.jsdelivr.net/npm/katex@0.10.0/dist/katex.min.css"
   />

   <!-- KaTeX JavaScript -->
   <script src="https://cdn.jsdelivr.net/npm/katex@0.10.0/dist/katex.min.js"></script>
   ```

2. **Rendering Math Expressions:**
   You can render math expressions by using the `katex.render()` function. For example:

   ```html
   <div id="math-container"></div>
   <script>
     katex.render(
       "c = \\pm\\sqrt{a^2 + b^2}",
       document.getElementById("math-container")
     );
   </script>
   ```

   This will display the expression $ c = \pm\sqrt{a^2 + b^2} $ in the `div` element with the ID `math-container`.

## Basic Syntax

KaTeX uses a LaTeX-like syntax. Here are some basic examples:

1. **Superscripts and Subscripts:**

   - Superscript: `x^2` renders as $ x^2 $
   - Subscript: `x_2` renders as $ x_2 $

2. **Greek Letters:**

   - Lowercase: `\alpha`, `\beta`, `\gamma` render as $ \alpha, \beta, \gamma $
   - Uppercase: `\Alpha`, `\Beta`, `\Gamma` render as $ A, B, \Gamma $ (Note that not all Greek letters have distinct uppercase forms)

3. **Mathematical Operators:**

   - Plus: `+`
   - Minus: `-`
   - Times: `\times` renders as $ \times $
   - Divide: `\div` renders as $ \div $
   - Fractions: `\frac{a}{b}` renders as $ \frac{a}{b} $

4. **Roots and Radicals:**

   - Square root: `\sqrt{x}` renders as $ \sqrt{x} $
   - nth root: `\sqrt[n]{x}` renders as $ \sqrt[n]{x} $

5. **Brackets and Parentheses:**

   - Round brackets: `(x)`
   - Square brackets: `[x]`
   - Curly braces: `\{x\}` (braces need to be escaped with a backslash)

6. **Equations and Alignment:**
   - Align equations: Use `align` environment
     ```latex
     \begin{align}
     a &= b + c \\
     x &= y - z
     \end{align}
     ```

## Display Mode vs. Inline Mode

- **Display Mode:** For equations that should be centered and on their own line, wrap the expression in `$$ ... $$`.
- **Inline Mode:** For equations that should be part of a text line, wrap the expression in `$ ... $`.

## Final Tips

- **Escaping Characters:** Some characters like `{`, `}`, and `%` are special in LaTeX. To use them as regular characters, you need to escape them with a backslash (`\`).

- **Learning More:** KaTeX supports most, but not all, of the syntax and commands available in LaTeX. For more advanced features, refer to the [KaTeX documentation](https://katex.org/docs/supported.html).

This guide covers just the basics. LaTeX and KaTeX have many more features and capabilities, especially for more complex mathematical typesetting.
