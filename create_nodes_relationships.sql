--------ITEM
--------\copy (SELECT 'i'||item_id as item_id,item_source_id,size,date,checksum,platform,pipeline,source_url,regexp_replace(local_url, E'\\n','') as local_url,'Item' as label FROM public.item) TO '../neo4j-community-3.4.1/import/gcm_entities/item.csv' WITH (DELIMITER '+', FORMAT CSV, FORCE_QUOTE (item_source_id,date,checksum,platform,pipeline,source_url,local_url));
--------ITEMWITH contentType
\copy (SELECT 'i'||item_id as item_id,item_source_id,size,date,checksum,content_type,platform,pipeline,source_url,regexp_replace(local_url, E'\\n','') as local_url,'Item' as label FROM public.item) TO '../neo4j-community-3.4.1/import/gcm_entities/item.csv' WITH (DELIMITER '+', FORMAT CSV, FORCE_QUOTE (item_source_id,date,checksum,content_type,platform,pipeline,source_url,local_url));
--------ITEM2EXPERIMENT
\copy (SELECT 'i'||item_id as item_id,'e'||experiment_type_id as experiment_type_id,'Item2ExperimentType' as label FROM public.item) TO '../neo4j-community-3.4.1/import/gcm_entities/item2experiment.csv' WITH (DELIMITER '+', FORMAT CSV);
--------ITEM2DATASET
\copy (SELECT 'i'||item_id as item_id,'da'||dataset_id as dataset_id, 'Item2Dataset' as label FROM public.item) TO '../neo4j-community-3.4.1/import/gcm_entities/item2dataset.csv' WITH (DELIMITER '+', FORMAT CSV);
--------ITEM2CASE
\copy (SELECT 'i'||item_id as item_id,'c'||case_id as case_study_id, 'Item2Case' as label FROM public.case2item) TO '../neo4j-community-3.4.1/import/gcm_entities/item2case.csv' WITH (DELIMITER '+', FORMAT CSV);
--------ITEM2REPLICATE
\copy (SELECT 'i'||item_id as item_id,'r'||replicate_id as replicate_id, 'Item2Replicate' as label FROM public.replicate2item) TO '../neo4j-community-3.4.1/import/gcm_entities/item2replicate.csv' WITH (DELIMITER '+', FORMAT CSV);
--------EXPERIMENTTYPE
\copy (SELECT 'e'||experiment_type_id as experiment_type_id,technique,feature,target,antibody, 'ExperimentType' as label  FROM public.experiment_type) TO '../neo4j-community-3.4.1/import/gcm_entities/experiment_type.csv' WITH (DELIMITER '+', FORMAT CSV, FORCE_QUOTE (technique,feature,target,antibody));
--------DATASET
\copy (SELECT 'da'||dataset_id as dataset_id,regexp_replace(name, E'\\n','') as name,data_type,format,assembly,is_ann,CASE WHEN name ilike '%GENCODE%' THEN 'GENCODE' WHEN name ilike '%REFSEQ%' THEN 'REFSEQ' WHEN name ilike '%CISTROME%' THEN 'CISTROME' WHEN name ilike '%\_ENCODE%' THEN 'ENCODE' WHEN name ilike 'GRCh38_TCGA%' THEN 'GDC' WHEN name ilike '%ROADMAP_EPIGENOMICS%' THEN 'ROADMAP_EPIGENOMICS' WHEN name ilike '%TAD%' THEN ' TAD'WHEN name ilike 'HG19_TCGA%' THEN 'TCGA' ELSE 'other' END as source, 'Dataset' as label  FROM public.dataset) TO '../neo4j-community-3.4.1/import/gcm_entities/dataset.csv' WITH (DELIMITER '+', FORMAT CSV, FORCE_QUOTE (name, data_type,format,assembly,source));
--------CASE
\copy (SELECT 'c'||case_study_id as case_study_id,case_source_id as case_study_source_id,source_site,external_ref, 'CaseStudy' as label FROM public.case_study) TO '../neo4j-community-3.4.1/import/gcm_entities/case_study.csv' WITH (DELIMITER '+', FORMAT CSV, FORCE_QUOTE (case_study_source_id,source_site,external_ref));
--------REPLICATE
\copy (SELECT 'r'||replicate_id as replicate_id,replicate_source_id,bio_replicate_num,bio_replicate_num||'_'||tech_replicate_num, 'Replicate' as label  FROM public.replicate) TO '../neo4j-community-3.4.1/import/gcm_entities/replicate.csv' WITH (DELIMITER '+', FORMAT CSV, FORCE_QUOTE (replicate_source_id));
--------CASE2PROJECT
\copy (SELECT 'c'||case_study_id as case_study_id,'pr'||project_id as project_id, 'Case2Project' as label  FROM public.case_study) TO '../neo4j-community-3.4.1/import/gcm_entities/case2project.csv' WITH (DELIMITER '+', FORMAT CSV);
--------PROJECT
\copy (SELECT 'pr'||project_id,project_name,program_name, 'Project' as label  FROM public.project) TO '../neo4j-community-3.4.1/import/gcm_entities/project.csv' WITH (DELIMITER '+', FORMAT CSV, FORCE_QUOTE (project_name,program_name));
--------REPLICATE2BIOSAMPLE
\copy (SELECT 'r'||replicate_id as replicate_id, 'b'||biosample_id as biosample_id, 'Replicate2Biosample' as label  FROM public.replicate) TO '../neo4j-community-3.4.1/import/gcm_entities/replicate2biosample.csv' WITH (DELIMITER '+', FORMAT CSV);
--------BIOSAMPLE
\copy (SELECT 'b'||biosample_id as biosample_id,biosample_source_id,type,tissue,cell_line,is_healthy,disease, 'Biosample' as label  FROM public.biosample)  TO '../neo4j-community-3.4.1/import/gcm_entities/biosample.csv' WITH (DELIMITER '+', FORMAT CSV, FORCE_QUOTE (biosample_source_id, type, tissue, cell_line,disease));
--------BIOSAMPLE2DONOR
\copy (SELECT 'b'||biosample_id as biosample_id,'do'||donor_id as donor_id, 'Biosample2Donor' as label  FROM public.biosample) TO '../neo4j-community-3.4.1/import/gcm_entities/biosample2donor.csv' WITH (DELIMITER '+', FORMAT CSV);
--------DONOR
\copy (SELECT 'do'||donor_id as donor_id,donor_source_id,species,age,gender,ethnicity, 'Donor' as label  FROM public.donor)  TO '../neo4j-community-3.4.1/import/gcm_entities/donor.csv' WITH (DELIMITER '+', FORMAT CSV, FORCE_QUOTE (donor_source_id, species, ethnicity));
--------RELATION_HAS_TID
\copy (SELECT 'i'||item_id as id,'platform' as onto_attribute,'tid'||platform_tid as tid,'HasTid' as label FROM public.item where platform_tid is not null UNION ALL SELECT 'do'||donor_id as id,'species' as onto_attribute,'tid'||species_tid as tid,'HasTid' as label FROM public.donor where species_tid is not null  UNION ALL SELECT 'do'||donor_id as id,'ethnicity' as onto_attribute,'tid'||ethnicity_tid as tid,'HasTid' as label FROM public.donor where ethnicity_tid is not null  UNION ALL SELECT 'i'||item_id as id,'content_type' as onto_attribute,'tid'||content_type_tid as tid,'HasTid' as label FROM public.item where content_type_tid is not null UNION ALL SELECT 'b'||biosample_id as id,'tissue' as onto_attribute,'tid'||tissue_tid as tid,'HasTid' as label FROM public.biosample where tissue_tid is not null  UNION ALL SELECT 'b'||biosample_id as id,'cell' as onto_attribute,'tid'||cell_line_tid as tid,'HasTid' as label FROM public.biosample where cell_line_tid is not null UNION ALL SELECT 'b'||biosample_id as id,'disease' as onto_attribute,'tid'||disease_tid as tid,'HasTid' as label FROM public.biosample where disease_tid is not null  UNION ALL SELECT 'e'||experiment_type_id as id,'technique' as onto_attribute,'tid'||technique_tid as tid,'HasTid' as label FROM public.experiment_type where technique_tid is not null  UNION ALL SELECT 'e'||experiment_type_id as id,'feature' as onto_attribute,'tid'||feature_tid as tid,'HasTid' as label FROM public.experiment_type where feature_tid is not null  UNION ALL SELECT 'e'||experiment_type_id as id,'target' as onto_attribute,'tid'||target_tid as tid,'HasTid' as label FROM public.experiment_type where target_tid is not null) TO '../neo4j-community-3.4.1/import/gcm_entities/has_tid.csv' WITH (DELIMITER '+', FORMAT CSV, FORCE_QUOTE (onto_attribute));
--------VOCABULARY
\copy (SELECT 'tid'||tid as tid,source,code,pref_label,regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(description, E'\\n\\n',' '), E'\\n',' ','g'), E'\\s\\n',' '), E'.\\n','.'), E'^\\s','') as description,iri, 'Vocabulary' as label FROM public.vocabulary) TO '../neo4j-community-3.4.1/import/gcm_entities/vocabulary.csv' WITH (DELIMITER '+', FORMAT CSV, FORCE_QUOTE (source,code,pref_label,description,iri));
-------RELATION_FROM_ONTOLOGY
\copy (SELECT 'tid'||tid as tid,source,'FromOntology' as label FROM public.vocabulary) TO '../neo4j-community-3.4.1/import/gcm_entities/from_ontology.csv' WITH (DELIMITER '+', FORMAT CSV);
-------ONTOLOGY
\copy (SELECT source,title,description,url,'Ontology' as label FROM public.ontology) TO '../neo4j-community-3.4.1/import/gcm_entities/ontology.csv' WITH (DELIMITER '+', FORMAT CSV, FORCE_QUOTE (title,description,url));
-------RELATION_HAS_SYNONYM
\copy (SELECT 'tid'||tid as tid,'s'||synonym_id as synonym_id,'HasSynonym' as label FROM public.synonym) TO '../neo4j-community-3.4.1/import/gcm_entities/has_synonym.csv' WITH (DELIMITER '+', FORMAT CSV);
-------SYNONYM
\copy (SELECT 's'||synonym_id as synonym_id,label,'Synonym' as label FROM public.synonym where type not ilike 'related' and type not ilike 'raw') TO '../neo4j-community-3.4.1/import/gcm_entities/synonym.csv' WITH (DELIMITER '+', FORMAT CSV, FORCE_QUOTE (label));
-------RELATION_HAS_REFERENCE
\copy (SELECT 'tid'||tid as tid,'x'||reference_id as reference_id,'HasXRef' as label FROM public.reference) TO '../neo4j-community-3.4.1/import/gcm_entities/has_reference.csv' WITH (DELIMITER '+', FORMAT CSV);
-------REFERENCE
\copy (SELECT 'x'||reference_id as reference_id,source,code,'XRef' as label FROM public.reference) TO '../neo4j-community-3.4.1/import/gcm_entities/reference.csv' WITH (DELIMITER '+', FORMAT CSV, FORCE_QUOTE (source,code));
-------RELATION_HAS_RELATIONSHIP
\copy (select 'tid'||tid_child as tid_child,'tid'||tid_parent as tid_parent,rel_type,'HasRelationship' as label from public.relationship) TO '../neo4j-community-3.4.1/import/gcm_entities/has_relationship.csv' WITH (DELIMITER '+', FORMAT CSV, FORCE_QUOTE (rel_type));
------PAIRS
\copy (select 'pa'||I.item_id||'_b' as pair_id, 'gcm_curated__biological_replicate_count' as key, CAST(count(distinct R.bio_replicate_num) as varchar) as value, 'Pair' as label from public.item I natural join replicate2item RI natural join replicate R group by I.item_id UNION ALL select 'pa'||I.item_id||'_t' as pair_id, 'gcm_curated__technical_replicate_count' as key, CAST(count(R.tech_replicate_num) as varchar) as value, 'Pair' as label from public.item I natural join replicate2item RI natural join replicate R group by I.item_id UNION ALL select 'pa'||row_number() OVER () as pair_id,regexp_replace(key, E'@','_') as key, value,'Pair' as label from public.pair order by pair_id asc) TO '../neo4j-community-3.4.1/import/gcm_entities/pair_pre.csv' WITH (DELIMITER '+', FORMAT CSV, FORCE_QUOTE (key,value));
------ITEM2PAIR
\copy (select 'i'||item_id as item_id,'pa'||I.item_id||'_b' as pair_id, 'Item2Pair' as label from public.item I UNION ALL select 'i'||item_id as item_id,'pa'||I.item_id||'_t' as pair_id, 'Item2Pair' as label from public.item I UNION ALL select 'i'||item_id as item_id,'pa'||row_number() OVER () as pair_id, 'Item2Pair' as label from public.pair) TO '../neo4j-community-3.4.1/import/gcm_entities/item2pair.csv' WITH (DELIMITER '+', FORMAT CSV);
