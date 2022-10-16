const DEFAULT_POLL_RETRIES = 3;
const DEFAULT_POLL_BACKOFF = 3000;
const DEFAULT_POLL_TIMEOUT = 60000;

export const sleep = (time: number) =>
  new Promise((resolve) => setTimeout(resolve, time));

/**
 * Poll for given number of retries or until validate is true
 */
export const pollToCount = async <T>(
  fn: () => Promise<T>,
  validate: (output: T) => boolean,
  retries = DEFAULT_POLL_RETRIES,
  backoff = DEFAULT_POLL_BACKOFF,
): Promise<T> => {
  const output = await fn();

  if (validate(output)) {
    return output;
  }

  if (retries < 1) {
    throw new Error("polling exceeded retry attempts");
  }

  await sleep(backoff);

  return pollToCount(fn, validate, retries - 1);
};

/**
 * Poll until given timeout or until validate is true
 */
export const pollToTimeout = async <T>(
  fn: () => Promise<T>,
  validate: (output: T) => boolean,
  timeout = DEFAULT_POLL_TIMEOUT,
  backoff = DEFAULT_POLL_BACKOFF,
) => {
  const begin = Date.now();

  const fnWthTimeout = () => {
    if (Date.now() - begin > timeout) {
      throw new Error(`polling exceeded timeout of ${timeout}`);
    }

    return fn();
  };

  await pollToCount(fnWthTimeout, validate, Infinity, backoff);
};
