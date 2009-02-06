<?xml version='1.0'?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1"> 
  
<xsl:output type="xml"/>
  
<xsl:template match="mapping">
    <style>
        table {
            border-collapse: collapse;
        }
        td {
            border: 1px solid #aaa;
            padding: 2px;
        }
        th {
            border: 1px solid #aaa;
            padding: 2px;
            text-align: left;
        }
    </style>
    <h2><xsl:value-of select="@package"/></h2>
    <table>
        <tr>
            <th>Entity</th>
            <th>Table</th>
            <th>Depends on values from</th>
            <th>Depends on Big Id from</th>
        </tr>
        <xsl:apply-templates select="entity"/>
    </table>
</xsl:template>
    
<xsl:template match="entity">
    <tr>
        <td><xsl:value-of select="@class"/></td>
        <td><xsl:value-of select="@table"/></td>    
        <td>
            <xsl:for-each select="logical-key/property[@entity]">
                <xsl:variable name="refentity" select="@entity"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$refentity"/>
                <xsl:if test="not(preceding::entity[@class=$refentity])">
                    <font color="red" size="2"> (UNDEFINED)</font>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="logical-key/property[@table]">
                <xsl:variable name="reftable" select="@table"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="//entity[@table=$reftable]/@class"/>
                <xsl:if test="not(preceding::entity[@table=$reftable])">
                    <font color="red" size="2">
                        <xsl:value-of select="$reftable"/> (UNDEFINED)
                    </font>
                </xsl:if>
            </xsl:for-each>
        </td>
        <td>
            <xsl:for-each select="logical-key/property[. = 'BIG_ID']">
                <xsl:variable name="reftable" select="@table"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="//entity[@table=$reftable]/@class"/>
                <xsl:if test="not(preceding::entity[@table=$reftable])">
                    <font color="red" size="2">
                        <xsl:value-of select="$reftable"/> (UNDEFINED)
                    </font>
                </xsl:if>
            </xsl:for-each>
        </td>
    </tr>
</xsl:template>
    
</xsl:stylesheet>
