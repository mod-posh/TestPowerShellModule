# Test PowerShell Module GitHub Action

This GitHub Action is designed to create and test a PowerShell module from source files. It integrates with GitHub's Actions workflow to automate the process of setting up, testing, and validating PowerShell modules.

## Inputs

### `ModuleName`

**Required** The name of the PowerShell module.

### `Source`

**Optional** The source directory containing the module (relative to the workspace). Default is the root of the workspace.

### `Output`

**Optional** The output directory for the manifest (relative to the workspace). The default is `output``.

### `Debug`

**Optional** Enable debug mode. The default is `false``.

## Example usage

```yaml
name: Build PowerShell Module

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  build:
    runs-on: windows-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
        with:
          path: 'Repo'

      - name: Create PowerShell Manifest
        uses: mod-posh/CreatePowerShellManifest@v0.0.1.0
        with:
          ModuleName: 'SpnLibrary'
          Source: 'Repo'
          Imports: 'public'
          Debug: 'true'

      - name: Create PowerShell Module
        uses: mod-posh/CreatePowerShellModule@v0.0.1.0
        with:
          ModuleName: 'SpnLibrary'
          Source: 'Repo'
          Imports: 'public'
          Debug: 'true'

      - name: Test PowerShell Module
        uses: mod-posh/TestpowerShellModule@main
        with:
          ModuleName: 'SpnLibrary'
          Source: 'Repo'
          Debug: 'true'

      - name: Upload PowerShell Module
        uses: actions/upload-artifact@v4
        with:
          name: your-module-output
          path: ${{ github.workspace }}/output
```
