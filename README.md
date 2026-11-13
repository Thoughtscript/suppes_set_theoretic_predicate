# suppes_set_theoretic_predicate

> *No classified nor controlled information is contained herein.*

An earlier incarnation of this idea was pitched to [DARPA Score](https://www.darpa.mil/research/programs/systematizing-confidence-in-open-research-and-evidence), advanced through the initial rounds (before bowing out to [Center for Open Science](https://www.cos.io/) - the very organization that first drew widespread attention to the **Replication Crisis** itself), and an idea developed with slightly greater detail [here](https://www.thoughtscript.io/blog/000000000128). See also:
* https://www.wired.com/story/darpa-bs-detector-science/
* https://www.ipr.northwestern.edu/news/2024/an-existential-crisis-for-science.html

> Artificial Intelligence helped generate some of the LaTeX and Lean content.

## Suppes Set Theoretic Predicate

> Find a copy of the seminal book [here](https://philpapers.org/archive/SUPRAI.pdf). And, [here](https://philpapers.org/archive/SUPRAI.pdf) for academic metadata.

1. Complex textual corpuses (written predominantly in Natural Language) can be succinctly expressed into compact formal objects (typically numbering only a few sentences).
1. Supportive of **Automated Theorem Proving** techniques. Allows one to formally verify logical consistency, coherence with other scientific theories, and extend results.
1. Broadly part of typical activities in the Philosophy of Science, Analytic Philosophy's "Linguistic Turn" (which places supreme importance on disambiguated expressions defined with exacting mathematical rigor).
1. Most Social Sciences can be formally represented in compact multi-sentence Formal Theories.

The main utility of such a technique/approach is the ability to succinctly represent complex technical documents, theories, and findings for immediate verification. For this reason, **Set Theoretic Predicates** are useful:
1. not only for establishing the veracity of an experiment, experimental result, paper, or scientific finding
1. but also for the data and representation compression benefits. Vast textual corpuses can be succinctly expressed as tidy formal artifacts (dispensing with the expository fluff where needed).

> Prior obstacles have been mitigated by advancements in **Document Understanding**, **Machine Learning**, and **Unsupervised Learning**.

### Example

[Suppes](https://philpapers.org/archive/SUPRAI.pdf), [Suppes, Sugar, and McKinsey](https://suppescorpus.stanford.edu/sites/g/files/sbiybj32751/files/media/file/axiomatic_foundations_of_classical_particle_mechanics_2.pdf), [da Costa and Krause](https://philsci-archive.pitt.edu/id/eprint/17445/1/CostaKrause%282020%29-Edelcio.pdf) discuss Suppes' formulations of **Classical Mechanics**.

*An example of this approach using the **Data ETL** (described below) is provided a "lab" (of sorts) within the contents of this repo.*

* Lean 4 model: [`_lean/ClassicalMechanics.lean`](_lean/ClassicalMechanics.lean)
* LaTeX source: [`_latex/classical_mechanics.tex`](_latex/classical_mechanics.tex)
* BibTeX references: [`_latex/references.bib`](_latex/references.bib)
* Compiled PDF: [`_pdf/classical_mechanics.pdf`](_pdf/classical_mechanics.pdf)

This initial formulation is compared against a fake theory akin to [Alan Sokal](https://physics.nyu.edu/sokal/transgress_v2/transgress_v2_singlefile.html)'s [infamous paper](https://en.wikipedia.org/wiki/Sokal_affair) "Transgressing the Boundaries: Towards a Transformative Hermeneutics of Quantum Gravity".

* Comparison report: [`_latex/compatibility_findings.tex`](_latex/compatibility_findings.tex) and [`_pdf/compatibility_findings.pdf`](_pdf/compatibility_findings.pdf)
* Fake theory audit: [`_lean/FakeScienceAudit.lean`](_lean/FakeScienceAudit.lean)
* Primarily a scenario where semantic shifts and definitional conflicts arise.

### Run the compatibility check with Docker

From the repository root, build and run the image:

```sh
docker build -t suppes-compatibility .
docker run --rm --network none suppes-compatibility
```

The image includes Lean 4.35.0 and a snapshot of the Lean files at build time.
Rebuild after changing them. The check exits successfully only if the expected
name collision and false-axiom dependency are confirmed; error diagnostics for
the intentionally incompatible declarations are expected. The image supports
`linux/amd64` and `linux/arm64`.

> For official academic BibTeX is available in [_latex](./_latex/)

## Data ETL

1. **Document Understanding** (this was originally a roadblock, now using **Large Language Models**, **LLM**).
1. **Representation** and parsing into a compact formal object (here, `Lean` with the formal technique advanced in the book).
1. **Verification** using Agent-based Artificial Intelligence (envisioned with a suite of Agent-based tools - here only a simple workflow is demonstrated).

Advantages of this approach:
1. **LLM**s can perform **Document Understanding** and **Labeling** techniques (where **Supervised Learning** is required).
1. **LLM Agents** can now perform basic translation and parsing without significant human intervention or the creation of vast tabular/columnar data sets.
1. Various Machine Learning techniques can be combined with the output to further reason about, verify, understand the relationsips between, the resultant Formal Theories.

Disadvantages of this approach:
1. `Lean` won't throw an exception for (or flag) all mathematical contradictions.
1. There are varying layers of incompatibility (between Formal Theories) that are only partially visualized through `Lean Web`:
    * Conceptual.
    * Syntactic - Namespace collisions.
    * *A stronger verification tool is still needed for more robust comparisons, consistency checking, etc.*
    * Here, the LLM plays the role of verifying Agent using `Lean` artifacts.

Follow-up:
1. Some of the Fake Science Theories core claims are semantically (possibly logically) vacuous but no semantic complexity metrics are available in the lab (akin to [Flesh-Kincaid](https://en.wikipedia.org/wiki/Flesch%E2%80%93Kincaid_readability_tests) scores for measuring the semantic expressiveness of the underlying claims).
    * Some kinds of Theories are mostly vacous and make no substantial assertions and it'd be great to detect/filter that right away.
1. Direct logical extrapolation on both Theories isn't performed here. "So, if Theory A is correct what follows. And B?"
1. Direct proposition and sentence comparisons aren't performed here (only trivial namespace, conceptual, and/or definitional conflicts).
1. Likely need for additional Formal artifacts (beyond and in addition to `Lean` and its capabilities).

## Resources and Links

1. https://philarchive.org/rec/SUPRAI
1. https://philpapers.org/archive/SUPRAI.pdf
1. https://www.darpa.mil/research/programs/systematizing-confidence-in-open-research-and-evidence
1. https://www.cos.io/
1. https://www.thoughtscript.io/blog/000000000128
1. https://www.wired.com/story/darpa-bs-detector-science/
1. https://www.ipr.northwestern.edu/news/2024/an-existential-crisis-for-science.html
1. https://suppescorpus.stanford.edu/sites/g/files/sbiybj32751/files/media/file/axiomatic_foundations_of_classical_particle_mechanics_2.pdf
1. https://philsci-archive.pitt.edu/id/eprint/17445/1/CostaKrause%282020%29-Edelcio.pdf
1. https://physics.nyu.edu/sokal/transgress_v2/transgress_v2_singlefile.html
1. https://en.wikipedia.org/wiki/Sokal_affair
1. https://en.wikipedia.org/wiki/Flesch%E2%80%93Kincaid_readability_tests