<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xpath-default-namespace="http://ACORD.org/Standards/Life/2"
    exclude-result-prefixes="xs" version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
        <data>
            <xsl:apply-templates select="//OLifE/Holding/Policy" />
        </data>
    </xsl:template>

    <xsl:template match="Policy">
        <id>
            <xsl:value-of select="PolNumber" />        
        </id>
        <policyNumber>
            <xsl:value-of select="PolNumber" />
        </policyNumber>
        <description>
            <xsl:value-of select="ProductType" />
        </description>
        <locations/>
        <polcyDetails>
            <xsl:call-template name="policyDetail"/>
        </polcyDetails>
        <issueAge>
            <xsl:value-of select="//OLifE/Holding/Policy/Life/Coverage/LifeParticipant[LifeParticipantRoleCode[@tc='1']]/IssueAge"/>
        </issueAge>
        <originalInceptionDate/>
        <termEffectiveDate>
            <xsl:value-of select="EffDate"/>
        </termEffectiveDate>
        <termExpirationDate>
            <xsl:value-of select="Life/Coverage/TermDate"/>
        </termExpirationDate>
        <cancelDate/>
        <maturityDate/>
        <policyTerm></policyTerm>
        <billingPlan/>
        <premium/>
        <billingDetails>
            <xsl:call-template name="billing"></xsl:call-template>
        </billingDetails>
        <policyAssociations>
            <!-- TODO -->
        </policyAssociations>
    </xsl:template>

    <xsl:template name="billing">
        <paymentMethod>
            <xsl:value-of select="PaymentMethod"/>
        </paymentMethod>
        <paymentMode>
            <xsl:value-of select="PaymentMode"/>
        </paymentMode>
        <paymentAmount>
            <xsl:value-of select="PaymentAmt"/>
        </paymentAmount>
    </xsl:template>
    
    <xsl:template name="policyDetail">
        <detailPart>Life</detailPart>
        <coverages>
            <xsl:call-template name="coverage"/>
        </coverages>
    </xsl:template>
    
    <xsl:template name="coverage">
        <deductibles/>
        <description>
            <xsl:value-of select="Life/Coverage/PlanName"/>
        </description>
        <coverageDetail>
            
        </coverageDetail>
        
    </xsl:template>
    
</xsl:stylesheet>