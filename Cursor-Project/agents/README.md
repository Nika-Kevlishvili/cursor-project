# Agents Package - ორგანიზებული სტრუქტურა

აგენტები ორგანიზებულია ტემატიკური ფოლდერების მიხედვით.

Agents are organized by topic in separate folders.

## 📁 სტრუქტურა / Structure

```
agents/
├── Main/              # ძირითადი აგენტები / Main agents
│   ├── phoenix_expert.py
│   └── test_agent.py
├── Support/           # დამხმარე აგენტები / Support agents
│   ├── gitlab_update_agent.py
│   └── environment_access_agent.py
├── Core/              # სისტემური კომპონენტები / Core components
│   ├── agent_registry.py
│   ├── agent_router.py
│   ├── integration_service.py
│   └── global_rules.py
├── Adapters/          # ადაპტერები / Adapters
│   ├── phoenix_expert_adapter.py
│   ├── test_agent_adapter.py
│   └── environment_access_adapter.py
├── Services/          # სერვისები / Services
│   ├── reporting_service.py
│   └── postman_collection_generator.py
├── Utils/             # Utilities / დამხმარე ფუნქციები
│   ├── initialize_agents.py
│   ├── rules_loader.py
│   ├── logger_utils.py
│   ├── reporting_helper.py
│   └── ai_response_logger.py
├── __init__.py        # მთავარი exports
└── README.md          # ეს ფაილი
```

## 📝 კატეგორიები / Categories

### Main Agents (ძირითადი აგენტები)
- **PhoenixExpert**: Q&A აგენტი Phoenix პროექტისთვის
- **TestAgent**: ავტომატიზებული ტესტირების აგენტი

### Support Agents (დამხმარე აგენტები)
- **GitLabUpdateAgent**: GitLab-დან პროექტების განახლების აგენტი
- **EnvironmentAccessAgent**: DEV და DEV-2 გარემოებში წვდომის აგენტი

### Core Components (სისტემური კომპონენტები)
- **AgentRegistry**: აგენტების რეგისტრი
- **AgentRouter**: ინტელექტუალური აგენტების როუტინგი
- **IntegrationService**: GitLab და Jira ინტეგრაციის სერვისი
- **GlobalRules**: გლობალური წესების სისტემა

### Adapters (ადაპტერები)
- **PhoenixExpertAdapter**: PhoenixExpert-ის ადაპტერი
- **TestAgentAdapter**: TestAgent-ის ადაპტერი
- **EnvironmentAccessAdapter**: EnvironmentAccessAgent-ის ადაპტერი

### Services (სერვისები)
- **ReportingService**: აგენტების აქტივობის რეპორტინგის სერვისი
- **PostmanCollectionGenerator**: Postman კოლექციების გენერაციის სერვისი

### Utils (დამხმარე ფუნქციები)
- **initialize_agents**: ყველა აგენტის ინიციალიზაცია
- **rules_loader**: წესების ჩატვირთვა .cursor/rules/ დირექტორიიდან
- **logger_utils**: ლოგირების utilities
- **reporting_helper**: რეპორტინგის დამხმარე ფუნქციები
- **ai_response_logger**: AI პასუხების ლოგირება

## 🔧 გამოყენება / Usage

### იმპორტები / Imports

ყველა აგენტი და კომპონენტი შეიძლება იმპორტირებული იყოს მთავარი `agents` package-იდან:

```python
# Main agents
from agents import PhoenixExpert, TestAgent, get_phoenix_expert, get_test_agent

# Support agents
from agents import GitLabUpdateAgent, EnvironmentAccessAgent

# Core components
from agents import AgentRegistry, AgentRouter, IntegrationService, GlobalRules

# Adapters
from agents import PhoenixExpertAdapter, TestAgentAdapter

# Services
from agents import ReportingService, PostmanCollectionGenerator

# Utils
from agents.Utils import initialize_all_agents
```

ან პირდაპირ კატეგორიიდან:

```python
from agents.Main import PhoenixExpert, TestAgent
from agents.Support import GitLabUpdateAgent
from agents.Core import AgentRegistry
from agents.Adapters import PhoenixExpertAdapter
from agents.Services import ReportingService
from agents.Utils import initialize_all_agents
```

## 📌 შენიშვნები / Notes

- ყველა იმპორტი მუშაობს როგორც absolute (`from agents...`) ასევე relative imports-ებით
- `__init__.py` ფაილები თითოეულ ფოლდერში უზრუნველყოფს მოხერხებულ იმპორტებს
- ახალი აგენტების დამატებისას გთხოვთ მოათავსოთ შესაბამის ფოლდერში
