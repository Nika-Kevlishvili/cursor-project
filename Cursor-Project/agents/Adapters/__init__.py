"""
Adapters - Adapter classes for agents

This package contains adapter classes that implement the Agent interface:
- PhoenixExpertAdapter: Adapter for PhoenixExpert
- TestAgentAdapter: Adapter for TestAgent
- EnvironmentAccessAdapter: Adapter for EnvironmentAccessAgent
"""

from .phoenix_expert_adapter import PhoenixExpertAdapter
from .test_agent_adapter import TestAgentAdapter
from .environment_access_adapter import EnvironmentAccessAdapter

__all__ = [
    'PhoenixExpertAdapter',
    'TestAgentAdapter',
    'EnvironmentAccessAdapter',
]
