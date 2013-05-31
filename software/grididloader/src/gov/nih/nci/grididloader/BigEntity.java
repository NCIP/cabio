/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.grididloader;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * An entity that is to be assigned a Big Ids by the BigIdCreator. 
 * The entity has both a database table and a corresponding model class. 
 * It also has a composite unique key <i>that is different from its 
 * generated primary key</i>. This is important because the generated primary 
 * keys can change between data loads, and the Big Id must be tied to object 
 * identity.
 */
/**
 * @author caBIO Team
 * @version 1.0
 */
public class BigEntity {
    
    private static final String ALIAS_SEPARATOR = "_";
    
    private String tableName;
    private String packageName;
    private String className;
    private String primaryKey;
    private String[] attributes;
    private boolean isParallelLoadable;
    
    /** A list of any joins that need to be made to retrieve all the fields
     *  in the unique key */
    private Collection<Join> joins;
   
    public BigEntity(String tableName, String packageName, String className,
            String primaryKey, String[] attributes, Collection<Join> joins,
            boolean isParallelLoadable) {
        
        this.tableName = tableName;
        this.packageName = packageName;
        this.primaryKey = primaryKey;
        this.className = className;
        this.attributes = attributes;
        this.joins = joins;
        this.isParallelLoadable = isParallelLoadable;
    }
    
    /**
     * Returns a collection of Joins used to get attributes for the unique key.
     * @return
     */
    public Collection<Join> getJoins() {
        return joins;
    }
    
    /** 
     * Returns the package qualified Java class name for this entity. 
     */
    public String getClassName() {
        return className;
    }

    /** 
     * Returns the package qualified Java class name for this entity. 
     */
    public String getPackageName() {
        return packageName;
    }

    /** 
     * Returns the package qualified Java class name for this entity. 
     */
    public String getQualifiedClassName() {
        return packageName+"."+className;
    }
    
    /** 
     *  Returns the name of the database table that maps to this entity.
     */
    public String getTableName() {
        return tableName;
    }
    
    /** 
     * Returns the primary key column name.
     */
    public String getPrimaryKey() {
        return primaryKey;
    }

    /** 
     * Returns the unique key column names which are in the table (not joined).
     */
    public String[] getAttributes() {
        return attributes;
    }

    /**
     * Returns true if we are allowed to load this entity in parallel.
     */
    public boolean isParallelLoadable() {
        return isParallelLoadable;
    }

    @Override
    public String toString() {
        return getClassName();
    }

    /**
     * Returns a comma delimited list of qualified attributes (with aliases)
     * that must be selected for this entity. This method is called on each
     * joined entity, which produces its own list, and those are appended here. 
     */
    public String getSelectSQL() {
        
        StringBuffer sql = new StringBuffer();
        sql.append(tableName);
        sql.append(".");
        sql.append(primaryKey);
        sql.append(" ");
        sql.append(getAlias(tableName)); 
        sql.append(ALIAS_SEPARATOR);
        sql.append(getAlias(primaryKey)); // alias <table>_<column>
        
        for(String attr : attributes) {
            sql.append(", ");
            sql.append(tableName);
            sql.append(".");
            sql.append(attr);
            sql.append(" ");
            sql.append(getAlias(tableName)); 
            sql.append(ALIAS_SEPARATOR); 
            sql.append(getAlias(attr)); // alias <table>_<column>
        }
        
        for(Join join : joins) {
            if (join instanceof TableJoin) {
                TableJoin tjoin = (TableJoin)join;
                for(String attr : tjoin.getAttributes()) {
                    sql.append(", ");
                    sql.append(getTableAlias(tjoin));
                    sql.append(".");
                    sql.append(attr);
                    sql.append(" ");
                    sql.append(getTableAlias(tjoin)); 
                    sql.append(ALIAS_SEPARATOR); 
                    sql.append(getAlias(attr)); // alias <table>_<column>
                }
            }
            else {
                sql.append(", ");
                EntityJoin ejoin = (EntityJoin)join;
                sql.append(ejoin.getEntity().getSelectSQL());
            }
        }
        
        return sql.toString();
    }
    
    /**
     * Returns a comma delimited list of tables that must be joined to get
     * the entire unique key for this entity.
     */
    public String getFromSQL() {
        StringBuffer sql = new StringBuffer(tableName);

        for(Join join : joins) {
            sql.append(", ");
            if (join instanceof TableJoin) {
                TableJoin tjoin = (TableJoin)join;
                sql.append(tjoin.getForeignTable());
                sql.append(" ");
                sql.append(getTableAlias(tjoin));
            }
            else {
                sql.append(((EntityJoin)join).getEntity().getFromSQL());
            }
        }
        
        return sql.toString();
    }

    /**
     * Returns the clauses necessary for joining.
     */
    public String getWhereSQL() {
        StringBuffer sql = new StringBuffer();
        
        int i = 0;
        for(Join join : joins) {
            if (i++ > 0) sql.append(" AND ");
            if (join instanceof TableJoin) {
                TableJoin tjoin = (TableJoin)join;
                sql.append(getTableName());
                sql.append(".");
                sql.append(tjoin.getForeignKey());
                sql.append(" = ");
                sql.append(getTableAlias(tjoin));
                sql.append(".");
                sql.append(tjoin.getForeignTablePK());
                // TODO: make outer joins optional
                sql.append(" (+)");
            }
            else {
                // first join to the entity table
                EntityJoin ejoin = (EntityJoin)join;
                BigEntity foreignEntity = ejoin.getEntity();
                sql.append(getTableName());
                sql.append(".");
                sql.append(ejoin.getForeignKey());
                sql.append(" = ");
                sql.append(foreignEntity.getTableName());
                sql.append(".");
                sql.append(foreignEntity.getPrimaryKey());
                // TODO: make outer joins optional
                sql.append(" (+) ");

                // now get the joins in the foreign entity
                String foreignJoins = foreignEntity.getWhereSQL();
                if (!"".equals(foreignJoins)) {
                    sql.append("AND ");
                    sql.append(foreignJoins);
                }
            }
        }

        return sql.toString();
    }

    /**
     * Returns the alias of the primary key for this table.
     * @return
     */
    public String getPrimaryKeyAlias() {
        return getAlias(tableName)+ALIAS_SEPARATOR+getAlias(primaryKey);
    }
    
    /**
     * Returns a list of aliases that form the unique key. These aliases can 
     * be retrived after execution of the generated SQL. 
     * @return
     */
    public List<String> getUniqueKeyAliases() {
        List<String> aliases = new ArrayList<String>();

        // add all local attributes
        for(String attr : attributes) {
            aliases.add(getAlias(tableName) + ALIAS_SEPARATOR + getAlias(attr));
        }

        for(Join join : joins) {
            if (join instanceof TableJoin) {
                TableJoin tjoin = (TableJoin)join;
                // add all the attributes we need from this table
                for(String attr : tjoin.getAttributes()) {
                    aliases.add(getTableAlias(tjoin) +
                            ALIAS_SEPARATOR + getAlias(attr));
                }
            }
            else {
                // get aliases from the entity
                aliases.addAll(((EntityJoin)join).getEntity().getUniqueKeyAliases());
            }
        }
        return aliases;
    }
    
    /**
     * Returns a deterministic short alias for the given identifier.
     * @param identifier
     * @return
     */
    private String getAlias(String identifier) {
        StringBuffer sb = new StringBuffer();
        for(String part : identifier.split("_")) {
            sb.append(part.charAt(0));
        }
        sb.append(identifier.length());
        return sb.toString();
    }

    /**
     * Returns an alias for the table being joined to the specified 
     * foreign key.
     * @param tableName name of the table being joined
     * @param foreignKey name of the foreign key being joined with
     * @return a unique alias
     */
    private String getTableAlias(TableJoin tjoin) {
        StringBuffer sb = new StringBuffer();
        sb.append(getAlias(tjoin.getForeignTable()));
        sb.append("_");
        sb.append(getAlias(tjoin.getForeignKey()));
        return sb.toString();
    }
    
    /**
     * A join or set of joins to other tables.
     */
    public static interface Join {
        public String getForeignKey();
    }
    
    /**
     * A join to another table.
     */
    public static class TableJoin implements Join {
        private String foreignKey;
        private String foreignTable;
        private String foreignTablePK;
        private Collection<String> attributes = new ArrayList<String>();
        
        TableJoin(String foreignKey, String foreignTable, 
                String foreignTablePK) {
            this.foreignKey = foreignKey;
            this.foreignTable = foreignTable;
            this.foreignTablePK = foreignTablePK;
        }
        
        /**
         * Returns the foreign key to join on.
         */
        public String getForeignKey() {
            return foreignKey;
        }

        /**
         * Returns the foreign table to join to.
         */
        public String getForeignTable() {
            return foreignTable;
        }
        
        /**
         * Returns the primary key column of the joined table.
         */
        public String getForeignTablePK() {
            return foreignTablePK;
        }
        
        /**
         * Returns the attributes that we are joining to get.
         */
        public Collection<String> getAttributes() {
            return attributes;
        }

        /**
         * Add an attribute for this join.
         */
        void addAttribute(String attribute) {
            attributes.add(attribute);
        }
    }

    /**
     * A join to another entity, to get its entire unique key (may include 
     * further joins).
     */
    public static class EntityJoin implements Join {
        private String foreignKey;
        private BigEntity entity;
        
        EntityJoin(String foreignKey, BigEntity entity) {
            this.foreignKey = foreignKey;
            this.entity = entity;
        }

        /**
         * Returns the foreign key to join on.
         */
        public String getForeignKey() {
            return foreignKey;
        }
        
        /**
         * Returns the entity we are taking attributes from.
         * @return
         */
        public BigEntity getEntity() {
            return entity;
        }
    }
}
