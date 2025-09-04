/**
 * Gitignore template tests
 *
 * Test runner note:
 * - Compatible with Jest, Mocha, and Vitest (uses global describe/it and Node's assert/strict).
 * - No external deps added.
 */

const fs = require("fs");
const path = require("path");
const assert = require("assert/strict");

function resolveGitignore() {
  const candidates = [
    path.resolve(process.cwd(), ".gitignore"),
    path.resolve(process.cwd(), "gitignore"),
    path.resolve(process.cwd(), "templates/.gitignore"),
    path.resolve(process.cwd(), "template/.gitignore"),
    path.resolve(process.cwd(), "config/.gitignore"),
    path.resolve(process.cwd(), "resources/.gitignore"),
  ];
  for (const p of candidates) {
    if (fs.existsSync(p)) return p;
  }
  throw new Error(
    "Unable to locate a .gitignore file. Checked:\n" + candidates.join("\n")
  );
}

function toLineSet(src) {
  return new Set(
    src
      .split("\n")
      .map((l) => l.replace(/\r$/, "")) // strip CR if present
      .map((l) => l.trim())
      .filter((l) => l.length > 0 && !l.startsWith("#"))
  );
}

function missingPatterns(set, required) {
  return required.filter((p) => !set.has(p));
}

const GITIGNORE_PATH = resolveGitignore();
const CONTENT_RAW = fs.readFileSync(GITIGNORE_PATH, "utf8");

describe("Repository .gitignore", () => {
  it("exists at an expected location", () => {
    assert.ok(fs.existsSync(GITIGNORE_PATH), `Expected to find .gitignore at ${GITIGNORE_PATH}`);
  });

  it("uses LF endings and has no trailing whitespace", () => {
    assert.equal(CONTENT_RAW.includes("\r"), false, "Expected LF-only line endings");
    CONTENT_RAW.split("\n").forEach((line, idx) => {
      assert.equal(/\s$/.test(line), false, `Trailing whitespace on line ${idx + 1}: "${line}"`);
    });
  });

  it("contains essential ignore patterns (cross-ecosystem)", () => {
    const set = toLineSet(CONTENT_RAW);
    const required = [
      // macOS / Windows thumbnail noise
      ".DS_Store", ".DS_Store?", "._*", ".Spotlight-V100", ".Trashes", "ehthumbs.db", "Thumbs.db",

      // Gradle / Build outputs
      ".gradle/", "build/",
      "!gradle/wrapper/gradle-wrapper.jar",
      "!**/src/main/**/build/", "!**/src/test/**/build/",

      // IntelliJ IDEA
      ".idea/", "*.iws", "*.iml", "*.ipr", "out/",
      "!**/src/main/**/out/", "!**/src/test/**/out/",

      // Eclipse
      ".classpath", ".project", ".settings", "bin/",
      "!**/src/main/**/bin/", "!**/src/test/**/bin/",

      // NetBeans
      "/nbproject/private/", "/nbbuild/", "/dist/", "/nbdist/", "/.nb-gradle/",

      // VS Code
      ".vscode/",

      // Maven
      "target/", "pom.xml.tag", "pom.xml.releaseBackup", "pom.xml.versionsBackup", "pom.xml.next",
      "release.properties", "dependency-reduced-pom.xml", "buildNumber.properties",
      ".mvn/timing.properties", ".mvn/wrapper/maven-wrapper.jar",

      // Spring Boot artifacts
      "*.jar", "*.war", "*.nar", "*.ear", "*.zip", "*.tar.gz", "*.rar", "hs_err_pid*",

      // Logs / runtime data
      "logs/", "*.log", "log/", "pids", "*.pid", "*.seed", "*.pid.lock",

      // Environment files
      ".env", ".env.local", ".env.development.local", ".env.test.local", ".env.production.local",

      // Databases
      "*.db", "*.sqlite", "*.sqlite3", "*.h2.db",

      // Temps / backups
      "*.tmp", "*.temp", "tmp/", "temp/", "*.bak", "*.backup", "*.old",

      // Xcode / Swift
      "xcuserdata/", "*.xcscmblueprint", "*.xccheckout", "DerivedData/", "*.moved-aside",
      "*.pbxuser", "!default.pbxuser", "*.mode1v3", "!default.mode1v3",
      "*.mode2v3", "!default.mode2v3", "*.perspectivev3", "!default.perspectivev3",
      "*.hmap", "*.ipa", "*.dSYM.zip", "*.dSYM", "timeline.xctimeline", "playground.xcworkspace",

      // Swift Package Manager
      ".build/",

      // Apple dependency managers
      "Carthage/Build/", "Dependencies/", ".accio/",

      // fastlane
      "fastlane/report.xml", "fastlane/Preview.html", "fastlane/screenshots/**/*.png", "fastlane/test_output",

      // Code injection / simulator
      "iOSInjectionProject/", "*.app",

      // macOS images
      "*.dmg",

      // Editor / IDE miscellany
      ".vscode/*", "!.vscode/extensions.json", ".idea", "*.suo", "*.ntvs*", "*.njsproj", "*.sln", "*.sw?",

      // Archives (repeated intentionally for emphasis in template)
      "*.zip", "*.tar.gz", "*.rar",

      // Coverage
      "coverage/", "*.lcov",

      // Node.js
      "node_modules/", "npm-debug.log*", "yarn-debug.log*", "yarn-error.log*",
    ];

    const missing = missingPatterns(set, required);
    assert.deepEqual(missing, [], `Missing patterns:\n${missing.join("\n")}`);
  });

  it("keeps key negation rules to include necessary files", () => {
    const set = toLineSet(CONTENT_RAW);
    const negations = [
      "!gradle/wrapper/gradle-wrapper.jar",
      "!**/src/main/**/build/",
      "!**/src/test/**/build/",
      "!**/src/main/**/out/",
      "!**/src/test/**/out/",
      "!**/src/main/**/bin/",
      "!**/src/test/**/bin/",
      "!.vscode/extensions.json",
      "!default.pbxuser",
      "!default.mode1v3",
      "!default.mode2v3",
      "!default.perspectivev3",
    ];
    const missing = missingPatterns(set, negations);
    assert.deepEqual(missing, [], `Missing negation patterns:\n${missing.join("\n")}`);
  });

  it("includes clear section headers to aid maintainers", () => {
    const lines = CONTENT_RAW.split("\n").map((l) => l.trim());
    const headers = [
      "# macOS",
      "# Spring Boot / Gradle",
      "# IntelliJ IDEA",
      "# Eclipse",
      "# NetBeans",
      "# VS Code",
      "# Maven",
      "# Spring Boot",
      "# Logs",
      "# Runtime data",
      "# Environment variables",
      "# Database",
      "# Temporary files",
      "# Backup files",
      "# Swift / Xcode",
      "# CocoaPods",
      "# Carthage",
      "# fastlane",
      "# Code Injection",
      "# Editor directories and files",
      "# Archive files",
      "# Test coverage",
      "# Node.js (if using any frontend tools)",
    ];
    const missingHeaders = headers.filter((h) => !lines.includes(h));
    assert.deepEqual(missingHeaders, [], `Missing section headers: ${missingHeaders.join(", ")}`);
  });
});