# Relate Lab: Install, Load and Query Relate

This is the hands-on environment for the module **Install, Load and Query Relate**. It runs in your browser. You install nothing on your own computer.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/OWNER/REPO?quickstart=1)

The lessons are at [Getting Started with Relate](https://graphacademy.neo4j.com/courses/relate-get-started). Keep them open in one tab and this Codespace in another.

## What you need

A GitHub account. That is all.

Codespaces is free up to a monthly quota on personal accounts. This lab uses the smallest machine (2 cores). The module takes under an hour.

## Start the lab

1. Click **Open in GitHub Codespaces** above, then **Create codespace** (or **Resume** if you have one already).
2. Wait for the editor to load. The first start takes a minute or two.
3. Look at the terminal at the bottom of the window. It opens in the `lab` folder. If you see no terminal, press `` Ctrl+` `` or pick **Terminal > New Terminal** from the menu.
4. Run the check:

   ```bash
   lab-check
   ```

   Every line should say `ok`. Now start Lesson 1.

## Run the lesson commands

Copy each command from the lesson and paste it into the terminal. The commands work as written. Stay in the `lab` folder, because the lessons use paths like `./team.rl` and `./import`.

A few things are different here from a laptop:

| Lesson | What to know in this lab |
| --- | --- |
| 1. Install Relate | `relate` is already installed. You can skip the `curl ... install.sh` command. You can also run it: it is safe, and it installs the newest release to `~/.local/bin`, which then takes over. The Windows note does not apply. |
| 2. Run Your First Query | Nothing special. The shell database lives in memory and vanishes on `.quit`. |
| 3. Seed Data From Different Sources | `duckdb` is installed for the optional Parquet step, and a sample `data/people.parquet` is waiting for you. |
| 4. Write and Read Data | Needs the `team.rl` from Lesson 3. Skipped it? Run `lab-seed 4`. |
| 5. Load a Graph From Two Sources | Asks for an empty directory. Run `lab-reset -y` first. |
| 6. Write and Read With an Agent | `relate skill install --agent claude-code` works here. Using an agent is optional. See below. |
| 7. Add Data, Then Ask Questions | Needs the `team.rl` from Challenge 5. Skipped it? Run `lab-seed 7`. |

The first statement you run prints one line about anonymous usage metrics. That is Relate's standard notice. To opt out, run `relate telemetry off`.

## Find your files

Open the **Explorer** (the top icon in the left bar) and expand `lab`. The scripts and CSV files you create show up there. You can click one to read or edit it.

Files ending in `.rl` are databases. Do not open them in the editor. Read them with `relate`.

## Use an agent (optional)

Lessons 6 and 7 can use an AI coding agent. You can finish both without one. Lesson 7 gives a "Solution without an agent" for that step.

If you want to try an agent inside this Codespace:

- **GitHub Copilot Chat**, if your account has Copilot. Run `relate skill install --agent copilot`, open Copilot Chat in agent mode, and give it the prompt from Lesson 6.
- **Any other agent you already pay for.** Install it in the terminal the way its own docs describe, then run `relate skill install --agent <name>`.

Nothing in this lab needs an API key.

## Check that things work

```bash
lab-check          # tools and lab folder, takes a second
lab-check --full   # replays every lesson and challenge in a scratch folder
```

`lab-check --full` does not touch your files. This lab runs no servers and opens no ports, so there is nothing else to start or watch.

## Start over

| You want to | Run |
| --- | --- |
| Empty the lab folder | `lab-reset` |
| Empty it without the question | `lab-reset -y` |
| Also go back to the preinstalled `relate` | `lab-reset --tools`, then `hash -r` |
| Rebuild the whole environment | Press `F1`, type **Codespaces: Rebuild Container**, press Enter |

## Fix common problems

| You see | Do this |
| --- | --- |
| `relate: command not found` | Run `hash -r`. Still broken? Open a new terminal. Still broken? Rebuild the container. |
| `LOAD CSV file unavailable` | Add `--load-csv-dir ./import` to the command, and check you are in the `lab` folder: `pwd` should end in `/lab`. |
| `database not found` on a `--read-only` command | The database does not exist in this folder. Run `ls`. Then redo the load step, or run `lab-seed 4` or `lab-seed 7`. |
| `storage locked` | Another terminal has that database open, usually in a `relate query` shell. Go there and type `.quit`. |
| A write prints nothing | That is normal. A statement with no `RETURN` prints no rows. Read the data back to see it. |
| The shell shows `...>` and waits | The statement has no semicolon yet. Type `;` and press Enter. |
| You cannot leave the shell | Type `.quit` and press Enter. |
| Your counts in Challenge 5 look wrong | Run `lab-reset -y` and do the challenge again from step 1. |
| The terminal opened somewhere else | Run `cd "$LAB_DIR"`. |
| Paste does nothing in the terminal | Your browser asks for clipboard permission the first time. Allow it, then paste again. |

## Stop or delete your Codespace

A Codespace stops by itself after 30 minutes without activity. Your files stay.

To stop it now, click **Codespaces** in the bottom-left corner and pick **Stop Current Codespace**.

When you finish the module, delete it so it stops using your storage quota. Go to [github.com/codespaces](https://github.com/codespaces), click the `...` next to the Codespace, and pick **Delete**. Deleting removes everything in the `lab` folder.
