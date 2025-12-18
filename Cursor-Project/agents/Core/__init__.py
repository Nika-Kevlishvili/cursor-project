"""
Core Components - System components for agent management

This package contains core system components:
- AgentRegistry: Registry for managing agents
- AgentRouter: Intelligent agent routing and orchestration
- IntegrationService: GitLab and Jira integration service
- GlobalRules: Global rules enforcement system
"""

from .agent_registry import get_agent_registry, AgentRegistry, Agent
from .agent_router import get_agent_router, AgentRouter
from .integration_service import get_integration_service, IntegrationService
from .global_rules import get_global_rules, GlobalRules, PermissionStatus

__all__ = [
    'get_agent_registry',
    'AgentRegistry',
    'Agent',
    'get_agent_router',
    'AgentRouter',
    'get_integration_service',
    'IntegrationService',
    'get_global_rules',
    'GlobalRules',
    'PermissionStatus',
]
