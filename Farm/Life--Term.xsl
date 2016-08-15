<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ifb="http://www.infarmbureau.com"
    xpath-default-namespace="http://ACORD.org/Standards/Life/2"
    exclude-result-prefixes="xs" version="2.0">
    
    <!-- Functions-should eventually be an include file -->
    <xsl:function name="ifb:castYesNoToBoolean">
        <xsl:param name="yesNo"/>
        <xsl:choose>
            <xsl:when test="$yesNo='Y' or $yesNo='y' or $yesNo='YES' or $yesNo='yes'">true</xsl:when>
            <xsl:when test="$yesNo='N' or $yesNo='n' or $yesNo='NO' or $yesNo='no'">false</xsl:when>
        </xsl:choose>
    </xsl:function>  
    
    <xsl:function name="ifb:getInsuranceProductType">
        <xsl:param name="productType"/>
        <xsl:choose>
            <!-- TERM -->
            <xsl:when test="$productType[@tc='2']">TERM</xsl:when>
        </xsl:choose>
    </xsl:function>
    
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
        <issueAge/>
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
        <paidToDate>
            <xsl:value-of select="PaidToDate"/>
        </paidToDate>
        <billedToDate>
            <xsl:value-of select="BilledToDate"/>
        </billedToDate>
        <gracePeriodEndDate>
            <xsl:value-of select="GracePeriodEndDate"/>
        </gracePeriodEndDate>
        <lastPremiumAutomaticPolicyLoan>
            <xsl:value-of select="ifb:castYesNoToBoolean(Life/NonFortProv)"/>
        </lastPremiumAutomaticPolicyLoan>
    </xsl:template>
    
    <xsl:template name="policyDetail">
        <detailPart>Life</detailPart>
        <coverages>
            <xsl:call-template name="coverage"/>
        </coverages>
        <investments/>
        <dividends>
            <xsl:call-template name="dividends"/>
        </dividends>
    </xsl:template>
    
    <xsl:template name="coverage">
        <deductibles/>
        <description>
            <xsl:value-of select="Life/Coverage/PlanName"/>
        </description>
        <coverageDetail>
            <xsl:call-template name="coverageDetail-Life"/>
        </coverageDetail>
        <limits/>
        <premium>
            <xsl:value-of select="Life/Coverage/AnnualPremAmt"/>
        </premium>
        <isEndorsement/>
        <isExcluded/>
        <isWaived/>
        <inclusions/>
    </xsl:template>
    
    <xsl:template name="coverageDetail-Life">
        <issueAge>
            <xsl:value-of select="//OLifE/Holding/Policy/Life/Coverage/LifeParticipant[LifeParticipantRoleCode[@tc='1']]/IssueAge"/>
        </issueAge>
        <type>
            <xsl:value-of select="ifb:getInsuranceProductType(ProductType)"/>
        </type>
        <guidelineAnnualPremium>
            <xsl:value-of select="Life/Coverage[@IndicatorCode='1']/GuidelineAnnualPremium"/>
        </guidelineAnnualPremium>
        <deathBenefitOption>
            <xsl:value-of select="Life/Coverage[@IndicatorCode='1']/DeathBenefitOptionType"/>
        </deathBenefitOption>
        <rateClassification>
            <xsl:value-of select="Life/Coverage/LifeParticipant/UnderwritingClass"/>
        </rateClassification>
        <tableRating>
            <xsl:value-of select="Life/Coverage/LifeParticipant/PermTableRating"/>
        </tableRating>
        <faceAmount>
            <xsl:value-of select="Life/Coverage/CurrentAmt"/>
        </faceAmount>
        <annualPremium>
            <xsl:value-of select="Life/Coverage/AnnualPremAmt"/>
        </annualPremium>
        <effectiveDate>
            <xsl:value-of select="Life/Coverage/CovOption/EffDate"/>
        </effectiveDate>
        <expirationDate>
            <xsl:value-of select="Life/Coverage/CovOption/TermDate"/>
        </expirationDate>
        <interestCredited>
            <xsl:value-of select="/Life/Coverage/InterestEarnedATD"/>
        </interestCredited>
    </xsl:template>
    
    <xsl:template name="dividends">
        <dividendOption>
            <xsl:value-of select="Life/DivType"/>
        </dividendOption>
        <totalPaidUpAdditions>
            <xsl:value-of select="Life/TotalPUA"/>
        </totalPaidUpAdditions>
        <paidUpAdditionsCashValue>
            <xsl:value-of select="Life/DivPUA"/>
        </paidUpAdditionsCashValue>
        <dividendsOnDeposit>
            <xsl:value-of select="Life/DivOnDepIntAmt"/>
        </dividendsOnDeposit>
        <proRataDividend>
            <xsl:value-of select="/Life/OLifEExtension.ProRataDiv"/>
        </proRataDividend>
        <terminalDividends>
            <xsl:value-of select="Life/TermDivAmt"/>
        </terminalDividends>
        <dividendsOnDepositAmount>
            <xsl:value-of select="Life/DivOnDepIntAmt"/>            
        </dividendsOnDepositAmount>
        <dividendsOnDepositInterestRate>
            <xsl:value-of select="Live/DivOnDepositIntRate"/>
        </dividendsOnDepositInterestRate>
    </xsl:template>
  
</xsl:stylesheet>