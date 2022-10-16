import { spawn } from "child_process";

/**
 * Spawns a child process and captures all output
 *
 * Resolves once child completes
 */
export const cliSync = async (
  command: string,
  ...args: string[]
): Promise<string> => {
  const stdout: string[] = [];
  const stderr: string[] = [];

  const child = spawn(command, args);
  child.stdout.on("data", (data) => stdout.push(data));
  child.stderr.on("data", (data) => stderr.push(data));
  const status = await new Promise((resolve) => child.once("close", resolve));

  if (status !== 0) {
    const fullcommand = [command, ...args].join(" \\\n  ");
    const metadata = {
      fullcommand,
      status,
      stdout: stdout.join(""),
      stderr: stderr.join(""),
    };

    const error = new Error(
      [
        `Execution failed with status: ${status}`,
        fullcommand,
        "STDOUT",
        "------",
        metadata.stdout,
        "STDERR",
        "------",
        metadata.stderr,
      ].join("\n"),
    );
    Object.assign(error, { metadata });
    throw error;
  }

  return stdout.join("");
};

/**
 * Spawns a child process that will inherit the stdio of the parent process
 *
 * Resolves once child completes
 */
export const cliStream = async (command: string, ...args: string[]) => {
  const child = spawn(command, args, { stdio: "inherit" });
  const status = await new Promise((resolve) => child.once("close", resolve));

  if (status !== 0) {
    const fullcommand = [command, ...args].join(" \\\n  ");
    const metadata = { fullcommand, status };

    const error = new Error(
      [`Execution failed with status: ${status}`, fullcommand].join("\n"),
    );
    Object.assign(error, { metadata });
    throw error;
  }
};
