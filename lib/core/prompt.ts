import { createInterface } from "readline";

export const prompt = async (question: string): Promise<string> => {
  const rl = createInterface({
    input: process.stdin,
    output: process.stdout,
  });

  const response = await new Promise((resolve) =>
    rl.question(`${question}\n> `, resolve),
  );

  rl.close();
  return response as string;
};

/**
 * Repeat question until answer is accepted
 */
export const promptUntilValid = async (
  question: string,
  validate: (answer: string) => string | null,
  retries = 3,
): Promise<string> => {
  const response = await prompt(question);
  const error = validate(response);
  if (!error) {
    return response;
  }

  if (retries < 0) {
    throw new Error("exceeded retry attempts");
  }

  return promptUntilValid(error, validate, retries - 1);
};

/**
 * Repeat question until answer is yes/no
 */
export const promptYesNo = async (question: string): Promise<boolean> => {
  const response = await promptUntilValid(`${question} (y/n)`, (answer) =>
    ["y", "yes", "n", "no"].includes(answer.toLowerCase())
      ? null
      : 'please answer "y[es]" or "n[o]"',
  );

  return ["y", "yes"].includes(response.toLowerCase());
};

/**
 * Repeat question until answer is a number within given range
 */
export const promptIndex = async (
  question: string,
  max: number,
  min = 0,
): Promise<number> => {
  const response = await promptUntilValid(
    `${question} (${min}-${max})`,
    (answer) => {
      const value = parseInt(answer);
      if (isNaN(value) || value < min || value > max) {
        return `please enter a valid number (${min}-${max})`;
      }

      return null;
    },
  );

  return parseInt(response);
};
