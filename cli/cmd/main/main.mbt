// Flare CLI - 使用 Admiral 框架
// MoonBit 生态中最好用的 CLI 框架示例

///|
fn main {
  let app = @admiral.cli(
    name="flare",
    version="0.1.0",
    description="Flare - 自我进化的个人 Agent 协调器",
    commands=[
      // start 命令
      @admiral.command(
        name="start",
        description="启动 Flare 服务",
        options=[
          @admiral.int("port", short='p', description="服务器端口", default=Some(8080)),
          @admiral.bool("verbose", short='v', description="详细输出"),
        ],
        examples=["flare start -p 3000", "flare start --verbose"],
        run=Some(fn(ctx) {
          let port = match ctx.get_int("port") { Some(n) => n; None => 8080 }
          let verbose = ctx.get_bool("verbose")
          if verbose {
            println("Starting Flare server on port " + port.to_string())
          }
          println("Flare server started on :8080")
        }),
      ),

      // chat 命令
      @admiral.command(
        name="chat",
        description="进入交互式对话",
        options=[
          @admiral.string("model", short='m', description="LLM 模型", default=Some("claude-sonnet-4")),
          @admiral.bool("stream", short='s', description="流式输出"),
        ],
        examples=["flare chat -m claude-opus", "flare chat --stream"],
        run=Some(fn(ctx) {
          let model = match ctx.get_string("model") { Some(m) => m; None => "claude-sonnet-4" }
          let stream = ctx.get_bool("stream")
          println("Entering chat mode with model: " + model)
          if stream {
            println("Stream output enabled")
          }
          println("Type 'exit' to quit")
        }),
      ),

      // dream 命令
      @admiral.command(
        name="dream",
        description="触发 Dream 整合机制",
        options=[
          @admiral.bool("force", short='f', description="强制整合"),
        ],
        examples=["flare dream -f"],
        run=Some(fn(ctx) {
          let force = ctx.get_bool("force")
          if force {
            println("Starting Dream integration (forced)...")
          } else {
            println("Starting Dream integration...")
          }
          println("Dream integration complete")
        }),
      ),

      // status 命令
      @admiral.command(
        name="status",
        description="查看服务状态",
        options=[],
        run=Some(fn(ctx) {
          println("Flare Status:")
          println("  Server: Not running")
          println("  Memory: 0 files")
          println("  Skills: 0 loaded")
        }),
      ),
    ],
  )
  try { app.run() } catch { err => println(err) }
}
