# Syncoria Claude business skills

The private Syncoria skills repository is packaged automatically on every push to main by the GitHub Actions workflow.

The versioned ZIP and its SHA-256 manifest are stored in the private S3 bucket syncoria-claude-plugin-publisher-bucket-fnlszlpsxhad. The archive includes all 18 skills.

Employees do not need GitHub or developer tools. Company IT should deploy the signed-off release to Windows organization plugins under C:\Program Files\Claude\org-plugins\syncoria-skills using a device-management platform such as Microsoft Intune or an equivalent RMM solution.

The deploy/install-org-skills.ps1 script validates SHA-256, checks skill count and replaces the installed plugin. deploy/detect-org-skills.ps1 supports MDM compliance checks. Run these through device management as Administrator or SYSTEM, never as an employee onboarding step.

GitHub to S3 publication is automated. S3 to every employee device requires an IT endpoint-management integration; this integration is not yet connected, so universal installation is not yet guaranteed. Employees authorize Google Workspace apps individually through OAuth, entirely separately from plugin distribution.

The supplied Google Drive folder was not accessible with the connected Google account. A Google service account granted access would be needed for an optional Drive mirror. A Drive folder is not a native Claude plugin installation source.
