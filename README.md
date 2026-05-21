# terraform-poc

Terraform sample project for AWS with best practices.

## Design

The documents under `docs/` contain the design and specifications of the infrastructure to build. It has been created using GenAI with **Copilot and Claude Sonnet 4.6**.

Additionally, the following AI resources have been applied to fine-grain and customize the output:

- [Skills](https://github.com/luisalbertogh/awesome-copilot-custom-agents/tree/main/skills)
- [Custom agent](https://github.com/luisalbertogh/awesome-copilot-custom-agents/blob/main/agents/awsarch.agent.md)
- MCP servers:
  - `awslabs.aws-documentation-mcp-server`
  - `awslabs.terraform-mcp-server`
  - See sample configuration for VSCode [here](https://github.com/luisalbertogh/awesome-copilot-custom-agents/blob/main/mcp/mcp.json)

## Floci Emulation

How to use this code with Floci is described [here](./docs/floci.md).
