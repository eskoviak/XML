<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
<xsl:template match="/">
    <data>
        <description>Term Life Model</description>
        <properties>
            <xsl:apply-templates select="Policy"/>
        </properties>
    </data>  
</xsl:template>
    
<xsl:template match="Policy">
    <policyNumber><xsl:value-of select="/PolNumber"/></policyNumber>    
</xsl:template>
    
</xsl:stylesheet>