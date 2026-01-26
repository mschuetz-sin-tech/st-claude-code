# Liquibase Changeset Examples

## File Naming Convention

Use sequential numbering with descriptive names:

```
db/changelog/persistent/
├── db.changelog-master.xml           # Main entry point with includes
├── crelux-changesets.xml             # Legacy/initial changesets
├── 00001_compoundplates_fk.xml       # First new changeset
├── 00002_add_supplier_table.xml      # Second new changeset
└── 00003_inventory_indexes.xml       # Third new changeset
```

**Format:** `NNNNN_short_description.xml`
- 5-digit sequential number for clear ordering
- Lowercase with underscores
- Short descriptive name

## Master Changelog with Includes

```xml
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog
        xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
        http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.25.xsd">

    <!-- Initial application changesets -->
    <include file="db/changelog/persistent/crelux-changesets.xml"/>

    <!-- New changesets - add new includes here -->
    <include file="db/changelog/persistent/00001_compoundplates_fk.xml"/>
    <include file="db/changelog/persistent/00002_add_supplier_table.xml"/>

    <!-- Test data - only loaded in local profile -->
    <include file="db/changelog/persistent/local-test-data.xml" context="local"/>

</databaseChangeLog>
```

## New Table with preConditions

Always use `preConditions` with `onFail="MARK_RAN"` for idempotent migrations:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog
        xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
        http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.25.xsd">

    <!-- Table: tbl_compoundplatetypes -->
    <changeSet author="developer (generated)" id="1764348430475-135">
        <preConditions onFail="MARK_RAN">
            <not>
                <tableExists tableName="tbl_compoundplatetypes"/>
            </not>
        </preConditions>
        <createTable tableName="tbl_compoundplatetypes">
            <column autoIncrement="true" name="CompoundPlateTypeID" type="INT">
                <constraints nullable="false" primaryKey="true"/>
            </column>
            <column name="CompoundPlateTypeName" type="VARCHAR(50)">
                <constraints unique="true"/>
            </column>
            <column name="timestamp" type="TIMESTAMP(0)" defaultValueComputed="current_timestamp()">
                <constraints nullable="false"/>
            </column>
            <column name="Is_Deleted" type="TINYINT" defaultValueNumeric="0"/>
        </createTable>
    </changeSet>

</databaseChangeLog>
```

## Foreign Key Constraint

```xml
<changeSet author="developer (generated)" id="1764348430475-1539">
    <preConditions onFail="MARK_RAN">
        <not>
            <foreignKeyConstraintExists foreignKeyName="fk_plates_platetypes"/>
        </not>
    </preConditions>
    <addForeignKeyConstraint
        baseColumnNames="PlateTypeID"
        baseTableName="tbl_compoundplates"
        constraintName="fk_plates_platetypes"
        deferrable="false"
        initiallyDeferred="false"
        onDelete="RESTRICT"
        onUpdate="RESTRICT"
        referencedColumnNames="CompoundPlateTypeID"
        referencedTableName="tbl_compoundplatetypes"
        validate="true"/>
</changeSet>
```

## Initial Data Insert

Use `sqlCheck` preCondition to avoid duplicate inserts:

```xml
<changeSet author="developer (generated)" id="1764348430475-135-data">
    <preConditions onFail="MARK_RAN">
        <sqlCheck expectedResult="0">SELECT COUNT(*) FROM tbl_compoundplatetypes</sqlCheck>
    </preConditions>
    <insert tableName="tbl_compoundplatetypes">
        <column name="CompoundPlateTypeID" valueNumeric="1"/>
        <column name="CompoundPlateTypeName" value="Greiner Bio-One-PP"/>
        <column name="Is_Deleted" valueNumeric="0"/>
    </insert>
    <insert tableName="tbl_compoundplatetypes">
        <column name="CompoundPlateTypeID" valueNumeric="11"/>
        <column name="CompoundPlateTypeName" value="Echo PP"/>
        <column name="Is_Deleted" valueNumeric="0"/>
    </insert>
</changeSet>
```

## Critical Rules

1. **Never modify existing changesets** - Liquibase tracks checksums. Any change to an already-executed changeset causes deployment failures.

2. **Always create new files** - When adding schema changes, create a new numbered file instead of modifying existing ones.

3. **Use preConditions** - Makes migrations idempotent and safe to run multiple times.

4. **Keep changesets atomic** - One logical change per changeset for easier rollback and debugging.
