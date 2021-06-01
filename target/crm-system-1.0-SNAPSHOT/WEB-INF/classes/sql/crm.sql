/*==============================================================*/
/* Table: tbl_user    用户表                                    */
/*==============================================================*/
drop table if exists tbl_user;
create table tbl_user
(
   id           char(32) not null comment 'uuid',
   loginAct     varchar(255),
   name         varchar(255),
   loginPwd     varchar(255) comment '密码不能采用明文存储，采用密文，MD5加密之后的数据',
   email        varchar(255),
   expireTime   char(19) comment '失效时间为空的时候表示永不失效，失效时间为2018-10-10',
   lockState    char(1) comment '锁定状态为空时表示启用，为0时表示锁定，为1时表示启用。',
   deptno       char(4),
   allowIps     varchar(255) comment 'IP为空时表示IP地址永不受限，允许访问的IP可以是一个，也可以是多个，当多个IP地址的时候，采用半角逗号分隔。',
   createTime   char(19),
   createBy     varchar(255),
   editTime     char(19),
   editBy       varchar(255),
   primary key (id)
);

INSERT INTO tbl_user VALUES ('06f5fc886eac41558a964f96daa7f27c', 'admin', '系统管理员', '202cb962ac59075b964b07152d234b70', 'admin@163.com', '2022-11-27 21:50:05', '1', 'A001', '192.168.1.1,127.0.0.1', '2021-05-08 12:11:40', '系统管理员', null, null);
INSERT INTO tbl_user VALUES ('06f5fc056eac41558a964f96daa7f27c', 'ls', '李四', '202cb962ac59075b964b07152d234b70', 'ls@163.com', '2022-11-27 21:50:05', '1', 'A001', '192.168.1.1,127.0.0.1', '2021-05-08 12:11:40', '李四', null, null);
INSERT INTO tbl_user VALUES ('40f6cdea0bd34aceb77492a1656d9fb3', 'zs', '张三', '202cb962ac59075b964b07152d234b70', 'zs@qq.com', '2022-11-30 23:50:55', '1', 'A001', '192.168.1.2,127.0.0.1', '2021-05-08 11:37:34', '张三', null, null);


/*==============================================================*/
/* Table: tbl_activity      市场活动表                          */
/*==============================================================*/
drop table if exists tbl_activity;
drop table if exists tbl_activity_remark;
create table tbl_activity
(
   id                   char(32) not null,
   owner                char(32),
   name                 varchar(255),
   startDate            char(10),
   endDate              char(10),
   cost                 varchar(255),
   description          varchar(255),
   createTime           char(19),
   createBy             varchar(255),
   editTime             char(19),
   editBy               varchar(255),
   primary key (id)
);
/*==============================================================*/
/* Table: tbl_activity_remark      市场活动备注表               */
/*==============================================================*/
create table tbl_activity_remark
(
   id                   char(32) not null,
   noteContent          varchar(255),
   createTime           char(19),
   createBy             varchar(255),
   editTime             char(19),
   editBy               varchar(255),
   editFlag             char(1) comment '0表示未修改，1表示已修改',
   activityId           char(32),
   primary key (id)
);


drop table if exists tbl_clue;

drop table if exists tbl_clue_activity_relation;

drop table if exists tbl_contacts;

drop table if exists tbl_contacts_activity_relation;

drop table if exists tbl_customer;

drop table if exists tbl_tran;

drop table if exists tbl_tran_history;


/*==============================================================*/
/* Table: tbl_clue        线索表                                */
/*==============================================================*/
create table tbl_clue
(
   id                   char(32) not null,
   fullname             varchar(255),
   appellation          varchar(255),
   owner                char(32),
   company              varchar(255),
   job                  varchar(255),
   email                varchar(255),
   phone                varchar(255),
   website              varchar(255),
   mphone               varchar(255),
   state                varchar(255),
   source               varchar(255),
   createBy             varchar(255),
   createTime           char(19),
   editBy               varchar(255),
   editTime             char(19),
   description          varchar(255),
   contactSummary       varchar(255),
   nextContactTime      char(10),
   address              varchar(255),
   primary key (id)
);

/*==============================================================*/
/* Table: tbl_clue_activity_relation    线索和市场活动的关系表  */
/*==============================================================*/
create table tbl_clue_activity_relation
(
   id                   char(32) not null,
   clueId               char(32),
   activityId           char(32),
   primary key (id)
);


/*==============================================================*/
/* Table: tbl_contacts           联系人表                        */
/*==============================================================*/
create table tbl_contacts
(
   id                   char(32) not null,
   owner                char(32),
   source               varchar(255),
   customerId           char(32),
   fullname             varchar(255),
   appellation          varchar(255),
   email                varchar(255),
   mphone               varchar(255),
   job                  varchar(255),
   birth                char(10),
   createBy             varchar(255),
   createTime           char(19),
   editBy               varchar(255),
   editTime             char(19),
   description          varchar(255),
   contactSummary       varchar(255),
   nextContactTime      char(10),
   address              varchar(255),
   primary key (id)
);

/*==============================================================*/
/* Table: tbl_contacts_activity_relation   联系人和市场活动的关系表  */
/*==============================================================*/
create table tbl_contacts_activity_relation
(
   id                   char(32) not null,
   contactsId           char(32),
   activityId           char(32),
   primary key (id)
);


/*==============================================================*/
/* Table: tbl_customer           客户表                         */
/*==============================================================*/
create table tbl_customer
(
   id                   char(32) not null,
   owner                char(32),
   name                 varchar(255),
   website              varchar(255),
   phone                varchar(255),
   createBy             varchar(255),
   createTime           char(19),
   editBy               varchar(255),
   editTime             char(19),
   contactSummary       varchar(255),
   nextContactTime      char(10),
   description          varchar(255),
   address              varchar(255),
   primary key (id)
);


/*==============================================================*/
/* Table: tbl_tran          交易表                              */
/*==============================================================*/
create table tbl_tran
(
   id                   char(32) not null,
   owner                char(32),
   money                varchar(255),
   name                 varchar(255),
   expectedDate         char(10),
   customerId           char(32),
   stage                varchar(255),
   type                 varchar(255),
   source               varchar(255),
   activityId           char(32),
   contactsId           char(32),
   createBy             varchar(255),
   createTime           char(19),
   editBy               varchar(255),
   editTime             char(19),
   description          varchar(255),
   contactSummary       varchar(255),
   nextContactTime      char(10),
   primary key (id)
);

/*==============================================================*/
/* Table: tbl_tran_history        交易历史表                    */
/*==============================================================*/
create table tbl_tran_history
(
   id                   char(32) not null,
   stage                varchar(255),
   money                varchar(255),
   expectedDate         char(10),
   createTime           char(19),
   createBy             varchar(255),
   tranId               char(32),
   primary key (id)
);
