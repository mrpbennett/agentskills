# agentskills

A collection of reusable AI agent skills for Claude Code and OpenCode.

## Skills

| Skill | Description |
|-------|-------------|
| [til](til/SKILL.md) | Capture a Today I Learned entry — writes a markdown file to the TIL repo, updates the README, commits and pushes |
| [omarchy-plugin-publish](omarchy-plugin-publish/SKILL.md) | Scaffold, validate, and publish a third-party Omarchy shell plugin as a public git repository |

## Installation

### Claude Code

```bash
# Copy all skills to Claude Code's skills directory
mkdir -p ~/.claude/skills
cp -r til omarchy-plugin-publish ~/.claude/skills/
```

### OpenCode

```bash
# Copy all skills to OpenCode's skills directory
mkdir -p ~/.config/opencode/skills
cp -r til omarchy-plugin-publish ~/.config/opencode/skills/
```

### One-liner (Claude Code)

```bash
git clone https://github.com/mrpbennett/agentskills.git /tmp/agentskills && \
  mkdir -p ~/.claude/skills && \
  cp -r /tmp/agentskills/til /tmp/agentskills/omarchy-plugin-publish ~/.claude/skills/ && \
  rm -rf /tmp/agentskills
```
