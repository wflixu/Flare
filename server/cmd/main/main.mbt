// Flare Server - HTTP Server using Halo Framework
// Phase 0: 技术验证 - 真实 HTTP 服务器

///|
fn main {
  let app = @halo.App::new()

  // 添加基础中间件
  ignore(app.add_middleware(@middleware.logger()))
  ignore(app.add_middleware(@middleware.error_handler()))

  // 创建路由
  let router = @router.Router::new()
    // 健康检查
    .get("/health", fn(ctx, _) {
      ctx.set_status(200)
      ignore(ctx.set_body("{\"status\": \"healthy\", \"service\": \"Flare\"}"))
    })

    // 服务器状态
    .get("/status", fn(ctx, _) {
      ctx.set_status(200)
      ignore(ctx.set_body("{\"server\": \"Flare\", \"version\": \"0.1.0\", \"phase\": \"Phase 0\"}"))
    })

    // API 测试端点
    .get("/api/test", fn(ctx, _) {
      ctx.set_status(200)
      ignore(ctx.set_body("{\"message\": \"GET request successful\"}"))
    })

    // POST API 端点
    .post("/api/data", fn(ctx, _) {
      ctx.set_status(200)
      ignore(ctx.set_body("{\"message\": \"POST request received\", \"success\": true}"))
    })

    // 默认路由
    .get("/", fn(ctx, _) {
      ctx.set_status(200)
      ignore(ctx.set_body("{\"message\": \"Welcome to Flare Server\", \"docs\": \"/health\"}"))
    })

    // 404 处理
    .handle_404(fn(ctx) {
      ctx.set_status(404)
      ignore(ctx.set_body("{\"error\": \"Not Found\", \"message\": \"The requested resource was not found\"}"))
    })

  // 添加路由中间件
  ignore(app.add_middleware(router.to_middleware()))

  // 启动服务器
  println("")
  println("╔════════════════════════════════════════════════╗")
  println("║   Flare Server v0.1.0                          ║")
  println("║   Phase 0 - HTTP Server Validation             ║")
  println("╚════════════════════════════════════════════════╝")
  println("")
  println("Endpoints:")
  println("  GET  /         - Welcome message")
  println("  GET  /health   - Health check")
  println("  GET  /status   - Server status")
  println("  GET  /api/test - API test")
  println("  POST /api/data - POST test")
  println("")
  println("Starting server on :8080")
  println("")
  println("Test with:")
  println("  curl http://localhost:8080/health")
  println("  curl http://localhost:8080/status")
  println("")

  app.listen(":8080")
}
