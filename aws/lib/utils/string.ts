export const upperFirst = (input: string) =>
  `${input.slice(0, 1).toUpperCase()}${input.slice(1)}`;

export const delimetedToPascalCase = (input: string, delimeter: string) =>
  input.split(delimeter).map(upperFirst).join("");

export const snakeToPascalCase = (input: string) =>
  delimetedToPascalCase(input, "_");

export const kebabToPascalCase = (input: string) =>
  delimetedToPascalCase(input, "-");

export const urlToPascalCase = (input: string) =>
  delimetedToPascalCase(input, ".");

export const pascalToWords = (input: string) =>
  input
    // split on beginning of capitalised word
    .replace(/([a-z])([A-Z])/g, "$1_$2")
    // split on acronym end
    .replace(/([A-Z]{2,})([A-Z][a-z])/g, "$1_$2")
    .split("_");
