const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    var test_runner = b.addTest("src/sfml/sfml_tests.zig");
    test_runner.linkLibC();
    test_runner.addLibPath("csfml/lib/msvc/");
    test_runner.linkSystemLibrary("csfml-graphics");
    test_runner.linkSystemLibrary("csfml-system");
    test_runner.linkSystemLibrary("csfml-window");
    test_runner.linkSystemLibrary("csfml-audio");
    test_runner.addIncludeDir("csfml/include/");
    test_runner.setTarget(target);
    test_runner.setBuildMode(mode);

    const test_step = b.step("test", "Runs the test suite.");
    test_step.dependOn(&test_runner.step);
}
