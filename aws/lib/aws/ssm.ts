import { SSMClient, GetParameterCommand } from "@aws-sdk/client-ssm";

const client = new SSMClient();

export const getParameter = async (path: string) => {
  const command = new GetParameterCommand({ Name: path, WithDecryption: true });
  const response = await client.send(command);
  return response.Parameter?.Value ?? null;
};
