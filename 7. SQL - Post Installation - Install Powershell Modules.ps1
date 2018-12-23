# Install SqlServer Module
Install-Module SqlServer -Scope AllUsers -Force -AllowClobber

# Install dbatools Module
Install-Module dbatools -Scope AllUsers -Force -AllowClobber

# Install Excel Module
Install-Module ImportExcel -Scope AllUsers -Force -AllowClobber

# Update Help
Update-Help -Force

# Update
Update-Module

