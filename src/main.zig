const zrv = @import("zerve");
const routes = @import("routes.zig");
const Server = zrv.Server;
const Route = zrv.Route;
const allocator = std.heap.page_allocator;

pub fn main() !void {
    const rt = [_]Route{.{"/", routes.index}, .{"/some/create", routes.create}, .{"/some", routes.some}};
    try Server.listen("0.0.0.0", 8080, &rt, allocator);
}
