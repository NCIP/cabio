/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

DROP TABLE KEYWORD;
DROP TABLE STG_KEYWORD;
DROP TABLE STG_KEYWORD_AGG;

-- Staging table for keywords, truncated before processing each class
CREATE TABLE STG_KEYWORD ( 
    SCORE NUMBER,
    VALUE VARCHAR2(512)
) TABLESPACE CABIO_FUT;

-- Aggregated staging table for keywords across all types. Scores are 
-- inversed (i.e. 1 is the best possible score).
CREATE TABLE STG_KEYWORD_AGG ( 
    SCORE NUMBER NOT NULL,
    VALUE VARCHAR2(512) NOT NULL,
    TYPE VARCHAR2(255) NOT NULL
) TABLESPACE CABIO_FUT;

-- User table with normal scoring (0 is the worst score). Scores are 
-- combined across classes, so TYPE no longer makes sense, since any 
-- given keyword may come from multipe types.
CREATE TABLE KEYWORD ( 
    ID NUMBER NOT NULL,
    SCORE NUMBER NOT NULL,
    VALUE VARCHAR2(512) NOT NULL
) TABLESPACE CABIO_FUT;

ALTER TABLE KEYWORD ADD CONSTRAINT PK_KEYWORD PRIMARY KEY (ID) 
    using index tablespace CABIO_FUT;
