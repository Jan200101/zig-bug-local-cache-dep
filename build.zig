const std = @import("std");

pub fn build(b: *std.Build) !void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    // We use env vars throughout the build so we grab them immediately here.
    var env = try std.process.getEnvMap(b.allocator);
    defer env.deinit();

    // We only build an exe if we have a runtime set.
    const exe = b.addExecutable(.{
        .name = "ghostty",
        .root_source_file = b.path("empty.zig"),
        .target = target,
        .optimize = optimize,
    });

    const freetype_dep = b.dependency("freetype", .{
        .target = target,
        .optimize = optimize,
    });

    exe.linkLibrary(freetype_dep.artifact("freetype"));

    b.installArtifact(exe);
}
