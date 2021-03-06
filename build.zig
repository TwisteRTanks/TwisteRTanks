const std = @import("std");
const Pkg = std.build.Pkg;

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("TwisteRTanks", "src/main.zig");
    exe.linkLibC();

    const pkg_sfml = Pkg{ .name = "sfml", .source = .{ .path = "sfml/src/sfml/sfml.zig" } };
    exe.addPackage(pkg_sfml);
    const pkg_sf = Pkg{ .name = "sf", .source = .{ .path = "src/sf.zig" }, .dependencies = &[_]Pkg{ pkg_sfml } };
    exe.addPackage(pkg_sf);
    //exe.addPackagePath("sfml", "sfml/src/sfml/sfml.zig");
    //exe.addPackagePath("sf", "src/sf.zig");

    if (target.getOsTag() == .windows) {
        exe.addLibPath("CSFML/lib/msvc/");
        exe.addIncludeDir("CSFML/include/");
    }
    exe.linkSystemLibrary("csfml-graphics");
    exe.linkSystemLibrary("csfml-system");
    exe.linkSystemLibrary("csfml-window");
    exe.linkSystemLibrary("csfml-audio");
    exe.addIncludeDir("csfml/include/");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();

    const run_step = b.step("run", "Run the game");
    run_step.dependOn(&exe.run().step);
}
