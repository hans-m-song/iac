import { table, TableUserConfig } from "table";

export const renderTable = (
  label: string,
  data: Record<string, unknown> | unknown[],
  config?: TableUserConfig,
) =>
  table([[label, ""], ...Object.entries(data)], {
    spanningCells: [{ col: 0, row: 0, colSpan: 2 }],
    ...config,
  });
