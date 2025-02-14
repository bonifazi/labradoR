# labradoR (development version)

## Version 1.0.0

First release

## Version 0.0.0.9004

### Enhancements

-   Improved README

-   Added example output using sheep simulated pedigree

## Version 0.0.0.9003

### Enhancements

-   Added options to `process_retriever`:

    -   `xinterval` argument to pass an interval to subset x-axis in plots
    -   `verbose` argument to return more information while processing Retriever file
    -   Added (structured and sequential) comments sections

-   Improved sires contribution figure

-   Pedigree completeness: improved figure & added separate plot for average number generation equivalents.

-   Added \`compute_deltas()\` which returns annual and generational deltas.

-   Added logo.

-   Small syntax improvements.

-   [in progress:] Created script for reporting and running retriever from within R

### Bug fixes

-   Corrected bug in `process_retriever` on `Mean Age Fathers` and `Mean Age Mothers` sections for "DUT" language Retriever .out files
-   Corrected bug in stacked bar plot to include x-axis start and end limit.

## Version 0.0.0.9002

### Enhancements

-   Improved warning message when strings searched are not found: return info and closest match

## Version 0.0.0.9001

### Bug Fixes

-   Fixed a bug on extract_pop function being too specific

## Version 0.0.0.9000

-   Init project.
