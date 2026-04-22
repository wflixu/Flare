# ADR-007: 采用 Halo 作为 HTTP Web 框架

**Status**: Accepted  
**Date**: 2026-04-20  
**Version**: Phase 0 技术选型

---

## 背景

WitMate 需要一个 HTTP Web 框架来实现：
- HTTP 服务器（监听端口、处理请求）
- 路由系统（URL 路径 → handler）
- 中间件（日志、错误处理、CORS 等）
- JSON 响应生成

---

## 决策

**采用 Halo (wflixu/Halo v0.5.1) 作为 HTTP Web 框架**

### 选择理由

1. **API 设计清晰** - 类 Express/Koa 风格，易于上手
2. **中间件系统完善** - 内置 logger、error_handler、cors 等
3. **路由功能完整** - 支持路径参数、通配符、多种 HTTP 方法
4. **MoonBit Native** - 原生 MoonBit 编写，无需 FFI
5. **代码简洁** - 链式 API，代码量少

### 使用示例

```moonbit
import {
  "wflixu/Halo/halo",
  "wflixu/Halo/halo/router",
  "wflixu/Halo/halo/middleware",
}

let app = @halo.App::new()

// 添加中间件
ignore(app.add_middleware(@middleware.logger()))
ignore(app.add_middleware(@middleware.error_handler()))

// 创建路由
let router = @router.Router::new()
  .get("/health", fn(ctx, _) {
    ctx.set_status(200)
    ignore(ctx.set_body("{\"status\": \"healthy\"}"))
  })
  .post("/api/data", fn(ctx, _) {
    ctx.set_status(200)
    ignore(ctx.set_body("{\"message\": \"POST received\"}"))
  })

ignore(app.add_middleware(router.to_middleware()))
app.listen(":8080")
```

---

## 替代方案

| 方案 | 状态 | 说明 |
|------|------|------|
| moonbitlang/async/http | ⚠️ 复杂 | 官方异步库，API 较底层 |
| 手写 HTTP Server | ❌ 不推荐 | 重复造轮子，复杂度高 |
| fangyinc/net | ⚠️ 待验证 | 跨平台网络库 |

---

## 影响

### 正面影响
- ✅ 快速实现 HTTP Server 原型
- ✅ 代码简洁，易于维护
- ✅ 中间件系统支持未来扩展

### 负面影响
- ⚠️ Halo 的 `listen()` 目前是框架，需要集成底层网络库
- ⚠️ 依赖第三方库，需要跟踪更新

---

## 执行计划

1. **Phase 0**: 使用 Halo 进行路由和中间件验证 ✅
2. **Phase 1**: 集成 moonbitlang/async 实现真实网络功能
3. **Phase 2+**: 根据需要扩展 Halo 或添加自定义中间件

---

## 参考资源

- [Halo on Mooncakes](https://mooncakes.io/docs/wflixu/Halo)
- [Halo GitHub](https://github.com/wflixu/Halo) (如有)
