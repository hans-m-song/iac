import type { CdkCustomResourceHandler } from "aws-lambda";

// import Cloudflare from "cloudflare";
import { getParameter } from "~/lib/aws/ssm";
import { Cloudflare } from "~/lib/cloudflare";

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

  try {
    switch (event.RequestType) {
      case "Create": {
        console.log("creating record", props);
        const response = await cf.upsertDNSRecord(zoneId, {
          type: props.type as any,
          name: props.name,
          content: props.value,
          ttl: props.ttl,
          proxied: props.proxied,
        });
        console.log(response);

        return { PhysicalResourceId: response.result.id };
      }

      case "Update": {
        const oldProps = getProps(event.OldResourceProperties);
        console.log("updating record", { new: props, old: oldProps });
        const response = await cf.editDNSRecord(
          zoneId,
          event.PhysicalResourceId,
          {
            type: props.type as any,
            name: props.name,
            content: props.value,
            ttl: props.ttl,
            proxied: props.proxied,
          },
        );
        console.log(response);

        return { PhysicalResourceId: response.result.id };
      }

      case "Delete": {
        console.log("deleting record", props);
        const response = await cf.delDNSRecord(
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
