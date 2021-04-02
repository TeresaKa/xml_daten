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
    
    <xsl:key name="inserts_ins" match="line[@type='inter']/f:ins" use="@f:at"/>
    <xsl:key name="inserts_seg" match="line[@type='inter']/seg" use="@f:left"/>

<!--  Problem Index 4 & 5 -->
    <xsl:template match="anchor">
        <xsl:variable name="ids" select="concat('#', @xml:id)"/>
        <xsl:for-each select="key('inserts_ins', $ids)">
            <seg>
                <xsl:attribute name="hand">
                <xsl:value-of select="@hand"/>                      
                </xsl:attribute>
                <xsl:attribute name="xml:id">
                    <xsl:value-of select="@xml:id"/>                   
                </xsl:attribute>
            <xsl:apply-templates/>
            </seg>
        </xsl:for-each>
        
        <xsl:for-each select="key('inserts_seg', $ids)">
            <!--            <xsl:copy-of select="."/>-->
         <xsl:element name="handshift"><xsl:copy-of select="preceding-sibling::handShift/@new"/></xsl:element>
            <seg>
                <xsl:attribute name="hand">
                    <xsl:choose>                    
                        <xsl:when test="@hand|@resp">
                            <xsl:value-of select="@hand|@resp"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="preceding-sibling::handShift/@new"/>
                        </xsl:otherwise>
                    </xsl:choose>                     
                </xsl:attribute>
                <xsl:attribute name="xml:id">
                    <xsl:value-of select="@xml:id"/>                      
                </xsl:attribute>
                <xsl:apply-templates/>
            </seg>
        </xsl:for-each>
    </xsl:template>
    
<!--  Problem Index 15  -->
    <xsl:template match="f:overw">
        <xsl:variable name="prec" select="preceding-sibling::text()"/>
        <xsl:variable name="follow" select="following-sibling::text()"/>
        <xsl:for-each select="f:under|f:over">
            <seg>
                <xsl:attribute name="overw">
                    <xsl:value-of select="name()"/>                      
                </xsl:attribute>      
                <xsl:value-of select="$prec"/> <xsl:value-of select="text()"/> <xsl:value-of select="$follow"/>              
            </seg>           
        </xsl:for-each>
        <xsl:apply-templates/>
    </xsl:template>
    
<!--  Problem Index 38   -->
    <xsl:template match="g">
        <xsl:value-of select="//char[@xml:id=substring-after(current()/@ref, '#')]/mapping"/>       
    </xsl:template>
    
    <xsl:template match="f:ins"/>
    <xsl:template match="seg[@f:left]"/>
    <xsl:template match="line[@type='inter']/handShift"/>
    <xsl:template match="f:over"/>
    <xsl:template match="f:under"/>
    
</xsl:stylesheet>
