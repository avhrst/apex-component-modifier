# Oracle APEX Component Modifier — Skill Installation Guide

## What is this?

The Oracle APEX Component Modifier is a Claude Code Skill. It lets you modify Oracle APEX application pages and components using natural language — right from the command line.

You tell Claude what you want to change, and it handles the entire process: exporting the APEX component, modifying the exported files, applying any database changes, and importing everything back. All of this happens through Oracle SQLcl's built-in MCP Server.

MCP stands for Model Context Protocol. It's a standard that lets AI tools like Claude Code connect to external services. In this case, Claude connects to your Oracle database through SQLcl, so it can export and import APEX components and run SQL commands on your behalf.

## What do you need before you start?

You need two things installed on your machine.

First, Claude Code — Anthropic's command-line interface for Claude. It runs in your terminal and gives Claude access to your project files and tools.

Second, Oracle SQLcl version 25.2 or later. SQLcl is Oracle's modern command-line tool for working with Oracle databases. Starting with version 25.2, it includes a built-in MCP server that Claude Code can connect to. SQLcl requires Java 17 or Java 21.

## Step 1 — Copy the skill into your project

The skill is a folder of files that teach Claude how to safely modify APEX components. You need to copy this folder into your project.

Open your terminal, navigate to your project directory, and run these commands:

First, clone the skill repository into a temporary directory. The repository is hosted on GitHub at github.com/avhrst/apex-component-modifier.

Then create the Claude skills directory in your project. The path is dot-claude, slash skills. This is the standard location where Claude Code looks for project skills.

Next, copy the apex-component-modifier skill folder from the cloned repository into your project's skills directory.

Finally, clean up by removing the temporary clone.

After this step, your project should have a dot-claude folder containing a skills folder, which contains the apex-component-modifier folder with a file called SKILL.md and several reference documentation files.

## Step 2 — Add the SQLcl MCP server

Now you need to tell Claude Code how to connect to SQLcl. Run this single command:

claude mcp add sqlcl -- sql -R 1 -mcp

This registers SQLcl as an MCP server named "sqlcl". The "-mcp" flag tells SQLcl to run in MCP server mode. The "-R 1" flag sets the restriction level to 1, which is the least restrictive. If you need tighter security, you can use "-R 4" for the most restrictive mode.

If the "sql" command is not on your system PATH, you'll need to use the full path to the SQLcl binary. On Linux, it's typically at /opt/sqlcl/bin/sql. On macOS, it's usually at /usr/local/bin/sql. On Windows, look for it under your user folder in Oracle/sqlcl/bin/sql.

## Step 3 — Create a saved database connection

The MCP server needs database credentials to connect to your APEX instance. You do this by creating a saved connection inside SQLcl.

Open SQLcl with the no-login flag by running: sql /nolog

Then save a connection with this command: conn -save DEV -savepwd -user YOUR_USER/YOUR_PASS@host:port/service

Replace "DEV" with whatever alias you want to use — this is the name you'll reference later. Replace the username, password, host, port, and service name with your actual database connection details.

The connection is stored securely in your home directory under dot-dbtools. Once saved, the MCP server can use it automatically without prompting for credentials every time.

## Step 4 — Configure skill settings

The last configuration step is telling the skill which APEX environment to use by default.

Create a file called settings.json inside the dot-claude folder in your project root. This file contains three environment variables:

SQLCL_CONNECTION — set this to the connection alias you created in Step 3. For example, "DEV".

APEX_APP_ID — set this to your APEX application ID. This is the numeric ID you see in the APEX Application Builder. For example, "113".

APEX_WORKSPACE — set this to your APEX workspace name. For example, "DEV_WORKSPACE".

These become the default values the skill uses when you don't specify them explicitly. You can always override them when invoking the skill.

If you're working on a team, this settings file can be committed to git so everyone shares the same defaults. For personal overrides, create a separate file called settings.local.json in the same dot-claude folder — this file is automatically excluded from git.

## Step 5 — Verify the installation

Open Claude Code in your project directory and invoke the skill:

/apex-component-modifier PAGE:1 -- Describe page 1

If everything is configured correctly, Claude will connect to your database through SQLcl, export Page 1 from your APEX application, and describe what's on the page.

## How to use the skill

Once installed, you invoke the skill by typing /apex-component-modifier followed by a component selector and a change request.

For example: /apex-component-modifier PAGE:10 -- Add item P10_STATUS as a select list based on LOV STATUS_LOV

The skill uses your configured defaults for the connection and application ID. If you need to target a different environment, provide them explicitly:

/apex-component-modifier STG 200 PAGE:10 -- Add item P10_STATUS as a select list

In this example, STG is the connection alias, 200 is the application ID, and PAGE:10 is the component selector.

The component selector can be a page (PAGE:10), a list of values (LOV: followed by the ID), or a region (REGION: followed by the ID).

## What happens behind the scenes?

When you invoke the skill, Claude follows a seven-step workflow:

First, it exports the specified APEX component using SQLcl's apex export command.

Second, it reads the built-in reference documentation about how APEX export files are structured. This documentation is bundled inside the skill folder.

Third, it analyzes your change request and creates a plan — separating database changes from APEX component changes.

Fourth, it applies any needed database changes. For example, creating a table or modifying a package. These scripts are designed to be idempotent, so they're safe to re-run.

Fifth, it patches the exported APEX component files. This is where the actual modifications happen — adding items, changing labels, updating regions, and so on.

Sixth, it imports the modified component back into APEX using SQLcl's install script.

Seventh, it verifies the changes by re-exporting the component and producing a diff so you can see exactly what changed.

## Summary

To install the Oracle APEX Component Modifier skill, you need five steps: copy the skill files into your project, register the SQLcl MCP server, create a saved database connection, configure your APEX settings, and verify with a test run. After that, you can modify APEX components using natural language commands directly from Claude Code.
