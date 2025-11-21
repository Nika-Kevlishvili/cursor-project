# MCP (Model Context Protocol) Setup Guide / MCP Setup გზამკვლევი

ეს გზამკვლევი დაგეხმარებათ MCP (Model Context Protocol) კონფიგურაციის დაყენებაში Cursor-ში.

This guide will help you set up MCP (Model Context Protocol) configuration in Cursor.

## 📋 რა არის MCP? / What is MCP?

MCP (Model Context Protocol) არის Cursor-ის ფუნქცია, რომელიც საშუალებას იძლევა AI-ს გამოიყენოს external tools და resources.

MCP (Model Context Protocol) is a Cursor feature that allows AI to use external tools and resources.

## ⚠️ მნიშვნელოვანი შენიშვნა / Important Note

**MCP კონფიგურაცია ინახება Cursor-ის user settings-ში** და არა პროექტში, ამიტომ ის **არ გადმოვიდა GitHub-ზე**.

**MCP configuration is stored in Cursor's user settings** and not in the project, so it **did not get uploaded to GitHub**.

## 🔧 MCP კონფიგურაციის მდებარეობა / MCP Configuration Location

### Windows:
```
%APPDATA%\Cursor\User\settings.json
```

### macOS:
```
~/Library/Application Support/Cursor/User/settings.json
```

### Linux:
```
~/.config/Cursor/User/settings.json
```

## 📝 MCP კონფიგურაციის დაყენება / Setting Up MCP Configuration

### ვარიანტი 1: Cursor Settings UI / Option 1: Cursor Settings UI

1. გახსენით Cursor Settings:
   - `Ctrl+,` (Windows/Linux) ან `Cmd+,` (Mac)
   - ან File → Preferences → Settings

2. მოძებნეთ "MCP" ან "Model Context Protocol"

3. დაამატეთ MCP servers და tools

### ვარიანტი 2: settings.json-ის რედაქტირება / Option 2: Edit settings.json

1. გახსენით settings.json:
   ```powershell
   # Windows
   code "$env:APPDATA\Cursor\User\settings.json"
   
   # ან პირდაპირ Cursor-ში:
   # Ctrl+Shift+P → "Preferences: Open User Settings (JSON)"
   ```

2. დაამატეთ MCP კონფიგურაცია:
   ```json
   {
     "mcp": {
       "servers": {
         "example-server": {
           "command": "node",
           "args": ["path/to/server.js"],
           "env": {
             "API_KEY": "your-api-key"
           }
         }
       }
     }
   }
   ```

## 🔍 MCP კონფიგურაციის შემოწმება / Checking MCP Configuration

### PowerShell-ში:
```powershell
# Windows - MCP კონფიგურაციის ნახვა
Get-Content "$env:APPDATA\Cursor\User\settings.json" | ConvertFrom-Json | Select-Object -ExpandProperty mcp
```

### Cursor-ში:
1. `Ctrl+Shift+P` (ან `Cmd+Shift+P` Mac-ზე)
2. მოძებნეთ "MCP" ან "Model Context Protocol"
3. შეამოწმეთ კონფიგურაცია

## 📤 MCP კონფიგურაციის ექსპორტი / Exporting MCP Configuration

თუ გსურთ MCP კონფიგურაციის backup ან სხვა კომპიუტერზე გადატანა:

### Windows:
```powershell
# MCP კონფიგურაციის ექსპორტი
$settings = Get-Content "$env:APPDATA\Cursor\User\settings.json" | ConvertFrom-Json
$mcpConfig = $settings.mcp | ConvertTo-Json -Depth 10
$mcpConfig | Out-File -FilePath "mcp_config_backup.json" -Encoding UTF8
```

### Import ახალ კომპიუტერზე:
```powershell
# MCP კონფიგურაციის იმპორტი
$backup = Get-Content "mcp_config_backup.json" | ConvertFrom-Json
$settings = Get-Content "$env:APPDATA\Cursor\User\settings.json" | ConvertFrom-Json
$settings.mcp = $backup
$settings | ConvertTo-Json -Depth 10 | Set-Content "$env:APPDATA\Cursor\User\settings.json" -Encoding UTF8
```

## 🛠️ MCP Tools-ის მაგალითები / MCP Tools Examples

### GitHub MCP Server:
```json
{
  "mcp": {
    "servers": {
      "github": {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-github"],
        "env": {
          "GITHUB_PERSONAL_ACCESS_TOKEN": "your-token"
        }
      }
    }
  }
}
```

### File System MCP Server:
```json
{
  "mcp": {
    "servers": {
      "filesystem": {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/allowed/directory"]
      }
    }
  }
}
```

## 🔐 Security / უსაფრთხოება

⚠️ **მნიშვნელოვანი**: MCP კონფიგურაცია შეიძლება შეიცავდეს sensitive data (API keys, tokens):
- ❌ **არ** დააკომიტოთ `settings.json` Git-ში
- ✅ გამოიყენეთ environment variables
- ✅ შეინახეთ backup-ები უსაფრთხო ადგილას

⚠️ **Important**: MCP configuration may contain sensitive data (API keys, tokens):
- ❌ **Do NOT** commit `settings.json` to Git
- ✅ Use environment variables
- ✅ Store backups in a secure location

## 🆘 Troubleshooting / პრობლემების გადაჭრა

### პრობლემა: MCP არ მუშაობს
**გადაწყვეტა**:
1. შეამოწმეთ settings.json syntax
2. გადატვირთეთ Cursor
3. შეამოწმეთ MCP server logs

### პრობლემა: MCP კონფიგურაცია არ გადმოვიდა GitHub-ზე
**გადაწყვეტა**:
- ეს ნორმალურია! MCP კონფიგურაცია ინახება user settings-ში
- გამოიყენეთ export/import scripts (იხ. ზემოთ)

## 📚 დამატებითი რესურსები / Additional Resources

- [Cursor MCP Documentation](https://cursor.sh/docs)
- [Model Context Protocol Specification](https://modelcontextprotocol.io)
- [MCP Servers Directory](https://github.com/modelcontextprotocol/servers)

---

**ბოლო განახლება / Last Updated**: 2025-01-14

