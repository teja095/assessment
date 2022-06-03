create database account;

use account;

create table `user_table`(user_id int(11) not null auto_increment,
						user_name char(20) not null,
                        user_dob date not null,
                        user_email varchar(45)  not null,
                        user_created_date date  not null,
                        primary key (user_id));

insert into  user_table(user_id, user_name, user_dob,user_email,user_created_date)
             values(1,'abhi dehu','1998-05-25','abhi.dehu@gmail.com','2021-08-23'),
                    (2,'vijay mores','1993-10-23','vijay24.mores@gmail.com','2019-09-14'),
                    (3, 'malik_hassan','1994-10-15','18malik.hassan@gmail.com','2018-10-25'),
                    (4, 'ronak pujari','1995-06-14','ronakronu.pujari@gmail.com','2017-07-16');

create table `bank_account`(user_id int(11) not null auto_increment,
                            bank_account_id int(11) not null ,
                            bank_account_number int(11) not null,
                            is_user_active smallint not null,
                            amount int(8) not null,
                            primary key (user_id));
                            
alter table `bank_account`
add constraint cf_bank_account_is_user_active_yesno check (is_user_active in (0,-1));

alter table bank_account
add key `fk_users_id` (user_id);

alter table bank_account
add constraint `fk_users_id` foreign key(user_id) references user_table (user_id) on update cascade;

insert into bank_account(user_id, bank_account_id, bank_account_number,is_user_active,amount)
            values(1,24,142598234,0,6000),
                   (2,43,142857752,0,15000),
                   (3,34,142587524,-1,500),
                   (4,54,1742894279,0,100000);
alter table bank_account
drop constraint fk_bank_account_hold;

alter table bank_account
add  key  `fk_bank_account_id_holder` (bank_account_id);

desc bank_account;

create table `transcation`(transcation_date date not null,
                           user_id int(11) not null ,
                           bank_account_id int(11) not null auto_increment,
                           withdrawn_amount int(9) not null,
                            primary key (bank_account_id));
                            
insert into transcation(transcation_date,user_id,bank_account_id, withdrawn_amount)
			values('2018-04-15',1,43,15000),
                   ('2019-06-18',3,34,0),
                   ('2021-08-16',2,23,1500),
                   ('2022-05-18',3,54,45000);
alter table transcation
add key `fk_bank_acc` (bank_account_id);

SET FOREIGN_KEY_CHECKS=1;

alter table transcation
add constraint `fk_bank_acc` foreign key(bank_account_id) references bank_account(user_id) on update cascade;

desc transcation
 
# create stored procedure to check the account balance
delimiter $$
create procedure account_balance()
begin
select u.user_id, user_name, bank_account_number, sum(amount) amt
from user_table u 
left join bank_account ba
on ba.user_id = u.user_id
group by 1.2,3;
end $$
delimiter ;

call account_balance();

# create stored procedure to check the withdrawn amount.
# i) user must have a sufficient amount to withdrawn from his/her account
# ii) minimum balance should be 5000 in each user.
delimiter $$
create procedure withdrawn_amount()
begin
select ba.user_id, bank_account_number, t.bank_account_id
from bank_account ba
join transcation t
on t.bank_account_id = ba.user_Id
group by 1
having min(withdrawn_amount) >= 5000  and sum(ba.amount) >= sum(t.withdrawn_amount) ;
end $$
delimiter ;

#drop procedure withdrawn_amount
call withdrawn_amount();

# create procedure to check all transcations for given interval of time
delimiter $$
create procedure transcation_details()
begin
select u.user_id, u.user_name, ba.bank_account_number, ba.amount,t.transcation_date
from user_table u
join bank_account ba
on u.user_id = ba.user_id
join transcation t
on t.bank_account_id = ba.user_id
where transcation_date between '2021-07-15' and '2021-12-31';
end $$
delimiter ;

call transcation_details()

