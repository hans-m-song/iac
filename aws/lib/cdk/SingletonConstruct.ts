import * as cdk from "aws-cdk-lib";
import { Construct, IConstruct } from "constructs";

export interface Constructable<C extends IConstruct, Props> {
  new (scope: Construct, id: string, props: Props): C;
}

export class SingletonConstruct<C extends IConstruct, Props> {
  private readonly ctor: Constructable<C, Props>;

  constructor(ctor: Constructable<C, Props>) {
    this.ctor = ctor;
  }

  get(scope: Construct, id: string, props: Props): C {
    const stack = cdk.Stack.of(scope);
    const instance = stack.node.tryFindChild(id);
    if (!instance) {
      return new this.ctor(stack, id, props);
    }

    if (!(instance instanceof this.ctor)) {
      throw new Error(
        `A construct with id ${id} already exists and is not an instance of ${this.ctor.name}`,
      );
    }

    return instance;
  }
}
