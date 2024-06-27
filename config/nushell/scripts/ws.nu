import WebSocketBuilder from "./WebSocketBuilder.ts";
import NuShellBuilder from "./NuShellBuilder.ts";

const nu = new NuShellBuilder();

const wsBuilder = new WebSocketBuilder("/api/ws")
    .registerFunction("executeCommandChain", async (payload) => {
        const sqlCommands = nu.sql()
            .select(payload.select)
            .where(payload.where)
            .softDelete()
            .commit()
            .build();

        await nu.storImport(payload.projectDb)
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
    where: ($in) => $in.user === "testing"
});
