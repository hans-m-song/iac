export const toSentenceCase = (input: string) =>
  `${input.slice(0, 1).toUpperCase()}${input.slice(1)}`;

export const delimetedToPascalCase = (input: string, delimeter: string) =>
  input.split(delimeter).map(toSentenceCase).join("");

export const snakeToPascalCase = (input: string) =>
  delimetedToPascalCase(input, "_");

export const kebabToPascalCase = (input: string) =>
  delimetedToPascalCase(input, "-");

export const urlToPascalCase = (input: string) =>
  delimetedToPascalCase(input, ".");
