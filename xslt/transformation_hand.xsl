<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:f="http://www.faustedition.net/ns"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    
    
    <xsl:mode on-no-match="shallow-copy"/>
    
    <!--  Problem Index 26, 27, 28  -->
    <xsl:template match="line//app">
        <xsl:for-each select="lem|rdg">
            <xsl:copy>                     
                <xsl:attribute name="hand">                     
                    <xsl:choose>                    
                        <xsl:when test="@hand|@resp">
                            <xsl:value-of select="@hand|@resp"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="preceding::handShift[1]/[@new]"/>
                        </xsl:otherwise>
                    </xsl:choose> 
                </xsl:attribute>
                <xsl:apply-templates/>
                
            </xsl:copy>
        </xsl:for-each>        
    </xsl:template>
    

    
</xsl:stylesheet>
