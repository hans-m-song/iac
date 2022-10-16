import { promises as fs, Stats } from "fs";
import path from "path";

type Item = { filepath: string; stats: Stats };

const isItem = (input: any): input is Item =>
  input &&
  typeof input.filepath === "string" &&
  typeof input.stats === "object";

export const walk = async (
  dir: string,
  cb?: (item: Item) => Promise<Item | null> | Item | null,
): Promise<Item[]> => {
  const contents = await fs.readdir(dir);
  const results = await Promise.all(
    contents.map(async (file) => {
      const filepath = path.join(dir, file);
      const stats = await fs.stat(filepath);
      const item = { filepath, stats };
      return cb ? cb(item) : item;
    }),
  );

  const items = results.filter(isItem);
  const files = items.filter(({ stats }) => stats.isFile());
  const subdirs = items.filter(({ stats }) => stats.isDirectory());
  const subfiles = await Promise.all(
    subdirs.map(({ filepath }) => walk(filepath, cb)),
  );
  return [...files, ...subfiles.flat()];
};
