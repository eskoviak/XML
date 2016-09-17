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
        <metadata>
            <statusCode>
                <xsl:value-of select="//ResultCode"/>          
            </statusCode>
            <statusDescription>
                <xsl:value-of select="//ResultInfo/ResultInfoDesc"/>
            </statusDescription>

        </metadata>
        <data>
            <xsl:apply-templates select="//OLifE/Holding/Policy" />
        </data>
    </xsl:template>

    <!-- Main Loop Start at TXLife/TXLifeResponse/OLifE/Holding -->
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
<!--        <billingPlan/>
-->        <premium/>
        <billingDetails>
            <xsl:call-template name="billing"></xsl:call-template>
        </billingDetails>
        <policyAssociations>
            <xsl:call-template name="policyAssociation"/>
        </policyAssociations>
    </xsl:template>

    <xsl:template name="billing">
<!--        <paymentMethod>
            <xsl:value-of select="PaymentMethod"/>
        </paymentMethod>
-->        <paymentMode>
            <xsl:value-of select="PaymentMode"/>
        </paymentMode>
 <!--       <paymentAmount>
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
-->    </xsl:template>
    
    <xsl:template name="policyDetail">
        <detailPart>Life</detailPart>
        <coverages>
            <xsl:call-template name="coverage"/>
        </coverages>
        <investments/>
        <dividends>
            <xsl:call-template name="dividends"/>
        </dividends>
        <faceAmount>
            <xsl:value-of select="Life/FaceAmt"/>
        </faceAmount>
        <netBaseDeathBenefit>
            <xsl:value-of select="Life/FaceAmt"/>
        </netBaseDeathBenefit>
        <targetPremiumAmount>
            <xsl:value-of select="Life/OLifEExtension/TargetPremAmts/TargetPremAmt"/>
        </targetPremiumAmount>
        <targetPremiumAmountBase>
            <xsl:value-of select="Life/OLifEExtension/TargetPremAmts/TargetPremPhase"/>
        </targetPremiumAmountBase>
        <totalPremiumsPaidAmount>
            <xsl:value-of select="Life/TotCumPremAmt"/>
        </totalPremiumsPaidAmount>
        <discountedAdvancePremium>
            <xsl:value-of select="Life/NonDivOnDepositAmt"/>
        </discountedAdvancePremium>
        <projectedValues>
            <xsl:call-template name="projectedValues"></xsl:call-template>
        </projectedValues>
        <nonForfeitureProvision>
            <xsl:call-template name="nonForfeiture-Life"/>
        </nonForfeitureProvision>
    </xsl:template>
    
    <xsl:template name="coverage">
        <xsl:for-each select="Life/Coverage">
            <deductibles/>
            <description>
                <xsl:value-of select="PlanName"/>
            </description>
            <coverageDetail>
                <xsl:call-template name="coverageDetail-Life"/>
            </coverageDetail>
            <limits/>
            <premium>
                <xsl:value-of select="AnnualPremAmt"/>
            </premium>
            <isEndorsement/>
            <isExcluded/>
            <isWaived/>
            <inclusions/>            
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="coverageDetail-Life">
        <issueAge>
            <xsl:value-of select="LifeParticipant[LifeParticipantRoleCode[@tc='1']]/IssueAge"/>
        </issueAge>
        <type>
            <xsl:value-of select="ifb:getInsuranceProductType(ProductType)"/>
        </type>
        <guidelineAnnualPremium>
            <xsl:value-of select="Coverage[@IndicatorCode='1']/GuidelineAnnualPremium"/>
        </guidelineAnnualPremium>
        <deathBenefitOption>
            <xsl:value-of select="Coverage[@IndicatorCode='1']/DeathBenefitOptionType"/>
        </deathBenefitOption>
        <rateClassification>
            <xsl:value-of select="Coverage/LifeParticipant/UnderwritingClass"/>
        </rateClassification>
        <tableRating>
            <xsl:value-of select="LifeParticipant/PermTableRating"/>
        </tableRating>
        <faceAmount>
            <xsl:value-of select="CurrentAmt"/>
        </faceAmount>
        <annualPremium>
            <xsl:value-of select="AnnualPremAmt"/>
        </annualPremium>
        <effectiveDate>
            <xsl:value-of select="CovOption/EffDate"/>
        </effectiveDate>
        <expirationDate>
            <xsl:value-of select="CovOption/TermDate"/>
        </expirationDate>
        <interestCredited>
            <xsl:value-of select="InterestEarnedATD"/>
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
            <xsl:value-of select="/Life/OLifEExtensionProRataDiv"/>
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
  
    <xsl:template name="projectedValues">
        <projectedValuesDate/>
        <anniversaryPolicyValue/>
        <age65PolicyValue/>
        <dividendValue/>
        <policyValue/>
    </xsl:template>
    
    <xsl:template name="nonForfeiture-Life">
        <reducedPaidUpAmount>
            <xsl:value-of select="Life/OLifEExtension/RPUQuote"/>
        </reducedPaidUpAmount>
        <extendedTermInsuranceAmount>
            <xsl:value-of select="Life/OLifEExtension/ETIQuote"/>
        </extendedTermInsuranceAmount>
        <extendedTermInsuranceExpirationDate>
            <xsl:value-of select="Life/OLifEExtension/ETIDate"/>
        </extendedTermInsuranceExpirationDate>
    </xsl:template>
    
    <xsl:template name="policyAssociation">
        <!-- Primary Beneficiary -->
        <xsl:for-each select='//OLifE/Party[@id=//OLifE/Relation[RelationRoleCode[@tc="34"]]/@RelatedObjectID]'>
            <name>
                <xsl:value-of select="concat(
                    Person/FirstName, ' ',
                    Person/MiddleName, ' ',
                    Person/LastName)"/>
            </name>
            <address>
                <xsl:value-of select="Address"/>
            </address>
            <referenceData></referenceData>
            <associationType>
                PRIMARY BENEFICIARY
            </associationType>
            <associationSubType></associationSubType>
        </xsl:for-each>
        <!-- Secondary Beneficiary -->
        <xsl:for-each select='//OLifE/Party[@id=//OLifE/Relation[RelationRoleCode[@tc="36"]]/@RelatedObjectID]'>
            <name>
                <xsl:value-of select="concat(
                    Person/FirstName, ' ',
                    Person/MiddleName, ' ',
                    Person/LastName)"/>
            </name>
            <address>
                <xsl:value-of select="Address"/>
            </address>
            <referenceData></referenceData>
            <associationType>
                SECONDARY BENFICIARY
            </associationType>
            <associationSubType></associationSubType>
        </xsl:for-each>
        
     </xsl:template>
    
    <xsl:template name="address">
        <addressType></addressType>
        <addressAggregate></addressAggregate>
        <street1></street1>
        <street2></street2>
        <city></city>
        <state></state>
        <countyCode></countyCode>
        <couty></couty>
        <townshipCode></townshipCode>
        <township></township>
        <postalCode></postalCode>
        <country></country>
    </xsl:template>
    
    <xsl:template match="//OLifE" name="beneficiaries">
        <!-- Primary -->
        <primaryBene>
            <xsl:value-of select='//OLifE/Party[@id=//OLifE/Relation[RelationRoleCode[@tc="34"]]/@RelatedObjectID]'/>
        </primaryBene>
    </xsl:template>
</xsl:stylesheet>