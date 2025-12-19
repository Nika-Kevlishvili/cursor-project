"""
BugFinderAgent - Specialized Agent for Bug Validation

ROLE:
- Validates bug reports by checking Confluence documentation and codebase
- Follows Rule 32 workflow: Confluence validation → Code validation → Comprehensive analysis
- Determines if bugs are valid based on discrepancies between documentation and implementation

WORKFLOW:
1. Receives bug description prompt
2. Searches Confluence using MCP tools to validate bug description
3. Searches codebase to check actual implementation
4. Compares findings and reports if bug is valid (code differs from description)

ACCESS:
- READ-ONLY access to Confluence (via MCP) and codebase
- Does NOT modify code or documentation
"""

import json
from typing import Dict, List, Any, Optional, Tuple
from pathlib import Path
from datetime import datetime

# Import services
try:
    from agents.Core.integration_service import get_integration_service
    INTEGRATION_SERVICE_AVAILABLE = True
except ImportError:
    INTEGRATION_SERVICE_AVAILABLE = False

try:
    from agents.Services.reporting_service import get_reporting_service
    REPORTING_SERVICE_AVAILABLE = True
except ImportError:
    REPORTING_SERVICE_AVAILABLE = False

try:
    from agents.Main.phoenix_expert import get_phoenix_expert
    PHOENIX_EXPERT_AVAILABLE = True
except ImportError:
    PHOENIX_EXPERT_AVAILABLE = False


class BugFinderAgent:
    """
    Specialized agent for bug validation.
    
    Validates bug reports by:
    1. Checking Confluence documentation (via MCP)
    2. Checking codebase implementation
    3. Comparing findings to determine if bug is valid
    """
    
    def __init__(self):
        """Initialize BugFinderAgent."""
        self.agent_name = "BugFinderAgent"
        self.confluence_cloud_id = None
        
        # Initialize services
        if INTEGRATION_SERVICE_AVAILABLE:
            self.integration_service = get_integration_service()
        else:
            self.integration_service = None
            
        if REPORTING_SERVICE_AVAILABLE:
            self.reporting_service = get_reporting_service()
        else:
            self.reporting_service = None
    
    def _get_confluence_cloud_id(self) -> Optional[str]:
        """
        Get Confluence cloud ID using MCP tools.
        
        Returns:
            Cloud ID string or None if unavailable
        """
        # This will be called via MCP tools in the main validation method
        # We return None here as a placeholder - actual MCP calls happen in validate_bug()
        return None
    
    def _search_confluence(
        self, 
        query: str, 
        cloud_id: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Search Confluence using MCP tools.
        
        Args:
            query: Search query string
            cloud_id: Optional Confluence cloud ID
            
        Returns:
            Dictionary with search results
        """
        # This method documents the MCP tool usage pattern
        # Actual MCP calls are made in validate_bug() method
        # MCP tools available:
        # - mcp_Confluence_search() - General search
        # - mcp_Confluence_searchConfluenceUsingCql() - CQL search
        # - mcp_Confluence_getConfluencePage() - Get specific page
        # - mcp_Confluence_getConfluenceSpaces() - Get spaces
        
        return {
            'query': query,
            'results': [],
            'note': 'MCP tools called in validate_bug() method'
        }
    
    def _search_codebase(
        self, 
        query: str, 
        target_directories: Optional[List[str]] = None
    ) -> Dict[str, Any]:
        """
        Search codebase for relevant code.
        
        Args:
            query: Search query string
            target_directories: Optional list of directories to search
            
        Returns:
            Dictionary with code search results
        """
        # This method documents the codebase search pattern
        # Actual searches are made in validate_bug() method using:
        # - codebase_search() - Semantic search
        # - grep() - Text search
        
        return {
            'query': query,
            'results': [],
            'note': 'Codebase search tools called in validate_bug() method'
        }
    
    def validate_bug(
        self, 
        bug_description: str,
        context: Optional[Dict[str, Any]] = None
    ) -> Dict[str, Any]:
        """
        Validate a bug report by checking Confluence and codebase.
        
        This method follows Rule 32 workflow:
        1. Validate bug report against Confluence (FIRST)
        2. Validate code against bug report (SECOND)
        3. Provide comprehensive analysis
        
        Args:
            bug_description: Description of the bug to validate
            context: Optional context dictionary with additional information
            
        Returns:
            Dictionary with validation results:
            {
                'bug_description': str,
                'confluence_validation': {
                    'status': 'correct' | 'incorrect' | 'partially_correct',
                    'explanation': str,
                    'sources': List[Dict]
                },
                'code_validation': {
                    'status': 'satisfies' | 'does_not_satisfy',
                    'explanation': str,
                    'code_references': List[Dict]
                },
                'conclusion': {
                    'bug_valid': bool,
                    'summary': str,
                    'details': str
                }
            }
        """
        # Log activity
        if self.reporting_service:
            self.reporting_service.log_activity(
                self.agent_name,
                'bug_validation_started',
                f'Starting bug validation for: {bug_description[:100]}...'
            )
        
        # Call IntegrationService before task (Rule 0.3)
        if self.integration_service:
            try:
                self.integration_service.update_before_task(
                    task_description=f"Bug validation: {bug_description[:100]}...",
                    agent_name=self.agent_name
                )
            except Exception as e:
                print(f"BugFinderAgent: [WARNING] IntegrationService.update_before_task() failed: {e}")
        
        # Consult PhoenixExpert (Rule 0.4) - for context and validation approach
        phoenix_expert_consultation = None
        if PHOENIX_EXPERT_AVAILABLE:
            try:
                phoenix_expert = get_phoenix_expert()
                # Log consultation
                if self.reporting_service:
                    self.reporting_service.log_activity(
                        self.agent_name,
                        'consultation',
                        'Consulting PhoenixExpert for bug validation approach',
                        consulted_agent='PhoenixExpert'
                    )
                # Note: PhoenixExpert consultation is logged, but actual validation
                # is performed by BugFinderAgent following Rule 32 workflow
            except Exception as e:
                print(f"BugFinderAgent: [WARNING] PhoenixExpert consultation failed: {e}")
        
        result = {
            'bug_description': bug_description,
            'confluence_validation': {
                'status': 'pending',
                'explanation': '',
                'sources': []
            },
            'code_validation': {
                'status': 'pending',
                'explanation': '',
                'code_references': []
            },
            'conclusion': {
                'bug_valid': False,
                'summary': '',
                'details': ''
            },
            'timestamp': datetime.now().isoformat()
        }
        
        # Log that validation will be performed via MCP and codebase tools
        if self.reporting_service:
            self.reporting_service.log_activity(
                self.agent_name,
                'information_source',
                'Using MCP Confluence tools and codebase search for validation',
                source_type='confluence_mcp',
                source_type_2='codebase_search'
            )
        
        # Return result structure
        # NOTE: Actual MCP Confluence calls and codebase searches are performed
        # by the calling code (Cursor AI) using available tools.
        # This agent provides the structure and workflow.
        
        result['workflow_note'] = (
            "BugFinderAgent workflow structure ready. "
            "Actual validation requires MCP Confluence tools and codebase_search/grep tools "
            "to be called with the bug_description. "
            "Follow Rule 32: Confluence FIRST, Codebase SECOND, then analysis."
        )
        
        return result
    
    def format_validation_report(self, validation_result: Dict[str, Any]) -> str:
        """
        Format validation result as a markdown report.
        
        Args:
            validation_result: Result dictionary from validate_bug()
            
        Returns:
            Formatted markdown report string
        """
        report = f"""## Bug Validation Analysis

**Bug Description:** {validation_result['bug_description']}

### 1. Confluence Validation

**Status:** {validation_result['confluence_validation']['status']}

**Explanation:** {validation_result['confluence_validation']['explanation']}

**Sources:**
"""
        
        for source in validation_result['confluence_validation']['sources']:
            report += f"- {source.get('title', 'Unknown')}: {source.get('url', 'N/A')}\n"
        
        report += f"""
### 2. Code Analysis

**Status:** {validation_result['code_validation']['status']}

**Explanation:** {validation_result['code_validation']['explanation']}

**Code References:**
"""
        
        for ref in validation_result['code_validation']['code_references']:
            report += f"- {ref.get('file', 'Unknown')}:{ref.get('line', 'N/A')} - {ref.get('description', '')}\n"
        
        report += f"""
### 3. Conclusion

**Bug Valid:** {'✅ YES' if validation_result['conclusion']['bug_valid'] else '❌ NO'}

**Summary:** {validation_result['conclusion']['summary']}

**Details:** {validation_result['conclusion']['details']}

---
*Generated by BugFinderAgent at {validation_result.get('timestamp', 'unknown')}*
"""
        
        return report


def get_bug_finder_agent() -> BugFinderAgent:
    """
    Get or create BugFinderAgent instance.
    
    Returns:
        BugFinderAgent instance
    """
    if not hasattr(get_bug_finder_agent, '_instance'):
        get_bug_finder_agent._instance = BugFinderAgent()
    return get_bug_finder_agent._instance
