const zrv = @import("zerve");
const sqlite = @import("sqlite");

const Request = zrv.Request;
const Response = zrv.Response;
const Method = zrv.Method;

var db = try sqlite.Db.init(.{
    .mode = sqlite.Db.Mode{ .File = "/home/some/mydata.db" },
    .open_flags = .{
        .write = true,
        .create = true,
    },
    .threading_mode = .MultiThread,
});
try db.exec("CREATE TABLE some(id integer primary key, name text, data blob)", .{}, .{});

pub fn index(req: *Request) Response {
  if (req.header != null) {
    Response.notFound("valid but no resource.");
  } else {
    return Response.write("root");
  }
}

pub fn some(req: *Request) Response {
  if (req.method == Method.GET) {
    read();
  } else if (req.method == method.PUT and req.body != null) {
    update();
  } else if (req.method == method.DELETE and req.body != null) {
    delete();
  }
}

pub fn create(req: *Request) Response {
  // revoke invalid user with req.header or anything
  Response.forbidden("invalid user.")

  // write to db with req.body after validation
  db.execDynamic(
      "INSERT INTO some(name, data) VALUES($req.body.name, $req.body.data)",
      .{},
      .{
          .name = data,
          .data = data,
      },
  ) catch |err| switch (err) {
      error.SQLiteError => return,
      else => return err,
  };

  const res = try std.json.stringify({});
  return Response.json(&res);
}

pub fn read(req: *Request) Response {
  // read values from db
  db.execDynamic(
      "SELECT id, name, data from some"
      .{},
      .{},
  ) catch |err| switch (err) {
      error.SQLiteError => return,
      else => return err,
  };

  const res = try std.json.stringify({});
  return Response.json(&res);
}

pub fn update(req: *Request) Response {
  // revoke invalid user with req.header or anything, probably it's better to write this logic in some fn
  Response.forbidden("invalid user.");

  // update db with req.body after validation

  return Reponse.write("updated successfully!");
}

pub fn delete(req: *Request) Response {
  // revoke invalid user with req.header or anything, probably it's better to write this logic in some fn
  Response.forbidden("forbidden");

  // delete the value from db

  return Response.write("deleted, I'm sad :(")
}
