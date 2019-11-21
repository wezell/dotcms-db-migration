PGDMP                          w            dotcms    9.6.11    9.6.11 �   t           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            u           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            v           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            w           1262    28883    dotcms    DATABASE     x   CREATE DATABASE dotcms WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE dotcms;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            x           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    3                        3079    13311    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            y           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1            q           1255    30144 !   bigIntBoolResult(boolean, bigint)    FUNCTION     �   CREATE FUNCTION public."bigIntBoolResult"("boolParam" boolean, "intParam" bigint) RETURNS boolean
    LANGUAGE sql
    AS $_$select case
		WHEN $1 AND $2 != 0 then true
		WHEN $1 != true AND $2 = 0 then true
		ELSE false
	END$_$;
 Q   DROP FUNCTION public."bigIntBoolResult"("boolParam" boolean, "intParam" bigint);
       public       dotcmsdbuser    false    3            p           1255    30143 !   boolBigIntResult(bigint, boolean)    FUNCTION     �   CREATE FUNCTION public."boolBigIntResult"("intParam" bigint, "boolParam" boolean) RETURNS boolean
    LANGUAGE sql
    AS $_$select case
		WHEN $2 AND $1 != 0 then true
		WHEN $2 != true AND $1 = 0 then true
		ELSE false
	END$_$;
 Q   DROP FUNCTION public."boolBigIntResult"("intParam" bigint, "boolParam" boolean);
       public       dotcmsdbuser    false    3            n           1255    30139    boolIntResult(integer, boolean)    FUNCTION     �   CREATE FUNCTION public."boolIntResult"("intParam" integer, "boolParam" boolean) RETURNS boolean
    LANGUAGE sql
    AS $_$select case
		WHEN $2 AND $1 != 0 then true
		WHEN $2 != true AND $1 = 0 then true
		ELSE false
	END$_$;
 O   DROP FUNCTION public."boolIntResult"("intParam" integer, "boolParam" boolean);
       public       dotcmsdbuser    false    3            �           1255    30181    check_child_assets()    FUNCTION     �  CREATE FUNCTION public.check_child_assets() RETURNS trigger
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
       public       dotcmsdbuser    false    1    3            u           1255    30175    container_versions_check()    FUNCTION     �  CREATE FUNCTION public.container_versions_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
	versionsCount integer;
  BEGIN
  IF (tg_op = 'DELETE') THEN
    select count(*) into versionsCount from dot_containers where identifier = OLD.identifier;
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
       public       dotcmsdbuser    false    3    1            s           1255    30171    content_versions_check()    FUNCTION     �  CREATE FUNCTION public.content_versions_check() RETURNS trigger
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
       public       dotcmsdbuser    false    3    1            �           1255    30232    dotfolderpath(text, text)    FUNCTION     �   CREATE FUNCTION public.dotfolderpath(parent_path text, asset_name text) RETURNS text
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
       public       dotcmsdbuser    false    3    1            �           1255    30216    folder_identifier_check()    FUNCTION     �  CREATE FUNCTION public.folder_identifier_check() RETURNS trigger
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
       public       dotcmsdbuser    false    3    1            r           1255    30147    identifier_host_inode_check()    FUNCTION     �  CREATE FUNCTION public.identifier_host_inode_check() RETURNS trigger
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
       public       dotcmsdbuser    false    1    3            �           1255    30179    identifier_parent_path_check()    FUNCTION     �  CREATE FUNCTION public.identifier_parent_path_check() RETURNS trigger
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
       public       dotcmsdbuser    false    3    1            o           1255    30140    intBoolResult(boolean, integer)    FUNCTION     �   CREATE FUNCTION public."intBoolResult"("boolParam" boolean, "intParam" integer) RETURNS boolean
    LANGUAGE sql
    AS $_$select case
		WHEN $1 AND $2 != 0 then true
		WHEN $1 != true AND $2 = 0 then true
		ELSE false
	END$_$;
 O   DROP FUNCTION public."intBoolResult"("boolParam" boolean, "intParam" integer);
       public       dotcmsdbuser    false    3            t           1255    30173    link_versions_check()    FUNCTION     �  CREATE FUNCTION public.link_versions_check() RETURNS trigger
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
       public       dotcmsdbuser    false    1    3            E           1259    30048    dist_reindex_journal    TABLE     �  CREATE TABLE public.dist_reindex_journal (
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
       public         dotcmsdbuser    false    3            �           1255    30170 :   load_records_to_index(character varying, integer, integer)    FUNCTION     4  CREATE FUNCTION public.load_records_to_index(server_id character varying, records_to_fetch integer, priority_level integer) RETURNS SETOF public.dist_reindex_journal
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
       public       dotcmsdbuser    false    1    3    325            �           1255    30230    rename_folder_and_assets()    FUNCTION     �  CREATE FUNCTION public.rename_folder_and_assets() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
   old_parent_path varchar(255);
   old_path varchar(255);
   new_path varchar(255);
   old_name varchar(255);
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
       public       dotcmsdbuser    false    1    3            �           1255    30229 M   renamefolderchildren(character varying, character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.renamefolderchildren(old_path character varying, new_path character varying, hostinode character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   fi identifier;
   new_folder_path varchar(255);
   old_folder_path varchar(255);
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
       public       dotcmsdbuser    false    3    1            �           1255    30168    structure_host_folder_check()    FUNCTION     T  CREATE FUNCTION public.structure_host_folder_check() RETURNS trigger
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
       public       dotcmsdbuser    false    1    3            v           1255    30177    template_versions_check()    FUNCTION     �  CREATE FUNCTION public.template_versions_check() RETURNS trigger
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
       public       dotcmsdbuser    false    1    3            ?           2617    30141    =    OPERATOR     t   CREATE OPERATOR public.= (
    PROCEDURE = public."intBoolResult",
    LEFTARG = boolean,
    RIGHTARG = integer
);
 +   DROP OPERATOR public.= (boolean, integer);
       public       dotcmsdbuser    false    3    367            @           2617    30142    =    OPERATOR     t   CREATE OPERATOR public.= (
    PROCEDURE = public."boolIntResult",
    LEFTARG = integer,
    RIGHTARG = boolean
);
 +   DROP OPERATOR public.= (integer, boolean);
       public       dotcmsdbuser    false    366    3            A           2617    30145    =    OPERATOR     v   CREATE OPERATOR public.= (
    PROCEDURE = public."bigIntBoolResult",
    LEFTARG = boolean,
    RIGHTARG = bigint
);
 *   DROP OPERATOR public.= (boolean, bigint);
       public       dotcmsdbuser    false    369    3            B           2617    30146    =    OPERATOR     v   CREATE OPERATOR public.= (
    PROCEDURE = public."boolBigIntResult",
    LEFTARG = bigint,
    RIGHTARG = boolean
);
 *   DROP OPERATOR public.= (bigint, boolean);
       public       dotcmsdbuser    false    368    3            �            1259    28889    address    TABLE     �  CREATE TABLE public.address (
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
       public         dotcmsdbuser    false    3            �            1259    28897    adminconfig    TABLE     �   CREATE TABLE public.adminconfig (
    configid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    type_ character varying(100),
    name character varying(100),
    config text
);
    DROP TABLE public.adminconfig;
       public         dotcmsdbuser    false    3            �            1259    29320    analytic_summary    TABLE     �  CREATE TABLE public.analytic_summary (
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
       public         dotcmsdbuser    false    3            �            1259    29390    analytic_summary_404    TABLE     �   CREATE TABLE public.analytic_summary_404 (
    id bigint NOT NULL,
    summary_period_id bigint NOT NULL,
    host_id character varying(36),
    uri character varying(255),
    referer_uri character varying(255)
);
 (   DROP TABLE public.analytic_summary_404;
       public         dotcmsdbuser    false    3            �            1259    29340    analytic_summary_content    TABLE     �   CREATE TABLE public.analytic_summary_content (
    id bigint NOT NULL,
    summary_id bigint NOT NULL,
    inode character varying(255),
    hits bigint,
    uri character varying(255),
    title character varying(255)
);
 ,   DROP TABLE public.analytic_summary_content;
       public         dotcmsdbuser    false    3            �            1259    29218    analytic_summary_pages    TABLE     �   CREATE TABLE public.analytic_summary_pages (
    id bigint NOT NULL,
    summary_id bigint NOT NULL,
    inode character varying(255),
    hits bigint,
    uri character varying(255)
);
 *   DROP TABLE public.analytic_summary_pages;
       public         dotcmsdbuser    false    3            �            1259    29308    analytic_summary_period    TABLE     $  CREATE TABLE public.analytic_summary_period (
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
       public         dotcmsdbuser    false    3                       1259    29566    analytic_summary_referer    TABLE     �   CREATE TABLE public.analytic_summary_referer (
    id bigint NOT NULL,
    summary_id bigint NOT NULL,
    hits bigint,
    uri character varying(255)
);
 ,   DROP TABLE public.analytic_summary_referer;
       public         dotcmsdbuser    false    3                        1259    29437    analytic_summary_visits    TABLE     �   CREATE TABLE public.analytic_summary_visits (
    id bigint NOT NULL,
    summary_period_id bigint NOT NULL,
    host_id character varying(36),
    visit_time timestamp without time zone,
    visits bigint
);
 +   DROP TABLE public.analytic_summary_visits;
       public         dotcmsdbuser    false    3                       1259    29540    analytic_summary_workstream    TABLE     N  CREATE TABLE public.analytic_summary_workstream (
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
       public         dotcmsdbuser    false    3            Q           1259    30488    broken_link    TABLE       CREATE TABLE public.broken_link (
    id character varying(36) NOT NULL,
    inode character varying(36) NOT NULL,
    field character varying(36) NOT NULL,
    link character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    status_code integer NOT NULL
);
    DROP TABLE public.broken_link;
       public         dotcmsdbuser    false    3            �            1259    29213    calendar_reminder    TABLE     �   CREATE TABLE public.calendar_reminder (
    user_id character varying(255) NOT NULL,
    event_id character varying(36) NOT NULL,
    send_date timestamp without time zone NOT NULL
);
 %   DROP TABLE public.calendar_reminder;
       public         dotcmsdbuser    false    3                       1259    29553    campaign    TABLE     �  CREATE TABLE public.campaign (
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
       public         dotcmsdbuser    false    3            �            1259    29419    category    TABLE     G  CREATE TABLE public.category (
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
       public         dotcmsdbuser    false    3            #           1259    29687    chain    TABLE     �   CREATE TABLE public.chain (
    id bigint NOT NULL,
    key_name character varying(255),
    name character varying(255) NOT NULL,
    success_value character varying(255) NOT NULL,
    failure_value character varying(255) NOT NULL
);
    DROP TABLE public.chain;
       public         dotcmsdbuser    false    3            �            1259    29427    chain_link_code    TABLE     �   CREATE TABLE public.chain_link_code (
    id bigint NOT NULL,
    class_name character varying(255),
    code text NOT NULL,
    last_mod_date timestamp without time zone NOT NULL,
    language character varying(255) NOT NULL
);
 #   DROP TABLE public.chain_link_code;
       public         dotcmsdbuser    false    3            0           1259    29927    chain_link_code_seq    SEQUENCE     |   CREATE SEQUENCE public.chain_link_code_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.chain_link_code_seq;
       public       dotcmsdbuser    false    3            4           1259    29935 	   chain_seq    SEQUENCE     r   CREATE SEQUENCE public.chain_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
     DROP SEQUENCE public.chain_seq;
       public       dotcmsdbuser    false    3                       1259    29535    chain_state    TABLE     �   CREATE TABLE public.chain_state (
    id bigint NOT NULL,
    chain_id bigint NOT NULL,
    link_code_id bigint NOT NULL,
    state_order bigint NOT NULL
);
    DROP TABLE public.chain_state;
       public         dotcmsdbuser    false    3                       1259    29621    chain_state_parameter    TABLE     �   CREATE TABLE public.chain_state_parameter (
    id bigint NOT NULL,
    chain_state_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255) NOT NULL
);
 )   DROP TABLE public.chain_state_parameter;
       public         dotcmsdbuser    false    3            =           1259    29953    chain_state_parameter_seq    SEQUENCE     �   CREATE SEQUENCE public.chain_state_parameter_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.chain_state_parameter_seq;
       public       dotcmsdbuser    false    3            +           1259    29917    chain_state_seq    SEQUENCE     x   CREATE SEQUENCE public.chain_state_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.chain_state_seq;
       public       dotcmsdbuser    false    3                       1259    29509    challenge_question    TABLE     o   CREATE TABLE public.challenge_question (
    cquestionid bigint NOT NULL,
    cqtext character varying(255)
);
 &   DROP TABLE public.challenge_question;
       public         dotcmsdbuser    false    3            
           1259    29504    click    TABLE     �   CREATE TABLE public.click (
    inode character varying(36) NOT NULL,
    link character varying(255),
    click_count integer
);
    DROP TABLE public.click;
       public         dotcmsdbuser    false    3                       1259    29478    clickstream    TABLE     �  CREATE TABLE public.clickstream (
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
       public         dotcmsdbuser    false    3                       1259    29653    clickstream_404    TABLE     ,  CREATE TABLE public.clickstream_404 (
    clickstream_404_id bigint NOT NULL,
    referer_uri character varying(255),
    query_string text,
    request_uri character varying(255),
    user_id character varying(255),
    host_id character varying(36),
    timestampper timestamp without time zone
);
 #   DROP TABLE public.clickstream_404;
       public         dotcmsdbuser    false    3            ;           1259    29949    clickstream_404_seq    SEQUENCE     |   CREATE SEQUENCE public.clickstream_404_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.clickstream_404_seq;
       public       dotcmsdbuser    false    3                       1259    29519    clickstream_request    TABLE     �  CREATE TABLE public.clickstream_request (
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
       public         dotcmsdbuser    false    3            :           1259    29947    clickstream_request_seq    SEQUENCE     �   CREATE SEQUENCE public.clickstream_request_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.clickstream_request_seq;
       public       dotcmsdbuser    false    3            1           1259    29929    clickstream_seq    SEQUENCE     x   CREATE SEQUENCE public.clickstream_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.clickstream_seq;
       public       dotcmsdbuser    false    3            \           1259    30590    cluster_server    TABLE     �  CREATE TABLE public.cluster_server (
    server_id character varying(36) NOT NULL,
    cluster_id character varying(36) NOT NULL,
    name character varying(100),
    ip_address character varying(39) NOT NULL,
    host character varying(255),
    cache_port smallint,
    es_transport_tcp_port smallint,
    es_network_port smallint,
    es_http_port smallint,
    key_ character varying(100)
);
 "   DROP TABLE public.cluster_server;
       public         dotcmsdbuser    false    3            f           1259    30735    cluster_server_action    TABLE     �  CREATE TABLE public.cluster_server_action (
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
       public         dotcmsdbuser    false    3            ]           1259    30603    cluster_server_uptime    TABLE     �   CREATE TABLE public.cluster_server_uptime (
    id character varying(36) NOT NULL,
    server_id character varying(36),
    startup timestamp without time zone,
    heartbeat timestamp without time zone
);
 )   DROP TABLE public.cluster_server_uptime;
       public         dotcmsdbuser    false    3                        1259    29661 
   cms_layout    TABLE     �   CREATE TABLE public.cms_layout (
    id character varying(36) NOT NULL,
    layout_name character varying(255) NOT NULL,
    description character varying(255),
    tab_order integer
);
    DROP TABLE public.cms_layout;
       public         dotcmsdbuser    false    3            �            1259    29398    cms_layouts_portlets    TABLE     �   CREATE TABLE public.cms_layouts_portlets (
    id character varying(36) NOT NULL,
    layout_id character varying(36) NOT NULL,
    portlet_id character varying(100) NOT NULL,
    portlet_order integer
);
 (   DROP TABLE public.cms_layouts_portlets;
       public         dotcmsdbuser    false    3            �            1259    29356    cms_role    TABLE     �  CREATE TABLE public.cms_role (
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
       public         dotcmsdbuser    false    3            e           1259    30697    cms_roles_ir    TABLE     Q  CREATE TABLE public.cms_roles_ir (
    name character varying(1000),
    role_key character varying(255),
    local_role_id character varying(36) NOT NULL,
    remote_role_id character varying(36),
    local_role_fqn character varying(1000),
    remote_role_fqn character varying(1000),
    endpoint_id character varying(36) NOT NULL
);
     DROP TABLE public.cms_roles_ir;
       public         dotcmsdbuser    false    3                       1259    29579    communication    TABLE       CREATE TABLE public.communication (
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
       public         dotcmsdbuser    false    3            �            1259    28905    company    TABLE     �  CREATE TABLE public.company (
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
       public         dotcmsdbuser    false    3            �            1259    29364    container_structures    TABLE     �   CREATE TABLE public.container_structures (
    id character varying(36) NOT NULL,
    container_id character varying(36) NOT NULL,
    container_inode character varying(36) NOT NULL,
    structure_id character varying(36) NOT NULL,
    code text
);
 (   DROP TABLE public.container_structures;
       public         dotcmsdbuser    false    3            �            1259    29263    container_version_info    TABLE     Z  CREATE TABLE public.container_version_info (
    identifier character varying(36) NOT NULL,
    working_inode character varying(36) NOT NULL,
    live_inode character varying(36),
    deleted boolean NOT NULL,
    locked_by character varying(100),
    locked_on timestamp without time zone,
    version_ts timestamp without time zone NOT NULL
);
 *   DROP TABLE public.container_version_info;
       public         dotcmsdbuser    false    3                       1259    29527    content_rating    TABLE     B  CREATE TABLE public.content_rating (
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
       public         dotcmsdbuser    false    3            3           1259    29933    content_rating_sequence    SEQUENCE     �   CREATE SEQUENCE public.content_rating_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.content_rating_sequence;
       public       dotcmsdbuser    false    3            �            1259    29382 
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
       public         dotcmsdbuser    false    3            �            1259    29250    contentlet_version_info    TABLE     u  CREATE TABLE public.contentlet_version_info (
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
       public         dotcmsdbuser    false    3            �            1259    28913    counter    TABLE     a   CREATE TABLE public.counter (
    name character varying(100) NOT NULL,
    currentid integer
);
    DROP TABLE public.counter;
       public         dotcmsdbuser    false    3                       1259    29548    dashboard_user_preferences    TABLE     �   CREATE TABLE public.dashboard_user_preferences (
    id bigint NOT NULL,
    summary_404_id bigint,
    user_id character varying(255),
    ignored boolean,
    mod_date timestamp without time zone
);
 .   DROP TABLE public.dashboard_user_preferences;
       public         dotcmsdbuser    false    3            *           1259    29915    dashboard_usrpref_seq    SEQUENCE     ~   CREATE SEQUENCE public.dashboard_usrpref_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.dashboard_usrpref_seq;
       public       dotcmsdbuser    false    3            �            1259    28884 
   db_version    TABLE     w   CREATE TABLE public.db_version (
    db_version integer NOT NULL,
    date_update timestamp with time zone NOT NULL
);
    DROP TABLE public.db_version;
       public         dotcmsdbuser    false    3            @           1259    30010    dist_journal    TABLE     �   CREATE TABLE public.dist_journal (
    id bigint NOT NULL,
    object_to_index character varying(1024) NOT NULL,
    serverid character varying(64),
    journal_type integer NOT NULL,
    time_entered timestamp without time zone NOT NULL
);
     DROP TABLE public.dist_journal;
       public         dotcmsdbuser    false    3            ?           1259    30008    dist_journal_id_seq    SEQUENCE     |   CREATE SEQUENCE public.dist_journal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.dist_journal_id_seq;
       public       dotcmsdbuser    false    320    3            z           0    0    dist_journal_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.dist_journal_id_seq OWNED BY public.dist_journal.id;
            public       dotcmsdbuser    false    319            C           1259    30036    dist_process    TABLE     �   CREATE TABLE public.dist_process (
    id bigint NOT NULL,
    object_to_index character varying(1024) NOT NULL,
    serverid character varying(64),
    journal_type integer NOT NULL,
    time_entered timestamp without time zone NOT NULL
);
     DROP TABLE public.dist_process;
       public         dotcmsdbuser    false    3            B           1259    30034    dist_process_id_seq    SEQUENCE     |   CREATE SEQUENCE public.dist_process_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.dist_process_id_seq;
       public       dotcmsdbuser    false    3    323            {           0    0    dist_process_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.dist_process_id_seq OWNED BY public.dist_process.id;
            public       dotcmsdbuser    false    322            D           1259    30046    dist_reindex_journal_id_seq    SEQUENCE     �   CREATE SEQUENCE public.dist_reindex_journal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.dist_reindex_journal_id_seq;
       public       dotcmsdbuser    false    325    3            |           0    0    dist_reindex_journal_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.dist_reindex_journal_id_seq OWNED BY public.dist_reindex_journal.id;
            public       dotcmsdbuser    false    324            [           1259    30585    dot_cluster    TABLE     S   CREATE TABLE public.dot_cluster (
    cluster_id character varying(36) NOT NULL
);
    DROP TABLE public.dot_cluster;
       public         dotcmsdbuser    false    3                       1259    29571    dot_containers    TABLE     ,  CREATE TABLE public.dot_containers (
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
 "   DROP TABLE public.dot_containers;
       public         dotcmsdbuser    false    3            g           1259    30743    dot_rule    TABLE     �  CREATE TABLE public.dot_rule (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    fire_on character varying(20),
    short_circuit boolean DEFAULT false,
    parent_id character varying(36) NOT NULL,
    folder character varying(36) NOT NULL,
    priority integer DEFAULT 0,
    enabled boolean DEFAULT false,
    mod_date timestamp without time zone
);
    DROP TABLE public.dot_rule;
       public         dotcmsdbuser    false    3                       1259    29629    field    TABLE     �  CREATE TABLE public.field (
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
       public         dotcmsdbuser    false    3            !           1259    29669    field_variable    TABLE     1  CREATE TABLE public.field_variable (
    id character varying(36) NOT NULL,
    field_id character varying(36),
    variable_name character varying(255),
    variable_key character varying(255),
    variable_value text,
    user_id character varying(255),
    last_mod_date timestamp without time zone
);
 "   DROP TABLE public.field_variable;
       public         dotcmsdbuser    false    3            d           1259    30689    fileassets_ir    TABLE     �  CREATE TABLE public.fileassets_ir (
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
       public         dotcmsdbuser    false    3            �            1259    29255    fixes_audit    TABLE     �   CREATE TABLE public.fixes_audit (
    id character varying(36) NOT NULL,
    table_name character varying(255),
    action character varying(255),
    records_altered integer,
    datetime timestamp without time zone
);
    DROP TABLE public.fixes_audit;
       public         dotcmsdbuser    false    3                       1259    29645    folder    TABLE     l  CREATE TABLE public.folder (
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
       public         dotcmsdbuser    false    3            `           1259    30666 
   folders_ir    TABLE     '  CREATE TABLE public.folders_ir (
    folder character varying(255),
    local_inode character varying(36) NOT NULL,
    remote_inode character varying(36),
    local_identifier character varying(36),
    remote_identifier character varying(36),
    endpoint_id character varying(36) NOT NULL
);
    DROP TABLE public.folders_ir;
       public         dotcmsdbuser    false    3                       1259    29595    host_variable    TABLE     A  CREATE TABLE public.host_variable (
    id character varying(36) NOT NULL,
    host_id character varying(36),
    variable_name character varying(255),
    variable_key character varying(255),
    variable_value character varying(255),
    user_id character varying(255),
    last_mod_date timestamp without time zone
);
 !   DROP TABLE public.host_variable;
       public         dotcmsdbuser    false    3            c           1259    30681    htmlpages_ir    TABLE     �  CREATE TABLE public.htmlpages_ir (
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
       public         dotcmsdbuser    false    3                       1259    29468 
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
       public         dotcmsdbuser    false    3            �            1259    28918    image    TABLE     d   CREATE TABLE public.image (
    imageid character varying(200) NOT NULL,
    text_ text NOT NULL
);
    DROP TABLE public.image;
       public         dotcmsdbuser    false    3            H           1259    30149    import_audit    TABLE     x  CREATE TABLE public.import_audit (
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
       public         dotcmsdbuser    false    3            O           1259    30475    indicies    TABLE        CREATE TABLE public.indicies (
    index_name character varying(30) NOT NULL,
    index_type character varying(16) NOT NULL
);
    DROP TABLE public.indicies;
       public         dotcmsdbuser    false    3            '           1259    29715    inode    TABLE     �   CREATE TABLE public.inode (
    inode character varying(36) NOT NULL,
    owner character varying(255),
    idate timestamp without time zone,
    type character varying(64)
);
    DROP TABLE public.inode;
       public         dotcmsdbuser    false    3                       1259    29455    language    TABLE     �   CREATE TABLE public.language (
    id bigint NOT NULL,
    language_code character varying(5),
    country_code character varying(255),
    language character varying(255),
    country character varying(255)
);
    DROP TABLE public.language;
       public         dotcmsdbuser    false    3            -           1259    29921    language_seq    SEQUENCE     u   CREATE SEQUENCE public.language_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.language_seq;
       public       dotcmsdbuser    false    3                       1259    29514    layouts_cms_roles    TABLE     �   CREATE TABLE public.layouts_cms_roles (
    id character varying(36) NOT NULL,
    layout_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);
 %   DROP TABLE public.layouts_cms_roles;
       public         dotcmsdbuser    false    3            $           1259    29697    link_version_info    TABLE     U  CREATE TABLE public.link_version_info (
    identifier character varying(36) NOT NULL,
    working_inode character varying(36) NOT NULL,
    live_inode character varying(36),
    deleted boolean NOT NULL,
    locked_by character varying(100),
    locked_on timestamp without time zone,
    version_ts timestamp without time zone NOT NULL
);
 %   DROP TABLE public.link_version_info;
       public         dotcmsdbuser    false    3                       1259    29603    links    TABLE       CREATE TABLE public.links (
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
       public         dotcmsdbuser    false    3            P           1259    30482 
   log_mapper    TABLE     �   CREATE TABLE public.log_mapper (
    enabled numeric(1,0) NOT NULL,
    log_name character varying(30) NOT NULL,
    description character varying(50) NOT NULL
);
    DROP TABLE public.log_mapper;
       public         dotcmsdbuser    false    3            �            1259    29284    mailing_list    TABLE     �   CREATE TABLE public.mailing_list (
    inode character varying(36) NOT NULL,
    title character varying(255),
    public_list boolean,
    user_id character varying(255)
);
     DROP TABLE public.mailing_list;
       public         dotcmsdbuser    false    3                       1259    29486 
   multi_tree    TABLE     �   CREATE TABLE public.multi_tree (
    child character varying(36) NOT NULL,
    parent1 character varying(36) NOT NULL,
    parent2 character varying(36) NOT NULL,
    relation_type character varying(64),
    tree_order integer
);
    DROP TABLE public.multi_tree;
       public         dotcmsdbuser    false    3            ^           1259    30633    notification    TABLE     O  CREATE TABLE public.notification (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    message text NOT NULL,
    notification_type character varying(100),
    notification_level character varying(100),
    time_sent timestamp without time zone NOT NULL,
    was_read boolean DEFAULT false
);
     DROP TABLE public.notification;
       public         dotcmsdbuser    false    3            �            1259    28926    passwordtracker    TABLE     �   CREATE TABLE public.passwordtracker (
    passwordtrackerid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    createdate timestamp without time zone NOT NULL,
    password_ character varying(100) NOT NULL
);
 #   DROP TABLE public.passwordtracker;
       public         dotcmsdbuser    false    3            �            1259    29372 
   permission    TABLE     �   CREATE TABLE public.permission (
    id bigint NOT NULL,
    permission_type character varying(500),
    inode_id character varying(36),
    roleid character varying(36),
    permission integer
);
    DROP TABLE public.permission;
       public         dotcmsdbuser    false    3            �            1259    29243    permission_reference    TABLE     �   CREATE TABLE public.permission_reference (
    id bigint NOT NULL,
    asset_id character varying(36),
    reference_id character varying(36),
    permission_type character varying(100)
);
 (   DROP TABLE public.permission_reference;
       public         dotcmsdbuser    false    3            .           1259    29923    permission_reference_seq    SEQUENCE     �   CREATE SEQUENCE public.permission_reference_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.permission_reference_seq;
       public       dotcmsdbuser    false    3            >           1259    29955    permission_seq    SEQUENCE     w   CREATE SEQUENCE public.permission_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.permission_seq;
       public       dotcmsdbuser    false    3            �            1259    29276    plugin    TABLE     S  CREATE TABLE public.plugin (
    id character varying(255) NOT NULL,
    plugin_name character varying(255) NOT NULL,
    plugin_version character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    first_deployed_date timestamp without time zone NOT NULL,
    last_deployed_date timestamp without time zone NOT NULL
);
    DROP TABLE public.plugin;
       public         dotcmsdbuser    false    3            A           1259    30021    plugin_property    TABLE     �   CREATE TABLE public.plugin_property (
    plugin_id character varying(255) NOT NULL,
    propkey character varying(255) NOT NULL,
    original_value character varying(255) NOT NULL,
    current_value character varying(255) NOT NULL
);
 #   DROP TABLE public.plugin_property;
       public         dotcmsdbuser    false    3            �            1259    28931    pollschoice    TABLE     �   CREATE TABLE public.pollschoice (
    choiceid character varying(100) NOT NULL,
    questionid character varying(100) NOT NULL,
    description text
);
    DROP TABLE public.pollschoice;
       public         dotcmsdbuser    false    3            �            1259    28939    pollsdisplay    TABLE     �   CREATE TABLE public.pollsdisplay (
    layoutid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    portletid character varying(100) NOT NULL,
    questionid character varying(100) NOT NULL
);
     DROP TABLE public.pollsdisplay;
       public         dotcmsdbuser    false    3            �            1259    28944    pollsquestion    TABLE     "  CREATE TABLE public.pollsquestion (
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
       public         dotcmsdbuser    false    3            �            1259    28952 	   pollsvote    TABLE     �   CREATE TABLE public.pollsvote (
    questionid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    choiceid character varying(100) NOT NULL,
    votedate timestamp without time zone
);
    DROP TABLE public.pollsvote;
       public         dotcmsdbuser    false    3            �            1259    28957    portlet    TABLE       CREATE TABLE public.portlet (
    portletid character varying(100) NOT NULL,
    groupid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    defaultpreferences text,
    narrow boolean,
    roles text,
    active_ boolean
);
    DROP TABLE public.portlet;
       public         dotcmsdbuser    false    3            �            1259    28965    portletpreferences    TABLE     �   CREATE TABLE public.portletpreferences (
    portletid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    layoutid character varying(100) NOT NULL,
    preferences text
);
 &   DROP TABLE public.portletpreferences;
       public         dotcmsdbuser    false    3            X           1259    30550    publishing_bundle    TABLE       CREATE TABLE public.publishing_bundle (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    publish_date timestamp without time zone,
    expire_date timestamp without time zone,
    owner character varying(100),
    force_push boolean
);
 %   DROP TABLE public.publishing_bundle;
       public         dotcmsdbuser    false    3            Y           1259    30560    publishing_bundle_environment    TABLE     �   CREATE TABLE public.publishing_bundle_environment (
    id character varying(36) NOT NULL,
    bundle_id character varying(36) NOT NULL,
    environment_id character varying(36) NOT NULL
);
 1   DROP TABLE public.publishing_bundle_environment;
       public         dotcmsdbuser    false    3            U           1259    30525    publishing_end_point    TABLE     F  CREATE TABLE public.publishing_end_point (
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
       public         dotcmsdbuser    false    3            V           1259    30535    publishing_environment    TABLE     �   CREATE TABLE public.publishing_environment (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    push_to_all boolean NOT NULL
);
 *   DROP TABLE public.publishing_environment;
       public         dotcmsdbuser    false    3            Z           1259    30575    publishing_pushed_assets    TABLE     E  CREATE TABLE public.publishing_pushed_assets (
    bundle_id character varying(36) NOT NULL,
    asset_id character varying(36) NOT NULL,
    asset_type character varying(255) NOT NULL,
    push_date timestamp without time zone,
    environment_id character varying(36) NOT NULL,
    endpoint_ids text,
    publisher text
);
 ,   DROP TABLE public.publishing_pushed_assets;
       public         dotcmsdbuser    false    3            S           1259    30508    publishing_queue    TABLE     G  CREATE TABLE public.publishing_queue (
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
       public         dotcmsdbuser    false    3            T           1259    30517    publishing_queue_audit    TABLE     �   CREATE TABLE public.publishing_queue_audit (
    bundle_id character varying(256) NOT NULL,
    status integer,
    status_pojo text,
    status_updated timestamp without time zone,
    create_date timestamp without time zone
);
 *   DROP TABLE public.publishing_queue_audit;
       public         dotcmsdbuser    false    3            R           1259    30506    publishing_queue_id_seq    SEQUENCE     �   CREATE SEQUENCE public.publishing_queue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.publishing_queue_id_seq;
       public       dotcmsdbuser    false    339    3            }           0    0    publishing_queue_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.publishing_queue_id_seq OWNED BY public.publishing_queue.id;
            public       dotcmsdbuser    false    338            �            1259    29054    qrtz_blob_triggers    TABLE     �   CREATE TABLE public.qrtz_blob_triggers (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    blob_data bytea
);
 &   DROP TABLE public.qrtz_blob_triggers;
       public         dotcmsdbuser    false    3            �            1259    29077    qrtz_calendars    TABLE     v   CREATE TABLE public.qrtz_calendars (
    calendar_name character varying(80) NOT NULL,
    calendar bytea NOT NULL
);
 "   DROP TABLE public.qrtz_calendars;
       public         dotcmsdbuser    false    3            �            1259    29044    qrtz_cron_triggers    TABLE     �   CREATE TABLE public.qrtz_cron_triggers (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    cron_expression character varying(80) NOT NULL,
    time_zone_id character varying(80)
);
 &   DROP TABLE public.qrtz_cron_triggers;
       public         dotcmsdbuser    false    3            �            1259    29159    qrtz_excl_blob_triggers    TABLE     �   CREATE TABLE public.qrtz_excl_blob_triggers (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    blob_data bytea
);
 +   DROP TABLE public.qrtz_excl_blob_triggers;
       public         dotcmsdbuser    false    3            �            1259    29182    qrtz_excl_calendars    TABLE     {   CREATE TABLE public.qrtz_excl_calendars (
    calendar_name character varying(80) NOT NULL,
    calendar bytea NOT NULL
);
 '   DROP TABLE public.qrtz_excl_calendars;
       public         dotcmsdbuser    false    3            �            1259    29149    qrtz_excl_cron_triggers    TABLE     �   CREATE TABLE public.qrtz_excl_cron_triggers (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    cron_expression character varying(80) NOT NULL,
    time_zone_id character varying(80)
);
 +   DROP TABLE public.qrtz_excl_cron_triggers;
       public         dotcmsdbuser    false    3            �            1259    29195    qrtz_excl_fired_triggers    TABLE     �  CREATE TABLE public.qrtz_excl_fired_triggers (
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
       public         dotcmsdbuser    false    3            �            1259    29108    qrtz_excl_job_details    TABLE     �  CREATE TABLE public.qrtz_excl_job_details (
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
       public         dotcmsdbuser    false    3            �            1259    29116    qrtz_excl_job_listeners    TABLE     �   CREATE TABLE public.qrtz_excl_job_listeners (
    job_name character varying(80) NOT NULL,
    job_group character varying(80) NOT NULL,
    job_listener character varying(80) NOT NULL
);
 +   DROP TABLE public.qrtz_excl_job_listeners;
       public         dotcmsdbuser    false    3            �            1259    29208    qrtz_excl_locks    TABLE     V   CREATE TABLE public.qrtz_excl_locks (
    lock_name character varying(40) NOT NULL
);
 #   DROP TABLE public.qrtz_excl_locks;
       public         dotcmsdbuser    false    3            �            1259    29190    qrtz_excl_paused_trigger_grps    TABLE     h   CREATE TABLE public.qrtz_excl_paused_trigger_grps (
    trigger_group character varying(80) NOT NULL
);
 1   DROP TABLE public.qrtz_excl_paused_trigger_grps;
       public         dotcmsdbuser    false    3            �            1259    29203    qrtz_excl_scheduler_state    TABLE     �   CREATE TABLE public.qrtz_excl_scheduler_state (
    instance_name character varying(80) NOT NULL,
    last_checkin_time bigint NOT NULL,
    checkin_interval bigint NOT NULL
);
 -   DROP TABLE public.qrtz_excl_scheduler_state;
       public         dotcmsdbuser    false    3            �            1259    29139    qrtz_excl_simple_triggers    TABLE       CREATE TABLE public.qrtz_excl_simple_triggers (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    repeat_count bigint NOT NULL,
    repeat_interval bigint NOT NULL,
    times_triggered bigint NOT NULL
);
 -   DROP TABLE public.qrtz_excl_simple_triggers;
       public         dotcmsdbuser    false    3            �            1259    29172    qrtz_excl_trigger_listeners    TABLE     �   CREATE TABLE public.qrtz_excl_trigger_listeners (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    trigger_listener character varying(80) NOT NULL
);
 /   DROP TABLE public.qrtz_excl_trigger_listeners;
       public         dotcmsdbuser    false    3            �            1259    29126    qrtz_excl_triggers    TABLE     o  CREATE TABLE public.qrtz_excl_triggers (
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
       public         dotcmsdbuser    false    3            �            1259    29090    qrtz_fired_triggers    TABLE     �  CREATE TABLE public.qrtz_fired_triggers (
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
       public         dotcmsdbuser    false    3            �            1259    29003    qrtz_job_details    TABLE     �  CREATE TABLE public.qrtz_job_details (
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
       public         dotcmsdbuser    false    3            �            1259    29011    qrtz_job_listeners    TABLE     �   CREATE TABLE public.qrtz_job_listeners (
    job_name character varying(80) NOT NULL,
    job_group character varying(80) NOT NULL,
    job_listener character varying(80) NOT NULL
);
 &   DROP TABLE public.qrtz_job_listeners;
       public         dotcmsdbuser    false    3            �            1259    29103 
   qrtz_locks    TABLE     Q   CREATE TABLE public.qrtz_locks (
    lock_name character varying(40) NOT NULL
);
    DROP TABLE public.qrtz_locks;
       public         dotcmsdbuser    false    3            �            1259    29085    qrtz_paused_trigger_grps    TABLE     c   CREATE TABLE public.qrtz_paused_trigger_grps (
    trigger_group character varying(80) NOT NULL
);
 ,   DROP TABLE public.qrtz_paused_trigger_grps;
       public         dotcmsdbuser    false    3            �            1259    29098    qrtz_scheduler_state    TABLE     �   CREATE TABLE public.qrtz_scheduler_state (
    instance_name character varying(80) NOT NULL,
    last_checkin_time bigint NOT NULL,
    checkin_interval bigint NOT NULL
);
 (   DROP TABLE public.qrtz_scheduler_state;
       public         dotcmsdbuser    false    3            �            1259    29034    qrtz_simple_triggers    TABLE     �   CREATE TABLE public.qrtz_simple_triggers (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    repeat_count bigint NOT NULL,
    repeat_interval bigint NOT NULL,
    times_triggered bigint NOT NULL
);
 (   DROP TABLE public.qrtz_simple_triggers;
       public         dotcmsdbuser    false    3            �            1259    29067    qrtz_trigger_listeners    TABLE     �   CREATE TABLE public.qrtz_trigger_listeners (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    trigger_listener character varying(80) NOT NULL
);
 *   DROP TABLE public.qrtz_trigger_listeners;
       public         dotcmsdbuser    false    3            �            1259    29021    qrtz_triggers    TABLE     j  CREATE TABLE public.qrtz_triggers (
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
       public         dotcmsdbuser    false    3            G           1259    30069 
   quartz_log    TABLE     �   CREATE TABLE public.quartz_log (
    id bigint NOT NULL,
    job_name character varying(255) NOT NULL,
    serverid character varying(64),
    time_started timestamp without time zone NOT NULL
);
    DROP TABLE public.quartz_log;
       public         dotcmsdbuser    false    3            F           1259    30067    quartz_log_id_seq    SEQUENCE     z   CREATE SEQUENCE public.quartz_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.quartz_log_id_seq;
       public       dotcmsdbuser    false    3    327            ~           0    0    quartz_log_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.quartz_log_id_seq OWNED BY public.quartz_log.id;
            public       dotcmsdbuser    false    326            �            1259    29292 	   recipient    TABLE     h  CREATE TABLE public.recipient (
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
       public         dotcmsdbuser    false    3                       1259    29637    relationship    TABLE     �  CREATE TABLE public.relationship (
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
       public         dotcmsdbuser    false    3            �            1259    28973    release_    TABLE     �   CREATE TABLE public.release_ (
    releaseid character varying(100) NOT NULL,
    createdate timestamp without time zone,
    modifieddate timestamp without time zone,
    buildnumber integer,
    builddate timestamp without time zone
);
    DROP TABLE public.release_;
       public         dotcmsdbuser    false    3            �            1259    29403    report_asset    TABLE       CREATE TABLE public.report_asset (
    inode character varying(36) NOT NULL,
    report_name character varying(255) NOT NULL,
    report_description character varying(1000) NOT NULL,
    requires_input boolean,
    ds character varying(100) NOT NULL,
    web_form_report boolean
);
     DROP TABLE public.report_asset;
       public         dotcmsdbuser    false    3            "           1259    29677    report_parameter    TABLE     +  CREATE TABLE public.report_parameter (
    inode character varying(36) NOT NULL,
    report_inode character varying(36),
    parameter_description character varying(1000),
    parameter_name character varying(255),
    class_type character varying(250),
    default_value character varying(4000)
);
 $   DROP TABLE public.report_parameter;
       public         dotcmsdbuser    false    3            k           1259    30790    rule_action    TABLE     �   CREATE TABLE public.rule_action (
    id character varying(36) NOT NULL,
    rule_id character varying(36),
    priority integer DEFAULT 0,
    actionlet text NOT NULL,
    mod_date timestamp without time zone
);
    DROP TABLE public.rule_action;
       public         dotcmsdbuser    false    3            l           1259    30804    rule_action_pars    TABLE     �   CREATE TABLE public.rule_action_pars (
    id character varying(36) NOT NULL,
    rule_action_id character varying(36),
    paramkey character varying(255) NOT NULL,
    value text
);
 $   DROP TABLE public.rule_action_pars;
       public         dotcmsdbuser    false    3            i           1259    30762    rule_condition    TABLE     ?  CREATE TABLE public.rule_condition (
    id character varying(36) NOT NULL,
    conditionlet text NOT NULL,
    condition_group character varying(36),
    comparison character varying(36) NOT NULL,
    operator character varying(10) NOT NULL,
    priority integer DEFAULT 0,
    mod_date timestamp without time zone
);
 "   DROP TABLE public.rule_condition;
       public         dotcmsdbuser    false    3            h           1259    30751    rule_condition_group    TABLE     �   CREATE TABLE public.rule_condition_group (
    id character varying(36) NOT NULL,
    rule_id character varying(36),
    operator character varying(10) NOT NULL,
    priority integer DEFAULT 0,
    mod_date timestamp without time zone
);
 (   DROP TABLE public.rule_condition_group;
       public         dotcmsdbuser    false    3            j           1259    30776    rule_condition_value    TABLE     �   CREATE TABLE public.rule_condition_value (
    id character varying(36) NOT NULL,
    condition_id character varying(36),
    paramkey character varying(255) NOT NULL,
    value text,
    priority integer DEFAULT 0
);
 (   DROP TABLE public.rule_condition_value;
       public         dotcmsdbuser    false    3            b           1259    30676 
   schemes_ir    TABLE     �   CREATE TABLE public.schemes_ir (
    name character varying(255),
    local_inode character varying(36) NOT NULL,
    remote_inode character varying(36),
    endpoint_id character varying(36) NOT NULL
);
    DROP TABLE public.schemes_ir;
       public         dotcmsdbuser    false    3            _           1259    30658    sitelic    TABLE     �   CREATE TABLE public.sitelic (
    id character varying(36) NOT NULL,
    serverid character varying(100),
    license text NOT NULL,
    lastping timestamp without time zone NOT NULL
);
    DROP TABLE public.sitelic;
       public         dotcmsdbuser    false    3            W           1259    30542    sitesearch_audit    TABLE     �  CREATE TABLE public.sitesearch_audit (
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
       public         dotcmsdbuser    false    3            �            1259    29348 	   structure    TABLE       CREATE TABLE public.structure (
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
       public         dotcmsdbuser    false    3            a           1259    30671    structures_ir    TABLE     �   CREATE TABLE public.structures_ir (
    velocity_name character varying(255),
    local_inode character varying(36) NOT NULL,
    remote_inode character varying(36),
    endpoint_id character varying(36) NOT NULL
);
 !   DROP TABLE public.structures_ir;
       public         dotcmsdbuser    false    3            2           1259    29931    summary_404_seq    SEQUENCE     x   CREATE SEQUENCE public.summary_404_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.summary_404_seq;
       public       dotcmsdbuser    false    3            5           1259    29937    summary_content_seq    SEQUENCE     |   CREATE SEQUENCE public.summary_content_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.summary_content_seq;
       public       dotcmsdbuser    false    3            6           1259    29939    summary_pages_seq    SEQUENCE     z   CREATE SEQUENCE public.summary_pages_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.summary_pages_seq;
       public       dotcmsdbuser    false    3            8           1259    29943    summary_period_seq    SEQUENCE     {   CREATE SEQUENCE public.summary_period_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.summary_period_seq;
       public       dotcmsdbuser    false    3            7           1259    29941    summary_referer_seq    SEQUENCE     |   CREATE SEQUENCE public.summary_referer_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.summary_referer_seq;
       public       dotcmsdbuser    false    3            (           1259    29911    summary_seq    SEQUENCE     t   CREATE SEQUENCE public.summary_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.summary_seq;
       public       dotcmsdbuser    false    3            /           1259    29925    summary_visits_seq    SEQUENCE     {   CREATE SEQUENCE public.summary_visits_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.summary_visits_seq;
       public       dotcmsdbuser    false    3            m           1259    30818    system_event    TABLE     �   CREATE TABLE public.system_event (
    identifier character varying(36) NOT NULL,
    event_type character varying(50) NOT NULL,
    payload text NOT NULL,
    created bigint NOT NULL
);
     DROP TABLE public.system_event;
       public         dotcmsdbuser    false    3            �            1259    29226    tag    TABLE     !  CREATE TABLE public.tag (
    tag_id character varying(100) NOT NULL,
    tagname character varying(255) NOT NULL,
    host_id character varying(255) DEFAULT 'SYSTEM_HOST'::character varying,
    user_id text,
    persona boolean DEFAULT false,
    mod_date timestamp without time zone
);
    DROP TABLE public.tag;
       public         dotcmsdbuser    false    3            	           1259    29499 	   tag_inode    TABLE     �   CREATE TABLE public.tag_inode (
    tag_id character varying(100) NOT NULL,
    inode character varying(100) NOT NULL,
    field_var_name character varying(255),
    mod_date timestamp without time zone
);
    DROP TABLE public.tag_inode;
       public         dotcmsdbuser    false    3            �            1259    29332    template    TABLE     /  CREATE TABLE public.template (
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
       public         dotcmsdbuser    false    3            %           1259    29702    template_containers    TABLE     �   CREATE TABLE public.template_containers (
    id character varying(36) NOT NULL,
    template_id character varying(36) NOT NULL,
    container_id character varying(36) NOT NULL
);
 '   DROP TABLE public.template_containers;
       public         dotcmsdbuser    false    3                       1259    29442    template_version_info    TABLE     Y  CREATE TABLE public.template_version_info (
    identifier character varying(36) NOT NULL,
    working_inode character varying(36) NOT NULL,
    live_inode character varying(36),
    deleted boolean NOT NULL,
    locked_by character varying(100),
    locked_on timestamp without time zone,
    version_ts timestamp without time zone NOT NULL
);
 )   DROP TABLE public.template_version_info;
       public         dotcmsdbuser    false    3            �            1259    29268 	   trackback    TABLE     '  CREATE TABLE public.trackback (
    id bigint NOT NULL,
    asset_identifier character varying(36),
    title character varying(255),
    excerpt character varying(255),
    url character varying(255),
    blog_name character varying(255),
    track_date timestamp without time zone NOT NULL
);
    DROP TABLE public.trackback;
       public         dotcmsdbuser    false    3            ,           1259    29919    trackback_sequence    SEQUENCE     {   CREATE SEQUENCE public.trackback_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.trackback_sequence;
       public       dotcmsdbuser    false    3            �            1259    29315    tree    TABLE     �   CREATE TABLE public.tree (
    child character varying(36) NOT NULL,
    parent character varying(36) NOT NULL,
    relation_type character varying(64) NOT NULL,
    tree_order integer
);
    DROP TABLE public.tree;
       public         dotcmsdbuser    false    3            �            1259    28978    user_    TABLE     {  CREATE TABLE public.user_ (
    userid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    createdate timestamp without time zone,
    mod_date timestamp without time zone,
    password_ text,
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
    active_ boolean,
    delete_in_progress boolean DEFAULT false,
    delete_date timestamp without time zone
);
    DROP TABLE public.user_;
       public         dotcmsdbuser    false    3            �            1259    29235    user_comments    TABLE     n  CREATE TABLE public.user_comments (
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
       public         dotcmsdbuser    false    3            &           1259    29707    user_filter    TABLE     u  CREATE TABLE public.user_filter (
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
       public         dotcmsdbuser    false    3                       1259    29447    user_preferences    TABLE     �   CREATE TABLE public.user_preferences (
    id bigint NOT NULL,
    user_id character varying(100) NOT NULL,
    preference character varying(255),
    pref_value text
);
 $   DROP TABLE public.user_preferences;
       public         dotcmsdbuser    false    3            )           1259    29913    user_preferences_seq    SEQUENCE     }   CREATE SEQUENCE public.user_preferences_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.user_preferences_seq;
       public       dotcmsdbuser    false    3                       1259    29611 
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
       public         dotcmsdbuser    false    3            <           1259    29951    user_to_delete_seq    SEQUENCE     {   CREATE SEQUENCE public.user_to_delete_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.user_to_delete_seq;
       public       dotcmsdbuser    false    3            �            1259    29327    users_cms_roles    TABLE     �   CREATE TABLE public.users_cms_roles (
    id character varying(36) NOT NULL,
    user_id character varying(100) NOT NULL,
    role_id character varying(36) NOT NULL
);
 #   DROP TABLE public.users_cms_roles;
       public         dotcmsdbuser    false    3                       1259    29463    users_to_delete    TABLE     d   CREATE TABLE public.users_to_delete (
    id bigint NOT NULL,
    user_id character varying(255)
);
 #   DROP TABLE public.users_to_delete;
       public         dotcmsdbuser    false    3            �            1259    28987    usertracker    TABLE     T  CREATE TABLE public.usertracker (
    usertrackerid character varying(100) NOT NULL,
    companyid character varying(100) NOT NULL,
    userid character varying(100) NOT NULL,
    modifieddate timestamp without time zone,
    remoteaddr character varying(100),
    remotehost character varying(100),
    useragent character varying(100)
);
    DROP TABLE public.usertracker;
       public         dotcmsdbuser    false    3            �            1259    28995    usertrackerpath    TABLE     �   CREATE TABLE public.usertrackerpath (
    usertrackerpathid character varying(100) NOT NULL,
    usertrackerid character varying(100) NOT NULL,
    path text NOT NULL,
    pathdate timestamp without time zone NOT NULL
);
 #   DROP TABLE public.usertrackerpath;
       public         dotcmsdbuser    false    3            �            1259    29300    web_form    TABLE     w  CREATE TABLE public.web_form (
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
       public         dotcmsdbuser    false    3            K           1259    30351    workflow_action    TABLE     A  CREATE TABLE public.workflow_action (
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
       public         dotcmsdbuser    false    3            L           1259    30381    workflow_action_class    TABLE     �   CREATE TABLE public.workflow_action_class (
    id character varying(36) NOT NULL,
    action_id character varying(36),
    name character varying(255) NOT NULL,
    my_order integer DEFAULT 0,
    clazz text
);
 )   DROP TABLE public.workflow_action_class;
       public         dotcmsdbuser    false    3            M           1259    30396    workflow_action_class_pars    TABLE     �   CREATE TABLE public.workflow_action_class_pars (
    id character varying(36) NOT NULL,
    workflow_action_class_id character varying(36),
    key character varying(255) NOT NULL,
    value text
);
 .   DROP TABLE public.workflow_action_class_pars;
       public         dotcmsdbuser    false    3            �            1259    29411    workflow_comment    TABLE     �   CREATE TABLE public.workflow_comment (
    id character varying(36) NOT NULL,
    creation_date timestamp without time zone,
    posted_by character varying(255),
    wf_comment text,
    workflowtask_id character varying(36)
);
 $   DROP TABLE public.workflow_comment;
       public         dotcmsdbuser    false    3                       1259    29587    workflow_history    TABLE     >  CREATE TABLE public.workflow_history (
    id character varying(36) NOT NULL,
    creation_date timestamp without time zone,
    made_by character varying(255),
    change_desc text,
    workflowtask_id character varying(36),
    workflow_action_id character varying(36),
    workflow_step_id character varying(36)
);
 $   DROP TABLE public.workflow_history;
       public         dotcmsdbuser    false    3            I           1259    30323    workflow_scheme    TABLE     W  CREATE TABLE public.workflow_scheme (
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
       public         dotcmsdbuser    false    3            N           1259    30410    workflow_scheme_x_structure    TABLE     �   CREATE TABLE public.workflow_scheme_x_structure (
    id character varying(36) NOT NULL,
    scheme_id character varying(36),
    structure_id character varying(36)
);
 /   DROP TABLE public.workflow_scheme_x_structure;
       public         dotcmsdbuser    false    3            J           1259    30336    workflow_step    TABLE     a  CREATE TABLE public.workflow_step (
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
       public         dotcmsdbuser    false    3                       1259    29491    workflow_task    TABLE     �  CREATE TABLE public.workflow_task (
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
       public         dotcmsdbuser    false    3                       1259    29561    workflowtask_files    TABLE     �   CREATE TABLE public.workflowtask_files (
    id character varying(36) NOT NULL,
    workflowtask_id character varying(36) NOT NULL,
    file_inode character varying(36) NOT NULL
);
 &   DROP TABLE public.workflowtask_files;
       public         dotcmsdbuser    false    3            9           1259    29945    workstream_seq    SEQUENCE     w   CREATE SEQUENCE public.workstream_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.workstream_seq;
       public       dotcmsdbuser    false    3            }           2604    30013    dist_journal id    DEFAULT     r   ALTER TABLE ONLY public.dist_journal ALTER COLUMN id SET DEFAULT nextval('public.dist_journal_id_seq'::regclass);
 >   ALTER TABLE public.dist_journal ALTER COLUMN id DROP DEFAULT;
       public       dotcmsdbuser    false    319    320    320            ~           2604    30039    dist_process id    DEFAULT     r   ALTER TABLE ONLY public.dist_process ALTER COLUMN id SET DEFAULT nextval('public.dist_process_id_seq'::regclass);
 >   ALTER TABLE public.dist_process ALTER COLUMN id DROP DEFAULT;
       public       dotcmsdbuser    false    322    323    323                       2604    30051    dist_reindex_journal id    DEFAULT     �   ALTER TABLE ONLY public.dist_reindex_journal ALTER COLUMN id SET DEFAULT nextval('public.dist_reindex_journal_id_seq'::regclass);
 F   ALTER TABLE public.dist_reindex_journal ALTER COLUMN id DROP DEFAULT;
       public       dotcmsdbuser    false    325    324    325            �           2604    30511    publishing_queue id    DEFAULT     z   ALTER TABLE ONLY public.publishing_queue ALTER COLUMN id SET DEFAULT nextval('public.publishing_queue_id_seq'::regclass);
 B   ALTER TABLE public.publishing_queue ALTER COLUMN id DROP DEFAULT;
       public       dotcmsdbuser    false    338    339    339            �           2604    30072    quartz_log id    DEFAULT     n   ALTER TABLE ONLY public.quartz_log ALTER COLUMN id SET DEFAULT nextval('public.quartz_log_id_seq'::regclass);
 <   ALTER TABLE public.quartz_log ALTER COLUMN id DROP DEFAULT;
       public       dotcmsdbuser    false    327    326    327            �           2606    28896    address address_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (addressid);
 >   ALTER TABLE ONLY public.address DROP CONSTRAINT address_pkey;
       public         dotcmsdbuser    false    186    186            �           2606    28904    adminconfig adminconfig_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.adminconfig
    ADD CONSTRAINT adminconfig_pkey PRIMARY KEY (configid);
 F   ALTER TABLE ONLY public.adminconfig DROP CONSTRAINT adminconfig_pkey;
       public         dotcmsdbuser    false    187    187            d           2606    29397 .   analytic_summary_404 analytic_summary_404_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.analytic_summary_404
    ADD CONSTRAINT analytic_summary_404_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.analytic_summary_404 DROP CONSTRAINT analytic_summary_404_pkey;
       public         dotcmsdbuser    false    250    250            C           2606    29347 6   analytic_summary_content analytic_summary_content_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.analytic_summary_content
    ADD CONSTRAINT analytic_summary_content_pkey PRIMARY KEY (id);
 `   ALTER TABLE ONLY public.analytic_summary_content DROP CONSTRAINT analytic_summary_content_pkey;
       public         dotcmsdbuser    false    244    244            �           2606    29225 2   analytic_summary_pages analytic_summary_pages_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.analytic_summary_pages
    ADD CONSTRAINT analytic_summary_pages_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.analytic_summary_pages DROP CONSTRAINT analytic_summary_pages_pkey;
       public         dotcmsdbuser    false    227    227            #           2606    29314 =   analytic_summary_period analytic_summary_period_full_date_key 
   CONSTRAINT     }   ALTER TABLE ONLY public.analytic_summary_period
    ADD CONSTRAINT analytic_summary_period_full_date_key UNIQUE (full_date);
 g   ALTER TABLE ONLY public.analytic_summary_period DROP CONSTRAINT analytic_summary_period_full_date_key;
       public         dotcmsdbuser    false    239    239            %           2606    29312 4   analytic_summary_period analytic_summary_period_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.analytic_summary_period
    ADD CONSTRAINT analytic_summary_period_pkey PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.analytic_summary_period DROP CONSTRAINT analytic_summary_period_pkey;
       public         dotcmsdbuser    false    239    239            4           2606    29324 &   analytic_summary analytic_summary_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.analytic_summary
    ADD CONSTRAINT analytic_summary_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.analytic_summary DROP CONSTRAINT analytic_summary_pkey;
       public         dotcmsdbuser    false    241    241            �           2606    29570 6   analytic_summary_referer analytic_summary_referer_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.analytic_summary_referer
    ADD CONSTRAINT analytic_summary_referer_pkey PRIMARY KEY (id);
 `   ALTER TABLE ONLY public.analytic_summary_referer DROP CONSTRAINT analytic_summary_referer_pkey;
       public         dotcmsdbuser    false    276    276            6           2606    29326 ?   analytic_summary analytic_summary_summary_period_id_host_id_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.analytic_summary
    ADD CONSTRAINT analytic_summary_summary_period_id_host_id_key UNIQUE (summary_period_id, host_id);
 i   ALTER TABLE ONLY public.analytic_summary DROP CONSTRAINT analytic_summary_summary_period_id_host_id_key;
       public         dotcmsdbuser    false    241    241    241            x           2606    29441 4   analytic_summary_visits analytic_summary_visits_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.analytic_summary_visits
    ADD CONSTRAINT analytic_summary_visits_pkey PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.analytic_summary_visits DROP CONSTRAINT analytic_summary_visits_pkey;
       public         dotcmsdbuser    false    256    256            �           2606    29547 <   analytic_summary_workstream analytic_summary_workstream_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.analytic_summary_workstream
    ADD CONSTRAINT analytic_summary_workstream_pkey PRIMARY KEY (id);
 f   ALTER TABLE ONLY public.analytic_summary_workstream DROP CONSTRAINT analytic_summary_workstream_pkey;
       public         dotcmsdbuser    false    272    272            <           2606    30495    broken_link broken_link_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.broken_link
    ADD CONSTRAINT broken_link_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.broken_link DROP CONSTRAINT broken_link_pkey;
       public         dotcmsdbuser    false    337    337            �           2606    29217 (   calendar_reminder calendar_reminder_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.calendar_reminder
    ADD CONSTRAINT calendar_reminder_pkey PRIMARY KEY (user_id, event_id, send_date);
 R   ALTER TABLE ONLY public.calendar_reminder DROP CONSTRAINT calendar_reminder_pkey;
       public         dotcmsdbuser    false    226    226    226    226            �           2606    29560    campaign campaign_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.campaign
    ADD CONSTRAINT campaign_pkey PRIMARY KEY (inode);
 @   ALTER TABLE ONLY public.campaign DROP CONSTRAINT campaign_pkey;
       public         dotcmsdbuser    false    274    274            o           2606    29426    category category_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (inode);
 @   ALTER TABLE ONLY public.category DROP CONSTRAINT category_pkey;
       public         dotcmsdbuser    false    254    254            �           2606    29696    chain chain_key_name_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.chain
    ADD CONSTRAINT chain_key_name_key UNIQUE (key_name);
 B   ALTER TABLE ONLY public.chain DROP CONSTRAINT chain_key_name_key;
       public         dotcmsdbuser    false    291    291            s           2606    29436 .   chain_link_code chain_link_code_class_name_key 
   CONSTRAINT     o   ALTER TABLE ONLY public.chain_link_code
    ADD CONSTRAINT chain_link_code_class_name_key UNIQUE (class_name);
 X   ALTER TABLE ONLY public.chain_link_code DROP CONSTRAINT chain_link_code_class_name_key;
       public         dotcmsdbuser    false    255    255            u           2606    29434 $   chain_link_code chain_link_code_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.chain_link_code
    ADD CONSTRAINT chain_link_code_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.chain_link_code DROP CONSTRAINT chain_link_code_pkey;
       public         dotcmsdbuser    false    255    255            �           2606    29694    chain chain_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.chain
    ADD CONSTRAINT chain_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.chain DROP CONSTRAINT chain_pkey;
       public         dotcmsdbuser    false    291    291            �           2606    29628 0   chain_state_parameter chain_state_parameter_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.chain_state_parameter
    ADD CONSTRAINT chain_state_parameter_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.chain_state_parameter DROP CONSTRAINT chain_state_parameter_pkey;
       public         dotcmsdbuser    false    283    283            �           2606    29539    chain_state chain_state_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.chain_state
    ADD CONSTRAINT chain_state_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.chain_state DROP CONSTRAINT chain_state_pkey;
       public         dotcmsdbuser    false    271    271            �           2606    29513 *   challenge_question challenge_question_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public.challenge_question
    ADD CONSTRAINT challenge_question_pkey PRIMARY KEY (cquestionid);
 T   ALTER TABLE ONLY public.challenge_question DROP CONSTRAINT challenge_question_pkey;
       public         dotcmsdbuser    false    267    267            �           2606    29508    click click_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.click
    ADD CONSTRAINT click_pkey PRIMARY KEY (inode);
 :   ALTER TABLE ONLY public.click DROP CONSTRAINT click_pkey;
       public         dotcmsdbuser    false    266    266            �           2606    29660 $   clickstream_404 clickstream_404_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.clickstream_404
    ADD CONSTRAINT clickstream_404_pkey PRIMARY KEY (clickstream_404_id);
 N   ALTER TABLE ONLY public.clickstream_404 DROP CONSTRAINT clickstream_404_pkey;
       public         dotcmsdbuser    false    287    287            �           2606    29485    clickstream clickstream_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.clickstream
    ADD CONSTRAINT clickstream_pkey PRIMARY KEY (clickstream_id);
 F   ALTER TABLE ONLY public.clickstream DROP CONSTRAINT clickstream_pkey;
       public         dotcmsdbuser    false    262    262            �           2606    29526 ,   clickstream_request clickstream_request_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY public.clickstream_request
    ADD CONSTRAINT clickstream_request_pkey PRIMARY KEY (clickstream_request_id);
 V   ALTER TABLE ONLY public.clickstream_request DROP CONSTRAINT clickstream_request_pkey;
       public         dotcmsdbuser    false    269    269            k           2606    30742 0   cluster_server_action cluster_server_action_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public.cluster_server_action
    ADD CONSTRAINT cluster_server_action_pkey PRIMARY KEY (server_action_id);
 Z   ALTER TABLE ONLY public.cluster_server_action DROP CONSTRAINT cluster_server_action_pkey;
       public         dotcmsdbuser    false    358    358            V           2606    30597 "   cluster_server cluster_server_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.cluster_server
    ADD CONSTRAINT cluster_server_pkey PRIMARY KEY (server_id);
 L   ALTER TABLE ONLY public.cluster_server DROP CONSTRAINT cluster_server_pkey;
       public         dotcmsdbuser    false    348    348            X           2606    30607 0   cluster_server_uptime cluster_server_uptime_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.cluster_server_uptime
    ADD CONSTRAINT cluster_server_uptime_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.cluster_server_uptime DROP CONSTRAINT cluster_server_uptime_pkey;
       public         dotcmsdbuser    false    349    349            �           2606    30097 !   cms_layout cms_layout_name_parent 
   CONSTRAINT     c   ALTER TABLE ONLY public.cms_layout
    ADD CONSTRAINT cms_layout_name_parent UNIQUE (layout_name);
 K   ALTER TABLE ONLY public.cms_layout DROP CONSTRAINT cms_layout_name_parent;
       public         dotcmsdbuser    false    288    288            �           2606    29668    cms_layout cms_layout_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.cms_layout
    ADD CONSTRAINT cms_layout_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.cms_layout DROP CONSTRAINT cms_layout_pkey;
       public         dotcmsdbuser    false    288    288            g           2606    30101 1   cms_layouts_portlets cms_layouts_portlets_parent1 
   CONSTRAINT     }   ALTER TABLE ONLY public.cms_layouts_portlets
    ADD CONSTRAINT cms_layouts_portlets_parent1 UNIQUE (layout_id, portlet_id);
 [   ALTER TABLE ONLY public.cms_layouts_portlets DROP CONSTRAINT cms_layouts_portlets_parent1;
       public         dotcmsdbuser    false    251    251    251            i           2606    29402 .   cms_layouts_portlets cms_layouts_portlets_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.cms_layouts_portlets
    ADD CONSTRAINT cms_layouts_portlets_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.cms_layouts_portlets DROP CONSTRAINT cms_layouts_portlets_pkey;
       public         dotcmsdbuser    false    251    251            L           2606    30078    cms_role cms_role_name_db_fqn 
   CONSTRAINT     Z   ALTER TABLE ONLY public.cms_role
    ADD CONSTRAINT cms_role_name_db_fqn UNIQUE (db_fqn);
 G   ALTER TABLE ONLY public.cms_role DROP CONSTRAINT cms_role_name_db_fqn;
       public         dotcmsdbuser    false    246    246            N           2606    30076    cms_role cms_role_name_role_key 
   CONSTRAINT     ^   ALTER TABLE ONLY public.cms_role
    ADD CONSTRAINT cms_role_name_role_key UNIQUE (role_key);
 I   ALTER TABLE ONLY public.cms_role DROP CONSTRAINT cms_role_name_role_key;
       public         dotcmsdbuser    false    246    246            P           2606    29363    cms_role cms_role_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.cms_role
    ADD CONSTRAINT cms_role_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.cms_role DROP CONSTRAINT cms_role_pkey;
       public         dotcmsdbuser    false    246    246            i           2606    30704    cms_roles_ir cms_roles_ir_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.cms_roles_ir
    ADD CONSTRAINT cms_roles_ir_pkey PRIMARY KEY (local_role_id, endpoint_id);
 H   ALTER TABLE ONLY public.cms_roles_ir DROP CONSTRAINT cms_roles_ir_pkey;
       public         dotcmsdbuser    false    357    357    357            �           2606    29586     communication communication_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.communication
    ADD CONSTRAINT communication_pkey PRIMARY KEY (inode);
 J   ALTER TABLE ONLY public.communication DROP CONSTRAINT communication_pkey;
       public         dotcmsdbuser    false    278    278            �           2606    28912    company company_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pkey PRIMARY KEY (companyid);
 >   ALTER TABLE ONLY public.company DROP CONSTRAINT company_pkey;
       public         dotcmsdbuser    false    188    188            R           2606    29371 .   container_structures container_structures_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.container_structures
    ADD CONSTRAINT container_structures_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.container_structures DROP CONSTRAINT container_structures_pkey;
       public         dotcmsdbuser    false    247    247                       2606    29267 2   container_version_info container_version_info_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.container_version_info
    ADD CONSTRAINT container_version_info_pkey PRIMARY KEY (identifier);
 \   ALTER TABLE ONLY public.container_version_info DROP CONSTRAINT container_version_info_pkey;
       public         dotcmsdbuser    false    233    233            �           2606    29534 "   content_rating content_rating_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.content_rating
    ADD CONSTRAINT content_rating_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.content_rating DROP CONSTRAINT content_rating_pkey;
       public         dotcmsdbuser    false    270    270            _           2606    29389    contentlet contentlet_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.contentlet
    ADD CONSTRAINT contentlet_pkey PRIMARY KEY (inode);
 D   ALTER TABLE ONLY public.contentlet DROP CONSTRAINT contentlet_pkey;
       public         dotcmsdbuser    false    249    249                       2606    29254 4   contentlet_version_info contentlet_version_info_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.contentlet_version_info
    ADD CONSTRAINT contentlet_version_info_pkey PRIMARY KEY (identifier, lang);
 ^   ALTER TABLE ONLY public.contentlet_version_info DROP CONSTRAINT contentlet_version_info_pkey;
       public         dotcmsdbuser    false    231    231    231            �           2606    28917    counter counter_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.counter
    ADD CONSTRAINT counter_pkey PRIMARY KEY (name);
 >   ALTER TABLE ONLY public.counter DROP CONSTRAINT counter_pkey;
       public         dotcmsdbuser    false    189    189            �           2606    29552 :   dashboard_user_preferences dashboard_user_preferences_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.dashboard_user_preferences
    ADD CONSTRAINT dashboard_user_preferences_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.dashboard_user_preferences DROP CONSTRAINT dashboard_user_preferences_pkey;
       public         dotcmsdbuser    false    273    273            �           2606    28888    db_version db_version_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.db_version
    ADD CONSTRAINT db_version_pkey PRIMARY KEY (db_version);
 D   ALTER TABLE ONLY public.db_version DROP CONSTRAINT db_version_pkey;
       public         dotcmsdbuser    false    185    185                       2606    30020 -   dist_journal dist_journal_object_to_index_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.dist_journal
    ADD CONSTRAINT dist_journal_object_to_index_key UNIQUE (object_to_index, serverid, journal_type);
 W   ALTER TABLE ONLY public.dist_journal DROP CONSTRAINT dist_journal_object_to_index_key;
       public         dotcmsdbuser    false    320    320    320    320                       2606    30018    dist_journal dist_journal_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.dist_journal
    ADD CONSTRAINT dist_journal_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.dist_journal DROP CONSTRAINT dist_journal_pkey;
       public         dotcmsdbuser    false    320    320                       2606    30044    dist_process dist_process_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.dist_process
    ADD CONSTRAINT dist_process_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.dist_process DROP CONSTRAINT dist_process_pkey;
       public         dotcmsdbuser    false    323    323                       2606    30058 .   dist_reindex_journal dist_reindex_journal_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.dist_reindex_journal
    ADD CONSTRAINT dist_reindex_journal_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.dist_reindex_journal DROP CONSTRAINT dist_reindex_journal_pkey;
       public         dotcmsdbuser    false    325    325            T           2606    30589    dot_cluster dot_cluster_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.dot_cluster
    ADD CONSTRAINT dot_cluster_pkey PRIMARY KEY (cluster_id);
 F   ALTER TABLE ONLY public.dot_cluster DROP CONSTRAINT dot_cluster_pkey;
       public         dotcmsdbuser    false    347    347            �           2606    29578 "   dot_containers dot_containers_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.dot_containers
    ADD CONSTRAINT dot_containers_pkey PRIMARY KEY (inode);
 L   ALTER TABLE ONLY public.dot_containers DROP CONSTRAINT dot_containers_pkey;
       public         dotcmsdbuser    false    277    277            m           2606    30750    dot_rule dot_rule_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.dot_rule
    ADD CONSTRAINT dot_rule_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.dot_rule DROP CONSTRAINT dot_rule_pkey;
       public         dotcmsdbuser    false    359    359            �           2606    29636    field field_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.field
    ADD CONSTRAINT field_pkey PRIMARY KEY (inode);
 :   ALTER TABLE ONLY public.field DROP CONSTRAINT field_pkey;
       public         dotcmsdbuser    false    284    284            �           2606    29676 "   field_variable field_variable_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.field_variable
    ADD CONSTRAINT field_variable_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.field_variable DROP CONSTRAINT field_variable_pkey;
       public         dotcmsdbuser    false    289    289            g           2606    30696     fileassets_ir fileassets_ir_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.fileassets_ir
    ADD CONSTRAINT fileassets_ir_pkey PRIMARY KEY (local_working_inode, language_id, endpoint_id);
 J   ALTER TABLE ONLY public.fileassets_ir DROP CONSTRAINT fileassets_ir_pkey;
       public         dotcmsdbuser    false    356    356    356    356                       2606    29262    fixes_audit fixes_audit_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.fixes_audit
    ADD CONSTRAINT fixes_audit_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.fixes_audit DROP CONSTRAINT fixes_audit_pkey;
       public         dotcmsdbuser    false    232    232            �           2606    29652    folder folder_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.folder
    ADD CONSTRAINT folder_pkey PRIMARY KEY (inode);
 <   ALTER TABLE ONLY public.folder DROP CONSTRAINT folder_pkey;
       public         dotcmsdbuser    false    286    286            _           2606    30670    folders_ir folders_ir_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.folders_ir
    ADD CONSTRAINT folders_ir_pkey PRIMARY KEY (local_inode, endpoint_id);
 D   ALTER TABLE ONLY public.folders_ir DROP CONSTRAINT folders_ir_pkey;
       public         dotcmsdbuser    false    352    352    352            �           2606    29602     host_variable host_variable_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.host_variable
    ADD CONSTRAINT host_variable_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.host_variable DROP CONSTRAINT host_variable_pkey;
       public         dotcmsdbuser    false    280    280            e           2606    30688    htmlpages_ir htmlpages_ir_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.htmlpages_ir
    ADD CONSTRAINT htmlpages_ir_pkey PRIMARY KEY (local_working_inode, language_id, endpoint_id);
 H   ALTER TABLE ONLY public.htmlpages_ir DROP CONSTRAINT htmlpages_ir_pkey;
       public         dotcmsdbuser    false    355    355    355    355            �           2606    29477 ;   identifier identifier_parent_path_asset_name_host_inode_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.identifier
    ADD CONSTRAINT identifier_parent_path_asset_name_host_inode_key UNIQUE (parent_path, asset_name, host_inode);
 e   ALTER TABLE ONLY public.identifier DROP CONSTRAINT identifier_parent_path_asset_name_host_inode_key;
       public         dotcmsdbuser    false    261    261    261    261            �           2606    29475    identifier identifier_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.identifier
    ADD CONSTRAINT identifier_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.identifier DROP CONSTRAINT identifier_pkey;
       public         dotcmsdbuser    false    261    261            �           2606    28925    image image_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_pkey PRIMARY KEY (imageid);
 :   ALTER TABLE ONLY public.image DROP CONSTRAINT image_pkey;
       public         dotcmsdbuser    false    190    190            !           2606    30156    import_audit import_audit_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.import_audit
    ADD CONSTRAINT import_audit_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.import_audit DROP CONSTRAINT import_audit_pkey;
       public         dotcmsdbuser    false    328    328            6           2606    30481     indicies indicies_index_type_key 
   CONSTRAINT     a   ALTER TABLE ONLY public.indicies
    ADD CONSTRAINT indicies_index_type_key UNIQUE (index_type);
 J   ALTER TABLE ONLY public.indicies DROP CONSTRAINT indicies_index_type_key;
       public         dotcmsdbuser    false    335    335            8           2606    30479    indicies indicies_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.indicies
    ADD CONSTRAINT indicies_pkey PRIMARY KEY (index_name);
 @   ALTER TABLE ONLY public.indicies DROP CONSTRAINT indicies_pkey;
       public         dotcmsdbuser    false    335    335                       2606    29719    inode inode_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.inode
    ADD CONSTRAINT inode_pkey PRIMARY KEY (inode);
 :   ALTER TABLE ONLY public.inode DROP CONSTRAINT inode_pkey;
       public         dotcmsdbuser    false    295    295            �           2606    29462    language language_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.language
    ADD CONSTRAINT language_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.language DROP CONSTRAINT language_pkey;
       public         dotcmsdbuser    false    259    259            �           2606    30118 +   layouts_cms_roles layouts_cms_roles_parent1 
   CONSTRAINT     t   ALTER TABLE ONLY public.layouts_cms_roles
    ADD CONSTRAINT layouts_cms_roles_parent1 UNIQUE (role_id, layout_id);
 U   ALTER TABLE ONLY public.layouts_cms_roles DROP CONSTRAINT layouts_cms_roles_parent1;
       public         dotcmsdbuser    false    268    268    268            �           2606    29518 (   layouts_cms_roles layouts_cms_roles_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.layouts_cms_roles
    ADD CONSTRAINT layouts_cms_roles_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.layouts_cms_roles DROP CONSTRAINT layouts_cms_roles_pkey;
       public         dotcmsdbuser    false    268    268                       2606    29701 (   link_version_info link_version_info_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.link_version_info
    ADD CONSTRAINT link_version_info_pkey PRIMARY KEY (identifier);
 R   ALTER TABLE ONLY public.link_version_info DROP CONSTRAINT link_version_info_pkey;
       public         dotcmsdbuser    false    292    292            �           2606    29610    links links_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_pkey PRIMARY KEY (inode);
 :   ALTER TABLE ONLY public.links DROP CONSTRAINT links_pkey;
       public         dotcmsdbuser    false    281    281            :           2606    30486    log_mapper log_mapper_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.log_mapper
    ADD CONSTRAINT log_mapper_pkey PRIMARY KEY (log_name);
 D   ALTER TABLE ONLY public.log_mapper DROP CONSTRAINT log_mapper_pkey;
       public         dotcmsdbuser    false    336    336                       2606    29291    mailing_list mailing_list_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.mailing_list
    ADD CONSTRAINT mailing_list_pkey PRIMARY KEY (inode);
 H   ALTER TABLE ONLY public.mailing_list DROP CONSTRAINT mailing_list_pkey;
       public         dotcmsdbuser    false    236    236            �           2606    29490    multi_tree multi_tree_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.multi_tree
    ADD CONSTRAINT multi_tree_pkey PRIMARY KEY (child, parent1, parent2);
 D   ALTER TABLE ONLY public.multi_tree DROP CONSTRAINT multi_tree_pkey;
       public         dotcmsdbuser    false    263    263    263    263            �           2606    28930 $   passwordtracker passwordtracker_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public.passwordtracker
    ADD CONSTRAINT passwordtracker_pkey PRIMARY KEY (passwordtrackerid);
 N   ALTER TABLE ONLY public.passwordtracker DROP CONSTRAINT passwordtracker_pkey;
       public         dotcmsdbuser    false    191    191            X           2606    29381 9   permission permission_permission_type_inode_id_roleid_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.permission
    ADD CONSTRAINT permission_permission_type_inode_id_roleid_key UNIQUE (permission_type, inode_id, roleid);
 c   ALTER TABLE ONLY public.permission DROP CONSTRAINT permission_permission_type_inode_id_roleid_key;
       public         dotcmsdbuser    false    248    248    248    248            Z           2606    29379    permission permission_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.permission
    ADD CONSTRAINT permission_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.permission DROP CONSTRAINT permission_pkey;
       public         dotcmsdbuser    false    248    248                       2606    29249 6   permission_reference permission_reference_asset_id_key 
   CONSTRAINT     u   ALTER TABLE ONLY public.permission_reference
    ADD CONSTRAINT permission_reference_asset_id_key UNIQUE (asset_id);
 `   ALTER TABLE ONLY public.permission_reference DROP CONSTRAINT permission_reference_asset_id_key;
       public         dotcmsdbuser    false    230    230                       2606    29247 .   permission_reference permission_reference_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.permission_reference
    ADD CONSTRAINT permission_reference_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.permission_reference DROP CONSTRAINT permission_reference_pkey;
       public         dotcmsdbuser    false    230    230            [           2606    30640    notification pk_notification 
   CONSTRAINT     i   ALTER TABLE ONLY public.notification
    ADD CONSTRAINT pk_notification PRIMARY KEY (group_id, user_id);
 F   ALTER TABLE ONLY public.notification DROP CONSTRAINT pk_notification;
       public         dotcmsdbuser    false    350    350    350            {           2606    30825    system_event pk_system_event 
   CONSTRAINT     b   ALTER TABLE ONLY public.system_event
    ADD CONSTRAINT pk_system_event PRIMARY KEY (identifier);
 F   ALTER TABLE ONLY public.system_event DROP CONSTRAINT pk_system_event;
       public         dotcmsdbuser    false    365    365                       2606    29283    plugin plugin_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.plugin
    ADD CONSTRAINT plugin_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.plugin DROP CONSTRAINT plugin_pkey;
       public         dotcmsdbuser    false    235    235                       2606    30028 $   plugin_property plugin_property_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.plugin_property
    ADD CONSTRAINT plugin_property_pkey PRIMARY KEY (plugin_id, propkey);
 N   ALTER TABLE ONLY public.plugin_property DROP CONSTRAINT plugin_property_pkey;
       public         dotcmsdbuser    false    321    321    321            �           2606    28938    pollschoice pollschoice_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.pollschoice
    ADD CONSTRAINT pollschoice_pkey PRIMARY KEY (choiceid, questionid);
 F   ALTER TABLE ONLY public.pollschoice DROP CONSTRAINT pollschoice_pkey;
       public         dotcmsdbuser    false    192    192    192            �           2606    28943    pollsdisplay pollsdisplay_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public.pollsdisplay
    ADD CONSTRAINT pollsdisplay_pkey PRIMARY KEY (layoutid, userid, portletid);
 H   ALTER TABLE ONLY public.pollsdisplay DROP CONSTRAINT pollsdisplay_pkey;
       public         dotcmsdbuser    false    193    193    193    193            �           2606    28951     pollsquestion pollsquestion_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.pollsquestion
    ADD CONSTRAINT pollsquestion_pkey PRIMARY KEY (questionid);
 J   ALTER TABLE ONLY public.pollsquestion DROP CONSTRAINT pollsquestion_pkey;
       public         dotcmsdbuser    false    194    194            �           2606    28956    pollsvote pollsvote_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.pollsvote
    ADD CONSTRAINT pollsvote_pkey PRIMARY KEY (questionid, userid);
 B   ALTER TABLE ONLY public.pollsvote DROP CONSTRAINT pollsvote_pkey;
       public         dotcmsdbuser    false    195    195    195            �           2606    28964    portlet portlet_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.portlet
    ADD CONSTRAINT portlet_pkey PRIMARY KEY (portletid, groupid, companyid);
 >   ALTER TABLE ONLY public.portlet DROP CONSTRAINT portlet_pkey;
       public         dotcmsdbuser    false    196    196    196    196            �           2606    30099    portlet portlet_role_key 
   CONSTRAINT     X   ALTER TABLE ONLY public.portlet
    ADD CONSTRAINT portlet_role_key UNIQUE (portletid);
 B   ALTER TABLE ONLY public.portlet DROP CONSTRAINT portlet_role_key;
       public         dotcmsdbuser    false    196    196            �           2606    28972 *   portletpreferences portletpreferences_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.portletpreferences
    ADD CONSTRAINT portletpreferences_pkey PRIMARY KEY (portletid, userid, layoutid);
 T   ALTER TABLE ONLY public.portletpreferences DROP CONSTRAINT portletpreferences_pkey;
       public         dotcmsdbuser    false    197    197    197    197            O           2606    30564 @   publishing_bundle_environment publishing_bundle_environment_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY public.publishing_bundle_environment
    ADD CONSTRAINT publishing_bundle_environment_pkey PRIMARY KEY (id);
 j   ALTER TABLE ONLY public.publishing_bundle_environment DROP CONSTRAINT publishing_bundle_environment_pkey;
       public         dotcmsdbuser    false    345    345            M           2606    30554 (   publishing_bundle publishing_bundle_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.publishing_bundle
    ADD CONSTRAINT publishing_bundle_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.publishing_bundle DROP CONSTRAINT publishing_bundle_pkey;
       public         dotcmsdbuser    false    344    344            C           2606    30532 .   publishing_end_point publishing_end_point_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.publishing_end_point
    ADD CONSTRAINT publishing_end_point_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.publishing_end_point DROP CONSTRAINT publishing_end_point_pkey;
       public         dotcmsdbuser    false    341    341            E           2606    30534 9   publishing_end_point publishing_end_point_server_name_key 
   CONSTRAINT     {   ALTER TABLE ONLY public.publishing_end_point
    ADD CONSTRAINT publishing_end_point_server_name_key UNIQUE (server_name);
 c   ALTER TABLE ONLY public.publishing_end_point DROP CONSTRAINT publishing_end_point_server_name_key;
       public         dotcmsdbuser    false    341    341            G           2606    30541 6   publishing_environment publishing_environment_name_key 
   CONSTRAINT     q   ALTER TABLE ONLY public.publishing_environment
    ADD CONSTRAINT publishing_environment_name_key UNIQUE (name);
 `   ALTER TABLE ONLY public.publishing_environment DROP CONSTRAINT publishing_environment_name_key;
       public         dotcmsdbuser    false    342    342            I           2606    30539 2   publishing_environment publishing_environment_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.publishing_environment
    ADD CONSTRAINT publishing_environment_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.publishing_environment DROP CONSTRAINT publishing_environment_pkey;
       public         dotcmsdbuser    false    342    342            A           2606    30524 2   publishing_queue_audit publishing_queue_audit_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public.publishing_queue_audit
    ADD CONSTRAINT publishing_queue_audit_pkey PRIMARY KEY (bundle_id);
 \   ALTER TABLE ONLY public.publishing_queue_audit DROP CONSTRAINT publishing_queue_audit_pkey;
       public         dotcmsdbuser    false    340    340            >           2606    30516 &   publishing_queue publishing_queue_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.publishing_queue
    ADD CONSTRAINT publishing_queue_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.publishing_queue DROP CONSTRAINT publishing_queue_pkey;
       public         dotcmsdbuser    false    339    339            �           2606    29061 *   qrtz_blob_triggers qrtz_blob_triggers_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_blob_triggers
    ADD CONSTRAINT qrtz_blob_triggers_pkey PRIMARY KEY (trigger_name, trigger_group);
 T   ALTER TABLE ONLY public.qrtz_blob_triggers DROP CONSTRAINT qrtz_blob_triggers_pkey;
       public         dotcmsdbuser    false    207    207    207            �           2606    29084 "   qrtz_calendars qrtz_calendars_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.qrtz_calendars
    ADD CONSTRAINT qrtz_calendars_pkey PRIMARY KEY (calendar_name);
 L   ALTER TABLE ONLY public.qrtz_calendars DROP CONSTRAINT qrtz_calendars_pkey;
       public         dotcmsdbuser    false    209    209            �           2606    29048 *   qrtz_cron_triggers qrtz_cron_triggers_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_cron_triggers
    ADD CONSTRAINT qrtz_cron_triggers_pkey PRIMARY KEY (trigger_name, trigger_group);
 T   ALTER TABLE ONLY public.qrtz_cron_triggers DROP CONSTRAINT qrtz_cron_triggers_pkey;
       public         dotcmsdbuser    false    206    206    206            �           2606    29166 4   qrtz_excl_blob_triggers qrtz_excl_blob_triggers_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_blob_triggers
    ADD CONSTRAINT qrtz_excl_blob_triggers_pkey PRIMARY KEY (trigger_name, trigger_group);
 ^   ALTER TABLE ONLY public.qrtz_excl_blob_triggers DROP CONSTRAINT qrtz_excl_blob_triggers_pkey;
       public         dotcmsdbuser    false    219    219    219            �           2606    29189 ,   qrtz_excl_calendars qrtz_excl_calendars_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public.qrtz_excl_calendars
    ADD CONSTRAINT qrtz_excl_calendars_pkey PRIMARY KEY (calendar_name);
 V   ALTER TABLE ONLY public.qrtz_excl_calendars DROP CONSTRAINT qrtz_excl_calendars_pkey;
       public         dotcmsdbuser    false    221    221            �           2606    29153 4   qrtz_excl_cron_triggers qrtz_excl_cron_triggers_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_cron_triggers
    ADD CONSTRAINT qrtz_excl_cron_triggers_pkey PRIMARY KEY (trigger_name, trigger_group);
 ^   ALTER TABLE ONLY public.qrtz_excl_cron_triggers DROP CONSTRAINT qrtz_excl_cron_triggers_pkey;
       public         dotcmsdbuser    false    218    218    218            �           2606    29202 6   qrtz_excl_fired_triggers qrtz_excl_fired_triggers_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.qrtz_excl_fired_triggers
    ADD CONSTRAINT qrtz_excl_fired_triggers_pkey PRIMARY KEY (entry_id);
 `   ALTER TABLE ONLY public.qrtz_excl_fired_triggers DROP CONSTRAINT qrtz_excl_fired_triggers_pkey;
       public         dotcmsdbuser    false    223    223            �           2606    29115 0   qrtz_excl_job_details qrtz_excl_job_details_pkey 
   CONSTRAINT        ALTER TABLE ONLY public.qrtz_excl_job_details
    ADD CONSTRAINT qrtz_excl_job_details_pkey PRIMARY KEY (job_name, job_group);
 Z   ALTER TABLE ONLY public.qrtz_excl_job_details DROP CONSTRAINT qrtz_excl_job_details_pkey;
       public         dotcmsdbuser    false    214    214    214            �           2606    29120 4   qrtz_excl_job_listeners qrtz_excl_job_listeners_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_job_listeners
    ADD CONSTRAINT qrtz_excl_job_listeners_pkey PRIMARY KEY (job_name, job_group, job_listener);
 ^   ALTER TABLE ONLY public.qrtz_excl_job_listeners DROP CONSTRAINT qrtz_excl_job_listeners_pkey;
       public         dotcmsdbuser    false    215    215    215    215            �           2606    29212 $   qrtz_excl_locks qrtz_excl_locks_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.qrtz_excl_locks
    ADD CONSTRAINT qrtz_excl_locks_pkey PRIMARY KEY (lock_name);
 N   ALTER TABLE ONLY public.qrtz_excl_locks DROP CONSTRAINT qrtz_excl_locks_pkey;
       public         dotcmsdbuser    false    225    225            �           2606    29194 @   qrtz_excl_paused_trigger_grps qrtz_excl_paused_trigger_grps_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_paused_trigger_grps
    ADD CONSTRAINT qrtz_excl_paused_trigger_grps_pkey PRIMARY KEY (trigger_group);
 j   ALTER TABLE ONLY public.qrtz_excl_paused_trigger_grps DROP CONSTRAINT qrtz_excl_paused_trigger_grps_pkey;
       public         dotcmsdbuser    false    222    222            �           2606    29207 8   qrtz_excl_scheduler_state qrtz_excl_scheduler_state_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_scheduler_state
    ADD CONSTRAINT qrtz_excl_scheduler_state_pkey PRIMARY KEY (instance_name);
 b   ALTER TABLE ONLY public.qrtz_excl_scheduler_state DROP CONSTRAINT qrtz_excl_scheduler_state_pkey;
       public         dotcmsdbuser    false    224    224            �           2606    29143 8   qrtz_excl_simple_triggers qrtz_excl_simple_triggers_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_simple_triggers
    ADD CONSTRAINT qrtz_excl_simple_triggers_pkey PRIMARY KEY (trigger_name, trigger_group);
 b   ALTER TABLE ONLY public.qrtz_excl_simple_triggers DROP CONSTRAINT qrtz_excl_simple_triggers_pkey;
       public         dotcmsdbuser    false    217    217    217            �           2606    29176 <   qrtz_excl_trigger_listeners qrtz_excl_trigger_listeners_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_trigger_listeners
    ADD CONSTRAINT qrtz_excl_trigger_listeners_pkey PRIMARY KEY (trigger_name, trigger_group, trigger_listener);
 f   ALTER TABLE ONLY public.qrtz_excl_trigger_listeners DROP CONSTRAINT qrtz_excl_trigger_listeners_pkey;
       public         dotcmsdbuser    false    220    220    220    220            �           2606    29133 *   qrtz_excl_triggers qrtz_excl_triggers_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_triggers
    ADD CONSTRAINT qrtz_excl_triggers_pkey PRIMARY KEY (trigger_name, trigger_group);
 T   ALTER TABLE ONLY public.qrtz_excl_triggers DROP CONSTRAINT qrtz_excl_triggers_pkey;
       public         dotcmsdbuser    false    216    216    216            �           2606    29097 ,   qrtz_fired_triggers qrtz_fired_triggers_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.qrtz_fired_triggers
    ADD CONSTRAINT qrtz_fired_triggers_pkey PRIMARY KEY (entry_id);
 V   ALTER TABLE ONLY public.qrtz_fired_triggers DROP CONSTRAINT qrtz_fired_triggers_pkey;
       public         dotcmsdbuser    false    211    211            �           2606    29010 &   qrtz_job_details qrtz_job_details_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public.qrtz_job_details
    ADD CONSTRAINT qrtz_job_details_pkey PRIMARY KEY (job_name, job_group);
 P   ALTER TABLE ONLY public.qrtz_job_details DROP CONSTRAINT qrtz_job_details_pkey;
       public         dotcmsdbuser    false    202    202    202            �           2606    29015 *   qrtz_job_listeners qrtz_job_listeners_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_job_listeners
    ADD CONSTRAINT qrtz_job_listeners_pkey PRIMARY KEY (job_name, job_group, job_listener);
 T   ALTER TABLE ONLY public.qrtz_job_listeners DROP CONSTRAINT qrtz_job_listeners_pkey;
       public         dotcmsdbuser    false    203    203    203    203            �           2606    29107    qrtz_locks qrtz_locks_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.qrtz_locks
    ADD CONSTRAINT qrtz_locks_pkey PRIMARY KEY (lock_name);
 D   ALTER TABLE ONLY public.qrtz_locks DROP CONSTRAINT qrtz_locks_pkey;
       public         dotcmsdbuser    false    213    213            �           2606    29089 6   qrtz_paused_trigger_grps qrtz_paused_trigger_grps_pkey 
   CONSTRAINT        ALTER TABLE ONLY public.qrtz_paused_trigger_grps
    ADD CONSTRAINT qrtz_paused_trigger_grps_pkey PRIMARY KEY (trigger_group);
 `   ALTER TABLE ONLY public.qrtz_paused_trigger_grps DROP CONSTRAINT qrtz_paused_trigger_grps_pkey;
       public         dotcmsdbuser    false    210    210            �           2606    29102 .   qrtz_scheduler_state qrtz_scheduler_state_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public.qrtz_scheduler_state
    ADD CONSTRAINT qrtz_scheduler_state_pkey PRIMARY KEY (instance_name);
 X   ALTER TABLE ONLY public.qrtz_scheduler_state DROP CONSTRAINT qrtz_scheduler_state_pkey;
       public         dotcmsdbuser    false    212    212            �           2606    29038 .   qrtz_simple_triggers qrtz_simple_triggers_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_simple_triggers
    ADD CONSTRAINT qrtz_simple_triggers_pkey PRIMARY KEY (trigger_name, trigger_group);
 X   ALTER TABLE ONLY public.qrtz_simple_triggers DROP CONSTRAINT qrtz_simple_triggers_pkey;
       public         dotcmsdbuser    false    205    205    205            �           2606    29071 2   qrtz_trigger_listeners qrtz_trigger_listeners_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_trigger_listeners
    ADD CONSTRAINT qrtz_trigger_listeners_pkey PRIMARY KEY (trigger_name, trigger_group, trigger_listener);
 \   ALTER TABLE ONLY public.qrtz_trigger_listeners DROP CONSTRAINT qrtz_trigger_listeners_pkey;
       public         dotcmsdbuser    false    208    208    208    208            �           2606    29028     qrtz_triggers qrtz_triggers_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public.qrtz_triggers
    ADD CONSTRAINT qrtz_triggers_pkey PRIMARY KEY (trigger_name, trigger_group);
 J   ALTER TABLE ONLY public.qrtz_triggers DROP CONSTRAINT qrtz_triggers_pkey;
       public         dotcmsdbuser    false    204    204    204                       2606    30074    quartz_log quartz_log_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.quartz_log
    ADD CONSTRAINT quartz_log_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.quartz_log DROP CONSTRAINT quartz_log_pkey;
       public         dotcmsdbuser    false    327    327                       2606    29299    recipient recipient_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.recipient
    ADD CONSTRAINT recipient_pkey PRIMARY KEY (inode);
 B   ALTER TABLE ONLY public.recipient DROP CONSTRAINT recipient_pkey;
       public         dotcmsdbuser    false    237    237            �           2606    29644    relationship relationship_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.relationship
    ADD CONSTRAINT relationship_pkey PRIMARY KEY (inode);
 H   ALTER TABLE ONLY public.relationship DROP CONSTRAINT relationship_pkey;
       public         dotcmsdbuser    false    285    285            �           2606    28977    release_ release__pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.release_
    ADD CONSTRAINT release__pkey PRIMARY KEY (releaseid);
 @   ALTER TABLE ONLY public.release_ DROP CONSTRAINT release__pkey;
       public         dotcmsdbuser    false    198    198            k           2606    29410    report_asset report_asset_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.report_asset
    ADD CONSTRAINT report_asset_pkey PRIMARY KEY (inode);
 H   ALTER TABLE ONLY public.report_asset DROP CONSTRAINT report_asset_pkey;
       public         dotcmsdbuser    false    252    252            �           2606    29684 &   report_parameter report_parameter_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.report_parameter
    ADD CONSTRAINT report_parameter_pkey PRIMARY KEY (inode);
 P   ALTER TABLE ONLY public.report_parameter DROP CONSTRAINT report_parameter_pkey;
       public         dotcmsdbuser    false    290    290            �           2606    29686 A   report_parameter report_parameter_report_inode_parameter_name_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.report_parameter
    ADD CONSTRAINT report_parameter_report_inode_parameter_name_key UNIQUE (report_inode, parameter_name);
 k   ALTER TABLE ONLY public.report_parameter DROP CONSTRAINT report_parameter_report_inode_parameter_name_key;
       public         dotcmsdbuser    false    290    290    290            x           2606    30811 &   rule_action_pars rule_action_pars_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.rule_action_pars
    ADD CONSTRAINT rule_action_pars_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.rule_action_pars DROP CONSTRAINT rule_action_pars_pkey;
       public         dotcmsdbuser    false    364    364            v           2606    30798    rule_action rule_action_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.rule_action
    ADD CONSTRAINT rule_action_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.rule_action DROP CONSTRAINT rule_action_pkey;
       public         dotcmsdbuser    false    363    363            p           2606    30756 .   rule_condition_group rule_condition_group_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.rule_condition_group
    ADD CONSTRAINT rule_condition_group_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.rule_condition_group DROP CONSTRAINT rule_condition_group_pkey;
       public         dotcmsdbuser    false    360    360            r           2606    30770 "   rule_condition rule_condition_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.rule_condition
    ADD CONSTRAINT rule_condition_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.rule_condition DROP CONSTRAINT rule_condition_pkey;
       public         dotcmsdbuser    false    361    361            t           2606    30784 .   rule_condition_value rule_condition_value_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.rule_condition_value
    ADD CONSTRAINT rule_condition_value_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.rule_condition_value DROP CONSTRAINT rule_condition_value_pkey;
       public         dotcmsdbuser    false    362    362            c           2606    30680    schemes_ir schemes_ir_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.schemes_ir
    ADD CONSTRAINT schemes_ir_pkey PRIMARY KEY (local_inode, endpoint_id);
 D   ALTER TABLE ONLY public.schemes_ir DROP CONSTRAINT schemes_ir_pkey;
       public         dotcmsdbuser    false    354    354    354            ]           2606    30665    sitelic sitelic_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.sitelic
    ADD CONSTRAINT sitelic_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.sitelic DROP CONSTRAINT sitelic_pkey;
       public         dotcmsdbuser    false    351    351            K           2606    30549 &   sitesearch_audit sitesearch_audit_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.sitesearch_audit
    ADD CONSTRAINT sitesearch_audit_pkey PRIMARY KEY (job_id, fire_date);
 P   ALTER TABLE ONLY public.sitesearch_audit DROP CONSTRAINT sitesearch_audit_pkey;
       public         dotcmsdbuser    false    343    343    343            H           2606    29355    structure structure_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.structure
    ADD CONSTRAINT structure_pkey PRIMARY KEY (inode);
 B   ALTER TABLE ONLY public.structure DROP CONSTRAINT structure_pkey;
       public         dotcmsdbuser    false    245    245            a           2606    30675     structures_ir structures_ir_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.structures_ir
    ADD CONSTRAINT structures_ir_pkey PRIMARY KEY (local_inode, endpoint_id);
 J   ALTER TABLE ONLY public.structures_ir DROP CONSTRAINT structures_ir_pkey;
       public         dotcmsdbuser    false    353    353    353            �           2606    29503    tag_inode tag_inode_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.tag_inode
    ADD CONSTRAINT tag_inode_pkey PRIMARY KEY (tag_id, inode);
 B   ALTER TABLE ONLY public.tag_inode DROP CONSTRAINT tag_inode_pkey;
       public         dotcmsdbuser    false    265    265    265            �           2606    29234    tag tag_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (tag_id);
 6   ALTER TABLE ONLY public.tag DROP CONSTRAINT tag_pkey;
       public         dotcmsdbuser    false    228    228            �           2606    30468    tag tag_tagname_host 
   CONSTRAINT     [   ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_tagname_host UNIQUE (tagname, host_id);
 >   ALTER TABLE ONLY public.tag DROP CONSTRAINT tag_tagname_host;
       public         dotcmsdbuser    false    228    228    228                       2606    29706 ,   template_containers template_containers_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.template_containers
    ADD CONSTRAINT template_containers_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.template_containers DROP CONSTRAINT template_containers_pkey;
       public         dotcmsdbuser    false    293    293            A           2606    29339    template template_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.template
    ADD CONSTRAINT template_pkey PRIMARY KEY (inode);
 @   ALTER TABLE ONLY public.template DROP CONSTRAINT template_pkey;
       public         dotcmsdbuser    false    243    243                       2606    29446 0   template_version_info template_version_info_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.template_version_info
    ADD CONSTRAINT template_version_info_pkey PRIMARY KEY (identifier);
 Z   ALTER TABLE ONLY public.template_version_info DROP CONSTRAINT template_version_info_pkey;
       public         dotcmsdbuser    false    257    257                       2606    29275    trackback trackback_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.trackback
    ADD CONSTRAINT trackback_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.trackback DROP CONSTRAINT trackback_pkey;
       public         dotcmsdbuser    false    234    234            2           2606    29319    tree tree_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.tree
    ADD CONSTRAINT tree_pkey PRIMARY KEY (child, parent, relation_type);
 8   ALTER TABLE ONLY public.tree DROP CONSTRAINT tree_pkey;
       public         dotcmsdbuser    false    240    240    240    240            J           2606    30165 $   structure unique_struct_vel_var_name 
   CONSTRAINT     l   ALTER TABLE ONLY public.structure
    ADD CONSTRAINT unique_struct_vel_var_name UNIQUE (velocity_var_name);
 N   ALTER TABLE ONLY public.structure DROP CONSTRAINT unique_struct_vel_var_name;
       public         dotcmsdbuser    false    245    245            #           2606    30335 +   workflow_scheme unique_workflow_scheme_name 
   CONSTRAINT     f   ALTER TABLE ONLY public.workflow_scheme
    ADD CONSTRAINT unique_workflow_scheme_name UNIQUE (name);
 U   ALTER TABLE ONLY public.workflow_scheme DROP CONSTRAINT unique_workflow_scheme_name;
       public         dotcmsdbuser    false    329    329            �           2606    28986    user_ user__pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.user_
    ADD CONSTRAINT user__pkey PRIMARY KEY (userid);
 :   ALTER TABLE ONLY public.user_ DROP CONSTRAINT user__pkey;
       public         dotcmsdbuser    false    199    199            �           2606    29242     user_comments user_comments_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.user_comments
    ADD CONSTRAINT user_comments_pkey PRIMARY KEY (inode);
 J   ALTER TABLE ONLY public.user_comments DROP CONSTRAINT user_comments_pkey;
       public         dotcmsdbuser    false    229    229                       2606    29714    user_filter user_filter_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.user_filter
    ADD CONSTRAINT user_filter_pkey PRIMARY KEY (inode);
 F   ALTER TABLE ONLY public.user_filter DROP CONSTRAINT user_filter_pkey;
       public         dotcmsdbuser    false    294    294            �           2606    29454 &   user_preferences user_preferences_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT user_preferences_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.user_preferences DROP CONSTRAINT user_preferences_pkey;
       public         dotcmsdbuser    false    258    258            �           2606    29618    user_proxy user_proxy_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.user_proxy
    ADD CONSTRAINT user_proxy_pkey PRIMARY KEY (inode);
 D   ALTER TABLE ONLY public.user_proxy DROP CONSTRAINT user_proxy_pkey;
       public         dotcmsdbuser    false    282    282            �           2606    29620 !   user_proxy user_proxy_user_id_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.user_proxy
    ADD CONSTRAINT user_proxy_user_id_key UNIQUE (user_id);
 K   ALTER TABLE ONLY public.user_proxy DROP CONSTRAINT user_proxy_user_id_key;
       public         dotcmsdbuser    false    282    282            ;           2606    30085 '   users_cms_roles users_cms_roles_parent1 
   CONSTRAINT     n   ALTER TABLE ONLY public.users_cms_roles
    ADD CONSTRAINT users_cms_roles_parent1 UNIQUE (role_id, user_id);
 Q   ALTER TABLE ONLY public.users_cms_roles DROP CONSTRAINT users_cms_roles_parent1;
       public         dotcmsdbuser    false    242    242    242            =           2606    29331 $   users_cms_roles users_cms_roles_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.users_cms_roles
    ADD CONSTRAINT users_cms_roles_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.users_cms_roles DROP CONSTRAINT users_cms_roles_pkey;
       public         dotcmsdbuser    false    242    242            �           2606    29467 $   users_to_delete users_to_delete_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.users_to_delete
    ADD CONSTRAINT users_to_delete_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.users_to_delete DROP CONSTRAINT users_to_delete_pkey;
       public         dotcmsdbuser    false    260    260            �           2606    28994    usertracker usertracker_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.usertracker
    ADD CONSTRAINT usertracker_pkey PRIMARY KEY (usertrackerid);
 F   ALTER TABLE ONLY public.usertracker DROP CONSTRAINT usertracker_pkey;
       public         dotcmsdbuser    false    200    200            �           2606    29002 $   usertrackerpath usertrackerpath_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public.usertrackerpath
    ADD CONSTRAINT usertrackerpath_pkey PRIMARY KEY (usertrackerpathid);
 N   ALTER TABLE ONLY public.usertrackerpath DROP CONSTRAINT usertrackerpath_pkey;
       public         dotcmsdbuser    false    201    201            !           2606    29307    web_form web_form_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.web_form
    ADD CONSTRAINT web_form_pkey PRIMARY KEY (web_form_id);
 @   ALTER TABLE ONLY public.web_form DROP CONSTRAINT web_form_pkey;
       public         dotcmsdbuser    false    238    238            0           2606    30403 :   workflow_action_class_pars workflow_action_class_pars_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.workflow_action_class_pars
    ADD CONSTRAINT workflow_action_class_pars_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.workflow_action_class_pars DROP CONSTRAINT workflow_action_class_pars_pkey;
       public         dotcmsdbuser    false    333    333            -           2606    30389 0   workflow_action_class workflow_action_class_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.workflow_action_class
    ADD CONSTRAINT workflow_action_class_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.workflow_action_class DROP CONSTRAINT workflow_action_class_pkey;
       public         dotcmsdbuser    false    332    332            *           2606    30364 $   workflow_action workflow_action_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.workflow_action
    ADD CONSTRAINT workflow_action_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.workflow_action DROP CONSTRAINT workflow_action_pkey;
       public         dotcmsdbuser    false    331    331            m           2606    29418 &   workflow_comment workflow_comment_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.workflow_comment
    ADD CONSTRAINT workflow_comment_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.workflow_comment DROP CONSTRAINT workflow_comment_pkey;
       public         dotcmsdbuser    false    253    253            �           2606    29594 &   workflow_history workflow_history_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.workflow_history
    ADD CONSTRAINT workflow_history_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.workflow_history DROP CONSTRAINT workflow_history_pkey;
       public         dotcmsdbuser    false    279    279            %           2606    30333 $   workflow_scheme workflow_scheme_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.workflow_scheme
    ADD CONSTRAINT workflow_scheme_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.workflow_scheme DROP CONSTRAINT workflow_scheme_pkey;
       public         dotcmsdbuser    false    329    329            4           2606    30414 <   workflow_scheme_x_structure workflow_scheme_x_structure_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.workflow_scheme_x_structure
    ADD CONSTRAINT workflow_scheme_x_structure_pkey PRIMARY KEY (id);
 f   ALTER TABLE ONLY public.workflow_scheme_x_structure DROP CONSTRAINT workflow_scheme_x_structure_pkey;
       public         dotcmsdbuser    false    334    334            (           2606    30344     workflow_step workflow_step_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.workflow_step
    ADD CONSTRAINT workflow_step_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.workflow_step DROP CONSTRAINT workflow_step_pkey;
       public         dotcmsdbuser    false    330    330            �           2606    29498     workflow_task workflow_task_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.workflow_task
    ADD CONSTRAINT workflow_task_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.workflow_task DROP CONSTRAINT workflow_task_pkey;
       public         dotcmsdbuser    false    264    264            �           2606    29565 *   workflowtask_files workflowtask_files_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.workflowtask_files
    ADD CONSTRAINT workflowtask_files_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.workflowtask_files DROP CONSTRAINT workflowtask_files_pkey;
       public         dotcmsdbuser    false    275    275            �           1259    30001    addres_userid_index    INDEX     I   CREATE INDEX addres_userid_index ON public.address USING btree (userid);
 '   DROP INDEX public.addres_userid_index;
       public         dotcmsdbuser    false    186            �           1259    30629    containers_ident    INDEX     Q   CREATE INDEX containers_ident ON public.dot_containers USING btree (identifier);
 $   DROP INDEX public.containers_ident;
       public         dotcmsdbuser    false    277            [           1259    30627    contentlet_ident    INDEX     M   CREATE INDEX contentlet_ident ON public.contentlet USING btree (identifier);
 $   DROP INDEX public.contentlet_ident;
       public         dotcmsdbuser    false    249            \           1259    30632    contentlet_lang    INDEX     M   CREATE INDEX contentlet_lang ON public.contentlet USING btree (language_id);
 #   DROP INDEX public.contentlet_lang;
       public         dotcmsdbuser    false    249            ]           1259    30631    contentlet_moduser    INDEX     M   CREATE INDEX contentlet_moduser ON public.contentlet USING btree (mod_user);
 &   DROP INDEX public.contentlet_moduser;
       public         dotcmsdbuser    false    249                       1259    30045    dist_process_index    INDEX     n   CREATE INDEX dist_process_index ON public.dist_process USING btree (object_to_index, serverid, journal_type);
 &   DROP INDEX public.dist_process_index;
       public         dotcmsdbuser    false    323    323    323                       1259    30063    dist_reindex_index    INDEX     d   CREATE INDEX dist_reindex_index ON public.dist_reindex_journal USING btree (serverid, dist_action);
 &   DROP INDEX public.dist_reindex_index;
       public         dotcmsdbuser    false    325    325                       1259    30059    dist_reindex_index1    INDEX     ^   CREATE INDEX dist_reindex_index1 ON public.dist_reindex_journal USING btree (inode_to_index);
 '   DROP INDEX public.dist_reindex_index1;
       public         dotcmsdbuser    false    325                       1259    30060    dist_reindex_index2    INDEX     [   CREATE INDEX dist_reindex_index2 ON public.dist_reindex_journal USING btree (dist_action);
 '   DROP INDEX public.dist_reindex_index2;
       public         dotcmsdbuser    false    325                       1259    30061    dist_reindex_index3    INDEX     X   CREATE INDEX dist_reindex_index3 ON public.dist_reindex_journal USING btree (serverid);
 '   DROP INDEX public.dist_reindex_index3;
       public         dotcmsdbuser    false    325                       1259    30062    dist_reindex_index4    INDEX     h   CREATE INDEX dist_reindex_index4 ON public.dist_reindex_journal USING btree (ident_to_index, serverid);
 '   DROP INDEX public.dist_reindex_index4;
       public         dotcmsdbuser    false    325    325                       1259    30064    dist_reindex_index5    INDEX     f   CREATE INDEX dist_reindex_index5 ON public.dist_reindex_journal USING btree (priority, time_entered);
 '   DROP INDEX public.dist_reindex_index5;
       public         dotcmsdbuser    false    325    325                       1259    30065    dist_reindex_index6    INDEX     X   CREATE INDEX dist_reindex_index6 ON public.dist_reindex_journal USING btree (priority);
 '   DROP INDEX public.dist_reindex_index6;
       public         dotcmsdbuser    false    325            �           1259    30626    folder_ident    INDEX     E   CREATE INDEX folder_ident ON public.folder USING btree (identifier);
     DROP INDEX public.folder_ident;
       public         dotcmsdbuser    false    286            7           1259    29752    idx_analytic_summary_1    INDEX     V   CREATE INDEX idx_analytic_summary_1 ON public.analytic_summary USING btree (host_id);
 *   DROP INDEX public.idx_analytic_summary_1;
       public         dotcmsdbuser    false    241            8           1259    29753    idx_analytic_summary_2    INDEX     U   CREATE INDEX idx_analytic_summary_2 ON public.analytic_summary USING btree (visits);
 *   DROP INDEX public.idx_analytic_summary_2;
       public         dotcmsdbuser    false    241            9           1259    29754    idx_analytic_summary_3    INDEX     Y   CREATE INDEX idx_analytic_summary_3 ON public.analytic_summary USING btree (page_views);
 *   DROP INDEX public.idx_analytic_summary_3;
       public         dotcmsdbuser    false    241            e           1259    29782    idx_analytic_summary_404_1    INDEX     ^   CREATE INDEX idx_analytic_summary_404_1 ON public.analytic_summary_404 USING btree (host_id);
 .   DROP INDEX public.idx_analytic_summary_404_1;
       public         dotcmsdbuser    false    250            &           1259    29750    idx_analytic_summary_period_2    INDEX     `   CREATE INDEX idx_analytic_summary_period_2 ON public.analytic_summary_period USING btree (day);
 1   DROP INDEX public.idx_analytic_summary_period_2;
       public         dotcmsdbuser    false    239            '           1259    29749    idx_analytic_summary_period_3    INDEX     a   CREATE INDEX idx_analytic_summary_period_3 ON public.analytic_summary_period USING btree (week);
 1   DROP INDEX public.idx_analytic_summary_period_3;
       public         dotcmsdbuser    false    239            (           1259    29748    idx_analytic_summary_period_4    INDEX     b   CREATE INDEX idx_analytic_summary_period_4 ON public.analytic_summary_period USING btree (month);
 1   DROP INDEX public.idx_analytic_summary_period_4;
       public         dotcmsdbuser    false    239            )           1259    29751    idx_analytic_summary_period_5    INDEX     a   CREATE INDEX idx_analytic_summary_period_5 ON public.analytic_summary_period USING btree (year);
 1   DROP INDEX public.idx_analytic_summary_period_5;
       public         dotcmsdbuser    false    239            y           1259    29801    idx_analytic_summary_visits_1    INDEX     d   CREATE INDEX idx_analytic_summary_visits_1 ON public.analytic_summary_visits USING btree (host_id);
 1   DROP INDEX public.idx_analytic_summary_visits_1;
       public         dotcmsdbuser    false    256            z           1259    29800    idx_analytic_summary_visits_2    INDEX     g   CREATE INDEX idx_analytic_summary_visits_2 ON public.analytic_summary_visits USING btree (visit_time);
 1   DROP INDEX public.idx_analytic_summary_visits_2;
       public         dotcmsdbuser    false    256            �           1259    29847    idx_campaign_1    INDEX     F   CREATE INDEX idx_campaign_1 ON public.campaign USING btree (user_id);
 "   DROP INDEX public.idx_campaign_1;
       public         dotcmsdbuser    false    274            �           1259    29846    idx_campaign_2    INDEX     I   CREATE INDEX idx_campaign_2 ON public.campaign USING btree (start_date);
 "   DROP INDEX public.idx_campaign_2;
       public         dotcmsdbuser    false    274            �           1259    29845    idx_campaign_3    INDEX     M   CREATE INDEX idx_campaign_3 ON public.campaign USING btree (completed_date);
 "   DROP INDEX public.idx_campaign_3;
       public         dotcmsdbuser    false    274            �           1259    29844    idx_campaign_4    INDEX     N   CREATE INDEX idx_campaign_4 ON public.campaign USING btree (expiration_date);
 "   DROP INDEX public.idx_campaign_4;
       public         dotcmsdbuser    false    274            p           1259    29793    idx_category_1    INDEX     L   CREATE INDEX idx_category_1 ON public.category USING btree (category_name);
 "   DROP INDEX public.idx_category_1;
       public         dotcmsdbuser    false    254            q           1259    29794    idx_category_2    INDEX     K   CREATE INDEX idx_category_2 ON public.category USING btree (category_key);
 "   DROP INDEX public.idx_category_2;
       public         dotcmsdbuser    false    254            �           1259    30007    idx_chain_key_name    INDEX     H   CREATE INDEX idx_chain_key_name ON public.chain USING btree (key_name);
 &   DROP INDEX public.idx_chain_key_name;
       public         dotcmsdbuser    false    291            v           1259    30006    idx_chain_link_code_classname    INDEX     _   CREATE INDEX idx_chain_link_code_classname ON public.chain_link_code USING btree (class_name);
 1   DROP INDEX public.idx_chain_link_code_classname;
       public         dotcmsdbuser    false    255            �           1259    29825    idx_click_1    INDEX     =   CREATE INDEX idx_click_1 ON public.click USING btree (link);
    DROP INDEX public.idx_click_1;
       public         dotcmsdbuser    false    266                       1259    29739    idx_communication_user_id    INDEX     R   CREATE INDEX idx_communication_user_id ON public.recipient USING btree (user_id);
 -   DROP INDEX public.idx_communication_user_id;
       public         dotcmsdbuser    false    237            S           1259    30647    idx_container_id    INDEX     Y   CREATE INDEX idx_container_id ON public.container_structures USING btree (container_id);
 $   DROP INDEX public.idx_container_id;
       public         dotcmsdbuser    false    247                       1259    30620    idx_container_vi_live    INDEX     ^   CREATE INDEX idx_container_vi_live ON public.container_version_info USING btree (live_inode);
 )   DROP INDEX public.idx_container_vi_live;
       public         dotcmsdbuser    false    233                       1259    30644    idx_container_vi_version_ts    INDEX     d   CREATE INDEX idx_container_vi_version_ts ON public.container_version_info USING btree (version_ts);
 /   DROP INDEX public.idx_container_vi_version_ts;
       public         dotcmsdbuser    false    233                       1259    30621    idx_container_vi_working    INDEX     d   CREATE INDEX idx_container_vi_working ON public.container_version_info USING btree (working_inode);
 ,   DROP INDEX public.idx_container_vi_working;
       public         dotcmsdbuser    false    233            `           1259    29964    idx_contentlet_3    INDEX     H   CREATE INDEX idx_contentlet_3 ON public.contentlet USING btree (inode);
 $   DROP INDEX public.idx_contentlet_3;
       public         dotcmsdbuser    false    249            a           1259    30189    idx_contentlet_4    INDEX     R   CREATE INDEX idx_contentlet_4 ON public.contentlet USING btree (structure_inode);
 $   DROP INDEX public.idx_contentlet_4;
       public         dotcmsdbuser    false    249            b           1259    30190    idx_contentlet_identifier    INDEX     V   CREATE INDEX idx_contentlet_identifier ON public.contentlet USING btree (identifier);
 -   DROP INDEX public.idx_contentlet_identifier;
       public         dotcmsdbuser    false    249                       1259    30624    idx_contentlet_vi_live    INDEX     `   CREATE INDEX idx_contentlet_vi_live ON public.contentlet_version_info USING btree (live_inode);
 *   DROP INDEX public.idx_contentlet_vi_live;
       public         dotcmsdbuser    false    231                       1259    30643    idx_contentlet_vi_version_ts    INDEX     f   CREATE INDEX idx_contentlet_vi_version_ts ON public.contentlet_version_info USING btree (version_ts);
 0   DROP INDEX public.idx_contentlet_vi_version_ts;
       public         dotcmsdbuser    false    231            	           1259    30625    idx_contentlet_vi_working    INDEX     f   CREATE INDEX idx_contentlet_vi_working ON public.contentlet_version_info USING btree (working_inode);
 -   DROP INDEX public.idx_contentlet_vi_working;
       public         dotcmsdbuser    false    231            �           1259    29838    idx_dashboard_prefs_2    INDEX     _   CREATE INDEX idx_dashboard_prefs_2 ON public.dashboard_user_preferences USING btree (user_id);
 )   DROP INDEX public.idx_dashboard_prefs_2;
       public         dotcmsdbuser    false    273            �           1259    29836    idx_dashboard_workstream_1    INDEX     i   CREATE INDEX idx_dashboard_workstream_1 ON public.analytic_summary_workstream USING btree (mod_user_id);
 .   DROP INDEX public.idx_dashboard_workstream_1;
       public         dotcmsdbuser    false    272            �           1259    29835    idx_dashboard_workstream_2    INDEX     e   CREATE INDEX idx_dashboard_workstream_2 ON public.analytic_summary_workstream USING btree (host_id);
 .   DROP INDEX public.idx_dashboard_workstream_2;
       public         dotcmsdbuser    false    272            �           1259    29837    idx_dashboard_workstream_3    INDEX     f   CREATE INDEX idx_dashboard_workstream_3 ON public.analytic_summary_workstream USING btree (mod_date);
 .   DROP INDEX public.idx_dashboard_workstream_3;
       public         dotcmsdbuser    false    272            �           1259    29878    idx_field_1    INDEX     H   CREATE INDEX idx_field_1 ON public.field USING btree (structure_inode);
    DROP INDEX public.idx_field_1;
       public         dotcmsdbuser    false    284            �           1259    29971    idx_field_velocity_structure    INDEX     s   CREATE UNIQUE INDEX idx_field_velocity_structure ON public.field USING btree (velocity_var_name, structure_inode);
 0   DROP INDEX public.idx_field_velocity_structure;
       public         dotcmsdbuser    false    284    284            �           1259    29891    idx_folder_1    INDEX     ?   CREATE INDEX idx_folder_1 ON public.folder USING btree (name);
     DROP INDEX public.idx_folder_1;
       public         dotcmsdbuser    false    286            �           1259    30066    idx_identifier    INDEX     C   CREATE INDEX idx_identifier ON public.identifier USING btree (id);
 "   DROP INDEX public.idx_identifier;
       public         dotcmsdbuser    false    261            �           1259    29809    idx_identifier_exp    INDEX     S   CREATE INDEX idx_identifier_exp ON public.identifier USING btree (sysexpire_date);
 &   DROP INDEX public.idx_identifier_exp;
       public         dotcmsdbuser    false    261            �           1259    30487    idx_identifier_perm    INDEX     \   CREATE INDEX idx_identifier_perm ON public.identifier USING btree (asset_type, host_inode);
 '   DROP INDEX public.idx_identifier_perm;
       public         dotcmsdbuser    false    261    261            �           1259    29808    idx_identifier_pub    INDEX     T   CREATE INDEX idx_identifier_pub ON public.identifier USING btree (syspublish_date);
 &   DROP INDEX public.idx_identifier_pub;
       public         dotcmsdbuser    false    261            	           1259    29910    idx_index_1    INDEX     =   CREATE INDEX idx_index_1 ON public.inode USING btree (type);
    DROP INDEX public.idx_index_1;
       public         dotcmsdbuser    false    295            �           1259    30618    idx_link_vi_live    INDEX     T   CREATE INDEX idx_link_vi_live ON public.link_version_info USING btree (live_inode);
 $   DROP INDEX public.idx_link_vi_live;
       public         dotcmsdbuser    false    292                        1259    30646    idx_link_vi_version_ts    INDEX     Z   CREATE INDEX idx_link_vi_version_ts ON public.link_version_info USING btree (version_ts);
 *   DROP INDEX public.idx_link_vi_version_ts;
       public         dotcmsdbuser    false    292                       1259    30619    idx_link_vi_working    INDEX     Z   CREATE INDEX idx_link_vi_working ON public.link_version_info USING btree (working_inode);
 '   DROP INDEX public.idx_link_vi_working;
       public         dotcmsdbuser    false    292            D           1259    30827    idx_lower_structure_name    INDEX     j   CREATE INDEX idx_lower_structure_name ON public.structure USING btree (lower((velocity_var_name)::text));
 ,   DROP INDEX public.idx_lower_structure_name;
       public         dotcmsdbuser    false    245    245                       1259    29733    idx_mailinglist_1    INDEX     M   CREATE INDEX idx_mailinglist_1 ON public.mailing_list USING btree (user_id);
 %   DROP INDEX public.idx_mailinglist_1;
       public         dotcmsdbuser    false    236            �           1259    29819    idx_multitree_1    INDEX     O   CREATE INDEX idx_multitree_1 ON public.multi_tree USING btree (relation_type);
 #   DROP INDEX public.idx_multitree_1;
       public         dotcmsdbuser    false    263            Y           1259    30642    idx_not_read    INDEX     I   CREATE INDEX idx_not_read ON public.notification USING btree (was_read);
     DROP INDEX public.idx_not_read;
       public         dotcmsdbuser    false    350            T           1259    29965    idx_permisision_4    INDEX     S   CREATE INDEX idx_permisision_4 ON public.permission USING btree (permission_type);
 %   DROP INDEX public.idx_permisision_4;
       public         dotcmsdbuser    false    248            U           1259    29775    idx_permission_2    INDEX     \   CREATE INDEX idx_permission_2 ON public.permission USING btree (permission_type, inode_id);
 $   DROP INDEX public.idx_permission_2;
       public         dotcmsdbuser    false    248    248            V           1259    29776    idx_permission_3    INDEX     I   CREATE INDEX idx_permission_3 ON public.permission USING btree (roleid);
 $   DROP INDEX public.idx_permission_3;
       public         dotcmsdbuser    false    248            �           1259    29966    idx_permission_reference_2    INDEX     c   CREATE INDEX idx_permission_reference_2 ON public.permission_reference USING btree (reference_id);
 .   DROP INDEX public.idx_permission_reference_2;
       public         dotcmsdbuser    false    230            �           1259    29967    idx_permission_reference_3    INDEX     t   CREATE INDEX idx_permission_reference_3 ON public.permission_reference USING btree (reference_id, permission_type);
 .   DROP INDEX public.idx_permission_reference_3;
       public         dotcmsdbuser    false    230    230            �           1259    29968    idx_permission_reference_4    INDEX     p   CREATE INDEX idx_permission_reference_4 ON public.permission_reference USING btree (asset_id, permission_type);
 .   DROP INDEX public.idx_permission_reference_4;
       public         dotcmsdbuser    false    230    230            �           1259    29969    idx_permission_reference_5    INDEX     ~   CREATE INDEX idx_permission_reference_5 ON public.permission_reference USING btree (asset_id, reference_id, permission_type);
 .   DROP INDEX public.idx_permission_reference_5;
       public         dotcmsdbuser    false    230    230    230                        1259    29970    idx_permission_reference_6    INDEX     f   CREATE INDEX idx_permission_reference_6 ON public.permission_reference USING btree (permission_type);
 .   DROP INDEX public.idx_permission_reference_6;
       public         dotcmsdbuser    false    230            �           1259    29807    idx_preference_1    INDEX     S   CREATE INDEX idx_preference_1 ON public.user_preferences USING btree (preference);
 $   DROP INDEX public.idx_preference_1;
       public         dotcmsdbuser    false    258            ?           1259    30584    idx_pub_qa_1    INDEX     Q   CREATE INDEX idx_pub_qa_1 ON public.publishing_queue_audit USING btree (status);
     DROP INDEX public.idx_pub_qa_1;
       public         dotcmsdbuser    false    340            P           1259    30581    idx_pushed_assets_1    INDEX     ]   CREATE INDEX idx_pushed_assets_1 ON public.publishing_pushed_assets USING btree (bundle_id);
 '   DROP INDEX public.idx_pushed_assets_1;
       public         dotcmsdbuser    false    346            Q           1259    30582    idx_pushed_assets_2    INDEX     b   CREATE INDEX idx_pushed_assets_2 ON public.publishing_pushed_assets USING btree (environment_id);
 '   DROP INDEX public.idx_pushed_assets_2;
       public         dotcmsdbuser    false    346            R           1259    30583    idx_pushed_assets_3    INDEX     l   CREATE INDEX idx_pushed_assets_3 ON public.publishing_pushed_assets USING btree (asset_id, environment_id);
 '   DROP INDEX public.idx_pushed_assets_3;
       public         dotcmsdbuser    false    346    346                       1259    29740    idx_recipiets_1    INDEX     F   CREATE INDEX idx_recipiets_1 ON public.recipient USING btree (email);
 #   DROP INDEX public.idx_recipiets_1;
       public         dotcmsdbuser    false    237                       1259    29741    idx_recipiets_2    INDEX     E   CREATE INDEX idx_recipiets_2 ON public.recipient USING btree (sent);
 #   DROP INDEX public.idx_recipiets_2;
       public         dotcmsdbuser    false    237            �           1259    29884    idx_relationship_1    INDEX     ]   CREATE INDEX idx_relationship_1 ON public.relationship USING btree (parent_structure_inode);
 &   DROP INDEX public.idx_relationship_1;
       public         dotcmsdbuser    false    285            �           1259    29885    idx_relationship_2    INDEX     \   CREATE INDEX idx_relationship_2 ON public.relationship USING btree (child_structure_inode);
 &   DROP INDEX public.idx_relationship_2;
       public         dotcmsdbuser    false    285            n           1259    30817    idx_rules_fire_on    INDEX     I   CREATE INDEX idx_rules_fire_on ON public.dot_rule USING btree (fire_on);
 %   DROP INDEX public.idx_rules_fire_on;
       public         dotcmsdbuser    false    359            E           1259    30167    idx_structure_folder    INDEX     L   CREATE INDEX idx_structure_folder ON public.structure USING btree (folder);
 (   DROP INDEX public.idx_structure_folder;
       public         dotcmsdbuser    false    245            F           1259    30166    idx_structure_host    INDEX     H   CREATE INDEX idx_structure_host ON public.structure USING btree (host);
 &   DROP INDEX public.idx_structure_host;
       public         dotcmsdbuser    false    245            y           1259    30826    idx_system_event    INDEX     L   CREATE INDEX idx_system_event ON public.system_event USING btree (created);
 $   DROP INDEX public.idx_system_event;
       public         dotcmsdbuser    false    365            >           1259    30188    idx_template3    INDEX     R   CREATE INDEX idx_template3 ON public.template USING btree (lower((title)::text));
 !   DROP INDEX public.idx_template3;
       public         dotcmsdbuser    false    243    243                       1259    30218    idx_template_id    INDEX     V   CREATE INDEX idx_template_id ON public.template_containers USING btree (template_id);
 #   DROP INDEX public.idx_template_id;
       public         dotcmsdbuser    false    293            {           1259    30622    idx_template_vi_live    INDEX     \   CREATE INDEX idx_template_vi_live ON public.template_version_info USING btree (live_inode);
 (   DROP INDEX public.idx_template_vi_live;
       public         dotcmsdbuser    false    257            |           1259    30645    idx_template_vi_version_ts    INDEX     b   CREATE INDEX idx_template_vi_version_ts ON public.template_version_info USING btree (version_ts);
 .   DROP INDEX public.idx_template_vi_version_ts;
       public         dotcmsdbuser    false    257            }           1259    30623    idx_template_vi_working    INDEX     b   CREATE INDEX idx_template_vi_working ON public.template_version_info USING btree (working_inode);
 +   DROP INDEX public.idx_template_vi_working;
       public         dotcmsdbuser    false    257                       1259    29732    idx_trackback_1    INDEX     Q   CREATE INDEX idx_trackback_1 ON public.trackback USING btree (asset_identifier);
 #   DROP INDEX public.idx_trackback_1;
       public         dotcmsdbuser    false    234                       1259    29731    idx_trackback_2    INDEX     D   CREATE INDEX idx_trackback_2 ON public.trackback USING btree (url);
 #   DROP INDEX public.idx_trackback_2;
       public         dotcmsdbuser    false    234            *           1259    29957    idx_tree    INDEX     Q   CREATE INDEX idx_tree ON public.tree USING btree (child, parent, relation_type);
    DROP INDEX public.idx_tree;
       public         dotcmsdbuser    false    240    240    240            +           1259    29958 
   idx_tree_1    INDEX     =   CREATE INDEX idx_tree_1 ON public.tree USING btree (parent);
    DROP INDEX public.idx_tree_1;
       public         dotcmsdbuser    false    240            ,           1259    29959 
   idx_tree_2    INDEX     <   CREATE INDEX idx_tree_2 ON public.tree USING btree (child);
    DROP INDEX public.idx_tree_2;
       public         dotcmsdbuser    false    240            -           1259    29960 
   idx_tree_3    INDEX     D   CREATE INDEX idx_tree_3 ON public.tree USING btree (relation_type);
    DROP INDEX public.idx_tree_3;
       public         dotcmsdbuser    false    240            .           1259    29961 
   idx_tree_4    INDEX     S   CREATE INDEX idx_tree_4 ON public.tree USING btree (parent, child, relation_type);
    DROP INDEX public.idx_tree_4;
       public         dotcmsdbuser    false    240    240    240            /           1259    29962 
   idx_tree_5    INDEX     L   CREATE INDEX idx_tree_5 ON public.tree USING btree (parent, relation_type);
    DROP INDEX public.idx_tree_5;
       public         dotcmsdbuser    false    240    240            0           1259    29963 
   idx_tree_6    INDEX     K   CREATE INDEX idx_tree_6 ON public.tree USING btree (child, relation_type);
    DROP INDEX public.idx_tree_6;
       public         dotcmsdbuser    false    240    240            �           1259    29810    idx_user_clickstream11    INDEX     Q   CREATE INDEX idx_user_clickstream11 ON public.clickstream USING btree (host_id);
 *   DROP INDEX public.idx_user_clickstream11;
       public         dotcmsdbuser    false    262            �           1259    29811    idx_user_clickstream12    INDEX     V   CREATE INDEX idx_user_clickstream12 ON public.clickstream USING btree (last_page_id);
 *   DROP INDEX public.idx_user_clickstream12;
       public         dotcmsdbuser    false    262            �           1259    29816    idx_user_clickstream13    INDEX     W   CREATE INDEX idx_user_clickstream13 ON public.clickstream USING btree (first_page_id);
 *   DROP INDEX public.idx_user_clickstream13;
       public         dotcmsdbuser    false    262            �           1259    29817    idx_user_clickstream14    INDEX     Z   CREATE INDEX idx_user_clickstream14 ON public.clickstream USING btree (operating_system);
 *   DROP INDEX public.idx_user_clickstream14;
       public         dotcmsdbuser    false    262            �           1259    29812    idx_user_clickstream15    INDEX     V   CREATE INDEX idx_user_clickstream15 ON public.clickstream USING btree (browser_name);
 *   DROP INDEX public.idx_user_clickstream15;
       public         dotcmsdbuser    false    262            �           1259    29814    idx_user_clickstream16    INDEX     Y   CREATE INDEX idx_user_clickstream16 ON public.clickstream USING btree (browser_version);
 *   DROP INDEX public.idx_user_clickstream16;
       public         dotcmsdbuser    false    262            �           1259    29818    idx_user_clickstream17    INDEX     X   CREATE INDEX idx_user_clickstream17 ON public.clickstream USING btree (remote_address);
 *   DROP INDEX public.idx_user_clickstream17;
       public         dotcmsdbuser    false    262            �           1259    29815    idx_user_clickstream_1    INDEX     S   CREATE INDEX idx_user_clickstream_1 ON public.clickstream USING btree (cookie_id);
 *   DROP INDEX public.idx_user_clickstream_1;
       public         dotcmsdbuser    false    262            �           1259    29813    idx_user_clickstream_2    INDEX     Q   CREATE INDEX idx_user_clickstream_2 ON public.clickstream USING btree (user_id);
 *   DROP INDEX public.idx_user_clickstream_2;
       public         dotcmsdbuser    false    262            �           1259    29899    idx_user_clickstream_404_1    INDEX     ]   CREATE INDEX idx_user_clickstream_404_1 ON public.clickstream_404 USING btree (request_uri);
 .   DROP INDEX public.idx_user_clickstream_404_1;
       public         dotcmsdbuser    false    287            �           1259    29897    idx_user_clickstream_404_2    INDEX     Y   CREATE INDEX idx_user_clickstream_404_2 ON public.clickstream_404 USING btree (user_id);
 .   DROP INDEX public.idx_user_clickstream_404_2;
       public         dotcmsdbuser    false    287            �           1259    29898    idx_user_clickstream_404_3    INDEX     Y   CREATE INDEX idx_user_clickstream_404_3 ON public.clickstream_404 USING btree (host_id);
 .   DROP INDEX public.idx_user_clickstream_404_3;
       public         dotcmsdbuser    false    287            �           1259    29832    idx_user_clickstream_request_1    INDEX     h   CREATE INDEX idx_user_clickstream_request_1 ON public.clickstream_request USING btree (clickstream_id);
 2   DROP INDEX public.idx_user_clickstream_request_1;
       public         dotcmsdbuser    false    269            �           1259    29831    idx_user_clickstream_request_2    INDEX     e   CREATE INDEX idx_user_clickstream_request_2 ON public.clickstream_request USING btree (request_uri);
 2   DROP INDEX public.idx_user_clickstream_request_2;
       public         dotcmsdbuser    false    269            �           1259    29834    idx_user_clickstream_request_3    INDEX     o   CREATE INDEX idx_user_clickstream_request_3 ON public.clickstream_request USING btree (associated_identifier);
 2   DROP INDEX public.idx_user_clickstream_request_3;
       public         dotcmsdbuser    false    269            �           1259    29833    idx_user_clickstream_request_4    INDEX     f   CREATE INDEX idx_user_clickstream_request_4 ON public.clickstream_request USING btree (timestampper);
 2   DROP INDEX public.idx_user_clickstream_request_4;
       public         dotcmsdbuser    false    269            �           1259    29725    idx_user_comments_1    INDEX     P   CREATE INDEX idx_user_comments_1 ON public.user_comments USING btree (user_id);
 '   DROP INDEX public.idx_user_comments_1;
       public         dotcmsdbuser    false    229                       1259    29747    idx_user_webform_1    INDEX     L   CREATE INDEX idx_user_webform_1 ON public.web_form USING btree (form_type);
 &   DROP INDEX public.idx_user_webform_1;
       public         dotcmsdbuser    false    238            �           1259    29824    idx_workflow_1    INDEX     O   CREATE INDEX idx_workflow_1 ON public.workflow_task USING btree (assigned_to);
 "   DROP INDEX public.idx_workflow_1;
       public         dotcmsdbuser    false    264            �           1259    29822    idx_workflow_2    INDEX     N   CREATE INDEX idx_workflow_2 ON public.workflow_task USING btree (belongs_to);
 "   DROP INDEX public.idx_workflow_2;
       public         dotcmsdbuser    false    264            �           1259    29823    idx_workflow_3    INDEX     J   CREATE INDEX idx_workflow_3 ON public.workflow_task USING btree (status);
 "   DROP INDEX public.idx_workflow_3;
       public         dotcmsdbuser    false    264            �           1259    29820    idx_workflow_4    INDEX     L   CREATE INDEX idx_workflow_4 ON public.workflow_task USING btree (webasset);
 "   DROP INDEX public.idx_workflow_4;
       public         dotcmsdbuser    false    264            �           1259    29821    idx_workflow_5    INDEX     N   CREATE INDEX idx_workflow_5 ON public.workflow_task USING btree (created_by);
 "   DROP INDEX public.idx_workflow_5;
       public         dotcmsdbuser    false    264            �           1259    30628    links_ident    INDEX     C   CREATE INDEX links_ident ON public.links USING btree (identifier);
    DROP INDEX public.links_ident;
       public         dotcmsdbuser    false    281            �           1259    30005    tag_inode_inode    INDEX     F   CREATE INDEX tag_inode_inode ON public.tag_inode USING btree (inode);
 #   DROP INDEX public.tag_inode_inode;
       public         dotcmsdbuser    false    265            �           1259    30004    tag_inode_tagid    INDEX     G   CREATE INDEX tag_inode_tagid ON public.tag_inode USING btree (tag_id);
 #   DROP INDEX public.tag_inode_tagid;
       public         dotcmsdbuser    false    265            �           1259    30003    tag_is_persona_index    INDEX     G   CREATE INDEX tag_is_persona_index ON public.tag USING btree (persona);
 (   DROP INDEX public.tag_is_persona_index;
       public         dotcmsdbuser    false    228            �           1259    30474    tag_user_id_index    INDEX     D   CREATE INDEX tag_user_id_index ON public.tag USING btree (user_id);
 %   DROP INDEX public.tag_user_id_index;
       public         dotcmsdbuser    false    228            ?           1259    30630    template_ident    INDEX     I   CREATE INDEX template_ident ON public.template USING btree (identifier);
 "   DROP INDEX public.template_ident;
       public         dotcmsdbuser    false    243            .           1259    30395     workflow_idx_action_class_action    INDEX     g   CREATE INDEX workflow_idx_action_class_action ON public.workflow_action_class USING btree (action_id);
 4   DROP INDEX public.workflow_idx_action_class_action;
       public         dotcmsdbuser    false    332            1           1259    30409 &   workflow_idx_action_class_param_action    INDEX     �   CREATE INDEX workflow_idx_action_class_param_action ON public.workflow_action_class_pars USING btree (workflow_action_class_id);
 :   DROP INDEX public.workflow_idx_action_class_param_action;
       public         dotcmsdbuser    false    333            +           1259    30380    workflow_idx_action_step    INDEX     W   CREATE INDEX workflow_idx_action_step ON public.workflow_action USING btree (step_id);
 ,   DROP INDEX public.workflow_idx_action_step;
       public         dotcmsdbuser    false    331            2           1259    30425    workflow_idx_scheme_structure_2    INDEX     v   CREATE UNIQUE INDEX workflow_idx_scheme_structure_2 ON public.workflow_scheme_x_structure USING btree (structure_id);
 3   DROP INDEX public.workflow_idx_scheme_structure_2;
       public         dotcmsdbuser    false    334            &           1259    30350    workflow_idx_step_scheme    INDEX     W   CREATE INDEX workflow_idx_step_scheme ON public.workflow_step USING btree (scheme_id);
 ,   DROP INDEX public.workflow_idx_step_scheme;
       public         dotcmsdbuser    false    330            �           2620    30182 %   identifier check_child_assets_trigger    TRIGGER     �   CREATE TRIGGER check_child_assets_trigger BEFORE DELETE ON public.identifier FOR EACH ROW EXECUTE PROCEDURE public.check_child_assets();
 >   DROP TRIGGER check_child_assets_trigger ON public.identifier;
       public       dotcmsdbuser    false    390    261            �           2620    30176 /   dot_containers container_versions_check_trigger    TRIGGER     �   CREATE TRIGGER container_versions_check_trigger AFTER DELETE ON public.dot_containers FOR EACH ROW EXECUTE PROCEDURE public.container_versions_check();
 H   DROP TRIGGER container_versions_check_trigger ON public.dot_containers;
       public       dotcmsdbuser    false    373    277            �           2620    30172 )   contentlet content_versions_check_trigger    TRIGGER     �   CREATE TRIGGER content_versions_check_trigger AFTER DELETE ON public.contentlet FOR EACH ROW EXECUTE PROCEDURE public.content_versions_check();
 B   DROP TRIGGER content_versions_check_trigger ON public.contentlet;
       public       dotcmsdbuser    false    371    249            �           2620    30217 &   folder folder_identifier_check_trigger    TRIGGER     �   CREATE TRIGGER folder_identifier_check_trigger AFTER DELETE ON public.folder FOR EACH ROW EXECUTE PROCEDURE public.folder_identifier_check();
 ?   DROP TRIGGER folder_identifier_check_trigger ON public.folder;
       public       dotcmsdbuser    false    286    391            �           2620    30180 )   identifier identifier_parent_path_trigger    TRIGGER     �   CREATE TRIGGER identifier_parent_path_trigger BEFORE INSERT OR UPDATE ON public.identifier FOR EACH ROW EXECUTE PROCEDURE public.identifier_parent_path_check();
 B   DROP TRIGGER identifier_parent_path_trigger ON public.identifier;
       public       dotcmsdbuser    false    389    261            �           2620    30174 !   links link_versions_check_trigger    TRIGGER     �   CREATE TRIGGER link_versions_check_trigger AFTER DELETE ON public.links FOR EACH ROW EXECUTE PROCEDURE public.link_versions_check();
 :   DROP TRIGGER link_versions_check_trigger ON public.links;
       public       dotcmsdbuser    false    281    372            �           2620    30231 #   folder rename_folder_assets_trigger    TRIGGER     �   CREATE TRIGGER rename_folder_assets_trigger AFTER UPDATE ON public.folder FOR EACH ROW EXECUTE PROCEDURE public.rename_folder_and_assets();
 <   DROP TRIGGER rename_folder_assets_trigger ON public.folder;
       public       dotcmsdbuser    false    393    286            �           2620    30148 1   identifier required_identifier_host_inode_trigger    TRIGGER     �   CREATE TRIGGER required_identifier_host_inode_trigger BEFORE INSERT OR UPDATE ON public.identifier FOR EACH ROW EXECUTE PROCEDURE public.identifier_host_inode_check();
 J   DROP TRIGGER required_identifier_host_inode_trigger ON public.identifier;
       public       dotcmsdbuser    false    370    261            �           2620    30169 '   structure structure_host_folder_trigger    TRIGGER     �   CREATE TRIGGER structure_host_folder_trigger BEFORE INSERT OR UPDATE ON public.structure FOR EACH ROW EXECUTE PROCEDURE public.structure_host_folder_check();
 @   DROP TRIGGER structure_host_folder_trigger ON public.structure;
       public       dotcmsdbuser    false    387    245            �           2620    30178 (   template template_versions_check_trigger    TRIGGER     �   CREATE TRIGGER template_versions_check_trigger AFTER DELETE ON public.template FOR EACH ROW EXECUTE PROCEDURE public.template_versions_check();
 A   DROP TRIGGER template_versions_check_trigger ON public.template;
       public       dotcmsdbuser    false    374    243            �           2606    30608 :   cluster_server_uptime cluster_server_uptime_server_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cluster_server_uptime
    ADD CONSTRAINT cluster_server_uptime_server_id_fkey FOREIGN KEY (server_id) REFERENCES public.cluster_server(server_id);
 d   ALTER TABLE ONLY public.cluster_server_uptime DROP CONSTRAINT cluster_server_uptime_server_id_fkey;
       public       dotcmsdbuser    false    4182    349    348            �           2606    30119 '   dot_containers containers_identifier_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.dot_containers
    ADD CONSTRAINT containers_identifier_fk FOREIGN KEY (identifier) REFERENCES public.identifier(id);
 Q   ALTER TABLE ONLY public.dot_containers DROP CONSTRAINT containers_identifier_fk;
       public       dotcmsdbuser    false    261    3978    277            �           2606    30129     contentlet content_identifier_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.contentlet
    ADD CONSTRAINT content_identifier_fk FOREIGN KEY (identifier) REFERENCES public.identifier(id);
 J   ALTER TABLE ONLY public.contentlet DROP CONSTRAINT content_identifier_fk;
       public       dotcmsdbuser    false    3978    249    261            �           2606    29900 "   report_parameter fk22da125e5fb51eb    FK CONSTRAINT     �   ALTER TABLE ONLY public.report_parameter
    ADD CONSTRAINT fk22da125e5fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 L   ALTER TABLE ONLY public.report_parameter DROP CONSTRAINT fk22da125e5fb51eb;
       public       dotcmsdbuser    false    295    4107    290            �           2606    29795    category fk302bcfe5fb51eb    FK CONSTRAINT     y   ALTER TABLE ONLY public.category
    ADD CONSTRAINT fk302bcfe5fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 C   ALTER TABLE ONLY public.category DROP CONSTRAINT fk302bcfe5fb51eb;
       public       dotcmsdbuser    false    4107    295    254            �           2606    29742    recipient fk30e172195fb51eb    FK CONSTRAINT     {   ALTER TABLE ONLY public.recipient
    ADD CONSTRAINT fk30e172195fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 E   ALTER TABLE ONLY public.recipient DROP CONSTRAINT fk30e172195fb51eb;
       public       dotcmsdbuser    false    295    237    4107            �           2606    29788    report_asset fk3765ec255fb51eb    FK CONSTRAINT     ~   ALTER TABLE ONLY public.report_asset
    ADD CONSTRAINT fk3765ec255fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 H   ALTER TABLE ONLY public.report_asset DROP CONSTRAINT fk3765ec255fb51eb;
       public       dotcmsdbuser    false    295    252    4107            �           2606    29839 -   dashboard_user_preferences fk496242cfd12c0c3b    FK CONSTRAINT     �   ALTER TABLE ONLY public.dashboard_user_preferences
    ADD CONSTRAINT fk496242cfd12c0c3b FOREIGN KEY (summary_404_id) REFERENCES public.analytic_summary_404(id);
 W   ALTER TABLE ONLY public.dashboard_user_preferences DROP CONSTRAINT fk496242cfd12c0c3b;
       public       dotcmsdbuser    false    3940    250    273            �           2606    29765 +   analytic_summary_content fk53cb4f2eed30e054    FK CONSTRAINT     �   ALTER TABLE ONLY public.analytic_summary_content
    ADD CONSTRAINT fk53cb4f2eed30e054 FOREIGN KEY (summary_id) REFERENCES public.analytic_summary(id);
 U   ALTER TABLE ONLY public.analytic_summary_content DROP CONSTRAINT fk53cb4f2eed30e054;
       public       dotcmsdbuser    false    3892    241    244            �           2606    29826    click fk5a5c5885fb51eb    FK CONSTRAINT     v   ALTER TABLE ONLY public.click
    ADD CONSTRAINT fk5a5c5885fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 @   ALTER TABLE ONLY public.click DROP CONSTRAINT fk5a5c5885fb51eb;
       public       dotcmsdbuser    false    295    4107    266            �           2606    29853 +   analytic_summary_referer fk5bc0f3e2ed30e054    FK CONSTRAINT     �   ALTER TABLE ONLY public.analytic_summary_referer
    ADD CONSTRAINT fk5bc0f3e2ed30e054 FOREIGN KEY (summary_id) REFERENCES public.analytic_summary(id);
 U   ALTER TABLE ONLY public.analytic_summary_referer DROP CONSTRAINT fk5bc0f3e2ed30e054;
       public       dotcmsdbuser    false    241    3892    276            �           2606    29879    field fk5cea0fa5fb51eb    FK CONSTRAINT     v   ALTER TABLE ONLY public.field
    ADD CONSTRAINT fk5cea0fa5fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 @   ALTER TABLE ONLY public.field DROP CONSTRAINT fk5cea0fa5fb51eb;
       public       dotcmsdbuser    false    295    284    4107            �           2606    29868    links fk6234fb95fb51eb    FK CONSTRAINT     v   ALTER TABLE ONLY public.links
    ADD CONSTRAINT fk6234fb95fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 @   ALTER TABLE ONLY public.links DROP CONSTRAINT fk6234fb95fb51eb;
       public       dotcmsdbuser    false    281    295    4107            �           2606    29783 '   analytic_summary_404 fk7050866db7b46300    FK CONSTRAINT     �   ALTER TABLE ONLY public.analytic_summary_404
    ADD CONSTRAINT fk7050866db7b46300 FOREIGN KEY (summary_period_id) REFERENCES public.analytic_summary_period(id);
 Q   ALTER TABLE ONLY public.analytic_summary_404 DROP CONSTRAINT fk7050866db7b46300;
       public       dotcmsdbuser    false    239    250    3877            �           2606    29873    user_proxy fk7327d4fa5fb51eb    FK CONSTRAINT     |   ALTER TABLE ONLY public.user_proxy
    ADD CONSTRAINT fk7327d4fa5fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 F   ALTER TABLE ONLY public.user_proxy DROP CONSTRAINT fk7327d4fa5fb51eb;
       public       dotcmsdbuser    false    295    282    4107            �           2606    29734    mailing_list fk7bc2cd925fb51eb    FK CONSTRAINT     ~   ALTER TABLE ONLY public.mailing_list
    ADD CONSTRAINT fk7bc2cd925fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 H   ALTER TABLE ONLY public.mailing_list DROP CONSTRAINT fk7bc2cd925fb51eb;
       public       dotcmsdbuser    false    4107    236    295            �           2606    29770    structure fk89d2d735fb51eb    FK CONSTRAINT     z   ALTER TABLE ONLY public.structure
    ADD CONSTRAINT fk89d2d735fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 D   ALTER TABLE ONLY public.structure DROP CONSTRAINT fk89d2d735fb51eb;
       public       dotcmsdbuser    false    4107    245    295            �           2606    29858    dot_containers fk8a844125fb51eb    FK CONSTRAINT        ALTER TABLE ONLY public.dot_containers
    ADD CONSTRAINT fk8a844125fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 I   ALTER TABLE ONLY public.dot_containers DROP CONSTRAINT fk8a844125fb51eb;
       public       dotcmsdbuser    false    295    277    4107            �           2606    29755 "   analytic_summary fk9e1a7f4b7b46300    FK CONSTRAINT     �   ALTER TABLE ONLY public.analytic_summary
    ADD CONSTRAINT fk9e1a7f4b7b46300 FOREIGN KEY (summary_period_id) REFERENCES public.analytic_summary_period(id);
 L   ALTER TABLE ONLY public.analytic_summary DROP CONSTRAINT fk9e1a7f4b7b46300;
       public       dotcmsdbuser    false    241    239    3877            �           2606    29802 *   analytic_summary_visits fk9eac9733b7b46300    FK CONSTRAINT     �   ALTER TABLE ONLY public.analytic_summary_visits
    ADD CONSTRAINT fk9eac9733b7b46300 FOREIGN KEY (summary_period_id) REFERENCES public.analytic_summary_period(id);
 T   ALTER TABLE ONLY public.analytic_summary_visits DROP CONSTRAINT fk9eac9733b7b46300;
       public       dotcmsdbuser    false    256    3877    239            �           2606    30496    broken_link fk_brokenl_content    FK CONSTRAINT     �   ALTER TABLE ONLY public.broken_link
    ADD CONSTRAINT fk_brokenl_content FOREIGN KEY (inode) REFERENCES public.contentlet(inode) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.broken_link DROP CONSTRAINT fk_brokenl_content;
       public       dotcmsdbuser    false    337    249    3935            �           2606    30501    broken_link fk_brokenl_field    FK CONSTRAINT     �   ALTER TABLE ONLY public.broken_link
    ADD CONSTRAINT fk_brokenl_field FOREIGN KEY (field) REFERENCES public.field(inode) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.broken_link DROP CONSTRAINT fk_brokenl_field;
       public       dotcmsdbuser    false    337    284    4064            �           2606    30565 *   publishing_bundle_environment fk_bundle_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.publishing_bundle_environment
    ADD CONSTRAINT fk_bundle_id FOREIGN KEY (bundle_id) REFERENCES public.publishing_bundle(id);
 T   ALTER TABLE ONLY public.publishing_bundle_environment DROP CONSTRAINT fk_bundle_id;
       public       dotcmsdbuser    false    345    344    4173            �           2606    30598    cluster_server fk_cluster_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.cluster_server
    ADD CONSTRAINT fk_cluster_id FOREIGN KEY (cluster_id) REFERENCES public.dot_cluster(cluster_id);
 F   ALTER TABLE ONLY public.cluster_server DROP CONSTRAINT fk_cluster_id;
       public       dotcmsdbuser    false    348    347    4180            �           2606    30613 *   cluster_server_uptime fk_cluster_server_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.cluster_server_uptime
    ADD CONSTRAINT fk_cluster_server_id FOREIGN KEY (server_id) REFERENCES public.cluster_server(server_id);
 T   ALTER TABLE ONLY public.cluster_server_uptime DROP CONSTRAINT fk_cluster_server_id;
       public       dotcmsdbuser    false    349    348    4182            �           2606    30730    cms_roles_ir fk_cms_roles_ir_ep    FK CONSTRAINT     �   ALTER TABLE ONLY public.cms_roles_ir
    ADD CONSTRAINT fk_cms_roles_ir_ep FOREIGN KEY (endpoint_id) REFERENCES public.publishing_end_point(id);
 I   ALTER TABLE ONLY public.cms_roles_ir DROP CONSTRAINT fk_cms_roles_ir_ep;
       public       dotcmsdbuser    false    357    4163    341            �           2606    30446 +   contentlet_version_info fk_con_ver_lockedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.contentlet_version_info
    ADD CONSTRAINT fk_con_ver_lockedby FOREIGN KEY (locked_by) REFERENCES public.user_(userid);
 U   ALTER TABLE ONLY public.contentlet_version_info DROP CONSTRAINT fk_con_ver_lockedby;
       public       dotcmsdbuser    false    231    199    3770            �           2606    30224 #   template_containers fk_container_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.template_containers
    ADD CONSTRAINT fk_container_id FOREIGN KEY (container_id) REFERENCES public.identifier(id);
 M   ALTER TABLE ONLY public.template_containers DROP CONSTRAINT fk_container_id;
       public       dotcmsdbuser    false    3978    293    261            �           2606    30238 ;   container_version_info fk_container_version_info_identifier    FK CONSTRAINT     �   ALTER TABLE ONLY public.container_version_info
    ADD CONSTRAINT fk_container_version_info_identifier FOREIGN KEY (identifier) REFERENCES public.identifier(id);
 e   ALTER TABLE ONLY public.container_version_info DROP CONSTRAINT fk_container_version_info_identifier;
       public       dotcmsdbuser    false    261    233    3978            �           2606    30278 5   container_version_info fk_container_version_info_live    FK CONSTRAINT     �   ALTER TABLE ONLY public.container_version_info
    ADD CONSTRAINT fk_container_version_info_live FOREIGN KEY (live_inode) REFERENCES public.dot_containers(inode);
 _   ALTER TABLE ONLY public.container_version_info DROP CONSTRAINT fk_container_version_info_live;
       public       dotcmsdbuser    false    277    4047    233            �           2606    30258 8   container_version_info fk_container_version_info_working    FK CONSTRAINT     �   ALTER TABLE ONLY public.container_version_info
    ADD CONSTRAINT fk_container_version_info_working FOREIGN KEY (working_inode) REFERENCES public.dot_containers(inode);
 b   ALTER TABLE ONLY public.container_version_info DROP CONSTRAINT fk_container_version_info_working;
       public       dotcmsdbuser    false    233    4047    277            �           2606    30318    contentlet fk_contentlet_lang    FK CONSTRAINT     �   ALTER TABLE ONLY public.contentlet
    ADD CONSTRAINT fk_contentlet_lang FOREIGN KEY (language_id) REFERENCES public.language(id);
 G   ALTER TABLE ONLY public.contentlet DROP CONSTRAINT fk_contentlet_lang;
       public       dotcmsdbuser    false    259    3972    249            �           2606    30233 =   contentlet_version_info fk_contentlet_version_info_identifier    FK CONSTRAINT     �   ALTER TABLE ONLY public.contentlet_version_info
    ADD CONSTRAINT fk_contentlet_version_info_identifier FOREIGN KEY (identifier) REFERENCES public.identifier(id) ON DELETE CASCADE;
 g   ALTER TABLE ONLY public.contentlet_version_info DROP CONSTRAINT fk_contentlet_version_info_identifier;
       public       dotcmsdbuser    false    261    231    3978            �           2606    30293 7   contentlet_version_info fk_contentlet_version_info_lang    FK CONSTRAINT     �   ALTER TABLE ONLY public.contentlet_version_info
    ADD CONSTRAINT fk_contentlet_version_info_lang FOREIGN KEY (lang) REFERENCES public.language(id);
 a   ALTER TABLE ONLY public.contentlet_version_info DROP CONSTRAINT fk_contentlet_version_info_lang;
       public       dotcmsdbuser    false    3972    231    259            �           2606    30273 7   contentlet_version_info fk_contentlet_version_info_live    FK CONSTRAINT     �   ALTER TABLE ONLY public.contentlet_version_info
    ADD CONSTRAINT fk_contentlet_version_info_live FOREIGN KEY (live_inode) REFERENCES public.contentlet(inode);
 a   ALTER TABLE ONLY public.contentlet_version_info DROP CONSTRAINT fk_contentlet_version_info_live;
       public       dotcmsdbuser    false    249    231    3935            �           2606    30253 :   contentlet_version_info fk_contentlet_version_info_working    FK CONSTRAINT     �   ALTER TABLE ONLY public.contentlet_version_info
    ADD CONSTRAINT fk_contentlet_version_info_working FOREIGN KEY (working_inode) REFERENCES public.contentlet(inode);
 d   ALTER TABLE ONLY public.contentlet_version_info DROP CONSTRAINT fk_contentlet_version_info_working;
       public       dotcmsdbuser    false    231    249    3935            �           2606    30648 '   container_structures fk_cs_container_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.container_structures
    ADD CONSTRAINT fk_cs_container_id FOREIGN KEY (container_id) REFERENCES public.identifier(id);
 Q   ALTER TABLE ONLY public.container_structures DROP CONSTRAINT fk_cs_container_id;
       public       dotcmsdbuser    false    247    261    3978            �           2606    30653     container_structures fk_cs_inode    FK CONSTRAINT     �   ALTER TABLE ONLY public.container_structures
    ADD CONSTRAINT fk_cs_inode FOREIGN KEY (container_inode) REFERENCES public.inode(inode);
 J   ALTER TABLE ONLY public.container_structures DROP CONSTRAINT fk_cs_inode;
       public       dotcmsdbuser    false    247    295    4107            �           2606    30570 /   publishing_bundle_environment fk_environment_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.publishing_bundle_environment
    ADD CONSTRAINT fk_environment_id FOREIGN KEY (environment_id) REFERENCES public.publishing_environment(id);
 Y   ALTER TABLE ONLY public.publishing_bundle_environment DROP CONSTRAINT fk_environment_id;
       public       dotcmsdbuser    false    345    342    4169            �           2606    30441 "   workflow_step fk_escalation_action    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_step
    ADD CONSTRAINT fk_escalation_action FOREIGN KEY (escalation_action) REFERENCES public.workflow_action(id);
 L   ALTER TABLE ONLY public.workflow_step DROP CONSTRAINT fk_escalation_action;
       public       dotcmsdbuser    false    330    331    4138            �           2606    30725    fileassets_ir fk_file_ir_ep    FK CONSTRAINT     �   ALTER TABLE ONLY public.fileassets_ir
    ADD CONSTRAINT fk_file_ir_ep FOREIGN KEY (endpoint_id) REFERENCES public.publishing_end_point(id);
 E   ALTER TABLE ONLY public.fileassets_ir DROP CONSTRAINT fk_file_ir_ep;
       public       dotcmsdbuser    false    4163    341    356            �           2606    30298 $   folder fk_folder_file_structure_type    FK CONSTRAINT     �   ALTER TABLE ONLY public.folder
    ADD CONSTRAINT fk_folder_file_structure_type FOREIGN KEY (default_file_type) REFERENCES public.structure(inode);
 N   ALTER TABLE ONLY public.folder DROP CONSTRAINT fk_folder_file_structure_type;
       public       dotcmsdbuser    false    3912    245    286            �           2606    30705    folders_ir fk_folder_ir_ep    FK CONSTRAINT     �   ALTER TABLE ONLY public.folders_ir
    ADD CONSTRAINT fk_folder_ir_ep FOREIGN KEY (endpoint_id) REFERENCES public.publishing_end_point(id);
 D   ALTER TABLE ONLY public.folders_ir DROP CONSTRAINT fk_folder_ir_ep;
       public       dotcmsdbuser    false    352    341    4163            �           2606    30461 +   link_version_info fk_link_ver_info_lockedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.link_version_info
    ADD CONSTRAINT fk_link_ver_info_lockedby FOREIGN KEY (locked_by) REFERENCES public.user_(userid);
 U   ALTER TABLE ONLY public.link_version_info DROP CONSTRAINT fk_link_ver_info_lockedby;
       public       dotcmsdbuser    false    292    199    3770            �           2606    30248 1   link_version_info fk_link_version_info_identifier    FK CONSTRAINT     �   ALTER TABLE ONLY public.link_version_info
    ADD CONSTRAINT fk_link_version_info_identifier FOREIGN KEY (identifier) REFERENCES public.identifier(id);
 [   ALTER TABLE ONLY public.link_version_info DROP CONSTRAINT fk_link_version_info_identifier;
       public       dotcmsdbuser    false    261    3978    292            �           2606    30288 +   link_version_info fk_link_version_info_live    FK CONSTRAINT     �   ALTER TABLE ONLY public.link_version_info
    ADD CONSTRAINT fk_link_version_info_live FOREIGN KEY (live_inode) REFERENCES public.links(inode);
 U   ALTER TABLE ONLY public.link_version_info DROP CONSTRAINT fk_link_version_info_live;
       public       dotcmsdbuser    false    292    4056    281            �           2606    30268 .   link_version_info fk_link_version_info_working    FK CONSTRAINT     �   ALTER TABLE ONLY public.link_version_info
    ADD CONSTRAINT fk_link_version_info_working FOREIGN KEY (working_inode) REFERENCES public.links(inode);
 X   ALTER TABLE ONLY public.link_version_info DROP CONSTRAINT fk_link_version_info_working;
       public       dotcmsdbuser    false    292    4056    281            �           2606    30720    htmlpages_ir fk_page_ir_ep    FK CONSTRAINT     �   ALTER TABLE ONLY public.htmlpages_ir
    ADD CONSTRAINT fk_page_ir_ep FOREIGN KEY (endpoint_id) REFERENCES public.publishing_end_point(id);
 D   ALTER TABLE ONLY public.htmlpages_ir DROP CONSTRAINT fk_page_ir_ep;
       public       dotcmsdbuser    false    341    355    4163            �           2606    29982 (   chain_state_parameter fk_parameter_state    FK CONSTRAINT     �   ALTER TABLE ONLY public.chain_state_parameter
    ADD CONSTRAINT fk_parameter_state FOREIGN KEY (chain_state_id) REFERENCES public.chain_state(id);
 R   ALTER TABLE ONLY public.chain_state_parameter DROP CONSTRAINT fk_parameter_state;
       public       dotcmsdbuser    false    4026    271    283            �           2606    30029 )   plugin_property fk_plugin_plugin_property    FK CONSTRAINT     �   ALTER TABLE ONLY public.plugin_property
    ADD CONSTRAINT fk_plugin_plugin_property FOREIGN KEY (plugin_id) REFERENCES public.plugin(id);
 S   ALTER TABLE ONLY public.plugin_property DROP CONSTRAINT fk_plugin_plugin_property;
       public       dotcmsdbuser    false    3862    321    235            �           2606    30555 ,   publishing_bundle fk_publishing_bundle_owner    FK CONSTRAINT     �   ALTER TABLE ONLY public.publishing_bundle
    ADD CONSTRAINT fk_publishing_bundle_owner FOREIGN KEY (owner) REFERENCES public.user_(userid);
 V   ALTER TABLE ONLY public.publishing_bundle DROP CONSTRAINT fk_publishing_bundle_owner;
       public       dotcmsdbuser    false    344    199    3770            �           2606    30715    schemes_ir fk_scheme_ir_ep    FK CONSTRAINT     �   ALTER TABLE ONLY public.schemes_ir
    ADD CONSTRAINT fk_scheme_ir_ep FOREIGN KEY (endpoint_id) REFERENCES public.publishing_end_point(id);
 D   ALTER TABLE ONLY public.schemes_ir DROP CONSTRAINT fk_scheme_ir_ep;
       public       dotcmsdbuser    false    354    4163    341            �           2606    29972    chain_state fk_state_chain    FK CONSTRAINT     z   ALTER TABLE ONLY public.chain_state
    ADD CONSTRAINT fk_state_chain FOREIGN KEY (chain_id) REFERENCES public.chain(id);
 D   ALTER TABLE ONLY public.chain_state DROP CONSTRAINT fk_state_chain;
       public       dotcmsdbuser    false    271    291    4093            �           2606    29977    chain_state fk_state_code    FK CONSTRAINT     �   ALTER TABLE ONLY public.chain_state
    ADD CONSTRAINT fk_state_code FOREIGN KEY (link_code_id) REFERENCES public.chain_link_code(id);
 C   ALTER TABLE ONLY public.chain_state DROP CONSTRAINT fk_state_code;
       public       dotcmsdbuser    false    255    3957    271            �           2606    30159    structure fk_structure_folder    FK CONSTRAINT        ALTER TABLE ONLY public.structure
    ADD CONSTRAINT fk_structure_folder FOREIGN KEY (folder) REFERENCES public.folder(inode);
 G   ALTER TABLE ONLY public.structure DROP CONSTRAINT fk_structure_folder;
       public       dotcmsdbuser    false    4073    245    286            �           2606    30183    structure fk_structure_host    FK CONSTRAINT     |   ALTER TABLE ONLY public.structure
    ADD CONSTRAINT fk_structure_host FOREIGN KEY (host) REFERENCES public.identifier(id);
 E   ALTER TABLE ONLY public.structure DROP CONSTRAINT fk_structure_host;
       public       dotcmsdbuser    false    245    3978    261            �           2606    29992    contentlet fk_structure_inode    FK CONSTRAINT     �   ALTER TABLE ONLY public.contentlet
    ADD CONSTRAINT fk_structure_inode FOREIGN KEY (structure_inode) REFERENCES public.structure(inode);
 G   ALTER TABLE ONLY public.contentlet DROP CONSTRAINT fk_structure_inode;
       public       dotcmsdbuser    false    3912    249    245            �           2606    30710     structures_ir fk_structure_ir_ep    FK CONSTRAINT     �   ALTER TABLE ONLY public.structures_ir
    ADD CONSTRAINT fk_structure_ir_ep FOREIGN KEY (endpoint_id) REFERENCES public.publishing_end_point(id);
 J   ALTER TABLE ONLY public.structures_ir DROP CONSTRAINT fk_structure_ir_ep;
       public       dotcmsdbuser    false    341    4163    353            �           2606    30469    tag_inode fk_tag_inode_tagid    FK CONSTRAINT     |   ALTER TABLE ONLY public.tag_inode
    ADD CONSTRAINT fk_tag_inode_tagid FOREIGN KEY (tag_id) REFERENCES public.tag(tag_id);
 F   ALTER TABLE ONLY public.tag_inode DROP CONSTRAINT fk_tag_inode_tagid;
       public       dotcmsdbuser    false    265    228    3829            �           2606    30451 2   container_version_info fk_tainer_ver_info_lockedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.container_version_info
    ADD CONSTRAINT fk_tainer_ver_info_lockedby FOREIGN KEY (locked_by) REFERENCES public.user_(userid);
 \   ALTER TABLE ONLY public.container_version_info DROP CONSTRAINT fk_tainer_ver_info_lockedby;
       public       dotcmsdbuser    false    233    199    3770            �           2606    30456 /   template_version_info fk_temp_ver_info_lockedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.template_version_info
    ADD CONSTRAINT fk_temp_ver_info_lockedby FOREIGN KEY (locked_by) REFERENCES public.user_(userid);
 Y   ALTER TABLE ONLY public.template_version_info DROP CONSTRAINT fk_temp_ver_info_lockedby;
       public       dotcmsdbuser    false    257    199    3770            �           2606    30219 "   template_containers fk_template_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.template_containers
    ADD CONSTRAINT fk_template_id FOREIGN KEY (template_id) REFERENCES public.identifier(id);
 L   ALTER TABLE ONLY public.template_containers DROP CONSTRAINT fk_template_id;
       public       dotcmsdbuser    false    261    3978    293            �           2606    30243 9   template_version_info fk_template_version_info_identifier    FK CONSTRAINT     �   ALTER TABLE ONLY public.template_version_info
    ADD CONSTRAINT fk_template_version_info_identifier FOREIGN KEY (identifier) REFERENCES public.identifier(id);
 c   ALTER TABLE ONLY public.template_version_info DROP CONSTRAINT fk_template_version_info_identifier;
       public       dotcmsdbuser    false    3978    261    257            �           2606    30283 3   template_version_info fk_template_version_info_live    FK CONSTRAINT     �   ALTER TABLE ONLY public.template_version_info
    ADD CONSTRAINT fk_template_version_info_live FOREIGN KEY (live_inode) REFERENCES public.template(inode);
 ]   ALTER TABLE ONLY public.template_version_info DROP CONSTRAINT fk_template_version_info_live;
       public       dotcmsdbuser    false    243    257    3905            �           2606    30263 6   template_version_info fk_template_version_info_working    FK CONSTRAINT     �   ALTER TABLE ONLY public.template_version_info
    ADD CONSTRAINT fk_template_version_info_working FOREIGN KEY (working_inode) REFERENCES public.template(inode);
 `   ALTER TABLE ONLY public.template_version_info DROP CONSTRAINT fk_template_version_info_working;
       public       dotcmsdbuser    false    3905    243    257            �           2606    30196 !   dot_containers fk_user_containers    FK CONSTRAINT     �   ALTER TABLE ONLY public.dot_containers
    ADD CONSTRAINT fk_user_containers FOREIGN KEY (mod_user) REFERENCES public.user_(userid);
 K   ALTER TABLE ONLY public.dot_containers DROP CONSTRAINT fk_user_containers;
       public       dotcmsdbuser    false    277    3770    199            �           2606    30191    contentlet fk_user_contentlet    FK CONSTRAINT     �   ALTER TABLE ONLY public.contentlet
    ADD CONSTRAINT fk_user_contentlet FOREIGN KEY (mod_user) REFERENCES public.user_(userid);
 G   ALTER TABLE ONLY public.contentlet DROP CONSTRAINT fk_user_contentlet;
       public       dotcmsdbuser    false    199    249    3770            �           2606    30206    links fk_user_links    FK CONSTRAINT     w   ALTER TABLE ONLY public.links
    ADD CONSTRAINT fk_user_links FOREIGN KEY (mod_user) REFERENCES public.user_(userid);
 =   ALTER TABLE ONLY public.links DROP CONSTRAINT fk_user_links;
       public       dotcmsdbuser    false    281    3770    199            �           2606    30201    template fk_user_template    FK CONSTRAINT     }   ALTER TABLE ONLY public.template
    ADD CONSTRAINT fk_user_template FOREIGN KEY (mod_user) REFERENCES public.user_(userid);
 C   ALTER TABLE ONLY public.template DROP CONSTRAINT fk_user_template;
       public       dotcmsdbuser    false    3770    243    199            �           2606    30431     workflow_task fk_workflow_assign    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_task
    ADD CONSTRAINT fk_workflow_assign FOREIGN KEY (assigned_to) REFERENCES public.cms_role(id);
 J   ALTER TABLE ONLY public.workflow_task DROP CONSTRAINT fk_workflow_assign;
       public       dotcmsdbuser    false    264    246    3920            �           2606    30303 !   workflowtask_files fk_workflow_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflowtask_files
    ADD CONSTRAINT fk_workflow_id FOREIGN KEY (workflowtask_id) REFERENCES public.workflow_task(id);
 K   ALTER TABLE ONLY public.workflowtask_files DROP CONSTRAINT fk_workflow_id;
       public       dotcmsdbuser    false    4003    264    275            �           2606    30436    workflow_task fk_workflow_step    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_task
    ADD CONSTRAINT fk_workflow_step FOREIGN KEY (status) REFERENCES public.workflow_step(id);
 H   ALTER TABLE ONLY public.workflow_task DROP CONSTRAINT fk_workflow_step;
       public       dotcmsdbuser    false    264    330    4136            �           2606    30426 $   workflow_task fk_workflow_task_asset    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_task
    ADD CONSTRAINT fk_workflow_task_asset FOREIGN KEY (webasset) REFERENCES public.identifier(id);
 N   ALTER TABLE ONLY public.workflow_task DROP CONSTRAINT fk_workflow_task_asset;
       public       dotcmsdbuser    false    261    3978    264            �           2606    29720 )   analytic_summary_pages fka1ad33b9ed30e054    FK CONSTRAINT     �   ALTER TABLE ONLY public.analytic_summary_pages
    ADD CONSTRAINT fka1ad33b9ed30e054 FOREIGN KEY (summary_id) REFERENCES public.analytic_summary(id);
 S   ALTER TABLE ONLY public.analytic_summary_pages DROP CONSTRAINT fka1ad33b9ed30e054;
       public       dotcmsdbuser    false    227    3892    241            �           2606    29760    template fkb13acc7a5fb51eb    FK CONSTRAINT     z   ALTER TABLE ONLY public.template
    ADD CONSTRAINT fkb13acc7a5fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 D   ALTER TABLE ONLY public.template DROP CONSTRAINT fkb13acc7a5fb51eb;
       public       dotcmsdbuser    false    295    4107    243            �           2606    29892    folder fkb45d1c6e5fb51eb    FK CONSTRAINT     x   ALTER TABLE ONLY public.folder
    ADD CONSTRAINT fkb45d1c6e5fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 B   ALTER TABLE ONLY public.folder DROP CONSTRAINT fkb45d1c6e5fb51eb;
       public       dotcmsdbuser    false    286    4107    295            �           2606    29863    communication fkc24acfd65fb51eb    FK CONSTRAINT        ALTER TABLE ONLY public.communication
    ADD CONSTRAINT fkc24acfd65fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 I   ALTER TABLE ONLY public.communication DROP CONSTRAINT fkc24acfd65fb51eb;
       public       dotcmsdbuser    false    278    295    4107            �           2606    30102 +   cms_layouts_portlets fkcms_layouts_portlets    FK CONSTRAINT     �   ALTER TABLE ONLY public.cms_layouts_portlets
    ADD CONSTRAINT fkcms_layouts_portlets FOREIGN KEY (layout_id) REFERENCES public.cms_layout(id);
 U   ALTER TABLE ONLY public.cms_layouts_portlets DROP CONSTRAINT fkcms_layouts_portlets;
       public       dotcmsdbuser    false    288    4083    251            �           2606    30079    cms_role fkcms_role_parent    FK CONSTRAINT     {   ALTER TABLE ONLY public.cms_role
    ADD CONSTRAINT fkcms_role_parent FOREIGN KEY (parent) REFERENCES public.cms_role(id);
 D   ALTER TABLE ONLY public.cms_role DROP CONSTRAINT fkcms_role_parent;
       public       dotcmsdbuser    false    246    246    3920            �           2606    29726    user_comments fkdf1b37e85fb51eb    FK CONSTRAINT        ALTER TABLE ONLY public.user_comments
    ADD CONSTRAINT fkdf1b37e85fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 I   ALTER TABLE ONLY public.user_comments DROP CONSTRAINT fkdf1b37e85fb51eb;
       public       dotcmsdbuser    false    295    4107    229            �           2606    29905    user_filter fke042126c5fb51eb    FK CONSTRAINT     }   ALTER TABLE ONLY public.user_filter
    ADD CONSTRAINT fke042126c5fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 G   ALTER TABLE ONLY public.user_filter DROP CONSTRAINT fke042126c5fb51eb;
       public       dotcmsdbuser    false    295    4107    294            �           2606    29886    relationship fkf06476385fb51eb    FK CONSTRAINT     ~   ALTER TABLE ONLY public.relationship
    ADD CONSTRAINT fkf06476385fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 H   ALTER TABLE ONLY public.relationship DROP CONSTRAINT fkf06476385fb51eb;
       public       dotcmsdbuser    false    295    285    4107            �           2606    29848    campaign fkf7a901105fb51eb    FK CONSTRAINT     z   ALTER TABLE ONLY public.campaign
    ADD CONSTRAINT fkf7a901105fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 D   ALTER TABLE ONLY public.campaign DROP CONSTRAINT fkf7a901105fb51eb;
       public       dotcmsdbuser    false    274    295    4107            �           2606    29777    contentlet fkfc4ef025fb51eb    FK CONSTRAINT     {   ALTER TABLE ONLY public.contentlet
    ADD CONSTRAINT fkfc4ef025fb51eb FOREIGN KEY (inode) REFERENCES public.inode(inode);
 E   ALTER TABLE ONLY public.contentlet DROP CONSTRAINT fkfc4ef025fb51eb;
       public       dotcmsdbuser    false    4107    249    295            �           2606    30107 &   layouts_cms_roles fklayouts_cms_roles1    FK CONSTRAINT     �   ALTER TABLE ONLY public.layouts_cms_roles
    ADD CONSTRAINT fklayouts_cms_roles1 FOREIGN KEY (role_id) REFERENCES public.cms_role(id);
 P   ALTER TABLE ONLY public.layouts_cms_roles DROP CONSTRAINT fklayouts_cms_roles1;
       public       dotcmsdbuser    false    3920    268    246            �           2606    30112 &   layouts_cms_roles fklayouts_cms_roles2    FK CONSTRAINT     �   ALTER TABLE ONLY public.layouts_cms_roles
    ADD CONSTRAINT fklayouts_cms_roles2 FOREIGN KEY (layout_id) REFERENCES public.cms_layout(id);
 P   ALTER TABLE ONLY public.layouts_cms_roles DROP CONSTRAINT fklayouts_cms_roles2;
       public       dotcmsdbuser    false    288    4083    268            �           2606    30086 "   users_cms_roles fkusers_cms_roles1    FK CONSTRAINT     �   ALTER TABLE ONLY public.users_cms_roles
    ADD CONSTRAINT fkusers_cms_roles1 FOREIGN KEY (role_id) REFERENCES public.cms_role(id);
 L   ALTER TABLE ONLY public.users_cms_roles DROP CONSTRAINT fkusers_cms_roles1;
       public       dotcmsdbuser    false    3920    242    246            �           2606    30091 "   users_cms_roles fkusers_cms_roles2    FK CONSTRAINT     �   ALTER TABLE ONLY public.users_cms_roles
    ADD CONSTRAINT fkusers_cms_roles2 FOREIGN KEY (user_id) REFERENCES public.user_(userid);
 L   ALTER TABLE ONLY public.users_cms_roles DROP CONSTRAINT fkusers_cms_roles2;
       public       dotcmsdbuser    false    199    242    3770            �           2606    30211    folder folder_identifier_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.folder
    ADD CONSTRAINT folder_identifier_fk FOREIGN KEY (identifier) REFERENCES public.identifier(id);
 E   ALTER TABLE ONLY public.folder DROP CONSTRAINT folder_identifier_fk;
       public       dotcmsdbuser    false    261    286    3978            �           2606    30134    links links_identifier_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_identifier_fk FOREIGN KEY (identifier) REFERENCES public.identifier(id);
 C   ALTER TABLE ONLY public.links DROP CONSTRAINT links_identifier_fk;
       public       dotcmsdbuser    false    261    3978    281            �           2606    29987    permission permission_role_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.permission
    ADD CONSTRAINT permission_role_fk FOREIGN KEY (roleid) REFERENCES public.cms_role(id);
 G   ALTER TABLE ONLY public.permission DROP CONSTRAINT permission_role_fk;
       public       dotcmsdbuser    false    248    246    3920            �           2606    29062 7   qrtz_blob_triggers qrtz_blob_triggers_trigger_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_blob_triggers
    ADD CONSTRAINT qrtz_blob_triggers_trigger_name_fkey FOREIGN KEY (trigger_name, trigger_group) REFERENCES public.qrtz_triggers(trigger_name, trigger_group);
 a   ALTER TABLE ONLY public.qrtz_blob_triggers DROP CONSTRAINT qrtz_blob_triggers_trigger_name_fkey;
       public       dotcmsdbuser    false    207    207    204    204    3780                       2606    29049 7   qrtz_cron_triggers qrtz_cron_triggers_trigger_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_cron_triggers
    ADD CONSTRAINT qrtz_cron_triggers_trigger_name_fkey FOREIGN KEY (trigger_name, trigger_group) REFERENCES public.qrtz_triggers(trigger_name, trigger_group);
 a   ALTER TABLE ONLY public.qrtz_cron_triggers DROP CONSTRAINT qrtz_cron_triggers_trigger_name_fkey;
       public       dotcmsdbuser    false    206    206    204    204    3780            �           2606    29167 A   qrtz_excl_blob_triggers qrtz_excl_blob_triggers_trigger_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_blob_triggers
    ADD CONSTRAINT qrtz_excl_blob_triggers_trigger_name_fkey FOREIGN KEY (trigger_name, trigger_group) REFERENCES public.qrtz_excl_triggers(trigger_name, trigger_group);
 k   ALTER TABLE ONLY public.qrtz_excl_blob_triggers DROP CONSTRAINT qrtz_excl_blob_triggers_trigger_name_fkey;
       public       dotcmsdbuser    false    216    219    216    3804    219            �           2606    29154 A   qrtz_excl_cron_triggers qrtz_excl_cron_triggers_trigger_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_cron_triggers
    ADD CONSTRAINT qrtz_excl_cron_triggers_trigger_name_fkey FOREIGN KEY (trigger_name, trigger_group) REFERENCES public.qrtz_excl_triggers(trigger_name, trigger_group);
 k   ALTER TABLE ONLY public.qrtz_excl_cron_triggers DROP CONSTRAINT qrtz_excl_cron_triggers_trigger_name_fkey;
       public       dotcmsdbuser    false    216    3804    218    218    216            �           2606    29121 =   qrtz_excl_job_listeners qrtz_excl_job_listeners_job_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_job_listeners
    ADD CONSTRAINT qrtz_excl_job_listeners_job_name_fkey FOREIGN KEY (job_name, job_group) REFERENCES public.qrtz_excl_job_details(job_name, job_group);
 g   ALTER TABLE ONLY public.qrtz_excl_job_listeners DROP CONSTRAINT qrtz_excl_job_listeners_job_name_fkey;
       public       dotcmsdbuser    false    215    215    214    214    3800            �           2606    29144 E   qrtz_excl_simple_triggers qrtz_excl_simple_triggers_trigger_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_simple_triggers
    ADD CONSTRAINT qrtz_excl_simple_triggers_trigger_name_fkey FOREIGN KEY (trigger_name, trigger_group) REFERENCES public.qrtz_excl_triggers(trigger_name, trigger_group);
 o   ALTER TABLE ONLY public.qrtz_excl_simple_triggers DROP CONSTRAINT qrtz_excl_simple_triggers_trigger_name_fkey;
       public       dotcmsdbuser    false    217    217    216    216    3804            �           2606    29177 I   qrtz_excl_trigger_listeners qrtz_excl_trigger_listeners_trigger_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_trigger_listeners
    ADD CONSTRAINT qrtz_excl_trigger_listeners_trigger_name_fkey FOREIGN KEY (trigger_name, trigger_group) REFERENCES public.qrtz_excl_triggers(trigger_name, trigger_group);
 s   ALTER TABLE ONLY public.qrtz_excl_trigger_listeners DROP CONSTRAINT qrtz_excl_trigger_listeners_trigger_name_fkey;
       public       dotcmsdbuser    false    3804    216    216    220    220            �           2606    29134 3   qrtz_excl_triggers qrtz_excl_triggers_job_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_excl_triggers
    ADD CONSTRAINT qrtz_excl_triggers_job_name_fkey FOREIGN KEY (job_name, job_group) REFERENCES public.qrtz_excl_job_details(job_name, job_group);
 ]   ALTER TABLE ONLY public.qrtz_excl_triggers DROP CONSTRAINT qrtz_excl_triggers_job_name_fkey;
       public       dotcmsdbuser    false    216    216    214    214    3800            |           2606    29016 3   qrtz_job_listeners qrtz_job_listeners_job_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_job_listeners
    ADD CONSTRAINT qrtz_job_listeners_job_name_fkey FOREIGN KEY (job_name, job_group) REFERENCES public.qrtz_job_details(job_name, job_group);
 ]   ALTER TABLE ONLY public.qrtz_job_listeners DROP CONSTRAINT qrtz_job_listeners_job_name_fkey;
       public       dotcmsdbuser    false    3776    203    203    202    202            ~           2606    29039 ;   qrtz_simple_triggers qrtz_simple_triggers_trigger_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_simple_triggers
    ADD CONSTRAINT qrtz_simple_triggers_trigger_name_fkey FOREIGN KEY (trigger_name, trigger_group) REFERENCES public.qrtz_triggers(trigger_name, trigger_group);
 e   ALTER TABLE ONLY public.qrtz_simple_triggers DROP CONSTRAINT qrtz_simple_triggers_trigger_name_fkey;
       public       dotcmsdbuser    false    204    3780    204    205    205            �           2606    29072 ?   qrtz_trigger_listeners qrtz_trigger_listeners_trigger_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_trigger_listeners
    ADD CONSTRAINT qrtz_trigger_listeners_trigger_name_fkey FOREIGN KEY (trigger_name, trigger_group) REFERENCES public.qrtz_triggers(trigger_name, trigger_group);
 i   ALTER TABLE ONLY public.qrtz_trigger_listeners DROP CONSTRAINT qrtz_trigger_listeners_trigger_name_fkey;
       public       dotcmsdbuser    false    208    208    204    204    3780            }           2606    29029 )   qrtz_triggers qrtz_triggers_job_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.qrtz_triggers
    ADD CONSTRAINT qrtz_triggers_job_name_fkey FOREIGN KEY (job_name, job_group) REFERENCES public.qrtz_job_details(job_name, job_group);
 S   ALTER TABLE ONLY public.qrtz_triggers DROP CONSTRAINT qrtz_triggers_job_name_fkey;
       public       dotcmsdbuser    false    204    202    3776    202    204            �           2606    30812 5   rule_action_pars rule_action_pars_rule_action_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.rule_action_pars
    ADD CONSTRAINT rule_action_pars_rule_action_id_fkey FOREIGN KEY (rule_action_id) REFERENCES public.rule_action(id);
 _   ALTER TABLE ONLY public.rule_action_pars DROP CONSTRAINT rule_action_pars_rule_action_id_fkey;
       public       dotcmsdbuser    false    364    363    4214            �           2606    30799 $   rule_action rule_action_rule_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.rule_action
    ADD CONSTRAINT rule_action_rule_id_fkey FOREIGN KEY (rule_id) REFERENCES public.dot_rule(id);
 N   ALTER TABLE ONLY public.rule_action DROP CONSTRAINT rule_action_rule_id_fkey;
       public       dotcmsdbuser    false    363    359    4205            �           2606    30771 2   rule_condition rule_condition_condition_group_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.rule_condition
    ADD CONSTRAINT rule_condition_condition_group_fkey FOREIGN KEY (condition_group) REFERENCES public.rule_condition_group(id);
 \   ALTER TABLE ONLY public.rule_condition DROP CONSTRAINT rule_condition_condition_group_fkey;
       public       dotcmsdbuser    false    4208    361    360            �           2606    30757 6   rule_condition_group rule_condition_group_rule_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.rule_condition_group
    ADD CONSTRAINT rule_condition_group_rule_id_fkey FOREIGN KEY (rule_id) REFERENCES public.dot_rule(id);
 `   ALTER TABLE ONLY public.rule_condition_group DROP CONSTRAINT rule_condition_group_rule_id_fkey;
       public       dotcmsdbuser    false    4205    359    360            �           2606    30785 ;   rule_condition_value rule_condition_value_condition_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.rule_condition_value
    ADD CONSTRAINT rule_condition_value_condition_id_fkey FOREIGN KEY (condition_id) REFERENCES public.rule_condition(id);
 e   ALTER TABLE ONLY public.rule_condition_value DROP CONSTRAINT rule_condition_value_condition_id_fkey;
       public       dotcmsdbuser    false    361    4210    362            �           2606    30124    template template_identifier_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.template
    ADD CONSTRAINT template_identifier_fk FOREIGN KEY (identifier) REFERENCES public.identifier(id);
 I   ALTER TABLE ONLY public.template DROP CONSTRAINT template_identifier_fk;
       public       dotcmsdbuser    false    243    3978    261            �           2606    30390 :   workflow_action_class workflow_action_class_action_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_action_class
    ADD CONSTRAINT workflow_action_class_action_id_fkey FOREIGN KEY (action_id) REFERENCES public.workflow_action(id);
 d   ALTER TABLE ONLY public.workflow_action_class DROP CONSTRAINT workflow_action_class_action_id_fkey;
       public       dotcmsdbuser    false    331    332    4138            �           2606    30404 S   workflow_action_class_pars workflow_action_class_pars_workflow_action_class_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_action_class_pars
    ADD CONSTRAINT workflow_action_class_pars_workflow_action_class_id_fkey FOREIGN KEY (workflow_action_class_id) REFERENCES public.workflow_action_class(id);
 }   ALTER TABLE ONLY public.workflow_action_class_pars DROP CONSTRAINT workflow_action_class_pars_workflow_action_class_id_fkey;
       public       dotcmsdbuser    false    332    4141    333            �           2606    30375 0   workflow_action workflow_action_next_assign_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_action
    ADD CONSTRAINT workflow_action_next_assign_fkey FOREIGN KEY (next_assign) REFERENCES public.cms_role(id);
 Z   ALTER TABLE ONLY public.workflow_action DROP CONSTRAINT workflow_action_next_assign_fkey;
       public       dotcmsdbuser    false    331    3920    246            �           2606    30370 1   workflow_action workflow_action_next_step_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_action
    ADD CONSTRAINT workflow_action_next_step_id_fkey FOREIGN KEY (next_step_id) REFERENCES public.workflow_step(id);
 [   ALTER TABLE ONLY public.workflow_action DROP CONSTRAINT workflow_action_next_step_id_fkey;
       public       dotcmsdbuser    false    331    330    4136            �           2606    30365 ,   workflow_action workflow_action_step_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_action
    ADD CONSTRAINT workflow_action_step_id_fkey FOREIGN KEY (step_id) REFERENCES public.workflow_step(id);
 V   ALTER TABLE ONLY public.workflow_action DROP CONSTRAINT workflow_action_step_id_fkey;
       public       dotcmsdbuser    false    4136    330    331            �           2606    30415 F   workflow_scheme_x_structure workflow_scheme_x_structure_scheme_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_scheme_x_structure
    ADD CONSTRAINT workflow_scheme_x_structure_scheme_id_fkey FOREIGN KEY (scheme_id) REFERENCES public.workflow_scheme(id);
 p   ALTER TABLE ONLY public.workflow_scheme_x_structure DROP CONSTRAINT workflow_scheme_x_structure_scheme_id_fkey;
       public       dotcmsdbuser    false    4133    334    329            �           2606    30420 I   workflow_scheme_x_structure workflow_scheme_x_structure_structure_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_scheme_x_structure
    ADD CONSTRAINT workflow_scheme_x_structure_structure_id_fkey FOREIGN KEY (structure_id) REFERENCES public.structure(inode);
 s   ALTER TABLE ONLY public.workflow_scheme_x_structure DROP CONSTRAINT workflow_scheme_x_structure_structure_id_fkey;
       public       dotcmsdbuser    false    3912    245    334            �           2606    30345 *   workflow_step workflow_step_scheme_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_step
    ADD CONSTRAINT workflow_step_scheme_id_fkey FOREIGN KEY (scheme_id) REFERENCES public.workflow_scheme(id);
 T   ALTER TABLE ONLY public.workflow_step DROP CONSTRAINT workflow_step_scheme_id_fkey;
       public       dotcmsdbuser    false    329    330    4133            �           2606    30308 +   workflow_comment workflowtask_id_comment_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_comment
    ADD CONSTRAINT workflowtask_id_comment_fk FOREIGN KEY (workflowtask_id) REFERENCES public.workflow_task(id);
 U   ALTER TABLE ONLY public.workflow_comment DROP CONSTRAINT workflowtask_id_comment_fk;
       public       dotcmsdbuser    false    253    4003    264            �           2606    30313 +   workflow_history workflowtask_id_history_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.workflow_history
    ADD CONSTRAINT workflowtask_id_history_fk FOREIGN KEY (workflowtask_id) REFERENCES public.workflow_task(id);
 U   ALTER TABLE ONLY public.workflow_history DROP CONSTRAINT workflowtask_id_history_fk;
       public       dotcmsdbuser    false    4003    264    279           