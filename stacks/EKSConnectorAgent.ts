import * as cdk from "aws-cdk-lib";
import { EKSConnectorAgentRole } from "@lib/iam/Role-EKS-ConnectorAgent.js";
import { App } from "aws-cdk-lib";

const app = new App();
const stack = new cdk.Stack(app, "EKSConnectorAgent");
new EKSConnectorAgentRole(stack);
