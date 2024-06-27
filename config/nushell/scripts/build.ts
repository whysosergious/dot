import WebSocketBuilder from "./WebSocketBuilder.ts";

const wsBuilder = new WebSocketBuilder("/api/ws")
  .registerFunction("hydrate", function hydrate(payload) {
    console.log("Hydrate function called:", payload);
  })
  .onEvent("runCommand", (payload) => {
    console.log("RunCommand event received:", payload);
  });

// Invoke a function on the server
// wsBuilder.invokeFunction("hydrate", { data: "example data" });

// Close the WebSocket connection when done
// wsBuilder.close();

import WebSocketBuilder from "./WebSocketBuilder.ts";

export function ws_server_init(ctx: any) {
  if (!ctx.isUpgradable) {
    ctx.throw(501);
  }
  ctx.response.headers.set("Upgrade", "websocket");
  const ws = ctx.upgrade();

  const wsBuilder = new WebSocketBuilder(ws)
    .registerFunction("runCommand", function runCommand(payload) {
      console.log("RunCommand function called:", payload);
    })
    .onEvent("hydrate", (payload) => {
      console.log("Hydrate event received:", payload);
    });

  return wsBuilder;
}

import WebSocketBuilder from "./WebSocketBuilder.ts";
import NuShellBuilder from "./NuShellBuilder.ts";

const nu = new NuShellBuilder();

const wsBuilder = new WebSocketBuilder("/api/ws")
  .registerFunction("executeCommandChain", async (payload) => {
    const sqlCommands = nu
      .sql()
      .select(payload.select)
      .from(payload.from)
      .where(payload.where)
      .build();

    await nu
      .storImport(payload.projectDb)
      .nuOpen(payload.files)
      .addSQLCommands(sqlCommands)
      .execute("execute_command_chain");
  })
  .onEvent("changeUser", async (payload) => {
    await nu.changeUser(payload.user).execute("change_user");
  });

// Invoke a command chain on the server
wsBuilder.invokeFunction("executeCommandChain", {
  projectDb: "project_db",
  files: ["file1", "file2"],
  select: "*",
  from: "table_name",
  where: ($in) => $in.user === "testing",
});

type Condition = (input: any) => boolean;

class SQLBuilder {
  private commands: string[] = [];

  select(columns: string): SQLBuilder {
    this.commands.push(`select ${columns}`);
    return this;
  }

  from(table: string): SQLBuilder {
    this.commands.push(`from ${table}`);
    return this;
  }

  where(condition: Condition): SQLBuilder {
    const conditionStr = condition.toString();
    this.commands.push(`where ${conditionStr}`);
    return this;
  }

  insert(table: string, values: any): SQLBuilder {
    const valuesStr = JSON.stringify(values);
    this.commands.push(`insert into ${table} values ${valuesStr}`);
    return this;
  }

  update(table: string, values: any): SQLBuilder {
    const valuesStr = JSON.stringify(values);
    this.commands.push(`update ${table} set ${valuesStr}`);
    return this;
  }

  delete(table: string): SQLBuilder {
    this.commands.push(`delete from ${table}`);
    return this;
  }

  createTable(table: string, columns: string): SQLBuilder {
    this.commands.push(`create table ${table} (${columns})`);
    return this;
  }

  softDelete(): SQLBuilder {
    this.commands.push(`soft_delete`);
    return this;
  }

  commit(): SQLBuilder {
    this.commands.push(`commit`);
    return this;
  }

  build(): string {
    return this.commands.join(" | ");
  }
}

export default SQLBuilder;

import { writeFileStrSync } from "https://deno.land/std/fs/mod.ts";
import SQLBuilder from "./SQLBuilder.ts";

class NuShellBuilder {
  private commands: string[] = [];

  storImport(projectDb: string): NuShellBuilder {
    this.commands.push(`open ${projectDb} | save db`);
    return this;
  }

  storExport(dir: string): NuShellBuilder {
    this.commands.push(`open db | save ${dir}`);
    return this;
  }

  nuOpen(list: string[]): NuShellBuilder {
    this.commands.push(`open ${list.join(" ")}`);
    return this;
  }

  changeUser(user: string): NuShellBuilder {
    this.commands.push(`config set user ${user}`);
    return this;
  }

  run(command: string): NuShellBuilder {
    this.commands.push(command);
    return this;
  }

  watchExec(command: string): NuShellBuilder {
    this.commands.push(`watch ${command}`);
    return this;
  }

  checkExec(command: string): NuShellBuilder {
    this.commands.push(`if ${command}`);
    return this;
  }

  sql(): SQLBuilder {
    return new SQLBuilder();
  }

  addSQLCommands(sqlCommands: string): NuShellBuilder {
    this.commands.push(sqlCommands);
    return this;
  }

  async execute(fileName: string): Promise<void> {
    const commandStr = this.commands.join(" | ");
    console.log(`Executing: ${commandStr}`);

    // Write the command string to a .nu file
    const filePath = `${fileName}.nu`;
    writeFileStrSync(filePath, commandStr);

    // Run the NuShell script
    const process = Deno.run({
      cmd: ["nu", filePath],
      stdout: "piped",
      stderr: "piped",
    });

    const { code } = await process.status();
    const rawOutput = await process.output();
    const rawError = await process.stderrOutput();
    const output = new TextDecoder().decode(rawOutput);
    const error = new TextDecoder().decode(rawError);

    if (code === 0) {
      console.log(`Successfully executed ${filePath}`);
      console.log(output);
    } else {
      console.error(`Failed to execute ${filePath}`);
      console.error(error);
    }
  }
}

export default NuShellBuilder;
type EventHandler = (payload: any) => void;

class WebSocketBuilder {
  private ws: WebSocket;
  private registeredFunctions: { [key: string]: Function } = {};
  private eventHandlers: { [key: string]: EventHandler } = {};

  constructor(url: string) {
    this.ws = new WebSocket(url);

    this.ws.onopen = () => {
      console.log("WebSocket connection opened");
    };

    this.ws.onmessage = (ev) => {
      const message = JSON.parse(ev.data);
      if (this.eventHandlers[message.type]) {
        this.eventHandlers[message.type](message.payload);
      } else if (this.registeredFunctions[message.type]) {
        this.registeredFunctions[message.type](message.payload);
      } else {
        console.error("Unknown message type:", message.type);
      }
    };

    this.ws.onclose = () => {
      console.log("WebSocket connection closed");
    };
  }

  registerFunction(name: string, fn: Function): WebSocketBuilder {
    this.registeredFunctions[name] = fn;
    this.ws.send(
      JSON.stringify({
        type: "register",
        payload: {
          name,
          code: fn.toString(),
        },
      }),
    );
    return this;
  }

  onEvent(name: string, handler: EventHandler): WebSocketBuilder {
    this.eventHandlers[name] = handler;
    return this;
  }

  invokeFunction(name: string, args: any): WebSocketBuilder {
    this.ws.send(
      JSON.stringify({
        type: "invoke",
        payload: {
          name,
          args,
        },
      }),
    );
    return this;
  }

  close(): void {
    this.ws.close();
  }
}

export default WebSocketBuilder;
