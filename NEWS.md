# labradoR

## Version 1.1.5
### Bug fixes
- fixed bug in `process_retriever` for `mean_age_parents` plots

## Version 1.1.4
### Bug fixes
- fixed `pedigree_completeness_plot` in output returned from `process_retriever`.

### Enhancements
- improved visualization for `pedigree_completeness_plot`

## Version 1.1.3
### Bug fixes
- fixed `safe_extract.R` to not return `NULL` but results when a warning or message is detected.

## Version 1.1.2

### Bug fixes

- fixed order of labels and label name for years>10 in plots mean_age_fathers and mean_age_mothers

### Enhancements
- added options for `xinterval` and `delta_intervals` in README and example sheep dataset document

## Version 1.1.1

### Bug fixes

-   simplified keyword for litter size when `language=DUT`

-   fixed maintainer field in DESCRIPTION

## Version 1.1.0

### Enhancements

1.  **Improved Section Extraction**:
    -   These changes make `labradoR` compatible with (and were tested on) Retriever version complied on `08.02.2025` .

    -   Added `extract_text`, a generalized function for extracting sections from Retriever’s `.out` files, making subsequent `extract_` functions cleaner and more maintainable.

    -   Introduced `fixed_col_width` argument in `extract_section` to handle fixed-width extraction, ensuring correct data frame dimensions even with missing or truncated columns.

    -   Adapted `extract_` functions (`extract_inbreeding`, `extract_parent_contribution`, `extract_parent_littersize`, `extract_pedigree_completeness`) to use `extract_text` and removed unnecessary arguments.

    -   Moved to use `fixed_col_width` in functions `extract_inbreeding`, `extract_parent_contribution`, `extract_parent_littersize`, `extract_pedigree_completeness`.
2.  **Updated Column Formats**:
    -   Adjusted column names to match new formats in Retriever’s output:

        -   Pedigree completeness: Added support for the `0` column.

        -   Population size: Updated sex ratio extraction.
3.  **New Plot: Sex Ratio**:
    -   Added `sex_ratio_plot` to visualize the percentage of male calves over time.
4.  **Improved Plot Visualizations**:
    -   Enhanced pedigree completeness plot:

        -   Normalized the 0 to 5+ years scale to address rounding issues.

        -   Used shades of blue for clearer representation.

    -   Minor improvements to titles, legends, and overall aesthetics across all plots.
5.  **Better Debugging Features**:
    -   Implemented `safe_extract` using `tryCatch` to log errors and warnings.

    -   Added `return_error_log` argument in `process_retriever` to return logged errors alongside results (accessible via `.$error_log`).

    -   Set `verbose = TRUE` by default in `process_retriever` for more informative progress messages.

### Minor improvements

-   Updated function documentation for clarity.

-   Improved error messages to include the closest match when strings are not found

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
