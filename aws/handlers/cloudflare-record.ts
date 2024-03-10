import type { CdkCustomResourceHandler } from "aws-lambda";
import Cloudflare from "cloudflare";
import dns from "dns/promises";

import { getParameter } from "~/lib/aws/ssm";

const requireAttr = (props: any, key: string): string => {
  if (!props[key]) {
    throw new Error(`Missing required property: ${key}`);
  }

  return props[key] as string;
};

const getProps = (props: any) => ({
  apiTokenPath: requireAttr(props, "ApiTokenPath"),
  zoneIdPath: requireAttr(props, "ZoneIdPath"),
  name: requireAttr(props, "Name"),
  type: requireAttr(props, "Type"),
  value: requireAttr(props, "Value"),
  ttl: Number(props?.Ttl ?? "300"),
  proxied: Boolean(props?.proxied),
});

export const onEvent: CdkCustomResourceHandler = async (event) => {
  const props = getProps(event.ResourceProperties);
  const apiToken = await getParameter(props.apiTokenPath);
  if (!apiToken) {
    throw new Error("Failed to retrieve Cloudflare API token");
  }

  const zoneId = await getParameter(props.zoneIdPath);
  if (!zoneId) {
    throw new Error("Failed to retrieve Cloudflare zone id");
  }

  const cf = new Cloudflare({ token: apiToken });

  const record = {
    type: props.type as any,
    name: props.name,
    content: props.value,
    ttl: props.ttl,
    proxied: props.proxied,
  };

  try {
    switch (event.RequestType) {
      case "Create": {
        console.log("creating record", { props, record });
        const existing = await cf.dnsRecords.browse(zoneId, {
          name: props.name,
          type: props.type as any,
        });

        if (existing.success && existing.result && existing.result.length > 0) {
          const response = (await cf.dnsRecords.edit(
            zoneId,
            existing.result[0].id,
            record,
          )) as any;
          console.log(response);
          return { PhysicalResourceId: response.result.id };
        }

        const response = (await cf.dnsRecords.add(zoneId, {
          type: props.type as any,
          name: props.name,
          content: props.value,
          ttl: props.ttl,
          proxied: props.proxied,
        })) as any;
        console.log(response);
        return { PhysicalResourceId: response.result.id };
      }

      case "Update": {
        const oldProps = getProps(event.OldResourceProperties);
        console.log("updating record", { new: props, old: oldProps });
        const response = (await cf.dnsRecords.edit(
          zoneId,
          event.PhysicalResourceId,
          record,
        )) as any;
        console.log(response);
        return { PhysicalResourceId: response.result.id };
      }

      case "Delete": {
        console.log("deleting record", props);
        if (!(await lookupRecord(props.name, props.type))) {
          console.log("record does not exist, skipping delete");
          return { PhysicalResourceId: event.PhysicalResourceId };
        }

        const response = await cf.dnsRecords.del(
          zoneId,
          event.PhysicalResourceId,
        );
        console.log(response);
        return { PhysicalResourceId: event.PhysicalResourceId };
      }
    }
  } catch (error) {
    console.error(
      "failed to handle event, to manually resolve, post a response to",
      event.ResponseURL,
    );
    throw error;
  }
};

const lookupRecord = async (hostname: string, type: string) => {
  try {
    await dns.resolve(hostname, type);
    return true;
  } catch (error) {
    return false;
  }
};
