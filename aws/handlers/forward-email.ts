import { SNSHandler } from "aws-lambda";

const inboxBucketARN = process.env.INBOX_BUCKET;

export const handler: SNSHandler = async (event) => {
  console.log(JSON.stringify({ inboxBucketARN, event }));
};
