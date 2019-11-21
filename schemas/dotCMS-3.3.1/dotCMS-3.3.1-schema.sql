PGDMP     8                     w            dotcms    9.6.11    9.6.11    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            �           1262    59531    dotcms    DATABASE     x   CREATE DATABASE dotcms WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE dotcms;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    3                        3079    13311    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            �           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1            �           1255    61230 !   bigIntBoolResult(boolean, bigint)    FUNCTION     �   CREATE FUNCTION public."bigIntBoolResult"("boolParam" boolean, "intParam" bigint) RETURNS boolean
    LANGUAGE sql
    AS $_$select case
		WHEN $1 AND $2 != 0 then true
		WHEN $1 != true AND $2 = 0 then true
		ELSE false
	END$_$;
 Q   DROP FUNCTION public."bigIntBoolResult"("boolParam" boolean, "intParam" bigint);
       public       dotcmsdbuser    false    3            �           1255    61229 !   boolBigIntResult(bigint, boolean)    FUNCTION     �   CREATE FUNCTION public."boolBigIntResult"("intParam" bigint, "boolParam" boolean) RETURNS boolean
    LANGUAGE sql
    AS $_$select case
		WHEN $2 AND $1 != 0 then true
		WHEN $2 != true AND $1 = 0 then true
		ELSE false
	END$_$;
 Q   DROP FUNCTION public."boolBigIntResult"("intParam" bigint, "boolParam" boolean);
       public       dotcmsdbuser    false    3            �           1255    61225    boolIntResult(integer, boolean)    FUNCTION     �   CREATE FUNCTION public."boolIntResult"("intParam" integer, "boolParam" boolean) RETURNS boolean
    LANGUAGE sql
    AS $_$select case
		WHEN $2 AND $1 != 0 then true
		WHEN $2 != true AND $1 = 0 then true
		ELSE false
	END$_$;
 O   DROP FUNCTION public."boolIntResult"("intParam" integer, "boolParam" boolean);
       public       dotcmsdbuser    false    3            �           1255    61271    check_child_assets()    FUNCTION     �  CREATE FUNCTION public.check_child_assets() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
   pathCount integer;
BEGIN
   IF (tg_op = 'DELETE') THEN
      IF(OLD.asset_type ='folder') THEN
	   select count(*) into pathCount from identifier where parent_path = OLD.parent_path||OLD.asset_name||'/'  and host_inode = OLD.host_inode;
	END IF;
	IF(OLD.asset_type ='contentlet') THEN
	   select count(*) into pathCount from identifier where host_inode = OLD.id;
	END IF;
	IF (pathCount > 0 )THEN
	  RAISE EXCEPTION 'Cannot delete as this path has children';
	  RETURN NULL;
	ELSE
	  RETURN OLD;
	END IF;
   END IF;
   RETURN NULL;
END
$$;
 +   DROP FUNCTION public.check_child_assets();
       public       dotcmsdbuser    false    3    1            �           1255    61321    check_template_id()    FUNCTION     �  CREATE FUNCTION public.check_template_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
   templateId varchar(100);
BEGIN
   IF (tg_op = 'INSERT' OR tg_op = 'UPDATE') THEN
  	 select id into templateId from identifier where asset_type='template' and id = NEW.template_id;
  	 IF FOUND THEN
          RETURN NEW;
	 ELSE
	    RAISE EXCEPTION 'Template Id should be the identifier of a template';
	    RETURN NULL;
	 END IF;
   END IF;
   RETURN NULL;
END
$$;
 *   DROP FUNCTION public.check_template_id();
       public       dotcmsdbuser    false    3    1            �           1255    61263    container_versions_check()    FUNCTION     �  CREATE FUNCTION public.container_versions_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
	versionsCount integer;
  BEGIN
  IF (tg_op = 'DELETE') THEN
    select count(*) into versionsCount from containers where identifier = OLD.identifier;
    IF (versionsCount = 0)THEN
	DELETE from identifier where id = OLD.identifier;
    ELSE
	RETURN OLD;
    END IF;
  END IF;
RETURN NULL;
END
$$;
 1   DROP FUNCTION public.container_versions_check();
       public       dotcmsdbuser    false    3    1            �           1255    61259    content_versions_check()    FUNCTION     �  CREATE FUNCTION public.content_versions_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
   DECLARE
       versionsCount integer;
   BEGIN
       IF (tg_op = 'DELETE') THEN
         select count(*) into versionsCount from contentlet where identifier = OLD.identifier;
         IF (versionsCount = 0)THEN
		DELETE from identifier where id = OLD.identifier;
	   ELSE
	      RETURN OLD;
	   END IF;
	END IF;
   RETURN NULL;
   END
  $$;
 /   DROP FUNCTION public.content_versions_check();
       public       dotcmsdbuser    false    1    3            �           1255    61339    dotfolderpath(text, text)    FUNCTION     �   CREATE FUNCTION public.dotfolderpath(parent_path text, asset_name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF(parent_path='/System folder') THEN
    RETURN '/';
  ELSE
    RETURN parent_path || asset_name || '/';
  END IF;
END;$$;
 G   DROP FUNCTION public.dotfolderpath(parent_path text, asset_name text);
       public       dotcmsdbuser    false    3    1            �           1255    61257    file_versions_check()    FUNCTION     �  CREATE FUNCTION public.file_versions_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
   DECLARE
	 versionsCount integer;
   BEGIN
	IF (tg_op = 'DELETE') THEN
          select count(*) into versionsCount from file_asset where identifier = OLD.identifier;
          IF (versionsCount = 0)THEN
             DELETE from identifier where id = OLD.identifier;
          ELSE
             RETURN OLD;
          END IF;
       END IF;
    RETURN NULL;
  END
$$;
 ,   DROP FUNCTION public.file_versions_check();
       public       dotcmsdbuser    false    3    1            �           1255    61323    folder_identifier_check()    FUNCTION     �  CREATE FUNCTION public.folder_identifier_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
   versionsCount integer;
BEGIN
   IF (tg_op = 'DELETE') THEN
      select count(*) into versionsCount from folder where identifier = OLD.identifier;
	IF (versionsCount = 0)THEN
	  DELETE from identifier where id = OLD.identifier;
	ELSE
	  RETURN OLD;
	END IF;
   END IF;
   RETURN NULL;
END
$$;
 0   DROP FUNCTION public.folder_identifier_check();
       public       dotcmsdbuser    false    3    1            �           1255    61267    htmlpage_versions_check()    FUNCTION     �  CREATE FUNCTION public.htmlpage_versions_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
	versionsCount integer;
  BEGIN
  IF (tg_op = 'DELETE') THEN
    select count(*) into versionsCount from htmlpage where identifier = OLD.identifier;
    IF (versionsCount = 0)THEN
	DELETE from identifier where id = OLD.identifier;
    ELSE
	RETURN OLD;
    END IF;
  END IF;
RETURN NULL;
END
$$;
 0   DROP FUNCTION public.htmlpage_versions_check();
       public       dotcmsdbuser    false    3    1            �           1255    61233    identifier_host_inode_check()    FUNCTION     �  CREATE FUNCTION public.identifier_host_inode_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	inodeType varchar(100);
BEGIN
  IF (tg_op = 'INSERT' OR tg_op = 'UPDATE') AND substr(NEW.asset_type, 0, 8) <> 'content' AND
		(NEW.host_inode IS NULL OR NEW.host_inode = '') THEN
		RAISE EXCEPTION 'Cannot insert/update a null or empty host inode for this kind of identifier';
		RETURN NULL;
  ELSE
		RETURN NEW;
  END IF;

  RETURN NULL;
END
$$;
 4   DROP FUNCTION public.identifier_host_inode_check();
       public       dotcmsdbuser    false    3    1            �           1255    61269    identifier_parent_path_check()    FUNCTION     �  CREATE FUNCTION public.identifier_parent_path_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 DECLARE
    folderId varchar(100);
  BEGIN
     IF (tg_op = 'INSERT' OR tg_op = 'UPDATE') THEN
      IF(NEW.parent_path='/') OR (NEW.parent_path='/System folder') THEN
        RETURN NEW;
     ELSE
      select id into folderId from identifier where asset_type='folder' and host_inode = NEW.host_inode and parent_path||asset_name||'/' = NEW.parent_path and id <> NEW.id;
      IF FOUND THEN
        RETURN NEW;
      ELSE
        RAISE EXCEPTION 'Cannot insert/update for this path does not exist for the given host';
        RETURN NULL;
      END IF;
     END IF;
    END IF;
RETURN NULL;
END
  $$;
 5   DROP FUNCTION public.identifier_parent_path_check();
       public       dotcmsdbuser    false    3    1            �           1255    61226    intBoolResult(boolean, integer)    FUNCTION     �   CREATE FUNCTION public."intBoolResult"("boolParam" boolean, "intParam" integer) RETURNS boolean
    LANGUAGE sql
    AS $_$select case
		WHEN $1 AND $2 != 0 then true
		WHEN $1 != true AND $2 = 0 then true
		ELSE false
	END$_$;
 O   DROP FUNCTION public."intBoolResult"("boolParam" boolean, "intParam" integer);
       public       dotcmsdbuser    false    3            �           1255    61261    link_versions_check()    FUNCTION     �  CREATE FUNCTION public.link_versions_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
	versionsCount integer;
  BEGIN
  IF (tg_op = 'DELETE') THEN
    select count(*) into versionsCount from links where identifier = OLD.identifier;
    IF (versionsCount = 0)THEN
	DELETE from identifier where id = OLD.identifier;
    ELSE
	RETURN OLD;
    END IF;
  END IF;
RETURN NULL;
END
$$;
 ,   DROP FUNCTION public.link_versions_check();
       public       dotcmsdbuser    false    3    1            �           1259    61124    dist_reindex_journal    TABLE     �  CREATE TABLE public.dist_reindex_journal (
    id bigint NOT NULL,
    inode_to_index character varying(100) NOT NULL,
    ident_to_index character varying(100) NOT NULL,
    serverid character varying(64),
    priority integer NOT NULL,
    time_entered timestamp without time zone DEFAULT ('now'::text)::date NOT NULL,
    index_val character varying(325),
    dist_action integer DEFAULT 1 NOT NULL
);
 (   DROP TABLE public.dist_reindex_journal;
       public         dotcmsdbuser    false    3            �           1255    61256 :   load_records_to_index(character varying, integer, integer)    FUNCTION     4  CREATE FUNCTION public.load_records_to_index(server_id character varying, records_to_fetch integer, priority_level integer) RETURNS SETOF public.dist_reindex_journal
    LANGUAGE plpgsql
    AS $$
DECLARE
   dj dist_reindex_journal;
BEGIN

    FOR dj IN SELECT * FROM dist_reindex_journal
       WHERE serverid IS NULL
       AND priority <= priority_level
       ORDER BY priority ASC
       LIMIT records_to_fetch
       FOR UPDATE
    LOOP
        UPDATE dist_reindex_journal SET serverid=server_id WHERE id=dj.id;
        RETURN NEXT dj;
    END LOOP;

END$$;
 {   DROP FUNCTION public.load_records_to_index(server_id character varying, records_to_fetch integer, priority_level integer);
       public       dotcmsdbuser    false    386    3    1            �           1255    61337    rename_folder_and_assets()    FUNCTION     �  CREATE FUNCTION public.rename_folder_and_assets() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
   old_parent_path varchar(100);
   old_path varchar(100);
   new_path varchar(100);
   old_name varchar(100);
   hostInode varchar(100);
BEGIN
   IF (tg_op = 'UPDATE' AND NEW.name<>OLD.name) THEN
      select asset_name,parent_path,host_inode INTO old_name,old_parent_path,hostInode from identifier where id = NEW.identifier;
      old_path := old_parent_path || old_name || '/';
      new_path := old_parent_path || NEW.name || '/';
      UPDATE identifier SET asset_name = NEW.name where id = NEW.identifier;
      PERFORM renameFolderChildren(old_path,new_path,hostInode);
      RETURN NEW;
   END IF;
RETURN NULL;
END
$$;
 1   DROP FUNCTION public.rename_folder_and_assets();
       public       dotcmsdbuser    false    3    1            �           1255    61336 M   renamefolderchildren(character varying, character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.renamefolderchildren(old_path character varying, new_path character varying, hostinode character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   fi identifier;
   new_folder_path varchar(100);
   old_folder_path varchar(100);
BEGIN
    UPDATE identifier SET  parent_path  = new_path where parent_path = old_path and host_inode = hostInode;
    FOR fi IN select * from identifier where asset_type='folder' and parent_path = new_path and host_inode = hostInode LOOP
	 new_folder_path := new_path ||fi.asset_name||'/';
	 old_folder_path := old_path ||fi.asset_name||'/';
	 PERFORM renameFolderChildren(old_folder_path,new_folder_path,hostInode);
    END LOOP;
END
$$;
 �   DROP FUNCTION public.renamefolderchildren(old_path character varying, new_path character varying, hostinode character varying);
       public       dotcmsdbuser    false    3    1            �           1255    61254    structure_host_folder_check()    FUNCTION     T  CREATE FUNCTION public.structure_host_folder_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    folderInode varchar(100);
    hostInode varchar(100);
BEGIN
    IF ((tg_op = 'INSERT' OR tg_op = 'UPDATE') AND (NEW.host IS NOT NULL AND NEW.host <> '' AND NEW.host <> 'SYSTEM_HOST'
          AND NEW.folder IS NOT NULL AND NEW.folder <> 'SYSTEM_FOLDER' AND NEW.folder <> '')) THEN
          select host_inode,folder.inode INTO hostInode,folderInode from folder,identifier where folder.identifier = identifier.id and folder.inode=NEW.folder;
	  IF (FOUND AND NEW.host = hostInode) THEN
		 RETURN NEW;
	  ELSE
		 RAISE EXCEPTION 'Cannot assign host/folder to structure, folder does not belong to given host';
		 RETURN NULL;
	  END IF;
    ELSE
        IF((tg_op = 'INSERT' OR tg_op = 'UPDATE') AND (NEW.host IS NULL OR NEW.host = '' OR NEW.host= 'SYSTEM_HOST'
           OR NEW.folder IS NULL OR NEW.folder = '' OR NEW.folder = 'SYSTEM_FOLDER')) THEN
          IF(NEW.host = 'SYSTEM_HOST' OR NEW.host IS NULL OR NEW.host = '') THEN
             NEW.host = 'SYSTEM_HOST';
             NEW.folder = 'SYSTEM_FOLDER';
          END IF;
          IF(NEW.folder = 'SYSTEM_FOLDER' OR NEW.folder IS NULL OR NEW.folder = '') THEN
             NEW.folder = 'SYSTEM_FOLDER';
          END IF;
        RETURN NEW;
        END IF;
    END IF;
  RETURN NULL;
END
$$;
 4   DROP FUNCTION public.structure_host_folder_check();
       public       dotcmsdbuser    false    1    3            �           1255    61265    template_versions_check()    FUNCTION     �  CREATE FUNCTION public.template_versions_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
	versionsCount integer;
  BEGIN
  IF (tg_op = 'DELETE') THEN
    select count(*) into versionsCount from template where identifier = OLD.identifier;
    IF (versionsCount = 0)THEN
	DELETE from identifier where id = OLD.identifier;
    ELSE
	RETURN OLD;
    END IF;
  END IF;
RETURN NULL;
END
$$;
 0   DROP FUNCTION public.template_versions_check();
       public       dotcmsdbuser    false    3    1            6	           2617    61227    =    OPERATOR     t   CREATE OPERATOR public.= (
    PROCEDURE = public."intBoolResult",
    LEFTARG = boolean,
    RIGHTARG = integer
);
 +   DROP OPERATOR public.= (boolean, integer);
       public       dotcmsdbuser    false    420    3            7	           2617    61228    =    OPERATOR     t   CREATE OPERATOR public.= (
    PROCEDURE = public."boolIntResult",
    LEFTARG = integer,
    RIGHTARG = boolean
);
 +   DROP OPERATOR public.= (integer, boolean);
       public       dotcmsdbuser    false    419    3            8	           2617    61231    =    OPERATOR     v   CREATE OPERATOR public.= (
    PROCEDURE = public."bigIntBoolResult",
    LEFTARG = boolean,
    RIGHTARG = bigint
);
 *   DROP OPERATOR public.= (boolean, bigint);
       public       dotcmsdbuser    false    422    3            9	           2617    61232    =    OPERATOR     v   CREATE OPERATOR public.= (
    PROCEDURE = public."boolBigIntResult",
    LEFTARG = bigint,
    RIGHTARG = boolean
);
 *   DROP OPERATOR public.= (bigint, boolean);
       public       dotcmsdbuser    false    421    3            �            1259    59537 	   abcontact    TABLE     ,  CREATE TABLE public.abcontact (
    contactid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    firstname character varying(100),
    middlename character varying(100),
    lastname character varying(100),
    nickname character varying(100),
    emailaddress character varying(100),
    homestreet character varying(100),
    homecity character varying(100),
    homestate character varying(100),
    homezip character varying(100),
    homecountry character varying(100),
    homephone character varying(100),
    homefax character varying(100),
    homecell character varying(100),
    homepager character varying(100),
    hometollfree character varying(100),
    homeemailaddress character varying(100),
    businesscompany character varying(100),
    businessstreet character varying(100),
    businesscity character varying(100),
    businessstate character varying(100),
    businesszip character varying(100),
    businesscountry character varying(100),
    businessphone character varying(100),
    businessfax character varying(100),
    businesscell character varying(100),
    businesspager character varying(100),
    businesstollfree character varying(100),
    businessemailaddress character varying(100),
    employeenumber character varying(100),
    jobtitle character varying(100),
    jobclass character varying(100),
    hoursofoperation text,
    birthday timestamp without time zone,
    timezoneid character varying(100),
    instantmessenger character varying(100),
    website character varying(100),
    comments text
);
    DROP TABLE public.abcontact;
       public         dotcmsdbuser    false    3            �            1259    59545    abcontacts_ablists    TABLE     �   CREATE TABLE public.abcontacts_ablists (
    contactid character varying(100) NOT NULL,
    listid character varying(100) NOT NULL
);
 &   DROP TABLE public.abcontacts_ablists;
       public         dotcmsdbuser    false    3            �            1259    59548    ablist    TABLE     �   CREATE TABLE public.ablist (
    listid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    name character varying(100)
);
    DROP TABLE public.ablist;
       public         dotcmsdbuser    false    3            �            1259    59553    address    TABLE     �  CREATE TABLE public.address (
    addressid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    username character varying(100),
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    classname character varying(100),
    classpk character varying(100),
    description character varying(100),
    street1 character varying(100),
    street2 character varying(100),
    city character varying(100),
    state character varying(100),
    zip character varying(100),
    country character varying(100),
    phone character varying(100),
    fax character varying(100),
    cell character varying(100),
    priority integer
);
    DROP TABLE public.address;
       public         dotcmsdbuser    false    3            �            1259    59561    adminconfig    TABLE     �   CREATE TABLE public.adminconfig (
    configid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    type_ character varying(100),
    name character varying(100),
    config text
);
    DROP TABLE public.adminconfig;
       public         dotcmsdbuser    false    3            *           1259    60355    analytic_summary    TABLE     �  CREATE TABLE public.analytic_summary (
    id bigint NOT NULL,
    summary_period_id bigint NOT NULL,
    host_id character varying(36) NOT NULL,
    visits bigint,
    page_views bigint,
    unique_visits bigint,
    new_visits bigint,
    direct_traffic bigint,
    referring_sites bigint,
    search_engines bigint,
    bounce_rate integer,
    avg_time_on_site timestamp without time zone
);
 $   DROP TABLE public.analytic_summary;
       public         dotcmsdbuser    false    3            3           1259    60425    analytic_summary_404    TABLE     �   CREATE TABLE public.analytic_summary_404 (
    id bigint NOT NULL,
    summary_period_id bigint NOT NULL,
    host_id character varying(36),
    uri character varying(255),
    referer_uri character varying(255)
);
 (   DROP TABLE public.analytic_summary_404;
       public         dotcmsdbuser    false    3            -           1259    60375    analytic_summary_content    TABLE     �   CREATE TABLE public.analytic_summary_content (
    id bigint NOT NULL,
    summary_id bigint NOT NULL,
    inode character varying(255),
    hits bigint,
    uri character varying(255),
    title character varying(255)
);
 ,   DROP TABLE public.analytic_summary_content;
       public         dotcmsdbuser    false    3                       1259    60246    analytic_summary_pages    TABLE     �   CREATE TABLE public.analytic_summary_pages (
    id bigint NOT NULL,
    summary_id bigint NOT NULL,
    inode character varying(255),
    hits bigint,
    uri character varying(255)
);
 *   DROP TABLE public.analytic_summary_pages;
       public         dotcmsdbuser    false    3            (           1259    60343    analytic_summary_period    TABLE     $  CREATE TABLE public.analytic_summary_period (
    id bigint NOT NULL,
    full_date timestamp without time zone,
    day integer,
    week integer,
    month integer,
    year character varying(255),
    dayname character varying(50) NOT NULL,
    monthname character varying(50) NOT NULL
);
 +   DROP TABLE public.analytic_summary_period;
       public         dotcmsdbuser    false    3            P           1259    60622    analytic_summary_referer    TABLE     �   CREATE TABLE public.analytic_summary_referer (
    id bigint NOT NULL,
    summary_id bigint NOT NULL,
    hits bigint,
    uri character varying(255)
);
 ,   DROP TABLE public.analytic_summary_referer;
       public         dotcmsdbuser    false    3            :           1259    60480    analytic_summary_visits    TABLE     �   CREATE TABLE public.analytic_summary_visits (
    id bigint NOT NULL,
    summary_period_id bigint NOT NULL,
    host_id character varying(36),
    visit_time timestamp without time zone,
    visits bigint
);
 +   DROP TABLE public.analytic_summary_visits;
       public         dotcmsdbuser    false    3            K           1259    60591    analytic_summary_workstream    TABLE     N  CREATE TABLE public.analytic_summary_workstream (
    id bigint NOT NULL,
    inode character varying(255),
    asset_type character varying(255),
    mod_user_id character varying(255),
    host_id character varying(36),
    mod_date timestamp without time zone,
    action character varying(255),
    name character varying(255)
);
 /   DROP TABLE public.analytic_summary_workstream;
       public         dotcmsdbuser    false    3            �            1259    59569    bjentries_bjtopics    TABLE     �   CREATE TABLE public.bjentries_bjtopics (
    entryid character varying(100) NOT NULL,
    topicid character varying(100) NOT NULL
);
 &   DROP TABLE public.bjentries_bjtopics;
       public         dotcmsdbuser    false    3            �            1259    59572    bjentries_bjverses    TABLE     �   CREATE TABLE public.bjentries_bjverses (
    entryid character varying(100) NOT NULL,
    verseid character varying(100) NOT NULL
);
 &   DROP TABLE public.bjentries_bjverses;
       public         dotcmsdbuser    false    3            �            1259    59575    bjentry    TABLE     K  CREATE TABLE public.bjentry (
    entryid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    name character varying(100),
    content text,
    versesinput text
);
    DROP TABLE public.bjentry;
       public         dotcmsdbuser    false    3            �            1259    59583    bjtopic    TABLE     9  CREATE TABLE public.bjtopic (
    topicid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    name character varying(100),
    description text
);
    DROP TABLE public.bjtopic;
       public         dotcmsdbuser    false    3            �            1259    59591    bjverse    TABLE     �   CREATE TABLE public.bjverse (
    verseid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    name character varying(100)
);
    DROP TABLE public.bjverse;
       public         dotcmsdbuser    false    3            �            1259    59596    blogscategory    TABLE     ,  CREATE TABLE public.blogscategory (
    categoryid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    name character varying(100)
);
 !   DROP TABLE public.blogscategory;
       public         dotcmsdbuser    false    3            �            1259    59601    blogscomments    TABLE     f  CREATE TABLE public.blogscomments (
    commentsid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    username character varying(100),
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    entryid character varying(100),
    content text
);
 !   DROP TABLE public.blogscomments;
       public         dotcmsdbuser    false    3            �            1259    59609 
   blogsentry    TABLE     �  CREATE TABLE public.blogsentry (
    entryid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    categoryid character varying(100),
    title character varying(100),
    content text,
    displaydate timestamp without time zone,
    sharing boolean,
    commentable boolean,
    propscount integer,
    commentscount integer
);
    DROP TABLE public.blogsentry;
       public         dotcmsdbuser    false    3            �            1259    59617 	   blogslink    TABLE     D  CREATE TABLE public.blogslink (
    linkid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    name character varying(100),
    url character varying(100)
);
    DROP TABLE public.blogslink;
       public         dotcmsdbuser    false    3            �            1259    59625 
   blogsprops    TABLE     d  CREATE TABLE public.blogsprops (
    propsid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    username character varying(100),
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    entryid character varying(100),
    quantity integer
);
    DROP TABLE public.blogsprops;
       public         dotcmsdbuser    false    3            �            1259    59633    blogsreferer    TABLE     �   CREATE TABLE public.blogsreferer (
    entryid character varying(100) NOT NULL,
    url character varying(100) NOT NULL,
    type_ character varying(100) NOT NULL,
    quantity integer
);
     DROP TABLE public.blogsreferer;
       public         dotcmsdbuser    false    3            �            1259    59638 	   blogsuser    TABLE     �   CREATE TABLE public.blogsuser (
    userid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    entryid character varying(100) NOT NULL,
    lastpostdate timestamp without time zone
);
    DROP TABLE public.blogsuser;
       public         dotcmsdbuser    false    3            �            1259    59643    bookmarksentry    TABLE     g  CREATE TABLE public.bookmarksentry (
    entryid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    folderid character varying(100),
    name character varying(100),
    url character varying(100),
    comments text,
    visits integer
);
 "   DROP TABLE public.bookmarksentry;
       public         dotcmsdbuser    false    3            �            1259    59651    bookmarksfolder    TABLE     (  CREATE TABLE public.bookmarksfolder (
    folderid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    parentfolderid character varying(100),
    name character varying(100)
);
 #   DROP TABLE public.bookmarksfolder;
       public         dotcmsdbuser    false    3            �           1259    61635    broken_link    TABLE       CREATE TABLE public.broken_link (
    id character varying(36) NOT NULL,
    inode character varying(36) NOT NULL,
    field character varying(36) NOT NULL,
    link character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    status_code integer NOT NULL
);
    DROP TABLE public.broken_link;
       public         dotcmsdbuser    false    3                       1259    60241    calendar_reminder    TABLE     �   CREATE TABLE public.calendar_reminder (
    user_id character varying(255) NOT NULL,
    event_id character varying(36) NOT NULL,
    send_date timestamp without time zone NOT NULL
);
 %   DROP TABLE public.calendar_reminder;
       public         dotcmsdbuser    false    3            �            1259    59656    calevent    TABLE     �  CREATE TABLE public.calevent (
    eventid character varying(100) NOT NULL,
    groupid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    username character varying(100),
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    title character varying(100),
    description text,
    startdate timestamp without time zone,
    enddate timestamp without time zone,
    durationhour integer,
    durationminute integer,
    allday boolean,
    timezonesensitive boolean,
    type_ character varying(100),
    location character varying(100),
    street character varying(100),
    city character varying(100),
    state character varying(100),
    zip character varying(100),
    phone character varying(100),
    repeating boolean,
    recurrence text,
    remindby character varying(100),
    firstreminder integer,
    secondreminder integer
);
    DROP TABLE public.calevent;
       public         dotcmsdbuser    false    3            �            1259    59664    caltask    TABLE     �  CREATE TABLE public.caltask (
    taskid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    title character varying(100),
    description text,
    noduedate boolean,
    duedate timestamp without time zone,
    priority integer,
    status integer
);
    DROP TABLE public.caltask;
       public         dotcmsdbuser    false    3            M           1259    60604    campaign    TABLE     �  CREATE TABLE public.campaign (
    inode character varying(36) NOT NULL,
    title character varying(255),
    from_email character varying(255),
    from_name character varying(255),
    subject character varying(255),
    message text,
    user_id character varying(255),
    start_date timestamp without time zone,
    completed_date timestamp without time zone,
    active boolean DEFAULT false,
    locked boolean,
    sends_per_hour character varying(15),
    sendemail boolean,
    communicationinode character varying(36),
    userfilterinode character varying(36),
    sendto character varying(15),
    isrecurrent boolean,
    wassent boolean,
    expiration_date timestamp without time zone,
    parent_campaign character varying(36)
);
    DROP TABLE public.campaign;
       public         dotcmsdbuser    false    3            7           1259    60454    category    TABLE     G  CREATE TABLE public.category (
    inode character varying(36) NOT NULL,
    category_name character varying(255),
    category_key character varying(255),
    sort_order integer,
    active boolean,
    keywords text,
    category_velocity_var_name character varying(255) NOT NULL,
    mod_date timestamp without time zone
);
    DROP TABLE public.category;
       public         dotcmsdbuser    false    3            `           1259    60748    chain    TABLE     �   CREATE TABLE public.chain (
    id bigint NOT NULL,
    key_name character varying(255),
    name character varying(255) NOT NULL,
    success_value character varying(255) NOT NULL,
    failure_value character varying(255) NOT NULL
);
    DROP TABLE public.chain;
       public         dotcmsdbuser    false    3            9           1259    60470    chain_link_code    TABLE     �   CREATE TABLE public.chain_link_code (
    id bigint NOT NULL,
    class_name character varying(255),
    code text NOT NULL,
    last_mod_date timestamp without time zone NOT NULL,
    language character varying(255) NOT NULL
);
 #   DROP TABLE public.chain_link_code;
       public         dotcmsdbuser    false    3            m           1259    61004    chain_link_code_seq    SEQUENCE     |   CREATE SEQUENCE public.chain_link_code_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.chain_link_code_seq;
       public       dotcmsdbuser    false    3            q           1259    61012 	   chain_seq    SEQUENCE     r   CREATE SEQUENCE public.chain_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
     DROP SEQUENCE public.chain_seq;
       public       dotcmsdbuser    false    3            J           1259    60586    chain_state    TABLE     �   CREATE TABLE public.chain_state (
    id bigint NOT NULL,
    chain_id bigint NOT NULL,
    link_code_id bigint NOT NULL,
    state_order bigint NOT NULL
);
    DROP TABLE public.chain_state;
       public         dotcmsdbuser    false    3            X           1259    60682    chain_state_parameter    TABLE     �   CREATE TABLE public.chain_state_parameter (
    id bigint NOT NULL,
    chain_state_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255) NOT NULL
);
 )   DROP TABLE public.chain_state_parameter;
       public         dotcmsdbuser    false    3            z           1259    61030    chain_state_parameter_seq    SEQUENCE     �   CREATE SEQUENCE public.chain_state_parameter_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.chain_state_parameter_seq;
       public       dotcmsdbuser    false    3            h           1259    60994    chain_state_seq    SEQUENCE     x   CREATE SEQUENCE public.chain_state_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.chain_state_seq;
       public       dotcmsdbuser    false    3            E           1259    60552    challenge_question    TABLE     o   CREATE TABLE public.challenge_question (
    cquestionid bigint NOT NULL,
    cqtext character varying(255)
);
 &   DROP TABLE public.challenge_question;
       public         dotcmsdbuser    false    3            D           1259    60547    click    TABLE     �   CREATE TABLE public.click (
    inode character varying(36) NOT NULL,
    link character varying(255),
    click_count integer
);
    DROP TABLE public.click;
       public         dotcmsdbuser    false    3            @           1259    60521    clickstream    TABLE     �  CREATE TABLE public.clickstream (
    clickstream_id bigint NOT NULL,
    cookie_id character varying(255),
    user_id character varying(255),
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    referer character varying(255),
    remote_address character varying(255),
    remote_hostname character varying(255),
    user_agent character varying(255),
    bot boolean,
    host_id character varying(36),
    last_page_id character varying(50),
    first_page_id character varying(50),
    operating_system character varying(50),
    browser_name character varying(50),
    browser_version character varying(50),
    mobile_device boolean,
    number_of_requests integer
);
    DROP TABLE public.clickstream;
       public         dotcmsdbuser    false    3            \           1259    60714    clickstream_404    TABLE     ,  CREATE TABLE public.clickstream_404 (
    clickstream_404_id bigint NOT NULL,
    referer_uri character varying(255),
    query_string text,
    request_uri character varying(255),
    user_id character varying(255),
    host_id character varying(36),
    timestampper timestamp without time zone
);
 #   DROP TABLE public.clickstream_404;
       public         dotcmsdbuser    false    3            x           1259    61026    clickstream_404_seq    SEQUENCE     |   CREATE SEQUENCE public.clickstream_404_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.clickstream_404_seq;
       public       dotcmsdbuser    false    3            H           1259    60570    clickstream_request    TABLE     �  CREATE TABLE public.clickstream_request (
    clickstream_request_id bigint NOT NULL,
    clickstream_id bigint,
    server_name character varying(255),
    protocol character varying(255),
    server_port integer,
    request_uri character varying(255),
    request_order integer,
    query_string text,
    language_id bigint,
    timestampper timestamp without time zone,
    host_id character varying(36),
    associated_identifier character varying(36)
);
 '   DROP TABLE public.clickstream_request;
       public         dotcmsdbuser    false    3            w           1259    61024    clickstream_request_seq    SEQUENCE     �   CREATE SEQUENCE public.clickstream_request_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.clickstream_request_seq;
       public       dotcmsdbuser    false    3            n           1259    61006    clickstream_seq    SEQUENCE     x   CREATE SEQUENCE public.clickstream_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.clickstream_seq;
       public       dotcmsdbuser    false    3            �           1259    61742    cluster_server    TABLE     �  CREATE TABLE public.cluster_server (
    server_id character varying(36) NOT NULL,
    cluster_id character varying(36) NOT NULL,
    name character varying(100),
    ip_address character varying(39) NOT NULL,
    host character varying(36),
    cache_port smallint,
    es_transport_tcp_port smallint,
    es_network_port smallint,
    es_http_port smallint,
    key_ character varying(100)
);
 "   DROP TABLE public.cluster_server;
       public         dotcmsdbuser    false    3            �           1259    61854    cluster_server_action    TABLE     �  CREATE TABLE public.cluster_server_action (
    server_action_id character varying(36) NOT NULL,
    originator_id character varying(36) NOT NULL,
    server_id character varying(36) NOT NULL,
    failed boolean,
    response character varying(2048),
    action_id character varying(1024) NOT NULL,
    completed boolean,
    entered_date timestamp without time zone NOT NULL,
    time_out_seconds bigint NOT NULL
);
 )   DROP TABLE public.cluster_server_action;
       public         dotcmsdbuser    false    3            �           1259    61752    cluster_server_uptime    TABLE     �   CREATE TABLE public.cluster_server_uptime (
    id character varying(36) NOT NULL,
    server_id character varying(36),
    startup timestamp without time zone,
    heartbeat timestamp without time zone
);
 )   DROP TABLE public.cluster_server_uptime;
       public         dotcmsdbuser    false    3            ]           1259    60722 
   cms_layout    TABLE     �   CREATE TABLE public.cms_layout (
    id character varying(36) NOT NULL,
    layout_name character varying(255) NOT NULL,
    description character varying(255),
    tab_order integer
);
    DROP TABLE public.cms_layout;
       public         dotcmsdbuser    false    3            4           1259    60433    cms_layouts_portlets    TABLE     �   CREATE TABLE public.cms_layouts_portlets (
    id character varying(36) NOT NULL,
    layout_id character varying(36) NOT NULL,
    portlet_id character varying(100) NOT NULL,
    portlet_order integer
);
 (   DROP TABLE public.cms_layouts_portlets;
       public         dotcmsdbuser    false    3            /           1259    60391    cms_role    TABLE     �  CREATE TABLE public.cms_role (
    id character varying(36) NOT NULL,
    role_name character varying(255) NOT NULL,
    description text,
    role_key character varying(255),
    db_fqn character varying(1000) NOT NULL,
    parent character varying(36) NOT NULL,
    edit_permissions boolean,
    edit_users boolean,
    edit_layouts boolean,
    locked boolean,
    system boolean
);
    DROP TABLE public.cms_role;
       public         dotcmsdbuser    false    3            R           1259    60635    communication    TABLE       CREATE TABLE public.communication (
    inode character varying(36) NOT NULL,
    title character varying(255),
    trackback_link_inode character varying(36),
    communication_type character varying(255),
    from_name character varying(255),
    from_email character varying(255),
    email_subject character varying(255),
    html_page_inode character varying(36),
    text_message text,
    mod_date timestamp without time zone,
    modified_by character varying(255),
    ext_comm_id character varying(255)
);
 !   DROP TABLE public.communication;
       public         dotcmsdbuser    false    3            �            1259    59672    company    TABLE     �  CREATE TABLE public.company (
    companyid character varying(100) NOT NULL,
    key_ text,
    portalurl character varying(100) NOT NULL,
    homeurl character varying(100) NOT NULL,
    mx character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    shortname character varying(100) NOT NULL,
    type_ character varying(100),
    size_ character varying(100),
    street character varying(100),
    city character varying(100),
    state character varying(100),
    zip character varying(100),
    phone character varying(100),
    fax character varying(100),
    emailaddress character varying(100),
    authtype character varying(100),
    autologin boolean,
    strangers boolean
);
    DROP TABLE public.company;
       public         dotcmsdbuser    false    3            0           1259    60399    container_structures    TABLE     �   CREATE TABLE public.container_structures (
    id character varying(36) NOT NULL,
    container_id character varying(36) NOT NULL,
    container_inode character varying(36) NOT NULL,
    structure_id character varying(36) NOT NULL,
    code text
);
 (   DROP TABLE public.container_structures;
       public         dotcmsdbuser    false    3            !           1259    60290    container_version_info    TABLE     Z  CREATE TABLE public.container_version_info (
    identifier character varying(36) NOT NULL,
    working_inode character varying(36) NOT NULL,
    live_inode character varying(36),
    deleted boolean NOT NULL,
    locked_by character varying(100),
    locked_on timestamp without time zone,
    version_ts timestamp without time zone NOT NULL
);
 *   DROP TABLE public.container_version_info;
       public         dotcmsdbuser    false    3            Q           1259    60627 
   containers    TABLE     (  CREATE TABLE public.containers (
    inode character varying(36) NOT NULL,
    code text,
    pre_loop text,
    post_loop text,
    show_on_menu boolean,
    title character varying(255),
    mod_date timestamp without time zone,
    mod_user character varying(100),
    sort_order integer,
    friendly_name character varying(255),
    max_contentlets integer,
    use_div boolean,
    staticify boolean,
    sort_contentlets_by character varying(255),
    lucene_query text,
    notes character varying(255),
    identifier character varying(36)
);
    DROP TABLE public.containers;
       public         dotcmsdbuser    false    3            I           1259    60578    content_rating    TABLE     B  CREATE TABLE public.content_rating (
    id bigint NOT NULL,
    rating real,
    user_id character varying(255),
    session_id character varying(255),
    identifier character varying(36),
    rating_date timestamp without time zone,
    user_ip character varying(255),
    long_live_cookie_id character varying(255)
);
 "   DROP TABLE public.content_rating;
       public         dotcmsdbuser    false    3            p           1259    61010    content_rating_sequence    SEQUENCE     �   CREATE SEQUENCE public.content_rating_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.content_rating_sequence;
       public       dotcmsdbuser    false    3            2           1259    60417 
   contentlet    TABLE     U  CREATE TABLE public.contentlet (
    inode character varying(36) NOT NULL,
    show_on_menu boolean,
    title character varying(255),
    mod_date timestamp without time zone,
    mod_user character varying(100),
    sort_order integer,
    friendly_name character varying(255),
    structure_inode character varying(36),
    last_review timestamp without time zone,
    next_review timestamp without time zone,
    review_interval character varying(255),
    disabled_wysiwyg character varying(255),
    identifier character varying(36),
    language_id bigint,
    date1 timestamp without time zone,
    date2 timestamp without time zone,
    date3 timestamp without time zone,
    date4 timestamp without time zone,
    date5 timestamp without time zone,
    date6 timestamp without time zone,
    date7 timestamp without time zone,
    date8 timestamp without time zone,
    date9 timestamp without time zone,
    date10 timestamp without time zone,
    date11 timestamp without time zone,
    date12 timestamp without time zone,
    date13 timestamp without time zone,
    date14 timestamp without time zone,
    date15 timestamp without time zone,
    date16 timestamp without time zone,
    date17 timestamp without time zone,
    date18 timestamp without time zone,
    date19 timestamp without time zone,
    date20 timestamp without time zone,
    date21 timestamp without time zone,
    date22 timestamp without time zone,
    date23 timestamp without time zone,
    date24 timestamp without time zone,
    date25 timestamp without time zone,
    text1 character varying(255),
    text2 character varying(255),
    text3 character varying(255),
    text4 character varying(255),
    text5 character varying(255),
    text6 character varying(255),
    text7 character varying(255),
    text8 character varying(255),
    text9 character varying(255),
    text10 character varying(255),
    text11 character varying(255),
    text12 character varying(255),
    text13 character varying(255),
    text14 character varying(255),
    text15 character varying(255),
    text16 character varying(255),
    text17 character varying(255),
    text18 character varying(255),
    text19 character varying(255),
    text20 character varying(255),
    text21 character varying(255),
    text22 character varying(255),
    text23 character varying(255),
    text24 character varying(255),
    text25 character varying(255),
    text_area1 text,
    text_area2 text,
    text_area3 text,
    text_area4 text,
    text_area5 text,
    text_area6 text,
    text_area7 text,
    text_area8 text,
    text_area9 text,
    text_area10 text,
    text_area11 text,
    text_area12 text,
    text_area13 text,
    text_area14 text,
    text_area15 text,
    text_area16 text,
    text_area17 text,
    text_area18 text,
    text_area19 text,
    text_area20 text,
    text_area21 text,
    text_area22 text,
    text_area23 text,
    text_area24 text,
    text_area25 text,
    integer1 bigint,
    integer2 bigint,
    integer3 bigint,
    integer4 bigint,
    integer5 bigint,
    integer6 bigint,
    integer7 bigint,
    integer8 bigint,
    integer9 bigint,
    integer10 bigint,
    integer11 bigint,
    integer12 bigint,
    integer13 bigint,
    integer14 bigint,
    integer15 bigint,
    integer16 bigint,
    integer17 bigint,
    integer18 bigint,
    integer19 bigint,
    integer20 bigint,
    integer21 bigint,
    integer22 bigint,
    integer23 bigint,
    integer24 bigint,
    integer25 bigint,
    float1 real,
    float2 real,
    float3 real,
    float4 real,
    float5 real,
    float6 real,
    float7 real,
    float8 real,
    float9 real,
    float10 real,
    float11 real,
    float12 real,
    float13 real,
    float14 real,
    float15 real,
    float16 real,
    float17 real,
    float18 real,
    float19 real,
    float20 real,
    float21 real,
    float22 real,
    float23 real,
    float24 real,
    float25 real,
    bool1 boolean,
    bool2 boolean,
    bool3 boolean,
    bool4 boolean,
    bool5 boolean,
    bool6 boolean,
    bool7 boolean,
    bool8 boolean,
    bool9 boolean,
    bool10 boolean,
    bool11 boolean,
    bool12 boolean,
    bool13 boolean,
    bool14 boolean,
    bool15 boolean,
    bool16 boolean,
    bool17 boolean,
    bool18 boolean,
    bool19 boolean,
    bool20 boolean,
    bool21 boolean,
    bool22 boolean,
    bool23 boolean,
    bool24 boolean,
    bool25 boolean
);
    DROP TABLE public.contentlet;
       public         dotcmsdbuser    false    3                       1259    60277    contentlet_version_info    TABLE     u  CREATE TABLE public.contentlet_version_info (
    identifier character varying(36) NOT NULL,
    lang bigint NOT NULL,
    working_inode character varying(36) NOT NULL,
    live_inode character varying(36),
    deleted boolean NOT NULL,
    locked_by character varying(100),
    locked_on timestamp without time zone,
    version_ts timestamp without time zone NOT NULL
);
 +   DROP TABLE public.contentlet_version_info;
       public         dotcmsdbuser    false    3            �            1259    59680    counter    TABLE     a   CREATE TABLE public.counter (
    name character varying(100) NOT NULL,
    currentid integer
);
    DROP TABLE public.counter;
       public         dotcmsdbuser    false    3            �            1259    59685 	   cyrususer    TABLE     }   CREATE TABLE public.cyrususer (
    userid character varying(100) NOT NULL,
    password_ character varying(100) NOT NULL
);
    DROP TABLE public.cyrususer;
       public         dotcmsdbuser    false    3            �            1259    59690    cyrusvirtual    TABLE     �   CREATE TABLE public.cyrusvirtual (
    emailaddress character varying(100) NOT NULL,
    userid character varying(100) NOT NULL
);
     DROP TABLE public.cyrusvirtual;
       public         dotcmsdbuser    false    3            L           1259    60599    dashboard_user_preferences    TABLE     �   CREATE TABLE public.dashboard_user_preferences (
    id bigint NOT NULL,
    summary_404_id bigint,
    user_id character varying(255),
    ignored boolean,
    mod_date timestamp without time zone
);
 .   DROP TABLE public.dashboard_user_preferences;
       public         dotcmsdbuser    false    3            g           1259    60992    dashboard_usrpref_seq    SEQUENCE     ~   CREATE SEQUENCE public.dashboard_usrpref_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.dashboard_usrpref_seq;
       public       dotcmsdbuser    false    3            �            1259    59532 
   db_version    TABLE     w   CREATE TABLE public.db_version (
    db_version integer NOT NULL,
    date_update timestamp with time zone NOT NULL
);
    DROP TABLE public.db_version;
       public         dotcmsdbuser    false    3            }           1259    61086    dist_journal    TABLE     �   CREATE TABLE public.dist_journal (
    id bigint NOT NULL,
    object_to_index character varying(1024) NOT NULL,
    serverid character varying(64),
    journal_type integer NOT NULL,
    time_entered timestamp without time zone NOT NULL
);
     DROP TABLE public.dist_journal;
       public         dotcmsdbuser    false    3            |           1259    61084    dist_journal_id_seq    SEQUENCE     |   CREATE SEQUENCE public.dist_journal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.dist_journal_id_seq;
       public       dotcmsdbuser    false    381    3            �           0    0    dist_journal_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.dist_journal_id_seq OWNED BY public.dist_journal.id;
            public       dotcmsdbuser    false    380            �           1259    61112    dist_process    TABLE     �   CREATE TABLE public.dist_process (
    id bigint NOT NULL,
    object_to_index character varying(1024) NOT NULL,
    serverid character varying(64),
    journal_type integer NOT NULL,
    time_entered timestamp without time zone NOT NULL
);
     DROP TABLE public.dist_process;
       public         dotcmsdbuser    false    3                       1259    61110    dist_process_id_seq    SEQUENCE     |   CREATE SEQUENCE public.dist_process_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.dist_process_id_seq;
       public       dotcmsdbuser    false    3    384            �           0    0    dist_process_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.dist_process_id_seq OWNED BY public.dist_process.id;
            public       dotcmsdbuser    false    383            �           1259    61122    dist_reindex_journal_id_seq    SEQUENCE     �   CREATE SEQUENCE public.dist_reindex_journal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.dist_reindex_journal_id_seq;
       public       dotcmsdbuser    false    386    3            �           0    0    dist_reindex_journal_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.dist_reindex_journal_id_seq OWNED BY public.dist_reindex_journal.id;
            public       dotcmsdbuser    false    385            �            1259    59695    dlfileprofile    TABLE     S  CREATE TABLE public.dlfileprofile (
    companyid character varying(100) NOT NULL,
    repositoryid character varying(100) NOT NULL,
    filename character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    username character varying(100),
    versionuserid character varying(100) NOT NULL,
    versionusername character varying(100),
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    readroles character varying(100),
    writeroles character varying(100),
    description text,
    version double precision,
    size_ integer
);
 !   DROP TABLE public.dlfileprofile;
       public         dotcmsdbuser    false    3            �            1259    59703 
   dlfilerank    TABLE     
  CREATE TABLE public.dlfilerank (
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    repositoryid character varying(100) NOT NULL,
    filename character varying(100) NOT NULL,
    createdate timestamp without time zone
);
    DROP TABLE public.dlfilerank;
       public         dotcmsdbuser    false    3            �            1259    59708    dlfileversion    TABLE     l  CREATE TABLE public.dlfileversion (
    companyid character varying(100) NOT NULL,
    repositoryid character varying(100) NOT NULL,
    filename character varying(100) NOT NULL,
    version double precision NOT NULL,
    userid character varying(100) NOT NULL,
    username character varying(100),
    createdate timestamp without time zone,
    size_ integer
);
 !   DROP TABLE public.dlfileversion;
       public         dotcmsdbuser    false    3            �            1259    59716    dlrepository    TABLE       CREATE TABLE public.dlrepository (
    repositoryid character varying(100) NOT NULL,
    groupid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    username character varying(100),
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    readroles character varying(100),
    writeroles character varying(100),
    name character varying(100),
    description text,
    lastpostdate timestamp without time zone
);
     DROP TABLE public.dlrepository;
       public         dotcmsdbuser    false    3            �           1259    61737    dot_cluster    TABLE     S   CREATE TABLE public.dot_cluster (
    cluster_id character varying(36) NOT NULL
);
    DROP TABLE public.dot_cluster;
       public         dotcmsdbuser    false    3            Y           1259    60690    field    TABLE     �  CREATE TABLE public.field (
    inode character varying(36) NOT NULL,
    structure_inode character varying(255),
    field_name character varying(255),
    field_type character varying(255),
    field_relation_type character varying(255),
    field_contentlet character varying(255),
    required boolean,
    indexed boolean,
    listed boolean,
    velocity_var_name character varying(255),
    sort_order integer,
    field_values text,
    regex_check character varying(255),
    hint character varying(255),
    default_value character varying(255),
    fixed boolean DEFAULT false NOT NULL,
    read_only boolean DEFAULT false NOT NULL,
    searchable boolean,
    unique_ boolean,
    mod_date timestamp without time zone
);
    DROP TABLE public.field;
       public         dotcmsdbuser    false    3            ^           1259    60730    field_variable    TABLE     1  CREATE TABLE public.field_variable (
    id character varying(36) NOT NULL,
    field_id character varying(36),
    variable_name character varying(255),
    variable_key character varying(255),
    variable_value text,
    user_id character varying(255),
    last_mod_date timestamp without time zone
);
 "   DROP TABLE public.field_variable;
       public         dotcmsdbuser    false    3            F           1259    60557 
   file_asset    TABLE       CREATE TABLE public.file_asset (
    inode character varying(36) NOT NULL,
    file_name character varying(255),
    file_size integer,
    width integer,
    height integer,
    mime_type character varying(255),
    author character varying(255),
    publish_date timestamp without time zone,
    show_on_menu boolean,
    title character varying(255),
    friendly_name character varying(255),
    mod_date timestamp without time zone,
    mod_user character varying(100),
    sort_order integer,
    identifier character varying(36)
);
    DROP TABLE public.file_asset;
       public         dotcmsdbuser    false    3            S           1259    60643    fileasset_version_info    TABLE     c  CREATE TABLE public.fileasset_version_info (
    identifier character varying(36) NOT NULL,
    working_inode character varying(36) NOT NULL,
    live_inode character varying(36),
    deleted boolean NOT NULL,
    locked_by character varying(100),
    locked_on timestamp without time zone NOT NULL,
    version_ts timestamp without time zone NOT NULL
);
 *   DROP TABLE public.fileasset_version_info;
       public         dotcmsdbuser    false    3            �           1259    61846    fileassets_ir    TABLE     �  CREATE TABLE public.fileassets_ir (
    file_name character varying(255),
    local_working_inode character varying(36) NOT NULL,
    local_live_inode character varying(36),
    remote_working_inode character varying(36),
    remote_live_inode character varying(36),
    local_identifier character varying(36),
    remote_identifier character varying(36),
    endpoint_id character varying(36) NOT NULL,
    language_id bigint NOT NULL
);
 !   DROP TABLE public.fileassets_ir;
       public         dotcmsdbuser    false    3                        1259    60282    fixes_audit    TABLE     �   CREATE TABLE public.fixes_audit (
    id character varying(36) NOT NULL,
    table_name character varying(255),
    action character varying(255),
    records_altered integer,
    datetime timestamp without time zone
);
    DROP TABLE public.fixes_audit;
       public         dotcmsdbuser    false    3            [           1259    60706    folder    TABLE     l  CREATE TABLE public.folder (
    inode character varying(36) NOT NULL,
    name character varying(255),
    title character varying(255) NOT NULL,
    show_on_menu boolean,
    sort_order integer,
    files_masks character varying(255),
    identifier character varying(36),
    default_file_type character varying(36),
    mod_date timestamp without time zone
);
    DROP TABLE public.folder;
       public         dotcmsdbuser    false    3            �           1259    61823 
   folders_ir    TABLE     '  CREATE TABLE public.folders_ir (
    folder character varying(255),
    local_inode character varying(36) NOT NULL,
    remote_inode character varying(36),
    local_identifier character varying(36),
    remote_identifier character varying(36),
    endpoint_id character varying(36) NOT NULL
);
    DROP TABLE public.folders_ir;
       public         dotcmsdbuser    false    3            U           1259    60656    host_variable    TABLE     A  CREATE TABLE public.host_variable (
    id character varying(36) NOT NULL,
    host_id character varying(36),
    variable_name character varying(255),
    variable_key character varying(255),
    variable_value character varying(255),
    user_id character varying(255),
    last_mod_date timestamp without time zone
);
 !   DROP TABLE public.host_variable;
       public         dotcmsdbuser    false    3            8           1259    60462    htmlpage    TABLE     {  CREATE TABLE public.htmlpage (
    inode character varying(36) NOT NULL,
    show_on_menu boolean,
    title character varying(255),
    mod_date timestamp without time zone,
    mod_user character varying(100),
    sort_order integer,
    friendly_name character varying(255),
    metadata text,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    page_url character varying(255),
    https_required boolean,
    redirect character varying(255),
    identifier character varying(36),
    seo_description text,
    seo_keywords text,
    cache_ttl bigint,
    template_id character varying(36)
);
    DROP TABLE public.htmlpage;
       public         dotcmsdbuser    false    3            N           1259    60612    htmlpage_version_info    TABLE     Y  CREATE TABLE public.htmlpage_version_info (
    identifier character varying(36) NOT NULL,
    working_inode character varying(36) NOT NULL,
    live_inode character varying(36),
    deleted boolean NOT NULL,
    locked_by character varying(100),
    locked_on timestamp without time zone,
    version_ts timestamp without time zone NOT NULL
);
 )   DROP TABLE public.htmlpage_version_info;
       public         dotcmsdbuser    false    3            �           1259    61838    htmlpages_ir    TABLE     �  CREATE TABLE public.htmlpages_ir (
    html_page character varying(255),
    local_working_inode character varying(36) NOT NULL,
    local_live_inode character varying(36),
    remote_working_inode character varying(36),
    remote_live_inode character varying(36),
    local_identifier character varying(36),
    remote_identifier character varying(36),
    endpoint_id character varying(36) NOT NULL,
    language_id bigint NOT NULL
);
     DROP TABLE public.htmlpages_ir;
       public         dotcmsdbuser    false    3            ?           1259    60511 
   identifier    TABLE     F  CREATE TABLE public.identifier (
    id character varying(36) NOT NULL,
    parent_path character varying(255),
    asset_name character varying(255),
    host_inode character varying(36),
    asset_type character varying(64),
    syspublish_date timestamp without time zone,
    sysexpire_date timestamp without time zone
);
    DROP TABLE public.identifier;
       public         dotcmsdbuser    false    3            �            1259    59724    igfolder    TABLE     }  CREATE TABLE public.igfolder (
    folderid character varying(100) NOT NULL,
    groupid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    parentfolderid character varying(100),
    name character varying(100)
);
    DROP TABLE public.igfolder;
       public         dotcmsdbuser    false    3            �            1259    59732    igimage    TABLE     w  CREATE TABLE public.igimage (
    imageid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    folderid character varying(100),
    description text,
    height integer,
    width integer,
    size_ integer
);
    DROP TABLE public.igimage;
       public         dotcmsdbuser    false    3            �            1259    59740    image    TABLE     d   CREATE TABLE public.image (
    imageid character varying(200) NOT NULL,
    text_ text NOT NULL
);
    DROP TABLE public.image;
       public         dotcmsdbuser    false    3            �           1259    61235    import_audit    TABLE     x  CREATE TABLE public.import_audit (
    id bigint NOT NULL,
    start_date timestamp without time zone,
    userid character varying(255),
    filename character varying(512),
    status integer,
    last_inode character varying(100),
    records_to_import bigint,
    serverid character varying(255),
    warnings text,
    errors text,
    results text,
    messages text
);
     DROP TABLE public.import_audit;
       public         dotcmsdbuser    false    3            �           1259    61622    indicies    TABLE        CREATE TABLE public.indicies (
    index_name character varying(30) NOT NULL,
    index_type character varying(16) NOT NULL
);
    DROP TABLE public.indicies;
       public         dotcmsdbuser    false    3            d           1259    60776    inode    TABLE     �   CREATE TABLE public.inode (
    inode character varying(36) NOT NULL,
    owner character varying(255),
    idate timestamp without time zone,
    type character varying(64)
);
    DROP TABLE public.inode;
       public         dotcmsdbuser    false    3            �            1259    59748    journalarticle    TABLE     '  CREATE TABLE public.journalarticle (
    articleid character varying(100) NOT NULL,
    version double precision NOT NULL,
    portletid character varying(100) NOT NULL,
    groupid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    username character varying(100),
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    title character varying(100),
    content text,
    type_ character varying(100),
    structureid character varying(100),
    templateid character varying(100),
    displaydate timestamp without time zone,
    expirationdate timestamp without time zone,
    approved boolean,
    approvedbyuserid character varying(100),
    approvedbyusername character varying(100)
);
 "   DROP TABLE public.journalarticle;
       public         dotcmsdbuser    false    3            �            1259    59756    journalstructure    TABLE     �  CREATE TABLE public.journalstructure (
    structureid character varying(100) NOT NULL,
    portletid character varying(100) NOT NULL,
    groupid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    username character varying(100),
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    name character varying(100),
    description text,
    xsd text
);
 $   DROP TABLE public.journalstructure;
       public         dotcmsdbuser    false    3            �            1259    59764    journaltemplate    TABLE     =  CREATE TABLE public.journaltemplate (
    templateid character varying(100) NOT NULL,
    portletid character varying(100) NOT NULL,
    groupid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    username character varying(100),
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    structureid character varying(100),
    name character varying(100),
    description text,
    xsl text,
    smallimage boolean,
    smallimageurl character varying(100)
);
 #   DROP TABLE public.journaltemplate;
       public         dotcmsdbuser    false    3            =           1259    60498    language    TABLE     �   CREATE TABLE public.language (
    id bigint NOT NULL,
    language_code character varying(5),
    country_code character varying(255),
    language character varying(255),
    country character varying(255)
);
    DROP TABLE public.language;
       public         dotcmsdbuser    false    3            j           1259    60998    language_seq    SEQUENCE     u   CREATE SEQUENCE public.language_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.language_seq;
       public       dotcmsdbuser    false    3            �            1259    59772    layer    TABLE     V  CREATE TABLE public.layer (
    layerid character varying(100) NOT NULL,
    skinid character varying(100) NOT NULL,
    href character varying(100),
    hrefhover character varying(100),
    background character varying(100),
    foreground character varying(100),
    negalert character varying(100),
    posalert character varying(100)
);
    DROP TABLE public.layer;
       public         dotcmsdbuser    false    3            G           1259    60565    layouts_cms_roles    TABLE     �   CREATE TABLE public.layouts_cms_roles (
    id character varying(36) NOT NULL,
    layout_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);
 %   DROP TABLE public.layouts_cms_roles;
       public         dotcmsdbuser    false    3            a           1259    60758    link_version_info    TABLE     U  CREATE TABLE public.link_version_info (
    identifier character varying(36) NOT NULL,
    working_inode character varying(36) NOT NULL,
    live_inode character varying(36),
    deleted boolean NOT NULL,
    locked_by character varying(100),
    locked_on timestamp without time zone,
    version_ts timestamp without time zone NOT NULL
);
 %   DROP TABLE public.link_version_info;
       public         dotcmsdbuser    false    3            V           1259    60664    links    TABLE       CREATE TABLE public.links (
    inode character varying(36) NOT NULL,
    show_on_menu boolean,
    title character varying(255),
    mod_date timestamp without time zone,
    mod_user character varying(100),
    sort_order integer,
    friendly_name character varying(255),
    identifier character varying(36),
    protocal character varying(100),
    url character varying(255),
    target character varying(100),
    internal_link_identifier character varying(36),
    link_type character varying(255),
    link_code text
);
    DROP TABLE public.links;
       public         dotcmsdbuser    false    3            �           1259    61629 
   log_mapper    TABLE     �   CREATE TABLE public.log_mapper (
    enabled numeric(1,0) NOT NULL,
    log_name character varying(30) NOT NULL,
    description character varying(50) NOT NULL
);
    DROP TABLE public.log_mapper;
       public         dotcmsdbuser    false    3            $           1259    60311    mailing_list    TABLE     �   CREATE TABLE public.mailing_list (
    inode character varying(36) NOT NULL,
    title character varying(255),
    public_list boolean,
    user_id character varying(255)
);
     DROP TABLE public.mailing_list;
       public         dotcmsdbuser    false    3            �            1259    59780    mailreceipt    TABLE     !  CREATE TABLE public.mailreceipt (
    receiptid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    recipientname character varying(100),
    recipientaddress character varying(100),
    subject character varying(100),
    sentdate timestamp without time zone,
    readcount integer,
    firstreaddate timestamp without time zone,
    lastreaddate timestamp without time zone
);
    DROP TABLE public.mailreceipt;
       public         dotcmsdbuser    false    3            �            1259    59788 	   mbmessage    TABLE       CREATE TABLE public.mbmessage (
    messageid character varying(100) NOT NULL,
    topicid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    username character varying(100),
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    threadid character varying(100),
    parentmessageid character varying(100),
    subject character varying(100),
    body text,
    attachments boolean,
    anonymous boolean
);
    DROP TABLE public.mbmessage;
       public         dotcmsdbuser    false    3            �            1259    59796    mbmessageflag    TABLE     �   CREATE TABLE public.mbmessageflag (
    topicid character varying(100) NOT NULL,
    messageid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    flag character varying(100)
);
 !   DROP TABLE public.mbmessageflag;
       public         dotcmsdbuser    false    3            �            1259    59801    mbthread    TABLE     �   CREATE TABLE public.mbthread (
    threadid character varying(100) NOT NULL,
    rootmessageid character varying(100),
    topicid character varying(100),
    messagecount integer,
    lastpostdate timestamp without time zone
);
    DROP TABLE public.mbthread;
       public         dotcmsdbuser    false    3            �            1259    59806    mbtopic    TABLE     5  CREATE TABLE public.mbtopic (
    topicid character varying(100) NOT NULL,
    portletid character varying(100) NOT NULL,
    groupid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    username character varying(100),
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    readroles character varying(100),
    writeroles character varying(100),
    name character varying(100),
    description text,
    lastpostdate timestamp without time zone
);
    DROP TABLE public.mbtopic;
       public         dotcmsdbuser    false    3            A           1259    60529 
   multi_tree    TABLE     �   CREATE TABLE public.multi_tree (
    child character varying(36) NOT NULL,
    parent1 character varying(36) NOT NULL,
    parent2 character varying(36) NOT NULL,
    relation_type character varying(64),
    tree_order integer
);
    DROP TABLE public.multi_tree;
       public         dotcmsdbuser    false    3            �            1259    59814    networkaddress    TABLE     �  CREATE TABLE public.networkaddress (
    addressid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    name character varying(100),
    url character varying(100),
    comments text,
    content text,
    status integer,
    lastupdated timestamp without time zone,
    notifyby character varying(100),
    interval_ integer,
    active_ boolean
);
 "   DROP TABLE public.networkaddress;
       public         dotcmsdbuser    false    3            �            1259    59822    note    TABLE       CREATE TABLE public.note (
    noteid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    username character varying(100),
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    classname character varying(100),
    classpk character varying(100),
    content text
);
    DROP TABLE public.note;
       public         dotcmsdbuser    false    3            �           1259    61787    notification    TABLE     I  CREATE TABLE public.notification (
    id character varying(36) NOT NULL,
    message text NOT NULL,
    notification_type character varying(100),
    notification_level character varying(100),
    user_id character varying(255) NOT NULL,
    time_sent timestamp without time zone NOT NULL,
    was_read boolean DEFAULT false
);
     DROP TABLE public.notification;
       public         dotcmsdbuser    false    3            �            1259    59830    passwordtracker    TABLE     �   CREATE TABLE public.passwordtracker (
    passwordtrackerid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    createdate timestamp without time zone NOT NULL,
    password_ character varying(100) NOT NULL
);
 #   DROP TABLE public.passwordtracker;
       public         dotcmsdbuser    false    3            1           1259    60407 
   permission    TABLE     �   CREATE TABLE public.permission (
    id bigint NOT NULL,
    permission_type character varying(500),
    inode_id character varying(36),
    roleid character varying(36),
    permission integer
);
    DROP TABLE public.permission;
       public         dotcmsdbuser    false    3                       1259    60270    permission_reference    TABLE     �   CREATE TABLE public.permission_reference (
    id bigint NOT NULL,
    asset_id character varying(36),
    reference_id character varying(36),
    permission_type character varying(100)
);
 (   DROP TABLE public.permission_reference;
       public         dotcmsdbuser    false    3            k           1259    61000    permission_reference_seq    SEQUENCE     �   CREATE SEQUENCE public.permission_reference_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.permission_reference_seq;
       public       dotcmsdbuser    false    3            {           1259    61032    permission_seq    SEQUENCE     w   CREATE SEQUENCE public.permission_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.permission_seq;
       public       dotcmsdbuser    false    3            #           1259    60303    plugin    TABLE     S  CREATE TABLE public.plugin (
    id character varying(255) NOT NULL,
    plugin_name character varying(255) NOT NULL,
    plugin_version character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    first_deployed_date timestamp without time zone NOT NULL,
    last_deployed_date timestamp without time zone NOT NULL
);
    DROP TABLE public.plugin;
       public         dotcmsdbuser    false    3            ~           1259    61097    plugin_property    TABLE     �   CREATE TABLE public.plugin_property (
    plugin_id character varying(255) NOT NULL,
    propkey character varying(255) NOT NULL,
    original_value character varying(255) NOT NULL,
    current_value character varying(255) NOT NULL
);
 #   DROP TABLE public.plugin_property;
       public         dotcmsdbuser    false    3            �            1259    59835    pollschoice    TABLE     �   CREATE TABLE public.pollschoice (
    choiceid character varying(100) NOT NULL,
    questionid character varying(100) NOT NULL,
    description text
);
    DROP TABLE public.pollschoice;
       public         dotcmsdbuser    false    3            �            1259    59843    pollsdisplay    TABLE     �   CREATE TABLE public.pollsdisplay (
    layoutid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    portletid character varying(100) NOT NULL,
    questionid character varying(100) NOT NULL
);
     DROP TABLE public.pollsdisplay;
       public         dotcmsdbuser    false    3            �            1259    59848    pollsquestion    TABLE     "  CREATE TABLE public.pollsquestion (
    questionid character varying(100) NOT NULL,
    portletid character varying(100) NOT NULL,
    groupid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    username character varying(100),
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    title character varying(100),
    description text,
    expirationdate timestamp without time zone,
    lastvotedate timestamp without time zone
);
 !   DROP TABLE public.pollsquestion;
       public         dotcmsdbuser    false    3            �            1259    59856 	   pollsvote    TABLE     �   CREATE TABLE public.pollsvote (
    questionid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    choiceid character varying(100) NOT NULL,
    votedate timestamp without time zone
);
    DROP TABLE public.pollsvote;
       public         dotcmsdbuser    false    3            �            1259    59861    portlet    TABLE       CREATE TABLE public.portlet (
    portletid character varying(100) NOT NULL,
    groupid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    defaultpreferences text,
    narrow boolean,
    roles text,
    active_ boolean
);
    DROP TABLE public.portlet;
       public         dotcmsdbuser    false    3            �            1259    59869    portletpreferences    TABLE     �   CREATE TABLE public.portletpreferences (
    portletid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    layoutid character varying(100) NOT NULL,
    preferences text
);
 &   DROP TABLE public.portletpreferences;
       public         dotcmsdbuser    false    3            �            1259    59877    projfirm    TABLE     ~  CREATE TABLE public.projfirm (
    firmid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    username character varying(100),
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    name character varying(100),
    description text,
    url character varying(100)
);
    DROP TABLE public.projfirm;
       public         dotcmsdbuser    false    3            �            1259    59885    projproject    TABLE     �  CREATE TABLE public.projproject (
    projectid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    username character varying(100),
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    firmid character varying(100),
    code character varying(100),
    name character varying(100),
    description text
);
    DROP TABLE public.projproject;
       public         dotcmsdbuser    false    3            �            1259    59893    projtask    TABLE     G  CREATE TABLE public.projtask (
    taskid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    username character varying(100),
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    projectid character varying(100),
    name character varying(100),
    description text,
    comments text,
    estimatedduration integer,
    estimatedenddate timestamp without time zone,
    actualduration integer,
    actualenddate timestamp without time zone,
    status integer
);
    DROP TABLE public.projtask;
       public         dotcmsdbuser    false    3            �            1259    59901    projtime    TABLE     �  CREATE TABLE public.projtime (
    timeid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    username character varying(100),
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    projectid character varying(100),
    taskid character varying(100),
    description text,
    startdate timestamp without time zone,
    enddate timestamp without time zone
);
    DROP TABLE public.projtime;
       public         dotcmsdbuser    false    3            �           1259    61710    publishing_bundle    TABLE       CREATE TABLE public.publishing_bundle (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    publish_date timestamp without time zone,
    expire_date timestamp without time zone,
    owner character varying(100),
    force_push boolean
);
 %   DROP TABLE public.publishing_bundle;
       public         dotcmsdbuser    false    3            �           1259    61715    publishing_bundle_environment    TABLE     �   CREATE TABLE public.publishing_bundle_environment (
    id character varying(36) NOT NULL,
    bundle_id character varying(36) NOT NULL,
    environment_id character varying(36) NOT NULL
);
 1   DROP TABLE public.publishing_bundle_environment;
       public         dotcmsdbuser    false    3            �           1259    61674    publishing_end_point    TABLE     F  CREATE TABLE public.publishing_end_point (
    id character varying(36) NOT NULL,
    group_id character varying(700),
    server_name character varying(700),
    address character varying(250),
    port character varying(10),
    protocol character varying(10),
    enabled boolean,
    auth_key text,
    sending boolean
);
 (   DROP TABLE public.publishing_end_point;
       public         dotcmsdbuser    false    3            �           1259    61684    publishing_environment    TABLE     �   CREATE TABLE public.publishing_environment (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    push_to_all boolean NOT NULL
);
 *   DROP TABLE public.publishing_environment;
       public         dotcmsdbuser    false    3            �           1259    61730    publishing_pushed_assets    TABLE       CREATE TABLE public.publishing_pushed_assets (
    bundle_id character varying(36) NOT NULL,
    asset_id character varying(36) NOT NULL,
    asset_type character varying(255) NOT NULL,
    push_date timestamp without time zone,
    environment_id character varying(36) NOT NULL
);
 ,   DROP TABLE public.publishing_pushed_assets;
       public         dotcmsdbuser    false    3            �           1259    61701    publishing_queue    TABLE     G  CREATE TABLE public.publishing_queue (
    id bigint NOT NULL,
    operation bigint,
    asset character varying(2000) NOT NULL,
    language_id bigint NOT NULL,
    entered_date timestamp without time zone,
    publish_date timestamp without time zone,
    type character varying(256),
    bundle_id character varying(256)
);
 $   DROP TABLE public.publishing_queue;
       public         dotcmsdbuser    false    3            �           1259    61666    publishing_queue_audit    TABLE     �   CREATE TABLE public.publishing_queue_audit (
    bundle_id character varying(256) NOT NULL,
    status integer,
    status_pojo text,
    status_updated timestamp without time zone,
    create_date timestamp without time zone
);
 *   DROP TABLE public.publishing_queue_audit;
       public         dotcmsdbuser    false    3            �           1259    61699    publishing_queue_id_seq    SEQUENCE     �   CREATE SEQUENCE public.publishing_queue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.publishing_queue_id_seq;
       public       dotcmsdbuser    false    3    404            �           0    0    publishing_queue_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.publishing_queue_id_seq OWNED BY public.publishing_queue.id;
            public       dotcmsdbuser    false    403                       1259    60082    qrtz_blob_triggers    TABLE     �   CREATE TABLE public.qrtz_blob_triggers (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    blob_data bytea
);
 &   DROP TABLE public.qrtz_blob_triggers;
       public         dotcmsdbuser    false    3            	           1259    60105    qrtz_calendars    TABLE     v   CREATE TABLE public.qrtz_calendars (
    calendar_name character varying(80) NOT NULL,
    calendar bytea NOT NULL
);
 "   DROP TABLE public.qrtz_calendars;
       public         dotcmsdbuser    false    3                       1259    60072    qrtz_cron_triggers    TABLE     �   CREATE TABLE public.qrtz_cron_triggers (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    cron_expression character varying(80) NOT NULL,
    time_zone_id character varying(80)
);
 &   DROP TABLE public.qrtz_cron_triggers;
       public         dotcmsdbuser    false    3                       1259    60187    qrtz_excl_blob_triggers    TABLE     �   CREATE TABLE public.qrtz_excl_blob_triggers (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    blob_data bytea
);
 +   DROP TABLE public.qrtz_excl_blob_triggers;
       public         dotcmsdbuser    false    3                       1259    60210    qrtz_excl_calendars    TABLE     {   CREATE TABLE public.qrtz_excl_calendars (
    calendar_name character varying(80) NOT NULL,
    calendar bytea NOT NULL
);
 '   DROP TABLE public.qrtz_excl_calendars;
       public         dotcmsdbuser    false    3                       1259    60177    qrtz_excl_cron_triggers    TABLE     �   CREATE TABLE public.qrtz_excl_cron_triggers (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    cron_expression character varying(80) NOT NULL,
    time_zone_id character varying(80)
);
 +   DROP TABLE public.qrtz_excl_cron_triggers;
       public         dotcmsdbuser    false    3                       1259    60223    qrtz_excl_fired_triggers    TABLE     �  CREATE TABLE public.qrtz_excl_fired_triggers (
    entry_id character varying(95) NOT NULL,
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    is_volatile boolean NOT NULL,
    instance_name character varying(80) NOT NULL,
    fired_time bigint NOT NULL,
    priority integer NOT NULL,
    state character varying(16) NOT NULL,
    job_name character varying(80),
    job_group character varying(80),
    is_stateful boolean,
    requests_recovery boolean
);
 ,   DROP TABLE public.qrtz_excl_fired_triggers;
       public         dotcmsdbuser    false    3                       1259    60136    qrtz_excl_job_details    TABLE     �  CREATE TABLE public.qrtz_excl_job_details (
    job_name character varying(80) NOT NULL,
    job_group character varying(80) NOT NULL,
    description character varying(120),
    job_class_name character varying(128) NOT NULL,
    is_durable boolean NOT NULL,
    is_volatile boolean NOT NULL,
    is_stateful boolean NOT NULL,
    requests_recovery boolean NOT NULL,
    job_data bytea
);
 )   DROP TABLE public.qrtz_excl_job_details;
       public         dotcmsdbuser    false    3                       1259    60144    qrtz_excl_job_listeners    TABLE     �   CREATE TABLE public.qrtz_excl_job_listeners (
    job_name character varying(80) NOT NULL,
    job_group character varying(80) NOT NULL,
    job_listener character varying(80) NOT NULL
);
 +   DROP TABLE public.qrtz_excl_job_listeners;
       public         dotcmsdbuser    false    3                       1259    60236    qrtz_excl_locks    TABLE     V   CREATE TABLE public.qrtz_excl_locks (
    lock_name character varying(40) NOT NULL
);
 #   DROP TABLE public.qrtz_excl_locks;
       public         dotcmsdbuser    false    3                       1259    60218    qrtz_excl_paused_trigger_grps    TABLE     h   CREATE TABLE public.qrtz_excl_paused_trigger_grps (
    trigger_group character varying(80) NOT NULL
);
 1   DROP TABLE public.qrtz_excl_paused_trigger_grps;
       public         dotcmsdbuser    false    3                       1259    60231    qrtz_excl_scheduler_state    TABLE     �   CREATE TABLE public.qrtz_excl_scheduler_state (
    instance_name character varying(80) NOT NULL,
    last_checkin_time bigint NOT NULL,
    checkin_interval bigint NOT NULL
);
 -   DROP TABLE public.qrtz_excl_scheduler_state;
       public         dotcmsdbuser    false    3                       1259    60167    qrtz_excl_simple_triggers    TABLE       CREATE TABLE public.qrtz_excl_simple_triggers (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    repeat_count bigint NOT NULL,
    repeat_interval bigint NOT NULL,
    times_triggered bigint NOT NULL
);
 -   DROP TABLE public.qrtz_excl_simple_triggers;
       public         dotcmsdbuser    false    3                       1259    60200    qrtz_excl_trigger_listeners    TABLE     �   CREATE TABLE public.qrtz_excl_trigger_listeners (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    trigger_listener character varying(80) NOT NULL
);
 /   DROP TABLE public.qrtz_excl_trigger_listeners;
       public         dotcmsdbuser    false    3                       1259    60154    qrtz_excl_triggers    TABLE     o  CREATE TABLE public.qrtz_excl_triggers (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    job_name character varying(80) NOT NULL,
    job_group character varying(80) NOT NULL,
    is_volatile boolean NOT NULL,
    description character varying(120),
    next_fire_time bigint,
    prev_fire_time bigint,
    priority integer,
    trigger_state character varying(16) NOT NULL,
    trigger_type character varying(8) NOT NULL,
    start_time bigint NOT NULL,
    end_time bigint,
    calendar_name character varying(80),
    misfire_instr smallint,
    job_data bytea
);
 &   DROP TABLE public.qrtz_excl_triggers;
       public         dotcmsdbuser    false    3                       1259    60118    qrtz_fired_triggers    TABLE     �  CREATE TABLE public.qrtz_fired_triggers (
    entry_id character varying(95) NOT NULL,
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    is_volatile boolean NOT NULL,
    instance_name character varying(80) NOT NULL,
    fired_time bigint NOT NULL,
    priority integer NOT NULL,
    state character varying(16) NOT NULL,
    job_name character varying(80),
    job_group character varying(80),
    is_stateful boolean,
    requests_recovery boolean
);
 '   DROP TABLE public.qrtz_fired_triggers;
       public         dotcmsdbuser    false    3                       1259    60031    qrtz_job_details    TABLE     �  CREATE TABLE public.qrtz_job_details (
    job_name character varying(80) NOT NULL,
    job_group character varying(80) NOT NULL,
    description character varying(120),
    job_class_name character varying(128) NOT NULL,
    is_durable boolean NOT NULL,
    is_volatile boolean NOT NULL,
    is_stateful boolean NOT NULL,
    requests_recovery boolean NOT NULL,
    job_data bytea
);
 $   DROP TABLE public.qrtz_job_details;
       public         dotcmsdbuser    false    3                       1259    60039    qrtz_job_listeners    TABLE     �   CREATE TABLE public.qrtz_job_listeners (
    job_name character varying(80) NOT NULL,
    job_group character varying(80) NOT NULL,
    job_listener character varying(80) NOT NULL
);
 &   DROP TABLE public.qrtz_job_listeners;
       public         dotcmsdbuser    false    3                       1259    60131 
   qrtz_locks    TABLE     Q   CREATE TABLE public.qrtz_locks (
    lock_name character varying(40) NOT NULL
);
    DROP TABLE public.qrtz_locks;
       public         dotcmsdbuser    false    3            
           1259    60113    qrtz_paused_trigger_grps    TABLE     c   CREATE TABLE public.qrtz_paused_trigger_grps (
    trigger_group character varying(80) NOT NULL
);
 ,   DROP TABLE public.qrtz_paused_trigger_grps;
       public         dotcmsdbuser    false    3                       1259    60126    qrtz_scheduler_state    TABLE     �   CREATE TABLE public.qrtz_scheduler_state (
    instance_name character varying(80) NOT NULL,
    last_checkin_time bigint NOT NULL,
    checkin_interval bigint NOT NULL
);
 (   DROP TABLE public.qrtz_scheduler_state;
       public         dotcmsdbuser    false    3                       1259    60062    qrtz_simple_triggers    TABLE     �   CREATE TABLE public.qrtz_simple_triggers (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    repeat_count bigint NOT NULL,
    repeat_interval bigint NOT NULL,
    times_triggered bigint NOT NULL
);
 (   DROP TABLE public.qrtz_simple_triggers;
       public         dotcmsdbuser    false    3                       1259    60095    qrtz_trigger_listeners    TABLE     �   CREATE TABLE public.qrtz_trigger_listeners (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    trigger_listener character varying(80) NOT NULL
);
 *   DROP TABLE public.qrtz_trigger_listeners;
       public         dotcmsdbuser    false    3                       1259    60049    qrtz_triggers    TABLE     j  CREATE TABLE public.qrtz_triggers (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    job_name character varying(80) NOT NULL,
    job_group character varying(80) NOT NULL,
    is_volatile boolean NOT NULL,
    description character varying(120),
    next_fire_time bigint,
    prev_fire_time bigint,
    priority integer,
    trigger_state character varying(16) NOT NULL,
    trigger_type character varying(8) NOT NULL,
    start_time bigint NOT NULL,
    end_time bigint,
    calendar_name character varying(80),
    misfire_instr smallint,
    job_data bytea
);
 !   DROP TABLE public.qrtz_triggers;
       public         dotcmsdbuser    false    3            �           1259    61145 
   quartz_log    TABLE     �   CREATE TABLE public.quartz_log (
    id bigint NOT NULL,
    job_name character varying(255) NOT NULL,
    serverid character varying(64),
    time_started timestamp without time zone NOT NULL
);
    DROP TABLE public.quartz_log;
       public         dotcmsdbuser    false    3            �           1259    61143    quartz_log_id_seq    SEQUENCE     z   CREATE SEQUENCE public.quartz_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.quartz_log_id_seq;
       public       dotcmsdbuser    false    388    3            �           0    0    quartz_log_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.quartz_log_id_seq OWNED BY public.quartz_log.id;
            public       dotcmsdbuser    false    387            %           1259    60319 	   recipient    TABLE     h  CREATE TABLE public.recipient (
    inode character varying(36) NOT NULL,
    name character varying(255),
    lastname character varying(255),
    email character varying(255),
    sent timestamp without time zone,
    opened timestamp without time zone,
    last_result integer,
    last_message character varying(255),
    user_id character varying(100)
);
    DROP TABLE public.recipient;
       public         dotcmsdbuser    false    3            Z           1259    60698    relationship    TABLE     �  CREATE TABLE public.relationship (
    inode character varying(36) NOT NULL,
    parent_structure_inode character varying(255),
    child_structure_inode character varying(255),
    parent_relation_name character varying(255),
    child_relation_name character varying(255),
    relation_type_value character varying(255),
    cardinality integer,
    parent_required boolean,
    child_required boolean,
    fixed boolean
);
     DROP TABLE public.relationship;
       public         dotcmsdbuser    false    3            �            1259    59909    release_    TABLE     �   CREATE TABLE public.release_ (
    releaseid character varying(100) NOT NULL,
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    buildnumber integer,
    builddate timestamp without time zone
);
    DROP TABLE public.release_;
       public         dotcmsdbuser    false    3            5           1259    60438    report_asset    TABLE       CREATE TABLE public.report_asset (
    inode character varying(36) NOT NULL,
    report_name character varying(255) NOT NULL,
    report_description character varying(1000) NOT NULL,
    requires_input boolean,
    ds character varying(100) NOT NULL,
    web_form_report boolean
);
     DROP TABLE public.report_asset;
       public         dotcmsdbuser    false    3            _           1259    60738    report_parameter    TABLE     +  CREATE TABLE public.report_parameter (
    inode character varying(36) NOT NULL,
    report_inode character varying(36),
    parameter_description character varying(1000),
    parameter_name character varying(255),
    class_type character varying(250),
    default_value character varying(4000)
);
 $   DROP TABLE public.report_parameter;
       public         dotcmsdbuser    false    3            �           1259    61833 
   schemes_ir    TABLE     �   CREATE TABLE public.schemes_ir (
    name character varying(255),
    local_inode character varying(36) NOT NULL,
    remote_inode character varying(36),
    endpoint_id character varying(36) NOT NULL
);
    DROP TABLE public.schemes_ir;
       public         dotcmsdbuser    false    3            �            1259    59922    shoppingcart    TABLE     E  CREATE TABLE public.shoppingcart (
    cartid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    itemids text,
    couponids text,
    altshipping integer
);
     DROP TABLE public.shoppingcart;
       public         dotcmsdbuser    false    3            �            1259    59930    shoppingcategory    TABLE     0  CREATE TABLE public.shoppingcategory (
    categoryid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    parentcategoryid character varying(100),
    name character varying(100)
);
 $   DROP TABLE public.shoppingcategory;
       public         dotcmsdbuser    false    3            �            1259    59935    shoppingcoupon    TABLE       CREATE TABLE public.shoppingcoupon (
    couponid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    name character varying(100),
    description text,
    startdate timestamp without time zone,
    enddate timestamp without time zone,
    active_ boolean,
    limitcategories text,
    limitskus text,
    minorder double precision,
    discount double precision,
    discounttype character varying(100)
);
 "   DROP TABLE public.shoppingcoupon;
       public         dotcmsdbuser    false    3            �            1259    59943    shoppingitem    TABLE     �  CREATE TABLE public.shoppingitem (
    itemid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    categoryid character varying(100),
    sku character varying(100),
    name character varying(100),
    description text,
    properties text,
    supplieruserid character varying(100),
    fields_ boolean,
    fieldsquantities text,
    minquantity integer,
    maxquantity integer,
    price double precision,
    discount double precision,
    taxable boolean,
    shipping double precision,
    useshippingformula boolean,
    requiresshipping boolean,
    stockquantity integer,
    featured_ boolean,
    sale_ boolean,
    smallimage boolean,
    smallimageurl character varying(100),
    mediumimage boolean,
    mediumimageurl character varying(100),
    largeimage boolean,
    largeimageurl character varying(100)
);
     DROP TABLE public.shoppingitem;
       public         dotcmsdbuser    false    3            �            1259    59951    shoppingitemfield    TABLE     �   CREATE TABLE public.shoppingitemfield (
    itemfieldid character varying(100) NOT NULL,
    itemid character varying(100),
    name character varying(100),
    values_ text,
    description text
);
 %   DROP TABLE public.shoppingitemfield;
       public         dotcmsdbuser    false    3            �            1259    59959    shoppingitemprice    TABLE     S  CREATE TABLE public.shoppingitemprice (
    itempriceid character varying(100) NOT NULL,
    itemid character varying(100),
    minquantity integer,
    maxquantity integer,
    price double precision,
    discount double precision,
    taxable boolean,
    shipping double precision,
    useshippingformula boolean,
    status integer
);
 %   DROP TABLE public.shoppingitemprice;
       public         dotcmsdbuser    false    3            �            1259    59964    shoppingorder    TABLE       CREATE TABLE public.shoppingorder (
    orderid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    tax double precision,
    shipping double precision,
    altshipping character varying(100),
    requiresshipping boolean,
    couponids text,
    coupondiscount double precision,
    billingfirstname character varying(100),
    billinglastname character varying(100),
    billingemailaddress character varying(100),
    billingcompany character varying(100),
    billingstreet character varying(100),
    billingcity character varying(100),
    billingstate character varying(100),
    billingzip character varying(100),
    billingcountry character varying(100),
    billingphone character varying(100),
    shiptobilling boolean,
    shippingfirstname character varying(100),
    shippinglastname character varying(100),
    shippingemailaddress character varying(100),
    shippingcompany character varying(100),
    shippingstreet character varying(100),
    shippingcity character varying(100),
    shippingstate character varying(100),
    shippingzip character varying(100),
    shippingcountry character varying(100),
    shippingphone character varying(100),
    ccname character varying(100),
    cctype character varying(100),
    ccnumber character varying(100),
    ccexpmonth integer,
    ccexpyear integer,
    ccvernumber character varying(100),
    comments text,
    pptxnid character varying(100),
    pppaymentstatus character varying(100),
    pppaymentgross double precision,
    ppreceiveremail character varying(100),
    pppayeremail character varying(100),
    sendorderemail boolean,
    sendshippingemail boolean
);
 !   DROP TABLE public.shoppingorder;
       public         dotcmsdbuser    false    3            �            1259    59972    shoppingorderitem    TABLE     y  CREATE TABLE public.shoppingorderitem (
    orderid character varying(100) NOT NULL,
    itemid character varying(100) NOT NULL,
    sku character varying(100),
    name character varying(100),
    description text,
    properties text,
    supplieruserid character varying(100),
    price double precision,
    quantity integer,
    shippeddate timestamp without time zone
);
 %   DROP TABLE public.shoppingorderitem;
       public         dotcmsdbuser    false    3            �           1259    61815    sitelic    TABLE     �   CREATE TABLE public.sitelic (
    id character varying(36) NOT NULL,
    serverid character varying(100),
    license text NOT NULL,
    lastping timestamp without time zone NOT NULL
);
    DROP TABLE public.sitelic;
       public         dotcmsdbuser    false    3            �           1259    61691    sitesearch_audit    TABLE     �  CREATE TABLE public.sitesearch_audit (
    job_id character varying(36) NOT NULL,
    job_name character varying(255) NOT NULL,
    fire_date timestamp without time zone NOT NULL,
    incremental boolean NOT NULL,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    host_list character varying(500) NOT NULL,
    all_hosts boolean NOT NULL,
    lang_list character varying(500) NOT NULL,
    path character varying(500) NOT NULL,
    path_include boolean NOT NULL,
    files_count integer NOT NULL,
    pages_count integer NOT NULL,
    urlmaps_count integer NOT NULL,
    index_name character varying(100) NOT NULL
);
 $   DROP TABLE public.sitesearch_audit;
       public         dotcmsdbuser    false    3            �            1259    59914    skin    TABLE     �  CREATE TABLE public.skin (
    skinid character varying(100) NOT NULL,
    name character varying(100),
    imageid character varying(100),
    alphalayerid character varying(100),
    alphaskinid character varying(100),
    betalayerid character varying(100),
    betaskinid character varying(100),
    gammalayerid character varying(100),
    gammaskinid character varying(100),
    bglayerid character varying(100),
    bgskinid character varying(100)
);
    DROP TABLE public.skin;
       public         dotcmsdbuser    false    3            .           1259    60383 	   structure    TABLE       CREATE TABLE public.structure (
    inode character varying(36) NOT NULL,
    name character varying(255),
    description character varying(255),
    default_structure boolean,
    review_interval character varying(255),
    reviewer_role character varying(255),
    page_detail character varying(36),
    structuretype integer,
    system boolean,
    fixed boolean DEFAULT false NOT NULL,
    velocity_var_name character varying(255) NOT NULL,
    url_map_pattern character varying(512),
    host character varying(36) DEFAULT 'SYSTEM_HOST'::character varying NOT NULL,
    folder character varying(36) DEFAULT 'SYSTEM_FOLDER'::character varying NOT NULL,
    expire_date_var character varying(255),
    publish_date_var character varying(255),
    mod_date timestamp without time zone
);
    DROP TABLE public.structure;
       public         dotcmsdbuser    false    3            �           1259    61828    structures_ir    TABLE     �   CREATE TABLE public.structures_ir (
    velocity_name character varying(255),
    local_inode character varying(36) NOT NULL,
    remote_inode character varying(36),
    endpoint_id character varying(36) NOT NULL
);
 !   DROP TABLE public.structures_ir;
       public         dotcmsdbuser    false    3            o           1259    61008    summary_404_seq    SEQUENCE     x   CREATE SEQUENCE public.summary_404_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.summary_404_seq;
       public       dotcmsdbuser    false    3            r           1259    61014    summary_content_seq    SEQUENCE     |   CREATE SEQUENCE public.summary_content_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.summary_content_seq;
       public       dotcmsdbuser    false    3            s           1259    61016    summary_pages_seq    SEQUENCE     z   CREATE SEQUENCE public.summary_pages_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.summary_pages_seq;
       public       dotcmsdbuser    false    3            u           1259    61020    summary_period_seq    SEQUENCE     {   CREATE SEQUENCE public.summary_period_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.summary_period_seq;
       public       dotcmsdbuser    false    3            t           1259    61018    summary_referer_seq    SEQUENCE     |   CREATE SEQUENCE public.summary_referer_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.summary_referer_seq;
       public       dotcmsdbuser    false    3            e           1259    60988    summary_seq    SEQUENCE     t   CREATE SEQUENCE public.summary_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.summary_seq;
       public       dotcmsdbuser    false    3            l           1259    61002    summary_visits_seq    SEQUENCE     {   CREATE SEQUENCE public.summary_visits_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.summary_visits_seq;
       public       dotcmsdbuser    false    3                       1259    60254    tag    TABLE     �   CREATE TABLE public.tag (
    tag_id character varying(100) NOT NULL,
    tagname character varying(255),
    host_id character varying(255) DEFAULT 'SYSTEM_HOST'::character varying,
    user_id text
);
    DROP TABLE public.tag;
       public         dotcmsdbuser    false    3            C           1259    60542 	   tag_inode    TABLE     y   CREATE TABLE public.tag_inode (
    tag_id character varying(100) NOT NULL,
    inode character varying(100) NOT NULL
);
    DROP TABLE public.tag_inode;
       public         dotcmsdbuser    false    3            ,           1259    60367    template    TABLE     /  CREATE TABLE public.template (
    inode character varying(36) NOT NULL,
    show_on_menu boolean,
    title character varying(255),
    mod_date timestamp without time zone,
    mod_user character varying(100),
    sort_order integer,
    friendly_name character varying(255),
    body text,
    header text,
    footer text,
    image character varying(36),
    identifier character varying(36),
    drawed boolean,
    drawed_body text,
    add_container_links integer,
    containers_added integer,
    head_code text,
    theme character varying(255)
);
    DROP TABLE public.template;
       public         dotcmsdbuser    false    3            b           1259    60763    template_containers    TABLE     �   CREATE TABLE public.template_containers (
    id character varying(36) NOT NULL,
    template_id character varying(36) NOT NULL,
    container_id character varying(36) NOT NULL
);
 '   DROP TABLE public.template_containers;
       public         dotcmsdbuser    false    3            ;           1259    60485    template_version_info    TABLE     Y  CREATE TABLE public.template_version_info (
    identifier character varying(36) NOT NULL,
    working_inode character varying(36) NOT NULL,
    live_inode character varying(36),
    deleted boolean NOT NULL,
    locked_by character varying(100),
    locked_on timestamp without time zone,
    version_ts timestamp without time zone NOT NULL
);
 )   DROP TABLE public.template_version_info;
       public         dotcmsdbuser    false    3            "           1259    60295 	   trackback    TABLE     '  CREATE TABLE public.trackback (
    id bigint NOT NULL,
    asset_identifier character varying(36),
    title character varying(255),
    excerpt character varying(255),
    url character varying(255),
    blog_name character varying(255),
    track_date timestamp without time zone NOT NULL
);
    DROP TABLE public.trackback;
       public         dotcmsdbuser    false    3            i           1259    60996    trackback_sequence    SEQUENCE     {   CREATE SEQUENCE public.trackback_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.trackback_sequence;
       public       dotcmsdbuser    false    3            )           1259    60350    tree    TABLE     �   CREATE TABLE public.tree (
    child character varying(36) NOT NULL,
    parent character varying(36) NOT NULL,
    relation_type character varying(64) NOT NULL,
    tree_order integer
);
    DROP TABLE public.tree;
       public         dotcmsdbuser    false    3            �            1259    59980    user_    TABLE       CREATE TABLE public.user_ (
    userid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    createdate timestamp without time zone,
    password_ character varying(100),
    passwordencrypted boolean,
    passwordexpirationdate timestamp without time zone,
    passwordreset boolean,
    firstname character varying(100),
    middlename character varying(100),
    lastname character varying(100),
    nickname character varying(100),
    male boolean,
    birthday timestamp without time zone,
    emailaddress character varying(100),
    smsid character varying(100),
    aimid character varying(100),
    icqid character varying(100),
    msnid character varying(100),
    ymid character varying(100),
    favoriteactivity character varying(100),
    favoritebibleverse character varying(100),
    favoritefood character varying(100),
    favoritemovie character varying(100),
    favoritemusic character varying(100),
    languageid character varying(100),
    timezoneid character varying(100),
    skinid character varying(100),
    dottedskins boolean,
    roundedskins boolean,
    greeting character varying(100),
    resolution character varying(100),
    refreshrate character varying(100),
    layoutids character varying(100),
    comments text,
    logindate timestamp without time zone,
    loginip character varying(100),
    lastlogindate timestamp without time zone,
    lastloginip character varying(100),
    failedloginattempts integer,
    agreedtotermsofuse boolean,
    active_ boolean
);
    DROP TABLE public.user_;
       public         dotcmsdbuser    false    3                       1259    60262    user_comments    TABLE     n  CREATE TABLE public.user_comments (
    inode character varying(36) NOT NULL,
    user_id character varying(255),
    cdate timestamp without time zone,
    comment_user_id character varying(100),
    type character varying(255),
    method character varying(255),
    subject character varying(255),
    ucomment text,
    communication_id character varying(36)
);
 !   DROP TABLE public.user_comments;
       public         dotcmsdbuser    false    3            c           1259    60768    user_filter    TABLE     u  CREATE TABLE public.user_filter (
    inode character varying(36) NOT NULL,
    title character varying(255),
    firstname character varying(100),
    middlename character varying(100),
    lastname character varying(100),
    emailaddress character varying(100),
    birthdaytypesearch character varying(100),
    birthday timestamp without time zone,
    birthdayfrom timestamp without time zone,
    birthdayto timestamp without time zone,
    lastlogintypesearch character varying(100),
    lastloginsince character varying(100),
    loginfrom timestamp without time zone,
    loginto timestamp without time zone,
    createdtypesearch character varying(100),
    createdsince character varying(100),
    createdfrom timestamp without time zone,
    createdto timestamp without time zone,
    lastvisittypesearch character varying(100),
    lastvisitsince character varying(100),
    lastvisitfrom timestamp without time zone,
    lastvisitto timestamp without time zone,
    city character varying(100),
    state character varying(100),
    country character varying(100),
    zip character varying(100),
    cell character varying(100),
    phone character varying(100),
    fax character varying(100),
    active_ character varying(255),
    tagname character varying(255),
    var1 character varying(255),
    var2 character varying(255),
    var3 character varying(255),
    var4 character varying(255),
    var5 character varying(255),
    var6 character varying(255),
    var7 character varying(255),
    var8 character varying(255),
    var9 character varying(255),
    var10 character varying(255),
    var11 character varying(255),
    var12 character varying(255),
    var13 character varying(255),
    var14 character varying(255),
    var15 character varying(255),
    var16 character varying(255),
    var17 character varying(255),
    var18 character varying(255),
    var19 character varying(255),
    var20 character varying(255),
    var21 character varying(255),
    var22 character varying(255),
    var23 character varying(255),
    var24 character varying(255),
    var25 character varying(255),
    categories character varying(255)
);
    DROP TABLE public.user_filter;
       public         dotcmsdbuser    false    3            <           1259    60490    user_preferences    TABLE     �   CREATE TABLE public.user_preferences (
    id bigint NOT NULL,
    user_id character varying(100) NOT NULL,
    preference character varying(255),
    pref_value text
);
 $   DROP TABLE public.user_preferences;
       public         dotcmsdbuser    false    3            f           1259    60990    user_preferences_seq    SEQUENCE     }   CREATE SEQUENCE public.user_preferences_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.user_preferences_seq;
       public       dotcmsdbuser    false    3            W           1259    60672 
   user_proxy    TABLE        CREATE TABLE public.user_proxy (
    inode character varying(36) NOT NULL,
    user_id character varying(255),
    prefix character varying(255),
    suffix character varying(255),
    title character varying(255),
    school character varying(255),
    how_heard character varying(255),
    company character varying(255),
    long_lived_cookie character varying(255),
    website character varying(255),
    graduation_year integer,
    organization character varying(255),
    mail_subscription boolean,
    var1 character varying(255),
    var2 character varying(255),
    var3 character varying(255),
    var4 character varying(255),
    var5 character varying(255),
    var6 character varying(255),
    var7 character varying(255),
    var8 character varying(255),
    var9 character varying(255),
    var10 character varying(255),
    var11 character varying(255),
    var12 character varying(255),
    var13 character varying(255),
    var14 character varying(255),
    var15 character varying(255),
    var16 character varying(255),
    var17 character varying(255),
    var18 character varying(255),
    var19 character varying(255),
    var20 character varying(255),
    var21 character varying(255),
    var22 character varying(255),
    var23 character varying(255),
    var24 character varying(255),
    var25 character varying(255),
    last_result integer,
    last_message character varying(255),
    no_click_tracking boolean,
    cquestionid character varying(255),
    cqanswer character varying(255),
    chapter_officer character varying(255)
);
    DROP TABLE public.user_proxy;
       public         dotcmsdbuser    false    3            y           1259    61028    user_to_delete_seq    SEQUENCE     {   CREATE SEQUENCE public.user_to_delete_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.user_to_delete_seq;
       public       dotcmsdbuser    false    3            +           1259    60362    users_cms_roles    TABLE     �   CREATE TABLE public.users_cms_roles (
    id character varying(36) NOT NULL,
    user_id character varying(100) NOT NULL,
    role_id character varying(36) NOT NULL
);
 #   DROP TABLE public.users_cms_roles;
       public         dotcmsdbuser    false    3            �            1259    59988    users_projprojects    TABLE     �   CREATE TABLE public.users_projprojects (
    userid character varying(100) NOT NULL,
    projectid character varying(100) NOT NULL
);
 &   DROP TABLE public.users_projprojects;
       public         dotcmsdbuser    false    3            �            1259    59991    users_projtasks    TABLE     �   CREATE TABLE public.users_projtasks (
    userid character varying(100) NOT NULL,
    taskid character varying(100) NOT NULL
);
 #   DROP TABLE public.users_projtasks;
       public         dotcmsdbuser    false    3            >           1259    60506    users_to_delete    TABLE     d   CREATE TABLE public.users_to_delete (
    id bigint NOT NULL,
    user_id character varying(255)
);
 #   DROP TABLE public.users_to_delete;
       public         dotcmsdbuser    false    3            �            1259    59994    usertracker    TABLE     T  CREATE TABLE public.usertracker (
    usertrackerid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    modifieddate timestamp without time zone,
    remoteaddr character varying(100),
    remotehost character varying(100),
    useragent character varying(100)
);
    DROP TABLE public.usertracker;
       public         dotcmsdbuser    false    3            �            1259    60002    usertrackerpath    TABLE     �   CREATE TABLE public.usertrackerpath (
    usertrackerpathid character varying(100) NOT NULL,
    usertrackerid character varying(100) NOT NULL,
    path text NOT NULL,
    pathdate timestamp without time zone NOT NULL
);
 #   DROP TABLE public.usertrackerpath;
       public         dotcmsdbuser    false    3            '           1259    60335    virtual_link    TABLE     �   CREATE TABLE public.virtual_link (
    inode character varying(36) NOT NULL,
    title character varying(255),
    url character varying(255),
    uri character varying(255),
    active boolean
);
     DROP TABLE public.virtual_link;
       public         dotcmsdbuser    false    3            &           1259    60327    web_form    TABLE     w  CREATE TABLE public.web_form (
    web_form_id character varying(36) NOT NULL,
    form_type character varying(255),
    submit_date timestamp without time zone,
    prefix character varying(255),
    first_name character varying(255),
    middle_initial character varying(255),
    middle_name character varying(255),
    full_name character varying(255),
    organization character varying(255),
    title character varying(255),
    last_name character varying(255),
    address character varying(255),
    address1 character varying(255),
    address2 character varying(255),
    city character varying(255),
    state character varying(255),
    zip character varying(255),
    country character varying(255),
    phone character varying(255),
    email character varying(255),
    custom_fields text,
    user_inode character varying(100),
    categories character varying(255)
);
    DROP TABLE public.web_form;
       public         dotcmsdbuser    false    3            �            1259    60010    wikidisplay    TABLE     �   CREATE TABLE public.wikidisplay (
    layoutid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    portletid character varying(100) NOT NULL,
    nodeid character varying(100) NOT NULL,
    showborders boolean
);
    DROP TABLE public.wikidisplay;
       public         dotcmsdbuser    false    3                        1259    60015    wikinode    TABLE     �  CREATE TABLE public.wikinode (
    nodeid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    username character varying(100),
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    readroles character varying(100),
    writeroles character varying(100),
    name character varying(100),
    description text,
    sharing boolean,
    lastpostdate timestamp without time zone
);
    DROP TABLE public.wikinode;
       public         dotcmsdbuser    false    3                       1259    60023    wikipage    TABLE     �  CREATE TABLE public.wikipage (
    nodeid character varying(100) NOT NULL,
    title character varying(100) NOT NULL,
    version double precision NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    username character varying(100),
    createdate timestamp without time zone,
    content text,
    format character varying(100),
    head boolean
);
    DROP TABLE public.wikipage;
       public         dotcmsdbuser    false    3            �           1259    61488    workflow_action    TABLE     A  CREATE TABLE public.workflow_action (
    id character varying(36) NOT NULL,
    step_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    condition_to_progress text,
    next_step_id character varying(36) NOT NULL,
    next_assign character varying(36) NOT NULL,
    my_order integer DEFAULT 0,
    assignable boolean DEFAULT false,
    commentable boolean DEFAULT false,
    requires_checkout boolean DEFAULT false,
    icon character varying(255) DEFAULT 'defaultWfIcon'::character varying,
    use_role_hierarchy_assign boolean DEFAULT false
);
 #   DROP TABLE public.workflow_action;
       public         dotcmsdbuser    false    3            �           1259    61518    workflow_action_class    TABLE     �   CREATE TABLE public.workflow_action_class (
    id character varying(36) NOT NULL,
    action_id character varying(36),
    name character varying(255) NOT NULL,
    my_order integer DEFAULT 0,
    clazz text
);
 )   DROP TABLE public.workflow_action_class;
       public         dotcmsdbuser    false    3            �           1259    61533    workflow_action_class_pars    TABLE     �   CREATE TABLE public.workflow_action_class_pars (
    id character varying(36) NOT NULL,
    workflow_action_class_id character varying(36),
    key character varying(255) NOT NULL,
    value text
);
 .   DROP TABLE public.workflow_action_class_pars;
       public         dotcmsdbuser    false    3            6           1259    60446    workflow_comment    TABLE     �   CREATE TABLE public.workflow_comment (
    id character varying(36) NOT NULL,
    creation_date timestamp without time zone,
    posted_by character varying(255),
    wf_comment text,
    workflowtask_id character varying(36)
);
 $   DROP TABLE public.workflow_comment;
       public         dotcmsdbuser    false    3            T           1259    60648    workflow_history    TABLE     >  CREATE TABLE public.workflow_history (
    id character varying(36) NOT NULL,
    creation_date timestamp without time zone,
    made_by character varying(255),
    change_desc text,
    workflowtask_id character varying(36),
    workflow_action_id character varying(36),
    workflow_step_id character varying(36)
);
 $   DROP TABLE public.workflow_history;
       public         dotcmsdbuser    false    3            �           1259    61460    workflow_scheme    TABLE     W  CREATE TABLE public.workflow_scheme (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    archived boolean DEFAULT false,
    mandatory boolean DEFAULT false,
    default_scheme boolean DEFAULT false,
    entry_action_id character varying(36),
    mod_date timestamp without time zone
);
 #   DROP TABLE public.workflow_scheme;
       public         dotcmsdbuser    false    3            �           1259    61547    workflow_scheme_x_structure    TABLE     �   CREATE TABLE public.workflow_scheme_x_structure (
    id character varying(36) NOT NULL,
    scheme_id character varying(36),
    structure_id character varying(36)
);
 /   DROP TABLE public.workflow_scheme_x_structure;
       public         dotcmsdbuser    false    3            �           1259    61473    workflow_step    TABLE     a  CREATE TABLE public.workflow_step (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    scheme_id character varying(36),
    my_order integer DEFAULT 0,
    resolved boolean DEFAULT false,
    escalation_enable boolean DEFAULT false,
    escalation_action character varying(36),
    escalation_time integer DEFAULT 0
);
 !   DROP TABLE public.workflow_step;
       public         dotcmsdbuser    false    3            B           1259    60534    workflow_task    TABLE     �  CREATE TABLE public.workflow_task (
    id character varying(36) NOT NULL,
    creation_date timestamp without time zone,
    mod_date timestamp without time zone,
    due_date timestamp without time zone,
    created_by character varying(255),
    assigned_to character varying(255),
    belongs_to character varying(255),
    title character varying(255),
    description text,
    status character varying(255),
    webasset character varying(255)
);
 !   DROP TABLE public.workflow_task;
       public         dotcmsdbuser    false    3            O           1259    60617    workflowtask_files    TABLE     �   CREATE TABLE public.workflowtask_files (
    id character varying(36) NOT NULL,
    workflowtask_id character varying(36) NOT NULL,
    file_inode character varying(36) NOT NULL
);
 &   DROP TABLE public.workflowtask_files;
       public         dotcmsdbuser    false    3            v           1259    61022    workstream_seq    SEQUENCE     w   CREATE SEQUENCE public.workstream_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.workstream_seq;
       public       dotcmsdbuser    false    3            r           2604    61089    dist_journal id    DEFAULT     r   ALTER TABLE ONLY public.dist_journal ALTER COLUMN id SET DEFAULT nextval('public.dist_journal_id_seq'::regclass);
 >   ALTER TABLE public.dist_journal ALTER COLUMN id DROP DEFAULT;
       public       dotcmsdbuser    false    381    380    381            s           2604    61115    dist_process id    DEFAULT     r   ALTER TABLE ONLY public.dist_process ALTER COLUMN id SET DEFAULT nextval('public.dist_process_id_seq'::regclass);
 >   ALTER TABLE public.dist_process ALTER COLUMN id DROP DEFAULT;
       public       dotcmsdbuser    false    383    384    384            t           2604    61127    dist_reindex_journal id    DEFAULT     �   ALTER TABLE ONLY public.dist_reindex_journal ALTER COLUMN id SET DEFAULT nextval('public.dist_reindex_journal_id_seq'::regclass);
 F   ALTER TABLE public.dist_reindex_journal ALTER COLUMN id DROP DEFAULT;
       public       dotcmsdbuser    false    386    385    386            �           2604    61704    publishing_queue id    DEFAULT     z   ALTER TABLE ONLY public.publishing_queue ALTER COLUMN id SET DEFAULT nextval('public.publishing_queue_id_seq'::regclass);
 B   ALTER TABLE public.publishing_queue ALTER COLUMN id DROP DEFAULT;
       public       dotcmsdbuser    false    403    404    404            w           2604    61148    quartz_log id    DEFAULT     n   ALTER TABLE ONLY public.quartz_log ALTER COLUMN id SET DEFAULT nextval('public.quartz_log_id_seq'::regclass);
 <   ALTER TABLE public.quartz_log ALTER COLUMN id DROP DEFAULT;
       public       dotcmsdbuser    false    387    388    388            �           2606    59544    abcontact abcontact_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.abcontact
    ADD CONSTRAINT abcontact_pkey PRIMARY KEY (contactid);
 B   ALTER TABLE ONLY public.abcontact DROP CONSTRAINT abcontact_pkey;
       public         dotcmsdbuser    false    186    186            �           2606    59552    ablist ablist_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.ablist
    ADD CONSTRAINT ablist_pkey PRIMARY KEY (listid);
 <   ALTER TABLE ONLY public.ablist DROP CONSTRAINT ablist_pkey;
       public         dotcmsdbuser    false    188    188            �           2606    59560    address address_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (addressid);
 >   ALTER TABLE ONLY public.address DROP CONSTRAINT address_pkey;
       public         dotcmsdbuser    false    189    189            �           2606    59568    adminconfig adminconfig_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.adminconfig
    ADD CONSTRAINT adminconfig_pkey PRIMARY KEY (configid);
 F   ALTER TABLE ONLY public.adminconfig DROP CONSTRAINT adminconfig_pkey;
       public         dotcmsdbuser    false    190    190            �           2606    60432 .   analytic_summary_404 analytic_summary_404_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.analytic_summary_404
    ADD CONSTRAINT analytic_summary_404_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.analytic_summary_404 DROP CONSTRAINT analytic_summary_404_pkey;
       public         dotcmsdbuser    false    307    307            �           2606    60382 6   analytic_summary_content analytic_summary_content_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.analytic_summary_content
    ADD CONSTRAINT analytic_summary_content_pkey PRIMARY KEY (id);
 `   ALTER TABLE ONLY public.analytic_summary_content DROP CONSTRAINT analytic_summary_content_pkey;
       public         dotcmsdbuser    false    301    301            F           2606    60253 2   analytic_summary_pages analytic_summary_pages_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.analytic_summary_pages
    ADD CONSTRAINT analytic_summary_pages_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.analytic_summary_pages DROP CONSTRAINT analytic_summary_pages_pkey;
       public         dotcmsdbuser    false    283    283            y           2606    60349 =   analytic_summary_period analytic_summary_period_full_date_key 
   CONSTRAINT     }   ALTER TABLE ONLY public.analytic_summary_period
    ADD CONSTRAINT analytic_summary_period_full_date_key UNIQUE (full_date);
 g   ALTER TABLE ONLY public.analytic_summary_period DROP CONSTRAINT analytic_summary_period_full_date_key;
       public         dotcmsdbuser    false    296    296            {           2606    60347 4   analytic_summary_period analytic_summary_period_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.analytic_summary_period
    ADD CONSTRAINT analytic_summary_period_pkey PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.analytic_summary_period DROP CONSTRAINT analytic_summary_period_pkey;
       public         dotcmsdbuser    false    296    296            �           2606    60359 &   analytic_summary analytic_summary_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.analytic_summary
    ADD CONSTRAINT analytic_summary_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.analytic_summary DROP CONSTRAINT analytic_summary_pkey;
       public         dotcmsdbuser    false    298    298            +           2606    60626 6   analytic_summary_referer analytic_summary_referer_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.analytic_summary_referer
    ADD CONSTRAINT analytic_summary_referer_pkey PRIMARY KEY (id);
 `   ALTER TABLE ONLY public.analytic_summary_referer DROP CONSTRAINT analytic_summary_referer_pkey;
       public         dotcmsdbuser    false    336    336            �           2606    60361 ?   analytic_summary analytic_summary_summary_period_id_host_id_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.analytic_summary
    ADD CONSTRAINT analytic_summary_summary_period_id_host_id_key UNIQUE (summary_period_id, host_id);
 i   ALTER TABLE ONLY public.analytic_summary DROP CONSTRAINT analytic_summary_summary_period_id_host_id_key;
       public         dotcmsdbuser    false    298    298    298            �           2606    60484 4   analytic_summary_visits analytic_summary_visits_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.analytic_summary_visits
    ADD CONSTRAINT analytic_summary_visits_pkey PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.analytic_summary_visits DROP CONSTRAINT analytic_summary_visits_pkey;
       public         dotcmsdbuser    false    314    314                       2606    60598 <   analytic_summary_workstream analytic_summary_workstream_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.analytic_summary_workstream
    ADD CONSTRAINT analytic_summary_workstream_pkey PRIMARY KEY (id);
 f   ALTER TABLE ONLY public.analytic_summary_workstream DROP CONSTRAINT analytic_summary_workstream_pkey;
       public         dotcmsdbuser    false    331    331            �           2606    59582    bjentry bjentry_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.bjentry
    ADD CONSTRAINT bjentry_pkey PRIMARY KEY (entryid);
 >   ALTER TABLE ONLY public.bjentry DROP CONSTRAINT bjentry_pkey;
       public         dotcmsdbuser    false    193    193            �           2606    59590    bjtopic bjtopic_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.bjtopic
    ADD CONSTRAINT bjtopic_pkey PRIMARY KEY (topicid);
 >   ALTER TABLE ONLY public.bjtopic DROP CONSTRAINT bjtopic_pkey;
       public         dotcmsdbuser    false    194    194            �           2606    59595    bjverse bjverse_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.bjverse
    ADD CONSTRAINT bjverse_pkey PRIMARY KEY (verseid);
 >   ALTER TABLE ONLY public.bjverse DROP CONSTRAINT bjverse_pkey;
       public         dotcmsdbuser    false    195    195            �           2606    59600     blogscategory blogscategory_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.blogscategory
    ADD CONSTRAINT blogscategory_pkey PRIMARY KEY (categoryid);
 J   ALTER TABLE ONLY public.blogscategory DROP CONSTRAINT blogscategory_pkey;
       public         dotcmsdbuser    false    196    196            �           2606    59608     blogscomments blogscomments_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.blogscomments
    ADD CONSTRAINT blogscomments_pkey PRIMARY KEY (commentsid);
 J   ALTER TABLE ONLY public.blogscomments DROP CONSTRAINT blogscomments_pkey;
       public         dotcmsdbuser    false    197    197            �           2606    59616    blogsentry blogsentry_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.blogsentry
    ADD CONSTRAINT blogsentry_pkey PRIMARY KEY (entryid);
 D   ALTER TABLE ONLY public.blogsentry DROP CONSTRAINT blogsentry_pkey;
       public         dotcmsdbuser    false    198    198            �           2606    59624    blogslink blogslink_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.blogslink
    ADD CONSTRAINT blogslink_pkey PRIMARY KEY (linkid);
 B   ALTER TABLE ONLY public.blogslink DROP CONSTRAINT blogslink_pkey;
       public         dotcmsdbuser    false    199    199            �           2606    59632    blogsprops blogsprops_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.blogsprops
    ADD CONSTRAINT blogsprops_pkey PRIMARY KEY (propsid);
 D   ALTER TABLE ONLY public.blogsprops DROP CONSTRAINT blogsprops_pkey;
       public         dotcmsdbuser    false    200    200            �           2606    59637    blogsreferer blogsreferer_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.blogsreferer
    ADD CONSTRAINT blogsreferer_pkey PRIMARY KEY (entryid, url, type_);
 H   ALTER TABLE ONLY public.blogsreferer DROP CONSTRAINT blogsreferer_pkey;
       public         dotcmsdbuser    false    201    201    201    201            �           2606    59642    blogsuser blogsuser_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.blogsuser
    ADD CONSTRAINT blogsuser_pkey PRIMARY KEY (userid);
 B   ALTER TABLE ONLY public.blogsuser DROP CONSTRAINT blogsuser_pkey;
       public         dotcmsdbuser    false    202    202            �           2606    59650 "   bookmarksentry bookmarksentry_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.bookmarksentry
    ADD CONSTRAINT bookmarksentry_pkey PRIMARY KEY (entryid);
 L   ALTER TABLE ONLY public.bookmarksentry DROP CONSTRAINT bookmarksentry_pkey;
       public         dotcmsdbuser    false    203    203            �           2606    59655 $   bookmarksfolder bookmarksfolder_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.bookmarksfolder
    ADD CONSTRAINT bookmarksfolder_pkey PRIMARY KEY (folderid);
 N   ALTER TABLE ONLY public.bookmarksfolder DROP CONSTRAINT bookmarksfolder_pkey;
       public         dotcmsdbuser    false    204    204            �           2606    61642    broken_link broken_link_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.broken_link
    ADD CONSTRAINT broken_link_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.broken_link DROP CONSTRAINT broken_link_pkey;
       public         dotcmsdbuser    false    398    398            D           2606    60245 (   calendar_reminder calendar_reminder_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.calendar_reminder
    ADD CONSTRAINT calendar_reminder_pkey PRIMARY KEY (user_id, event_id, send_date);
 R   ALTER TABLE ONLY public.calendar_reminder DROP CONSTRAINT calendar_reminder_pkey;
       public         dotcmsdbuser    false    282    282    282    282            �           2606    59663    calevent calevent_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.calevent
    ADD CONSTRAINT calevent_pkey PRIMARY KEY (eventid);
 @   ALTER TABLE ONLY public.calevent DROP CONSTRAINT calevent_pkey;
       public         dotcmsdbuser    false    205    205            �           2606    59671    caltask caltask_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.caltask
    ADD CONSTRAINT caltask_pkey PRIMARY KEY (taskid);
 >   ALTER TABLE ONLY public.caltask DROP CONSTRAINT caltask_pkey;
       public         dotcmsdbuser    false    206    206                       2606    60611    campaign campaign_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.campaign
    ADD CONSTRAINT campaign_pkey PRIMARY KEY (inode);
 @   ALTER TABLE ONLY public.campaign DROP CONSTRAINT campaign_pkey;
       public         dotcmsdbuser    false    333    333            �           2606    60461    category category_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (inode);
 @   ALTER TABLE ONLY public.category DROP CONSTRAINT category_pkey;
       public         dotcmsdbuser    false    311    311            _           2606    60757    chain chain_key_name_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.chain
    ADD CONSTRAINT chain_key_name_key UNIQUE (key_name);
 B   ALTER TABLE ONLY public.chain DROP CONSTRAINT chain_key_name_key;
       public         dotcmsdbuser    false    352    352            �           2606    60479 .   chain_link_code chain_link_code_class_name_key 
   CONSTRAINT     o   ALTER TABLE ONLY public.chain_link_code
    ADD CONSTRAINT chain_link_code_class_name_key UNIQUE (class_name);
 X   ALTER TABLE ONLY public.chain_link_code DROP CONSTRAINT chain_link_code_class_name_key;
       public         dotcmsdbuser    false    313    313            �           2606    60477 $   chain_link_code chain_link_code_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.chain_link_code
    ADD CONSTRAINT chain_link_code_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.chain_link_code DROP CONSTRAINT chain_link_code_pkey;
       public         dotcmsdbuser    false    313    313            a           2606    60755    chain chain_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.chain
    ADD CONSTRAINT chain_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.chain DROP CONSTRAINT chain_pkey;
       public         dotcmsdbuser    false    352    352            B           2606    60689 0   chain_state_parameter chain_state_parameter_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.chain_state_parameter
    ADD CONSTRAINT chain_state_parameter_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.chain_state_parameter DROP CONSTRAINT chain_state_parameter_pkey;
       public         dotcmsdbuser    false    344    344                       2606    60590    chain_state chain_state_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.chain_state
    ADD CONSTRAINT chain_state_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.chain_state DROP CONSTRAINT chain_state_pkey;
       public         dotcmsdbuser    false    330    330                       2606    60556 *   challenge_question challenge_question_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public.challenge_question
    ADD CONSTRAINT challenge_question_pkey PRIMARY KEY (cquestionid);
 T   ALTER TABLE ONLY public.challenge_question DROP CONSTRAINT challenge_question_pkey;
       public         dotcmsdbuser    false    325    325                       2606    60551    click click_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.click
    ADD CONSTRAINT click_pkey PRIMARY KEY (inode);
 :   ALTER TABLE ONLY public.click DROP CONSTRAINT click_pkey;
       public         dotcmsdbuser    false    324    324            P           2606    60721 $   clickstream_404 clickstream_404_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.clickstream_404
    ADD CONSTRAINT clickstream_404_pkey PRIMARY KEY (clickstream_404_id);
 N   ALTER TABLE ONLY public.clickstream_404 DROP CONSTRAINT clickstream_404_pkey;
       public         dotcmsdbuser    false    348    348            �           2606    60528    clickstream clickstream_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.clickstream
    ADD CONSTRAINT clickstream_pkey PRIMARY KEY (clickstream_id);
 F   ALTER TABLE ONLY public.clickstream DROP CONSTRAINT clickstream_pkey;
       public         dotcmsdbuser    false    320    320                       2606    60577 ,   clickstream_request clickstream_request_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY public.clickstream_request
    ADD CONSTRAINT clickstream_request_pkey PRIMARY KEY (clickstream_request_id);
 V   ALTER TABLE ONLY public.clickstream_request DROP CONSTRAINT clickstream_request_pkey;
       public         dotcmsdbuser    false    328    328            �           2606    61861 0   cluster_server_action cluster_server_action_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public.cluster_server_action
    ADD CONSTRAINT cluster_server_action_pkey PRIMARY KEY (server_action_id);
 Z   ALTER TABLE ONLY public.cluster_server_action DROP CONSTRAINT cluster_server_action_pkey;
       public         dotcmsdbuser    false    418    418            �           2606    61746 "   cluster_server cluster_server_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.cluster_server
    ADD CONSTRAINT cluster_server_pkey PRIMARY KEY (server_id);
 L   ALTER TABLE ONLY public.cluster_server DROP CONSTRAINT cluster_server_pkey;
       public         dotcmsdbuser    false    409    409            �           2606    61756 0   cluster_server_uptime cluster_server_uptime_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.cluster_server_uptime
    ADD CONSTRAINT cluster_server_uptime_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.cluster_server_uptime DROP CONSTRAINT cluster_server_uptime_pkey;
       public         dotcmsdbuser    false    410    410            U           2606    61173 !   cms_layout cms_layout_name_parent 
   CONSTRAINT     c   ALTER TABLE ONLY public.cms_layout
    ADD CONSTRAINT cms_layout_name_parent UNIQUE (layout_name);
 K   ALTER TABLE ONLY public.cms_layout DROP CONSTRAINT cms_layout_name_parent;
       public         dotcmsdbuser    false    349    349            W           2606    60729    cms_layout cms_layout_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.cms_layout
    ADD CONSTRAINT cms_layout_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.cms_layout DROP CONSTRAINT cms_layout_pkey;
       public         dotcmsdbuser    false    349    349            �           2606    61177 1   cms_layouts_portlets cms_layouts_portlets_parent1 
   CONSTRAINT     }   ALTER TABLE ONLY public.cms_layouts_portlets
    ADD CONSTRAINT cms_layouts_portlets_parent1 UNIQUE (layout_id, portlet_id);
 [   ALTER TABLE ONLY public.cms_layouts_portlets DROP CONSTRAINT cms_layouts_portlets_parent1;
       public         dotcmsdbuser    false    308    308    308            �           2606    60437 .   cms_layouts_portlets cms_layouts_portlets_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.cms_layouts_portlets
    ADD CONSTRAINT cms_layouts_portlets_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.cms_layouts_portlets DROP CONSTRAINT cms_layouts_portlets_pkey;
       public         dotcmsdbuser    false    308    308            �           2606    61154    cms_role cms_role_name_db_fqn 
   CONSTRAINT     Z   ALTER TABLE ONLY public.cms_role
    ADD CONSTRAINT cms_role_name_db_fqn UNIQUE (db_fqn);
 G   ALTER TABLE ONLY public.cms_role DROP CONSTRAINT cms_role_name_db_fqn;
       public         dotcmsdbuser    false    303    303            �           2606    61152    cms_role cms_role_name_role_key 
   CONSTRAINT     ^   ALTER TABLE ONLY public.cms_role
    ADD CONSTRAINT cms_role_name_role_key UNIQUE (role_key);
 I   ALTER TABLE ONLY public.cms_role DROP CONSTRAINT cms_role_name_role_key;
       public         dotcmsdbuser    false    303    303            �           2606    60398    cms_role cms_role_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.cms_role
    ADD CONSTRAINT cms_role_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.cms_role DROP CONSTRAINT cms_role_pkey;
       public         dotcmsdbuser    false    303    303            0           2606    60642     communication communication_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.communication
    ADD CONSTRAINT communication_pkey PRIMARY KEY (inode);
 J   ALTER TABLE ONLY public.communication DROP CONSTRAINT communication_pkey;
       public         dotcmsdbuser    false    338    338            �           2606    59679    company company_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pkey PRIMARY KEY (companyid);
 >   ALTER TABLE ONLY public.company DROP CONSTRAINT company_pkey;
       public         dotcmsdbuser    false    207    207            �           2606    60406 .   container_structures container_structures_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.container_structures
    ADD CONSTRAINT container_structures_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.container_structures DROP CONSTRAINT container_structures_pkey;
       public         dotcmsdbuser    false    304    304            `           2606    60294 2   container_version_info container_version_info_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.container_version_info
    ADD CONSTRAINT container_version_info_pkey PRIMARY KEY (identifier);
 \   ALTER TABLE ONLY public.container_version_info DROP CONSTRAINT container_version_info_pkey;
       public         dotcmsdbuser    false    289    289            .           2606    60634    containers containers_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.containers
    ADD CONSTRAINT containers_pkey PRIMARY KEY (inode);
 D   ALTER TABLE ONLY public.containers DROP CONSTRAINT containers_pkey;
       public         dotcmsdbuser    false    337    337                       2606    60585 "   content_rating content_rating_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.content_rating
    ADD CONSTRAINT content_rating_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.content_rating DROP CONSTRAINT content_rating_pkey;
       public         dotcmsdbuser    false    329    329            �           2606    60424    contentlet contentlet_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.contentlet
    ADD CONSTRAINT contentlet_pkey PRIMARY KEY (inode);
 D   ALTER TABLE ONLY public.contentlet DROP CONSTRAINT contentlet_pkey;
       public         dotcmsdbuser    false    306    306            Y           2606    60281 4   contentlet_version_info contentlet_version_info_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.contentlet_version_info
    ADD CONSTRAINT contentlet_version_info_pkey PRIMARY KEY (identifier, lang);
 ^   ALTER TABLE ONLY public.contentlet_version_info DROP CONSTRAINT contentlet_version_info_pkey;
       public         dotcmsdbuser    false    287    287    287            �           2606    59684    counter counter_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.counter
    ADD CONSTRAINT counter_pkey PRIMARY KEY (name);
 >   ALTER TABLE ONLY public.counter DROP CONSTRAINT counter_pkey;
       public         dotcmsdbuser    false    208    208            �           2606    59689    cyrususer cyrususer_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.cyrususer
    ADD CONSTRAINT cyrususer_pkey PRIMARY KEY (userid);
 B   ALTER TABLE ONLY public.cyrususer DROP CONSTRAINT cyrususer_pkey;
       public         dotcmsdbuser    false    209    209            �           2606    59694    cyrusvirtual cyrusvirtual_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.cyrusvirtual
    ADD CONSTRAINT cyrusvirtual_pkey PRIMARY KEY (emailaddress);
 H   ALTER TABLE ONLY public.cyrusvirtual DROP CONSTRAINT cyrusvirtual_pkey;
       public         dotcmsdbuser    false    210    210                       2606    60603 :   dashboard_user_preferences dashboard_user_preferences_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.dashboard_user_preferences
    ADD CONSTRAINT dashboard_user_preferences_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.dashboard_user_preferences DROP CONSTRAINT dashboard_user_preferences_pkey;
       public         dotcmsdbuser    false    332    332            �           2606    59536    db_version db_version_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.db_version
    ADD CONSTRAINT db_version_pkey PRIMARY KEY (db_version);
 D   ALTER TABLE ONLY public.db_version DROP CONSTRAINT db_version_pkey;
       public         dotcmsdbuser    false    185    185            q           2606    61096 -   dist_journal dist_journal_object_to_index_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.dist_journal
    ADD CONSTRAINT dist_journal_object_to_index_key UNIQUE (object_to_index, serverid, journal_type);
 W   ALTER TABLE ONLY public.dist_journal DROP CONSTRAINT dist_journal_object_to_index_key;
       public         dotcmsdbuser    false    381    381    381    381            s           2606    61094    dist_journal dist_journal_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.dist_journal
    ADD CONSTRAINT dist_journal_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.dist_journal DROP CONSTRAINT dist_journal_pkey;
       public         dotcmsdbuser    false    381    381            x           2606    61120    dist_process dist_process_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.dist_process
    ADD CONSTRAINT dist_process_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.dist_process DROP CONSTRAINT dist_process_pkey;
       public         dotcmsdbuser    false    384    384            �           2606    61134 .   dist_reindex_journal dist_reindex_journal_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.dist_reindex_journal
    ADD CONSTRAINT dist_reindex_journal_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.dist_reindex_journal DROP CONSTRAINT dist_reindex_journal_pkey;
       public         dotcmsdbuser    false    386    386            �           2606    59702     dlfileprofile dlfileprofile_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public.dlfileprofile
    ADD CONSTRAINT dlfileprofile_pkey PRIMARY KEY (companyid, repositoryid, filename);
 J   ALTER TABLE ONLY public.dlfileprofile DROP CONSTRAINT dlfileprofile_pkey;
       public         dotcmsdbuser    false    211    211    211    211            �           2606    59707    dlfilerank dlfilerank_pkey 
   CONSTRAINT        ALTER TABLE ONLY public.dlfilerank
    ADD CONSTRAINT dlfilerank_pkey PRIMARY KEY (companyid, userid, repositoryid, filename);
 D   ALTER TABLE ONLY public.dlfilerank DROP CONSTRAINT dlfilerank_pkey;
       public         dotcmsdbuser    false    212    212    212    212    212            �           2606    59715     dlfileversion dlfileversion_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.dlfileversion
    ADD CONSTRAINT dlfileversion_pkey PRIMARY KEY (companyid, repositoryid, filename, version);
 J   ALTER TABLE ONLY public.dlfileversion DROP CONSTRAINT dlfileversion_pkey;
       public         dotcmsdbuser    false    213    213    213    213    213            �           2606    59723    dlrepository dlrepository_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.dlrepository
    ADD CONSTRAINT dlrepository_pkey PRIMARY KEY (repositoryid);
 H   ALTER TABLE ONLY public.dlrepository DROP CONSTRAINT dlrepository_pkey;
       public         dotcmsdbuser    false    214    214            �           2606    61741    dot_cluster dot_cluster_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.dot_cluster
    ADD CONSTRAINT dot_cluster_pkey PRIMARY KEY (cluster_id);
 F   ALTER TABLE ONLY public.dot_cluster DROP CONSTRAINT dot_cluster_pkey;
       public         dotcmsdbuser    false    408    408            D           2606    60697    field field_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.field
    ADD CONSTRAINT field_pkey PRIMARY KEY (inode);
 :   ALTER TABLE ONLY public.field DROP CONSTRAINT field_pkey;
       public         dotcmsdbuser    false    345    345            Y           2606    60737 "   field_variable field_variable_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.field_variable
    ADD CONSTRAINT field_variable_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.field_variable DROP CONSTRAINT field_variable_pkey;
       public         dotcmsdbuser    false    350    350                       2606    60564    file_asset file_asset_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.file_asset
    ADD CONSTRAINT file_asset_pkey PRIMARY KEY (inode);
 D   ALTER TABLE ONLY public.file_asset DROP CONSTRAINT file_asset_pkey;
       public         dotcmsdbuser    false    326    326            2           2606    60647 2   fileasset_version_info fileasset_version_info_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.fileasset_version_info
    ADD CONSTRAINT fileasset_version_info_pkey PRIMARY KEY (identifier);
 \   ALTER TABLE ONLY public.fileasset_version_info DROP CONSTRAINT fileasset_version_info_pkey;
       public         dotcmsdbuser    false    339    339            �           2606    61853     fileassets_ir fileassets_ir_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.fileassets_ir
    ADD CONSTRAINT fileassets_ir_pkey PRIMARY KEY (local_working_inode, language_id, endpoint_id);
 J   ALTER TABLE ONLY public.fileassets_ir DROP CONSTRAINT fileassets_ir_pkey;
       public         dotcmsdbuser    false    417    417    417    417            ^           2606    60289    fixes_audit fixes_audit_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.fixes_audit
    ADD CONSTRAINT fixes_audit_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.fixes_audit DROP CONSTRAINT fixes_audit_pkey;
       public         dotcmsdbuser    false    288    288            M           2606    60713    folder folder_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.folder
    ADD CONSTRAINT folder_pkey PRIMARY KEY (inode);
 <   ALTER TABLE ONLY public.folder DROP CONSTRAINT folder_pkey;
       public         dotcmsdbuser    false    347    347            �           2606    61827    folders_ir folders_ir_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.folders_ir
    ADD CONSTRAINT folders_ir_pkey PRIMARY KEY (local_inode, endpoint_id);
 D   ALTER TABLE ONLY public.folders_ir DROP CONSTRAINT folders_ir_pkey;
       public         dotcmsdbuser    false    413    413    413            9           2606    60663     host_variable host_variable_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.host_variable
    ADD CONSTRAINT host_variable_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.host_variable DROP CONSTRAINT host_variable_pkey;
       public         dotcmsdbuser    false    341    341            �           2606    60469    htmlpage htmlpage_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.htmlpage
    ADD CONSTRAINT htmlpage_pkey PRIMARY KEY (inode);
 @   ALTER TABLE ONLY public.htmlpage DROP CONSTRAINT htmlpage_pkey;
       public         dotcmsdbuser    false    312    312            $           2606    60616 0   htmlpage_version_info htmlpage_version_info_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.htmlpage_version_info
    ADD CONSTRAINT htmlpage_version_info_pkey PRIMARY KEY (identifier);
 Z   ALTER TABLE ONLY public.htmlpage_version_info DROP CONSTRAINT htmlpage_version_info_pkey;
       public         dotcmsdbuser    false    334    334            �           2606    61845    htmlpages_ir htmlpages_ir_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.htmlpages_ir
    ADD CONSTRAINT htmlpages_ir_pkey PRIMARY KEY (local_working_inode, language_id, endpoint_id);
 H   ALTER TABLE ONLY public.htmlpages_ir DROP CONSTRAINT htmlpages_ir_pkey;
       public         dotcmsdbuser    false    416    416    416    416            �           2606    60520 ;   identifier identifier_parent_path_asset_name_host_inode_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.identifier
    ADD CONSTRAINT identifier_parent_path_asset_name_host_inode_key UNIQUE (parent_path, asset_name, host_inode);
 e   ALTER TABLE ONLY public.identifier DROP CONSTRAINT identifier_parent_path_asset_name_host_inode_key;
       public         dotcmsdbuser    false    319    319    319    319            �           2606    60518    identifier identifier_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.identifier
    ADD CONSTRAINT identifier_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.identifier DROP CONSTRAINT identifier_pkey;
       public         dotcmsdbuser    false    319    319            �           2606    59731    igfolder igfolder_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.igfolder
    ADD CONSTRAINT igfolder_pkey PRIMARY KEY (folderid);
 @   ALTER TABLE ONLY public.igfolder DROP CONSTRAINT igfolder_pkey;
       public         dotcmsdbuser    false    215    215            �           2606    59739    igimage igimage_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.igimage
    ADD CONSTRAINT igimage_pkey PRIMARY KEY (imageid, companyid);
 >   ALTER TABLE ONLY public.igimage DROP CONSTRAINT igimage_pkey;
       public         dotcmsdbuser    false    216    216    216            �           2606    59747    image image_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_pkey PRIMARY KEY (imageid);
 :   ALTER TABLE ONLY public.image DROP CONSTRAINT image_pkey;
       public         dotcmsdbuser    false    217    217            �           2606    61242    import_audit import_audit_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.import_audit
    ADD CONSTRAINT import_audit_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.import_audit DROP CONSTRAINT import_audit_pkey;
       public         dotcmsdbuser    false    389    389            �           2606    61628     indicies indicies_index_type_key 
   CONSTRAINT     a   ALTER TABLE ONLY public.indicies
    ADD CONSTRAINT indicies_index_type_key UNIQUE (index_type);
 J   ALTER TABLE ONLY public.indicies DROP CONSTRAINT indicies_index_type_key;
       public         dotcmsdbuser    false    396    396            �           2606    61626    indicies indicies_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.indicies
    ADD CONSTRAINT indicies_pkey PRIMARY KEY (index_name);
 @   ALTER TABLE ONLY public.indicies DROP CONSTRAINT indicies_pkey;
       public         dotcmsdbuser    false    396    396            o           2606    60780    inode inode_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.inode
    ADD CONSTRAINT inode_pkey PRIMARY KEY (inode);
 :   ALTER TABLE ONLY public.inode DROP CONSTRAINT inode_pkey;
       public         dotcmsdbuser    false    356    356            �           2606    59755 "   journalarticle journalarticle_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.journalarticle
    ADD CONSTRAINT journalarticle_pkey PRIMARY KEY (articleid, version);
 L   ALTER TABLE ONLY public.journalarticle DROP CONSTRAINT journalarticle_pkey;
       public         dotcmsdbuser    false    218    218    218            �           2606    59763 &   journalstructure journalstructure_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.journalstructure
    ADD CONSTRAINT journalstructure_pkey PRIMARY KEY (structureid);
 P   ALTER TABLE ONLY public.journalstructure DROP CONSTRAINT journalstructure_pkey;
       public         dotcmsdbuser    false    219    219            �           2606    59771 $   journaltemplate journaltemplate_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.journaltemplate
    ADD CONSTRAINT journaltemplate_pkey PRIMARY KEY (templateid);
 N   ALTER TABLE ONLY public.journaltemplate DROP CONSTRAINT journaltemplate_pkey;
       public         dotcmsdbuser    false    220    220            �           2606    60505    language language_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.language
    ADD CONSTRAINT language_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.language DROP CONSTRAINT language_pkey;
       public         dotcmsdbuser    false    317    317            �           2606    59779    layer layer_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.layer
    ADD CONSTRAINT layer_pkey PRIMARY KEY (layerid, skinid);
 :   ALTER TABLE ONLY public.layer DROP CONSTRAINT layer_pkey;
       public         dotcmsdbuser    false    221    221    221                       2606    61194 +   layouts_cms_roles layouts_cms_roles_parent1 
   CONSTRAINT     t   ALTER TABLE ONLY public.layouts_cms_roles
    ADD CONSTRAINT layouts_cms_roles_parent1 UNIQUE (role_id, layout_id);
 U   ALTER TABLE ONLY public.layouts_cms_roles DROP CONSTRAINT layouts_cms_roles_parent1;
       public         dotcmsdbuser    false    327    327    327            
           2606    60569 (   layouts_cms_roles layouts_cms_roles_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.layouts_cms_roles
    ADD CONSTRAINT layouts_cms_roles_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.layouts_cms_roles DROP CONSTRAINT layouts_cms_roles_pkey;
       public         dotcmsdbuser    false    327    327            g           2606    60762 (   link_version_info link_version_info_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.link_version_info
    ADD CONSTRAINT link_version_info_pkey PRIMARY KEY (identifier);
 R   ALTER TABLE ONLY public.link_version_info DROP CONSTRAINT link_version_info_pkey;
       public         dotcmsdbuser    false    353    353            <           2606    60671    links links_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_pkey PRIMARY KEY (inode);
 :   ALTER TABLE ONLY public.links DROP CONSTRAINT links_pkey;
       public         dotcmsdbuser    false    342    342            �           2606    61633    log_mapper log_mapper_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.log_mapper
    ADD CONSTRAINT log_mapper_pkey PRIMARY KEY (log_name);
 D   ALTER TABLE ONLY public.log_mapper DROP CONSTRAINT log_mapper_pkey;
       public         dotcmsdbuser    false    397    397            l           2606    60318    mailing_list mailing_list_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.mailing_list
    ADD CONSTRAINT mailing_list_pkey PRIMARY KEY (inode);
 H   ALTER TABLE ONLY public.mailing_list DROP CONSTRAINT mailing_list_pkey;
       public         dotcmsdbuser    false    292    292            �           2606    59787    mailreceipt mailreceipt_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.mailreceipt
    ADD CONSTRAINT mailreceipt_pkey PRIMARY KEY (receiptid);
 F   ALTER TABLE ONLY public.mailreceipt DROP CONSTRAINT mailreceipt_pkey;
       public         dotcmsdbuser    false    222    222            �           2606    59795    mbmessage mbmessage_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.mbmessage
    ADD CONSTRAINT mbmessage_pkey PRIMARY KEY (messageid, topicid);
 B   ALTER TABLE ONLY public.mbmessage DROP CONSTRAINT mbmessage_pkey;
       public         dotcmsdbuser    false    223    223    223            �           2606    59800     mbmessageflag mbmessageflag_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.mbmessageflag
    ADD CONSTRAINT mbmessageflag_pkey PRIMARY KEY (topicid, messageid, userid);
 J   ALTER TABLE ONLY public.mbmessageflag DROP CONSTRAINT mbmessageflag_pkey;
       public         dotcmsdbuser    false    224    224    224    224            �           2606    59805    mbthread mbthread_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.mbthread
    ADD CONSTRAINT mbthread_pkey PRIMARY KEY (threadid);
 @   ALTER TABLE ONLY public.mbthread DROP CONSTRAINT mbthread_pkey;
       public         dotcmsdbuser    false    225    225            �           2606    59813    mbtopic mbtopic_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.mbtopic
    ADD CONSTRAINT mbtopic_pkey PRIMARY KEY (topicid);
 >   ALTER TABLE ONLY public.mbtopic DROP CONSTRAINT mbtopic_pkey;
       public         dotcmsdbuser    false    226    226            �           2606    60533    multi_tree multi_tree_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.multi_tree
    ADD CONSTRAINT multi_tree_pkey PRIMARY KEY (child, parent1, parent2);
 D   ALTER TABLE ONLY public.multi_tree DROP CONSTRAINT multi_tree_pkey;
       public         dotcmsdbuser    false    321    321    321    321            �           2606    59821 "   networkaddress networkaddress_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.networkaddress
    ADD CONSTRAINT networkaddress_pkey PRIMARY KEY (addressid);
 L   ALTER TABLE ONLY public.networkaddress DROP CONSTRAINT networkaddress_pkey;
       public         dotcmsdbuser    false    227    227            �           2606    59829    note note_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.note
    ADD CONSTRAINT note_pkey PRIMARY KEY (noteid);
 8   ALTER TABLE ONLY public.note DROP CONSTRAINT note_pkey;
       public         dotcmsdbuser    false    228    228            �           2606    61795    notification notification_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.notification DROP CONSTRAINT notification_pkey;
       public         dotcmsdbuser    false    411    411            �           2606    59834 $   passwordtracker passwordtracker_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public.passwordtracker
    ADD CONSTRAINT passwordtracker_pkey PRIMARY KEY (passwordtrackerid);
 N   ALTER TABLE ONLY public.passwordtracker DROP CONSTRAINT passwordtracker_pkey;
       public         dotcmsdbuser    false    229    229            �           2606    60416 9   permission permission_permission_type_inode_id_roleid_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.permission
    ADD CONSTRAINT permission_permission_type_inode_id_roleid_key UNIQUE (permission_type, inode_id, roleid);
 c   ALTER TABLE ONLY public.permission DROP CONSTRAINT permission_permission_type_inode_id_roleid_key;
       public         dotcmsdbuser    false    305    305    305    305            �           2606    60414    permission permission_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.permission
    ADD CONSTRAINT permission_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.permission DROP CONSTRAINT permission_pkey;
       public         dotcmsdbuser    false    305    305            U           2606    60276 6   permission_reference permission_reference_asset_id_key 
   CONSTRAINT     u   ALTER TABLE ONLY public.permission_reference
    ADD CONSTRAINT permission_reference_asset_id_key UNIQUE (asset_id);
 `   ALTER TABLE ONLY public.permission_reference DROP CONSTRAINT permission_reference_asset_id_key;
       public         dotcmsdbuser    false    286    286            W           2606    60274 .   permission_reference permission_reference_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.permission_reference
    ADD CONSTRAINT permission_reference_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.permission_reference DROP CONSTRAINT permission_reference_pkey;
       public         dotcmsdbuser    false    286    286            i           2606    60310    plugin plugin_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.plugin
    ADD CONSTRAINT plugin_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.plugin DROP CONSTRAINT plugin_pkey;
       public         dotcmsdbuser    false    291    291            u           2606    61104 $   plugin_property plugin_property_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.plugin_property
    ADD CONSTRAINT plugin_property_pkey PRIMARY KEY (plugin_id, propkey);
 N   ALTER TABLE ONLY public.plugin_property DROP CONSTRAINT plugin_property_pkey;
       public         dotcmsdbuser    false    382    382    382            �           2606    59842    pollschoice pollschoice_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.pollschoice
    ADD CONSTRAINT pollschoice_pkey PRIMARY KEY (choiceid, questionid);
 F   ALTER TABLE ONLY public.pollschoice DROP CONSTRAINT pollschoice_pkey;
       public         dotcmsdbuser    false    230    230    230            �           2606    59847    pollsdisplay pollsdisplay_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public.pollsdisplay
    ADD CONSTRAINT pollsdisplay_pkey PRIMARY KEY (layoutid, userid, portletid);
 H   ALTER TABLE ONLY public.pollsdisplay DROP CONSTRAINT pollsdisplay_pkey;
       public         dotcmsdbuser    false    231    231    231    231            �           2606    59855     pollsquestion pollsquestion_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.pollsquestion
    ADD CONSTRAINT pollsquestion_pkey PRIMARY KEY (questionid);
 J   ALTER TABLE ONLY public.pollsquestion DROP CONSTRAINT pollsquestion_pkey;
       public         dotcmsdbuser    false    232    232            �           2606    59860    pollsvote pollsvote_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.pollsvote
    ADD CONSTRAINT pollsvote_pkey PRIMARY KEY (questionid, userid);
 B   ALTER TABLE ONLY public.pollsvote DROP CONSTRAINT pollsvote_pkey;
       public         dotcmsdbuser    false    233    233    233            �           2606    59868    portlet portlet_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.portlet
    ADD CONSTRAINT portlet_pkey PRIMARY KEY (portletid, groupid, companyid);
 >   ALTER TABLE ONLY public.portlet DROP CONSTRAINT portlet_pkey;
       public         dotcmsdbuser    false    234    234    234    234            �           2606    61175    portlet portlet_role_key 
   CONSTRAINT     X   ALTER TABLE ONLY public.portlet
    ADD CONSTRAINT portlet_role_key UNIQUE (portletid);
 B   ALTER TABLE ONLY public.portlet DROP CONSTRAINT portlet_role_key;
       public         dotcmsdbuser    false    234    234            �           2606    59876 *   portletpreferences portletpreferences_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.portletpreferences
    ADD CONSTRAINT portletpreferences_pkey PRIMARY KEY (portletid, userid, layoutid);
 T   ALTER TABLE ONLY public.portletpreferences DROP CONSTRAINT portletpreferences_pkey;
       public         dotcmsdbuser    false    235    235    235    235            �           2606    59884    projfirm projfirm_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.projfirm
    ADD CONSTRAINT projfirm_pkey PRIMARY KEY (firmid);
 @   ALTER TABLE ONLY public.projfirm DROP CONSTRAINT projfirm_pkey;
       public         dotcmsdbuser    false    236    236            �           2606    59892    projproject projproject_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.projproject
    ADD CONSTRAINT projproject_pkey PRIMARY KEY (projectid);
 F   ALTER TABLE ONLY public.projproject DROP CONSTRAINT projproject_pkey;
       public         dotcmsdbuser    false    237    237            �           2606    59900    projtask projtask_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.projtask
    ADD CONSTRAINT projtask_pkey PRIMARY KEY (taskid);
 @   ALTER TABLE ONLY public.projtask DROP CONSTRAINT projtask_pkey;
       public         dotcmsdbuser    false    238    238            �           2606    59908    projtime projtime_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.projtime
    ADD CONSTRAINT projtime_pkey PRIMARY KEY (timeid);
 @   ALTER TABLE ONLY public.projtime DROP CONSTRAINT projtime_pkey;
       public         dotcmsdbuser    false    239    239            �           2606    61719 @   publishing_bundle_environment publishing_bundle_environment_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY public.publishing_bundle_environment
    ADD CONSTRAINT publishing_bundle_environment_pkey PRIMARY KEY (id);
 j   ALTER TABLE ONLY public.publishing_bundle_environment DROP CONSTRAINT publishing_bundle_environment_pkey;
       public         dotcmsdbuser    false    406    406            �           2606    61714 (   publishing_bundle publishing_bundle_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.publishing_bundle
    ADD CONSTRAINT publishing_bundle_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.publishing_bundle DROP CONSTRAINT publishing_bundle_pkey;
       public         dotcmsdbuser    false    405    405            �           2606    61681 .   publishing_end_point publishing_end_point_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.publishing_end_point
    ADD CONSTRAINT publishing_end_point_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.publishing_end_point DROP CONSTRAINT publishing_end_point_pkey;
       public         dotcmsdbuser    false    400    400            �           2606    61683 9   publishing_end_point publishing_end_point_server_name_key 
   CONSTRAINT     {   ALTER TABLE ONLY public.publishing_end_point
    ADD CONSTRAINT publishing_end_point_server_name_key UNIQUE (server_name);
 c   ALTER TABLE ONLY public.publishing_end_point DROP CONSTRAINT publishing_end_point_server_name_key;
       public         dotcmsdbuser    false    400    400            �           2606    61690 6   publishing_environment publishing_environment_name_key 
   CONSTRAINT     q   ALTER TABLE ONLY public.publishing_environment
    ADD CONSTRAINT publishing_environment_name_key UNIQUE (name);
 `   ALTER TABLE ONLY public.publishing_environment DROP CONSTRAINT publishing_environment_name_key;
       public         dotcmsdbuser    false    401    401            �           2606    61688 2   publishing_environment publishing_environment_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.publishing_environment
    ADD CONSTRAINT publishing_environment_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.publishing_environment DROP CONSTRAINT publishing_environment_pkey;
       public         dotcmsdbuser    false    401    401            �           2606    61673 2   publishing_queue_audit publishing_queue_audit_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public.publishing_queue_audit
    ADD CONSTRAINT publishing_queue_audit_pkey PRIMARY KEY (bundle_id);
 \   ALTER TABLE ONLY public.publishing_queue_audit DROP CONSTRAINT publishing_queue_audit_pkey;
       public         dotcmsdbuser    false    399    399            �           2606    61709 &   publishing_queue publishing_queue_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.publishing_queue
    ADD CONSTRAINT publishing_queue_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.publishing_queue DROP CONSTRAINT publishing_queue_pkey;
       public         dotcmsdbuser    false    404    404                       2606    60089 *   qrtz_blob_triggers qrtz_blob_triggers_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_blob_triggers
    ADD CONSTRAINT qrtz_blob_triggers_pkey PRIMARY KEY (trigger_name, trigger_group);
 T   ALTER TABLE ONLY public.qrtz_blob_triggers DROP CONSTRAINT qrtz_blob_triggers_pkey;
       public         dotcmsdbuser    false    263    263    263            "           2606    60112 "   qrtz_calendars qrtz_calendars_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.qrtz_calendars
    ADD CONSTRAINT qrtz_calendars_pkey PRIMARY KEY (calendar_name);
 L   ALTER TABLE ONLY public.qrtz_calendars DROP CONSTRAINT qrtz_calendars_pkey;
       public         dotcmsdbuser    false    265    265                       2606    60076 *   qrtz_cron_triggers qrtz_cron_triggers_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_cron_triggers
    ADD CONSTRAINT qrtz_cron_triggers_pkey PRIMARY KEY (trigger_name, trigger_group);
 T   ALTER TABLE ONLY public.qrtz_cron_triggers DROP CONSTRAINT qrtz_cron_triggers_pkey;
       public         dotcmsdbuser    false    262    262    262            6           2606    60194 4   qrtz_excl_blob_triggers qrtz_excl_blob_triggers_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_blob_triggers
    ADD CONSTRAINT qrtz_excl_blob_triggers_pkey PRIMARY KEY (trigger_name, trigger_group);
 ^   ALTER TABLE ONLY public.qrtz_excl_blob_triggers DROP CONSTRAINT qrtz_excl_blob_triggers_pkey;
       public         dotcmsdbuser    false    275    275    275            :           2606    60217 ,   qrtz_excl_calendars qrtz_excl_calendars_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public.qrtz_excl_calendars
    ADD CONSTRAINT qrtz_excl_calendars_pkey PRIMARY KEY (calendar_name);
 V   ALTER TABLE ONLY public.qrtz_excl_calendars DROP CONSTRAINT qrtz_excl_calendars_pkey;
       public         dotcmsdbuser    false    277    277            4           2606    60181 4   qrtz_excl_cron_triggers qrtz_excl_cron_triggers_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_cron_triggers
    ADD CONSTRAINT qrtz_excl_cron_triggers_pkey PRIMARY KEY (trigger_name, trigger_group);
 ^   ALTER TABLE ONLY public.qrtz_excl_cron_triggers DROP CONSTRAINT qrtz_excl_cron_triggers_pkey;
       public         dotcmsdbuser    false    274    274    274            >           2606    60230 6   qrtz_excl_fired_triggers qrtz_excl_fired_triggers_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.qrtz_excl_fired_triggers
    ADD CONSTRAINT qrtz_excl_fired_triggers_pkey PRIMARY KEY (entry_id);
 `   ALTER TABLE ONLY public.qrtz_excl_fired_triggers DROP CONSTRAINT qrtz_excl_fired_triggers_pkey;
       public         dotcmsdbuser    false    279    279            ,           2606    60143 0   qrtz_excl_job_details qrtz_excl_job_details_pkey 
   CONSTRAINT        ALTER TABLE ONLY public.qrtz_excl_job_details
    ADD CONSTRAINT qrtz_excl_job_details_pkey PRIMARY KEY (job_name, job_group);
 Z   ALTER TABLE ONLY public.qrtz_excl_job_details DROP CONSTRAINT qrtz_excl_job_details_pkey;
       public         dotcmsdbuser    false    270    270    270            .           2606    60148 4   qrtz_excl_job_listeners qrtz_excl_job_listeners_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_job_listeners
    ADD CONSTRAINT qrtz_excl_job_listeners_pkey PRIMARY KEY (job_name, job_group, job_listener);
 ^   ALTER TABLE ONLY public.qrtz_excl_job_listeners DROP CONSTRAINT qrtz_excl_job_listeners_pkey;
       public         dotcmsdbuser    false    271    271    271    271            B           2606    60240 $   qrtz_excl_locks qrtz_excl_locks_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.qrtz_excl_locks
    ADD CONSTRAINT qrtz_excl_locks_pkey PRIMARY KEY (lock_name);
 N   ALTER TABLE ONLY public.qrtz_excl_locks DROP CONSTRAINT qrtz_excl_locks_pkey;
       public         dotcmsdbuser    false    281    281            <           2606    60222 @   qrtz_excl_paused_trigger_grps qrtz_excl_paused_trigger_grps_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_paused_trigger_grps
    ADD CONSTRAINT qrtz_excl_paused_trigger_grps_pkey PRIMARY KEY (trigger_group);
 j   ALTER TABLE ONLY public.qrtz_excl_paused_trigger_grps DROP CONSTRAINT qrtz_excl_paused_trigger_grps_pkey;
       public         dotcmsdbuser    false    278    278            @           2606    60235 8   qrtz_excl_scheduler_state qrtz_excl_scheduler_state_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_scheduler_state
    ADD CONSTRAINT qrtz_excl_scheduler_state_pkey PRIMARY KEY (instance_name);
 b   ALTER TABLE ONLY public.qrtz_excl_scheduler_state DROP CONSTRAINT qrtz_excl_scheduler_state_pkey;
       public         dotcmsdbuser    false    280    280            2           2606    60171 8   qrtz_excl_simple_triggers qrtz_excl_simple_triggers_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_simple_triggers
    ADD CONSTRAINT qrtz_excl_simple_triggers_pkey PRIMARY KEY (trigger_name, trigger_group);
 b   ALTER TABLE ONLY public.qrtz_excl_simple_triggers DROP CONSTRAINT qrtz_excl_simple_triggers_pkey;
       public         dotcmsdbuser    false    273    273    273            8           2606    60204 <   qrtz_excl_trigger_listeners qrtz_excl_trigger_listeners_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_trigger_listeners
    ADD CONSTRAINT qrtz_excl_trigger_listeners_pkey PRIMARY KEY (trigger_name, trigger_group, trigger_listener);
 f   ALTER TABLE ONLY public.qrtz_excl_trigger_listeners DROP CONSTRAINT qrtz_excl_trigger_listeners_pkey;
       public         dotcmsdbuser    false    276    276    276    276            0           2606    60161 *   qrtz_excl_triggers qrtz_excl_triggers_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_triggers
    ADD CONSTRAINT qrtz_excl_triggers_pkey PRIMARY KEY (trigger_name, trigger_group);
 T   ALTER TABLE ONLY public.qrtz_excl_triggers DROP CONSTRAINT qrtz_excl_triggers_pkey;
       public         dotcmsdbuser    false    272    272    272            &           2606    60125 ,   qrtz_fired_triggers qrtz_fired_triggers_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.qrtz_fired_triggers
    ADD CONSTRAINT qrtz_fired_triggers_pkey PRIMARY KEY (entry_id);
 V   ALTER TABLE ONLY public.qrtz_fired_triggers DROP CONSTRAINT qrtz_fired_triggers_pkey;
       public         dotcmsdbuser    false    267    267                       2606    60038 &   qrtz_job_details qrtz_job_details_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public.qrtz_job_details
    ADD CONSTRAINT qrtz_job_details_pkey PRIMARY KEY (job_name, job_group);
 P   ALTER TABLE ONLY public.qrtz_job_details DROP CONSTRAINT qrtz_job_details_pkey;
       public         dotcmsdbuser    false    258    258    258                       2606    60043 *   qrtz_job_listeners qrtz_job_listeners_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_job_listeners
    ADD CONSTRAINT qrtz_job_listeners_pkey PRIMARY KEY (job_name, job_group, job_listener);
 T   ALTER TABLE ONLY public.qrtz_job_listeners DROP CONSTRAINT qrtz_job_listeners_pkey;
       public         dotcmsdbuser    false    259    259    259    259            *           2606    60135    qrtz_locks qrtz_locks_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.qrtz_locks
    ADD CONSTRAINT qrtz_locks_pkey PRIMARY KEY (lock_name);
 D   ALTER TABLE ONLY public.qrtz_locks DROP CONSTRAINT qrtz_locks_pkey;
       public         dotcmsdbuser    false    269    269            $           2606    60117 6   qrtz_paused_trigger_grps qrtz_paused_trigger_grps_pkey 
   CONSTRAINT        ALTER TABLE ONLY public.qrtz_paused_trigger_grps
    ADD CONSTRAINT qrtz_paused_trigger_grps_pkey PRIMARY KEY (trigger_group);
 `   ALTER TABLE ONLY public.qrtz_paused_trigger_grps DROP CONSTRAINT qrtz_paused_trigger_grps_pkey;
       public         dotcmsdbuser    false    266    266            (           2606    60130 .   qrtz_scheduler_state qrtz_scheduler_state_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public.qrtz_scheduler_state
    ADD CONSTRAINT qrtz_scheduler_state_pkey PRIMARY KEY (instance_name);
 X   ALTER TABLE ONLY public.qrtz_scheduler_state DROP CONSTRAINT qrtz_scheduler_state_pkey;
       public         dotcmsdbuser    false    268    268                       2606    60066 .   qrtz_simple_triggers qrtz_simple_triggers_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_simple_triggers
    ADD CONSTRAINT qrtz_simple_triggers_pkey PRIMARY KEY (trigger_name, trigger_group);
 X   ALTER TABLE ONLY public.qrtz_simple_triggers DROP CONSTRAINT qrtz_simple_triggers_pkey;
       public         dotcmsdbuser    false    261    261    261                        2606    60099 2   qrtz_trigger_listeners qrtz_trigger_listeners_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_trigger_listeners
    ADD CONSTRAINT qrtz_trigger_listeners_pkey PRIMARY KEY (trigger_name, trigger_group, trigger_listener);
 \   ALTER TABLE ONLY public.qrtz_trigger_listeners DROP CONSTRAINT qrtz_trigger_listeners_pkey;
       public         dotcmsdbuser    false    264    264    264    264                       2606    60056     qrtz_triggers qrtz_triggers_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public.qrtz_triggers
    ADD CONSTRAINT qrtz_triggers_pkey PRIMARY KEY (trigger_name, trigger_group);
 J   ALTER TABLE ONLY public.qrtz_triggers DROP CONSTRAINT qrtz_triggers_pkey;
       public         dotcmsdbuser    false    260    260    260            �           2606    61150    quartz_log quartz_log_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.quartz_log
    ADD CONSTRAINT quartz_log_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.quartz_log DROP CONSTRAINT quartz_log_pkey;
       public         dotcmsdbuser    false    388    388            q           2606    60326    recipient recipient_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.recipient
    ADD CONSTRAINT recipient_pkey PRIMARY KEY (inode);
 B   ALTER TABLE ONLY public.recipient DROP CONSTRAINT recipient_pkey;
       public         dotcmsdbuser    false    293    293            J           2606    60705    relationship relationship_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.relationship
    ADD CONSTRAINT relationship_pkey PRIMARY KEY (inode);
 H   ALTER TABLE ONLY public.relationship DROP CONSTRAINT relationship_pkey;
       public         dotcmsdbuser    false    346    346            �           2606    59913    release_ release__pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.release_
    ADD CONSTRAINT release__pkey PRIMARY KEY (releaseid);
 @   ALTER TABLE ONLY public.release_ DROP CONSTRAINT release__pkey;
       public         dotcmsdbuser    false    240    240            �           2606    60445    report_asset report_asset_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.report_asset
    ADD CONSTRAINT report_asset_pkey PRIMARY KEY (inode);
 H   ALTER TABLE ONLY public.report_asset DROP CONSTRAINT report_asset_pkey;
       public         dotcmsdbuser    false    309    309            [           2606    60745 &   report_parameter report_parameter_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.report_parameter
    ADD CONSTRAINT report_parameter_pkey PRIMARY KEY (inode);
 P   ALTER TABLE ONLY public.report_parameter DROP CONSTRAINT report_parameter_pkey;
       public         dotcmsdbuser    false    351    351            ]           2606    60747 A   report_parameter report_parameter_report_inode_parameter_name_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.report_parameter
    ADD CONSTRAINT report_parameter_report_inode_parameter_name_key UNIQUE (report_inode, parameter_name);
 k   ALTER TABLE ONLY public.report_parameter DROP CONSTRAINT report_parameter_report_inode_parameter_name_key;
       public         dotcmsdbuser    false    351    351    351            �           2606    61837    schemes_ir schemes_ir_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.schemes_ir
    ADD CONSTRAINT schemes_ir_pkey PRIMARY KEY (local_inode, endpoint_id);
 D   ALTER TABLE ONLY public.schemes_ir DROP CONSTRAINT schemes_ir_pkey;
       public         dotcmsdbuser    false    415    415    415            �           2606    59929    shoppingcart shoppingcart_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.shoppingcart
    ADD CONSTRAINT shoppingcart_pkey PRIMARY KEY (cartid);
 H   ALTER TABLE ONLY public.shoppingcart DROP CONSTRAINT shoppingcart_pkey;
       public         dotcmsdbuser    false    242    242            �           2606    59934 &   shoppingcategory shoppingcategory_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.shoppingcategory
    ADD CONSTRAINT shoppingcategory_pkey PRIMARY KEY (categoryid);
 P   ALTER TABLE ONLY public.shoppingcategory DROP CONSTRAINT shoppingcategory_pkey;
       public         dotcmsdbuser    false    243    243            �           2606    59942 "   shoppingcoupon shoppingcoupon_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.shoppingcoupon
    ADD CONSTRAINT shoppingcoupon_pkey PRIMARY KEY (couponid);
 L   ALTER TABLE ONLY public.shoppingcoupon DROP CONSTRAINT shoppingcoupon_pkey;
       public         dotcmsdbuser    false    244    244            �           2606    59950    shoppingitem shoppingitem_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.shoppingitem
    ADD CONSTRAINT shoppingitem_pkey PRIMARY KEY (itemid);
 H   ALTER TABLE ONLY public.shoppingitem DROP CONSTRAINT shoppingitem_pkey;
       public         dotcmsdbuser    false    245    245                        2606    59958 (   shoppingitemfield shoppingitemfield_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.shoppingitemfield
    ADD CONSTRAINT shoppingitemfield_pkey PRIMARY KEY (itemfieldid);
 R   ALTER TABLE ONLY public.shoppingitemfield DROP CONSTRAINT shoppingitemfield_pkey;
       public         dotcmsdbuser    false    246    246                       2606    59963 (   shoppingitemprice shoppingitemprice_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.shoppingitemprice
    ADD CONSTRAINT shoppingitemprice_pkey PRIMARY KEY (itempriceid);
 R   ALTER TABLE ONLY public.shoppingitemprice DROP CONSTRAINT shoppingitemprice_pkey;
       public         dotcmsdbuser    false    247    247                       2606    59971     shoppingorder shoppingorder_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.shoppingorder
    ADD CONSTRAINT shoppingorder_pkey PRIMARY KEY (orderid);
 J   ALTER TABLE ONLY public.shoppingorder DROP CONSTRAINT shoppingorder_pkey;
       public         dotcmsdbuser    false    248    248                       2606    59979 (   shoppingorderitem shoppingorderitem_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.shoppingorderitem
    ADD CONSTRAINT shoppingorderitem_pkey PRIMARY KEY (orderid, itemid);
 R   ALTER TABLE ONLY public.shoppingorderitem DROP CONSTRAINT shoppingorderitem_pkey;
       public         dotcmsdbuser    false    249    249    249            �           2606    61822    sitelic sitelic_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.sitelic
    ADD CONSTRAINT sitelic_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.sitelic DROP CONSTRAINT sitelic_pkey;
       public         dotcmsdbuser    false    412    412            �           2606    61698 &   sitesearch_audit sitesearch_audit_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.sitesearch_audit
    ADD CONSTRAINT sitesearch_audit_pkey PRIMARY KEY (job_id, fire_date);
 P   ALTER TABLE ONLY public.sitesearch_audit DROP CONSTRAINT sitesearch_audit_pkey;
       public         dotcmsdbuser    false    402    402    402            �           2606    59921    skin skin_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.skin
    ADD CONSTRAINT skin_pkey PRIMARY KEY (skinid);
 8   ALTER TABLE ONLY public.skin DROP CONSTRAINT skin_pkey;
       public         dotcmsdbuser    false    241    241            �           2606    60390    structure structure_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.structure
    ADD CONSTRAINT structure_pkey PRIMARY KEY (inode);
 B   ALTER TABLE ONLY public.structure DROP CONSTRAINT structure_pkey;
       public         dotcmsdbuser    false    302    302            �           2606    61832     structures_ir structures_ir_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.structures_ir
    ADD CONSTRAINT structures_ir_pkey PRIMARY KEY (local_inode, endpoint_id);
 J   ALTER TABLE ONLY public.structures_ir DROP CONSTRAINT structures_ir_pkey;
       public         dotcmsdbuser    false    414    414    414            �           2606    60546    tag_inode tag_inode_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.tag_inode
    ADD CONSTRAINT tag_inode_pkey PRIMARY KEY (tag_id, inode);
 B   ALTER TABLE ONLY public.tag_inode DROP CONSTRAINT tag_inode_pkey;
       public         dotcmsdbuser    false    323    323    323            H           2606    60261    tag tag_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (tag_id);
 6   ALTER TABLE ONLY public.tag DROP CONSTRAINT tag_pkey;
       public         dotcmsdbuser    false    284    284            J           2606    61615    tag tag_tagname_host 
   CONSTRAINT     [   ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_tagname_host UNIQUE (tagname, host_id);
 >   ALTER TABLE ONLY public.tag DROP CONSTRAINT tag_tagname_host;
       public         dotcmsdbuser    false    284    284    284            j           2606    60767 ,   template_containers template_containers_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.template_containers
    ADD CONSTRAINT template_containers_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.template_containers DROP CONSTRAINT template_containers_pkey;
       public         dotcmsdbuser    false    354    354            �           2606    60374    template template_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.template
    ADD CONSTRAINT template_pkey PRIMARY KEY (inode);
 @   ALTER TABLE ONLY public.template DROP CONSTRAINT template_pkey;
       public         dotcmsdbuser    false    300    300            �           2606    60489 0   template_version_info template_version_info_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.template_version_info
    ADD CONSTRAINT template_version_info_pkey PRIMARY KEY (identifier);
 Z   ALTER TABLE ONLY public.template_version_info DROP CONSTRAINT template_version_info_pkey;
       public         dotcmsdbuser    false    315    315            g           2606    60302    trackback trackback_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.trackback
    ADD CONSTRAINT trackback_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.trackback DROP CONSTRAINT trackback_pkey;
       public         dotcmsdbuser    false    290    290            �           2606    60354    tree tree_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.tree
    ADD CONSTRAINT tree_pkey PRIMARY KEY (child, parent, relation_type);
 8   ALTER TABLE ONLY public.tree DROP CONSTRAINT tree_pkey;
       public         dotcmsdbuser    false    297    297    297    297            �           2606    61251 $   structure unique_struct_vel_var_name 
   CONSTRAINT     l   ALTER TABLE ONLY public.structure
    ADD CONSTRAINT unique_struct_vel_var_name UNIQUE (velocity_var_name);
 N   ALTER TABLE ONLY public.structure DROP CONSTRAINT unique_struct_vel_var_name;
       public         dotcmsdbuser    false    302    302            �           2606    61472 +   workflow_scheme unique_workflow_scheme_name 
   CONSTRAINT     f   ALTER TABLE ONLY public.workflow_scheme
    ADD CONSTRAINT unique_workflow_scheme_name UNIQUE (name);
 U   ALTER TABLE ONLY public.workflow_scheme DROP CONSTRAINT unique_workflow_scheme_name;
       public         dotcmsdbuser    false    390    390                       2606    59987    user_ user__pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.user_
    ADD CONSTRAINT user__pkey PRIMARY KEY (userid);
 :   ALTER TABLE ONLY public.user_ DROP CONSTRAINT user__pkey;
       public         dotcmsdbuser    false    250    250            N           2606    60269     user_comments user_comments_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.user_comments
    ADD CONSTRAINT user_comments_pkey PRIMARY KEY (inode);
 J   ALTER TABLE ONLY public.user_comments DROP CONSTRAINT user_comments_pkey;
       public         dotcmsdbuser    false    285    285            l           2606    60775    user_filter user_filter_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.user_filter
    ADD CONSTRAINT user_filter_pkey PRIMARY KEY (inode);
 F   ALTER TABLE ONLY public.user_filter DROP CONSTRAINT user_filter_pkey;
       public         dotcmsdbuser    false    355    355            �           2606    60497 &   user_preferences user_preferences_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT user_preferences_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.user_preferences DROP CONSTRAINT user_preferences_pkey;
       public         dotcmsdbuser    false    316    316            >           2606    60679    user_proxy user_proxy_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.user_proxy
    ADD CONSTRAINT user_proxy_pkey PRIMARY KEY (inode);
 D   ALTER TABLE ONLY public.user_proxy DROP CONSTRAINT user_proxy_pkey;
       public         dotcmsdbuser    false    343    343            @           2606    60681 !   user_proxy user_proxy_user_id_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.user_proxy
    ADD CONSTRAINT user_proxy_user_id_key UNIQUE (user_id);
 K   ALTER TABLE ONLY public.user_proxy DROP CONSTRAINT user_proxy_user_id_key;
       public         dotcmsdbuser    false    343    343            �           2606    61161 '   users_cms_roles users_cms_roles_parent1 
   CONSTRAINT     n   ALTER TABLE ONLY public.users_cms_roles
    ADD CONSTRAINT users_cms_roles_parent1 UNIQUE (role_id, user_id);
 Q   ALTER TABLE ONLY public.users_cms_roles DROP CONSTRAINT users_cms_roles_parent1;
       public         dotcmsdbuser    false    299    299    299            �           2606    60366 $   users_cms_roles users_cms_roles_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.users_cms_roles
    ADD CONSTRAINT users_cms_roles_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.users_cms_roles DROP CONSTRAINT users_cms_roles_pkey;
       public         dotcmsdbuser    false    299    299            �           2606    60510 $   users_to_delete users_to_delete_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.users_to_delete
    ADD CONSTRAINT users_to_delete_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.users_to_delete DROP CONSTRAINT users_to_delete_pkey;
       public         dotcmsdbuser    false    318    318            
           2606    60001    usertracker usertracker_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.usertracker
    ADD CONSTRAINT usertracker_pkey PRIMARY KEY (usertrackerid);
 F   ALTER TABLE ONLY public.usertracker DROP CONSTRAINT usertracker_pkey;
       public         dotcmsdbuser    false    253    253                       2606    60009 $   usertrackerpath usertrackerpath_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public.usertrackerpath
    ADD CONSTRAINT usertrackerpath_pkey PRIMARY KEY (usertrackerpathid);
 N   ALTER TABLE ONLY public.usertrackerpath DROP CONSTRAINT usertrackerpath_pkey;
       public         dotcmsdbuser    false    254    254            w           2606    60342    virtual_link virtual_link_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.virtual_link
    ADD CONSTRAINT virtual_link_pkey PRIMARY KEY (inode);
 H   ALTER TABLE ONLY public.virtual_link DROP CONSTRAINT virtual_link_pkey;
       public         dotcmsdbuser    false    295    295            t           2606    60334    web_form web_form_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.web_form
    ADD CONSTRAINT web_form_pkey PRIMARY KEY (web_form_id);
 @   ALTER TABLE ONLY public.web_form DROP CONSTRAINT web_form_pkey;
       public         dotcmsdbuser    false    294    294                       2606    60014    wikidisplay wikidisplay_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.wikidisplay
    ADD CONSTRAINT wikidisplay_pkey PRIMARY KEY (layoutid, userid, portletid);
 F   ALTER TABLE ONLY public.wikidisplay DROP CONSTRAINT wikidisplay_pkey;
       public         dotcmsdbuser    false    255    255    255    255                       2606    60022    wikinode wikinode_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.wikinode
    ADD CONSTRAINT wikinode_pkey PRIMARY KEY (nodeid);
 @   ALTER TABLE ONLY public.wikinode DROP CONSTRAINT wikinode_pkey;
       public         dotcmsdbuser    false    256    256                       2606    60030    wikipage wikipage_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.wikipage
    ADD CONSTRAINT wikipage_pkey PRIMARY KEY (nodeid, title, version);
 @   ALTER TABLE ONLY public.wikipage DROP CONSTRAINT wikipage_pkey;
       public         dotcmsdbuser    false    257    257    257    257            �           2606    61540 :   workflow_action_class_pars workflow_action_class_pars_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.workflow_action_class_pars
    ADD CONSTRAINT workflow_action_class_pars_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.workflow_action_class_pars DROP CONSTRAINT workflow_action_class_pars_pkey;
       public         dotcmsdbuser    false    394    394            �           2606    61526 0   workflow_action_class workflow_action_class_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.workflow_action_class
    ADD CONSTRAINT workflow_action_class_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.workflow_action_class DROP CONSTRAINT workflow_action_class_pkey;
       public         dotcmsdbuser    false    393    393            �           2606    61501 $   workflow_action workflow_action_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.workflow_action
    ADD CONSTRAINT workflow_action_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.workflow_action DROP CONSTRAINT workflow_action_pkey;
       public         dotcmsdbuser    false    392    392            �           2606    60453 &   workflow_comment workflow_comment_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.workflow_comment
    ADD CONSTRAINT workflow_comment_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.workflow_comment DROP CONSTRAINT workflow_comment_pkey;
       public         dotcmsdbuser    false    310    310            7           2606    60655 &   workflow_history workflow_history_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.workflow_history
    ADD CONSTRAINT workflow_history_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.workflow_history DROP CONSTRAINT workflow_history_pkey;
       public         dotcmsdbuser    false    340    340            �           2606    61470 $   workflow_scheme workflow_scheme_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.workflow_scheme
    ADD CONSTRAINT workflow_scheme_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.workflow_scheme DROP CONSTRAINT workflow_scheme_pkey;
       public         dotcmsdbuser    false    390    390            �           2606    61551 <   workflow_scheme_x_structure workflow_scheme_x_structure_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.workflow_scheme_x_structure
    ADD CONSTRAINT workflow_scheme_x_structure_pkey PRIMARY KEY (id);
 f   ALTER TABLE ONLY public.workflow_scheme_x_structure DROP CONSTRAINT workflow_scheme_x_structure_pkey;
       public         dotcmsdbuser    false    395    395            �           2606    61481     workflow_step workflow_step_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.workflow_step
    ADD CONSTRAINT workflow_step_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.workflow_step DROP CONSTRAINT workflow_step_pkey;
       public         dotcmsdbuser    false    391    391            �           2606    60541     workflow_task workflow_task_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.workflow_task
    ADD CONSTRAINT workflow_task_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.workflow_task DROP CONSTRAINT workflow_task_pkey;
       public         dotcmsdbuser    false    322    322            )           2606    60621 *   workflowtask_files workflowtask_files_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.workflowtask_files
    ADD CONSTRAINT workflowtask_files_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.workflowtask_files DROP CONSTRAINT workflowtask_files_pkey;
       public         dotcmsdbuser    false    335    335            �           1259    61078    addres_userid_index    INDEX     I   CREATE INDEX addres_userid_index ON public.address USING btree (userid);
 '   DROP INDEX public.addres_userid_index;
       public         dotcmsdbuser    false    189            ,           1259    61783    containers_ident    INDEX     M   CREATE INDEX containers_ident ON public.containers USING btree (identifier);
 $   DROP INDEX public.containers_ident;
       public         dotcmsdbuser    false    337            �           1259    61780    contentlet_ident    INDEX     M   CREATE INDEX contentlet_ident ON public.contentlet USING btree (identifier);
 $   DROP INDEX public.contentlet_ident;
       public         dotcmsdbuser    false    306            �           1259    61786    contentlet_lang    INDEX     M   CREATE INDEX contentlet_lang ON public.contentlet USING btree (language_id);
 #   DROP INDEX public.contentlet_lang;
       public         dotcmsdbuser    false    306            �           1259    61785    contentlet_moduser    INDEX     M   CREATE INDEX contentlet_moduser ON public.contentlet USING btree (mod_user);
 &   DROP INDEX public.contentlet_moduser;
       public         dotcmsdbuser    false    306            v           1259    61121    dist_process_index    INDEX     n   CREATE INDEX dist_process_index ON public.dist_process USING btree (object_to_index, serverid, journal_type);
 &   DROP INDEX public.dist_process_index;
       public         dotcmsdbuser    false    384    384    384            y           1259    61139    dist_reindex_index    INDEX     d   CREATE INDEX dist_reindex_index ON public.dist_reindex_journal USING btree (serverid, dist_action);
 &   DROP INDEX public.dist_reindex_index;
       public         dotcmsdbuser    false    386    386            z           1259    61135    dist_reindex_index1    INDEX     ^   CREATE INDEX dist_reindex_index1 ON public.dist_reindex_journal USING btree (inode_to_index);
 '   DROP INDEX public.dist_reindex_index1;
       public         dotcmsdbuser    false    386            {           1259    61136    dist_reindex_index2    INDEX     [   CREATE INDEX dist_reindex_index2 ON public.dist_reindex_journal USING btree (dist_action);
 '   DROP INDEX public.dist_reindex_index2;
       public         dotcmsdbuser    false    386            |           1259    61137    dist_reindex_index3    INDEX     X   CREATE INDEX dist_reindex_index3 ON public.dist_reindex_journal USING btree (serverid);
 '   DROP INDEX public.dist_reindex_index3;
       public         dotcmsdbuser    false    386            }           1259    61138    dist_reindex_index4    INDEX     h   CREATE INDEX dist_reindex_index4 ON public.dist_reindex_journal USING btree (ident_to_index, serverid);
 '   DROP INDEX public.dist_reindex_index4;
       public         dotcmsdbuser    false    386    386            ~           1259    61140    dist_reindex_index5    INDEX     f   CREATE INDEX dist_reindex_index5 ON public.dist_reindex_journal USING btree (priority, time_entered);
 '   DROP INDEX public.dist_reindex_index5;
       public         dotcmsdbuser    false    386    386                       1259    61141    dist_reindex_index6    INDEX     X   CREATE INDEX dist_reindex_index6 ON public.dist_reindex_journal USING btree (priority);
 '   DROP INDEX public.dist_reindex_index6;
       public         dotcmsdbuser    false    386            K           1259    61779    folder_ident    INDEX     E   CREATE INDEX folder_ident ON public.folder USING btree (identifier);
     DROP INDEX public.folder_ident;
       public         dotcmsdbuser    false    347            �           1259    61782    htmlpage_ident    INDEX     I   CREATE INDEX htmlpage_ident ON public.htmlpage USING btree (identifier);
 "   DROP INDEX public.htmlpage_ident;
       public         dotcmsdbuser    false    312            �           1259    60819    idx_analytic_summary_1    INDEX     V   CREATE INDEX idx_analytic_summary_1 ON public.analytic_summary USING btree (host_id);
 *   DROP INDEX public.idx_analytic_summary_1;
       public         dotcmsdbuser    false    298            �           1259    60820    idx_analytic_summary_2    INDEX     U   CREATE INDEX idx_analytic_summary_2 ON public.analytic_summary USING btree (visits);
 *   DROP INDEX public.idx_analytic_summary_2;
       public         dotcmsdbuser    false    298            �           1259    60821    idx_analytic_summary_3    INDEX     Y   CREATE INDEX idx_analytic_summary_3 ON public.analytic_summary USING btree (page_views);
 *   DROP INDEX public.idx_analytic_summary_3;
       public         dotcmsdbuser    false    298            �           1259    60849    idx_analytic_summary_404_1    INDEX     ^   CREATE INDEX idx_analytic_summary_404_1 ON public.analytic_summary_404 USING btree (host_id);
 .   DROP INDEX public.idx_analytic_summary_404_1;
       public         dotcmsdbuser    false    307            |           1259    60817    idx_analytic_summary_period_2    INDEX     `   CREATE INDEX idx_analytic_summary_period_2 ON public.analytic_summary_period USING btree (day);
 1   DROP INDEX public.idx_analytic_summary_period_2;
       public         dotcmsdbuser    false    296            }           1259    60816    idx_analytic_summary_period_3    INDEX     a   CREATE INDEX idx_analytic_summary_period_3 ON public.analytic_summary_period USING btree (week);
 1   DROP INDEX public.idx_analytic_summary_period_3;
       public         dotcmsdbuser    false    296            ~           1259    60815    idx_analytic_summary_period_4    INDEX     b   CREATE INDEX idx_analytic_summary_period_4 ON public.analytic_summary_period USING btree (month);
 1   DROP INDEX public.idx_analytic_summary_period_4;
       public         dotcmsdbuser    false    296                       1259    60818    idx_analytic_summary_period_5    INDEX     a   CREATE INDEX idx_analytic_summary_period_5 ON public.analytic_summary_period USING btree (year);
 1   DROP INDEX public.idx_analytic_summary_period_5;
       public         dotcmsdbuser    false    296            �           1259    60873    idx_analytic_summary_visits_1    INDEX     d   CREATE INDEX idx_analytic_summary_visits_1 ON public.analytic_summary_visits USING btree (host_id);
 1   DROP INDEX public.idx_analytic_summary_visits_1;
       public         dotcmsdbuser    false    314            �           1259    60872    idx_analytic_summary_visits_2    INDEX     g   CREATE INDEX idx_analytic_summary_visits_2 ON public.analytic_summary_visits USING btree (visit_time);
 1   DROP INDEX public.idx_analytic_summary_visits_2;
       public         dotcmsdbuser    false    314                       1259    60924    idx_campaign_1    INDEX     F   CREATE INDEX idx_campaign_1 ON public.campaign USING btree (user_id);
 "   DROP INDEX public.idx_campaign_1;
       public         dotcmsdbuser    false    333                        1259    60923    idx_campaign_2    INDEX     I   CREATE INDEX idx_campaign_2 ON public.campaign USING btree (start_date);
 "   DROP INDEX public.idx_campaign_2;
       public         dotcmsdbuser    false    333            !           1259    60922    idx_campaign_3    INDEX     M   CREATE INDEX idx_campaign_3 ON public.campaign USING btree (completed_date);
 "   DROP INDEX public.idx_campaign_3;
       public         dotcmsdbuser    false    333            "           1259    60921    idx_campaign_4    INDEX     N   CREATE INDEX idx_campaign_4 ON public.campaign USING btree (expiration_date);
 "   DROP INDEX public.idx_campaign_4;
       public         dotcmsdbuser    false    333            �           1259    60860    idx_category_1    INDEX     L   CREATE INDEX idx_category_1 ON public.category USING btree (category_name);
 "   DROP INDEX public.idx_category_1;
       public         dotcmsdbuser    false    311            �           1259    60861    idx_category_2    INDEX     K   CREATE INDEX idx_category_2 ON public.category USING btree (category_key);
 "   DROP INDEX public.idx_category_2;
       public         dotcmsdbuser    false    311            b           1259    61083    idx_chain_key_name    INDEX     H   CREATE INDEX idx_chain_key_name ON public.chain USING btree (key_name);
 &   DROP INDEX public.idx_chain_key_name;
       public         dotcmsdbuser    false    352            �           1259    61082    idx_chain_link_code_classname    INDEX     _   CREATE INDEX idx_chain_link_code_classname ON public.chain_link_code USING btree (class_name);
 1   DROP INDEX public.idx_chain_link_code_classname;
       public         dotcmsdbuser    false    313                       1259    60897    idx_click_1    INDEX     =   CREATE INDEX idx_click_1 ON public.click USING btree (link);
    DROP INDEX public.idx_click_1;
       public         dotcmsdbuser    false    324            m           1259    60800    idx_communication_user_id    INDEX     R   CREATE INDEX idx_communication_user_id ON public.recipient USING btree (user_id);
 -   DROP INDEX public.idx_communication_user_id;
       public         dotcmsdbuser    false    293            �           1259    61804    idx_container_id    INDEX     Y   CREATE INDEX idx_container_id ON public.container_structures USING btree (container_id);
 $   DROP INDEX public.idx_container_id;
       public         dotcmsdbuser    false    304            a           1259    61771    idx_container_vi_live    INDEX     ^   CREATE INDEX idx_container_vi_live ON public.container_version_info USING btree (live_inode);
 )   DROP INDEX public.idx_container_vi_live;
       public         dotcmsdbuser    false    289            b           1259    61799    idx_container_vi_version_ts    INDEX     d   CREATE INDEX idx_container_vi_version_ts ON public.container_version_info USING btree (version_ts);
 /   DROP INDEX public.idx_container_vi_version_ts;
       public         dotcmsdbuser    false    289            c           1259    61772    idx_container_vi_working    INDEX     d   CREATE INDEX idx_container_vi_working ON public.container_version_info USING btree (working_inode);
 ,   DROP INDEX public.idx_container_vi_working;
       public         dotcmsdbuser    false    289            �           1259    61041    idx_contentlet_3    INDEX     H   CREATE INDEX idx_contentlet_3 ON public.contentlet USING btree (inode);
 $   DROP INDEX public.idx_contentlet_3;
       public         dotcmsdbuser    false    306            �           1259    61279    idx_contentlet_4    INDEX     R   CREATE INDEX idx_contentlet_4 ON public.contentlet USING btree (structure_inode);
 $   DROP INDEX public.idx_contentlet_4;
       public         dotcmsdbuser    false    306            �           1259    61280    idx_contentlet_identifier    INDEX     V   CREATE INDEX idx_contentlet_identifier ON public.contentlet USING btree (identifier);
 -   DROP INDEX public.idx_contentlet_identifier;
       public         dotcmsdbuser    false    306            Z           1259    61775    idx_contentlet_vi_live    INDEX     `   CREATE INDEX idx_contentlet_vi_live ON public.contentlet_version_info USING btree (live_inode);
 *   DROP INDEX public.idx_contentlet_vi_live;
       public         dotcmsdbuser    false    287            [           1259    61798    idx_contentlet_vi_version_ts    INDEX     f   CREATE INDEX idx_contentlet_vi_version_ts ON public.contentlet_version_info USING btree (version_ts);
 0   DROP INDEX public.idx_contentlet_vi_version_ts;
       public         dotcmsdbuser    false    287            \           1259    61776    idx_contentlet_vi_working    INDEX     f   CREATE INDEX idx_contentlet_vi_working ON public.contentlet_version_info USING btree (working_inode);
 -   DROP INDEX public.idx_contentlet_vi_working;
       public         dotcmsdbuser    false    287                       1259    60915    idx_dashboard_prefs_2    INDEX     _   CREATE INDEX idx_dashboard_prefs_2 ON public.dashboard_user_preferences USING btree (user_id);
 )   DROP INDEX public.idx_dashboard_prefs_2;
       public         dotcmsdbuser    false    332                       1259    60913    idx_dashboard_workstream_1    INDEX     i   CREATE INDEX idx_dashboard_workstream_1 ON public.analytic_summary_workstream USING btree (mod_user_id);
 .   DROP INDEX public.idx_dashboard_workstream_1;
       public         dotcmsdbuser    false    331                       1259    60912    idx_dashboard_workstream_2    INDEX     e   CREATE INDEX idx_dashboard_workstream_2 ON public.analytic_summary_workstream USING btree (host_id);
 .   DROP INDEX public.idx_dashboard_workstream_2;
       public         dotcmsdbuser    false    331                       1259    60914    idx_dashboard_workstream_3    INDEX     f   CREATE INDEX idx_dashboard_workstream_3 ON public.analytic_summary_workstream USING btree (mod_date);
 .   DROP INDEX public.idx_dashboard_workstream_3;
       public         dotcmsdbuser    false    331            E           1259    60955    idx_field_1    INDEX     H   CREATE INDEX idx_field_1 ON public.field USING btree (structure_inode);
    DROP INDEX public.idx_field_1;
       public         dotcmsdbuser    false    345            F           1259    61048    idx_field_velocity_structure    INDEX     s   CREATE UNIQUE INDEX idx_field_velocity_structure ON public.field USING btree (velocity_var_name, structure_inode);
 0   DROP INDEX public.idx_field_velocity_structure;
       public         dotcmsdbuser    false    345    345            3           1259    61767    idx_fileasset_vi_live    INDEX     ^   CREATE INDEX idx_fileasset_vi_live ON public.fileasset_version_info USING btree (live_inode);
 )   DROP INDEX public.idx_fileasset_vi_live;
       public         dotcmsdbuser    false    339            4           1259    61802    idx_fileasset_vi_version_ts    INDEX     d   CREATE INDEX idx_fileasset_vi_version_ts ON public.fileasset_version_info USING btree (version_ts);
 /   DROP INDEX public.idx_fileasset_vi_version_ts;
       public         dotcmsdbuser    false    339            5           1259    61768    idx_fileasset_vi_working    INDEX     d   CREATE INDEX idx_fileasset_vi_working ON public.fileasset_version_info USING btree (working_inode);
 ,   DROP INDEX public.idx_fileasset_vi_working;
       public         dotcmsdbuser    false    339            N           1259    60968    idx_folder_1    INDEX     ?   CREATE INDEX idx_folder_1 ON public.folder USING btree (name);
     DROP INDEX public.idx_folder_1;
       public         dotcmsdbuser    false    347            %           1259    61777    idx_htmlpage_vi_live    INDEX     \   CREATE INDEX idx_htmlpage_vi_live ON public.htmlpage_version_info USING btree (live_inode);
 (   DROP INDEX public.idx_htmlpage_vi_live;
       public         dotcmsdbuser    false    334            &           1259    61801    idx_htmlpage_vi_version_ts    INDEX     b   CREATE INDEX idx_htmlpage_vi_version_ts ON public.htmlpage_version_info USING btree (version_ts);
 .   DROP INDEX public.idx_htmlpage_vi_version_ts;
       public         dotcmsdbuser    false    334            '           1259    61778    idx_htmlpage_vi_working    INDEX     b   CREATE INDEX idx_htmlpage_vi_working ON public.htmlpage_version_info USING btree (working_inode);
 +   DROP INDEX public.idx_htmlpage_vi_working;
       public         dotcmsdbuser    false    334            �           1259    61142    idx_identifier    INDEX     C   CREATE INDEX idx_identifier ON public.identifier USING btree (id);
 "   DROP INDEX public.idx_identifier;
       public         dotcmsdbuser    false    319            �           1259    60881    idx_identifier_exp    INDEX     S   CREATE INDEX idx_identifier_exp ON public.identifier USING btree (sysexpire_date);
 &   DROP INDEX public.idx_identifier_exp;
       public         dotcmsdbuser    false    319            �           1259    61634    idx_identifier_perm    INDEX     \   CREATE INDEX idx_identifier_perm ON public.identifier USING btree (asset_type, host_inode);
 '   DROP INDEX public.idx_identifier_perm;
       public         dotcmsdbuser    false    319    319            �           1259    60880    idx_identifier_pub    INDEX     T   CREATE INDEX idx_identifier_pub ON public.identifier USING btree (syspublish_date);
 &   DROP INDEX public.idx_identifier_pub;
       public         dotcmsdbuser    false    319            m           1259    60987    idx_index_1    INDEX     =   CREATE INDEX idx_index_1 ON public.inode USING btree (type);
    DROP INDEX public.idx_index_1;
       public         dotcmsdbuser    false    356            c           1259    61769    idx_link_vi_live    INDEX     T   CREATE INDEX idx_link_vi_live ON public.link_version_info USING btree (live_inode);
 $   DROP INDEX public.idx_link_vi_live;
       public         dotcmsdbuser    false    353            d           1259    61803    idx_link_vi_version_ts    INDEX     Z   CREATE INDEX idx_link_vi_version_ts ON public.link_version_info USING btree (version_ts);
 *   DROP INDEX public.idx_link_vi_version_ts;
       public         dotcmsdbuser    false    353            e           1259    61770    idx_link_vi_working    INDEX     Z   CREATE INDEX idx_link_vi_working ON public.link_version_info USING btree (working_inode);
 '   DROP INDEX public.idx_link_vi_working;
       public         dotcmsdbuser    false    353            j           1259    60794    idx_mailinglist_1    INDEX     M   CREATE INDEX idx_mailinglist_1 ON public.mailing_list USING btree (user_id);
 %   DROP INDEX public.idx_mailinglist_1;
       public         dotcmsdbuser    false    292            �           1259    60891    idx_multitree_1    INDEX     O   CREATE INDEX idx_multitree_1 ON public.multi_tree USING btree (relation_type);
 #   DROP INDEX public.idx_multitree_1;
       public         dotcmsdbuser    false    321            �           1259    61797    idx_not_read    INDEX     I   CREATE INDEX idx_not_read ON public.notification USING btree (was_read);
     DROP INDEX public.idx_not_read;
       public         dotcmsdbuser    false    411            �           1259    61796    idx_not_user    INDEX     H   CREATE INDEX idx_not_user ON public.notification USING btree (user_id);
     DROP INDEX public.idx_not_user;
       public         dotcmsdbuser    false    411            �           1259    61042    idx_permisision_4    INDEX     S   CREATE INDEX idx_permisision_4 ON public.permission USING btree (permission_type);
 %   DROP INDEX public.idx_permisision_4;
       public         dotcmsdbuser    false    305            �           1259    60842    idx_permission_2    INDEX     \   CREATE INDEX idx_permission_2 ON public.permission USING btree (permission_type, inode_id);
 $   DROP INDEX public.idx_permission_2;
       public         dotcmsdbuser    false    305    305            �           1259    60843    idx_permission_3    INDEX     I   CREATE INDEX idx_permission_3 ON public.permission USING btree (roleid);
 $   DROP INDEX public.idx_permission_3;
       public         dotcmsdbuser    false    305            O           1259    61043    idx_permission_reference_2    INDEX     c   CREATE INDEX idx_permission_reference_2 ON public.permission_reference USING btree (reference_id);
 .   DROP INDEX public.idx_permission_reference_2;
       public         dotcmsdbuser    false    286            P           1259    61044    idx_permission_reference_3    INDEX     t   CREATE INDEX idx_permission_reference_3 ON public.permission_reference USING btree (reference_id, permission_type);
 .   DROP INDEX public.idx_permission_reference_3;
       public         dotcmsdbuser    false    286    286            Q           1259    61045    idx_permission_reference_4    INDEX     p   CREATE INDEX idx_permission_reference_4 ON public.permission_reference USING btree (asset_id, permission_type);
 .   DROP INDEX public.idx_permission_reference_4;
       public         dotcmsdbuser    false    286    286            R           1259    61046    idx_permission_reference_5    INDEX     ~   CREATE INDEX idx_permission_reference_5 ON public.permission_reference USING btree (asset_id, reference_id, permission_type);
 .   DROP INDEX public.idx_permission_reference_5;
       public         dotcmsdbuser    false    286    286    286            S           1259    61047    idx_permission_reference_6    INDEX     f   CREATE INDEX idx_permission_reference_6 ON public.permission_reference USING btree (permission_type);
 .   DROP INDEX public.idx_permission_reference_6;
       public         dotcmsdbuser    false    286            �           1259    60879    idx_preference_1    INDEX     S   CREATE INDEX idx_preference_1 ON public.user_preferences USING btree (preference);
 $   DROP INDEX public.idx_preference_1;
       public         dotcmsdbuser    false    316            �           1259    61736    idx_pub_qa_1    INDEX     Q   CREATE INDEX idx_pub_qa_1 ON public.publishing_queue_audit USING btree (status);
     DROP INDEX public.idx_pub_qa_1;
       public         dotcmsdbuser    false    399            �           1259    61733    idx_pushed_assets_1    INDEX     ]   CREATE INDEX idx_pushed_assets_1 ON public.publishing_pushed_assets USING btree (bundle_id);
 '   DROP INDEX public.idx_pushed_assets_1;
       public         dotcmsdbuser    false    407            �           1259    61734    idx_pushed_assets_2    INDEX     b   CREATE INDEX idx_pushed_assets_2 ON public.publishing_pushed_assets USING btree (environment_id);
 '   DROP INDEX public.idx_pushed_assets_2;
       public         dotcmsdbuser    false    407            �           1259    61735    idx_pushed_assets_3    INDEX     l   CREATE INDEX idx_pushed_assets_3 ON public.publishing_pushed_assets USING btree (asset_id, environment_id);
 '   DROP INDEX public.idx_pushed_assets_3;
       public         dotcmsdbuser    false    407    407            n           1259    60801    idx_recipiets_1    INDEX     F   CREATE INDEX idx_recipiets_1 ON public.recipient USING btree (email);
 #   DROP INDEX public.idx_recipiets_1;
       public         dotcmsdbuser    false    293            o           1259    60802    idx_recipiets_2    INDEX     E   CREATE INDEX idx_recipiets_2 ON public.recipient USING btree (sent);
 #   DROP INDEX public.idx_recipiets_2;
       public         dotcmsdbuser    false    293            G           1259    60961    idx_relationship_1    INDEX     ]   CREATE INDEX idx_relationship_1 ON public.relationship USING btree (parent_structure_inode);
 &   DROP INDEX public.idx_relationship_1;
       public         dotcmsdbuser    false    346            H           1259    60962    idx_relationship_2    INDEX     \   CREATE INDEX idx_relationship_2 ON public.relationship USING btree (child_structure_inode);
 &   DROP INDEX public.idx_relationship_2;
       public         dotcmsdbuser    false    346            �           1259    61253    idx_structure_folder    INDEX     L   CREATE INDEX idx_structure_folder ON public.structure USING btree (folder);
 (   DROP INDEX public.idx_structure_folder;
       public         dotcmsdbuser    false    302            �           1259    61252    idx_structure_host    INDEX     H   CREATE INDEX idx_structure_host ON public.structure USING btree (host);
 &   DROP INDEX public.idx_structure_host;
       public         dotcmsdbuser    false    302            �           1259    61278    idx_template3    INDEX     R   CREATE INDEX idx_template3 ON public.template USING btree (lower((title)::text));
 !   DROP INDEX public.idx_template3;
       public         dotcmsdbuser    false    300    300            h           1259    61325    idx_template_id    INDEX     V   CREATE INDEX idx_template_id ON public.template_containers USING btree (template_id);
 #   DROP INDEX public.idx_template_id;
       public         dotcmsdbuser    false    354            �           1259    61773    idx_template_vi_live    INDEX     \   CREATE INDEX idx_template_vi_live ON public.template_version_info USING btree (live_inode);
 (   DROP INDEX public.idx_template_vi_live;
       public         dotcmsdbuser    false    315            �           1259    61800    idx_template_vi_version_ts    INDEX     b   CREATE INDEX idx_template_vi_version_ts ON public.template_version_info USING btree (version_ts);
 .   DROP INDEX public.idx_template_vi_version_ts;
       public         dotcmsdbuser    false    315            �           1259    61774    idx_template_vi_working    INDEX     b   CREATE INDEX idx_template_vi_working ON public.template_version_info USING btree (working_inode);
 +   DROP INDEX public.idx_template_vi_working;
       public         dotcmsdbuser    false    315            d           1259    60793    idx_trackback_1    INDEX     Q   CREATE INDEX idx_trackback_1 ON public.trackback USING btree (asset_identifier);
 #   DROP INDEX public.idx_trackback_1;
       public         dotcmsdbuser    false    290            e           1259    60792    idx_trackback_2    INDEX     D   CREATE INDEX idx_trackback_2 ON public.trackback USING btree (url);
 #   DROP INDEX public.idx_trackback_2;
       public         dotcmsdbuser    false    290            �           1259    61034    idx_tree    INDEX     Q   CREATE INDEX idx_tree ON public.tree USING btree (child, parent, relation_type);
    DROP INDEX public.idx_tree;
       public         dotcmsdbuser    false    297    297    297            �           1259    61035 
   idx_tree_1    INDEX     =   CREATE INDEX idx_tree_1 ON public.tree USING btree (parent);
    DROP INDEX public.idx_tree_1;
       public         dotcmsdbuser    false    297            �           1259    61036 
   idx_tree_2    INDEX     <   CREATE INDEX idx_tree_2 ON public.tree USING btree (child);
    DROP INDEX public.idx_tree_2;
       public         dotcmsdbuser    false    297            �           1259    61037 
   idx_tree_3    INDEX     D   CREATE INDEX idx_tree_3 ON public.tree USING btree (relation_type);
    DROP INDEX public.idx_tree_3;
       public         dotcmsdbuser    false    297            �           1259    61038 
   idx_tree_4    INDEX     S   CREATE INDEX idx_tree_4 ON public.tree USING btree (parent, child, relation_type);
    DROP INDEX public.idx_tree_4;
       public         dotcmsdbuser    false    297    297    297            �           1259    61039 
   idx_tree_5    INDEX     L   CREATE INDEX idx_tree_5 ON public.tree USING btree (parent, relation_type);
    DROP INDEX public.idx_tree_5;
       public         dotcmsdbuser    false    297    297            �           1259    61040 
   idx_tree_6    INDEX     K   CREATE INDEX idx_tree_6 ON public.tree USING btree (child, relation_type);
    DROP INDEX public.idx_tree_6;
       public         dotcmsdbuser    false    297    297            �           1259    60882    idx_user_clickstream11    INDEX     Q   CREATE INDEX idx_user_clickstream11 ON public.clickstream USING btree (host_id);
 *   DROP INDEX public.idx_user_clickstream11;
       public         dotcmsdbuser    false    320            �           1259    60883    idx_user_clickstream12    INDEX     V   CREATE INDEX idx_user_clickstream12 ON public.clickstream USING btree (last_page_id);
 *   DROP INDEX public.idx_user_clickstream12;
       public         dotcmsdbuser    false    320            �           1259    60888    idx_user_clickstream13    INDEX     W   CREATE INDEX idx_user_clickstream13 ON public.clickstream USING btree (first_page_id);
 *   DROP INDEX public.idx_user_clickstream13;
       public         dotcmsdbuser    false    320            �           1259    60889    idx_user_clickstream14    INDEX     Z   CREATE INDEX idx_user_clickstream14 ON public.clickstream USING btree (operating_system);
 *   DROP INDEX public.idx_user_clickstream14;
       public         dotcmsdbuser    false    320            �           1259    60884    idx_user_clickstream15    INDEX     V   CREATE INDEX idx_user_clickstream15 ON public.clickstream USING btree (browser_name);
 *   DROP INDEX public.idx_user_clickstream15;
       public         dotcmsdbuser    false    320            �           1259    60886    idx_user_clickstream16    INDEX     Y   CREATE INDEX idx_user_clickstream16 ON public.clickstream USING btree (browser_version);
 *   DROP INDEX public.idx_user_clickstream16;
       public         dotcmsdbuser    false    320            �           1259    60890    idx_user_clickstream17    INDEX     X   CREATE INDEX idx_user_clickstream17 ON public.clickstream USING btree (remote_address);
 *   DROP INDEX public.idx_user_clickstream17;
       public         dotcmsdbuser    false    320            �           1259    60887    idx_user_clickstream_1    INDEX     S   CREATE INDEX idx_user_clickstream_1 ON public.clickstream USING btree (cookie_id);
 *   DROP INDEX public.idx_user_clickstream_1;
       public         dotcmsdbuser    false    320            �           1259    60885    idx_user_clickstream_2    INDEX     Q   CREATE INDEX idx_user_clickstream_2 ON public.clickstream USING btree (user_id);
 *   DROP INDEX public.idx_user_clickstream_2;
       public         dotcmsdbuser    false    320            Q           1259    60976    idx_user_clickstream_404_1    INDEX     ]   CREATE INDEX idx_user_clickstream_404_1 ON public.clickstream_404 USING btree (request_uri);
 .   DROP INDEX public.idx_user_clickstream_404_1;
       public         dotcmsdbuser    false    348            R           1259    60974    idx_user_clickstream_404_2    INDEX     Y   CREATE INDEX idx_user_clickstream_404_2 ON public.clickstream_404 USING btree (user_id);
 .   DROP INDEX public.idx_user_clickstream_404_2;
       public         dotcmsdbuser    false    348            S           1259    60975    idx_user_clickstream_404_3    INDEX     Y   CREATE INDEX idx_user_clickstream_404_3 ON public.clickstream_404 USING btree (host_id);
 .   DROP INDEX public.idx_user_clickstream_404_3;
       public         dotcmsdbuser    false    348                       1259    60909    idx_user_clickstream_request_1    INDEX     h   CREATE INDEX idx_user_clickstream_request_1 ON public.clickstream_request USING btree (clickstream_id);
 2   DROP INDEX public.idx_user_clickstream_request_1;
       public         dotcmsdbuser    false    328                       1259    60908    idx_user_clickstream_request_2    INDEX     e   CREATE INDEX idx_user_clickstream_request_2 ON public.clickstream_request USING btree (request_uri);
 2   DROP INDEX public.idx_user_clickstream_request_2;
       public         dotcmsdbuser    false    328                       1259    60911    idx_user_clickstream_request_3    INDEX     o   CREATE INDEX idx_user_clickstream_request_3 ON public.clickstream_request USING btree (associated_identifier);
 2   DROP INDEX public.idx_user_clickstream_request_3;
       public         dotcmsdbuser    false    328                       1259    60910    idx_user_clickstream_request_4    INDEX     f   CREATE INDEX idx_user_clickstream_request_4 ON public.clickstream_request USING btree (timestampper);
 2   DROP INDEX public.idx_user_clickstream_request_4;
       public         dotcmsdbuser    false    328            L           1259    60786    idx_user_comments_1    INDEX     P   CREATE INDEX idx_user_comments_1 ON public.user_comments USING btree (user_id);
 '   DROP INDEX public.idx_user_comments_1;
       public         dotcmsdbuser    false    285            r           1259    60808    idx_user_webform_1    INDEX     L   CREATE INDEX idx_user_webform_1 ON public.web_form USING btree (form_type);
 &   DROP INDEX public.idx_user_webform_1;
       public         dotcmsdbuser    false    294            u           1259    60809    idx_virtual_link_1    INDEX     J   CREATE INDEX idx_virtual_link_1 ON public.virtual_link USING btree (url);
 &   DROP INDEX public.idx_virtual_link_1;
       public         dotcmsdbuser    false    295            �           1259    60896    idx_workflow_1    INDEX     O   CREATE INDEX idx_workflow_1 ON public.workflow_task USING btree (assigned_to);
 "   DROP INDEX public.idx_workflow_1;
       public         dotcmsdbuser    false    322            �           1259    60894    idx_workflow_2    INDEX     N   CREATE INDEX idx_workflow_2 ON public.workflow_task USING btree (belongs_to);
 "   DROP INDEX public.idx_workflow_2;
       public         dotcmsdbuser    false    322            �           1259    60895    idx_workflow_3    INDEX     J   CREATE INDEX idx_workflow_3 ON public.workflow_task USING btree (status);
 "   DROP INDEX public.idx_workflow_3;
       public         dotcmsdbuser    false    322            �           1259    60892    idx_workflow_4    INDEX     L   CREATE INDEX idx_workflow_4 ON public.workflow_task USING btree (webasset);
 "   DROP INDEX public.idx_workflow_4;
       public         dotcmsdbuser    false    322            �           1259    60893    idx_workflow_5    INDEX     N   CREATE INDEX idx_workflow_5 ON public.workflow_task USING btree (created_by);
 "   DROP INDEX public.idx_workflow_5;
       public         dotcmsdbuser    false    322            :           1259    61781    links_ident    INDEX     C   CREATE INDEX links_ident ON public.links USING btree (identifier);
    DROP INDEX public.links_ident;
       public         dotcmsdbuser    false    342            �           1259    61081    tag_inode_inode    INDEX     F   CREATE INDEX tag_inode_inode ON public.tag_inode USING btree (inode);
 #   DROP INDEX public.tag_inode_inode;
       public         dotcmsdbuser    false    323            �           1259    61080    tag_inode_tagid    INDEX     G   CREATE INDEX tag_inode_tagid ON public.tag_inode USING btree (tag_id);
 #   DROP INDEX public.tag_inode_tagid;
       public         dotcmsdbuser    false    323            K           1259    61621    tag_user_id_index    INDEX     D   CREATE INDEX tag_user_id_index ON public.tag USING btree (user_id);
 %   DROP INDEX public.tag_user_id_index;
       public         dotcmsdbuser    false    284            �           1259    61784    template_ident    INDEX     I   CREATE INDEX template_ident ON public.template USING btree (identifier);
 "   DROP INDEX public.template_ident;
       public         dotcmsdbuser    false    300            �           1259    61532     workflow_idx_action_class_action    INDEX     g   CREATE INDEX workflow_idx_action_class_action ON public.workflow_action_class USING btree (action_id);
 4   DROP INDEX public.workflow_idx_action_class_action;
       public         dotcmsdbuser    false    393            �           1259    61546 &   workflow_idx_action_class_param_action    INDEX     �   CREATE INDEX workflow_idx_action_class_param_action ON public.workflow_action_class_pars USING btree (workflow_action_class_id);
 :   DROP INDEX public.workflow_idx_action_class_param_action;
       public         dotcmsdbuser    false    394            �           1259    61517    workflow_idx_action_step    INDEX     W   CREATE INDEX workflow_idx_action_step ON public.workflow_action USING btree (step_id);
 ,   DROP INDEX public.workflow_idx_action_step;
       public         dotcmsdbuser    false    392            �           1259    61562    workflow_idx_scheme_structure_2    INDEX     v   CREATE UNIQUE INDEX workflow_idx_scheme_structure_2 ON public.workflow_scheme_x_structure USING btree (structure_id);
 3   DROP INDEX public.workflow_idx_scheme_structure_2;
       public         dotcmsdbuser    false    395            �           1259    61487    workflow_idx_step_scheme    INDEX     W   CREATE INDEX workflow_idx_step_scheme ON public.workflow_step USING btree (scheme_id);
 ,   DROP INDEX public.workflow_idx_step_scheme;
       public         dotcmsdbuser    false    391            Q           2620    61272 %   identifier check_child_assets_trigger    TRIGGER     �   CREATE TRIGGER check_child_assets_trigger BEFORE DELETE ON public.identifier FOR EACH ROW EXECUTE PROCEDURE public.check_child_assets();
 >   DROP TRIGGER check_child_assets_trigger ON public.identifier;
       public       dotcmsdbuser    false    319    445            N           2620    61322 "   htmlpage check_template_identifier    TRIGGER     �   CREATE TRIGGER check_template_identifier BEFORE INSERT OR UPDATE ON public.htmlpage FOR EACH ROW EXECUTE PROCEDURE public.check_template_id();
 ;   DROP TRIGGER check_template_identifier ON public.htmlpage;
       public       dotcmsdbuser    false    446    312            S           2620    61264 +   containers container_versions_check_trigger    TRIGGER     �   CREATE TRIGGER container_versions_check_trigger AFTER DELETE ON public.containers FOR EACH ROW EXECUTE PROCEDURE public.container_versions_check();
 D   DROP TRIGGER container_versions_check_trigger ON public.containers;
       public       dotcmsdbuser    false    428    337            L           2620    61260 )   contentlet content_versions_check_trigger    TRIGGER     �   CREATE TRIGGER content_versions_check_trigger AFTER DELETE ON public.contentlet FOR EACH ROW EXECUTE PROCEDURE public.content_versions_check();
 B   DROP TRIGGER content_versions_check_trigger ON public.contentlet;
       public       dotcmsdbuser    false    306    426            R           2620    61258 &   file_asset file_versions_check_trigger    TRIGGER     �   CREATE TRIGGER file_versions_check_trigger AFTER DELETE ON public.file_asset FOR EACH ROW EXECUTE PROCEDURE public.file_versions_check();
 ?   DROP TRIGGER file_versions_check_trigger ON public.file_asset;
       public       dotcmsdbuser    false    424    326            U           2620    61324 &   folder folder_identifier_check_trigger    TRIGGER     �   CREATE TRIGGER folder_identifier_check_trigger AFTER DELETE ON public.folder FOR EACH ROW EXECUTE PROCEDURE public.folder_identifier_check();
 ?   DROP TRIGGER folder_identifier_check_trigger ON public.folder;
       public       dotcmsdbuser    false    447    347            M           2620    61268 (   htmlpage htmlpage_versions_check_trigger    TRIGGER     �   CREATE TRIGGER htmlpage_versions_check_trigger AFTER DELETE ON public.htmlpage FOR EACH ROW EXECUTE PROCEDURE public.htmlpage_versions_check();
 A   DROP TRIGGER htmlpage_versions_check_trigger ON public.htmlpage;
       public       dotcmsdbuser    false    443    312            P           2620    61270 )   identifier identifier_parent_path_trigger    TRIGGER     �   CREATE TRIGGER identifier_parent_path_trigger BEFORE INSERT OR UPDATE ON public.identifier FOR EACH ROW EXECUTE PROCEDURE public.identifier_parent_path_check();
 B   DROP TRIGGER identifier_parent_path_trigger ON public.identifier;
       public       dotcmsdbuser    false    444    319            T           2620    61262 !   links link_versions_check_trigger    TRIGGER     �   CREATE TRIGGER link_versions_check_trigger AFTER DELETE ON public.links FOR EACH ROW EXECUTE PROCEDURE public.link_versions_check();
 :   DROP TRIGGER link_versions_check_trigger ON public.links;
       public       dotcmsdbuser    false    427    342            V           2620    61338 #   folder rename_folder_assets_trigger    TRIGGER     �   CREATE TRIGGER rename_folder_assets_trigger AFTER UPDATE ON public.folder FOR EACH ROW EXECUTE PROCEDURE public.rename_folder_and_assets();
 <   DROP TRIGGER rename_folder_assets_trigger ON public.folder;
       public       dotcmsdbuser    false    449    347            O           2620    61234 1   identifier required_identifier_host_inode_trigger    TRIGGER     �   CREATE TRIGGER required_identifier_host_inode_trigger BEFORE INSERT OR UPDATE ON public.identifier FOR EACH ROW EXECUTE PROCEDURE public.identifier_host_inode_check();
 J   DROP TRIGGER required_identifier_host_inode_trigger ON public.identifier;
       public       dotcmsdbuser    false    423    319            K           2620    61255 '   structure structure_host_folder_trigger    TRIGGER     �   CREATE TRIGGER structure_host_folder_trigger BEFORE INSERT OR UPDATE ON public.structure FOR EACH ROW EXECUTE PROCEDURE public.structure_host_folder_check();
 @   DROP TRIGGER structure_host_folder_trigger ON public.structure;
       public       dotcmsdbuser    false    441    302            J           2620    61266 (   template template_versions_check_trigger    TRIGGER     �   CREATE TRIGGER template_versions_check_trigger AFTER DELETE ON public.template FOR EACH ROW EXECUTE PROCEDURE public.template_versions_check();
 A   DROP TRIGGER template_versions_check_trigger ON public.template;
       public       dotcmsdbuser    false    300    425            I           2606    61757 :   cluster_server_uptime cluster_server_uptime_server_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cluster_server_uptime
    ADD CONSTRAINT cluster_server_uptime_server_id_fkey FOREIGN KEY (server_id) REFERENCES public.cluster_server(server_id);
 d   ALTER TABLE ONLY public.cluster_server_uptime DROP CONSTRAINT cluster_server_uptime_server_id_fkey;
       public       dotcmsdbuser    false    409    410    4538                       2606    61195 #   containers containers_identifier_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.containers
    ADD CONSTRAINT containers_identifier_fk FOREIGN KEY (identifier) REFERENCES public.identifier(id);
 M   ALTER TABLE ONLY public.containers DROP CONSTRAINT containers_identifier_fk;
       public       dotcmsdbuser    false    319    337    4322            �           2606    61215     contentlet content_identifier_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.contentlet
    ADD CONSTRAINT content_identifier_fk FOREIGN KEY (identifier) REFERENCES public.identifier(id);
 J   ALTER TABLE ONLY public.contentlet DROP CONSTRAINT content_identifier_fk;
       public       dotcmsdbuser    false    4322    319    306                       2606    61210    file_asset file_identifier_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.file_asset
    ADD CONSTRAINT file_identifier_fk FOREIGN KEY (identifier) REFERENCES public.identifier(id);
 G   ALTER TABLE ONLY public.file_asset DROP CONSTRAINT file_identifier_fk;
       public       dotcmsdbuser    false    4322    326    319            1           2606    60977 "   report_parameter fk22da125e5fb51eb    FK CONSTRAINT     �   ALTER TABLE ONLY public.report_parameter
    ADD CONSTRAINT fk22da125e5fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 L   ALTER TABLE ONLY public.report_parameter DROP CONSTRAINT fk22da125e5fb51eb;
       public       dotcmsdbuser    false    4463    351    356                        2606    60862    category fk302bcfe5fb51eb    FK CONSTRAINT     y   ALTER TABLE ONLY public.category
    ADD CONSTRAINT fk302bcfe5fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 C   ALTER TABLE ONLY public.category DROP CONSTRAINT fk302bcfe5fb51eb;
       public       dotcmsdbuser    false    311    356    4463            �           2606    60803    recipient fk30e172195fb51eb    FK CONSTRAINT     {   ALTER TABLE ONLY public.recipient
    ADD CONSTRAINT fk30e172195fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 E   ALTER TABLE ONLY public.recipient DROP CONSTRAINT fk30e172195fb51eb;
       public       dotcmsdbuser    false    356    4463    293            �           2606    60855    report_asset fk3765ec255fb51eb    FK CONSTRAINT     ~   ALTER TABLE ONLY public.report_asset
    ADD CONSTRAINT fk3765ec255fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 H   ALTER TABLE ONLY public.report_asset DROP CONSTRAINT fk3765ec255fb51eb;
       public       dotcmsdbuser    false    356    309    4463                       2606    60916 -   dashboard_user_preferences fk496242cfd12c0c3b    FK CONSTRAINT     �   ALTER TABLE ONLY public.dashboard_user_preferences
    ADD CONSTRAINT fk496242cfd12c0c3b FOREIGN KEY (summary_404_id) REFERENCES public.analytic_summary_404(id);
 W   ALTER TABLE ONLY public.dashboard_user_preferences DROP CONSTRAINT fk496242cfd12c0c3b;
       public       dotcmsdbuser    false    307    332    4281            �           2606    60832 +   analytic_summary_content fk53cb4f2eed30e054    FK CONSTRAINT     �   ALTER TABLE ONLY public.analytic_summary_content
    ADD CONSTRAINT fk53cb4f2eed30e054 FOREIGN KEY (summary_id) REFERENCES public.analytic_summary(id);
 U   ALTER TABLE ONLY public.analytic_summary_content DROP CONSTRAINT fk53cb4f2eed30e054;
       public       dotcmsdbuser    false    298    301    4234                       2606    60898    click fk5a5c5885fb51eb    FK CONSTRAINT     v   ALTER TABLE ONLY public.click
    ADD CONSTRAINT fk5a5c5885fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 @   ALTER TABLE ONLY public.click DROP CONSTRAINT fk5a5c5885fb51eb;
       public       dotcmsdbuser    false    4463    324    356                       2606    60930 +   analytic_summary_referer fk5bc0f3e2ed30e054    FK CONSTRAINT     �   ALTER TABLE ONLY public.analytic_summary_referer
    ADD CONSTRAINT fk5bc0f3e2ed30e054 FOREIGN KEY (summary_id) REFERENCES public.analytic_summary(id);
 U   ALTER TABLE ONLY public.analytic_summary_referer DROP CONSTRAINT fk5bc0f3e2ed30e054;
       public       dotcmsdbuser    false    4234    298    336            ,           2606    60956    field fk5cea0fa5fb51eb    FK CONSTRAINT     v   ALTER TABLE ONLY public.field
    ADD CONSTRAINT fk5cea0fa5fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 @   ALTER TABLE ONLY public.field DROP CONSTRAINT fk5cea0fa5fb51eb;
       public       dotcmsdbuser    false    356    4463    345            )           2606    60945    links fk6234fb95fb51eb    FK CONSTRAINT     v   ALTER TABLE ONLY public.links
    ADD CONSTRAINT fk6234fb95fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 @   ALTER TABLE ONLY public.links DROP CONSTRAINT fk6234fb95fb51eb;
       public       dotcmsdbuser    false    342    356    4463            �           2606    60850 '   analytic_summary_404 fk7050866db7b46300    FK CONSTRAINT     �   ALTER TABLE ONLY public.analytic_summary_404
    ADD CONSTRAINT fk7050866db7b46300 FOREIGN KEY (summary_period_id) REFERENCES public.analytic_summary_period(id);
 Q   ALTER TABLE ONLY public.analytic_summary_404 DROP CONSTRAINT fk7050866db7b46300;
       public       dotcmsdbuser    false    307    4219    296            *           2606    60950    user_proxy fk7327d4fa5fb51eb    FK CONSTRAINT     |   ALTER TABLE ONLY public.user_proxy
    ADD CONSTRAINT fk7327d4fa5fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 F   ALTER TABLE ONLY public.user_proxy DROP CONSTRAINT fk7327d4fa5fb51eb;
       public       dotcmsdbuser    false    343    4463    356            �           2606    60795    mailing_list fk7bc2cd925fb51eb    FK CONSTRAINT     ~   ALTER TABLE ONLY public.mailing_list
    ADD CONSTRAINT fk7bc2cd925fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 H   ALTER TABLE ONLY public.mailing_list DROP CONSTRAINT fk7bc2cd925fb51eb;
       public       dotcmsdbuser    false    292    356    4463                       2606    60903    file_asset fk7ed2366d5fb51eb    FK CONSTRAINT     |   ALTER TABLE ONLY public.file_asset
    ADD CONSTRAINT fk7ed2366d5fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 F   ALTER TABLE ONLY public.file_asset DROP CONSTRAINT fk7ed2366d5fb51eb;
       public       dotcmsdbuser    false    356    326    4463            �           2606    60837    structure fk89d2d735fb51eb    FK CONSTRAINT     z   ALTER TABLE ONLY public.structure
    ADD CONSTRAINT fk89d2d735fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 D   ALTER TABLE ONLY public.structure DROP CONSTRAINT fk89d2d735fb51eb;
       public       dotcmsdbuser    false    302    356    4463                        2606    60935    containers fk8a844125fb51eb    FK CONSTRAINT     {   ALTER TABLE ONLY public.containers
    ADD CONSTRAINT fk8a844125fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 E   ALTER TABLE ONLY public.containers DROP CONSTRAINT fk8a844125fb51eb;
       public       dotcmsdbuser    false    356    4463    337            �           2606    60822 "   analytic_summary fk9e1a7f4b7b46300    FK CONSTRAINT     �   ALTER TABLE ONLY public.analytic_summary
    ADD CONSTRAINT fk9e1a7f4b7b46300 FOREIGN KEY (summary_period_id) REFERENCES public.analytic_summary_period(id);
 L   ALTER TABLE ONLY public.analytic_summary DROP CONSTRAINT fk9e1a7f4b7b46300;
       public       dotcmsdbuser    false    296    298    4219                       2606    60874 *   analytic_summary_visits fk9eac9733b7b46300    FK CONSTRAINT     �   ALTER TABLE ONLY public.analytic_summary_visits
    ADD CONSTRAINT fk9eac9733b7b46300 FOREIGN KEY (summary_period_id) REFERENCES public.analytic_summary_period(id);
 T   ALTER TABLE ONLY public.analytic_summary_visits DROP CONSTRAINT fk9eac9733b7b46300;
       public       dotcmsdbuser    false    296    314    4219            D           2606    61643    broken_link fk_brokenl_content    FK CONSTRAINT     �   ALTER TABLE ONLY public.broken_link
    ADD CONSTRAINT fk_brokenl_content FOREIGN KEY (inode) REFERENCES public.contentlet(inode) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.broken_link DROP CONSTRAINT fk_brokenl_content;
       public       dotcmsdbuser    false    4276    306    398            C           2606    61648    broken_link fk_brokenl_field    FK CONSTRAINT     �   ALTER TABLE ONLY public.broken_link
    ADD CONSTRAINT fk_brokenl_field FOREIGN KEY (field) REFERENCES public.field(inode) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.broken_link DROP CONSTRAINT fk_brokenl_field;
       public       dotcmsdbuser    false    398    4420    345            F           2606    61720 *   publishing_bundle_environment fk_bundle_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.publishing_bundle_environment
    ADD CONSTRAINT fk_bundle_id FOREIGN KEY (bundle_id) REFERENCES public.publishing_bundle(id);
 T   ALTER TABLE ONLY public.publishing_bundle_environment DROP CONSTRAINT fk_bundle_id;
       public       dotcmsdbuser    false    4529    406    405            G           2606    61747    cluster_server fk_cluster_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.cluster_server
    ADD CONSTRAINT fk_cluster_id FOREIGN KEY (cluster_id) REFERENCES public.dot_cluster(cluster_id);
 F   ALTER TABLE ONLY public.cluster_server DROP CONSTRAINT fk_cluster_id;
       public       dotcmsdbuser    false    409    408    4536            H           2606    61762 *   cluster_server_uptime fk_cluster_server_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.cluster_server_uptime
    ADD CONSTRAINT fk_cluster_server_id FOREIGN KEY (server_id) REFERENCES public.cluster_server(server_id);
 T   ALTER TABLE ONLY public.cluster_server_uptime DROP CONSTRAINT fk_cluster_server_id;
       public       dotcmsdbuser    false    4538    410    409            �           2606    61583 +   contentlet_version_info fk_con_ver_lockedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.contentlet_version_info
    ADD CONSTRAINT fk_con_ver_lockedby FOREIGN KEY (locked_by) REFERENCES public.user_(userid);
 U   ALTER TABLE ONLY public.contentlet_version_info DROP CONSTRAINT fk_con_ver_lockedby;
       public       dotcmsdbuser    false    287    250    4104            6           2606    61331 #   template_containers fk_container_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.template_containers
    ADD CONSTRAINT fk_container_id FOREIGN KEY (container_id) REFERENCES public.identifier(id);
 M   ALTER TABLE ONLY public.template_containers DROP CONSTRAINT fk_container_id;
       public       dotcmsdbuser    false    4322    354    319            �           2606    61345 ;   container_version_info fk_container_version_info_identifier    FK CONSTRAINT     �   ALTER TABLE ONLY public.container_version_info
    ADD CONSTRAINT fk_container_version_info_identifier FOREIGN KEY (identifier) REFERENCES public.identifier(id);
 e   ALTER TABLE ONLY public.container_version_info DROP CONSTRAINT fk_container_version_info_identifier;
       public       dotcmsdbuser    false    319    289    4322            �           2606    61405 5   container_version_info fk_container_version_info_live    FK CONSTRAINT     �   ALTER TABLE ONLY public.container_version_info
    ADD CONSTRAINT fk_container_version_info_live FOREIGN KEY (live_inode) REFERENCES public.containers(inode);
 _   ALTER TABLE ONLY public.container_version_info DROP CONSTRAINT fk_container_version_info_live;
       public       dotcmsdbuser    false    289    337    4398            �           2606    61375 8   container_version_info fk_container_version_info_working    FK CONSTRAINT     �   ALTER TABLE ONLY public.container_version_info
    ADD CONSTRAINT fk_container_version_info_working FOREIGN KEY (working_inode) REFERENCES public.containers(inode);
 b   ALTER TABLE ONLY public.container_version_info DROP CONSTRAINT fk_container_version_info_working;
       public       dotcmsdbuser    false    289    337    4398            �           2606    61455    contentlet fk_contentlet_lang    FK CONSTRAINT     �   ALTER TABLE ONLY public.contentlet
    ADD CONSTRAINT fk_contentlet_lang FOREIGN KEY (language_id) REFERENCES public.language(id);
 G   ALTER TABLE ONLY public.contentlet DROP CONSTRAINT fk_contentlet_lang;
       public       dotcmsdbuser    false    4316    306    317            �           2606    61340 =   contentlet_version_info fk_contentlet_version_info_identifier    FK CONSTRAINT     �   ALTER TABLE ONLY public.contentlet_version_info
    ADD CONSTRAINT fk_contentlet_version_info_identifier FOREIGN KEY (identifier) REFERENCES public.identifier(id) ON DELETE CASCADE;
 g   ALTER TABLE ONLY public.contentlet_version_info DROP CONSTRAINT fk_contentlet_version_info_identifier;
       public       dotcmsdbuser    false    287    4322    319            �           2606    61430 7   contentlet_version_info fk_contentlet_version_info_lang    FK CONSTRAINT     �   ALTER TABLE ONLY public.contentlet_version_info
    ADD CONSTRAINT fk_contentlet_version_info_lang FOREIGN KEY (lang) REFERENCES public.language(id);
 a   ALTER TABLE ONLY public.contentlet_version_info DROP CONSTRAINT fk_contentlet_version_info_lang;
       public       dotcmsdbuser    false    4316    287    317            �           2606    61400 7   contentlet_version_info fk_contentlet_version_info_live    FK CONSTRAINT     �   ALTER TABLE ONLY public.contentlet_version_info
    ADD CONSTRAINT fk_contentlet_version_info_live FOREIGN KEY (live_inode) REFERENCES public.contentlet(inode);
 a   ALTER TABLE ONLY public.contentlet_version_info DROP CONSTRAINT fk_contentlet_version_info_live;
       public       dotcmsdbuser    false    4276    306    287            �           2606    61370 :   contentlet_version_info fk_contentlet_version_info_working    FK CONSTRAINT     �   ALTER TABLE ONLY public.contentlet_version_info
    ADD CONSTRAINT fk_contentlet_version_info_working FOREIGN KEY (working_inode) REFERENCES public.contentlet(inode);
 d   ALTER TABLE ONLY public.contentlet_version_info DROP CONSTRAINT fk_contentlet_version_info_working;
       public       dotcmsdbuser    false    306    4276    287            �           2606    61805 '   container_structures fk_cs_container_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.container_structures
    ADD CONSTRAINT fk_cs_container_id FOREIGN KEY (container_id) REFERENCES public.identifier(id);
 Q   ALTER TABLE ONLY public.container_structures DROP CONSTRAINT fk_cs_container_id;
       public       dotcmsdbuser    false    319    304    4322            �           2606    61810     container_structures fk_cs_inode    FK CONSTRAINT     �   ALTER TABLE ONLY public.container_structures
    ADD CONSTRAINT fk_cs_inode FOREIGN KEY (container_inode) REFERENCES public.inode(inode);
 J   ALTER TABLE ONLY public.container_structures DROP CONSTRAINT fk_cs_inode;
       public       dotcmsdbuser    false    4463    304    356            E           2606    61725 /   publishing_bundle_environment fk_environment_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.publishing_bundle_environment
    ADD CONSTRAINT fk_environment_id FOREIGN KEY (environment_id) REFERENCES public.publishing_environment(id);
 Y   ALTER TABLE ONLY public.publishing_bundle_environment DROP CONSTRAINT fk_environment_id;
       public       dotcmsdbuser    false    406    401    4523            :           2606    61578 "   workflow_step fk_escalation_action    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_step
    ADD CONSTRAINT fk_escalation_action FOREIGN KEY (escalation_action) REFERENCES public.workflow_action(id);
 L   ALTER TABLE ONLY public.workflow_step DROP CONSTRAINT fk_escalation_action;
       public       dotcmsdbuser    false    392    391    4494            "           2606    61603 /   fileasset_version_info fk_fil_ver_info_lockedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.fileasset_version_info
    ADD CONSTRAINT fk_fil_ver_info_lockedby FOREIGN KEY (locked_by) REFERENCES public.user_(userid);
 Y   ALTER TABLE ONLY public.fileasset_version_info DROP CONSTRAINT fk_fil_ver_info_lockedby;
       public       dotcmsdbuser    false    4104    339    250            %           2606    61360 ;   fileasset_version_info fk_fileasset_version_info_identifier    FK CONSTRAINT     �   ALTER TABLE ONLY public.fileasset_version_info
    ADD CONSTRAINT fk_fileasset_version_info_identifier FOREIGN KEY (identifier) REFERENCES public.identifier(id);
 e   ALTER TABLE ONLY public.fileasset_version_info DROP CONSTRAINT fk_fileasset_version_info_identifier;
       public       dotcmsdbuser    false    339    319    4322            #           2606    61420 5   fileasset_version_info fk_fileasset_version_info_live    FK CONSTRAINT     �   ALTER TABLE ONLY public.fileasset_version_info
    ADD CONSTRAINT fk_fileasset_version_info_live FOREIGN KEY (live_inode) REFERENCES public.file_asset(inode);
 _   ALTER TABLE ONLY public.fileasset_version_info DROP CONSTRAINT fk_fileasset_version_info_live;
       public       dotcmsdbuser    false    326    4358    339            $           2606    61390 8   fileasset_version_info fk_fileasset_version_info_working    FK CONSTRAINT     �   ALTER TABLE ONLY public.fileasset_version_info
    ADD CONSTRAINT fk_fileasset_version_info_working FOREIGN KEY (working_inode) REFERENCES public.file_asset(inode);
 b   ALTER TABLE ONLY public.fileasset_version_info DROP CONSTRAINT fk_fileasset_version_info_working;
       public       dotcmsdbuser    false    326    339    4358            .           2606    61435 $   folder fk_folder_file_structure_type    FK CONSTRAINT     �   ALTER TABLE ONLY public.folder
    ADD CONSTRAINT fk_folder_file_structure_type FOREIGN KEY (default_file_type) REFERENCES public.structure(inode);
 N   ALTER TABLE ONLY public.folder DROP CONSTRAINT fk_folder_file_structure_type;
       public       dotcmsdbuser    false    4253    347    302                       2606    61355 9   htmlpage_version_info fk_htmlpage_version_info_identifier    FK CONSTRAINT     �   ALTER TABLE ONLY public.htmlpage_version_info
    ADD CONSTRAINT fk_htmlpage_version_info_identifier FOREIGN KEY (identifier) REFERENCES public.identifier(id);
 c   ALTER TABLE ONLY public.htmlpage_version_info DROP CONSTRAINT fk_htmlpage_version_info_identifier;
       public       dotcmsdbuser    false    334    4322    319                       2606    61415 3   htmlpage_version_info fk_htmlpage_version_info_live    FK CONSTRAINT     �   ALTER TABLE ONLY public.htmlpage_version_info
    ADD CONSTRAINT fk_htmlpage_version_info_live FOREIGN KEY (live_inode) REFERENCES public.htmlpage(inode);
 ]   ALTER TABLE ONLY public.htmlpage_version_info DROP CONSTRAINT fk_htmlpage_version_info_live;
       public       dotcmsdbuser    false    312    4297    334                       2606    61385 6   htmlpage_version_info fk_htmlpage_version_info_working    FK CONSTRAINT     �   ALTER TABLE ONLY public.htmlpage_version_info
    ADD CONSTRAINT fk_htmlpage_version_info_working FOREIGN KEY (working_inode) REFERENCES public.htmlpage(inode);
 `   ALTER TABLE ONLY public.htmlpage_version_info DROP CONSTRAINT fk_htmlpage_version_info_working;
       public       dotcmsdbuser    false    312    4297    334            2           2606    61608 +   link_version_info fk_link_ver_info_lockedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.link_version_info
    ADD CONSTRAINT fk_link_ver_info_lockedby FOREIGN KEY (locked_by) REFERENCES public.user_(userid);
 U   ALTER TABLE ONLY public.link_version_info DROP CONSTRAINT fk_link_ver_info_lockedby;
       public       dotcmsdbuser    false    4104    353    250            5           2606    61365 1   link_version_info fk_link_version_info_identifier    FK CONSTRAINT     �   ALTER TABLE ONLY public.link_version_info
    ADD CONSTRAINT fk_link_version_info_identifier FOREIGN KEY (identifier) REFERENCES public.identifier(id);
 [   ALTER TABLE ONLY public.link_version_info DROP CONSTRAINT fk_link_version_info_identifier;
       public       dotcmsdbuser    false    4322    319    353            3           2606    61425 +   link_version_info fk_link_version_info_live    FK CONSTRAINT     �   ALTER TABLE ONLY public.link_version_info
    ADD CONSTRAINT fk_link_version_info_live FOREIGN KEY (live_inode) REFERENCES public.links(inode);
 U   ALTER TABLE ONLY public.link_version_info DROP CONSTRAINT fk_link_version_info_live;
       public       dotcmsdbuser    false    4412    342    353            4           2606    61395 .   link_version_info fk_link_version_info_working    FK CONSTRAINT     �   ALTER TABLE ONLY public.link_version_info
    ADD CONSTRAINT fk_link_version_info_working FOREIGN KEY (working_inode) REFERENCES public.links(inode);
 X   ALTER TABLE ONLY public.link_version_info DROP CONSTRAINT fk_link_version_info_working;
       public       dotcmsdbuser    false    353    342    4412                       2606    61598 /   htmlpage_version_info fk_page_ver_info_lockedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.htmlpage_version_info
    ADD CONSTRAINT fk_page_ver_info_lockedby FOREIGN KEY (locked_by) REFERENCES public.user_(userid);
 Y   ALTER TABLE ONLY public.htmlpage_version_info DROP CONSTRAINT fk_page_ver_info_lockedby;
       public       dotcmsdbuser    false    4104    334    250            +           2606    61059 (   chain_state_parameter fk_parameter_state    FK CONSTRAINT     �   ALTER TABLE ONLY public.chain_state_parameter
    ADD CONSTRAINT fk_parameter_state FOREIGN KEY (chain_state_id) REFERENCES public.chain_state(id);
 R   ALTER TABLE ONLY public.chain_state_parameter DROP CONSTRAINT fk_parameter_state;
       public       dotcmsdbuser    false    330    4372    344            9           2606    61105 )   plugin_property fk_plugin_plugin_property    FK CONSTRAINT     �   ALTER TABLE ONLY public.plugin_property
    ADD CONSTRAINT fk_plugin_plugin_property FOREIGN KEY (plugin_id) REFERENCES public.plugin(id);
 S   ALTER TABLE ONLY public.plugin_property DROP CONSTRAINT fk_plugin_plugin_property;
       public       dotcmsdbuser    false    291    382    4201                       2606    61049    chain_state fk_state_chain    FK CONSTRAINT     z   ALTER TABLE ONLY public.chain_state
    ADD CONSTRAINT fk_state_chain FOREIGN KEY (chain_id) REFERENCES public.chain(id);
 D   ALTER TABLE ONLY public.chain_state DROP CONSTRAINT fk_state_chain;
       public       dotcmsdbuser    false    4449    352    330                       2606    61054    chain_state fk_state_code    FK CONSTRAINT     �   ALTER TABLE ONLY public.chain_state
    ADD CONSTRAINT fk_state_code FOREIGN KEY (link_code_id) REFERENCES public.chain_link_code(id);
 C   ALTER TABLE ONLY public.chain_state DROP CONSTRAINT fk_state_code;
       public       dotcmsdbuser    false    313    4301    330            �           2606    61245    structure fk_structure_folder    FK CONSTRAINT        ALTER TABLE ONLY public.structure
    ADD CONSTRAINT fk_structure_folder FOREIGN KEY (folder) REFERENCES public.folder(inode);
 G   ALTER TABLE ONLY public.structure DROP CONSTRAINT fk_structure_folder;
       public       dotcmsdbuser    false    4429    302    347            �           2606    61273    structure fk_structure_host    FK CONSTRAINT     |   ALTER TABLE ONLY public.structure
    ADD CONSTRAINT fk_structure_host FOREIGN KEY (host) REFERENCES public.identifier(id);
 E   ALTER TABLE ONLY public.structure DROP CONSTRAINT fk_structure_host;
       public       dotcmsdbuser    false    302    319    4322            �           2606    61069    contentlet fk_structure_inode    FK CONSTRAINT     �   ALTER TABLE ONLY public.contentlet
    ADD CONSTRAINT fk_structure_inode FOREIGN KEY (structure_inode) REFERENCES public.structure(inode);
 G   ALTER TABLE ONLY public.contentlet DROP CONSTRAINT fk_structure_inode;
       public       dotcmsdbuser    false    306    302    4253                       2606    61616    tag_inode fk_tag_inode_tagid    FK CONSTRAINT     |   ALTER TABLE ONLY public.tag_inode
    ADD CONSTRAINT fk_tag_inode_tagid FOREIGN KEY (tag_id) REFERENCES public.tag(tag_id);
 F   ALTER TABLE ONLY public.tag_inode DROP CONSTRAINT fk_tag_inode_tagid;
       public       dotcmsdbuser    false    284    4168    323            �           2606    61588 2   container_version_info fk_tainer_ver_info_lockedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.container_version_info
    ADD CONSTRAINT fk_tainer_ver_info_lockedby FOREIGN KEY (locked_by) REFERENCES public.user_(userid);
 \   ALTER TABLE ONLY public.container_version_info DROP CONSTRAINT fk_tainer_ver_info_lockedby;
       public       dotcmsdbuser    false    4104    289    250                       2606    61593 /   template_version_info fk_temp_ver_info_lockedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.template_version_info
    ADD CONSTRAINT fk_temp_ver_info_lockedby FOREIGN KEY (locked_by) REFERENCES public.user_(userid);
 Y   ALTER TABLE ONLY public.template_version_info DROP CONSTRAINT fk_temp_ver_info_lockedby;
       public       dotcmsdbuser    false    315    250    4104            7           2606    61326 "   template_containers fk_template_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.template_containers
    ADD CONSTRAINT fk_template_id FOREIGN KEY (template_id) REFERENCES public.identifier(id);
 L   ALTER TABLE ONLY public.template_containers DROP CONSTRAINT fk_template_id;
       public       dotcmsdbuser    false    319    4322    354            	           2606    61350 9   template_version_info fk_template_version_info_identifier    FK CONSTRAINT     �   ALTER TABLE ONLY public.template_version_info
    ADD CONSTRAINT fk_template_version_info_identifier FOREIGN KEY (identifier) REFERENCES public.identifier(id);
 c   ALTER TABLE ONLY public.template_version_info DROP CONSTRAINT fk_template_version_info_identifier;
       public       dotcmsdbuser    false    319    4322    315                       2606    61410 3   template_version_info fk_template_version_info_live    FK CONSTRAINT     �   ALTER TABLE ONLY public.template_version_info
    ADD CONSTRAINT fk_template_version_info_live FOREIGN KEY (live_inode) REFERENCES public.template(inode);
 ]   ALTER TABLE ONLY public.template_version_info DROP CONSTRAINT fk_template_version_info_live;
       public       dotcmsdbuser    false    4247    300    315                       2606    61380 6   template_version_info fk_template_version_info_working    FK CONSTRAINT     �   ALTER TABLE ONLY public.template_version_info
    ADD CONSTRAINT fk_template_version_info_working FOREIGN KEY (working_inode) REFERENCES public.template(inode);
 `   ALTER TABLE ONLY public.template_version_info DROP CONSTRAINT fk_template_version_info_working;
       public       dotcmsdbuser    false    315    300    4247                       2606    61291    containers fk_user_containers    FK CONSTRAINT     �   ALTER TABLE ONLY public.containers
    ADD CONSTRAINT fk_user_containers FOREIGN KEY (mod_user) REFERENCES public.user_(userid);
 G   ALTER TABLE ONLY public.containers DROP CONSTRAINT fk_user_containers;
       public       dotcmsdbuser    false    4104    250    337            �           2606    61281    contentlet fk_user_contentlet    FK CONSTRAINT     �   ALTER TABLE ONLY public.contentlet
    ADD CONSTRAINT fk_user_contentlet FOREIGN KEY (mod_user) REFERENCES public.user_(userid);
 G   ALTER TABLE ONLY public.contentlet DROP CONSTRAINT fk_user_contentlet;
       public       dotcmsdbuser    false    250    306    4104                       2606    61301    file_asset fk_user_file_asset    FK CONSTRAINT     �   ALTER TABLE ONLY public.file_asset
    ADD CONSTRAINT fk_user_file_asset FOREIGN KEY (mod_user) REFERENCES public.user_(userid);
 G   ALTER TABLE ONLY public.file_asset DROP CONSTRAINT fk_user_file_asset;
       public       dotcmsdbuser    false    4104    326    250                       2606    61286    htmlpage fk_user_htmlpage    FK CONSTRAINT     }   ALTER TABLE ONLY public.htmlpage
    ADD CONSTRAINT fk_user_htmlpage FOREIGN KEY (mod_user) REFERENCES public.user_(userid);
 C   ALTER TABLE ONLY public.htmlpage DROP CONSTRAINT fk_user_htmlpage;
       public       dotcmsdbuser    false    4104    312    250            '           2606    61306    links fk_user_links    FK CONSTRAINT     w   ALTER TABLE ONLY public.links
    ADD CONSTRAINT fk_user_links FOREIGN KEY (mod_user) REFERENCES public.user_(userid);
 =   ALTER TABLE ONLY public.links DROP CONSTRAINT fk_user_links;
       public       dotcmsdbuser    false    4104    342    250            �           2606    61296    template fk_user_template    FK CONSTRAINT     }   ALTER TABLE ONLY public.template
    ADD CONSTRAINT fk_user_template FOREIGN KEY (mod_user) REFERENCES public.user_(userid);
 C   ALTER TABLE ONLY public.template DROP CONSTRAINT fk_user_template;
       public       dotcmsdbuser    false    250    300    4104                       2606    61568     workflow_task fk_workflow_assign    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_task
    ADD CONSTRAINT fk_workflow_assign FOREIGN KEY (assigned_to) REFERENCES public.cms_role(id);
 J   ALTER TABLE ONLY public.workflow_task DROP CONSTRAINT fk_workflow_assign;
       public       dotcmsdbuser    false    303    322    4261                       2606    61440 !   workflowtask_files fk_workflow_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflowtask_files
    ADD CONSTRAINT fk_workflow_id FOREIGN KEY (workflowtask_id) REFERENCES public.workflow_task(id);
 K   ALTER TABLE ONLY public.workflowtask_files DROP CONSTRAINT fk_workflow_id;
       public       dotcmsdbuser    false    4347    335    322            
           2606    61573    workflow_task fk_workflow_step    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_task
    ADD CONSTRAINT fk_workflow_step FOREIGN KEY (status) REFERENCES public.workflow_step(id);
 H   ALTER TABLE ONLY public.workflow_task DROP CONSTRAINT fk_workflow_step;
       public       dotcmsdbuser    false    322    391    4492                       2606    61563 $   workflow_task fk_workflow_task_asset    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_task
    ADD CONSTRAINT fk_workflow_task_asset FOREIGN KEY (webasset) REFERENCES public.identifier(id);
 N   ALTER TABLE ONLY public.workflow_task DROP CONSTRAINT fk_workflow_task_asset;
       public       dotcmsdbuser    false    322    319    4322            �           2606    60781 )   analytic_summary_pages fka1ad33b9ed30e054    FK CONSTRAINT     �   ALTER TABLE ONLY public.analytic_summary_pages
    ADD CONSTRAINT fka1ad33b9ed30e054 FOREIGN KEY (summary_id) REFERENCES public.analytic_summary(id);
 S   ALTER TABLE ONLY public.analytic_summary_pages DROP CONSTRAINT fka1ad33b9ed30e054;
       public       dotcmsdbuser    false    298    283    4234            �           2606    60827    template fkb13acc7a5fb51eb    FK CONSTRAINT     z   ALTER TABLE ONLY public.template
    ADD CONSTRAINT fkb13acc7a5fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 D   ALTER TABLE ONLY public.template DROP CONSTRAINT fkb13acc7a5fb51eb;
       public       dotcmsdbuser    false    4463    300    356            0           2606    60969    folder fkb45d1c6e5fb51eb    FK CONSTRAINT     x   ALTER TABLE ONLY public.folder
    ADD CONSTRAINT fkb45d1c6e5fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 B   ALTER TABLE ONLY public.folder DROP CONSTRAINT fkb45d1c6e5fb51eb;
       public       dotcmsdbuser    false    356    347    4463            !           2606    60940    communication fkc24acfd65fb51eb    FK CONSTRAINT        ALTER TABLE ONLY public.communication
    ADD CONSTRAINT fkc24acfd65fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 I   ALTER TABLE ONLY public.communication DROP CONSTRAINT fkc24acfd65fb51eb;
       public       dotcmsdbuser    false    4463    338    356            �           2606    61178 +   cms_layouts_portlets fkcms_layouts_portlets    FK CONSTRAINT     �   ALTER TABLE ONLY public.cms_layouts_portlets
    ADD CONSTRAINT fkcms_layouts_portlets FOREIGN KEY (layout_id) REFERENCES public.cms_layout(id);
 U   ALTER TABLE ONLY public.cms_layouts_portlets DROP CONSTRAINT fkcms_layouts_portlets;
       public       dotcmsdbuser    false    4439    308    349            �           2606    61155    cms_role fkcms_role_parent    FK CONSTRAINT     {   ALTER TABLE ONLY public.cms_role
    ADD CONSTRAINT fkcms_role_parent FOREIGN KEY (parent) REFERENCES public.cms_role(id);
 D   ALTER TABLE ONLY public.cms_role DROP CONSTRAINT fkcms_role_parent;
       public       dotcmsdbuser    false    303    4261    303            �           2606    60810    virtual_link fkd844f8ae5fb51eb    FK CONSTRAINT     ~   ALTER TABLE ONLY public.virtual_link
    ADD CONSTRAINT fkd844f8ae5fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 H   ALTER TABLE ONLY public.virtual_link DROP CONSTRAINT fkd844f8ae5fb51eb;
       public       dotcmsdbuser    false    356    295    4463            �           2606    60787    user_comments fkdf1b37e85fb51eb    FK CONSTRAINT        ALTER TABLE ONLY public.user_comments
    ADD CONSTRAINT fkdf1b37e85fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 I   ALTER TABLE ONLY public.user_comments DROP CONSTRAINT fkdf1b37e85fb51eb;
       public       dotcmsdbuser    false    285    4463    356            8           2606    60982    user_filter fke042126c5fb51eb    FK CONSTRAINT     }   ALTER TABLE ONLY public.user_filter
    ADD CONSTRAINT fke042126c5fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 G   ALTER TABLE ONLY public.user_filter DROP CONSTRAINT fke042126c5fb51eb;
       public       dotcmsdbuser    false    355    4463    356                       2606    60867    htmlpage fkebf39cba5fb51eb    FK CONSTRAINT     z   ALTER TABLE ONLY public.htmlpage
    ADD CONSTRAINT fkebf39cba5fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 D   ALTER TABLE ONLY public.htmlpage DROP CONSTRAINT fkebf39cba5fb51eb;
       public       dotcmsdbuser    false    4463    356    312            -           2606    60963    relationship fkf06476385fb51eb    FK CONSTRAINT     ~   ALTER TABLE ONLY public.relationship
    ADD CONSTRAINT fkf06476385fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 H   ALTER TABLE ONLY public.relationship DROP CONSTRAINT fkf06476385fb51eb;
       public       dotcmsdbuser    false    356    4463    346                       2606    60925    campaign fkf7a901105fb51eb    FK CONSTRAINT     z   ALTER TABLE ONLY public.campaign
    ADD CONSTRAINT fkf7a901105fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 D   ALTER TABLE ONLY public.campaign DROP CONSTRAINT fkf7a901105fb51eb;
       public       dotcmsdbuser    false    4463    356    333            �           2606    60844    contentlet fkfc4ef025fb51eb    FK CONSTRAINT     {   ALTER TABLE ONLY public.contentlet
    ADD CONSTRAINT fkfc4ef025fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 E   ALTER TABLE ONLY public.contentlet DROP CONSTRAINT fkfc4ef025fb51eb;
       public       dotcmsdbuser    false    356    4463    306                       2606    61183 &   layouts_cms_roles fklayouts_cms_roles1    FK CONSTRAINT     �   ALTER TABLE ONLY public.layouts_cms_roles
    ADD CONSTRAINT fklayouts_cms_roles1 FOREIGN KEY (role_id) REFERENCES public.cms_role(id);
 P   ALTER TABLE ONLY public.layouts_cms_roles DROP CONSTRAINT fklayouts_cms_roles1;
       public       dotcmsdbuser    false    327    303    4261                       2606    61188 &   layouts_cms_roles fklayouts_cms_roles2    FK CONSTRAINT     �   ALTER TABLE ONLY public.layouts_cms_roles
    ADD CONSTRAINT fklayouts_cms_roles2 FOREIGN KEY (layout_id) REFERENCES public.cms_layout(id);
 P   ALTER TABLE ONLY public.layouts_cms_roles DROP CONSTRAINT fklayouts_cms_roles2;
       public       dotcmsdbuser    false    349    4439    327            �           2606    61162 "   users_cms_roles fkusers_cms_roles1    FK CONSTRAINT     �   ALTER TABLE ONLY public.users_cms_roles
    ADD CONSTRAINT fkusers_cms_roles1 FOREIGN KEY (role_id) REFERENCES public.cms_role(id);
 L   ALTER TABLE ONLY public.users_cms_roles DROP CONSTRAINT fkusers_cms_roles1;
       public       dotcmsdbuser    false    303    299    4261            �           2606    61167 "   users_cms_roles fkusers_cms_roles2    FK CONSTRAINT     �   ALTER TABLE ONLY public.users_cms_roles
    ADD CONSTRAINT fkusers_cms_roles2 FOREIGN KEY (user_id) REFERENCES public.user_(userid);
 L   ALTER TABLE ONLY public.users_cms_roles DROP CONSTRAINT fkusers_cms_roles2;
       public       dotcmsdbuser    false    250    299    4104            /           2606    61311    folder folder_identifier_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.folder
    ADD CONSTRAINT folder_identifier_fk FOREIGN KEY (identifier) REFERENCES public.identifier(id);
 E   ALTER TABLE ONLY public.folder DROP CONSTRAINT folder_identifier_fk;
       public       dotcmsdbuser    false    347    4322    319                       2606    61205    htmlpage htmlpage_identifier_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.htmlpage
    ADD CONSTRAINT htmlpage_identifier_fk FOREIGN KEY (identifier) REFERENCES public.identifier(id);
 I   ALTER TABLE ONLY public.htmlpage DROP CONSTRAINT htmlpage_identifier_fk;
       public       dotcmsdbuser    false    312    4322    319            (           2606    61220    links links_identifier_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_identifier_fk FOREIGN KEY (identifier) REFERENCES public.identifier(id);
 C   ALTER TABLE ONLY public.links DROP CONSTRAINT links_identifier_fk;
       public       dotcmsdbuser    false    342    319    4322            �           2606    61064    permission permission_role_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.permission
    ADD CONSTRAINT permission_role_fk FOREIGN KEY (roleid) REFERENCES public.cms_role(id);
 G   ALTER TABLE ONLY public.permission DROP CONSTRAINT permission_role_fk;
       public       dotcmsdbuser    false    305    4261    303            �           2606    60090 7   qrtz_blob_triggers qrtz_blob_triggers_trigger_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_blob_triggers
    ADD CONSTRAINT qrtz_blob_triggers_trigger_name_fkey FOREIGN KEY (trigger_name, trigger_group) REFERENCES public.qrtz_triggers(trigger_name, trigger_group);
 a   ALTER TABLE ONLY public.qrtz_blob_triggers DROP CONSTRAINT qrtz_blob_triggers_trigger_name_fkey;
       public       dotcmsdbuser    false    263    263    260    260    4120            �           2606    60077 7   qrtz_cron_triggers qrtz_cron_triggers_trigger_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_cron_triggers
    ADD CONSTRAINT qrtz_cron_triggers_trigger_name_fkey FOREIGN KEY (trigger_name, trigger_group) REFERENCES public.qrtz_triggers(trigger_name, trigger_group);
 a   ALTER TABLE ONLY public.qrtz_cron_triggers DROP CONSTRAINT qrtz_cron_triggers_trigger_name_fkey;
       public       dotcmsdbuser    false    262    262    260    260    4120            �           2606    60195 A   qrtz_excl_blob_triggers qrtz_excl_blob_triggers_trigger_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_blob_triggers
    ADD CONSTRAINT qrtz_excl_blob_triggers_trigger_name_fkey FOREIGN KEY (trigger_name, trigger_group) REFERENCES public.qrtz_excl_triggers(trigger_name, trigger_group);
 k   ALTER TABLE ONLY public.qrtz_excl_blob_triggers DROP CONSTRAINT qrtz_excl_blob_triggers_trigger_name_fkey;
       public       dotcmsdbuser    false    272    272    4144    275    275            �           2606    60182 A   qrtz_excl_cron_triggers qrtz_excl_cron_triggers_trigger_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_cron_triggers
    ADD CONSTRAINT qrtz_excl_cron_triggers_trigger_name_fkey FOREIGN KEY (trigger_name, trigger_group) REFERENCES public.qrtz_excl_triggers(trigger_name, trigger_group);
 k   ALTER TABLE ONLY public.qrtz_excl_cron_triggers DROP CONSTRAINT qrtz_excl_cron_triggers_trigger_name_fkey;
       public       dotcmsdbuser    false    4144    274    274    272    272            �           2606    60149 =   qrtz_excl_job_listeners qrtz_excl_job_listeners_job_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_job_listeners
    ADD CONSTRAINT qrtz_excl_job_listeners_job_name_fkey FOREIGN KEY (job_name, job_group) REFERENCES public.qrtz_excl_job_details(job_name, job_group);
 g   ALTER TABLE ONLY public.qrtz_excl_job_listeners DROP CONSTRAINT qrtz_excl_job_listeners_job_name_fkey;
       public       dotcmsdbuser    false    270    4140    270    271    271            �           2606    60172 E   qrtz_excl_simple_triggers qrtz_excl_simple_triggers_trigger_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_simple_triggers
    ADD CONSTRAINT qrtz_excl_simple_triggers_trigger_name_fkey FOREIGN KEY (trigger_name, trigger_group) REFERENCES public.qrtz_excl_triggers(trigger_name, trigger_group);
 o   ALTER TABLE ONLY public.qrtz_excl_simple_triggers DROP CONSTRAINT qrtz_excl_simple_triggers_trigger_name_fkey;
       public       dotcmsdbuser    false    272    273    272    4144    273            �           2606    60205 I   qrtz_excl_trigger_listeners qrtz_excl_trigger_listeners_trigger_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_trigger_listeners
    ADD CONSTRAINT qrtz_excl_trigger_listeners_trigger_name_fkey FOREIGN KEY (trigger_name, trigger_group) REFERENCES public.qrtz_excl_triggers(trigger_name, trigger_group);
 s   ALTER TABLE ONLY public.qrtz_excl_trigger_listeners DROP CONSTRAINT qrtz_excl_trigger_listeners_trigger_name_fkey;
       public       dotcmsdbuser    false    4144    272    272    276    276            �           2606    60162 3   qrtz_excl_triggers qrtz_excl_triggers_job_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_triggers
    ADD CONSTRAINT qrtz_excl_triggers_job_name_fkey FOREIGN KEY (job_name, job_group) REFERENCES public.qrtz_excl_job_details(job_name, job_group);
 ]   ALTER TABLE ONLY public.qrtz_excl_triggers DROP CONSTRAINT qrtz_excl_triggers_job_name_fkey;
       public       dotcmsdbuser    false    272    272    4140    270    270            �           2606    60044 3   qrtz_job_listeners qrtz_job_listeners_job_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_job_listeners
    ADD CONSTRAINT qrtz_job_listeners_job_name_fkey FOREIGN KEY (job_name, job_group) REFERENCES public.qrtz_job_details(job_name, job_group);
 ]   ALTER TABLE ONLY public.qrtz_job_listeners DROP CONSTRAINT qrtz_job_listeners_job_name_fkey;
       public       dotcmsdbuser    false    4116    258    258    259    259            �           2606    60067 ;   qrtz_simple_triggers qrtz_simple_triggers_trigger_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_simple_triggers
    ADD CONSTRAINT qrtz_simple_triggers_trigger_name_fkey FOREIGN KEY (trigger_name, trigger_group) REFERENCES public.qrtz_triggers(trigger_name, trigger_group);
 e   ALTER TABLE ONLY public.qrtz_simple_triggers DROP CONSTRAINT qrtz_simple_triggers_trigger_name_fkey;
       public       dotcmsdbuser    false    261    261    260    260    4120            �           2606    60100 ?   qrtz_trigger_listeners qrtz_trigger_listeners_trigger_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_trigger_listeners
    ADD CONSTRAINT qrtz_trigger_listeners_trigger_name_fkey FOREIGN KEY (trigger_name, trigger_group) REFERENCES public.qrtz_triggers(trigger_name, trigger_group);
 i   ALTER TABLE ONLY public.qrtz_trigger_listeners DROP CONSTRAINT qrtz_trigger_listeners_trigger_name_fkey;
       public       dotcmsdbuser    false    4120    264    264    260    260            �           2606    60057 )   qrtz_triggers qrtz_triggers_job_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_triggers
    ADD CONSTRAINT qrtz_triggers_job_name_fkey FOREIGN KEY (job_name, job_group) REFERENCES public.qrtz_job_details(job_name, job_group);
 S   ALTER TABLE ONLY public.qrtz_triggers DROP CONSTRAINT qrtz_triggers_job_name_fkey;
       public       dotcmsdbuser    false    260    4116    258    260    258                       2606    61316    htmlpage template_id_fk    FK CONSTRAINT        ALTER TABLE ONLY public.htmlpage
    ADD CONSTRAINT template_id_fk FOREIGN KEY (template_id) REFERENCES public.identifier(id);
 A   ALTER TABLE ONLY public.htmlpage DROP CONSTRAINT template_id_fk;
       public       dotcmsdbuser    false    312    4322    319            �           2606    61200    template template_identifier_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.template
    ADD CONSTRAINT template_identifier_fk FOREIGN KEY (identifier) REFERENCES public.identifier(id);
 I   ALTER TABLE ONLY public.template DROP CONSTRAINT template_identifier_fk;
       public       dotcmsdbuser    false    300    4322    319            ?           2606    61527 :   workflow_action_class workflow_action_class_action_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_action_class
    ADD CONSTRAINT workflow_action_class_action_id_fkey FOREIGN KEY (action_id) REFERENCES public.workflow_action(id);
 d   ALTER TABLE ONLY public.workflow_action_class DROP CONSTRAINT workflow_action_class_action_id_fkey;
       public       dotcmsdbuser    false    393    392    4494            @           2606    61541 S   workflow_action_class_pars workflow_action_class_pars_workflow_action_class_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_action_class_pars
    ADD CONSTRAINT workflow_action_class_pars_workflow_action_class_id_fkey FOREIGN KEY (workflow_action_class_id) REFERENCES public.workflow_action_class(id);
 }   ALTER TABLE ONLY public.workflow_action_class_pars DROP CONSTRAINT workflow_action_class_pars_workflow_action_class_id_fkey;
       public       dotcmsdbuser    false    394    4497    393            <           2606    61512 0   workflow_action workflow_action_next_assign_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_action
    ADD CONSTRAINT workflow_action_next_assign_fkey FOREIGN KEY (next_assign) REFERENCES public.cms_role(id);
 Z   ALTER TABLE ONLY public.workflow_action DROP CONSTRAINT workflow_action_next_assign_fkey;
       public       dotcmsdbuser    false    303    392    4261            =           2606    61507 1   workflow_action workflow_action_next_step_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_action
    ADD CONSTRAINT workflow_action_next_step_id_fkey FOREIGN KEY (next_step_id) REFERENCES public.workflow_step(id);
 [   ALTER TABLE ONLY public.workflow_action DROP CONSTRAINT workflow_action_next_step_id_fkey;
       public       dotcmsdbuser    false    4492    391    392            >           2606    61502 ,   workflow_action workflow_action_step_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_action
    ADD CONSTRAINT workflow_action_step_id_fkey FOREIGN KEY (step_id) REFERENCES public.workflow_step(id);
 V   ALTER TABLE ONLY public.workflow_action DROP CONSTRAINT workflow_action_step_id_fkey;
       public       dotcmsdbuser    false    392    4492    391            B           2606    61552 F   workflow_scheme_x_structure workflow_scheme_x_structure_scheme_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_scheme_x_structure
    ADD CONSTRAINT workflow_scheme_x_structure_scheme_id_fkey FOREIGN KEY (scheme_id) REFERENCES public.workflow_scheme(id);
 p   ALTER TABLE ONLY public.workflow_scheme_x_structure DROP CONSTRAINT workflow_scheme_x_structure_scheme_id_fkey;
       public       dotcmsdbuser    false    390    395    4489            A           2606    61557 I   workflow_scheme_x_structure workflow_scheme_x_structure_structure_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_scheme_x_structure
    ADD CONSTRAINT workflow_scheme_x_structure_structure_id_fkey FOREIGN KEY (structure_id) REFERENCES public.structure(inode);
 s   ALTER TABLE ONLY public.workflow_scheme_x_structure DROP CONSTRAINT workflow_scheme_x_structure_structure_id_fkey;
       public       dotcmsdbuser    false    302    4253    395            ;           2606    61482 *   workflow_step workflow_step_scheme_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_step
    ADD CONSTRAINT workflow_step_scheme_id_fkey FOREIGN KEY (scheme_id) REFERENCES public.workflow_scheme(id);
 T   ALTER TABLE ONLY public.workflow_step DROP CONSTRAINT workflow_step_scheme_id_fkey;
       public       dotcmsdbuser    false    4489    391    390            �           2606    61445 +   workflow_comment workflowtask_id_comment_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_comment
    ADD CONSTRAINT workflowtask_id_comment_fk FOREIGN KEY (workflowtask_id) REFERENCES public.workflow_task(id);
 U   ALTER TABLE ONLY public.workflow_comment DROP CONSTRAINT workflowtask_id_comment_fk;
       public       dotcmsdbuser    false    322    310    4347            &           2606    61450 +   workflow_history workflowtask_id_history_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_history
    ADD CONSTRAINT workflowtask_id_history_fk FOREIGN KEY (workflowtask_id) REFERENCES public.workflow_task(id);
 U   ALTER TABLE ONLY public.workflow_history DROP CONSTRAINT workflowtask_id_history_fk;
       public       dotcmsdbuser    false    322    4347    340           