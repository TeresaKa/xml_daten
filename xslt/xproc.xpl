<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
    xmlns:f="http://www.faustedition.net/ns"
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
    
    
    <!-- Ports der Pipeline deklarieren -->
    <p:input port="source"/>
    <p:output port="result"/>
   
    <p:directory-list path="./gsa" include-filter=".*.xml" name="directory"/>
    
    <p:for-each>
        <p:iteration-source select="//c:file"/>
        <p:variable name="filename" select="//c:file/@name"/>
                
        <p:load>
            <p:with-option name="href" select="concat('gsa/', $filename)"/> 
        </p:load>
        
         <!-- Pipelineschritte -->
         <p:xslt name="transform">
             <p:input port="parameters"><p:empty/></p:input>
             <p:input port="stylesheet"><p:document href="transformation.xsl"/></p:input>
         </p:xslt>
    
        <p:xslt>
            <p:input port="parameters"><p:empty/></p:input>
            <p:input port="stylesheet"><p:document href="transformation_hand.xsl"/></p:input>
        </p:xslt>
        
        <p:store>
            <p:with-option name="href" select="concat('output/','transformed_', $filename)"/> 
        </p:store>
    </p:for-each>
    
    <p:identity>
        <p:input port="source">
            <p:pipe port="result" step="directory"/>
        </p:input>
    </p:identity>
   
    
</p:declare-step>
