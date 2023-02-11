import { StackProps } from "aws-cdk-lib";
import { HostedZone, HostedZoneAttributes } from "aws-cdk-lib/aws-route53";
import { EmailIdentity, Identity, ReceiptRuleSet } from "aws-cdk-lib/aws-ses";
import { Sns, Stop } from "aws-cdk-lib/aws-ses-actions";
import { Topic } from "aws-cdk-lib/aws-sns";
import { EmailSubscription } from "aws-cdk-lib/aws-sns-subscriptions";
import { Queue } from "aws-cdk-lib/aws-sqs";
import { StringParameter } from "aws-cdk-lib/aws-ssm";
import { Construct } from "constructs";

import { Stack } from "~/lib/cdk/Stack";

export interface ManagedEmailStackProps extends StackProps {
  hostedZoneIdentity: HostedZoneAttributes;
}

export class ManagedEmailStack extends Stack {
  constructor(
    scope: Construct,
    id: string,
    { hostedZoneIdentity, ...props }: ManagedEmailStackProps,
  ) {
    super(scope, id, props);

    const hostedZone = HostedZone.fromHostedZoneAttributes(
      this,
      "HostedZone",
      hostedZoneIdentity,
    );

    new EmailIdentity(this, "SenderIdentity", {
      identity: Identity.publicHostedZone(hostedZone),
    });

    const recipientEmail = StringParameter.valueForStringParameter(
      this,
      `/infrastructure/email/${hostedZoneIdentity.zoneName}/recipient`,
    );

    const deadLetterQueue = new Queue(this, "DeadLetterQueue");
    const topic = new Topic(this, "Topic");
    topic.addSubscription(
      new EmailSubscription(recipientEmail, { deadLetterQueue }),
    );

    new ReceiptRuleSet(this, "ReceiptRuleSet", {
      rules: [
        {
          recipients: [`hello@${hostedZone.zoneName}`],
          actions: [new Stop()],
        },
        {
          recipients: [`contact@${hostedZone.zoneName}`],
          actions: [new Sns({ topic })],
        },
      ],
    });
  }
}
